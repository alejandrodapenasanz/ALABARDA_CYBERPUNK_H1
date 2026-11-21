extends Node3D

const PlayerScript = preload("res://scripts/player.gd")
const EnemyScript = preload("res://scripts/enemy.gd")

var player
var hud_health: Label
var hud_enemies: Label
var hud_feedback: Label
var enemies_left := 0
var feedback_timer := 0.0

func _ready() -> void:
    _setup_environment()
    _setup_arena()
    player = PlayerScript.new()
    player.position = Vector3(0, 1.1, 9)
    add_child(player)
    player.health_changed.connect(_on_health_changed)
    player.shot_fired.connect(_on_shot_fired)
    player.died.connect(_on_player_died)
    _setup_enemies()
    _setup_hud()
    _on_health_changed(player.health, player.max_health)
    _update_enemy_count()

func _process(delta: float) -> void:
    feedback_timer -= delta
    if feedback_timer <= 0.0 and hud_feedback != null:
        hud_feedback.text = ""
    if Input.is_key_pressed(KEY_R) and enemies_left == 0:
        _setup_enemies()
        _update_enemy_count()

func _setup_environment() -> void:
    var world := WorldEnvironment.new()
    var environment := Environment.new()
    environment.background_mode = Environment.BG_COLOR
    environment.background_color = Color("0b1018")
    environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
    environment.ambient_light_color = Color("8899af")
    environment.ambient_light_energy = 0.55
    world.environment = environment
    add_child(world)
    var light := DirectionalLight3D.new()
    light.rotation_degrees = Vector3(-55, -25, 0)
    light.light_energy = 1.35
    add_child(light)

func _make_block(pos: Vector3, size: Vector3, color: Color, solid: bool = true) -> void:
    var root: Node3D
    if solid:
        root = StaticBody3D.new()
    else:
        root = Node3D.new()
    root.position = pos
    add_child(root)
    var model := MeshInstance3D.new()
    var mesh := BoxMesh.new()
    mesh.size = size
    model.mesh = mesh
    var mat := StandardMaterial3D.new()
    mat.albedo_color = color
    mat.metallic = 0.15
    model.material_override = mat
    root.add_child(model)
    if solid:
        var collider := CollisionShape3D.new()
        var shape := BoxShape3D.new()
        shape.size = size
        collider.shape = shape
        root.add_child(collider)

func _setup_arena() -> void:
    _make_block(Vector3(0, -0.5, 0), Vector3(32, 1, 32), Color("293442"))
    _make_block(Vector3(0, 4, -16), Vector3(32, 8, 1), Color("1d2530"))
    _make_block(Vector3(0, 4, 16), Vector3(32, 8, 1), Color("1d2530"))
    _make_block(Vector3(-16, 4, 0), Vector3(1, 8, 32), Color("1d2530"))
    _make_block(Vector3(16, 4, 0), Vector3(1, 8, 32), Color("1d2530"))
    for i in range(7):
        _make_block(Vector3(-12 + i * 4, 0.035, -13), Vector3(2.2, 0.06, 0.2), Color("3c8999"), false)
    _make_block(Vector3(-5, 1, -3), Vector3(2, 2, 3), Color("536477"))
    _make_block(Vector3(6, 1, 3), Vector3(2, 2, 3), Color("536477"))
    _make_block(Vector3(0, 0.6, -7), Vector3(3, 1.2, 1), Color("536477"))
    _make_block(Vector3(-10, 1.6, 3), Vector3(1.5, 3.2, 1.5), Color("3e6976"))
    _make_block(Vector3(10, 1.6, -6), Vector3(1.5, 3.2, 1.5), Color("3e6976"))

func _setup_enemies() -> void:
    for enemy in get_tree().get_nodes_in_group("enemies"):
        enemy.queue_free()
    enemies_left = 0
    feedback_timer = 0.0
    if hud_feedback != null:
        hud_feedback.text = ""
    _spawn_enemy(Vector3(-8, 0, -8), 35.0, false)
    _spawn_enemy(Vector3(8, 0, -9), 35.0, false)
    _spawn_enemy(Vector3(0, 0, -11), 70.0, true)
    _spawn_enemy(Vector3(-11, 0, 0), 70.0, true)
    _spawn_enemy(Vector3(10, 0, 9), 70.0, true)

func _spawn_enemy(pos: Vector3, hp: float, ranged: bool) -> void:
    var enemy = EnemyScript.new()
    enemy.position = pos
    enemy.configure(player, hp, ranged)
    enemy.eliminated.connect(_on_enemy_eliminated)
    add_child(enemy)
    enemies_left += 1

func _setup_hud() -> void:
    var layer := CanvasLayer.new()
    add_child(layer)
    var root := Control.new()
    root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    root.mouse_filter = Control.MOUSE_FILTER_IGNORE
    layer.add_child(root)
    hud_health = _make_label(root, Vector2(24, 16), 24, Color("ff6475"))
    hud_enemies = _make_label(root, Vector2(24, 50), 20, Color("88dfe7"))
    hud_feedback = _make_label(root, Vector2(24, 88), 20, Color("efde99"))
    var instruction := _make_label(root, Vector2(24, 125), 17, Color("b6c4d6"))
    instruction.text = "WASD mover  |  SHIFT sprint  |  Q dash  |  ESPACIO saltar\nRATÓN apuntar  |  CLIC disparar  |  ESC liberar ratón\nObjetivo: elimina los 5 enemigos. R reinicia al vencer."
    var crosshair := Label.new()
    crosshair.text = "+"
    crosshair.add_theme_font_size_override("font_size", 27)
    crosshair.add_theme_color_override("font_color", Color("ddfaff"))
    crosshair.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
    crosshair.position = Vector2(-7, -17)
    crosshair.mouse_filter = Control.MOUSE_FILTER_IGNORE
    root.add_child(crosshair)
    var footer := Label.new()
    footer.text = "ALABARDA STUDIOS  //  CONTRACT SIMULATOR H1  //  GREYBOX"
    footer.add_theme_font_size_override("font_size", 15)
    footer.add_theme_color_override("font_color", Color("607888"))
    footer.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_LEFT)
    footer.position = Vector2(24, -34)
    root.add_child(footer)

func _make_label(parent: Node, pos: Vector2, font_size: int, color: Color) -> Label:
    var label := Label.new()
    label.position = pos
    label.add_theme_font_size_override("font_size", font_size)
    label.add_theme_color_override("font_color", color)
    label.mouse_filter = Control.MOUSE_FILTER_IGNORE
    parent.add_child(label)
    return label

func _on_health_changed(current: float, maximum: float) -> void:
    if hud_health != null:
        hud_health.text = "VIDA  %03d / %03d" % [int(current), int(maximum)]

func _on_shot_fired(hit: bool) -> void:
    if hit and enemies_left > 0:
        _feedback("IMPACTO CONFIRMADO", 0.2)

func _on_enemy_eliminated(_enemy: Node3D) -> void:
    enemies_left -= 1
    _update_enemy_count()
    if enemies_left <= 0:
        _feedback("CONTRATO COMPLETADO  //  PULSA R PARA REINICIAR", 300.0)
    else:
        _feedback("OBJETIVO ELIMINADO", 0.7)

func _update_enemy_count() -> void:
    if hud_enemies != null:
        hud_enemies.text = "HOSTILES  %02d" % enemies_left

func _on_player_died() -> void:
    _feedback("SISTEMA REINICIADO  //  SALUD RESTABLECIDA", 1.5)

func _feedback(message: String, duration: float) -> void:
    feedback_timer = duration
    if hud_feedback != null:
        hud_feedback.text = message
