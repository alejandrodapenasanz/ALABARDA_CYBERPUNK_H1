"""Blender background utility: clear personal file-browser metadata from authored sources.

Preserves meshes/materials/UVs and existing GLB bytes; refreshes only source hashes.
"""
from pathlib import Path
import hashlib
import json
import bpy

ROOT = Path(__file__).resolve().parents[2]
manifest_path = ROOT / 'resources/art_kit/manifest.json'
manifest = json.loads(manifest_path.read_text())
bpy.context.preferences.filepaths.save_version = 0
for asset in manifest['assets']:
    path = ROOT / asset['source']
    bpy.ops.wm.open_mainfile(filepath=str(path))
    adjusted = 0
    for screen in bpy.data.screens:
        for area in screen.areas:
            for space in area.spaces:
                if space.type == 'FILE_BROWSER' and space.params:
                    space.params.directory = b'//'
                    adjusted += 1
    meshes = [o for o in bpy.data.objects if o.type == 'MESH']
    triangles = 0
    for obj in meshes:
        obj.data.calc_loop_triangles()
        triangles += len(obj.data.loop_triangles)
        assert len(obj.data.uv_layers) == 1
    assert triangles == asset['triangles']
    bpy.ops.wm.save_as_mainfile(filepath=str(path))
    assert b'C:\\Users\\' not in path.read_bytes()
    asset['source_sha256'] = hashlib.sha256(path.read_bytes()).hexdigest()
    assert hashlib.sha256((ROOT / asset['destination']).read_bytes()).hexdigest() == asset['sha256']
    print('H04_SOURCE_METADATA_SANITIZED', asset['name'], adjusted, triangles)
manifest_path.write_text(json.dumps(manifest, indent=2))
