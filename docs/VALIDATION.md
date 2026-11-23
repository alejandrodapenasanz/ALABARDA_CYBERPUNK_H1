# Decisiones D-027/D-028 y validador estático · 2026-11-23

**Origen:** decisiones expresas del creador en conversación con Claude (PC Claude, sin Godot ni Blender). Solo documentación y herramientas del pipeline; no se modifican scripts de juego, escenas, Resources, assets ni tests Godot.

- **D-027:** interacción con F; ascensor a energía 150 sin tocar HP confirmado; **sin regeneración pasiva de energía** (energía solo por bajas +15 provisional y ascensor); slots 1/2/3 libres sin categoría. Resuelve P-015 y P-016; sustituye la pasiva 8/s de D-024. Sincronizado en AGENTS, DECISIONS, contrato, casos SB (SB-10/17/21 reescritos), CONTROLS, BALANCE y prompts H05–H09, H13–H15, H18, H19, H22.
- **D-028:** migración v2.1 **aprobada por el creador**; una rama por lote desde `main` (`B1`…`B8`), fusión a `main` tras VALIDATED + APPROVED y nueva verificación en `main`.
- **Nuevo:** `tools/pipeline/check_godot_static.py` (gdtoolkit 4.5.0), `gdlintrc`, `tools/pipeline/static_baseline.json`; `check_docs.py` exige las reglas D-027; `run_checks.py` incluye el validador estático y usa `core.whitespace=cr-at-eol` como ya documentaba esta validación.

Resultados reales (Windows 11, Python 3.14, venv con `tools/pipeline/requirements.txt`), `python -X utf8 tools/pipeline/run_checks.py`:

| Comprobación | Resultado |
|---|---|
| schema (plantilla TEST_MANIFEST) | PASS, exit 0 |
| manifest_tests | PASS, 16/16 |
| godot_static | PASS: 18 .gd parsean, 8 .tscn/.tres sin referencias rotas nuevas; 20 hallazgos aceptados del legado con motivo; 1 aviso gdlint (falso positivo en `modern_psx_lab.gd:81`) |
| whitespace (cr-at-eol) | PASS |
| documents (verify_checkout) | PASS tras regenerar `checkout_manifest.json` con los ficheros de esta entrega |
| check_docs (comprobaciones de contenido) | 0 errores de contenido; las de PC original/índice histórico no aplican a un clon |

Control negativo del validador estático: un .gd con error de sintaxis y un .tscn con ruta inexistente, id no declarado y padre inexistente → FAIL con los 4 errores. **Tests Godot: NOT_RUN** (no existen en este PC). B1 NOT_STARTED.

# Transferencia completa a GitHub ? 2026-11-23

Publicaci?n solicitada expresamente para descargar en otro PC y revisar la migraci?n antes de B1. B1 NOT_STARTED; migraci?n PENDING_APPROVAL. C?digo, documentaci?n completa, prompts, plantillas, herramientas, hist?ricos, evidencia y recursos redistribuibles incluidos; exclusiones de modelos enumeradas en [gu?a](GITHUB_TRANSFER.md) y manifiesto portable.

Validaci?n real de la copia Git aislada: `python -X utf8 tools/h04/run_tests.py --godot C:/Users/aleja/Downloads/Godot_v4.7.2-stable_win64.exe/Godot_v4.7.2-stable_win64_console.exe --output C:/dev/ALABARDA_CYBERPUNK_H1/docs/evidence/github_transfer_20261123/headless`, exit0. [Resumen](evidence/github_transfer_20261123/headless/summary.json): importaci?n/arranque/integridad PASS;20 casos GdUnit positivos PASS; control negativo esperado verificado; H1 regresi?n PASS con clic f?sico NOT_RUN headless. No nuevas pruebas gr?ficas ni aprobaci?n humana inferida.

Verificador portable PASS (2776 archivos en la preparaci?n inicial,688 enlaces),16/16 tests de manifest PASS y test de integridad portable PASS. Inventario final se ampl?a con estos logs y est? en checkout_manifest.json. Git whitespace con `git -c core.whitespace=cr-at-eol diff --check`: exit0; se conservan bytes CRLF hist?ricos. ?ndice Git del workspace original intacto. SHA de descarga: `git rev-parse HEAD` en el clon de main.

# VALIDATION — migración documental pipeline v2.1

## Entrega 2026-11-23 · pendiente de validación expresa

Trabajo documental iniciado el 2026-11-22 y completado para revisión el 2026-11-23. **PENDING_APPROVAL; B1 NOT_STARTED.** Ningún hito de gameplay se ejecuta ni se aprueba por esta migración. H1–H04 conservan sus cierres históricos. [Informe de15 apartados e inventario](PIPELINE_MIGRATION_REPORT.md), [workflow](DEVELOPMENT_WORKFLOW.md), [snapshot de entrada](evidence/pipeline_v2_1/before.json).

### Entorno y comandos reales

Windows11 build26200, Python3.13.15. Entorno Python aislado fuera del proyecto en `C:/dev/tools/alabarda-pipeline-v21-venv`; instalación ejecutada con `python -m venv C:/dev/tools/alabarda-pipeline-v21-venv` y su Python `-m pip install -r tools/pipeline/requirements.txt`, exit0. JSON Schema Draft2020-12, jsonschema4.23.0 y dependencias fijadas; [versiones realmente instaladas](evidence/pipeline_v2_1/run_02/dependencies.stdout.log). Ninguna dependencia del juego añadida.

Desde `C:/dev/ALABARDA_CYBERPUNK_H1`, PowerShell:

```powershell
& C:/dev/tools/alabarda-pipeline-v21-venv/Scripts/python.exe -X utf8 tools/pipeline/run_checks.py --output docs/evidence/pipeline_v2_1/run_02 --godot-version-only C:/Users/aleja/Downloads/Godot_v4.7.2-stable_win64.exe/Godot_v4.7.2-stable_win64_console.exe
```

[Resumen/argv/cwd/fechas UTC/exit/tiempos](evidence/pipeline_v2_1/run_02/summary.json). Cada proceso conserva stdout/stderr. No se ejecutan comandos del manifest ni se inicia Godot para probar un hito; solo `--version`.

| Comprobación | Resultado real | Evidencia / alcance |
|---|---|---|
| Meta-schema Draft2020-12 y plantilla JSON | PASS, exit0 | [schema](evidence/pipeline_v2_1/run_02/schema.stdout.log); plantilla válida, NO paquete INTEGRATION_READY |
| Tests de verificador | PASS,16/16, exit0 | [unitarias de metadata](evidence/pipeline_v2_1/run_02/manifest_tests.stderr.log); commits exactos/árbol limpio en repo temporal, faltas de datos, fechas, dependencias/ciclos, rutas, comandos, roles y estados |
| Preservación e integridad documental | PASS, exit0 | [auditoría](evidence/pipeline_v2_1/run_02/documents.stdout.log);2705 archivos protegidos intactos,41 históricos por hash,23 prompts mismos IDs/rutas,9 lotes,29 SB/10 CT especificados, links locales, valores/clasificación y Git index intacto |
| Whitespace | PASS, exit0 | [git diff --check](evidence/pipeline_v2_1/run_02/whitespace.stderr.log); avisos CRLF no son errores |
| Versión de Godot | PASS consulta, exit0 | [4.7.2.stable.official.ed1daf0bf](evidence/pipeline_v2_1/run_02/godot_version_only.stdout.log); NO PASS de import/gameplay |

### Fallo conservado y corrección

Primera ejecución [run_01](evidence/pipeline_v2_1/run_01/summary.json): schema/documentos/whitespace/versiones PASS, suite metadata FAIL (15/16). Un timestamp inválido no se rechazaba porque el formateador RFC3339 es opcional en jsonschema sin extras. [Fallo y traceback](evidence/pipeline_v2_1/run_01/manifest_tests.stderr.log). Se añadió validación explícita con biblioteca estándar, incluyendo zona horaria y fecha calendario real, y casos de regresión. Run_02 conserva16/16 PASS; no se rebajó el test ni se sustituyó el log fallido.

Intento inicial de patch fue rechazado por operaciones repetidas sobre AGENTS sin modificar archivos; se aplicó después por operaciones separadas, con original ya archivado. Una búsqueda con glob de PowerShell no admitido se repitió mediante rg -g. No afectan pruebas del juego ni se presentan como ejecuciones exitosas.

### NOT_RUN y límites

Importación y suites Godot/H03/H04/H1, gameplay nuevo, Blender, gráficos, export Windows: **NOT_RUN durante esta tarea**, que prohíbe ejecutar hitos. Los29 casos SB y10 CT son contratos futuros, no tests de gameplay implementados. Transferencia real entre dos PC con candidato B1 NOT_RUN. Solo se verificó el protocolo de SHA mediante repositorio temporal aislado; no hay commit en esta carpeta original.

URLs externas/licencias nuevas no verificadas; no nuevos assets. Tests históricos de datos H03 no prueban autoHP/E/pasiva/bajas y los de extracción quedan SUPERSEDED como aceptación futura. Runner antiguo conserva hash AGENTS previo; documentado en TEST_STRATEGY para crear baseline aprobado sin alterar evidencia histórica. Herramientas actuales de migración sí verifican runtime/assets/tests/fuentes intactos.

Aprobación semántica y entrega de migración: **PENDING_APPROVAL del creador**. Tecla de interacción P-015, slots P-011/P-016 y remates P-017 documentados, sin resolverlos por inferencia. No se publica la migración como aprobada ni se inicia B1.

## Histórico de validación anterior — bytes íntegros conservados

Los estados y resultados siguientes pertenecen a sus fechas/SHAs; no son afirmaciones sobre las nuevas reglas. Las referencias a F/entregas previas están SUPERSEDED cuando DECISIONS lo especifica. La aprobación H1–H04 permanece válida con su alcance original.

> **Estado vigente · 2026-11-22: H04 CERRADO Y APROBADO POR EL CREADOR / PASS.** Suite técnica y revisión manual satisfechas. H1–H04 cerrados; H05 no iniciado. Los resultados y estados previos se conservan como antecedentes.

## Cierre H04 · confirmación del creador 2026-11-22

El creador responde «Si, todo me cuadra» a la lista final de revisión: aspecto de materiales/colores/props, silueta y HomeVideo con tres luces, cámaras/brazos/reset y smoke H1. **PASS manual declarado de la revisión conjunta**, sin desglose o logs inventados. [Fuente y contexto](evidence/h04/manual_approval_20261122.txt). Aceptación de referencia experimental D-021; los assets siguen siendo pruebas. No se infieren otras resoluciones, equipos ni límites finales de producción.

La suite local [run_02](evidence/h04/run_02/summary.json) ya es PASS/exit 0: 20 tests positivos, H1 34 PASS/0 FAIL/1 NOT_RUN headless físico, control negativo detectado, importación, integridad y gráficos. La aprobación humana es independiente de aquel NOT_RUN; no se reescriben logs ni los FAIL anteriores. No hay requisito obligatorio pendiente del hito; **H04 CERRADO**. H05 no autorizado por este cierre.

Este acto no cambia el juego ni los assets aprobados. Se actualizan documentación/estados y preparación de copia pública; el texto de limitaciones del runner remite ahora la aceptación humana a este documento, sin adjudicarla al test. La copia pública debe probarse con el sustituto propio y sin recursos locales antes del push. Export Windows y otros equipos/sesiones largas permanecen NOT_RUN fuera del alcance H04.

**Publicación preparada y probada:** copia nueva `C:/dev/ALABARDA_CYBERPUNK_H04_RELEASE`, con kit/fuentes/tests H04 y documentación pública breve; sin originales, Malorian ni evidencia privada. Ejecutado desde esa copia: `python -X utf8 tools/h04/run_tests.py --godot 'C:/Users/aleja/Downloads/Godot_v4.7.2-stable_win64.exe/Godot_v4.7.2-stable_win64_console.exe' --output C:/dev/ALABARDA_CYBERPUNK_H1/docs/evidence/h04/public_release --graphics`. [Resumen público](evidence/h04/public_release/summary.json) **PASS/exit 0**: 20 tests positivos, H1 34/0/1, control negativo, importación desde cero, integridad pública, gráficos y legibilidad con fallback propio. No se atribuyen 908 originales a la copia pública; su baseline es el conjunto H1 publicado.

Control de privacidad inicial [FAIL](evidence/h04/public_scan.json): los tres `.blend` propios conservaban la carpeta personal Documents en el estado de su explorador de archivos. Se eliminó mediante API de Blender, sin modificar geometría/materiales/UV ni ningún GLB/textura. [Limpieza ejecutada](evidence/h04/source_metadata_cleanup.json), PASS/exit 0; conteos/UV y hashes GLB verificados. El generador evita conservar esa carpeta en futuras fuentes. Solo se actualizan hashes de los `.blend` en manifiesto; los assets externos permanecen intactos. La copia saneada se comprueba por hashes antes de publicar; no requiere repetir gameplay ya probado sin cambios.

**Publicación completada:** [escaneo final](evidence/h04/public_scan_final.json) PASS, fuentes/GLB cotejados; 32 archivos cambiados en copia pública. `git diff --cached --check` con cr-at-eol PASS; commit `48f972c6ebeac2a4c7e6ab526e7dead43ad2baba`. Primer push [FAIL/124](evidence/h04/public_push.json) por timeout con conexión reseteada; se inspeccionaron estado y HEAD remoto antes de repetir. [Reintento HTTP/1.1](evidence/h04/public_push_retry.json) **PASS/0**, sin force. Verificación posterior: repo PUBLIC, HEAD remoto idéntico, árbol limpio, 744 archivos coinciden con snapshot probado/saneado y enlaces públicos válidos. [Comprobante final](evidence/h04/publication.json).

Dos scripts existentes se normalizaron a LF para igualar el commit H03 y evitar un diff de todo el archivo; igualdad del contenido normalizado verificada en origen/snapshot/checkout. El intento intermedio CRLF se revirtió al comprobar que Git guardaba LF. [Registro](evidence/h04/line_endings.json). No cambió lógica ni resultado visual. La interrupción del orquestador durante el primer push no se confundió con éxito: commit había terminado, push no, y se verificaron ambos antes del reintento. **H04 cerrado y publicado; H05 no iniciado.**

## H04 — vertical artística temprana · 2026-11-22

Antes de editar: AGENTS completo, documentos requeridos, prompt H04, código/escenas y Git leídos. Todos los documentos obligatorios presentes; PDF original ausente como antecedente, sin bloquear este hito. Godot identificado 4.7.2.stable.official.ed1daf0bf; Blender ausente de PATH y búsqueda de programas/descargas/dev. Se usa portátil oficial 4.5.3 con hash verificado, fuera del proyecto. Windows 11 10.0.26200, Python 3.13.15, GdUnit4 6.2.3. [Encargo](evidence/h04/request.txt), [310 hashes de entrada](evidence/h04/before.json), [Git previo](evidence/h04/git_before.txt). Índice histórico preservado, sin reset ni commit en workspace.

Implementación: misma sala/ruta H03, kit original de tres GLB/fuentes Blender, Resource visual, paleta y materiales por instancia, arquitectura/conducciones/señales HomeVideo, silueta revisada, tres luces comparables y viewmodel/rig de prueba conservados. `project.godot`, main.tscn y los tres scripts H1 permanecen intactos. No se implementan H05, IA, alarmas de gameplay, combate, animación de equipar ni nuevos parámetros de balance.

### Comandos y resultados reales

Comando completo final, cwd raíz:

```powershell
python -X utf8 tools/h04/run_tests.py --godot 'C:/Users/aleja/Downloads/Godot_v4.7.2-stable_win64.exe/Godot_v4.7.2-stable_win64_console.exe' --output docs/evidence/h04/run_02 --graphics
```

**PASS global, exit 0**, [summary.json](evidence/h04/run_02/summary.json). Cada etapa guarda argv, PowerShell exacto, fecha, OS, exit y stdout/stderr completos. Sin errores de motor en la ejecución final. El runner H04 ejecuta la suite H03 completa antes de añadir sus pruebas.

| Prueba ejecutada | Estado / salida | Evidencia |
|---|---|---|
| Blender portátil descargado y SHA-256 cotejado | PASS | [URL/hash/exe](evidence/h04/blender_download.json); fuente oficial y copyright local GPL |
| `blender.exe --background --factory-startup --python tools/h04/build_kit.py` | PASS / 0 | [Export final](evidence/h04/blender_export_02.json); tres blend + tres GLB + manifiesto |
| Godot versión e importación headless | PASS / 0 | [Import](evidence/h04/run_02/regression/import.json) |
| Unitarias H03 | 8 PASS, 0 failures/errors/skips / 0 | [Unit](evidence/h04/run_02/regression/unit.json) |
| Integración H03 | 8 PASS, 0 failures/errors/skips / 0 | [Integración anterior](evidence/h04/run_02/regression/integration.json) |
| Integración H04 | 4 PASS, 0 failures/errors/skips / 0 | [Integración nueva](evidence/h04/run_02/integration.json) |
| Fallo deliberado | Detector PASS; exactamente una aserción fallida, raw exit 100 esperado | [Control negativo](evidence/h04/run_02/regression/negative_control.json) |
| Arranque H1 | PASS / 0 | [Startup](evidence/h04/run_02/regression/startup.json) |
| Regresión H1 | 34 PASS / 0 FAIL / 1 NOT_RUN; exit 0 | [Log](evidence/h04/run_02/regression/h1_regression.stdout.log); clic/captura físicos fuera del backend headless |
| Originales/históricos y selección de assets | PASS / 0 | [Integridad H03](evidence/h04/run_02/regression/integrity.json), 908 protegidos |
| GLB y fuentes Blender coinciden con manifiesto | PASS | [Kit](evidence/h04/run_02/kit_integrity.json) |
| Gráficos y legibilidad de H03 sobre sala evolucionada | PASS / 0 ambos | [Graphics](evidence/h04/run_02/regression/graphics.json), [readability](evidence/h04/run_02/regression/readability.json) |
| Tres luces × cuatro cámaras, coste y capturas H04 | PASS técnico / 0 | [Probe](evidence/h04/run_02/lookdev_graphics.json), [métricas y datos crudos](evidence/h04/run_02/graphics/metrics.json) |
| Aceptación estética y smoke físico por creador | PENDING_APPROVAL / NOT_RUN en H04 | Pasos concretos en HANDOFF; confirmación H03 no sustituye esta revisión |
| Export Windows, otros equipos/sesiones largas | NOT_RUN; fuera de la puerta H04, sin cambios de export | Sin PASS atribuido |

Los cuatro casos H04 comprueban dimensiones/pivote Y=0/UV/materiales/triángulos tras importación, vuelta exacta al perfil aprobado tras tres luces y reset, ocho instancias de kit y materiales independientes entre escenas, señales HomeVideo/cámara/viewmodel separado de gameplay. No son pruebas de gusto ni diversión.

Capturas originales, sin retoque: [atmósfera](evidence/h04/run_02/graphics/atmospheric_camera_1.png), [neutra](evidence/h04/run_02/graphics/neutral_camera_1.png), [alarma](evidence/h04/run_02/graphics/alarm_camera_1.png). Diferencia media de píxeles frente a atmósfera: 0.05089 neutra / 0.03349 alarma en escala 0–1; demuestra cambio real de luz, no legibilidad humana. 70 meshes/88 materiales, 410 draw calls con sombras/131 sin ellas. Medias 2.228/2.155/2.100/1.111/2.290 ms para atmósfera/neutra/alarma/sin sombras/repetición. Hardware/configuración y límites en ART_BIBLE; sin objetivo de FPS inventado.

### Fallos conservados y correcciones

- `import_01`: proceso exit 0 pero **FAIL** por dos Parse Error al acceder a arrays de cámara con valores por defecto no serializados. El detector de logs lo rechaza. Se serializaron ambos arrays en lookdev.tres; `import_02` PASS/0 y final import PASS. [Fallo](evidence/h04/import_01.json), [corrección](evidence/h04/import_02.json).
- Primer preview gráfico PASS técnico, con observación visual de materiales demasiado claros y señales pequeñas. Se corrigió conversión sRGB→lineal del material Blender, se regeneró kit y se mejoró texto físico con viewport 320×128/filtro lineal. No se alteraron imágenes de evidencia ni texturas originales suministradas.
- `run_01` **FAIL global**: nueva aserción comparaba float 0.0 con int 0 mediante igualdad tipada de GdUnit. Dos casos registrados antes de detenerse, uno fallido; no se atribuyen cuatro ejecutados a ese run. Corregida expectativa a 0.0; `integration_02` 4 PASS/exit 0. Tras ajuste de señales se repitió suite completa `run_02`, PASS. [Primer resumen](evidence/h04/run_01/summary.json), [repetición focalizada](evidence/h04/integration_02.json).
- Búsqueda inicial de Blender retornó exit 1 por ausencia en PATH; descarga del listado oficial realizada con urllib tras fallar el acceso del lector web. ZIP comprobado contra checksum oficial antes de ejecutar. No se ocultó ni se fingió una instalación previa.

**Puerta técnica satisfecha; cierre H04 pendiente de la revisión del creador.** H05 sin iniciar. GitHub sigue en cierre H03; no publicación de esta entrega todavía. Archivos cambiados, conservación de H1 y enlaces se registran en [auditoría de entrega](evidence/h04/delivery_audit.json).

Auditoría de entrega ejecutada: `python -X utf8 tools/h04/audit_delivery.py`, **PASS/exit 0**; 13 documentos y 288 enlaces locales verificados, ocho archivos de runtime/configuración protegidos idénticos, cero archivos eliminados, `git diff --check` exit 0. Los originales/selección tienen además la comprobación H03 de 908 protegidos. THIRD_PARTY_NOTICES existía antes pero quedó fuera de la captura inicial de hashes: se clasifica como modificado por la lectura/edición registrada, sin inventar su hash de entrada. [Diff de los dos scripts evolucionados](evidence/h04/runtime_changes.diff) contra la publicación H03 para revisión; el resto son módulos/kit/tests nuevos y documentación. No se vuelve a ejecutar Godot tras estas ediciones exclusivamente documentales.

## Cierre H03 · aprobación manual recibida 2026-11-22

El creador responde «1. Si» a la comprobación H1 (movimiento, ratón, disparo, eliminar cinco blancos y R), y «Si, me gustala fuente home video, se lee bien y en la camara 4 con a se mueven los brazos» al laboratorio. Solicita actualizar H03, terminarlo si era lo último y publicar en GitHub. [Mensaje conservado](evidence/h03/manual_approval_20261122.txt). Se registra **PASS manual declarado** de ambas comprobaciones; no se inventan logs de teclado, tamaños adicionales ni nuevas capturas del creador. D-019 ya aprobaba el perfil visual; D-020 registra preferencia y legibilidad de HomeVideo en el contexto probado.

Puerta de H03 satisfecha: implementación entregada, [run_06_selected_profile](evidence/h03/run_06_selected_profile/summary.json) global PASS/exit 0 (8 unitarias, 8 integración, 34 comprobaciones H1), fallo deliberado detectado, importación/recursos/arranque/gráficos PASS, documentación y aprobación manual. El caso de clic físico sigue NOT_RUN en el informe headless por su limitación técnica; la prueba humana se aprueba en este registro separado. Ningún bloqueo crítico pendiente del alcance H03. Se marca **CERRADO / APROBADO POR CREADOR**, sin iniciar H04.

Este cierre solo actualiza documentación/estados. No se cambia código, balance, escenas, modelos, shaders ni tests; se conservan las ejecuciones reales y se comprueba integridad de fuentes y enlaces. No se atribuye una nueva ejecución Godot a este acto documental. Export Windows, Blender, otros equipos y pruebas largas siguen NOT_RUN fuera de la puerta H03. Assets experimentales, restricciones de distribución y parámetros futuros conservan sus límites.

Comprobaciones de cierre ejecutadas: [518 archivos de runtime/tests/UID comparados](evidence/h03/closure_20261122/runtime_matches_published.json) con commit probado `1c66903536b81b191c1cb7008560c781dff1b374`, PASS sin diferencias; [integridad local](evidence/h03/closure_20261122/integrity.json) PASS/exit 0, 908 protegidos y manifiestos de muestras verificados; [enlaces documentales](evidence/h03/document_links.json) PASS mediante `python -X utf8 tools/h03/final_audit.py`. La comparación de código excluye binarios locales; sus hashes se comprueban en integridad. Se conserva el índice original y solo se publica la copia previamente delimitada.

Publicación final ejecutada: seis documentos públicos de cierre, sin cambios de runtime/tests/recursos. `git diff --check` con cr-at-eol PASS; commit `2a89548a20313832f60f5a08b47508e382db43df`, `git push origin main` exit 0, HEAD remoto idéntico por `git ls-remote`, árbol público limpio. Repositorio PUBLIC verificado con gh. [Comprobante](evidence/h03/closure_20261122/publication.json). La colección original, conversaciones, evidencia privada y Malorian local no se publican. **Cierre H03 completado; no queda trabajo obligatorio de este hito.**

## H03 — resultados ejecutados · 2026-11-21

### Selección visual expresa del creador · 2026-11-22

**APROBADO por el creador, D-019:** captura y texto «Esta es la decision final de momento. Quiza en el futuro cambia». Se transcriben estados visibles: nearest+mips, luz atmosférica, 3D (1280,720), retro desactivado, sombras sí, niebla no; slider de retro 70% sin efecto, comparación A/B no activa. Se guarda como selección vigente y revisable, no como propuesta. Esta confirmación aprueba el perfil de la escena mostrada; no se atribuyen pruebas físicas H1, rig o fuentes que no haya descrito ni selección final de assets.

Implementación mínima: cambiar DEFAULT_OPTIONS.atmospheric a true, utilizado tanto por inicio como por reset; ajustar las comprobaciones de reversibilidad y restauración existentes. No shaders/modelos nuevos, H1 intacto. Los registros inferiores que describen reset neutro y ausencia de aprobación de configuración corresponden a momentos anteriores.

Verificación posterior: `powershell -NoProfile -ExecutionPolicy Bypass -File tools/run_tests.ps1 -Godot 'C:/Users/aleja/Downloads/Godot_v4.7.2-stable_win64.exe/Godot_v4.7.2-stable_win64_console.exe' -OutputDir docs/evidence/h03/run_06_selected_profile -Graphics`, **PASS global, exit 0**. [Resumen](evidence/h03/run_06_selected_profile/summary.json): 8 unitarias, 8 integración, H1 34 PASS/0 FAIL/1 NOT_RUN, control negativo esperado exit 100, importación/arranque/integridad/gráficos/legibilidad PASS. Godot 4.7.2/GdUnit4 6.2.3. El test existente comprueba explícitamente el diccionario aprobado tras reset y la intensidad 0.70; los probes gráficos conservan capturas actuales con el perfil atmosférico. No se atribuyen aprobaciones humanas adicionales.

Copia pública: [integración](evidence/h03/public_selected_profile/integration.json) 8 PASS/0 fallos/errores/skips y [integridad](evidence/h03/public_selected_profile/integrity.json) PASS, exit 0 en ambos. Argv exactos y logs en esa carpeta. Suite pública completa NOT_RUN de nuevo para el cambio de valor inicial; sí se ejecutó completa localmente. Publicado commit `1c66903536b81b191c1cb7008560c781dff1b374`, push exit 0, `git ls-remote origin refs/heads/main` idéntico a HEAD y árbol público limpio. Cambio acotado al perfil, sus tests existentes y documentación; sin assets locales en el commit ni alteración del índice original. Auditoría final de enlaces locales y diff whitespace ejecutada.

### Corrección tras capturas del creador · 2026-11-22

Las capturas posteriores confirman que `retro` sí alterna true/false, pero no se percibe efecto útil, y muestran solapes de rótulos/UI. El creador solicita la Malorian esperada en primera persona. Se registra como revisión manual con problemas, **no PASS artístico**. Se mantiene íntegro el diagnóstico y las pruebas anteriores inferiores.

Cambios: interfaz lateral fuera de la vista 3D, títulos/leyendas de cámara externos, fuentes desplegables sin superposición, cámara general frontal más cercana, retro regulable y split A/B, Malorian opcional local. CC0 y permiso del autor contrastados en fuente oficial; originales sin modificar, tres archivos copiados con hashes, excluidos de GitHub. FBX sin textura resuelta: asignación explícita del atlas suministrado, normalización de escala/pivote/orientación en instancia; modelo no publicado. No hay gameplay de arma ni acople de manos. Preservados main.tscn, project.godot, tres scripts H1 e Input Map.

**Suite final local:** [run_05_readability/summary.json](evidence/h03/run_05_readability/summary.json), PASS, salida global **0**, Windows/Godot 4.7.2/GdUnit4 6.2.3. Comando exacto:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File tools/run_tests.ps1 -Godot 'C:/Users/aleja/Downloads/Godot_v4.7.2-stable_win64.exe/Godot_v4.7.2-stable_win64_console.exe' -OutputDir docs/evidence/h03/run_05_readability -Graphics
```

8 unitarias y **8 integración PASS**, 0 errores/fallos/skips. H1 34 PASS/0 FAIL/1 NOT_RUN (clic físico headless). Importación/arranque/integridad PASS/exit 0; 908 archivos protegidos, manifiestos original y local comprobados. Control negativo: una aserción esperada, exit 100; detector PASS. Ventana gráfica y nuevo probe de legibilidad PASS/exit 0; stdout/stderr, argv y JUnit en la carpeta del resumen. Ningún error de motor en ejecución final.

Nueva evidencia: [readability.json](evidence/h03/run_05_readability/readability/readability.json), cuatro cámaras, fuentes abiertas/cerradas en 1280×720 y 960×540; controles y panel fuera del rectángulo 3D. Retro con intensidad 0.70 produce diferencia media RGB **4.839/255** en región central, 143708/144060 píxeles diferentes; intensidad cero **0 píxeles diferentes**. Umbral técnico >2/255 comprueba que el efecto se aplica con amplitud mayor que el anterior; no declara gusto/visibilidad humana aprobados. Capturas reales sin retoque: [general](evidence/h03/run_05_readability/readability/camera_1.png), [CRT](evidence/h03/run_05_readability/readability/camera_2.png), [silueta](evidence/h03/run_05_readability/readability/camera_3.png), [rig](evidence/h03/run_05_readability/readability/camera_4.png), [A/B](evidence/h03/run_05_readability/readability/retro_split.png).

Medición actual en [metrics.json](evidence/h03/run_05_readability/graphics/metrics.json): 31 meshes locales, 181 draw calls base/77 sin sombras. Medias ms: nearest 1.718, linear 1.486, atmósfera 1.399, mitad de resolución/retro/sin sombras/niebla 8.333 cada una. El salto y la meseta cerca de 120 Hz indican una condición de temporización distinta durante la ejecución; el foco de ventana no está controlado. No se atribuye el salto al coste de esos efectos ni se usa esta serie para afirmar mejoras de rendimiento. Datos crudos conservados, sin objetivo FPS inferido.

Historial correctivo: primer inspector ad hoc accedió a global_transform antes de entrar en árbol y produjo avisos; repetido mediante llamada diferida, identificando dos meshes y texturas nulas. Preview gráfico inicial PASS pero reveló arma orientada hacia cámara; yaw corregido a 170°. [run_04](evidence/h03/run_04_readability/summary.json) FAIL global porque un test nuevo infería un Array desde Variant: exit 105 de descubrimiento de integración, sin ocultarlo como fallo esperado. Se tipó Array[Node], se acercó cámara 1 y se repitió suite completa como run_05. El intento de edición anterior a esos runs abortó por truncado de una lectura JSON sin modificar el archivo; no es un fallo de motor.

Revisión manual de la corrección, disparo/captura físicos H1 actuales, export Windows y selección final de assets: PENDIENTE/NOT_RUN según corresponda. H03 no cerrado; H04 no iniciado.

**Entrega pública corregida:** [public_readability/summary.json](evidence/h03/public_readability/summary.json) PASS global/exit 0, mismo comando desde checkout público con `-OutputDir docs/evidence/h03/public_readability -Graphics`; 8 unitarias/8 integración, H1 34/0/1, fallback propio sin carpeta local, control negativo, recursos y dos probes gráficos PASS. Escaneo previo del paquete sin FBX/PNG Malorian, originales, evidencias privadas ni coincidencias de secretos/rutas personales. Metadatos .import de texturas actualizados por detección 3D de Godot (mips/S3TC/normal CRT), fuentes intactas; configuración comprobada en esa suite. `git diff --check` con cr-at-eol PASS. Commit `5f03fb3b751e7037c3d742f5fd661df61dcec99a`, push exit 0, GitHub PUBLIC/main/HEAD remoto confirmados y árbol público limpio. [Comprobante](evidence/h03/publication_readability.json). No se modificó índice del workspace original. Auditoría de enlaces locales actualizada con final_audit.py; no se repiten pruebas de gameplay tras cambios puramente documentales.

### Revisión manual parcial recibida · 2026-11-22

El creador comunica: filtro Nearest+mips; luz neutra; escala 3D (1280,720); sombras true; niebla false; al alternar retro no aprecia cambios; F5 vuelve a la greybox sin texturas. Se registra como **configuración observada**, sin inferir preferencia definitiva, aprobación de assets ni cierre H03. No ha confirmado todavía si el indicador `retro` alterna true/false al pulsar X.

Comprobación de configuración/código: `project.godot` conserva `run/main_scene="res://scenes/main.tscn"`. F5 inicia H1 con sus primitivas; los assets del laboratorio solo están en `scenes/art_reference/modern_psx_lab.tscn`, ejecutable con F6. La ausencia de esas texturas en H1 es el alcance entregado, no evidencia de un fallo de importación. No se cambia la escena principal ni se integra arte en H1 durante esta revisión.

Diagnóstico del retro: shader con intensidad 0.25, cuantización de 31 niveles y líneas de 0.018 antes de mezclar. Comparación numérica de las capturas **ya existentes del 2026-11-21**, base neutra frente a retro, región 3D x=300..1099/y=250..539: 197322 de 232000 píxeles diferentes, media absoluta RGB (0.678444, 0.928608, 0.851500) sobre 255, máximo 3 por canal. Confirma cambio pequeño en aquellas capturas; no demuestra percepción humana ni que la tecla llegue a la ventana de la prueba actual. [Resultado](evidence/h03/retro_review_20261122.json), [script reproducible de comparación](evidence/h03/retro_review_20261122.gd). No se retocaron imágenes ni se aumentó la intensidad por inferencia.

Ejecutado con Godot 4.7.2, `--headless --path . --script res://.godot/h03_retro_review.gd`, exit 0; usa Image para leer PNG, no mide gráficos headless. El mismo script conservado en evidencia puede ejecutarse pasando su ruta. Intento previo con Python/Pillow no ejecutable por dependencia ausente (ModuleNotFoundError), sin instalarla; diagnóstico completado con el motor existente. Suites de gameplay/importación NOT_RUN de nuevo en esta revisión documental; se mantienen sus resultados fechados anteriores. Aprobación manual global y utilidad perceptible del retro: PENDIENTES.

Solicitud ampliada: [fuente recibida](evidence/h03/request.txt). H02 aprobado documentalmente antes de empezar. Documentos requeridos presentes; PDF original y export presets ausentes; Blender no resuelto en PATH/ubicación habitual. Git de entrada sin commits ni remoto, rama h02-audit con índice previo y cambios H02; no se resetea ni sustituye ese trabajo. [Estado inicial](evidence/h03/git_before.txt), [hashes de entrada](evidence/h03/before.json).

Entorno real: Windows 11 10.0.26200, x64, Python 3.13.15, Godot **4.7.2.stable.official.ed1daf0bf** estándar, GdUnit4 **6.2.3**. [Hardware](evidence/h03/hardware.json), [CPU](evidence/h03/cpu.json). Renderer principal GL Compatibility conservado; ventana gráfica reporta OpenGL 3.3.0 NVIDIA 621.24, GeForce RTX 4050 Laptop GPU, Ryzen 7 7735HS. La existencia adicional de GPU integrada no demuestra que se haya usado en la medición.

### Comando completo final de desarrollo

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File tools/run_tests.ps1 -Godot 'C:/Users/aleja/Downloads/Godot_v4.7.2-stable_win64.exe/Godot_v4.7.2-stable_win64_console.exe' -OutputDir docs/evidence/h03/run_03 -Graphics
```

Ejecutado desde `C:/dev/ALABARDA_CYBERPUNK_H1`, salida global **0**. `OutputDir` debe ser nuevo; cambiar nombre para repetir. [Resumen completo](evidence/h03/run_03/summary.json) contiene argv exactos, PowerShell equivalente, OS, fechas con UTC+01:00 y códigos de cada proceso. Cada etapa guarda `nombre.stdout.log`, `nombre.stderr.log`, `nombre.json`; JUnit en `*_reports`. No hay stderr ni errores fatales detectados en la ejecución final.

| Prueba | Resultado real | Exit | Evidencia |
|---|---|---|---|
| Versión/importación headless | PASS | 0/0 | [version](evidence/h03/run_03/version.json), [import](evidence/h03/run_03/import.json) |
| Unitarias balance | 8 PASS, 0 fallos/errores/skips | 0 | [unit](evidence/h03/run_03/unit.json) |
| Integración escena | 5 PASS: recursos/materiales/rig, toggles, glifos españoles, entrada H1, cambio real de pose | 0 | [integration](evidence/h03/run_03/integration.json) |
| Fallo deliberado | 1 aserción FAIL esperada; detector PASS, no error de motor ni skip | **100** | [negative_control](evidence/h03/run_03/negative_control.json) |
| Arranque H1 120 frames | PASS | 0 | [startup](evidence/h03/run_03/startup.json) |
| Regresión H1 --edges | 34 PASS / 0 FAIL / 1 NOT_RUN (captura/clic físico headless) | 0 | [log](evidence/h03/run_03/h1_regression.stdout.log) |
| Integridad | 908 protegidos, 12 referencias runtime, hashes de 74 fuentes seleccionadas, sin errores | 0 | [log](evidence/h03/run_03/integrity.stdout.log) |
| Ventana gráfica, shader y capturas | PASS ejecución; no aprobación estética | 0 | [graphics](evidence/h03/run_03/graphics.json), [medidas/cámara/config](evidence/h03/run_03/graphics/metrics.json) |
| Manual del creador H03 | PENDIENTE / NOT_RUN aquí | — | Pasos en HANDOFF |
| Export Windows / otros equipos / sesiones largas / Blender | NOT_RUN, fuera del alcance ejecutado | — | No se atribuye PASS |

La prueba negativa se ejecuta en directorio independiente. El runner exige exit 100 y JUnit con exactamente `test_controlled_failure_h03`, un fallo, cero errores/skips; una carga rota o cero tests no se aceptan como fallo controlado. No se incluye ese caso entre los 13 tests positivos.

Balance valida reglas aprobadas 100 HP/150 energía/umbral 100/escala Dead Eye 0.5, sin implementar sus sistemas. Valores provisionales separados, tipos/valores finitos/no negativos, esquema, claves y coherencia; clamps puros, recursos ausentes/de tipo incorrecto/inválidos. H1 no consume el Resource; sus números permanecen intactos.

### Historial de fallos y correcciones H03

Preflight en proyecto temporal: importación y caso positivo PASS antes de incorporar framework; logs `framework_preflight_import.*` y `framework_preflight_test.*` en esta carpeta. Tag upstream y ZIP hash fijados en `tools/h03/gdunit.lock.json`. No se atribuye certificación upstream explícita de 4.7.2: compatibilidad local ejecutada.

[run_01](evidence/h03/run_01/summary.json): FAIL real. Integración comparaba un float 0.65 de material con igualdad exacta; corregido a tolerancia 0.00001. Integridad detectó una ampliación externa de AGENTS durante la sesión; se leyó íntegra, no se revirtió. El creador después facilitó esa política; [external_changes](evidence/h03/external_changes.json) acepta solo su hash específico y conserva el original de entrada. Import inicial exploratorio también expuso diferencias Textures/textures del FBX y una inspección anticipada a fin de importación; se normalizó únicamente la copia experimental y se esperó al import. Final sin avisos de recurso roto.

[run_02](evidence/h03/run_02/summary.json): PASS con 8 unitarias/4 integración. Posteriormente se añadió un quinto caso para comprobar que el rig modifica una pose, y se repitió suite completa como run_03. Capturas exploratorias graphics_01/02 sirvieron para detectar recorte de brazos; se movió la muestra a una peana/cámara propia. Para rendimiento se usa exclusivamente run_03, secuencial después de tests.

### Evidencia gráfica y límites

33 meshes y 34 materiales en memoria. 1280×720, VSync desactivado, 60 frames de calentamiento y 180 intervalos `frame_post_draw` por variante. Misma cámara general, modificando una opción respecto a base neutra. Tiempo wall-clock entre frames; no GPU exclusivo. Medición breve, escena pequeña sin combate; variaciones pequeñas no prueban superioridad.

| Variante | Media ms | p50 | p95 | p99 | Draw calls |
|---|---:|---:|---:|---:|---:|
| Native nearest | 3.060 | 3.062 | 3.962 | 4.120 | 198 |
| Linear | 3.072 | 3.071 | 3.552 | 3.802 | 198 |
| Atmosférica | 3.000 | 3.047 | 3.961 | 4.263 | 198 |
| 640×360 interno | 3.250 | 3.261 | 3.896 | 4.200 | 198 |
| Retro | 3.165 | 3.122 | 3.806 | 4.147 | 198 |
| Sin sombras | 2.449 | 2.380 | 3.200 | 3.641 | 91 |
| Niebla | 3.303 | 3.285 | 4.033 | 4.450 | 198 |

Capturas reales sin edición y observaciones en [ART_BIBLE](ART_BIBLE.md). Fuentes también a 960×540, cámara CRT; rig en cámara 4. 640×360 empeora carteles/bordes; UI fuera del efecto mantiene resolución. HomeVideo 14 px y stretch fraccionario pierden limpieza. Desgaste/paleta/brillo entre packs requieren armonización; carteles 3D de diagnóstico pueden solaparse con UI en primer plano. Calidad artística PENDING_APPROVAL, no fallo oculto de importación. No se fija presupuesto FPS ni triángulos definitivo.

### Assets, cambios y cierre

Inventario completo: 638 archivos originales, 10 entradas y 30 grupos de duplicados exactos. [Registro](ASSET_REGISTRY.md), [inventario](evidence/h03/assets_inventory.json), [manifiesto selección](../resources/art_samples/manifest.json). Originales sin borrar/renombrar; `.gdignore` nuevo evita imports indiscriminados. Cinco packs seleccionados con licencia documentada; Malorian y PSXAmmoBoxes bloqueados como dependencias/distribución por los motivos registrados, sin impedir comparar placeholders propios. Blender interno NOT_RUN. Ningún VISUALLY_APPROVED.

ARCHITECTURE, TEST_STRATEGY, BALANCE_PROVISIONAL, ASSET_REGISTRY, ART_BIBLE, DECISIONS, ROADMAP, README, índice/prompts H03/H04 y HANDOFF reflejan H03. Relación exhaustiva de cambios respecto a entrada en `evidence/h03/changed_files.json`; conservación de H1 y original/history separada de cambios documentales. H04 solo recibe continuidad del prompt, no implementación. Puerta manual pendiente según AGENTS §5–6 y solicitud §12/16.

### Verificación de entrega y publicación H03

Tras ajustar `verify_integrity.py` para admitir una copia pública sin originales privados, se ejecutó de nuevo integridad local: [final_integrity](evidence/h03/final_integrity.json), PASS/exit 0, 908 protegidos y 12 referencias. También se repitió inspección runtime de cuatro muestras ya importadas: [final_sample_inspection](evidence/h03/final_sample_inspection.json), PASS/exit 0, sin errores de motor.

Copia independiente `C:/dev/ALABARDA_CYBERPUNK_H03_PUBLIC`: importación desde cero + misma suite **con gráficos**, comando equivalente al de desarrollo cambiando `-OutputDir docs/evidence/h03/public_fresh`. [Resumen completo](evidence/h03/public_fresh/summary.json): PASS global/exit 0; 8 unitarias, 5 integración, control negativo exacto exit 100, H1 34/0/1, arranque/import/graphics/integridad PASS. Baseline público de seis archivos H1 + referencias y muestras; originales privados/historia no presentes, sin fingir cobertura de 908.

Inspección previa de publicación: allowlist de código/recursos/licencias/docs breves; búsqueda de rutas personales, tokens reconocibles, claves privadas, .env/credenciales sin coincidencias en fuentes publicadas. Índice sin assets originales ni docs/evidence. `git diff --cached --check` inicial detectó CRLF al conservar bytes con `-text` y espacios heredados; verificación de código/docs propios con `core.whitespace=cr-at-eol` PASS, sin modificar vendor/licencias ni baseline H1 para normalizar formato. 719 archivos en commit público.

GitHub: [repositorio PUBLIC](https://github.com/alejandrodapenasanz/ALABARDA_CYBERPUNK_H1), rama main, commit `9153287449f1521b864ad7818d19a8b9914b6c51`. `gh repo create ... --public --source ... --remote origin --push` exit 0; `gh repo view` confirma PUBLIC y `git ls-remote` confirma commit. Clone nuevo desde GitHub en `.godot/h03_public_clone`, integridad PASS/exit 0 y árbol limpio. [Comprobante](evidence/h03/publication.json). No se cambió el índice del workspace original ni se publicaron sus históricos/conversaciones.

Verificación documental: `python -X utf8 tools/h03/final_audit.py`, objetivos de enlaces locales comprobados en 14 documentos/prompts; [resultado](evidence/h03/document_links.json). No certifica enlaces web ni aprobación semántica. Relación de nuevos/modificados/borrados en [changed_files](evidence/h03/changed_files.json); cero archivos de entrada eliminados. `git diff --check` original exit 0 con avisos de conversión CRLF, no errores de whitespace.

**Resultado de entrega: PARTIAL únicamente por aprobación manual pendiente y las muestras restringidas identificadas; implementación técnica y publicación completadas.** El encargo permite placeholders y no exige incorporar todos los packs. No hay error crítico técnico conocido; H04 no iniciado.

## Historial H1/H02/PRE-H03

# VALIDATION — registro de resultados reales
Inicializado en el paquete de planificación; el apartado H1 conserva lo declarado entonces. Las ejecuciones reales H02 se añaden abajo; no se adjudican retrospectivamente a H1. [Original íntegro](history/pre_h02/docs/VALIDATION.md).

**Estado actual (revisión correctiva 2026-11-20): tres bugs corregidos; regresión ampliada 34 PASS / 0 FAIL / 1 NOT_RUN.** Limpieza v2 y decisiones expresas del creador aplicadas. Cinco pruebas manuales previas aprobadas; falta revisar únicamente feedback de victoria/reinicio tras el arreglo y aprobar expresamente el cierre. Ver la sección «Revisión correctiva H02» al final. H03 no iniciado.

## H1 histórico
- Estado declarado por el creador: «el proyecto funciona» (Godot 4, PC).
- **NO VERIFICADO AQUÍ:** versión Godot exacta, tests automáticos, fuente completa, export.

## Plantilla de cada hito
### Hxx — [nombre]
- Fecha / OS / Godot / GdUnit4:
- Commit base / commit resultado / archivos cambiados:
- `git status` antes y después:
- **Importación:** comando, exit code, log, PASS/FAIL/BLOCKED/NOT_RUN.
- **Unitarias:** comando, contadores, exit code, log, estado.
- **Integración:** comando, contadores, exit code, log, estado.
- **Regresión:** comando, contadores, exit code, log, estado.
- **Manual por creador:** pasos; PENDIENTE hasta revisión expresa.
- Defectos, decisiones abiertas, blockers:
- Estado: `IMPLEMENTADO SIN APROBAR` / `APROBADO POR CREADOR`.

## H02 — Auditoría inicial · 2026-11-20 · registro histórico anterior a correcciones

**Estado: AUDITADO / PENDIENTE DE CIERRE; cinco comprobaciones manuales aprobadas por el creador. Suite automática global NO PASS.** Se completó el saneamiento autorizado y se registraron fallos del H1 y contradicciones materiales del diseño. No se cambia gameplay ni se inicia H03.

### Precondición y entorno

HANDOFF y VALIDATION originales contienen la declaración del creador de que H1 funciona. Se acepta esa precondición documental, sin inferir tests automáticos históricos. La checklist original [VALIDACION](history/pre_h02/docs/VALIDACION.md) permanece sin marcar, con «NO PROBADO EN GODOT» del momento de autoría.

Windows 11 `10.0.26200`, PowerShell; Python 3.13.15; Git 2.54.0.windows.1; Godot **4.7.2.stable.official.ed1daf0bf**, encontrado fuera de PATH en `C:/Users/aleja/Downloads/Godot_v4.7.2-stable_win64.exe/Godot_v4.7.2-stable_win64_console.exe`. Cwd: `C:/dev/ALABARDA_CYBERPUNK_H1`. Sin GdUnit4/addons ni suite preexistente. Las marcas horarias de los JSON usan Madrid UTC+01:00 el 2026-11-20.

Todos los documentos solicitados estaban presentes. Faltaban PDF original, concatenación anunciada de prompts, tests y export presets. No se descargó nada.

### Git y preservación

`git status --short --branch` inicial: **exit 128**, «not a git repository». [Comando/salida](evidence/h02/initial_git_status.json). Se creó rama local `h02-audit`; tree de los 56 originales `a876fef52112f952de91a015903026e6f79cce9a`, ref `refs/h02/baseline`. No hay commit base ni commit resultado, tampoco remote; no había identidad configurada. El índice conserva la entrada, los cambios H02 quedan sin commit. [Captura con comandos y exit codes](evidence/h02/baseline.stdout.log), [estado posterior](evidence/h02/final_git_status_02.stdout.log).

48 Markdown originales archivados con SHA-256. Ocho alias migrados; seis pares idénticos y dos registros no idénticos comparados en [diff](evidence/h02/original_comparisons.diff). DECISIONES conserva cuatro decisiones/IDs históricos mediante maestro y archivo original. `.gitattributes` preserva bytes de histórico/evidencia en futuros checkouts; `.gitignore` excluye caché Godot y Python.

### Ejecuciones y resultados reales

Cada enlace JSON contiene **argv exacto**, comando equivalente PowerShell, fecha/hora, cwd, OS, exit code y nombres de stdout/stderr completos en la misma carpeta. [TEST_STRATEGY](TEST_STRATEGY.md) contiene comandos copiables y la ruta del ejecutable. En la tabla, `G` abrevia únicamente ese ejecutable Godot; no se presupone alias instalado.

| Prueba / comando | Estado | Exit | Contadores y evidencia |
|---|---|---:|---|
| `G --version` | PASS identificación | 0 | [godot_version](evidence/h02/godot_version.json). |
| `G --headless --path . --editor --import --quit`, antes | PASS | 0 | [import_before](evidence/h02/import_before.json); stdout de inicialización completo, stderr vacío. |
| Mismo comando, después del saneamiento | PASS | 0 | [import_after](evidence/h02/import_after.json); sin errores de motor/recursos en stdout/stderr. |
| `G --headless --path . --quit-after 120` | PASS arranque | 0 | [startup](evidence/h02/startup.json); no prueba inputs ni imagen. |
| `G --headless --path . --check-only --script res://scripts/main.gd` | PASS | 0 | [parse_main](evidence/h02/parse_main.json). |
| `G --headless --path . --check-only --script res://scripts/player.gd` | PASS | 0 | [parse_player](evidence/h02/parse_player.json). |
| `G --headless --path . --check-only --script res://scripts/enemy.gd` | PASS | 0 | [parse_enemy](evidence/h02/parse_enemy.json). |
| `G --headless --path . --fixed-fps 60 --script res://tests/h02/h1_probe.gd` | PASS parcial automatizable | 0 | [smoke_03](evidence/h02/smoke_03.json): 25 PASS / 0 FAIL / 1 NOT_RUN. Movimiento por eventos de teclado; raycast real mediante `_shoot()`, cinco enemigos, ocho impactos, HUD/respawn/R. |
| Mismo comando con `-- --edges` | **FAIL** | 1 | [edges_01](evidence/h02/edges_01.json): 25 PASS / **3 FAIL** / 1 NOT_RUN. Defectos detallados abajo. |
| `python -X utf8 tools/h02/verify_migration.py` | PASS | 0 | [migration_test](evidence/h02/migration_test.json): 3 comprobaciones, 8 cambios primera pasada / 0 segunda; 48 hashes históricos; rechazo de edición ajena sin escrituras parciales. |
| `python -X utf8 tools/h02/migrate_docs.py` | PASS | 0 | [migration_apply](evidence/h02/migration_apply.json): 8 alias; [migration_repeat](evidence/h02/migration_repeat.json): 0 cambios en repo real. |
| `python -X utf8 tools/h02/audit_repo.py` | PASS integridad automática | 0 | [references_final](evidence/h02/references_final.json): 97 Markdown, 48 hashes históricos + 8 productivos, 6 recursos/5 dependencias, 183 enlaces, 1231 tokens de archivo, 227 referencias de IDs; 0 errores y 11 avisos históricos/ausencias declaradas. El inventario se actualiza al volver a ejecutar tras cambios de documentación. |
| `git -c core.autocrlf=false diff --exit-code refs/h02/baseline -- project.godot scenes scripts AGENTS.md` | PASS sin cambios productivos | 0 | [gameplay_unchanged](evidence/h02/gameplay_unchanged.json), diff vacío. |
| `git -c core.autocrlf=false diff --check refs/h02/baseline` | PASS formato de diff | 0 | [git_whitespace_final](evidence/h02/git_whitespace_final.json). |

No se han encontrado warnings/errores de Godot en importación, arranque, parseos o smoke_03. Los FAIL de borde aparecen completos en stdout, con salida 1; no se silencian ni se reclasifican como PASS.

### Intentos anteriores, problemas de herramientas y correcciones

- [smoke_01](evidence/h02/smoke_01.json) y [smoke_02_mouse_diagnostic](evidence/h02/smoke_02_mouse_diagnostic.json): exit 1, cada uno 15 PASS / 4 FAIL. El probe asumía captura de cursor disponible en headless; diagnóstico muestra initial_mode=0 y after_explicit_capture=0. Se corrigió el **test**, no el juego. La limitación pasa a NOT_RUN explícito; disparo se verifica llamando el método original. No se presenta ese cambio como reparación del clic.
- [references_01](evidence/h02/references_01.json): exit 1, cuatro incidencias. Dos falsos positivos eran extensiones `.gd.uid`/`.tscn`, otro enlace apuntaba al reporte que aún no se había generado y HANDOFF tenía ruta de prompt obsoleta. Se distingue extensión de archivo y se corrige HANDOFF.
- [references_02](evidence/h02/references_02.json): exit 1, dos rutas abreviadas nuevas en TEST_STRATEGY; corregidas a rutas completas antes de references_03.
- El prompt H02 local desapareció después de la captura por causa no determinada. No se atribuye al usuario ni al motor. El creador pidió restaurarlo: [restore_h02_prompt](evidence/h02/restore_h02_prompt.json), exit 0, bytes del histórico; después se añadió nota editorial. El primer script de notas imprimió un total fijo 23 aunque quedaban 22 archivos: no era un test. Se corrigió a contador calculado y [prompt_notes_02](evidence/h02/prompt_notes_02.json) confirma 23 presentes.
- Lectura exploratoria Python sin `-X utf8`: exit 1 por UnicodeEncodeError (cp1252). La lectura completa se repitió con UTF-8; el intento exploratorio está en la transcripción de herramientas, sin log de archivo propio. No afecta a bytes de fuentes.
- Un `git diff --stat` exploratorio avisó de futura conversión LF→CRLF por configuración heredada. Se usó `-c core.autocrlf=false` para las comprobaciones, sin cambiar configuración global. El archivo histórico y evidencia se fijan como binarios a efectos de conversión de finales de línea con `.gitattributes`.

### Defectos H1 reproducidos (sin corregir en el momento de la auditoría inicial)

| Bug | Entrada / expectativa / resultado | Impacto y siguiente acción |
|---|---|---|
| H1-B01 | Player con HP=100, `take_damage(-10)`: esperado no superar máximo, observado 110. | API sin validación. Entrada negativa no procede de blancos actuales; definir validación técnica al corregir daño. |
| H1-B02 | Dos llamadas letales a un mismo Enemy antes de procesar queue_free: esperado un decremento; observado dos. | Señal eliminated duplicada puede corromper contador/victoria. Latente con múltiples impactos; no observado en ocho impactos normales separados del smoke. |
| H1-B03 | Último blanco con 35 HP, disparo hitscan real: esperado texto CONTRATO COMPLETADO; observado texto de impacto. | shot_fired llega después de eliminated y sobrescribe feedback. R funciona por contador cero; requiere revisión manual de UX. |

Reproducción automática conjunta: comando `-- --edges` de la tabla. Se conservan fallos sin añadir reglas de gameplay por intuición. H1 tiene además limitaciones esperadas: ataques de blancos por rango atraviesan oclusión, no patrullan; respawn no repone enemigos; no hay energía/curación/guardado. Son alcance histórico, no regresiones creadas por H02.

### BLOCKED / NOT_RUN y revisión humana

| Comprobación | Estado | Motivo |
|---|---|---|
| Cursor y clic→disparo extremo a extremo automatizado headless | BLOCKED por backend / NOT_RUN en probe | DisplayServer headless mantiene cursor visible; necesita editor/ventana real. |
| Suite anterior / GdUnit4 | NOT_RUN | No existía suite ni plugin instalado; no se inventa comando ni resultado. |
| Cinco comprobaciones manuales de H1 entregadas en el chat | PASS manual, declarado por el creador el 2026-11-20 | Arranque/Depurador, movimiento/ratón/colisiones, captura/disparo, daño/respawn y eliminación/reinicio. No es ejecución automática ni aprobación artística del MVP. |
| Export Windows | NOT_RUN | Fuera de H02; no hay presets, no se verificaron templates. |
| Comparación con PDF original | BLOCKED / NOT_RUN | Archivo ausente; se trabajó con documentos locales disponibles. |
| Licencias online / arte final | NOT_RUN | Sin incorporación de assets; no se valida ninguna licencia concreta en H02. |
| Coherencia creativa global | PENDING_APPROVAL, **no superada** | P-008…P-014 y pendientes anteriores; el PASS del verificador no los resuelve. |

### Prueba manual para aprobación expresa

1. Abrir project.godot con Godot 4.7.2; ejecutar F5 y F6 desde main.tscn; revisar errores del Depurador y visibilidad de arena/HUD.
2. Probar WASD y apuntado; Shift, Q mientras se mueve y salto. Chocar contra paredes/coberturas y hacer dash para revisar colisiones.
3. Escape libera cursor; clic vuelve al control. Mantener clic, comprobar recuperación/retroceso y que apuntar a pared no daña blancos.
4. Recibir daño de blancos cercanos/de distancia, observar HUD, dejar bajar salud a cero y comprobar respawn con 100 HP.
5. Eliminar los cinco blancos, comprobar contador cero, registrar H1-B03 y pulsar R para repetir. Verificar R sin victoria no repone blancos.
6. Revisar [DOCUMENTATION_AUDIT](DOCUMENTATION_AUDIT.md) y resolver las contradicciones materiales antes del cierre. Las cinco comprobaciones jugables entregadas en el chat ya tienen aprobación manual; la revisión de decisiones y el cierre de H02 continúan pendientes.

### Confirmación manual del creador · 2026-11-20

El creador comunica que realizó las cinco comprobaciones de la entrega y que «todo okay». Se registra PASS manual declarado para: (1) arranque y revisión del Depurador; (2) WASD/ratón/sprint/dash/salto/paredes; (3) Escape/recaptura/clic mantenido; (4) daño y respawn con 100 HP; (5) eliminación de cinco blancos, contador y reinicio R. No aportó un log ni reiteró la versión de su ejecución manual, por lo que no se inventan esos datos.

La confirmación cubre la interacción con ratón en su PC; el caso automatizado headless sigue NOT_RUN por su limitación técnica. Los tres FAIL de `edges_01` se conservan: no hubo corrección de código ni nueva ejecución de esas pruebas. El «todo okay» general no demuestra que el caso específico de feedback H1-B03 haya dejado de reproducirse. Esta confirmación tampoco aprueba el cierre global ni las decisiones creativas pendientes.

Verificación de esta actualización documental: `python -X utf8 tools/h02/run_logged.py manual_confirmation_refs python -X utf8 tools/h02/audit_repo.py`, **exit 1, FAIL de integridad actual**; 96 Markdown y una incidencia: falta la ruta original `docs/DECISIONS (1).md`, que al terminar la auditoría era un alias. Los 48 hashes históricos y ocho productivos se verifican sin incidencias; el maestro DECISIONS sigue presente. Causa de la desaparición no determinada; queda restaurar el alias o aprobar/documentar su retirada y adaptar el inventario. No se restaura silenciosamente una posible retirada del usuario. Comando, entorno y stdout/stderr conservados con el nombre manual_confirmation_refs en la carpeta de evidencias H02. No se repitieron pruebas Godot para este cambio documental.

### Entregables y continuación

Documentos modificados: README, GDD canónico/alias, DECISIONS/DECISIONES, GAME_VISION, GAME_DESIGN, MVP_SCOPE, ROADMAP, ARCHITECTURE, BALANCE_PROVISIONAL, SPEC_REVIEW, ART_BIBLE, ASSET_REGISTRY, PROMPTS_INDEX, TEST_STRATEGY, VALIDATION/VALIDACION, HANDOFF y cinco copias `(1)` convertidas a alias. Notas documentales añadidas a los 23 prompts.

Nuevos: DOCUMENTATION_AUDIT, política de referencias, histórico/manifiesto, evidencia/logs, `tests/h02/h1_probe.gd`, utilidades `tools/h02/`, `.gitignore` y `.gitattributes`. El código/escena/configuración H1 queda igual. No se da por cerrado H02 ni se autoriza H03. Punto de continuación y resumen para otro chat: [HANDOFF](HANDOFF.md).

## Revisión correctiva H02 — 2026-11-20

### Autorización y cambios

El creador solicita retirar todos los duplicados (1), conservar una copia correcta, comparar VALIDATION/VALIDACION y corregir los errores para cerrar H02. Después aprueba expresamente: firmware activo al instalar USB; alarma general bloquea retorno al sigilo durante ese intento; Dead Eye ralentiza mundo con cualquier arma, compatibilidad solo para efectos específicos de arma. Se revisan D-006/D-003/D-009 con sustituciones fechadas y se sincronizan AGENTS, visión, alcance, diseño, roadmap y prompts.

Correcciones técnicas autorizadas en `scripts/player.gd`, `scripts/enemy.gd` y `scripts/main.gd`: daño inválido rechazado, HP limitado, eliminación única incluso con callback reentrante, ausencia de ataques tras derrota, victoria conservada tras último disparo y feedback limpio al reiniciar. No cambian datos numéricos de balance, controles, project, escena ni UIDs. [Hashes anteriores/actuales](h02_runtime_snapshot.json).

VALIDACION original y VALIDATION eran diferentes: checklist H1 no ejecutada frente a registro posterior. La copia activa de VALIDACION era ya un alias. Se retira y se conserva la checklist íntegra en el histórico, enlazada desde el único registro activo VALIDATION. También se retiran los demás alias; los 22 prompts únicos con (1) se renombran. Se conservan 48 contenidos históricos mediante 42 archivos únicos, eliminando seis duplicados idénticos. El manifiesto mantiene cada ruta original y su destino; cero nombres (1) en el árbol de trabajo documental.

### Ejecuciones correctivas

Mismo entorno registrado: Windows 11 build 26200, Godot 4.7.2.stable.official.ed1daf0bf fuera de PATH, Python 3.13.15. Los JSON enlazados incluyen comando EXACTO, fecha/hora Madrid, cwd, OS, exit code, stdout/stderr. Comandos copiables en TEST_STRATEGY; `G` en la tabla solo abrevia la ruta Godot allí registrada.

| Comando / comprobación | Estado actual | Exit | Evidencia y contadores |
|---|---|---:|---|
| `G --headless --path . --fixed-fps 60 --script res://tests/h02/h1_probe.gd -- --edges` | PASS automatizable | 0 | [correction_edges_01](evidence/h02/correction_edges_01.json): **34 PASS, 0 FAIL, 1 NOT_RUN**. Incluye smoke completo y nueve bordes; clic headless permanece NOT_RUN. |
| `G --headless --path . --editor --import --quit` | PASS | 0 | [correction_import](evidence/h02/correction_import.json), sin recursos perdidos ni errores de motor. |
| `G --headless --path . --quit-after 120` | PASS | 0 | [correction_startup](evidence/h02/correction_startup.json). |
| `G --headless --path . --check-only --script` para cada script | PASS 3/3 | 0 cada uno | [main](evidence/h02/correction_parse_main.json), [player](evidence/h02/correction_parse_player.json), [enemy](evidence/h02/correction_parse_enemy.json). |
| `python -X utf8 tools/h02/migrate_docs.py` | PASS | 0 | [cleanup_apply_v2](evidence/h02/cleanup_apply_v2.json): 50 movimientos/deduplicaciones y 7 alias presentes retirados; el octavo alias ya faltaba. [cleanup_repeat_v2](evidence/h02/cleanup_repeat_v2.json): cero cambios. |
| `python -X utf8 tools/h02/verify_migration.py` | PASS 4/4 | 0 | [cleanup_test_v2](evidence/h02/cleanup_test_v2.json): consolidación desde originales, idempotencia, 48 hashes, rechazo de edición ajena y colisión sin pérdida. |
| `python -X utf8 tools/h02/record_runtime_snapshot.py` | PASS registro de invariantes | 0 | [correction_snapshot](evidence/h02/correction_snapshot.json): ocho archivos; tres scripts corregidos, otros cinco idénticos al original. No reescribe baseline. |
| `git -c core.autocrlf=false diff --exit-code refs/h02/baseline -- project.godot scenes scripts/player.gd.uid scripts/enemy.gd.uid scripts/main.gd.uid` | PASS | 0 | [correction_invariants](evidence/h02/correction_invariants.json), diff vacío. |
| `python -X utf8 tools/h02/audit_repo.py` | PASS integridad documental | 0 | [correction_references_02](evidence/h02/correction_references_02.json): 83 Markdown, 48 hashes históricos y ocho productivos, cero errores; 23 prompts únicos y ningún nombre (1). Los avisos de rutas históricas/externas se conservan explícitos en el reporte. |
| `git -c core.autocrlf=false diff --check refs/h02/baseline` | PASS formato | 0 | [correction_whitespace](evidence/h02/correction_whitespace.json). |

Estado Git posterior: [correction_git_status](evidence/h02/correction_git_status.json), exit 0. Se conservan las retiradas/renombrados autorizados y cambios de tres scripts sin commit; la ref baseline permanece intacta. Las decisiones y los prompts se sincronizaron con `tools/h02/update_prompt_notes.py`, con ejecuciones correction_prompt_sync y correction_prompt_sync_02 registradas, exit 0.

Los tres FAIL de edges_01 permanecen como resultados históricos; ahora pasan sus asserts originales y seis casos adicionales relacionados. No se han ocultado warnings/errores: stdout y stderr completos disponibles, sin errores Godot en las ejecuciones correctivas.

### Incidencias documentales durante la corrección

`correction_references_01` devuelve exit 1 con cuatro incidencias: el verificador confundía referencias de D-003/D-006/D-009 en la tabla de sustituciones con nuevas definiciones; además TEST_STRATEGY abreviaba una ruta de script. Se restringe la detección de definiciones a las entradas maestras y se escribe la ruta completa. El log fallido se conserva. La antigua falta de DECISIONS con sufijo queda resuelta por la retirada autorizada del alias; el inventario ahora comprueba sucesores y hashes, no exige restaurar copias eliminadas.

### Estado de decisiones y puerta manual

P-008/P-009/P-010: resueltas por respuestas expresas, no por inferencia. P-012: dependencia documental corregida sin reordenar hitos. P-011/P-013/P-014 y parámetros futuros continúan pendientes de sus propios hitos, sin instrucciones que los presenten como aprobados. [Matriz actual](DOCUMENTATION_AUDIT.md).

Las cinco comprobaciones manuales previas siguen aprobadas. **NOT_RUN después de la corrección:** revisión humana focalizada de feedback de victoria y reinicio. Procedimiento: F5, eliminar cinco blancos, comprobar que permanece «CONTRATO COMPLETADO», pulsar R y comprobar cinco blancos y mensaje anterior borrado. No se exige repetir toda la batería manual previa. **H02 listo para aprobación del cierre, no autoaprobado.** Sin trabajo H03.

## PRE-H03 — ART DIRECTION UPDATE · 2026-11-20

**PASS de actualización y comprobación documental. H03 no iniciado.** D-017 registra la decisión expresa del creador: **Modern PSX / Retro Industrial Cyberpunk**, reinterpretación moderna con identidad retro, coherencia y legibilidad. Su aprobación no equivale a validar arte implementado ni cerrar H02. Este registro se añade íntegramente después de H02, sin sobrescribir resultados anteriores.

### Alcance, lectura previa y precondición

Fuente: [solicitud íntegra recibida](evidence/pre_h03/request.txt), con SHA-256 en [captura de entrada](evidence/pre_h03/before.json). Antes de editar se leyeron AGENTS completo, GAME_VISION, MVP_SCOPE, DECISIONS, ROADMAP, ARCHITECTURE, GAME_DESIGN, ART_BIBLE, ASSET_REGISTRY, BALANCE_PROVISIONAL, TEST_STRATEGY, VALIDATION y HANDOFF; también README, DOCUMENTATION_AUDIT, SPEC_REVIEW, PROMPTS_INDEX, GDD histórico y los prompts H03/H04. Se buscaron las referencias artísticas del resto de Markdown/prompts y se revisó el diff completo de las modificaciones. Se inspeccionaron project.godot, la escena main y los tres scripts productivos, así como Git y la versión real del motor.

Todos los documentos obligatorios y el prompt H03 existen. No hay concatenación adicional de prompts; se sincroniza su índice. El PDF histórico continúa ausente y THIRD_PARTY_NOTICES es condicional, sin assets externos incorporados. No se recrean archivos renombrados ni se añade un segundo maestro.

La solicitud sitúa PRE-H03 después de H02; al empezar, el repo todavía registraba pendiente su revisión focalizada de victoria/R y cierre. Se trabajó únicamente en actualización documental segura. Durante la tarea el creador confirmó haber realizado las pruebas y que todo funciona: la confirmación posterior se registra abajo y satisface esa puerta. H03 era infraestructura y balance, H04 vertical de arte: la ampliación documental expresamente solicitada añade investigación/escena comparativa a H03 y mantiene H04 y sus dependencias.

### Archivos modificados y motivo

38 Markdown: 15 documentos y los 23 prompts H02–H24. Ningún archivo de juego, herramienta o test se modifica; no se añaden assets. Evidencia nueva separada en `docs/evidence/pre_h03/`.

| Archivos | Motivo |
|---|---|
| AGENTS.md, README.md | Resumen de dirección vigente, sin cambiar controles ni puertas de aprobación. |
| docs/ART_BIBLE.md | Fuente detallada: filosofía, prioridades, geometría/materiales/texturas, luz/paleta, efectos, sistemas, producción, validación técnica y criterios visuales. |
| docs/GAME_VISION.md, docs/MVP_SCOPE.md, docs/GAME_DESIGN.md | Unificar identidad artística sin cambiar pilares narrativos, reglas jugables ni balance; conservar salud roja/energía azul. |
| docs/DECISIONS.md | D-017 APROBADA/APPROVED con fecha, fuente, justificación y consecuencias; precisar D-001, ampliar D-015 y acotar P-004 conservando antecedentes. |
| docs/ASSET_REGISTRY.md | Criterios estilísticos y ficha de procedencia/licencia/fecha/uso/modificaciones/restricciones/ruta; separar revisión legal, técnica y visual. Ningún candidato se declara aprobado. |
| docs/ROADMAP.md, docs/PROMPTS_INDEX.md | H03 conserva infraestructura/balance y añade investigación visual; H04 desarrolla esa referencia. Sin renumerar ni cambiar dependencias. |
| docs/DOCUMENTATION_AUDIT.md, docs/SPEC_REVIEW.md | Trazar D-017 en requisitos artísticos existentes; distinguir dirección aprobada de parámetros y resultado visual pendientes. |
| docs/TEST_STRATEGY.md | Separar checks documentales/headless de futuras comparaciones visuales y medición gráfica. |
| docs/VALIDATION.md, docs/HANDOFF.md | Resultados reales, cambios, límites y continuidad; cierre H02 registrado tras confirmación manual posterior del creador, sin iniciar H03. |
| Los 23 prompts enlazados en PROMPTS_INDEX | Sustituir el contexto artístico ambiguo. H03 añade lectura obligatoria de biblia, referencia A/B, legibilidad/coherencia, rendimiento, decisiones técnicas, inventario y capturas; H04 reutiliza la base. H16 aclara terminal retro legible; H23 elimina interpretación de postefectos PS1 obligatorios. |

ARCHITECTURE, BALANCE_PROVISIONAL y GDD histórico permanecen intactos. Lista de rutas y diff contra la entrada PRE-H03 en la evidencia de integridad; no se usa el diff total H1→H02 como si fuera cambio de esta tarea.

### Entorno y comandos ejecutados

Fecha: **2026-11-20, Europe/Madrid UTC+01:00**; horas exactas en cada JSON. Windows 11 `10.0.26200`, PowerShell, Python 3.13.15; Godot **4.7.2.stable.official.ed1daf0bf**. Cwd `C:/dev/ALABARDA_CYBERPUNK_H1`. Godot/godot4 no están en PATH; se verificó el ejecutable registrado en TEST_STRATEGY. Rama h02-audit, sin commits ni remoto; índice y cambios H02 preexistentes conservados. No se instala framework, plugin ni dependencia.

Se reutiliza el registrador H02 importándolo con su destino de logs redirigido en memoria a PRE-H03; no se modifica su archivo. Cada JSON contiene argv y **comando EXACTO PowerShell**, fecha, OS, cwd, exit code y rutas de stdout/stderr completos. La comprobación de inventario también redirige su salida en memoria para preservar la evidencia H02. Su última línea de stdout conserva un literal heredado que menciona la carpeta H02; el archivo escrito realmente es [inventario PRE-H03](evidence/pre_h03/inventory_and_references.json), según el comando registrado.

Comandos Godot realmente ejecutados desde la raíz:

```powershell
& 'C:/Users/aleja/Downloads/Godot_v4.7.2-stable_win64.exe/Godot_v4.7.2-stable_win64_console.exe' --version
& 'C:/Users/aleja/Downloads/Godot_v4.7.2-stable_win64.exe/Godot_v4.7.2-stable_win64_console.exe' --headless --path . --editor --import --quit
& 'C:/Users/aleja/Downloads/Godot_v4.7.2-stable_win64.exe/Godot_v4.7.2-stable_win64_console.exe' --headless --path . --quit-after 120
```

| Comprobación | Estado / exit | Resultado y evidencia |
|---|---|---|
| Captura previa por SHA-256 | PASS / 0 | [baseline](evidence/pre_h03/baseline.json): 252 archivos, 41 Markdown activos; fuente recibida conservada. Cachés/Git excluidos. |
| Git antes/después | PASS lectura / 0 | `git status --short --branch`: [antes](evidence/pre_h03/git_before.json), [después](evidence/pre_h03/git_after.json). No se comete ni se descarta trabajo. |
| Versión Godot | PASS identificación / 0 | [godot_version](evidence/pre_h03/godot_version.json). |
| Importación headless | PASS / 0 | [import](evidence/pre_h03/import.json); sin errores/warnings ni recursos perdidos en logs; stderr vacío. |
| Arranque headless, 120 frames | PASS / 0 | [startup](evidence/pre_h03/startup.json); stderr vacío. No prueba inputs ni aspecto. |
| Inventario y enlaces/IDs | PASS / 0 | [references_01](evidence/pre_h03/references_01.json): 83 Markdown, 48 hashes históricos, 8 productivos, 6 recursos/5 dependencias; 212 enlaces, 1224 referencias de archivo y 343 de IDs; **0 errores / 18 avisos**. Resultado antes de añadir este registro; el inventario se actualiza en la comprobación final. |
| Integridad y diff PRE-H03 | PASS / 0 | [integrity_01](evidence/pre_h03/integrity_01.json): **10 PASS / 0 FAIL**; 211 archivos no documentales/históricos idénticos, 27 entradas D/P no artísticas idénticas, líneas originales de GAME_DESIGN y registro H02 conservados; 41 Markdown activos sin duplicados exactos y cero nombres (1). Primera pasada: 37 Markdown modificados antes de añadir VALIDATION; estado final esperado 38. [Informe](evidence/pre_h03/integrity_01_report.json), [diff revisado](evidence/pre_h03/integrity_01.diff). |
| Búsqueda de definiciones artísticas obsoletas | PASS de patrones / 0 | [style_scan](evidence/pre_h03/style_scan.json): 41 activos, cero coincidencias de patrones normativos antiguos y 59 referencias artísticas para revisión semántica; [detalle](evidence/pre_h03/style_scan_report.json). No equivale a un test automático de calidad artística. |
| Formato del diff Git | PASS / 0 | `git -c core.autocrlf=false diff --check refs/h02/baseline`, [whitespace](evidence/pre_h03/whitespace.json). El diff Git incluye trabajo H02; la separación de esta tarea se verifica con su captura propia. |
| Sincronización mecánica de contexto de prompts | Ejecutada / 0 | [sync_prompts](evidence/pre_h03/sync_prompts.json): 23 contextos actualizados; no es una prueba del videojuego. |

Los 18 avisos no son errores activos ocultos: corresponden al PDF ausente, THIRD_PARTY_NOTICES condicional, nombres españoles/alias históricos con sucesor y referencias de archivos históricos que nunca llegaron. Los logs anteriores no se sobrescriben ni reclasifican. No hubo ejecuciones FAIL de estas comprobaciones PRE-H03.

### Revisión semántica y límites

Se revisó el diff completo y se contrastó la petición con los documentos centrales y las referencias artísticas activas. No se identificaron contradicciones materiales sin tratamiento: identidad unificada, ampliación H03/H04 delimitada, números/paleta provisionales, efectos perjudiciales configurables/desactivables y salud/energía conservadas. [Tabla de discrepancias y resoluciones](DOCUMENTATION_AUDIT.md). Las menciones antiguas de PS1 quedan como antecedentes, negaciones de emulación literal o material histórico, sin obligaciones activas de reproducir hardware. Esta conclusión es revisión editorial, no aprobación humana de un resultado visual.

| Comprobación no ejecutada | Estado y motivo |
|---|---|
| Smoke jugable H1 / probe de 34 asserts | NOT_RUN en PRE-H03: cambio exclusivamente documental. Los 34 PASS/0 FAIL/1 NOT_RUN de la corrección H02 siguen en su registro; no se atribuyen a esta ejecución. |
| Ejecución de pruebas manuales por Codex | NOT_RUN; la confirmación conjunta posterior del creador se registra como declaración humana independiente, sin log ni desglose inventados. |
| Escena comparativa, capturas, shaders, importación de nuevos GLB y benchmark gráfico | NOT_RUN: pertenecen a H03 y no se han creado/ejecutado. Headless no aprueba el arte ni mide rendimiento gráfico. |
| Descarga, selección/licencias individuales y aprobación de assets | NOT_RUN: no se incorporan assets en PRE-H03 ni se inventan licencias. |
| Export Windows | NOT_RUN: fuera de esta actualización documental. |
| Inicio H03 | NOT_RUN: H02 ya aprobado tras confirmación posterior; H03 requiere autorización propia y no forma parte de esta tarea. |

### Continuidad y revisión del creador

La documentación está preparada para solicitar H03; su precondición H02 queda satisfecha por la confirmación posterior. Las decisiones técnicas y el resultado visual se evaluarán en ese hito. La prueba manual solicitada era Godot F5, eliminar cinco blancos, comprobar que permanece «CONTRATO COMPLETADO» y pulsar R para confirmar cinco blancos y limpieza del mensaje. Se acepta la confirmación conjunta del creador que consta debajo, sin atribuirle un desglose no aportado. No se añade una prueba visual jugable de PRE-H03 porque no hay cambios de imagen/escena.

Resumen para otro chat: D-017 y ART_BIBLE fijan la nueva identidad; 23 prompts sincronizados y H03 ampliado documentalmente sin iniciar. Conservar reglas de firmware/alarma/Dead Eye, históricos y evidencias. Paleta, resoluciones, presupuestos, renderer/efectos concretos y assets pendientes de validación. [HANDOFF](HANDOFF.md) mantiene estado reproducible y siguiente puerta.

### Confirmación manual posterior del creador y cierre H02 · 2026-11-20

Mensaje recibido después de las correcciones y durante PRE-H03:

> Continua, he hecho als pruebas y los controles y respwan y todo funciona.

**PASS manual declarado por el creador** para la confirmación conjunta de las pruebas solicitadas; menciona expresamente controles y respawn. No aporta versión, log, capturas ni desglose por cada paso y no se inventan. Esta nueva confirmación es posterior a los arreglos, a diferencia de las cinco pruebas iniciales. Se acepta para la revisión manual pendiente en el contexto de su petición previa de corregir todos los errores y cerrar H02.

**H02 APROBADO POR CREADOR / CERRADO.** Se combinan pruebas críticas automatizables ya registradas (34 PASS/0 FAIL/1 NOT_RUN del backend), saneamiento e integridad y esta validación humana. El clic headless sigue NOT_RUN; los fallos originales permanecen como histórico. No se ha vuelto a ejecutar el probe ni cambiado código en PRE-H03. La confirmación no aprueba shaders, assets, un resultado visual futuro ni la ejecución de H03.

### Verificación posterior a la confirmación manual

2026-11-20, Madrid. [references_final](evidence/pre_h03/references_final.json), 18:04:50, exit **0**: 83 Markdown, 48 hashes históricos, 8 productivos, 232 enlaces, 1224 referencias de archivo, 350 referencias de IDs, **0 errores / 18 avisos**. [integrity_final](evidence/pre_h03/integrity_final.json), 18:05:13, exit **0**: **10 PASS / 0 FAIL**, **38 Markdown modificados**, cero archivos retirados o añadidos fuera de evidencia, 211 no documentales/históricos intactos. [Listado completo de archivos](evidence/pre_h03/integrity_final_report.json) y [diff de esta revisión](evidence/pre_h03/integrity_final.diff). No se repite Godot para registrar una confirmación humana; permanecen las ejecuciones reales de importación/arranque anteriores de PRE-H03.

Incidencias de herramientas al reanudar, sin cambios del juego: una consulta a memoria auxiliar de la orquestación devolvió TypeError antes de ejecutar procesos; el primer lanzador Python falló por comillas nativas de PowerShell, **exit 1**, antes de crear el registro de integridad. La reproducción conserva `SyntaxError: keyword argument repeated: label`, comando exacto y salida en [diagnóstico](evidence/pre_h03/orchestration_diagnostic.json). Una lectura posterior pidió ese log aún inexistente y emitió PathNotFound; la sesión terminó 0 por el rg que se ejecutó después, no por éxito de la lectura. Se recuperó el comando original desde su JSON y se corrigió el quoting del lanzador, sin modificar herramientas del repo: integridad final exit 0. Estas incidencias no se ocultan ni se confunden con FAIL de gameplay.

Las comprobaciones de entrega posteriores a esta anotación se guardan con nombres delivery_references, delivery_integrity, delivery_whitespace y delivery_git_status en la misma carpeta, con sus comandos/exit codes reales; el inventario actual y el diff de entrega reflejan el estado entregado. Ninguna validación documental implica que se haya comenzado H03.
