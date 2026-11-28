class_name DamageInfo
extends RefCounted
## H06 · One damage event. Zone multipliers are applied by Hitbox; type multipliers by HealthComponent.

const HITSCAN := &"hitscan"
const PROJECTILE := &"projectile"
const MELEE := &"melee"
const ENVIRONMENT := &"environment"

const ZONE_BODY := &"body"
const ZONE_HEAD := &"head"

var amount := 0.0
var damage_type: StringName = HITSCAN
var hit_zone: StringName = ZONE_BODY
var multiplier := 1.0
var source: Node = null
var position := Vector3.ZERO


static func create(base_amount: float, type: StringName = HITSCAN, from: Node = null) -> DamageInfo:
    var info := DamageInfo.new()
    info.amount = base_amount
    info.damage_type = type
    info.source = from
    return info


func is_valid() -> bool:
    return is_finite(amount) and amount > 0.0 and is_finite(multiplier) and multiplier >= 0.0


func is_critical() -> bool:
    return hit_zone == ZONE_HEAD


func scaled_amount() -> float:
    return amount * multiplier


## Copy with a zone and an extra multiplier (used by hitboxes; the original is never mutated).
func for_zone(zone: StringName, zone_multiplier: float, at: Vector3 = Vector3.ZERO) -> DamageInfo:
    var copy := DamageInfo.create(amount, damage_type, source)
    copy.hit_zone = zone
    copy.multiplier = multiplier * zone_multiplier
    copy.position = at
    return copy
