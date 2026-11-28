extends GdUnitTestSuite
## D-030: real walls must stop the visible weapon without changing its framing.

const World = preload("res://tests/gameplay/support/test_world.gd")

var world: World
var player: PlayerController


func before_test() -> void:
    World.release_all()
    world = auto_free(World.new())
    add_child(world)
    world.add_floor()
    player = world.spawn_player()
    await _frames(15)


func after_test() -> void:
    World.release_all()


func _frames(count: int) -> void:
    for i in range(count):
        await get_tree().physics_frame


func _meshes_clear() -> bool:
    # Query the visible meshes, independently of the implementation's collision envelope.
    var query := PhysicsShapeQueryParameters3D.new()
    query.collision_mask = PhysicsLayers.WORLD
    query.exclude = [player.get_rid()]
    for child in player.weapon.model.get_children():
        var mesh := child as MeshInstance3D
        if mesh == null:
            continue
        var box := BoxShape3D.new()
        box.size = mesh.get_aabb().size
        query.shape = box
        query.transform = mesh.global_transform.translated_local(mesh.get_aabb().get_center())
        if not world.get_world_3d().direct_space_state.intersect_shape(query, 1).is_empty():
            return false
    return true


func _animation_poses_clear() -> bool:
    var animator := player.weapon.animation_player
    animator.callback_mode_process = AnimationMixer.ANIMATION_CALLBACK_MODE_PROCESS_MANUAL
    var clear := true
    for animation_name in animator.get_animation_list():
        var animation := animator.get_animation(animation_name)
        animator.play(animation_name)
        for pose in range(21):
            animator.seek(animation.length * pose / 20.0, true)
            clear = _meshes_clear() and clear
    animator.stop()
    return clear


func test_dash_stops_weapon_at_wall_including_recoil_and_reload() -> void:
    world.add_block(Vector3(0, 1.5, -3), Vector3(6, 3, 0.1))
    await _frames(2)
    var clear := true
    for attempt in range(3):
        player.dash.cooldown_left = 0.0
        player.request_dash(&"move_forward")
        for frame in range(20):
            await _frames(1)
            clear = _meshes_clear() and clear
    assert_bool(clear).is_true()
    assert_bool(_animation_poses_clear()).is_true()
    assert_bool(player.is_on_floor()).is_true()
    assert_bool(player.dash.is_dashing()).is_false()


func test_strafe_stops_weapon_but_can_slide_and_back_away() -> void:
    world.add_block(Vector3(1, 1.5, 0), Vector3(0.1, 3, 12))
    await _frames(2)
    Input.action_press(InputActions.MOVE_RIGHT)
    await _frames(30)
    assert_bool(_animation_poses_clear()).is_true()
    var contact := player.global_position
    Input.action_press(InputActions.MOVE_FORWARD)
    await _frames(20)
    assert_float(player.global_position.z).is_less(contact.z - 0.5)
    assert_bool(_meshes_clear()).is_true()
    World.release_all()
    Input.action_press(InputActions.MOVE_LEFT)
    await _frames(20)
    assert_float(player.global_position.x).is_less(contact.x - 0.5)


func test_fast_yaw_cannot_sweep_weapon_through_thin_wall() -> void:
    # Initial and requested final orientations are clear; the intervening arc hits the wall.
    world.add_block(Vector3(0.7, 1.5, 0), Vector3(0.02, 3, 8))
    await _frames(2)
    player.look(Vector2(PI / player.config.mouse_sensitivity, 0))
    assert_float(absf(player.rotation.y)).is_less(PI / 2.0)
    assert_bool(_animation_poses_clear()).is_true()
    var blocked_yaw := player.rotation.y
    player.look(Vector2(-0.25 / player.config.mouse_sensitivity, 0))
    assert_float(player.rotation.y).is_greater(blocked_yaw + 0.1)
    assert_bool(_meshes_clear()).is_true()


func test_pitch_stops_weapon_at_ceiling_and_can_turn_away() -> void:
    world.add_block(Vector3(0, 2.2, 0), Vector3(6, 0.05, 6))
    await _frames(2)
    player.look(Vector2(0, -10000))
    assert_float(player.pitch).is_less(1.4)
    assert_bool(_animation_poses_clear()).is_true()
    player.look(Vector2(0, player.pitch / player.config.mouse_sensitivity))
    assert_float(player.pitch).is_equal_approx(0.0, 0.001)
    assert_bool(_meshes_clear()).is_true()


func test_diagonal_movement_against_corner_keeps_animated_meshes_clear() -> void:
    world.add_block(Vector3(1, 1.5, -2), Vector3(0.1, 3, 6))
    world.add_block(Vector3(0, 1.5, -2), Vector3(6, 3, 0.1))
    await _frames(2)
    Input.action_press(InputActions.MOVE_FORWARD)
    Input.action_press(InputActions.MOVE_RIGHT)
    var clear := true
    for frame in range(45):
        await _frames(1)
        clear = _meshes_clear() and clear
    assert_bool(clear).is_true()
    assert_bool(_animation_poses_clear()).is_true()


func test_forward_weapon_fits_narrow_corridor_without_enlarging_body_radius() -> void:
    world.add_block(Vector3(-0.6, 1.5, -2), Vector3(0.1, 3, 12))
    world.add_block(Vector3(0.6, 1.5, -2), Vector3(0.1, 3, 12))
    await _frames(2)
    var start := player.global_position.z
    Input.action_press(InputActions.MOVE_FORWARD)
    await _frames(30)
    assert_float(player.global_position.z).is_less(start - 2.0)
    assert_bool(_meshes_clear()).is_true()


func test_weapon_local_transform_and_animations_stay_unchanged() -> void:
    assert_vector(player.weapon.position).is_equal_approx(Vector3(0.32, -0.28, -0.55), Vector3.ONE * 0.00001)
    assert_vector(player.weapon.scale).is_equal(Vector3.ONE)
    var original := player.weapon.transform
    player.look(Vector2(200, -10000))
    assert_float(player.pitch).is_equal_approx(1.45, 0.0001)
    player.look(Vector2(-200, 20000))
    assert_float(player.pitch).is_equal_approx(-1.45, 0.0001)
    assert_bool(player.weapon.transform.is_equal_approx(original)).is_true()
    var animator := player.weapon.animation_player
    animator.callback_mode_process = AnimationMixer.ANIMATION_CALLBACK_MODE_PROCESS_MANUAL
    animator.play(AttackStateMachine.ANIM_RELOAD)
    animator.seek(player.weapon.reload_anim_s * 0.5, true)
    assert_vector(player.weapon.model.position).is_equal_approx(Vector3(0, -0.25, 0.05), Vector3.ONE * 0.00001)
    animator.stop()
