Lee primero `AGENTS.md` íntegro desde la raíz y cumple su orden de lectura. Después lee `docs/DEVELOPMENT_WORKFLOW.md`, `docs/ROADMAP.md`, `docs/DECISIONS.md`, `docs/GAME_DESIGN.md`, `docs/HEALTH_ENERGY_CONTRACT.md`, `docs/CONTROLS.md`, `docs/BALANCE_PROVISIONAL.md`, `docs/ARCHITECTURE.md`, `docs/TEST_STRATEGY.md`, `docs/VALIDATION.md` y `docs/HANDOFF.md`. Para visuales, ART_BIBLE y ASSET_REGISTRY íntegros. Inspecciona project.godot, escenas/scripts/tests y git status antes de editar; declara ausencias/capacidades. Este archivo solo se ejecuta con encargo expreso dentro del lote autorizado.

# H19 — Contrato Yakuza: tres plantas + ascensores

**Revisión pipeline v2.1 · 2026-11-22 · B6 · NOT_STARTED.** Migración aprobada 2026-11-23 (D-028); no autoriza iniciar/reabrir este hito sin encargo expreso. Dependencia: H18 / lote anterior aprobado antes de integración; solape solo según workflow y autorización.

## Objetivo funcional

Greybox modular del contrato de tres plantas, rutas de sigilo/combate; primera infiltración, segunda combate, tercera antesala boss. Ascensores fijan energía150 sin cambiar HP, excepción a sobrecarga por bajas. Transiciones dentro del intento, dificultad y objetivo15–25 min de diseño; no boss completo todavía. Retorno entre plantas P-013 pendiente; rutas/densidad requieren decisión P-003.



## Continuidad futura: muerte del protagonista (D-029)

El creador pidió el 2026-11-27 que al morir se pase de primera a tercera persona, alejando y elevando un poco la cámara para mostrar el cuerpo tumbado. Incorporar esta dependencia al plan cuando se encargue el desarrollo correspondiente: cuerpo completo, transición, obstáculos y revisión visual. Distancia, duración y técnica de animación/ragdoll siguen sin decidir; no implementar por la mera lectura de este prompt ni como corrección B1. [Decisión y fuente](../docs/DECISIONS.md).

## Roles, checkpoint y alcance

Claude implementa solo los hitos del lote autorizado, con revisión y checkpoint por hito (interfaces, archivos, tests, dependencias, bugs y commit separado cuando sea posible). **PC Claude sin Godot ni Blender**: prepara tests/escenas/datos y ejecuta solo verificaciones disponibles sin motor; Godot queda NOT_RUN. No confundir CODE_READY con VALIDATED.

Codex comprueba el SHA exacto y valida importación, tests, regresiones y escenas; usa Blender solo si procede. Corrige fallos pequeños/locales; cambios estructurales vuelven a Claude con BUG_REPORT reproducible. Creador valida manualmente y concede APPROVED. Dentro del lote autorizado puede continuar tras checkpoint; no cerrar ni empezar otro lote por iniciativa propia.

Fuera de alcance: hitos ajenos al lote, reinterpretar propuestas como aprobadas, ampliar MVP, assets sin licencia, refactors irrelevantes, sistemas futuros para simular resultados. Conservar rutas/bindings hasta su migración autorizada. Modern PSX / Retro Industrial Cyberpunk D-017, perfil D-019, HomeVideo D-020 y referencia H04 D-021; muestras experimentales, Malorian solo local, fallback público. H04 es laboratorio sin colisiones/IA, no nivel jugable. [Continuidad](../docs/HANDOFF.md).

## Contrato transversal (no adelanta otros hitos)

Salud 0–100 y energía 0–150 independientes. Salud automática tras **5 s sin daño** a **5 HP/s**, sin energía; daño reinicia espera, muerto no regenera. E mantenida: **25 HP/s por 25 energía/s**, solo coste de HP recuperado, sin gasto a salud llena, termina al soltar/agotar energía/morir; daño no cancela si sobrevive. Manual activa pausa automática (provisional). **Sin energía pasiva** (D-027): la energía solo sube por bajas confirmadas del jugador, **+15 hasta 150**, y por ascensor; sin curación directa de HP. **Tasas, tiempos y pausa: PROVISIONAL_VALUE / PENDING_PLAYTEST.** F extracción SUPERSEDED. Ascensor: energía 150, HP intacto. Ultimate >=100 energía, consume toda; duración según energía anterior al consumo. [Contrato detallado](../docs/HEALTH_ENERGY_CONTRACT.md).

## Pruebas a preparar y ejecutar en el entorno correspondiente

- SB-27 en ascensor real: energía inicial0/99/110/150→150 y HP30/100 intactos; transiciones1→2→3, retorno solo según decisión P-013, reinicio planta1, navegación/conteo/3dificultades, un run manual y regresión H18.
- Cada caso del paquete: ID, propósito, fixture/datos, precondiciones, comando exacto o pasos numerados, cwd, esperado, PASS/FAIL, timeout, dependencias, entorno y evidencia. No basta enumerar nombres de tests.
- Claude: revisión estática/documental ejecutada se registra como tal; tests Godot NOT_RUN. Codex: importación headless, suites pertinentes, logs/JUnit y regresiones existentes sobre el commit pedido según TEST_STRATEGY. No atribuir PASS por haber escrito un test.
- Manual: escena exacta, cómo abrir/ejecutar, controles, estado inicial, pasos, resultado/fallo observable, evidencia y repetición. Gameplay/arte/performance requieren motor/ventana y revisión humana, no solo headless.
- Reutilizar [casos SB](../docs/HEALTH_ENERGY_TEST_CASES.md) y [CT](../docs/CONTROLS.md) aplicables; otros casos siguen NOT_RUN hasta su hito. Parámetros provisionales configurables, sin convertir tests de hipótesis en aprobación de balance.

## Archivos probables y entrega

Código/escenas/Resources/tests del sistema de este hito según [ARCHITECTURE](../docs/ARCHITECTURE.md); documentar rutas reales antes de editar, no asumir módulos futuros existentes. Actualizar arquitectura implementada, decisiones afectadas, VALIDATION, HANDOFF y ROADMAP sin alterar evidencia histórica. Registrar assets modificados antes de integrar.

Paquete: `validation/B06/` con TEST_HANDOFF.md, TEST_MANIFEST.json conforme al esquema1.0.0, TEST_RESULTS.md y evidence/. [Plantillas](../docs/PROMPTS_INDEX.md). Incluir errores conocidos, regresiones, checklist humana y recuperación al commit aprobado. H02–H04 ya cerrados conservan evidencia histórica; no fabricar un paquete retroactivo ni ejecutar sus tareas por esta actualización.

## Aceptación

Contrato navegable en tres plantas con ascensores y sin softlocks.

Requisitos satisfechos, pruebas técnicas críticas PASS reales sobre mismo commit, sin regresiones críticas, paquete completo y validación manual expresa. Fallos → VALIDATION_FAILED; dependencia crítica ausente → BLOCKED; pendientes sin ejecutar → NOT_RUN, nunca PASS. Entrega final: qué cambió, archivos, comandos/exit/logs/resultados, bugs, decisiones, pasos manuales y siguiente paso. No autoaprobar ni autorizar otro lote.
