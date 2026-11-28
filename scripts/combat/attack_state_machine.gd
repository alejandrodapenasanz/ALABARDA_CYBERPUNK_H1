class_name AttackStateMachine
extends Node
## H06 · READY → ATTACK → RECOVERY → READY and READY → RELOAD → READY, driven ONLY by the
## AnimationPlayer: the hit frame is a method-track key calling anim_hit_event(), and state changes on
## animation_finished. There is no independent cadence timer (D-005: cadence follows animation).

signal state_changed(state: int)
signal hit_frame
signal reloaded

enum State { READY, ATTACK, RECOVERY, RELOAD }

const ANIM_ATTACK := &"attack"
const ANIM_RECOVERY := &"recovery"
const ANIM_RELOAD := &"reload"

@export var animation_player_path: NodePath
@export var magazine_size := 12

var animation_player: AnimationPlayer
var state: int = State.READY
var ammo := 0
var _hit_emitted := false


func _ready() -> void:
    if animation_player == null and not animation_player_path.is_empty():
        animation_player = get_node_or_null(animation_player_path) as AnimationPlayer
    if animation_player != null:
        animation_player.animation_finished.connect(_on_animation_finished)
    ammo = magazine_size


func request_attack() -> bool:
    if state != State.READY or ammo <= 0 or animation_player == null:
        return false
    ammo -= 1
    _hit_emitted = false
    _enter(State.ATTACK, ANIM_ATTACK)
    return true


func request_reload() -> bool:
    if state != State.READY or ammo >= magazine_size or animation_player == null:
        return false
    _enter(State.RELOAD, ANIM_RELOAD)
    return true


## Called by the attack animation's method track at the hit frame. Emits once per attack.
func anim_hit_event() -> void:
    if state == State.ATTACK and not _hit_emitted:
        _hit_emitted = true
        hit_frame.emit()


## Stops everything (death, weapon switch in H07). Returns to READY without firing.
func interrupt() -> void:
    if animation_player != null:
        animation_player.stop()
    _set_state(State.READY)


func _on_animation_finished(anim_name: StringName) -> void:
    match state:
        State.ATTACK:
            if anim_name == ANIM_ATTACK:
                _enter(State.RECOVERY, ANIM_RECOVERY)
        State.RECOVERY:
            if anim_name == ANIM_RECOVERY:
                _set_state(State.READY)
        State.RELOAD:
            if anim_name == ANIM_RELOAD:
                ammo = magazine_size
                _set_state(State.READY)
                reloaded.emit()


func _enter(new_state: int, anim_name: StringName) -> void:
    _set_state(new_state)
    animation_player.stop()
    animation_player.play(anim_name)


func _set_state(new_state: int) -> void:
    if new_state == state:
        return
    state = new_state
    state_changed.emit(new_state)
