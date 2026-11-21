extends StaticBody3D

signal eliminated(enemy: Node3D)

var health := 70.0
var max_health := 70.0
var attack_range := 17.0
var attack_interval := 2.2
var damage := 7.0
var time_until_attack := 0.8
var player: Node3D
var model: MeshInstance3D
var defeated := false

func configure(target: Node3D, total_health: float, ranged: bool) -> void:
    player = target
    max_health = total_health
    health = total_health
    if not ranged:
        attack_range = 3.0
        damage = 12.0
        attack_interval = 1.5

func _ready() -> void:
    add_to_group("enemies")
    var shape := BoxShape3D.new()
    shape.size = Vector3(0.8, 1.8, 0.8)
    var collision := CollisionShape3D.new()
    collision.shape = shape
    collision.position.y = 0.9
    add_child(collision)
    model = MeshInstance3D.new()
    var mesh := BoxMesh.new()
    mesh.size = shape.size
    model.mesh = mesh
    model.position.y = 0.9
    add_child(model)
    _update_material()

func _process(delta: float) -> void:
    if defeated or player == null or not is_instance_valid(player):
        return
    time_until_attack -= delta
    if global_position.distance_to(player.global_position) <= attack_range and time_until_attack <= 0.0:
        time_until_attack = attack_interval
        if player.has_method("take_damage"):
            player.take_damage(damage)

func take_damage(amount: float) -> void:
    if defeated or not is_finite(amount) or amount <= 0.0:
        return
    health = maxf(0.0, health - amount)
    if health <= 0.0:
        defeated = true
        set_process(false)
        eliminated.emit(self)
        queue_free()
    else:
        _update_material()

func _update_material() -> void:
    if model == null: return
    var mat := StandardMaterial3D.new()
    mat.albedo_color = Color("e9a24b") if attack_range < 5.0 else Color("d45b79")
    if health / max_health < 0.5:
        mat.albedo_color = Color("f0d6cb")
    mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
    model.material_override = mat
