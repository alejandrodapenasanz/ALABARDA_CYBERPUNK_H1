# HANDOFF — migración pipeline v2.1

**2026-11-23: entrega documental para revisión; aprobación PENDING_APPROVAL. B1 NOT_STARTED.** H1–H04 conservan sus aprobaciones; no se programa gameplay ni se repiten H03/H04 durante esta tarea. [Informe completo](PIPELINE_MIGRATION_REPORT.md), [validación](VALIDATION.md), [documentos anteriores](history/pre_pipeline_v2_1/manifest.json).

## Qué está preparado

AGENTS para ambos roles; [workflow](DEVELOPMENT_WORKFLOW.md) con lotes/estados/Git/SHA;23 prompts individuales, [catálogo B0–B8](../prompts/BATCH_PROMPTS.md); plantillas Claude implementar/fix, Codex validar y handoff/manifest/resultados/bug. Schema versionado y verificador de paquetes; no ejecutor universal de comandos. [Índice](PROMPTS_INDEX.md).

Salud0–100/energía0–150, autoHP, E, pasiva/bajas/ultimates/ascensor sincronizados; [contrato](HEALTH_ENERGY_CONTRACT.md), [balance provisional](BALANCE_PROVISIONAL.md),29 casos SB y10 CT. F extracción SUPERSEDED. No se cambian scripts, escenas, Resources, assets, tests Godot ni fuentes Blender. Resource H03 aún legado: adaptación futura explícita en B1/B2; sus PASS no prueban el diseño nuevo.

## Estado ejecutable conservado

Godot4.7.2 estándar/Compatibility. Importar project.godot: **F5 greybox H1**; abrir `scenes/art_reference/modern_psx_lab.tscn` y **F6 laboratorio H04**. H1 usa WASD/ratón/clic, Shift, Espacio, Q dash, Esc cursor y R tras cinco blancos. E/energía/nuevo doble toque/slots aún no existen.

Laboratorio:1–4 cámaras, A brazos, F fuentes, L tres luces, X/B retro,0 restaura D-019:nearest+mips, atmósfera,1280×720,retroOFF,sombrasON,nieblaOFF. HomeVideo aceptada en contexto probado; kit H04/muestras experimentales, no finales. Malorian opcional local excluida del público, fallback propio; rig separado. Reutilizar kit/registry/biblia antes de producir visuales.

## Git y transferencia a otro PC

El creador ordena publicar toda la versión actual para continuar desde otro PC el2026-11-23. Se sustituye la entrega pública resumida por la copia de desarrollo completa, con restricciones de assets explícitas. [Guía de descarga y comprobación](GITHUB_TRANSFER.md). La publicación no cambia PENDING_APPROVAL ni inicia B1.

La carpeta original conserva h02-audit sin HEAD e índice histórico. La transferencia se prepara en una copia Git aislada sobre H04 `48f972c6ebeac2a4c7e6ab526e7dead43ad2baba`; desde un clon de main usar `git rev-parse HEAD` como BASE_SHA real. Baseline portable explícita en tools/pipeline/checkout_manifest.json, sin modificar evidencia histórica ni exigir archivos locales excluidos. [Inventario de migración anterior](evidence/pipeline_v2_1/changed_files.json) y [snapshot de entrada](evidence/pipeline_v2_1/before.json) conservan su alcance histórico. No tocar el índice original.

## Pendientes que no debe decidir una IA

- P-015: tecla de interacción distinta de E. E exclusiva ya decidida; acción y tests inyectados posibles, binding/prueba manual afectados pendientes.
- P-016/P-011: etiquetas melee/primaria/secundaria frente a tres armas cualesquiera; duplicados y slots vacíos. Sin restricción por categoría por defecto.
- P-017: adaptación de remates sin extracción F, disparador/tiempos/protección.
- Tasas/tiempos provisionales pendientes de playtest; resto de perks/economía/compatibilidad/IA/niveles/retorno entre plantas y cierre MVP sigue DECISIONS. HP ascensor ya resuelto: intacto.

No hace falta resolver pendientes de B2–B8 para revisar la documentación. El binding P-015 sí debe concretarse antes de completar la interacción jugable B1.

## Preparación e instrucciones exactas para Claude B1

**Usar solo después de validar la migración, crear/sincronizar el commit base real y autorizar B1.** Sustituir BASE_SHA por el SHA real de esa copia y completar la decisión P-015 si se resuelve; el SHA H04 público no incluye esta migración.

```text
Lee íntegramente AGENTS.md desde la raíz y cumple su orden de lectura.
La migración pipeline v2.1 ha sido validada por mí; autorizo exclusivamente B1 (H05 y H06).
Base de desarrollo: BASE_SHA (SHA completo real con esta documentación). Inspecciona git status y confirma la base antes de editar.
Lee docs/DEVELOPMENT_WORKFLOW.md, ROADMAP, DECISIONS, GAME_VISION, MVP_SCOPE, ARCHITECTURE, GAME_DESIGN, HEALTH_ENERGY_CONTRACT, CONTROLS, BALANCE_PROVISIONAL, ART_BIBLE, ASSET_REGISTRY, TEST_STRATEGY, VALIDATION y HANDOFF.
Aplica prompts/_templates/CLAUDE_IMPLEMENT_BATCH.md y el bloque B1 de prompts/BATCH_PROMPTS.md.
Lee completos prompts/H05_NUCLEO_DE_JUGADOR_INTERACCION_Y_MOVIMIENTO.md y prompts/H06_DANO_SALUD_HITZONES_Y_ESTADOS_DE_ATAQUE.md.
No tienes Godot ni Blender. Prepara código, fixtures y tests; registra solo verificaciones realmente ejecutadas sin motor. Godot/visuales/manuales quedan NOT_RUN.
H05: movimiento, interacción separada de E y dash WW/AA/SS/DD. Si P-015 sigue sin resolver, no inventes binding; avanza API/tests independientes y registra el bloqueo concreto.
H06: salud/daño y regeneración automática tras5 s sin daño a5 HP/s, valores provisionales; contrato de pausa para E futura mediante dobles. No programes energía/E de H08, seis armas H07 ni ultimates H09.
Reutiliza la referencia y assets experimentales compatibles H04, conservando licencias y límites. Mantén checkpoints H05/H06 y commits separados cuando sea posible.
Entrega validation/B01/ con TEST_HANDOFF.md, TEST_MANIFEST.json, TEST_RESULTS.md y evidence/, candidatos y paquete C/P según workflow. Tests específicos SB/CT aplicables, regresión y pasos manuales exactos.
Actualiza documentación de implementación y handoff. No autoapruebes, no fusiones código sin validar a estable ni comiences B2. Codex validará el SHA exacto y yo aprobaré el resultado manual.
```

El texto «ha sido validada» es condicional para un futuro encargo, **no registra aprobación actual**. Hasta entonces B1 permanece sin iniciar.
