extends GdUnitTestSuite

const LAB = preload("res://scenes/art_reference/modern_psx_lab.tscn")

func test_scene_loads_samples_and_materials() -> void:
    var lab = LAB.instantiate()
    add_child(lab)
    assert_int(lab.world.sample_nodes.size()).is_equal(5)
    assert_int(lab.world.materials.size()).is_greater(20)
    assert_object(lab.world.camera).is_not_null()
    assert_object(lab.world.arms_animation).is_not_null()
    assert_bool(lab.world.arms_animation.has_animation("rest")).is_true()
    var skeleton: Skeleton3D = lab.world.find_child("Skeleton3D", true, false)
    assert_int(skeleton.get_bone_count()).is_equal(52)
    assert_object(lab.effect.shader).is_not_null()
    for material in lab.world.materials:
        assert_object(material).is_not_null()
        if material.albedo_texture:
            assert_int(material.albedo_texture.get_width()).is_greater(0)
    lab.free()

func test_optional_settings_are_reversible() -> void:
    var lab = LAB.instantiate()
    add_child(lab)
    var before: Dictionary = lab.capture_config()
    for key in lab.options:
        var original: bool = lab.options[key]
        lab.toggle(key)
        assert_bool(lab.options[key]).is_equal(not original)
        if key == "retro":
            assert_bool(lab.effect.get_shader_parameter("enabled")).is_equal(not original)
        elif key == "nearest":
            assert_int(lab.world.materials[0].texture_filter).is_equal(BaseMaterial3D.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS)
        elif key == "half_resolution":
            assert_int(lab.viewport.size.x).is_equal(int(lab.get_viewport_rect().size.x / 2))
        elif key == "shadows":
            assert_bool(lab.world.key_light.shadow_enabled).is_equal(not original)
        elif key == "fog":
            assert_bool(lab.world.environment.fog_enabled).is_equal(not original)
        elif key == "atmospheric":
            assert_float(lab.world.environment.ambient_light_energy).is_equal_approx(0.65, 0.00001)
        lab.toggle(key)
    assert_dict(lab.capture_config()).is_equal(before)
    lab.free()

func test_font_spanish_characters_without_fallback() -> void:
    var font: Font = load("res://resources/art_samples/font/HomeVideo-Regular.ttf")
    for character in "Instalación Ññ áéíóúü ¿¡ 0123456789 /":
        assert_bool(font.has_char(character.unicode_at(0))).is_true()

func test_h1_remains_entry_scene() -> void:
    assert_str(ProjectSettings.get_setting("application/run/main_scene")).is_equal("res://scenes/main.tscn")
    assert_str(ProjectSettings.get_setting("rendering/renderer/rendering_method")).is_equal("gl_compatibility")

func test_arm_animation_changes_skeleton_pose() -> void:
    var lab = LAB.instantiate()
    add_child(lab)
    var skeleton: Skeleton3D = lab.world.find_child("Skeleton3D", true, false)
    var animation: AnimationPlayer = lab.world.arms_animation
    animation.play("jab_L")
    animation.advance(0.0)
    var poses := []
    for index in range(skeleton.get_bone_count()):
        poses.append(skeleton.get_bone_pose(index))
    animation.advance(0.2)
    var changed := false
    for index in range(skeleton.get_bone_count()):
        changed = changed or not skeleton.get_bone_pose(index).is_equal_approx(poses[index])
    assert_bool(changed).is_true()
    lab.free()

func test_controls_and_fonts_do_not_cover_3d_view() -> void:
    var lab = LAB.instantiate()
    add_child(lab)
    for font_panel in [false, true]:
        lab.comparison_panel.visible = font_panel
        await get_tree().process_frame
        await get_tree().process_frame
        var view: Rect2 = lab.stage.get_global_rect()
        assert_float(view.size.x).is_greater(400.0)
        assert_float(view.size.y).is_greater(200.0)
        for button in lab.option_buttons.values():
            assert_bool(view.intersects(button.get_global_rect())).is_false()
        if font_panel:
            assert_bool(view.intersects(lab.comparison_panel.get_global_rect())).is_false()
        for camera_index in range(4):
            lab.set_camera(camera_index)
            assert_bool(lab.view_title.text.begins_with(str(camera_index + 1))).is_true()
    assert_int(lab.world.find_children("*", "Label3D", true, false).size()).is_equal(0)
    lab.free()

func test_retro_comparison_and_reset() -> void:
    var lab = LAB.instantiate()
    add_child(lab)
    lab.toggle_split()
    assert_bool(lab.options.retro).is_true()
    assert_bool(lab.effect.get_shader_parameter("split_preview")).is_true()
    lab.set_retro_intensity(0.0)
    assert_float(lab.effect.get_shader_parameter("intensity")).is_equal(0.0)
    lab.toggle_fonts()
    lab.set_camera(2)
    lab.reset_view()
    assert_bool(lab.comparison_panel.visible).is_false()
    assert_bool(lab.split_preview).is_false()
    assert_bool(lab.options.retro).is_false()
    assert_int(lab.camera_index).is_equal(0)
    assert_dict(lab.options).is_equal({"nearest": true, "atmospheric": true, "half_resolution": false, "retro": false, "shadows": true, "fog": false})
    assert_float(lab.retro_intensity).is_equal_approx(0.7, 0.00001)
    lab.free()

func test_local_viewmodel_and_public_fallback() -> void:
    var lab = LAB.instantiate()
    add_child(lab)
    assert_bool(lab.world.camera.is_ancestor_of(lab.world.viewmodel)).is_true()
    var meshes: Array[Node] = lab.world.viewmodel.find_children("*", "MeshInstance3D", true, false)
    if ResourceLoader.exists(lab.world.LOCAL_VIEWMODEL):
        assert_str(lab.world.viewmodel_name).is_equal("Malorian / prueba local")
        assert_int(meshes.size()).is_equal(1)
        assert_object(meshes[0].material_override.albedo_texture).is_not_null()
        assert_int(meshes[0].material_override.albedo_texture.get_width()).is_equal(128)
    else:
        assert_str(lab.world.viewmodel_name).is_equal("Arma abstracta / muestra pública")
        assert_int(meshes.size()).is_equal(3)
    lab.free()
