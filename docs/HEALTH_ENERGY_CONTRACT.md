# Salud y energía — contrato v2.1

**2026-11-22 · D-023/D-024; implementación NOT_STARTED.** Reglas solicitadas por el creador; migración pendiente de validación humana. [Balance](BALANCE_PROVISIONAL.md) y [pruebas futuras](HEALTH_ENERGY_TEST_CASES.md).

## Dos barras

Salud (HP) **0–100**, roja: daño válido reduce HP y 0 significa muerte. Energía **0–150**, azul: recurso para E y ultimates. Son independientes. Recibir daño no resta energía salvo otra mecánica expresamente aprobada. Matar **no cura HP directamente**. Salud llena no significa ultimate disponible; HP bajo no impide activarla estando vivo y con energía suficiente.

## Salud automática

Estando vivo, tras **5 s sin daño**, recuperar **5 HP/s** hasta 100, sin gastar ni generar energía. Ambos valores **PROVISIONAL_VALUE / PENDING_PLAYTEST**. Cada nuevo daño válido reinicia la espera, incluso durante regeneración. No revive ni continúa muerto. No depende de bajas. Curación manual activa pausa la automática (`manual_heal_pauses_auto_regen=true`, provisional); al cesar puede reanudarse si ya transcurrió la espera. No sumar ambas tasas por defecto.

## Mantener E

Curación continua **25 HP/s** por **25 energía/s**, relación inicial 1:1; **PROVISIONAL_VALUE / PENDING_PLAYTEST**. Empieza sin esperar la regeneración automática. Termina al soltar, morir, alcanzar 100 HP o agotar energía. Daño no la cancela mientras se sobreviva. Gastar solo el coste del HP efectivamente recuperado; HP lleno no consume. Aislando otras fuentes, HP=99/energía=10 durante 1 s → HP=100/energía=9; HP=50/energía=2 → como máximo 2 HP de curación antes de agotar esa energía.

«Manual activa» significa que recupera HP y consume energía; mantener E sin poder curar no genera gasto ficticio. H08 documentará orden de eventos/delta y comprobará fuentes simultáneas. La regeneración energética sigue sus condiciones (vivo y por debajo de 100); no inventar una exclusión durante E. Las pruebas unitarias aíslan fuentes y la integración comprueba su combinación.

E exclusiva para curación **también junto a objetos**. Interacción tendrá acción distinta configurable; tecla **PENDING_APPROVAL P-015**, sin imponer R/F ni E contextual. H05 puede preparar API/test por inyección; la prueba manual de interacción requiere resolver el binding.

## Energía

- Vivo y energía<100: **8 energía/s**, **PROVISIONAL_VALUE / PENDING_PLAYTEST**, incluso en combate. Pasiva limitada a 100; no rebajar energía almacenada >100.
- Cada baja confirmada atribuida al jugador: **+15**, **PROVISIONAL_VALUE / PENDING_PLAYTEST**, una sola vez e independiente del arquetipo. Sin multiplicadores no aprobados, eventos duplicados ni ganancias muerto.
- 95+15=110; 145+15→150. Esperar en 100 no llega a 150. Gastar por debajo de 100 reactiva la pasiva; energía llena no se sobrecarga.
- En combate normal solo bajas llenan 100–150. **Excepción aprobada:** ascensor fija energía a 150 **sin cambiar HP**.
- Extracción mantenida con F **SUPERSEDED**: no dependencia, fórmula vigente ni test de aceptación que la exija. El nombre antiguo del prompt H08 conserva compatibilidad de rutas.

## Ultimates

Una equipada, vivo y **>=100 energía**; consume toda la actual (100–150). Duración calculada con el valor **anterior al consumo**; solo escala duración. **6 s a 100 / 10 s a 150 e interpolación lineal: PROVISIONAL_VALUE / PENDING_PLAYTEST**. Dead Eye mundo/IA/proyectiles al 50%, jugador normal, cualquier arma. Aimbot destaca cabezas visibles y asiste al ratón, respeta oclusión, sin disparo automático. Overdrive cadencia/potencia de armas de fuego mediante animaciones. Bonus/compatibilidades específicas P-006. E compite por este recurso; salud automática no lo gasta. Umbral energético no equivale a 100 HP.

## Remates y firmware

Retirar extracción no elimina silenciosamente remates: normal debilitado/aturdido/sin detectar; tanque con armadura rota/debilitado; ejecución válida elimina objetivo. Adaptación de disparador, tiempos y protección antes ligada a extracción **PENDING_APPROVAL P-017**. No aplicar esa protección a E, regeneración o toda baja. Un futuro remate usaría el evento único de baja, sin fuente adicional de energía.

Firmware solo al instalar USB y hasta respec. No inventar perks de salud/energía/dash; futuras modificaciones deben probarse con reversión y no cambiar límites aprobados por intuición.

H1 no implementa este contrato. El Resource y tests H03 conservan datos antiguos de extracción, **SUPERSEDED para el nuevo diseño**, sin cambios de bytes en esta migración. Adaptación prevista en B1/B2 autorizados; sus PASS históricos no demuestran estas mecánicas.
