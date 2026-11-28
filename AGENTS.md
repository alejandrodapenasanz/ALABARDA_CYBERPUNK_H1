# ALABARDA STUDIOS — Instrucciones permanentes para Claude y Codex

**Versión 0.8 · pipeline v2.1 · 2026-11-28.** Migración aprobada por el creador (D-027/D-028). La aprobación de la migración no inicia lotes: cada lote requiere encargo expreso y se desarrolla en su rama (`B1`, `B2`…) desde `main`. H1–H04 conservan sus aprobaciones históricas.

**Estado vigente:** B1 (H05/H06) APPROVED por el creador, integrado en el flujo normal (`scenes/main.tscn`, F5). Jugador compartido `PlayerController`; suites `tests/gameplay`, runner `tools/gameplay/run_tests.py`. B2 se encarga mediante `next_prompt.md`, sin ejecutarlo por su mera existencia. D-031 autoriza merge a main y retirada de B1; la rama estable se llama **main**. El código futuro amplía el juego actual, no un runtime paralelo por lote. D-032 retira los archivos de entrega B1 del árbol actual: su aprobación y evidencia se conservan en Git, commit `1e30b5c1aa1ed8f949059ead5517e6c095c3d436`; no recrear esa carpeta ni el manual de raíz. Las regresiones útiles viven en `tests/gameplay`.

## 0. Lectura obligatoria por conversación o lote

1. Este `AGENTS.md` íntegro, siempre en la raíz Godot.
2. [GAME_VISION](docs/GAME_VISION.md) y [MVP_SCOPE](docs/MVP_SCOPE.md).
3. [DECISIONS](docs/DECISIONS.md), [ROADMAP](docs/ROADMAP.md) y [DEVELOPMENT_WORKFLOW](docs/DEVELOPMENT_WORKFLOW.md).
4. [ARCHITECTURE](docs/ARCHITECTURE.md), [GAME_DESIGN](docs/GAME_DESIGN.md), [HEALTH_ENERGY_CONTRACT](docs/HEALTH_ENERGY_CONTRACT.md), [CONTROLS](docs/CONTROLS.md) y [BALANCE_PROVISIONAL](docs/BALANCE_PROVISIONAL.md).
5. [ART_BIBLE](docs/ART_BIBLE.md) y [ASSET_REGISTRY](docs/ASSET_REGISTRY.md) íntegros antes de afectar escenarios, personajes, armas, interfaces, animaciones, modelos o audio.
6. [TEST_STRATEGY](docs/TEST_STRATEGY.md), [VALIDATION](docs/VALIDATION.md), [HANDOFF](docs/HANDOFF.md), implementación/tests reales y `git status`.
7. Prompt del lote, todos sus hitos y paquete de transferencia si existe. [Índice](docs/PROMPTS_INDEX.md).

Señalar documentos ausentes sin fingir lectura. H02 autorizó la consolidación: no recrear alias españoles ni copias `(1)`. [Histórico H02](docs/history/pre_h02/manifest.json) y [originales anteriores a v2.1](docs/history/pre_pipeline_v2_1/manifest.json) trazados por hash. El GDD H1 y los históricos no son especificación vigente.

## 1. Autoridad y alcance

Prevalecen las decisiones expresas más recientes del creador y DECISIONS; después visión/alcance/diseño/biblia aprobados; después PDF original y GDD histórico; finalmente propuestas y prototipos. Una propuesta numérica no es una aprobación de balance. Ante contradicción material, parar solo la funcionalidad afectada, registrarla y pedir decisión. No ampliar el MVP ni ejecutar lotes por la mera existencia de un prompt.

## 2. Roles y estados

Claude programa los lotes autorizados, prepara escenas de texto, Resources, tests y documentación. En B1 su PC **no tenía Godot ni Blender**. En cada nuevo entorno comprueba disponibilidad real: si dispone de motor puede abrir el proyecto completo y ejecutar pruebas; si falta, registra NOT_RUN y no certifica importación, gameplay, gráficos, animaciones o rendimiento. Ejecuta comprobaciones documentales/lógica externa disponibles, incluido `tools/pipeline/check_godot_static.py` antes de cada checkpoint, y registra resultados reales.

Codex integra y valida en el PC con Godot/Blender sobre el commit exacto del paquete. Conserva evidencia y hace solo correcciones pequeñas/locales. Devuelve cambios estructurales o grandes a Claude con bugs reproducibles. Blender solo cuando el lote lo exige. El creador valida sensaciones, arte, animación, gunplay, dificultad, legibilidad y UX y concede la aprobación final.

Estados de trabajo: `NOT_STARTED`, `IN_PROGRESS`, `CODE_READY`, `INTEGRATION_READY`, `VALIDATION_FAILED`, `VALIDATED`, `APPROVED`, `BLOCKED`. Pruebas: `PASS`, `FAIL`, `NOT_RUN`, `BLOCKED`. CODE_READY no significa VALIDATED; únicamente el creador permite APPROVED. Transiciones en DEVELOPMENT_WORKFLOW.

## 3. Decisiones vigentes resumidas

- Godot 4, PC/Windows, FPS, brazo izquierdo cyborg; Modern PSX / Retro Industrial Cyberpunk, sin emulación literal PS1; legibilidad moderna y efectos retro configurables/desactivables.
- Guarida interactiva y contrato Yakuza repetible: tres plantas, tres dificultades, boss dos fases; 15–25 minutos es objetivo de diseño.
- Tres armas cualesquiera de seis; iniciales katana, pistola silenciada y escopeta doble. Reserva infinita, cargadores, recarga/recuperación por animación. Firmware al instalar USB y hasta respec; mejoras físicas separadas.
- Salud 0–100 y energía 0–150 independientes, HUD rojo/azul. Salud automática tras 5 s sin daño a 5 HP/s; E mantenida cura a 25 HP/s gastando 25 energía/s; sin energía pasiva: solo cada baja confirmada del jugador aporta +15 hasta 150, y el ascensor la fija a 150 (D-027). **Tasas y tiempos PROVISIONAL_VALUE / PENDING_PLAYTEST**, no balance final. Matar no cura HP. Extracción mantenida con F **SUPERSEDED**. Contrato y límites en HEALTH_ENERGY_CONTRACT.
- E exclusiva para curar incluso junto a objetos; interacción con **F** (D-027). WASD; dash WW/AA/SS/DD; 1/2/3 seleccionan slots y repetir el equipado lo guarda. 1/2/3 son slots libres sin categoría: cualquier combinación de tres armas, incluidas tres cuerpo a cuerpo (D-027).
- Una ultimate equipada; >=100 energía, consume toda y solo escala duración. Dead Eye global con cualquier arma; Aimbot asiste a cabezas visibles sin disparo automático; Overdrive para armas de fuego. Ascensores recargan energía a 150 **sin modificar HP**, excepción a sobrecarga por bajas.
- Sigilo reversible con memoria, patrullas, alarmas, cámaras y cadáveres; alarma general impide volver al sigilo durante ese intento.
- PC → timbre → paquete transportado → montaje 3–4 pasos o USB → equipar; créditos, autosave y progreso persistente. Boss entrega trofeo y flag de shurikens futuro.

## 4. Procedimiento por lote

Antes de editar: leer §0, examinar repo/índice, diagnosticar alcance, criterios, dependencias y dudas reales. Claude declara herramientas ausentes; Codex verifica versiones y comandos. Preservar cambios ajenos y funcionalidades/rutas anteriores; no resetear el índice histórico.

Durante: solo lote autorizado, incrementos con checkpoint por hito (archivos, interfaces, tests preparados/ejecutados, dependencias, bugs y commit separado cuando sea posible). Puede continuar los hitos autorizados del mismo lote sin fingir aprobación intermedia. Preferir Resources de configuración y señales desacopladas cuando aporten claridad; conservar estilo, sin dependencias innecesarias ni refactors ajenos. No marcar cerrado por haber escrito código.

Después: entregar `validation/BXX/TEST_HANDOFF.md`, `TEST_MANIFEST.json`, `TEST_RESULTS.md` y `evidence/` según plantillas. Manifest versionado, SHA exacto y tests reproducibles. Mantener VALIDATION/HANDOFF/ROADMAP y documentos afectados; informar archivos, comandos, resultados, bugs y pendientes humanos. INTEGRATION_READY exige paquete completo.

No comenzar otro lote sin encargo explícito. Solapar lotes autorizados solo con ramas aisladas, interfaces estables y sin bloqueos críticos/decisiones creativas pendientes, según workflow. No fusionar a estable código sin validar. No cerrar lote/hito sin pruebas críticas satisfechas y aprobación manual expresa.

## 5. Pruebas y honestidad

Preparar integridad/importación, unitarias, integración, regresión, manuales y export Windows cuando corresponda. Registrar comando, cwd, commit, versiones, exit, contadores, logs y límites. Tests críticos no ejecutables impiden VALIDATED; distinguir BLOCKED de NOT_RUN. Headless no aprueba estética/jugabilidad. Conservar H1–H04 sin atribuir cobertura de nuevas mecánicas.

GdUnit4 6.2.3 vendorizado; comandos/Godot probado en ARCHITECTURE/TEST_STRATEGY. No asumir herramientas iguales en ambos PC. Cada corrección exige nuevo commit y repetir test del bug y regresiones afectadas; conservar fallos previos. No cambiar tests para esconder fallos.

## 6. Assets y continuidad artística

Inspeccionar y reutilizar recursos compatibles antes de crear/descargar. Producción híbrida: assets gratuitos legales adaptados, props Blender propios, materiales/shaders y protagonistas personalizados; IA conceptual. Registrar antes de incorporar nombre/versión, autor, URL oficial, licencia exacta/fecha, permisos de modificación/distribución/uso comercial, atribución, exclusiones, rutas y cambios. Autoría/licencia ambigua bloquea ese recurso; una referencia no autoriza copiar videojuegos. Mantener THIRD_PARTY_NOTICES. No mezclar estilos sin revisión.

Muestras suministradas experimentales, no finales. Malorian opcional local, fuera del público; conservar fallback y exclusiones del registry. Respetar D-019/D-020/D-021 y límites de aprobación visual. Mantener coherencia de materiales, texturas, modelos, iluminación y animaciones. Actualizar registry/handoff y prompts futuros afectados sin ejecutar esos hitos.

## 7. Pendientes y continuidad

Consultar P-001…P-017: balance, perks/economía, niveles/IA/boss, compatibilidades, controles sin decidir, duplicados/slots vacíos, retorno entre plantas, remates independientes y alcance final. No borrar remates al retirar extracción; su adaptación requiere revisión. Decisiones con fecha, fuente y estado `APROBADA`, `PENDIENTE`, `DESCARTADA` o `SUPERSEDED`; conservar sustituciones históricas.

Cada prompt empieza leyendo este archivo, distingue rol, lote/hitos, objetivo, requisitos, fuera de alcance, archivos, pruebas y aceptación. Plantillas operativas obligatorias. Al terminar un chat, HANDOFF debe permitir continuar sin memoria del chat. La confirmación de H1 y cierres H02–H04 conservan su alcance exacto, sin inventar ejecuciones.
