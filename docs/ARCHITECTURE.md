# ARCHITECTURE — implementación H1–H04, B1 (CODE_READY) y contratos futuros

**2026-11-22.** H1–H04 APPROVED; B1–B8 NOT_STARTED. Migración documental aprobada 2026-11-23 (D-028); no se han programado los contratos futuros.

## Contratos previstos (nombres conceptuales, no archivos existentes)

| Sistema | Propietario / contrato | Entrega futura |
|---|---|---|
| HealthSystem | HP0–100, daño válido, muerte única, reloj último daño, autoHP; señales de salud/muerte; curar devuelve HP efectivamente añadido | H06/B1 |
| EnergySystem | Energía0–150; sin pasiva (D-027), bajas únicas hasta150 y ascensor; consulta/consumo seguro; señal energía | H08/B2 |
| Coordinación manual E | Calcula curación posible por HP faltante/energía/tasas; aplica y descuenta coste efectivo sin negativos/redondeo gratis; pausa autoHP activa; no dependencia circular entre componentes | H08/B2 |
| InputController | Acciones distintas: movimiento/dash/slots/curación/interacción; E no contextual; interacción en F (D-027); ignora auto-repeat en doble toque | H05/B1, amplía H07/H08 |
| DashController | Ventana misma tecla y cooldown configurables, una activación por par, dirección/colisiones/estados válidos | H05/B1 |
| WeaponSlotController | ID/etiqueta/arma/restricciones separados; equipa/guarda/cambia; transición única determinista; sin imponer categorías | H07/B2 |
| UltimateController | Umbral energético100, captura energía antes de consumir toda, duración según captura; reloj mundo/jugador separado y restauración al morir/terminar | H09/B2 |

HealthSystem no necesita conocer EnergySystem: coordinador consulta ambos y confirma HP/coste en una operación coherente. H06 prueba su interfaz con dobles, no implementa energía ni E. H08 registra orden de eventos de daño, baja, regeneración de salud y curación y verifica simultaneidad; no existe pasiva energética (D-027). Evento de baja atribuido al jugador idempotente; H10 conecta IA real. Ascensor H19 repone energía150/HPintacto. Contrato detallado y parámetros: [salud/energía](HEALTH_ENERGY_CONTRACT.md), [balance](BALANCE_PROVISIONAL.md), [controles](CONTROLS.md).

El esquema1 de BalanceProfile H03 no implementa estos contratos. Campos de extracción **SUPERSEDED** para el nuevo diseño se conservan byte a byte ahora; adaptación versionada en H06/H08/H09, sin reescribir PASS históricos. No confundir nombres conceptuales futuros con recursos existentes.

## Implementación B1 (H05/H06) · 2026-11-23 · CODE_READY, tests Godot NOT_RUN

Código escrito en el PC Claude sin Godot; solo análisis estático (`check_godot_static.py`) ejecutado. Hasta que Codex valide el SHA, nada de esta sección está comprobado en motor. H1 (`scenes/main.tscn`, `scripts/player.gd`, `scripts/enemy.gd`) **no cambia**: F5 sigue siendo H1 con Q dash y respawn; la regresión H1 sigue vigente.

| Contrato | Archivo real | Notas |
|---|---|---|
| InputController | `scripts/player/input_actions.gd` (InputActions) | Registra acciones en runtime sin sobrescribir remapeos: WASD, Shift, Espacio, **F interact**, **E heal reservada** (sin consumidor hasta H08), clic fire. Sin binding para recarga/ultimate/pausa |
| DashController | `scripts/player/double_tap_detector.gd`, `scripts/player/dash_controller.gd` | Lógica pura con reloj explícito: misma tecla dentro de ventana, ignora echo y parejas mixtas, un dash por par; duración/cooldown; el jugador aplica la velocidad con move_and_slide y cancela si una pared lo frena |
| Jugador | `scenes/player/b1_player.tscn` + `scripts/player/b1_player.gd` (B1Player) | CharacterBody3D, Head/Camera3D, InteractRay, HealthComponent, Hitbox y FixtureWeapon. Estados GROUNDED/AIRBORNE/DASHING/DISABLED. Reloj inyectable para tests |
| Config movimiento | `scripts/player/player_movement_config.gd`, `resources/player/movement_default.tres` | Valores H1 + `double_tap_window_s=0.25` propuesta; todo PROVISIONAL_VALUE |
| Interacción | `scripts/interaction/interactable_switch.gd` | Contrato: grupo `interactable` + `interact(actor)`. Rayo desde cámara, la primera colisión gana (las paredes bloquean) |
| HealthSystem | `scripts/combat/health_component.gd` (HealthComponent), `scripts/combat/health_config.gd`, `resources/combat/player_health.tres` | 0..max, muerte única, armadura, vulnerabilidad/inmunidad por tipo, autoHP tras 5 s a 5 HP/s. `heal()` devuelve HP efectivo; `set_regen_paused(&"manual_heal")` es el contrato para H08. Sin energía |
| Daño | `scripts/combat/damage_info.gd`, `hitbox.gd`, `hitscan.gd`, `damage_projectile.gd` | Hitbox en capa 4 con zona/multiplicador (cabeza x2.0 provisional); hitscan y proyectil sin tunneling (raycast por segmento) |
| Estados de ataque | `scripts/combat/attack_state_machine.gd`, `scripts/combat/fixture_weapon.gd` | READY/ATTACK/RECOVERY/RELOAD solo por AnimationPlayer (method track en el frame de impacto, `animation_finished`); sin temporizador de cadencia. Arma fixture, no H07; recarga automática al vaciar |
| Fixtures | `scripts/combat/target_dummy.gd`, `scripts/b1/sandbox_hazards.gd`, `scripts/b1/b1_sandbox.gd`, `scenes/b1/b1_sandbox.tscn` | Sandbox F6: blancos 60/80/150+armadura 100, zona de daño 10/s, torreta de proyectiles, consola interactuable, barra de salud roja. No es un nivel ni IA (H10) |

Capas físicas (`scripts/core/physics_layers.gd`): 1 mundo, 2 jugador, 3 cuerpos enemigos/blancos, 4 hitboxes. Tests: `tests/b1/unit` (37), `tests/b1/integration` (28), soporte `tests/b1/support/test_world.gd`; runner `tools/b1/run_tests.py`.

## Pipeline de documentación y validación

Claude sin Godot/Blender prepara archivos/tests; Codex importa y ejecuta; creador aprueba. [Workflow](DEVELOPMENT_WORKFLOW.md) define commits C/P, paquetes y estados. JSON Schema1.0.0 en validation/_schemas; checker documental en tools/pipeline, sin ejecutar comandos del manifest. Herramientas antiguas H02/H03/H04 siguen como referencia de sus snapshots; no son sincronizadores del nuevo workflow.

## Implementación vigente H04 · 2026-11-22

H04 APPROVED por el creador (D-021), con pruebas técnicas y manuales registradas. Se conserva `scenes/art_reference/modern_psx_lab.tscn`, su API y controles H03. `project.godot`, main.tscn, tres scripts H1 y balance permanecen intactos. El laboratorio sigue sin colisiones, movimiento FPS, combate, IA ni terminal interactivo.

| Componente | Responsabilidad real |
|---|---|
| scripts/art_reference/lookdev_room.gd | Ensambla el mismo laboratorio con arquitectura, ocho instancias del kit, señales físicas, cinco muestras suministradas y silueta estática. |
| scripts/art_reference/lookdev_profile.gd + resources/art_kit/lookdev.tres | Resource de parámetros de presentación: paleta, ambiente, energía de luces, rango, posiciones/objetivos de cámaras. Cifras experimentales, separadas del balance. |
| lab_world.gd | Conserva cámara, viewmodel opcional/fallback, rig y API set_filter/set_lighting/set_shadows/set_fog. Duplica materiales antes de armonizar roughness/metallic/tintes; fuentes originales intactas. |
| modern_psx_lab.gd | Mismo layout sin solapes; L/botón recorre atmosférica, neutra y alarma estática. Reset conserva D-019 y elimina estado de alarma. X/B/F/A/M/1–4 siguen disponibles. |
| resources/art_kit/*.glb | Tres props originales, metros, eje Y-up, origen al suelo, UV, materiales incluidos; ocho instancias en sala. No binarios de Blender requeridos para abrir Godot. |
| art_sources/h04/*.blend | Fuentes editables producidas por Blender 4.5.3; art_sources/.gdignore evita que el editor intente importarlas. |
| tools/h04/build_kit.py | Autoría reproducible sin plugins extra; aplica transforms, UV y triangulación al exportar; manifiesto SHA-256 de GLB y blend. Paleta hexadecimal convertida de sRGB a lineal antes del Principled BSDF. |
| tests/h04/integration/lookdev_test.gd | Cuatro casos: geometría/UV/pivote/metros; reversibilidad de tres luces; reutilización/aislamiento de materiales; separación de gameplay/UI. |
| tests/h04/lookdev_probe.gd | Ventana real, tres luces × cuatro cámaras, comparación sin sombras y repetición base; foco, hardware, muestras y PNG originales. |
| tools/h04/run_tests.py | Ejecuta suite H03/H1 y añade H04. Exige cuatro casos JUnit reales, cero failures/errors/skips, manifiesto intacto y exit de probes. |

El texto físico usa HomeVideo a 40 px en SubViewport 320×128, actualizado una vez, QuadMesh sin iluminación. Ese ViewportTexture no tiene mipmaps: usa filtro lineal para conservar trazos a distancia. Los materiales 3D restantes siguen nearest+mips por defecto. HUD y panel F siguen fuera del postprocesado. No supone aprobación global de HomeVideo para HUD.

### Pipeline Blender → GLB → Godot comprobada

Herramienta: **Blender 4.5.3 LTS portátil**, paquete Windows del [servidor oficial](https://download.blender.org/release/Blender4.5/), SHA-256 cotejado antes de ejecutar. [Registro URL/hash](evidence/h04/blender_download.json); copyright incluido identifica GPL y componentes compatibles. Ejecutable fuera del repositorio; no plugin instalado. Godot 4.7.2 / GL Compatibility y GdUnit4 6.2.3 conservados.

```powershell
# BLENDER_BIN apunta a blender.exe portátil 4.5.3; GODOT_BIN al console.exe 4.7.2.
& $env:BLENDER_BIN --background --factory-startup --python tools/h04/build_kit.py
& $env:GODOT_BIN --headless --path . --editor --import --quit
python -X utf8 tools/h04/run_tests.py --godot $env:GODOT_BIN --output docs/evidence/h04/nueva_ejecucion --graphics
```

El generador sobrescribe únicamente sus tres fuentes y exports propios; desactiva copias `.blend1`. El runner exige un directorio de logs nuevo. No se necesita Blender para tests o ejecución normal, solo para regenerar el kit. El manifiesto permite comprobar que no cambió desde export. No se atribuye identidad binaria a exports de versiones distintas.

Los apartados H03 siguientes son históricos; sus parámetros antiguos no sustituyen D-019 ni el estado H04.

**H03 cerrado y aprobado; H04 también cerrado posteriormente (D-021).** Confirmadas H1, HomeVideo y animación de brazos; perfil D-019 vigente. Detalles de entregas anteriores en el archivo histórico.

**Valor vigente 2026-11-22, D-019:** DEFAULT_OPTIONS inicia y restaura iluminación atmosférica, nearest+mips, 1280×720, sombras sí, retro/niebla no. Reemplaza el reset neutro de diagnóstico de la corrección anterior. Intensidad 0.70 inactiva con retro apagado; todos los toggles se conservan. Perfil aprobado por el creador, revisable; no cambio de H1.


## Implementación H03 · 2026-11-21

Controles en panel lateral, título/leyenda fuera del 3D, fuentes en panel desplegable propio. Render3D1280×720/640×360 con16:9; el tamaño de ventana no cambia esas resoluciones de prueba. Cámara general frontal FOV55°, restantes65°. B compara retro dividido, slider regula intensidad; X conmuta efecto completo.0 restaura D-019 atmosférica/nearest+mips/1280×720/sombras, sin retro/niebla/fuentes. Shader15 pasos, líneas0.10, mezcla0.70 inactiva cuando retro apagado.

`lab_world.gd` carga opcionalmente Malorian local sin preload, solo si existe el FBX importado. Asigna la textura suministrada y adapta transform de una instancia; mantiene fallback propio cuando no existe la carpeta. `.gitignore` y `package_public.py` excluyen `resources/local_experiments/`; integridad comprueba su manifiesto si está presente y declara ausencia opcional en la copia pública. La carpeta local no está aprobada para exportación; antes de futuros exports aplicar una selección explícita. No hay export presets en H03.

Integración ampliada a 8 casos: distribución de controles/fuentes, reset/A-B y carga local/fallback público, además de los cinco previos. `tests/h03/readability_probe.gd`, añadido a `-Graphics`, captura cuatro cámaras y dos tamaños de ventana, comprueba rectángulos sin solapes, efecto real sobre píxeles y ausencia de efecto a intensidad cero. Los tests gráficos no sustituyen aprobación humana.

H03 aprobado por el creador. H1 conserva entrada, project.godot, main.tscn y tres scripts productivos. Framework/assets/Resources existen separados del gameplay H1.

| Componente real | Función / dependencias |
|---|---|
| addons/gdUnit4 | Framework **6.2.3, MIT**, vendorizado sin cambios; no se activa plugin de editor. CLI probada en Godot 4.7.2 Windows. |
| tools/h03/gdunit.lock.json, tools/h03/install_gdunit.py | URL de tag y SHA-256 del ZIP; reinstalación idempotente, rechaza bytes distintos sin sobrescribir. Solo extrae addon y LICENSE. |
| tools/run_tests.ps1 → tools/h03/run_tests.py | Ejecuta versión/import, unitarias, integración, fallo controlado, arranque, regresión H1 e integridad; opcional gráfico real. Logs separados por ejecución, JUnit y summary.json. |
| scripts/config/balance_profile.gd | Resource con schema_version, diccionarios separados rules/values, validación y clamps puros de límites aprobados. No implementa energía/curación/ultimate/dificultad. |
| resources/balance/provisional.tres | Perfil legado H03, anterior al contrato v2.1. H1 **no lo consume**; daño35 no cambia a propuesta30. Migración futura de campos según BALANCE_PROVISIONAL. |
| scenes/art_reference/modern_psx_lab.tscn | Escena aislada ejecutable con F6; Control raíz. No sustituye main. |
| scripts/art_reference/modern_psx_lab.gd | SubViewport propio para 3D → TextureRect con shader → UI externa. Controles de comparación, cuatro cámaras, movimiento sinusoidal de inspección, comparación de fuentes. |
| scripts/art_reference/lab_world.gd | Geometría/materiales propios, CRT/desk, dos meshes del FBX industrial, silueta estática, arma abstracta FPS y rig de brazos sobre peana. Sin colisiones/IA/daño/interacciones. |
| resources/shaders/subtle_retro.gdshader | Cuantización/líneas, intensidad seleccionada0.70, retro apagado por defecto; solo3D. HUD/fuentes fuera del shader. |
| assets/.gdignore | Conserva el archivo original y evita importación de duplicados, blend, escenas Godot antiguas y recursos no autorizados. |
| resources/art_samples | Una selección importable licenciada; manifiesto fuente/destino/hash. Solo aquí se normaliza Textures→textures para FBX. Godot extrae texturas embebidas de glTF/GLB. |
| tests/h03/unit, tests/h03/integration | 8 tests de datos y8 de integración después de ampliación de legibilidad. Sin cobertura de mecánicas futuras. |
| tests/h03/controlled_failure | Una aserción que debe fallar, fuera de los directorios de suite normal. El ejecutor exige el nombre/caso JUnit esperado y exit 100. |
| tests/h03/graphics_probe.gd | Ventana real, capturas sin edición y wall time entre frame_post_draw, hardware/renderer/config y muestras crudas. Rechaza headless. |
| tools/h03/audit_assets.py, inspect_samples.gd, verify_integrity.py | Inventario estático completo, inspección runtime y preservación por hash/referencias. No reescriben evidencia H02. |

Motor de la referencia: **4.7.2.stable.official.ed1daf0bf**, estándar x64, Windows11 build26200, Compatibility. Ejecución gráfica histórica OpenGL3.3.0/NVIDIA621.24/RTX4050Laptop. Blender4.5.3 portátil se incorporó en H04 para autoría; no es requisito para abrir Godot.

### Instalación y ejecución reproducibles

Requiere Godot estándar **4.7.2**, PowerShell y Python **3.11+** (probado 3.13.15). El addon y muestras ya se entregan. Para reconstruir addon ausente, desde raíz:

```powershell
python -X utf8 tools/h03/install_gdunit.py
# GODOT_BIN debe apuntar al ejecutable console de tu instalación.
powershell -NoProfile -ExecutionPolicy Bypass -File tools/run_tests.ps1 -Godot $env:GODOT_BIN
# Añade medición/capturas en ventana real al final:
powershell -NoProfile -ExecutionPolicy Bypass -File tools/run_tests.ps1 -Godot $env:GODOT_BIN -Graphics
```

También acepta Godot en PATH como godot/godot4. No se incluye ninguna ruta personal en el ejecutor. Sin motor resuelto devuelve 2; test/import/error de recurso devuelve 1; éxito global devuelve 0. Cada proceso conserva su exit real; el fallo esperado devuelve 100 y solo se acepta si JUnit confirma exactamente ese fallo. Un error de parseo o ausencia de tests no puede sustituirlo. Timeout 180 s (import 240 s), resultado 124. Carpetas de salida nuevas, sin sobrescribir logs. Detalle: [TEST_STRATEGY](TEST_STRATEGY.md).

Upstream v6.2.3 declara Godot 4.5+ y enumera 4.7/4.7.1; no se atribuye certificación upstream específica de 4.7.2. Antes de integrar se verificó import + test positivo en proyecto temporal con el ejecutable real. [Compatibilidad](https://github.com/godot-gdunit-labs/gdUnit4/tree/v6.2.3), [CLI Windows](https://godot-gdunit-labs.github.io/gdUnit4/latest/advanced_testing/cmd/), evidencia preflight en VALIDATION. SHA-256 ZIP: 8fb1a298af110be6d73067af66132bf036049deb6d5929d4a16756e18d2228bb.

### Decisiones técnicas y límites

Datos separados de presentación y de H1; no nuevo autoload ni bus global porque aún no hay sistemas que lo requieran. Señales de H1 intactas. El laboratorio tiene API apply_options/set_camera/capture_config para pruebas, sin depender de controles de gameplay. Cada material de muestra se duplica en memoria para evitar contaminar imports o escenas ajenas.

Nearest/linear con mipmaps por material; resolución 3D 1280×720 o 640×360 mediante SubViewport, UI a tamaño lógico del proyecto. Luz ambiente/direccional y dos OmniLight3D, sombras opcionales, niebla estándar (no volumétrica). Se conserva renderer; ninguna mejora requiere Forward+. La [documentación de formatos](https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/importing_3d_scenes/available_formats.html) recomienda glTF, permite FBX ufbx y requiere Blender para blend: solo los formatos ejecutados se dan por comprobados.

El arte continúa EXPERIMENTAL. No hay export presets/paquete Windows ni objetivos finales de rendimiento. Registro de assets/licencias en ASSET_REGISTRY, manual y continuidad en HANDOFF.


## Motor y entrada

- Windows 11, build 26200; Godot `4.7.2.stable.official.ed1daf0bf`, editor estándar. `project.godot` declara features 4.7 y GL Compatibility, viewport 1280×720, stretch canvas_items.
- Inicio: [project.godot](../project.godot) → [scenes/main.tscn](../scenes/main.tscn) → [scripts/main.gd](../scripts/main.gd).
- Entrada jugable H1: raíz `PrototypeH1: Node3D`, con un ext_resource Script. No hay escenas independientes de jugador/enemigo, autoloads de gameplay, navegación, guardado ni export presets. El laboratorio/Resources/addon H03/H04 existen separados del gameplay.
- Los tres scripts productivos tienen sidecars `.gd.uid`; rutas y UIDs conservados. La fase correctiva H02 modifica esos tres scripts para resolver los defectos reproducidos y limpiar el feedback al reiniciar.

## Construcción y dependencias

`main.gd` precarga `player.gd` y `enemy.gd`; no hay ciclos entre ellos. Crea en `_ready`: WorldEnvironment, DirectionalLight3D, bloques de arena, Player, cinco enemigos y CanvasLayer/HUD. Geometría, materiales, arma, colisiones y UI son procedurales con clases de Godot; la escena H1 no usa assets externos; el laboratorio posterior sí usa muestras registradas.

| Componente | Responsabilidad y contrato existente |
|---|---|
| `scripts/main.gd` | Arena 32×32, cinco blancos, HUD vida/hostiles/feedback, reinicio con R solo con contador cero. Instancia scripts con `.new()`. |
| `scripts/player.gd` | CharacterBody3D; grupo player; CapsuleShape3D, Camera3D, WeaponRay y meshes de arma; movimiento en `_physics_process`, `move_and_slide`, hitscan, recoil, salud y respawn. |
| `scripts/enemy.gd` | StaticBody3D; grupo enemies; caja de colisión/mesh; `configure(player, hp, ranged)` antes de entrar al árbol; daño por distancia y temporizador en `_process`. No hay visión ni proyectiles. |
| `tests/h02/h1_probe.gd` | SceneTree de auditoría que instancia la escena real. Fixtures aíslan ataques automáticos y colocan jugador/objetivos para raycast. No se carga al ejecutar F5. |
| `tools/h02/` | Utilidades Python de inventario, captura histórica, migración y registro de comandos para H02; biblioteca estándar, sin framework instalado. |

Señales: Player `health_changed(current, maximum)` → HUD; `shot_fired(hit)` → feedback mientras queden enemigos; `died` → aviso de respawn. Enemy `eliminated(enemy)` → contador/victoria, como máximo una vez por enemigo. Respawn restaura posición, velocidad y salud; no repone blancos ni reinicia un contrato persistente.

Correcciones H02: `take_damage(amount)` rechaza valores no finitos/no positivos; jugador limita HP a [0,max_health]. Enemy limita HP a cero y activa `defeated` antes de emitir eliminación, impidiendo daño reentrante y ataques tras derrota. Main preserva feedback de victoria ante la señal del último disparo y limpia el feedback al reponer blancos. No cambian daño, velocidades, cooldowns ni bindings. [Regresión](VALIDATION.md).

## Inputs comprobados en código

No hay sección Input Map personalizada en `project.godot`. Se usan consultas directas de teclas; no existe remapeo.

| Entrada | Implementación H1 |
|---|---|
| W/S/A/D | Dirección normalizada relativa al jugador. |
| Shift | Sprint mientras se mantiene. |
| Q + dirección | Dash mientras cooldown permite; mantener Q puede repetir tras enfriamiento. |
| Espacio | Salto al estar en suelo; se consulta tecla mantenida. |
| Ratón | `_unhandled_input`, yaw y pitch limitado, solo con captura. |
| Clic izquierdo | Disparo mientras se mantiene, hay captura y cooldown cero. Con cursor visible solicita captura. |
| Escape | Libera cursor; no pausa simulación. |
| R | Repone blancos tras eliminar todos. No es recarga. |
| E/F | No implementadas en H1. |

## Datos numéricos realmente usados

Se conservan los parámetros de H1 sin migrarlos en H02. Son descripción del código, no balance definitivo. H03 añadió un Resource de datos separado de H1; su esquema requiere migración futura para las nuevas reglas.

| Dato H1 | Valor observado / ubicación |
|---|---|
| Marcha / sprint / dash / salto / gravedad | 8.5 / 12.5 / 22 / 6 / 22, exports en player. |
| Dash duración / cooldown | 0.16 / 1 s, literales en player. |
| Vida inicial/máxima | 100; max_health export. |
| Daño / recuperación / alcance de pistola | 35 / 0.23 s / 90, literales en player; no cargador ni AnimationPlayer. |
| Blancos | Dos de 35 HP y tres de 70 HP, definidos en main. |
| Corto alcance | Radio 3, daño 12, intervalo 1.5 s. |
| Distancia | Radio 17, daño 7, intervalo 2.2 s. |
| Primer ataque | Temporizador inicial 0.8 s; no comprueba línea de visión. |



## Git y herramientas

Godot probado 4.7.2.stable.official.ed1daf0bf / Compatibility; GdUnit4 6.2.3 MIT vendorizado; Blender4.5.3 solo autoría. Reinstalación fijada por hash en `tools/h03/install_gdunit.py`, evidencia/licencias en ASSET_REGISTRY. Comandos vigentes en [TEST_STRATEGY](TEST_STRATEGY.md).

Carpeta original `h02-audit` sin HEAD, índice histórico protegido. Tree H02 `a876fef52112f952de91a015903026e6f79cce9a`, `refs/h02/baseline`, no commit. Publicación H04 commit `48f972c6ebeac2a4c7e6ab526e7dead43ad2baba` en copia pública separada. Sincronización completa entre PC pendiente del baseline documental aprobado: no usar un tree como commit ni hacer git add . en esta carpeta. [Snapshot de migración](evidence/pipeline_v2_1/before.json).
