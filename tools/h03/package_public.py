"""Create a fresh public source snapshot; never copy raw assets, credentials or history."""
from pathlib import Path
import hashlib
import json
import shutil
import sys

ROOT = Path(__file__).resolve().parents[2]


def main():
    destination = Path(sys.argv[1]).resolve()
    if destination.exists():
        raise SystemExit('Refusing existing destination: ' + str(destination))
    destination.mkdir(parents=True)
    paths = [ROOT / name for name in ('project.godot', 'AGENTS.md', 'THIRD_PARTY_NOTICES.md', 'tools/run_tests.ps1')]
    for directory in ('scenes', 'scripts', 'resources', 'addons/gdUnit4', 'tests/h02', 'tests/h03'):
        paths.extend(p for p in (ROOT / directory).rglob('*') if p.is_file() and not any(part in ('__pycache__', 'local_experiments') for part in p.parts))
    paths.extend(ROOT / 'tools/h03' / name for name in ('run_tests.py', 'install_gdunit.py', 'gdunit.lock.json', 'verify_integrity.py'))
    for path in paths:
        target = destination / path.relative_to(ROOT)
        target.parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(path, target)
    baseline = {}
    for path in ('project.godot', 'scenes/main.tscn', 'scripts/main.gd', 'scripts/player.gd', 'scripts/enemy.gd', 'tests/h02/h1_probe.gd'):
        baseline[path] = hashlib.sha256((ROOT / path).read_bytes()).hexdigest()
    (destination / 'tools/h03/public_h1_baseline.json').write_text(json.dumps(baseline, indent=2), encoding='utf-8')
    (destination / '.gitignore').write_text('.godot/\n__pycache__/\n*.pyc\ndocs/evidence/\nreports/\n/resources/local_experiments/\n', encoding='utf-8')
    (destination / '.gitattributes').write_text('# Preserve exact source bytes for integrity manifests on Windows.\n* -text\n', encoding='utf-8')
    (destination / 'docs').mkdir(exist_ok=True)
    for path in (ROOT / 'tools/h03/public_docs').glob('*.md'):
        target = destination / ('README.md' if path.name == 'README.md' else 'docs/' + path.name)
        shutil.copyfile(path, target)
    print(json.dumps({'destination': str(destination), 'copied_files': len(paths), 'raw_assets_included': False}))


if __name__ == '__main__':
    main()
