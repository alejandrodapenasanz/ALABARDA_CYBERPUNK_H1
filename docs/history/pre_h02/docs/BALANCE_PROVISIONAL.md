# BALANCE_PROVISIONAL — hipótesis configurables, NO aprobadas
**Versión 1.0 · 2026-11-20.** Las decisiones de mecánicas aprobadas prevalecen sobre estos números. Codex no debe presentar estos valores como equilibrio validado. La primera tarea de H03 será trasladarlos a Resources/configs con cobertura de tests.

## Parámetros iniciales para pruebas
| Identificador | Valor prototipo | Motivo / estado |
|---|---:|---|
| player_max_hp | 100 | Aprobado en PDF |
| energy_max | 150 | Aprobado |
| ultimate_activation_min | 100 | Aprobado |
| dead_eye_world_scale | 0.50 | Aprobado como punto de partida |
| extraction_energy_per_second | 20 | Hipótesis |
| extraction_max_energy_per_target | 60 | Hipótesis; por definir cómo interactúa con tiempo F |
| extraction_damage_multiplier | 0.50 | Hipótesis, reduce daño en 50 % |
| heal_hp_per_second | 25 | Hipótesis |
| heal_energy_per_second | 25 | Hipótesis |
| ultimate_duration_at_100_seconds | 6 | Hipótesis |
| ultimate_duration_at_150_seconds | 10 | Hipótesis |
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

## Reglas matemáticas verificables
- Extraer: `energia_ganada = min(energia_maxima_por_objetivo - ya_extraida, tasa * delta_segundos)` y `energia_jugador = clamp(energia_actual + ganada, 0, 150)`; **resolver si la muerte se produce al soltar F o al completar un mínimo de animación** antes de implementarlo. Nunca dar energía tras ejecución concluida.
- Curar: `hp_nuevos = min(hp_faltante, energia_actual * hp_por_energia, velocidad_hp * dt)`; descontar la energía *realmente consumida*; evitar curación con HP máximo.
- Ultimate: `duracion(E) = 6 + (E-100) * 4/50` para E en [100,150]; todas consumen E completo al activar; aumentar solo duración, no potencia.
- Una acción por animación; no duplicar daño por múltiples señales del mismo fotograma.
- Dificultad: definir multiplicadores por recurso (daño recibido, percepción, HP, agresividad) en configuración sin alterar el saldo persistente ni los estados de compra; fijar tabla en H22 después de playtest.

## Reglas operativas
1. Parámetros numéricos en archivos editables con validación de rangos; no hardcodear números en 12 scripts.
2. Toda variación de balance debe indicar motivo, fecha y resultados de prueba.
3. `PASS` de una prueba de fórmula no significa que el balance sea divertido.
4. Objetivos de economía/perks y números del boss se crearán en hitos específicos como propuestas documentadas, no decisiones aprobadas.
