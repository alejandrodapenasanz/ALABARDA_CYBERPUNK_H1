"""Captura única del material recibido; nunca sobrescribe el archivo histórico."""
import difflib
import hashlib
import json
from pathlib import Path
import subprocess

ROOT = Path(__file__).resolve().parents[2]
HISTORY = ROOT / "docs/history/pre_h02"


def git(*args):
    result = subprocess.run(["git", *args], cwd=ROOT, capture_output=True)
    print(json.dumps({"argv": ["git", *args], "exit_code": result.returncode,
                      "stdout": result.stdout.decode("utf-8", "replace"),
                      "stderr": result.stderr.decode("utf-8", "replace")}, ensure_ascii=False))
    result.check_returncode()
    return result.stdout.decode("utf-8").strip()


def main():
    if HISTORY.exists() or (ROOT / ".git").exists():
        raise SystemExit("Captura ya existente; no se modifica")
    originals = sorted([*ROOT.glob("*.md"), ROOT / "project.godot",
                        *ROOT.glob("docs/*.md"), *ROOT.glob("prompts/*.md"),
                        *ROOT.glob("scenes/*"), *ROOT.glob("scripts/*")])
    git("init", "-b", "h02-audit")
    git("-c", "core.autocrlf=false", "add", "--", *[p.relative_to(ROOT).as_posix() for p in originals])
    tree = git("write-tree")
    git("update-ref", "refs/h02/baseline", tree)
    HISTORY.mkdir(parents=True)
    manifest = {"date": "2026-11-20", "git_tree": tree, "git_ref": "refs/h02/baseline", "files": []}
    for path in originals:
        relative = path.relative_to(ROOT).as_posix()
        data = path.read_bytes()
        item = {"path": relative, "sha256": hashlib.sha256(data).hexdigest(), "bytes": len(data)}
        if path.suffix == ".md":
            destination = HISTORY / relative
            destination.parent.mkdir(parents=True, exist_ok=True)
            destination.write_bytes(data)
            item["archive"] = destination.relative_to(ROOT).as_posix()
        manifest["files"].append(item)
    (HISTORY / "manifest.json").write_text(json.dumps(manifest, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    pairs = [("GDD_TECNICO_H1.md", "docs/GDD_TECNICO_H1.md"),
             ("docs/DECISIONES.md", "docs/DECISIONS.md"),
             ("docs/VALIDACION.md", "docs/VALIDATION.md")]
    pairs += [(p.relative_to(ROOT).as_posix(), p.relative_to(ROOT).as_posix().replace(" (1)", ""))
              for p in ROOT.glob("docs/* (1).md")]
    diff = []
    for left, right in pairs:
        a, b = (ROOT / left).read_bytes(), (ROOT / right).read_bytes()
        diff.append(f"\nCOMPARE {left} -> {right}: {'IDENTICAL_BYTES' if a == b else 'DIFFERENT'}\n")
        diff.extend(difflib.unified_diff(a.decode("utf-8-sig").splitlines(True),
                                        b.decode("utf-8-sig").splitlines(True), left, right))
    (ROOT / "docs/evidence/h02/original_comparisons.diff").write_text("".join(diff), encoding="utf-8")
    print(f"BASELINE tree={tree}; files={len(originals)}; markdown={sum(p.suffix == '.md' for p in originals)}; commits=0")


if __name__ == "__main__":
    main()
