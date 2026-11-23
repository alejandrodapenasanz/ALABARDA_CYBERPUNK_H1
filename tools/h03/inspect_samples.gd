extends SceneTree

func _initialize() -> void:
    call_deferred("_run")

func _run() -> void:
    var report := {}
    for path in ["res://resources/art_samples/crt/CRTTV.gltf", "res://resources/art_samples/office/desk1_weathered.glb", "res://resources/art_samples/arms/arms_rig.glb", "res://resources/art_samples/industrial/Models/IndustrialHorror_PS_like.fbx"]:
        var packed := load(path) as PackedScene
        if packed == null:
            push_error("Cannot load " + path)
            quit(1)
            return
        var node := packed.instantiate()
        root.add_child(node)
        var meshes := []
        var skeletons := []
        var animations := []
        for child in node.find_children("*", "MeshInstance3D", true, false):
            var mesh: MeshInstance3D = child
            var textures := []
            for index in range(mesh.mesh.get_surface_count()):
                var material := mesh.get_active_material(index) as BaseMaterial3D
                if material and material.albedo_texture:
                    textures.append(str(material.albedo_texture.get_size()))
            meshes.append({"name": str(node.get_path_to(child)), "bounds": str(mesh.get_aabb()), "position": str(mesh.global_position), "textures": textures})
        for child in node.find_children("*", "Skeleton3D", true, false):
            skeletons.append({"name": child.name, "bones": child.get_bone_count()})
        for child in node.find_children("*", "AnimationPlayer", true, false):
            animations.append(Array(child.get_animation_list()))
        report[path] = {"meshes": meshes, "skeletons": skeletons, "animations": animations}
        node.free()
    var file := FileAccess.open("res://docs/evidence/h03/imported_samples.json", FileAccess.WRITE)
    file.store_string(JSON.stringify(report, "  "))
    print("SAMPLES_INSPECTED ", report.size())
    quit(0)
