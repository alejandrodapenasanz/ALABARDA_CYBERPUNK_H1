extends SceneTree
## Ventana real: capturas y tiempo entre frames renderizados, nunca benchmark headless.

const LAB = preload("res://scenes/art_reference/modern_psx_lab.tscn")
const WARMUP_FRAMES := 60
const SAMPLE_FRAMES := 180

func _initialize() -> void:
    call_deferred("_run")

func _run() -> void:
    if DisplayServer.get_name() == "headless":
        print("BLOCKED: graphics measurement requires a real window")
        quit(2)
        return
    var output := ""
    for arg in OS.get_cmdline_user_args():
        if arg.begins_with("--output="):
            output = arg.trim_prefix("--output=")
    if output.is_empty():
        push_error("--output required")
        quit(2)
        return
    DirAccess.make_dir_recursive_absolute(output)
    DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
    Engine.max_fps = 0
    var lab = LAB.instantiate()
    root.add_child(lab)
    current_scene = lab
    var report := {"godot": Engine.get_version_info(), "os": OS.get_name(), "cpu": OS.get_processor_name(), "gpu": RenderingServer.get_video_adapter_name(), "vendor": RenderingServer.get_video_adapter_vendor(), "api": RenderingServer.get_video_adapter_api_version(), "renderer": RenderingServer.get_current_rendering_method(), "display": DisplayServer.get_name(), "vsync": DisplayServer.window_get_vsync_mode(), "warmup_frames": WARMUP_FRAMES, "sample_frames": SAMPLE_FRAMES, "metric": "Wall-clock milliseconds between frame_post_draw; includes CPU/GPU/OS, not GPU-only timing", "runs": []}
    var base := {"nearest": true, "atmospheric": false, "half_resolution": false, "retro": false, "shadows": true, "fog": false}
    for variant in ["native_nearest", "native_linear", "atmospheric", "half_resolution", "subtle_retro", "no_shadows", "fog"]:
        lab.options = base.duplicate()
        if variant == "native_linear": lab.options.nearest = false
        if variant == "atmospheric": lab.options.atmospheric = true
        if variant == "half_resolution": lab.options.half_resolution = true
        if variant == "subtle_retro": lab.options.retro = true
        if variant == "no_shadows": lab.options.shadows = false
        if variant == "fog": lab.options.fog = true
        lab.set_camera(0)
        lab.apply_options()
        for frame in range(WARMUP_FRAMES):
            await RenderingServer.frame_post_draw
        var timings: Array[float] = []
        var previous := Time.get_ticks_usec()
        for frame in range(SAMPLE_FRAMES):
            await RenderingServer.frame_post_draw
            var now := Time.get_ticks_usec()
            timings.append(float(now - previous) / 1000.0)
            previous = now
        var draw_calls := Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME)
        var primitives := Performance.get_monitor(Performance.RENDER_TOTAL_PRIMITIVES_IN_FRAME)
        var snapshot: Image = root.get_texture().get_image()
        if snapshot.is_empty() or snapshot.save_png(output.path_join(variant + ".png")) != OK:
            push_error("Cannot save real screenshot")
            quit(1)
            return
        var sorted := timings.duplicate()
        sorted.sort()
        var average := 0.0
        for timing in timings: average += timing / float(SAMPLE_FRAMES)
        report.runs.append({"variant": variant, "config": lab.capture_config(), "mean_ms": average, "p50_ms": sorted[int(SAMPLE_FRAMES * 0.5)], "p95_ms": sorted[int(SAMPLE_FRAMES * 0.95)], "p99_ms": sorted[int(SAMPLE_FRAMES * 0.99)], "draw_calls": draw_calls, "primitives": primitives, "samples_ms": timings})
        print("GRAPHICS ", variant, " mean_ms=", average)
    # Comparación de texto nativa en tamaño menor; el HUD no se reduce con el viewport 3D.
    for output_size in [Vector2i(1280, 720), Vector2i(960, 540)]:
        DisplayServer.window_set_size(output_size)
        lab.options = base.duplicate()
        lab.set_camera(1)
        lab.apply_options()
        for frame in range(30): await RenderingServer.frame_post_draw
        var filename := "font_crt_%dx%d.png" % [output_size.x, output_size.y]
        var snapshot: Image = root.get_texture().get_image()
        snapshot.save_png(output.path_join(filename))
    DisplayServer.window_set_size(Vector2i(1280, 720))
    lab.set_camera(3)
    lab.comparison_panel.visible = false
    for frame in range(30): await RenderingServer.frame_post_draw
    root.get_texture().get_image().save_png(output.path_join("arms_rig.png"))
    var file := FileAccess.open(output.path_join("metrics.json"), FileAccess.WRITE)
    file.store_string(JSON.stringify(report, "  "))
    print("GRAPHICS_COMPLETE ", output)
    lab.queue_free()
    await process_frame
    quit(0)
