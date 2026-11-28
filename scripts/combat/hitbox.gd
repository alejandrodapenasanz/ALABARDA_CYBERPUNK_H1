class_name Hitbox
extends Area3D
## H06 · Damage zone (body, head...) forwarding hits to a HealthComponent with a zone multiplier.
## Lives on physics layer 4 (PhysicsLayers.HITBOX) and is only hit by hitscan/projectile queries.
## Head multiplier 2.0 is PROVISIONAL_VALUE / PENDING_PLAYTEST; per-weapon values belong to H07.

const HEAD_MULTIPLIER_PROVISIONAL := 2.0

@export var zone: StringName = DamageInfo.ZONE_BODY
@export var multiplier := 1.0
@export var health_path: NodePath

var health: HealthComponent


func _ready() -> void:
    collision_layer = PhysicsLayers.HITBOX
    collision_mask = 0
    monitoring = false
    monitorable = true
    if health == null and not health_path.is_empty():
        health = get_node_or_null(health_path) as HealthComponent


## Returns HP removed. Disabled or orphan hitboxes absorb nothing.
func receive_hit(info: DamageInfo, at: Vector3 = Vector3.ZERO) -> float:
    if health == null or info == null or not is_finite(multiplier) or multiplier < 0.0:
        return 0.0
    return health.apply_damage(info.for_zone(zone, multiplier, at))
