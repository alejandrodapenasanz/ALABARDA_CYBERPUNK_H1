Lee primero `AGENTS.md` íntegro y cumple su orden de lectura. Este catálogo no autoriza ejecutar ningún lote.

# Prompts de lotes B0–B8

**v2.1 · 2026-11-22 · migración pendiente de validación.** Roles/estados, commits y paquetes según [workflow](../docs/DEVELOPMENT_WORKFLOW.md). Plantillas [Claude implementación](_templates/CLAUDE_IMPLEMENT_BATCH.md), [Codex validación](_templates/CODEX_VALIDATE_BATCH.md), [Claude corrección](_templates/CLAUDE_FIX_BATCH.md). No se duplican especificaciones individuales; los enlaces definen contenido/aceptación.

## B0 — Infraestructura y arte

Estado: APPROVED histórico; no reejecutar ni fabricar paquete. Dependencia: H02. Paquete al implementar: `validation/B00/`.

Prompt para usar **solo tras autorización**:

> Lee íntegramente AGENTS.md y su orden de lectura. Aplica prompts/_templates/CLAUDE_IMPLEMENT_BATCH.md al lote B0, hitos H03, H04, con los prompts enlazados debajo. Programa exclusivamente este lote autorizado; conserva checkpoints por hito, interfaces y tests/fixtures. No tienes Godot ni Blender: sus pruebas quedan NOT_RUN. Entrega paquete completo por SHA en validation/B00/ conforme al workflow, registra pendientes y no autoapruebes ni empieces B1. Codex aplicará CODEX_VALIDATE_BATCH al mismo SHA; el creador aprueba.

Hitos y criterios (fuente única, no duplicada):

- [H03 — Infraestructura de pruebas y balance](H03_INFRAESTRUCTURA_DE_PRUEBAS_Y_BALANCE.md)
- [H04 — Vertical de arte temprano](H04_VERTICAL_DE_ARTE_TEMPRANO.md)

Regresiones: H1 y laboratorio H03/H04 cuando estén afectados, más lotes anteriores pertinentes. Los hitos especifican casos propios y decisiones bloqueantes. Sin adelantarlos por datos/fixtures; todos los resultados nuevos empiezan NOT_RUN.

## B1 — Jugador, interacción, movimiento, salud y daño

Estado: NOT_STARTED; requiere aprobación de migración y encargo propio. Dependencia: B0. Paquete al implementar: `validation/B01/`.

Prompt para usar **solo tras autorización**:

> Lee íntegramente AGENTS.md y su orden de lectura. Aplica prompts/_templates/CLAUDE_IMPLEMENT_BATCH.md al lote B1, hitos H05, H06, con los prompts enlazados debajo. Programa exclusivamente este lote autorizado; conserva checkpoints por hito, interfaces y tests/fixtures. No tienes Godot ni Blender: sus pruebas quedan NOT_RUN. Entrega paquete completo por SHA en validation/B01/ conforme al workflow, registra pendientes y no autoapruebes ni empieces B2. Codex aplicará CODEX_VALIDATE_BATCH al mismo SHA; el creador aprueba.

Hitos y criterios (fuente única, no duplicada):

- [H05 — Núcleo de jugador, interacción y movimiento](H05_NUCLEO_DE_JUGADOR_INTERACCION_Y_MOVIMIENTO.md)
- [H06 — Daño, salud, hitzones y estados de ataque](H06_DANO_SALUD_HITZONES_Y_ESTADOS_DE_ATAQUE.md)

Regresiones: H1 y laboratorio H03/H04 cuando estén afectados, más lotes anteriores pertinentes. Los hitos especifican casos propios y decisiones bloqueantes. Sin adelantarlos por datos/fixtures; todos los resultados nuevos empiezan NOT_RUN.

## B2 — Armas, energía y ultimates

Estado: NOT_STARTED; requiere aprobación de migración y encargo propio. Dependencia: B1. Paquete al implementar: `validation/B02/`.

Prompt para usar **solo tras autorización**:

> Lee íntegramente AGENTS.md y su orden de lectura. Aplica prompts/_templates/CLAUDE_IMPLEMENT_BATCH.md al lote B2, hitos H07, H08, H09, con los prompts enlazados debajo. Programa exclusivamente este lote autorizado; conserva checkpoints por hito, interfaces y tests/fixtures. No tienes Godot ni Blender: sus pruebas quedan NOT_RUN. Entrega paquete completo por SHA en validation/B02/ conforme al workflow, registra pendientes y no autoapruebes ni empieces B3. Codex aplicará CODEX_VALIDATE_BATCH al mismo SHA; el creador aprueba.

Hitos y criterios (fuente única, no duplicada):

- [H07 — Seis armas y loadout libre](H07_SEIS_ARMAS_Y_LOADOUT_LIBRE.md)
- [H08 — Energía pasiva, bajas y curación manual con E](H08_ENERGIA_CURACION_Y_EXTRACCION_CYBORG.md)
- [H09 — Tres ultimates independientes](H09_TRES_ULTIMATES_INDEPENDIENTES.md)

Regresiones: H1 y laboratorio H03/H04 cuando estén afectados, más lotes anteriores pertinentes. Los hitos especifican casos propios y decisiones bloqueantes. Sin adelantarlos por datos/fixtures; todos los resultados nuevos empiezan NOT_RUN.

## B3 — Enemigos, percepción y sigilo

Estado: NOT_STARTED; requiere aprobación de migración y encargo propio. Dependencia: B2. Paquete al implementar: `validation/B03/`.

Prompt para usar **solo tras autorización**:

> Lee íntegramente AGENTS.md y su orden de lectura. Aplica prompts/_templates/CLAUDE_IMPLEMENT_BATCH.md al lote B3, hitos H10, H11, H12, con los prompts enlazados debajo. Programa exclusivamente este lote autorizado; conserva checkpoints por hito, interfaces y tests/fixtures. No tienes Godot ni Blender: sus pruebas quedan NOT_RUN. Entrega paquete completo por SHA en validation/B03/ conforme al workflow, registra pendientes y no autoapruebes ni empieces B4. Codex aplicará CODEX_VALIDATE_BATCH al mismo SHA; el creador aprueba.

Hitos y criterios (fuente única, no duplicada):

- [H10 — Enemigos base: tres arquetipos y patrullas](H10_ENEMIGOS_BASE_TRES_ARQUETIPOS_Y_PATRULLAS.md)
- [H11 — Sigilo: memoria, búsqueda y retorno](H11_SIGILO_MEMORIA_BUSQUEDA_Y_RETORNO.md)
- [H12 — Cámaras, alarmas y cadáveres](H12_CAMARAS_ALARMAS_Y_CADAVERES.md)

Regresiones: H1 y laboratorio H03/H04 cuando estén afectados, más lotes anteriores pertinentes. Los hitos especifican casos propios y decisiones bloqueantes. Sin adelantarlos por datos/fixtures; todos los resultados nuevos empiezan NOT_RUN.

## B4 — Persistencia, firmware y economía

Estado: NOT_STARTED; requiere aprobación de migración y encargo propio. Dependencia: B3. Paquete al implementar: `validation/B04/`.

Prompt para usar **solo tras autorización**:

> Lee íntegramente AGENTS.md y su orden de lectura. Aplica prompts/_templates/CLAUDE_IMPLEMENT_BATCH.md al lote B4, hitos H13, H14, H15, con los prompts enlazados debajo. Programa exclusivamente este lote autorizado; conserva checkpoints por hito, interfaces y tests/fixtures. No tienes Godot ni Blender: sus pruebas quedan NOT_RUN. Entrega paquete completo por SHA en validation/B04/ conforme al workflow, registra pendientes y no autoapruebes ni empieces B5. Codex aplicará CODEX_VALIDATE_BATCH al mismo SHA; el creador aprueba.

Hitos y criterios (fuente única, no duplicada):

- [H13 — Persistencia, inventario, créditos y dificultades](H13_PERSISTENCIA_INVENTARIO_CREDITOS_Y_DIFICULTAD.md)
- [H14 — Firmware árbol de perks y respec](H14_FIRMWARE_ARBOL_DE_PERKS_Y_RESPEC.md)
- [H15 — Mejoras físicas de armas y catálogo comercial](H15_MEJORAS_FISICAS_DE_ARMAS_Y_CATALOGO_COMERCIAL.md)

Regresiones: H1 y laboratorio H03/H04 cuando estén afectados, más lotes anteriores pertinentes. Los hitos especifican casos propios y decisiones bloqueantes. Sin adelantarlos por datos/fixtures; todos los resultados nuevos empiezan NOT_RUN.

## B5 — Guarida y equipamiento

Estado: NOT_STARTED; requiere aprobación de migración y encargo propio. Dependencia: B4. Paquete al implementar: `validation/B05/`.

Prompt para usar **solo tras autorización**:

> Lee íntegramente AGENTS.md y su orden de lectura. Aplica prompts/_templates/CLAUDE_IMPLEMENT_BATCH.md al lote B5, hitos H16, H17, H18, con los prompts enlazados debajo. Programa exclusivamente este lote autorizado; conserva checkpoints por hito, interfaces y tests/fixtures. No tienes Godot ni Blender: sus pruebas quedan NOT_RUN. Entrega paquete completo por SHA en validation/B05/ conforme al workflow, registra pendientes y no autoapruebes ni empieces B6. Codex aplicará CODEX_VALIDATE_BATCH al mismo SHA; el creador aprueba.

Hitos y criterios (fuente única, no duplicada):

- [H16 — Guarida y ordenador/terminal](H16_GUARIDA_Y_ORDENADOR_TERMINAL.md)
- [H17 — Entregas físicas, montaje y USB](H17_ENTREGAS_FISICAS_MONTAJE_Y_USB.md)
- [H18 — Arsenal, selección de 3 armas y vitrina](H18_ARSENAL_SELECCION_DE_3_ARMAS_Y_VITRINA.md)

Regresiones: H1 y laboratorio H03/H04 cuando estén afectados, más lotes anteriores pertinentes. Los hitos especifican casos propios y decisiones bloqueantes. Sin adelantarlos por datos/fixtures; todos los resultados nuevos empiezan NOT_RUN.

## B6 — Contrato, boss y recompensas

Estado: NOT_STARTED; requiere aprobación de migración y encargo propio. Dependencia: B5. Paquete al implementar: `validation/B06/`.

Prompt para usar **solo tras autorización**:

> Lee íntegramente AGENTS.md y su orden de lectura. Aplica prompts/_templates/CLAUDE_IMPLEMENT_BATCH.md al lote B6, hitos H19, H20, H21, con los prompts enlazados debajo. Programa exclusivamente este lote autorizado; conserva checkpoints por hito, interfaces y tests/fixtures. No tienes Godot ni Blender: sus pruebas quedan NOT_RUN. Entrega paquete completo por SHA en validation/B06/ conforme al workflow, registra pendientes y no autoapruebes ni empieces B7. Codex aplicará CODEX_VALIDATE_BATCH al mismo SHA; el creador aprueba.

Hitos y criterios (fuente única, no duplicada):

- [H19 — Contrato Yakuza: tres plantas + ascensores](H19_CONTRATO_YAKUZA_TRES_PLANTAS_ASCENSORES.md)
- [H20 — Jefe Yakuza: dos fases y recompensa](H20_JEFE_YAKUZA_DOS_FASES_Y_RECOMPENSA.md)
- [H21 — Economía de contratos y objetivos secundarios](H21_ECONOMIA_DE_CONTRATOS_Y_OBJETIVOS_SECUNDARIOS.md)

Regresiones: H1 y laboratorio H03/H04 cuando estén afectados, más lotes anteriores pertinentes. Los hitos especifican casos propios y decisiones bloqueantes. Sin adelantarlos por datos/fixtures; todos los resultados nuevos empiezan NOT_RUN.

## B7 — Integración y UX

Estado: NOT_STARTED; requiere aprobación de migración y encargo propio. Dependencia: B6. Paquete al implementar: `validation/B07/`.

Prompt para usar **solo tras autorización**:

> Lee íntegramente AGENTS.md y su orden de lectura. Aplica prompts/_templates/CLAUDE_IMPLEMENT_BATCH.md al lote B7, hitos H22, con los prompts enlazados debajo. Programa exclusivamente este lote autorizado; conserva checkpoints por hito, interfaces y tests/fixtures. No tienes Godot ni Blender: sus pruebas quedan NOT_RUN. Entrega paquete completo por SHA en validation/B07/ conforme al workflow, registra pendientes y no autoapruebes ni empieces B8. Codex aplicará CODEX_VALIDATE_BATCH al mismo SHA; el creador aprueba.

Hitos y criterios (fuente única, no duplicada):

- [H22 — Integración, dificultad, UX y accesibilidad básica](H22_INTEGRACION_DIFICULTAD_UX_Y_ACCESIBILIDAD_BAS.md)

Regresiones: H1 y laboratorio H03/H04 cuando estén afectados, más lotes anteriores pertinentes. Los hitos especifican casos propios y decisiones bloqueantes. Sin adelantarlos por datos/fixtures; todos los resultados nuevos empiezan NOT_RUN.

## B8 — Pulido y publicación Windows

Estado: NOT_STARTED; requiere aprobación de migración y encargo propio. Dependencia: B7. Paquete al implementar: `validation/B08/`.

Prompt para usar **solo tras autorización**:

> Lee íntegramente AGENTS.md y su orden de lectura. Aplica prompts/_templates/CLAUDE_IMPLEMENT_BATCH.md al lote B8, hitos H23, H24, con los prompts enlazados debajo. Programa exclusivamente este lote autorizado; conserva checkpoints por hito, interfaces y tests/fixtures. No tienes Godot ni Blender: sus pruebas quedan NOT_RUN. Entrega paquete completo por SHA en validation/B08/ conforme al workflow, registra pendientes y no autoapruebes ni empieces B8. Codex aplicará CODEX_VALIDATE_BATCH al mismo SHA; el creador aprueba.

Hitos y criterios (fuente única, no duplicada):

- [H23 — Pulido artístico/audio/animación y rendimiento](H23_PULIDO_ARTISTICO_AUDIO_ANIMACION_Y_RENDIMIENT.md)
- [H24 — Release candidate Windows + auditoría final](H24_RELEASE_CANDIDATE_WINDOWS_AUDITORIA_FINAL.md)

Regresiones: H1 y laboratorio H03/H04 cuando estén afectados, más lotes anteriores pertinentes. Los hitos especifican casos propios y decisiones bloqueantes. Sin adelantarlos por datos/fixtures; todos los resultados nuevos empiezan NOT_RUN.
