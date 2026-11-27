extends GdUnitTestSuite
## The configured F5 scene must use the same approved core as all gameplay regressions.

const World = preload("res://tests/gameplay/support/test_world.gd")
const Main = preload("res://scripts/main.gd")

var game: Main


func before_test() -> void:
    World.release_all()
    var scene: PackedScene = load(ProjectSettings.get_setting("application/run/main_scene"))
    game = auto_free(scene.instantiate())
    game.capture_mouse_on_start = false
    add_child(game)
    for frame in range(15):
        await get_tree().physics_frame


func after_test() -> void:
    World.release_all()


func test_default_scene_uses_shared_player_and_interaction() -> void:
    assert_str(game.scene_file_path).is_equal("res://scenes/main.tscn")
    assert_bool(game.player is PlayerController).is_true()
    assert_int(get_tree().get_nodes_in_group("player").size()).is_equal(1)
    game.player.global_position = Vector3(-4, 0.91, 6)
    game.player.look(Vector2.ZERO)
    for frame in range(3):
        await get_tree().physics_frame
    assert_bool(game.player.try_interact()).is_true()
    assert_bool(game.console.is_on).is_true()
    assert_int(game.console.interaction_count).is_equal(1)


func test_default_scene_health_damage_and_regen_update_hud() -> void:
    game.player.health.auto_process = false
    game.player.take_damage(30)
    assert_float(game.health_bar.value).is_equal(70.0)
    assert_str(game.health_label.text).is_equal("SALUD  70 / 100")
    game.player.health.advance(5.0)
    game.player.health.advance(6.0)
    assert_float(game.health_bar.value).is_equal(100.0)
    assert_str(game.health_label.text).is_equal("SALUD  100 / 100")


func test_default_scene_shot_reaches_target_and_updates_feedback() -> void:
    var targets: Array[TargetDummy] = []
    for child in game.get_children():
        if child is TargetDummy:
            targets.append(child)
    assert_int(targets.size()).is_equal(3)
    var target := targets[0]
    game.player.global_position = target.global_position + Vector3(0, 0.91, 4)
    game.player.camera.look_at(target.global_position + Vector3(0, 0.8, 0))
    for frame in range(2):
        await get_tree().physics_frame
    game.player.weapon.animation_player.callback_mode_process = AnimationMixer.ANIMATION_CALLBACK_MODE_PROCESS_MANUAL
    assert_bool(game.player.fire()).is_true()
    game.player.weapon.animation_player.advance(0.05)
    assert_float(target.health.health).is_equal(target.max_health - game.player.weapon.damage)
    assert_str(game.hud_feedback.text).contains("IMPACTO CUERPO")
    assert_float(game.player.health.health).is_equal(100.0)
