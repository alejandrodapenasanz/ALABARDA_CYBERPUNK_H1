class_name InputActions
extends RefCounted
## Shared player input map, registered at runtime. The historical H1 test fixture
## keeps raw keys and Q dash. Current bindings follow docs/CONTROLS.md:
## WASD move, double tap dash (D-025), Shift sprint, Space jump, F interact (D-027),
## E reserved for manual healing (H08, not yet implemented), left click fire.
## Reload, ultimate and pause have NO approved binding: they are deliberately not registered.

const MOVE_FORWARD := &"move_forward"
const MOVE_BACK := &"move_back"
const MOVE_LEFT := &"move_left"
const MOVE_RIGHT := &"move_right"
const SPRINT := &"sprint"
const JUMP := &"jump"
const INTERACT := &"interact"
const HEAL := &"heal"
const FIRE := &"fire"

const MOVE_ACTIONS: Array[StringName] = [MOVE_FORWARD, MOVE_BACK, MOVE_LEFT, MOVE_RIGHT]

const KEY_BINDINGS := {
    MOVE_FORWARD: KEY_W,
    MOVE_BACK: KEY_S,
    MOVE_LEFT: KEY_A,
    MOVE_RIGHT: KEY_D,
    SPRINT: KEY_SHIFT,
    JUMP: KEY_SPACE,
    INTERACT: KEY_F,
    HEAL: KEY_E,
}


## Idempotent: creates missing actions only, never overrides a binding the user remapped.
static func ensure_registered() -> void:
    for action in KEY_BINDINGS:
        if InputMap.has_action(action):
            continue
        InputMap.add_action(action)
        var key_event := InputEventKey.new()
        key_event.keycode = KEY_BINDINGS[action]
        InputMap.action_add_event(action, key_event)
    if not InputMap.has_action(FIRE):
        InputMap.add_action(FIRE)
        var mouse_event := InputEventMouseButton.new()
        mouse_event.button_index = MOUSE_BUTTON_LEFT
        InputMap.action_add_event(FIRE, mouse_event)


## Local planar direction for a movement action: x = right, y = back (Godot -Z is forward).
static func local_direction(action: StringName) -> Vector2:
    match action:
        MOVE_FORWARD:
            return Vector2(0, -1)
        MOVE_BACK:
            return Vector2(0, 1)
        MOVE_LEFT:
            return Vector2(-1, 0)
        MOVE_RIGHT:
            return Vector2(1, 0)
    return Vector2.ZERO


## Returns which movement action this event presses (fresh or echo), or &"".
static func movement_action_of(event: InputEvent) -> StringName:
    for action in MOVE_ACTIONS:
        if event.is_action(action, true):
            return action
    return &""
