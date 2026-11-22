"""Run existing H03/H1 regressions and H04 import/lighting/kit tests, keeping logs."""
import argparse
import hashlib
import json
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / 'tools/h03'))
from run_tests import execute, xml_results


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--godot', required=True)
    parser.add_argument('--output', required=True)
    parser.add_argument('--graphics', action='store_true')
    args = parser.parse_args()
    out = Path(args.output).resolve()
    out.mkdir(parents=True, exist_ok=False)
    (out / '.gdignore').touch()
    godot = str(Path(args.godot).resolve())
    command = [sys.executable, '-X', 'utf8', 'tools/h03/run_tests.py', '--godot', godot, '--output', str(out / 'regression')]
    if args.graphics:
        command.append('--graphics')
    regression, _ = execute(out, 'regression', command, 480)
    reports = out / 'integration_reports'
    integration, _ = execute(out, 'integration', [godot, '--headless', '--path', str(ROOT), '-s', 'res://addons/gdUnit4/bin/GdUnitCmdTool.gd', '-a', 'res://tests/h04/integration', '--ignoreHeadlessMode', '-rd', str(reports)])
    counts = xml_results(reports)
    integration['junit'] = counts
    if not counts or counts['tests'] != 4 or any(counts[k] for k in ['failures', 'errors', 'skipped']):
        integration['status'] = 'FAIL'
    (out / 'integration.json').write_text(json.dumps(integration, indent=2))
    results = [regression, integration]
    errors = []
    for item in json.loads((ROOT / 'resources/art_kit/manifest.json').read_text())['assets']:
        for key, sha_key in [('destination', 'sha256'), ('source', 'source_sha256')]:
            path = ROOT / item[key]
            if not path.is_file() or hashlib.sha256(path.read_bytes()).hexdigest() != item[sha_key]:
                errors.append('Kit differs from manifest: ' + item[key])
    kit = dict(status='FAIL' if errors else 'PASS', errors=errors, meaning='GLB and Blender authoring sources match generated manifest')
    (out / 'kit_integrity.json').write_text(json.dumps(kit, indent=2))
    results.append(kit)
    if args.graphics:
        graphics, _ = execute(out, 'lookdev_graphics', [godot, '--path', str(ROOT), '--rendering-method', 'gl_compatibility', '--resolution', '1280x720', '--position', '30,30', '--script', 'res://tests/h04/lookdev_probe.gd', '--', '--output=' + str(out / 'graphics').replace('\\', '/')])
        results.append(graphics)
    summary = dict(status='PASS' if all(r['status'] == 'PASS' for r in results) else 'FAIL', results=results,
                   limitations=['Human visual acceptance is recorded separately in docs/VALIDATION.md; tests do not grant it', 'H1 physical click NOT_RUN in headless', 'Windows export NOT_RUN; no export configuration changed'])
    (out / 'summary.json').write_text(json.dumps(summary, indent=2))
    print(summary['status'], out / 'summary.json')
    return 0 if summary['status'] == 'PASS' else 1


if __name__ == '__main__':
    raise SystemExit(main())
