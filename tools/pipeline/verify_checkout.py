"""Verify the explicitly recorded portable development baseline, without Godot."""
import argparse
import hashlib
import json
from pathlib import Path, PurePosixPath
import re
from urllib.parse import unquote

ROOT = Path(__file__).resolve().parents[2]
MANIFEST = 'tools/pipeline/checkout_manifest.json'
RUNTIME = ('scripts/', 'scenes/', 'resources/', 'addons/', 'tests/', 'art_sources/', 'tools/')


def checksum(path):
    with path.open('rb') as stream:
        return hashlib.file_digest(stream, 'sha256').hexdigest()


def check(root=ROOT, runtime_only=False):
    root = Path(root).resolve()
    manifest = json.loads((root/MANIFEST).read_text(encoding='utf-8'))
    if manifest.get('schema_version') != 1 or manifest.get('scope') != 'portable-development-checkout':
        raise ValueError('Unsupported portable baseline')
    errors, checked = [], 0
    for name, expected in manifest['files'].items():
        if runtime_only and name != 'project.godot' and not name.startswith(RUNTIME):
            continue
        path = (root/name).resolve()
        if not name or '\\' in name or ':' in name or '..' in PurePosixPath(name).parts or not path.is_relative_to(root):
            errors.append('Unsafe manifest path: '+name)
            continue
        checked += 1
        if not path.is_file():
            errors.append('Missing published file: '+name)
        elif checksum(path) != expected:
            errors.append('Changed since transfer baseline: '+name)
    for name in manifest['excluded_files']:
        if (root/name).exists():
            errors.append('Excluded local asset present in portable checkout: '+name)
    links = 0
    if not runtime_only:
        docs = [root/'AGENTS.md', root/'README.md', root/'THIRD_PARTY_NOTICES.md',
                *sorted((root/'docs').glob('*.md')), *sorted((root/'prompts').rglob('*.md')),
                *sorted((root/'validation/_templates').glob('*.md'))]
        for path in docs:
            if not path.is_file():
                errors.append('Missing active guide: '+str(path.relative_to(root)))
                continue
            text = re.sub(r'```.*?```', '', path.read_text(encoding='utf-8-sig'), flags=re.S)
            for target in re.findall(r'(?<!!)\[[^\]\n]+\]\(([^)\n]+)\)', text):
                target=target.strip().strip('<>')
                if target.startswith(('https:', 'http:', 'mailto:')):
                    continue
                target=unquote(target.split('#',1)[0])
                links += 1
                if target and not (path.parent/target).exists():
                    errors.append(f'Broken link: {path.relative_to(root)} -> {target}')
        prompts = sorted(p.name[:3] for p in (root/'prompts').glob('H*.md'))
        if prompts != [f'H{i:02d}' for i in range(2,25)]:
            errors.append('Expected exactly 23 milestone prompts H02-H24')
    return {'status':'FAIL' if errors else 'PASS','scope':manifest['scope'],
            'runtime_only':runtime_only,'checked_files':checked,'active_local_links':links,
            'declared_exclusions':len(manifest['excluded_files']),'errors':errors,
            'note':'Checks the recorded transfer baseline, not approval of future gameplay or current work after edits.'}


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--runtime-only', action='store_true')
    args=parser.parse_args()
    try:
        result=check(runtime_only=args.runtime_only)
    except (OSError, ValueError, KeyError) as exc:
        result={'status':'FAIL','errors':[str(exc)]}
    print(json.dumps(result,ensure_ascii=False,indent=2))
    return 0 if result['status']=='PASS' else 1


if __name__=='__main__':
    raise SystemExit(main())
