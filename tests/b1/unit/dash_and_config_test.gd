extends GdUnitTestSuite
## H05 · DashController timing/cooldown, movement config validation and input map registration.

const Dash = preload("res://scripts/player/dash_controller.gd")
const Config = preload("res://scripts/player/player_movement_config.gd")
const Actions = preload("res://scripts/player/input_actions.gd")


func test_dash_starts_and_ends_after_duration() -> void:
    var dash := Dash.new()
    dash.configure(0.16, 1.0, 22.0)
    assert_bool(dash.try_start(Vector3(0, 0, -1))).is_true()
    assert_bool(dash.is_dashing()).is_true()
    assert_vector(dash.velocity_for()).is_equal_approx(Vector3(0, 0, -22), Vector3.ONE * 0.001)
    dash.tick(0.1)
    assert_bool(dash.is_dashing()).is_true()
    dash.tick(0.07)
    assert_bool(dash.is_dashing()).is_false()
    assert_vector(dash.velocity_for()).is_equal(Vector3.ZERO)


func test_ct03_cooldown_blocks_second_dash_until_elapsed() -> void:
    var dash := Dash.new()
    dash.configure(0.16, 1.0, 22.0)
    assert_bool(dash.try_start(Vector3.FORWARD)).is_true()
    dash.tick(0.5)
    assert_bool(dash.try_start(Vector3.FORWARD)).is_false()
    dash.tick(0.49)
    assert_bool(dash.try_start(Vector3.FORWARD)).is_false()
    dash.tick(0.02)
    assert_bool(dash.try_start(Vector3.FORWARD)).is_true()


func test_dash_direction_is_flattened_and_validated() -> void:
    var dash := Dash.new()
    assert_bool(dash.try_start(Vector3.ZERO)).is_false()
    assert_bool(dash.try_start(Vector3.UP)).is_false()
    assert_bool(dash.try_start(Vector3(NAN, 0, 1))).is_false()
    assert_bool(dash.try_start(Vector3(3, 5, 4))).is_true()
    assert_float(dash.direction.y).is_equal(0.0)
    assert_float(dash.direction.length()).is_equal_approx(1.0, 0.0001)


func test_ct04_blocked_state_does_not_start_or_consume_cooldown() -> void:
    var dash := Dash.new()
    assert_bool(dash.try_start(Vector3.FORWARD, false)).is_false()
    assert_float(dash.cooldown_left).is_equal(0.0)


func test_tick_ignores_invalid_delta() -> void:
    var dash := Dash.new()
    dash.try_start(Vector3.FORWARD)
    var left := dash.time_left
    for delta in [0.0, -1.0, NAN, INF]:
        dash.tick(delta)
    assert_float(dash.time_left).is_equal(left)


func test_default_movement_resource_is_valid() -> void:
    var config: PlayerMovementConfig = load("res://resources/player/movement_default.tres")
    assert_object(config).is_not_null()
    assert_array(Array(config.validation_errors())).is_empty()
    assert_float(config.double_tap_window_s).is_equal(0.25)


func test_invalid_movement_values_are_rejected() -> void:
    for mutation in [{"walk_speed_mps": -1.0}, {"dash_cooldown_s": NAN}, {"double_tap_window_s": 0.0},
            {"double_tap_window_s": 2.0}, {"sprint_speed_mps": 1.0}, {"dash_duration_s": 3.0}]:
        var config := Config.new()
        for key in mutation:
            config.set(key, mutation[key])
        assert_bool(config.validation_errors().is_empty()).is_false()


func test_input_actions_registered_with_approved_keys() -> void:
    Actions.ensure_registered()
    Actions.ensure_registered()  # idempotent
    var expected := {&"move_forward": KEY_W, &"move_back": KEY_S, &"move_left": KEY_A,
            &"move_right": KEY_D, &"interact": KEY_F, &"heal": KEY_E, &"sprint": KEY_SHIFT, &"jump": KEY_SPACE}
    for action in expected:
        assert_bool(InputMap.has_action(action)).is_true()
        var events := InputMap.action_get_events(action)
        assert_int(events.size()).is_equal(1)
        assert_int((events[0] as InputEventKey).keycode).is_equal(expected[action])
    assert_bool(InputMap.has_action(&"fire")).is_true()


func test_ct06_interact_and_heal_use_different_keys() -> void:
    Actions.ensure_registered()
    var e := InputEventKey.new()
    e.keycode = KEY_E
    e.pressed = true
    var f := InputEventKey.new()
    f.keycode = KEY_F
    f.pressed = true
    assert_bool(e.is_action(&"interact")).is_false()
    assert_bool(f.is_action(&"interact")).is_true()
    assert_bool(e.is_action(&"heal")).is_true()
    assert_bool(f.is_action(&"heal")).is_false()


func test_no_binding_invented_for_pending_actions() -> void:
    Actions.ensure_registered()
    for action in [&"reload", &"ultimate", &"pause"]:
        assert_bool(InputMap.has_action(action)).is_false()
