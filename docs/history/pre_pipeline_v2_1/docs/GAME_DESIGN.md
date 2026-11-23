# GAME_DESIGN — Reglas funcionales consolidadas
**Versión:** 0.9 · 2026-11-20. `APROBADO` identifica decisiones explícitas. `PENDIENTE` no autoriza a Codex a inventar datos.

## Combate y carga [APROBADO]
- Tres armas cualesquiera, sin bloqueos por clase/categoría; selecciones antes del contrato.
- Ninja: katana, pistola silenciada, rifle silenciado con mira. Tanque: espada-sierra, revólver, escopeta doble cañón. Son identidades recomendadas, no restricciones.
- Munición de reserva infinita; cargadores y secuencias de recarga. Disparos/ataques se desbloquean por finalización de animación/estado de recuperación, no cadencias independientes sin animación.
- Escopeta: modo un cañón y modo doble. Katana: desvío automático con arma equipada. Mejoras físicas independientes de perks.

## Salud/energía [APROBADO]
- Salud 0–100, energía 0–150; HUD rojo y azul.
- Enemigo normal es ejecutable si debilitado, aturdido o no detectó al jugador. Tanque requiere armadura rota o debilitamiento. Ejecución válida siempre elimina objetivo.
- Mantener F durante extracción para obtener energía proporcional al tiempo; el daño recibido se reduce durante la extracción y no la interrumpe salvo muerte (D-007). No implica que recibir daño reduzca la energía obtenida.
- Mantener E cura continuamente mientras consume energía. Ascensor recarga energía completa a 150.
- Ultimate equipable única; puede activarse con energía >=100; consume toda energía disponible (100–150). Energía extra solo aumenta duración. Dead Eye mundo al 50% excepto jugador (valor inicial), con cualquier arma; Aimbot asistencia intensa a cabeza visible, requiere disparo manual; Overdrive aumenta cadencia/potencia de armas de fuego. La compatibilidad limita solo efectos específicos de arma, no el efecto global de Dead Eye (D-009 revisada).

## IA y sigilo [APROBADO]
- Los tres arquetipos patrullan; percepción visual/auditiva, sospecha, investigación, combate y búsqueda tras romper visión; enemigos conservan memoria de detección/última posición; pueden perder contacto y retornar al sigilo.
- Cámaras, alarmas y detección de cadáveres. Jefe Yakuza dos fases, shurikens, cambia patrón.
- Excepción D-003 revisada: una alarma general impide recuperar el sigilo durante el resto de ese intento. Antes de alarma general se conserva el retorno tras perder contacto.

## Progresión [APROBADO]
- Créditos única moneda, contrato Yakuza repetible con pago base y bonus por objetivos variados de sigilo/combate.
- Tres plantas (infiltración, combate, boss), ascensores entre plantas con recarga hasta 150, tiempo meta 15–25 min; dificultades fácil/normal/difícil.
- Derrota reinicia contrato, conserva compras/mejoras/firmware/trofeos. Al derrotar boss: trofeo + flag de shurikens futuro.
- Firmware en árbol con prerequisitos, créditos y sin límite comprado. Efectos activos solo al instalar USB, no al comprar (D-006 revisada); respec reembolsa y desactiva/retira perks reembolsadas. Mezcla estadísticas y efectos mecánicos.
- Guarida física, ordenador tienda/contratos, timbre, paquete transportable, montaje 3–4 interacciones, instalación USB, pared loadout, vitrina. Equipo inicial: katana, pistola silenciada y escopeta doble cañón.
- Guardado automático en compras, mejoras y final de contratos; estado persistente entre sesiones.

## Presentación artística [APROBADA · D-017]

La presentación de estas mecánicas sigue **Modern PSX / Retro Industrial Cyberpunk** (D-017), detallada en [ART_BIBLE](ART_BIBLE.md): siluetas, señales, animaciones y HUD legibles, con efectos retro potencialmente perjudiciales configurables o desactivables. Salud roja y energía azul conservan su regla aprobada. PRE-H03 no cambia ninguna mecánica, control ni cifra de este documento.

## Propuestas históricas NO APROBADAS

- Daño/HP sugeridos: katana 35; pistola 30; rifle 90; espada-sierra 60; revólver 75; escopeta 8x12; squishy 60, tirador 80 y tanque 150 HP + 100 armadura.
- Energía 20/s, tope 60 por ejecución, curación 25 HP/s por 25 energía/s, reducción 50%; ultimate 6–10 s de duración. Estos números están por testar y **NO** se consideran requisitos.
- Tres ramas REFLEX/ASSAULT/SYSTEM y 12 perks son propuestas, no decisiones.
- Las tablas previas de compatibilidad de ultimates son propuestas; hay que aprobarlas.

## Contradicciones o detalles por resolver
- F manteniendo: duración de la ejecución, momento exacto de matar, cuándo termina y cuánto concede si se suelta antes; impedir exploits de pulsaciones repetidas.
- E curación y E interacción: prioridad contextual y conflicto de controles.
- Katana deflexión automática: ¿bloquea todo tipo de proyectil? ¿consume recurso? ¿qué significa «rebote» en upgrades? Controlar poder y animación.
- Cada perk instalada activa permanentemente versus respec: «permanente» significa hasta reembolso, no que siga activa tras recuperarse créditos.
- Al morir y después de ganar: qué se guarda durante ejecución en curso y cómo preservar créditos si el juego cierra antes de instalar una compra.

## Auditoría H02 · 2026-11-20

Estado de implementación: solo greybox H1 descrito en [ARCHITECTURE](ARCHITECTURE.md). Los apartados aprobados de este documento son requisitos del MVP, no funcionalidades ya implementadas.

**APROBADO por el creador:** firmware al instalar USB (P-008), alarma general bloquea retorno al sigilo durante el intento (P-009), Dead Eye global con cualquier arma y compatibilidad solo en efectos específicos (P-010). **PENDING_APPROVAL para sus hitos:** duplicados de loadout (P-011), política de ascensor/retorno (P-013) y liberación temprana de F (P-014). No se implementan en H02. [Auditoría completa](DOCUMENTATION_AUDIT.md).

Corrección editorial: la frase ambigua sobre daño durante extracción se aclara con D-007, sin alterar su regla. [Versión previa íntegra](history/pre_h02/docs/GAME_DESIGN.md).
