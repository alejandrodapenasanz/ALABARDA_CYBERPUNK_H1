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

## Veredicto técnico y siguiente paso

**Automáticas PASS sobre `94e4880b03b60d1517917d11ab98dce786499d69`.** Estado del lote: **INTEGRATION_READY**, con manuales críticas pendientes; **no VALIDATED ni APPROVED**. El candidato original conserva su FAIL.

El creador hará M-01…M-08 con [manual_tests_B1.md](../../manual_tests_B1.md) sobre el candidato corregido y enviará el bloque OK/KO. No hay aprobación manual inferida, no se fusiona a main y no se inicia B2.
