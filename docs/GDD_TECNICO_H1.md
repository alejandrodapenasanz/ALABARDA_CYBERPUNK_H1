# ALABARDA STUDIOS — CYBERPUNK FPS

> HISTÓRICO · Nota añadida en H02 (2026-11-20). Se conserva debajo el contenido de v0.1. H2–H5 son la numeración antigua, no los hitos H02–H24 actuales. Sus propuestas y casillas sin ejecutar no sustituyen [DECISIONS](DECISIONS.md), [ROADMAP](ROADMAP.md) ni [VALIDATION](VALIDATION.md). [Original exacto](history/pre_h02/docs/GDD_TECNICO_H1.md).

## Documento de diseño técnico (TDD/GDD) v0.1 · 19/11/2026

**Estado:** preproducción y prototipo H1. **Plataforma:** PC/Windows. **Motor elegido:** Godot 4.x; GDScript; escenas 3D. **Nombre comercial:** pendiente.

## 1. Fuentes y alcance
Documento basado en el PDF original **JUEGO CYBERPUNK.pdf**, cinco páginas, aportado por el creador. Se distinguen tres etiquetas:
- **[PDF]** idea expresamente descrita por el creador.
- **[PROPUESTA]** decisión de diseño o implementación sugerida, aún modificable.
- **[H1]** elemento incluido en este prototipo.

## 2. Visión
- [PDF] Boomer shooter cyberpunk low-poly, referencia de ritmo: ULTRAKILL. Protagonista contratista mercenario cyborg con brazo izquierdo robótico.
- [PDF] Bucle casa → ordenador → contratos → vuelta a casa; se compran armas/firmware; compras físicas llegan en caja; la instalación de firmware utiliza USB y HUD estilo `apt install`; armas ensambladas en mesa; exposición en pared.
- [PDF] Dos fantasías compatibles: «one man army», tanque agresivo, y «ninja», precisión letal; permitir híbridos e incentivar la rejugabilidad.
- [PDF] Misiones divididas en salas; jefe final, objeto especial y trofeo para la vitrina de casa.

## 3. Pilares de diseño
1. **Combate satisfactorio:** el arma y sus animaciones gobiernan la cadencia; munición estándar no debe ser el factor principal de escasez [PDF].
2. **Energía como decisión:** extraerla acercándose, invertirla en curarse o en una ultimate [PDF].
3. **Dos estilos a través del equipo:** especializaciones por firmware y armamento, no clases bloqueadas [PDF + PROPUESTA].
4. **Progresión física en casa:** las compras pasan por entrega, montaje/instalación y exposición [PDF].

## 4. Movimiento — decisiones provisionales
- [PROPUESTA/H1] WASD, ratón, salto, sprint y dash direccional; base rápida con dash puntual para hacer viable el estilo ninja; el estilo tanque se implementaría con armadura/firmware posteriormente.
- [H1] Movimiento en `CharacterBody3D` y cámara hija; `move_and_slide()` y captura de cursor.
- [PROPUESTA] Cifras **solo de prototipo**: marcha 8.5 m/s, sprint 12.5 m/s, dash 22 m/s durante 0.16 s, recuperación de dash 1 s, salto 6 m/s.
- **Pendiente:** wall jump, bunny hop, deslizamiento, inercia, impactos al aterrizar. Ninguna de estas opciones aparece definida en el PDF.

## 5. Combate / armas
- [PDF] Cuerpo a cuerpo, pistolas, escopetas, rifles, armas contundentes/pesadas con penalización de recursos.
- [PDF] Una acción no se puede repetir hasta que concluya la animación de recuperación (corte/retroceso/pumpeo).
- [H1] Pistola provisional hitscan; 35 de daño; recuperación de 0.23 s emulada por temporizador **hasta tener animaciones reales**; munición ilimitada; raycast de cámara.
- [PROPUESTA] Sustituir el temporizador por estados `READY → ATTACK → RECOVERY → READY` con ventanas definidas por `AnimationPlayer` en H2/H3.
- [PROPUESTA] Arquitectura futura `WeaponData` (Resource: daño, alcance, animación, recoil, FX, coste de energía/munición cuando corresponda) y `WeaponController`.

## 6. Enemigos
- [PDF] Squishy: frágiles y habitualmente en grupo; distancia: poca vida y fomentan esquivas; tanque: mucha vida, armadura cambia/desaparece según vida. Jefe al final.
- [H1] Cinco blancos de prueba estáticos con daño periódico por proximidad/rango. Dos modelos de estadísticas (35 y 70 HP). Se destruyen al quedar a cero HP. **No hay IA de navegación ni ataques con proyectiles aún**.
- [PROPUESTA] H3: `EnemyBase` + estados idle/seek/attack/hit/death, telegráficos visuales, percepción, navegación, coberturas simples, armadura desmontable para tanques.

## 7. Salud, energía, brazo cyborg
- [PDF] Vida 0–100, rojo; energía 0–150, azul. Con F extraes energía del enemigo cuerpo a cuerpo y siempre lo matas al terminar la ejecución; cuánto mantengas F influye en energía recuperada. En ascensor, recarga mediante enchufe. Entre 100 y 150 se habilita una sola ultimate equipada; curación con E consume energía (rango 0–100).
- [H1] Vida 100 con HUD, daño y respawn simplificado. **Energía, ejecuciones, curación, ascensores y ultimate no implementadas todavía.**
- [PENDIENTE] Curación HP/energía, cuánto se extrae según duración de F, coste de ultimate, si se bloquea la curación cuando supera 100, invulnerabilidad durante ejecución, riesgo/recompensa, atajos E contextuales.
- [PROPUESTA] `EnergyComponent`, `HealthComponent`, `ExecutionController`, `UltimateController`; UI centralizada en HUD.

## 8. Casa / economía / misiones
- [PDF] Ordenador con tienda, entregas en puerta, cajas transportadas a mesa, montaje de armas, USB para firmware, pared y vitrina de trofeos.
- [PDF] Primer ejemplo de contrato: edificio de la Yakuza, varias plantas, jefe con shurikens, trofeo y desbloqueo de shurikens.
- [PROPUESTA] Estas experiencias se construirán después del núcleo de disparos para evitar implementar sistemas sin bucle de combate probado.
- **Pendientes sin especificar en PDF:** divisa, precios, pérdida de equipo, repetición de contratos, guardado, duración, estructura de progresión, contenido total.

## 9. Arquitectura técnica prevista
```text
Main / GameFlow
├── Arena (greybox H1)              → ContractScene (H5)
├── Player (CharacterBody3D)
│   ├── Camera3D / WeaponRay
│   ├── WeaponController             [futuro]
│   ├── Health / Energy              [futuro]
│   └── FirmwareLoadout              [futuro]
├── Enemies (EnemyBase)
├── HUD (CanvasLayer)
└── GameState / SaveData             [futuro]
```
- [H1] `main.gd`: crea arena, enemigos y HUD; `player.gd`: movimiento/disparo/salud; `enemy.gd`: daño y ataques periódicos.
- [PROPUESTA] Usar señales desacopladas para eventos, `Resource` para balance, escenas `.tscn` separadas cuando termine el greybox.
- [PROPUESTA] Versionar en Git y registrar decisiones en `docs/DECISIONES.md`.

## 10. Hitos y criterios de aceptación
| Hito | Resultado | Criterio verificable |
|---|---|---|
| **H1 — Greybox de combate** | Arena FPS con movilidad, pistola, cinco blancos y HUD | Moverse, apuntar, disparar, recibir daño, morir/reaparecer y completar arena |
| H2 — Brazo cyborg | Ejecución F, energía, curación E, primera ultimate | Balance de energía verificable mediante HUD y pruebas de límites |
| H3 — Combate completo | Enemigos con IA, 3 arquetipos y armas con animaciones | Tres combates distintos y cadencias controladas por animación |
| H4 — Casa | Ordenador, entrega, banco de trabajo, firmware, pared | Comprar → recibir → instalar/equipar → guardar progreso |
| H5 — Vertical slice | Contrato Yakuza con salas y jefe | Jugar contrato entero y volver a casa con recompensa |

## 11. Definición de terminado (DoD) de H1
- [ ] Proyecto abre en Godot 4.
- [ ] `F6` o `F5`: arena visible con primera persona, sin errores de ejecución.
- [ ] WASD, ratón, SHIFT, Q y salto responden.
- [ ] Disparos y enemigos con daños registrados; eliminación de cinco.
- [ ] HUD muestra vida y enemigos; muertes reinician salud/posición.
- [ ] Sin escenas o recursos externos de pago.

**Importante:** estos criterios están definidos, no se afirman aprobados. El proyecto no se ha ejecutado en el entorno de autoría con el editor Godot, por lo que la validación real está pendiente.
