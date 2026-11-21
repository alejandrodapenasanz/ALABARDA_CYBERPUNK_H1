extends GdUnitTestSuite

const Profile = preload("res://scripts/config/balance_profile.gd")

func test_framework_positive() -> void:
    assert_int(2 + 2).is_equal(4)

func test_load_resource_and_approved_rules() -> void:
    var profile := Profile.read_validated("res://resources/balance/provisional.tres")
    assert_object(profile).is_not_null()
    assert_dict(profile.rules).is_equal(Profile.APPROVED_RULES)
    assert_float(profile.values.pistol_suppressed_damage).is_equal(30.0)

func test_invalid_numeric_data() -> void:
    for value in [-1.0, NAN, INF, -INF, "20", true, null]:
        var profile := Profile.new()
        profile.values.heal_hp_per_second = value
        assert_bool(profile.validation_errors().is_empty()).is_false()

func test_missing_unknown_and_approved_rule_changes() -> void:
    var profile := Profile.new()
    profile.values.erase("katana_damage")
    assert_bool(profile.validation_errors().is_empty()).is_false()
    profile = Profile.new()
    profile.values["invented_value"] = 1.0
    assert_bool(profile.validation_errors().is_empty()).is_false()
    profile = Profile.new()
    profile.rules.energy_max = 151.0
    assert_bool(profile.validation_errors().is_empty()).is_false()
    profile = Profile.new()
    profile.schema_version = 2
    assert_bool(profile.validation_errors().is_empty()).is_false()

func test_relationships_and_integer_counts() -> void:
    for mutation in [{"sprint_speed_mps": 1.0}, {"dash_duration_seconds": 2.0}, {"extraction_damage_multiplier": 1.1}, {"ultimate_duration_at_150_seconds": 5.0}, {"pistol_magazine": 0.0}, {"rifle_magazine": 1.5}]:
        var profile := Profile.new()
        profile.values.merge(mutation, true)
        assert_bool(profile.validation_errors().is_empty()).is_false()

func test_clamps_and_nonfinite_values() -> void:
    for pair in [[-1.0, 0.0], [0.0, 0.0], [99.0, 99.0], [100.0, 100.0], [150.0, 150.0], [151.0, 150.0], [1.0e30, 150.0], [NAN, 0.0], [INF, 0.0], [-INF, 0.0]]:
        assert_float(Profile.clamp_energy(pair[0])).is_equal(pair[1])
    assert_float(Profile.clamp_health(-1.0)).is_equal(0.0)
    assert_float(Profile.clamp_health(100.0)).is_equal(100.0)
    assert_float(Profile.clamp_health(101.0)).is_equal(100.0)
    assert_float(Profile.clamp_health(NAN)).is_equal(0.0)

func test_missing_wrong_type_and_invalid_resource() -> void:
    assert_object(Profile.read_validated("res://resources/balance/does_not_exist.tres")).is_null()
    assert_object(Profile.read_validated("res://scenes/main.tscn")).is_null()
    var invalid := Profile.new()
    invalid.rules.energy_max = 200.0
    var path := "user://h03_invalid_balance.tres"
    assert_int(ResourceSaver.save(invalid, path)).is_equal(OK)
    assert_object(Profile.read_validated(path)).is_null()
    DirAccess.remove_absolute(path)

func test_instances_do_not_share_mutable_defaults() -> void:
    var first := Profile.new()
    var second := Profile.new()
    first.values.katana_damage = 1.0
    assert_float(second.values.katana_damage).is_equal(35.0)
