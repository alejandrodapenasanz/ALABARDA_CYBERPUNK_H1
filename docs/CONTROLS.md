# Controles — contrato futuro y estado real

**2026-11-22, revisado 2026-11-23 · D-025/D-026/D-027; B1/B2 NOT_STARTED.** Controles del laboratorio separados del gameplay. [Curación E](HEALTH_ENERGY_CONTRACT.md).

| Acción | Decisión futura | Estado real / límite |
|---|---|---|
| Mover | WASD | APROBADA; existe en H1 |
| Dash | WW / AA / SS / DD | APROBADA; implementado en B1 (CODE_READY, NOT_RUN); H1 aún usa Q |
| Curación | Mantener E, incluso junto a objetos | APROBADA; H08; no existe en H1 |
| Interacción | F (acción distinta de E, configurable) | APROBADA D-027; implementado en B1 (CODE_READY, NOT_RUN) |
| Slot 1 | Seleccionar/guardar | APROBADA; slot libre sin categoría (D-027); H07 |
| Slot 2 | Seleccionar/guardar | Igual; H07 |
| Slot 3 | Seleccionar/guardar | Igual; H07 |
| Apuntar/disparar | Ratón/clic izquierdo actuales | Conservar compatibilidad; acciones por arma H07 |
| Salto/sprint | Espacio/Shift actuales | Continuidad H1; remapeo futuro |
| Recargar | Binding pendiente; el arma fixture B1 recarga sola al vaciarse | R en H1 repone blancos tras vencer, NO recarga |
| Ultimate | Binding pendiente | No asignar Q/F por deducción; H09 |
| Menú/pausa/cursor | Escape libera cursor en H1 | No pausa actualmente; detalle pendiente H16/H22 |
| Extracción | No existe | F mantenida para extraer SUPERSEDED; F pasa a interacción (D-027) |

## Dash

Dos eventos nuevos de la **misma tecla** dentro de una ventana configurable: WW adelante, SS atrás, AA izquierda, DD derecha. WA/WD y parejas mixtas no activan. Ignorar auto-repeat; un par como máximo un dash, sin reutilizar el segundo evento para duplicar activación. Cooldown configurable, colisiones y estados incompatibles de movimiento/animación; conservar desplazamiento normal. Ventana sin cifra aprobada: documentar una propuesta configurable al implementar y probar activaciones accidentales. Dash para todos los builds; perks futuros sujetos a aprobación.

## Slots

Desde sin arma, pulsar 1/2/3 equipa su asignación. Repetir el equipado guarda. Otro slot cambia directamente al destino respetando animación, sin desarmado artificial intermedio. Separar ID de slot y arma asignada. **Tres armas cualesquiera sigue vigente** (D-027): 1/2/3 son slots libres sin categoría, se admite cualquier combinación, incluidas tres armas cuerpo a cuerpo; duplicados/loadout incompleto P-011 pendiente. Un fixture vacío debe ser robusto sin aprobar salir al contrato con menos armas. Resolver inputs rápidos/simultáneos en orden determinista documentado y un único estado final.

## Casos futuros (todos NOT_RUN)

| ID | Entrada | Resultado exigido | Hito |
|---|---|---|---|
| CT-01 | WW/AA/SS/DD dentro de ventana | Un dash en cada dirección | H05 |
| CT-02 | Dos iguales lentas; WA/WD | Movimiento sin dash | H05 |
| CT-03 | Tecla mantenida, auto-repeat, par en cooldown | Sin activación extra | H05 |
| CT-04 | Dash contra pared/estado incompatible | Sin atravesar ni estado imposible | H05 |
| CT-05 | Movimiento simple/sprint/salto/ratón | Regresión de movimiento y cámara | H05 |
| CT-06 | E junto a objeto e interacción separada | Sin doble comando; curación cuando exista H08 | H05/H08 |
| CT-07 | Desarmado → cada slot → mismo slot | Equipa y guarda correctamente | H07 |
| CT-08 | 1→2→3 con armas asignadas cualesquiera | Cambio directo sin categorías obligatorias | H07 |
| CT-09 | Slot vacío de fixture, inputs rápidos/simultáneos | Sin bloqueo ni duplicación | H07 |
| CT-10 | Recarga/recuperación y cambio de slot | Estados coherentes, sin disparo indebido | H07 |

Claude prepara tests, escenas y pasos por lote; Codex ejecuta; creador valida sensación/legibilidad. Esta migración no implementa ni ejecuta estos casos.
