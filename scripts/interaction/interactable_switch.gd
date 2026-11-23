class_name InteractableSwitch
extends StaticBody3D
## H05 · Minimal interactable fixture: a console that toggles when the player interacts (F).
## Contract for any interactable: be in group "interactable" and implement interact(actor).
## Not a final prop; built from primitives so it needs no new asset.

signal toggled(is_on: bool)

@export var prompt := "F  ·  activar consola"
@export var size := Vector3(1.0, 1.2, 0.6)

var is_on := false
var interaction_count := 0
var _mesh: MeshInstance3D


func _ready() -> void:
    add_to_group(&"interactable")
    collision_layer = PhysicsLayers.WORLD
    var shape := BoxShape3D.new()
    shape.size = size
    var collider := CollisionShape3D.new()
    collider.shape = shape
    add_child(collider)
    _mesh = MeshInstance3D.new()
    var box := BoxMesh.new()
    box.size = size
    _mesh.mesh = box
    add_child(_mesh)
    _refresh_look()


func interact(_actor: Node) -> void:
    interaction_count += 1
    is_on = not is_on
    _refresh_look()
    toggled.emit(is_on)


func _refresh_look() -> void:
    if _mesh == null:
        return
    var mat := StandardMaterial3D.new()
    mat.albedo_color = Color("3fd0a0") if is_on else Color("6a4f8f")
    mat.emission_enabled = is_on
    mat.emission = Color("3fd0a0")
    _mesh.material_override = mat
