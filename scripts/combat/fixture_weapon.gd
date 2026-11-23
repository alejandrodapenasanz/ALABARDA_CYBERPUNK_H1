class_name FixtureWeapon
extends Node3D
## H06 · Single hitscan TEST weapon to exercise the attack state machine. NOT one of the six H07
## weapons and not a final asset (primitive mesh). Damage 35 / magazine 12 are H1/H03 hypotheses.
## Animations are generated here: attack (hit frame via method track), recovery, reload.
## Reload has no approved binding (docs/CONTROLS.md): the player reloads automatically when empty.

signal fired(result: Dictionary)

@export var damage := 35.0
@export var range_m := 90.0
@export var magazine_size := 12
@export var attack_anim_s := 0.10
@export var hit_time_s := 0.03
@export var recovery_anim_s := 0.13
@export var reload_anim_s := 0.9

var animation_player: AnimationPlayer
var attack_machine: AttackStateMachine
var model: Node3D
## Origin/direction of the shot (the player camera). Falls back to this node.
var aim_node: Node3D
var exclude: Array[RID] = []
var shooter: Node = null


func _ready() -> void:
    _build_model()
    animation_player = AnimationPlayer.new()
    animation_player.name = "AnimationPlayer"
    animation_player.callback_mode_method = AnimationMixer.ANIMATION_CALLBACK_MODE_METHOD_IMMEDIATE
    add_child(animation_player)
    animation_player.add_animation_library(&"", _build_library())
    attack_machine = AttackStateMachine.new()
    attack_machine.name = "AttackStateMachine"
    attack_machine.magazine_size = magazine_size
    attack_machine.animation_player = animation_player
    add_child(attack_machine)
    attack_machine.hit_frame.connect(_on_hit_frame)


## Player intent to fire. Starts an attack if READY; reloads automatically when empty.
func trigger() -> bool:
    if attack_machine.ammo <= 0:
        attack_machine.request_reload()
        return false
    return attack_machine.request_attack()


func reload_if_empty() -> void:
    if attack_machine.ammo <= 0:
        attack_machine.request_reload()


func interrupt() -> void:
    attack_machine.interrupt()
    model.position = Vector3.ZERO


func _on_hit_frame() -> void:
    var origin: Node3D = aim_node if aim_node != null else self
    var from := origin.global_position
    var to := from - origin.global_transform.basis.z * range_m
    var info := DamageInfo.create(damage, DamageInfo.HITSCAN, shooter)
    var result := Hitscan.fire(get_world_3d().direct_space_state, from, to, info, exclude)
    fired.emit(result)


func _build_model() -> void:
    model = Node3D.new()
    model.name = "Model"
    add_child(model)
    for part in [[Vector3(0, -0.04, 0), Vector3(0.22, 0.20, 0.44), Color("202932")],
            [Vector3(0, 0.005, -0.26), Vector3(0.10, 0.10, 0.24), Color("75d6df")],
            [Vector3(-0.01, -0.20, 0.08), Vector3(0.11, 0.24, 0.12), Color("111b24")]]:
        var mesh_instance := MeshInstance3D.new()
        var box := BoxMesh.new()
        box.size = part[1]
        mesh_instance.mesh = box
        var mat := StandardMaterial3D.new()
        mat.albedo_color = part[2]
        mat.metallic = 0.35
        mesh_instance.material_override = mat
        mesh_instance.position = part[0]
        model.add_child(mesh_instance)


func _build_library() -> AnimationLibrary:
    var library := AnimationLibrary.new()
    var attack := _pose_animation(attack_anim_s, [[0.0, Vector3.ZERO], [attack_anim_s, Vector3(0, 0.03, 0.09)]])
    var hit_track := attack.add_track(Animation.TYPE_METHOD)
    attack.track_set_path(hit_track, NodePath("AttackStateMachine"))
    attack.track_insert_key(hit_track, hit_time_s, {"method": &"anim_hit_event", "args": []})
    library.add_animation(AttackStateMachine.ANIM_ATTACK, attack)
    library.add_animation(AttackStateMachine.ANIM_RECOVERY,
            _pose_animation(recovery_anim_s, [[0.0, Vector3(0, 0.03, 0.09)], [recovery_anim_s, Vector3.ZERO]]))
    library.add_animation(AttackStateMachine.ANIM_RELOAD,
            _pose_animation(reload_anim_s, [[0.0, Vector3.ZERO], [reload_anim_s * 0.5, Vector3(0, -0.25, 0.05)],
                    [reload_anim_s, Vector3.ZERO]]))
    return library


func _pose_animation(length: float, keys: Array) -> Animation:
    var animation := Animation.new()
    animation.length = length
    animation.loop_mode = Animation.LOOP_NONE
    var track := animation.add_track(Animation.TYPE_VALUE)
    animation.track_set_path(track, NodePath("Model:position"))
    for key in keys:
        animation.track_insert_key(track, key[0], key[1])
    return animation
