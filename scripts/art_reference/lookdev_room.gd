extends RefCounted
## Kit y composición del mismo laboratorio. Sin gameplay ni colisiones.
const PROFILE = preload("res://resources/art_kit/lookdev.tres")
const PANEL = preload("res://resources/art_kit/wall_panel.glb")
const CABINET = preload("res://resources/art_kit/service_cabinet.glb")
const CASE = preload("res://resources/art_kit/transit_case.glb")
const HOME_VIDEO = preload("res://resources/art_samples/font/HomeVideo-Regular.ttf")

static func populate(world: Node3D) -> void:
    var concrete: Material = world.material(PROFILE.floor_color, 0.0, 0.95, true)
    var metal: Material = world.material(PROFILE.metal_color, 0.5, 0.75, true)
    var dark: Material = world.material(PROFILE.dark_color, 0.2, 0.9)
    var paint: Material = world.material(PROFILE.wall_color, 0.25, 0.85, true)
    world.box(world, Vector3(0, -.15, 0), Vector3(PROFILE.room_size.x, .3, PROFILE.room_size.z), concrete)
    world.box(world, Vector3(0, 2, -4.25), Vector3(12, 4, .3), dark)
    # Paneles reutilizables exportados de Blender, pivotados al suelo.
    for x in [-5.0, -3.0, 3.0, 5.0]:
        _prop(world, PANEL, Vector3(x, 0, -4.05), "WallPanel")
    for x in [-5.9, 5.9]:
        world.box(world, Vector3(x, 1.8, -1.5), Vector3(.2, 3.6, 5.2), paint)
    world.box(world, Vector3(0, 3.6, -3.7), Vector3(12, .3, .5), metal)
    for z in [-3.4, -2.9]:
        world.box(world, Vector3(0, 3.4, z), Vector3(11.6, .07, .07), dark)
    # Conducciones de servicio: recorridos legibles por el borde, sin tapar zonas.
    for x in [-5.6, -5.35]:
        world.box(world, Vector3(x, 1.65, -3.7), Vector3(.09, 3.1, .09), metal)
        for y in [.5, 1.5, 2.5]:
            world.box(world, Vector3(x, y, -3.64), Vector3(.15, .09, .16), dark)
    # Nicho central y marco cálido: un fondo que separa la silueta.
    world.box(world, Vector3(0, 1.5, -4.0), Vector3(2.0, 3, .08), paint)
    for x in [-1.06, 1.06]:
        world.box(world, Vector3(x, 1.5, -3.9), Vector3(.13, 3, .15), metal)
    world.box(world, Vector3(0, 2.9, -3.85), Vector3(2.1, .12, .18), world.material(PROFILE.warm_color, .1, .85))
    # Costuras de suelo y camino despejado. El detalle se concentra en bordes.
    for x in [-4.0, -2.0, 0.0, 2.0, 4.0]:
        world.box(world, Vector3(x, .002, -.2), Vector3(.022, .008, 9), dark)
    for z in [-3.0, -1.0, 1.0, 3.0]:
        world.box(world, Vector3(0, .002, z), Vector3(11.8, .008, .022), dark)
    for x in [-1.0, 1.0]:
        world.box(world, Vector3(x, .009, -2), Vector3(.04, .01, 2.6), world.material(PROFILE.warm_color, 0, 1))
    for x in [-4.0, 0.0, 4.0]:
        world.box(world, Vector3(x, 3.15, -3.75), Vector3(1.7, .13, .2), dark)
        world.box(world, Vector3(x, 3.14, -3.63), Vector3(1.5, .045, .025), world.emissive(PROFILE.terminal_color))

    var desk: Node3D = world.DESK.instantiate()
    desk.name = "OfficeSample"
    desk.position = Vector3(-3.2, 0, -1.5)
    world.add_child(desk)
    world.sample_nodes.append(desk)
    var crt: Node3D = world.CRT.instantiate()
    crt.name = "CRTSample"
    crt.position = Vector3(-3.2, .9, -1.5)
    world.add_child(crt)
    world.sample_nodes.append(crt)
    world.box(world, Vector3(-3.1, .02, -2.4), Vector3(.045, .04, 1.7), dark)
    world.box(world, Vector3(-3.1, 1.0, -3.2), Vector3(.045, 2, .04), dark)
    _sign(world, "TerminalSign", "TALLER / 04\nEN LÍNEA", Vector3(-3.3, 2.36, -3.78), Vector2(1.8, .72))
    _sign(world, "ServiceSign", "SERVICIO\nSECTOR 04", Vector3(3.8, 2.55, -3.78), Vector2(1.6, .64))
    # Dos muestras del pack industrial, nunca el catálogo completo.
    var industrial: Node = world.INDUSTRIAL.instantiate()
    for spec in [["Barrel_1", Vector3(2.5, .04, -2.8)], ["Ventilation_1", Vector3(5.0, .04, -3.1)]]:
        var source := industrial.find_child(spec[0], true, false) as Node3D
        if source:
            var sample := source.duplicate() as Node3D
            sample.transform = Transform3D.IDENTITY
            sample.position = spec[1]
            world.add_child(sample)
            world.sample_nodes.append(sample)
    industrial.free()
    _prop(world, CABINET, Vector3(3.8, 0, -3.4), "ServiceCabinet")
    for index in range(3):
        _prop(world, CASE, Vector3(2.7 + index * .76, 0, -1.8), "TransitCase")
    # Desgaste y paleta se ajustan en instancias; los imports fuente permanecen intactos.
    _silhouette(world, metal, dark)
    for spec in [[Vector3(-3.1, 2.4, -.6), Color("76b8ac")], [Vector3(3.4, 2.8, -1.6), Color("dba979")]]:
        var light := OmniLight3D.new()
        light.position = spec[0]
        light.light_color = spec[1]
        light.omni_range = PROFILE.local_range
        world.add_child(light)
        world.point_lights.append(light)

static func _prop(world: Node3D, scene: PackedScene, position: Vector3, label: String) -> void:
    var prop := scene.instantiate() as Node3D
    prop.name = label
    prop.position = position
    prop.set_meta("h04_kit", true)
    world.add_child(prop)

static func _silhouette(world: Node3D, metal: Material, dark: Material) -> void:
    var body := Node3D.new()
    body.name = "SilhouetteFixture"
    body.position = Vector3(.2, 0, -1.2)
    world.add_child(body)
    var suit: Material = world.material(Color("777c70"), .1, .9)
    world.box(body, Vector3(0, 1.2, 0), Vector3(.50, .64, .28), suit)
    world.box(body, Vector3(0, 1.34, .17), Vector3(.44, .35, .08), metal)
    world.box(body, Vector3(0, .89, 0), Vector3(.44, .13, .29), dark)
    world.box(body, Vector3(0, 1.73, 0), Vector3(.32, .31, .30), dark)
    world.box(body, Vector3(0, 1.77, .158), Vector3(.24, .045, .018), world.emissive(PROFILE.warm_color))
    for x in [-.16, .16]:
        world.box(body, Vector3(x, .48, 0), Vector3(.2, .78, .23), suit)
        world.box(body, Vector3(x, .43, .14), Vector3(.21, .17, .08), metal)
        world.box(body, Vector3(x, .1, .05), Vector3(.23, .18, .36), dark)
        world.box(body, Vector3(x * 2.3, 1.26, 0), Vector3(.17, .61, .21), suit)
        world.box(body, Vector3(x * 2.3, 1.5, 0), Vector3(.25, .17, .29), metal)

static func _sign(world: Node3D, label: String, text: String, position: Vector3, dimensions: Vector2) -> void:
    var viewport := SubViewport.new()
    viewport.name = label + "Viewport"
    viewport.size = Vector2i(320, 128)
    viewport.transparent_bg = false
    viewport.render_target_update_mode = SubViewport.UPDATE_ONCE
    world.add_child(viewport)
    var background := ColorRect.new()
    background.color = Color("10201e")
    background.size = Vector2(viewport.size)
    viewport.add_child(background)
    var title := Label.new()
    title.text = text
    title.position = Vector2(12, 12)
    title.add_theme_font_override("font", HOME_VIDEO)
    title.add_theme_font_size_override("font_size", 40)
    title.add_theme_color_override("font_color", PROFILE.terminal_color)
    viewport.add_child(title)
    var surface := StandardMaterial3D.new()
    surface.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
    surface.albedo_texture = viewport.get_texture()
    surface.texture_filter = BaseMaterial3D.TEXTURE_FILTER_LINEAR
    var mesh := MeshInstance3D.new()
    mesh.name = label
    var quad := QuadMesh.new()
    quad.size = dimensions
    mesh.mesh = quad
    mesh.material_override = surface
    mesh.position = position
    world.add_child(mesh)
