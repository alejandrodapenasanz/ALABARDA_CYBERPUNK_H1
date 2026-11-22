# Asset registry — H04 public selection

Creator approved the experimental H04 reference on 2026-11-22. Legal provenance, technical validation and visual acceptance remain separate. No final production model selection is implied.

| Resource | Author / source / licence | Use and changes |
|---|---|---|
| CRT TV | loafbrr — https://loafbrr.itch.io/crt-tv-asset — CC0 | Selected glTF/textures unchanged; placement/material filtering in lab |
| Office desk | valsekamerplant — https://valsekamerplant.itch.io/psx-style-opulent-office — CC0 | Selected GLB unchanged; instance tint/roughness/metallic/filter adjustments |
| Industrial exterior v2 | godgoldfear — https://godgoldfear.itch.io/psx-industrial-environment-asset-pack — CC BY 4.0 | Barrel and ventilation selected from FBX; source unchanged, instance placement/material adjustments; attribution retained |
| HomeVideo 0.9 | GGBotNet — https://ggbot.itch.io/home-video-font — CC0 1.0 | Regular TTF unchanged; font comparison and physical signs |
| FPS arms | Drillimpact — https://drillimpact.itch.io/psx-first-person-arms-free — CC0 1.0 | Current GLB unchanged; separate scale/animation demonstration |
| Original H04 kit | Authored for this project with Blender 4.5.3 using tools/h04/build_kit.py; no external geometry/images | Cabinet 248 tri, panel 104, transit case 124; blend/GLB hashes in resources/art_kit/manifest.json; visual acceptance limited to experimental room |
| Original procedural materials, silhouette, fallback viewmodel and retro shader | Project-authored, no external images/models | Experimental; rendering controls and readable silhouette fixtures |
| GdUnit4 6.2.3 | Mike Schulze / Godot GdUnit Labs — MIT | Unmodified development dependency; pinned archive hash |

Source pack selection is traced in `resources/art_samples/manifest.json`. Original complete collections are not distributed. Optional local Malorian and restricted PSXAmmoBoxes are excluded. The public scene works without them. [Required attribution and notices](../THIRD_PARTY_NOTICES.md).

Blender is an external GPL authoring tool, not distributed. Original `.blend` sources in `art_sources/h04/` are ignored by Godot import; only generated GLB assets are runtime dependencies. No additional asset permissions were inferred from milestone approval.
