"""Verify original bytes, H1 entry point and curated runtime references."""
from pathlib import Path
import hashlib
import json
import re

ROOT = Path(__file__).resolve().parents[2]


def main():
    baseline = ROOT / 'docs/evidence/h03/before.json'
    scope = 'local-originals-and-history'
    external = {}
    if baseline.is_file():
        changes = ROOT / 'docs/evidence/h03/external_changes.json'
        if changes.is_file():
            external = json.loads(changes.read_text(encoding='utf-8'))
    else:
        baseline = ROOT / 'tools/h03/public_h1_baseline.json'
        scope = 'public-h1-baseline-only'
    if not baseline.is_file():
        print('FAIL: no local or public integrity baseline supplied')
        return 1
    before = json.loads(baseline.read_text(encoding='utf-8'))
    errors = []
    preserved = 0
    for name, expected in before.items():
        if name.startswith(('assets/', 'scripts/', 'scenes/', 'tests/h02/', 'tools/h02/', 'docs/history/', 'docs/evidence/h02/', 'docs/evidence/pre_h03/')) or name in ('project.godot', 'AGENTS.md'):
            path = ROOT / name
            accepted = external.get(name, {}).get('sha256', expected)
            if not path.exists() or hashlib.file_digest(path.open('rb'), 'sha256').hexdigest() != accepted:
                errors.append('Original changed/missing: ' + name)
            preserved += 1
    count = 0
    for folder in ('scenes', 'scripts', 'resources'):
        for path in (ROOT / folder).rglob('*'):
            if path.suffix not in ('.gd', '.tscn', '.tres', '.gdshader'):
                continue
            for ref in re.findall(r'res://[^"\s\)]+', path.read_text(encoding='utf-8')):
                if not (ROOT / ref[6:]).is_file():
                    errors.append(f'Missing dependency: {path.relative_to(ROOT)} -> {ref}')
                if ref.startswith('res://assets/'):
                    errors.append('Runtime depends on uncurated originals: ' + ref)
                count += 1
    for record in json.loads((ROOT / 'resources/art_samples/manifest.json').read_text(encoding='utf-8')):
        path = ROOT / record['destination']
        if not path.is_file() or hashlib.file_digest(path.open('rb'), 'sha256').hexdigest() != record['sha256']:
            errors.append('Sample changed without manifest: ' + record['destination'])
    print(json.dumps(dict(scope=scope, checked=preserved, external_changes=external, runtime_references=count, errors=errors), ensure_ascii=False, indent=2))
    return 1 if errors else 0


if __name__ == '__main__':
    raise SystemExit(main())
