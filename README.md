# ALABARDA STUDIOS — Cyberpunk FPS

**Perfil visual aprobado por el creador (D-019, 2026-11-22):** nearest+mips, luz atmosférica, 3D 1280×720, retro desactivado, sombras sí y niebla no. Inicio y tecla 0 reproducen esta elección, vigente y revisable en el futuro. El 70% de intensidad no tiene efecto con retro apagado; los assets siguen siendo de prueba.

Prototipo Godot para Windows. H1 jugable y laboratorio H03 de pruebas, balance provisional y comparación Modern PSX / Retro Industrial Cyberpunk. **H03 CERRADO Y APROBADO POR EL CREADOR el 2026-11-22. H04 no iniciado.** Confirmadas regresión manual H1, legibilidad y preferencia HomeVideo, y animación de brazos con A en cámara 4. Suite técnica PASS.

Los assets incluidos son exclusivamente muestras de prueba: no representan la selección final del juego. Esta publicación contiene el código ejecutable, tests y una selección redistribuible de recursos. El archivo documental privado, los originales completos y los logs locales no forman parte de esta copia pública.

## Abrir

Validado con **Godot 4.7.2.stable.official.ed1daf0bf**, edición estándar, GL Compatibility en Windows 11. Importar `project.godot` en Godot; esperar a que termine la importación. No hace falta Blender para los GLB/glTF/FBX incluidos.

- **F5:** prototipo H1, escena `scenes/main.tscn`.
- **Laboratorio:** abrir `scenes/art_reference/modern_psx_lab.tscn` y pulsar **F6**.
- **T/L/R/X/S/G:** filtro, iluminación, resolución 3D, retro, sombras, niebla.
- **B:** comparación retro A/B, izquierda sin efecto y derecha con efecto; slider de intensidad. Los controles están fuera de la escena, la cámara general es frontal y **F** despliega las fuentes sin tapar el 3D. Reset inicia con luz atmosférica aprobada.
- **1–4:** cámara general, CRT, silueta, rig de brazos. **A:** animación; **M:** movimiento de cámara; **F:** panel tipográfico; **0:** restaurar; **Esc:** salir.

El laboratorio muestra CRT, escritorio, barril/ventilación, brazos con 52 huesos/18 clips y fuente HomeVideo. El arma abstracta y las cajas son primitivas propias. No implementa combate ni nuevos sistemas. El perfil `resources/balance/provisional.tres` tampoco altera el balance de H1.

## Tests

Requisitos: PowerShell, Python **3.11+** en PATH y Godot estándar. GdUnit4 **6.2.3**, MIT, está incluido; su ZIP de origen queda fijado por SHA-256 en `tools/h03/gdunit.lock.json`. No hay que activar el plugin del editor.

```powershell
$env:GODOT_BIN = 'C:/ruta/Godot_console.exe'
powershell -NoProfile -ExecutionPolicy Bypass -File tools/run_tests.ps1
# Medición y capturas en ventana real, además de la suite:
powershell -NoProfile -ExecutionPolicy Bypass -File tools/run_tests.ps1 -Graphics
```

El runner crea una carpeta nueva en `docs/evidence/h03/`, con logs, JUnit, comandos y `summary.json`. Salida global 0 = PASS, 1 = FAIL, 2 = falta motor. Comprueba importación, ocho tests de balance, ocho de integración, arranque H1, 34 regresiones y recursos. Con -Graphics comprueba también legibilidad técnica mediante rectángulos de UI y diferencias reales de píxeles. El control negativo falla deliberadamente con salida **100**; el runner exige exactamente ese fallo y después informa `negative_control verification: PASS`. Captura/clic físico H1: NOT_RUN en headless, comprobación humana aprobada por el creador y registrada separadamente el 2026-11-22.

La integridad de esta copia comprueba seis archivos base H1, dependencias y hashes de muestras. No afirma disponer de los 908 archivos originales/históricos comprobados en el workspace privado. Para reinstalar exactamente el framework: `python tools/h03/install_gdunit.py` (requiere red; no sobrescribe archivos distintos).

## Créditos y continuidad

Consultar [atribuciones y licencias](THIRD_PARTY_NOTICES.md), [registro de muestras](docs/ASSET_REGISTRY.md), [arquitectura](docs/ARCHITECTURE.md), [validación](docs/VALIDATION.md) y [handoff](docs/HANDOFF.md). Malorian y PSXAmmoBoxes no están incluidos. La disponibilidad pública del repositorio no concede una licencia adicional sobre el código propio; las dependencias mantienen sus licencias indicadas.
