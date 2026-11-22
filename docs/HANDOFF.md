# Handoff — H04 closed

**2026-11-22: H1–H04 closed with creator approval.** H04 technical suite passed; the creator accepted the joint visual/manual review. Assets remain experimental. H05 has not started and requires its own instruction.

Open `project.godot` with Godot 4.7.2. F5 runs H1; F6 with `scenes/art_reference/modern_psx_lab.tscn` selected runs H04. Reset 0 uses the approved atmospheric/nearest+mips/1280×720/shadows profile, with retro/fog off. L cycles atmospheric/neutral/static alarm; 1–4 select views; A animates arms; M previews motion; F compares fonts; X/B compare retro.

Public fallback is the original abstract viewmodel. Local experimental files are optional and excluded. Arms are not bound to the weapon. No combat, AI, interaction or collision system exists in the lookdev room; H1 remains the gameplay entry.

Continue from the existing room, shared profile and authored GLB kit; preserve licences and original samples. Blender 4.5.3 authoring sources and generator are included, but Blender itself is unnecessary to run Godot. Tests and reproduction are in [ARCHITECTURE](ARCHITECTURE.md); approval and limitations in [VALIDATION](VALIDATION.md).
