extends SceneTree

func _initialize() -> void:
    call_deferred("_run")

func _run() -> void:
    var lab = load("res://scenes/art_reference/modern_psx_lab.tscn").instantiate()
    root.add_child(lab)
    var arms: Node3D = lab.world.find_child("FPSArmsSample", true, false)
    var animation: AnimationPlayer = lab.world.arms_animation
    for pose in ["rest", "guard_idle", "finger_gun_idle", "knife_idle"]:
        animation.play(pose)
        animation.seek(0.1, true)
        animation.pause()
        for turn in [0, 1]:
            arms.rotation.y = PI * turn
            for i in range(15): await RenderingServer.frame_post_draw
            root.get_texture().get_image().save_png("res://docs/evidence/h03/arms_%s_%d.png" % [pose, turn])
    lab.queue_free()
    await process_frame
    quit()
