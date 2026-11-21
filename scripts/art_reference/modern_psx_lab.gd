extends Control
## Laboratorio H03 aislado; el HUD queda fuera del escalado y postefecto 3D.

const World = preload("res://scripts/art_reference/lab_world.gd")
const HOME_VIDEO = preload("res://resources/art_samples/font/HomeVideo-Regular.ttf")
const RETRO = preload("res://resources/shaders/subtle_retro.gdshader")

var viewport: SubViewport
var world: Node3D
var display: TextureRect
var effect: ShaderMaterial
var status: Label
var comparison_panel: PanelContainer
var options := {"nearest": true, "atmospheric": true, "half_resolution": false, "retro": false, "shadows": true, "fog": false}
var camera_index := 0
var motion_preview := false
var elapsed := 0.0
var animation_index := 0

func _ready() -> void:
    viewport = SubViewport.new()
    viewport.name = "WorldViewport"
    viewport.own_world_3d = true
    viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
    add_child(viewport)
    world = World.new()
    world.name = "SampleWorld"
    viewport.add_child(world)
    display = TextureRect.new()
    display.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    display.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
    display.texture = viewport.get_texture()
    display.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
    effect = ShaderMaterial.new()
    effect.shader = RETRO
    display.material = effect
    display.mouse_filter = Control.MOUSE_FILTER_IGNORE
    add_child(display)
    _build_ui()
    resized.connect(_resize_world)
    apply_options()

func _build_ui() -> void:
    var margin := MarginContainer.new()
    margin.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
    margin.add_theme_constant_override("margin_left", 24)
    margin.add_theme_constant_override("margin_top", 18)
    margin.add_theme_constant_override("margin_right", 24)
    margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
    add_child(margin)
    var stack := VBoxContainer.new()
    stack.add_theme_constant_override("separation", 7)
    margin.add_child(stack)
    var heading := _label("ALABARDA  /  MATERIAL & LIGHT LAB", 24, Color("d4e4dc"))
    stack.add_child(heading)
    stack.add_child(_label("H03   ·   MODERN PSX   /   MUESTRAS EXPERIMENTALES", 13, Color("8fa6a8")))
    var buttons := HFlowContainer.new()
    buttons.add_theme_constant_override("h_separation", 6)
    stack.add_child(buttons)
    for spec in [["T · Filtro", "nearest"], ["L · Luz", "atmospheric"], ["R · Escala", "half_resolution"], ["X · Retro", "retro"], ["S · Sombras", "shadows"], ["G · Niebla", "fog"]]:
        var button := Button.new()
        button.text = spec[0]
        button.focus_mode = Control.FOCUS_NONE
        var key: String = spec[1]
        button.pressed.connect(func(): toggle(key))
        buttons.add_child(button)
    status = _label("", 14, Color("d3bd88"))
    stack.add_child(status)
    stack.add_child(_label("1 General   2 CRT   3 Silueta   4 Rig   M Movimiento   A Animar   F Fuentes   0 Reset   Esc Salir", 13, Color("a6b8bd")))
    comparison_panel = PanelContainer.new()
    comparison_panel.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
    comparison_panel.offset_left = 24
    comparison_panel.offset_right = -24
    comparison_panel.offset_top = -164
    comparison_panel.offset_bottom = -20
    var style := StyleBoxFlat.new()
    style.bg_color = Color(0.03, 0.06, 0.075, 0.96)
    style.content_margin_left = 16
    style.content_margin_top = 10
    style.content_margin_right = 16
    style.content_margin_bottom = 10
    comparison_panel.add_theme_stylebox_override("panel", style)
    add_child(comparison_panel)
    var columns := HBoxContainer.new()
    columns.add_theme_constant_override("separation", 28)
    comparison_panel.add_child(columns)
    for retro_font in [false, true]:
        var column := VBoxContainer.new()
        column.size_flags_horizontal = Control.SIZE_EXPAND_FILL
        columns.add_child(column)
        column.add_child(_label("HOME VIDEO / CC0 · TERMINAL" if retro_font else "GODOT / FUENTE UI · REFERENCIA", 12, Color("8da2a6")))
        for font_size in [14, 20, 28]:
            var label := _label("Instalación · Ñ áéíóú · 100/150", font_size, Color("c5e2c2"))
            if retro_font:
                label.add_theme_font_override("font", HOME_VIDEO)
            column.add_child(label)
    var aim := _label("+", 24, Color("e2e8cf"))
    aim.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
    aim.position -= Vector2(8, 18)
    add_child(aim)
    var hud := _label("VIDA 100    /    ENERGÍA 150    ·    INDICADORES SIMULADOS", 14, Color("c4d9e6"))
    hud.position = Vector2(24, 183)
    add_child(hud)
    var health := ColorRect.new()
    health.color = Color("df6d70")
    health.position = Vector2(24, 207)
    health.size = Vector2(90, 3)
    add_child(health)
    var energy := ColorRect.new()
    energy.color = Color("6ba4d9")
    energy.position = Vector2(126, 207)
    energy.size = Vector2(135, 3)
    add_child(energy)

func _label(text: String, font_size: int, color: Color) -> Label:
    var label := Label.new()
    label.text = text
    label.add_theme_font_size_override("font_size", font_size)
    label.add_theme_color_override("font_color", color)
    label.add_theme_color_override("font_shadow_color", Color("060b0f"))
    label.add_theme_constant_override("shadow_offset_y", 1)
    label.mouse_filter = Control.MOUSE_FILTER_IGNORE
    return label

func toggle(key: String) -> void:
    options[key] = not options[key]
    apply_options()

func apply_options() -> void:
    world.set_filter(options.nearest)
    world.set_lighting(options.atmospheric)
    world.set_shadows(options.shadows)
    world.set_fog(options.fog)
    effect.set_shader_parameter("enabled", options.retro)
    _resize_world()
    status.text = "%s   |   %s   |   3D %s   |   retro %s   |   sombras %s   |   niebla %s" % ["NEAREST + MIPS" if options.nearest else "LINEAR + MIPS", "ATMÓSFERA" if options.atmospheric else "NEUTRA", str(viewport.size), str(options.retro), str(options.shadows), str(options.fog)]

func _resize_world() -> void:
    var output_size := Vector2i(get_viewport_rect().size)
    viewport.size = Vector2i(maxi(1, output_size.x / 2), maxi(1, output_size.y / 2)) if options.half_resolution else output_size

func set_camera(index: int) -> void:
    camera_index = index
    motion_preview = false
    elapsed = 0.0
    world.set_camera(index)

func _unhandled_key_input(event: InputEvent) -> void:
    if not event is InputEventKey or not event.pressed or event.echo:
        return
    var keys := {KEY_T: "nearest", KEY_L: "atmospheric", KEY_R: "half_resolution", KEY_X: "retro", KEY_S: "shadows", KEY_G: "fog"}
    if keys.has(event.keycode):
        toggle(keys[event.keycode])
    elif event.keycode in [KEY_1, KEY_2, KEY_3, KEY_4]:
        set_camera(event.keycode - KEY_1)
    elif event.keycode == KEY_F:
        comparison_panel.visible = not comparison_panel.visible
    elif event.keycode == KEY_M:
        motion_preview = not motion_preview
        if not motion_preview:
            world.set_camera(camera_index)
    elif event.keycode == KEY_A:
        var clips := ["guard_idle", "jab_L", "relax"]
        animation_index = (animation_index + 1) % clips.size()
        world.arms_animation.play(clips[animation_index])
    elif event.keycode == KEY_0:
        options = {"nearest": true, "atmospheric": true, "half_resolution": false, "retro": false, "shadows": true, "fog": false}
        set_camera(0)
        animation_index = 0
        world.arms_animation.play("guard_idle")
        world.arms_animation.seek(0.1, true)
        world.arms_animation.pause()
        apply_options()
    elif event.keycode == KEY_ESCAPE:
        get_tree().quit()

func _process(delta: float) -> void:
    if motion_preview:
        elapsed += delta
        world.set_camera(camera_index)
        world.camera.position.x += sin(elapsed * 0.8) * 0.35

func capture_config() -> Dictionary:
    return {"options": options.duplicate(), "camera": str(world.camera.transform), "viewport": str(viewport.size), "output": str(get_viewport_rect().size), "materials": world.materials.size(), "mesh_instances": world.find_children("*", "MeshInstance3D", true, false).size()}
