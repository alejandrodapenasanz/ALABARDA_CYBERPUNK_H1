# ALABARDA STUDIOS — MASTER PIPELINE MIGRATION v2.0

## 0. INSTRUCCIÓN INICIAL OBLIGATORIA

Lee íntegramente `AGENTS.md` en la raíz del repositorio antes de realizar cualquier modificación.

Después inspecciona el repositorio completo y lee toda la documentación de diseño, producción, arquitectura, pruebas y continuidad disponible.

Como mínimo, si existen:

- `docs/ROADMAP.md`
- `docs/DEVELOPMENT_WORKFLOW.md`
- `docs/GAME_VISION.md`
- `docs/MVP_SCOPE.md`
- `docs/GAME_DESIGN.md`
- `docs/DECISIONS.md`
- `docs/ARCHITECTURE.md`
- `docs/BALANCE_PROVISIONAL.md`
- `docs/ART_BIBLE.md`
- `docs/ASSET_REGISTRY.md`
- `docs/TEST_STRATEGY.md`
- `docs/VALIDATION.md`
- `docs/HANDOFF.md`
- `docs/DOCUMENTATION_AUDIT.md`

Inspecciona también todos los prompts de hitos H02–H24 existentes, incluido el documento consolidado de prompts si lo hay.

Inspecciona `project.godot`, la estructura de escenas y scripts, el estado de Git y los tests existentes.

No supongas que todos los hitos están implementados ni que todos los documentos reflejan correctamente el estado actual.

Esta tarea es una **migración documental y de workflow**. No ejecutes ningún hito de gameplay ni modifiques código del juego salvo que sea estrictamente necesario para corregir una referencia documental o un archivo de configuración del pipeline.

Antes de modificar archivos, muestra un diagnóstico de la estructura real, posibles contradicciones, documentos duplicados y estado de los hitos.

---

# 1. OBJETIVO GENERAL

Transformar la pipeline de desarrollo del proyecto ALABARDA STUDIOS CYBERPUNK FPS.

El modelo anterior asumía que una única IA podía programar, ejecutar Godot, probar y documentar cada hito individualmente.

El nuevo modelo utiliza dos entornos asimétricos, con diferentes capacidades y presupuestos.

El objetivo es maximizar la producción de código en Claude y minimizar los créditos necesarios para validarlo con Codex.

También debemos incorporar nuevas decisiones de gameplay relativas a **dos barras independientes (salud y energía), su regeneración/curación** y a los controles, actualizando todas sus referencias documentales y prompts futuros.

No alterar funcionalidades creativas ya aprobadas salvo las sustituidas explícitamente en este documento.

---

# 2. NUEVA ARQUITECTURA DE TRABAJO

## 2.1. PC CLAUDE — PROGRAMACIÓN PRINCIPAL

Capacidades:

- Claude con créditos prácticamente ilimitados.
- Acceso al repositorio y archivos de código.
- Puede programar GDScript.
- Puede crear escenas `.tscn` en texto.
- Puede crear recursos `.tres`.
- Puede generar tests.
- Puede analizar arquitectura.
- Puede modificar documentación.
- Puede crear scripts auxiliares y automatizaciones.

Limitaciones:

- No tiene acceso a Godot.
- No tiene acceso a Blender.
- No puede comprobar visualmente escenas 3D.
- No puede ejecutar el videojuego.
- No puede validar animaciones, materiales ni iluminación en el motor.

Claude será el responsable principal de implementar los lotes de programación.

Se permite avanzar varios hitos relacionados en una misma conversación, respetando sus dependencias.

Debe generar commits separados por hito cuando sea posible, además de un paquete final de integración por lote.

Claude nunca podrá marcar una prueba Godot como PASS si no la ha ejecutado.

## 2.2. PC CODEX — INTEGRACIÓN Y VALIDACIÓN

Capacidades:

- Codex con créditos limitados.
- Acceso al repositorio.
- Godot instalado.
- Blender instalado.
- Puede importar modelos.
- Puede ejecutar escenas.
- Puede ejecutar tests.
- Puede comprobar errores de scripts y recursos.
- Puede generar capturas y evidencias cuando el entorno lo permita.
- Puede modificar código y escenas para resolver problemas de integración.

Codex tendrá principalmente estas responsabilidades:

1. Integrar el código producido por Claude.
2. Ejecutar las pruebas preparadas.
3. Validar la importación de escenas.
4. Verificar assets y animaciones.
5. Registrar errores reales.
6. Preparar informes de validación.
7. Corregir únicamente problemas pequeños y locales cuando sea razonable.

Los problemas estructurales o las correcciones grandes deben devolverse preferentemente a Claude.

No utilizar los créditos limitados de Codex para reescribir sistemas enteros que Claude puede corregir a partir de logs y evidencias.

## 2.3. DIRECTOR CREATIVO

El creador del proyecto conserva la responsabilidad de aprobar:

- Sensaciones de movimiento y combate.
- Dirección artística.
- Animaciones.
- Calidad del gunplay.
- Dificultad.
- Diseño de interfaces.
- Experiencia de usuario.
- Cierre definitivo de cada lote.

Ninguna IA puede autoaprobar un lote.

---

# 3. NUEVO MODELO DE DESARROLLO POR LOTES

Mantener los identificadores originales H02–H24 y todas sus funcionalidades aprobadas.

Introducir una capa adicional de agrupación.

Agrupación propuesta:

| Lote | Hitos | Dominio |
|---|---|---|
| B0 | H03–H04 | Infraestructura y dirección artística |
| B1 | H05–H06 | Movimiento, interacción, salud y daño |
| B2 | H07–H09 | Armas, energía y ultimates |
| B3 | H10–H12 | Enemigos, percepción y sigilo |
| B4 | H13–H15 | Persistencia, firmware y economía |
| B5 | H16–H18 | Guarida y equipamiento |
| B6 | H19–H21 | Contrato Yakuza, jefe y recompensas |
| B7 | H22 | Integración y UX |
| B8 | H23–H24 | Pulido y publicación Windows |

H02 es una auditoría previa y no pertenece a un lote nuevo.

Revisar dependencias reales antes de declarar cualquier agrupación viable.

No reordenar ni renumerar los hitos existentes sin aprobación.

El objetivo es que Claude pueda recibir un lote completo y desarrollar todos sus hitos, siempre que no exista un bloqueo crítico.

## 3.1. Checkpoints internos

Claude debe crear un checkpoint lógico al terminar cada hito del lote.

En cada checkpoint:

- Revisar cambios.
- Preparar pruebas.
- Documentar archivos afectados.
- Identificar dependencias.
- Registrar errores conocidos.
- Realizar commit si Git está configurado y las instrucciones del repositorio lo permiten.

El checkpoint no equivale a validación en Godot.

No continuar silenciosamente si existe un fallo estructural que invalida todos los hitos posteriores.

## 3.2. Trabajo adelantado

Se permite que Claude programe un lote posterior mientras Codex valida el anterior, únicamente si:

- Las interfaces necesarias están definidas.
- Las dependencias son suficientemente estables.
- No existen bloqueos críticos conocidos.
- Los cambios permanecen aislados en ramas de desarrollo.
- La implementación no depende de decisiones creativas pendientes.

No fusionar en la rama estable código sin validar.

---

# 4. ESTADOS OFICIALES

Utilizar estos estados:

- `NOT_STARTED`: trabajo no comenzado.
- `IN_PROGRESS`: implementación en curso.
- `CODE_READY`: Claude ha terminado el código y preparado las pruebas.
- `INTEGRATION_READY`: commit identificado y paquete de pruebas completo.
- `VALIDATION_FAILED`: se han detectado errores de integración o pruebas.
- `VALIDATED`: pruebas técnicas obligatorias superadas en el entorno adecuado.
- `APPROVED`: el creador ha aprobado expresamente el resultado.
- `BLOCKED`: existe un impedimento que requiere intervención.

Mantener también los estados individuales de pruebas:

- `PASS`
- `FAIL`
- `NOT_RUN`
- `BLOCKED`

Nunca equiparar `CODE_READY` con `VALIDATED`.

Nunca utilizar `APPROVED` sin aprobación expresa del creador.

No sobrescribir resultados históricos de validaciones anteriores.

---

# 5. PROTOCOLO OBLIGATORIO DE ENTREGA CLAUDE → CODEX

Al terminar cada lote, Claude debe generar obligatoriamente:

`validation/BXX/TEST_HANDOFF.md`

`validation/BXX/TEST_MANIFEST.json`

`validation/BXX/TEST_RESULTS.md`

Y una carpeta:

`validation/BXX/evidence/`

Crear plantillas reutilizables para estos archivos.

## 5.1. TEST_HANDOFF.md

Debe ser un documento completo, autónomo y ejecutable por otro agente.

Contenido mínimo:

### A. Identificación

- Lote.
- Hitos incluidos.
- Fecha.
- Rama.
- Commit SHA exacto.
- Versión Godot esperada.
- Estado de implementación.
- Sistemas afectados.

### B. Resumen funcional

Describir qué se ha programado.

No limitarse a enumerar archivos.

Explicar qué debería ser capaz de hacer el jugador.

### C. Archivos afectados

Lista de archivos:

- Nuevos.
- Modificados.
- Eliminados.
- Recursos y dependencias.
- Escenas principales.
- Tests.

### D. Dependencias

Indicar:

- Qué sistemas existentes utiliza.
- Qué escenas deben existir.
- Qué recursos son obligatorios.
- Qué funcionalidades todavía son placeholders.
- Qué trabajo depende de hitos futuros.

### E. Pruebas automáticas

Para cada prueba:

- Identificador único.
- Nombre.
- Propósito.
- Precondiciones.
- Comando exacto.
- Directorio de ejecución.
- Resultado esperado.
- Criterio PASS.
- Criterio FAIL.
- Tiempo de espera si corresponde.
- Archivos de evidencia.
- Dependencias de entorno.

No afirmar resultados sin ejecución.

### F. Pruebas manuales de Godot

Para cada caso:

- Escena exacta.
- Cómo abrirla.
- Cómo ejecutarla.
- Controles.
- Estado inicial.
- Pasos numerados.
- Resultado esperado observable.
- Resultado que indicaría un fallo.
- Capturas o logs necesarios.
- Condiciones para repetir la prueba.

Las instrucciones deben ser suficientemente precisas para que Codex no tenga que inferir lo que se pretendía implementar.

### G. Pruebas de regresión

Explicar qué hitos anteriores podrían verse afectados y cómo comprobarlos.

### H. Problemas conocidos

Incluir errores, limitaciones y funcionalidades no terminadas.

### I. Checklist del creador

Pruebas de sensaciones, arte y jugabilidad que una IA no debe autoaprobar.

### J. Criterios de aceptación

Definir qué significa que el lote funcione correctamente.

### K. Instrucciones de recuperación

Cómo volver al commit anterior o aislar un fallo de integración.

## 5.2. TEST_MANIFEST.json

Crear un esquema JSON estable, versionado y validable.

Debe incluir al menos:

- Versión del esquema.
- Identificador del lote.
- Hitos.
- Commit.
- Entorno requerido.
- Lista de pruebas.
- Tipo de prueba.
- Comando, si es automático.
- Precondiciones.
- Resultado esperado.
- Dependencias.
- Ruta de logs.
- Estado inicial `NOT_RUN`.

No introducir comandos destructivos.

El manifiesto debe permitir que un futuro script de PowerShell ejecute automáticamente las pruebas compatibles.

Añadir comprobaciones sintácticas del JSON.

## 5.3. TEST_RESULTS.md

Claude crea la plantilla, pero NO registra como ejecutadas las pruebas que requieren Godot.

Codex o el creador completarán posteriormente:

- Commit realmente probado.
- Entorno.
- Comandos ejecutados.
- Exit codes.
- Resultado.
- Logs.
- Capturas.
- Bugs.
- Regresiones.
- Veredicto técnico.

Los resultados deben poder relacionarse inequívocamente con el commit probado.

## 5.4. Informes de errores

Crear una plantilla reutilizable `BUG_REPORT.md`.

Campos:

- Identificador.
- Hito.
- Commit.
- Severidad.
- Sistema afectado.
- Pasos de reproducción.
- Resultado esperado.
- Resultado observado.
- Log.
- Captura, si existe.
- Sospecha diagnóstica, claramente marcada como hipótesis.
- Estado.
- Fix commit, cuando exista.
- Prueba de regresión asociada.

---

# 6. PROMPT ESTÁNDAR PARA CODEX VALIDADOR

Crear una plantilla:

`prompts/_templates/CODEX_VALIDATE_BATCH.md`

Debe comenzar obligatoriamente leyendo `AGENTS.md`.

Después debe leer:

- `DEVELOPMENT_WORKFLOW.md`
- `TEST_HANDOFF.md` del lote.
- `TEST_MANIFEST.json`.
- `TEST_STRATEGY.md`.
- `VALIDATION.md`.
- `HANDOFF.md`.
- Documentación técnica relevante.

Debe comprobar el commit esperado antes de ejecutar pruebas.

Si el commit no coincide, detenerse e informar.

Prioridades:

1. No inventar resultados.
2. Ejecutar las pruebas ya preparadas.
3. Reutilizar scripts y automatizaciones existentes.
4. Minimizar modificaciones innecesarias.
5. No ampliar funcionalidades.
6. Registrar errores exactos.
7. Generar evidencias.
8. Devolver un informe para Claude.
9. No aprobar el lote automáticamente.

Solo debe utilizar Blender cuando la prueba realmente requiera inspección o adaptación de modelos.

No debe iniciar el siguiente lote.

---

# 7. PROMPT ESTÁNDAR PARA CLAUDE PROGRAMADOR

Crear:

`prompts/_templates/CLAUDE_IMPLEMENT_BATCH.md`

Debe comenzar obligatoriamente leyendo `AGENTS.md`.

Después debe leer los documentos relevantes, los prompts originales de los hitos incluidos y el estado del repositorio.

Responsabilidades:

- Implementar el lote completo.
- Mantener separación por hitos.
- Respetar interfaces.
- Crear tests.
- Preparar escenas de prueba.
- Generar datos de prueba.
- Registrar limitaciones.
- Realizar commits separados cuando sea posible.
- Generar TEST_HANDOFF.
- Generar TEST_MANIFEST.
- Preparar TEST_RESULTS.
- Actualizar HANDOFF y ROADMAP.
- Dejar el trabajo preparado para Codex.

No declarar tests Godot como PASS.

No marcar el lote como aprobado.

No ejecutar hitos ajenos al lote.

---

# 8. SISTEMA DEFINITIVO DE DOS BARRAS — CAMBIO CREATIVO APROBADO

**Esta sección sustituye íntegramente las reglas antiguas sobre extracción manual de energía y elimina la ambigüedad anterior entre salud y energía. Es una decisión expresa del creador.** Sin embargo, los valores numéricos de regeneración y curación indicados como provisionales NO quedan aprobados como balance final.

## 8.1. Dos recursos diferentes y claramente separados

**SALUD (HP):** mínimo 0, máximo **100**. Es la vida real del personaje. Recibir daño la reduce; llegar a 0 provoca la muerte según las reglas vigentes del contrato. No puede superar 100.

**ENERGÍA:** mínimo 0, máximo **150**. Es un recurso independiente que permite curarse activamente manteniendo **E** y activar la ultimate. No representa la vida del personaje. No puede superar 150.

Ambas barras deben mostrarse por separado y con nombres inequívocos en el diseño del HUD. No confundir «tener 150 de energía» con «tener 150 HP». La salud NO se incrementa automáticamente al matar enemigos: las bajas rellenan la energía, y el jugador decide si gastarla en curación o ultimate.

## 8.2. Cómo se gana energía (0–150)

El sistema antiguo de agarrar enemigos y mantener F para robar energía queda **SUPERSEDED** como fuente de energía. No implementar la extracción manual como requisito de recarga, ni mantener dependencias funcionales de esa mecánica obsoleta.

**Zona 0–100:** la energía aumenta por regeneración pasiva durante el tiempo y por bajas confirmadas del jugador.

**Zona 100–150:** la regeneración pasiva NO puede aumentar la energía por encima de 100. Solo las bajas confirmadas del jugador pueden rellenar esta zona.

Una baja puede añadir energía tanto por debajo como por encima de 100; puede cruzar 100 y continuar hasta un máximo de 150. Si se registra una baja mientras el personaje tiene, por ejemplo, 95 de energía, una ganancia de 15 debe dejarlo en 110, no en 100.

**Regla de balance provisional:** regeneración pasiva de energía **8 puntos/segundo**, constante cuando el personaje está vivo y la energía es menor de 100, sin exigir estar fuera de combate. Una baja confirmada concede **+15 energía** independientemente del arquetipo enemigo (modificadores futuros no incluidos en el MVP hasta aprobación). Todos los valores deben residir en configuración editable, no en constantes dispersas. Estos valores son de prototipado y se etiquetarán `PROVISIONAL_VALUE`.

## 8.3. Regeneración automática de SALUD (sin consumir energía)

Además de la curación manual, la salud se regenera **automáticamente tras pasar un tiempo sin recibir daño**.

**Valores provisionales solicitados para arrancar:**

- Retraso desde el último daño recibido: **5,0 segundos**.
- Recuperación automática: **5 HP/segundo**.
- Tope: **100 HP**.
- Recibir daño reinicia por completo la espera de 5 segundos, aunque la regeneración hubiera empezado.
- La regeneración se detiene si el jugador está muerto y no puede revivirlo.
- La regeneración automática no consume energía, no aumenta energía y no depende de matar enemigos.

Estos valores son configurables para equilibrarlos tras playtests y no deben confundirse con valores definitivos aprobados.

## 8.4. Curación MANUAL manteniendo E (consume energía)

Se **confirma expresamente** que el jugador puede curarse manteniendo la tecla **E**:

- Mientras E se mantiene y el jugador está vivo, la salud aumenta de forma continua, nunca por encima de 100.
- Cada punto de curación manual consume energía de la barra 0–150.
- Si no queda energía, la curación manual se detiene.
- Si la salud ya está al máximo, no se consume energía.
- Al soltar E, la curación manual termina.
- La energía usada para curar deja de estar disponible para la ultimate: este intercambio es deliberado.
- La curación manual puede utilizarse sin esperar a que transcurran los cinco segundos de regeneración automática.
- Recibir daño no interrumpe automáticamente la curación manual; puede seguir mientras se mantenga E, siempre que el jugador sobreviva.

**Balance provisional:** curación manual **25 HP/segundo** con coste **25 energía/segundo** (relación inicial 1:1). Configurable y sujeto a pruebas.

**Regla provisional para evitar doble curación simultánea:** mientras el jugador mantenga E y la curación manual esté activa, se pausa la regeneración automática de salud. Al soltar E, se reanuda la regeneración automática si el retraso desde el último daño ya ha transcurrido. Registrar esta regla como `PROVISIONAL_VALUE / PENDING_PLAYTEST`, no como decisión creativa irrevocable.

**Prioridad de controles:** E queda reservada para curación manual mientras se mantenga, incluso si el personaje tiene un objeto interactivo cerca; la interacción del mundo debe reasignarse a otra acción diferenciada en el input map antes de implementar ambos sistemas juntos. La tecla definitiva de interacción no ha sido aprobada: marcar `PENDING_APPROVAL` y preparar una solución configurable sin asumir silenciosamente otra tecla. No sacrificar el control E de curación.

## 8.5. Ultimate — energía compartida

Mantener reglas ya aprobadas:

- La ultimate está disponible con **100 o más de energía**, independientemente de los HP actuales.
- Solo una ultimate puede estar equipada.
- Al activarla, consume **toda** la energía actual (entre 100 y 150).
- La duración escala con la energía **previa** al consumo; solo escala duración, no potencia.
- Dead Eye ralentiza el mundo inicialmente al 50 %, manteniendo al jugador a velocidad normal.
- Aimbot resalta cabezas visibles y ofrece asistencia intensa al ratón sin disparar automáticamente.
- Overdrive aumenta la cadencia y potencia de armas de fuego.
- Las compatibilidades con armas siguen las reglas aprobadas.
- Los ascensores recargan la energía a 150, tal como se había aprobado; esto NO implica curar automáticamente la salud.

**Duración provisional de prueba:** 6 s al activar con 100 puntos y 10 s al activar con 150, interpolación lineal entre ambos; parámetros editables y `PROVISIONAL_VALUE`.

## 8.6. Separación de responsabilidades e implementación futura

Modelar `HealthSystem` y `EnergySystem` como sistemas independientes con interfaces explícitas. La curación manual coordina ambos, descontando energía únicamente por HP efectivamente recuperados. Evitar consumos negativos, sobregiros, redondeos que generen salud o energía gratis y dependencias circulares entre recursos.

Las ejecuciones, remates y posibles animaciones especiales de combate son cuestiones de diseño independientes: el cambio elimina la extracción manual como mecánica de energía, **pero no autoriza a borrar silenciosamente el resto del combate o las mecánicas de remate previamente documentadas**. Marcar las referencias a ejecuciones antiguas para revisión de compatibilidad; no programar ejecuciones dependientes de F para obtener energía.

Mantener los sistemas de salud/energía fuera de la implementación actual si sus hitos todavía no han comenzado. En esta migración, **solo actualizar documentos, prompts, balance provisional y contratos de pruebas**.

## 8.7. Parámetros editables obligatorios

Incluir en `docs/BALANCE_PROVISIONAL.md` y en el diseño de configuración futura:

- `health_max = 100` (regla aprobada).
- `energy_max = 150` (regla aprobada).
- `energy_passive_cap = 100` (regla aprobada).
- `ultimate_activation_min = 100` (regla aprobada).
- `health_auto_regen_delay_s = 5.0` (provisional).
- `health_auto_regen_hp_per_s = 5.0` (provisional).
- `health_manual_heal_hp_per_s = 25.0` (provisional).
- `health_manual_energy_cost_per_s = 25.0` (provisional).
- `energy_passive_regen_per_s = 8.0` (provisional).
- `energy_per_kill = 15.0` (provisional).
- `manual_heal_pauses_auto_regen = true` (provisional).
- `ultimate_duration_at_100_s = 6.0` (provisional).
- `ultimate_duration_at_150_s = 10.0` (provisional).

No tratar estas claves como nombres de archivos o API obligatorios: adaptar a convenciones reales del repositorio, preservando semántica, unidades y trazabilidad.

## 8.8. Tests futuros OBLIGATORIOS: salud, energía y curación

Preparar los tests en los prompts correspondientes (especialmente H06, H08, H09 y H22), aunque la migración documental no ejecute gameplay:

**Salud y regeneración automática:**
1. HP empieza dentro de 0–100 y siempre se mantiene en ese intervalo.
2. Antes de 5 segundos sin recibir daño, la regeneración automática no empieza.
3. Tras 5 segundos sin daño, recupera 5 HP/s (con tolerancia numérica adecuada y delta time).
4. Un nuevo golpe reinicia la cuenta atrás, aunque ya estuviera regenerando.
5. La regeneración automática se detiene a 100 HP.
6. A 0 HP, el jugador está muerto y no se regenera ni revive.
7. La regeneración automática no consume energía.

**Curación manual E:**
8. Mantener E con HP incompletos y energía disponible resta energía y aumenta HP de manera continua.
9. Soltar E termina la curación manual.
10. Mantener E con energía 0 no cura.
11. Mantener E con salud 100 no consume energía.
12. Con poca energía, se cura solo lo permitido por el recurso restante; nunca se generan puntos gratis.
13. Daño durante la curación no cancela el input si el jugador sigue vivo.
14. Curación manual y automática no se duplican mientras E activa, según regla provisional.
15. Prueba de conflicto E / interacción del mundo: ambas acciones deben poder ejecutarse sin ambigüedad con bindings distintos.

**Energía:**
16. Energía siempre entre 0 y 150.
17. La regeneración pasiva aumenta hasta 100 y nunca lo supera por sí sola.
18. Una baja aumenta energía por debajo y por encima de 100, incluso cruzando el umbral.
19. Una baja con energía 145 queda limitada a 150.
20. Sin bajas, la espera no aumenta energía de 100 a 150.
21. La curación manual consume energía y puede bajar de 100 a menos de 100.
22. No se consume energía adicional cuando la salud está completa.

**Ultimates y regresión:**
23. Por debajo de 100 energía, no se puede activar una ultimate.
24. Con 100–150, consume toda la energía y calcula duración usando el valor previo.
25. Salud y energía son independientes: recibir daño no resta energía salvo que otra mecánica aprobada lo especifique.
26. La muerte no puede provocar regeneración, curación manual ni ultimates.
27. Ascensor restaura energía a 150 sin modificar HP.
28. No existe dependencia funcional obligatoria de la antigua extracción manual mediante F.
29. Los tests y documentos históricos que presupongan extracción con F quedan etiquetados `SUPERSEDED`, nunca PASS vigente.

Registrar resultados reales; todos los tests dependientes de Godot que Claude no pueda ejecutar quedan `NOT_RUN` hasta validación en el PC Codex.
---

# 9. NUEVO SISTEMA DE CONTROLES — CAMBIO APROBADO

Actualizar los documentos de diseño y los prompts correspondientes.

## 9.1. Movimiento

Controles:

- W: adelante.
- A: izquierda.
- S: atrás.
- D: derecha.

## 9.2. Dash mediante doble pulsación

Dos pulsaciones rápidas de la misma tecla provocan un dash en esa dirección:

- WW: adelante.
- AA: izquierda.
- SS: atrás.
- DD: derecha.

Requisitos:

- Detectar doble pulsación dentro de una ventana temporal configurable.
- No interpretar WA, WD, AS, etc. como doble pulsación.
- Ejecutar el dash en la dirección correspondiente al movimiento.
- Mantener un cooldown configurable.
- Evitar activaciones múltiples por un único doble toque.
- Gestionar pulsaciones durante animaciones y estados incompatibles.
- Conservar compatibilidad con el movimiento normal.
- Permitir ajustar la ventana temporal para evitar dashes accidentales.

El dash debe ser una mecánica de movimiento, no depender de tener equipada una build Ninja.

Las perks podrán modificar su comportamiento posteriormente.

## 9.3. Equipamiento

Teclas:

- 1: arma cuerpo a cuerpo.
- 2: arma principal.
- 3: arma secundaria.

Comportamiento:

Si no hay un arma equipada y se pulsa 1, se equipa el arma del slot 1.

Si vuelve a pulsarse 1 mientras esa misma arma está equipada, se guarda.

Lo mismo con 2 y 3.

Si está equipada el arma 1 y se pulsa 2, debe cambiar directamente al arma 2.

No realizar una transición completa de guardado seguida de un estado desarmado obligatorio antes de cambiar de arma, salvo las animaciones de transición necesarias.

El comportamiento final debe resultar rápido y fluido.

Durante cambios de arma, evitar entradas simultáneas que provoquen estados inconsistentes.

## 9.4. Compatibilidad con la libertad de loadout

Existe una decisión anterior que permitía llevar tres armas cualesquiera sin restricciones.

El nuevo esquema describe las teclas como cuerpo a cuerpo, principal y secundaria.

No eliminar silenciosamente la libertad de equipamiento.

Documentar esta tensión como una decisión pendiente de precisión.

Hasta aclararla, separar:

- Identificador de slot.
- Etiqueta funcional.
- Arma asignada.
- Restricciones reales de equipamiento.

No introducir reglas de inventario adicionales por inferencia.

## 9.5. Otros controles

Revisar posibles conflictos con:

- Interacción.
- Recarga.
- Salto.
- Sprint.
- Ultimate.
- Curación.
- Menús.
- Pausa.
- Acciones contextuales.

No reasignar de forma arbitraria controles no confirmados.

Preparar una tabla única de controles aprobados y pendientes.

## 9.6. Tests futuros

- Selección 1, 2 y 3.
- Pulsar la misma tecla guarda el arma.
- Cambiar a otro slot equipa directamente la nueva arma.
- Pulsar una tecla de slot vacío no bloquea el jugador.
- Cambios rápidos entre slots.
- Dash WW, AA, SS y DD.
- Pulsaciones separadas no activan dash.
- Pulsaciones de distintas teclas no activan dash.
- Cooldown.
- Sin activaciones repetidas por el mismo evento.
- Regresión de movimiento y disparo.

---

# 10. ARCHIVOS QUE SE DEBEN ACTUALIZAR

## 10.1. AGENTS.md

Actualizar las instrucciones maestras para incorporar:

- Dos PCs con capacidades diferentes.
- Claude como desarrollador principal.
- Codex como validador.
- Desarrollo por lotes.
- Estados de implementación y aprobación.
- Paquetes de transferencia obligatorios.
- Prohibición de inventar pruebas ejecutadas.
- Política de gestión de errores.
- Obligación de consultar documentación vigente.
- Jerarquía de decisiones aprobadas.
- Continuidad entre chats.
- Política de assets y licencias.
- Separación entre código escrito y código validado.

Conservar las reglas existentes que sigan siendo válidas.

Evitar duplicaciones y contradicciones.

## 10.2. DEVELOPMENT_WORKFLOW.md

Revisar o crear como fuente principal del nuevo flujo operativo.

Documentar detalladamente el trabajo Claude → Codex → Claude → aprobación.

Incluir un procedimiento para sincronizar cambios mediante Git, con ramas y commits trazables.

No asumir que ambos entornos tienen las mismas herramientas.

## 10.3. ROADMAP.md

Mantener los hitos H02–H24.

Añadir los lotes B0–B8.

Documentar las dependencias.

Distinguir estado individual del hito y estado del lote.

Actualizar el protocolo de aprobación.

No marcar como implementados hitos futuros.

## 10.4. GAME_DESIGN.md

Actualizar:

- Energía por regeneración pasiva hasta 100 y bajas hasta 150; salud independiente de 0–100.
- Supresión de extracción manual obligatoria.
- Controles.
- Dash.
- Selección y guardado de armas.
- Curación manual confirmada manteniendo E y regeneración automática de salud después de 5 segundos sin recibir daño (valores provisionales).
- Relación con ultimates.
- Compatibilidad con firmware.

No alterar las otras mecánicas aprobadas.

## 10.5. DECISIONS.md

Registrar formalmente:

- Nuevo workflow.
- Nuevo sistema de salud (regeneración automática y curación manual con E) y energía, ambos separados.
- Nuevos controles.
- Dependencias y decisiones pendientes.

Las decisiones sustituidas deben quedar registradas como SUPERSEDED, preservando su histórico.

No eliminar registros antiguos sin trazabilidad.

## 10.6. BALANCE_PROVISIONAL.md

Añadir la configuración del nuevo sistema energético y el doble toque del dash.

Retirar las fórmulas anteriores de extracción manual de los parámetros vigentes.

Mantener los valores anteriores como históricos si hace falta para trazabilidad.

## 10.7. ARCHITECTURE.md

Añadir los contratos técnicos previstos para:

- EnergySystem.
- HealthSystem.
- InputController.
- DashController.
- WeaponSlotController.
- UltimateController.

Son nombres conceptuales: adaptar a la arquitectura real del repositorio.

Distinguir diseño previsto de implementación efectiva.

## 10.8. TEST_STRATEGY.md

Incorporar pruebas en dos entornos.

Explicar:

- Tests preparables por Claude.
- Tests ejecutables sin Godot.
- Tests exclusivos del PC Codex.
- Pruebas manuales.
- Informes de transferencia.
- Validación por commit.
- Regresiones obligatorias.
- Repetición tras corrección.

## 10.9. VALIDATION.md

Registrar la migración documental.

No borrar resultados históricos.

No convertir tests no ejecutados en PASS.

## 10.10. HANDOFF.md

Actualizar el estado actual del proyecto y el nuevo método de trabajo.

Indicar qué debe leer Claude para comenzar B1.

## 10.11. MVP_SCOPE.md y GAME_VISION.md

Sincronizar las nuevas decisiones de gameplay cuando corresponda.

No ampliar el MVP.

## 10.12. Prompts de hitos

Revisar TODOS los prompts H02–H24 disponibles.

Para cada uno:

1. Mantener objetivo funcional.
2. Mantener numeración.
3. Actualizar referencias documentales.
4. Incorporar el nuevo workflow.
5. Distinguir tareas de Claude y Codex.
6. Eliminar requisitos obsoletos.
7. Añadir pruebas y paquete de transferencia.
8. Mantener criterios de aceptación.
9. Evitar asumir acceso a Godot en Claude.
10. Evitar que Codex tenga que reconstruir requisitos no documentados.

Prestar especial atención a:

- H05: movimiento y dash.
- H07: selección de armas.
- H06: salud y regeneración automática (5 s y 5 HP/s provisionales).
- H08: energía y curación manual mediante E (25 HP/s y 25 energía/s provisionales).
- H09: ultimates.
- H13–H15: firmware, persistencia y economía.
- H22: integración general.

Si existe `PROMPTS_TODOS.md`, sincronizarlo con los prompts individuales.

No mantener dos versiones contradictorias.

## 10.13. Plantillas nuevas

Crear:

- `prompts/_templates/CLAUDE_IMPLEMENT_BATCH.md`
- `prompts/_templates/CODEX_VALIDATE_BATCH.md`
- `prompts/_templates/CLAUDE_FIX_BATCH.md`
- `validation/_templates/TEST_HANDOFF.md`
- `validation/_templates/TEST_MANIFEST.json`
- `validation/_templates/TEST_RESULTS.md`
- `validation/_templates/BUG_REPORT.md`

Crear también un documento con los prompts específicos de B0–B8 si la estructura del repositorio lo permite.

---

# 11. VALIDACIÓN DE ESTA MIGRACIÓN

Esta tarea debe verificar:

- No se han cambiado scripts de gameplay.
- No se han alterado escenas de producción.
- Los hitos conservan su numeración.
- Los lotes tienen dependencias documentadas.
- AGENTS y DEVELOPMENT_WORKFLOW son coherentes.
- Todos los prompts relevantes siguen las nuevas reglas.
- Los prompts futuros no requieren obligatoriamente Godot en el PC Claude.
- Existen plantillas de transferencia.
- El esquema JSON es válido.
- Las referencias Markdown a rutas existentes son correctas.
- El sistema de extracción manual de energía está marcado como sustituido; la salud 0–100 y energía 0–150 quedan inequívocamente separadas.
- La regeneración automática de HP y la curación manual con E aparecen de manera consistente en GAME_DESIGN, DECISIONS, BALANCE_PROVISIONAL y prompts relevantes.
- Los valores 5 s, 5 HP/s, 25 HP/s, 25 energía/s, 8 energía/s y +15 por baja figuran como provisionales.
- El conflicto de controles E (curación frente a interacción) está registrado y no se resuelve por suposición.
- Los nuevos controles están documentados.
- Las ambigüedades pendientes están identificadas.
- No hay pruebas ficticias.
- No se han marcado hitos como aprobados sin evidencia.

Registrar los resultados reales de las comprobaciones realizadas.

---

# 12. ENTREGA FINAL

Devuelve un informe con estas secciones:

1. Estado de la migración.
2. Estado original del repositorio.
3. Archivos modificados.
4. Archivos creados.
5. Cambios en AGENTS.md.
6. Cambios en DEVELOPMENT_WORKFLOW.md.
7. Agrupación definitiva de hitos.
8. Prompts actualizados.
9. Sistema de dos barras, regeneración automática de salud, curación manual con E y nueva recarga de energía documentados.
10. Nuevos controles documentados.
11. Conflictos o decisiones pendientes.
12. Comprobaciones realizadas.
13. Pruebas no ejecutadas.
14. Preparación para B1.
15. Instrucciones exactas para comenzar B1 en un nuevo chat de Claude.

No comenzar a programar B1 durante esta migración.

No ejecutar H03, H04 ni otros hitos.

No autoaprobar la migración.

El objetivo es dejar el repositorio preparado para desarrollar por lotes de manera rápida, reproducible y coordinada, utilizando Claude para programación intensiva y Codex para validación técnica en Godot.

**La migración termina cuando toda la documentación, los prompts y el protocolo de transferencia representan fielmente este nuevo modelo de trabajo.**