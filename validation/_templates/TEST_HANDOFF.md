# TEST_HANDOFF — plantilla (no paquete listo)

Copiar a validation/BXX/ al implementar un lote autorizado. Completar todos los campos; referencias cruzadas por ID con TEST_MANIFEST y TEST_RESULTS. No afirmar pruebas ejecutadas.

## A. Identificación

Lote / hitos / fecha / autor-rol / rama / **SHA completo candidato C** / SHA paquete P comunicado externamente / commit aprobado anterior / estado. Godot exacto esperado, OS, renderer, Python, framework y Blender solo si necesario. Sistemas afectados y alcance autorizado. P no puede contener su propio SHA; ver workflow.

## B. Funcionalidad entregada

Qué puede hacer el jugador y límites observables. Separar implementado, fixture/placeholder y futuro. No usar CODE_READY como prueba de funcionamiento en motor.

## C. Archivos

Lista completa nuevos/modificados/eliminados; escenas de entrada y tests, scripts, recursos, assets/licencias, documentación. Motivo por grupo y commit/checkpoint por hito.

## D. Dependencias

Sistemas/lotes/SHAs previos; interfaces estables; escenas/recursos obligatorios y rutas reales; herramientas/versiones; placeholders/fallbacks; funcionalidades de hitos futuros y decisiones bloqueantes. No inventar binding de interacción E.

## E. Pruebas automáticas (repetir ficha por ID)

ID / nombre / propósito / hito / tipo / criticidad técnica / datos y precondiciones / comando exacto como ejecutable+argv / cwd relativo a C / esperado / criterio PASS / criterio FAIL / timeout / dependencias de tests y entorno / ruta logs y otros artefactos en evidence/. Estado inicial NOT_RUN y motivo; quién puede ejecutar. Los tests/scripts indicados deben existir en C.

## F. Pruebas manuales Godot (repetir ficha por ID)

Escena exacta / abrir mediante import o escena del editor / ejecutar con F5 o F6 según corresponda / controles / estado inicial y datos / condiciones para repetir. Pasos numerados:

1. Preparar estado concreto.
2. Ejecutar acción concreta.
3. Observar y registrar resultado.

Esperado observable / fallo observable / captura o log requerido / alcance técnico o sensaciones del creador. No dejar frases como «probar que va bien». Sin captura: NOT_RUN con motivo.

## G. Regresiones

Hitos afectados y IDs/comandos; baseline de comportamiento y perfiles. Separar reglas H1 legadas de cambios explícitamente autorizados. No exigir matriz de dificultades antes de H13.

## H. Problemas conocidos

Bugs con ID/severidad/repro; limitaciones, decisiones pendientes y funcionalidades incompletas. Enlazar BUG_REPORT; marcar hipótesis. No ocultar fallos anteriores.

## I. Checklist del creador

- [ ] Movimiento, dash y controles: casos/escena concretos.
- [ ] Combate/curación/energía/ultimate cuando correspondan.
- [ ] Arte, animaciones, lectura HUD/feedback y UX según alcance.
- [ ] Dificultad/balance provisional y regresiones percibidas.
- [ ] Aceptación o rechazo expreso con fecha y SHA; no rellenar por el creador.

## J. Aceptación

Requisitos por hito; tests técnicos críticos PASS sobre mismo C, sin regresiones críticas; pendientes documentados. VALIDATED técnico separado de APPROVED humano. Lista explícita de qué bloquea cada puerta.

## K. Recuperación

SHA anterior aprobado y cómo abrirlo en worktree nuevo sin borrar trabajo/saves; aislar escena/fixture fallida; ruta de copia de datos de prueba si procede; cómo volver a validar fix. No reset --hard, force-push ni limpieza destructiva.
