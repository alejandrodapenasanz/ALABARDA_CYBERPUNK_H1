extends Control
## Controles y fuentes fuera de la vista 3D para no tapar las muestras.
const World = preload("res://scripts/art_reference/lab_world.gd")
const HOME_VIDEO = preload("res://resources/art_samples/font/HomeVideo-Regular.ttf")
const RETRO = preload("res://resources/shaders/subtle_retro.gdshader")
const CAMERA_NAMES := ["1 · General", "2 · CRT / oficina", "3 · Silueta", "4 · Rig de brazos"]
const CAMERA_HINTS := [
    "Taller / sector 04 · CRT y oficina · Silueta · Kit industrial",
    "CRT y escritorio · Comparar textura, desgaste y lectura en luz neutra/tenue",
    "Amenaza simulada · Revisar silueta y contraste · Sin IA ni combate",
    "Rig de referencia · A cambia de animación · No es el brazo cyborg final"
]
const DEFAULT_OPTIONS := {"nearest": true, "atmospheric": true, "half_resolution": false, "retro": false, "shadows": true, "fog": false}
var viewport: SubViewport
var world: Node3D
var display: TextureRect
var effect: ShaderMaterial
var status: Label
var comparison_panel: PanelContainer
var stage: Control
var view_title: Label
var view_hint: Label
var split_label: Label
var intensity_label: Label
var intensity_slider: HSlider
var option_buttons: Dictionary = {}
var options := DEFAULT_OPTIONS.duplicate()
var camera_index := 0
var motion_preview := false
var elapsed := 0.0
var animation_index := 0
var split_preview := false
var retro_intensity := 0.7
var alarm_preview := false

func _ready() -> void:
    viewport = SubViewport.new()
    viewport.name = "WorldViewport"
    viewport.own_world_3d = true
    viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
    add_child(viewport)
    world = World.new()
    world.name = "SampleWorld"
    viewport.add_child(world)
    _build_ui()
    apply_options()
    set_camera(0)

func _build_ui() -> void:
    var background := ColorRect.new()
    background.color = Color("0e171c")
    background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    add_child(background)
    var layout := HBoxContainer.new()
    layout.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    layout.add_theme_constant_override("separation", 16)
    add_child(layout)
    var sidebar := PanelContainer.new()
    sidebar.custom_minimum_size.x = 284
    sidebar.add_theme_stylebox_override("panel", _panel_style())
    layout.add_child(sidebar)
    var scroll := ScrollContainer.new()
    scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
    sidebar.add_child(scroll)
    var controls := VBoxContainer.new()
    controls.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    controls.add_theme_constant_override("separation", 8)
    scroll.add_child(controls)
    controls.add_child(_label("ALABARDA / H04", 23, Color("d9e7dc")))
    controls.add_child(_label("Taller · Modern PSX", 16))
    controls.add_child(HSeparator.new())
    var cameras := GridContainer.new()
    cameras.columns = 2
    controls.add_child(cameras)
    for index in range(4):
        var selected: int = index
        cameras.add_child(_button(CAMERA_NAMES[index], func(): set_camera(selected)))
    controls.add_child(HSeparator.new())
    for key in ["nearest", "atmospheric", "half_resolution", "retro", "shadows", "fog"]:
        var option: String = key
        var button := _button("", func(): cycle_lighting() if option == "atmospheric" else toggle(option))
        option_buttons[key] = button
        controls.add_child(button)
    controls.add_child(_button("B · Comparar retro A/B", toggle_split))
    intensity_label = _label("", 16, Color("d7bf88"))
    controls.add_child(intensity_label)
    intensity_slider = HSlider.new()
    intensity_slider.min_value = 0.0
    intensity_slider.max_value = 1.0
    intensity_slider.step = 0.05
    intensity_slider.value = retro_intensity
    intensity_slider.focus_mode = Control.FOCUS_NONE
    intensity_slider.value_changed.connect(set_retro_intensity)
    controls.add_child(intensity_slider)
    controls.add_child(_button("F · Comparar fuentes", toggle_fonts))
    var actions := HBoxContainer.new()
    actions.add_child(_button("M · Mover", toggle_motion))
    actions.add_child(_button("A · Animar", animate_arms))
    controls.add_child(actions)
    controls.add_child(_button("0 · Restaurar vista", reset_view))
    controls.add_child(_label("F6 abre este laboratorio.\nF5 abre la greybox H1.\nEsc · Salir", 14, Color("9baeb5")))
    var right := VBoxContainer.new()
    right.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    right.add_theme_constant_override("separation", 8)
    layout.add_child(right)
    view_title = _label("", 24, Color("d9e7dc"))
    right.add_child(view_title)
    view_hint = _label("", 16)
    view_hint.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    right.add_child(view_hint)
    split_label = _label("A · SIN RETRO                                  B · RETRO", 16, Color("e7c78a"))
    split_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    split_label.visible = false
    right.add_child(split_label)
    stage = Control.new()
    stage.name = "Unobstructed3DView"
    stage.size_flags_vertical = Control.SIZE_EXPAND_FILL
    stage.clip_contents = true
    right.add_child(stage)
    display = TextureRect.new()
    display.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    display.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
    display.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
    display.texture = viewport.get_texture()
    display.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
    display.mouse_filter = Control.MOUSE_FILTER_IGNORE
    effect = ShaderMaterial.new()
    effect.shader = RETRO
    display.material = effect
    stage.add_child(display)
    status = _label("", 15, Color("d7bf88"))
    status.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    right.add_child(status)
    right.add_child(_label("VIDA 100 / ENERGÍA 150 · Indicadores simulados · Muestras experimentales", 14))
    comparison_panel = PanelContainer.new()
    comparison_panel.visible = false
    comparison_panel.add_theme_stylebox_override("panel", _panel_style())
    right.add_child(comparison_panel)
    var columns := HBoxContainer.new()
    columns.add_theme_constant_override("separation", 16)
    comparison_panel.add_child(columns)
    for retro_font in [false, true]:
        var column := VBoxContainer.new()
        column.size_flags_horizontal = Control.SIZE_EXPAND_FILL
        columns.add_child(column)
        column.add_child(_label("HOME VIDEO · 14/20/28 px" if retro_font else "GODOT UI · 14/20/28 px", 14))
        for font_size in [14, 20, 28]:
            var label := _label("Instalación · Ñá · 150", font_size, Color("c5e2c2"))
            label.clip_text = true
            if retro_font:
                label.add_theme_font_override("font", HOME_VIDEO)
            column.add_child(label)

func _panel_style() -> StyleBoxFlat:
    var style := StyleBoxFlat.new()
    style.bg_color = Color("152329")
    style.content_margin_left = 14
    style.content_margin_right = 14
    style.content_margin_top = 14
    style.content_margin_bottom = 14
    return style

func _button(text: String, action: Callable) -> Button:
    var button := Button.new()
    button.text = text
    button.custom_minimum_size.y = 32
    button.add_theme_font_size_override("font_size", 16)
    button.focus_mode = Control.FOCUS_NONE
    button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    button.pressed.connect(action)
    return button

func _label(text: String, font_size: int, color := Color("b6c8cc")) -> Label:
    var label := Label.new()
    label.text = text
    label.add_theme_font_size_override("font_size", font_size)
    label.add_theme_color_override("font_color", color)
    label.mouse_filter = Control.MOUSE_FILTER_IGNORE
    return label

func toggle(key: String) -> void:
    options[key] = not options[key]
    if key == "atmospheric":
        alarm_preview = false
    if key == "retro":
        split_preview = false
    apply_options()

func toggle_split() -> void:
    split_preview = not split_preview
    if split_preview:
        options.retro = true
    apply_options()

func set_retro_intensity(value: float) -> void:
    retro_intensity = clampf(value, 0.0, 1.0)
    apply_options()

func toggle_fonts() -> void:
    comparison_panel.visible = not comparison_panel.visible

func apply_options() -> void:
    world.set_filter(options.nearest)
    world.set_lighting(options.atmospheric)
    if alarm_preview:
        world.set_alarm_lighting()
    world.set_shadows(options.shadows)
    world.set_fog(options.fog)
    effect.set_shader_parameter("enabled", options.retro)
    effect.set_shader_parameter("intensity", retro_intensity)
    effect.set_shader_parameter("split_preview", split_preview)
    viewport.size = Vector2i(640, 360) if options.half_resolution else Vector2i(1280, 720)
    option_buttons.nearest.text = "T · " + ("Nearest + mips" if options.nearest else "Linear + mips")
    option_buttons.atmospheric.text = "L · Luz " + ("alarma / muestra" if alarm_preview else ("atmosférica" if options.atmospheric else "neutra"))
    option_buttons.half_resolution.text = "R · 3D " + str(viewport.size)
    option_buttons.retro.text = "X · Retro " + ("ACTIVADO" if options.retro else "DESACTIVADO")
    option_buttons.shadows.text = "S · Sombras " + ("sí" if options.shadows else "no")
    option_buttons.fog.text = "G · Niebla " + ("sí" if options.fog else "no")
    split_label.visible = split_preview
    intensity_label.text = "Intensidad retro · %d%%" % roundi(retro_intensity * 100)
    status.text = world.viewmodel_name + " · " + ("A/B: izquierda sin efecto / derecha con efecto" if split_preview else "Retro %s · 3D %s" % [str(options.retro), str(viewport.size)])

func set_camera(index: int) -> void:
    camera_index = clampi(index, 0, 3)
    motion_preview = false
    elapsed = 0.0
    world.set_camera(camera_index)
    view_title.text = CAMERA_NAMES[camera_index]
    view_hint.text = CAMERA_HINTS[camera_index]

func toggle_motion() -> void:
    motion_preview = not motion_preview
    if not motion_preview:
        world.set_camera(camera_index)

func animate_arms() -> void:
    var clips := ["guard_idle", "jab_L", "relax"]
    animation_index = (animation_index + 1) % clips.size()
    world.arms_animation.play(clips[animation_index])

func reset_view() -> void:
    options = DEFAULT_OPTIONS.duplicate()
    alarm_preview = false
    split_preview = false
    retro_intensity = 0.7
    intensity_slider.set_value_no_signal(retro_intensity)
    comparison_panel.visible = false
    set_camera(0)
    animation_index = 0
    world.arms_animation.play("guard_idle")
    world.arms_animation.seek(0.1, true)
    world.arms_animation.pause()
    apply_options()

func _unhandled_key_input(event: InputEvent) -> void:
    if not event is InputEventKey or not event.pressed or event.echo:
        return
    var keys := {KEY_T: "nearest", KEY_L: "atmospheric", KEY_R: "half_resolution", KEY_X: "retro", KEY_S: "shadows", KEY_G: "fog"}
    if keys.has(event.keycode):
        if event.keycode == KEY_L:
            cycle_lighting()
        else:
            toggle(keys[event.keycode])
    elif event.keycode in [KEY_1, KEY_2, KEY_3, KEY_4]:
        set_camera(event.keycode - KEY_1)
    elif event.keycode == KEY_B:
        toggle_split()
    elif event.keycode == KEY_F:
        toggle_fonts()
    elif event.keycode == KEY_M:
        toggle_motion()
    elif event.keycode == KEY_A:
        animate_arms()
    elif event.keycode == KEY_0:
        reset_view()
    elif event.keycode == KEY_ESCAPE:
        get_tree().quit()

func _process(delta: float) -> void:
    if motion_preview:
        elapsed += delta
        world.set_camera(camera_index)
        world.camera.position.x += sin(elapsed * 0.8) * 0.35

func capture_config() -> Dictionary:
    return {"options": options.duplicate(), "camera": str(world.camera.transform), "viewport": str(viewport.size), "output": str(get_viewport_rect().size), "materials": world.materials.size(), "mesh_instances": world.find_children("*", "MeshInstance3D", true, false).size(), "retro_intensity": retro_intensity, "split_preview": split_preview, "viewmodel": world.viewmodel_name, "lighting_condition": "alarm" if alarm_preview else ("atmospheric" if options.atmospheric else "neutral")}

func cycle_lighting() -> void:
    # Atmosférica → neutra → alarma estática → atmosférica.
    if alarm_preview:
        alarm_preview = false
        options.atmospheric = true
    elif options.atmospheric:
        options.atmospheric = false
    else:
        alarm_preview = true
    apply_options()
