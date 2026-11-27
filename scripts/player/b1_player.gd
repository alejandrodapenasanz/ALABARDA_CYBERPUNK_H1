class_name B1Player
extends CharacterBody3D
## H05 · First-person player core: separated camera, input actions and movement (sprint, jump,
## collisions, double-tap dash) plus a dedicated interaction action on F (D-027).
## E is reserved for manual healing (H08) and never triggers interaction, even near objects.
## H1 (scripts/player.gd) is intentionally untouched and keeps its Q dash.
## H06 · Health (0-100, auto regen), body hitbox and a fixture weapon driven by animation states.
## Death is single and final for this player instance: movement, dash, interaction and fire stop.

signal dashed(direction_action: StringName)
signal interacted(target: Node)
signal interaction_focus_changed(target: Node)
signal move_state_changed(state: int)
signal died

enum MoveState { GROUNDED, AIRBORNE, DASHING, DISABLED }

const DEFAULT_CONFIG := preload("res://resources/player/movement_default.tres")
const INTERACTABLE_GROUP := &"interactable"
const WallGuard = preload("res://scripts/player/weapon_wall_guard.gd")

@export var config: PlayerMovementConfig
@export var capture_mouse_on_ready := true

var move_state: int = MoveState.GROUNDED
var dash := DashController.new()
var double_tap := DoubleTapDetector.new()
var input_enabled := true
var focused_interactable: Node = null
var pitch := 0.0
var wall_guard: WallGuard
## Injectable clock (seconds) so tests can control the double-tap window deterministically.
var clock: Callable

@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera3D
@onready var interact_ray: RayCast3D = $Head/Camera3D/InteractRay
@onready var health: HealthComponent = $HealthComponent
@onready var hitbox: Hitbox = $Hitbox
@onready var weapon: FixtureWeapon = $Head/Camera3D/FixtureWeapon


func _init() -> void:
    clock = func() -> float: return Time.get_ticks_msec() / 1000.0


func _ready() -> void:
    InputActions.ensure_registered()
    add_to_group(&"player")
    if config == null or not config.validation_errors().is_empty():
        if config != null:
            push_warning("B1Player: invalid movement config, using default: %s" % ", ".join(config.validation_errors()))
        config = DEFAULT_CONFIG
    apply_config()
    health.died.connect(_on_died)
    weapon.aim_node = camera
    weapon.shooter = self
    var excluded: Array[RID] = [get_rid(), hitbox.get_rid()]
    weapon.exclude = excluded
    weapon.attack_machine.state_changed.connect(_on_attack_state_changed)
    wall_guard = WallGuard.new(self, weapon, camera)
    if capture_mouse_on_ready:
        Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func apply_config() -> void:
    dash.configure(config.dash_duration_s, config.dash_cooldown_s, config.dash_speed_mps)
    double_tap.window_s = config.double_tap_window_s
    interact_ray.target_position = Vector3(0, 0, -config.interact_distance_m)
    interact_ray.add_exception(self)


func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
        look(event.relative)
        return
    if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
        Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
        return
    if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT \
            and Input.mouse_mode == Input.MOUSE_MODE_VISIBLE and capture_mouse_on_ready:
        Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
        get_viewport().set_input_as_handled()
        return
    var move_action := InputActions.movement_action_of(event)
    if move_action != &"" and event.is_pressed():
        handle_direction_press(move_action, event.is_echo(), clock.call())
        return
    if event.is_action_pressed(InputActions.INTERACT, false):
        try_interact()


func look(relative: Vector2) -> void:
    var target_pitch := clampf(pitch - relative.y * config.mouse_sensitivity, -1.45, 1.45)
    wall_guard.turn(-relative.x * config.mouse_sensitivity, target_pitch - pitch)
    pitch = camera.rotation.x


## Feeds a direction key press to the double-tap detector. Returns true if a dash started.
func handle_direction_press(action: StringName, echo: bool, time_s: float) -> bool:
    var completed := double_tap.feed(action, true, echo, time_s)
    if completed == &"":
        return false
    return request_dash(completed)


func request_dash(action: StringName) -> bool:
    var local := InputActions.local_direction(action)
    var world := global_transform.basis * Vector3(local.x, 0.0, local.y)
    if dash.try_start(world, can_dash()):
        dashed.emit(action)
        _set_state(MoveState.DASHING)
        return true
    return false


func can_dash() -> bool:
    if not input_enabled or move_state == MoveState.DISABLED:
        return false
    return is_on_floor() or config.allow_air_dash


func _physics_process(delta: float) -> void:
    wall_guard.sync_shape()
    dash.tick(delta)
    if not is_on_floor():
        velocity.y -= config.gravity * delta
    if move_state == MoveState.DISABLED:
        velocity.x = move_toward(velocity.x, 0.0, config.acceleration * delta)
        velocity.z = move_toward(velocity.z, 0.0, config.acceleration * delta)
        move_and_slide()
        return
    if input_enabled and is_on_floor() and Input.is_action_pressed(InputActions.JUMP):
        velocity.y = config.jump_velocity
    var input_dir := Vector2.ZERO
    if input_enabled:
        input_dir = Input.get_vector(InputActions.MOVE_LEFT, InputActions.MOVE_RIGHT,
                InputActions.MOVE_FORWARD, InputActions.MOVE_BACK)
    var direction := (global_transform.basis * Vector3(input_dir.x, 0.0, input_dir.y))
    direction.y = 0.0
    direction = direction.normalized()
    var speed := config.sprint_speed_mps if input_enabled and Input.is_action_pressed(InputActions.SPRINT) \
            else config.walk_speed_mps
    if dash.is_dashing():
        var dash_velocity := dash.velocity_for()
        velocity.x = dash_velocity.x
        velocity.z = dash_velocity.z
    else:
        velocity.x = move_toward(velocity.x, direction.x * speed, config.acceleration * delta)
        velocity.z = move_toward(velocity.z, direction.z * speed, config.acceleration * delta)
    move_and_slide()
    if dash.is_dashing() and Vector2(velocity.x, velocity.z).length() < config.dash_speed_mps * 0.5:
        dash.cancel()  # blocked by a wall: end the dash instead of pushing into geometry (CT-04)
    _refresh_state()
    _refresh_focus()
    if input_enabled and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED and Input.is_action_pressed(InputActions.FIRE):
        fire()


func _refresh_state() -> void:
    if move_state == MoveState.DISABLED:
        return
    if dash.is_dashing():
        _set_state(MoveState.DASHING)
    elif is_on_floor():
        _set_state(MoveState.GROUNDED)
    else:
        _set_state(MoveState.AIRBORNE)


func _set_state(state: int) -> void:
    if state == move_state:
        return
    move_state = state
    move_state_changed.emit(state)


## Starts an attack with the fixture weapon if alive and READY. Cadence comes from its animations.
func fire() -> bool:
    if not input_enabled or move_state == MoveState.DISABLED or health.is_dead():
        return false
    return weapon.trigger()


## Compatibility helper (hazards/tests): applies generic damage through the health component.
func take_damage(amount: float, type: StringName = DamageInfo.ENVIRONMENT, source: Node = null) -> float:
    return health.apply_damage(DamageInfo.create(amount, type, source))


func is_dead() -> bool:
    return health.is_dead()


func _on_died() -> void:
    set_disabled(true)
    weapon.interrupt()
    died.emit()


func _on_attack_state_changed(state: int) -> void:
    if state == AttackStateMachine.State.READY and not health.is_dead():
        weapon.reload_if_empty()


## Disables movement, dash and interaction (used on death by H06). Re-enabling restores GROUNDED.
func set_disabled(disabled: bool) -> void:
    if disabled:
        dash.cancel()
        double_tap.reset()
        _set_state(MoveState.DISABLED)
    elif move_state == MoveState.DISABLED and not health.is_dead():
        _set_state(MoveState.GROUNDED)


func find_interactable(collider: Object) -> Node:
    var node := collider as Node
    while node != null:
        if node.is_in_group(INTERACTABLE_GROUP) and node.has_method(&"interact"):
            return node
        node = node.get_parent()
    return null


func _refresh_focus() -> void:
    var target: Node = find_interactable(interact_ray.get_collider()) if interact_ray.is_colliding() else null
    if target != focused_interactable:
        focused_interactable = target
        interaction_focus_changed.emit(target)


## Interacts with the interactable in front of the camera. Walls block it (first hit wins).
func try_interact() -> bool:
    if not input_enabled or move_state == MoveState.DISABLED:
        return false
    interact_ray.force_raycast_update()
    var target: Node = find_interactable(interact_ray.get_collider()) if interact_ray.is_colliding() else null
    if target == null:
        return false
    target.interact(self)
    interacted.emit(target)
    return true
