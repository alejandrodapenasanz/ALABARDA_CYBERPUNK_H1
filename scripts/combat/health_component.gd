class_name HealthComponent
extends Node
## H06 · Reusable health: 0..max, single death, armor pool, per-type vulnerabilities/immunity and
## automatic regeneration after a delay without damage (player: 5 s, 5 HP/s, provisional).
## It knows nothing about energy (docs/HEALTH_ENERGY_CONTRACT.md): regeneration never costs or grants it.
##
## Contract for H08 manual healing (not implemented here): a coordinator calls
## set_regen_paused(&"manual_heal", true) while manual healing is ACTIVE and heal(amount), which
## returns the HP actually added so it can charge only the effective cost. Pausing does not reset
## the wait: the time since the last damage keeps counting, so regen resumes at once on release if
## the delay already elapsed.

signal health_changed(current: float, maximum: float)
signal damaged(info: DamageInfo, applied: float)
signal armor_changed(current: float)
signal armor_broken
signal died

@export var config: HealthConfig
@export var max_health := 100.0
@export var armor := 0.0
@export_range(0.0, 1.0) var armor_absorption := 1.0
## damage_type -> multiplier. 0 means immune to that type. Missing types use 1.0.
@export var vulnerabilities: Dictionary = {}
@export var invulnerable := false
@export var auto_regen_enabled := false
@export var auto_regen_delay_s := 5.0
@export var auto_regen_hp_per_s := 5.0
## When false the owner (or a test) drives time with advance(delta).
@export var auto_process := true

var health := 100.0
var time_since_damage := 0.0
var _dead := false
var _regen_pause_sources: Dictionary = {}


func _ready() -> void:
    if config != null:
        if config.validation_errors().is_empty():
            max_health = config.max_health
            auto_regen_enabled = config.auto_regen_enabled
            auto_regen_delay_s = config.auto_regen_delay_s
            auto_regen_hp_per_s = config.auto_regen_hp_per_s
        else:
            push_warning("HealthComponent: invalid config ignored: %s" % ", ".join(config.validation_errors()))
    reset_full()


func _physics_process(delta: float) -> void:
    if auto_process:
        advance(delta)


## Full health, alive, regeneration eligible. Used on spawn; never called by regeneration itself.
func reset_full() -> void:
    _dead = false
    health = max_health
    time_since_damage = auto_regen_delay_s
    _regen_pause_sources.clear()
    health_changed.emit(health, max_health)


func is_dead() -> bool:
    return _dead


func type_multiplier(damage_type: StringName) -> float:
    var value: Variant = vulnerabilities.get(damage_type, 1.0)
    return float(value) if (value is float or value is int) and is_finite(float(value)) and float(value) >= 0.0 else 1.0


## Applies one hit. Returns the HP actually removed (armor-absorbed damage is not HP).
func apply_damage(info: DamageInfo) -> float:
    if _dead or invulnerable or info == null or not info.is_valid():
        return 0.0
    var amount := info.scaled_amount() * type_multiplier(info.damage_type)
    if not is_finite(amount) or amount <= 0.0:
        return 0.0  # immune type: not a valid hit, the regen wait is not reset
    time_since_damage = 0.0
    if armor > 0.0 and armor_absorption > 0.0:
        var absorbed := minf(armor, amount * armor_absorption)
        armor -= absorbed
        amount -= absorbed
        armor_changed.emit(armor)
        if armor <= 0.0:
            armor = 0.0
            armor_broken.emit()
    var applied := minf(health, amount)
    health -= applied
    damaged.emit(info, applied)
    health_changed.emit(health, max_health)
    if health <= 0.0:
        health = 0.0
        _dead = true
        died.emit()
    return applied


## Adds HP while alive, capped at max. Returns HP actually added (0 when dead, full or invalid).
func heal(amount: float) -> float:
    if _dead or not is_finite(amount) or amount <= 0.0:
        return 0.0
    var added := minf(max_health - health, amount)
    if added <= 0.0:
        return 0.0
    health += added
    health_changed.emit(health, max_health)
    return added


func set_regen_paused(source: StringName, paused: bool) -> void:
    if paused:
        _regen_pause_sources[source] = true
    else:
        _regen_pause_sources.erase(source)


func is_regen_paused() -> bool:
    return not _regen_pause_sources.is_empty()


func is_regenerating() -> bool:
    return auto_regen_enabled and not _dead and not is_regen_paused() and health < max_health \
            and time_since_damage >= auto_regen_delay_s


## Advances the regeneration clock. Split steps give the same result as one large step.
func advance(delta: float) -> void:
    if not is_finite(delta) or delta <= 0.0:
        return
    var before := time_since_damage
    time_since_damage += delta
    if not auto_regen_enabled or _dead or is_regen_paused() or health >= max_health:
        return
    var regen_time := time_since_damage - maxf(before, auto_regen_delay_s)
    if regen_time > 0.0:
        heal(regen_time * auto_regen_hp_per_s)
