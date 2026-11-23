Lee primero `AGENTS.md` completo en la raíz del repositorio. Después lee `docs/GAME_VISION.md`, `docs/MVP_SCOPE.md`, `docs/DECISIONS.md`, `docs/GAME_DESIGN.md`, `docs/ROADMAP.md`, `docs/ARCHITECTURE.md`, `docs/BALANCE_PROVISIONAL.md`, `docs/TEST_STRATEGY.md`, `docs/VALIDATION.md` y `docs/HANDOFF.md` si existen; para cambios visuales, también `docs/ART_BIBLE.md` y `docs/ASSET_REGISTRY.md`. Inspecciona `project.godot`, escenas/scripts reales y `git status` ANTES de editar. No supongas que la arquitectura propuesta ya está implementada. Aclara qué archivos faltan y evita inventar resultados. Implementa SOLO el hito de este prompt, sin empezar el siguiente. Registra comandos reales, exit codes, logs, pruebas no ejecutadas y problemas, y deja pruebas manuales para aprobación expresa del creador.

# H03 — Infraestructura de pruebas y balance

**CERRADO / APROBADO POR CREADOR · 2026-11-22.** Suite técnica PASS, perfil D-019 y pruebas manuales H1/HomeVideo/animación confirmadas expresamente. Registro final en VALIDATION/HANDOFF. El prompt y los estados de preparación inferiores se conservan como antecedentes; no reabrir ni repetir el hito por esas frases históricas. H04 no iniciado.

**Ejecución 2026-11-21:** este prompt base fue ampliado por la [solicitud íntegra H03](../docs/evidence/h03/request.txt), que añade inventario concreto y aceptación A–L. Implementado según esa fuente y órdenes posteriores de usar los assets solo como pruebas y publicar código. Estado/evidencias en VALIDATION/HANDOFF; revisión manual pendiente, H04 no iniciado. El texto inferior se conserva como antecedente de planificación.

Actualización documental PRE-H03 · 2026-11-20: conserva infraestructura y balance; añade investigación visual y escena comparativa según D-017. **Leer íntegramente la nueva [ART_BIBLE](../docs/ART_BIBLE.md) y [ASSET_REGISTRY](../docs/ASSET_REGISTRY.md) antes de comenzar**, además de los documentos del bloque inicial. Esta edición del prompt no ejecuta H03.

## Contexto específico y precondición
- Proyecto: ALABARDA STUDIOS CYBERPUNK FPS, Godot 4, Windows, estética Modern PSX / Retro Industrial Cyberpunk (D-017 y docs/ART_BIBLE.md), reinterpretación moderna sin emulación literal de PS1; primero funcional y después pulido.
- Precondición: Con H02 aprobado. Si no está documentada/aprobada en `docs/HANDOFF.md` y `docs/VALIDATION.md`, **no asumir** que lo está; reporta BLOCKED y completa únicamente la auditoría que sí sea segura.
- Las reglas creativas aprobadas viven en `docs/DECISIONS.md` y `docs/MVP_SCOPE.md`; los números están en `docs/BALANCE_PROVISIONAL.md` y NO son balance definitivo.

## Objetivo y tareas autorizadas
Instalar y fijar versión de framework de test compatible; crear ejecutor Windows reproducible, tests base, verificación headless, fixtures y archivo de balance provisional; definir arquitectura incremental de eventos y datos.

### Investigación visual y escena de referencia

1. Detectar versión exacta de Godot, renderer y entorno Windows. La base observada en H02 es Godot 4.7.2.stable.official.ed1daf0bf / GL Compatibility; verificarla de nuevo. No asumir técnicas compatibles por asociarse al estilo PSX.
2. Investigar renderer, importación glTF/GLB, materiales, texturas y filtrado por material, iluminación, sombras, fog, resolución interna/escalado y shaders retro opcionales. Justificar utilidad visual, compatibilidad y coste de cada técnica; no cambiar renderer sin justificarlo ni añadir dependencias innecesarias.
3. Construir una **escena de referencia aislada y reproducible**, conservando la entrada jugable H1. Incluir muestras de superficies/materiales, siluetas, elemento en primera persona y HUD/textos de prueba para comparar. Usar placeholders propios si no hay assets autorizados; no producir los sistemas futuros para simularlos.
4. Comparar materiales y técnicas A/B con la misma cámara, luz y resolución. Valorar nearest frente a alternativas por material sin imponerlo globalmente; revisar fuentes/HUD por separado. Las resoluciones y paleta de ART_BIBLE son provisionales; proponer presupuestos por categoría tras medir, sin límite universal de polígonos.
5. Comprobar coherencia Modern PSX / Retro Industrial Cyberpunk, siluetas, apuntado, información de amenaza/interacción y lectura en movimiento/luz tenue. Efectos potencialmente perjudiciales deben ser configurables o desactivables; comparar activados/desactivados. La revisión estética requiere aprobación del creador.
6. Medir rendimiento en ventana real sobre Windows; registrar hardware/driver, versión, renderer, resolución, condiciones y tiempos de frame. Comparar la base y cada efecto sin inventar objetivos de FPS. Proponer degradación visual que preserve siluetas, señales y HUD. Headless solo prueba carga/integridad; si no puede medirse rendimiento gráfico, registrar BLOCKED/NOT_RUN y la causa.
7. Inventariar todos los assets utilizados, incluidos placeholders, procedencia, modificaciones y rutas; comprobar licencias antes de incorporar terceros. Separar verificación legal/técnica y aprobación visual en ASSET_REGISTRY.
8. Registrar decisiones técnicas provisionales y evidencia: escena/pasos reproducibles, configuración A/B, resultados y capturas cuando sea posible. Capturas no obtenidas: NOT_RUN con motivo. Actualizar ARCHITECTURE solo con lo realmente implementado; no elevar una técnica experimental a decisión de gameplay.

H04 mantiene la vertical de arte temprano y desarrollará esta referencia después de aprobar H03, sin crear una segunda sala por defecto ni renumerar dependencias. H03 no produce las tres plantas, las seis armas finales ni arte definitivo.

## Fuera de alcance
- No implementar características de los hitos siguientes, no cambiar reglas creativas aprobadas, no descargar assets sin validar licencia, no regenerar desde cero el proyecto H1.
- No instalar plugins sin verificar compatibilidad/licencia. No hacer refactors masivos irrelevantes.
- No emular obligatoriamente limitaciones del hardware PS1 ni sacrificar legibilidad para obtener efectos retro. No aprobar parámetros visuales ni assets por intuición.

## Protocolo de implementación
1. Presenta un resumen breve del estado REAL del repo, rutas afectadas, plan mínimo y riesgos detectados.
2. Implementa en incrementos y mantiene compatibilidad con los hitos anteriores. Configura valores numéricos a través de datos, no magic numbers.
3. Para funcionalidad visual, deja escenas de test reproducibles; para lógica, funciones/recursos testeables. Evita archivos enormes y dependencia circular.
4. Actualiza `docs/ARCHITECTURE.md` solo con hechos comprobados; documenta cualquier decisión técnica provisional distinta de una decisión de gameplay.
5. Si hay ambigüedad creativa material, detén solo el subcomponente bloqueado y explica qué aprobación falta. Nunca decidas por el creador a escondidas.

## Tests AUTOMÁTICOS obligatorios
- Específicos del hito: Test de ejemplo con fallo controlado detectado; import Godot; test runner exit code !=0 en fallo; lectura de balance; test de no negativos y clamps; regresión H1.
- Escena comparativa: carga/importación sin recursos perdidos, dependencias de materiales/texturas/shaders válidas y configuración de efectos opcionales comprobable. Si se usa glTF/GLB, registrar prueba real de importación y el asset concreto; no atribuir PASS a formatos o técnicas no probados.
- Ejecuta la suite existente de test y la importación Godot headless, usando los ejecutables/configuración reales registrados en `docs/TEST_STRATEGY.md` (detectar PATH y versión). Si no es posible, registra BLOCKED/NOT_RUN y explicación: NO escribir PASS.
- Comprueba los casos límite, errores de interacción y regresión de H1; no ocultes warnings/errores en log.
- Registra comando EXACTO, fecha, OS, versión Godot, exit code, resultados/contadores y ruta de logs. Nunca inventes una ejecución ni un resultado.

## Criterios de aceptación
Comando local reproducible documentado, suite automatizada PASS, parámetros editables sin hardcodear, CI opcional sin credenciales.
- Referencia visual reproducible e inventariada; comparación de materiales/técnicas, compatibilidad, rendimiento y degradación documentada; capturas cuando sea posible, con sus limitaciones. Coherencia y legibilidad revisadas manualmente por el creador, sin afirmar aprobación artística a partir de un test headless.
- Tests críticos del hito y regresión pasan realmente; sin errores fatales o recursos perdidos.
- `docs/VALIDATION.md` documenta resultados reales, y `docs/HANDOFF.md` incluye estado reproducible y siguientes pasos.
- El usuario debe aprobar manualmente las pruebas jugables/visuales antes de cerrar el hito.

## Revisión manual visual y de rendimiento

Abrir la escena de referencia en la versión registrada, reproducir cámaras/condiciones A/B, recorrerla y comprobar siluetas, superficies, elemento FPS y textos con cada efecto activado/desactivado. Comparar claridad en luz clara/tenue y la información simulada de alarma; los fixtures no implementan sistemas futuros. Revisar capturas y mediciones reales, proponer ajustes de paleta/presupuestos y obtener aprobación expresa antes de cerrar H03. Documentar por separado cualquier comprobación no ejecutable.

## Entrega final OBLIGATORIA
Devuelve: (a) qué se implementó; (b) archivos cambiados; (c) comandos, exit codes y pruebas PASS/FAIL/BLOCKED/NOT_RUN; (d) pasos concretos de test manual que el creador debe ejecutar en Godot; (e) bugs y decisiones pendientes; (f) resumen para nuevo chat. **No te autoapruebes ni comiences H04.**

## Nota de auditoría documental H02 · 2026-11-20

Pendiente de autorización en su propio hito.

Consulta [DOCUMENTATION_AUDIT](../docs/DOCUMENTATION_AUDIT.md) y [DECISIONS](../docs/DECISIONS.md). Este aviso documenta el estado y no inicia el hito.
