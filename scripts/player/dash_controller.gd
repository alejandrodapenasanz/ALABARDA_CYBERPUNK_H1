class_name DashController
extends RefCounted
## H05 · Dash timing: duration, cooldown and direction. No physics here: the player applies
## `velocity_for()` through move_and_slide, so walls stop the dash (no teleport, CT-04).

var duration_s := 0.16
var cooldown_s := 1.0
var speed_mps := 22.0

var time_left := 0.0
var cooldown_left := 0.0
var direction := Vector3.ZERO


func configure(new_duration: float, new_cooldown: float, new_speed: float) -> void:
    duration_s = new_duration
    cooldown_s = new_cooldown
    speed_mps = new_speed


## Starts a dash along a horizontal world direction. Returns false (and changes nothing)
## when on cooldown, already dashing, blocked by state, or the direction is invalid.
func try_start(world_direction: Vector3, allowed: bool = true) -> bool:
    if not allowed or is_dashing() or cooldown_left > 0.0:
        return false
    var flat := Vector3(world_direction.x, 0.0, world_direction.z)
    if flat.length_squared() < 0.0001 or not flat.is_finite():
        return false
    direction = flat.normalized()
    time_left = duration_s
    cooldown_left = cooldown_s
    return true


func tick(delta: float) -> void:
    if not is_finite(delta) or delta <= 0.0:
        return
    time_left = maxf(0.0, time_left - delta)
    cooldown_left = maxf(0.0, cooldown_left - delta)


func cancel() -> void:
    time_left = 0.0


func is_dashing() -> bool:
    return time_left > 0.0


func velocity_for() -> Vector3:
    return direction * speed_mps if is_dashing() else Vector3.ZERO
