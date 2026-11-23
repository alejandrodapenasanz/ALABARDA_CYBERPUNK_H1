"""Verify original bytes, H1 entry point and curated runtime references."""
from pathlib import Path
import hashlib
import json
import re

ROOT = Path(__file__).resolve().parents[2]


def main():
    # Full development transfers retain historical evidence, but optional local
    # assets and the original PC's index are not part of their portable scope.
    portable = ROOT / 'tools/pipeline/checkout_manifest.json'
    if portable.is_file():
        import importlib.util
        spec = importlib.util.spec_from_file_location('portable_integrity', ROOT / 'tools/pipeline/verify_checkout.py')
        module = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(module)
        result = module.check(ROOT, runtime_only=True)
        print(json.dumps(result, ensure_ascii=False, indent=2))
        return 0 if result['status'] == 'PASS' else 1
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
    absent_local_samples = []
    for folder in ('scenes', 'scripts', 'resources'):
        for path in (ROOT / folder).rglob('*'):
            if path.suffix not in ('.gd', '.tscn', '.tres', '.gdshader'):
                continue
            for ref in re.findall(r'res://[^"\s\)]+', path.read_text(encoding='utf-8')):
                if ref.startswith('res://resources/local_experiments/') and not (ROOT / ref[6:]).is_file():
                    absent_local_samples.append(ref)
                    continue
                if not (ROOT / ref[6:]).is_file():
                    errors.append(f'Missing dependency: {path.relative_to(ROOT)} -> {ref}')
                if ref.startswith('res://assets/'):
                    errors.append('Runtime depends on uncurated originals: ' + ref)
                count += 1
    for record in json.loads((ROOT / 'resources/art_samples/manifest.json').read_text(encoding='utf-8')):
        path = ROOT / record['destination']
        if not path.is_file() or hashlib.file_digest(path.open('rb'), 'sha256').hexdigest() != record['sha256']:
            errors.append('Sample changed without manifest: ' + record['destination'])
    local_manifest = ROOT / 'resources/local_experiments/malorian/manifest.json'
    if local_manifest.exists():
        for record in json.loads(local_manifest.read_text(encoding='utf-8')):
            path = ROOT / record['destination']
            if not path.is_file() or hashlib.sha256(path.read_bytes()).hexdigest() != record['sha256']:
                errors.append('Local sample changed: ' + record['destination'])
    print(json.dumps(dict(scope=scope, checked=preserved, external_changes=external, runtime_references=count, absent_optional_local_samples=absent_local_samples, errors=errors), ensure_ascii=False, indent=2))
    return 1 if errors else 0


if __name__ == '__main__':
    raise SystemExit(main())
