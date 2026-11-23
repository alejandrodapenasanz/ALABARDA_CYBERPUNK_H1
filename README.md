# ALABARDA CYBERPUNK — Godot

**Descarga para otro PC:** usa la rama **main** del repositorio y sigue [GITHUB_TRANSFER](docs/GITHUB_TRANSFER.md). Incluye la documentación completa, prompts, herramientas y recursos de prueba redistribuibles. `python -X utf8 tools/pipeline/verify_checkout.py` comprueba la copia antes de editar. B1 sigue sin implementar.

**2026-11-22:** H1–H04 cerrados y aprobados. Migración documental pipeline v2.1 preparada para revisión, **sin aprobación de esta entrega**; B1 NOT_STARTED, sin programar. [Handoff](docs/HANDOFF.md), [informe](docs/PIPELINE_MIGRATION_REPORT.md).

Importa `project.godot` con Godot **4.7.2 estándar**. **F5 inicia la greybox H1**. Para arte abre `scenes/art_reference/modern_psx_lab.tscn` y pulsa **F6**: laboratorio H04, kit propio y muestras experimentales. L cambia luz, 1–4 cámara, A anima brazos, F compara fuentes, X/B retro, 0 restaura D-019. Malorian solo local/opcional, publicación con fallback propio; assets de prueba, no finales.

H1 actual: WASD, ratón/clic disparo, Shift sprint, Espacio salto, Q+dirección dash, Esc libera cursor, R repone blancos tras vencer cinco. HP100/respawn; no energía, E ni nuevos controles todavía. [Arquitectura real](docs/ARCHITECTURE.md).

## Desarrollo siguiente

Leer [AGENTS](AGENTS.md) y [workflow Claude → Codex](docs/DEVELOPMENT_WORKFLOW.md). Claude programa sin Godot/Blender, Codex valida SHA exacto, creador aprueba. [Roadmap](docs/ROADMAP.md), [prompts](docs/PROMPTS_INDEX.md), [contrato de dos barras](docs/HEALTH_ENERGY_CONTRACT.md) y [controles futuros](docs/CONTROLS.md). La existencia de estos documentos no autoriza B1.

## Verificación

Comandos y capacidades en [TEST_STRATEGY](docs/TEST_STRATEGY.md); resultados reales en [VALIDATION](docs/VALIDATION.md). Históricos H1–H04 no certifican el sistema nuevo. Fuente de gameplay vigente DECISIONS/GAME_DESIGN; GDD y paquetes públicos H03/H04 son snapshots históricos. La copia pública resumida no sustituye la documentación completa para desarrollar entre PC.
