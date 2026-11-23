class_name PlayerMovementConfig
extends Resource
## H05 · Editable movement data. ALL values are PROVISIONAL_VALUE / PENDING_PLAYTEST.
## Speeds, dash duration and cooldown come from the H1 proposal (BALANCE_PROVISIONAL), not approved.
## `double_tap_window_s` has no approved figure (D-025): 0.25 s is a proposal to tune in playtests.

@export var walk_speed_mps := 8.5
@export var sprint_speed_mps := 12.5
@export var acceleration := 55.0
@export var jump_velocity := 6.0
@export var gravity := 22.0
@export var mouse_sensitivity := 0.0024
@export var dash_speed_mps := 22.0
@export var dash_duration_s := 0.16
@export var dash_cooldown_s := 1.0
@export var double_tap_window_s := 0.25
@export var allow_air_dash := true
@export var interact_distance_m := 2.5


func validation_errors() -> PackedStringArray:
    var errors := PackedStringArray()
    var positive := {
        "walk_speed_mps": walk_speed_mps, "sprint_speed_mps": sprint_speed_mps,
        "acceleration": acceleration, "jump_velocity": jump_velocity, "gravity": gravity,
        "mouse_sensitivity": mouse_sensitivity, "dash_speed_mps": dash_speed_mps,
        "dash_duration_s": dash_duration_s, "dash_cooldown_s": dash_cooldown_s,
        "double_tap_window_s": double_tap_window_s, "interact_distance_m": interact_distance_m,
    }
    for key in positive:
        var value: float = positive[key]
        if not is_finite(value) or value <= 0.0:
            errors.append("%s: expected finite positive value" % key)
    if not errors.is_empty():
        return errors
    if sprint_speed_mps < walk_speed_mps:
        errors.append("sprint_speed_mps: below walk speed")
    if dash_duration_s > dash_cooldown_s:
        errors.append("dash_duration_s: above cooldown")
    if double_tap_window_s > 1.0:
        errors.append("double_tap_window_s: above 1 s, would trigger accidental dashes")
    return errors
