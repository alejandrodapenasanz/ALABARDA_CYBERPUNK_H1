# Architecture — H04

Godot **4.7.2.stable.official.ed1daf0bf**, GL Compatibility, Windows; GdUnit4 **6.2.3**, MIT, vendored unmodified. H1 entry `scenes/main.tscn`, project settings, input behavior and gameplay scripts are preserved.

`scenes/art_reference/modern_psx_lab.tscn` is the same H03 scene developed into H04. `modern_psx_lab.gd` builds external controls and an independent 3D SubViewport. `lab_world.gd` owns materials, samples, camera and optional local viewmodel/fallback. `lookdev_room.gd` builds the modular composition. `lookdev_profile.gd` and `resources/art_kit/lookdev.tres` hold experimental palette, lights and camera parameters.

Three authored GLB models are reused eight times. The five supplied sample instances remain: CRT, desk, barrel, ventilation and arms. Material adaptations affect copies, preserving imported sources. Two physical signs use HomeVideo at 40 px in 320×128 viewports, linear minification; other 3D materials default to nearest+mipmaps. Retro affects only the 3D display, never the external HUD.

## Authoring

Blender **4.5.3 LTS portable**, official Windows package: https://download.blender.org/release/Blender4.5/ . Verify the ZIP against the matching official SHA-256 file before use. Blender is an external GPL authoring tool and is not included.

```powershell
& $env:BLENDER_BIN --background --factory-startup --python tools/h04/build_kit.py
& $env:GODOT_BIN --headless --path . --editor --import --quit
```

The generator writes three original `.blend` files under `art_sources/h04/`, three GLB exports and their SHA-256 manifest under `resources/art_kit/`. Metres, Y-up in glTF, floor origins, transforms applied, UV and materials included. `art_sources/.gdignore` prevents Blender imports in Godot. No Blender dependency for normal gameplay or tests.

## Testing

```powershell
python -X utf8 tools/h04/run_tests.py --godot $env:GODOT_BIN --output docs/evidence/h04/new_run --graphics
```

Requires Python 3.11+ and a new output directory. Runs H03 units/integration, controlled negative test, H1 regression, import/startup/integrity, four H04 tests, source/export hashes and optional real-window graphics. Exit 0 means all automated stages passed. Manual approval is recorded separately. No engine errors or missing JUnit cases are accepted as PASS.

GdUnit4 reinstall: `python -X utf8 tools/h03/install_gdunit.py`, pinned by `tools/h03/gdunit.lock.json`. Source/tag/hash and MIT notice retained. Public integrity uses the six-file H1 baseline and delivered resources; it does not claim access to private original collections.
