class_name Hitscan
extends RefCounted
## H06 · Instant ray damage. World geometry (layer 1) blocks; hitboxes (layer 4, areas) receive damage.
## Enemy/player bodies are not in the mask, so hits land on their hitboxes, not on the capsule.

const MASK := PhysicsLayers.WORLD | PhysicsLayers.HITBOX


## Returns {hit, collider, position, zone, applied}. `exclude` holds RIDs (e.g. the shooter's own hitbox).
static func fire(space: PhysicsDirectSpaceState3D, from: Vector3, to: Vector3, info: DamageInfo,
        exclude: Array[RID] = []) -> Dictionary:
    var result := {"hit": false, "collider": null, "position": to, "zone": &"", "applied": 0.0}
    if space == null or info == null or not from.is_finite() or not to.is_finite():
        return result
    var query := PhysicsRayQueryParameters3D.create(from, to, MASK, exclude)
    query.collide_with_areas = true
    query.collide_with_bodies = true
    var hit := space.intersect_ray(query)
    if hit.is_empty():
        return result
    result.hit = true
    result.collider = hit.collider
    result.position = hit.position
    if hit.collider is Hitbox:
        var box: Hitbox = hit.collider
        result.zone = box.zone
        result.applied = box.receive_hit(info, hit.position)
    return result
