# ALABARDA CYBERPUNK — Godot

**Descarga para otro PC:** usa **main** para la versión aprobada y la rama **B1** para revisar este lote. Sigue [GITHUB_TRANSFER](docs/GITHUB_TRANSFER.md). Incluye documentación, prompts, herramientas y recursos redistribuibles; la baseline portable se comprueba antes de editar. B1 está implementado y pendiente del retest manual del fix de paredes.

**2026-11-22:** H1–H04 cerrados y aprobados. **2026-11-23:** migración documental pipeline v2.1 aprobada por el creador (D-027/D-028). **2026-11-27:** B1 INTEGRATION_READY, fix `1401e05` con automáticas PASS; aceptación manual pendiente. [Handoff](docs/HANDOFF.md), [informe](validation/B01/TEST_RESULTS.md).

Importa `project.godot` con Godot **4.7.2 estándar**. **F5 inicia la greybox H1**. Para arte abre `scenes/art_reference/modern_psx_lab.tscn` y pulsa **F6**: laboratorio H04, kit propio y muestras experimentales. L cambia luz, 1–4 cámara, A anima brazos, F compara fuentes, X/B retro, 0 restaura D-019. Malorian solo local/opcional, publicación con fallback propio; assets de prueba, no finales.

**B1 (automáticas PASS: 37 unitarias + 35 de integración):** detén cualquier ejecución anterior, abre `scenes/b1/b1_sandbox.tscn` y pulsa **F6**: doble toque WW/AA/SS/DD dash, F interactuar, E reservada, clic dispara, salud con regeneración, blancos y zona de daño. El fix impide que el arma penetre paredes al moverse o girar, conservando su aspecto. F5 sigue siendo H1.

H1 actual: WASD, ratón/clic disparo, Shift sprint, Espacio salto, Q+dirección dash, Esc libera cursor, R repone blancos tras vencer cinco. HP100/respawn; no energía, E ni nuevos controles todavía. [Arquitectura real](docs/ARCHITECTURE.md).

## Desarrollo siguiente

Leer [AGENTS](AGENTS.md) y [workflow Claude → Codex](docs/DEVELOPMENT_WORKFLOW.md). Claude programa sin Godot/Blender, Codex valida SHA exacto, creador aprueba. [Roadmap](docs/ROADMAP.md), [prompts](docs/PROMPTS_INDEX.md), [contrato de dos barras](docs/HEALTH_ENERGY_CONTRACT.md) y [controles futuros](docs/CONTROLS.md). B2 no iniciado; cada lote requiere encargo expreso.

## Verificación

Comandos y capacidades en [TEST_STRATEGY](docs/TEST_STRATEGY.md); resultados reales en [VALIDATION](docs/VALIDATION.md). Históricos H1–H04 no certifican el sistema nuevo. Fuente de gameplay vigente DECISIONS/GAME_DESIGN; GDD y paquetes públicos H03/H04 son snapshots históricos. La copia pública resumida no sustituye la documentación completa para desarrollar entre PC.
