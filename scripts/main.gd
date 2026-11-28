extends Node3D
## Current game entry point. The training arena hosts the shared player/combat systems;
## later milestones extend these same systems and scene instead of adding a parallel game.

const PLAYER_SCENE := preload("res://scenes/player/player.tscn")
const SWITCH_SCRIPT := preload("res://scripts/interaction/interactable_switch.gd")
const Hazards := preload("res://scripts/world/environment_hazards.gd")
const RESTART_AFTER_DEATH_S := 3.0

@export var capture_mouse_on_start := true

var player: PlayerController
var console: InteractableSwitch
var hud_state: Label
var hud_prompt: Label
var hud_feedback: Label
var feedback_left := 0.0
var health_bar: ProgressBar
var health_label: Label
var restart_left := -1.0


func _ready() -> void:
    _setup_environment()
    _setup_range()
    player = PLAYER_SCENE.instantiate()
    player.capture_mouse_on_ready = capture_mouse_on_start
    add_child(player)
    player.global_position = Vector3(0, 1.0, 10)
    player.dashed.connect(func(action: StringName): _feedback("DASH  %s" % String(action).trim_prefix("move_").to_upper(), 0.6))
    player.interacted.connect(func(_target: Node): _feedback("INTERACCIÓN (F)", 0.8))
    player.interaction_focus_changed.connect(_on_focus_changed)
    console = SWITCH_SCRIPT.new()
    add_child(console)
    console.global_position = Vector3(-4, 1.4, 4)
    _setup_targets_and_hazards()
    _setup_hud()
    player.health.health_changed.connect(_on_health_changed)
    player.health.damaged.connect(func(info: DamageInfo, applied: float): _feedback("DAÑO -%d (%s)" % [ceili(applied), info.damage_type], 0.6))
    player.weapon.fired.connect(_on_weapon_fired)
    player.died.connect(_on_player_died)
    _on_health_changed(player.health.health, player.health.max_health)


func _process(delta: float) -> void:
    feedback_left -= delta
    if feedback_left <= 0.0:
        hud_feedback.text = ""
    var attack_states := ["LISTA", "ATAQUE", "RECUPERACIÓN", "RECARGA"]
    var machine := player.weapon.attack_machine
    hud_state.text = "DASH %s   |   ARMA %s %d/%d   |   REGENERACIÓN %s" % [
            "LISTO" if player.dash.cooldown_left <= 0.0 else "%.1f s" % player.dash.cooldown_left,
            attack_states[machine.state], machine.ammo, machine.magazine_size,
            "SÍ" if player.health.is_regenerating() else "no"]
    if restart_left > 0.0:
        restart_left -= delta
        if restart_left <= 0.0:
            get_tree().reload_current_scene()


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


func _setup_targets_and_hazards() -> void:
    for spec in [[Vector3(-6, 0, -12), 60.0, 0.0, "BLANCO 60"], [Vector3(0, 0, -12), 80.0, 0.0, "BLANCO 80"],
            [Vector3(6, 0, -12), 150.0, 100.0, "TANQUE 150 + ARM 100"]]:
        var dummy := TargetDummy.new()
        dummy.max_health = spec[1]
        dummy.armor = spec[2]
        dummy.label = spec[3]
        dummy.respawn_after_s = 3.0
        add_child(dummy)
        dummy.global_position = spec[0]
    var zone := Hazards.DamageZone.new(Vector3(3, 1, 3))
    add_child(zone)
    zone.global_position = Vector3(-12, 0.5, 10)
    var turret := Hazards.ProjectileTurret.new()
    turret.target = player
    add_child(turret)
    turret.global_position = Vector3(15, 0.6, 15)
    var marker := Label3D.new()
    marker.text = "ZONA DE DAÑO 10/s"
    marker.billboard = BaseMaterial3D.BILLBOARD_ENABLED
    marker.position = Vector3(-12, 1.6, 10)
    add_child(marker)


func _setup_hud() -> void:
    var layer := CanvasLayer.new()
    add_child(layer)
    var root := Control.new()
    root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    root.mouse_filter = Control.MOUSE_FILTER_IGNORE
    layer.add_child(root)
    health_bar = ProgressBar.new()
    health_bar.position = Vector2(24, 16)
    health_bar.size = Vector2(320, 26)
    health_bar.show_percentage = false
    health_bar.max_value = 100.0
    var fill := StyleBoxFlat.new()
    fill.bg_color = Color("d63a4a")
    health_bar.add_theme_stylebox_override("fill", fill)
    health_bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
    root.add_child(health_bar)
    health_label = _label(root, Vector2(32, 16), 18, Color("ffffff"))
    hud_state = _label(root, Vector2(24, 50), 18, Color("88dfe7"))
    hud_prompt = _label(root, Vector2(24, 78), 20, Color("efde99"))
    hud_feedback = _label(root, Vector2(24, 106), 20, Color("ddfaff"))
    var help := _label(root, Vector2(24, 142), 16, Color("b6c4d6"))
    help.text = "WASD mover  |  doble toque WW/AA/SS/DD dash  |  SHIFT sprint  |  ESPACIO saltar\n" \
            + "F interactuar  |  RATÓN mirar  |  CLIC disparar (recarga automática)  |  ESC liberar ratón\n" \
            + "ALABARDA // ZONA DE ENTRENAMIENTO"
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


func _on_health_changed(current: float, maximum: float) -> void:
    health_bar.max_value = maximum
    health_bar.value = current
    health_label.text = "SALUD  %d / %d" % [ceili(current), int(maximum)]


func _on_weapon_fired(result: Dictionary) -> void:
    if result.applied > 0.0:
        _feedback("IMPACTO %s  -%d" % ["CABEZA" if result.zone == DamageInfo.ZONE_HEAD else "CUERPO", ceili(result.applied)], 0.5)


func _on_player_died() -> void:
    _feedback("HAS MUERTO  //  reinicio en %d s" % int(RESTART_AFTER_DEATH_S), RESTART_AFTER_DEATH_S + 1.0)
    restart_left = RESTART_AFTER_DEATH_S


func _feedback(message: String, duration: float) -> void:
    feedback_left = duration
    hud_feedback.text = message
