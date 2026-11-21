class_name BalanceProfile
extends Resource
## H03: datos para futuros sistemas. H1 no consume este Resource.

const APPROVED_RULES := {
    "player_max_hp": 100.0,
    "energy_max": 150.0,
    "ultimate_activation_min": 100.0,
    "dead_eye_world_scale": 0.5,
}
const DEFAULT_VALUES := {
    "walk_speed_mps": 8.5, "sprint_speed_mps": 12.5, "dash_speed_mps": 22.0,
    "dash_duration_seconds": 0.16, "dash_cooldown_seconds": 1.0,
    "extraction_energy_per_second": 20.0, "extraction_max_energy_per_target": 60.0,
    "extraction_damage_multiplier": 0.5, "heal_hp_per_second": 25.0,
    "heal_energy_per_second": 25.0, "ultimate_duration_at_100_seconds": 6.0,
    "ultimate_duration_at_150_seconds": 10.0,
    "katana_damage": 35.0, "pistol_suppressed_damage": 30.0, "pistol_magazine": 12.0,
    "rifle_suppressed_damage": 90.0, "rifle_magazine": 5.0, "chainsword_damage": 60.0,
    "revolver_damage": 75.0, "revolver_magazine": 6.0,
    "shotgun_pellet_damage": 12.0, "shotgun_pellets_per_barrel": 8.0,
    "shotgun_magazine_shells": 2.0, "enemy_squishy_hp": 60.0, "enemy_ranged_hp": 80.0,
    "enemy_tank_hp": 150.0, "enemy_tank_armor": 100.0,
}
const INTEGER_VALUES := ["pistol_magazine", "rifle_magazine", "revolver_magazine", "shotgun_pellets_per_barrel", "shotgun_magazine_shells"]

@export var schema_version: int = 1
@export var rules: Dictionary = APPROVED_RULES.duplicate()
@export var values: Dictionary = DEFAULT_VALUES.duplicate()

func validation_errors() -> PackedStringArray:
    var errors := PackedStringArray()
    if schema_version != 1:
        errors.append("schema_version: unsupported")
    for key in APPROVED_RULES:
        if not rules.has(key) or not _number(rules[key]) or rules[key] != APPROVED_RULES[key]:
            errors.append("%s: APPROVED_RULE mismatch" % key)
    for key in rules:
        if not APPROVED_RULES.has(key):
            errors.append("%s: unknown rule" % key)
    for key in DEFAULT_VALUES:
        if not values.has(key) or not _number(values[key]) or values[key] < 0.0:
            errors.append("%s: expected finite nonnegative value" % key)
        elif key in INTEGER_VALUES and (values[key] < 1.0 or floorf(values[key]) != values[key]):
            errors.append("%s: expected positive integer" % key)
    for key in values:
        if not DEFAULT_VALUES.has(key):
            errors.append("%s: unknown provisional value" % key)
    if not errors.is_empty():
        return errors
    if values.extraction_damage_multiplier > 1.0:
        errors.append("extraction_damage_multiplier: expected [0,1]")
    if values.sprint_speed_mps < values.walk_speed_mps:
        errors.append("sprint_speed_mps: below walk speed")
    if values.dash_duration_seconds > values.dash_cooldown_seconds:
        errors.append("dash_duration_seconds: above cooldown")
    if values.ultimate_duration_at_150_seconds < values.ultimate_duration_at_100_seconds:
        errors.append("ultimate duration must not decrease with energy")
    return errors

static func _number(value: Variant) -> bool:
    return (value is float or value is int) and is_finite(float(value))

static func clamp_health(value: float) -> float:
    return clampf(value, 0.0, APPROVED_RULES.player_max_hp) if is_finite(value) else 0.0

static func clamp_energy(value: float) -> float:
    return clampf(value, 0.0, APPROVED_RULES.energy_max) if is_finite(value) else 0.0

static func read_validated(path: String) -> BalanceProfile:
    if not ResourceLoader.exists(path):
        return null
    var resource := load(path) as BalanceProfile
    if resource == null or not resource.validation_errors().is_empty():
        return null
    return resource
