# Informe de migración ALABARDA pipeline v2.1

## 1. Estado de la migración

2026-11-22–23. Documentación e infraestructura operativa preparadas y comprobadas técnicamente para revisión. **PENDING_APPROVAL por el creador**; no se marca APPROVED. B1 NOT_STARTED; ningún hito de gameplay ejecutado.

## 2. Estado original del repositorio

H1–H04 cerrados con validación histórica. Carpeta local h02-audit sin HEAD y con índice de entrada histórico, cambios previos y assets locales. Copia pública separada H04 commit `48f972c6ebeac2a4c7e6ab526e7dead43ad2baba`.2746 archivos capturados antes de editar;41 documentos archivados íntegros por SHA. Estaban23 prompts H02–H24, sin duplicados activos `(1)`; no existían DEVELOPMENT_WORKFLOW, validation/ ni PROMPTS_TODOS. Fuente suministrada en raíz, intacta.

## 3. Archivos modificados

[Inventario completo comparado con entrada](evidence/pipeline_v2_1/changed_files.json), independiente del git status histórico. Lista detallada al final de este informe. Sin eliminaciones. Se actualizaron AGENTS, README, guías activas aplicables y23 prompts. GDD histórico sin cambios.

## 4. Archivos creados

Workflow, contrato de dos barras, controles,29 casos de prueba futuros, informe; catálogo B0–B8;3 plantillas de prompts;4 plantillas de transferencia; schema JSON; verificadores documentales/de metadata con tests y dependencias Python fijadas. Archivo histórico de41 documentos con manifiesto; snapshot/inventario/logs de esta migración. Lista completa en inventario y al final. Sin nuevos scripts/escenas/Resources/assets del juego.

## 5. Cambios en AGENTS.md

v0.5 para Claude/Codex: lectura común, roles asimétricos, checkpoints por hito dentro del lote, estados, paquete por SHA, honestidad de resultados, bugs/corrección y aprobación humana. Conserva alcance, licencias, arte, continuidad e histórico. Dos barras y controles nuevos, pendientes explícitos; no autoriza B1.

## 6. Cambios en DEVELOPMENT_WORKFLOW.md

Nuevo protocolo Claude implementa → Codex valida → Claude corrige si es estructural → creador aprueba. CODE_READY no es VALIDATED; pruebas Godot en Claude NOT_RUN. Candidato C separado del paquete posterior P evita SHA autorreferencial. Verificación de commit/árbol limpio antes de tests, evidencia externa, nuevas ramas/commits por corrección, recuperación sin reset destructivo. Trabajo solapado solo autorizado/con interfaces estables/sin bloqueos y ramas aisladas. No merge sin validar a estable.

## 7. Agrupación definitiva solicitada de hitos

| Lote | Hitos | Dependencia | Estado |
|---|---|---|---|
| B0 | H03–H04 | H02 previo fuera de lotes | APPROVED histórico |
| B1 | H05–H06 | B0 | NOT_STARTED |
| B2 | H07–H09 | B1 | NOT_STARTED |
| B3 | H10–H12 | B2 | NOT_STARTED |
| B4 | H13–H15 | B3 | NOT_STARTED |
| B5 | H16–H18 | B4 | NOT_STARTED |
| B6 | H19–H21 | B5 | NOT_STARTED |
| B7 | H22 | B6 | NOT_STARTED |
| B8 | H23–H24 | B7 | NOT_STARTED |

Se conserva numeración/orden. La agrupación refleja el encargo; no equivale a aprobar esta entrega o a autorizar lotes. H06 prepara salud e interfaz para H08; energía/E reales B2; ascensor real H19; tres dificultades desde H13.

## 8. Prompts actualizados

Los 23 H02–H24 mantienen rutas/objetivos y distinguen roles, precondiciones/checkpoints, tests/fixtures, paquete, revisión manual y aceptación. H08 conserva EXTRACCION solo en filename por compatibilidad; el contenido vigente elimina esa dependencia. [Índice completo](PROMPTS_INDEX.md). B0 no se reejecuta; catálogo por enlaces evita duplicar otra versión de los hitos. PROMPTS_TODOS no existía y no se inventa.

## 9. Dos barras y regeneración

Salud 0–100 y energía 0–150 independientes. AutoHP tras 5 s sin daño a 5 HP/s; daño reinicia espera, muerto no regenera, sin coste energético. E mantenida 25 HP/s por 25 energía/s, coste del HP real, sin gastar a salud llena, soltar/energía 0/muerte detienen; daño no cancela si sobrevive. Manual activa pausa autoHP. Pasiva 8 energía/s hasta100 incluso en combate, sin reducir reservas>100; bajas+15 hasta150,95→110 y145→150; matar no sana HP. Ascensor energía 150 sin HP; ultimate>=100 consume toda y duración según valor previo. **Tiempos/tasas/pausa y duración 6–10 s son PROVISIONAL_VALUE / PENDING_PLAYTEST.** Límites y reglas se distinguen de balance.

F extracción SUPERSEDED, remates no borrados (P-017). Resource/tests H03 siguen legados sin editar; adaptación futura B1/B2. [Contrato](HEALTH_ENERGY_CONTRACT.md), [balance](BALANCE_PROVISIONAL.md), [29 casos NOT_RUN](HEALTH_ENERGY_TEST_CASES.md).

## 10. Controles

WASD; dash WW/AA/SS/DD misma tecla dentro de ventana/cooldown configurables, sin auto-repeat/parejas mixtas/doble activación; todos los builds.1/2/3 equipa, repetir equipado guarda, otro cambia directo. E siempre cura, interacción acción distinta con tecla pendiente. Etiquetas de slots separadas de restricciones; tres armas cualesquiera intacto. Bindings actuales H1 y del laboratorio separados de futuro, sin modificación de runtime. [Tabla y10 casos](CONTROLS.md).

## 11. Contradicciones y decisiones pendientes

[Matriz completa](DOCUMENTATION_AUDIT.md). Resueltas documentalmente: fuente filename v2.1/título v2.0 (original intacto), agente único, F y fórmulas activas, autoHP ausente, E contextual, ascensor HP, estados antiguos H03/H04. Pendientes: P-015 tecla interacción; P-016 etiquetas de slots y P-011 duplicados/vacíos; P-017 remates; balance y pendientes previos del MVP. No inventar decisiones para cerrar estos puntos.

Límites operativos: carpeta sin commit, copia pública con guías resumidas y hash histórico AGENTS en runner. Workflow exige preparar baseline documental aprobado en copia aislada antes de B1, transportar toda la documentación y actualizar explícitamente política de invariantes sin alterar evidencias antiguas. No se publica la migración como aprobada.

## 12. Comprobaciones realizadas

PASS real de schema/template,16/16 tests del verificador (incluyen positivos y rechazos),2705 archivos protegidos idénticos,41 históricos por hash, índice Git intacto,23 prompts/9 lotes,29 SB/10 CT especificados, valores/clasificaciones y links locales. git diff --check exit0. Godot --version confirma4.7.2, sin ejecutar gameplay. [Comandos y resultados](VALIDATION.md), [run_02 PASS](evidence/pipeline_v2_1/run_02/summary.json).

Run_01 tuvo un fallo real de rechazo de fecha inválida; corregido con comprobación RFC3339 explícita y conservado en [log inicial](evidence/pipeline_v2_1/run_01/manifest_tests.stderr.log). No se ocultaron ni reinterpretaron resultados. La comprobación documental final se registra en evidence/pipeline_v2_1/final_audit.json.

## 13. Pruebas no ejecutadas

Godot import/gameplay/suites H1–H04, Blender/export/gráficos,29 SB/10 CT futuros y Windows build: NOT_RUN en esta migración documental. Versionar un ejecutable con --version no es ejecutar el hito. Prueba de transferencia real entre PC con B1: NOT_RUN, aún no hay candidato. Aprobación semántica/manual del creador PENDING_APPROVAL. URLs externas/licencias nuevas fuera de comprobación, sin assets nuevos.

## 14. Preparación para B1

Documentos, prompts, tests especificados y plantillas disponibles. Falta validación humana de esta entrega y encargo B1, copia Git completa con SHA real y resolver P-015 antes de completar interacción manual. Claude puede preparar acción/tests independientes si aún falta ese binding, sin autoaprobar. B1 solo H05/H06, sin implementar H07–H09 para suplir fixtures.

## 15. Instrucciones exactas para nuevo chat de Claude

El bloque copiable y sus precondiciones están en [HANDOFF](HANDOFF.md). Solo usar después de validar esta migración y crear/sincronizar BASE_SHA real; contiene autorización **futura condicional**, no aprobación actual. Leer AGENTS/guías, aplicar CLAUDE_IMPLEMENT_BATCH a B1/H05–H06, entregar validation/B01/ por candidato C/paquete P, dejar Godot NOT_RUN y devolver a Codex sin iniciar B2.

<!-- FILE_INVENTORY -->

## Anexo — inventario exhaustivo de esta tarea

40 archivos modificados; 94 creados (incluyen archivo histórico y evidencia); 0 eliminados. Sin tocar índice Git. Las rutas de abajo cubren todos los archivos, no solo los documentos principales.

### Modificados (40)

- [AGENTS.md](../AGENTS.md)
- [README.md](../README.md)
- [docs/ARCHITECTURE.md](ARCHITECTURE.md)
- [docs/ART_BIBLE.md](ART_BIBLE.md)
- [docs/ASSET_REGISTRY.md](ASSET_REGISTRY.md)
- [docs/BALANCE_PROVISIONAL.md](BALANCE_PROVISIONAL.md)
- [docs/DECISIONS.md](DECISIONS.md)
- [docs/DOCUMENTATION_AUDIT.md](DOCUMENTATION_AUDIT.md)
- [docs/GAME_DESIGN.md](GAME_DESIGN.md)
- [docs/GAME_VISION.md](GAME_VISION.md)
- [docs/HANDOFF.md](HANDOFF.md)
- [docs/MVP_SCOPE.md](MVP_SCOPE.md)
- [docs/PROMPTS_INDEX.md](PROMPTS_INDEX.md)
- [docs/ROADMAP.md](ROADMAP.md)
- [docs/SPEC_REVIEW.md](SPEC_REVIEW.md)
- [docs/TEST_STRATEGY.md](TEST_STRATEGY.md)
- [docs/VALIDATION.md](VALIDATION.md)
- [prompts/H02_AUDITORIA_H1_Y_SANEAMIENTO_DOCUMENTAL.md](../prompts/H02_AUDITORIA_H1_Y_SANEAMIENTO_DOCUMENTAL.md)
- [prompts/H03_INFRAESTRUCTURA_DE_PRUEBAS_Y_BALANCE.md](../prompts/H03_INFRAESTRUCTURA_DE_PRUEBAS_Y_BALANCE.md)
- [prompts/H04_VERTICAL_DE_ARTE_TEMPRANO.md](../prompts/H04_VERTICAL_DE_ARTE_TEMPRANO.md)
- [prompts/H05_NUCLEO_DE_JUGADOR_INTERACCION_Y_MOVIMIENTO.md](../prompts/H05_NUCLEO_DE_JUGADOR_INTERACCION_Y_MOVIMIENTO.md)
- [prompts/H06_DANO_SALUD_HITZONES_Y_ESTADOS_DE_ATAQUE.md](../prompts/H06_DANO_SALUD_HITZONES_Y_ESTADOS_DE_ATAQUE.md)
- [prompts/H07_SEIS_ARMAS_Y_LOADOUT_LIBRE.md](../prompts/H07_SEIS_ARMAS_Y_LOADOUT_LIBRE.md)
- [prompts/H08_ENERGIA_CURACION_Y_EXTRACCION_CYBORG.md](../prompts/H08_ENERGIA_CURACION_Y_EXTRACCION_CYBORG.md)
- [prompts/H09_TRES_ULTIMATES_INDEPENDIENTES.md](../prompts/H09_TRES_ULTIMATES_INDEPENDIENTES.md)
- [prompts/H10_ENEMIGOS_BASE_TRES_ARQUETIPOS_Y_PATRULLAS.md](../prompts/H10_ENEMIGOS_BASE_TRES_ARQUETIPOS_Y_PATRULLAS.md)
- [prompts/H11_SIGILO_MEMORIA_BUSQUEDA_Y_RETORNO.md](../prompts/H11_SIGILO_MEMORIA_BUSQUEDA_Y_RETORNO.md)
- [prompts/H12_CAMARAS_ALARMAS_Y_CADAVERES.md](../prompts/H12_CAMARAS_ALARMAS_Y_CADAVERES.md)
- [prompts/H13_PERSISTENCIA_INVENTARIO_CREDITOS_Y_DIFICULTAD.md](../prompts/H13_PERSISTENCIA_INVENTARIO_CREDITOS_Y_DIFICULTAD.md)
- [prompts/H14_FIRMWARE_ARBOL_DE_PERKS_Y_RESPEC.md](../prompts/H14_FIRMWARE_ARBOL_DE_PERKS_Y_RESPEC.md)
- [prompts/H15_MEJORAS_FISICAS_DE_ARMAS_Y_CATALOGO_COMERCIAL.md](../prompts/H15_MEJORAS_FISICAS_DE_ARMAS_Y_CATALOGO_COMERCIAL.md)
- [prompts/H16_GUARIDA_Y_ORDENADOR_TERMINAL.md](../prompts/H16_GUARIDA_Y_ORDENADOR_TERMINAL.md)
- [prompts/H17_ENTREGAS_FISICAS_MONTAJE_Y_USB.md](../prompts/H17_ENTREGAS_FISICAS_MONTAJE_Y_USB.md)
- [prompts/H18_ARSENAL_SELECCION_DE_3_ARMAS_Y_VITRINA.md](../prompts/H18_ARSENAL_SELECCION_DE_3_ARMAS_Y_VITRINA.md)
- [prompts/H19_CONTRATO_YAKUZA_TRES_PLANTAS_ASCENSORES.md](../prompts/H19_CONTRATO_YAKUZA_TRES_PLANTAS_ASCENSORES.md)
- [prompts/H20_JEFE_YAKUZA_DOS_FASES_Y_RECOMPENSA.md](../prompts/H20_JEFE_YAKUZA_DOS_FASES_Y_RECOMPENSA.md)
- [prompts/H21_ECONOMIA_DE_CONTRATOS_Y_OBJETIVOS_SECUNDARIOS.md](../prompts/H21_ECONOMIA_DE_CONTRATOS_Y_OBJETIVOS_SECUNDARIOS.md)
- [prompts/H22_INTEGRACION_DIFICULTAD_UX_Y_ACCESIBILIDAD_BAS.md](../prompts/H22_INTEGRACION_DIFICULTAD_UX_Y_ACCESIBILIDAD_BAS.md)
- [prompts/H23_PULIDO_ARTISTICO_AUDIO_ANIMACION_Y_RENDIMIENT.md](../prompts/H23_PULIDO_ARTISTICO_AUDIO_ANIMACION_Y_RENDIMIENT.md)
- [prompts/H24_RELEASE_CANDIDATE_WINDOWS_AUDITORIA_FINAL.md](../prompts/H24_RELEASE_CANDIDATE_WINDOWS_AUDITORIA_FINAL.md)

### Nuevos activos (19)

- [docs/CONTROLS.md](CONTROLS.md)
- [docs/DEVELOPMENT_WORKFLOW.md](DEVELOPMENT_WORKFLOW.md)
- [docs/HEALTH_ENERGY_CONTRACT.md](HEALTH_ENERGY_CONTRACT.md)
- [docs/HEALTH_ENERGY_TEST_CASES.md](HEALTH_ENERGY_TEST_CASES.md)
- [docs/PIPELINE_MIGRATION_REPORT.md](PIPELINE_MIGRATION_REPORT.md)
- [prompts/BATCH_PROMPTS.md](../prompts/BATCH_PROMPTS.md)
- [prompts/_templates/CLAUDE_FIX_BATCH.md](../prompts/_templates/CLAUDE_FIX_BATCH.md)
- [prompts/_templates/CLAUDE_IMPLEMENT_BATCH.md](../prompts/_templates/CLAUDE_IMPLEMENT_BATCH.md)
- [prompts/_templates/CODEX_VALIDATE_BATCH.md](../prompts/_templates/CODEX_VALIDATE_BATCH.md)
- [tools/pipeline/check_docs.py](../tools/pipeline/check_docs.py)
- [tools/pipeline/requirements.txt](../tools/pipeline/requirements.txt)
- [tools/pipeline/run_checks.py](../tools/pipeline/run_checks.py)
- [tools/pipeline/test_manifest.py](../tools/pipeline/test_manifest.py)
- [tools/pipeline/validate_manifest.py](../tools/pipeline/validate_manifest.py)
- [validation/_schemas/test_manifest.schema.json](../validation/_schemas/test_manifest.schema.json)
- [validation/_templates/BUG_REPORT.md](../validation/_templates/BUG_REPORT.md)
- [validation/_templates/TEST_HANDOFF.md](../validation/_templates/TEST_HANDOFF.md)
- [validation/_templates/TEST_MANIFEST.json](../validation/_templates/TEST_MANIFEST.json)
- [validation/_templates/TEST_RESULTS.md](../validation/_templates/TEST_RESULTS.md)

### Históricos creados (42)

- [docs/history/pre_pipeline_v2_1/AGENTS.md](history/pre_pipeline_v2_1/AGENTS.md)
- [docs/history/pre_pipeline_v2_1/README.md](history/pre_pipeline_v2_1/README.md)
- [docs/history/pre_pipeline_v2_1/docs/ARCHITECTURE.md](history/pre_pipeline_v2_1/docs/ARCHITECTURE.md)
- [docs/history/pre_pipeline_v2_1/docs/ART_BIBLE.md](history/pre_pipeline_v2_1/docs/ART_BIBLE.md)
- [docs/history/pre_pipeline_v2_1/docs/ASSET_REGISTRY.md](history/pre_pipeline_v2_1/docs/ASSET_REGISTRY.md)
- [docs/history/pre_pipeline_v2_1/docs/BALANCE_PROVISIONAL.md](history/pre_pipeline_v2_1/docs/BALANCE_PROVISIONAL.md)
- [docs/history/pre_pipeline_v2_1/docs/DECISIONS.md](history/pre_pipeline_v2_1/docs/DECISIONS.md)
- [docs/history/pre_pipeline_v2_1/docs/DOCUMENTATION_AUDIT.md](history/pre_pipeline_v2_1/docs/DOCUMENTATION_AUDIT.md)
- [docs/history/pre_pipeline_v2_1/docs/GAME_DESIGN.md](history/pre_pipeline_v2_1/docs/GAME_DESIGN.md)
- [docs/history/pre_pipeline_v2_1/docs/GAME_VISION.md](history/pre_pipeline_v2_1/docs/GAME_VISION.md)
- [docs/history/pre_pipeline_v2_1/docs/GDD_TECNICO_H1.md](history/pre_pipeline_v2_1/docs/GDD_TECNICO_H1.md)
- [docs/history/pre_pipeline_v2_1/docs/HANDOFF.md](history/pre_pipeline_v2_1/docs/HANDOFF.md)
- [docs/history/pre_pipeline_v2_1/docs/MVP_SCOPE.md](history/pre_pipeline_v2_1/docs/MVP_SCOPE.md)
- [docs/history/pre_pipeline_v2_1/docs/PROMPTS_INDEX.md](history/pre_pipeline_v2_1/docs/PROMPTS_INDEX.md)
- [docs/history/pre_pipeline_v2_1/docs/ROADMAP.md](history/pre_pipeline_v2_1/docs/ROADMAP.md)
- [docs/history/pre_pipeline_v2_1/docs/SPEC_REVIEW.md](history/pre_pipeline_v2_1/docs/SPEC_REVIEW.md)
- [docs/history/pre_pipeline_v2_1/docs/TEST_STRATEGY.md](history/pre_pipeline_v2_1/docs/TEST_STRATEGY.md)
- [docs/history/pre_pipeline_v2_1/docs/VALIDATION.md](history/pre_pipeline_v2_1/docs/VALIDATION.md)
- [docs/history/pre_pipeline_v2_1/manifest.json](history/pre_pipeline_v2_1/manifest.json)
- [docs/history/pre_pipeline_v2_1/prompts/H02_AUDITORIA_H1_Y_SANEAMIENTO_DOCUMENTAL.md](history/pre_pipeline_v2_1/prompts/H02_AUDITORIA_H1_Y_SANEAMIENTO_DOCUMENTAL.md)
- [docs/history/pre_pipeline_v2_1/prompts/H03_INFRAESTRUCTURA_DE_PRUEBAS_Y_BALANCE.md](history/pre_pipeline_v2_1/prompts/H03_INFRAESTRUCTURA_DE_PRUEBAS_Y_BALANCE.md)
- [docs/history/pre_pipeline_v2_1/prompts/H04_VERTICAL_DE_ARTE_TEMPRANO.md](history/pre_pipeline_v2_1/prompts/H04_VERTICAL_DE_ARTE_TEMPRANO.md)
- [docs/history/pre_pipeline_v2_1/prompts/H05_NUCLEO_DE_JUGADOR_INTERACCION_Y_MOVIMIENTO.md](history/pre_pipeline_v2_1/prompts/H05_NUCLEO_DE_JUGADOR_INTERACCION_Y_MOVIMIENTO.md)
- [docs/history/pre_pipeline_v2_1/prompts/H06_DANO_SALUD_HITZONES_Y_ESTADOS_DE_ATAQUE.md](history/pre_pipeline_v2_1/prompts/H06_DANO_SALUD_HITZONES_Y_ESTADOS_DE_ATAQUE.md)
- [docs/history/pre_pipeline_v2_1/prompts/H07_SEIS_ARMAS_Y_LOADOUT_LIBRE.md](history/pre_pipeline_v2_1/prompts/H07_SEIS_ARMAS_Y_LOADOUT_LIBRE.md)
- [docs/history/pre_pipeline_v2_1/prompts/H08_ENERGIA_CURACION_Y_EXTRACCION_CYBORG.md](history/pre_pipeline_v2_1/prompts/H08_ENERGIA_CURACION_Y_EXTRACCION_CYBORG.md)
- [docs/history/pre_pipeline_v2_1/prompts/H09_TRES_ULTIMATES_INDEPENDIENTES.md](history/pre_pipeline_v2_1/prompts/H09_TRES_ULTIMATES_INDEPENDIENTES.md)
- [docs/history/pre_pipeline_v2_1/prompts/H10_ENEMIGOS_BASE_TRES_ARQUETIPOS_Y_PATRULLAS.md](history/pre_pipeline_v2_1/prompts/H10_ENEMIGOS_BASE_TRES_ARQUETIPOS_Y_PATRULLAS.md)
- [docs/history/pre_pipeline_v2_1/prompts/H11_SIGILO_MEMORIA_BUSQUEDA_Y_RETORNO.md](history/pre_pipeline_v2_1/prompts/H11_SIGILO_MEMORIA_BUSQUEDA_Y_RETORNO.md)
- [docs/history/pre_pipeline_v2_1/prompts/H12_CAMARAS_ALARMAS_Y_CADAVERES.md](history/pre_pipeline_v2_1/prompts/H12_CAMARAS_ALARMAS_Y_CADAVERES.md)
- [docs/history/pre_pipeline_v2_1/prompts/H13_PERSISTENCIA_INVENTARIO_CREDITOS_Y_DIFICULTAD.md](history/pre_pipeline_v2_1/prompts/H13_PERSISTENCIA_INVENTARIO_CREDITOS_Y_DIFICULTAD.md)
- [docs/history/pre_pipeline_v2_1/prompts/H14_FIRMWARE_ARBOL_DE_PERKS_Y_RESPEC.md](history/pre_pipeline_v2_1/prompts/H14_FIRMWARE_ARBOL_DE_PERKS_Y_RESPEC.md)
- [docs/history/pre_pipeline_v2_1/prompts/H15_MEJORAS_FISICAS_DE_ARMAS_Y_CATALOGO_COMERCIAL.md](history/pre_pipeline_v2_1/prompts/H15_MEJORAS_FISICAS_DE_ARMAS_Y_CATALOGO_COMERCIAL.md)
- [docs/history/pre_pipeline_v2_1/prompts/H16_GUARIDA_Y_ORDENADOR_TERMINAL.md](history/pre_pipeline_v2_1/prompts/H16_GUARIDA_Y_ORDENADOR_TERMINAL.md)
- [docs/history/pre_pipeline_v2_1/prompts/H17_ENTREGAS_FISICAS_MONTAJE_Y_USB.md](history/pre_pipeline_v2_1/prompts/H17_ENTREGAS_FISICAS_MONTAJE_Y_USB.md)
- [docs/history/pre_pipeline_v2_1/prompts/H18_ARSENAL_SELECCION_DE_3_ARMAS_Y_VITRINA.md](history/pre_pipeline_v2_1/prompts/H18_ARSENAL_SELECCION_DE_3_ARMAS_Y_VITRINA.md)
- [docs/history/pre_pipeline_v2_1/prompts/H19_CONTRATO_YAKUZA_TRES_PLANTAS_ASCENSORES.md](history/pre_pipeline_v2_1/prompts/H19_CONTRATO_YAKUZA_TRES_PLANTAS_ASCENSORES.md)
- [docs/history/pre_pipeline_v2_1/prompts/H20_JEFE_YAKUZA_DOS_FASES_Y_RECOMPENSA.md](history/pre_pipeline_v2_1/prompts/H20_JEFE_YAKUZA_DOS_FASES_Y_RECOMPENSA.md)
- [docs/history/pre_pipeline_v2_1/prompts/H21_ECONOMIA_DE_CONTRATOS_Y_OBJETIVOS_SECUNDARIOS.md](history/pre_pipeline_v2_1/prompts/H21_ECONOMIA_DE_CONTRATOS_Y_OBJETIVOS_SECUNDARIOS.md)
- [docs/history/pre_pipeline_v2_1/prompts/H22_INTEGRACION_DIFICULTAD_UX_Y_ACCESIBILIDAD_BAS.md](history/pre_pipeline_v2_1/prompts/H22_INTEGRACION_DIFICULTAD_UX_Y_ACCESIBILIDAD_BAS.md)
- [docs/history/pre_pipeline_v2_1/prompts/H23_PULIDO_ARTISTICO_AUDIO_ANIMACION_Y_RENDIMIENT.md](history/pre_pipeline_v2_1/prompts/H23_PULIDO_ARTISTICO_AUDIO_ANIMACION_Y_RENDIMIENT.md)
- [docs/history/pre_pipeline_v2_1/prompts/H24_RELEASE_CANDIDATE_WINDOWS_AUDITORIA_FINAL.md](history/pre_pipeline_v2_1/prompts/H24_RELEASE_CANDIDATE_WINDOWS_AUDITORIA_FINAL.md)

### Evidencia creada (33)

- [docs/evidence/pipeline_v2_1/before.json](evidence/pipeline_v2_1/before.json)
- [docs/evidence/pipeline_v2_1/changed_files.json](evidence/pipeline_v2_1/changed_files.json)
- [docs/evidence/pipeline_v2_1/final_audit.json](evidence/pipeline_v2_1/final_audit.json)
- [docs/evidence/pipeline_v2_1/run_01/dependencies.stderr.log](evidence/pipeline_v2_1/run_01/dependencies.stderr.log)
- [docs/evidence/pipeline_v2_1/run_01/dependencies.stdout.log](evidence/pipeline_v2_1/run_01/dependencies.stdout.log)
- [docs/evidence/pipeline_v2_1/run_01/documents.stderr.log](evidence/pipeline_v2_1/run_01/documents.stderr.log)
- [docs/evidence/pipeline_v2_1/run_01/documents.stdout.log](evidence/pipeline_v2_1/run_01/documents.stdout.log)
- [docs/evidence/pipeline_v2_1/run_01/godot_version_only.stderr.log](evidence/pipeline_v2_1/run_01/godot_version_only.stderr.log)
- [docs/evidence/pipeline_v2_1/run_01/godot_version_only.stdout.log](evidence/pipeline_v2_1/run_01/godot_version_only.stdout.log)
- [docs/evidence/pipeline_v2_1/run_01/manifest_tests.stderr.log](evidence/pipeline_v2_1/run_01/manifest_tests.stderr.log)
- [docs/evidence/pipeline_v2_1/run_01/manifest_tests.stdout.log](evidence/pipeline_v2_1/run_01/manifest_tests.stdout.log)
- [docs/evidence/pipeline_v2_1/run_01/python_version.stderr.log](evidence/pipeline_v2_1/run_01/python_version.stderr.log)
- [docs/evidence/pipeline_v2_1/run_01/python_version.stdout.log](evidence/pipeline_v2_1/run_01/python_version.stdout.log)
- [docs/evidence/pipeline_v2_1/run_01/schema.stderr.log](evidence/pipeline_v2_1/run_01/schema.stderr.log)
- [docs/evidence/pipeline_v2_1/run_01/schema.stdout.log](evidence/pipeline_v2_1/run_01/schema.stdout.log)
- [docs/evidence/pipeline_v2_1/run_01/summary.json](evidence/pipeline_v2_1/run_01/summary.json)
- [docs/evidence/pipeline_v2_1/run_01/whitespace.stderr.log](evidence/pipeline_v2_1/run_01/whitespace.stderr.log)
- [docs/evidence/pipeline_v2_1/run_01/whitespace.stdout.log](evidence/pipeline_v2_1/run_01/whitespace.stdout.log)
- [docs/evidence/pipeline_v2_1/run_02/dependencies.stderr.log](evidence/pipeline_v2_1/run_02/dependencies.stderr.log)
- [docs/evidence/pipeline_v2_1/run_02/dependencies.stdout.log](evidence/pipeline_v2_1/run_02/dependencies.stdout.log)
- [docs/evidence/pipeline_v2_1/run_02/documents.stderr.log](evidence/pipeline_v2_1/run_02/documents.stderr.log)
- [docs/evidence/pipeline_v2_1/run_02/documents.stdout.log](evidence/pipeline_v2_1/run_02/documents.stdout.log)
- [docs/evidence/pipeline_v2_1/run_02/godot_version_only.stderr.log](evidence/pipeline_v2_1/run_02/godot_version_only.stderr.log)
- [docs/evidence/pipeline_v2_1/run_02/godot_version_only.stdout.log](evidence/pipeline_v2_1/run_02/godot_version_only.stdout.log)
- [docs/evidence/pipeline_v2_1/run_02/manifest_tests.stderr.log](evidence/pipeline_v2_1/run_02/manifest_tests.stderr.log)
- [docs/evidence/pipeline_v2_1/run_02/manifest_tests.stdout.log](evidence/pipeline_v2_1/run_02/manifest_tests.stdout.log)
- [docs/evidence/pipeline_v2_1/run_02/python_version.stderr.log](evidence/pipeline_v2_1/run_02/python_version.stderr.log)
- [docs/evidence/pipeline_v2_1/run_02/python_version.stdout.log](evidence/pipeline_v2_1/run_02/python_version.stdout.log)
- [docs/evidence/pipeline_v2_1/run_02/schema.stderr.log](evidence/pipeline_v2_1/run_02/schema.stderr.log)
- [docs/evidence/pipeline_v2_1/run_02/schema.stdout.log](evidence/pipeline_v2_1/run_02/schema.stdout.log)
- [docs/evidence/pipeline_v2_1/run_02/summary.json](evidence/pipeline_v2_1/run_02/summary.json)
- [docs/evidence/pipeline_v2_1/run_02/whitespace.stderr.log](evidence/pipeline_v2_1/run_02/whitespace.stderr.log)
- [docs/evidence/pipeline_v2_1/run_02/whitespace.stdout.log](evidence/pipeline_v2_1/run_02/whitespace.stdout.log)
