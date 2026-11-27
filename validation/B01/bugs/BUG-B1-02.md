# BUG-B1-02 — El arma atraviesa paredes aunque el cuerpo se detenga

- Lote / hitos: B1 / H05-H06. Caso M-02-WALL; restricción del creador D-030.
- Severidad: **mayor**, colisión/presentación del arma; impide cerrar la revisión manual B1.
- Estado: **abierto, requiere corrección de Claude**. No existe commit de fix.
- Candidato automático previo: `94e4880b03b60d1517917d11ab98dce786499d69`; paquete inspeccionado: `79d63e3d6b5c0ea87f88dac55e33f11ddef9d7c1`, rama B1. El creador no escribió el SHA de su sesión; se conserva ese límite en el [informe original](../evidence/manual_review_20261127/CREATOR_RESULTS.md).
- Entorno Codex comprobado: Windows 11 Home 10.0.26300; Godot `4.7.2.stable.official.ed1daf0bf`, GdUnit4 6.2.3, Python 3.13.15. No inferir versiones adicionales de la sesión manual.
- Escena: `scenes/b1/b1_sandbox.tscn`, F6. Frecuencia exacta no indicada por el creador; sin captura ni vídeo. Codex no reprodujo gameplay manual.

## Reproducción

1. Abrir la escena B1 y ejecutarla con F6; jugador vivo y arma de prueba visible.
2. Mirar el muro gris del carril derecho o un muro exterior y acercarse; hacer WW hacia la pared conforme a M-02.
3. Observar el contacto del arma y el cuerpo con la pared.

Observado por el creador: «No atravieos la pared pero mi arma si». El cuerpo respeta la pared, el modelo del arma la penetra. No hay crash ni exit manual que registrar.

Esperado, aclaración posterior expresa: **conservar posición y apariencia del arma, y que no pueda atravesar la pared al tocarla**. No se acepta reducirla, acercarla a cámara, desplazarla para disimular el contacto, ocultarla o dibujarla sobre la pared. Conservar también las animaciones existentes como referencia visual; cualquier conflicto material con la respuesta física debe explicitarse, no resolverse cambiando el diseño silenciosamente.

## Diagnóstico

Hechos del código:

- `scenes/player/b1_player.tscn`: el cuerpo físico es una cápsula de radio 0,35 y altura 1,8. `FixtureWeapon` es un `Node3D` hijo de cámara, con escala 1 y posición `(0.32, -0.28, -0.55)`.
- `scripts/combat/fixture_weapon.gd` crea tres cajas visibles, animadas en retroceso/recuperación/recarga. El arma no tiene forma física que limite el movimiento del CharacterBody3D.
- `scripts/player/b1_player.gd` aplica el giro de cámara por `look()` y mueve el cuerpo; actualmente no comprueba el volumen barrido por el arma al girar. Comprobar solamente el avance frontal no cubriría esos giros.
- El hitscan ya respeta paredes; esto no impide que el mesh del arma las atraviese. No confundir ambos problemas.

Diagnóstico automático **sin modificar el arma**, commit `49ecd30a5b78ef18a85390e8929baf132d6b78ff`: prueba experimental de vértices de las cajas en poses de las animaciones y ángulos de cámara. La distancia máxima a la línea central de la cápsula alcanzó 1,188606 frente a radio 0,35. [JUnit exacto](../evidence/diagnostic_03/b1_integration_reports/report_1/results.xml):

```text
Expecting to be less than:
 0.350000 but was 1.188606
```

Integración: 29 casos, 1 fallo, 0 errores/omitidos, exit 100; los 28 casos anteriores pasan. Importación, 37 unitarias y smoke PASS. [Comando, cwd y exit del runner](../evidence/diagnostic_03/preflight/runner.json), [summary](../evidence/diagnostic_03/summary.json). Se usó `--skip-regression`; estático y regresión completa NOT_RUN en ese diagnóstico. El intento 02 conserva la regresión completa anterior.

**Límite:** esta prueba demuestra que el mesh sobresale de la cápsula, no reproduce una colisión con pared ni define la solución correcta. El criterio «todo el arma dentro de la cápsula» fue retirado tras D-030 mediante `71ce9a24f574b888fe2f9b8ca1c641470703b96a`. Logs y test histórico se conservan; no se atribuye un fix a esa retirada. El runtime, escenas, tests y baseline portable vuelven exactamente al paquete `79d63e3`.

**HIPÓTESIS de implementación, no decisión aprobada:** coordinar comprobaciones del volumen del arma contra geometría con la traslación del jugador y el giro, evitando penetración sin cambiar el transform relativo ni el aspecto del arma. Hay que cubrir contacto lateral, esquinas, pitch y poses animadas, permitir separarse de la pared y evitar bloqueo permanente. La respuesta exacta al contacto requiere diseño de esa coordinación; no basta añadir un collider suelto al mesh ni agrandar indiscriminadamente el cuerpo.

Se devuelve a Claude según AGENTS §2/§5 y el paso 5 del encargo: corregir estas interacciones entre cámara, movimiento y arma supera la corrección pequeña/local reservada a Codex. El requisito visual está decidido (D-030); esta devolución no pide que el creador lo confirme de nuevo.

## Corrección y regresión

Fix: **pendiente**. No marcar cerrado ni cambiar PASS/FAIL para ocultar la incidencia.

1. Claude conserva el transform y aspecto actuales; implementa la prevención de penetración física en B1 y documenta la respuesta de contacto.
2. Añadir tests con paredes reales: caminar/dash frontal, aproximación lateral/esquina, giro cerca de pared y extremos verticales; retroceso/recarga junto a pared, separación y ausencia de atascos. Las pruebas deberán fallar con la implementación actual y pasar con el fix.
3. Repetir en candidato limpio las unitarias/integración B1, importación, estático, smoke y regresión H1/H03/H04, guardando nuevo SHA, comandos y evidencia. Mantener la cobertura previa; no imponer contención dentro del cuerpo como requisito.
4. Creador: repetir M-02 y revisar M-03/M-06 (movimiento, cámara y disparo) si el fix los afecta. Confirmar que posición, encuadre, tamaño aparente y animaciones se conservan. Registrar el SHA de esa sesión.
5. Cierre técnico y aceptación visual son pasos separados. La cámara de muerte D-029 queda fuera de esta corrección y para desarrollo futuro.
