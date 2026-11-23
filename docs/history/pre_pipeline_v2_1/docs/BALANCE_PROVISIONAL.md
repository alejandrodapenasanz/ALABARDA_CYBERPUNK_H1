# BALANCE_PROVISIONAL — hipótesis configurables, NO aprobadas
**Versión 1.1 · 2026-11-21.** Las decisiones de mecánicas aprobadas prevalecen. H03 implementa únicamente los datos y su validación; no hay balance definitivo ni sistemas futuros conectados. El traslado antes propuesto queda autorizado por el encargo H03, sin aprobación de las cifras provisionales.

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

## Fórmulas propuestas para verificar, NO mecánicas aprobadas
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

## Aclaración de auditoría H02

La tabla mezcla límites aprobados (salud 100, energía 150, activación 100, escala inicial Dead Eye 0.50) con hipótesis. Cada fila conserva su estado; no todo el documento es balance aprobado ni todo es pendiente. La interpolación 6–10 s, la extracción por objetivo y el reembolso concreto no quedan aprobados por ser testeables.

H1 real usa daño de pistola 35, blancos 35/70 y recuperación 0.23 s; no se han reemplazado por pistola 30 ni enemigos 60/80/150 de esta tabla. Valores observados en [ARCHITECTURE](ARCHITECTURE.md). P-014 bloquea concretar muerte/liberación de F; P-001/P-002/P-006 conservan balance, economía/perks y compatibilidades pendientes.

## Resource implementado en H03

[provisional.tres](../resources/balance/provisional.tres) y [BalanceProfile](../scripts/config/balance_profile.gd). No conectados a H1. Todas las filas de la tabla anterior se conservan en el Resource, separadas en rules y values.

| Clasificación | Datos y procedencia | Efecto actual |
|---|---|---|
| APPROVED_RULE | player_max_hp=100, energy_max=150, ultimate_activation_min=100, dead_eye_world_scale=0.50; D-007/D-009 | Validación exige los límites exactos; clamps puros de salud/energía. No mecánicas nuevas |
| PROVISIONAL_VALUE | Las otras filas numéricas; movimiento heredado de H1, resto hipótesis de este documento | Editables sin tocar scripts; validadas como datos, no aplicadas a gameplay |
| REQUIRES_PLAYTEST | Todas las cifras provisionales y su interacción | Tests de datos no certifican diversión ni dificultad |
| PENDING_APPROVAL | Fórmulas de extracción/curación/ultimate, liberación F, headshots, cadencias, dificultades, economía/perks | No implementadas ni rellenadas con multiplicadores inventados |

Reglas aprobadas no numéricas (F/E continuas, consumo total, ascensor recarga, tres dificultades) siguen documentadas en GAME_DESIGN; el Resource no simula esas mecánicas. Los valores que faltan en la tabla no se crean por intuición.

Validación: versión de esquema 1; campos requeridos; rechazo de desconocidos, strings/bools/null/NaN/inf/negativos; cargadores/pellets enteros positivos; multiplicador de reducción [0,1], sprint>=marcha, duración dash<=cooldown y duración a 150>=duración a 100. Son controles de coherencia de datos, no balance aprobado. No se inventa daño máximo universal. Cero permitido en tasas/daños; nada los utiliza todavía.

Clamps: salud [0,100], energía [0,150]; no finitos se convierten a 0 en estas funciones puras. La configuración inválida se **rechaza**, no se corrige silenciosamente. read_validated devuelve null ante ruta ausente, tipo incorrecto o perfil inválido. Casos 0/99/100/150/151 y extremos, persistencia temporal de un Resource inválido e independencia entre instancias ejecutados en la suite.
