extends GdUnitTestSuite
## H06 · Hitboxes/headshot, hitscan and projectile damage, attack state machine driven by animation,
## and player death/regen integration. Requires Godot (headless). Animations are advanced manually.

const World = preload("res://tests/b1/support/test_world.gd")
const Weapon = preload("res://scripts/combat/fixture_weapon.gd")

var world: World


func before_test() -> void:
    World.release_all()
    world = auto_free(World.new())
    add_child(world)
    world.add_floor()
    await _frames(2)


func after_test() -> void:
    World.release_all()


func _frames(count: int) -> void:
    for i in range(count):
        await get_tree().physics_frame


func _dummy(pos: Vector3, max_hp: float = 200.0, armor: float = 0.0) -> TargetDummy:
    var dummy := TargetDummy.new()
    dummy.max_health = max_hp
    dummy.armor = armor
    world.add_child(dummy)
    dummy.global_position = pos
    return dummy


func _space() -> PhysicsDirectSpaceState3D:
    return world.get_world_3d().direct_space_state


func _manual(weapon: FixtureWeapon) -> void:
    weapon.animation_player.callback_mode_process = AnimationMixer.ANIMATION_CALLBACK_MODE_PROCESS_MANUAL


func _advance(weapon: FixtureWeapon, seconds: float) -> void:
    var step := 1.0 / 120.0
    var elapsed := 0.0
    while elapsed < seconds - 0.00001:
        weapon.animation_player.advance(step)
        elapsed += step
        await get_tree().process_frame


func test_hitscan_head_and_body_zones() -> void:
    var dummy := _dummy(Vector3(0, 0, -5))
    await _frames(2)
    var head := Hitscan.fire(_space(), Vector3(0, 1.72, 0), Vector3(0, 1.72, -20), DamageInfo.create(35.0))
    assert_bool(head.hit).is_true()
    assert_str(String(head.zone)).is_equal("head")
    assert_float(head.applied).is_equal(70.0)
    var body := Hitscan.fire(_space(), Vector3(0, 0.8, 0), Vector3(0, 0.8, -20), DamageInfo.create(35.0))
    assert_str(String(body.zone)).is_equal("body")
    assert_float(body.applied).is_equal(35.0)
    assert_float(dummy.health.health).is_equal(95.0)


func test_hitscan_blocked_by_wall() -> void:
    var dummy := _dummy(Vector3(0, 0, -6))
    var wall := world.add_block(Vector3(0, 1.5, -3), Vector3(4, 3, 0.3))
    await _frames(2)
    var result := Hitscan.fire(_space(), Vector3(0, 1.0, 0), Vector3(0, 1.0, -20), DamageInfo.create(35.0))
    assert_object(result.collider).is_same(wall)
    assert_float(result.applied).is_equal(0.0)
    assert_float(dummy.health.health).is_equal(200.0)


func test_armored_target_and_dead_target_hitboxes_disabled() -> void:
    var dummy := _dummy(Vector3(0, 0, -5), 60.0, 30.0)
    await _frames(2)
    Hitscan.fire(_space(), Vector3(0, 0.8, 0), Vector3(0, 0.8, -20), DamageInfo.create(35.0))
    assert_float(dummy.health.armor).is_equal(0.0)
    assert_float(dummy.health.health).is_equal(55.0)
    Hitscan.fire(_space(), Vector3(0, 0.8, 0), Vector3(0, 0.8, -20), DamageInfo.create(100.0))
    assert_bool(dummy.health.is_dead()).is_true()
    await _frames(2)
    var after := Hitscan.fire(_space(), Vector3(0, 0.8, 0), Vector3(0, 0.8, -20), DamageInfo.create(35.0))
    assert_float(after.applied).is_equal(0.0)


func test_projectile_hits_hitbox_once_and_frees() -> void:
    var dummy := _dummy(Vector3(0, 0, -8))
    await _frames(2)
    var shot := DamageProjectile.new()
    world.add_child(shot)
    var impacts := [0]
    shot.impacted.connect(func(_c: Object, _a: float): impacts[0] += 1)
    shot.launch(Vector3(0, 0.8, 0), Vector3(0, 0, -1), DamageInfo.create(8.0, DamageInfo.PROJECTILE))
    for i in range(40):
        if not is_instance_valid(shot):
            break
        shot.step(1.0 / 60.0)
    assert_float(dummy.health.health).is_equal(192.0)
    assert_int(impacts[0]).is_equal(1)


func test_fast_projectile_does_not_tunnel_through_thin_wall() -> void:
    var dummy := _dummy(Vector3(0, 0, -8))
    world.add_block(Vector3(0, 1.5, -4), Vector3(4, 3, 0.05))
    await _frames(2)
    var shot := DamageProjectile.new()
    shot.speed_mps = 600.0
    world.add_child(shot)
    shot.launch(Vector3(0, 0.8, 0), Vector3(0, 0, -1), DamageInfo.create(8.0, DamageInfo.PROJECTILE))
    shot.step(1.0 / 30.0)  # one step spans 20 m, crossing wall and target
    assert_bool(shot.finished).is_true()
    assert_float(dummy.health.health).is_equal(200.0)


func test_projectile_expires_after_lifetime() -> void:
    var shot := DamageProjectile.new()
    shot.lifetime_s = 0.5
    world.add_child(shot)
    shot.launch(Vector3(0, 5, 0), Vector3(0, 1, 0), DamageInfo.create(8.0, DamageInfo.PROJECTILE))
    for i in range(40):
        shot.step(1.0 / 60.0)
    assert_bool(shot.finished).is_true()


func _weapon_at_origin() -> FixtureWeapon:
    var weapon: FixtureWeapon = Weapon.new()
    world.add_child(weapon)
    weapon.global_position = Vector3(0, 1.0, 0)
    _manual(weapon)
    return weapon


func test_attack_cycle_is_driven_by_animation() -> void:
    var weapon := _weapon_at_origin()
    var machine := weapon.attack_machine
    var hits := [0]
    machine.hit_frame.connect(func(): hits[0] += 1)
    assert_int(machine.state).is_equal(AttackStateMachine.State.READY)
    assert_bool(weapon.trigger()).is_true()
    assert_int(machine.state).is_equal(AttackStateMachine.State.ATTACK)
    assert_bool(machine.request_attack()).is_false()
    await _advance(weapon, 0.05)
    assert_int(hits[0]).is_equal(1)
    await _advance(weapon, 0.07)
    assert_int(machine.state).is_equal(AttackStateMachine.State.RECOVERY)
    assert_bool(machine.request_attack()).is_false()  # no attack during RECOVERY
    await _advance(weapon, 0.15)
    assert_int(machine.state).is_equal(AttackStateMachine.State.READY)
    assert_int(hits[0]).is_equal(1)
    assert_int(machine.ammo).is_equal(11)


func test_no_cadence_without_animation_progress() -> void:
    var weapon := _weapon_at_origin()
    weapon.trigger()
    for i in range(30):
        await get_tree().process_frame  # manual mode: time alone never advances the state
    assert_int(weapon.attack_machine.state).is_equal(AttackStateMachine.State.ATTACK)


func test_empty_magazine_reloads_by_animation() -> void:
    var weapon := _weapon_at_origin()
    var machine := weapon.attack_machine
    var reloads := [0]
    machine.reloaded.connect(func(): reloads[0] += 1)
    machine.ammo = 0
    assert_bool(weapon.trigger()).is_false()
    assert_int(machine.state).is_equal(AttackStateMachine.State.RELOAD)
    assert_bool(machine.request_attack()).is_false()
    await _advance(weapon, 0.95)
    assert_int(machine.state).is_equal(AttackStateMachine.State.READY)
    assert_int(machine.ammo).is_equal(machine.magazine_size)
    assert_int(reloads[0]).is_equal(1)
    assert_bool(machine.request_reload()).is_false()  # already full


func test_interrupt_cancels_attack_without_hit() -> void:
    var weapon := _weapon_at_origin()
    var hits := [0]
    weapon.attack_machine.hit_frame.connect(func(): hits[0] += 1)
    weapon.trigger()
    await _advance(weapon, 0.01)
    weapon.interrupt()
    await _advance(weapon, 0.3)
    assert_int(hits[0]).is_equal(0)
    assert_int(weapon.attack_machine.state).is_equal(AttackStateMachine.State.READY)


func test_weapon_hit_frame_fires_hitscan() -> void:
    var dummy := _dummy(Vector3(0, 0, -6))
    var weapon := _weapon_at_origin()
    weapon.global_position = Vector3(0, 0.8, 0)
    await _frames(2)
    var results := []
    weapon.fired.connect(func(r: Dictionary): results.append(r))
    weapon.trigger()
    await _advance(weapon, 0.05)
    assert_int(results.size()).is_equal(1)
    assert_float(dummy.health.health).is_equal(165.0)


func test_player_fire_damages_target_but_never_itself() -> void:
    var dummy := _dummy(Vector3(0, 0, -6))
    var player := world.spawn_player(Vector3(0, 1.0, 0))
    await _frames(15)
    _manual(player.weapon)
    assert_bool(player.fire()).is_true()
    await _advance(player.weapon, 0.05)
    assert_float(dummy.health.health).is_less(200.0)
    assert_float(player.health.health).is_equal(100.0)


func test_player_regen_and_projectile_damage() -> void:
    var player := world.spawn_player(Vector3(0, 1.0, 0))
    player.health.auto_process = false
    await _frames(15)
    var shot := DamageProjectile.new()
    world.add_child(shot)
    shot.launch(Vector3(0, 1.0, -6), Vector3(0, 0, 1), DamageInfo.create(30.0, DamageInfo.PROJECTILE))
    for i in range(60):
        if not is_instance_valid(shot):
            break
        shot.step(1.0 / 60.0)
    assert_float(player.health.health).is_equal(70.0)
    player.health.advance(5.0)
    player.health.advance(1.0)
    assert_float(player.health.health).is_equal_approx(75.0, 0.0001)


func test_player_death_is_single_and_disables_control() -> void:
    var player := world.spawn_player(Vector3(0, 1.0, 0))
    await _frames(15)
    var deaths := [0]
    player.died.connect(func(): deaths[0] += 1)
    player.take_damage(60.0)
    player.take_damage(60.0)
    player.take_damage(60.0)
    assert_int(deaths[0]).is_equal(1)
    assert_bool(player.is_dead()).is_true()
    assert_int(player.move_state).is_equal(B1Player.MoveState.DISABLED)
    assert_bool(player.fire()).is_false()
    assert_bool(player.try_interact()).is_false()
    player.set_disabled(false)
    assert_int(player.move_state).is_equal(B1Player.MoveState.DISABLED)
    player.health.advance(100.0)
    assert_float(player.health.health).is_equal(0.0)
