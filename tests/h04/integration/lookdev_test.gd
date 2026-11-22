extends GdUnitTestSuite

const LAB = preload("res://scenes/art_reference/modern_psx_lab.tscn")
const KIT := ["service_cabinet", "wall_panel", "transit_case"]
const TRIANGLES := [248, 104, 124]
const HEIGHTS := [2.0, 3.0, 0.49]

func test_blender_glb_dimensions_pivots_uv_and_materials() -> void:
    for index in range(KIT.size()):
        var scene := load("res://resources/art_kit/" + KIT[index] + ".glb") as PackedScene
        assert_object(scene).is_not_null()
        var prop := scene.instantiate() as Node3D
        add_child(prop)
        var triangles := 0
        var bounds := AABB()
        var first := true
        for mesh: MeshInstance3D in prop.find_children("*", "MeshInstance3D", true, false):
            var local_bounds: AABB = mesh.global_transform * mesh.get_aabb()
            bounds = local_bounds if first else bounds.merge(local_bounds)
            first = false
            for surface in range(mesh.mesh.get_surface_count()):
                var arrays := mesh.mesh.surface_get_arrays(surface)
                var vertices: PackedVector3Array = arrays[Mesh.ARRAY_VERTEX]
                var uv: PackedVector2Array = arrays[Mesh.ARRAY_TEX_UV]
                var indices: PackedInt32Array = arrays[Mesh.ARRAY_INDEX]
                assert_int(uv.size()).is_equal(vertices.size())
                assert_int(vertices.size()).is_greater(0)
                assert_object(mesh.get_active_material(surface)).is_not_null()
                triangles += int(indices.size() / 3) if not indices.is_empty() else int(vertices.size() / 3)
        assert_int(triangles).is_equal(TRIANGLES[index])
        assert_float(bounds.position.y).is_equal_approx(0, .001)
        assert_float(bounds.size.y).is_equal_approx(HEIGHTS[index], .001)
        prop.free()

func test_three_lighting_conditions_restore_approved_profile() -> void:
    var lab = LAB.instantiate()
    add_child(lab)
    var before: Dictionary = lab.capture_config()
    var original_color: Color = lab.world.point_lights[0].light_color
    lab.cycle_lighting()
    assert_str(lab.capture_config().lighting_condition).is_equal("neutral")
    assert_float(lab.world.point_lights[0].light_energy).is_equal(0.0)
    lab.cycle_lighting()
    assert_str(lab.capture_config().lighting_condition).is_equal("alarm")
    assert_bool(lab.option_buttons.atmospheric.text.contains("alarma")).is_true()
    assert_float(lab.world.point_lights[0].light_color.r).is_greater(lab.world.point_lights[0].light_color.g)
    lab.cycle_lighting()
    assert_dict(lab.capture_config()).is_equal(before)
    assert_bool(lab.world.point_lights[0].light_color.is_equal_approx(original_color)).is_true()
    lab.cycle_lighting()
    lab.cycle_lighting()
    lab.reset_view()
    assert_dict(lab.capture_config()).is_equal(before)
    lab.free()

func test_kit_reused_and_material_changes_isolated() -> void:
    var a = LAB.instantiate()
    var b = LAB.instantiate()
    add_child(a)
    add_child(b)
    var count := 0
    for child in a.world.get_children():
        if child.has_meta("h04_kit"):
            count += 1
    assert_int(count).is_equal(8)
    assert_object(a.world.get_node_or_null("ServiceCabinet")).is_not_null()
    assert_int(a.world.sample_nodes.size()).is_equal(5)
    a.toggle("nearest")
    for material in b.world.materials:
        var expected := BaseMaterial3D.TEXTURE_FILTER_LINEAR if material.albedo_texture is ViewportTexture else BaseMaterial3D.TEXTURE_FILTER_NEAREST_WITH_MIPMAPS
        assert_int(material.texture_filter).is_equal(expected)
    assert_int(a.world.materials[0].texture_filter).is_equal(BaseMaterial3D.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS)
    a.free()
    b.free()

func test_inspection_is_separate_from_gameplay_and_ui() -> void:
    var lab = LAB.instantiate()
    add_child(lab)
    assert_int(lab.world.find_children("*", "CollisionObject3D", true, false).size()).is_equal(0)
    var terminal: SubViewport = lab.world.get_node("TerminalSignViewport")
    var text: Label = terminal.get_child(1)
    assert_str(text.get_theme_font("font").resource_path).is_equal("res://resources/art_samples/font/HomeVideo-Regular.ttf")
    assert_int(text.get_theme_font_size("font_size")).is_equal(40)
    for camera_index in range(4):
        lab.set_camera(camera_index)
        assert_bool(lab.world.camera.position.is_finite()).is_true()
    for mesh: MeshInstance3D in lab.world.viewmodel.find_children("*", "MeshInstance3D", true, false):
        assert_int(mesh.layers).is_equal(2)
        assert_int(mesh.cast_shadow).is_equal(GeometryInstance3D.SHADOW_CASTING_SETTING_OFF)
    lab.free()
