# Casos de aceptación de dos barras

**2026-11-23 · especificaciones, todos NOT_RUN.** No son tests implementados ni resultados de esta migración. Claude los concretará en fixtures/escenas/comandos por lote; Codex los ejecutará sobre SHA exacto. [Contrato](HEALTH_ENERGY_CONTRACT.md), [balance](BALANCE_PROVISIONAL.md). Tasas/tiempos son PROVISIONAL_VALUE / PENDING_PLAYTEST; assertions sobre hipótesis no aprueban balance.

Usar reloj controlado y aislar fuentes no relevantes (no existe pasiva energética, D-027). En integración añadir simultaneidad y orden de eventos. `dt=0`, deltas partidos/grandes, no finitos/config inválida y límites deben estar cubiertos en los casos pertinentes. Tolerancia numérica documentada, sin redondeos que regalen curación. Muerte no se confunde con respawn de H1.

| ID | Precondición / acción | Resultado exigido | Hito que lo entrega |
|---|---|---|---|
| SB-01 | HP inicial100; daño válido10; daño negativo/no finito; daño letal | HP90 tras válido, inválidos no alteran, límite0–100 y muerte única al0 | H06 |
| SB-02 | Vivo HP50, daño en t0; avanzar hasta antes de5 s | Sin regenerar antes del retraso5 s provisional | H06 |
| SB-03 | HP50, espera5 s completada; avanzar1 s sin daño | +5 HP provisional; misma suma con pasos de tiempo partidos | H06 |
| SB-04 | Regenerando, recibir daño válido; avanzar4.9 s | Espera reiniciada, sin regenerar hasta nuevo retraso | H06 |
| SB-05 | HP99, regeneración habilitada durante1 s/gran delta | HP100 como máximo, nunca sobrecura | H06 |
| SB-06 | HP0/muerto, avanzar espera y mantener acciones | Sin autoHP ni resurrección por regeneración | H06 |
| SB-07 | HP50, energía de fixture0/100/150, autoHP habilitada | Misma regeneración HP; energía intacta, sin coste ni ganancia | H06; integración H08 |
| SB-08 | HP50/E100, mantener E1 s; autoHP aislada | HP75/E75 por tasas25/25 provisionales, curación continua | H08 |
| SB-09 | Mantener E0.2 s y soltar | 5 HP/5 energía consumida mientras activa; nada manual después | H08 |
| SB-10 | HP50/E0, mantener E durante5 s sin bajas | Sin curación manual; energía sigue0 (sin pasiva, D-027) y nunca negativa; no falsear actividad | H08 |
| SB-11 | HP100/E50, mantener E | Ningún gasto ni sobrecura | H08 |
| SB-12 | HP99/E10 por1 s; después HP50/E2 | Primer caso100/9; segundo como máximo52/0; solo coste real | H08 |
| SB-13 | E activa, daño no letal y luego letal | No letal no cancela manual; letal termina, sin curar muerto | H08 |
| SB-14 | AutoHP elegible; manual activa y luego soltar | No suma5+25; pausa auto durante manual, puede reanudar al soltar si espera cumplida | H08 |
| SB-15 | Cerca/lejos de interactuable, mantener E e inyectar interact | E conserva curación y nunca ejecuta interacción; interacción en F (D-027) | H05 contrato; H08 real |
| SB-16 | Energía0/99/100/150/151 y consumo/suma extremos | Mantener0–150, validar datos inválidos; HP independiente | H08 |
| SB-17 | E0, E90 y E110, vivo, con y sin combate durante10 s sin bajas | Energía no cambia: sin regeneración pasiva (D-027) | H08 |
| SB-18 | Una baja confirmada con E50,95,110; repetir evento | 65,110,125 una vez; igual por arquetipo, HP intacto | H08; integración IA H10 |
| SB-19 | E145 y una baja | E150, no160 | H08 |
| SB-20 | Vivo E100, esperar sin bajas | Sigue100; esperar no completa150 | H08 |
| SB-21 | E110, gastar hasta90 mediante E; después esperar vivo sin bajas; luego una baja | Sigue90 durante la espera; la baja la sube a105 | H08 |
| SB-22 | Salud100, mantener E; energía50/150 y tiempo/baja | Sin consumo adicional por curación con salud completa; fuentes respetan límites, sin sobrecarga | H08 |
| SB-23 | Ultimate equipada, vivo, energía0/99/100 |0/99 rechaza sin gasto;100 permite, sin depender de HP máximo | H09 |
| SB-24 | Activar con100/125/150 | Consume todo a0; duración calculada antes del consumo,6/8/10 s provisionales; no escala potencia | H09 |
| SB-25 | Daño válido a HP100/E120, aislando fuentes; HP100/E99 y HP1/E100 para ultimate | Daño reduce solo HP, energía120 intacta. Salud llena no activa la primera ultimate; la segunda permite estando vivo. E compite por energía, autoHP no | H08/H09 |
| SB-26 | Muerto; mantener E, avanzar tiempo, confirmar baja/activar ultimate | Sin curación/regen/baja energética/ultimate mientras muerto | H06 salud; H08/H09 conjunto |
| SB-27 | HP30/100 y energía0/99/110/150; usar ascensor | Energía150 y HP idéntico; excepción explícita a100–150 por bajas | H19; H08 contrato con doble |
| SB-28 | Combatir, matar, regenerar, curar y activar sin F | Bucle completo sin extracción ni recogida manual de energía | H08/H09; E2E H22 |
| SB-29 | Revisar Resource/tests/guías heredados al migrarlos | Casos de F identificados SUPERSEDED; no contarlos como aceptación ni PASS de diseño actual; conservar evidencia histórica | H06/H08 y H22 |

Para E y bajas simultáneas, H08 añade test que verifica la aportación de la baja y el coste real de la curación en el mismo frame. Para energía al matar, emitir evento único atribuido al jugador; señal repetida no duplica recompensa. AutoHP no depende de kill. Los casos SB-23/24 también deben probar restauración de relojes/efectos tras muerte/final, oclusión Aimbot/sin auto-fire y bonus por arma según H09.

Manual humano: demostrar delay/reset de HP, curación E junto a un objeto, barras legibles en combate,95→110 por baja, espera en100, ultimate y ascensor. Handoff debe fijar escena/control/datos/pasos exactos cuando existan. H06 no programa EnergySystem/E/H09 para satisfacer estos casos: usa interfaces/dobles y deja integración futura NOT_RUN.
