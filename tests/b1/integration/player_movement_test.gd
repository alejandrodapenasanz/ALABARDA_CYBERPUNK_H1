extends GdUnitTestSuite
## H05 · Player integration in a physics world: CT-01, CT-02, CT-03, CT-04, CT-05, CT-06.
## Requires Godot (headless is enough). Input is injected with Input.parse_input_event.

const World = preload("res://tests/b1/support/test_world.gd")
const Switch = preload("res://scripts/interaction/interactable_switch.gd")

var world: Node3D
var player: B1Player
var fake_time := 100.0


func before_test() -> void:
    World.release_all()
    world = auto_free(World.new())
    add_child(world)
    world.add_floor()
    player = world.spawn_player(Vector3(0, 1.0, 0))
    player.clock = func() -> float: return fake_time
    await _frames(15)


func after_test() -> void:
    World.release_all()


func _frames(count: int) -> void:
    for i in range(count):
        await get_tree().physics_frame


func _press(code: Key) -> void:
    Input.parse_input_event(World.key_event(code, true))
    Input.flush_buffered_events()


func _release(code: Key) -> void:
    Input.parse_input_event(World.key_event(code, false))
    Input.flush_buffered_events()


func test_ct05_player_rests_on_floor() -> void:
    assert_bool(player.is_on_floor()).is_true()
    assert_int(player.move_state).is_equal(B1Player.MoveState.GROUNDED)
    assert_bool(player.camera.current).is_true()


func test_ct05_w_moves_forward_with_real_input() -> void:
    var start := player.global_position
    _press(KEY_W)
    await _frames(18)
    _release(KEY_W)
    assert_float(player.global_position.z).is_less(start.z - 1.0)
    assert_float(absf(player.global_position.x - start.x)).is_less(0.05)


func test_ct05_sprint_is_faster_than_walk() -> void:
    _press(KEY_W)
    await _frames(20)
    var walk := Vector2(player.velocity.x, player.velocity.z).length()
    _press(KEY_SHIFT)
    await _frames(20)
    var sprint := Vector2(player.velocity.x, player.velocity.z).length()
    assert_float(walk).is_equal_approx(player.config.walk_speed_mps, 0.1)
    assert_float(sprint).is_equal_approx(player.config.sprint_speed_mps, 0.1)


func test_ct05_jump_from_floor() -> void:
    _press(KEY_SPACE)
    await _frames(2)
    _release(KEY_SPACE)
    assert_float(player.velocity.y).is_greater(0.0)
    await _frames(3)
    assert_int(player.move_state).is_equal(B1Player.MoveState.AIRBORNE)
    await _frames(80)
    assert_bool(player.is_on_floor()).is_true()


func test_ct05_mouse_look_clamps_pitch_and_turns_body() -> void:
    player.look(Vector2(0, -100000))
    assert_float(player.pitch).is_equal_approx(1.45, 0.0001)
    assert_float(player.camera.rotation.x).is_equal_approx(1.45, 0.0001)
    player.look(Vector2(0, 200000))
    assert_float(player.pitch).is_equal_approx(-1.45, 0.0001)
    var yaw := player.rotation.y
    player.look(Vector2(100, 0))
    assert_float(player.rotation.y).is_not_equal(yaw)


func test_ct01_each_direction_dashes_in_its_world_direction() -> void:
    var expected := {&"move_forward": Vector3(0, 0, -1), &"move_back": Vector3(0, 0, 1),
            &"move_left": Vector3(-1, 0, 0), &"move_right": Vector3(1, 0, 0)}
    for action in expected:
        player.dash.cooldown_left = 0.0
        player.dash.cancel()
        assert_bool(player.handle_direction_press(action, false, 10.0)).is_false()
        assert_bool(player.handle_direction_press(action, false, 10.1)).is_true()
        assert_vector(player.dash.direction).is_equal_approx(expected[action], Vector3.ONE * 0.001)


func test_ct01_dash_follows_body_yaw() -> void:
    player.rotation.y = PI / 2.0  # facing -X
    player.handle_direction_press(&"move_forward", false, 1.0)
    assert_bool(player.handle_direction_press(&"move_forward", false, 1.1)).is_true()
    assert_vector(player.dash.direction).is_equal_approx(Vector3(-1, 0, 0), Vector3.ONE * 0.001)


func test_ct01_real_key_double_tap_triggers_one_dash() -> void:
    var signals := monitor_signals(player, false)
    var start := player.global_position
    fake_time = 50.0
    _press(KEY_W)
    await _frames(1)
    _release(KEY_W)
    await _frames(1)
    fake_time = 50.12
    _press(KEY_W)
    await _frames(1)
    _release(KEY_W)
    await assert_signal(signals).is_emitted("dashed", &"move_forward")
    await _frames(10)
    assert_float(player.global_position.z).is_less(start.z - 2.0)
    assert_float(player.dash.cooldown_left).is_greater(0.0)


func test_ct02_slow_or_mixed_presses_do_not_dash() -> void:
    assert_bool(player.handle_direction_press(&"move_forward", false, 1.0)).is_false()
    assert_bool(player.handle_direction_press(&"move_forward", false, 1.5)).is_false()
    assert_bool(player.handle_direction_press(&"move_left", false, 1.55)).is_false()
    assert_bool(player.handle_direction_press(&"move_right", false, 1.6)).is_false()
    assert_bool(player.dash.is_dashing()).is_false()
    assert_float(player.dash.cooldown_left).is_equal(0.0)


func test_ct03_echo_and_pair_in_cooldown_do_not_dash_again() -> void:
    player.handle_direction_press(&"move_back", false, 1.0)
    assert_bool(player.handle_direction_press(&"move_back", true, 1.05)).is_false()  # echo
    assert_bool(player.handle_direction_press(&"move_back", false, 1.1)).is_true()
    var cooldown := player.dash.cooldown_left
    await _frames(15)  # dash over, cooldown still running
    player.handle_direction_press(&"move_back", false, 1.4)
    assert_bool(player.handle_direction_press(&"move_back", false, 1.5)).is_false()
    assert_float(player.dash.cooldown_left).is_less(cooldown)


func test_ct04_dash_into_wall_never_passes_geometry() -> void:
    world.add_block(Vector3(0, 1.5, -3.0), Vector3(6, 3, 1))  # wall face at z = -2.5
    await _frames(2)
    for i in range(4):
        player.dash.cooldown_left = 0.0
        player.handle_direction_press(&"move_forward", false, 20.0 + i)
        player.handle_direction_press(&"move_forward", false, 20.05 + i)
        await _frames(20)
        assert_float(player.global_position.z).is_greater(-2.5)
    assert_bool(player.dash.is_dashing()).is_false()
    assert_int(player.move_state).is_equal(B1Player.MoveState.GROUNDED)


func test_ct04_disabled_state_blocks_dash_movement_and_interaction() -> void:
    player.set_disabled(true)
    assert_int(player.move_state).is_equal(B1Player.MoveState.DISABLED)
    player.handle_direction_press(&"move_forward", false, 1.0)
    assert_bool(player.handle_direction_press(&"move_forward", false, 1.1)).is_false()
    assert_bool(player.try_interact()).is_false()
    var start := player.global_position
    _press(KEY_W)
    await _frames(15)
    _release(KEY_W)
    assert_float(player.global_position.distance_to(start)).is_less(0.05)
    player.set_disabled(false)
    assert_int(player.move_state).is_equal(B1Player.MoveState.GROUNDED)


func _add_switch(pos: Vector3) -> InteractableSwitch:
    var console: InteractableSwitch = Switch.new()
    world.add_child(console)
    console.global_position = pos
    return console


func test_ct06_f_interacts_and_e_never_does_even_near_object() -> void:
    var console := _add_switch(Vector3(0, 1.5, -1.5))
    await _frames(3)
    assert_object(player.focused_interactable).is_same(console)
    _press(KEY_E)
    await _frames(2)
    _release(KEY_E)
    await _frames(1)
    assert_int(console.interaction_count).is_equal(0)
    _press(KEY_F)
    await _frames(2)
    _release(KEY_F)
    await _frames(1)
    assert_int(console.interaction_count).is_equal(1)
    assert_bool(console.is_on).is_true()


func test_ct06_wall_and_distance_block_interaction() -> void:
    var console := _add_switch(Vector3(0, 1.5, -2.2))
    world.add_block(Vector3(0, 1.5, -1.2), Vector3(3, 3, 0.2))
    await _frames(3)
    assert_bool(player.try_interact()).is_false()
    assert_int(console.interaction_count).is_equal(0)
    var far := _add_switch(Vector3(5, 1.5, -6))
    player.look_at(Vector3(5, player.global_position.y, -6))
    await _frames(2)
    assert_bool(player.try_interact()).is_false()
    assert_int(far.interaction_count).is_equal(0)
