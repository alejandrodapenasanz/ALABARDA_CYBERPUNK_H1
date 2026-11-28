import hashlib
import json
from pathlib import Path
import re
import subprocess
import xml.etree.ElementTree as ET

root = Path('C:/dev/ALABARDA_CYBERPUNK_H1')
pkg = root / 'validation/B01'
source = 'f951cb6892e2867f28ceb3edebb823377c6ecd8f'
old = subprocess.check_output(['git', 'show', source + ':validation/B01/TEST_RESULTS.md'], cwd=root)
old_section = old[old.index(b'## Intento 00'):old.index('## Veredicto técnico'.encode())]
new = (pkg / 'TEST_RESULTS.md').read_bytes()
new_section = new[new.index(b'## Intento 00'):new.index(b'## Intento 01')]
assert old_section == new_section, 'Intento 00 changed'
old_validation = subprocess.check_output(['git', 'show', source + ':docs/VALIDATION.md'], cwd=root)
assert (root / 'docs/VALIDATION.md').read_bytes().endswith(old_validation)
checked = 0
rows = []
for attempt, expected in [('attempt_01', 'FAIL'), ('attempt_02', 'PASS')]:
    folder = pkg / 'evidence' / attempt
    data = json.loads((folder / 'summary.json').read_text())
    assert data['status'] == expected
    for name, digest in json.loads((folder / 'raw_artifacts_sha256.json').read_text()).items():
        assert hashlib.sha256((folder / name).read_bytes()).hexdigest() == digest, name
        checked += 1
    for xml in folder.rglob('results.xml'):
        cases = list(ET.parse(xml).getroot().iter('testcase'))
        counts = {'tests': len(cases), 'failures': sum(c.find('failure') is not None for c in cases),
                  'errors': sum(c.find('error') is not None for c in cases),
                  'skipped': sum(c.find('skipped') is not None for c in cases)}
        if 'negative_control_reports' in xml.parts:
            assert counts == dict(tests=1, failures=1, errors=0, skipped=0)
        else:
            assert counts['failures'] == counts['errors'] == counts['skipped'] == 0
        rows.append({'file': str(xml.relative_to(root)), **counts})
    for file in (folder / 'manual').glob('*.md'):
        assert 'NOT_RUN' in file.read_text(encoding='utf-8')
        assert 'las realiza el creador' in file.read_text(encoding='utf-8')
manifest = json.loads((pkg / 'TEST_MANIFEST.json').read_text(encoding='utf-8'))
assert manifest['code_commit'] == '94e4880b03b60d1517917d11ab98dce786499d69'
assert all(t['owner'] == 'CREATOR' for t in manifest['tests'] if t['type'] == 'manual')
for test in manifest['tests']:
    assert (pkg / test['log_path']).is_file(), test['log_path']
    if test['type'] != 'manual':
        for artifact in test['artifacts']:
            assert (pkg / artifact).is_file(), artifact
files = [root / p for p in ['docs/HANDOFF.md', 'docs/ROADMAP.md', 'docs/VALIDATION.md',
                           'validation/B01/TEST_HANDOFF.md', 'validation/B01/TEST_RESULTS.md',
                           'validation/B01/bugs/BUG-B1-01.md']]
links = 0
for file in files:
    text = re.sub(r'```.*?```', '', file.read_text(encoding='utf-8'), flags=re.S)
    for target in re.findall(r'(?<!!)\[[^\]\n]+\]\(([^)\n]+)\)', text):
        if target.startswith(('http:', 'https:', 'mailto:')):
            continue
        path = target.split('#', 1)[0].strip('<>')
        if path:
            assert (file.parent / path).exists(), (str(file), target)
            links += 1
unchanged_runtime = subprocess.check_output(['git', 'diff', '94e4880', '--name-only', '--',
        'scripts', 'scenes', 'resources', 'tests', 'addons', 'art_sources', 'project.godot', 'tools'], cwd=root)
assert not unchanged_runtime.strip(), unchanged_runtime
print(json.dumps({'status': 'PASS', 'raw_artifacts_verified': checked,
                  'local_links_verified': links, 'original_attempt_00_preserved': True,
                  'historical_validation_preserved': True, 'runtime_matches_tested_commit': True,
                  'junit': rows}, indent=2))
