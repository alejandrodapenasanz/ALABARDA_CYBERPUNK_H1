extends Node3D
## Composición experimental. No colisiones, IA ni interacciones de gameplay.

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
    var concrete := material(Color("515755"), 0.0, 0.95, true)
    var metal := material(Color("66747b"), 0.7, 0.62, true)
    var dark := material(Color("242d32"), 0.25, 0.8)
    var office := material(Color("87735b"), 0.0, 0.9, true)
    box(self, Vector3(0, -0.15, 0), Vector3(12, 0.3, 10), concrete)
    box(self, Vector3(0, 2.0, -4.2), Vector3(12, 4.0, 0.25), dark)
    for x in [-5.7, -2.0, 2.0, 5.7]:
        box(self, Vector3(x, 2.0, -4.0), Vector3(0.12, 4, 0.16), metal)
    for x in [-4.3, 0.0, 4.3]:
        box(self, Vector3(x, 3.6, -3.9), Vector3(2.0, 0.05, 0.06), emissive(Color("c9dbbd")))
    for index in range(3):
        var x := -3.8 + index * 3.8
        box(self, Vector3(x, 1.7, -4.0), Vector3(2.1, 1.1, 0.12), [concrete, office, metal][index])
    var desk := DESK.instantiate() as Node3D
    desk.name = "OfficeSample"
    desk.position = Vector3(-3.2, 0, -1.5)
    add_child(desk)
    sample_nodes.append(desk)
    var crt := CRT.instantiate() as Node3D
    crt.name = "CRTSample"
    crt.position = Vector3(-3.2, 0.9, -1.5)
    add_child(crt)
    sample_nodes.append(crt)
    # Extraer solo dos meshes del FBX; el catálogo completo no se instancia en la sala.
    var industrial_source := INDUSTRIAL.instantiate()
    for spec in [["Barrel_1", Vector3(2.8, 0.04, -2.4)], ["Ventilation_1", Vector3(4.6, 0.04, -3.1)]]:
        var source := industrial_source.find_child(spec[0], true, false) as Node3D
        if source:
            var sample := source.duplicate() as Node3D
            sample.transform = Transform3D.IDENTITY
            sample.position = spec[1]
            add_child(sample)
            sample_nodes.append(sample)
    industrial_source.free()
    # Pared de prueba y cajas ambientales propias: la licencia PSXAmmoBoxes sigue bloqueada.
    box(self, Vector3(3.7, 1.2, -2.8), Vector3(2.4, 1.2, 0.12), dark)
    box(self, Vector3(3.7, 1.3, -2.65), Vector3(1.15, 0.16, 0.12), metal)
    for index in range(3):
        box(self, Vector3(2.95 + index * 0.7, 0.25, -2.4), Vector3(0.58, 0.45, 0.4), material(Color("8b8053"), 0.15, 0.9, true))
    # Silueta humana angular para leer amenaza en luz tenue; sin enemigo ni daño.
    var silhouette := Node3D.new()
    silhouette.name = "SilhouetteFixture"
    silhouette.position = Vector3(0.2, 0, -1.2)
    add_child(silhouette)
    var suit := material(Color("6b7274"), 0.1, 0.85)
    box(silhouette, Vector3(0, 1.2, 0), Vector3(0.52, 0.67, 0.28), suit)
    box(silhouette, Vector3(0, 1.74, 0), Vector3(0.30, 0.32, 0.29), suit)
    for x in [-0.17, 0.17]:
        box(silhouette, Vector3(x, 0.45, 0), Vector3(0.2, 0.9, 0.23), suit)
        box(silhouette, Vector3(x * 2.4, 1.2, 0), Vector3(0.18, 0.7, 0.22), suit)
    box(silhouette, Vector3(0, 1.76, 0.151), Vector3(0.23, 0.05, 0.02), emissive(Color("e5ae5a")))
    for spec in [[Vector3(-3.1, 2.4, -0.6), Color("76b8ac")], [Vector3(3.4, 2.8, -1.6), Color("dba979")]]:
        var light := OmniLight3D.new()
        light.position = spec[0]
        light.light_color = spec[1]
        light.omni_range = 6.5
        add_child(light)
        point_lights.append(light)
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
                var tone := 0.72 + float((x * 17 + y * 31) % 13) / 60.0
                if x % 32 == 0 or y % 32 == 0:
                    tone = 0.43
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
        surface.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST_WITH_MIPMAPS if nearest else BaseMaterial3D.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS

func set_lighting(atmospheric: bool) -> void:
    environment.ambient_light_energy = 0.24 if atmospheric else 0.65
    key_light.light_energy = 0.38 if atmospheric else 1.0
    for light in point_lights:
        light.light_energy = 1.8 if atmospheric else 0.0

func set_shadows(enabled: bool) -> void:
    key_light.shadow_enabled = enabled
    for light in point_lights:
        light.shadow_enabled = enabled

func set_fog(enabled: bool) -> void:
    environment.fog_enabled = enabled
    environment.fog_density = 0.018
    environment.fog_light_color = Color("293d43")

func set_camera(index: int) -> void:
    var positions := [Vector3(0, 2.0, 3.5), Vector3(-3.0, 1.55, 1.25), Vector3(0.2, 1.6, 3.5), Vector3(-1.4, 1.45, 1.55)]
    var targets := [Vector3(0, 1.25, -1.8), Vector3(-3.2, 1.2, -1.5), Vector3(0.2, 1.4, -1.2), Vector3(-1.4, 1.17, 0.1)]
    camera.position = positions[index]
    camera.fov = 55.0 if index == 0 else 65.0
    camera.look_at(targets[index])
