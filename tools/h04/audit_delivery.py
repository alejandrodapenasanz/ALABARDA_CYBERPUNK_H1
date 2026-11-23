"""H04-only changed-file inventory, protected runtime hashes and Markdown links."""
from pathlib import Path
import hashlib
import json
import re
import subprocess
from urllib.parse import unquote

ROOT = Path(__file__).resolve().parents[2]
OUT = ROOT / 'docs/evidence/h04'
GROUPS = ['scripts', 'scenes', 'resources', 'tests', 'tools', 'docs', 'prompts', 'art_sources']
TOP = ['project.godot', 'AGENTS.md', 'README.md', '.gitignore', 'THIRD_PARTY_NOTICES.md']


def main():
    before = json.loads((OUT / 'before.json').read_text(encoding='utf-8'))
    paths = [ROOT / name for name in TOP]
    for folder in GROUPS:
        paths.extend(p for p in (ROOT / folder).rglob('*') if p.is_file()
                     and not any(part in ['__pycache__', 'evidence', '.godot'] for part in p.parts))
    current = {p.relative_to(ROOT).as_posix(): hashlib.sha256(p.read_bytes()).hexdigest() for p in paths}
    # Read and edited this turn, but omitted from the initial hash inventory.
    preexisting_without_entry_hash = {'THIRD_PARTY_NOTICES.md'}
    added = sorted(current.keys() - before.keys() - preexisting_without_entry_hash)
    modified = sorted({name for name in current.keys() & before.keys() if current[name] != before[name]} | preexisting_without_entry_hash)
    deleted = sorted(before.keys() - current.keys())
    errors = ['Deleted entry file: ' + name for name in deleted]
    protected = ['project.godot', 'AGENTS.md', 'scenes/main.tscn', 'scripts/main.gd', 'scripts/player.gd', 'scripts/enemy.gd', 'tests/h02/h1_probe.gd', 'resources/balance/provisional.tres']
    for name in protected:
        if current.get(name) != before[name]:
            errors.append('Protected runtime/config changed: ' + name)
    documents = [name for name in modified + added if name.endswith('.md') and not name.startswith('tools/h04/public_docs/')]
    public_templates = [name for name in modified + added if name.startswith('tools/h04/public_docs/') and name.endswith('.md')]
    links = 0
    for name in documents:
        path = ROOT / name
        for match in re.finditer(r'\[[^\]]*\]\((<[^>]+>|[^)\s]+)(?:\s+"[^"]*")?\)', path.read_text(encoding='utf-8')):
            target = match.group(1).strip('<>')
            if re.match(r'^[a-zA-Z]+:', target) or target.startswith('#'):
                continue
            target = unquote(target.split('#')[0])
            links += 1
            if not (path.parent / target).exists() and target != 'evidence/h04/delivery_audit.json':
                errors.append(f'Missing link: {name} -> {target}')
    whitespace = subprocess.run(['git', '-c', 'core.whitespace=cr-at-eol', '-c', 'core.autocrlf=false', 'diff', '--check'], cwd=ROOT, capture_output=True)
    (OUT / 'whitespace.stdout.log').write_bytes(whitespace.stdout)
    (OUT / 'whitespace.stderr.log').write_bytes(whitespace.stderr)
    if whitespace.returncode:
        errors.append('Git whitespace check failed')
    (OUT / 'git_after.txt').write_bytes(subprocess.check_output(['git', 'status', '--short', '--branch'], cwd=ROOT))
    result = dict(status='FAIL' if errors else 'PASS', errors=errors, added=added, modified=modified,
                  deleted=deleted, protected_runtime=protected, markdown_documents=len(documents),
                  local_links=links, git_diff_check_exit=whitespace.returncode,
                  public_document_templates=public_templates,
                  preexisting_without_entry_hash=sorted(preexisting_without_entry_hash),
                  note='Compared with H04 entry, not the historical Git index. Import sidecars/UIDs included. Evidence logs excluded. Original packs separately protected by H03 integrity.')
    (OUT / 'delivery_audit.json').write_text(json.dumps(result, indent=2, ensure_ascii=False), encoding='utf-8')
    print(json.dumps(result, indent=2, ensure_ascii=False))
    return 1 if errors else 0


if __name__ == '__main__':
    raise SystemExit(main())
