# Arquitectura ejecutable H03

Revisión 2026-11-22: panel lateral de controles, leyendas externas y fuentes desplegables fuera del rectángulo 3D. Render fijo 1280×720/640×360 presentado con aspecto 16:9. Retro regulable y split B, solo 3D; shader 15 pasos/scanline 0.10/mezcla 0.70 de prueba. 8 tests de integración; -Graphics añade readability_probe.gd con comparaciones de píxeles y comprobación de solapes. Carga opcional de Malorian suministrada en la instalación local del creador; carpeta resources/local_experiments excluida de Git y empaquetado. Esta publicación se prueba sin ella y usa arma abstracta. No funcionalidad de arma ni cambio de H1.

Godot 4.7.2 estándar, GL Compatibility, Windows. `project.godot` conserva entrada H1 e Input Map. `scripts/main.gd`, `player.gd`, `enemy.gd` y `scenes/main.tscn` son el prototipo previo, preservado por hash.

- `scripts/config/balance_profile.gd`: Resource con reglas aprobadas y valores provisionales separados, validación de esquema/rangos y clamps. `resources/balance/provisional.tres` es editable; no está conectado al gameplay H1.
- `scenes/art_reference/modern_psx_lab.tscn`: Control aislado, `scripts/art_reference/modern_psx_lab.gd` crea UI y SubViewport 3D. `lab_world.gd` construye la sala/muestras. Solo el 3D recibe escalado y shader; UI queda fuera.
- `resources/art_samples`: única selección experimental importable; `manifest.json` fija archivos por hash. Modelos GLB/glTF/FBX importados por Godot sin Blender.
- `resources/shaders/subtle_retro.gdshader`: cuantización/líneas suaves, apagado por defecto.
- `addons/gdUnit4`: upstream v6.2.3 sin modificaciones, MIT. ZIP/SHA fijados, instalador `tools/h03/install_gdunit.py`. Preflight e integración ejecutados en Godot 4.7.2. No plugin activo en editor.
- `tests/h03/unit`, `integration`, `controlled_failure`, `graphics_probe.gd`; regresión anterior `tests/h02/h1_probe.gd`.
- `tools/run_tests.ps1` delega en `tools/h03/run_tests.py`. Captura códigos, errores de motor y JUnit; el fallo deliberado se comprueba separadamente. [Comandos reproducibles](../README.md).

No dependencias de Python adicionales; Python 3.11+ por `hashlib.file_digest`. Integridad pública: baseline H1 de seis archivos + referencias y hashes de muestras; el archivo privado completo se valida solo donde existe. Resultados/cachés generados excluidos de Git.
