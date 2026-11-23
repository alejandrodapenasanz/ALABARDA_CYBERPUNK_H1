# TEST_STRATEGY — Puertas de calidad y resultados verificables

**Cierre H04 · 2026-11-22:** aceptación manual conjunta recibida, registrada en VALIDATION y D-021. H04 cerrado con suite `run_02` PASS. El clic headless conserva NOT_RUN en sus logs; aprobación humana separada. Las menciones inferiores de aprobación H04 pendiente corresponden a la entrega previa.

## H04 · 2026-11-22

```powershell
python -X utf8 tools/h04/run_tests.py --godot $env:GODOT_BIN --output docs/evidence/h04/nueva_ejecucion --graphics
```

Directorio de salida nuevo obligatorio. Ejecuta toda la suite H03/H1 (incluido control negativo) y cuatro casos GdUnit H04; `--graphics` añade probes anteriores y tres luces × cuatro cámaras H04. Logs/argv/OS/exit/JUnit y resumen por ejecución. Sin gráficos no se atribuyen capturas ni mediciones. Import, logs con errores o casos faltantes producen FAIL; Blender no es dependencia de ejecución, solo de autoría. Para regenerar kit: comando y versión fijada en ARCHITECTURE.

H04 añade: GLB exportado con UV/materiales/triángulos/metraje/pivote al suelo, tres luces reversibles/reset D-019, materiales independientes entre instancias, ocho usos del kit, separación de fixtures y gameplay; hashes de blend/GLB. Suite final [run_02](evidence/h04/run_02/summary.json): 20 tests GdUnit positivos PASS, H1 34/0/1, gráficos/integridad PASS. El único NOT_RUN H1 es interacción física headless. Revisión visual/manual H04 PENDING_APPROVAL; no reutiliza la aceptación H03.

Mediciones: 60 frames de calentamiento +180 muestras, foco registrado, configuración/hardware y tiempos crudos; comparación base al comienzo/final y variante sin sombras. Diferencia de píxeles comprueba cambios de iluminación y los probes H03 siguen comprobando retro/UI. Sin objetivo de FPS ni aprobación artística automática.

## H03 implementado · 2026-11-21

Framework **GdUnit4 6.2.3 / MIT**, Godot **4.7.2 estándar x64** en Windows; Python 3.13.15 (mínimo del ejecutor 3.11), PowerShell. Addon vendorizado y fijado por URL/hash. Instalación reproducible y límites de compatibilidad en [ARCHITECTURE](ARCHITECTURE.md). Los apartados H02/PRE-H03 inferiores son antecedentes, no el estado de instalación actual.

Desde la raíz, con GODOT_BIN apuntando a tu Godot console.exe:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File tools/run_tests.ps1 -Godot $env:GODOT_BIN
powershell -NoProfile -ExecutionPolicy Bypass -File tools/run_tests.ps1 -Godot $env:GODOT_BIN -Graphics
```

También se acepta PATH godot/godot4. Sin motor, BLOCKED y exit 2; no se descubre silenciosamente un ejecutable personal. Para otro directorio nuevo de logs: -OutputDir seguido de la ruta. No reutilizar un directorio existente. Sin -Graphics, ventana/capturas no se ejecutan. Con -Graphics, el benchmark va al final, después de terminar los otros procesos Godot.

Comandos internos reproducibles (el runner registra los argv exactos por ejecución):

```powershell
& $env:GODOT_BIN --headless --path . --editor --import --quit
& $env:GODOT_BIN --headless --path . -s res://addons/gdUnit4/bin/GdUnitCmdTool.gd -a res://tests/h03/unit --ignoreHeadlessMode
& $env:GODOT_BIN --headless --path . -s res://addons/gdUnit4/bin/GdUnitCmdTool.gd -a res://tests/h03/integration --ignoreHeadlessMode
# Este comando DEBE fallar con 100; no es la suite normal:
& $env:GODOT_BIN --headless --path . -s res://addons/gdUnit4/bin/GdUnitCmdTool.gd -a res://tests/h03/controlled_failure --ignoreHeadlessMode
& $env:GODOT_BIN --headless --path . --fixed-fps 60 --script res://tests/h02/h1_probe.gd -- --edges
python -X utf8 tools/h03/verify_integrity.py
```

El runner usa -rd para aislar JUnit/HTML. Evalúa exit, errores de motor en ambos streams, presencia/contenido del JUnit y conteo del probe H1. El control negativo exige 1 caso identificado, 1 failure, cero errors/skipped y exit 100: no acepta errores de inicialización como prueba del detector. No ejecutar -a res://tests indiscriminadamente porque incluiría el fallo intencionado.

| Grupo | Cobertura real / éxito exigido |
|---|---|
| Unitarias (8) | Framework positivo; lectura y reglas; tipos/no finitos/negativos; campos/esquema; relaciones/enteros; clamps extremos; recursos ausentes/incorrectos; independencia de instancias. Todas PASS |
| Integración (5) | Muestras/materiales/cámara/esqueleto; reversión de cada opción; glifos españoles sin fallback; entrada/renderer H1; deformación de esqueleto por animación. Todas PASS |
| Control negativo (1) | Aserción deliberadamente falsa; FAIL real y exit 100 esperado, verificado por ejecutor |
| Regresión H1 | Probe H02 intacto: 34 PASS, 0 FAIL, 1 NOT_RUN de clic/cursor headless |
| Integridad | Originales y H1 por hash, referencias runtime existentes, muestras coinciden con manifiesto; cambio externo de AGENTS registrado aparte |
| Gráfico optativo | Rechaza headless, shader dibujado en ventana real, PNG auténticos y medidas por perfil. Revisión estética manual separada |

CI futura: instalar versión exacta de Godot/Python, ejecutar el mismo script, conservar summary.json, logs y JUnit como artifacts. No se configura servicio remoto ni credenciales. GPU/desktop para -Graphics; un agente headless solo valida datos/escenas, no estética ni rendimiento. No hay tests de sistemas futuros ni export Windows en H03.

La evidencia vigente está en [VALIDATION](VALIDATION.md). Revisiones manuales: [HANDOFF](HANDOFF.md).
## Estados
- `PASS`: comando ejecutado; código de salida 0; asserts pasan; log y entorno identificados.
- `FAIL`: test ejecutado, requisito incumplido o regresión.
- `BLOCKED`: dependencia real impide ejecutar test crítico; no equivale a PASS.
- `NOT_RUN`: test sin ejecutar; jamás escribir PASS.

## Matriz por tipo
| Tipo | Automatización requerida | Manual complementaria |
|---|---|---|
| Documental H02 | enlaces/rutas, duplicados/migración idempotente | dueño confirma contenido consolidado |
| Import Godot | headless editor import + inspeccionar código retorno/log | abrir en editor |
| Lógica | framework de tests fijado + asserts, datasets extremos | probar interacción |
| Escenas | instanciar scenes y señales, sin missing nodes | navegación y feedback |
| IA | FSM eventos inyectados, FOV, oclusión, memoria, deterministic fixtures | sigilo en arena real |
| Persistencia | save/load roundtrip, corrupto, atomicidad, rollback | cerrar/reabrir app |
| Economía | créditos, doble pago, repetición, fallos de transacción | experiencia de compra |
| Arte | importación, dependencia/licencia, colisiones con reemplazos | aprobación estética |
| Export | export con templates disponibles, hash; build artifacts | ejecutar .exe en Windows real |

## Herramientas (verificar en H03)
- Referencia oficial de argumentos Godot: https://docs.godotengine.org/en/stable/tutorials/editor/command_line_tutorial.html
- Suite de referencia GdUnit4: https://godot-gdunit-labs.github.io/gdUnit4/latest/advanced_testing/cmd/
- No afirmar que el framework ya está instalado; H03 selecciona y fija una versión COMPATIBLE, registra comando exacto de Windows, funcionamiento del exit code, directorio de pruebas y resultados JUnit si disponible.
- Posibles comprobaciones Godot **solo cuando CLI resuelta** (shell equivalente para Windows): `godot --headless --path . --editor --import --quit`; `godot --headless --path . --quit-after 120`. No asumir que el comando `godot` existe en PATH; detectar ejecutable real.

## Pruebas numéricas de borde
- Energía 0, 99, 100, 150, 151; curación salud 0/100; delta 0 y delta grande; doble pulsación; interrupción por muerte.
- Dinero: 0, coste-1, coste exacto, dos compras concurrentes simuladas, respec tras save/load, saldo inválido.
- Armas: 0/1/2 cartuchos, tres slots, recarga durante recovery, cinco disparos con un cargador, anti doble daño.
- Sigilo: visión obstruida, ruido fuera de radio, pérdida de contacto, recuerdo última posición, dos alarmas a la vez.
- Contrato: éxito una vez, fallo, reinicio, repetición, abandono, recompensa doble no permitida.

## Informe mínimo en VALIDATION.md por hito
- ID + commit/branch + Godot versión + OS + versión framework.
- Comando exacto, fecha, exit code, conteo, extracto de log/ruta de reporte.
- Estado PASS/FAIL/BLOCKED/NOT_RUN por clase de test.
- Manual: pasos para usuario, resultado pendiente/aprobado/rechazado.
- Problemas, regresiones, decisiones abiertas.

## DoD
No aprobar hito con fallos críticos, datos deshonestos, regresiones o pruebas críticas sin ejecutar. Tras completar tests, **esperar validación manual del creador**. Tests automatizados no certifican fluidez ni dirección artística.

## Entorno resuelto H02 · 2026-11-20

- OS observado: Windows 11, `10.0.26200`; PowerShell de Windows.
- Godot en PATH: no encontrado. Ejecutable localizado por búsqueda de archivos y corroborado en metadata del editor: `C:/Users/aleja/Downloads/Godot_v4.7.2-stable_win64.exe/Godot_v4.7.2-stable_win64_console.exe`.
- `--version`: `4.7.2.stable.official.ed1daf0bf`; `project.godot` declara 4.7/GL Compatibility. No se prueba compatibilidad con otras versiones.
- Python real: 3.13.15, `C:/Users/aleja/AppData/Local/Programs/Python/Python313/python.exe`; usar `-X utf8` para salida en Windows.
- Git: 2.54.0.windows.1. No existía repo; baseline H02 documentado en ARCHITECTURE. Sin identidad configurada, commits ni remote.
- Suite previa, GdUnit4 y addons: **ausentes**. Su ejecución previa se registra NOT_RUN, no PASS. No se instala framework en H02.

## Comandos reproducibles H02

Desde `C:/dev/ALABARDA_CYBERPUNK_H1`, en PowerShell:

```powershell
$GodotH02 = 'C:/Users/aleja/Downloads/Godot_v4.7.2-stable_win64.exe/Godot_v4.7.2-stable_win64_console.exe'
& $GodotH02 --version
& $GodotH02 --headless --path . --editor --import --quit
& $GodotH02 --headless --path . --quit-after 120
& $GodotH02 --headless --path . --check-only --script res://scripts/main.gd
& $GodotH02 --headless --path . --check-only --script res://scripts/player.gd
& $GodotH02 --headless --path . --check-only --script res://scripts/enemy.gd
& $GodotH02 --headless --path . --fixed-fps 60 --script res://tests/h02/h1_probe.gd
& $GodotH02 --headless --path . --fixed-fps 60 --script res://tests/h02/h1_probe.gd -- --edges
python -X utf8 tools/h02/audit_repo.py
python -X utf8 tools/h02/verify_migration.py
python -X utf8 tools/h02/migrate_docs.py
git -c core.autocrlf=false diff --exit-code refs/h02/baseline -- project.godot scenes scripts/player.gd.uid scripts/enemy.gd.uid scripts/main.gd.uid
```

Para conservar una nueva ejecución, prefijar con el registrador y un nombre libre; no sobrescribe logs existentes:

```powershell
python -X utf8 tools/h02/run_logged.py revision_manual_import $GodotH02 --headless --path . --editor --import --quit
```

Cada ejecución deja JSON con argv y comando exacto escapado para PowerShell, fecha UTC+01:00 (Madrid en la fecha H02), cwd, OS/Python, exit code del proceso y stdout/stderr completos en `docs/evidence/h02/`. La versión Godot está en [godot_version](evidence/h02/godot_version.stdout.log). No se considera PASS solo por exit 0: hay que revisar contadores y logs. El timeout de 120 s deja exit 124; ejecutable no disponible, 127. El comando `tools/h02/capture_baseline.py` es de captura única y rechaza volver a ejecutarse sobre un Git ya existente.

## Cobertura y límites del probe H1

`tests/h02/h1_probe.gd` instancia la escena de inicio real; valida suelo, tecla W, sprint, dash/cooldown, salto, pared, salud/HUD, respawn, ataque por rango, R durante/después de combate y derrota de cinco objetivos (ocho impactos con daño H1). No crea un sistema jugable nuevo. Se desactivan ataques autónomos durante el fixture para aislar los resultados; se invoca el ataque original de forma controlada.

En headless, DisplayServer conserva mouse_mode=0 incluso tras capturarlo explícitamente. Cursor y ruta clic→disparo extremo a extremo quedan NOT_RUN/BLOCKED por backend. La prueba llama `_shoot()` real para raycast, daño, señal y cooldown: PASS de ese flujo no demuestra captura, puntería con ratón ni cadencia percibida. Los tres scripts sí se cargan y ejercitan. No se prueban aquí sistemas inexistentes (energía, guardado, IA, etc.).

`--edges` comprueba además daño negativo/no finito/cero en jugador y enemigo, doble eliminación en el mismo frame y en callback reentrante, HP mínimo, ataque tras derrota, persistencia de victoria y limpieza al reiniciar. La ejecución original tenía tres FAIL; la revisión correctiva conserva esos asserts y añade bordes relacionados. Debe devolver 0 únicamente si todos pasan; resultados por ejecución en VALIDATION.

Migración v2: `tools/h02/verify_migration.py` verifica consolidación desde originales, 23 prompts, cero nombres con (1), repetición sin cambios, preservación de los 48 contenidos por hash y rechazo de ediciones ajenas/colisiones antes de escribir. El inventario valida rutas actuales del manifiesto, archivos históricos y snapshot de los tres scripts corregidos; no exige recrear los alias retirados por el creador.

El verificador documental revisa links relativos/anclas presentes, rutas de archivos en código inline e IDs de decisiones/requisitos; fórmulas, comandos y patrones no son archivos. Reporta referencias históricas y ausencias declaradas por separado. No es un parser universal de Markdown ni verifica URL externas o coherencia creativa por sí solo. La revisión humana queda en DOCUMENTATION_AUDIT.

## PRE-H03 documental y futuras pruebas visuales

PRE-H03 comprueba coherencia de D-017/ART_BIBLE/prompts, enlaces/IDs/duplicados y diff contra el estado de entrada propio, además de importación o arranque headless. Sus logs se guardan separados en `docs/evidence/pre_h03/`; no se sobrescriben resultados H02. Ver comandos y resultados en [VALIDATION](VALIDATION.md). Los checks existentes se reutilizan sin modificar herramientas ni scripts del juego.

Al ejecutar H03 con autorización, añadir carga de la escena comparativa, dependencias de materiales/shaders, pruebas de configuración de efectos opcionales y muestras de importación realmente usadas. La comparación A/B de arte, HUD, siluetas y claridad en movimiento requiere ventana y revisión humana; medir rendimiento gráfico con hardware, driver, renderer, resolución y condiciones registrados. Capturas cuando sea posible. Headless no valida estética ni rendimiento GPU; registrar BLOCKED/NOT_RUN si falta esa capacidad. [Prompt H03 actualizado](../prompts/H03_INFRAESTRUCTURA_DE_PRUEBAS_Y_BALANCE.md).
# Ampliación H03 · 2026-11-22

Integración actual: **8 casos** (cinco iniciales + distribución sin solapes, reset/retro A-B y Malorian local/fallback público). `-Graphics` ejecuta también `tests/h03/readability_probe.gd`: cuatro cámaras, panel de fuentes abierto/cerrado a dos tamaños, diferencia de píxeles del efecto y ausencia de cambios a intensidad cero. Datos/capturas en subcarpeta readability. Estos controles no otorgan aprobación humana por sí mismos; posteriormente el creador confirmó H1, HomeVideo y animación y cerró H03 el 2026-11-22. El clic físico conserva NOT_RUN en headless y PASS manual declarado en VALIDATION. Los contadores iniciales del documento son históricos.
