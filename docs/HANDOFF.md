# HANDOFF — B1: pared del arma pendiente de corregir

**2026-11-27 · rama B1 · VALIDATION_FAILED por M-02-WALL. No VALIDATED ni APPROVED.** El creador comunicó siete manuales OK y paredes KO: el cuerpo se detiene, pero el arma atraviesa el muro. [Resultados originales y aclaraciones](../validation/B01/evidence/manual_review_20261127/CREATOR_RESULTS.md). Las pruebas manuales las realizó el creador, no Codex.

## Continuar con Claude: BUG-B1-02

Preparar el fix de [BUG-B1-02](../validation/B01/bugs/BUG-B1-02.md) en B1 conforme a **D-030**: conservar posición, escala, encuadre y apariencia del arma, impidiendo que atraviese la pared al tocarla. Hay que coordinar contacto físico con movimiento y giro; no basta reducir/acercar el arma ni cambiar el render para ocultar la penetración. Supera una corrección local y vuelve a Claude según AGENTS. No se ha implementado ninguna modificación del arma.

El diagnóstico geométrico `49ecd30a5b78ef18a85390e8929baf132d6b78ff` añadió un test que falló (mesh fuera de la cápsula). La aclaración del creador descartó usar contención en el cuerpo como criterio: se retiró con `71ce9a24f574b888fe2f9b8ca1c641470703b96a`, conservando [logs/JUnit](../validation/B01/evidence/diagnostic_03/README.md). Runtime, escenas, tests y baseline portable quedaron exactamente como `79d63e3`; esta retirada no corrige el bug manual. Automáticas vigentes: 37 unitarias y 28 de integración, no 29.

## Resultados y trazabilidad

- C inicial `bfe7071b63e756200f4e1ea94160175bc6294644`; paquete inicial `f951cb6892e2867f28ceb3edebb823377c6ecd8f`. Intento 01: integración no descubre los tests, exit 105.
- Fix local `94e4880b03b60d1517917d11ab98dce786499d69`: tipado World del test. Intento 02: STATIC, IMPORT, UNIT 37/37, INTEGRATION 28/28, SMOKE 600 frames y REGRESSION PASS. H03/H04: 20 positivos y control negativo esperado; H1: 34 PASS / 0 FAIL / 1 NOT_RUN headless. [BUG-B1-01](../validation/B01/bugs/BUG-B1-01.md) cerrado técnicamente.
- Paquete al recibir las manuales: `79d63e3d6b5c0ea87f88dac55e33f11ddef9d7c1`, runtime idéntico a C94e4880, sin cambios versionados. El creador no escribió el SHA de su sesión: la asociación al checkout es contexto inspeccionado, no una confirmación independiente.
- M-01 PASS, ventana «bien»; M-02 FAIL; M-03/M-04/M-05/M-06/M-07 PASS comunicados; M-08 PASS tras aclarar Q histórico en F5. B1 en F6 usa WW/AA/SS/DD. Balance sigue provisional.
- [TEST_RESULTS](../validation/B01/TEST_RESULTS.md), [manifest](../validation/B01/TEST_MANIFEST.json) y [paquete](../validation/B01/TEST_HANDOFF.md). Manifest en VALIDATION_FAILED: valida esquema, no debe presentarse como transferencia --ready hasta el próximo fix.

Entorno automático real: Windows 11 Home 10.0.26300, Godot 4.7.2.stable.official.ed1daf0bf, GdUnit4 6.2.3, Python 3.13.15. Solo headless. Godot generó 24 sidecars .gd.uid y caché; se conservan los archivos locales. No ejecución manual, gráfica, export ni Blender por Codex.

## Petición futura: cámara al morir

**D-029**, expresamente solicitada para dejar anotada: transición a tercera persona, alejamiento y pequeña elevación de cámara, mostrando el cuerpo del protagonista tumbado. No implementar ahora ni bloquear la cámara actual por inferencia. Distancia, duración y técnica del cuerpo/animación pendientes; continuidad anotada en GAME_DESIGN, ART_BIBLE y prompts H19/H23, sin iniciar esos hitos.

## Después del fix

Claude entrega nuevo C y paquete completo en B1. Codex comprueba --ready en worktree limpio y repite automáticas/regresiones, con evidencia nueva fuera del candidato. El creador repite M-02 y las manuales afectadas (movimiento/cámara/disparo), indicando SHA. No reutilizar como limpios los worktrees importados ni sobrescribir intentos previos. B2 sigue NOT_STARTED; main no se fusiona; aprobación final pendiente.

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
