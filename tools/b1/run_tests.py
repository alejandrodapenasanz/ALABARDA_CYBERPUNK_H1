"""B1 runner (PC Codex): import, B1 unit/integration suites, sandbox smoke run and full H1/H03/H04 regression.

Usage (PowerShell, cwd = repository root of candidate C):
  python -X utf8 tools/b1/run_tests.py --godot <Godot_v4.7.2-stable_win64_console.exe> --output <new empty dir>

Every step keeps stdout/stderr/json in --output. A suite only passes if exit 0, no engine errors in the log
and the JUnit test count equals the number of `func test_` declared in its folder (catches suites that
failed to load). Does not grant VALIDATED or APPROVED.
"""
import argparse
import json
from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / 'tools/h03'))
from run_tests import execute, xml_results  # noqa: E402

SUITES = [('b1_unit', 'tests/b1/unit'), ('b1_integration', 'tests/b1/integration')]


def declared_tests(folder):
    return sum(len(re.findall(r'(?m)^func test_\w+\(', p.read_text(encoding='utf-8')))
               for p in (ROOT / folder).glob('*_test.gd'))


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument('--godot', required=True)
    parser.add_argument('--output', required=True)
    parser.add_argument('--skip-regression', action='store_true', help='only B1 suites (for quick fix loops)')
    args = parser.parse_args()
    out = Path(args.output).resolve()
    out.mkdir(parents=True, exist_ok=False)
    (out / '.gdignore').touch()
    godot = str(Path(args.godot).resolve())
    results = []

    version, _ = execute(out, 'version', [godot, '--version'])
    results.append(version)
    imported, _ = execute(out, 'import', [godot, '--headless', '--path', str(ROOT), '--editor', '--import', '--quit'], 300)
    results.append(imported)
    if imported['status'] == 'PASS':
        for label, folder in SUITES:
            reports = out / (label + '_reports')
            record, _ = execute(out, label, [godot, '--headless', '--path', str(ROOT), '-s',
                                             'res://addons/gdUnit4/bin/GdUnitCmdTool.gd', '-a', 'res://' + folder,
                                             '--ignoreHeadlessMode', '-rd', str(reports)], 300)
            counts = xml_results(reports)
            expected = declared_tests(folder)
            record['junit'] = counts
            record['declared_tests'] = expected
            if not counts or counts['tests'] != expected or counts['failures'] or counts['errors'] or counts['skipped']:
                record['status'] = 'FAIL'
            (out / f'{label}.json').write_text(json.dumps(record, indent=2), encoding='utf-8')
            results.append(record)
        smoke, _ = execute(out, 'b1_sandbox_smoke', [godot, '--headless', '--path', str(ROOT), '--fixed-fps', '60',
                                                    '--quit-after', '600', 'res://scenes/b1/b1_sandbox.tscn'], 180)
        smoke['meaning'] = 'Sandbox loads and runs 600 frames headless without script/engine errors; not a gameplay check'
        (out / 'b1_sandbox_smoke.json').write_text(json.dumps(smoke, indent=2), encoding='utf-8')
        results.append(smoke)
        if not args.skip_regression:
            regression, _ = execute(out, 'regression_h1_h03_h04', [sys.executable, '-X', 'utf8', 'tools/h04/run_tests.py',
                                                                   '--godot', godot, '--output', str(out / 'regression')], 900)
            results.append(regression)
    status = 'PASS' if all(r['status'] == 'PASS' for r in results) else 'FAIL'
    summary = {'status': status, 'results': results,
               'limitations': ['Headless: no visual, feel or mouse-capture verification', 'Manual cases M-* are separate',
                               'PASS here is technical evidence for VALIDATED, never APPROVED']}
    (out / 'summary.json').write_text(json.dumps(summary, indent=2), encoding='utf-8')
    print(status, out / 'summary.json')
    return 0 if status == 'PASS' else 1


if __name__ == '__main__':
    raise SystemExit(main())
