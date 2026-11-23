extends RefCounted
## B1 sandbox-only damage sources for manual H06 checks (regen delay/reset, projectiles).
## Not enemies (H10): no perception, no AI. Damage values are test fixtures.


class DamageZone extends Area3D:
    ## Deals `damage` every `interval_s` to a B1Player standing inside (environment damage).
    var damage := 10.0
    var interval_s := 1.0
    var _inside: B1Player = null
    var _left := 0.0

    func _init(size: Vector3 = Vector3(3, 1, 3)) -> void:
        collision_layer = 0
        collision_mask = PhysicsLayers.PLAYER
        monitoring = true
        var shape := BoxShape3D.new()
        shape.size = size
        var collider := CollisionShape3D.new()
        collider.shape = shape
        add_child(collider)
        var mesh_instance := MeshInstance3D.new()
        var box := BoxMesh.new()
        box.size = Vector3(size.x, 0.04, size.z)
        mesh_instance.mesh = box
        mesh_instance.position.y = -size.y * 0.5 + 0.02
        var mat := StandardMaterial3D.new()
        mat.albedo_color = Color(0.9, 0.2, 0.2, 0.55)
        mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
        mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
        mesh_instance.material_override = mat
        add_child(mesh_instance)
        body_entered.connect(func(body: Node3D):
            if body is B1Player:
                _inside = body
                _left = 0.0)
        body_exited.connect(func(body: Node3D):
            if body == _inside:
                _inside = null)

    func _physics_process(delta: float) -> void:
        if _inside == null or not is_instance_valid(_inside):
            return
        _left -= delta
        if _left <= 0.0:
            _left = interval_s
            _inside.take_damage(damage, DamageInfo.ENVIRONMENT, self)


class ProjectileTurret extends Node3D:
    ## Fires a DamageProjectile at the player every `interval_s` while within `range_m`.
    var damage := 8.0
    var interval_s := 2.0
    var range_m := 22.0
    var target: B1Player
    var _left := 1.0

    func _ready() -> void:
        var mesh_instance := MeshInstance3D.new()
        var cylinder := CylinderMesh.new()
        cylinder.top_radius = 0.3
        cylinder.bottom_radius = 0.45
        cylinder.height = 1.2
        mesh_instance.mesh = cylinder
        var mat := StandardMaterial3D.new()
        mat.albedo_color = Color("ff8a3d")
        mesh_instance.material_override = mat
        add_child(mesh_instance)

    func _physics_process(delta: float) -> void:
        if target == null or not is_instance_valid(target) or target.is_dead():
            return
        _left -= delta
        var aim := target.global_position + Vector3(0, 0.4, 0)
        if _left > 0.0 or global_position.distance_to(aim) > range_m:
            return
        _left = interval_s
        var shot := DamageProjectile.new()
        shot.speed_mps = 14.0
        get_parent().add_child(shot)
        var muzzle := global_position + Vector3(0, 0.7, 0)
        shot.launch(muzzle, aim - muzzle, DamageInfo.create(damage, DamageInfo.PROJECTILE, self))
