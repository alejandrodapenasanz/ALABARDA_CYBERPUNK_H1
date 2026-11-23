# ROADMAP — H02–H24 y lotes B0–B8

**2026-11-22 · agrupación solicitada v2.1; migración pendiente de validación.** No se renumera ni implementa ningún hito. H1–H04 cerrados por el creador; B1 NOT_STARTED y no autorizado.

## Lotes y dependencias

| Lote | Hitos | Objetivo | Depende de | Estado lote |
|---|---|---|---|---|
| B0 | H03, H04 | Infraestructura y arte | H02 | APPROVED histórico H03/H04 |
| B1 | H05, H06 | Jugador, interacción, movimiento, salud y daño | B0 | NOT_STARTED |
| B2 | H07, H08, H09 | Armas, energía y ultimates | B1 | NOT_STARTED |
| B3 | H10, H11, H12 | Enemigos, percepción y sigilo | B2 | NOT_STARTED |
| B4 | H13, H14, H15 | Persistencia, firmware y economía | B3 | NOT_STARTED |
| B5 | H16, H17, H18 | Guarida y equipamiento | B4 | NOT_STARTED |
| B6 | H19, H20, H21 | Contrato, boss y recompensas | B5 | NOT_STARTED |
| B7 | H22 | Integración y UX | B6 | NOT_STARTED |
| B8 | H23, H24 | Pulido y publicación Windows | B7 | NOT_STARTED |

H02 es auditoría previa fuera de lotes. B0 identifica infraestructura ya aprobada, no una nueva aprobación ni un paquete retroactivo. Dentro de cada lote se conserva orden y checkpoint por hito. [Workflow](DEVELOPMENT_WORKFLOW.md) define puertas, solape autorizado, SHA y roles.

## Estado individual y prompts de aceptación

| Hito | Objetivo / prompt | Lote | Estado hito | Dependencia funcional |
|---|---|---|---|---|
| H02 | [Auditoría H1 y saneamiento documental](../prompts/H02_AUDITORIA_H1_Y_SANEAMIENTO_DOCUMENTAL.md) | Fuera de lotes | APPROVED histórico | H1 |
| H03 | [Infraestructura de pruebas y balance](../prompts/H03_INFRAESTRUCTURA_DE_PRUEBAS_Y_BALANCE.md) | B0 | APPROVED histórico | H02 |
| H04 | [Vertical de arte temprano](../prompts/H04_VERTICAL_DE_ARTE_TEMPRANO.md) | B0 | APPROVED histórico | H03 |
| H05 | [Núcleo de jugador, interacción y movimiento](../prompts/H05_NUCLEO_DE_JUGADOR_INTERACCION_Y_MOVIMIENTO.md) | B1 | NOT_STARTED | H04 |
| H06 | [Daño, salud, hitzones y estados de ataque](../prompts/H06_DANO_SALUD_HITZONES_Y_ESTADOS_DE_ATAQUE.md) | B1 | NOT_STARTED | H05 |
| H07 | [Seis armas y loadout libre](../prompts/H07_SEIS_ARMAS_Y_LOADOUT_LIBRE.md) | B2 | NOT_STARTED | H06 |
| H08 | [Energía pasiva, bajas y curación manual con E](../prompts/H08_ENERGIA_CURACION_Y_EXTRACCION_CYBORG.md) | B2 | NOT_STARTED | H07 |
| H09 | [Tres ultimates independientes](../prompts/H09_TRES_ULTIMATES_INDEPENDIENTES.md) | B2 | NOT_STARTED | H08 |
| H10 | [Enemigos base: tres arquetipos y patrullas](../prompts/H10_ENEMIGOS_BASE_TRES_ARQUETIPOS_Y_PATRULLAS.md) | B3 | NOT_STARTED | H09 |
| H11 | [Sigilo: memoria, búsqueda y retorno](../prompts/H11_SIGILO_MEMORIA_BUSQUEDA_Y_RETORNO.md) | B3 | NOT_STARTED | H10 |
| H12 | [Cámaras, alarmas y cadáveres](../prompts/H12_CAMARAS_ALARMAS_Y_CADAVERES.md) | B3 | NOT_STARTED | H11 |
| H13 | [Persistencia, inventario, créditos y dificultades](../prompts/H13_PERSISTENCIA_INVENTARIO_CREDITOS_Y_DIFICULTAD.md) | B4 | NOT_STARTED | H12 |
| H14 | [Firmware árbol de perks y respec](../prompts/H14_FIRMWARE_ARBOL_DE_PERKS_Y_RESPEC.md) | B4 | NOT_STARTED | H13 |
| H15 | [Mejoras físicas de armas y catálogo comercial](../prompts/H15_MEJORAS_FISICAS_DE_ARMAS_Y_CATALOGO_COMERCIAL.md) | B4 | NOT_STARTED | H14 |
| H16 | [Guarida y ordenador/terminal](../prompts/H16_GUARIDA_Y_ORDENADOR_TERMINAL.md) | B5 | NOT_STARTED | H15 |
| H17 | [Entregas físicas, montaje y USB](../prompts/H17_ENTREGAS_FISICAS_MONTAJE_Y_USB.md) | B5 | NOT_STARTED | H16 |
| H18 | [Arsenal, selección de 3 armas y vitrina](../prompts/H18_ARSENAL_SELECCION_DE_3_ARMAS_Y_VITRINA.md) | B5 | NOT_STARTED | H17 |
| H19 | [Contrato Yakuza: tres plantas + ascensores](../prompts/H19_CONTRATO_YAKUZA_TRES_PLANTAS_ASCENSORES.md) | B6 | NOT_STARTED | H18 |
| H20 | [Jefe Yakuza: dos fases y recompensa](../prompts/H20_JEFE_YAKUZA_DOS_FASES_Y_RECOMPENSA.md) | B6 | NOT_STARTED | H19 |
| H21 | [Economía de contratos y objetivos secundarios](../prompts/H21_ECONOMIA_DE_CONTRATOS_Y_OBJETIVOS_SECUNDARIOS.md) | B6 | NOT_STARTED | H20 |
| H22 | [Integración, dificultad, UX y accesibilidad básica](../prompts/H22_INTEGRACION_DIFICULTAD_UX_Y_ACCESIBILIDAD_BAS.md) | B7 | NOT_STARTED | H21 |
| H23 | [Pulido artístico/audio/animación y rendimiento](../prompts/H23_PULIDO_ARTISTICO_AUDIO_ANIMACION_Y_RENDIMIENT.md) | B8 | NOT_STARTED | H22 |
| H24 | [Release candidate Windows + auditoría final](../prompts/H24_RELEASE_CANDIDATE_WINDOWS_AUDITORIA_FINAL.md) | B8 | NOT_STARTED | H23 |

Cada prompt mantiene su objetivo, pruebas y aceptación. H06 prepara salud/autoHP e interfaz para manual; H08 implementa energía/E; H09 ultimates. H08 usa eventos de baja de fixtures antes de enemigos H10; H19 conecta ascensor real. H13 introduce matriz de dificultad; H05/H10 no dependen de algo inexistente. H14 usa instalación simulada por contrato antes de flujo físico H17, sin activar perks al comprar. Estas dependencias no autorizan adelantar sistemas.

## Puertas y pendientes

NOT_STARTED → IN_PROGRESS → CODE_READY → INTEGRATION_READY → VALIDATED → APPROVED; fallos VALIDATION_FAILED, impedimento BLOCKED. Tests usan PASS/FAIL/NOT_RUN/BLOCKED. Claude puede continuar dentro del lote autorizado tras checkpoint, sin aprobación humana ficticia. Codex verifica último commit, creador aprueba manualmente. Ningún lote siguiente comienza sin encargo; solape excepcional solo según workflow.

P-015 binding interacción afecta B1; se puede preparar acción/test inyectado, no cerrar prueba manual sin decisión. P-011/P-016 slots y P-006 compatibilidades afectan B2/B5; P-017 remates se revisan sin F extracción. P-002 perks/economía B4; P-003 mapa/IA/boss B3/B6; P-013 retorno B6; P-007 cierre MVP B8. No cambiar secuencia para esconder pendientes.

[Prompts de lotes](../prompts/BATCH_PROMPTS.md), [índice](PROMPTS_INDEX.md), [estado de entrega](HANDOFF.md), [validación histórica](VALIDATION.md).
