# Prompt para Claude — B2 sobre el juego integrado

Copia el bloque completo en Claude. B1 está aprobado; este encargo autoriza únicamente B2: H07, H08 y H09.

```text
Eres Claude, programador de ALABARDA CYBERPUNK. Te encargo implementar B2 completo: H07 (seis armas/slots libres), H08 (energía por bajas/curación con E) y H09 (tres ultimates).

Repositorio completo: https://github.com/alejandrodapenasanz/ALABARDA_CYBERPUNK_H1.git
Rama estable: main. B1 está aprobado e integrado en el juego normal. No lo trates como código separado ni recrees B1. Crea B2 desde el main actualizado y registra su SHA base real con git rev-parse HEAD.

SINCRONIZACIÓN Y LECTURA
Clona el repositorio completo si no lo tienes. Si ya existe, inspecciona git status y conserva cambios propios antes de actualizar. Ejecuta git fetch origin, git switch main, git pull --ff-only y git switch -c B2. Si B2 ya existe, inspecciona su historial antes de continuar; no sobrescribas trabajo ni fuerces Git.

Lee AGENTS.md íntegro y todo su orden de lectura. Aplica prompts/_templates/CLAUDE_IMPLEMENT_BATCH.md. Lee completos los prompts:
- prompts/H07_SEIS_ARMAS_Y_LOADOUT_LIBRE.md
- prompts/H08_ENERGIA_CURACION_Y_EXTRACCION_CYBORG.md
- prompts/H09_TRES_ULTIMATES_INDEPENDIENTES.md
Consulta especialmente HANDOFF, ARCHITECTURE, DECISIONS, CONTROLS, GAME_DESIGN, HEALTH_ENERGY_CONTRACT, HEALTH_ENERGY_TEST_CASES, BALANCE_PROVISIONAL, TEST_STRATEGY y validation/B01/APPROVAL.md e INTEGRATION.md. Lee ART_BIBLE y ASSET_REGISTRY antes de afectar visuales o assets.

Comprueba las herramientas reales de este PC. El repositorio incluye el proyecto completo: puedes importar project.godot y abrir Godot si lo tienes instalado. Versión probada: Godot 4.7.2 estándar/Compatibility; GdUnit4 6.2.3 incluido. No asumas que falta el motor por una descripción antigua ni inventes ejecuciones. Si no está disponible, ejecuta Python/estático y deja las pruebas de motor NOT_RUN para Codex. Blender no hace falta para abrir el juego; úsalo solo si está disponible y el trabajo autorizado lo requiere.

CONTINUIDAD OBLIGATORIA
F5 ejecuta scenes/main.tscn con scripts/main.gd. El jugador compartido está en scenes/player/player.tscn y scripts/player/player_controller.gd (PlayerController). Combate en scripts/combat/, interacción en scripts/interaction/ y peligros de la arena en scripts/world/.
Amplía ese flujo normal. No crees otro jugador B2, otra copia de salud/daño ni una escena principal paralela para las novedades. Las fixtures aisladas de tests sí son válidas. La arena actual permite ejercitar B2 en F5; no adelantes niveles, IA o contratos futuros.
Conserva movimiento, dash WW/AA/SS/DD, F de interacción, salud/regeneración, muerte única, hitboxes y recuperación por animaciones aprobados. Mantén la prevención de penetración del arma: scripts/player/weapon_wall_guard.gd y tests/gameplay/integration/weapon_wall_test.gd. La envolvente actual cubre HitscanWeapon y sus poses lineales; adáptala explícitamente a las nuevas armas/animaciones con pruebas. No supongas que sirve para cualquier rig ni ocultes colisiones reduciendo, desplazando, ocultando o dibujando el arma encima de paredes (D-030).
H1 antiguo solo vive en tests/fixtures/h1 como regresión; Q/R históricos no definen los controles actuales. Sus aprobaciones no prueban mecánicas nuevas.

ALCANCE
H07: katana, pistola silenciada, rifle silenciado con mira, espada-sierra, revólver y escopeta de uno/dos cañones. Tres slots libres con cualquier combinación; iniciales katana/pistola/escopeta. 1/2/3 equipa, repetir guarda, otro slot cambia directamente respetando animaciones/estados. Reserva infinita, cargadores, recarga y recuperación animadas. Datos configurables, modelos provisionales legales y feedback legible. Auto-deflect de katana solo para proyectiles compatibles según decisiones aprobadas.
H08: salud 0–100 y energía 0–150 independientes. Salud automática tras 5 s sin daño a 5 HP/s. SIN regeneración pasiva de energía: solo +15 por baja confirmada y atribuida al jugador, una vez, hasta 150; matar no cura HP. E mantenida cura a 25 HP/s gastando 25 energía/s, cobrando solo HP recuperado, sin gasto a salud llena; termina al soltar/morir/agotar energía. Con energía 0 no cura. E cura también junto a objetos; F interactúa. Pausar autoHP durante curación manual según contrato, HUD rojo/azul y orden de eventos documentado. Ascensor fija energía 150 sin tocar HP: interfaz/doble hasta H19, sin construirlo. No restaurar extracción F ni implementar remates pendientes.
H09: una ultimate equipada, umbral >=100, consume toda la energía; solo duración escala con energía anterior al consumo. Dead Eye ralentiza mundo/IA/proyectiles al 50%, jugador/cámara normales y cualquier arma. Aimbot asiste a cabezas visibles con oclusión respetada y sin auto-fire. Overdrive solo beneficia armas de fuego manteniendo cadencia por animaciones. Restaurar estados/relojes al terminar o morir. Tasas, daño, tiempos y duración 6–10 s son provisionales, no balance final.
Consulta P-001/P-005/P-006/P-011/P-017. No inventes bindings de recarga/ultimate/apuntado/modo doble, política de duplicados/vacíos ni compatibilidades de parry. Pregunta solo las decisiones materiales que falten y continúa las partes independientes. R o Q libres no autorizan asignarlos por intuición. La cámara de muerte en tercera persona D-029 sigue siendo futura y NO forma parte de B2.

CHECKPOINTS Y PRUEBAS
Implementa H07 → H08 → H09 con checkpoints y commits separados. Puedes continuar estos tres hitos sin una aprobación ficticia intermedia. Conserva regresiones útiles y añade límites, estados simultáneos, muerte, munición, slots, curación, energía y ultimates según SB/CT aplicables.
Suites comunes: tests/gameplay/unit y tests/gameplay/integration. Runner: tools/gameplay/run_tests.py. Base integrada: 37 unitarias y 38 de integración, más H1/H03/H04. Amplía cobertura/recuentos al añadir casos; no retires aserciones para esconder fallos.
Antes de cada checkpoint ejecuta python -X utf8 tools/pipeline/check_godot_static.py. Si Godot está disponible, usa un candidato limpio y evidencia nueva fuera de él:
python -X utf8 tools/gameplay/run_tests.py --godot <ruta_real_console.exe> --output <directorio_nuevo_fuera_del_candidato>
No ejecutes literalmente marcadores. Si falta motor, documenta NOT_RUN con causa y deja comandos reproducibles para Codex. El creador revisa sensaciones/arte. Actualiza hashes de integridad solo para cambios deliberados/revisados; conserva snapshots y evidencia anteriores.

ENTREGA
Prepara validation/B02/TEST_HANDOFF.md (A–K), TEST_MANIFEST.json conforme al schema, TEST_RESULTS.md, evidence/ y bugs/ cuando proceda. C contiene código/tests; P posterior contiene el paquete con el SHA exacto C. Comprueba manifest --ready contra un worktree limpio de C. Registra versiones, comandos, cwd, exit, logs/JUnit y límites reales; importar con error no es PASS.
Actualiza ARCHITECTURE, DECISIONS afectadas, ROADMAP, VALIDATION y HANDOFF. Entrega SHA base, checkpoints H07/H08/H09, C/P, archivos, resultados/NOT_RUN, bugs y pasos para Codex/creador. Haz commit y push de B2 para entregar el proyecto completo. No hagas merge a main, no borres ramas ajenas, no uses reset --hard/clean/force-push, no declares APPROVED ni empieces B3.
```
