extends SceneTree

func _initialize() -> void:
    var base := Image.load_from_file("res://docs/evidence/h03/run_03/graphics/native_nearest.png")
    var retro := Image.load_from_file("res://docs/evidence/h03/run_03/graphics/subtle_retro.png")
    if base == null or retro == null or base.get_size() != retro.get_size():
        push_error("Missing or incompatible original captures")
        quit(1)
        return
    var changed := 0
    var total_difference := Vector3.ZERO
    var maximum := Vector3.ZERO
    var count := 0
    for y in range(250, 540):
        for x in range(300, 1100):
            var a := base.get_pixel(x, y)
            var b := retro.get_pixel(x, y)
            var delta := Vector3(absf(a.r - b.r), absf(a.g - b.g), absf(a.b - b.b)) * 255.0
            if delta.length_squared() > 0.0:
                changed += 1
            total_difference += delta
            maximum = Vector3(maxf(maximum.x, delta.x), maxf(maximum.y, delta.y), maxf(maximum.z, delta.z))
            count += 1
    var report := {"date": "2026-11-22", "source": "Existing run_03 PNGs from 2026-11-21; not a new render or user-machine test", "roi_xyxy": [300, 250, 1100, 540], "changed_pixels": changed, "total_pixels": count, "mean_absolute_rgb_0_255": str(total_difference / float(count)), "max_absolute_rgb_0_255": str(maximum), "interpretation": "Nonzero differences establish an effect in prior captures, not human perceptibility or current input delivery"}
    var file := FileAccess.open("res://docs/evidence/h03/retro_review_20261122.json", FileAccess.WRITE)
    file.store_string(JSON.stringify(report, "  "))
    print(JSON.stringify(report))
    quit(0)
