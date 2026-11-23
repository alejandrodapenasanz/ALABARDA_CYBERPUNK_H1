# SPEC_REVIEW — Qué falta antes del roadmap
**Estado:** revisión final previa a congelación del MVP.

## Ya aprobado
Ver `DECISIONS.md`, `GAME_DESIGN.md` y `MVP_SCOPE.md`. La especificación cubre visión, armas, ultimates, economía conceptual, sigilo, guarida, niveles, guardado, progresión y dificultad.

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

## Próximo entregable tras tu aprobación
`ROADMAP.md`, `ARCHITECTURE.md`, `VALIDATION.md` y los prompts de hitos con contratos de entrada/salida y tests automáticos concretos. `AGENTS.md` es leído antes de cada prompt.
