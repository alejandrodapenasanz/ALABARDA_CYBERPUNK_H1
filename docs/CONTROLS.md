# Controles — contrato futuro y estado real

**Revisado 2026-11-28 · D-025/D-026/D-027/D-031; B1 APPROVED, B2 NOT_STARTED.** Controles del laboratorio separados del gameplay. [Curación E](HEALTH_ENERGY_CONTRACT.md).

| Acción | Decisión futura | Estado real / límite |
|---|---|---|
| Mover | WASD | APROBADA; existe en el juego actual |
| Dash | WW / AA / SS / DD | APROBADA; implementado en el juego normal F5; Q solo en la fixture histórica H1 |
| Curación | Mantener E, incluso junto a objetos | APROBADA; pendiente de H08, todavía sin implementar |
| Interacción | F (acción distinta de E, configurable) | APROBADA D-027; implementado y aprobado en el juego normal |
| Slot 1 | Seleccionar/guardar | APROBADA; slot libre sin categoría (D-027); H07 |
| Slot 2 | Seleccionar/guardar | Igual; H07 |
| Slot 3 | Seleccionar/guardar | Igual; H07 |
| Apuntar/disparar | Ratón/clic izquierdo actuales | Conservar compatibilidad; acciones por arma H07 |
| Salto/sprint | Espacio/Shift actuales | Continuidad H1; remapeo futuro |
| Recargar | Binding pendiente; el arma actual recarga sola al vaciarse | R solo repone blancos en la fixture histórica H1; no es binding de recarga aprobado |
| Ultimate | Binding pendiente | No asignar Q/F por deducción; H09 |
| Menú/pausa/cursor | Escape libera cursor en el juego actual | No pausa actualmente; detalle pendiente H16/H22 |
| Extracción | No existe | F mantenida para extraer SUPERSEDED; F pasa a interacción (D-027) |

## Dash

Dos eventos nuevos de la **misma tecla** dentro de una ventana configurable: WW adelante, SS atrás, AA izquierda, DD derecha. WA/WD y parejas mixtas no activan. Ignorar auto-repeat; un par como máximo un dash, sin reutilizar el segundo evento para duplicar activación. Cooldown configurable, colisiones y estados incompatibles de movimiento/animación; conservar desplazamiento normal. Ventana sin cifra aprobada: documentar una propuesta configurable al implementar y probar activaciones accidentales. Dash para todos los builds; perks futuros sujetos a aprobación.

## Slots

Desde sin arma, pulsar 1/2/3 equipa su asignación. Repetir el equipado guarda. Otro slot cambia directamente al destino respetando animación, sin desarmado artificial intermedio. Separar ID de slot y arma asignada. **Tres armas cualesquiera sigue vigente** (D-027): 1/2/3 son slots libres sin categoría, se admite cualquier combinación, incluidas tres armas cuerpo a cuerpo; duplicados/loadout incompleto P-011 pendiente. Un fixture vacío debe ser robusto sin aprobar salir al contrato con menos armas. Resolver inputs rápidos/simultáneos en orden determinista documentado y un único estado final.

## Casos y cobertura

CT-01…CT-05 y separación F/E de CT-06 se probaron y aprobaron en B1; la curación E de H08 y CT-07…CT-10 siguen pendientes de B2. Ver resultados por SHA en VALIDATION.

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

Claude prepara tests, escenas y pasos por lote; Codex ejecuta; creador valida sensación/legibilidad. La integración conserva los casos aprobados; sus resultados no se atribuyen a mecánicas futuras.
