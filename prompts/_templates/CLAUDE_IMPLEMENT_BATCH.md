Lee primero `AGENTS.md` íntegro y cumple su orden de lectura. Después lee `docs/DEVELOPMENT_WORKFLOW.md`, ROADMAP, DECISIONS, GAME_DESIGN, HEALTH_ENERGY_CONTRACT, CONTROLS, BALANCE_PROVISIONAL, ARCHITECTURE, TEST_STRATEGY, VALIDATION y HANDOFF, los prompts individuales del lote y ART_BIBLE/ASSET_REGISTRY si hay cambios visuales.

# Claude — implementar un lote autorizado

Completar antes de usar: lote B__, hitos H__–H__, autorización del creador, rama y commit base aprobado, alcance y decisiones pendientes. Este archivo no autoriza B1 por sí mismo.

1. Inspecciona repo real, git status y dependencias. Informa alcance, criterios, componentes, ausencias y bloqueos antes de editar. Tu PC **no tiene Godot ni Blender**. No intentes certificar importación, gameplay, visuales o rendimiento.
2. Implementa exclusivamente los hitos autorizados, en su orden. Checkpoint por hito: funcionalidad, archivos nuevos/modificados/eliminados, contratos/interfaces, datos, tests, dependencias, bugs, estado y commit separado cuando sea posible. Puede continuar dentro del lote autorizado; no inventes aprobación intermedia.
3. Conserva funciones/rutas/bindings hasta su migración autorizada. Reutiliza recursos aprobados experimentales, registra licencias; no asumas modelo final. No implementes pendientes creativos por intuición. Datos provisionales configurables, no balance aprobado.
4. Prepara unitarias, integración, regresiones, escenas/fixtures y pruebas manuales. Cada caso tendrá ID, propósito, entradas/precondiciones, comando/cwd/timeout o pasos, esperado, PASS/FAIL, dependencias y log. Convierte los casos SB/CT aplicables en pruebas concretas; no basta copiar sus títulos. No implementes sistemas de lotes futuros para cumplir un fixture.
5. Ejecuta únicamente verificaciones disponibles sin motor; registra comando/exit/log y límites. Tests Godot/Blender/gráficos/manuales quedan NOT_RUN con motivo. CODE_READY no equivale a VALIDATED.
6. Prepara `validation/BXX/TEST_HANDOFF.md`, TEST_MANIFEST.json, TEST_RESULTS.md, evidence/ y bugs/ si procede. Usa las [plantillas](../../docs/PROMPTS_INDEX.md). Candidato C contiene código y tests; paquete posterior P apunta al SHA C. No inventes ni uses el SHA del paquete como código probado. Valida esquema y completitud antes de INTEGRATION_READY.
7. Actualiza ARCHITECTURE con implementación real separada de planes; ROADMAP/VALIDATION/HANDOFF y decisiones/documentos afectados. Entrega archivos, SHAs C/P, resultados reales, tests NOT_RUN, bugs, pendientes y pasos exactos para Codex/creador.

No autoaprobar, fusionar código sin validar a estable ni comenzar otro lote. Cambios de alcance requieren decisión del creador. Referencia operativa: [workflow](../../docs/DEVELOPMENT_WORKFLOW.md).
