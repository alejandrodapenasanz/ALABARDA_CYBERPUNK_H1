class_name HealthConfig
extends Resource
## H06 · Player health data. max_health 100 is an APPROVED_RULE (D-023); regeneration values are
## PROVISIONAL_VALUE / PENDING_PLAYTEST (docs/BALANCE_PROVISIONAL.md).

const APPROVED_PLAYER_MAX_HEALTH := 100.0

@export var max_health := 100.0
@export var auto_regen_enabled := true
@export var auto_regen_delay_s := 5.0
@export var auto_regen_hp_per_s := 5.0


func validation_errors() -> PackedStringArray:
    var errors := PackedStringArray()
    if max_health != APPROVED_PLAYER_MAX_HEALTH:
        errors.append("max_health: APPROVED_RULE is 100")
    if not is_finite(auto_regen_delay_s) or auto_regen_delay_s < 0.0:
        errors.append("auto_regen_delay_s: expected finite nonnegative value")
    if not is_finite(auto_regen_hp_per_s) or auto_regen_hp_per_s < 0.0:
        errors.append("auto_regen_hp_per_s: expected finite nonnegative value")
    return errors
