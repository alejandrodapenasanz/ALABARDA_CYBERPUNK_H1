extends GdUnitTestSuite
## H06 · HealthComponent: SB-01..SB-07, SB-26 (health part), armor/vulnerability/immunity, multiple
## hits, single death and the H08 manual-heal pause contract tested with a double (no E, no energy).

const Health = preload("res://scripts/combat/health_component.gd")
const Info = preload("res://scripts/combat/damage_info.gd")
const Config = preload("res://scripts/combat/health_config.gd")
const PLAYER_HEALTH = preload("res://resources/combat/player_health.tres")


## Test double of the future H08 coordinator: pauses auto regen while active and heals 25 HP/s.
class ManualHealDouble extends RefCounted:
    var health: HealthComponent
    var rate := 25.0
    var active := false

    func _init(target: HealthComponent) -> void:
        health = target

    func start() -> void:
        active = true
        health.set_regen_paused(&"manual_heal", true)

    func tick(delta: float) -> float:
        return health.heal(rate * delta) if active else 0.0

    func stop() -> void:
        active = false
        health.set_regen_paused(&"manual_heal", false)


func _health(max_hp: float = 100.0, regen: bool = true) -> HealthComponent:
    var h: HealthComponent = Health.new()
    h.auto_process = false
    h.max_health = max_hp
    h.auto_regen_enabled = regen
    h.auto_regen_delay_s = 5.0
    h.auto_regen_hp_per_s = 5.0
    add_child(h)
    auto_free(h)
    return h


func _hit(amount: float, type: StringName = &"hitscan") -> DamageInfo:
    return Info.create(amount, type)


func test_sb01_limits_valid_invalid_and_single_death() -> void:
    var h := _health()
    var deaths := [0]
    h.died.connect(func(): deaths[0] += 1)
    assert_float(h.health).is_equal(100.0)
    assert_float(h.apply_damage(_hit(10.0))).is_equal(10.0)
    assert_float(h.health).is_equal(90.0)
    for amount in [-10.0, 0.0, NAN, INF, -INF]:
        assert_float(h.apply_damage(_hit(amount))).is_equal(0.0)
    assert_float(h.apply_damage(null)).is_equal(0.0)
    assert_float(h.health).is_equal(90.0)
    assert_float(h.apply_damage(_hit(500.0))).is_equal(90.0)
    assert_float(h.health).is_equal(0.0)
    assert_bool(h.is_dead()).is_true()
    assert_float(h.apply_damage(_hit(10.0))).is_equal(0.0)
    assert_int(deaths[0]).is_equal(1)


func test_sb02_no_regen_before_delay() -> void:
    var h := _health()
    h.apply_damage(_hit(50.0))
    h.advance(4.9)
    assert_float(h.health).is_equal(50.0)
    assert_bool(h.is_regenerating()).is_false()


func test_sb03_regen_rate_after_delay_and_split_steps_match() -> void:
    var one := _health()
    one.apply_damage(_hit(50.0))
    one.advance(5.0)
    assert_float(one.health).is_equal_approx(50.0, 0.0001)
    one.advance(1.0)
    assert_float(one.health).is_equal_approx(55.0, 0.0001)
    var big := _health()
    big.apply_damage(_hit(50.0))
    big.advance(6.0)
    var split := _health()
    split.apply_damage(_hit(50.0))
    for i in range(360):
        split.advance(1.0 / 60.0)
    assert_float(big.health).is_equal_approx(55.0, 0.0001)
    assert_float(split.health).is_equal_approx(55.0, 0.001)


func test_sb04_damage_restarts_wait_even_while_regenerating() -> void:
    var h := _health()
    h.apply_damage(_hit(50.0))
    h.advance(6.0)
    assert_float(h.health).is_equal_approx(55.0, 0.0001)
    h.apply_damage(_hit(5.0))
    h.advance(4.9)
    assert_float(h.health).is_equal_approx(50.0, 0.0001)
    h.advance(0.2)
    assert_float(h.health).is_equal_approx(50.5, 0.0001)


func test_sb05_regen_caps_at_max_with_large_delta() -> void:
    var h := _health()
    h.apply_damage(_hit(1.0))
    h.advance(1000.0)
    assert_float(h.health).is_equal(100.0)
    assert_bool(h.is_regenerating()).is_false()


func test_sb06_sb26_dead_never_regenerates_heals_or_revives() -> void:
    var h := _health()
    h.apply_damage(_hit(100.0))
    h.advance(1000.0)
    assert_float(h.health).is_equal(0.0)
    assert_float(h.heal(50.0)).is_equal(0.0)
    assert_bool(h.is_dead()).is_true()
    assert_bool(h.is_regenerating()).is_false()


func test_sb07_regen_neither_costs_nor_grants_energy() -> void:
    for energy_value in [0.0, 100.0, 150.0]:
        var energy_fixture := {"value": energy_value}
        var h := _health()
        h.apply_damage(_hit(50.0))
        h.advance(6.0)
        assert_float(h.health).is_equal_approx(55.0, 0.0001)
        assert_float(energy_fixture.value).is_equal(energy_value)
    var names := []
    var probe: HealthComponent = Health.new()
    for prop in probe.get_property_list():
        names.append(String(prop.name))
    probe.free()
    assert_bool(names.any(func(n: String): return n.contains("energy"))).is_false()


func test_heal_returns_only_effective_hp() -> void:
    var h := _health()
    h.apply_damage(_hit(1.0))
    assert_float(h.heal(10.0)).is_equal(1.0)
    assert_float(h.heal(10.0)).is_equal(0.0)
    for amount in [-5.0, 0.0, NAN, INF]:
        assert_float(h.heal(amount)).is_equal(0.0)
    assert_float(h.health).is_equal(100.0)


func test_contract_manual_heal_pauses_auto_regen_without_new_delay() -> void:
    var h := _health()
    var manual := ManualHealDouble.new(h)
    h.apply_damage(_hit(80.0))
    h.advance(5.0)  # delay elapsed, auto regen eligible
    manual.start()
    for i in range(60):
        h.advance(1.0 / 60.0)
        manual.tick(1.0 / 60.0)
    assert_float(h.health).is_equal_approx(45.0, 0.001)  # 20 + 25, never 20 + 30
    assert_bool(h.is_regen_paused()).is_true()
    manual.stop()
    h.advance(1.0)
    assert_float(h.health).is_equal_approx(50.0, 0.001)  # resumes at once, no new 5 s wait


func test_contract_pause_sources_are_independent() -> void:
    var h := _health()
    h.set_regen_paused(&"manual_heal", true)
    h.set_regen_paused(&"other", true)
    h.set_regen_paused(&"manual_heal", false)
    assert_bool(h.is_regen_paused()).is_true()
    h.set_regen_paused(&"other", false)
    assert_bool(h.is_regen_paused()).is_false()


func test_armor_absorbs_then_breaks_once() -> void:
    var h := _health(150.0, false)
    h.armor = 100.0
    var broken := [0]
    h.armor_broken.connect(func(): broken[0] += 1)
    assert_float(h.apply_damage(_hit(60.0))).is_equal(0.0)
    assert_float(h.armor).is_equal(40.0)
    assert_float(h.health).is_equal(150.0)
    assert_float(h.apply_damage(_hit(60.0))).is_equal(20.0)
    assert_float(h.armor).is_equal(0.0)
    assert_float(h.health).is_equal(130.0)
    h.apply_damage(_hit(10.0))
    assert_int(broken[0]).is_equal(1)


func test_partial_armor_absorption() -> void:
    var h := _health(100.0, false)
    h.armor = 50.0
    h.armor_absorption = 0.5
    assert_float(h.apply_damage(_hit(20.0))).is_equal(10.0)
    assert_float(h.armor).is_equal(40.0)


func test_vulnerability_immunity_and_invulnerable() -> void:
    var h := _health()
    h.vulnerabilities = {&"projectile": 2.0, &"melee": 0.0, &"hitscan": NAN}
    assert_float(h.apply_damage(_hit(10.0, &"projectile"))).is_equal(20.0)
    h.time_since_damage = 3.0
    assert_float(h.apply_damage(_hit(10.0, &"melee"))).is_equal(0.0)
    assert_float(h.time_since_damage).is_equal(3.0)  # immune hit does not reset the regen wait
    assert_float(h.apply_damage(_hit(10.0, &"hitscan"))).is_equal(10.0)  # invalid multiplier -> 1.0
    h.invulnerable = true
    assert_float(h.apply_damage(_hit(10.0))).is_equal(0.0)


func test_multiple_hits_same_frame_die_once() -> void:
    var h := _health()
    var deaths := [0]
    var total := [0.0]
    h.died.connect(func(): deaths[0] += 1)
    h.damaged.connect(func(_i: DamageInfo, applied: float): total[0] += applied)
    for i in range(5):
        h.apply_damage(_hit(30.0))
    assert_int(deaths[0]).is_equal(1)
    assert_float(total[0]).is_equal(100.0)
    assert_float(h.health).is_equal(0.0)


func test_damage_info_zone_copy_and_critical() -> void:
    var base := Info.create(35.0, &"hitscan")
    var head := base.for_zone(&"head", 2.0, Vector3(1, 2, 3))
    assert_float(head.scaled_amount()).is_equal(70.0)
    assert_bool(head.is_critical()).is_true()
    assert_float(base.multiplier).is_equal(1.0)
    assert_bool(base.is_critical()).is_false()
    var bad := Info.create(10.0)
    bad.multiplier = -1.0
    assert_bool(bad.is_valid()).is_false()


func test_player_health_config_resource() -> void:
    var config: HealthConfig = PLAYER_HEALTH
    assert_array(Array(config.validation_errors())).is_empty()
    assert_float(config.max_health).is_equal(100.0)
    assert_float(config.auto_regen_delay_s).is_equal(5.0)
    assert_float(config.auto_regen_hp_per_s).is_equal(5.0)
    var wrong := Config.new()
    wrong.max_health = 150.0
    assert_bool(wrong.validation_errors().is_empty()).is_false()
    wrong = Config.new()
    wrong.auto_regen_hp_per_s = NAN
    assert_bool(wrong.validation_errors().is_empty()).is_false()


func test_config_applies_on_ready() -> void:
    var h: HealthComponent = Health.new()
    h.auto_process = false
    h.config = PLAYER_HEALTH
    h.max_health = 1.0
    add_child(h)
    auto_free(h)
    assert_float(h.max_health).is_equal(100.0)
    assert_bool(h.auto_regen_enabled).is_true()
    assert_float(h.health).is_equal(100.0)
