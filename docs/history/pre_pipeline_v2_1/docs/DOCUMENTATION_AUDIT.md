# DOCUMENTATION_AUDIT — H02

Fecha: 2026-11-20 · **H02 APROBADO POR CREADOR tras confirmación manual posterior a las correcciones.** Contradicciones materiales identificadas resueltas expresamente; saneamiento y correcciones verificados. Los resultados anteriores se conservan en VALIDATION y en los logs; no se convierten retroactivamente en PASS.

**Actualización PRE-H03 · 2026-11-20:** matriz artística sincronizada con D-017, **Modern PSX / Retro Industrial Cyberpunk**. La aprobación de dirección artística no cierra H02 ni inicia H03. Los recuentos y resultados de H02 inferiores describen su ejecución; la nueva verificación se registra por separado en VALIDATION.

## Alcance, fuentes y método

Se leyeron los 48 Markdown originales: tres en raíz, 22 en docs y 23 prompts. Las cinco copias de docs con sufijo `(1)` eran idénticas a sus canónicos; los 22 prompts con ese sufijo eran únicos. Tras la retirada autorizada de alias y normalización, quedan 41 Markdown activos y 42 históricos únicos: 83 en total, sin nombres (1). Las 48 entradas originales se recuperan por hash desde esos 42 históricos. [Inventario completo](evidence/h02/inventory_and_references.json) y [manifiesto con rutas antiguas/actuales](history/pre_h02/manifest.json).

Antes de editar se leyeron project.godot, main.tscn y los tres scripts; Git no existía. Todos los documentos exigidos por el prompt estaban presentes. Ausentes: PDF fuente, concatenación de prompts anunciada, suite de tests, plugins, assets externos y export presets. La precondición H1 consta en HANDOFF y VALIDATION como declaración del creador, no como resultado automático retroactivo.

Autoridad: prompt actual y últimas respuestas del creador → DECISIONS y decisiones aprobadas → diseño/alcance → históricos/propuestas. D-001…D-016 son decisiones registradas; P-008/P-009/P-010 se resuelven con revisiones expresas de D-006/D-003/D-009 y P-012 con corrección de dependencias documentales. Los demás P conservan su estado pendiente para sus hitos. REQ son índices de trazabilidad, no decisiones añadidas. H03–H24 no iniciados.

## Coherencia de los cinco documentos centrales

| Documento | Hallazgo comprobado | Corrección / situación |
|---|---|---|
| [GAME_VISION](GAME_VISION.md) | PDF ausente; compra/instalación y retorno al sigilo requerían aclaración. | PDF declarado ausente, efectos al instalar USB y excepción de alarma general sincronizados con decisiones del creador. |
| [MVP_SCOPE](MVP_SCOPE.md) | Cobertura amplia; shurikens jugables aparecen a la vez excluidos por decisión y en exclusiones propuestas. | Se aclara que esa exclusión ya está aprobada, resto sigue P-007; salud 0–100 se explicita desde D-007. |
| [GAME_DESIGN](GAME_DESIGN.md) | Daño durante extracción ambiguo; tres contradicciones materiales en efectos/estados. | Daño recibido reducido; firmware al instalar, bloqueo de sigilo por alarma general y Dead Eye global aclarados. Balance/detalles futuros permanecen pendientes. |
| [DECISIONS](DECISIONS.md) | Documentos anunciados como inexistentes e IDs históricos diferentes; reglas anteriores necesitaban sustitución expresa. | Cuatro entradas históricas integradas; sustituciones D-003/D-006/D-009 con fecha, fuente y hitos afectados. Maestro único. |
| [ROADMAP](ROADMAP.md) | Doce perks propuestas tratadas como puerta; dificultades testeadas antes de su sistema; concatenación inexistente. | H14 exige lista aprobada. H05/H10 prueban perfiles existentes, matriz de dificultades desde H13. Índice normalizado; no se reordenan hitos. |

## Matriz de trazabilidad del MVP

En «Estado», APROBADA se refiere a la regla, **no a implementación ni test PASS**. H1 parcial significa una aproximación del prototipo; el resto es funcionalidad pendiente. Referencias abreviadas: DV=[GAME_VISION](GAME_VISION.md), MS=[MVP_SCOPE](MVP_SCOPE.md), GD=[GAME_DESIGN](GAME_DESIGN.md), DC=[DECISIONS](DECISIONS.md), RM=[ROADMAP](ROADMAP.md), BP=[BALANCE_PROVISIONAL](BALANCE_PROVISIONAL.md), AB=[ART_BIBLE](ART_BIBLE.md).

| Requisito | Documento de referencia / decisión | Estado y presencia real | Contradicciones / incompletitud | Acción correctiva / hito propuesto |
|---|---|---|---|---|
| REQ-001 FPS PC/Windows, Godot 4, cyborg brazo izquierdo | DV, MS, DC D-001, GDD histórico | APROBADA; FPS H1, brazo pendiente | No confundir greybox con personaje final | Arquitectura real documentada; H04/H08. |
| REQ-002 Modern PSX / Retro Industrial Cyberpunk, coherencia y legibilidad moderna | DV, MS, GD, AB, DC D-001/D-015/D-017 | APROBADA por el creador en PRE-H03; implementación visual pendiente | Emulación literal descartada como objetivo; paleta, resoluciones, presupuestos y técnicas siguen propuestas P-004 | Investigación y referencia comparativa H03, vertical H04, aplicación posterior H23; efectos perjudiciales configurables o desactivables. |
| REQ-003 Movimiento ágil, Ninja/Tanque/híbridos según equipo | DV, MS, GD, DC D-002 | APROBADA conceptual; marcha/sprint/salto/dash H1 | Velocidades, controles y movimientos adicionales no aprobados (P-001/P-005) | Preservar inputs H1, registrar números observados; H05. |
| REQ-004 Tres armas cualesquiera en loadout | MS, GD, DC D-002 | APROBADA; pendiente | Duplicados/slots vacíos P-011 | PENDING_APPROVAL; H07/H18. |
| REQ-005 Seis armas e iniciales katana/pistola silenciada/doble cañón | MS, GD, DC D-004 | APROBADA; solo pistola provisional H1 | Daño H1 35 no equivale a pistola propuesta 30 | No migrar balance; H07/H15. |
| REQ-006 Reserva infinita, cargadores y recargas animadas; recuperación por animación | DV, MS, GD, DC D-005 | APROBADA; H1 solo munición ilimitada/cooldown | H1 carece de cargador/AnimationPlayer | Diferencia histórica documentada; H06/H07. |
| REQ-007 Escopeta uno/dos cañones, katana desvío automático equipada | MS, GD, DC D-005 | APROBADA; pendiente | Proyectiles/efecto/coste y cartucho único P-001/P-006 | PENDING_APPROVAL para detalles; H07/H15. |
| REQ-008 Salud 0–100, HUD rojo | GD, DC D-007, MS | APROBADA; salud/HUD H1 | H1-B01 reproducido en auditoría inicial | Corregido: daño inválido rechazado, HP limitado; regresión H02 PASS. |
| REQ-009 Energía 0–150 y HUD azul | MS, GD, DC D-007 | APROBADA; pendiente | Cifras de tasas propuestas P-001 | Distinguir límite aprobado de tasas; H08. |
| REQ-010 Ejecución normal debilitado/aturdido/no detectado; tanque armadura rota/debilitado | MS, GD, DC D-007 | APROBADA; pendiente | Umbrales y estados aún no definidos | PENDING_APPROVAL P-001/P-003; H08/H10. |
| REQ-011 F mantenida, energía proporcional, muerte de objetivo; daño reducido, interrupción solo por muerte | DV, MS, GD, DC D-007 | APROBADA general; pendiente | Liberación temprana y momento de matar P-014 | Redacción sobre daño corregida; mecánica detallada PENDING_APPROVAL, H08. |
| REQ-012 E mantenida cura consumiendo energía | MS, GD, DC D-008 | APROBADA; pendiente | E interacción, R propuesto frente a reinicio H1; tasas P-001/P-005 | No cambiar bindings en H02; H05/H08. |
| REQ-013 Ascensor recarga hasta 150 | MS, GD, DC D-008 | APROBADA; pendiente de implementación | Salud/retorno entre plantas no definidos (P-013) | Se retiran restricciones no aprobadas de H19; decidir esos detalles en ese hito. |
| REQ-014 Una ultimate equipada, umbral 100, consume todo, energía extra solo duración | MS, GD, DC D-009, BP | APROBADA; pendiente | Duración 6–10 e interpolación no aprobadas | Marcar fórmulas como hipótesis; H09/H18. |
| REQ-015 Dead Eye mundo 50%, jugador normal | MS, GD, DC D-009 revisada | APROBADA; pendiente de implementación | P-010 resuelta por el creador | Ralentización global con cualquier arma; compatibilidad solo en efectos específicos. H09. |
| REQ-016 Aimbot cabezas visibles, ayuda intensa sin disparo automático | MS, GD, DC D-009 | APROBADA; pendiente | Parámetros y compatibilidad P-006 | No asignar tabla de armas por intuición; H09. |
| REQ-017 Overdrive cadencia/daño armas de fuego | MS, GD, DC D-009 | APROBADA; pendiente | Intensidad/compatibilidad P-006 | Datos futuros, no implementación H02; H09. |
| REQ-018 Firmware con créditos/dependencias, perks instaladas activas, sin límite, respec/reembolso | MS, GD, DC D-006 revisada | APROBADA; pendiente de implementación | P-008 resuelta: compra no activa efectos | Efectos al instalar USB. Doce nodos/ramas siguen propuesta P-002 para H14. |
| REQ-019 Mejoras físicas de armas separadas del firmware | MS, GD, DC D-006 | APROBADA; pendiente | Efectos, precios, entrega/instalación no definidos P-002/P-008 | H15; no crear catálogo en H02. |
| REQ-020 Tres arquetipos patrullan: squishy/tirador/tanque | MS, GD, DC D-002/D-003 | APROBADA; H1 cinco blancos estáticos de dos estadísticas | No son tres IA ni patrullas | Arquitectura corregida; H10. |
| REQ-021 Visión/oído, investigación, búsqueda, memoria, ruptura de contacto y retorno al sigilo | DV, MS, GD, DC D-003 revisada | APROBADA; pendiente de implementación | P-009 resuelta por el creador | Alarma general impide recuperar sigilo durante el intento; retorno permitido antes de esa excepción. H11/H12. |
| REQ-022 Cámaras, alarmas y cadáveres detectables | MS, GD, DC D-003 | APROBADA; pendiente | Alcance, desactivación, feedback, estados P-003/P-009 | H12; la propuesta opcional no es decisión. |
| REQ-023 Guarida PC/tienda/contratos, pared y vitrina | DV, MS, GD, DC D-012 | APROBADA; pendiente | UX/contexto controles P-005 | H16/H18; no escenas de hub reales. |
| REQ-024 Timbre, paquete transportado, montaje 3–4 pasos o USB y equipar | DV, MS, GD, DC D-012/D-006 | APROBADA; pendiente de implementación | Activación firmware al instalar ya aprobada | Autosave intermedio detallado sigue P-005, a concretar H13/H17. |
| REQ-025 Contrato Yakuza repetible, tres plantas, objetivo principal/secundarios | DV, MS, GD, DC D-010/D-011 | APROBADA; pendiente | Rutas, densidad, objetivos, bonus P-003; retorno P-013 | H19/H21. |
| REQ-026 Tres dificultades, duración objetivo 15–25 min | MS, GD, DC D-014 | APROBADA como selección/meta; pendiente de implementación | Multiplicadores P-001 pendientes | P-012 corregida: matriz desde H13 y H22. No benchmark ni selector H1. |
| REQ-027 Boss dos fases, shurikens y cambio de patrón, trofeo/flag futuro | MS, GD, DC D-010 | APROBADA; pendiente | Patrones/balance P-003; shurikens jugables no incluidos | Corregida etiqueta de exclusión; H20. |
| REQ-028 Muerte reinicia contrato conservando equipo/progreso | MS, GD, DC D-011 | APROBADA; H1 solo respawn local | Persistencia de intento y créditos pendientes P-005 | No describir respawn como reinicio contractual; H13/H21. |
| REQ-029 Créditos única moneda, compra/mejora, pago base + extras | MS, GD, DC D-011 | APROBADA; pendiente | Precios, recompensas y prevención de bloqueos P-002/P-003 | H13/H15/H21. |
| REQ-030 Autosave compras/mejoras/fin contrato; armas/firmware/créditos/loadout/ultimates/trofeos persistentes | MS, GD, DC D-013 | APROBADA; pendiente de implementación | Antes de USB hay compra sin efectos; recuperación detallada P-005 | Definir política de guardado intermedio en H13/H17; sin SaveData real en H1. |
| REQ-031 Producción híbrida/progresiva, assets legales adaptados y protagonistas propios/personalizados | MS, AB, ASSET_REGISTRY, DC D-015/D-017 | APROBADA como política; ningún pack incorporado | Licencias, técnica y aprobación visual individuales pendientes P-004; IA solo apoyo conceptual | Inventariar muestras H03 y assets posteriores; verificar licencia antes de integrar. Blender/materiales/shaders propios permitidos, sin descarga en PRE-H03. |
| REQ-032 Tests verificables, lectura AGENTS, gates y aprobación humana | AGENTS, RM, TEST_STRATEGY, DC D-016 | APROBADA como proceso; H02 aprobado por el creador | Tres bugs corregidos; pruebas automáticas y confirmación manual posterior registradas | Conservar límites headless e históricos; H03 no iniciado. |
| REQ-033 Exclusiones restantes y DoD final del MVP | MS, DC P-007, RM | PROPUESTA; PENDING_APPROVAL | Lista no congelada; shurikens ya excluidos por D-010 | Mantener distinción, no añadir alcance. |

## Duplicados, migración y preservación

- GDD raíz/docs y cinco pares de docs `(1)` eran idénticos byte a byte: [comparación](evidence/h02/original_comparisons.diff). Los ocho alias de la primera migración quedan retirados por petición del creador. Se mantienen solo canónicos activos; los seis duplicados históricos se deduplican sin cambiar contenido.
- Los 22 prompts con sufijo `(1)` no tenían copia sin sufijo: se renombraron, conservando los 23 prompts H02–H24. Se actualizaron enlaces e índice. Cero archivos con (1) en la documentación activa o histórica.
- DECISIONES y DECISIONS **no eran duplicados**: cuatro decisiones originales, fechas e IDs integrados en el maestro y conservados en histórico; el antiguo alias activo se elimina. D003 histórico no equivale a D-003.
- **VALIDACION y VALIDATION eran diferentes:** VALIDACION era la checklist H1 sin ejecutar; VALIDATION era el registro posterior con declaración del creador. La primera fase convirtió VALIDACION en un alias. Ahora se retira ese alias: VALIDATION es el único registro activo, con enlace a la checklist histórica intacta. No se fusionan resultados de épocas distintas ni se marcan casillas retroactivamente.
- Las 48 entradas Markdown originales se recuperan desde 42 archivos únicos según SHA-256 del manifiesto. Rutas antiguas, actuales y de archivo quedan registradas. El tree Git de los 56 archivos de entrada no cambia.
- [migrate_docs.py](../tools/h02/migrate_docs.py) v2 valida hashes y todas las colisiones antes de eliminar/renombrar; no sobreescribe contenido diferente. [verify_migration.py](../tools/h02/verify_migration.py) prueba consolidación, idempotencia, 48 hashes y rechazo de ediciones ajenas/colisiones sin escrituras parciales. Las rutas se validan dentro del workspace antes de mutar.

## Revisión de los demás Markdown

| Grupo | Resultado de revisión |
|---|---|
| AGENTS | Revisión 0.3 sincroniza decisiones expresas D-003/D-006/D-009 y migración autorizada. No se cambia la puerta de aprobación ni se autoriza H03. Original 0.2 preservado. |
| README | Se retira estado obsoleto de no validación por el creador; se aclaran versión probada, ruta de validación vigente y numeración de hitos. |
| ARCHITECTURE | Propuesta anterior archivada; reemplazada por escenas, scripts, inputs, señales, números y límites comprobados. |
| BALANCE_PROVISIONAL | Límites aprobados separados de hipótesis; fórmulas explícitamente propuestas, sin trasladarlas a gameplay. |
| ART_BIBLE / ASSET_REGISTRY | Sin cambios visuales ni packs nuevos; enlaces/licencias de proveedores no consultados en H02, no equivalen a licencia individual. |
| TEST_STRATEGY / VALIDATION / HANDOFF | Versión/ruta/comandos reales y resultados históricos/correctivos separados; cinco pruebas manuales previas y confirmación conjunta posterior del creador registradas. H02 aprobado; H03 no iniciado. |
| SPEC_REVIEW | Se corrige anuncio obsoleto de creación futura de documentos que ya existen. |
| PROMPTS_INDEX y los 23 prompts | Índice enlazado a nombres recibidos; notas H02 distinguen propuestas/contradicciones. No se ejecutan ni aprueban H03–H24. H02 local recibe aviso de alcance ampliado del prompt actual. |
| Archivos históricos | Contenido íntegro por hash, seis copias redundantes eliminadas; referencias antiguas documentadas mediante manifiesto. No quedan alias activos. |

## Verificación automática y límites humanos

[audit_repo.py](../tools/h02/audit_repo.py) recorre todos los Markdown, comprueba enlaces relativos/anclas, tokens de archivos, definiciones/referencias D/P/REQ, cobertura de las 16 decisiones en 33 requisitos, dependencias res://, cero nombres (1) y exactamente un prompt por hito. Verifica 48 hashes históricos y ocho productivos contra [snapshot de correcciones](h02_runtime_snapshot.json), manteniendo el hash original como antecedente. Referencias a rutas retiradas se informan con sucesor verificado; un enlace activo roto sigue siendo error. No verifica URLs externas ni semántica automáticamente. [Ausencias externas declaradas](h02_reference_policy.json).

La coherencia de las reglas aprobadas se revisó contra las tres respuestas expresas del creador: P-008/P-009/P-010 resueltas, P-012 corregida como dependencia documental. P-011/P-013/P-014 son detalles futuros expresamente pendientes, sin alternativas convertidas en exigencias; P-001…P-007 tampoco se elevan a decisiones. No quedan contradicciones materiales identificadas sin tratamiento. Esta conclusión es revisión documental, no test de gameplay futuro ni cierre del alcance completo del MVP.

Los tres defectos H1 están corregidos y la regresión ampliada pasa 34 comprobaciones. Integridad automática y logs: [VALIDATION](VALIDATION.md). La confirmación posterior del creador de que realizó las pruebas y todo funciona satisface la revisión manual pendiente y permite cerrar H02; se conserva la distinción entre declaración humana y ejecución automática.

## Coherencia artística PRE-H03 — revisión documental

| Discrepancia o riesgo | Resolución y límite |
|---|---|
| PS1/low-poly como etiqueta genérica en visión, alcance, AGENTS y 23 prompts. | Definición única Modern PSX / Retro Industrial Cyberpunk, D-017 y ART_BIBLE como fuente detallada. Históricos y antecedentes se conservan, sin convertirlos en requisitos vigentes. |
| Biblia/pipeline completamente propuestas; producción descrita solo como packs gratuitos. | Dirección y producción híbrida aprobadas; valores, compatibilidad técnica, assets y resultado visual pendientes. No se convierten propuestas de resolución/paleta en límites. |
| Petición PRE-H03 exige referencia visual en H03, mientras H04 contenía la primera vertical. | H03 conserva infraestructura/balance y añade investigación/escena comparativa expresamente solicitada. H04 desarrolla esa base; numeración, dependencias y puertas se mantienen. |
| Antiguo «post FX PS1» en H23 podía interpretarse como efecto obligatorio. | Efectos potencialmente perjudiciales configurables o desactivables; claridad de HUD, apuntado y señales preservada. H16 también explicita terminal retro con uso moderno. |
| Paleta conceptual nueva frente a salud roja y energía azul ya aprobadas. | Se conserva la regla de GAME_DESIGN; el resto de la paleta se evalúa en H03. Sin modificación de gameplay. |
| Referencias genéricas de proveedores/licencias en la biblia anterior. | Se conservan como antecedente en el diff/histórico, no como permiso. Registry exige evidencia individual, restricciones y aprobación legal/técnica/visual separadas. |
| Al comenzar PRE-H03, H02 aún esperaba confirmación manual posterior a las correcciones. | Se trabajó solo en documentación; después el creador confirmó las pruebas y que todo funciona. Se registra cierre H02 por esa validación, sin avanzar H03. |

No se ha identificado una contradicción artística material sin tratamiento después de la sincronización. Es una revisión semántica documental, no aprobación estética de una escena. La verificación automática comprueba enlaces, archivos, IDs y hashes, pero no certifica calidad artística. Ahora hay 17 decisiones maestras trazadas en los mismos 33 requisitos; el informe H02 de 16 decisiones sigue siendo evidencia histórica válida.
