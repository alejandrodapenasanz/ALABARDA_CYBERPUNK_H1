Lee primero `AGENTS.md` íntegro desde la raíz y cumple su orden de lectura. Después lee `docs/DEVELOPMENT_WORKFLOW.md`, `docs/ROADMAP.md`, `docs/DECISIONS.md`, `docs/GAME_DESIGN.md`, `docs/HEALTH_ENERGY_CONTRACT.md`, `docs/CONTROLS.md`, `docs/BALANCE_PROVISIONAL.md`, `docs/ARCHITECTURE.md`, `docs/TEST_STRATEGY.md`, `docs/VALIDATION.md` y `docs/HANDOFF.md`. Para visuales, ART_BIBLE y ASSET_REGISTRY íntegros. Inspecciona project.godot, escenas/scripts/tests y git status antes de editar; declara ausencias/capacidades. Este archivo solo se ejecuta con encargo expreso dentro del lote autorizado.

# H03 — Infraestructura de pruebas y balance

**Revisión pipeline v2.1 · 2026-11-22 · B0 · APPROVED histórico.** Migración pendiente de validación; no autoriza iniciar/reabrir este hito. Dependencia: H02 / lote anterior aprobado antes de integración; solape solo según workflow y autorización.

## Objetivo funcional

Instalar y fijar versión de framework de test compatible; crear ejecutor Windows reproducible, tests base, verificación headless, fixtures y archivo de balance provisional; definir arquitectura incremental de eventos y datos.

### Investigación visual y escena de referencia

1. Detectar versión exacta de Godot, renderer y entorno Windows. La base observada en H02 es Godot 4.7.2.stable.official.ed1daf0bf / GL Compatibility; verificarla de nuevo. No asumir técnicas compatibles por asociarse al estilo PSX.
2. Investigar renderer, importación glTF/GLB, materiales, texturas y filtrado por material, iluminación, sombras, fog, resolución interna/escalado y shaders retro opcionales. Justificar utilidad visual, compatibilidad y coste de cada técnica; no cambiar renderer sin justificarlo ni añadir dependencias innecesarias.
3. Construir una **escena de referencia aislada y reproducible**, conservando la entrada jugable H1. Incluir muestras de superficies/materiales, siluetas, elemento en primera persona y HUD/textos de prueba para comparar. Usar placeholders propios si no hay assets autorizados; no producir los sistemas futuros para simularlos.
4. Comparar materiales y técnicas A/B con la misma cámara, luz y resolución. Valorar nearest frente a alternativas por material sin imponerlo globalmente; revisar fuentes/HUD por separado. Las resoluciones y paleta de ART_BIBLE son provisionales; proponer presupuestos por categoría tras medir, sin límite universal de polígonos.
5. Comprobar coherencia Modern PSX / Retro Industrial Cyberpunk, siluetas, apuntado, información de amenaza/interacción y lectura en movimiento/luz tenue. Efectos potencialmente perjudiciales deben ser configurables o desactivables; comparar activados/desactivados. La revisión estética requiere aprobación del creador.
6. Medir rendimiento en ventana real sobre Windows; registrar hardware/driver, versión, renderer, resolución, condiciones y tiempos de frame. Comparar la base y cada efecto sin inventar objetivos de FPS. Proponer degradación visual que preserve siluetas, señales y HUD. Headless solo prueba carga/integridad; si no puede medirse rendimiento gráfico, registrar BLOCKED/NOT_RUN y la causa.
7. Inventariar todos los assets utilizados, incluidos placeholders, procedencia, modificaciones y rutas; comprobar licencias antes de incorporar terceros. Separar verificación legal/técnica y aprobación visual en ASSET_REGISTRY.
8. Registrar decisiones técnicas provisionales y evidencia: escena/pasos reproducibles, configuración A/B, resultados y capturas cuando sea posible. Capturas no obtenidas: NOT_RUN con motivo. Actualizar ARCHITECTURE solo con lo realmente implementado; no elevar una técnica experimental a decisión de gameplay.

H04 ya desarrolló esta referencia. No reabrir H03: este objetivo conserva alcance histórico, sin producir niveles ni armas finales.



## Roles, checkpoint y alcance

Claude implementa solo los hitos del lote autorizado, con revisión y checkpoint por hito (interfaces, archivos, tests, dependencias, bugs y commit separado cuando sea posible). **PC Claude sin Godot ni Blender**: prepara tests/escenas/datos y ejecuta solo verificaciones disponibles sin motor; Godot queda NOT_RUN. No confundir CODE_READY con VALIDATED.

Codex comprueba el SHA exacto y valida importación, tests, regresiones y escenas; usa Blender solo si procede. Corrige fallos pequeños/locales; cambios estructurales vuelven a Claude con BUG_REPORT reproducible. Creador valida manualmente y concede APPROVED. Dentro del lote autorizado puede continuar tras checkpoint; no cerrar ni empezar otro lote por iniciativa propia.

Fuera de alcance: hitos ajenos al lote, reinterpretar propuestas como aprobadas, ampliar MVP, assets sin licencia, refactors irrelevantes, sistemas futuros para simular resultados. Conservar rutas/bindings hasta su migración autorizada. Modern PSX / Retro Industrial Cyberpunk D-017, perfil D-019, HomeVideo D-020 y referencia H04 D-021; muestras experimentales, Malorian solo local, fallback público. H04 es laboratorio sin colisiones/IA, no nivel jugable. [Continuidad](../docs/HANDOFF.md).

## Pruebas a preparar y ejecutar en el entorno correspondiente

- Test de ejemplo con fallo controlado detectado; import Godot; test runner exit code !=0 en fallo; lectura de balance; test de no negativos y clamps; regresión H1.
- Cada caso del paquete: ID, propósito, fixture/datos, precondiciones, comando exacto o pasos numerados, cwd, esperado, PASS/FAIL, timeout, dependencias, entorno y evidencia. No basta enumerar nombres de tests.
- Claude: revisión estática/documental ejecutada se registra como tal; tests Godot NOT_RUN. Codex: importación headless, suites pertinentes, logs/JUnit y regresiones existentes sobre el commit pedido según TEST_STRATEGY. No atribuir PASS por haber escrito un test.
- Manual: escena exacta, cómo abrir/ejecutar, controles, estado inicial, pasos, resultado/fallo observable, evidencia y repetición. Gameplay/arte/performance requieren motor/ventana y revisión humana, no solo headless.
- Reutilizar [casos SB](../docs/HEALTH_ENERGY_TEST_CASES.md) y [CT](../docs/CONTROLS.md) aplicables; otros casos siguen NOT_RUN hasta su hito. Parámetros provisionales configurables, sin convertir tests de hipótesis en aprobación de balance.

## Archivos probables y entrega

Código/escenas/Resources/tests del sistema de este hito según [ARCHITECTURE](../docs/ARCHITECTURE.md); documentar rutas reales antes de editar, no asumir módulos futuros existentes. Actualizar arquitectura implementada, decisiones afectadas, VALIDATION, HANDOFF y ROADMAP sin alterar evidencia histórica. Registrar assets modificados antes de integrar.

Paquete: `validation/B00/` con TEST_HANDOFF.md, TEST_MANIFEST.json conforme al esquema1.0.0, TEST_RESULTS.md y evidence/. [Plantillas](../docs/PROMPTS_INDEX.md). Incluir errores conocidos, regresiones, checklist humana y recuperación al commit aprobado. H02–H04 ya cerrados conservan evidencia histórica; no fabricar un paquete retroactivo ni ejecutar sus tareas por esta actualización.

## Aceptación

Comando local reproducible documentado, suite automatizada PASS, parámetros editables sin hardcodear, CI opcional sin credenciales.
- Referencia visual reproducible e inventariada; comparación de materiales/técnicas, compatibilidad, rendimiento y degradación documentada; capturas cuando sea posible, con sus limitaciones. Coherencia y legibilidad revisadas manualmente por el creador, sin afirmar aprobación artística a partir de un test headless.

Requisitos satisfechos, pruebas técnicas críticas PASS reales sobre mismo commit, sin regresiones críticas, paquete completo y validación manual expresa. Fallos → VALIDATION_FAILED; dependencia crítica ausente → BLOCKED; pendientes sin ejecutar → NOT_RUN, nunca PASS. Entrega final: qué cambió, archivos, comandos/exit/logs/resultados, bugs, decisiones, pasos manuales y siguiente paso. No autoaprobar ni autorizar otro lote.
