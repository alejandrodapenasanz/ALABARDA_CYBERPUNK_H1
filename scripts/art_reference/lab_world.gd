extends Node3D
## Composición experimental. No colisiones, IA ni interacciones de gameplay.

const Room = preload("res://scripts/art_reference/lookdev_room.gd")
const PROFILE = preload("res://resources/art_kit/lookdev.tres")
const CRT = preload("res://resources/art_samples/crt/CRTTV.gltf")
const DESK = preload("res://resources/art_samples/office/desk1_weathered.glb")
const ARMS = preload("res://resources/art_samples/arms/arms_rig.glb")
const INDUSTRIAL = preload("res://resources/art_samples/industrial/Models/IndustrialHorror_PS_like.fbx")
const LOCAL_VIEWMODEL = "res://resources/local_experiments/malorian/Malorian.fbx"

var materials: Array[BaseMaterial3D] = []
var camera: Camera3D
var environment: Environment
var key_light: DirectionalLight3D
var point_lights: Array[OmniLight3D] = []
var arms_animation: AnimationPlayer
var sample_nodes: Array[Node3D] = []
var viewmodel_name := "Arma abstracta / muestra pública"
var viewmodel: Node3D

func _ready() -> void:
    var world_environment := WorldEnvironment.new()
    environment = Environment.new()
    environment.background_mode = Environment.BG_COLOR
    environment.background_color = Color("10191e")
    environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
    environment.ambient_light_color = Color("9aafba")
    world_environment.environment = environment
    add_child(world_environment)
    key_light = DirectionalLight3D.new()
    key_light.rotation_degrees = Vector3(-55, -28, 0)
    add_child(key_light)
    Room.populate(self)
    var dark := material(PROFILE.dark_color, 0.25, 0.8)
    var metal := material(PROFILE.metal_color, 0.5, 0.75)
    camera = Camera3D.new()
    camera.name = "ReferenceCamera"
    camera.fov = 65.0
    camera.near = 0.04
    camera.current = true
    add_child(camera)
    var arms := ARMS.instantiate() as Node3D
    arms.name = "FPSArmsSample"
    arms.position = Vector3(-1.4, 0.25, 0.1)
    arms.scale = Vector3.ONE * 0.7
    add_child(arms)
    box(self, Vector3(-1.4, 0.25, 0.1), Vector3(1.2, 0.5, 0.7), dark)
    sample_nodes.append(arms)
    arms_animation = arms.find_child("AnimationPlayer", true, false) as AnimationPlayer
    if arms_animation:
        arms_animation.play("guard_idle")
        arms_animation.seek(0.1, true)
        arms_animation.pause()
    # Muestra opcional local; la publicación conserva el sustituto propio.
    var gun := Node3D.new()
    gun.name = "FPSReference"
    gun.position = Vector3(0.25, -0.19, -0.70)
    camera.add_child(gun)
    viewmodel = gun
    if not _load_local_viewmodel(gun):
        gun.scale = Vector3.ONE * 0.7
        box(gun, Vector3.ZERO, Vector3(0.16, 0.13, 0.44), dark)
        box(gun, Vector3(0, -0.12, 0.12), Vector3(0.13, 0.26, 0.13), metal)
        box(gun, Vector3(0, 0.08, -0.04), Vector3(0.025, 0.02, 0.09), emissive(Color("b8d9b2")))
    for mesh in gun.find_children("*", "MeshInstance3D", true, false):
        mesh.layers = 2
        mesh.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
    var viewmodel_light := OmniLight3D.new()
    viewmodel_light.position = Vector3(-0.2, 0.2, -0.3)
    viewmodel_light.light_energy = 0.25
    viewmodel_light.omni_range = 2.0
    viewmodel_light.light_cull_mask = 2
    camera.add_child(viewmodel_light)
    collect_materials(self)
    _harmonize_samples()
    set_camera(0)
    set_lighting(false)

func material(tint: Color, metallic: float, roughness: float, textured := false) -> StandardMaterial3D:
    var result := StandardMaterial3D.new()
    result.albedo_color = tint
    result.metallic = metallic
    result.roughness = roughness
    if textured:
        var pixels := Image.create(64, 64, false, Image.FORMAT_RGB8)
        for y in range(64):
            for x in range(64):
                var tone := 0.88 + float((x * 17 + y * 31) % 13) / 150.0
                if y % 32 == 0:
                    tone = 0.74
                pixels.set_pixel(x, y, Color(tone, tone, tone))
        pixels.generate_mipmaps()
        result.albedo_texture = ImageTexture.create_from_image(pixels)
    return result

func emissive(tint: Color) -> StandardMaterial3D:
    var result := material(tint, 0, 1)
    result.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
    return result

func box(parent: Node3D, pos: Vector3, dimensions: Vector3, surface: Material) -> MeshInstance3D:
    var instance := MeshInstance3D.new()
    var mesh := BoxMesh.new()
    mesh.size = dimensions
    instance.mesh = mesh
    instance.material_override = surface
    instance.position = pos
    parent.add_child(instance)
    return instance

func _load_local_viewmodel(gun: Node3D) -> bool:
    if not ResourceLoader.exists(LOCAL_VIEWMODEL):
        return false
    var packed := load(LOCAL_VIEWMODEL) as PackedScene
    if packed == null:
        return false
    var source := packed.instantiate()
    var original := source.find_child("Malorian", true, false) as MeshInstance3D
    var texture_path := LOCAL_VIEWMODEL.get_base_dir().path_join("Textures/Malorian_Base.png")
    if original == null or not ResourceLoader.exists(texture_path):
        source.free()
        return false
    var mesh := original.duplicate() as MeshInstance3D
    var bounds := mesh.transform * mesh.get_aabb()
    mesh.position -= bounds.get_center()
    var surface := material(Color.WHITE, 0.15, 0.8)
    surface.albedo_texture = load(texture_path) as Texture2D
    mesh.material_override = surface
    gun.add_child(mesh)
    gun.scale = Vector3.ONE * (0.50 / bounds.size.z)
    gun.rotation_degrees.y = 170.0
    source.free()
    viewmodel_name = "Malorian / prueba local"
    return true

func collect_materials(node: Node) -> void:
    if node is MeshInstance3D:
        var instance := node as MeshInstance3D
        if instance.material_override is BaseMaterial3D:
            var copy := instance.material_override.duplicate() as BaseMaterial3D
            instance.material_override = copy
            materials.append(copy)
        else:
            for index in range(instance.mesh.get_surface_count()):
                var source := instance.get_active_material(index) as BaseMaterial3D
                if source:
                    var copy := source.duplicate() as BaseMaterial3D
                    instance.set_surface_override_material(index, copy)
                    materials.append(copy)
    for child in node.get_children():
        collect_materials(child)

func set_filter(nearest: bool) -> void:
    for surface in materials:
        # Texto de viewport sin mipmaps: conservar trazos al reducirlo en pantalla.
        if surface.albedo_texture is ViewportTexture:
            surface.texture_filter = BaseMaterial3D.TEXTURE_FILTER_LINEAR
        else:
            surface.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST_WITH_MIPMAPS if nearest else BaseMaterial3D.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS

func set_lighting(atmospheric: bool) -> void:
    environment.ambient_light_color = Color("9aafba")
    environment.ambient_light_energy = PROFILE.ambient_atmospheric if atmospheric else PROFILE.ambient_neutral
    key_light.light_energy = PROFILE.key_atmospheric if atmospheric else PROFILE.key_neutral
    for index in range(point_lights.size()):
        var light := point_lights[index]
        light.light_color = Color("76b8ac") if index == 0 else Color("dba979")
        light.light_energy = PROFILE.local_energy if atmospheric else 0.0

func set_shadows(enabled: bool) -> void:
    key_light.shadow_enabled = enabled
    for light in point_lights:
        light.shadow_enabled = enabled

func set_fog(enabled: bool) -> void:
    environment.fog_enabled = enabled
    environment.fog_density = 0.018
    environment.fog_light_color = Color("293d43")

func set_camera(index: int) -> void:
    camera.position = PROFILE.camera_positions[index]
    camera.fov = 55.0 if index == 0 else 65.0
    camera.look_at(PROFILE.camera_targets[index])

func set_alarm_lighting() -> void:
    # Condición de inspección estática: no activa un sistema de alarmas.
    environment.ambient_light_energy = PROFILE.ambient_alarm
    key_light.light_energy = PROFILE.key_alarm
    point_lights[0].light_color = Color("d87660")
    point_lights[1].light_color = Color("9eb3b9")
    for light in point_lights:
        light.light_energy = PROFILE.local_energy

func _harmonize_samples() -> void:
    var wear := material(Color.WHITE, 0, 1, true).albedo_texture
    for prop in get_children():
        if prop.has_meta("h04_kit"):
            for mesh in prop.find_children("*", "MeshInstance3D", true, false):
                for index in range(mesh.mesh.get_surface_count()):
                    var surface := mesh.get_active_material(index) as BaseMaterial3D
                    if surface:
                        surface.albedo_texture = wear
    for sample in sample_nodes:
        for mesh in sample.find_children("*", "MeshInstance3D", true, false) + ([sample] if sample is MeshInstance3D else []):
            for index in range(mesh.mesh.get_surface_count()):
                var surface := mesh.get_active_material(index) as BaseMaterial3D
                if surface:
                    surface.roughness = maxf(surface.roughness, 0.78)
                    surface.metallic = minf(surface.metallic, 0.3)
                    if sample.name == "OfficeSample":
                        surface.albedo_color = Color("b2b3a6")
                    elif str(sample.name).begins_with("Barrel"):
                        surface.albedo_color = Color("a6aa94")
