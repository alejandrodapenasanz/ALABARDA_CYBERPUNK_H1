extends SceneTree
## Auditoría del H1 real. No cambia los scripts ni instala un framework.

var passed := 0
var failed := 0
var game
var player
var hits := 0
var misses := 0
var deaths := 0
var not_run := 0

func _initialize() -> void:
    call_deferred("_run")

func check(condition: bool, label: String) -> void:
    if condition:
        passed += 1
        print("PASS ", label)
    else:
        failed += 1
        print("FAIL ", label)

func frames(count: int) -> void:
    for i in range(count):
        await physics_frame
        await process_frame

func key(code: Key, pressed: bool) -> void:
    var event := InputEventKey.new()
    event.keycode = code
    event.pressed = pressed
    Input.parse_input_event(event)

func button(pressed: bool) -> void:
    var event := InputEventMouseButton.new()
    event.button_index = MOUSE_BUTTON_LEFT
    event.pressed = pressed
    Input.parse_input_event(event)

func shoot() -> void:
    if DisplayServer.get_name() == "headless":
        player._shoot()
    else:
        button(true)
        await frames(1)
        button(false)

func freeze_enemies() -> void:
    for enemy in get_nodes_in_group("enemies"):
        enemy.set_process(false)

func aim(enemy) -> void:
    player.global_position = enemy.global_position + Vector3(0, 0.91, 2.5)
    player.velocity = Vector3.ZERO
    player.camera.look_at(enemy.global_position + Vector3(0, 0.9, 0), Vector3.UP)

func _run() -> void:
    game = load("res://scenes/main.tscn").instantiate()
    root.add_child(game)
    current_scene = game
    player = game.player
    print("MOUSE display=%s initial_mode=%s" % [DisplayServer.get_name(), Input.mouse_mode])
    freeze_enemies()
    player.shot_fired.connect(func(hit: bool):
        if hit: hits += 1
        else: misses += 1)
    player.died.connect(func(): deaths += 1)
    await frames(30)
    check(game.enemies_left == 5 and get_nodes_in_group("enemies").size() == 5, "cinco blancos reales")
    check(player.health == 100 and player.camera.current, "salud y cámara inicial")
    check(player.is_on_floor(), "jugador colisiona con suelo")
    var start: Vector3 = player.position
    key(KEY_W, true)
    await frames(18)
    key(KEY_W, false)
    check(player.position.z < start.z - 1, "W mueve jugador mediante input real")
    key(KEY_W, true)
    key(KEY_SHIFT, true)
    await frames(20)
    check(absf(player.velocity.z) > player.move_speed, "sprint supera marcha")
    key(KEY_Q, true)
    await frames(2)
    check(player.dash_time > 0 and player.dash_cooldown > 0, "dash y cooldown")
    key(KEY_Q, false)
    key(KEY_W, false)
    key(KEY_SHIFT, false)
    await frames(25)
    key(KEY_SPACE, true)
    await frames(2)
    key(KEY_SPACE, false)
    check(player.velocity.y > 0, "salto desde suelo")
    await frames(50)
    player.global_position = Vector3(0, 0.91, 14)
    player.velocity = Vector3.ZERO
    key(KEY_S, true)
    key(KEY_Q, true)
    await frames(25)
    key(KEY_S, false)
    key(KEY_Q, false)
    check(player.position.z < 15.5, "pared bloquea movimiento/dash")
    key(KEY_ESCAPE, true)
    key(KEY_ESCAPE, false)
    await frames(2)
    if DisplayServer.get_name() != "headless":
        check(Input.mouse_mode == Input.MOUSE_MODE_VISIBLE, "Escape libera cursor")
    button(true)
    await frames(1)
    button(false)
    if DisplayServer.get_name() == "headless":
        not_run += 1
        print("NOT_RUN cursor/clic E2E: DisplayServer headless mantiene mouse_mode=0; hitscan vía _shoot real")
    else:
        check(Input.mouse_mode == Input.MOUSE_MODE_CAPTURED, "clic recaptura cursor")
    player.camera.rotation = Vector3.ZERO
    player.global_position = Vector3(0, 0.91, 9)
    await frames(18)
    player.take_damage(7)
    check(player.health == 93 and "093" in game.hud_health.text, "daño y HUD conectado")
    player.take_damage(1000)
    check(deaths == 1 and player.health == 100 and player.position == player.spawn_position, "muerte y respawn H1")
    var foe = get_nodes_in_group("enemies")[0]
    foe.time_until_attack = 0
    player.global_position = foe.global_position + Vector3(0, 1, 1)
    foe._process(0.1)
    check(player.health == 88, "ataque cercano existente")
    player.health = 100
    player.global_position = Vector3(0, 1, 15)
    foe.time_until_attack = 0
    foe._process(0.1)
    check(player.health == 100, "fuera de rango no daña")
    key(KEY_R, true)
    await frames(2)
    key(KEY_R, false)
    check(game.enemies_left == 5, "R no reinicia durante combate")
    var required_shots := 0
    for enemy in get_nodes_in_group("enemies"):
        var shots := int(ceil(float(enemy.health) / 35.0))
        required_shots += shots
        aim(enemy)
        await frames(16)
        for n in range(shots):
            await shoot()
            check(player.fire_cooldown > 0, "disparo establece recuperación")
            await frames(16)
    check(hits == required_shots, "hitscan real: ocho impactos contra HP 35/70")
    check(game.enemies_left == 0 and get_nodes_in_group("enemies").is_empty(), "derrota de cinco blancos y señales")
    check("00" in game.hud_enemies.text, "HUD cero hostiles")
    key(KEY_R, true)
    await frames(2)
    key(KEY_R, false)
    freeze_enemies()
    check(game.enemies_left == 5 and get_nodes_in_group("enemies").size() == 5, "R restaura cinco blancos tras victoria")
    if "--edges" in OS.get_cmdline_user_args():
        await edge_cases()
    for code in [KEY_W, KEY_A, KEY_S, KEY_D, KEY_SHIFT, KEY_Q, KEY_SPACE, KEY_R, KEY_ESCAPE]:
        key(code, false)
    button(false)
    Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
    game.queue_free()
    await frames(2)
    print("RESULT passed=%d failed=%d not_run=%d" % [passed, failed, not_run])
    quit(1 if failed else 0)

func edge_cases() -> void:
    player.health = player.max_health
    player.take_damage(-10)
    check(player.health <= player.max_health, "EDGE daño negativo no supera HP máximo")
    player.take_damage(7)
    for invalid in [-10.0, 0.0, NAN, INF, -INF]:
        player.take_damage(invalid)
    check(player.health == 93, "EDGE daño inválido no cura, mata ni contamina HP de jugador herido")
    player.health = player.max_health
    var enemy = get_nodes_in_group("enemies")[0]
    var enemy_health: float = enemy.health
    for invalid in [-10.0, 0.0, NAN, INF, -INF]:
        enemy.take_damage(invalid)
    check(enemy.health == enemy_health, "EDGE daño inválido no altera salud del enemigo")
    var before: int = game.enemies_left
    enemy.eliminated.connect(func(target): target.take_damage(1000))
    enemy.take_damage(1000)
    enemy.take_damage(1000)
    check(game.enemies_left == before - 1, "EDGE eliminación emite una sola vez antes de queue_free")
    check(enemy.health == 0, "EDGE daño letal limita HP a cero")
    enemy.time_until_attack = 0
    player.global_position = enemy.global_position + Vector3(0, 1, 1)
    enemy._process(0.1)
    check(player.health == player.max_health, "EDGE enemigo derrotado no ataca en frame pendiente")
    await frames(2)
    game._setup_enemies()
    freeze_enemies()
    await frames(2)
    var targets = get_nodes_in_group("enemies")
    for i in range(targets.size() - 1):
        targets[i].take_damage(1000)
    await frames(2)
    var last = get_nodes_in_group("enemies")[0]
    last.health = 35
    aim(last)
    await frames(16)
    await shoot()
    check("CONTRATO COMPLETADO" in game.hud_feedback.text, "EDGE mensaje victoria sobrevive al último shot_fired")
    await frames(20)
    check("CONTRATO COMPLETADO" in game.hud_feedback.text, "EDGE victoria persiste tras expirar feedback de impacto")
    key(KEY_R, true)
    await frames(2)
    key(KEY_R, false)
    freeze_enemies()
    check(game.enemies_left == 5 and game.hud_feedback.text == "", "EDGE reinicio limpia victoria anterior")
