# TEST_RESULTS — B1 (H05, H06)

Lote B1 · hitos H05, H06 · rama `B1` · SHA esperado C `bfe7071b63e756200f4e1ea94160175bc6294644` · SHA paquete P: comunicado en la entrega.

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

## Veredicto técnico

**NOT_RUN.** Solo análisis estático y comprobaciones de pipeline en PASS. Ningún test Godot ejecutado: B1 no está VALIDATED. Estado del lote: `INTEGRATION_READY`.

## Intento 01 · PC Codex (por completar)

Registrar: SHA realmente probado (debe ser C; si no coincide, BLOCKED y parar), árbol limpio, versiones reales (Godot, GdUnit, Python, OS/GPU), comando exacto y cwd por ID, exit, recuentos JUnit, logs, capturas manuales, bugs y regresiones. Directorio de evidencia nuevo `evidence/attempt_01/`; no sobrescribir este intento 00.

| ID | Commit | Comando + cwd o pasos | Exit | Estado | Evidencia / causa |
|---|---|---|---|---|---|
| B1-IMPORT | | | | NOT_RUN | |
| B1-UNIT | | | | NOT_RUN | |
| B1-INTEGRATION | | | | NOT_RUN | |
| B1-SMOKE | | | | NOT_RUN | |
| B1-REGRESSION | | | | NOT_RUN | |
| M-02-WALL | | | | NOT_RUN | |
| M-04-INTERACT | | | | NOT_RUN | |
| M-05-REGEN | | | | NOT_RUN | |
| M-07-DEATH | | | | NOT_RUN | |

## Correcciones y repetición

Ninguna todavía. Por cada bug: ID, commit fallido, commit del fix, test del bug, regresiones repetidas, nuevo intento y resultado; conservar la evidencia anterior.

## Validación del creador

PENDING_APPROVAL. M-01-DASH, M-03-MOVE, M-06-COMBAT y M-08-H1 más la checklist I del handoff; respuesta expresa con fecha y SHA. No se rellena por inferencia.
