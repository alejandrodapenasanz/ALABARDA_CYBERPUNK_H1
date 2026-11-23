"""Extend the H03 public selection with authored H04 sources, tests and public docs."""
from pathlib import Path
import importlib.util
import json
import shutil
import sys

ROOT = Path(__file__).resolve().parents[2]


def main():
    destination = Path(sys.argv[1]).resolve()
    if destination.exists():
        raise SystemExit('Refusing existing destination: ' + str(destination))
    spec = importlib.util.spec_from_file_location('h03_package', ROOT / 'tools/h03/package_public.py')
    package = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(package)
    package.main()
    paths = [ROOT / 'art_sources/.gdignore']
    paths.extend(ROOT / item['source'] for item in json.loads((ROOT / 'resources/art_kit/manifest.json').read_text())['assets'])
    paths.extend(p for p in (ROOT / 'tests/h04').rglob('*') if p.is_file())
    paths.extend(ROOT / 'tools/h04' / name for name in ['build_kit.py', 'run_tests.py', 'sanitize_sources.py'])
    for path in paths:
        target = destination / path.relative_to(ROOT)
        target.parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(path, target)
    for path in (ROOT / 'tools/h04/public_docs').glob('*.md'):
        target = destination / ('README.md' if path.name == 'README.md' else 'docs/' + path.name)
        shutil.copyfile(path, target)
    print(json.dumps({'h04_files_added': len(paths), 'originals_included': False, 'local_experiments_included': False}))


if __name__ == '__main__':
    main()
