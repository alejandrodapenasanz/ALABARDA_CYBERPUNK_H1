# GAME_DESIGN — reglas funcionales vigentes

**v1.0 · 2026-11-22.** Diseño aprobado/solicitado no significa implementado. B1 en INTEGRATION_READY tras fix técnico de BUG-B1-02; B2–B8 NOT_STARTED; migración aprobada por el creador 2026-11-23 (D-028). [Decisiones](DECISIONS.md), [arquitectura real](ARCHITECTURE.md).

## Combate y loadout [APROBADO]

- Tres armas cualesquiera, sin bloqueos por clase/categoría; selecciones antes del contrato.
- Ninja: katana, pistola silenciada, rifle silenciado con mira. Tanque: espada-sierra, revólver, escopeta doble cañón. Son identidades recomendadas, no restricciones.
- Munición de reserva infinita; cargadores y secuencias de recarga. Disparos/ataques se desbloquean por finalización de animación/estado de recuperación, no cadencias independientes sin animación.
- Escopeta: modo un cañón y modo doble. Katana: desvío automático con arma equipada. Mejoras físicas independientes de perks.

## Salud, energía y ultimates

Salud 0–100 y energía 0–150 independientes. Salud automática tras **5 s sin daño** a **5 HP/s**, sin energía; daño reinicia espera, muerto no regenera. E mantenida: **25 HP/s por 25 energía/s**, solo coste de HP recuperado, sin gasto a salud llena, termina al soltar/agotar energía/morir; daño no cancela si sobrevive. Manual activa pausa automática (provisional). **Sin energía pasiva** (D-027): la energía solo sube por bajas confirmadas del jugador, **+15 hasta 150**, y por ascensor; sin curación directa de HP. **Tasas, tiempos y pausa: PROVISIONAL_VALUE / PENDING_PLAYTEST.** F extracción SUPERSEDED. Ascensor: energía 150, HP intacto. Ultimate >=100 energía, consume toda; duración según energía anterior al consumo. [Contrato detallado](HEALTH_ENERGY_CONTRACT.md).

Duración ultimate **6 s a100 / 10 s a150**, interpolación lineal **PROVISIONAL_VALUE / PENDING_PLAYTEST**. Dead Eye mundo/IA/proyectiles al50%, jugador normal y cualquier arma. Aimbot destaca cabezas visibles con asistencia intensa, respeta oclusión y requiere disparo manual. Overdrive potencia/cadencia firearms por animaciones. Una equipada; más energía solo duración, no potencia. [Contrato íntegro y remates pendientes](HEALTH_ENERGY_CONTRACT.md).

## Movimiento e inputs

WASD y dash WW/AA/SS/DD dentro de ventana configurable; cooldown, un dash por par, sin auto-repeat ni parejas mixtas. Disponible en todos los builds. 1/2/3 equipa slot, mismo equipado guarda, otro cambia directo. 1/2/3 son slots libres sin categoría (D-027); duplicados/vacíos P-011. E siempre curación; interacción con F (D-027). Tabla única y casos [CONTROLS](CONTROLS.md). H1 conserva Q dash/R reset y no se modifica en esta migración.

## Muerte: presentación futura (D-029)

Petición expresa del creador, 2026-11-27: al morir, transición de primera a tercera persona; cámara que se aleja y sube un poco mostrando al protagonista tumbado en el suelo. Dirección aprobada para el futuro, no implementada en B1. La cámara B1 todavía permite mirar muerto; movimiento, dash, interacción y disparo se bloquean. No hay instrucción de bloquear ahora el ratón.

Distancia/tiempos, colisiones de cámara y técnica para mostrar el cuerpo quedan pendientes de concretar; no se presupone ragdoll ni animación específica. Registrar la dependencia de cuerpo completo y presentación en H19/H23 sin iniciar esos hitos. No cambia la política de derrota/progreso.

## Arma B1 frente a paredes (D-030)

Conservar posición, escala, encuadre y aspecto del arma; cuando toque la pared no puede atravesarla. BUG-B1-02 tiene fix técnico `1401e05`, encargado directamente a Codex: una envolvente física cubre el arma y sus poses de animación; el movimiento y el giro se detienen antes de penetrar. Al tocar una pared hay que apartarse o girar en dirección libre. Pendiente de retest visual del creador. Reducir, desplazar, ocultar o superponer el arma sobre la pared no satisface el requisito.

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

Ascensores dejan HP intacto. Bajas del jugador aportan energía una sola vez sin premio extra por arquetipo. No persistir daño/alertas del intento como progreso; política detallada de reinicio/guardado P-005. Firmware sigue instalación USB y respec, sin añadir efectos nuevos sobre las barras por intuición.

## Presentación y pendientes

Modern PSX / Retro Industrial Cyberpunk, legibilidad y efectos opcionales según [ART_BIBLE](ART_BIBLE.md). D-019/D-020/D-021 son referencia experimental aprobada, no assets finales. HUD salud roja/energía azul con etiquetas y feedback distintos.

Balance, perks, compatibilidades/parry, niveles, economía, controles sin asignar, slots y remates: [DECISIONS](DECISIONS.md). Extracción F SUPERSEDED; no eliminar remates de combate sin decisión P-017. [Documento anterior íntegro](history/pre_pipeline_v2_1/docs/GAME_DESIGN.md) conserva fórmulas antiguas; no son requisitos actuales.
