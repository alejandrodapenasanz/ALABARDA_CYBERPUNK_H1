# SPEC_REVIEW — Qué falta antes de congelar el alcance
**Estado:** revisión final previa a congelación del MVP.

## Ya aprobado
Ver `DECISIONS.md`, `GAME_DESIGN.md` y `MVP_SCOPE.md`. La especificación cubre visión, armas, ultimates, economía conceptual, sigilo, guarida, niveles, guardado, progresión y dificultad.

PRE-H03 · 2026-11-20: D-017 aprueba **Modern PSX / Retro Industrial Cyberpunk** y producción híbrida/progresiva. [ART_BIBLE](ART_BIBLE.md) detalla geometría, texturas, iluminación, legibilidad, efectos opcionales y aplicación por sistema. Paleta/resoluciones/presupuestos siguen propuestas; no hay assets ni resultado visual aprobados. H03 prepara una escena comparativa e investigación; H04 conserva la vertical. La propuesta ampliada de dos armas/brazo de abajo no se convierte en requisito de H03.

## Cierre propuesto (requiere aprobación)
- Congelar exclusiones incluidas en `MVP_SCOPE.md`.
- Formalizar configuraciones de dificultad como datos y no como 3 copias de niveles.
- Incluir un primer objetivo visual corto que valide una sala, dos armas en primera persona, brazo cyborg y enemigo coherentes antes de producir arte de tres plantas.
- Establecer cifras **configurables** en Godot Resources y probarlas, sin afirmar valores no aprobados como definitivos.
- Diseñar tests con asserts de extracción, curación, ultimates, IA de alarma, economía/rollback y serialización + import/export.
- Evitar reescribir H1 antes de pasar sus funcionalidades a una arquitectura refactorizada y validada.

## Riesgos críticos
1. **Sigilo completo** (cámaras, cadáveres, alarmas y memoria) suma muchos estados y escenarios de prueba.
2. **Armas en FPS** requieren animaciones exclusivas en primera persona, no basta descargar armas estáticas.
3. **Compras físicas** implican máquina de estados robusta entre compra, entrega, transporte, montaje, desbloqueo y autosave.
4. **Dead Eye** debe ralentizar el mundo manteniendo jugador a velocidad normal.
5. **Arte mixto** sin guía de materiales y siluetas produce inconsistencia aunque los assets sean técnicamente aptos.

## Estado corregido en H02 · 2026-11-20
`ROADMAP.md`, `ARCHITECTURE.md`, `VALIDATION.md` y los prompts ya existen. Su existencia no demuestra aprobación del alcance ni ejecución de hitos futuros. Esta nota reemplaza el anuncio obsoleto de crearlos; [original íntegro](history/pre_h02/docs/SPEC_REVIEW.md).

La revisión queda centralizada en [DOCUMENTATION_AUDIT](DOCUMENTATION_AUDIT.md). Las contradicciones de firmware, alarma general y alcance de Dead Eye se resolvieron mediante respuestas expresas del creador el 2026-11-20; las propuestas futuras conservan PENDING_APPROVAL. `AGENTS.md` sigue leyéndose antes de cada hito. H02 APROBADO POR CREADOR tras su confirmación manual posterior durante PRE-H03; H03 documentalmente preparado, pendiente de autorización propia.
