# HANDOFF — B1: colisión del arma corregida, retest visual pendiente

**2026-11-27 · B1 · INTEGRATION_READY. No VALIDATED ni APPROVED.** El creador pidió expresamente a Codex corregir el arma después de la devolución inicial a Claude y aportó una captura del fallo. Esta instrucción autoriza el fix de BUG-B1-02 en B1; no otro lote.

## Fix disponible en el directorio de trabajo

Candidato probado **`1401e05269fc4919f3658788e7de48bc5a4aa148`**. `scripts/player/weapon_wall_guard.gd` añade al cuerpo del jugador una forma convexa que cubre el arma en todas sus poses de retroceso/recuperación/recarga. El movimiento colisiona mediante `move_and_slide`; el giro comprueba el volumen barrido antes de aplicarse. Al contacto se limita el movimiento/giro que penetraría, permitiendo apartarse y deslizarse.

**Posición, escala, modelo, materiales, encuadre relativo y animaciones originales conservados (D-030).** No cambios de escenas ni de `fixture_weapon.gd`. El jugador puede notar el límite de giro junto al muro: es la respuesta física que permite conservar el arma en su posición. La sensación sigue pendiente de revisión humana. D-029 (cámara de muerte futura) permanece anotada, sin implementar.

## Pruebas y commits

- Regresión nueva `f9f215b59b99e1d7b967db274db977de5f7727b4`: siete casos de paredes/giros/animaciones/encuadre/pasillo. Antes del fix, cinco fallan y dos pasan al ejecutarlos con `-c`; evidencia del intento 04 conservada. El runner normal se detuvo en el primer caso fallido: 29 de 35 ejecutados, un caso con dos aserciones fallidas, seis sin ejecutar.
- Fix `1401e05269fc4919f3658788e7de48bc5a4aa148`: solo jugador B1, nuevo guard de colisión y hashes explícitos del manifest portable. Los tests entre rojo y verde son idénticos.
- **Intento 05: STATIC PASS (44 scripts/12 recursos), IMPORT PASS, UNIT 37/37, INTEGRATION 35/35, SMOKE 600 frames PASS, REGRESSION PASS.** H03 8+8, H04 4, control negativo esperado exit 100; H1 34 PASS / 0 FAIL / 1 NOT_RUN headless. Todos los seis checks finales exit 0.
- Entorno real: Windows 11 Home 10.0.26300, Godot 4.7.2.stable.official.ed1daf0bf, GdUnit4 6.2.3, Python 3.13.15. Candidatos limpios antes de importar; sidecars/cachés generados después conservados. Sin manuales, Blender ni export por Codex.
- [Resultados/comandos](../validation/B01/TEST_RESULTS.md), [manifest vigente](../validation/B01/TEST_MANIFEST.json), [evidencia 05](../validation/B01/evidence/attempt_05/summary.json), [BUG-B1-02](../validation/B01/bugs/BUG-B1-02.md): fix técnico PASS, retest creador pendiente.

Historial: candidato original `bfe7071` con error de descubrimiento; fix de tipado `94e4880`, intento 02 PASS (37+28), paquete `79d63e3`. [Revisión manual anterior](../validation/B01/evidence/manual_review_20261127/CREATOR_RESULTS.md): siete OK y paredes KO; SHA de sesión no escrito por el creador. El diagnóstico geométrico `49ecd30` fue retirado por `71ce9a2`; registros preservados en `diagnostic_03`. No se presenta esa prueba descartada como solución.

## Siguiente paso: creador

Detener la ejecución anterior y volver a abrir `scenes/b1/b1_sandbox.tscn` con F6 para cargar el fix. Repetir M-02: aproximación frontal/lateral, dash, giro y disparo/recarga junto a muros y esquinas; revisar también M-03/M-06 (movimiento/cámara/disparo). Confirmar que el arma mantiene su aspecto y no penetra. Indicar SHA de la sesión. El PASS técnico no reemplaza esa revisión ni concede aprobación final.

F5 sigue lanzando H1 con Q; B1 F6 usa doble toque. No merge a main ni inicio de B2. Para repetir automáticas: worktree nuevo de C, manifest --ready, runner y estático, evidencia nueva fuera del candidato. Conservar todos los intentos; no usar los árboles importados como limpios.

## Contexto histórico de la migración y preparación previa

Los apartados siguientes conservan el contexto anterior a B1 y sus instrucciones condicionales. El estado actual y el siguiente paso son los descritos arriba.

## Qué está preparado

AGENTS para ambos roles; [workflow](DEVELOPMENT_WORKFLOW.md) con lotes/estados/Git/SHA;23 prompts individuales, [catálogo B0–B8](../prompts/BATCH_PROMPTS.md); plantillas Claude implementar/fix, Codex validar y handoff/manifest/resultados/bug. Schema versionado y verificador de paquetes; no ejecutor universal de comandos. [Índice](PROMPTS_INDEX.md).

Salud0–100/energía0–150, autoHP, E, bajas/ultimates/ascensor sincronizados (sin pasiva energética, D-027); [contrato](HEALTH_ENERGY_CONTRACT.md), [balance provisional](BALANCE_PROVISIONAL.md),29 casos SB y10 CT. F extracción SUPERSEDED. No se cambian scripts, escenas, Resources, assets, tests Godot ni fuentes Blender. Resource H03 aún legado: adaptación futura explícita en B1/B2; sus PASS no prueban el diseño nuevo.

## Estado ejecutable conservado

Godot4.7.2 estándar/Compatibility. Importar project.godot: **F5 greybox H1**; abrir `scenes/art_reference/modern_psx_lab.tscn` y **F6 laboratorio H04**. H1 usa WASD/ratón/clic, Shift, Espacio, Q dash, Esc cursor y R tras cinco blancos. E/energía/nuevo doble toque/slots aún no existen.

Laboratorio:1–4 cámaras, A brazos, F fuentes, L tres luces, X/B retro,0 restaura D-019:nearest+mips, atmósfera,1280×720,retroOFF,sombrasON,nieblaOFF. HomeVideo aceptada en contexto probado; kit H04/muestras experimentales, no finales. Malorian opcional local excluida del público, fallback propio; rig separado. Reutilizar kit/registry/biblia antes de producir visuales.

## Git y transferencia a otro PC

El creador ordena publicar toda la versión actual para continuar desde otro PC el2026-11-23. Se sustituye la entrega pública resumida por la copia de desarrollo completa, con restricciones de assets explícitas. [Guía de descarga y comprobación](GITHUB_TRANSFER.md). La publicación no cambia PENDING_APPROVAL ni inicia B1.

La carpeta original conserva h02-audit sin HEAD e índice histórico. La transferencia se prepara en una copia Git aislada sobre H04 `48f972c6ebeac2a4c7e6ab526e7dead43ad2baba`; desde un clon de main usar `git rev-parse HEAD` como BASE_SHA real. Baseline portable explícita en tools/pipeline/checkout_manifest.json, sin modificar evidencia histórica ni exigir archivos locales excluidos. [Inventario de migración anterior](evidence/pipeline_v2_1/changed_files.json) y [snapshot de entrada](evidence/pipeline_v2_1/before.json) conservan su alcance histórico. No tocar el índice original.

## Pendientes que no debe decidir una IA

- P-015 RESUELTA (D-027): interacción con F; E solo curación.
- P-016 RESUELTA (D-027): slots libres sin categoría. P-011 (duplicados y slots vacíos) sigue pendiente para B2.
- P-017: adaptación de remates sin extracción F, disparador/tiempos/protección.
- Tasas/tiempos provisionales pendientes de playtest; resto de perks/economía/compatibilidad/IA/niveles/retorno entre plantas y cierre MVP sigue DECISIONS. HP ascensor ya resuelto: intacto.

No hace falta resolver pendientes de B2–B8 para revisar la documentación. P-015 ya está resuelta (F), así que la interacción jugable de B1 no queda bloqueada.

## Preparación e instrucciones exactas para Claude B1

**Usar con encargo expreso de B1, en la rama `B1` creada desde el commit base de `main`.** Sustituir BASE_SHA por el SHA real de esa copia (P-015 ya resuelta: interacción F); el SHA H04 público no incluye esta migración.

```text
Lee íntegramente AGENTS.md desde la raíz y cumple su orden de lectura.
La migración pipeline v2.1 ha sido validada por mí; autorizo exclusivamente B1 (H05 y H06).
Base de desarrollo: BASE_SHA (SHA completo real con esta documentación). Inspecciona git status y confirma la base antes de editar.
Lee docs/DEVELOPMENT_WORKFLOW.md, ROADMAP, DECISIONS, GAME_VISION, MVP_SCOPE, ARCHITECTURE, GAME_DESIGN, HEALTH_ENERGY_CONTRACT, CONTROLS, BALANCE_PROVISIONAL, ART_BIBLE, ASSET_REGISTRY, TEST_STRATEGY, VALIDATION y HANDOFF.
Aplica prompts/_templates/CLAUDE_IMPLEMENT_BATCH.md y el bloque B1 de prompts/BATCH_PROMPTS.md.
Lee completos prompts/H05_NUCLEO_DE_JUGADOR_INTERACCION_Y_MOVIMIENTO.md y prompts/H06_DANO_SALUD_HITZONES_Y_ESTADOS_DE_ATAQUE.md.
No tienes Godot ni Blender. Prepara código, fixtures y tests; registra solo verificaciones realmente ejecutadas sin motor. Godot/visuales/manuales quedan NOT_RUN.
H05: movimiento, interacción en F separada de E (D-027) y dash WW/AA/SS/DD.
H06: salud/daño y regeneración automática tras5 s sin daño a5 HP/s, valores provisionales; contrato de pausa para E futura mediante dobles. No programes energía/E de H08, seis armas H07 ni ultimates H09.
Reutiliza la referencia y assets experimentales compatibles H04, conservando licencias y límites. Mantén checkpoints H05/H06 y commits separados cuando sea posible.
Entrega validation/B01/ con TEST_HANDOFF.md, TEST_MANIFEST.json, TEST_RESULTS.md y evidence/, candidatos y paquete C/P según workflow. Tests específicos SB/CT aplicables, regresión y pasos manuales exactos.
Actualiza documentación de implementación y handoff. No autoapruebes, no fusiones código sin validar a estable ni comiences B2. Codex validará el SHA exacto y yo aprobaré el resultado manual.
```

El texto «ha sido validada» es condicional para un futuro encargo, **no registra aprobación actual**. Hasta entonces B1 permanece sin iniciar.
