# TEST_HANDOFF — B1 (H05, H06)

Documento autónomo para repetir las pruebas y para la revisión del creador. Los IDs coinciden con [TEST_MANIFEST.json](TEST_MANIFEST.json) y [TEST_RESULTS.md](TEST_RESULTS.md). **2026-11-27: automáticas PASS sobre `94e4880`; revisión del creador con siete OK y M-02-WALL FAIL. Estado VALIDATION_FAILED; BUG-B1-02 abierto para Claude.** No se declara VALIDATED ni APPROVED. El fallo original de descubrimiento de la suite queda conservado en el intento 01 y [BUG-B1-01](bugs/BUG-B1-01.md).

## A. Identificación

| Campo | Valor |
|---|---|
| Lote / hitos | B1 · H05 Núcleo de jugador, interacción y movimiento · H06 Daño, salud, hitzones y estados de ataque |
| Fecha / autor | Entrega Claude 2026-11-23; ejecución automática y actualización Codex 2026-11-27 |
| Rama | `B1` (creada desde `main`, D-028) |
| **Candidato C corregido y probado** | `94e4880b03b60d1517917d11ab98dce786499d69` |
| Candidato original / paquete de entrada | `bfe7071b63e756200f4e1ea94160175bc6294644` / `f951cb6892e2867f28ceb3edebb823377c6ecd8f` |
| Paquete P de resultados | commit posterior al fix en `B1`, comunicado en el informe final; no se incluye su propio SHA dentro de sí mismo |
| Commit aprobado anterior | `796255711fd04c4e6a6d061fba718e86db8cf099` (`main`, migración v2.1 aprobada, D-028) |
| Estado | `VALIDATION_FAILED`: automáticas anteriores PASS, M-02-WALL FAIL comunicado por el creador; nada `VALIDATED` ni `APPROVED` |
| Entorno esperado | Windows 11 · Godot 4.7.2.stable.official.ed1daf0bf (console) · GL Compatibility · Python 3.11+ · GdUnit4 6.2.3 vendorizado · Blender no necesario |
| Sistemas afectados | Nuevo jugador B1, input map en runtime, salud/daño/hitboxes, arma fixture, sandbox B1. **H1 sin cambios** |

Commits por hito dentro de `B1`: `7e293e3` H05 · `8cc5996` H06 · `bfe7071` candidato (runner, documentación técnica, manifest portable).

Fix `94e4880`: tipar `world` como el script `World` en el test de combate y actualizar únicamente su hash portable. Sin cambios de gameplay ni de aserciones. Resultados: intento 01 FAIL en C original (2026-11-23); intento 02 PASS en el fix (2026-11-27). Windows real del segundo intento: 11 Home 10.0.26300; Python 3.13.15; Godot/GdUnit coinciden con el entorno esperado.

## B. Funcionalidad entregada

En `scenes/b1/b1_sandbox.tscn` (F6) el jugador puede:

- **Moverse** con WASD, **esprintar** con Shift, **saltar** con Espacio y mirar con el ratón (tope vertical ±1,45 rad). Esc libera el ratón; clic lo recaptura.
- **Hacer dash con doble toque** de la misma tecla (WW adelante, SS atrás, AA izquierda, DD derecha, relativo a la vista). Ventana 0,25 s (propuesta), duración 0,16 s, cooldown 1 s. Un dash por par; la repetición automática del teclado, las parejas mixtas (WA, WD…) y los pares durante el cooldown no hacen dash. Una pared detiene el dash.
- **Interactuar con F** con lo que tiene delante (rayo de 2,5 m desde la cámara; las paredes bloquean). **E nunca interactúa**: queda registrada como acción `heal` reservada para H08 y en B1 no hace nada (el sandbox muestra un aviso).
- **Recibir daño** (zona roja 10/s, proyectiles de torreta 8) con una **barra de salud roja 0–100**. Tras **5 s sin daño** regenera **5 HP/s** hasta 100; un nuevo daño reinicia la espera. Valores provisionales.
- **Morir una sola vez**: a 0 HP se bloquean movimiento, dash, interacción y disparo, no hay regeneración; el sandbox se reinicia a los 3 s (solo sandbox).
- **Disparar** un arma de prueba hitscan (35 de daño, cargador 12, hipótesis H1/H03) contra blancos con zona de **cuerpo** (x1) y **cabeza** (x2,0 provisional); un blanco tanque tiene 100 de **armadura** que se consume antes que la salud. La cadencia la marcan las animaciones (ataque 0,10 s con impacto a 0,03 s, recuperación 0,13 s); al vaciar el cargador **recarga sola** (0,9 s) porque la recarga no tiene tecla aprobada.

Separación: **implementado** = todo lo anterior. **Fixture/placeholder** = arma de prueba, blancos estáticos, zona de daño, torreta, consola, geometría greybox, recarga automática, reinicio del sandbox. **Futuro (no implementado)** = energía y curación con E (H08), seis armas y slots 1/2/3 (H07), ultimates (H09), enemigos con IA (H10), respawn/contrato (H19), tecla de recarga.

## C. Archivos

Nuevos (H05): `scripts/core/physics_layers.gd`, `scripts/player/{input_actions,double_tap_detector,dash_controller,player_movement_config,b1_player}.gd`, `resources/player/movement_default.tres`, `scenes/player/b1_player.tscn`, `scripts/interaction/interactable_switch.gd`, `scripts/b1/b1_sandbox.gd`, `scenes/b1/b1_sandbox.tscn`, `tests/b1/support/test_world.gd`, `tests/b1/unit/{double_tap,dash_and_config}_test.gd`, `tests/b1/integration/player_movement_test.gd`.

Nuevos (H06): `scripts/combat/{damage_info,health_config,health_component,hitbox,hitscan,damage_projectile,attack_state_machine,fixture_weapon,target_dummy}.gd`, `resources/combat/player_health.tres`, `scripts/b1/sandbox_hazards.gd`, `tests/b1/unit/health_component_test.gd`, `tests/b1/integration/combat_test.gd`. Modificados en H06: `scenes/player/b1_player.tscn`, `scripts/player/b1_player.gd`, `scripts/b1/b1_sandbox.gd`.

Candidato: nuevo `tools/b1/run_tests.py`; modificados `docs/ARCHITECTURE.md` (sección B1 con rutas reales), `docs/CONTROLS.md`, `docs/BALANCE_PROVISIONAL.md` (ventana 0,25 s y cabeza x2,0 como propuestas), `docs/TEST_STRATEGY.md`, `README.md`, `tools/pipeline/checkout_manifest.json` (29 ficheros nuevos).

Eliminados: ninguno. **No modificados**: `scenes/main.tscn`, `scripts/player.gd`, `scripts/enemy.gd`, `scripts/main.gd`, `project.godot`, H03/H04, assets, addons. Sin assets nuevos (todo con primitivas): no hay licencias que registrar.

## D. Dependencias

- Base: `main` en `7962557` (H1–H04 aprobados, D-027/D-028). GdUnit4 6.2.3 ya vendorizado. Ninguna dependencia nueva del juego.
- El input map de B1 se registra en runtime (`InputActions.ensure_registered()`), no en `project.godot`, para no alterar H1.
- Interfaces estables para B2: `HealthComponent.heal(amount) -> float` (HP efectivo), `set_regen_paused(source, paused)` (H08 usará `&"manual_heal"`), señales `damaged/died/health_changed`; `DamageInfo`; `Hitbox.receive_hit`; `AttackStateMachine` (estados y `hit_frame`); `B1Player.set_disabled`, `fire`, `take_damage`; acción `heal` (E) ya reservada.
- Decisiones aplicadas: D-025 (dash), D-027 (F interactúa, E reservada). Pendientes que no bloquean B1: ventana del doble toque y multiplicador de cabeza (PENDING_PLAYTEST), tecla de recarga, P-017 remates.

## E. Pruebas automáticas

**Forma recomendada (un comando):** en un worktree limpio de C, `python -X utf8 tools/b1/run_tests.py --godot <ruta a Godot_v4.7.2-stable_win64_console.exe> --output <directorio nuevo fuera del candidato>`. Ejecuta B1-IMPORT, B1-UNIT, B1-INTEGRATION, B1-SMOKE y B1-REGRESSION, guarda logs/JSON/JUnit y escribe `summary.json`. Exit 0 solo si todo pasa.

| ID | Tipo · crítico | Comando (cwd = raíz de C) | PASS | FAIL | Timeout | Depende |
|---|---|---|---|---|---|---|
| B1-STATIC | static · no | `python -X utf8 tools/pipeline/check_godot_static.py` | exit 0, `errors` vacío | error nuevo | 120 s | — |
| B1-IMPORT | import · sí | `${GODOT_BIN} --headless --path . --editor --import --quit` | exit 0 sin SCRIPT ERROR/Parse Error/Failed to load | exit≠0, timeout o error de motor | 300 s | — |
| B1-UNIT | unit · sí | `${GODOT_BIN} --headless --path . -s res://addons/gdUnit4/bin/GdUnitCmdTool.gd -a res://tests/b1/unit --ignoreHeadlessMode -rd ${EVIDENCE_DIR}/b1_unit_reports` | exit 0, **37** testcase, 0 failure/error/skipped | cualquier fallo o recuento ≠ 37 | 300 s | IMPORT |
| B1-INTEGRATION | integration · sí | igual con `-a res://tests/b1/integration` y `-rd ${EVIDENCE_DIR}/b1_integration_reports` | exit 0, **28** testcase, 0 failure/error/skipped | cualquier fallo o recuento ≠ 28 | 300 s | IMPORT |
| B1-SMOKE | integration · sí | `${GODOT_BIN} --headless --path . --fixed-fps 60 --quit-after 600 res://scenes/b1/b1_sandbox.tscn` | exit 0 sin errores de motor | error/timeout | 180 s | IMPORT |
| B1-REGRESSION | regression · sí | `python -X utf8 tools/h04/run_tests.py --godot ${GODOT_BIN} --output ${EVIDENCE_DIR}/regression` | `summary.json` PASS; `RESULT passed=34 failed=0 not_run=1` en H1 | cualquier entrada FAIL | 900 s | IMPORT |

Cobertura de los tests (ejecutados en el intento 02; todos PASS):

- `double_tap_test.gd` (10): CT-01 cuatro direcciones; CT-02 ventana lenta, límite inclusivo, parejas mixtas, mixta seguida de la misma tecla; CT-03 echo/soltar ignorados, tecla mantenida, triple toque = un dash; entradas inválidas y reloj hacia atrás.
- `dash_and_config_test.gd` (10): duración, cooldown, dirección aplanada/validada, estado bloqueado sin consumir cooldown, delta inválido; config por defecto válida e inválidas rechazadas; acciones con teclas aprobadas; E≠F; sin binding inventado para recarga/ultimate/pausa.
- `health_component_test.gd` (17): SB-01, SB-02, SB-03 (incluye pasos partidos = paso grande), SB-04, SB-05, SB-06/SB-26, SB-07, `heal` efectivo, **contrato de pausa H08 con doble** (20+25, nunca 20+30; reanuda sin nueva espera), fuentes de pausa independientes, armadura y rotura única, absorción parcial, vulnerabilidad/inmunidad/multiplicador inválido/invulnerable, varios impactos con muerte única, `DamageInfo`, recurso de salud y aplicación de config.
- `player_movement_test.gd` (14): CT-05 suelo, W con input real, sprint, salto, cámara; CT-01 dirección por acción y por yaw, doble toque con eventos reales; CT-02; CT-03; CT-04 pared y estado bloqueado; CT-06 F frente a E junto a la consola, pared y distancia.
- `combat_test.gd` (14): cabeza x2/cuerpo, pared bloquea hitscan, armadura y hitboxes desactivadas al morir, proyectil impacta una vez, proyectil rápido no atraviesa pared fina, caducidad, ciclo de ataque por animación, sin cadencia sin avance de animación, recarga por animación, interrupción sin impacto, hitscan en el frame de impacto, el jugador no se daña a sí mismo, proyectil + regeneración del jugador, muerte única que bloquea el control.

> Recuento: 10 + 10 + 17 = 37 unitarios; 14 + 14 = 28 de integración. El runner compara el recuento JUnit con los `func test_` declarados.

## F. Pruebas manuales Godot

**Las realiza el creador**, por instrucción expresa. Revisión recibida: M-01/M-03/M-04/M-05/M-06/M-07/M-08 PASS comunicados y M-02 FAIL; [fuente, aclaraciones y límite del SHA](evidence/manual_review_20261127/CREATOR_RESULTS.md). No ejecución manual por Codex. Abrir `scenes/b1/b1_sandbox.tscn` y pulsar **F6** (F5 sigue lanzando H1). Fichas completas en el manifest y guía [manual_tests_B1.md](../../manual_tests_B1.md); resumen:

| ID | Quién | Qué | Pasos clave | Esperado / fallo |
|---|---|---|---|---|
| M-01-DASH | Creador | CT-01..03 y sensación de la ventana 0,25 s | 1. Caminar suelto y con W mantenida 5 s. 2. WW, AA, SS, DD. 3. W luego A. 4. Par durante cooldown. 5. Girar 90° y WW. 6. Valorar la ventana | Un dash por par en la dirección de la vista; nunca al caminar / dash accidental o doble |
| M-02-WALL | Creador | CT-04 | Dash y aproximación/giro cerca de muro gris (10, 1.5, -2) y muro perimetral | Cuerpo y arma no atraviesan, posición/aspecto del arma conservados (D-030), vuelve a SUELO / penetración o bloqueo |
| M-03-MOVE | Creador | CT-05 | Marcas de 1 m andando y con Shift, salto al bloque bajo, tope de cámara | Igual o mejor que H1 / tirones o cámara invertida |
| M-04-INTERACT | Creador | CT-06 / SB-15 | Ante la consola (-4, 1.4, 4): E sin efecto + aviso; F la pone verde; a más de 2,5 m F no hace nada | F alterna, E nunca / E activa |
| M-05-REGEN | Creador | SB-02..05 | Zona roja hasta 70, salir, cronometrar REGEN SÍ (~5 s), subir a 100, reentrar a mitad | 5 s de espera, ~6 s de 70 a 100, reinicio con daño / regenera antes o supera 100 |
| M-06-COMBAT | Creador | Hitzones, armadura, cadencia, recarga | Cuerpo y cabeza al blanco de 60; vaciar el cargador; tanque | -35/-70, ARM antes que HP, recarga a los 12 disparos / zona errónea o sin recarga |
| M-07-DEATH | Creador | SB-06/SB-26 | Torreta (15, 0.6, 15) + zona roja hasta 0; intentar moverse, disparar y F | HAS MUERTO una vez, BLOQUEADO, sin regenerar, reinicio a 3 s / se mueve o dispara muerto |
| M-08-H1 | Creador | Regresión H1 | F5: Q dash, cinco blancos, R | Igual que antes de B1 |

Los registros de esta ejecución en `evidence/attempt_01/manual/` y `evidence/attempt_02/manual/` indican NOT_RUN y no contienen capturas. La revisión posterior está en `evidence/manual_review_20261127/`; conserva los NOT_RUN de ambos intentos históricos. Guardar el futuro retest del fix en un directorio nuevo.

## G. Regresiones

- **H1** (`scenes/main.tscn`): no se ha tocado ningún fichero suyo; B1-REGRESSION ejecuta `tests/h02/h1_probe.gd --edges` y exige `passed=34 failed=0 not_run=1`. Q dash, R y respawn de H1 siguen siendo comportamiento legado válido solo en H1.
- **H03**: suites unitarias/integración, control negativo (exit 100 esperado) e integridad, vía `tools/h04/run_tests.py`.
- **H04**: integración de lookdev (4 tests) e integridad del kit Blender/GLB.
- Riesgo de interferencia bajo: B1 registra acciones de input nuevas en runtime (no existen en H1) y usa capas físicas 2–4 solo en sus escenas.

## H. Problemas conocidos y límites

- Automáticas ejecutadas en Godot 4.7.2: 37 unitarias y 28 de integración PASS en el fix. La suite cubrió `AnimationPlayer.advance()` e inputs inyectados; estos resultados headless no sustituyen sensación, interacción física, arte ni pruebas manuales. El análisis estático no detectó el error de inferencia que sí detectó Godot; fallo y corrección trazados en BUG-B1-01.
- Fixtures, no producto: arma de prueba y blancos con primitivas; geometría greybox; recarga automática; reinicio del sandbox a los 3 s.
- Valores provisionales (PENDING_PLAYTEST): ventana 0,25 s, cabeza x2,0, velocidades/dash de H1, regeneración 5 s / 5 HP/s.
- El salto se repite si se mantiene Espacio (igual que H1). El dash aéreo está permitido (`allow_air_dash = true`, como H1); cambiarlo es una decisión de diseño.
- Worktree en Windows: usar `git -c core.longpaths=true worktree add …`; sin esa opción el checkout falla por rutas largas de assets (comprobado en el PC Claude).
- BUG-B1-01 cerrado técnicamente. **BUG-B1-02 abierto**: el creador informa penetración del arma al detenerse contra paredes. D-030 exige conservar posicionamiento y aspecto; corrección estructural devuelta a Claude. No usar reducción, cambio de encuadre ni ocultación del mesh como solución.
- Diagnóstico geométrico `49ecd30`: 29 casos con 1 fallo, sin cambios del arma; criterio de contención en la cápsula retirado con `71ce9a2` tras D-030. [Evidencia y límite](evidence/diagnostic_03/README.md). Los tests actuales vuelven a ser los 28 del intento 02.
- D-029: futura cámara de muerte en tercera persona, ligeramente elevada y alejada, con cuerpo tumbado. Registrada, sin implementar ni bloquear ahora la cámara. H1 Q aclarado con el creador; resto de H1 confirmado OK.

## I. Checklist del creador

- [x] M-01 dash: creador comunica «OK, ventana bien»; aceptación en esta prueba, sin fijar balance final.
- [x] M-03 movimiento: OK comunicado por el creador.
- [x] M-06 disparo: OK comunicado por el creador; sin mediciones adicionales aportadas.
- [ ] HUD: barra roja de salud legible; textos de estado útiles para probar.
- [x] M-05 regeneración: OK comunicado; parámetros siguen provisionales.
- [x] M-08 H1: resto confirmado OK, Q aclarado como binding histórico.
- [ ] M-02: corregir penetración del arma respetando D-030 y repetir con el creador.
- [ ] Aceptación o rechazo expreso con fecha y SHA (no lo rellena ninguna IA).

## J. Aceptación

- Las automáticas PASS sobre `94e4880b03b60d1517917d11ab98dce786499d69` no bastan para declarar VALIDATED. El creador comunicó siete manuales OK y M-02 FAIL; BUG-B1-02 impide cerrar la validación. SHA de la sesión manual no confirmado explícitamente. Tras el fix, repetir las pruebas afectadas con SHA registrado.
- **APPROVED** requiere la aceptación expresa del creador sobre el SHA probado y la revisión manual completa. No se concede en este paquete.
- Bloquea VALIDATED: cualquier test crítico FAIL o NOT_RUN, SHA distinto o regresión H1/H03/H04. Bloquea APPROVED: rechazo de sensación/legibilidad o pendientes que el creador considere necesarios.
- Fallos → `VALIDATION_FAILED` con BUG_REPORT; correcciones pequeñas y locales puede hacerlas Codex en `B1` con nuevo SHA; estructurales vuelven a Claude.

## K. Recuperación

- Último aprobado: `796255711fd04c4e6a6d061fba718e86db8cf099` (`main`). Para comparar sin perder trabajo: `git -c core.longpaths=true worktree add --detach <dir-nuevo> 796255711fd04c4e6a6d061fba718e86db8cf099`.
- Aislar un fallo: `tools/b1/run_tests.py --skip-regression` repite solo B1; cada suite GdUnit puede lanzarse sola con su comando de E.
- B1 no guarda partidas ni datos persistentes: no hay saves que respaldar.
- El manifest actual registra VALIDATION_FAILED: validar esquema sin --ready. Tras el fix y paquete completo, declarar INTEGRATION_READY y verificar --ready contra el nuevo C limpio.
- Tras un fix: nuevo commit en `B1`, nuevo intento en un directorio de evidencia nuevo, repetir el test del bug y B1-REGRESSION. No usar `reset --hard`, `clean` ni force-push.
