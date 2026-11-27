extends GdUnitTestSuite
## H05 · CT-01..CT-03 at logic level: same-key double tap, window, mixed pairs, echo, pair reuse.

const Detector = preload("res://scripts/player/double_tap_detector.gd")


func _detector() -> DoubleTapDetector:
    return Detector.new(0.25)


func test_ct01_each_direction_double_tap_inside_window() -> void:
    for key in [&"move_forward", &"move_left", &"move_back", &"move_right"]:
        var d := _detector()
        assert_str(String(d.feed(key, true, false, 10.0))).is_empty()
        assert_str(String(d.feed(key, true, false, 10.2))).is_equal(String(key))


func test_ct02_slow_pair_does_not_dash() -> void:
    var d := _detector()
    d.feed(&"move_forward", true, false, 1.0)
    assert_str(String(d.feed(&"move_forward", true, false, 1.26))).is_empty()
    # the slow second press becomes a new first tap
    assert_str(String(d.feed(&"move_forward", true, false, 1.4))).is_equal("move_forward")


func test_ct02_window_boundary_is_inclusive() -> void:
    var d := _detector()
    d.feed(&"move_left", true, false, 2.0)
    assert_str(String(d.feed(&"move_left", true, false, 2.25))).is_equal("move_left")


func test_ct02_mixed_keys_never_dash() -> void:
    var pairs := [[&"move_forward", &"move_left"], [&"move_forward", &"move_right"],
            [&"move_left", &"move_back"], [&"move_back", &"move_forward"]]
    for pair in pairs:
        var d := _detector()
        d.feed(pair[0], true, false, 0.0)
        assert_str(String(d.feed(pair[1], true, false, 0.1))).is_empty()


func test_ct02_mixed_then_same_key_counts_from_latest() -> void:
    var d := _detector()
    d.feed(&"move_forward", true, false, 0.0)
    d.feed(&"move_left", true, false, 0.05)
    assert_str(String(d.feed(&"move_left", true, false, 0.15))).is_equal("move_left")


func test_ct03_echo_and_release_are_ignored() -> void:
    var d := _detector()
    d.feed(&"move_forward", true, false, 0.0)
    assert_str(String(d.feed(&"move_forward", true, true, 0.05))).is_empty()  # OS auto-repeat
    assert_str(String(d.feed(&"move_forward", false, false, 0.08))).is_empty()  # release
    assert_str(String(d.feed(&"move_forward", true, false, 0.1))).is_equal("move_forward")


func test_ct03_held_key_with_repeats_never_dashes() -> void:
    var d := _detector()
    d.feed(&"move_forward", true, false, 0.0)
    for i in range(20):
        assert_str(String(d.feed(&"move_forward", true, true, 0.03 * (i + 1)))).is_empty()


func test_ct03_triple_tap_gives_one_dash_and_starts_new_pair() -> void:
    var d := _detector()
    d.feed(&"move_right", true, false, 0.0)
    assert_str(String(d.feed(&"move_right", true, false, 0.1))).is_equal("move_right")
    assert_str(String(d.feed(&"move_right", true, false, 0.15))).is_empty()
    assert_bool(d.has_pending()).is_true()


func test_invalid_inputs_are_ignored() -> void:
    var d := _detector()
    assert_str(String(d.feed(&"", true, false, 0.0))).is_empty()
    assert_str(String(d.feed(&"move_back", true, false, NAN))).is_empty()
    assert_bool(d.has_pending()).is_false()
    d.feed(&"move_back", true, false, 5.0)
    assert_str(String(d.feed(&"move_back", true, false, 4.9))).is_empty()  # clock went backwards


func test_reset_clears_pending_tap() -> void:
    var d := _detector()
    d.feed(&"move_back", true, false, 0.0)
    d.reset()
    assert_str(String(d.feed(&"move_back", true, false, 0.1))).is_empty()
