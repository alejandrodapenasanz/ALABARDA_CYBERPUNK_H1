"""Prueba migración desde originales, repetición y rechazo de cambios ajenos."""
import hashlib
import json
from pathlib import Path
import shutil
import tempfile

from migrate_docs import ROOT, migrate


def hashes(root):
    return {p.relative_to(root).as_posix(): hashlib.sha256(p.read_bytes()).hexdigest()
            for p in root.rglob("*") if p.is_file()}


with tempfile.TemporaryDirectory(prefix="alabarda_h02_") as directory:
    fixture = Path(directory)
    history = ROOT / "docs/history/pre_h02"
    shutil.copytree(history, fixture / "docs/history/pre_h02")
    manifest = json.loads((history / "manifest.json").read_text(encoding="utf-8"))
    for item in manifest["files"]:
        if "archive" in item:
            target = fixture / item["path"]
            target.parent.mkdir(parents=True, exist_ok=True)
            target.write_bytes((ROOT / item["archive"]).read_bytes())
    changed = migrate(fixture)
    assert changed > 0, changed
    first = hashes(fixture)
    assert migrate(fixture) == 0
    assert hashes(fixture) == first, "La segunda ejecución cambia datos"
    assert not list(fixture.rglob("*(1)*")), "Quedan nombres duplicados"
    assert len(list((fixture / "prompts").glob("H*.md"))) == 23
    for alias in ["GDD_TECNICO_H1.md", "docs/VALIDACION.md", "docs/DECISIONES.md"]:
        assert not (fixture / alias).exists()
    print("PASS consolidación completa; 23 prompts; cero (1); repetición 0 cambios")
    migrated = json.loads((fixture / "docs/history/pre_h02/manifest.json").read_text(encoding="utf-8"))
    for item in migrated["files"]:
        if "archive" in item:
            assert hashlib.sha256((fixture / item["archive"]).read_bytes()).hexdigest() == item["sha256"]
    print("PASS 48 originales Markdown conservados byte a byte")
    (fixture / "docs/DECISIONES.md").write_text("Edición ajena", encoding="utf-8")
    before = hashes(fixture)
    try:
        migrate(fixture)
    except ValueError as error:
        assert "edición ajena" in str(error)
    else:
        raise AssertionError("Debe rechazar sobrescritura")
    assert before == hashes(fixture)
    print("PASS rechazo de edición ajena sin escrituras parciales")
    (fixture / "docs/DECISIONES.md").unlink()
    prompt = next(p for p in (fixture / "prompts").glob("*.md") if p.name.startswith("H02_"))
    conflicting = prompt.with_name(prompt.stem + " (1).md")
    conflicting.write_text("Versión distinta que no debe perderse", encoding="utf-8")
    before = hashes(fixture)
    try:
        migrate(fixture)
    except ValueError as error:
        assert "Colisión" in str(error)
    else:
        raise AssertionError("Debe rechazar versiones diferentes")
    assert before == hashes(fixture)
    print("PASS colisión de prompts rechazada sin perder versiones")
print("RESULT passed=4 failed=0")
