extends SceneTree
## Regresión gráfica del informe humano: efecto visible, UI fuera de escena y cuatro vistas.
const LAB = preload("res://scenes/art_reference/modern_psx_lab.tscn")
var failures: Array[String] = []

func _initialize() -> void:
    call_deferred("_run")

func _run() -> void:
    if DisplayServer.get_name() == "headless":
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
    var lab = LAB.instantiate()
    root.add_child(lab)
    current_scene = lab
    await _settle()
    for index in range(4):
        lab.set_camera(index)
        await _settle()
        _save(output, "camera_%d.png" % (index + 1))
    lab.set_camera(0)
    await _settle()
    var before: Image = root.get_texture().get_image()
    lab.toggle("retro")
    await _settle()
    var after: Image = root.get_texture().get_image()
    _save(output, "retro_on.png")
    # Centro de la vista 3D, excluyendo controles, texto y letterbox.
    var rect: Rect2 = lab.stage.get_global_rect()
    var roi := Rect2i(Vector2i(rect.position + rect.size * 0.25), Vector2i(rect.size * 0.5))
    var changed := 0
    var mean_difference := 0.0
    var count := 0
    for y in range(roi.position.y, roi.end.y):
        for x in range(roi.position.x, roi.end.x):
            var a := before.get_pixel(x, y)
            var b := after.get_pixel(x, y)
            var difference := (absf(a.r - b.r) + absf(a.g - b.g) + absf(a.b - b.b)) * 255.0 / 3.0
            mean_difference += difference
            count += 1
            if difference > 0.1:
                changed += 1
    mean_difference /= maxf(count, 1)
    if mean_difference < 2.0:
        failures.append("Retro comparison too weak: mean RGB difference below 2/255")
    lab.set_retro_intensity(0.0)
    await _settle()
    var zero: Image = root.get_texture().get_image()
    var zero_changed := 0
    for y in range(roi.position.y, roi.end.y):
        for x in range(roi.position.x, roi.end.x):
            if before.get_pixel(x, y) != zero.get_pixel(x, y):
                zero_changed += 1
    if zero_changed != 0:
        failures.append("Intensity zero changes the 3D image")
    lab.reset_view()
    lab.toggle_split()
    await _settle()
    _save(output, "retro_split.png")
    var layouts := []
    for window_size in [Vector2i(1280, 720), Vector2i(960, 540)]:
        DisplayServer.window_set_size(window_size)
        lab.reset_view()
        lab.set_camera(1)
        for fonts in [false, true]:
            lab.comparison_panel.visible = fonts
            await _settle()
            var view: Rect2 = lab.stage.get_global_rect()
            for button in lab.option_buttons.values():
                if view.intersects(button.get_global_rect()):
                    failures.append("Control overlaps the 3D view")
            if fonts and view.intersects(lab.comparison_panel.get_global_rect()):
                failures.append("Font panel overlaps the 3D view")
            layouts.append({"window": str(window_size), "fonts": fonts, "view": str(view)})
            _save(output, "layout_%dx%d_fonts_%s.png" % [window_size.x, window_size.y, str(fonts)])
    var report := {"status": "PASS" if failures.is_empty() else "FAIL", "failures": failures, "viewmodel": lab.world.viewmodel_name, "retro_mean_absolute_rgb_0_255": mean_difference, "changed_pixels": changed, "sampled_pixels": count, "zero_intensity_changed_pixels": zero_changed, "layouts": layouts, "limits": "Pixel difference is technical evidence, not human artistic acceptance; runtime captures are unedited."}
    var file := FileAccess.open(output.path_join("readability.json"), FileAccess.WRITE)
    file.store_string(JSON.stringify(report, "  "))
    print("READABILITY ", JSON.stringify(report))
    lab.queue_free()
    await process_frame
    quit(0 if failures.is_empty() else 1)

func _settle() -> void:
    for frame in range(24):
        await RenderingServer.frame_post_draw

func _save(output: String, name: String) -> void:
    if root.get_texture().get_image().save_png(output.path_join(name)) != OK:
        failures.append("Screenshot write failed: " + name)
