class_name TargetDummy
extends StaticBody3D
## H06 · Static test target with body and head hitboxes, optional armor and type vulnerabilities.
## Fixture only: it does not move, see or attack (enemies are H10). Values are BALANCE hypotheses.

signal defeated(dummy: TargetDummy)

@export var max_health := 60.0
@export var armor := 0.0
@export var vulnerabilities: Dictionary = {}
@export var respawn_after_s := 0.0  # 0 = stays down (tests); the sandbox uses 3 s
@export var label := "BLANCO"

var health: HealthComponent
var body_hitbox: Hitbox
var head_hitbox: Hitbox
var _mesh: MeshInstance3D
var _info: Label3D
var _respawn_left := 0.0


func _ready() -> void:
    collision_layer = PhysicsLayers.ENEMY
    collision_mask = 0
    var body_shape := BoxShape3D.new()
    body_shape.size = Vector3(0.8, 1.5, 0.5)
    _add_collider(self, body_shape, Vector3(0, 0.75, 0))
    health = HealthComponent.new()
    health.name = "HealthComponent"
    health.max_health = max_health
    health.armor = armor
    health.vulnerabilities = vulnerabilities
    health.auto_regen_enabled = false
    add_child(health)
    body_hitbox = _add_hitbox("BodyHitbox", DamageInfo.ZONE_BODY, 1.0, body_shape, Vector3(0, 0.75, 0))
    var head_shape := BoxShape3D.new()
    head_shape.size = Vector3(0.4, 0.4, 0.4)
    head_hitbox = _add_hitbox("HeadHitbox", DamageInfo.ZONE_HEAD, Hitbox.HEAD_MULTIPLIER_PROVISIONAL,
            head_shape, Vector3(0, 1.72, 0))
    _mesh = MeshInstance3D.new()
    var box := BoxMesh.new()
    box.size = body_shape.size
    _mesh.mesh = box
    _mesh.position = Vector3(0, 0.75, 0)
    add_child(_mesh)
    var head_mesh := MeshInstance3D.new()
    var head_box := BoxMesh.new()
    head_box.size = head_shape.size
    head_mesh.mesh = head_box
    head_mesh.position = Vector3(0, 1.72, 0)
    add_child(head_mesh)
    _info = Label3D.new()
    _info.position = Vector3(0, 2.25, 0)
    _info.billboard = BaseMaterial3D.BILLBOARD_ENABLED
    _info.font_size = 40
    add_child(_info)
    health.health_changed.connect(func(_c: float, _m: float): _refresh())
    health.armor_changed.connect(func(_a: float): _refresh())
    health.died.connect(_on_died)
    _refresh()


func _process(delta: float) -> void:
    if _respawn_left > 0.0:
        _respawn_left -= delta
        if _respawn_left <= 0.0:
            revive()


func revive() -> void:
    health.armor = armor
    health.reset_full()
    _set_hitboxes_enabled(true)
    _refresh()


func _on_died() -> void:
    _set_hitboxes_enabled(false)
    _refresh()
    defeated.emit(self)
    if respawn_after_s > 0.0:
        _respawn_left = respawn_after_s


func _set_hitboxes_enabled(enabled: bool) -> void:
    for box in [body_hitbox, head_hitbox]:
        box.collision_layer = PhysicsLayers.HITBOX if enabled else 0


func _add_collider(parent: Node, shape: Shape3D, offset: Vector3) -> void:
    var collider := CollisionShape3D.new()
    collider.shape = shape
    collider.position = offset
    parent.add_child(collider)


func _add_hitbox(node_name: String, zone: StringName, mult: float, shape: Shape3D, offset: Vector3) -> Hitbox:
    var box := Hitbox.new()
    box.name = node_name
    box.zone = zone
    box.multiplier = mult
    box.health = health
    _add_collider(box, shape, offset)
    add_child(box)
    return box


func _refresh() -> void:
    if _info == null:
        return
    var dead := health.is_dead()
    _info.text = "%s\n%s" % [label, "DERRIBADO" if dead else "HP %d%s" % [ceili(health.health),
            "  ARM %d" % ceili(health.armor) if health.armor > 0.0 else ""]]
    var mat := StandardMaterial3D.new()
    mat.albedo_color = Color("4a4f57") if dead else (Color("c9a34a") if health.armor > 0.0 else Color("d45b79"))
    _mesh.material_override = mat
