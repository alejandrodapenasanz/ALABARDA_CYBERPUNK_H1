"""Record H03 changes and check links in the documentation changed by this milestone."""
from pathlib import Path
import hashlib
import json
import re
from urllib.parse import unquote

ROOT = Path(__file__).resolve().parents[2]
OUT = ROOT / 'docs/evidence/h03'
DOCS = ['README.md', 'THIRD_PARTY_NOTICES.md'] + ['docs/' + name + '.md' for name in (
    'ARCHITECTURE', 'ASSET_REGISTRY', 'ART_BIBLE', 'BALANCE_PROVISIONAL',
    'TEST_STRATEGY', 'VALIDATION', 'HANDOFF', 'DECISIONS', 'ROADMAP', 'PROMPTS_INDEX'
)] + ['prompts/H03_INFRAESTRUCTURA_DE_PRUEBAS_Y_BALANCE.md', 'prompts/H04_VERTICAL_DE_ARTE_TEMPRANO.md']


def main():
    before = json.loads((OUT / 'before.json').read_text(encoding='utf-8'))
    current = {}
    import_sidecars = []
    for path in ROOT.rglob('*'):
        rel = path.relative_to(ROOT)
        if not path.is_file() or any(p in ('.git', '.godot', '__pycache__') for p in rel.parts):
            continue
        if path.suffix == '.import':
            import_sidecars.append(rel.as_posix())
            continue
        if rel.as_posix() in ('docs/evidence/h03/changed_files.json', 'docs/evidence/h03/document_links.json'):
            continue
        current[rel.as_posix()] = hashlib.sha256(path.read_bytes()).hexdigest()
    added = sorted(set(current) - set(before))
    modified = sorted(name for name in current.keys() & before.keys() if current[name] != before[name])
    deleted = sorted(set(before) - set(current))
    changes = dict(added=added, modified=modified, deleted=deleted, generated_import_sidecars=sorted(import_sidecars),
                   generated_audit_reports=['docs/evidence/h03/changed_files.json', 'docs/evidence/h03/document_links.json'],
                   notes=['Relative to H03 entry, not Git staged index.', 'AGENTS.md changed externally: see external_changes.json.',
                          'Generated .import sidecars listed separately because entry baseline excluded them. Caches excluded.'])
    (OUT / 'changed_files.json').write_text(json.dumps(changes, indent=2, ensure_ascii=False), encoding='utf-8')
    errors = []
    checked = 0
    for name in DOCS:
        path = ROOT / name
        for match in re.finditer(r'\[[^\]]*\]\((<[^>]+>|[^)\s]+)(?:\s+"[^"]*")?\)', path.read_text(encoding='utf-8')):
            target = match.group(1).strip('<>')
            if re.match(r'^[a-zA-Z]+:', target) or target.startswith('#'):
                continue
            target = unquote(target.split('#')[0])
            checked += 1
            if not (path.parent / target).exists():
                errors.append(dict(document=name, target=target))
    result = dict(status='FAIL' if errors else 'PASS', documents=len(DOCS), links=checked, errors=errors,
                  scope='Local Markdown link targets only, not external URL availability or semantic approval.')
    (OUT / 'document_links.json').write_text(json.dumps(result, indent=2, ensure_ascii=False), encoding='utf-8')
    print(json.dumps(dict(added=len(added), modified=modified, deleted=deleted, documentation=result), ensure_ascii=False, indent=2))
    return 1 if errors or deleted else 0


if __name__ == '__main__':
    raise SystemExit(main())
