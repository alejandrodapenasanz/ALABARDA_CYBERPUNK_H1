extends SceneTree
## Capturas originales de tres luces, tiempos wall-clock y comparación repetida.
const LAB = preload("res://scenes/art_reference/modern_psx_lab.tscn")
const WARMUP := 60
const SAMPLES := 180

func _initialize() -> void:
    call_deferred("_run")

func _run() -> void:
    if DisplayServer.get_name() == "headless":
        print("BLOCKED: real graphics window required")
        quit(2)
        return
    var output := ""
    for arg in OS.get_cmdline_user_args():
        if arg.begins_with("--output="):
            output = arg.trim_prefix("--output=")
    if output.is_empty():
        quit(2)
        return
    DirAccess.make_dir_recursive_absolute(output)
    DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
    Engine.max_fps = 0
    var lab = LAB.instantiate()
    root.add_child(lab)
    current_scene = lab
    var results := []
    var images: Array[Image] = []
    var failures: Array[String] = []
    for variant in ["atmospheric", "neutral", "alarm", "no_shadows", "atmospheric_repeat"]:
        lab.reset_view()
        if variant == "neutral" or variant == "alarm":
            lab.cycle_lighting()
        if variant == "alarm":
            lab.cycle_lighting()
        if variant == "no_shadows":
            lab.toggle("shadows")
        for frame in range(WARMUP):
            await RenderingServer.frame_post_draw
        var previous := Time.get_ticks_usec()
        var timings: Array[float] = []
        for frame in range(SAMPLES):
            await RenderingServer.frame_post_draw
            var now := Time.get_ticks_usec()
            timings.append(float(now - previous) / 1000.0)
            previous = now
        var snapshot: Image = lab.viewport.get_texture().get_image()
        if snapshot.is_empty() or snapshot.save_png(output.path_join(variant + "_3d.png")) != OK:
            failures.append("Missing 3D capture " + variant)
        if variant in ["atmospheric", "neutral", "alarm"]:
            images.append(snapshot)
        var sorted := timings.duplicate()
        sorted.sort()
        var mean := 0.0
        for timing in timings:
            mean += timing / float(SAMPLES)
        results.append({"variant": variant, "config": lab.capture_config(), "mean_ms": mean, "p50_ms": sorted[90], "p95_ms": sorted[171], "draw_calls": Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME), "primitives": Performance.get_monitor(Performance.RENDER_TOTAL_PRIMITIVES_IN_FRAME), "window_focused": root.has_focus(), "samples_ms": timings})
        if variant in ["atmospheric", "neutral", "alarm"]:
            for camera_index in range(4):
                lab.set_camera(camera_index)
                for frame in range(24):
                    await RenderingServer.frame_post_draw
                if root.get_texture().get_image().save_png(output.path_join("%s_camera_%d.png" % [variant, camera_index + 1])) != OK:
                    failures.append("Capture write failed")
        print("H04_GRAPHICS ", variant, " mean_ms=", mean)
    var differences := []
    for index in [1, 2]:
        var difference := 0.0
        for y in range(0, 720, 8):
            for x in range(0, 1280, 8):
                var a := images[0].get_pixel(x, y)
                var b := images[index].get_pixel(x, y)
                difference += absf(a.r - b.r) + absf(a.g - b.g) + absf(a.b - b.b)
        difference /= 160 * 90 * 3
        differences.append(difference)
        if difference <= .01:
            failures.append("Light condition did not change rendered pixels")
    var report := {"status": "PASS" if failures.is_empty() else "FAIL", "failures": failures, "godot": Engine.get_version_info(), "gpu": RenderingServer.get_video_adapter_name(), "cpu": OS.get_processor_name(), "api": RenderingServer.get_video_adapter_api_version(), "renderer": RenderingServer.get_current_rendering_method(), "vsync": DisplayServer.window_get_vsync_mode(), "warmup": WARMUP, "samples": SAMPLES, "runs": results, "lighting_mean_differences_0_1": differences, "limits": "Wall-clock between frame_post_draw, not GPU-only; brief scene without combat. No FPS target or human approval inferred. Unedited captures."}
    var file := FileAccess.open(output.path_join("metrics.json"), FileAccess.WRITE)
    file.store_string(JSON.stringify(report, "  "))
    lab.queue_free()
    await process_frame
    quit(0 if failures.is_empty() else 1)
