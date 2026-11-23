"""Curate the small licensed H03 selection without altering any source binary."""
from pathlib import Path
import hashlib
import json

ROOT = Path(__file__).resolve().parents[2]


def prepare():
    mapping = {
        'assets/CRT_TV_VHS_fbx_gltx_blend_textures/GLTF/CRTTV.gltf': 'resources/art_samples/crt/CRTTV.gltf',
        'assets/OFFICE/OFFICE/desks/desk1_weathered.glb': 'resources/art_samples/office/desk1_weathered.glb',
        'assets/psx-first-person-arms-free-game-assets/arms_rig.glb': 'resources/art_samples/arms/arms_rig.glb',
        'assets/HomeVideo_Font_0_9/TrueType (.ttf)/HomeVideo-Regular.ttf': 'resources/art_samples/font/HomeVideo-Regular.ttf',
        'assets/HomeVideo_Font_0_9/License.txt': 'resources/art_samples/font/License.txt',
    }
    source_root = ROOT / 'assets/Industrial_exterior_v1 (1)/Industrial_exterior_v2'
    for path in source_root.rglob('*'):
        if path.is_file() and path.suffix.lower() in ('.fbx', '.png'):
            relative = path.relative_to(source_root).as_posix().replace('Textures/', 'textures/')
            mapping[path.relative_to(ROOT).as_posix()] = 'resources/art_samples/industrial/' + relative
    records = []
    for source, destination in mapping.items():
        content = (ROOT / source).read_bytes()
        target = ROOT / destination
        if target.exists() and target.read_bytes() != content:
            raise RuntimeError(f'Refusing to overwrite adapted asset: {destination}')
        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_bytes(content)
        records.append(dict(source=source, destination=destination, sha256=hashlib.sha256(content).hexdigest(), modification='None; curated single import copy'))
    (ROOT / 'resources/art_samples/manifest.json').write_text(json.dumps(records, ensure_ascii=False, indent=2), encoding='utf-8')
    print(f'{len(records)} curated files, originals untouched')


if __name__ == '__main__':
    prepare()
