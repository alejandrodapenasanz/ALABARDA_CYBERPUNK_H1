# ALABARDA CYBERPUNK — H04

Godot 4.7.2 / Windows / GL Compatibility. **H1–H04 closed with creator approval, 2026-11-22.** H04 develops the existing Modern PSX reference room with a reusable industrial kit, materials, HomeVideo signs and three lighting conditions. Assets remain experimental.

Open `project.godot` in Godot 4.7.2. **F5** starts the H1 gameplay prototype. To view H04, open `scenes/art_reference/modern_psx_lab.tscn` and press **F6**.

- **1–4:** general, CRT, silhouette, arms rig. **A:** arm animation; **M:** inspection motion.
- **L:** atmospheric → neutral → static alarm light → atmospheric.
- **T/R/X/S/G:** filtering/internal resolution/retro/shadows/fog. **B:** retro split comparison.
- **F:** font comparison. **0:** approved defaults. **Esc:** exit lab.

Defaults: nearest+mipmaps, atmospheric light, internal 1280×720, shadows on, retro/fog off. HomeVideo physical signs use linear minification to preserve strokes. HUD remains outside the 3D effect.

Public viewmodel is an original abstract placeholder. Optional local experimental assets are excluded. The lab has no combat, AI or interactive terminal; H1 gameplay remains intact. H05 has not started.

```powershell
# GODOT_BIN points to the Godot 4.7.2 console executable. Python 3.11+ required.
python -X utf8 tools/h04/run_tests.py --godot $env:GODOT_BIN --output docs/evidence/h04/new_run --graphics
```

Blender is only needed to regenerate the authored kit. [Architecture and pipeline](docs/ARCHITECTURE.md), [asset provenance](docs/ASSET_REGISTRY.md), [validation](docs/VALIDATION.md), [handoff](docs/HANDOFF.md), [third-party notices](THIRD_PARTY_NOTICES.md).
