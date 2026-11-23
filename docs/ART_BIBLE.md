# ART_BIBLE — dirección vigente y registro de referencia

**2026-11-22 · sincronización v2.1.** D-017/D-019/D-020/D-021 se conservan. H03/H04 aprobados como referencia experimental; no arte final. Para nueva UI/animación, [contrato salud/energía](HEALTH_ENERGY_CONTRACT.md) y [controles](CONTROLS.md): salud roja0–100, energía azul0–150, autoHP y E distintos de energía por bajas; F extracción SUPERSEDED. No se cambian assets, paleta ni shaders ahora. Claude prepara; Codex prueba render/import; creador aprueba según [workflow](DEVELOPMENT_WORKFLOW.md).

Los apartados de entregas H03/H04/PRE-H03 inferiores son registro fechado: sus estados pendientes son históricos cuando D-019–D-021 los resolvieron. Las reglas de dirección artística siguen vigentes; futuras pruebas no descritas no heredan aprobación. [Original anterior íntegro](history/pre_pipeline_v2_1/docs/ART_BIBLE.md).

# ART_BIBLE — Modern PSX / Retro Industrial Cyberpunk

**Cierre H04 aprobado · 2026-11-22 · D-021:** el creador confirma que todo encaja tras revisar la lista de aspecto, legibilidad en tres luces, cámaras/animación y regresión. La sala, paleta/materiales y señales HomeVideo quedan aceptadas como referencia experimental en el contexto entregado. D-019 sigue siendo el perfil predeterminado; no se aprueban assets finales ni máximos universales de geometría/textura/rendimiento. Los estados PENDING_APPROVAL de la entrega inferior son anteriores a esta confirmación.

## Vertical H04 entregada para revisión · 2026-11-22

La misma sala H03 evoluciona a taller de referencia: paneles de servicio, armario, cajas ambientales, conducciones, señales HomeVideo, escritorio/CRT, industria y silueta. La revisión artística H04 sigue **PENDING_APPROVAL**. D-019/D-020 se mantienen; no hay aprobación de assets finales ni nuevo límite de producción.

Reglas de trabajo medibles de esta muestra, no presupuestos finales:

| Aspecto | Implementación comprobada / alcance |
|---|---|
| Paleta de kit propio | Pintura #354c50, metal #74817b, base #161f24, ocre #af8749; suelo #535751. Valores provisionales en lookdev.tres; no cambian salud roja/energía azul. |
| Materiales | Procedural 64² de contraste reducido, mipmaps; imports fuente intactos. Instancias externas con roughness mínimo 0.78 y metallic máximo 0.3, escritorio/barril con tinte moderado. No se afirma densidad uniforme entre UV de packs. |
| Geometría / escala | Panel 104 tri / 2×3 m; armario 248 tri / 1.1×2 m; caja 124 tri / 0.71×0.49 m. Metros, Y-up, pivote al suelo, UV presentes. Son conteos observados, no máximos por categoría. |
| Luz | Base D-019: ambiente 0.24, direccional 0.38, dos puntos 1.8/rango 6.5 m. Neutra: 0.65/1.0/puntos apagados. Alarma de inspección: ambiente 0.28/direccional 0.45, rojo cálido y contraluz frío. No sistema jugable de alarma. |
| Silueta | Casco/visor, hombros, pecho, cinturón, rodillas y botas separados por forma/valor; maniquí estático, sin arquetipo final ni IA. |
| Tipografía | HomeVideo 40 px en señales físicas 320×128; filtro lineal exclusivo para texto de viewport para evitar pérdida de trazos en minificación. UI externa y panel comparativo conservados. |
| Presentación | 1280×720 interno, nearest+mips, sombras sí, retro/niebla no. X/B/slider permiten estudiar retro sin cambiar la decisión vigente. Cuatro cámaras y M para oscilación de inspección. |

Pipeline Blender 4.5.3 → GLB → Godot verificada con tres props propios; fuentes, hashes y procedencia en ASSET_REGISTRY. Malorian permanece prueba local opcional, rig de brazos separado; no arma/animación de equipar final. Cajas son propias, no pickups ni PSXAmmoBoxes.

Capturas originales finales: [atmósfera general](evidence/h04/run_02/graphics/atmospheric_camera_1.png), [neutra / CRT](evidence/h04/run_02/graphics/neutral_camera_2.png), [alarma / silueta](evidence/h04/run_02/graphics/alarm_camera_3.png), [brazos](evidence/h04/run_02/graphics/atmospheric_camera_4.png). El primer preview mostró materiales Blender demasiado claros (conversión sRGB corregida) y pérdida de trazos del texto reducido (resolución/filtro ajustados); sus capturas siguen conservadas.

Rendimiento de esta sala: 70 meshes/88 materiales; 410 draw calls con sombras y 131 sin ellas, incluyendo pases/UI. RTX 4050 Laptop/Ryzen 7 7735HS, OpenGL 3.3 NVIDIA 621.24, ventana e interno 1280×720, VSync off, foco true en cinco lecturas, 60 frames de calentamiento +180 muestras. Medias: atmósfera 2.228 ms, neutra 2.155, alarma 2.100, sin sombras 1.111, repetición atmósfera 2.290. [Datos crudos y p95](evidence/h04/run_02/graphics/metrics.json). Wall-clock entre frames, no tiempo GPU exclusivo; no demuestra rendimiento de contrato, otros equipos o sesiones largas. La reducción de sombras baja coste en esta medición, sin cambiar el perfil aprobado.

Pendientes humanos: coherencia del desgaste original de mesa/ventilación frente al kit, lectura de señales/silueta en movimiento y luces, encuadre del viewmodel, calidad a 960×540. No se usa un PASS técnico para resolver preferencias. Los apartados anteriores en fecha siguen debajo como antecedentes.

**Cierre H03 aprobado por el creador · 2026-11-22:** perfil D-019 aceptado, HomeVideo preferida y legible en la muestra (D-020), animación de brazos confirmada. Esta aprobación de la referencia experimental cierra H03; no aprueba assets finales, otros tamaños no probados ni un HUD global HomeVideo. Los estados de revisión pendiente de los apartados históricos inferiores corresponden a fases previas.

**Perfil aprobado por el creador · 2026-11-22 · D-019:** Nearest+mips, luz atmosférica, 3D 1280×720, retro apagado, sombras sí, niebla no. Vigente y revisable por decisión futura. El slider de retro permanece al 70% pero no altera la imagen mientras el efecto esté desactivado. Abrir/restaurar el laboratorio reproduce esta selección; sustituye el reset neutro de diagnóstico documentado más abajo. La aprobación corresponde al perfil mostrado, sin convertir los packs de prueba en assets finales ni validar otras pruebas por inferencia.

> **Antecedente correctivo H03 · 2026-11-22:** laboratorio corregido tras capturas del creador; ver revisión final del documento. Dirección D-017 intacta; la aprobación posterior figura al principio. Los apartados PRE-H03/2026-11-21 conservan su contexto histórico.

**Versión 1.0 · 2026-11-20 · Dirección artística APROBADA (D-017).** Fuente principal de arte. Los parámetros técnicos marcados PROPUESTA siguen pendientes de validación en H03; ningún asset ni resultado visual queda aprobado por este documento. [Decisión y sustituciones](DECISIONS.md), [registro de assets](ASSET_REGISTRY.md).

## Identidad y filosofía aprobadas

**MODERN PSX / RETRO INDUSTRIAL CYBERPUNK.** Reinterpretar el lenguaje 3D de finales de los noventa para un FPS actual: cómo recordamos visualmente los juegos de PS1, sin reproducir literalmente sus limitaciones de hardware. La identidad retro debe convivir con controles, animaciones, iluminación y legibilidad modernas.

Se conservan los pilares retro industrial, cyberpunk decadente, tecnología obsoleta y atmósfera nocturna. «PS1 graphics», «retro low-poly», «PSX horror» o «Cyberpunk PS1» dejan de ser definiciones suficientes del estilo; no obligan a emulación técnica ni convierten el proyecto en un juego de terror. Los históricos se conservan como antecedentes.

Prioridades, en este orden:

1. Identidad artística reconocible.
2. Atmósfera cyberpunk industrial.
3. Coherencia visual entre assets.
4. Legibilidad en combate y sigilo.
5. Siluetas claras de personajes, enemigos y armas.
6. Geometría low-poly deliberadamente simplificada.
7. Texturas de baja resolución usadas con intención.
8. Iluminación expresiva y contrastada.
9. Sensación retro auténtica.
10. Rendimiento estable en PC.

La fidelidad al hardware original no es una prioridad. Ningún recurso estilístico debe hacer injustamente difícil detectar enemigos, proyectiles, peligros o interactuables.

## Geometría y materiales

Formas angulosas, siluetas expresivas, superficies amplias y geometría industrial contundente. Modelar el detalle que cambia la lectura; llevar detalles secundarios a texturas. Preferir componentes modulares para escenarios y reservar más detalle para armas y brazo en primera persona que para decoración lejana.

Evitar modelos hiperrealistas, personajes cartoon brillantes, redondeado innecesario y densidades de detalle incompatibles entre packs. No hay un límite universal de polígonos aprobado: H03 propondrá presupuestos por categoría tras medir escala, distancia de cámara y coste.

Metal desgastado, hormigón, plástico, madera y pintura envejecida forman un vocabulario común. Materiales y desgaste deben apoyar las formas y su función; mantener escala, respuesta a la luz y nivel de detalle coherentes. Evitar superficies fotográficas sin tratamiento o mezcla arbitraria de materiales hiperrealistas y modelos simples. Los ajustes concretos de materiales se compararán en Godot; no se prescribe un shader obligatorio.

## Texturas y filtrado

Pixelado visible y controlado, señalética retrofuturista, carteles y pantallas con personalidad, sin ruido que impida reconocer objetos. Mantener consistencia de densidad aparente entre categorías; considerar tamaño, distancia, importancia y lectura en movimiento.

**PROPUESTA para evaluación H03, no límites absolutos:**

| Categoría | Resolución inicial orientativa |
|---|---|
| Objetos pequeños | 64×64 o 128×128 |
| Props medianos | 128×128 o 256×256 |
| Armas y objetos protagonistas | 256×256 o 512×512 si mejora la lectura |
| Superficies grandes | Materiales repetibles y atlas adecuados a escala y distancia |

Evaluar nearest-neighbor y alternativas por material. No imponer nearest global: HUD, fuentes y elementos que necesiten claridad moderna requieren comprobación separada. Evitar tanto el suavizado que borre toda intención retro como pixelación extrema, fotografías sin adaptación y ruido excesivo.

## Iluminación y paleta

Ambientes oscuros con fuentes localizadas: luces industriales, CRT, señalización luminosa y neones moderados. Contrastar luz y sombra sin ocultar información necesaria. El color comunica peligro, seguridad e interacción con intención; no llenar todas las escenas de magenta y cian.

**Paleta conceptual PROPUESTA para validar en H03:** negros y grises industriales; marrones y tonos cálidos envejecidos; azules/cian tecnológicos; rojo de alarma; verde de terminal; amarillo de interacción cuando corresponda. No fija códigos cromáticos ni umbrales definitivos. Se conserva la diferenciación ya aprobada de salud roja y energía azul en [GAME_DESIGN](GAME_DESIGN.md); el resto de la paleta no sustituye esa regla.

## Efectos retro y legibilidad

Se permite **explorar**, sin obligación de incorporarlos: dithering moderado, banding deliberado, pixelación selectiva, niebla, color grading retro, ruido ligero, vertex snapping/wobble muy sutil, CRT en monitores físicos y distorsiones tecnológicas puntuales.

**Todos los efectos retro potencialmente perjudiciales para la legibilidad deben ser configurables o desactivables.** Comparar la imagen con y sin cada efecto. No imponer wobble intenso, resolución interna extremadamente baja, dithering que oculte enemigos, ruido que perjudique apuntar, distorsión permanente de cámara, blur excesivo, aberración cromática agresiva ni filtros que dificulten leer el HUD. Priorizar precisión y lectura durante el movimiento.

## Aplicación por sistema

### Guarida

Espacio habitado por un mercenario cyborg: apartamento decadente, hardware antiguo, interiores industriales y objetos cotidianos. Ordenador retrofuturista con CRT o equivalente, banco con herramientas, cables, cajas, dispositivos, racks, pared de armas y vitrina de trofeos. No debe parecer showroom impecable ni laboratorio estéril. La composición distingue rápidamente las zonas interactuables; los props decorativos no añaden funcionalidades nuevas.

### Contrato Yakuza

Conservar las tres plantas aprobadas y evolucionar la atmósfera sin romper el lenguaje común:

| Planta | Dirección visual |
|---|---|
| Infiltración | Oficinas corporativas decadentes, iluminación contenida, pasillos de vigilancia, cámaras y dispositivos de seguridad identificables. |
| Combate | Instalaciones técnicas, servidores, zonas industriales, coberturas claras y mayor contraste/tensión. |
| Jefe | Espacio memorable, arquitectura que permita leer patrones y luz dramática; referencias a la organización sin copiar assets protegidos. |

Oscuridad, niebla y decoración no deben ocultar injustamente proyectiles, enemigos ni señales de peligro. Esto orienta la presentación; no decide rutas, densidad, IA ni patrones del jefe.

### Armas y animaciones

Las seis armas aprobadas —katana, pistola silenciada, rifle silenciado con mira, espada-sierra, revólver potente y escopeta de doble cañón— comparten materiales y lenguaje visual, con siluetas distintas, detalles mecánicos visibles y modelos low-poly personalizados. La vista FPS permite más detalle cuando favorece la silueta o la animación; evitar geometría ultrabaja que las deteriore.

Animaciones expresivas, acciones legibles y retroceso visual satisfactorio, con respuesta propia de un FPS moderno. No copiar diseños identificables de otras franquicias. No se modifica la regla jugable de recuperación/cadencia gobernada por animación ni sus valores pendientes.

### Brazo cyborg izquierdo

Elemento protagonista de tecnología industrial: fuerza mecánica, componentes funcionales, modificaciones, desgaste y reparaciones. Mantener materiales y diseño consistentes en todas las escenas. Curación/reparación con E e instalación de firmware deben tener animaciones reconocibles. La extracción F está SUPERSEDED por la migración v2.1; no producirla como requisito. Feedback de regeneración de HP y de energía por bajas debe distinguir ambas barras. Remates sujetos a revisión P-017; esta dirección no decide sus estados ni costes.

### Enemigos

| Arquetipo | Lectura de silueta y amenaza |
|---|---|
| Squishy | Ligero, poca protección, diseño sencillo. |
| Ranged / tirador | Arma reconocible y animación que comunique amenaza a distancia. |
| Tank / tanque | Volumen considerable, armadura visible, silueta pesada y cambio visual al perder protección. |

La estética retro no debe impedir distinguirlos de inmediato, incluso en iluminación tenue y durante movimiento. No se aprueba aquí una IA nueva ni valores de armadura.

### HUD e interfaces

Sistema operativo del cyborg: minimalista, tecnológico y legible, inspirado en terminales, HUD militar y software industrial. Salud y energía diferenciadas; indicadores claros de interacción, detección, alarma y ultimate disponible cuando existan esos sistemas.

El ordenador de la guarida puede ser más retro que el HUD de combate. No reproducir incomodidades de interfaces de los noventa; preservar tipografía legible y la lectura de información durante combates rápidos. CRT en pantallas físicas no implica filtro global sobre el HUD.

## Producción híbrida y progresiva aprobada

Orden de prioridad:

1. Reutilizar assets gratuitos que cumplan requisitos legales y estilísticos.
2. Adaptar modelos base: escala, pivotes, siluetas, UV, materiales, complejidad, recolor y ensamblaje.
3. Crear en Blender props sencillos que aporten identidad.
4. Desarrollar materiales y shaders propios cuando aporten utilidad comprobable.
5. Personalizar armas, brazo y demás protagonistas, con diseño propio o derivados permitidos por licencia.
6. Usar IA como apoyo conceptual; no depender de ella para modelos finales ni exclusivamente de packs sin modificar.

El greybox propio sigue sirviendo para comprobar escala, cobertura y visibilidad. Antes de producir las tres plantas, validar una referencia común de luz, texturas, siluetas y elementos protagonistas. Registrar procedencia, versión, permisos, cambios, ruta y aprobación en [ASSET_REGISTRY](ASSET_REGISTRY.md). Sin licencia verificada, dejar pendiente y no incorporar ni distribuir. PRE-H03 no descarga assets.

## Investigación técnica pendiente en H03

**Estado observado:** Godot `4.7.2.stable.official.ed1daf0bf`, Windows, GL Compatibility en el H1; viewport 1280×720 y stretch canvas_items. [Arquitectura real](ARCHITECTURE.md). Esta configuración no es una pipeline visual validada y PRE-H03 no la modifica.

H03 conserva infraestructura de pruebas y balance, y añade la investigación y escena comparativa solicitadas en PRE-H03. H04 conserva su vertical de arte y depende de H03; reutilizará la referencia cuando se autorice, sin duplicarla por defecto.

| Área a investigar | Evidencia requerida en H03 |
|---|---|
| Renderer y Windows | Versión exacta, renderer real, hardware/driver, compatibilidad medida; justificar cualquier propuesta de cambio. |
| glTF/GLB y adaptación Blender | Escala, pivotes, materiales, UV y animación de muestras disponibles con procedencia; registrar faltas, sin asumir importación ya probada. |
| Texturas/materiales | Comparación A/B de resoluciones, atlas, densidad y filtros por categoría, incluyendo HUD/fuentes. |
| Iluminación/sombras/fog | Utilidad visual, lectura de siluetas y compatibilidad con el renderer; no asumir soporte de cualquier técnica. |
| Resolución interna/escalado | Claridad al apuntar y moverse, HUD legible, coste medido; valores provisionales. |
| Shaders retro opcionales | Comparación activado/desactivado, intensidad/configuración, coste y justificación por efecto. |
| Rendimiento | Misma escena/cámara y condiciones para comparar; registrar hardware, resolución, tiempos de frame y limitaciones. Sin FPS objetivo inventado. |

Crear en H03 una escena de referencia aislada y reproducible con materiales, siluetas, un elemento FPS y UI de prueba; usar placeholders propios si faltan assets autorizados. Evaluar claridad, coherencia y coste sin implementar combate/sigilo futuro. Conservar capturas con configuración y punto de cámara cuando sea posible; si no, NOT_RUN con causa. Documentar decisiones técnicas provisionales separadas de decisiones de gameplay.

**Estrategia de degradación a validar:** medir una base sin efectos opcionales; reducir/desactivar primero ruido, distorsión y postprocesado que no aporten lectura, luego ajustar fog/sombras/luces según coste observado; simplificar detalle decorativo y resolución solo tras comprobar legibilidad. Preservar siluetas, señales de peligro y HUD. La secuencia es propuesta técnica, no perfil ya implementado. No añadir dependencias sin necesidad y verificación.

## Consistencia y aceptación visual

La revisión humana debe comprobar que:

- Una captura comunica PSX reinterpretada y atmósfera industrial, sin apariencia de fallo técnico.
- Guarida, contrato, armas, brazo y enemigos comparten materiales, densidad aparente, escala y desgaste.
- Siluetas y zonas de interacción se leen con luz clara, tenue y en condiciones de alarma cuando existan; nunca se confunde un fixture con un sistema jugable implementado.
- Movimiento, apuntado, señales de amenaza y animaciones mantienen claridad; efectos opcionales no condicionan injustamente la información.
- HUD y textos siguen legibles con los efectos activados y desactivados; salud/energía mantienen su distinción.
- Las comparaciones usan condiciones reproducibles, capturas cuando sea posible y datos de rendimiento reales.
- Cada asset usado tiene registro completo y aprobación legal/visual diferenciada; no hay mezcla incoherente de packs.

H03 debe dejar revisables la escena comparativa, las propuestas de paleta, presupuestos por categoría, resoluciones/filtros, renderer, iluminación/fog, efectos y perfiles de degradación. Su aprobación visual corresponde al creador. Rigging/animación detallada, selección de packs y audio/licencias se concretan en sus hitos; no quedan aprobados por este texto.

## Trazabilidad y límites

D-017 precisa el componente artístico de D-001 y amplía D-015; conserva sus pilares compatibles. La versión inicial está en [histórico](history/pre_h02/docs/ART_BIBLE.md); el cambio PRE-H03 y su fuente se registran en [VALIDATION](VALIDATION.md). Las antiguas menciones de Kenney/Quaternius eran orientación sin verificación individual, no licencias de assets aprobadas. No se reutilizan esas afirmaciones como permiso.

No se incorporó ningún asset en H02 ni PRE-H03. H1 usa primitivas/materiales procedurales; su existencia no demuestra cumplimiento de esta dirección. **En PRE-H03 aún no había escena, shaders ni aprobación visual.** La ejecución posterior H03 se documenta debajo.

## Laboratorio H03 y observaciones · 2026-11-21

[modern_psx_lab.tscn](../scenes/art_reference/modern_psx_lab.tscn), abrir con F6. Es banco de comparación, no guarida ni vertical H04. Incluye CRT/desk/industria del creador, brazos sobre peana, HomeVideo, materiales propios, silueta y arma abstracta FPS. Cajas propias en composición ambiental; PSXAmmoBoxes y Malorian no son dependencias por los límites de ASSET_REGISTRY. **Todo es experimental, nunca selección final.**

| Técnica | Evaluación observada / configuración | Estado |
|---|---|---|
| Nearest vs linear + mipmaps | Mismos materiales/UV/cámara. Nearest conserva patrón de píxel; linear suaviza especialmente suelo/paneles. El escritorio sigue más ruidoso que las superficies propias | A/B ejecutado; preferencia por categoría pendiente |
| Luz neutra vs atmosférica | Ambiente 0.65/direccional 1 frente a ambiente 0.24/direccional 0.38 y dos puntos 1.8. Mezcla cálida/fría contenida | Valores de laboratorio, no receta final. Silueta visible en capturas; lectura en movimiento pendiente humana |
| Sombras | Direccional y puntos con toggle común. Base 198 draw calls; sin sombras 91, incluyendo pases/UI | Coste medido; probar reducción de sombras antes de bajar resolución |
| 1280×720 vs 640×360 interno | SubViewport de 3D, UI fuera. En 640×360 se degrada claramente la rotulación 3D y los bordes; UI permanece legible | Opción de estudio, no perfil predeterminado; no mejora demostrada de tiempo en esta escena pequeña |
| Retro opcional | Cuantización 31 niveles + líneas 0.018 mezcladas al 25%; apagado por defecto. Sin wobble ni distorsión de cámara | Shader dibujado en OpenGL, reversible. Beneficio estético pendiente |
| Niebla | Niebla estándar, densidad 0.018, apagada por defecto; no volumétrica | Compatibilidad gráfica ejecutada; utilidad y contraste pendientes |
| HomeVideo / Godot UI | Comparación simultánea de 14/20/28 px lógicos, texto con ñ/tildes/¿¡ verificado por glifos. Ventanas 1280×720 y 960×540 (stretch al 75%) | Candidata de terminal; 14 px/escalado fraccionario menos limpios. Evaluar 20/40 px sugeridos por autor; no cambiar HUD global |
| Rig FPS | GLB con 52 huesos/18 clips; cámara 4, A anima guardia/jab/relax. Prueba de cambio real de pose | Compatibilidad validada; acople al arma FPS y brazo izquierdo original pendientes |

Capturas auténticas: [base](evidence/h03/run_03/graphics/native_nearest.png), [linear](evidence/h03/run_03/graphics/native_linear.png), [atmósfera](evidence/h03/run_03/graphics/atmospheric.png), [640×360](evidence/h03/run_03/graphics/half_resolution.png), [retro](evidence/h03/run_03/graphics/subtle_retro.png), [tipografía 960×540](evidence/h03/run_03/graphics/font_crt_960x540.png), [rig](evidence/h03/run_03/graphics/arms_rig.png). No fueron generadas ni retocadas. La revisión de Codex detecta diferencias y problemas técnicos; no otorga VISUALLY_APPROVED.

**Coherencia pendiente:** desgaste del escritorio y brillo de industria difieren de las superficies propias; el barril azul/blanco necesita adaptación de paleta si se conserva. Carteles 3D pequeños pierden lectura en vista general/escala reducida y algunos se superponen con UI de diagnóstico al acercarse. El arma FPS abstracta prueba encuadre, no animación/calidad final. Estos límites están visibles para la revisión H04, no se ocultan bajo PASS de carga.

### Rendimiento real, alcance y propuestas

Godot 4.7.2, OpenGL 3.3.0 NVIDIA 621.24, RTX 4050 Laptop, Ryzen 7 7735HS. Ventana 1280×720, VSync desactivado, 60 frames de calentamiento y 180 muestras por variante. 33 meshes, 34 materiales en memoria; sin simulación de combate. Media entre frames renderizados: base 3.060 ms, linear 3.072, atmósfera 3.000, mitad de resolución 3.250, retro 3.165, sin sombras 2.449, niebla 3.303. [Muestras/configuración completas](evidence/h03/run_03/graphics/metrics.json).

Son mediciones breves de escena pequeña, no tiempos GPU exclusivos ni presupuestos para un contrato completo. Diferencias pequeñas están dentro de variación observada; no demuestran superioridad. Export, sesiones largas, otros equipos/driver y combate real NOT_RUN. No se fija un objetivo de FPS.

**PROPUESTA por categoría, PENDING_APPROVAL:** usar escritorio 236 tri como referencia de prop simple (ensayar 250–500); CRT 1662 como referencia de prop protagonista (ensayar hasta 2000); brazos 1176 actuales/2248 antiguos como referencia de rig (ensayar 1200–2500, no límite para cyborg final). Estos intervalos no son máximos aprobados. Textura procedural 64² y brazos 512² prueban extremos del vocabulario; conservar resoluciones reales antes de proponer reducción. Armas finales/enemigos requieren evidencia propia, no extrapolar de cajas/placeholder.

Degradación propuesta: apagar retro/niebla si no aportan lectura; reducir sombras (mejora observada en esta muestra); simplificar luces; después estudiar resolución 3D, manteniendo siempre UI y señales. No imponer 640×360 porque empeora rotulación. No se cambia renderer: [Compatibility](https://docs.godotengine.org/en/stable/tutorials/rendering/renderers.html), [SubViewport](https://docs.godotengine.org/en/stable/classes/class_subviewport.html) y [Environment](https://docs.godotengine.org/en/stable/classes/class_environment.html) contrastados con ejecución real.

## Corrección de legibilidad H03 · 2026-11-22

El creador confirma mediante dos capturas que el retro true/false apenas se percibe y la composición es difícil de leer. El PASS técnico previo no validaba esa legibilidad. Se retiran los rótulos 3D superpuestos; controles, título/leyenda de la cámara e indicadores se colocan fuera de la imagen. Fuentes disponibles con F, ocultas inicialmente; al abrirlas el 3D conserva aspecto y reduce su espacio visible sin quedar tapado. Cámara 1 frontal más próxima; el título muestra siempre la cámara real. Neutra al reset como base de comparación, sin inferir preferencia artística definitiva del creador.

Retro corregido: cuantización en 15 pasos, líneas alternas de 0.10 y mezcla regulable 0–1 (0.70 de prueba), apagado por defecto. X alterna; B permite ver izquierda sin efecto y derecha con efecto simultáneamente. No wobble, distorsión ni filtro sobre HUD/fuentes. La intensidad actual también es experimental; no aprobación de perfil final. La comparación anterior inferior a 1/255 medio por canal se conserva como evidencia del problema inicial; las nuevas capturas/pruebas constan en VALIDATION.

Malorian local cargada en perspectiva FPS bajo los permisos del archivo y alcance experimental solicitado; detalle/limitaciones en ASSET_REGISTRY. No se publica el modelo ni se implementa un arma jugable; rig de brazos sigue muestra separada. La revisión humana de esta corrección sigue pendiente.
