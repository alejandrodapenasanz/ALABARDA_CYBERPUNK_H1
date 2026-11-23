# TEST_STRATEGY — pruebas por entorno y por commit

**2026-11-23 · v2.1, migración aprobada por el creador 2026-11-23 (D-028).** [Workflow](DEVELOPMENT_WORKFLOW.md), [histórico íntegro](history/pre_pipeline_v2_1/docs/TEST_STRATEGY.md). Los resultados H1–H04 no se recalifican.

## Capacidades y resultado

| Prueba | Claude | Codex | Creador |
|---|---|---|---|
| Documentación, JSON/schema, archivos/IDs, lógica externa sin motor, sintaxis GDScript y referencias .tscn/.tres (`check_godot_static.py`) | Prepara y puede ejecutar si dispone de Python/dependencias | Puede ejecutar | Revisa decisiones |
| Unitarias GDScript, importación, escenas, integración y regresión | Prepara fixtures/scripts y pasa `check_godot_static.py`; ejecución NOT_RUN, sin Godot | Ejecuta en Godot exacto con logs/exit/contadores | Revisión complementaria |
| Blender/GLB | Prepara requisitos/scripts; NOT_RUN, sin Blender | Solo si el caso requiere autoría/inspección | Aprueba resultado artístico |
| Gráficos, animación, profiling | Prepara pasos; NOT_RUN | Ventana real, hardware/config/capturas originales | Aprueba legibilidad, sensación y arte |
| Movimiento, gunplay, dificultad, UX | Prepara escenas/pasos; no autoaprueba | Reproduce aspectos técnicos | Acepta o rechaza expresamente |
| Export Windows | Prepara configuración y checklist | Export con templates/versiones resueltos y prueba real | Prueba build final |

PASS: ejecutado y cumple el esperado, con comando/entorno/SHA/evidencia. FAIL: ejecutado e incumple. NOT_RUN: no ejecutado, con motivo. BLOCKED: impedimento concreto para ejecutarlo/completarlo, con condición de salida. Control negativo puede esperar exit100: PASS del verificador requiere exactamente el caso/fallo previsto. Exit0 solo no basta.

Estados de trabajo no son resultados de tests: CODE_READY, INTEGRATION_READY, VALIDATED y APPROVED tienen puertas distintas. VALIDATED técnico exige todos los críticos; APPROVED además validación expresa humana. La plantilla no contiene resultados. Corrección invalida atribuir PASS al nuevo SHA hasta repetir casos y regresiones afectadas.

## Paquete por SHA

**Transferencia completa2026-11-23:** [GITHUB_TRANSFER](GITHUB_TRANSFER.md) define instalación desde main y `tools/pipeline/verify_checkout.py`. El hash del índice local solo pertenece a la auditoría original. Cuando existe checkout_manifest.json, check_docs y la integridad del runner usan esa baseline portable explícita; no exigen assets excluidos. No se sobrescriben snapshots ni excepciones históricas. Después de editar B1 se verifica su nuevo candidato y regresiones, sin regenerar hashes para ocultar cambios.

Claude entrega A–K en TEST_HANDOFF y manifest schema1.0.0, más resultados iniciales y evidence/. Identificar candidato C y paquete posterior P; ejecutar en worktree limpio de C y escribir evidencia fuera. **Mismatch de SHA detiene antes de tests.** La copia original sin HEAD no sirve como candidato Git por inferencia. [Procedimiento Git y transporte completo](DEVELOPMENT_WORKFLOW.md).

Manifest contiene IDs, tipo, comandos como executable/args, cwd, datos/precondiciones, timeout, esperado/PASS/FAIL, entorno, dependencias y logs. Manuales contienen escena, apertura/ejecución, controles, estado inicial, pasos numerados y repetición. El checker rechaza claves desconocidas/duplicadas, ciclos, rutas fuera de evidencia, comandos inline/destructivos conocidos y faltas de paquete; **no ejecuta comandos y no es un sandbox ni certifica que un script arbitrario sea seguro**. Revisar scripts/comandos del candidato antes de un futuro ejecutor PowerShell. No existe todavía un ejecutor universal de manifests.

## Comprobaciones documentales v2.1

Python3.11+; JSON Schema Draft2020-12 validado con jsonschema4.23.0 y dependencias fijadas en [requirements](../tools/pipeline/requirements.txt). Instalar en entorno virtual externo al candidato, sin dependencia nueva del juego:

```powershell
python -m venv C:/dev/tools/alabarda-pipeline-v21-venv
& C:/dev/tools/alabarda-pipeline-v21-venv/Scripts/python.exe -m pip install -r tools/pipeline/requirements.txt
& C:/dev/tools/alabarda-pipeline-v21-venv/Scripts/python.exe -X utf8 tools/pipeline/validate_manifest.py validation/_templates/TEST_MANIFEST.json
& C:/dev/tools/alabarda-pipeline-v21-venv/Scripts/python.exe -X utf8 tools/pipeline/test_manifest.py
python -X utf8 tools/pipeline/check_docs.py
python -X utf8 tools/pipeline/check_godot_static.py
git diff --check
```

`check_godot_static.py` (gdtoolkit, D-028) analiza sin Godot la sintaxis GDScript, `class_name` duplicados y referencias res:// de scripts/.tscn/.tres/project.godot; errores bloquean, avisos gdlint (`gdlintrc`) solo informan, y los hallazgos aceptados del legado están en `tools/pipeline/static_baseline.json` con motivo. Su PASS **no** demuestra importación ni ejecución: los tests Godot siguen NOT_RUN hasta Codex. La primera orden de manifest valida una **plantilla**, no INTEGRATION_READY. Para un paquete real: ejecutar `validate_manifest.py <ruta-manifest> --ready --candidate <worktree-C>` con campos completados y SHA real. Las rutas entre `<...>` son marcadores, no comandos literales. El resultado registra cero comandos ejecutados desde el manifest. `check_docs.py` comprueba esta migración respecto a su snapshot, no impone inmutabilidad de gameplay a todos los hitos futuros. Histórico/paquetes públicos se preservan por hash; no se convierten en guías activas.

## Godot y regresiones existentes (no ejecutadas en esta migración)

Godot4.7.2.stable.official.ed1daf0bf, Compatibility, GdUnit4 **6.2.3 MIT** vendorizado, Python3.11+ (observado3.13.15), PowerShell. Blender4.5.3 solo autoría. Detectar ruta/versiones en cada PC; Claude no dispone de los dos motores. Reinstalar addon ausente con `python -X utf8 tools/h03/install_gdunit.py`, URL/SHA fijados, sin plugin de editor. Versiones distintas requieren comprobar compatibilidad; no heredan PASS.

Comandos existentes desde raíz, con GODOT_BIN resuelto al console.exe y directorio de evidencia nuevo:

```powershell
& $env:GODOT_BIN --version
& $env:GODOT_BIN --headless --path . --editor --import --quit
& $env:GODOT_BIN --headless --path . -s res://addons/gdUnit4/bin/GdUnitCmdTool.gd -a res://tests/h03/unit --ignoreHeadlessMode
& $env:GODOT_BIN --headless --path . -s res://addons/gdUnit4/bin/GdUnitCmdTool.gd -a res://tests/h03/integration --ignoreHeadlessMode
& $env:GODOT_BIN --headless --path . --fixed-fps 60 --script res://tests/h02/h1_probe.gd -- --edges
powershell -NoProfile -ExecutionPolicy Bypass -File tools/run_tests.ps1 -Godot $env:GODOT_BIN -OutputDir <directorio_nuevo>
python -X utf8 tools/h04/run_tests.py --godot $env:GODOT_BIN --output <directorio_nuevo> --graphics
```

No ejecutar literalmente marcadores. Para paquetes C/P, resolver rutas absolutas de logs fuera de C. Suites globales incluyen control negativo aislado (exit100,1 failure esperado,0 errors/skips) y chequean JUnit/logs/conteos. No ejecutar `-a res://tests` indiscriminadamente. Históricos finales H04:20 positivos GdUnit (8 unitarias+8 integración H03+4 H04), H1 probe34 PASS/0 FAIL/1 NOT_RUN de clic físico headless. Ese clic tiene confirmación humana separada, no PASS headless.

**Integridad antigua:** runner H03/H04 también comprueba hash de AGENTS contra snapshot anterior. Esta migración lo modifica autorizadamente, pero no altera el log ni las excepciones históricas para hacerlo pasar. Al preparar el baseline documental aprobado para B1, versionar la nueva política de invariantes con referencia al snapshot/diff aprobado; nunca aceptar cambios automáticamente ni borrar checks. Hasta entonces no usar el resultado histórico del runner como PASS de esta edición. La comprobación de conservación propia de v2.1 cubre scripts/escenas/Resources/assets/tests/evidencia e índice. Los futuros refactors autorizados necesitan regresiones de comportamiento y baseline explícito, no restaurar requisitos F por un test legado.

## B1 (H05/H06) · runner del lote

PC Codex, en un worktree limpio del SHA C: `python -X utf8 tools/b1/run_tests.py --godot <console.exe 4.7.2> --output <directorio nuevo>`. Ejecuta versión, importación, `tests/b1/unit` y `tests/b1/integration` (el recuento JUnit debe igualar los `func test_` declarados), un arranque headless de 600 frames del sandbox y la regresión completa H1/H03/H04 vía `tools/h04/run_tests.py`. `--skip-regression` solo para bucles rápidos de corrección. PC Claude: solo `check_godot_static.py`; el resto NOT_RUN.

## Casos futuros y repetición

[SB-01…SB-29](HEALTH_ENERGY_TEST_CASES.md) y [CT-01…CT-10](CONTROLS.md) son especificaciones NOT_RUN. H06 cubre autoHP y contrato de pausa; H08 energía/E y baja única; H09 ultimates; H10 conexión enemigos; H19 ascensor real; H22 conjunto. No programar H08 para cerrar H06. Economía/inventario/IA/guardado conservan tests de cada prompt: créditos no negativos/doble pago, save corrupto/roundtrip/atomicidad, memoria/oclusiones/alarma, montaje/USB idempotentes y tres dificultades desde H13.

Tras bug: conservar intento fallido, crear nuevo C y P, repetir caso del bug más regresiones justificadas; pruebas completas solo si afecta transversalmente. Sin reciclar capturas ni contadores. Informe incluye datos/fecha/OS/hardware/versiones/comando/exit/cwd/SHA, logs completos, limitaciones y checklist humana. Export Windows al cierre del MVP y cuando afecte exportación; no exigido ahora.
