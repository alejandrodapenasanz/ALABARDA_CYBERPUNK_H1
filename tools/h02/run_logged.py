"""Registro local de comandos de auditoría H02, sin dependencias externas."""
import datetime as dt
import json
import os
from pathlib import Path
import platform
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[2]
LOGS = ROOT / "docs/evidence/h02"


def main():
    if len(sys.argv) < 3:
        raise SystemExit("Uso: python tools/h02/run_logged.py NOMBRE ejecutable [argumentos]")
    name, *command = sys.argv[1:]
    if not name.replace("_", "").replace("-", "").isalnum():
        raise SystemExit("Nombre de log inválido")
    LOGS.mkdir(parents=True, exist_ok=True)
    report = LOGS / (name + ".json")
    if report.exists():
        raise SystemExit("No se sobrescriben ejecuciones previas: " + str(report))
    # Europe/Madrid en la fecha de H02 (20-11-2026): UTC+01:00.
    started = dt.datetime.now(dt.timezone(dt.timedelta(hours=1))).isoformat()
    env = dict(os.environ, PYTHONUTF8="1", PYTHONIOENCODING="utf-8")
    try:
        result = subprocess.run(command, cwd=ROOT, capture_output=True, timeout=120, env=env)
        stdout, stderr, code = result.stdout, result.stderr, result.returncode
        executed = True
    except subprocess.TimeoutExpired as exc:
        stdout, stderr, code = exc.stdout or b"", (exc.stderr or b"") + b"\nTIMEOUT 120s", 124
        executed = True
    except OSError as exc:
        stdout, stderr, code = b"", str(exc).encode("utf-8"), 127
        executed = False
    (LOGS / (name + ".stdout.log")).write_bytes(stdout)
    (LOGS / (name + ".stderr.log")).write_bytes(stderr)
    metadata = {
        "started_madrid": started, "cwd": str(ROOT), "os": platform.platform(),
        "python": sys.version, "argv": command,
        "powershell": "& " + " ".join("'" + s.replace("'", "''") + "'" for s in command),
        "executed": executed, "exit_code": code,
        "stdout": name + ".stdout.log", "stderr": name + ".stderr.log",
    }
    report.write_text(json.dumps(metadata, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    sys.stdout.reconfigure(encoding="utf-8")
    print(json.dumps(metadata, ensure_ascii=False))
    print(stdout.decode("utf-8", errors="replace"))
    print(stderr.decode("utf-8", errors="replace"))
    return code


if __name__ == "__main__":
    sys.exit(main())
