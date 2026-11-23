# Pruebas manuales B1 — para el creador

Hazlas **después** de que Codex confirme que las pruebas automáticas pasan.
Godot 4.7.2 con la rama `B1` actualizada (`git pull` en la rama B1).

**Cómo abrir:** en el editor abre `scenes/b1/b1_sandbox.tscn` y pulsa **F6**. Solo la prueba 8 usa **F5**.
**Controles:** WASD mover · doble toque WW/AA/SS/DD dash · Shift sprint · Espacio saltar · F interactuar · E (reservada, no hace nada) · clic disparar · Esc libera el ratón, clic lo recaptura.
Arriba a la izquierda verás la barra de salud y una línea de estado: `ESTADO`, `DASH`, `ARMA` y `REGEN`.

En cada prueba marca **OK** o **KO**. Si es KO, escribe una línea con lo que pasó.

---

## 1. Dash por doble toque (M-01)
1. Camina con pulsaciones sueltas y con W mantenida unos 5 s → **no** debe haber dash.
2. Pulsa W W rápido → un dash adelante. Repite con A A, S S y D D.
3. Pulsa W y enseguida A → **no** hay dash.
4. Haz un doble toque mientras `DASH` muestra segundos (cooldown) → **no** hay dash.
5. Gira la cámara 90° y haz W W → el dash va hacia donde miras.
6. ¿La ventana de 0,25 s te parece corta, bien o larga?

- [ ] OK  - [ ] KO → ______  · Ventana: corta / bien / larga

## 2. Dash contra paredes (M-02)
1. Ponte a 2 m del muro gris del carril de la derecha, mirándolo, y haz W W varias veces.
2. Repite contra un muro exterior.
→ Nunca lo atraviesas y `ESTADO` vuelve a `SUELO`.

- [ ] OK  - [ ] KO → ______

## 3. Movimiento, sprint, salto y cámara (M-03)
1. Recorre el carril de marcas (cada raya es 1 m) andando y luego con Shift.
2. Salta al bloque bajo de la izquierda.
3. Mira arriba y abajo del todo.
→ Fluido, igual o mejor que H1, la cámara no da la vuelta.

- [ ] OK  - [ ] KO → ______

## 4. Interacción F frente a E (M-04)
1. Acércate a la consola morada sobre el pedestal y mírala: aparece `F · activar consola`.
2. Pulsa **E** → no cambia (aparece un aviso de tecla reservada).
3. Pulsa **F** → se pone verde. Pulsa F otra vez → vuelve a morado.
4. Aléjate más de 2,5 m y pulsa F → no pasa nada.

- [ ] OK  - [ ] KO → ______

## 5. Regeneración de salud (M-05)
1. Entra en la zona roja del suelo (abajo a la izquierda) hasta bajar a unos 70 y sal.
2. Cronometra: durante unos **5 s** no sube; después `REGEN SÍ` y sube unos **5 por segundo** hasta 100, y para ahí.
3. Repite y vuelve a entrar en la zona a mitad de la subida → se para y la espera vuelve a empezar.

- [ ] OK  - [ ] KO → ______

## 6. Disparo, zonas de impacto, armadura y recarga (M-06)
1. Dispara al cuerpo del blanco «BLANCO 60» → `IMPACTO CUERPO -35`. A la cabeza → `IMPACTO CABEZA -70`.
2. Mantén el clic hasta vaciar el cargador → `ARMA RECARGA` y vuelve a 12/12 solo.
3. Dispara al tanque → baja primero `ARM` y después la vida.
4. ¿Te gusta la cadencia como punto de partida?

- [ ] OK  - [ ] KO → ______

## 7. Daño por proyectiles y muerte (M-07)
1. Acércate a la torreta naranja (esquina del fondo a la derecha): sus bolas restan 8.
2. Combínala con la zona roja hasta llegar a 0.
3. Ya muerto, intenta moverte, disparar y pulsar F.
→ `HAS MUERTO` una sola vez, `ESTADO BLOQUEADO`, no te mueves, no disparas, no regeneras, y a los 3 s se reinicia.

- [ ] OK  - [ ] KO → ______

## 8. H1 sigue igual (M-08) · con **F5**
1. Muévete y haz dash con **Q**.
2. Elimina los 5 blancos y pulsa **R** para reiniciar.
→ Todo igual que antes de B1.

- [ ] OK  - [ ] KO → ______

---

## Devuélveme esto a Claude

Copia, rellena y pégamelo en el chat:

```
Pruebas manuales B1 (SHA de B1 probado: ________)
1 Dash: OK/KO — ventana corta/bien/larga — notas:
2 Paredes: OK/KO — notas:
3 Movimiento: OK/KO — notas:
4 F/E: OK/KO — notas:
5 Regeneración: OK/KO — notas:
6 Disparo: OK/KO — notas:
7 Muerte: OK/KO — notas:
8 H1: OK/KO — notas:
¿Apruebo B1?: SÍ / NO
```

Si todo es OK y apruebas B1, lo registro como aprobado y te digo cómo unir `B1` a `main`. Si hay algún KO, lo corrijo en `B1`.
