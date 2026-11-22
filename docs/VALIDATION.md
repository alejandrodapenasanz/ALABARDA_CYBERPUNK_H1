# Validation — H04

**H04 closed with creator approval, 2026-11-22.** Local automated suite passed before the joint human review was accepted: materials/composition, silhouette and HomeVideo under three lights, camera/arms/reset, brief H1 regression. Approval is for the experimental reference. No additional hardware, resolutions or final production assets are inferred.

Godot 4.7.2 standard / Windows / GL Compatibility; GdUnit4 6.2.3, Python 3.13.15, Blender 4.5.3 LTS for authored exports.

Local verification: 8 H03 unit tests +8 H03 integration tests +4 H04 integration tests PASS. H1 regression 34 PASS/0 FAIL/1 NOT_RUN (physical mouse capture/click unavailable in headless). Negative control deliberately returns 100 with one expected failed assertion; detector PASS. Import/startup, source/export integrity, shader/UI probes and three lighting conditions ×four camera captures PASS. Human acceptance is separate from automated results.

The fresh public snapshot was also tested with the complete graphical suite on 2026-11-22: PASS, global exit 0, the same 20 positive tests and H1 34/0/1, public fallback viewmodel, import/integrity and graphical probes. No local experimental assets were present. Authoring files then had only personal file-browser metadata removed through Blender; source geometry/UV counts and unchanged GLB hashes were checked, and delivered manifest hashes reverified. Game/runtime code was unchanged after the public suite.

```powershell
python -X utf8 tools/h04/run_tests.py --godot $env:GODOT_BIN --output docs/evidence/h04/new_run --graphics
```

Run from repository root, using a new output directory. Exact argv, dates, OS, exit codes, stdout/stderr, JUnit, raw frame timings and unedited screenshots are written there. Machine-specific/private logs and conversations are excluded from GitHub. The public integrity baseline covers H1 and delivered resources, not private originals.

Earlier development failures were corrected: camera-array import defaults required explicit serialization; a test expected integer 0 instead of float 0.0. Material colour conversion and physical-sign minification were also improved before final local validation. Historical failures were retained in the local evidence.

Windows export, other hardware and long sessions NOT_RUN, outside H04 scope. Headless tests do not certify physical input or artistic quality. H05 not started.
