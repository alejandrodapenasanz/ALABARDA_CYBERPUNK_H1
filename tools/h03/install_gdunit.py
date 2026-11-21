"""Install the pinned MIT GdUnit4 release; refuse overwrites of different files."""
from pathlib import Path
import hashlib
import io
import json
import sys
import urllib.request
import zipfile

ROOT = Path(__file__).resolve().parents[2]
LOCK = ROOT / 'tools/h03/gdunit.lock.json'


def install(destination):
    lock = json.loads(LOCK.read_text(encoding='utf-8'))
    data = urllib.request.urlopen(lock['url'], timeout=60).read()
    actual = hashlib.sha256(data).hexdigest()
    if actual != lock['sha256']:
        raise RuntimeError('Archive SHA-256 differs from pinned release')
    archive = zipfile.ZipFile(io.BytesIO(data))
    entries = {}
    prefix = archive.namelist()[0].split('/')[0] + '/'
    for name in archive.namelist():
        rel = name.removeprefix(prefix)
        if name.endswith('/'):
            continue
        if rel.startswith('addons/gdUnit4/'):
            target = destination / rel
        elif rel == 'LICENSE':
            target = destination / 'addons/gdUnit4/LICENSE'
        else:
            continue
        if not target.resolve().is_relative_to(destination.resolve()):
            raise RuntimeError('Archive path outside destination')
        content = archive.read(name)
        if target.exists() and target.read_bytes() != content:
            raise RuntimeError(f'Refusing to overwrite {target}')
        entries[target] = content
    for target, content in entries.items():
        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_bytes(content)
    print(f'GdUnit4 {lock["version"]}: {len(entries)} files, SHA-256 verified')


if __name__ == '__main__':
    install(Path(sys.argv[1]).resolve() if len(sys.argv) > 1 else ROOT)
