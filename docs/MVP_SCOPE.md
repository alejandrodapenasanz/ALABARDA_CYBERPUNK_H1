# MVP_SCOPE — Vertical slice contractual
**Versión:** 1.0 · 2026-11-22 · migración aprobada por el creador 2026-11-23 (D-028); alcance final P-007.

## En alcance (APROBADO)
- PC/Windows, Godot 4, FPS 3D; estética consistente **Modern PSX / Retro Industrial Cyberpunk** según D-017 y [ART_BIBLE](ART_BIBLE.md): identidad retro con legibilidad moderna, sin emulación literal de PS1. Efectos retro potencialmente perjudiciales configurables o desactivables.
- Movimiento ágil para todos; builds mediante armas/firmware, Ninja destaca en movilidad y Tanque en resistencia.
- Tres slots para **tres armas cualesquiera**, sin restricciones por categoría.
- Seis armas: katana, pistola silenciada, rifle silenciado con mira; espada-sierra, revólver potente, escopeta doble cañón con disparo de uno o ambos cañones.
- Munición de reserva ilimitada, cargadores y recargas con animaciones; ataques gobernados por recuperación/animación.
- Katana con desvío automático de balas cuando está equipada (detalle preciso de proyectiles compatibles, efecto y balance PENDIENTE).
- Salud 0–100 y energía 0–150 independientes. Salud automática tras **5 s sin daño** a **5 HP/s**, sin energía; daño reinicia espera, muerto no regenera. E mantenida: **25 HP/s por 25 energía/s**, solo coste de HP recuperado, sin gasto a salud llena, termina al soltar/agotar energía/morir; daño no cancela si sobrevive. Manual activa pausa automática (provisional). **Sin energía pasiva** (D-027): la energía solo sube por bajas confirmadas del jugador, **+15 hasta 150**, y por ascensor; sin curación directa de HP. **Tasas, tiempos y pausa: PROVISIONAL_VALUE / PENDING_PLAYTEST.** F extracción SUPERSEDED. Ascensor: energía 150, HP intacto. Ultimate >=100 energía, consume toda; duración según energía anterior al consumo. [Contrato detallado](HEALTH_ENERGY_CONTRACT.md).
- Ultimates: una equipada, activación con >=100 energía, consume toda la disponible; más energía aumenta **solo duración**. Dead Eye: mundo al 50 % y jugador a velocidad normal (inicial), con cualquier arma. Aimbot: ayuda intensa a apuntar a cabezas visibles sin disparo automático. Overdrive: potencia/cadencia de armas de fuego. Compatibilidad limita los efectos específicos de arma, no la ralentización global de Dead Eye (D-009 revisada).
- Sigilo integral: patrullas de los tres arquetipos (squishy, tirador, tanque), visión, oído, investigación, búsqueda, retención de última posición, ruptura de contacto, retorno al sigilo; cámaras, alarmas y cadáveres detectables. Excepción D-003 revisada: tras una alarma general no se recupera sigilo durante ese intento.
- Contrato Yakuza único: tres plantas (infiltración, combate, boss), jefe de dos fases con shurikens y cambio de patrones, objetivo principal y secundarios variados de sigilo/combate, bonus económicos.
- Dificultad seleccionable: fácil, normal, difícil. Duración objetivo del contrato 15–25 min (**objetivo de diseño, no rendimiento medido**).
- Muerte: reinicia contrato desde comienzo, conserva equipamiento y progresión persistentes.
- Economía: créditos (única moneda), compras y mejoras; contrato repetible para ganar créditos.
- Guarida explorable: PC/tienda/contratos, timbre y paquete físico, transportar paquete a mesa, montaje de armas simplificado en 3–4 pasos, instalación USB/terminal de firmware, pared de armas para loadout, vitrina de trofeos.
- Firmware: árbol de perks con dependencias y coste en créditos; los efectos comienzan al instalar el USB y permanecen activos salvo respec; comprar no los activa (D-006 revisada). Sin límite total de adquisición; reinicio del árbol con reembolso; mezcla numérica y mecánica. Mejoras físicas de armas en sistema separado.
- Armas iniciales: katana, pistola silenciada, escopeta doble cañón. Otras comprables.
- Boss: trofeo y flag persistente de desbloqueo de shurikens como **arma futura**, no shurikens jugables en MVP.
- Guardado automático al comprar, mejorar, completar contratos. Persistencia de armas, firmware, créditos, loadout, ultimates y trofeos.
- Producción visual híbrida y progresiva: assets gratuitos legales seleccionados/adaptados, props propios en Blender, materiales/shaders y protagonistas personalizados; IA como apoyo conceptual. Licencia verificada y registrada antes de incorporar. Esta dirección no añade funcionalidades jugables.

## Fuera del MVP (PROPUESTA pendiente de confirmación explícita)
Mundo abierto, coches, cooperativo, contratos extra, facciones extra, árbol narrativo ramificado, shurikens jugables, personalización estética extensa, fabricación compleja, destrucción avanzada y múltiples idiomas.

Aclaración H02 (2026-11-20): la exclusión de shurikens jugables ya está aprobada en D-010 y en el punto de boss anterior; su repetición en esta lista no la vuelve propuesta. Las demás exclusiones de esta sección y el DoD final continúan pendientes bajo P-007.

## No cerrar sin concretar (PENDIENTE)
1. Valores de balance y dificultad: salud/daño de armas/enemigos, headshots, tasas/esperas de regeneración y curación, adaptación de remates P-017, duración y valores exactos de ultimates, cadencia/magazines, parámetros de movimiento, dash.
2. Árbol concreto de perks: nodos/efectos/umbrales/costes, refund y dependencias en cadena; mejora de deflexión de katana compatible con desvío base.
3. Máquina de estados y alcance de alarma/cámaras/cadáveres; comunicación, cobertura y reset tras muerte.
4. Economía: créditos iniciales, precios, recompensa base, objetivos y bonus, prevención de bloqueos de progreso.
5. Armas: acciones de uso/recarga, comportamiento de escopeta doble modo y compatibilidades definitivas de cada ultimate.
6. Arte: dirección Modern PSX aprobada; D-019–D-021 validan referencia experimental H03/H04; validar presupuestos finales por categoría, animaciones y rendimiento del contrato; selección/licencias y aprobación visual de assets/protagonistas siguen pendientes. Los números de ART_BIBLE son orientativos.
7. UX: E exclusiva de curación; interacción F (D-027), controles restantes, menú, selección dificultad, tutorial, accesibilidad mínima, guardado roto, salida del contrato.
8. Política de autosave frente a compras entregadas pero no montadas; recuperación ante cierres inesperados.

## Definición de completado para el vertical slice (PROPUESTA)
Debe poder iniciarse una nueva partida, preparar loadout, comprar/recibir/montar/instalar, jugar contrato completo en cualquier dificultad, infiltrarse o combatir, superar jefe, cobrar extras, volver a guarida y observar persistencia después de reiniciar la aplicación. Tests de lógica, integración, importación, regresión y export Windows; revisión manual del creador. **No es suficiente compilar.**

## Estado y entrega por lotes

H1–H04 APPROVED con evidencia histórica; B1–B8 NOT_STARTED. Dash WW/AA/SS/DD y slots 1/2/3 con toggle según [CONTROLS](CONTROLS.md); categorías no restringen tres armas cualesquiera. Remates pendientes de adaptación, no borrados al retirar F. [Workflow](DEVELOPMENT_WORKFLOW.md): Claude prepara código/tests sin Godot, Codex ejecuta sobre SHA exacto, creador valida. La agrupación no añade contenido al MVP ni cierra P-007.
