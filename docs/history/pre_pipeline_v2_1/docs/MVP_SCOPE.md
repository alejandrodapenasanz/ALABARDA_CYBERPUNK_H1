# MVP_SCOPE — Vertical slice contractual
**Versión:** 0.9 · 2026-11-20 · **Estado:** revisión previa al cierre formal.

## En alcance (APROBADO)
- PC/Windows, Godot 4, FPS 3D; estética consistente **Modern PSX / Retro Industrial Cyberpunk** según D-017 y [ART_BIBLE](ART_BIBLE.md): identidad retro con legibilidad moderna, sin emulación literal de PS1. Efectos retro potencialmente perjudiciales configurables o desactivables.
- Movimiento ágil para todos; builds mediante armas/firmware, Ninja destaca en movilidad y Tanque en resistencia.
- Tres slots para **tres armas cualesquiera**, sin restricciones por categoría.
- Seis armas: katana, pistola silenciada, rifle silenciado con mira; espada-sierra, revólver potente, escopeta doble cañón con disparo de uno o ambos cañones.
- Munición de reserva ilimitada, cargadores y recargas con animaciones; ataques gobernados por recuperación/animación.
- Katana con desvío automático de balas cuando está equipada (detalle preciso de proyectiles compatibles, efecto y balance PENDIENTE).
- Salud 0–100 (D-007). Brazo cyborg: energía 0–150; extracción con F proporcional al tiempo mantenido al ejecutar enemigos elegibles; reducción de daño durante extracción; no se cancela por daño salvo muerte. Enemigos normales ejecutables debilitados, aturdidos o sin detectar; tanques tras romper armadura o debilitar.
- Curación continua manteniendo E, consume energía. Ascensores recargan energía completamente hasta 150.
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
1. Valores de balance y dificultad: salud/daño de armas/enemigos, headshots, duración/coste por segundo de ejecución y curación, protección durante extracción, duración y valores exactos de ultimates, cadencia/magazines, parámetros de movimiento, dash.
2. Árbol concreto de perks: nodos/efectos/umbrales/costes, refund y dependencias en cadena; mejora de deflexión de katana compatible con desvío base.
3. Máquina de estados y alcance de alarma/cámaras/cadáveres; comunicación, cobertura y reset tras muerte.
4. Economía: créditos iniciales, precios, recompensa base, objetivos y bonus, prevención de bloqueos de progreso.
5. Armas: acciones de uso/recarga, comportamiento de escopeta doble modo y compatibilidades definitivas de cada ultimate.
6. Arte: dirección Modern PSX aprobada; validar paleta, resoluciones/filtros, presupuestos por categoría, iluminación, efectos y rendimiento en H03; selección/licencias y aprobación visual de assets/protagonistas siguen pendientes. Los números de ART_BIBLE son orientativos.
7. UX: teclas contextuales E, Q, F, menú, selección dificultad, tutorial, accesibilidad mínima, guardado roto, salida del contrato.
8. Política de autosave frente a compras entregadas pero no montadas; recuperación ante cierres inesperados.

## Definición de completado para el vertical slice (PROPUESTA)
Debe poder iniciarse una nueva partida, preparar loadout, comprar/recibir/montar/instalar, jugar contrato completo en cualquier dificultad, infiltrarse o combatir, superar jefe, cobrar extras, volver a guarida y observar persistencia después de reiniciar la aplicación. Tests de lógica, integración, importación, regresión y export Windows; revisión manual del creador. **No es suficiente compilar.**

## Estado H02 · 2026-11-20

La implementación actual sigue siendo H1. [Matriz de requisitos](DOCUMENTATION_AUDIT.md): P-008/P-009/P-010 resueltas por decisiones expresas del creador; P-012 corregida documentalmente. P-011/P-013/P-014 y balance siguen pendientes en sus hitos, sin imponer alternativas como requisitos. No se ha cerrado el alcance completo del MVP ni se han implementado sus mecánicas en H02.
