# BUG-B1-02 — El arma atraviesa paredes aunque el cuerpo se detenga

- Lote / hitos: B1 / H05-H06. Caso M-02-WALL; restricción del creador D-030.
- Severidad: **mayor**, colisión/presentación del arma; impide cerrar la revisión manual B1.
- Estado: **cerrado: fix técnico PASS y confirmado por el creador**. Fix `1401e05269fc4919f3658788e7de48bc5a4aa148`. Encargo directo posterior del creador a Codex: «El arma sigue traspasando la pared, solucionalo».
- Candidato automático previo: `94e4880b03b60d1517917d11ab98dce786499d69`; paquete inspeccionado: `79d63e3d6b5c0ea87f88dac55e33f11ddef9d7c1`, rama B1. El creador no escribió el SHA de su sesión; se conserva ese límite en el [informe original](../evidence/manual_review_20261127/CREATOR_RESULTS.md).
- Entorno Codex comprobado: Windows 11 Home 10.0.26300; Godot `4.7.2.stable.official.ed1daf0bf`, GdUnit4 6.2.3, Python 3.13.15. No inferir versiones adicionales de la sesión manual.
- Escena: `scenes/b1/b1_sandbox.tscn`, F6. Frecuencia exacta no indicada. Tras el informe inicial, el creador aportó una captura en conversación mostrando la penetración y solicitó la corrección directa; no hay archivo de captura local incorporado al paquete. Codex no ejecutó gameplay manual.

## Reproducción

1. Abrir la escena B1 y ejecutarla con F6; jugador vivo y arma de prueba visible.
2. Mirar el muro gris del carril derecho o un muro exterior y acercarse; hacer WW hacia la pared conforme a M-02.
3. Observar el contacto del arma y el cuerpo con la pared.

Observado por el creador: «No atravieos la pared pero mi arma si». El cuerpo respeta la pared, el modelo del arma la penetra. No hay crash ni exit manual que registrar.

Esperado, aclaración posterior expresa: **conservar posición y apariencia del arma, y que no pueda atravesar la pared al tocarla**. No se acepta reducirla, acercarla a cámara, desplazarla para disimular el contacto, ocultarla o dibujarla sobre la pared. Conservar también las animaciones existentes como referencia visual; cualquier conflicto material con la respuesta física debe explicitarse, no resolverse cambiando el diseño silenciosamente.

## Diagnóstico

Hechos del código:

- `scenes/player/b1_player.tscn`: el cuerpo físico es una cápsula de radio 0,35 y altura 1,8. `FixtureWeapon` es un `Node3D` hijo de cámara, con escala 1 y posición `(0.32, -0.28, -0.55)`.
- Antes del fix, `scripts/combat/fixture_weapon.gd` creaba tres cajas visibles animadas sin forma física que limitara al CharacterBody3D. El script de la fixture continúa intacto; el nuevo guard añade esa forma al cuerpo.
- `scripts/player/b1_player.gd` aplica el giro de cámara por `look()` y mueve el cuerpo; antes del fix no comprobaba el volumen barrido por el arma al girar. Comprobar solamente el avance frontal no cubriría esos giros.
- El hitscan ya respeta paredes; esto no impide que el mesh del arma las atraviese. No confundir ambos problemas.

Diagnóstico automático **sin modificar el arma**, commit `49ecd30a5b78ef18a85390e8929baf132d6b78ff`: prueba experimental de vértices de las cajas en poses de las animaciones y ángulos de cámara. La distancia máxima a la línea central de la cápsula alcanzó 1,188606 frente a radio 0,35. [JUnit exacto](../evidence/diagnostic_03/b1_integration_reports/report_1/results.xml):

```text
Expecting to be less than:
 0.350000 but was 1.188606
```

Integración: 29 casos, 1 fallo, 0 errores/omitidos, exit 100; los 28 casos anteriores pasan. Importación, 37 unitarias y smoke PASS. [Comando, cwd y exit del runner](../evidence/diagnostic_03/preflight/runner.json), [summary](../evidence/diagnostic_03/summary.json). Se usó `--skip-regression`; estático y regresión completa NOT_RUN en ese diagnóstico. El intento 02 conserva la regresión completa anterior.

**Límite:** esta prueba demuestra que el mesh sobresale de la cápsula, no reproduce una colisión con pared ni define la solución correcta. El criterio «todo el arma dentro de la cápsula» fue retirado tras D-030 mediante `71ce9a24f574b888fe2f9b8ca1c641470703b96a`. Logs y test histórico se conservan; no se atribuye un fix a esa retirada. El runtime, escenas, tests y baseline portable vuelven exactamente al paquete `79d63e3`.

**HIPÓTESIS de implementación, no decisión aprobada:** coordinar comprobaciones del volumen del arma contra geometría con la traslación del jugador y el giro, evitando penetración sin cambiar el transform relativo ni el aspecto del arma. Hay que cubrir contacto lateral, esquinas, pitch y poses animadas, permitir separarse de la pared y evitar bloqueo permanente. La respuesta exacta al contacto requiere diseño de esa coordinación; no basta añadir un collider suelto al mesh ni agrandar indiscriminadamente el cuerpo.

La devolución inicial a Claude se hizo conforme al reparto de roles. Posteriormente el creador pidió expresamente a Codex solucionar este mismo fallo y aportó una captura; ese encargo directo autoriza la implementación de este bug B1 manteniendo D-030. No autoriza otro lote.

## Corrección y regresión ejecutadas

Fix `1401e05269fc4919f3658788e7de48bc5a4aa148`. Nuevo `scripts/player/weapon_wall_guard.gd` conectado desde `b1_player.gd`: CollisionShape3D convexa hija del CharacterBody3D, construida de las cajas existentes y sus poses de animación. `move_and_slide` detiene la traslación; consultas del volumen barrido, subdivisión angular y búsqueda del contacto limitan yaw/pitch. Permite girar en dirección libre, apartarse y deslizarse. El volumen cubre toda la animación; puede detenerse antes de que la pose de reposo llegue a tocar, reservando espacio para recarga/retroceso.

No se modifica el transform `(0.32, -0.28, -0.55)`, escala 1, cámara relativa, mallas, materiales, animaciones, Hitbox ni escenas. No se oculta el arma ni se dibuja encima de la pared. El guard está limitado a esta fixture y sus animaciones lineales; futuras armas/rotaciones de huesos requieren su propia cobertura.

Tests `f9f215b59b99e1d7b967db274db977de5f7727b4`: `tests/b1/integration/weapon_wall_test.gd`, siete casos con paredes físicas y consultas independientes de las cajas visibles: dash, strafe/deslizamiento/retirada, yaw rápido con inicio/final libres pero arco bloqueado, techo/pitch y vuelta, esquina diagonal con poses animadas, pasillo estrecho, transform/recarga intactos. El test anterior de contención dentro de la cápsula no se reutiliza.

- Antes del fix: [intento 04](../evidence/attempt_04/summary.json), runner exit 1; integración exit 100, 29/35 casos ejecutados, uno fallido con dos aserciones, seis no ejecutados por fail-fast. La [suite nueva completa con -c](../evidence/attempt_04/red_full/reports/report_1/results.xml) ejecutó 7 casos: 5 fallidos, 2 PASS, 10 aserciones fallidas. Import, 37 unitarias y smoke PASS; regresión completa no ejecutada en esta fase roja.
- Después: [intento 05](../evidence/attempt_05/summary.json), runner exit 0. Unitarias 37/37 e integración 35/35, 0 fallos/errores/omitidos; importación, smoke 600 frames, estático y regresión H1/H03/H04 PASS. H1 34 PASS / 0 FAIL / 1 NOT_RUN, negativo GdUnit esperado exit 100. Misma suite, sin relajar aserciones; comparación de tests/visuales en [metadata](../evidence/attempt_05/metadata.json).

El creador debe detener la ejecución previa y volver a F6 para cargar el fix. Repetir M-02 y revisar M-03/M-06 junto a muros/esquinas, disparando/recargando y girando. Validación visual/sensación aún pendiente; no cierre manual ni aprobación de B1 por el PASS automático. D-029 (cámara de muerte futura) sigue fuera del fix.

## Confirmación y cierre

El creador respondió «Perfecto, funciona» y aprobó B1. [Aprobación](../APPROVAL.md). El bloque anterior de pasos pendientes describe la entrega previa; el bug está cerrado. La integración posterior conserva el fix en el jugador compartido y sus siete regresiones. No se altera la petición futura D-029.
