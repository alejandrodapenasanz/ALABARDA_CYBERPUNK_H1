"""Windows/local runner: exit status, log inspection, JUnit counts and explicit negative control."""
import argparse
from datetime import datetime, timezone, timedelta
import json
from pathlib import Path
import platform
import re
import shutil
import subprocess
import sys
import xml.etree.ElementTree as ET

ROOT = Path(__file__).resolve().parents[2]
ERROR = re.compile(r'(?m)(?:SCRIPT ERROR:|SHADER ERROR:|^ERROR:|Parse Error|Failed to load)')


def execute(out, label, argv, timeout=180):
    start = datetime.now(timezone(timedelta(hours=1))).isoformat()
    try:
        proc = subprocess.run(argv, cwd=ROOT, capture_output=True, timeout=timeout)
        code, stdout, stderr = proc.returncode, proc.stdout, proc.stderr
    except subprocess.TimeoutExpired as exc:
        code, stdout, stderr = 124, exc.stdout or b'', exc.stderr or b''
    except OSError as exc:
        code, stdout, stderr = 127, b'', str(exc).encode()
    (out / f'{label}.stdout.log').write_bytes(stdout)
    (out / f'{label}.stderr.log').write_bytes(stderr)
    log = (stdout + stderr).decode('utf-8', errors='replace')
    record = dict(label=label, date=start, cwd=str(ROOT), argv=argv,
                  powershell='& ' + ' '.join("'" + str(v).replace("'", "''") + "'" for v in argv),
                  exit_code=code, os=platform.platform(), engine_errors=ERROR.findall(log),
                  status='PASS' if code == 0 and not ERROR.search(log) else 'FAIL')
    (out / f'{label}.json').write_text(json.dumps(record, indent=2), encoding='utf-8')
    print(f'{label}: {record["status"]} exit={code}', flush=True)
    return record, log


def xml_results(folder):
    paths = list(folder.rglob('results.xml'))
    if len(paths) != 1:
        return None
    root = ET.parse(paths[0]).getroot()
    cases = list(root.iter('testcase'))
    return dict(tests=len(cases), failures=sum(c.find('failure') is not None for c in cases),
                errors=sum(c.find('error') is not None for c in cases),
                skipped=sum(c.find('skipped') is not None for c in cases),
                names=[c.attrib.get('name') for c in cases])


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--godot', default=None)
    parser.add_argument('--output')
    parser.add_argument('--graphics', action='store_true')
    args = parser.parse_args()
    import os
    godot = args.godot or os.environ.get('GODOT_BIN') or shutil.which('godot') or shutil.which('godot4')
    if not godot:
        print('BLOCKED: pass -Godot <console.exe> or set GODOT_BIN. Python 3.11+ required.')
        return 2
    godot = str(Path(godot).resolve())
    out = Path(args.output).resolve() if args.output else ROOT / 'docs/evidence/h03' / datetime.now().strftime('run_%Y%m%d_%H%M%S')
    out.mkdir(parents=True, exist_ok=False)
    (out / '.gdignore').touch()
    results = []

    def run(label, command, timeout=180):
        result, log = execute(out, label, command, timeout)
        results.append(result)
        return result, log

    run('version', [godot, '--version'])
    result, _ = run('import', [godot, '--headless', '--path', str(ROOT), '--editor', '--import', '--quit'], 240)
    if result['status'] == 'PASS':
        for name, directory in [('unit', 'unit'), ('integration', 'integration'), ('negative_control', 'controlled_failure')]:
            report_dir = out / (name + '_reports')
            command = [godot, '--headless', '--path', str(ROOT), '-s', 'res://addons/gdUnit4/bin/GdUnitCmdTool.gd', '-a', f'res://tests/h03/{directory}', '--ignoreHeadlessMode', '-rd', str(report_dir)]
            result, log = run(name, command)
            counts = xml_results(report_dir)
            result['junit'] = counts
            if name == 'negative_control':
                detected = counts and counts['tests'] == 1 and counts['failures'] == 1 and counts['errors'] == 0 and counts['skipped'] == 0 and 'test_controlled_failure_h03' in counts['names'] and result['exit_code'] == 100 and not result['engine_errors']
                result['status'] = 'PASS' if detected else 'FAIL'
                result['meaning'] = 'The intentionally failing assertion is detected; raw framework exit must be 100.'
                print('negative_control verification:', result['status'], flush=True)
            elif not counts or counts['tests'] == 0 or counts['failures'] or counts['errors'] or counts['skipped']:
                result['status'] = 'FAIL'
            (out / f'{name}.json').write_text(json.dumps(result, indent=2), encoding='utf-8')
        run('startup', [godot, '--headless', '--path', str(ROOT), '--quit-after', '120'])
        result, log = run('h1_regression', [godot, '--headless', '--path', str(ROOT), '--fixed-fps', '60', '--script', 'res://tests/h02/h1_probe.gd', '--', '--edges'])
        if 'RESULT passed=34 failed=0 not_run=1' not in log:
            result['status'] = 'FAIL'
        run('integrity', [sys.executable, '-X', 'utf8', 'tools/h03/verify_integrity.py'])
        if args.graphics:
            run('graphics', [godot, '--path', str(ROOT), '--rendering-method', 'gl_compatibility', '--resolution', '1280x720', '--position', '30,30', '--script', 'res://tests/h03/graphics_probe.gd', '--', '--output=' + str(out / 'graphics').replace('\\', '/')], 180)
    status = 'PASS' if all(r['status'] == 'PASS' for r in results) else 'FAIL'
    summary = dict(status=status, results=results, limitations=['H1 mouse capture/click E2E NOT_RUN in headless.', 'Human visual and gameplay acceptance PENDING_APPROVAL.'])
    (out / 'summary.json').write_text(json.dumps(summary, indent=2), encoding='utf-8')
    print(f'{status}: {out / "summary.json"}', flush=True)
    return 0 if status == 'PASS' else 1


if __name__ == '__main__':
    raise SystemExit(main())
