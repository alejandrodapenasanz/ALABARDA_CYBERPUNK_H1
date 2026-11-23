extends Node3D
## B1 sandbox (open scenes/b1/b1_sandbox.tscn and press F6). Greybox test range for H05/H06 manual
## checks. Not a level and not the main scene: F5 still runs H1 unchanged.

const PLAYER_SCENE := preload("res://scenes/player/b1_player.tscn")
const SWITCH_SCRIPT := preload("res://scripts/interaction/interactable_switch.gd")

var player: B1Player
var console: InteractableSwitch
var hud_state: Label
var hud_prompt: Label
var hud_feedback: Label
var feedback_left := 0.0


func _ready() -> void:
    _setup_environment()
    _setup_range()
    player = PLAYER_SCENE.instantiate()
    add_child(player)
    player.global_position = Vector3(0, 1.0, 10)
    player.dashed.connect(func(action: StringName): _feedback("DASH  %s" % String(action).trim_prefix("move_").to_upper(), 0.6))
    player.interacted.connect(func(_target: Node): _feedback("INTERACCIÓN (F)", 0.8))
    player.interaction_focus_changed.connect(_on_focus_changed)
    console = SWITCH_SCRIPT.new()
    add_child(console)
    console.global_position = Vector3(-4, 1.4, 4)
    _setup_hud()


func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed(InputActions.HEAL, false) and player.focused_interactable != null:
        _feedback("E reservada a curación (H08): no interactúa", 1.2)


func _process(delta: float) -> void:
    feedback_left -= delta
    if feedback_left <= 0.0:
        hud_feedback.text = ""
    var states := ["SUELO", "AIRE", "DASH", "BLOQUEADO"]
    hud_state.text = "ESTADO %s   |   DASH %s" % [states[player.move_state],
            "LISTO" if player.dash.cooldown_left <= 0.0 else "%.1f s" % player.dash.cooldown_left]


func _setup_environment() -> void:
    var world := WorldEnvironment.new()
    var environment := Environment.new()
    environment.background_mode = Environment.BG_COLOR
    environment.background_color = Color("0b1018")
    environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
    environment.ambient_light_color = Color("8899af")
    environment.ambient_light_energy = 0.6
    world.environment = environment
    add_child(world)
    var light := DirectionalLight3D.new()
    light.rotation_degrees = Vector3(-55, -25, 0)
    light.light_energy = 1.3
    add_child(light)


func make_block(pos: Vector3, size: Vector3, color: Color) -> StaticBody3D:
    var body := StaticBody3D.new()
    body.collision_layer = PhysicsLayers.WORLD
    body.position = pos
    var mesh_instance := MeshInstance3D.new()
    var mesh := BoxMesh.new()
    mesh.size = size
    mesh_instance.mesh = mesh
    var mat := StandardMaterial3D.new()
    mat.albedo_color = color
    mesh_instance.material_override = mat
    body.add_child(mesh_instance)
    var shape := BoxShape3D.new()
    shape.size = size
    var collider := CollisionShape3D.new()
    collider.shape = shape
    body.add_child(collider)
    add_child(body)
    return body


func _setup_range() -> void:
    make_block(Vector3(0, -0.5, 0), Vector3(40, 1, 40), Color("293442"))
    for wall in [[Vector3(0, 3, -20), Vector3(40, 6, 1)], [Vector3(0, 3, 20), Vector3(40, 6, 1)],
            [Vector3(-20, 3, 0), Vector3(1, 6, 40)], [Vector3(20, 3, 0), Vector3(1, 6, 40)]]:
        make_block(wall[0], wall[1], Color("1d2530"))
    # dash lane with a wall at the end (CT-04) and a low step for jumps
    make_block(Vector3(10, 1.5, -2), Vector3(6, 3, 0.6), Color("536477"))
    make_block(Vector3(-10, 0.4, -6), Vector3(3, 0.8, 3), Color("3e6976"))
    make_block(Vector3(-4, 0.4, 4), Vector3(1.4, 0.8, 1.0), Color("2b3644"))  # console pedestal
    for i in range(9):
        make_block(Vector3(10, 0.01, 8 - i * 1.0), Vector3(1.2, 0.02, 0.08), Color("3c8999"))  # 1 m marks


func _setup_hud() -> void:
    var layer := CanvasLayer.new()
    add_child(layer)
    var root := Control.new()
    root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    root.mouse_filter = Control.MOUSE_FILTER_IGNORE
    layer.add_child(root)
    hud_state = _label(root, Vector2(24, 16), 20, Color("88dfe7"))
    hud_prompt = _label(root, Vector2(24, 46), 20, Color("efde99"))
    hud_feedback = _label(root, Vector2(24, 76), 20, Color("ddfaff"))
    var help := _label(root, Vector2(24, 112), 16, Color("b6c4d6"))
    help.text = "WASD mover  |  doble toque WW/AA/SS/DD dash  |  SHIFT sprint  |  ESPACIO saltar\n" \
            + "F interactuar  |  E reservada a curación (H08)  |  RATÓN mirar  |  ESC liberar ratón\n" \
            + "B1 SANDBOX // greybox de pruebas, no es un nivel"
    var crosshair := _label(root, Vector2.ZERO, 27, Color("ddfaff"))
    crosshair.text = "+"
    crosshair.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
    crosshair.position = Vector2(-7, -17)


func _label(parent: Control, pos: Vector2, font_size: int, color: Color) -> Label:
    var label := Label.new()
    label.position = pos
    label.add_theme_font_size_override("font_size", font_size)
    label.add_theme_color_override("font_color", color)
    label.mouse_filter = Control.MOUSE_FILTER_IGNORE
    parent.add_child(label)
    return label


func _on_focus_changed(target: Node) -> void:
    hud_prompt.text = target.prompt if target is InteractableSwitch else ""


func _feedback(message: String, duration: float) -> void:
    feedback_left = duration
    hud_feedback.text = message
