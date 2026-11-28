extends CharacterBody3D

signal health_changed(current: float, maximum: float)
signal shot_fired(hit: bool)
signal died

@export var mouse_sensitivity := 0.0024
@export var move_speed := 8.5
@export var sprint_speed := 12.5
@export var dash_speed := 22.0
@export var jump_velocity := 6.0
@export var gravity := 22.0
@export var max_health := 100.0

var health := 100.0
var dash_time := 0.0
var dash_cooldown := 0.0
var dash_vector := Vector3.ZERO
var fire_cooldown := 0.0
var spawn_position := Vector3.ZERO
var pitch := 0.0
var camera: Camera3D
var gun: Node3D
var gun_rest_position := Vector3.ZERO
var recoil := 0.0

func _ready() -> void:
    name = "Player"
    add_to_group("player")
    spawn_position = global_position
    health = max_health
    var capsule := CapsuleShape3D.new()
    capsule.radius = 0.35
    capsule.height = 1.8
    var collider := CollisionShape3D.new()
    collider.shape = capsule
    add_child(collider)
    camera = Camera3D.new()
    camera.position = Vector3(0, 0.65, 0)
    camera.current = true
    add_child(camera)
    var ray := RayCast3D.new()
    ray.name = "WeaponRay"
    ray.target_position = Vector3(0, 0, -90)
    ray.enabled = true
    camera.add_child(ray)
    gun = Node3D.new()
    gun.position = Vector3(0.32, -0.28, -0.55)
    camera.add_child(gun)
    gun_rest_position = gun.position
    _add_gun_mesh(Vector3(0, -0.04, 0), Vector3(0.22, 0.20, 0.44), Color("202932"))
    _add_gun_mesh(Vector3(0, 0.005, -0.26), Vector3(0.10, 0.10, 0.24), Color("75d6df"))
    _add_gun_mesh(Vector3(-0.01, -0.20, 0.08), Vector3(0.11, 0.24, 0.12), Color("111b24"))
    Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
    health_changed.emit(health, max_health)

func _add_gun_mesh(offset: Vector3, size: Vector3, tint: Color) -> void:
    var mesh_instance := MeshInstance3D.new()
    var mesh := BoxMesh.new()
    mesh.size = size
    mesh_instance.mesh = mesh
    var mat := StandardMaterial3D.new()
    mat.albedo_color = tint
    mat.metallic = 0.35
    mesh_instance.material_override = mat
    mesh_instance.position = offset
    gun.add_child(mesh_instance)

func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
        rotate_y(-event.relative.x * mouse_sensitivity)
        pitch = clamp(pitch - event.relative.y * mouse_sensitivity, -1.45, 1.45)
        camera.rotation.x = pitch
    if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
        Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
    if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
        Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
    dash_cooldown = maxf(0.0, dash_cooldown - delta)
    dash_time = maxf(0.0, dash_time - delta)
    fire_cooldown = maxf(0.0, fire_cooldown - delta)
    recoil = move_toward(recoil, 0.0, delta * 3.0)
    gun.position = gun_rest_position + Vector3(0, recoil * 0.35, recoil)
    if not is_on_floor():
        velocity.y -= gravity * delta
    elif Input.is_key_pressed(KEY_SPACE):
        velocity.y = jump_velocity
    var input_dir := Vector2.ZERO
    if Input.is_key_pressed(KEY_W): input_dir.y -= 1.0
    if Input.is_key_pressed(KEY_S): input_dir.y += 1.0
    if Input.is_key_pressed(KEY_A): input_dir.x -= 1.0
    if Input.is_key_pressed(KEY_D): input_dir.x += 1.0
    input_dir = input_dir.normalized()
    var direction := (global_transform.basis * Vector3(input_dir.x, 0.0, input_dir.y)).normalized()
    var speed := sprint_speed if Input.is_key_pressed(KEY_SHIFT) else move_speed
    if Input.is_key_pressed(KEY_Q) and dash_cooldown <= 0.0 and input_dir != Vector2.ZERO:
        dash_vector = direction
        dash_time = 0.16
        dash_cooldown = 1.0
    if dash_time > 0.0:
        velocity.x = dash_vector.x * dash_speed
        velocity.z = dash_vector.z * dash_speed
    else:
        velocity.x = move_toward(velocity.x, direction.x * speed, delta * 55.0)
        velocity.z = move_toward(velocity.z, direction.z * speed, delta * 55.0)
    move_and_slide()
    if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED and fire_cooldown <= 0.0:
        _shoot()

func _shoot() -> void:
    fire_cooldown = 0.23  # Provisional: representa la duración de la animación de recuperación.
    recoil = 0.095
    var ray: RayCast3D = camera.get_node("WeaponRay")
    ray.force_raycast_update()
    var hit := false
    if ray.is_colliding():
        var target := ray.get_collider()
        if target != null and target.has_method("take_damage"):
            target.take_damage(35.0)
            hit = true
    shot_fired.emit(hit)

func take_damage(amount: float) -> void:
    if not is_finite(amount) or amount <= 0.0:
        return
    health = clampf(health - amount, 0.0, max_health)
    health_changed.emit(health, max_health)
    if health <= 0.0:
        died.emit()
        global_position = spawn_position
        velocity = Vector3.ZERO
        health = max_health
        health_changed.emit(health, max_health)
