extends RefCounted
## Current HitscanWeapon geometry/poses only: solid animation envelope attached to the player's body.
## Keeps the weapon's transform/materials/animations unchanged. Movement uses move_and_slide;
## look checks the swept volume so a large mouse delta cannot rotate through a thin wall.

const ANGLE_STEP := 0.02
const CONTACT_BACKOFF := 0.001

var body: CharacterBody3D
var weapon: HitscanWeapon
var camera: Camera3D
var collider: CollisionShape3D
var points := PackedVector3Array()
var sweep := ConvexPolygonShape3D.new()
var query := PhysicsShapeQueryParameters3D.new()


func _init(player: CharacterBody3D, fixture: HitscanWeapon, view: Camera3D) -> void:
    body = player
    weapon = fixture
    camera = view
    points = _animation_envelope()
    var shape := ConvexPolygonShape3D.new()
    shape.points = points
    collider = CollisionShape3D.new()
    collider.name = "WeaponWallShape"
    collider.shape = shape
    body.add_child(collider)
    sync_shape()
    query.shape = sweep
    query.collision_mask = body.collision_mask
    query.exclude = [body.get_rid()]


func _animation_envelope() -> PackedVector3Array:
    # Fixture animations translate Model along linear segments. The convex hull of all
    # mesh corners at their key poses contains recoil/recovery/reload between keys too.
    var poses: Array[Vector3] = [Vector3.ZERO]
    for animation_name in weapon.animation_player.get_animation_list():
        var animation := weapon.animation_player.get_animation(animation_name)
        for track in range(animation.get_track_count()):
            if animation.track_get_type(track) != Animation.TYPE_VALUE \
                    or animation.track_get_path(track) != NodePath("Model:position"):
                continue
            for key in range(animation.track_get_key_count(track)):
                var pose: Vector3 = animation.track_get_key_value(track, key)
                if not poses.has(pose):
                    poses.append(pose)
    var vertices := PackedVector3Array()
    for child in weapon.model.get_children():
        var mesh := child as MeshInstance3D
        if mesh == null:
            continue
        for pose in poses:
            for corner in range(8):
                vertices.append(pose + mesh.transform * mesh.get_aabb().get_endpoint(corner))
    return vertices


func sync_shape() -> void:
    collider.transform = body.global_transform.affine_inverse() * weapon.global_transform


func turn(yaw_delta: float, pitch_delta: float) -> void:
    _turn_axis(clampf(yaw_delta, -TAU, TAU), true)
    _turn_axis(pitch_delta, false)
    sync_shape()


func _turn_axis(angle: float, yaw: bool) -> void:
    if is_zero_approx(angle):
        return
    var node: Node3D = body if yaw else camera
    var steps := maxi(1, ceili(absf(angle) / ANGLE_STEP))
    var step := angle / steps
    for part in range(steps):
        var before := node.transform
        var start := weapon.global_transform
        var pivot := node.global_position
        _rotate(node, step, yaw)
        if not _arc_blocked(start, weapon.global_transform, pivot, step):
            continue
        var low := 0.0
        var high := 1.0
        for search in range(8):
            var middle := (low + high) * 0.5
            node.transform = before
            _rotate(node, step * middle, yaw)
            if _arc_blocked(start, weapon.global_transform, pivot, step * middle):
                high = middle
            else:
                low = middle
        node.transform = before
        # Leave a small angular clearance so the next input can freely turn away.
        _rotate(node, signf(step) * maxf(0.0, absf(step) * low - CONTACT_BACKOFF), yaw)
        break


func _rotate(node: Node3D, angle: float, yaw: bool) -> void:
    if yaw:
        node.rotate_y(angle)
    else:
        node.rotate_x(angle)


func _arc_blocked(start: Transform3D, finish: Transform3D, pivot: Vector3, angle: float) -> bool:
    var vertices := PackedVector3Array()
    var radius := 0.0
    for point in points:
        var from := start * point
        vertices.append(from - body.global_position)
        vertices.append(finish * point - body.global_position)
        radius = maxf(radius, from.distance_to(pivot))
    sweep.points = vertices
    query.transform = Transform3D(Basis.IDENTITY, body.global_position)
    # Arc-to-chord distance <= radius * angle^2 / 8. Inflate the swept hull by that
    # bound: checking just the endpoint would miss a fast rotation across a thin wall.
    query.margin = radius * angle * angle * 0.125 + 0.00001
    return not body.get_world_3d().direct_space_state.intersect_shape(query, 1).is_empty()
