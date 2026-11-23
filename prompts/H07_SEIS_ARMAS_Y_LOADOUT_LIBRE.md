Lee primero `AGENTS.md` íntegro desde la raíz y cumple su orden de lectura. Después lee `docs/DEVELOPMENT_WORKFLOW.md`, `docs/ROADMAP.md`, `docs/DECISIONS.md`, `docs/GAME_DESIGN.md`, `docs/HEALTH_ENERGY_CONTRACT.md`, `docs/CONTROLS.md`, `docs/BALANCE_PROVISIONAL.md`, `docs/ARCHITECTURE.md`, `docs/TEST_STRATEGY.md`, `docs/VALIDATION.md` y `docs/HANDOFF.md`. Para visuales, ART_BIBLE y ASSET_REGISTRY íntegros. Inspecciona project.godot, escenas/scripts/tests y git status antes de editar; declara ausencias/capacidades. Este archivo solo se ejecuta con encargo expreso dentro del lote autorizado.

# H07 — Seis armas y loadout libre

**Revisión pipeline v2.1 · 2026-11-22 · B2 · NOT_STARTED.** Migración pendiente de validación; no autoriza iniciar/reabrir este hito. Dependencia: H06 / lote anterior aprobado antes de integración; solape solo según workflow y autorización.

## Objetivo funcional

Katana auto-deflect equipada (limitar a proyectiles compatibles definidos), pistola silenciada, rifle con scope, espada-sierra, revólver, escopeta 1/2 cañones; cargadores y reserva ilimitada; recargas animadas; tres slots de cualquier arma, iniciales katana/pistola/escopeta. Implementar data-driven y viewmodels provisionales con feedback.

1/2/3: desde desarmado equipa, mismo slot guarda, otro cambia directo respetando animación. Separar slot/etiqueta/asignación/restricciones; NO imponer categorías. P-016 etiquetas, P-011 duplicados/vacíos y P-006 parry/bonus requieren decisión para sus componentes.

## Roles, checkpoint y alcance

Claude implementa solo los hitos del lote autorizado, con revisión y checkpoint por hito (interfaces, archivos, tests, dependencias, bugs y commit separado cuando sea posible). **PC Claude sin Godot ni Blender**: prepara tests/escenas/datos y ejecuta solo verificaciones disponibles sin motor; Godot queda NOT_RUN. No confundir CODE_READY con VALIDATED.

Codex comprueba el SHA exacto y valida importación, tests, regresiones y escenas; usa Blender solo si procede. Corrige fallos pequeños/locales; cambios estructurales vuelven a Claude con BUG_REPORT reproducible. Creador valida manualmente y concede APPROVED. Dentro del lote autorizado puede continuar tras checkpoint; no cerrar ni empezar otro lote por iniciativa propia.

Fuera de alcance: hitos ajenos al lote, reinterpretar propuestas como aprobadas, ampliar MVP, assets sin licencia, refactors irrelevantes, sistemas futuros para simular resultados. Conservar rutas/bindings hasta su migración autorizada. Modern PSX / Retro Industrial Cyberpunk D-017, perfil D-019, HomeVideo D-020 y referencia H04 D-021; muestras experimentales, Malorian solo local, fallback público. H04 es laboratorio sin colisiones/IA, no nivel jugable. [Continuidad](../docs/HANDOFF.md).

## Pruebas a preparar y ejecutar en el entorno correspondiente

- Tests munición de reserva infinita/cargador, recarga parcial, dos cañones con 1 cartucho, slot 3 y duplicados, headshots, auto-deflect condicionado, disparos durante RELOAD bloqueados; smoke de cada arma; regresión H06.
- Cada caso del paquete: ID, propósito, fixture/datos, precondiciones, comando exacto o pasos numerados, cwd, esperado, PASS/FAIL, timeout, dependencias, entorno y evidencia. No basta enumerar nombres de tests.
- Claude: revisión estática/documental ejecutada se registra como tal; tests Godot NOT_RUN. Codex: importación headless, suites pertinentes, logs/JUnit y regresiones existentes sobre el commit pedido según TEST_STRATEGY. No atribuir PASS por haber escrito un test.
- Manual: escena exacta, cómo abrir/ejecutar, controles, estado inicial, pasos, resultado/fallo observable, evidencia y repetición. Gameplay/arte/performance requieren motor/ventana y revisión humana, no solo headless.
- Reutilizar [casos SB](../docs/HEALTH_ENERGY_TEST_CASES.md) y [CT](../docs/CONTROLS.md) aplicables; otros casos siguen NOT_RUN hasta su hito. Parámetros provisionales configurables, sin convertir tests de hipótesis en aprobación de balance.

## Archivos probables y entrega

Código/escenas/Resources/tests del sistema de este hito según [ARCHITECTURE](../docs/ARCHITECTURE.md); documentar rutas reales antes de editar, no asumir módulos futuros existentes. Actualizar arquitectura implementada, decisiones afectadas, VALIDATION, HANDOFF y ROADMAP sin alterar evidencia histórica. Registrar assets modificados antes de integrar.

Paquete: `validation/B02/` con TEST_HANDOFF.md, TEST_MANIFEST.json conforme al esquema1.0.0, TEST_RESULTS.md y evidence/. [Plantillas](../docs/PROMPTS_INDEX.md). Incluir errores conocidos, regresiones, checklist humana y recuperación al commit aprobado. H02–H04 ya cerrados conservan evidencia histórica; no fabricar un paquete retroactivo ni ejecutar sus tareas por esta actualización.

## Aceptación

Seis armas usables, acciones y recuperación animadas, libre selección y sin crashes.

Requisitos satisfechos, pruebas técnicas críticas PASS reales sobre mismo commit, sin regresiones críticas, paquete completo y validación manual expresa. Fallos → VALIDATION_FAILED; dependencia crítica ausente → BLOCKED; pendientes sin ejecutar → NOT_RUN, nunca PASS. Entrega final: qué cambió, archivos, comandos/exit/logs/resultados, bugs, decisiones, pasos manuales y siguiente paso. No autoaprobar ni autorizar otro lote.
