"""Capture exact subprocess evidence without PowerShell stderr conversion."""
import datetime
import json
from pathlib import Path
import subprocess
import sys

out, label, cwd, *command = sys.argv[1:]
out = Path(out)
out.mkdir(parents=True, exist_ok=True)
if (out / (label + '.json')).exists():
    raise SystemExit('Refusing to overwrite an existing execution')
start = datetime.datetime.now(datetime.timezone.utc).isoformat()
result = subprocess.run(command, cwd=cwd, capture_output=True)
(out / (label + '.stdout.log')).write_bytes(result.stdout)
(out / (label + '.stderr.log')).write_bytes(result.stderr)
record = dict(label=label, started_at_utc=start,
              ended_at_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),
              cwd=cwd, argv=command, exit_code=result.returncode)
(out / (label + '.json')).write_text(json.dumps(record, indent=2), encoding='utf-8')
print(json.dumps(record, indent=2))
print(result.stdout.decode('utf-8', errors='replace')[-6000:])
print(result.stderr.decode('utf-8', errors='replace')[-3000:])
raise SystemExit(result.returncode)
