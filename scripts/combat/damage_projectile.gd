class_name DamageProjectile
extends Node3D
## H06 · Travelling damage. Each step ray-casts the segment it moves through, so fast projectiles
## never tunnel through thin walls or hitboxes. Damages at most one target, then frees itself.

signal impacted(collider: Object, applied: float)

@export var speed_mps := 30.0
@export var lifetime_s := 3.0

var info: DamageInfo
var direction := Vector3.FORWARD
var exclude: Array[RID] = []
var age := 0.0
var finished := false


func launch(from: Vector3, toward: Vector3, damage: DamageInfo, excluded: Array[RID] = []) -> void:
    global_position = from
    direction = toward.normalized() if toward.length_squared() > 0.0001 else Vector3.FORWARD
    info = damage
    exclude = excluded


func _ready() -> void:
    var mesh_instance := MeshInstance3D.new()
    var sphere := SphereMesh.new()
    sphere.radius = 0.08
    sphere.height = 0.16
    mesh_instance.mesh = sphere
    var mat := StandardMaterial3D.new()
    mat.albedo_color = Color("ff8a3d")
    mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
    mesh_instance.material_override = mat
    add_child(mesh_instance)


func _physics_process(delta: float) -> void:
    step(delta)


## Moves one step. Public so tests can drive it deterministically.
func step(delta: float) -> void:
    if finished or not is_finite(delta) or delta <= 0.0:
        return
    age += delta
    var from := global_position
    var to := from + direction * speed_mps * delta
    var query := PhysicsRayQueryParameters3D.create(from, to, Hitscan.MASK, exclude)
    query.collide_with_areas = true
    var hit := get_world_3d().direct_space_state.intersect_ray(query)
    if not hit.is_empty():
        global_position = hit.position
        var applied := 0.0
        if hit.collider is Hitbox and info != null:
            applied = (hit.collider as Hitbox).receive_hit(info, hit.position)
        _finish(hit.collider, applied)
        return
    global_position = to
    if age >= lifetime_s:
        _finish(null, 0.0)


func _finish(collider: Object, applied: float) -> void:
    finished = true
    impacted.emit(collider, applied)
    queue_free()
