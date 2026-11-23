Lee primero `AGENTS.md` completo en la raíz del repositorio. Después lee `docs/GAME_VISION.md`, `docs/MVP_SCOPE.md`, `docs/DECISIONS.md`, `docs/GAME_DESIGN.md`, `docs/ROADMAP.md`, `docs/ARCHITECTURE.md`, `docs/BALANCE_PROVISIONAL.md`, `docs/TEST_STRATEGY.md`, `docs/VALIDATION.md` y `docs/HANDOFF.md` si existen; para cambios visuales, también `docs/ART_BIBLE.md` y `docs/ASSET_REGISTRY.md`. Inspecciona `project.godot`, escenas/scripts reales y `git status` ANTES de editar. No supongas que la arquitectura propuesta ya está implementada. Aclara qué archivos faltan y evita inventar resultados. Implementa SOLO el hito de este prompt, sin empezar el siguiente. Registra comandos reales, exit codes, logs, pruebas no ejecutadas y problemas, y deja pruebas manuales para aprobación expresa del creador.

# H20 — Jefe Yakuza: dos fases y recompensa

## Contexto específico y precondición
- Proyecto: ALABARDA STUDIOS CYBERPUNK FPS, Godot 4, Windows, estética industrial + PS1, primero funcional y después pulido.
- Precondición: H19 aprobado. Si no está documentada/aprobada en `docs/HANDOFF.md` y `docs/VALIDATION.md`, **no asumir** que lo está; reporta BLOCKED y completa únicamente la auditoría que sí sea segura.
- Las reglas creativas aprobadas viven en `docs/DECISIONS.md` y `docs/MVP_SCOPE.md`; los números están en `docs/BALANCE_PROVISIONAL.md` y NO son balance definitivo.

## Objetivo y tareas autorizadas
Boss con shurikens proyectil, telegraphs claros, dos fases con cambios de patrón deterministas, salud/balance configurados, victoria trofeo + flag shurikens futuros (NO arma jugable), reintento muerte reinicia; no otorgar recompensas dos veces.

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
- Específicos del hito: Tests transición fase umbral y solo una vez, shuriken no atraviesa colisiones, señalización ataques, muerte/victoria orden, recompensa exactamente 1 por completion, derrota cero premio, reintento sin estados residuales, regresión niveles.
- Ejecuta la suite existente de test y la importación Godot headless, usando los ejecutables/configuración reales registrados en `docs/TEST_STRATEGY.md` (detectar PATH y versión). Si no es posible, registra BLOCKED/NOT_RUN y explicación: NO escribir PASS.
- Comprueba los casos límite, errores de interacción y regresión de H1; no ocultes warnings/errores en log.
- Registra comando EXACTO, fecha, OS, versión Godot, exit code, resultados/contadores y ruta de logs. Nunca inventes una ejecución ni un resultado.

## Criterios de aceptación
Boss derrotables en las tres dificultades y flag/trofeo persistentes.
- Tests críticos del hito y regresión pasan realmente; sin errores fatales o recursos perdidos.
- `docs/VALIDATION.md` documenta resultados reales, y `docs/HANDOFF.md` incluye estado reproducible y siguientes pasos.
- El usuario debe aprobar manualmente las pruebas jugables/visuales antes de cerrar el hito.

## Entrega final OBLIGATORIA
Devuelve: (a) qué se implementó; (b) archivos cambiados; (c) comandos, exit codes y pruebas PASS/FAIL/BLOCKED/NOT_RUN; (d) pasos concretos de test manual que el creador debe ejecutar en Godot; (e) bugs y decisiones pendientes; (f) resumen para nuevo chat. **No te autoapruebes ni comiences H21.**
