"""Fija hashes de los tres arreglos autorizados; no cambia la línea base H1."""
import hashlib
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
manifest = json.loads((ROOT / "docs/history/pre_h02/manifest.json").read_text(encoding="utf-8"))
reasons = {"scripts/player.gd": "H1-B01: rechazar daño inválido y limitar HP",
           "scripts/enemy.gd": "H1-B02: muerte única/reentrante, sin ataque tras derrota, daño válido",
           "scripts/main.gd": "H1-B03: preservar victoria y limpiar feedback al reiniciar"}
records = {}
for item in manifest["files"]:
    if "archive" in item:
        continue
    current = hashlib.sha256((ROOT / item["path"]).read_bytes()).hexdigest()
    if item["path"] not in reasons and current != item["sha256"]:
        raise SystemExit("Cambio no autorizado: " + item["path"])
    records[item["path"]] = {"baseline_sha256": item["sha256"], "sha256": current,
        "reason": reasons.get(item["path"], "Sin cambios")}
report = {"date": "2026-11-20", "authorization": "Corregir todos los errores para cerrar H02", "files": records}
path = ROOT / "docs/h02_runtime_snapshot.json"
data = (json.dumps(report, ensure_ascii=False, indent=2) + "\n").encode("utf-8")
if path.exists() and path.read_bytes() != data:
    raise SystemExit("Snapshot existente distinto: requiere revisión explícita")
path.write_bytes(data)
print("SNAPSHOT 8 archivos; 3 correcciones autorizadas, 5 sin cambios")
