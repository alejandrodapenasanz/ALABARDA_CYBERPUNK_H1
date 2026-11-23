# BALANCE_PROVISIONAL — configuración prevista, no balance final

**v2.1 · 2026-11-22.** Reglas según D-023–D-027; valores iniciales de prueba, todavía no trasladados a Resources. Migración aprobada (D-028), B1 NOT_STARTED.

## Salud y energía

| Clave conceptual futura | Valor | Clasificación |
|---|---:|---|
| health_max | 100 | APPROVED_RULE |
| energy_max | 150 | APPROVED_RULE |
| energy_passive_cap | n/a | SUPERSEDED por D-027 (sin pasiva energética) |
| ultimate_activation_min | 100 | APPROVED_RULE |
| dead_eye_world_scale | 0.50 | APPROVED_RULE inicial, D-009 |
| health_auto_regen_delay_s | 5.0 | PROVISIONAL_VALUE / PENDING_PLAYTEST |
| health_auto_regen_hp_per_s | 5.0 | PROVISIONAL_VALUE / PENDING_PLAYTEST |
| health_manual_heal_hp_per_s | 25.0 | PROVISIONAL_VALUE / PENDING_PLAYTEST |
| health_manual_energy_cost_per_s | 25.0 | PROVISIONAL_VALUE / PENDING_PLAYTEST |
| energy_passive_regen_per_s | 0 | APPROVED_RULE (D-027: energía solo por bajas y ascensor) |
| energy_per_kill | 15.0 | PROVISIONAL_VALUE / PENDING_PLAYTEST |
| manual_heal_pauses_auto_regen | true | PROVISIONAL_VALUE / PENDING_PLAYTEST |
| ultimate_duration_at_100_s | 6.0 | PROVISIONAL_VALUE / PENDING_PLAYTEST |
| ultimate_duration_at_150_s | 10.0 | PROVISIONAL_VALUE / PENDING_PLAYTEST |
| dash_double_tap_window_s | sin cifra fijada | PENDING_PLAYTEST; configurable, propuesta al implementar H05 |

Salud 0–100 y energía 0–150 independientes. Salud automática tras **5 s sin daño** a **5 HP/s**, sin energía; daño reinicia espera, muerto no regenera. E mantenida: **25 HP/s por 25 energía/s**, solo coste de HP recuperado, sin gasto a salud llena, termina al soltar/agotar energía/morir; daño no cancela si sobrevive. Manual activa pausa automática (provisional). **Sin energía pasiva** (D-027): la energía solo sube por bajas confirmadas del jugador, **+15 hasta 150**, y por ascensor; sin curación directa de HP. **Tasas, tiempos y pausa: PROVISIONAL_VALUE / PENDING_PLAYTEST.** F extracción SUPERSEDED. Ascensor: energía 150, HP intacto. Ultimate >=100 energía, consume toda; duración según energía anterior al consumo. [Contrato detallado](HEALTH_ENERGY_CONTRACT.md).

## Relaciones para los tests futuros

- Manual: `hp_real = min(hp_faltante, tasa_hp*dt, energia_disponible*tasa_hp/tasa_energia)`; coste `hp_real*tasa_energia/tasa_hp`. Tasas inválidas/no finitas se rechazan en configuración. Sin redondeo que regale salud, negativos ni consumo con HP lleno. Aislar fuentes de energía en unitarias; integrar simultaneidad en H08.
- Energía: sin pasiva (D-027); el tiempo nunca la aumenta. Bajas: sumar una vez y clamp150. 95+15=110,145+15=150.
- Ultimate: `duracion(E_pre)=6+(E_pre-100)*4/50` para100–150, fórmula **provisional**; consumir todo después de capturar valor. Solo duración escala.
- Automática: espera desde último daño válido; muerto no regenera; manual activa pausa la tasa, no inventa un nuevo retraso al soltar.
- Una acción por animación; sin doble daño por señales repetidas. Dificultad configurable no cambia créditos persistentes.

## Otros valores heredados de prueba

No son decisiones definitivas. H1 real conserva pistola35, blancos35/70 y recuperación0.23 s; no sustituirlos silenciosamente por esta tabla.

| Identificador histórico | Valor | Estado original, no definitivo |
|---|---:|---|
| walk_speed_mps | 8.5 | H1 propuesta |
| sprint_speed_mps | 12.5 | H1 propuesta |
| dash_speed_mps | 22 | H1 propuesta |
| dash_duration_seconds | 0.16 | H1 propuesta |
| dash_cooldown_seconds | 1 | H1 propuesta |
| katana_damage | 35 | Hipótesis |
| pistol_suppressed_damage | 30 | Hipótesis |
| pistol_magazine | 12 | Hipótesis |
| rifle_suppressed_damage | 90 | Hipótesis |
| rifle_magazine | 5 | Hipótesis |
| chainsword_damage | 60 | Hipótesis |
| revolver_damage | 75 | Hipótesis |
| revolver_magazine | 6 | Hipótesis |
| shotgun_pellet_damage | 12 | Hipótesis |
| shotgun_pellets_per_barrel | 8 | Hipótesis |
| shotgun_magazine_shells | 2 | Aprobado conceptualmente doble cañón; capacidad de 2 hipótesis concreta |
| enemy_squishy_hp | 60 | Hipótesis |
| enemy_ranged_hp | 80 | Hipótesis |
| enemy_tank_hp | 150 | Hipótesis |
| enemy_tank_armor | 100 | Hipótesis |

Dash futuro: ventana, velocidad, duración y cooldown configurables; no asumir aprobados los valores H1. Perks, costes, headshots, IA y boss se concretan en sus hitos; no inventar multiplicadores. Todo cambio registra fecha/motivo/playtest. PASS de fórmula no demuestra diversión.

## Resource H03: legado conservado, no contrato nuevo

[BalanceProfile](../scripts/config/balance_profile.gd) y [provisional.tres](../resources/balance/provisional.tres), esquema1, existen y no están conectados a H1. Conservan `player_max_hp`, tasas antiguas y campos `extraction_*`. Extracción temporal/protección/cap por objetivo **SUPERSEDED** como parámetros de energía; sus fórmulas se retiran de la sección vigente y quedan en el [original histórico](history/pre_pipeline_v2_1/docs/BALANCE_PROVISIONAL.md).

La migración actual no modifica esos archivos ni sus tests. H06 adaptará salud/datos; H08 energía/E; H09 ultimates, con mapeo/migración de claves y actualización explícita de tests obsoletos. No suponer que `health_max` ya existe en el Resource. Tests H03 de schema/clamps siguen evidencia del legado, nunca PASS de las nuevas mecánicas. [Arquitectura](ARCHITECTURE.md) y [pruebas](HEALTH_ENERGY_TEST_CASES.md).
