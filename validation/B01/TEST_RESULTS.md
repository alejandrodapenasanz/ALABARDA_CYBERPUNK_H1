# TEST_RESULTS — B1 (H05, H06)

Lote B1 · rama `B1` · candidato inicial `bfe7071b63e756200f4e1ea94160175bc6294644` · candidato corregido `94e4880b03b60d1517917d11ab98dce786499d69`. Paquete de entrada `f951cb6892e2867f28ceb3edebb823377c6ecd8f`. Actualización: 2026-11-27.

## Intento 00 · PC Claude · 2026-11-23 · solo comprobaciones sin Godot

Entorno real: Windows 11 Enterprise 10.0.26100, Python 3.14 (venv con `tools/pipeline/requirements.txt`, gdtoolkit 4.5.0, jsonschema 4.23.0). **Sin Godot ni Blender.** Ejecutado sobre un worktree limpio de C (`git status --porcelain` vacío, HEAD = C), creado con `git -c core.longpaths=true worktree add --detach`.

| ID | Commit probado | Comando (cwd = raíz de C) | Exit | Estado | Evidencia / notas |
|---|---|---|---|---|---|
| B1-STATIC | bfe7071b… | `python -X utf8 tools/pipeline/check_godot_static.py` | 0 | PASS | [log](evidence/claude_static/godot_static.stdout.log): 42 .gd parsean, 12 .tscn/.tres sin referencias rotas nuevas, 20 hallazgos aceptados del legado, 1 aviso gdlint previo (H04) |
| (pipeline) | bfe7071b… | `python -X utf8 tools/pipeline/verify_checkout.py` | 0 | PASS | [log](evidence/claude_static/verify_checkout.stdout.log): 2871 ficheros del manifest portable coinciden |
| (pipeline) | bfe7071b… | `python -X utf8 tools/h03/verify_integrity.py` | 0 | PASS | [log](evidence/claude_static/verify_integrity.stdout.log): ficheros de runtime H1/H03/H04 intactos |
| (pipeline) | bfe7071b… | `python -X utf8 tools/pipeline/validate_manifest.py validation/B01/TEST_MANIFEST.json --ready --candidate <worktree C>` | 0 | PASS | [log](evidence/claude_static/validate_manifest_ready.stdout.log): esquema, completitud, SHA y rutas de C; 0 comandos ejecutados desde el manifest |
| B1-IMPORT | No probado | — | — | NOT_RUN | Requiere Godot (PC Codex) |
| B1-UNIT | No probado | — | — | NOT_RUN | Requiere Godot |
| B1-INTEGRATION | No probado | — | — | NOT_RUN | Requiere Godot |
| B1-SMOKE | No probado | — | — | NOT_RUN | Requiere Godot |
| B1-REGRESSION | No probado | — | — | NOT_RUN | Requiere Godot |
| M-01…M-08 | No probado | — | — | NOT_RUN | Requieren Godot con ventana y revisión humana |

Control negativo del validador estático (fuera de C, 2026-11-23): un .gd con error de sintaxis y un .tscn con ruta inexistente, id no declarado y padre inexistente dieron FAIL con los 4 errores. El control negativo de GdUnit (H03) forma parte de B1-REGRESSION y no se ha ejecutado.

## Intento 01 · PC Codex · 2026-11-23 · FAIL conservado

SHA probado: `bfe7071b63e756200f4e1ea94160175bc6294644`. Worktree `C:/dev/ALABARDA_B1_C_bfe7071`, limpio antes de importar, comprobado con [manifest --ready](evidence/attempt_01/preflight/manifest_ready.stdout.log) (exit 0).

Entorno real: Windows 11 Home 10.0.26200; Godot `4.7.2.stable.official.ed1daf0bf`; GdUnit4 `6.2.3`; Python `3.13.15`, gdtoolkit `4.5.0`, jsonschema `4.23.0`. Ejecución headless; Blender y pruebas gráficas no ejecutados. [Metadatos](evidence/attempt_01/metadata.json).

| ID | Exit | Resultado | Recuento / evidencia |
|---|---:|---|---|
| B1-STATIC | 0 | PASS | 42 scripts, 12 recursos, 0 errores nuevos; 20 hallazgos legados aceptados y 1 aviso previo H04. [Comando/cwd](evidence/attempt_01/preflight/static.json), [salida](evidence/attempt_01/preflight/static.stdout.log) |
| B1-IMPORT | 0 | PASS | Sin errores de motor. [Comando/cwd](evidence/attempt_01/import.json), [salida](evidence/attempt_01/import.stdout.log) |
| B1-UNIT | 0 | PASS | 37 tests, 0 fallos/errores/omitidos. [Comando/cwd/JUnit](evidence/attempt_01/b1_unit.json) |
| B1-INTEGRATION | 105 | FAIL | Descubrimiento abortado: 0 casos ejecutados de los 28 esperados, sin JUnit. [Comando/cwd](evidence/attempt_01/b1_integration.json), [errores íntegros](evidence/attempt_01/b1_integration.stderr.log), [BUG-B1-01](bugs/BUG-B1-01.md) |
| B1-SMOKE | 0 | PASS | Sandbox 600 frames, sin errores. [Comando/cwd](evidence/attempt_01/b1_sandbox_smoke.json) |
| B1-REGRESSION | 0 | PASS | 20 positivos GdUnit H03/H04; control negativo esperado exit 100; H1 34 PASS / 0 FAIL / 1 NOT_RUN. [Comando/cwd](evidence/attempt_01/regression_h1_h03_h04.json), [resumen](evidence/attempt_01/regression/summary.json) |

Comando principal, cwd `C:/dev/ALABARDA_B1_C_bfe7071`:

```powershell
& C:/dev/tools/alabarda-pipeline-v21-venv/Scripts/python.exe -X utf8 tools/b1/run_tests.py --godot C:/Users/aleja/Downloads/Godot_v4.7.2-stable_win64.exe/Godot_v4.7.2-stable_win64_console.exe --output C:/dev/ALABARDA_B1_EVIDENCE_20261123/attempt_01
```

Runner exit **1**: [invocación y tiempos](evidence/attempt_01/preflight/runner.json), [summary.json](evidence/attempt_01/summary.json). No se sustituyen sus fallos por el retest posterior.

Preparación del entorno: gdtoolkit no estaba instalado. `pip install -r tools/pipeline/requirements.txt` lo instaló; PowerShell convirtió un mensaje de stderr en error del wrapper, pese a que el log indicaba instalación completada. Se verificó la versión instalada y B1-STATIC la utilizó con éxito. Logs originales en `evidence/attempt_01/preflight/dependencies.*.log`. No se atribuye un exit 0 inexistente a ese wrapper.

## Intento 02 · PC Codex · 2026-11-27 · automáticas PASS

SHA realmente probado: `94e4880b03b60d1517917d11ab98dce786499d69`. Worktree nuevo `C:/dev/ALABARDA_B1_C_94e4880`, limpio antes de importar. El [manifest de repetición](evidence/attempt_02/preflight/TEST_MANIFEST.json) cambia el candidato al fix autorizado; [comprobación --ready](evidence/attempt_02/preflight/manifest_ready.stdout.log) PASS, exit 0. El paquete fuente original permanece identificado por su SHA.

Entorno real: **Windows 11 Home 10.0.26300** (actualizado desde el primer intento), Godot `4.7.2.stable.official.ed1daf0bf`, GdUnit4 `6.2.3`, Python `3.13.15`, gdtoolkit `4.5.0`, jsonschema `4.23.0`. [Versiones y hardware inventariado](evidence/attempt_02/environment.json), [metadatos](evidence/attempt_02/metadata.json). Solo headless; la configuración del proyecto es GL Compatibility, sin medición gráfica/GPU ni ejecución de Blender.

| ID | Exit | Resultado | Recuento / evidencia |
|---|---:|---|---|
| B1-STATIC | 0 | PASS | 42 scripts, 12 recursos, 0 errores nuevos; 20 hallazgos legados aceptados y 1 aviso H04. [Comando/cwd](evidence/attempt_02/preflight/static.json), [salida](evidence/attempt_02/preflight/static.stdout.log) |
| B1-IMPORT | 0 | PASS | Sin errores de motor. [Comando/cwd](evidence/attempt_02/import.json), [salida](evidence/attempt_02/import.stdout.log) |
| B1-UNIT | 0 | PASS | **37/37**, 0 fallos/errores/omitidos. [Comando/cwd/JUnit](evidence/attempt_02/b1_unit.json) |
| B1-INTEGRATION | 0 | PASS | **28/28**, 0 fallos/errores/omitidos. [Comando/cwd/JUnit](evidence/attempt_02/b1_integration.json) |
| B1-SMOKE | 0 | PASS | 600 frames, sin errores. [Comando/cwd](evidence/attempt_02/b1_sandbox_smoke.json) |
| B1-REGRESSION | 0 | PASS | H03 **8 + 8**, H04 **4**, sin fallos/errores/omitidos; control negativo **1 fallo esperado**, exit **100**; H1 **34 PASS / 0 FAIL / 1 NOT_RUN**. [Comando/cwd](evidence/attempt_02/regression_h1_h03_h04.json), [resumen H04](evidence/attempt_02/regression/summary.json), [resumen H03/H1](evidence/attempt_02/regression/regression/summary.json) |

Comando principal, cwd `C:/dev/ALABARDA_B1_C_94e4880`:

```powershell
& C:/dev/tools/alabarda-pipeline-v21-venv/Scripts/python.exe -X utf8 tools/b1/run_tests.py --godot C:/Users/aleja/Downloads/Godot_v4.7.2-stable_win64.exe/Godot_v4.7.2-stable_win64_console.exe --output C:/dev/ALABARDA_B1_EVIDENCE_20261123/attempt_02
```

Runner exit **0**: [invocación y tiempos](evidence/attempt_02/preflight/runner.json), [summary.json](evidence/attempt_02/summary.json). No se usó `--skip-regression` ni `--graphics`. El control negativo es una aserción que debe fallar; no es un defecto nuevo. El NOT_RUN de H1 es el clic físico que headless no comprueba.

En ambos worktrees Godot generó 24 sidecars `.gd.uid` no versionados y su caché `.godot`; el diff de archivos versionados siguió vacío. Los metadatos conservan el inventario posterior. Se comprobó SHA y limpieza **antes** de importar; no se presenta el árbol posterior como limpio. No se editaron los candidatos ni se borraron esos artefactos.

Los logs, JSON y JUnit originales se copiaron byte a byte. Cada intento contiene `raw_artifacts_sha256.json` con los hashes cotejados contra la evidencia externa. Los JSON por proceso conservan argv, cwd, fecha, exit y detección de errores; los XML están en los subdirectorios de reports producidos por GdUnit4.

## Pruebas manuales · ambos intentos

La instrucción expresa del creador para este encargo sustituye la asignación manual anterior al PC Codex.

| ID | Estado | Motivo |
|---|---|---|
| M-01-DASH | NOT_RUN | las realiza el creador |
| M-02-WALL | NOT_RUN | las realiza el creador |
| M-03-MOVE | NOT_RUN | las realiza el creador |
| M-04-INTERACT | NOT_RUN | las realiza el creador |
| M-05-REGEN | NOT_RUN | las realiza el creador |
| M-06-COMBAT | NOT_RUN | las realiza el creador |
| M-07-DEATH | NOT_RUN | las realiza el creador |
| M-08-H1 | NOT_RUN | las realiza el creador |

No se tomaron capturas ni se ejecutó interacción manual. Las fichas `manual/*.md` solo registran NOT_RUN, no observaciones de gameplay.

## Correcciones y repetición

**BUG-B1-01**: tipado de `world` en la suite de combate. Fix `94e4880b03b60d1517917d11ab98dce786499d69`: `Node3D` → `World`, con actualización explícita únicamente del hash de ese test en la baseline portable. Ninguna aserción relajada, ningún cambio de gameplay ni de H1/H03/H04. Intento 02: descubrimiento y 28 casos PASS; todas las automáticas y regresiones repetidas. [Informe y cierre técnico](bugs/BUG-B1-01.md). Sin fallos estructurales detectados por estas pruebas.

## Veredicto técnico del intento 02 · anterior a la revisión manual

**Automáticas PASS sobre `94e4880b03b60d1517917d11ab98dce786499d69`.** Estado del lote: **INTEGRATION_READY**, con manuales críticas pendientes; **no VALIDATED ni APPROVED**. El candidato original conserva su FAIL.

El creador hará M-01…M-08 con [manual_tests_B1.md](../../manual_tests_B1.md) sobre el candidato corregido y enviará el bloque OK/KO. No hay aprobación manual inferida, no se fusiona a main y no se inicia B2.

## Revisión manual posterior del creador · 2026-11-27

[Informe original, aclaraciones y contexto del SHA](evidence/manual_review_20261127/CREATOR_RESULTS.md). Checkout inspeccionado al recibirlo: `79d63e3d6b5c0ea87f88dac55e33f11ddef9d7c1`, runtime igual a C `94e4880`; el creador no escribió el SHA de la sesión. Codex no ejecutó manuales ni obtuvo capturas. Los NOT_RUN anteriores permanecen como historial real.

| ID | Resultado comunicado | Observación |
|---|---|---|
| M-01-DASH | PASS | OK, ventana bien; balance general aún provisional |
| M-02-WALL | FAIL | Cuerpo detenido, arma atraviesa pared; BUG-B1-02 |
| M-03-MOVE | PASS | OK del creador |
| M-04-INTERACT | PASS | F/E OK |
| M-05-REGEN | PASS | OK; no tiempos medidos aportados |
| M-06-COMBAT | PASS | Disparo OK |
| M-07-DEATH | PASS en alcance B1 | Bloqueo del jugador OK, cámara gira; futura tercera persona registrada en D-029 |
| M-08-H1 | PASS tras aclaración | Q histórico esperado; movimiento, cinco blancos y R confirmados |

## Diagnóstico 03 · prueba geométrica retirada, sin fix de gameplay

SHA probado: `49ecd30a5b78ef18a85390e8929baf132d6b78ff`, worktree limpio `C:/dev/ALABARDA_B1_C_49ecd30`; [--ready PASS](evidence/diagnostic_03/preflight/manifest_ready.stdout.log), exit 0 antes de importar. Godot 4.7.2.stable.official.ed1daf0bf, GdUnit4 6.2.3, Python 3.13.15, Windows 11 Home 10.0.26300. [Metadatos](evidence/diagnostic_03/metadata.json).

| ID | Exit | Resultado | Recuento / alcance |
|---|---:|---|---|
| B1-STATIC | — | NOT_RUN | No ejecutado en el diagnóstico |
| B1-IMPORT | 0 | PASS | Importación headless |
| B1-UNIT | 0 | PASS | 37 tests, 0 fallos/errores/omitidos |
| B1-INTEGRATION | 100 | FAIL | 29 tests, 1 fallo geométrico nuevo, 0 errores/omitidos; los 28 anteriores PASS |
| B1-SMOKE | 0 | PASS | 600 frames headless |
| B1-REGRESSION | — | NOT_RUN | Se usó --skip-regression; no es una entrega validada |

Comando real (cwd del candidato):

```powershell
& C:/dev/tools/alabarda-pipeline-v21-venv/Scripts/python.exe -X utf8 tools/b1/run_tests.py --godot C:/Users/aleja/Downloads/Godot_v4.7.2-stable_win64.exe/Godot_v4.7.2-stable_win64_console.exe --output C:/dev/ALABARDA_B1_MANUAL_20261127/attempt_03 --skip-regression
```

Runner exit 1; [argv/cwd/fechas](evidence/diagnostic_03/preflight/runner.json), [summary](evidence/diagnostic_03/summary.json), [JUnit](evidence/diagnostic_03/b1_integration_reports/report_1/results.xml). Distancia máxima a la línea central de la cápsula 1,188606 frente a radio 0,35. Esto comprueba que el modelo sobresale, no una colisión real con pared.

Tras D-030, que exige conservar posición y aspecto, se retiró ese criterio experimental mediante `71ce9a24f574b888fe2f9b8ca1c641470703b96a`. No se modificó el arma en ningún momento. Se conserva el fallo y no se lo reetiqueta PASS; **BUG-B1-02 sigue abierto**. La igualdad de runtime, escenas, tests y baseline con el paquete `79d63e3` se comprobó por `git diff --exit-code` (exit 0 en metadata). La suite vigente vuelve a 28 casos de integración; no se atribuye una ejecución nueva al SHA del revert.

## Veredicto anterior al encargo directo de corregir el arma

**Automáticas de aceptación anteriores: PASS sobre C `94e4880b03b60d1517917d11ab98dce786499d69` (intento 02). Revisión manual: FAIL por M-02. Estado del lote: VALIDATION_FAILED**, no VALIDATED ni APPROVED. BUG-B1-01 cerrado técnicamente; [BUG-B1-02](bugs/BUG-B1-02.md) abierto para Claude, sin fix todavía. La implementación requerida supera una corrección local de Codex.

D-029 deja anotada la cámara de muerte futura; D-030 obliga a conservar posición/aspecto del arma y resolver físicamente su contacto con paredes. Tras fix de Claude: nuevo candidato, automáticas/regresiones y retest manual afectado con SHA. Sin merge a main ni inicio de B2.

## Intento 04 · reproducción del bug de pared · 2026-11-27

SHA `f9f215b59b99e1d7b967db274db977de5f7727b4`, candidato limpio `C:/dev/ALABARDA_B1_C_f9f215b`, [manifest --ready PASS](evidence/attempt_04/preflight/manifest_ready.stdout.log) antes de importar. Añade siete pruebas de colisión real sin cambiar el arma ni gameplay.

[Runner](evidence/attempt_04/preflight/runner.json), exit 1, con `--skip-regression`: import PASS/0, unitarias 37/37 PASS/0, integración FAIL/100, smoke 600 frames PASS/0; estático y regresión completa NOT_RUN en este intento. [Summary](evidence/attempt_04/summary.json). Integración: 29 de 35 casos ejecutados, un caso fallido con dos aserciones, 0 errores/omitidos JUnit; los otros seis no se ejecutaron por fail-fast (no confundir ese cero de skipped con cobertura completa).

Para comprobar los siete nuevos casos se ejecutó únicamente `weapon_wall_test.gd` con `-c` en el mismo candidato importado: [argv/cwd/exit](evidence/attempt_04/red_full/new_wall_suite.json), [JUnit](evidence/attempt_04/red_full/reports/report_1/results.xml). Exit 100; 7 casos, 5 fallidos/2 PASS, 10 aserciones fallidas, 0 errores/omitidos. Posición/animación original y pasillo estrecho ya pasaban; cinco situaciones de contacto reproducían el fallo.

## Intento 05 · fix de pared solicitado a Codex · automáticas PASS

SHA probado **`1401e05269fc4919f3658788e7de48bc5a4aa148`**, candidato nuevo `C:/dev/ALABARDA_B1_C_1401e05`; [manifest --ready](evidence/attempt_05/preflight/manifest_ready.stdout.log) PASS, exit 0 con árbol limpio antes de importar. El creador solicitó directamente «solucionalo» tras la devolución anterior, manteniendo D-030. Fix: guard físico del arma/poses y barrido del giro. Las escenas y `fixture_weapon.gd` siguen idénticos; los tests del intento 04 no cambian.

Entorno real: **Windows 11 Home 10.0.26300; Godot 4.7.2.stable.official.ed1daf0bf; GdUnit4 6.2.3; Python 3.13.15**. [Versiones, inventario posterior y comparación](evidence/attempt_05/metadata.json). Solo headless, sin manuales, export ni Blender. Godot genera sidecars/caché tras importar; no cambia fuentes versionadas. Logs/JUnit copiados y cotejados por hash.

| ID | Exit | Resultado | Recuento / evidencia |
|---|---:|---|---|
| B1-STATIC | 0 | PASS | 44 scripts, 12 recursos; 20 hallazgos aceptados y aviso H04 previo. [Comando/salida](evidence/attempt_05/preflight/static.json) |
| B1-IMPORT | 0 | PASS | Sin errores del motor. [Comando](evidence/attempt_05/import.json) |
| B1-UNIT | 0 | PASS | 37/37, 0 fallos/errores/omitidos. [JUnit/argv](evidence/attempt_05/b1_unit.json) |
| B1-INTEGRATION | 0 | PASS | 35/35 = 28 anteriores + 7 de paredes, 0 fallos/errores/omitidos. [JUnit/argv](evidence/attempt_05/b1_integration.json) |
| B1-SMOKE | 0 | PASS | 600 frames headless. [Comando](evidence/attempt_05/b1_sandbox_smoke.json) |
| B1-REGRESSION | 0 | PASS | H03 8+8, H04 4; negativo esperado exit 100; H1 34 PASS / 0 FAIL / 1 NOT_RUN. [Comando](evidence/attempt_05/regression_h1_h03_h04.json), [H1/H03](evidence/attempt_05/regression/regression/summary.json) |

Comando principal (cwd del candidato):

```powershell
& C:/dev/tools/alabarda-pipeline-v21-venv/Scripts/python.exe -X utf8 tools/b1/run_tests.py --godot C:/Users/aleja/Downloads/Godot_v4.7.2-stable_win64.exe/Godot_v4.7.2-stable_win64_console.exe --output C:/dev/ALABARDA_B1_WALL_FIX_20261127/attempt_05
```

Runner exit 0, [invocación/fechas](evidence/attempt_05/preflight/runner.json), [summary](evidence/attempt_05/summary.json). Sin --skip-regression ni --graphics. [BUG-B1-02](bugs/BUG-B1-02.md) tiene fix técnico PASS, pendiente de retest del creador.

## Veredicto vigente tras el fix

**Automáticas PASS sobre `1401e05269fc4919f3658788e7de48bc5a4aa148`. INTEGRATION_READY; no VALIDATED ni APPROVED.** M-01…M-08 en este candidato: NOT_RUN, «las realiza el creador»; fichas en `evidence/attempt_05/manual/`. Los siete OK y M-02 KO de la revisión anterior conservan su contexto y no se atribuyen a este nuevo SHA. Repetir paredes (M-02) y revisar movimiento/cámara/disparo afectados (M-03/M-06), indicando SHA. La cámara puede limitar su giro junto al muro para que el arma mantenga su posición sin penetrarlo; sensación/aceptación pendientes. Sin merge a main ni inicio de B2.

## Aprobación e integración posterior

El creador confirmó el fix y aprobó B1: [APPROVAL](APPROVAL.md). Se autoriza integrar como juego normal, preparar B2 y fusionar a main/retirar B1. [Integración `5a622069c4267821ba5e5a16b6404a60ed7ad6a8`](INTEGRATION.md): 37 unitarias, 38 integración y regresiones PASS. Los NOT_RUN manuales del intento 05 quedan como registros anteriores a esa confirmación, sin reescribir ejecuciones pasadas.
