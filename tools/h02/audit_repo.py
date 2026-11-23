"""Inventario H02, integridad histórica y referencias Markdown (biblioteca estándar)."""
import hashlib
import json
from pathlib import Path
import re
import sys
from urllib.parse import unquote

ROOT = Path(__file__).resolve().parents[2]
EVIDENCE = ROOT / "docs/evidence/h02"
SKIP = {".git", ".godot", "__pycache__"}
ID = re.compile(r"\b(?:D-\d{3}|P-\d{3}|REQ-\d{3})\b")


def files():
    return sorted(p for p in ROOT.rglob("*") if p.is_file() and not SKIP.intersection(p.relative_to(ROOT).parts))


def slug(text):
    text = re.sub(r"[`*_]", "", text.lower())
    return re.sub(r"[^\w\- ]", "", text).replace(" ", "-")


def main():
    errors, notices = [], []
    manifest = json.loads((ROOT / "docs/history/pre_h02/manifest.json").read_text(encoding="utf-8"))
    redirects = manifest.get("migration", {}).get("redirects", {})
    snapshot_path = ROOT / "docs/h02_runtime_snapshot.json"
    snapshot = json.loads(snapshot_path.read_text(encoding="utf-8"))["files"] if snapshot_path.exists() else {}
    history_count, runtime_count = 0, 0
    for item in manifest["files"]:
        if "archive" in item:
            path = ROOT / item["archive"]
            history_count += 1
        else:
            path = ROOT / item["path"]
            runtime_count += 1
        expected = snapshot.get(item["path"], {}).get("sha256", item["sha256"]) if "archive" not in item else item["sha256"]
        if not path.is_file() or hashlib.sha256(path.read_bytes()).hexdigest() != expected:
            errors.append("BASELINE_CHANGED " + str(path.relative_to(ROOT)))
        if "archive" not in item and item["path"] in snapshot and snapshot[item["path"]]["baseline_sha256"] != item["sha256"]:
            errors.append("BASELINE_REWRITTEN " + item["path"])
    runtime = [p for p in files() if p.suffix in {".gd", ".tscn", ".tres", ".godot"}]
    dependencies = []
    for path in runtime:
        for ref in re.findall(r'["\']res://([^"\']+)["\']', path.read_text(encoding="utf-8-sig")):
            dependencies.append({"source": path.relative_to(ROOT).as_posix(), "target": ref})
            if not (ROOT / ref).is_file():
                errors.append(f"RESOURCE_MISSING {path.relative_to(ROOT)} -> {ref}")
    markdown = [p for p in files() if p.suffix == ".md"]
    policy_path = ROOT / "docs/h02_reference_policy.json"
    policy = json.loads(policy_path.read_text(encoding="utf-8")) if policy_path.exists() else {}
    definitions = {}
    for doc in ["docs/DECISIONS.md", "docs/DOCUMENTATION_AUDIT.md"]:
        path = ROOT / doc
        if not path.exists():
            continue
        for line in path.read_text(encoding="utf-8").splitlines():
            pattern = r"^- (D-\d{3}|P-\d{3})\b" if doc.endswith("DECISIONS.md") else r"^\| (REQ-\d{3})\b"
            found = re.match(pattern, line)
            if found:
                identifier = found[1]
                if identifier in definitions:
                    errors.append("DUPLICATE_ID " + identifier)
                definitions[identifier] = doc
    links, references, id_refs = [], [], []
    historical = {}
    for item in manifest["files"]:
        if "archive" in item:
            historical.setdefault(item["archive"], item["path"])
    for path in markdown:
        relative = path.relative_to(ROOT).as_posix()
        text = path.read_text(encoding="utf-8-sig")
        is_history = relative in historical
        # Archivos conservados literalmente: resolver como en su ruta original.
        base = ROOT / historical.get(relative, relative)
        content = re.sub(r"```.*?```", "", text, flags=re.S)
        for label, raw in re.findall(r"\[([^\]]+)\]\((<[^>]+>|[^)]+)\)", content):
            raw = unquote(raw.strip().strip("<>"))
            if re.match(r"^[a-zA-Z][a-zA-Z0-9+.-]*:", raw):
                continue
            target, _, fragment = raw.partition("#")
            resolved = (base.parent / target).resolve() if target else base
            valid = resolved.is_file()
            if valid and fragment and resolved.suffix == ".md":
                target_text = resolved.read_text(encoding="utf-8-sig")
                anchors = [slug(m) for m in re.findall(r"^#+\s+(.+)$", target_text, re.M)]
                valid = fragment in anchors or f'id="{fragment}"' in target_text
            links.append({"source": relative, "target": raw, "exists": valid, "historical": is_history})
            if not valid:
                (notices if is_history else errors).append(f"LINK_MISSING {relative} -> {raw}")
        for raw in re.findall(r"`([^`\n]+)`", content):
            # Solo tokens que representan rutas, no comandos, fórmulas o patrones futuros.
            if not re.search(r"\.(?:md|gd|tscn|tres|godot|pdf|json|py|log|uid)$", raw, re.I):
                continue
            if raw.startswith(("& ", "python ", "git ", "godot ")) or re.search(r"\s--?\w", raw) or any(c in raw for c in "*{}"):
                continue
            raw = raw.removeprefix("res://")
            if re.fullmatch(r"\.[a-z.]+", raw):
                continue  # Extensiones ilustrativas, por ejemplo .tscn o .gd.uid.
            candidates = [base.parent / raw, ROOT / raw]
            if "/" not in raw and "\\" not in raw:
                candidates += [ROOT / d / raw for d in ("docs", "scripts", "scenes")]
            exists = any(p.is_file() for p in candidates)
            reason = policy.get(raw)
            if not exists:
                for candidate in candidates:
                    try:
                        old_path = candidate.resolve().relative_to(ROOT).as_posix()
                    except ValueError:
                        continue
                    if old_path in redirects and (ROOT / redirects[old_path]).is_file():
                        reason = "Ruta histórica retirada; sucesor verificado: " + redirects[old_path]
                        break
            references.append({"source": relative, "target": raw, "exists": exists,
                               "historical": is_history, "declared_absence": reason})
            if not exists:
                message = f"FILE_MISSING {relative} -> {raw}" + (f" ({reason})" if reason else "")
                (notices if is_history or reason else errors).append(message)
        if not is_history:
            for identifier in ID.findall(content):
                id_refs.append({"source": relative, "id": identifier})
                if identifier not in definitions:
                    errors.append(f"UNKNOWN_ID {relative} -> {identifier}")
    matrix_path = ROOT / "docs/DOCUMENTATION_AUDIT.md"
    matrix = matrix_path.read_text(encoding="utf-8") if matrix_path.exists() else ""
    matrix_rows = "\n".join(line for line in matrix.splitlines() if line.startswith("| REQ-"))
    for identifier in definitions:
        if identifier.startswith("D-") and identifier not in matrix_rows:
            errors.append("DECISION_WITHOUT_TRACE " + identifier)
    for item in manifest["files"]:
        if not (ROOT / item.get("current_path", item["path"])).is_file():
            errors.append("CURRENT_PATH_MISSING " + item.get("current_path", item["path"]))
    for path in files():
        if "(1)" in path.name:
            errors.append("DUPLICATE_NAME " + path.relative_to(ROOT).as_posix())
    prompts = list((ROOT / "prompts").glob("H*.md"))
    for number in range(2, 25):
        if len([p for p in prompts if p.name.startswith(f"H{number:02d}_")]) != 1:
            errors.append(f"PROMPT_COUNT H{number:02d}")
    report = {"date": "2026-11-20", "markdown_files": [p.relative_to(ROOT).as_posix() for p in markdown],
              "runtime_files": [p.relative_to(ROOT).as_posix() for p in runtime],
              "dependencies": dependencies, "historical_hashes_checked": history_count,
              "runtime_hashes_checked": runtime_count, "runtime_snapshot": snapshot, "links": links, "file_references": references,
              "id_definitions": definitions, "id_references": id_refs, "notices": notices, "errors": errors,
              "limits": "No verifica URLs externas, semántica de mecánicas, rutas dinámicas ni jugabilidad visual."}
    (EVIDENCE / "inventory_and_references.json").write_text(json.dumps(report, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    print(f"MARKDOWN {len(markdown)}; HISTORY_HASHES {history_count}; RUNTIME_HASHES {runtime_count}")
    print(f"RESOURCES {len(runtime)}; DEPENDENCIES {len(dependencies)}; LINKS {len(links)}; FILE_REFS {len(references)}; ID_REFS {len(id_refs)}")
    for error in errors:
        print("FAIL " + error)
    print(f"RESULT errors={len(errors)} declared_or_historical_notices={len(notices)}")
    print("Detalle: docs/evidence/h02/inventory_and_references.json")
    return 1 if errors else 0


if __name__ == "__main__":
    sys.exit(main())
