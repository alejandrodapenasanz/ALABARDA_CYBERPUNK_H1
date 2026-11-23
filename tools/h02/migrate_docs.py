"""Consolidación autorizada H02: sin copias (1), con historia y rutas trazables."""
import hashlib
import json
import os
from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parents[2]
ALIASES = {"GDD_TECNICO_H1.md": "docs/GDD_TECNICO_H1.md",
           "docs/DECISIONES.md": "docs/DECISIONS.md", "docs/VALIDACION.md": "docs/VALIDATION.md"}


def digest(data):
    return hashlib.sha256(data).hexdigest()


def within(root, relative):
    path = (root / relative).resolve()
    path.relative_to(root.resolve())  # Rechaza escapes antes de escribir/mover/borrar.
    return path


def legacy_alias(item, target):
    source = Path(item["path"])
    link = lambda p: os.path.relpath(p, source.parent).replace("\\", "/")
    archive = item.get("archive_original", item["archive"])
    return (f"# Referencia documental — {source.name}\n\n"
            "Migración H02 · 2026-11-20. Esta ruta se conserva para compatibilidad.\n\n"
            f"- Documento central: [{Path(target).name}](<{link(target)}>).\n"
            f"- Original íntegro anterior a H02: [archivo histórico](<{link(archive)}>).\n"
            "- El historial no constituye una decisión nueva ni una validación de tests.\n").encode("utf-8")


def migrate(root):
    root = root.resolve()
    manifest_path = within(root, "docs/history/pre_h02/manifest.json")
    manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    moves, removals, redirects = {}, set(), {}
    for item in manifest["files"]:
        old = item["path"]
        target = ALIASES.get(old, old.replace(" (1)", ""))
        item["current_path"] = target
        if old != target:
            redirects[old] = target
        if "archive" not in item:
            continue
        previous_archive = item.get("archive_original", item["archive"])
        archive = previous_archive.replace(" (1)", "")
        if old == "GDD_TECNICO_H1.md":
            archive = "docs/history/pre_h02/docs/GDD_TECNICO_H1.md"
        stored = within(root, item["archive"])
        if not stored.is_file() or digest(stored.read_bytes()) != item["sha256"]:
            raise ValueError("Original histórico ausente/alterado: " + old)
        if item["archive"] != archive:
            moves[item["archive"]] = archive
        if previous_archive != archive:
            redirects[previous_archive] = archive
        item["archive_original"] = previous_archive
        item["archive"] = archive
        source = within(root, old)
        is_alias = old in ALIASES or (old.startswith("docs/") and " (1)" in old)
        if is_alias:
            if not within(root, target).is_file():
                raise ValueError("Canónico ausente: " + target)
            if source.is_file():
                data = source.read_bytes()
                if digest(data) != item["sha256"] and data != legacy_alias(item, target):
                    raise ValueError("Se rechaza eliminar edición ajena: " + old)
                removals.add(old)
        elif old != target and source.exists():
            moves[old] = target
        elif not within(root, target).is_file():
            raise ValueError("Documento único ausente: " + old)
    # Validar todas las colisiones antes de mutar. Nunca sobrescribir versiones distintas.
    for source, target in moves.items():
        src, dst = within(root, source), within(root, target)
        if dst.exists() and src.read_bytes() != dst.read_bytes():
            raise ValueError("Colisión con contenido distinto: " + target)
    changes = len(moves) + len(removals)
    for source, target in moves.items():
        src, dst = within(root, source), within(root, target)
        if dst.exists():
            src.unlink()  # Solo se elimina tras igualdad byte a byte comprobada.
        else:
            src.rename(dst)
    for relative in removals:
        within(root, relative).unlink()
    manifest["migration"] = {"date": "2026-11-20", "version": 2,
        "authorization": "Petición expresa: eliminar duplicados (1), una copia correcta y corregir H02.",
        "redirects": redirects}
    encoded = (json.dumps(manifest, indent=2, ensure_ascii=False) + "\n").encode("utf-8")
    if manifest_path.read_bytes() != encoded:
        manifest_path.write_bytes(encoded)
        changes += 1
    # Reescribir enlaces activos; el texto histórico conserva exactamente sus bytes.
    pattern = re.compile(r"\[([^\]]+)\]\((<[^>]+>|[^)]+)\)")
    for path in sorted(root.rglob("*.md")):
        relative = path.relative_to(root)
        if {".git", ".godot", "history"}.intersection(relative.parts):
            continue
        before = path.read_bytes()
        def rewrite(match):
            raw = match[2].strip().strip("<>")
            if re.match(r"^[a-zA-Z][a-zA-Z0-9+.-]*:", raw):
                return match[0]
            target, separator, fragment = raw.partition("#")
            try:
                old = (path.parent / target).resolve().relative_to(root).as_posix()
            except ValueError:
                return match[0]
            if old not in redirects:
                return match[0]
            new = os.path.relpath(root / redirects[old], path.parent).replace("\\", "/")
            return f"[{match[1]}](<{new}{separator}{fragment}>)"
        after = pattern.sub(rewrite, before.decode("utf-8-sig")).encode("utf-8")
        if after != before:
            path.write_bytes(after)
            changes += 1
    print(f"MIGRATION v2 moved_or_deduplicated={len(moves)} removed_aliases={len(removals)} changes={changes}")
    return changes


if __name__ == "__main__":
    migrate(Path(sys.argv[1]).resolve() if len(sys.argv) > 1 else ROOT)
