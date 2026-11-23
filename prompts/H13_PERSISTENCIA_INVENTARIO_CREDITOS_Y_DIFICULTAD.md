Lee primero `AGENTS.md` íntegro desde la raíz y cumple su orden de lectura. Después lee `docs/DEVELOPMENT_WORKFLOW.md`, `docs/ROADMAP.md`, `docs/DECISIONS.md`, `docs/GAME_DESIGN.md`, `docs/HEALTH_ENERGY_CONTRACT.md`, `docs/CONTROLS.md`, `docs/BALANCE_PROVISIONAL.md`, `docs/ARCHITECTURE.md`, `docs/TEST_STRATEGY.md`, `docs/VALIDATION.md` y `docs/HANDOFF.md`. Para visuales, ART_BIBLE y ASSET_REGISTRY íntegros. Inspecciona project.godot, escenas/scripts/tests y git status antes de editar; declara ausencias/capacidades. Este archivo solo se ejecuta con encargo expreso dentro del lote autorizado.

# H13 — Persistencia, inventario, créditos y dificultades

**Revisión pipeline v2.1 · 2026-11-22 · B4 · NOT_STARTED.** Migración pendiente de validación; no autoriza iniciar/reabrir este hito. Dependencia: H12 / lote anterior aprobado antes de integración; solape solo según workflow y autorización.

## Objetivo funcional

GameState versionado y guardados atómicos, idempotencia de transacciones, jugador empieza con tres armas, moneda créditos, selector fácil/normal/difícil; persistencia exclusivamente acciones permanentes; derrota reinicia contrato conservando compras; separar SaveData y RunState.

Separar progreso persistente de estado de intento; no persistir daño/alertas como progreso ni confundir HP/energía. Estado inicial/reinicio detallado P-005; guardar configuraciones versionadas sin convertir valores provisionales en aprobados. Repetir IA/sigilo/armas en tres dificultades desde aquí.

## Roles, checkpoint y alcance

Claude implementa solo los hitos del lote autorizado, con revisión y checkpoint por hito (interfaces, archivos, tests, dependencias, bugs y commit separado cuando sea posible). **PC Claude sin Godot ni Blender**: prepara tests/escenas/datos y ejecuta solo verificaciones disponibles sin motor; Godot queda NOT_RUN. No confundir CODE_READY con VALIDATED.

Codex comprueba el SHA exacto y valida importación, tests, regresiones y escenas; usa Blender solo si procede. Corrige fallos pequeños/locales; cambios estructurales vuelven a Claude con BUG_REPORT reproducible. Creador valida manualmente y concede APPROVED. Dentro del lote autorizado puede continuar tras checkpoint; no cerrar ni empezar otro lote por iniciativa propia.

Fuera de alcance: hitos ajenos al lote, reinterpretar propuestas como aprobadas, ampliar MVP, assets sin licencia, refactors irrelevantes, sistemas futuros para simular resultados. Conservar rutas/bindings hasta su migración autorizada. Modern PSX / Retro Industrial Cyberpunk D-017, perfil D-019, HomeVideo D-020 y referencia H04 D-021; muestras experimentales, Malorian solo local, fallback público. H04 es laboratorio sin colisiones/IA, no nivel jugable. [Continuidad](../docs/HANDOFF.md).

## Contrato transversal (no adelanta otros hitos)

Salud 0–100 y energía 0–150 independientes. Salud automática tras **5 s sin daño** a **5 HP/s**, sin energía; daño reinicia espera, muerto no regenera. E mantenida: **25 HP/s por 25 energía/s**, solo coste de HP recuperado, sin gasto a salud llena, termina al soltar/agotar energía/morir; daño no cancela si sobrevive. Manual activa pausa automática (provisional). Energía pasiva **8/s hasta 100**, incluso en combate, sin reducir la almacenada >100; cada baja del jugador **+15 hasta 150**, sin curación directa de HP. **Tasas, tiempos y pausa: PROVISIONAL_VALUE / PENDING_PLAYTEST.** F extracción SUPERSEDED. Ascensor: energía 150, HP intacto. Ultimate >=100 energía, consume toda; duración según energía anterior al consumo. [Contrato detallado](../docs/HEALTH_ENERGY_CONTRACT.md).

## Pruebas a preparar y ejecutar en el entorno correspondiente

- Tests serialización roundtrip, save corrupto/faltante, version migration, créditos no negativos, compra duplicada, muerte/restart, 3 dificultades sin alterar valores persistentes, IDs de armas; regresión sigilo.
- Cada caso del paquete: ID, propósito, fixture/datos, precondiciones, comando exacto o pasos numerados, cwd, esperado, PASS/FAIL, timeout, dependencias, entorno y evidencia. No basta enumerar nombres de tests.
- Claude: revisión estática/documental ejecutada se registra como tal; tests Godot NOT_RUN. Codex: importación headless, suites pertinentes, logs/JUnit y regresiones existentes sobre el commit pedido según TEST_STRATEGY. No atribuir PASS por haber escrito un test.
- Manual: escena exacta, cómo abrir/ejecutar, controles, estado inicial, pasos, resultado/fallo observable, evidencia y repetición. Gameplay/arte/performance requieren motor/ventana y revisión humana, no solo headless.
- Reutilizar [casos SB](../docs/HEALTH_ENERGY_TEST_CASES.md) y [CT](../docs/CONTROLS.md) aplicables; otros casos siguen NOT_RUN hasta su hito. Parámetros provisionales configurables, sin convertir tests de hipótesis en aprobación de balance.

## Archivos probables y entrega

Código/escenas/Resources/tests del sistema de este hito según [ARCHITECTURE](../docs/ARCHITECTURE.md); documentar rutas reales antes de editar, no asumir módulos futuros existentes. Actualizar arquitectura implementada, decisiones afectadas, VALIDATION, HANDOFF y ROADMAP sin alterar evidencia histórica. Registrar assets modificados antes de integrar.

Paquete: `validation/B04/` con TEST_HANDOFF.md, TEST_MANIFEST.json conforme al esquema1.0.0, TEST_RESULTS.md y evidence/. [Plantillas](../docs/PROMPTS_INDEX.md). Incluir errores conocidos, regresiones, checklist humana y recuperación al commit aprobado. H02–H04 ya cerrados conservan evidencia histórica; no fabricar un paquete retroactivo ni ejecutar sus tareas por esta actualización.

## Aceptación

Cerrar/reabrir preserva progreso correcto y no persiste daño/alertas de intento.

Requisitos satisfechos, pruebas técnicas críticas PASS reales sobre mismo commit, sin regresiones críticas, paquete completo y validación manual expresa. Fallos → VALIDATION_FAILED; dependencia crítica ausente → BLOCKED; pendientes sin ejecutar → NOT_RUN, nunca PASS. Entrega final: qué cambió, archivos, comandos/exit/logs/resultados, bugs, decisiones, pasos manuales y siguiente paso. No autoaprobar ni autorizar otro lote.
