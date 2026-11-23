"""Read-only inventory of original packs; no importer or external packages required."""
from pathlib import Path
import collections
import hashlib
import json
import struct
import sys

ROOT = Path(__file__).resolve().parents[2]


def digest(path):
    return hashlib.file_digest(path.open('rb'), 'sha256').hexdigest()


def gltf_info(path):
    if path.suffix.lower() == '.glb':
        with path.open('rb') as stream:
            magic, version, length = struct.unpack('<4sII', stream.read(12))
            size, kind = struct.unpack('<II', stream.read(8))
            if magic != b'glTF' or kind != 0x4E4F534A:
                raise ValueError('Invalid GLB header')
            doc = json.loads(stream.read(size))
    else:
        doc = json.loads(path.read_text(encoding='utf-8-sig'))
    acc = doc.get('accessors', [])
    primitives = [p for m in doc.get('meshes', []) for p in m['primitives']]
    triangles = sum(acc[p['indices']]['count'] // 3 if 'indices' in p else acc[p['attributes']['POSITION']]['count'] // 3 for p in primitives if p.get('mode', 4) == 4)
    deps = [v['uri'] for key in ('buffers', 'images') for v in doc.get(key, []) if 'uri' in v and not v['uri'].startswith('data:')]
    return dict(generator=doc.get('asset', {}), meshes=len(doc.get('meshes', [])), triangles=triangles,
                materials=doc.get('materials', []), images=doc.get('images', []), dependencies=deps,
                missing_dependencies=[p for p in deps if not (path.parent / p).exists()],
                skins=[dict(name=s.get('name'), joints=len(s['joints'])) for s in doc.get('skins', [])],
                animations=[dict(name=a.get('name'), channels=len(a['channels'])) for a in doc.get('animations', [])],
                bounds=[dict(min=acc[p['attributes']['POSITION']].get('min'), max=acc[p['attributes']['POSITION']].get('max')) for p in primitives],
                root_nodes=[doc.get('nodes', [])[i] for s in doc.get('scenes', []) for i in s.get('nodes', [])])


def inventory():
    packs = []
    hashes = collections.defaultdict(list)
    for pack in sorted((ROOT / 'assets').iterdir()):
        if pack.name == 'experimental' or pack.name.endswith('.import'):
            continue
        files = sorted(pack.rglob('*')) if pack.is_dir() else [pack]
        records = []
        for path in files:
            if not path.is_file() or path.suffix in ('.import', '.uid') or path.name == '.gdignore':
                continue
            rel = path.relative_to(ROOT).as_posix()
            record = dict(path=rel, bytes=path.stat().st_size, sha256=digest(path), format=path.suffix.lower())
            hashes[record['sha256']].append(rel)
            if path.suffix.lower() in ('.glb', '.gltf'):
                try:
                    record['gltf'] = gltf_info(path)
                except Exception as exc:
                    record['inspection_error'] = str(exc)
            if path.suffix.lower() == '.png':
                with path.open('rb') as stream:
                    header = stream.read(24)
                if header[:8] == b'\x89PNG\r\n\x1a\n':
                    record['image_size'] = list(struct.unpack('>II', header[16:24]))
            records.append(record)
        packs.append(dict(name=pack.name, path=pack.relative_to(ROOT).as_posix(), files=records,
                          formats=dict(collections.Counter(r['format'] for r in records)),
                          bytes=sum(r['bytes'] for r in records)))
    return dict(packs=packs, duplicates=[paths for paths in hashes.values() if len(paths) > 1])


if __name__ == '__main__':
    report = inventory()
    output = Path(sys.argv[1]) if len(sys.argv) > 1 else ROOT / 'docs/evidence/h03/assets_inventory.json'
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(json.dumps(report, ensure_ascii=False, indent=2), encoding='utf-8')
    for pack in report['packs']:
        print(json.dumps({k: v for k, v in pack.items() if k != 'files'}, ensure_ascii=False))
    print('duplicate groups:', len(report['duplicates']))
