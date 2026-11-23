# HANDOFF — H04 CERRADO Y APROBADO POR EL CREADOR

## Cierre vigente · 2026-11-22

El creador confirma «Si, todo me cuadra» tras la revisión manual solicitada (aspecto, tres luces, HomeVideo/silueta, cámaras/brazos/reset y smoke H1). Se registra aprobación conjunta de la referencia experimental, D-021; no nuevos tamaños/equipos ni selección de assets finales. [Fuente](evidence/h04/manual_approval_20261122.txt). Con la suite técnica `run_02` PASS, la puerta H04 está satisfecha: **CERRADO / APROBADO POR CREADOR**. H1–H04 cerrados; H05 requiere encargo propio y no está iniciado.

La implementación jugable/visual aprobada permanece intacta durante el cierre. Se actualizan estados y documentación pública; se prepara publicación con kit propio, fuentes Blender, pruebas H04 y fallback propio sin Malorian. El registro final de publicación y verificación pública se añade en VALIDATION. Se conserva el índice histórico original.

**Publicado y verificado:** [GitHub público](https://github.com/alejandrodapenasanz/ALABARDA_CYBERPUNK_H1), `main`, commit `48f972c6ebeac2a4c7e6ab526e7dead43ad2baba`. Suite gráfica pública completa PASS/exit 0, 20 tests y H1 34/0/1, sin Malorian; fuentes Blender saneadas de rutas personales y GLB intactos. Push final exit 0, HEAD remoto coincide, árbol público limpio. [Comprobante](evidence/h04/publication.json). H04 cerrado y publicado; no queda trabajo obligatorio de este hito. Para futuras selecciones usar `tools/h04/package_public.py`, que incluye fuentes/tests H04 y conserva exclusiones.

Los pasos de revisión y estados pendientes que siguen son el antecedente de la entrega previa a esta confirmación; sirven como reproducción, no como puerta pendiente actual.

## Estado vigente H04 · 2026-11-22

Encargo expreso: «Con h1,h2 y h3 cerrados; empieza h4». H1–H03 siguen cerrados. H04 implementado y **suite automática PASS**, pendiente de aprobación manual; H05 no iniciado. [Resultados](VALIDATION.md), [resumen ejecutado](evidence/h04/run_02/summary.json). Las secciones H03 inferiores son antecedentes.

Se desarrolla la **misma** escena `scenes/art_reference/modern_psx_lab.tscn`: taller de referencia con kit modular propio, conductos, señales HomeVideo, CRT/escritorio/industria existentes, silueta angular y Malorian opcional local. Los brazos conservan la muestra animada separada; no se han equipado sobre la pistola ni añadido disparo. Assets experimentales, sin selección final. H1, configuración principal e inputs intactos.

### Revisión que debe realizar el creador

1. Detener ejecución previa con **F8**, esperar importación, abrir `scenes/art_reference/modern_psx_lab.tscn` y pulsar **F6**. La cabecera muestra **ALABARDA / H04**. **F5 sigue abriendo H1**.
2. Pulsar **0**. Deben aparecer taller, paneles, armario, cajas, silueta, CRT, brazos y Malorian local. Perfil D-019: nearest+mips, atmosférica, 1280×720, retro/niebla no, sombras sí. Evaluar coherencia del escritorio, industria y kit nuevo; los modelos siguen siendo pruebas.
3. **L** recorre atmosférica → neutra → alarma estática → atmosférica. Revisar la silueta en **3**, CRT/textos en **2** y visión general en **1**. La alarma solo cambia la iluminación, no implementa H12. **M** conserva la oscilación de cámara para inspección.
4. **4 + A**: comprobar brazos y animación. **F**: panel de fuentes. **X/B**: retro y comparación; **S**: sombras. **0** debe restaurar todo. Revisar lectura también redimensionando a 960×540; esta escala necesita aprobación propia.
5. **F5**: comprobación breve de H1, movimiento/ratón/disparo, cinco blancos y **R**. La prueba física no se simula como PASS headless.

Indicar si se acepta la composición, paleta, silueta, legibilidad de señales/CRT y luz en esas condiciones. Su aceptación cerrará la puerta manual H04 conforme a AGENTS §5–6; los tests no la sustituyen.

### Archivos, reproducción y continuidad

- `scripts/art_reference/lookdev_room.gd`: composición y reutilización del kit; `lab_world.gd`: materiales por instancia, iluminación y muestras; `modern_psx_lab.gd`: ciclo de tres luces. Sin segunda sala ni nueva escena principal.
- `scripts/art_reference/lookdev_profile.gd` / `resources/art_kit/lookdev.tres`: paleta, luces y cámaras experimentales editables. `resources/art_kit/` contiene tres GLB y manifiesto; `art_sources/h04/` sus fuentes Blender, excluidas del importador por `.gdignore`.
- `tools/h04/build_kit.py`: Blender 4.5.3 portátil → fuentes `.blend` y GLB; `tests/h04/` y `tools/h04/run_tests.py`: pruebas nuevas junto a las existentes. Comandos y dependencias en ARCHITECTURE/TEST_STRATEGY.
- Suite final `run_02`: 8 unitarias H03 + 8 integración H03 + 4 integración H04 PASS; H1 34 PASS/0 FAIL/1 NOT_RUN físico headless; fallo deliberado detectado; importación, originales, manifiesto de kit, gráficos y legibilidad PASS. Capturas originales en `evidence/h04/run_02/graphics/`.
- No bloqueos técnicos conocidos. Revisión estética PENDING_APPROVAL; export Windows y otros equipos NOT_RUN, fuera de este hito. Los presupuestos medidos no son máximos aprobados. El escritorio y la ventilación aún conservan el desgaste original; se requiere juicio humano sobre la mezcla.
- H04 aún no se ha publicado. GitHub conserva el cierre H03 `2a89548`. Para publicación posterior, incluir kit/fuentes y pruebas H04 en la selección pública; el empaquetador H03 no recoge esos directorios nuevos. Conservar exclusión de originales, evidencia privada y Malorian. No modificar el índice histórico del workspace.
- El prompt H05 recibe esta continuidad; solo se ejecutará con aprobación H04 y nuevo encargo. No convertir los fixtures sin colisiones/IA en sistemas de gameplay por inferencia.

## Cierre H03 conservado como antecedente

**Estado vigente · 2026-11-22: H03 CERRADO / PASS. H04 no iniciado ni autorizado.** Tras aprobar el perfil D-019, el creador confirma las dos comprobaciones finales solicitadas: H1 con movimiento/ratón/disparo, cinco blancos y reinicio R; legibilidad de HomeVideo y movimiento de brazos con A en cámara 4. Ordena actualizar y cerrar H03 si eran los últimos pendientes y publicar el código. Son los últimos requisitos manuales; se registra cierre con esa aprobación expresa, no por inferencia de tests automáticos. [Registro manual](evidence/h03/manual_approval_20261122.txt), [validación](VALIDATION.md).

## Estado entregado y continuidad

- Godot 4.7.2 estándar, GL Compatibility; GdUnit4 6.2.3 fijado, runner Windows y Resource de balance provisional desacoplado de H1.
- F5 inicia H1. F6 sobre `scenes/art_reference/modern_psx_lab.tscn` abre el laboratorio. Perfil inicial/restaurado: nearest+mips, atmósfera, 1280×720, retro off, sombras sí, niebla no; intensidad 70% inactiva. D-019 vigente y revisable.
- HomeVideo preferida y legible en la muestra probada (D-020); referencia de terminales, sin sustituir globalmente el HUD. Rig animado comprobado manualmente. Los modelos siguen assets de prueba, no selección final.
- Última suite completa [run_06_selected_profile](evidence/h03/run_06_selected_profile/summary.json): PASS/exit 0, 8 unitarias + 8 integración, H1 34 PASS/0 FAIL/1 NOT_RUN. El NOT_RUN corresponde al clic físico headless: la comprobación humana ahora tiene PASS separado, sin reescribir aquel log. Importación, arranque, recursos, fallo controlado, gráficos y legibilidad técnica PASS.
- Código y cierre publicados en [GitHub público](https://github.com/alejandrodapenasanz/ALABARDA_CYBERPUNK_H1), main `2a89548a20313832f60f5a08b47508e382db43df`; push exit 0, HEAD remoto idéntico y árbol público limpio. Checkout `C:/dev/ALABARDA_CYBERPUNK_H03_PUBLIC`; sincronización por allowlist, sin alterar índice original. [Comprobante de cierre/publicación](evidence/h03/closure_20261122/publication.json).
- Originales intactos; Malorian opcional local en `resources/local_experiments/`, excluida de publicación. PSXAmmoBoxes sustituido por cajas propias. Estas limitaciones ya contempladas no bloquean H03 ni aprueban redistribución futura.
- Export Windows, Blender y otros equipos/sesiones largas permanecen NOT_RUN fuera del cierre exigido en H03. Los números de balance y límites finales de arte siguen pendientes de sus hitos.

El siguiente hito previsto es H04; su precondición H03 ya está satisfecha. Antes de ejecutarlo debe existir encargo propio. Reutilizar laboratorio, perfil D-019, preferencia HomeVideo D-020, fixtures, pruebas y registro de assets. No regenerar históricos/alias H02 ni confundir el cierre técnico de H03 con el MVP completo.

## Historial de entrega y revisiones anteriores al cierre

Los apartados siguientes conservan sus estados y fechas originales. Sus menciones a aprobación pendiente y reset neutro son antecedentes, sustituidos por el estado vigente anterior.

**Decisión posterior del creador · 2026-11-22 · D-019 APROBADA:** la captura y «decisión final de momento» fijan el perfil vigente: nearest+mips, luz atmosférica, 1280×720, retro desactivado, sombras sí, niebla no; intensidad 70% inactiva. Se aplica al abrir la escena con F6 y al pulsar 0. Revisable en el futuro mediante decisión registrada. Prevalece sobre la luz neutra de los pasos históricos inferiores. Se reconoce aprobación del perfil visual mostrado; no se infiere cierre global H03 ni pruebas manuales de H1/fuentes/rig no mencionadas, ni se inicia H04. Assets siguen de prueba.

Suite del perfil seleccionado: [run_06_selected_profile](evidence/h03/run_06_selected_profile/summary.json), PASS global/exit 0 con gráficos, 8 unitarias + 8 integración y H1 34/0/1. Abrir/restaurar ya reproduce la elección sin tener que pulsar L. Los estados de «configuración aún no aprobada» inferiores son anteriores a D-019.

Publicación de D-019: [GitHub](https://github.com/alejandrodapenasanz/ALABARDA_CYBERPUNK_H1), main `1c66903536b81b191c1cb7008560c781dff1b374`; push exit 0, HEAD remoto idéntico y árbol público limpio. Integración pública repetida 8 PASS e integridad PASS, ambas exit 0: [registro](evidence/h03/public_selected_profile/integration.json). La Malorian sigue local y los assets originales excluidos. Los commits 5f03fb3/9153287 inferiores son publicaciones anteriores.

**Última corrección · 2026-11-22:** el creador aporta capturas y confirma retro true/false imperceptible y mala legibilidad; esos aspectos NO se dan por aprobados. Se corrige cámara general/encuadre, se trasladan controles y títulos fuera de 3D, se oculta inicialmente el panel tipográfico y se añade retro regulable con comparación B. La Malorian suministrada aparece localmente como muestra FPS texturizada; fuente CC0 verificada de nuevo, excluida de publicación. [Suite run_05](evidence/h03/run_05_readability/summary.json) PASS global/exit 0: 8 unitarias, 8 integración, 34 regresiones H1, fallo controlado detectado e importación/integridad/gráficos/legibilidad automáticos. Los resultados anteriores inferiores son históricos. H03 pendiente de revisión de esta corrección; H04 no iniciado.

**Cómo revisar la versión corregida:** detener la instancia anterior con F8; esperar reimportación; abrir `scenes/art_reference/modern_psx_lab.tscn` y F6. Pulsar 0: cámara 1 frontal, neutra/nearest/1280×720/sombras, sin retro/niebla, fuentes ocultas. Panel izquierdo con cámaras 1–4 y botones T/L/R/X/S/G. X activa retro; B compara sin efecto a izquierda y con efecto a derecha; slider 0–100% regula intensidad (70% de prueba). F abre las fuentes en una zona propia; A cambia animación del rig; M mueve la cámara; Esc sale. F5 sigue abriendo H1. La Malorian se ve en la esquina inferior derecha como muestra de encuadre, sin disparo ni acople al rig de brazos. Si falta la carpeta local, el código público usa arma abstracta propia.

**Publicación actualizada:** [GitHub público](https://github.com/alejandrodapenasanz/ALABARDA_CYBERPUNK_H1), commit `5f03fb3b751e7037c3d742f5fd661df61dcec99a` en main; push exit 0 y HEAD remoto verificado. [Suite pública corregida](evidence/h03/public_readability/summary.json) PASS global/exit 0, sin Malorian ni originales locales. Paquete público excluye carpeta local_experiments; fuentes/muestras originales intactas. Evidencia de publicación en [publication_readability](evidence/h03/publication_readability.json). El commit 9153287 citado más abajo es la entrega inicial.

Capturas de revisión: [general](evidence/h03/run_05_readability/readability/camera_1.png), [retro A/B](evidence/h03/run_05_readability/readability/retro_split.png), [fuentes 960×540](evidence/h03/run_05_readability/readability/layout_960x540_fonts_true.png). No hay superposición entre controles/panel fuentes y vista 3D. A 960×540 sigue habiendo escalado al 75% y requiere criterio humano de legibilidad. La lámpara de viewmodel solo ilumina capa 2; el arma sigue experimental y puede requerir ajuste artístico.

**2026-11-21 · H02 APROBADO. H03 IMPLEMENTADO SIN APROBAR; resultado técnico PASS. H04 NO INICIADO.** La solicitud ampliada [H03](evidence/h03/request.txt) y la orden de continuar/publicar autorizan esta implementación, no sustituyen la revisión artística del creador. Las secciones PRE-H03 inferiores son antecedentes conservados.

## Estado ejecutable H03

F5 conserva `scenes/main.tscn`, controles y balance H1. Abrir `scenes/art_reference/modern_psx_lab.tscn` y pulsar F6 para el laboratorio. Godot estándar **4.7.2.stable.official.ed1daf0bf**, GL Compatibility; GdUnit4 **6.2.3**, MIT, ya incluido. Python 3.11+ y PowerShell para `tools/run_tests.ps1 -Godot <ejecutable_console> [-Graphics]`. Reinstalación fijada por hash y comandos en [ARCHITECTURE](ARCHITECTURE.md).

Balance: `scripts/config/balance_profile.gd` + `resources/balance/provisional.tres`, reglas/valores separados y validados. No conectado al gameplay H1. Assets originales intactos en `assets/`, excluidos con `.gdignore`; selección experimental única en `resources/art_samples/`. CRT, escritorio, barril/ventilación, fuente HomeVideo y brazos animados suministrados por el creador. Son exclusivamente pruebas, **no selección final**. Cajas y arma abstracta propias; sin nuevas mecánicas.

Última suite completa de desarrollo: [run_03/summary.json](evidence/h03/run_03/summary.json), **PASS, salida global 0**, 8 unitarias + 5 integración; control negativo detectado con salida 100; H1 34 PASS/0 FAIL/1 NOT_RUN; importación/arranque/integridad/gráficos PASS. 908 archivos protegidos sin cambios respecto a entrada, salvo nueva política AGENTS recibida durante la sesión y aceptada por hash específico. [VALIDATION](VALIDATION.md) conserva errores iniciales y sus correcciones.

## Revisión manual H03 pendiente

**Actualización 2026-11-22:** recibida revisión parcial: Nearest+mips, luz neutra, 3D 1280×720, sombras true y niebla false. El creador no percibe cambios con retro y observa la greybox al pulsar F5. Son valores reportados, sin aprobación definitiva inferida. Se confirma que F5 sigue abriendo H1; los assets experimentales se inspeccionan abriendo el laboratorio y pulsando F6. Comparación de las capturas anteriores confirma un retro muy leve (diferencia media inferior a 1/255 por canal); falta saber si el indicador true/false cambia en su prueba actual. No se ajusta intensidad ni se cambia el arranque. Detalle/evidencia en VALIDATION. H03 sigue pendiente de aprobación.

1. Importar `project.godot` con Godot 4.7.2 estándar; esperar importación. Abrir la escena del laboratorio y F6. Usar ventana 1280×720; pulsar **0**. Estado inicial: nearest+mips, luz atmosférica, resolución nativa, sombras sí, niebla/retro no, cámara general, rig estático.
2. Pulsar **L** una vez para base neutra. Comparar **T** (nearest/linear), **R** (resolución 3D), **X** (retro), **S** (sombras), **G** (niebla) de uno en uno, devolviendo cada opción al estado anterior. UI permanece independiente del escalado/efecto. Revisar paneles de metal/oficina/industria y silueta. Los seis botones equivalen a las teclas.
3. **1/2/3/4**: general/CRT/silueta/rig. **M** alterna movimiento sinusoidal de inspección; no hay controles FPS jugables en esta sala. **A** alterna jab_L/relax/guard_idle del rig; **0** restaura pose/cámara/configuración. Confirmar brazos visibles, proporción de arma abstracta y señal de amenaza simulada.
4. **F** oculta/muestra comparación de HomeVideo y Godot UI a 14/20/28 px. Revisar tildes/ñ, números, espaciado y contraste. Cambiar ventana a 960×540 para comparar escalado al 75%; HomeVideo sigue candidata de terminal, no HUD aprobado.
5. Revisar composición de cajas propias debajo de armas: es sustituto ambiental para evaluar ubicación; no certifica el aspecto de PSXAmmoBoxes bloqueado por licencia. Evaluar coherencia/paleta de los cinco packs, luces claras/tenues y lectura en movimiento.
6. **Esc** cierra laboratorio. **F5** inicia H1: movimiento, ratón/disparo, eliminar cinco blancos, victoria y **R** reinicio. Confirmar captura del ratón y nueva partida. La aprobación H02 anterior no se reutiliza como validación manual H03.

Resultado humano de estos seis pasos: **PENDIENTE**. Export Windows, otros equipos y sesiones largas NOT_RUN. Medición gráfica local y capturas auténticas sí ejecutadas, en [ART_BIBLE](ART_BIBLE.md). Solapes de carteles 3D/UI en primeros planos y diferencias de densidad/brillo entre packs quedan como limitaciones visibles de este banco de pruebas.

## Continuidad y publicación

El siguiente chat debe leer AGENTS y los documentos activos. No reconstruir alias retirados ni ejecutar herramientas históricas de migración para regenerar documentos. H03 no autoriza H04. El prompt H04 ya incorpora rutas del laboratorio, selección, rig, toggles y limitaciones; únicamente se actualizó continuidad documental.

Pendientes específicos: aprobación manual/estética; aclaración de condiciones de PSXAmmoBoxes y derechos de diseño de Malorian si se pretende incorporarlos; adaptación coherente de materiales/paleta; diseño original del brazo izquierdo robótico. Blender no localizado: inspección interna de `.blend` NOT_RUN. Ningún pack VISUALLY_APPROVED. Datos completos y permisos en [ASSET_REGISTRY](ASSET_REGISTRY.md).

**Publicado y verificado:** [alejandrodapenasanz/ALABARDA_CYBERPUNK_H1](https://github.com/alejandrodapenasanz/ALABARDA_CYBERPUNK_H1), visibilidad PUBLIC, rama main, commit `9153287449f1521b864ad7818d19a8b9914b6c51`. Push exit 0; HEAD remoto coincide. Clone posterior desde GitHub con integridad PASS y árbol limpio. [Comprobante](evidence/h03/publication.json).

Checkout de publicación: `C:/dev/ALABARDA_CYBERPUNK_H03_PUBLIC`, conservando el índice preexistente de este workspace sin commit/reset. Código H1/H03, tests, framework y muestras redistribuibles; sin originales restringidos, conversaciones, historial documental privado ni logs con rutas personales. La copia pública tiene documentos breves propios y baseline de seis archivos H1, claramente separado de la auditoría local de 908. Antes del envío pasó importación desde cero y suite completa con gráficos: [public_fresh](evidence/h03/public_fresh/summary.json), salida 0. Identidad de commit GitHub noreply; no se publica correo personal.

Para futuras publicaciones, sincronizar explícitamente código/muestras verificadas al checkout público y repetir tests allí; no ejecutar `git add .` sobre la colección original suponiendo que todos los packs son redistribuibles. `tools/h03/package_public.py <destino_nuevo>` reproduce la selección y rechaza un destino existente; docs públicos se mantienen en `tools/h03/public_docs/`. Su prueba de integridad local verifica originales/historia; la pública verifica únicamente H1 y dependencias entregadas. No confundir los dos alcances.

## Antecedente PRE-H03 documental y continuidad H02

2026-11-20 · **H02: APROBADO POR CREADOR. H03 no iniciado.** Tras las correcciones, el creador confirma: «Continua, he hecho als pruebas y los controles y respwan y todo funciona.» Se registra su confirmación conjunta de las pruebas solicitadas, destacando controles y respawn. Unida a su petición previa de corregir y cerrar H02 y a las pruebas automáticas ya superadas, satisface la puerta manual. No se inventan versión, capturas ni observaciones individuales que no haya aportado. Las cinco pruebas previas y las decisiones de diseño conservan su historial.

## Actualización artística PRE-H03

D-017 APROBADA por solicitud expresa del creador el 2026-11-20: **Modern PSX / Retro Industrial Cyberpunk**. [ART_BIBLE](ART_BIBLE.md) es la fuente principal: lenguaje retro industrial con experiencia/legibilidad modernas; geometría y texturas intencionales, luz atmosférica, siluetas diferenciadas y efectos potencialmente perjudiciales configurables o desactivables. Producción híbrida/progresiva con reutilización legal, adaptación, props propios, materiales/shaders y protagonistas personalizados; IA conceptual.

Se sincronizan visión, alcance, diseño, AGENTS, decisiones, registro de assets, roadmap, matriz, índice y los 23 prompts. H03 conserva pruebas/balance y añade investigación de pipeline y una escena comparativa; H04 mantiene la vertical y desarrolla esa base. No se renumeran dependencias. Paleta, resoluciones, presupuestos y técnicas concretas siguen propuestas por validar, sin assets aprobados por inferencia.

PRE-H03 solo cambia documentación/prompts y añade evidencia; no cambia código, escenas, project, controles ni balance, no incorpora assets ni ejecuta H03. Resultados y listado exacto de cambios: [VALIDATION](VALIDATION.md). Fuente recibida: [solicitud](evidence/pre_h03/request.txt). Las herramientas H02 de generación/migración son históricas: no regenerar el índice o notas sin revisar el diff, porque las ampliaciones PRE-H03 viven ahora en los documentos.

**Preparación:** H03 está documentalmente preparado y su precondición H02 queda satisfecha con la confirmación posterior del creador. Aún requiere autorización de su propio hito; PRE-H03 no lo ejecuta. No hay nueva escena visual que aprobar en esta tarea documental.

**Verificación PRE-H03:** importación y arranque headless PASS, exit 0, Godot 4.7.2; referencias de 83 Markdown sin errores y 18 avisos históricos/ausencias declaradas; diez comprobaciones de integridad PASS. Código, escena, configuración, herramientas y evidencia H02 conservados por hash. No se repitieron smoke jugable, revisión visual ni benchmark: NOT_RUN en esta tarea. El resultado documental no valida todavía la estética en el motor.

## Estado ejecutable y Git

- Workspace: `C:/dev/ALABARDA_CYBERPUNK_H1`. F5 inicia `scenes/main.tscn`.
- Godot `4.7.2.stable.official.ed1daf0bf`, estándar; Windows 11 build 26200, Python 3.13.15, Git 2.54.0.windows.1.
- Ejecutable fuera de PATH: `C:/Users/aleja/Downloads/Godot_v4.7.2-stable_win64.exe/Godot_v4.7.2-stable_win64_console.exe`.
- Rama `h02-audit`; tree de entrada `a876fef52112f952de91a015903026e6f79cce9a`, ref `refs/h02/baseline`. Sin commits ni remote; no se inventó identidad Git. Índice con originales, trabajo H02 en working tree. Las retiradas/renombrados actuales son intencionados y autorizados.
- Project, escena, UIDs, controles y cifras de balance H1 conservados. Tres scripts corregidos; hashes originales y actuales en [snapshot](h02_runtime_snapshot.json). Arquitectura real en [ARCHITECTURE](ARCHITECTURE.md).

## Limpieza y comparación de documentos

No quedan archivos con (1). Los 22 prompts únicos con ese sufijo se renombraron; siguen existiendo los 23 prompts H02–H24. Los alias redundantes GDD raíz, DECISIONES, VALIDACION y cinco copias de docs se retiraron. Canónicos: `docs/GDD_TECNICO_H1.md`, `docs/DECISIONS.md` y `docs/VALIDATION.md`.

VALIDACION original era una checklist H1 aún no ejecutada; VALIDATION era el registro posterior de planificación/resultados. Eran diferentes. El primero se conserva íntegro en [histórico](history/pre_h02/docs/VALIDACION.md); el único registro activo ahora es VALIDATION, con resultados antiguos y nuevos separados. No se marcan casillas históricas retroactivamente.

Los 48 contenidos Markdown de entrada se recuperan por hash desde 42 históricos únicos; se deduplicaron seis copias idénticas. [Manifiesto](history/pre_h02/manifest.json) conserva rutas originales, actuales y de archivo. En la sesión se restauró el prompt H02 a petición del creador; posteriormente se normalizó su nombre. La desaparición del alias DECISIONS detectada antes queda resuelta por su retirada expresa, no por recrearlo.

## Correcciones y comprobaciones

- H1-B01: jugador/enemigo rechazan daño no positivo/no finito; HP del jugador limitado a rango válido.
- H1-B02: enemigo marca derrota antes de emitir señal, no se elimina dos veces ni ataca mientras espera queue_free.
- H1-B03: último impacto no borra victoria; R limpia el mensaje al reponer cinco blancos.
- Regresión con `--edges`: **34 PASS, 0 FAIL, 1 NOT_RUN** (clic completo headless). No se desactivaron los tres asserts que fallaban; se ampliaron sus casos límite.
- Importación, arranque, parseo individual de tres scripts e invariantes project/escena/UID: PASS, exit 0.
- Migración v2: cuatro comprobaciones PASS; segunda ejecución en repo real hace cero cambios. Preserva hashes y rechaza ediciones ajenas/colisiones sin pérdidas.
- Inventario/referencias: ver resultado actual en [VALIDATION](VALIDATION.md) y [reporte](evidence/h02/inventory_and_references.json). La fase inicial y sus FAIL permanecen documentados.

Comandos exactos, fechas, OS, versiones, exit codes y logs completos: [VALIDATION](VALIDATION.md) y [TEST_STRATEGY](TEST_STRATEGY.md). Headless no valida captura/clic físico; el creador sí los aprobó manualmente antes de estas correcciones, que no cambian esos controles. No hay framework previo instalado. PDF fuente ausente, export Windows y arte/licencias de packs siguen NOT_RUN y fuera de esta corrección H02.

## Decisiones expresas y futuros pendientes

APROBADAS por el creador el 2026-11-20: D-006 firmware activo al instalar USB; D-003 alarma general impide recuperar sigilo durante el resto del intento; D-009 Dead Eye ralentiza mundo con cualquier arma, compatibilidad solo para efectos específicos de arma. P-008/P-009/P-010 resueltas y documentos/prompts sincronizados; no se implementan esas mecánicas en H02.

P-012 corregida documentalmente: matriz de dificultades desde H13; H05/H10 prueban lo existente. P-011 duplicados/slots, P-013 ascensores/retorno y P-014 liberación de F siguen pendientes en H07/H18, H19 y H08. Son detalles futuros sin alternativas impuestas, no contradicciones activas. Balance, perks, assets, UX y DoD final siguen pendientes según sus hitos. [Trazabilidad de 33 requisitos](DOCUMENTATION_AUDIT.md).

## Confirmación manual posterior y cierre H02

La revisión solicitada tras corregir H02 era F5 → eliminar cinco blancos → comprobar mensaje de victoria → R → cinco blancos y mensaje limpio. El creador responde que ha hecho las pruebas y todo funciona, con mención expresa a controles y respawn; se acepta su confirmación conjunta, sin afirmar disponer de un desglose o log manual. **PASS manual declarado**, separado de los 34 PASS automáticos y del clic headless NOT_RUN. H02 queda cerrado por esa validación del creador, sin nueva implementación ni prueba atribuida a Codex. Registro completo en VALIDATION.

## Resumen para nuevo chat

Leer AGENTS y documentos actuales. H02 APROBADO POR CREADOR tras confirmación manual posterior: limpieza y tres bugs corregidos, regresión PASS, tres contradicciones creativas resueltas expresamente. Historial íntegro, cero archivos (1), VALIDATION canónico. H03 todavía requiere autorización propia. Prompt local: [H02](../prompts/H02_AUDITORIA_H1_Y_SANEAMIENTO_DOCUMENTAL.md).

PRE-H03: D-017 y ART_BIBLE fijan Modern PSX / Retro Industrial Cyberpunk; documentos y prompts sincronizados, sin trabajo de juego ni assets. [H03 preparado](../prompts/H03_INFRAESTRUCTURA_DE_PRUEBAS_Y_BALANCE.md) conserva infraestructura y balance y añade investigación/escena comparativa, medición y revisión visual; H04 sigue siendo vertical de arte. Parámetros y resultado visual requieren validación futura. No restaurar alias retirados, no confundir los FAIL históricos con resultados posteriores y no dar por aprobados tests/arte no ejecutados.
