"""Record documentary checks. Does not run a milestone or manifest commands."""
import argparse
from datetime import datetime, timezone
import json
from pathlib import Path
import platform
import subprocess
import sys
import time

ROOT = Path(__file__).resolve().parents[2]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path, required=True)
    parser.add_argument('--godot-version-only', type=Path)
    args = parser.parse_args()
    output = args.output.resolve()
    output.mkdir(parents=True, exist_ok=False)
    commands = [
        ('schema', [sys.executable, '-X', 'utf8', 'tools/pipeline/validate_manifest.py', 'validation/_templates/TEST_MANIFEST.json']),
        ('manifest_tests', [sys.executable, '-X', 'utf8', 'tools/pipeline/test_manifest.py']),
        ('documents', [sys.executable, '-X', 'utf8', 'tools/pipeline/check_docs.py']),
        ('godot_static', [sys.executable, '-X', 'utf8', 'tools/pipeline/check_godot_static.py']),
        ('whitespace', ['git', '-c', 'core.whitespace=cr-at-eol', 'diff', '--check']),
        ('python_version', [sys.executable, '--version']),
        ('dependencies', [sys.executable, '-m', 'pip', 'freeze']),
    ]
    if args.godot_version_only:
        commands.append(('godot_version_only', [str(args.godot_version_only), '--version']))
    records = []
    for name, argv in commands:
        start = time.monotonic()
        try:
            completed = subprocess.run(argv, cwd=ROOT, capture_output=True, text=True,
                                       encoding='utf-8', errors='replace', timeout=120)
            code, stdout, stderr = completed.returncode, completed.stdout, completed.stderr
        except subprocess.TimeoutExpired as exc:
            code, stdout, stderr = 124, str(exc.stdout or ''), str(exc.stderr or '')
        except OSError as exc:
            code, stdout, stderr = 127, '', str(exc)
        (output/f'{name}.stdout.log').write_text(stdout, encoding='utf-8')
        (output/f'{name}.stderr.log').write_text(stderr, encoding='utf-8')
        record = {'name':name,'argv':argv,'cwd':str(ROOT),'timestamp_utc':datetime.now(timezone.utc).isoformat(),
                  'elapsed_s':round(time.monotonic()-start,3),'exit_code':code,'status':'PASS' if code==0 else 'FAIL',
                  'stdout':f'{name}.stdout.log','stderr':f'{name}.stderr.log'}
        records.append(record)
        print(f'{name}: {record["status"]}, exit {code}', flush=True)
    result = {'status':'PASS' if all(r['exit_code']==0 for r in records) else 'FAIL',
              'os':platform.platform(),'python':sys.version,'commands':records,
              'scope':'Documentation/schema/metadata only; no Godot milestone executed',
              'approval':'PENDING_APPROVAL','gameplay':'NOT_RUN'}
    (output/'summary.json').write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
    return 0 if result['status']=='PASS' else 1


if __name__=='__main__':
    raise SystemExit(main())
