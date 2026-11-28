# Revisión manual del creador — B1 — 2026-11-27

Fuente: mensajes y respuestas expresas del creador en esta conversación. Las pruebas las realizó el creador; Codex solo registra su informe. No se recibieron capturas, vídeos, cronometrajes ni un SHA escrito por el creador.

Contexto local inspeccionado al recibir el informe: rama `B1`, HEAD `79d63e3d6b5c0ea87f88dac55e33f11ddef9d7c1`, sin cambios versionados y con 24 `.gd.uid` generados por Godot. Su runtime coincide con el candidato automático `94e4880b03b60d1517917d11ab98dce786499d69`. Esta asociación procede del checkout inspeccionado; **no es una confirmación independiente del SHA de la sesión jugada**.

## Resultados comunicados

| ID | Resultado comunicado | Observación y alcance |
|---|---|---|
| M-01-DASH | PASS | Tras la línea inicialmente incompleta: «OK, ventana bien». Aceptación de la sensación en esta prueba; no fija balance definitivo. |
| M-02-WALL | FAIL | «No atravieos la pared pero mi arma si». El cuerpo se detiene; el arma atraviesa visualmente. [BUG-B1-02](../../bugs/BUG-B1-02.md). |
| M-03-MOVE | PASS | «Movimiento: OK». |
| M-04-INTERACT | PASS | «F/E: /OK». |
| M-05-REGEN | PASS | «Regeneración: OK». No se aportaron tiempos medidos. |
| M-06-COMBAT | PASS | «Disparo: OK». |
| M-07-DEATH | PASS en el alcance B1 | «No puedo moverme pero si la camara». Se registra el OK del creador y su petición futura D-029; el bloqueo de cámara no era un criterio expreso de este caso. |
| M-08-H1 | PASS tras aclaración | El KO inicial se debía a que H1 usa Q en vez de WW. Se explicó que F5 ejecuta H1 histórico y F6 el sandbox B1. Al preguntar por movimiento, cinco blancos y R respondió: «Sí, el resto funciona». Q es el binding esperado de esta regresión. |

Son respuestas a la guía manual resumida. No se atribuyen a Codex ejecuciones manuales ni se inventan mediciones u observaciones adicionales. Los NOT_RUN de los intentos automáticos 01/02 se conservan como registros anteriores a estas respuestas.

## Petición futura al morir

Texto del creador: «En el futuro, al morir (quiero que lo dejes anotado) quiero que la camara pase de primera a twercera persona y se aleje hacia arriba un poco y se vea le cuerpo del protagonista tumbado en el suelo (creo q en el cs 1.6 era asi)».

Se registra [D-029](../../../../docs/DECISIONS.md): transición a tercera persona, alejamiento y pequeña elevación, mostrando el cuerpo tumbado. Referencia de intención recordada por el creador, sin afirmar cómo funcionaba ese otro juego ni copiar sus assets. Implementación futura, sin lote iniciado; duración, distancia, colisiones de cámara y técnica de animación/cuerpo pendientes de concretar.

## Restricción expresa para corregir el arma

Texto del creador: «Continua, pero es muy importante que no camies el posicionamiento del arma o la manera ne que se ve. Es importante que cuando el arma toque la pared, esta no pueda travesarla.»

[D-030](../../../../docs/DECISIONS.md) y BUG-B1-02: mantener posición, escala, encuadre y aspecto del arma; resolver el contacto físico con la pared. No usar reducción/reubicación del modelo, ocultación ni dibujo por encima de la pared como solución. Codex no llegó a modificar el arma. Retiró la prueba experimental de contención dentro de la cápsula porque imponía una solución incompatible con esta aclaración.

## Estado y siguiente paso

**VALIDATION_FAILED** por M-02; siete resultados OK comunicados, un KO abierto. Sin aprobación final de B1, sin merge a main ni inicio de B2. Claude debe corregir BUG-B1-02 manteniendo D-030; Codex repetirá automáticas/regresiones sobre el nuevo SHA y el creador repetirá paredes y las manuales afectadas por el fix.
