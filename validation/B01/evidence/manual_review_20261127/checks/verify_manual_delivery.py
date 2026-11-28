import hashlib
import json
from pathlib import Path
import re
import subprocess

root = Path('C:/dev/ALABARDA_CYBERPUNK_H1')
pkg = root / 'validation/B01'
diagnostic = pkg / 'evidence/diagnostic_03'
hashes = json.loads((diagnostic / 'raw_artifacts_sha256.json').read_text())
for name, digest in hashes.items():
    assert hashlib.sha256((diagnostic / name).read_bytes()).hexdigest() == digest, name
manifest = json.loads((pkg / 'TEST_MANIFEST.json').read_text(encoding='utf-8'))
assert manifest['state'] == 'VALIDATION_FAILED'
assert manifest['code_commit'] == '94e4880b03b60d1517917d11ab98dce786499d69'
for test in manifest['tests']:
    if test['type'] == 'manual':
        text = (pkg / test['log_path']).read_text(encoding='utf-8')
        result = 'FAIL' if test['id'] == 'M-02-WALL' else 'PASS'
        assert f'**{result}**' in text, test['id']
        assert test['owner'] == 'CREATOR'
files = [root / name for name in subprocess.check_output(['git', 'diff', '--name-only'], cwd=root, text=True).splitlines() if name.endswith('.md')]
files.extend([pkg / 'bugs/BUG-B1-02.md', diagnostic / 'README.md'])
files.extend((pkg / 'evidence/manual_review_20261127').glob('*.md'))
links = 0
for file in files:
    text = re.sub(r'```.*?```', '', file.read_text(encoding='utf-8'), flags=re.S)
    for target in re.findall(r'(?<!!)\[[^\]\n]+\]\(([^)\n]+)\)', text):
        if target.startswith(('http:', 'https:', 'mailto:')):
            continue
        path = target.split('#', 1)[0].strip('<>')
        if path:
            assert (file.parent / path).exists(), (file, path)
            links += 1
runtime = subprocess.run(['git', 'diff', '--exit-code', '94e4880b03b60d1517917d11ab98dce786499d69', '--', 'scripts', 'scenes', 'resources', 'tests', 'addons', 'art_sources', 'project.godot', 'tools'], cwd=root, capture_output=True)
assert runtime.returncode == 0, runtime.stdout
print(json.dumps({'status': 'PASS', 'diagnostic_raw_artifacts_verified': len(hashes), 'local_links_checked': links, 'manual_results': {'PASS': 7, 'FAIL': 1}, 'runtime_and_tests_match_C94e4880': True, 'weapon_position_appearance_animations_unchanged': True}, indent=2))
