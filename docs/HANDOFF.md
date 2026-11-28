# HANDOFF — juego integrado; siguiente encargo B2

**2026-11-28.** B1 (H05/H06) APPROVED por el creador e integrado en main. La rama B1 ya está eliminada local/remota. [Decisiones D-031/D-032](DECISIONS.md), [resultados y evidencia histórica](VALIDATION.md). B2 no se ha implementado.

## Código que debe ampliar Claude

F5 → `scenes/main.tscn` → `scripts/main.gd`. Jugador compartido: `scenes/player/player.tscn` y `scripts/player/player_controller.gd` (PlayerController). Combate en `scripts/combat/`, interacción en `scripts/interaction/`, peligros de la arena en `scripts/world/`.

Conservar movimiento/dash doble toque, F/E separados, salud/regeneración y colisión del arma aprobados. No cambiar posición/aspecto del arma para esconder penetración. Nuevas armas/animaciones requieren adaptar su volumen de colisión y las pruebas. Ampliar este flujo normal.

## Estado de la entrega

Merge `be3a94fb9118664ebc95919398a020a968b16074`: 37 unitarias, 38 integración, importación, estático, entrada F5 y regresiones H1/H03/H04 PASS. Suites comunes en `tests/gameplay`, runner `tools/gameplay/run_tests.py`. H1 antiguo solo en `tests/fixtures/h1` como regresión histórica.

D-032 retira del árbol de trabajo 558 archivos en total: el paquete B1 y el manual de raíz, incluidos informes, diagnósticos y ZIP. La evidencia y aprobación se consultan en Git, commit `1e30b5c1aa1ed8f949059ead5517e6c095c3d436`; no recrear sus carpetas ni manuales. Las pruebas comunes siguen siendo necesarias para el juego y B2.

El proyecto completo sigue disponible para importar `project.godot` en otro PC: [GITHUB_TRANSFER](GITHUB_TRANSFER.md). Verificar las herramientas reales; la falta de Godot se declara solo si se comprueba.

## Siguiente encargo

Copiar [next_prompt.md](../next_prompt.md) en Claude: B2 = H07/H08/H09, nueva rama desde main actualizado, checkpoints y paquete propio. Actualizar main y registrar su SHA real. La existencia del prompt no ejecuta el lote.

Pendientes P-001/P-005/P-006/P-011/P-017: bindings, duplicados/vacíos, compatibilidades y balance no se deciden por intuición. D-029 conserva la petición futura de cámara de muerte en tercera persona elevada con el cuerpo tumbado, fuera de B2.
