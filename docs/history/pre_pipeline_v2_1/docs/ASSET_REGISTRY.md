# ASSET_REGISTRY — H04 y antecedentes H03

**Aprobación manual H04 · 2026-11-22 · D-021:** A-013 (kit propio), A-014 (composición/materiales) y el uso de HomeVideo en señales obtienen **VISUALLY_APPROVED para la referencia experimental entregada**. Se acepta el conjunto de las muestras en ese contexto, sin convertir ningún modelo en final ni ampliar sus permisos. A-005 continúa exclusivamente local/opcional; A-009 continúa excluido. Las limitaciones de dimensiones/equipos no expresamente probados y de redistribución se conservan. Los estados pendientes inferiores son antecedentes de la entrega previa.

Preparación pública A-013: eliminada únicamente la carpeta personal del explorador de archivos almacenada en los `.blend`, usando Blender. Geometría/materiales/UV y GLB intactos; hashes de fuente actualizados en manifiesto. `build_kit.py` limpia ese estado antes de guardar; `sanitize_sources.py` verifica UV/conteos y que los GLB existentes no cambien. No se alteran los packs suministrados ni la referencia aprobada.

**Resultado técnico H04 · 2026-11-22:** A-013 y A-014 TECHNICALLY_VALIDATED / EXPERIMENTAL, VISUALLY_APPROVED pendiente. Pipeline Blender 4.5.3→GLB→Godot ejecutada, pivote/metros/UV/materiales comprobados. [Manifiesto de fuentes y exports](../resources/art_kit/manifest.json), [suite](evidence/h04/run_02/summary.json).

| Asset propio A-013 | Fuente editable | Export / conteo real |
|---|---|---|
| Armario de servicio | art_sources/h04/service_cabinet.blend | resources/art_kit/service_cabinet.glb · 248 tri |
| Panel modular | art_sources/h04/wall_panel.blend | resources/art_kit/wall_panel.glb · 104 tri |
| Caja de transporte ambiental | art_sources/h04/transit_case.blend | resources/art_kit/transit_case.glb · 124 tri |

Ocho instancias en sala: cuatro paneles, un armario, tres cajas. SHA-256 de blend/GLB y versión Blender en manifiesto; autoría original por código, sin imágenes/modelos externos. Geometría chamfer de un segmento, UV y materiales exportados; corrección de color sRGB→lineal en export. Superficie de ruido 64² propia añadida por instancia en Godot, sin editar GLB.

Cambios de muestras externas H04: roughness mínimo 0.78, metallic máximo 0.3; tintes moderados de escritorio y barril, reubicación industrial. Son adaptaciones de instancia, originales/selección binaria intactos. A-003 además se usa en dos señales físicas; texto a 40 px, viewport 320×128, filtro lineal para reducción. La aprobación D-020 se conserva para H03; **el uso/legibilidad en estas señales nuevas requiere revisión H04**. Créditos actualizados en THIRD_PARTY_NOTICES. A-005 sigue local opcional, A-009 excluido, A-008 rig separado.

## H04 autorizado · 2026-11-22 · registro previo de producción

El creador solicita comenzar H04 tras cerrar H1–H03. Se reutilizan A-001 CRT, A-003 HomeVideo, A-004 industria, A-006 escritorio y A-008 brazos desde la selección ya verificada. Los originales y sus texturas no se editan; armonización solo mediante materiales de instancia. A-005 conserva uso opcional local; A-009 sigue sustituido por cajas propias. Todos son muestras, no selección final.

- **A-013 · Kit industrial propio H04:** armario de servicio, panel modular y caja ambiental. Autoría nueva producida por Codex para este proyecto, sin geometría, imágenes ni marcas externas. Fuente reproducible `tools/h04/build_kit.py`; fuente Blender en `art_sources/h04/`, export GLB en `resources/art_kit/`. Sin licencia de terceros ni atribución externa obligatoria. Pivotes al suelo, metros, transforms aplicados, UV y materiales incluidos. Estado inicial: EN PRODUCCIÓN; importación, presupuesto y revisión visual pendientes hasta ejecución.
- **A-014 · Materiales y composición H04:** texturas procedurales propias, paleta provisional compartida, luces de inspección y silueta estática. Se desarrolla la misma sala H03, sin nueva IA ni interacción. Parámetros en `resources/art_kit/lookdev.tres`; no límites artísticos finales.
- **T-002 · Blender portátil 4.5.3:** herramienta externa de autoría, GPL, obtenida del [servidor oficial](https://download.blender.org/release/Blender4.5/), comprobada contra SHA-256 oficial antes de ejecutar. No addon externo ni cambio del renderer. Ejecutable fuera del proyecto; la herramienta no se distribuye con el juego. Evidencia en `docs/evidence/h04/blender_download.json`.

**Cierre 2026-11-22, aprobado por el creador:** A-003 HomeVideo obtiene VISUALLY_APPROVED para legibilidad/preferencia en la muestra H03 (D-020); se mantiene como referencia preferida de terminales, sin selección final universal ni extensión automática al HUD. A-008: animación en cámara 4 con A confirmada manualmente; no se declara aprobado el diseño de un brazo definitivo. El laboratorio y perfil D-019 quedan aceptados para cerrar H03. Todos los modelos continúan EXPERIMENTALES y las licencias/restricciones conservan su alcance.

**2026-11-22 · D-019:** aprobado el perfil visual de la captura (nearest+mips, atmosférica, 1280×720, retro off, sombras on, niebla off), revisable en el futuro. Se modifica únicamente el valor inicial/restaurado de iluminación del laboratorio. Ningún binario/textura/modelo cambia; los assets siguen EXPERIMENTALES, sin selección final ni nuevas condiciones legales aprobadas.

## Revisión A-005 previa a incorporación local · 2026-11-22

El creador reitera que espera la Malorian equipada como prueba. Nueva consulta de la [fuente oficial Wildenza](https://wildenza.itch.io/psx-malorian-armscyberpunk): ficha CC0 y respuesta del autor que permite uso y modificación. Se corrige la cautela aplicada al experimento anterior: **LICENSE_VERIFIED para el archivo; uso experimental local autorizado**, sin aprobar el diseño para versión final ni afirmar resueltos derechos de terceros. El bloqueo de dependencia local de A-005 de la entrega inicial queda sustituido por este estado; publicación/distribución del modelo sigue excluida.

Destino experimental: `resources/local_experiments/malorian/`, FBX y dos PNG copiados del pack suministrado, originales intactos. Hashes en manifiesto local. Sin atribución obligatoria CC0; crédito voluntario Wildenza y URL retenidos. La muestra local es opcional: el repositorio público conserva un arma abstracta propia cuando no existe ese recurso. `.gitignore` y el empaquetador público excluyen toda la carpeta local_experiments. Importación y render local comprobados: el FBX aporta dos meshes, se selecciona el arma y se excluye la munición suelta; sus materiales importados no resolvían texturas, por lo que se asigna explícitamente `Malorian_Base.png` 128² a una copia de material. Escala normalizada a longitud 0.50 m de muestra, pivote centrado y yaw 170° para apuntar hacia delante; lámpara de inspección solo sobre viewmodel. Son ajustes experimentales, no dimensiones finales. Sin unión a los huesos de los brazos ni animación de equipar. No se implementan disparo/daño/recarga ni se sustituye H1. A-005 TECHNICALLY_VALIDATED local; VISUALLY_APPROVED pendiente.

A-011/A-012 modificados en esta revisión: cámara general frontal/más próxima, rótulos trasladados a UI externa, arma abstracta reducida para fallback público; shader con cuantización de 15 pasos, scanlines 0.10 y mezcla regulable 0–1 (0.70 inicial), comparación dividida opcional. Sin imágenes ni modelos externos nuevos. La UI propia se construye en GDScript y la fuente Godot mantiene controles legibles; panel HomeVideo oculto inicialmente y desplegable con F.

Los metadatos `.import` de las muestras públicas reflejan ahora la detección 3D realizada por Godot: mipmaps generados, compresión VRAM S3TC y normal map identificado en CRT. Se conservan esos ajustes en la publicación comprobada; los PNG/GLB/FBX fuente no cambian de bytes ni resolución. Son derivados del importador, no edición destructiva del pack.

Los apartados fechados 2026-11-21 inferiores conservan el estado inicial de esa entrega; para A-005 prevalece esta revisión.

**2026-11-21 · Inventario técnico/legal; revisión visual PENDING_APPROVAL.** Originales incorporados por el creador. H03 no descarga modelos, fuentes ni texturas. [Inventario completo por archivo](evidence/h03/assets_inventory.json): **638 archivos / 10 entradas / 30 grupos de duplicados exactos**, con hashes, formatos, glTF, materiales, texturas, rig y dependencias. La versión local se identifica por hash cuando no consta número de edición.

DISCOVERED, LICENSE_VERIFIED, TECHNICALLY_VALIDATED y VISUALLY_APPROVED son dimensiones distintas; BLOCKED identifica uso impedido. REJECTED no se aplica a ningún pack completo. UNVERIFIED indica ausencia de evidencia. **A-003 tiene aprobación visual limitada a la prueba H03; ningún modelo es un asset final aprobado.** Las tablas de inspección inferiores conservan sus datos de procedencia; el cierre de esta cabecera actualiza el estado manual.

## Packs detectados

Rutas de la segunda columna relativas a assets/. Consulta oficial: **2026-11-21**. [Atribuciones](../THIRD_PARTY_NOTICES.md).

| ID | Pack / ruta original | Autor y fuente oficial | Archivos reales | Licencia / evidencia | Uso y estado |
|---|---|---|---|---|---|
| A-001 | CRT_TV_VHS_fbx_gltx_blend_textures | [loafbrr](https://loafbrr.itch.io/crt-tv-asset) | 4 glTF, 4 FBX, 1 blend, 52 PNG, README | CC0; README y ficha. Versión del pack UNVERIFIED | LICENSE_VERIFIED; CRTTV glTF TECHNICALLY_VALIDATED. Electrónica/guarida, muestra experimental |
| A-002 | CRTVHS_GodotFiles | [loafbrr](https://loafbrr.itch.io/crt-tv-asset) | 4 glTF, 4 tscn, 5 material, 24 PNG, README | CC0; README. Versión UNVERIFIED | LICENSE_VERIFIED; escenas antiguas BLOCKED técnicamente. Preferir A-001 |
| A-003 | HomeVideo_Font_0_9 | [GGBotNet](https://ggbot.itch.io/home-video-font) | Regular/negrita en TTF/OTF/WOFF/WOFF2; License.txt y URL | CC0 1.0 Universal, texto local y ficha v0.9 | LICENSE_VERIFIED / TECHNICALLY_VALIDATED TTF regular. Candidata a terminal, no HUD global |
| A-004 | Industrial_exterior_v1 (1) | [godgoldfear](https://godgoldfear.itch.io/psx-industrial-environment-asset-pack) | Interior Industrial_exterior_v2: 1 FBX, 68 PNG | CC BY 4.0 International explícita en Asset license de ficha; versión local v2 por carpeta | LICENSE_VERIFIED / TECHNICALLY_VALIDATED FBX. Barril y ventilación experimentales |
| A-005 | Malorian | [Wildenza](https://wildenza.itch.io/psx-malorian-armscyberpunk) | 1 FBX, 2 PNG; versión UNVERIFIED | CC0 del autor del archivo; derechos del diseño derivado de Cyberpunk UNVERIFIED | DISCOVERED; BLOCKED dependencia/distribución. Referencia visual, nunca arma definitiva |
| A-006 | OFFICE | [valsekamerplant](https://valsekamerplant.itch.io/psx-style-opulent-office) | 180 GLB + 180 FBX alternativos, 21 JPG + 13 PNG | CC0 explícita en ficha; versión local exacta UNVERIFIED, web v1.4.2 | LICENSE_VERIFIED; escritorio desk1_weathered GLB TECHNICALLY_VALIDATED. Oficinas/guarida |
| A-007 | PSX Electronics Asset Pack | [Animimo Studios](https://animimostudios.itch.io/psx-electronics-asset-pack-free) | 1 GLB, 1 blend; 13 meshes / 1088 tri; versión UNVERIFIED | CC0 declarada; imágenes Pexels/Wikimedia según autor, trazabilidad individual UNVERIFIED | DISCOVERED técnico / LICENSE_VERIFIED declaración del autor. Reservado, sin duplicar electrónica en escena |
| A-008 | psx-first-person-arms-free-game-assets | [Drillimpact](https://drillimpact.itch.io/psx-first-person-arms-free) | Actual y Old Versions: 2 GLB, 2 FBX, 2 blend, 4 PNG | CC0 1.0 en ficha/devlog; versión web 1.1.0, revisión local por hash | LICENSE_VERIFIED / TECHNICALLY_VALIDATED GLB actual. Referencia de rig, no brazo cyborg final |
| A-009 | PSXAmmoBoxes | [Doctor_sci3nce](https://doctor-sci3nce.itch.io/psx-ammo-boxes) | 8 OBJ/MTL, 8 FBX, 25 PNG; versión UNVERIFIED | UNVERIFIED: etiqueta CC-BY sin versión frente a texto no comercial, compra para comercial y prohibición de redistribuir incluso modificados | DISCOVERED / BLOCKED licencia. Decoración bajo pared de armas, banco/estantería; nunca pickups |
| A-010 | CRTTVHS Preview.blend | loafbrr, procedencia A-001 por hash idéntico | 1 blend, 6.29 MB | Identidad binaria con blend de A-001; CC0 | DISCOVERED. Conservar sin importar. Función de preview inferida del nombre; interior Blender UNVERIFIED |

## Permisos, restricciones y organización

CC0 permite modificar/distribuir, también en un juego comercial, sin atribución obligatoria; se mantienen créditos voluntarios. No resuelve marcas ni derechos de terceros: [texto oficial](https://creativecommons.org/publicdomain/zero/1.0/). A-001/A-002/A-006/A-007 abrevian CC0; A-003/A-008 identifican CC0 1.0. No se inventa otra licencia. El permiso del archivo Malorian no demuestra derechos sobre el diseño: no se carga en el laboratorio.

A-004 permite modificación y distribución comercial bajo [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/), con atribución, enlace e indicación de cambios en THIRD_PARTY_NOTICES. No se incorpora el paquete Unity de pago.

A-009 requiere aclaración del autor y, si procede, prueba de compra y términos aplicables. No constan. Se usan cajas propias abstractas, sin copiar marcas/diseños del pack. El uso ambiental pedido por el creador queda registrado; no cambia reserva infinita/cargadores/recarga.

- Originales intactos en assets/, excluidos de importación por assets/.gdignore añadido. Esto no autoriza a distribuir el repositorio completo.
- Selección única importable en resources/art_samples/: 74 archivos trazados en [manifiesto](../resources/art_samples/manifest.json). Separa fuentes intactas de dependencias entregables y evita importar FBX y GLB de un mismo modelo. PNG/JPG extraídos por Godot son derivados del importador.
- Ajustes de escala/material/orientación en instancias; no cambios destructivos de binarios. No existe categoría física de finales porque ninguno está aprobado.
- 29 grupos duplicados exactos entre packs CRT; FBX/glTF alternativos aunque no idénticos en bytes. El blend suelto es el trigésimo grupo. No se elimina nada.
- A-002 usa format=2, PoolByteArray y rutas res://CRTVHS ajenas: preparación antigua de Godot. Se elige glTF de A-001 sin conversión masiva.
- Nombre real del preview: **CRTTVHS Preview.blend**. Carpeta industrial exterior v1, contenido v2. Originales sin renombrar.

## Compatibilidad y adaptaciones observadas

Godot 4.7.2 / GL Compatibility / Windows. [Inspección importada](evidence/h03/imported_samples.json) y [VALIDATION](VALIDATION.md). Una muestra importada no certifica todo su pack.

| Muestra | Datos y adaptación real | Límites / trabajo pendiente |
|---|---|---|
| CRTTV glTF | 1662 tri; AABB local aprox. 0.65 × 0.55 × 1.02; texturas/materiales cargados, colocado sobre escritorio | Pantalla verde sin terminal interactivo; revisar escala/profundidad/densidad. Otros tres modelos no probados |
| Escritorio GLB | 236 tri; aprox. 2.21 × 0.89 × 1.09; textura embebida cargada, filtro por instancia | Desgaste más ruidoso que paneles propios; adaptar coherencia tras revisión H04 |
| Industrial FBX | ufbx integrado carga 78 MeshInstance3D; sin rig/animaciones. Solo Barrel_1 y Ventilation_1 en sala, eliminando transform de catálogo | Carpeta experimental Textures normalizada a textures por referencias FBX; original intacto. Modularidad, conectores/colisiones NOT_RUN |
| Brazos actuales GLB | 1176 tri, 52 huesos, 18 clips, textura 512²; esqueleto/animación comprobables. Escala 0.7 sobre peana, cámara 4 | Muestra de rig completa; ajuste ergonómico arma/brazos FPS pendiente. No robóticos: requieren diseño izquierdo original, geometría/materiales, pesos y animaciones propias |
| Brazos antiguos | Estático: 2248 tri, 50 joints, 11 clips | No importados; evitar duplicar versiones. Runtime NOT_RUN |
| HomeVideo | TTF regular 138264 bytes; glifos españoles sin fallback; 14/20/28 px lógicos, ventanas 1280×720 y 960×540 | 14 px y escalado 75% pierden limpieza; 20 px candidato, autor sugiere múltiplos de 20. Sin aprobación humana |
| PSXAmmoBoxes | Inspección OBJ/MTL y PNG; rutas Texture/Textures/textures; fuente indica atlas 240² | Importación/render/escala NOT_RUN por licencia; no presupuesto de resolución aprobado |
| Malorian | Fuente declara 822 tri, 128²/64²; PNG locales inventariados | Triángulos FBX no medidos en motor; escala/rig/brazos/render NOT_RUN por derechos pendientes |
| Electronics | GLB estático autocontenido, 13 meshes con transforms de catálogo | Sin importación runtime ni adaptación de densidad; no segunda selección por redundancia con CRT |

Blender no está resuelto en PATH ni en la ubicación habitual inspeccionada. No se instala. No se afirma haber abierto los blend. Se conserva el pipeline glTF/GLB/FBX probado. AABB/unidades del laboratorio no equivalen a escala artística aprobada.

## Recursos propios y dependencia de desarrollo

| ID | Recurso | Procedencia / derechos / cambios | Estado |
|---|---|---|---|
| A-011 | Primitivas, textura procedural 64², silueta, cajas y arma abstracta en scripts/art_reference/lab_world.gd | Generados por Codex para H03, sin material externo; no derivados de Malorian/PSXAmmoBoxes. Sin licencia externa atribuida | TECHNICALLY_VALIDATED; EXPERIMENTAL, visual pendiente |
| A-012 | resources/shaders/subtle_retro.gdshader | Propio: cuantización/líneas sutiles solo sobre 3D, apagado por defecto | Compilación gráfica y reversibilidad probadas; EXPERIMENTAL |
| T-001 | addons/gdUnit4 | Mike Schulze / Godot GdUnit Labs; [v6.2.3](https://github.com/godot-gdunit-labs/gdUnit4/tree/v6.2.3), MIT; LICENSE incluido; ZIP fijado por SHA-256 | Preflight positivo antes de integrar, sin plugin de editor activado |

H02/PRE-H03 no incorporaron packs por Codex. [Registro vacío de entrada](evidence/h03/asset_registry_before.txt). Reglas generales de AGENTS/ART_BIBLE vigentes.
