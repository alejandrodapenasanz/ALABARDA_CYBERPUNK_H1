Lee primero `AGENTS.md` completo en la raíz del repositorio. Después lee `docs/GAME_VISION.md`, `docs/MVP_SCOPE.md`, `docs/DECISIONS.md`, `docs/GAME_DESIGN.md`, `docs/ROADMAP.md`, `docs/ARCHITECTURE.md`, `docs/BALANCE_PROVISIONAL.md`, `docs/TEST_STRATEGY.md`, `docs/VALIDATION.md` y `docs/HANDOFF.md` si existen; para cambios visuales, también `docs/ART_BIBLE.md` y `docs/ASSET_REGISTRY.md`. Inspecciona `project.godot`, escenas/scripts reales y `git status` ANTES de editar. No supongas que la arquitectura propuesta ya está implementada. Aclara qué archivos faltan y evita inventar resultados. Implementa SOLO el hito de este prompt, sin empezar el siguiente. Registra comandos reales, exit codes, logs, pruebas no ejecutadas y problemas, y deja pruebas manuales para aprobación expresa del creador.

# H04 — Vertical de arte temprano

**CERRADO / APROBADO POR CREADOR · 2026-11-22:** confirmación «Si, todo me cuadra» tras revisión manual y suite técnica PASS; D-021. Las notas inferiores de revisión pendiente conservan el contexto de la entrega anterior. H05 no iniciado.

**Ejecución autorizada · 2026-11-22:** el creador solicita «Con h1,h2 y h3 cerrados; empieza h4». Implementación entregada, suite técnica PASS, revisión manual pendiente según HANDOFF/VALIDATION. Esta cabecera sustituye las notas inferiores de falta de autorización. Se preserva el prompt como alcance; no se aprueba H04 ni se empieza H05 automáticamente.

**Precondición satisfecha · 2026-11-22:** H03 cerrado y aprobado expresamente por el creador, incluidas pruebas manuales H1, HomeVideo y animación de brazos. Perfil D-019 vigente; HomeVideo preferida y legible en la muestra D-020. Este estado sustituye las menciones inferiores a esperar aprobación H03; H04 sigue requiriendo encargo propio y no se ejecuta con el cierre H03.

Continuidad vigente D-019 (2026-11-22): el creador aprueba como referencia actual nearest+mips, luz atmosférica, 1280×720, retro apagado, sombras sí y niebla no; revisable por decisión futura. Esta selección sustituye la base neutra de diagnóstico del laboratorio. No es autorización para comenzar H04 ni aprobación de assets finales.

Continuidad H03 · 2026-11-21: la base real es `scenes/art_reference/modern_psx_lab.tscn`, con GdUnit4 6.2.3 y `tools/run_tests.ps1`. Leer HANDOFF/ASSET_REGISTRY: originales en assets ignorados, muestras licenciadas en resources/art_samples; ninguna selección final ni aprobación visual. PSXAmmoBoxes y Malorian tienen restricciones registradas. Reutilizar la base y evidencia A/B cuando el creador apruebe H03 y autorice H04; esta nota no ejecuta el hito.

## Contexto específico y precondición
- Proyecto: ALABARDA STUDIOS CYBERPUNK FPS, Godot 4, Windows, estética Modern PSX / Retro Industrial Cyberpunk (D-017 y docs/ART_BIBLE.md), reinterpretación moderna sin emulación literal de PS1; primero funcional y después pulido.
- Precondición: Con H03 aprobado. Si no está documentada/aprobada en `docs/HANDOFF.md` y `docs/VALIDATION.md`, **no asumir** que lo está; reporta BLOCKED y completa únicamente la auditoría que sí sea segura.
- Las reglas creativas aprobadas viven en `docs/DECISIONS.md` y `docs/MVP_SCOPE.md`; los números están en `docs/BALANCE_PROVISIONAL.md` y NO son balance definitivo.

## Objetivo y tareas autorizadas
Desarrollar la escena de referencia comparativa de H03 como vertical **Modern PSX / Retro Industrial Cyberpunk** según D-017 y ART_BIBLE; kit coherente de materiales, iluminación, texturas, props, silueta enemigo y viewmodel provisional; pipeline Blender→GLB y registro de assets con verificación real de licencias. Reutilizar la base aprobada, sin duplicar salas por defecto. No bloquear por assets: placeholders propios si falta permiso. Mantener legibilidad moderna y efectos retro potencialmente perjudiciales configurables o desactivables; presupuestos/paleta se validan, no se presuponen definitivos. Esta sincronización PRE-H03 no inicia H04.

## Fuera de alcance
- No implementar características de los hitos siguientes, no cambiar reglas creativas aprobadas, no descargar assets sin validar licencia, no regenerar desde cero el proyecto H1.
- No instalar plugins sin verificar compatibilidad/licencia. No hacer refactors masivos irrelevantes.

## Protocolo de implementación
1. Presenta un resumen breve del estado REAL del repo, rutas afectadas, plan mínimo y riesgos detectados.
2. Implementa en incrementos y mantiene compatibilidad con los hitos anteriores. Configura valores numéricos a través de datos, no magic numbers.
3. Para funcionalidad visual, deja escenas de test reproducibles; para lógica, funciones/recursos testeables. Evita archivos enormes y dependencia circular.
4. Actualiza `docs/ARCHITECTURE.md` solo con hechos comprobados; documenta cualquier decisión técnica provisional distinta de una decisión de gameplay.
5. Si hay ambigüedad creativa material, detén solo el subcomponente bloqueado y explica qué aprobación falta. Nunca decidas por el creador a escondidas.

## Tests AUTOMÁTICOS obligatorios
- Específicos del hito: Carga/import de GLB y materiales; validación de rutas/refs; snapshot manual de lookdev en 3 condiciones de luz; comparación rendimiento básica, sin objetivos de FPS fingidos; regresión H1.
- Ejecuta la suite existente de test y la importación Godot headless, usando los ejecutables/configuración reales registrados en `docs/TEST_STRATEGY.md` (detectar PATH y versión). Si no es posible, registra BLOCKED/NOT_RUN y explicación: NO escribir PASS.
- Comprueba los casos límite, errores de interacción y regresión de H1; no ocultes warnings/errores en log.
- Registra comando EXACTO, fecha, OS, versión Godot, exit code, resultados/contadores y ruta de logs. Nunca inventes una ejecución ni un resultado.

## Criterios de aceptación
Sala de referencia aprobable y reglas visuales medibles; ningún asset sin trazabilidad.
- Tests críticos del hito y regresión pasan realmente; sin errores fatales o recursos perdidos.
- `docs/VALIDATION.md` documenta resultados reales, y `docs/HANDOFF.md` incluye estado reproducible y siguientes pasos.
- El usuario debe aprobar manualmente las pruebas jugables/visuales antes de cerrar el hito.

## Entrega final OBLIGATORIA
Devuelve: (a) qué se implementó; (b) archivos cambiados; (c) comandos, exit codes y pruebas PASS/FAIL/BLOCKED/NOT_RUN; (d) pasos concretos de test manual que el creador debe ejecutar en Godot; (e) bugs y decisiones pendientes; (f) resumen para nuevo chat. **No te autoapruebes ni comiences H05.**

## Nota de auditoría documental H02 · 2026-11-20

Continuidad H03 actualizada 2026-11-22: reutilizar laboratorio corregido con controles externos al 3D, cámara 1 frontal, F para fuentes, X/B/slider para retro y reset neutro. La Malorian es muestra opcional local en resources/local_experiments, excluida de GitHub, sin acople al rig ni gameplay; no asumirla asset final. Publicación usa fallback propio. Revisar capturas/pruebas run_05_readability y el feedback humano antes de cualquier vertical H04. Esta nota no autoriza iniciar H04 ni aprueba los parámetros del shader.

Pendiente de autorización en su propio hito.

Consulta [DOCUMENTATION_AUDIT](../docs/DOCUMENTATION_AUDIT.md) y [DECISIONS](../docs/DECISIONS.md). Este aviso documenta el estado y no inicia el hito.
