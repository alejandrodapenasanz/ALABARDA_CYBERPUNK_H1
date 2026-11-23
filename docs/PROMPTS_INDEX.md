# Índice de prompts — v2.1

**2026-11-22.** Exactamente23 prompts H02–H24, mismos IDs/rutas. H08 conserva EXTRACCION en el nombre por compatibilidad; su contenido vigente es energía por bajas/E. No existe PROMPTS_TODOS.md recibido; [BATCH_PROMPTS](../prompts/BATCH_PROMPTS.md) agrupa por enlaces, sin una segunda copia contradictoria. B1 no iniciado.

## Operación

- [Claude implementar lote](../prompts/_templates/CLAUDE_IMPLEMENT_BATCH.md)
- [Codex validar lote](../prompts/_templates/CODEX_VALIDATE_BATCH.md)
- [Claude corregir lote](../prompts/_templates/CLAUDE_FIX_BATCH.md)
- [Handoff de pruebas](../validation/_templates/TEST_HANDOFF.md)
- [Manifest JSON](../validation/_templates/TEST_MANIFEST.json) y [schema1.0.0](../validation/_schemas/test_manifest.schema.json)
- [Resultados](../validation/_templates/TEST_RESULTS.md) y [bug](../validation/_templates/BUG_REPORT.md)
- [Workflow](DEVELOPMENT_WORKFLOW.md), [roadmap](ROADMAP.md), [casos salud/energía](HEALTH_ENERGY_TEST_CASES.md), [controles](CONTROLS.md)

## Hitos individuales

- [H02 — Auditoría H1 y saneamiento documental](../prompts/H02_AUDITORIA_H1_Y_SANEAMIENTO_DOCUMENTAL.md) · previo B0
- [H03 — Infraestructura de pruebas y balance](../prompts/H03_INFRAESTRUCTURA_DE_PRUEBAS_Y_BALANCE.md) · B0
- [H04 — Vertical de arte temprano](../prompts/H04_VERTICAL_DE_ARTE_TEMPRANO.md) · B0
- [H05 — Núcleo de jugador, interacción y movimiento](../prompts/H05_NUCLEO_DE_JUGADOR_INTERACCION_Y_MOVIMIENTO.md) · B1
- [H06 — Daño, salud, hitzones y estados de ataque](../prompts/H06_DANO_SALUD_HITZONES_Y_ESTADOS_DE_ATAQUE.md) · B1
- [H07 — Seis armas y loadout libre](../prompts/H07_SEIS_ARMAS_Y_LOADOUT_LIBRE.md) · B2
- [H08 — Energía por bajas y curación manual con E](../prompts/H08_ENERGIA_CURACION_Y_EXTRACCION_CYBORG.md) · B2
- [H09 — Tres ultimates independientes](../prompts/H09_TRES_ULTIMATES_INDEPENDIENTES.md) · B2
- [H10 — Enemigos base: tres arquetipos y patrullas](../prompts/H10_ENEMIGOS_BASE_TRES_ARQUETIPOS_Y_PATRULLAS.md) · B3
- [H11 — Sigilo: memoria, búsqueda y retorno](../prompts/H11_SIGILO_MEMORIA_BUSQUEDA_Y_RETORNO.md) · B3
- [H12 — Cámaras, alarmas y cadáveres](../prompts/H12_CAMARAS_ALARMAS_Y_CADAVERES.md) · B3
- [H13 — Persistencia, inventario, créditos y dificultades](../prompts/H13_PERSISTENCIA_INVENTARIO_CREDITOS_Y_DIFICULTAD.md) · B4
- [H14 — Firmware árbol de perks y respec](../prompts/H14_FIRMWARE_ARBOL_DE_PERKS_Y_RESPEC.md) · B4
- [H15 — Mejoras físicas de armas y catálogo comercial](../prompts/H15_MEJORAS_FISICAS_DE_ARMAS_Y_CATALOGO_COMERCIAL.md) · B4
- [H16 — Guarida y ordenador/terminal](../prompts/H16_GUARIDA_Y_ORDENADOR_TERMINAL.md) · B5
- [H17 — Entregas físicas, montaje y USB](../prompts/H17_ENTREGAS_FISICAS_MONTAJE_Y_USB.md) · B5
- [H18 — Arsenal, selección de 3 armas y vitrina](../prompts/H18_ARSENAL_SELECCION_DE_3_ARMAS_Y_VITRINA.md) · B5
- [H19 — Contrato Yakuza: tres plantas + ascensores](../prompts/H19_CONTRATO_YAKUZA_TRES_PLANTAS_ASCENSORES.md) · B6
- [H20 — Jefe Yakuza: dos fases y recompensa](../prompts/H20_JEFE_YAKUZA_DOS_FASES_Y_RECOMPENSA.md) · B6
- [H21 — Economía de contratos y objetivos secundarios](../prompts/H21_ECONOMIA_DE_CONTRATOS_Y_OBJETIVOS_SECUNDARIOS.md) · B6
- [H22 — Integración, dificultad, UX y accesibilidad básica](../prompts/H22_INTEGRACION_DIFICULTAD_UX_Y_ACCESIBILIDAD_BAS.md) · B7
- [H23 — Pulido artístico/audio/animación y rendimiento](../prompts/H23_PULIDO_ARTISTICO_AUDIO_ANIMACION_Y_RENDIMIENT.md) · B8
- [H24 — Release candidate Windows + auditoría final](../prompts/H24_RELEASE_CANDIDATE_WINDOWS_AUDITORIA_FINAL.md) · B8

H02–H04 APPROVED histórico; su revisión del prompt no reabre el trabajo. Cada prompt distingue Claude sin motor, Codex con motor y aprobación humana, paquete y regresiones. Originales trazados en [manifiesto](history/pre_pipeline_v2_1/manifest.json).
