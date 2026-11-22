"""Blender 4.5.3 --background --factory-startup --python tools/h04/build_kit.py.

Original experimental geometry. Metres, floor-centred origins, applied transforms,
UVs and embedded materials. No third-party source geometry or textures.
"""
from pathlib import Path
import hashlib
import json
import bpy

ROOT = Path(__file__).resolve().parents[2]
OUT = ROOT / 'resources/art_kit'
SOURCE = ROOT / 'art_sources/h04'
PALETTE = {'paint': ('354c50', .35, .82), 'edge': ('74817b', .55, .68),
           'dark': ('161f24', .2, .9), 'ochre': ('af8749', .1, .85)}


def material(name):
    tint, metal, rough = PALETTE[name]
    mat = bpy.data.materials.new('h04_' + name)
    mat.use_nodes = True
    node = mat.node_tree.nodes.get('Principled BSDF')
    srgb = [int(tint[i:i+2], 16) / 255 for i in (0, 2, 4)]
    rgb = [v / 12.92 if v <= .04045 else ((v + .055) / 1.055) ** 2.4 for v in srgb]
    node.inputs['Base Color'].default_value = (*rgb, 1)
    node.inputs['Metallic'].default_value = metal
    node.inputs['Roughness'].default_value = rough
    return mat


def box(name, center, size, surface, bevel=0):
    bpy.ops.mesh.primitive_cube_add(size=1, location=center)
    obj = bpy.context.object
    obj.name = name
    obj.dimensions = size
    bpy.ops.object.transform_apply(location=False, rotation=False, scale=True)
    obj.data.materials.append(MATERIALS[surface])
    if bevel:
        modifier = obj.modifiers.new('deliberate_chamfer', 'BEVEL')
        modifier.width = bevel
        modifier.segments = 1
        bpy.ops.object.modifier_apply(modifier=modifier.name)
    bpy.ops.object.mode_set(mode='EDIT')
    bpy.ops.mesh.select_all(action='SELECT')
    bpy.ops.uv.smart_project(island_margin=.03)
    bpy.ops.object.mode_set(mode='OBJECT')
    return obj


def export(name):
    meshes = [o for o in bpy.context.scene.objects if o.type == 'MESH']
    bpy.ops.object.select_all(action='DESELECT')
    for obj in meshes:
        obj.select_set(True)
    bpy.context.view_layer.objects.active = meshes[0]
    bpy.ops.object.join()
    obj = bpy.context.object
    obj.name = name
    bpy.context.scene.cursor.location = (0, 0, 0)
    bpy.ops.object.origin_set(type='ORIGIN_CURSOR')
    bpy.ops.object.transform_apply(location=True, rotation=True, scale=True)
    obj.data.calc_loop_triangles()
    triangles = len(obj.data.loop_triangles)
    # Blender stores file-browser folders in .blend UI metadata, even in background.
    for screen in bpy.data.screens:
        for area in screen.areas:
            for space in area.spaces:
                if space.type == 'FILE_BROWSER' and space.params:
                    space.params.directory = b'//'
    bpy.ops.wm.save_as_mainfile(filepath=str(SOURCE / (name + '.blend')))
    path = OUT / (name + '.glb')
    bpy.ops.export_scene.gltf(filepath=str(path), export_format='GLB', use_selection=True,
                              export_yup=True, export_texcoords=True, export_normals=True,
                              export_materials='EXPORT', export_animations=False)
    return dict(name=name, destination=path.relative_to(ROOT).as_posix(),
                source=(SOURCE / (name + '.blend')).relative_to(ROOT).as_posix(),
                source_sha256=hashlib.sha256((SOURCE / (name + '.blend')).read_bytes()).hexdigest(),
                sha256=hashlib.sha256(path.read_bytes()).hexdigest(), triangles=triangles,
                dimensions_blender_m=list(obj.dimensions), uv_layers=len(obj.data.uv_layers),
                materials=[m.name for m in obj.data.materials], provenance='Original H04; build_kit.py')


OUT.mkdir(parents=True, exist_ok=True)
SOURCE.mkdir(parents=True, exist_ok=True)
bpy.context.preferences.filepaths.save_version = 0
(SOURCE.parent / '.gdignore').touch()
bpy.ops.object.select_all(action='SELECT')
bpy.ops.object.delete(use_global=False)
bpy.context.scene.unit_settings.system = 'METRIC'
bpy.context.scene.unit_settings.scale_length = 1
MATERIALS = {name: material(name) for name in PALETTE}
records = []

# Blender Z-up; Godot receives Y-up. The detailed face is Blender -Y / Godot +Z.
box('CabinetBody', (0, 0, 1), (1.1, .48, 2), 'paint', .035)
box('DoorInset', (0, -.252, 1.05), (.94, .045, 1.66), 'dark')
box('UpperDoor', (0, -.282, 1.35), (.88, .025, 1.0), 'paint', .015)
box('LowerDoor', (0, -.282, .52), (.88, .025, .55), 'paint', .015)
for z in [.38, .47, .56, .65]:
    box('Vent', (-.10, -.303, z), (.56, .02, .028), 'edge')
box('Handle', (.32, -.33, 1.2), (.035, .07, .28), 'edge', .008)
box('IDPlate', (-.2, -.307, 1.63), (.27, .012, .12), 'ochre')
records.append(export('service_cabinet'))
bpy.ops.object.delete(use_global=False)

box('WallPanel', (0, 0, 1.5), (2, .16, 3), 'paint', .025)
for x in [-.94, .94]:
    box('EdgeRail', (x, -.11, 1.5), (.09, .11, 3), 'edge')
box('Recess', (0, -.09, 1.7), (1.6, .035, 1.9), 'dark')
box('PanelSkin', (0, -.12, 1.7), (1.49, .035, 1.78), 'paint')
box('Skirting', (0, -.14, .16), (1.8, .12, .24), 'dark')
records.append(export('wall_panel'))
bpy.ops.object.delete(use_global=False)

box('Case', (0, 0, .24), (.68, .46, .48), 'ochre', .025)
box('Lid', (0, 0, .45), (.71, .49, .08), 'dark', .012)
for x in [-.23, .23]:
    box('Strap', (x, -.241, .25), (.055, .02, .36), 'edge')
box('Handle', (0, -.265, .29), (.18, .045, .045), 'dark')
records.append(export('transit_case'))

(OUT / 'manifest.json').write_text(json.dumps(dict(blender=bpy.app.version_string,
    units='metres', axis='glTF Y-up', source_script='tools/h04/build_kit.py', assets=records),indent=2))
print('H04_KIT_EXPORTED', json.dumps(records))
