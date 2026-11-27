extends Node3D
## B1 test support (not a suite): a floor, optional walls and helpers for deterministic integration tests.

const PLAYER_SCENE := preload("res://scenes/player/player.tscn")


func add_block(pos: Vector3, size: Vector3) -> StaticBody3D:
    var body := StaticBody3D.new()
    body.collision_layer = PhysicsLayers.WORLD
    body.position = pos
    var shape := BoxShape3D.new()
    shape.size = size
    var collider := CollisionShape3D.new()
    collider.shape = shape
    body.add_child(collider)
    add_child(body)
    return body


func add_floor() -> StaticBody3D:
    return add_block(Vector3(0, -0.5, 0), Vector3(60, 1, 60))


func spawn_player(pos: Vector3 = Vector3(0, 1.0, 0)) -> PlayerController:
    var player: PlayerController = PLAYER_SCENE.instantiate()
    player.capture_mouse_on_ready = false
    add_child(player)
    player.global_position = pos
    return player


static func key_event(code: Key, pressed: bool, echo: bool = false) -> InputEventKey:
    var event := InputEventKey.new()
    event.keycode = code
    event.pressed = pressed
    event.echo = echo
    return event


static func release_all() -> void:
    for action in InputMap.get_actions():
        if not String(action).begins_with("ui_"):
            Input.action_release(action)
    for code in [KEY_W, KEY_A, KEY_S, KEY_D, KEY_SHIFT, KEY_SPACE, KEY_E, KEY_F]:
        Input.parse_input_event(key_event(code, false))
    Input.flush_buffered_events()
