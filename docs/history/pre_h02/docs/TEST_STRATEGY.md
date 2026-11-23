# TEST_STRATEGY — Puertas de calidad y resultados verificables
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
