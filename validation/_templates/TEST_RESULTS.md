# TEST_RESULTS — plantilla, todas las pruebas sin ejecutar

Lote / hitos / intento / fecha / rol / SHA esperado C / **SHA realmente probado** / SHA paquete P / rama / árbol limpio antes de tests. Si SHA no coincide: BLOCKED, detener antes de ejecutar.

Entorno real: OS/hardware/driver/renderer, Godot, GdUnit4, Python, Blender si utilizado, resolución/foco si gráfico. No copiar versiones esperadas como si se hubieran medido.

| ID | Commit | Comando exacto + cwd o pasos manuales | Exit | Estado | Evidencia / causa |
|---|---|---|---|---|---|
| COMPLETAR | No probado | No ejecutado | — | NOT_RUN | Plantilla; Claude no dispone de Godot/Blender |

Por caso: duración/timeout, asserts/contadores/JUnit, stdout/stderr, log, captura original si existe, esperado vs observado, bugs y regresiones. Registrar control negativo por su expectativa exacta, no por exit0. Rutas relativas al paquete; cada intento en directorio nuevo e inmutable.

## Veredicto técnico

NOT_RUN: plantilla. No hay validación ni aprobación. Al ejecutar: alcance real, PASS/FAIL/NOT_RUN/BLOCKED por grupo, fallos críticos, límites y estado del lote. No trasladar PASS entre SHAs.

## Correcciones y repetición

Bug / commit fallido / fix commit / caso del bug / regresiones afectadas / nuevo intento y resultado. Preservar evidencia anterior; no sobrescribirla.

## Validación del creador

PENDING_APPROVAL. Checklist del handoff, respuesta expresa, fecha, SHA y alcance; rechazos y condiciones pendientes. No rellenar aceptación por inferencia.
