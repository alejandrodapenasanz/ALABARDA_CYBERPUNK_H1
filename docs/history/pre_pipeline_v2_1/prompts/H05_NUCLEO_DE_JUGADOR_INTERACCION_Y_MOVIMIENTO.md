Lee primero `AGENTS.md` completo en la raíz del repositorio. Después lee `docs/GAME_VISION.md`, `docs/MVP_SCOPE.md`, `docs/DECISIONS.md`, `docs/GAME_DESIGN.md`, `docs/ROADMAP.md`, `docs/ARCHITECTURE.md`, `docs/BALANCE_PROVISIONAL.md`, `docs/TEST_STRATEGY.md`, `docs/VALIDATION.md` y `docs/HANDOFF.md` si existen; para cambios visuales, también `docs/ART_BIBLE.md` y `docs/ASSET_REGISTRY.md`. Inspecciona `project.godot`, escenas/scripts reales y `git status` ANTES de editar. No supongas que la arquitectura propuesta ya está implementada. Aclara qué archivos faltan y evita inventar resultados. Implementa SOLO el hito de este prompt, sin empezar el siguiente. Registra comandos reales, exit codes, logs, pruebas no ejecutadas y problemas, y deja pruebas manuales para aprobación expresa del creador.

# H05 — Núcleo de jugador, interacción y movimiento

**Precondición H04 satisfecha · 2026-11-22:** H04 cerrado y aprobado expresamente, D-021. Reutilizar su referencia experimental junto con D-019/D-020. Esta cabecera sustituye la nota inferior de revisión H04 pendiente. H05 sigue requiriendo encargo propio; no se ejecuta con el cierre H04.

## Continuidad H04 · 2026-11-22 — no autoriza H05

H04 implementado con pruebas técnicas PASS, **revisión manual pendiente**. Reutilizar la sala existente `scenes/art_reference/modern_psx_lab.tscn`, perfil D-019/HomeVideo D-020 y kit con fuentes `art_sources/h04/` y exports `resources/art_kit/`; revisar ART_BIBLE/ASSET_REGISTRY/HANDOFF antes de tocar visuales. No duplicar ni sustituir modelos por primitivas sin justificación. La sala es fixture visual sin colisiones/IA; no asumir que es un nivel jugable. Malorian sigue opcional local y rig separado; no arma final ni integración de manos. El mapa de teclas L/1–4/A/F/X/B/R del laboratorio no constituye Input Map de gameplay. H1 mantiene su ruta y controles originales. La pipeline Blender→GLB ya está comprobada, no instalar otra dependencia por defecto.

## Contexto específico y precondición
- Proyecto: ALABARDA STUDIOS CYBERPUNK FPS, Godot 4, Windows, estética Modern PSX / Retro Industrial Cyberpunk (D-017 y docs/ART_BIBLE.md), reinterpretación moderna sin emulación literal de PS1; primero funcional y después pulido.
- Precondición: H04 aprobado. Si no está documentada/aprobada en `docs/HANDOFF.md` y `docs/VALIDATION.md`, **no asumir** que lo está; reporta BLOCKED y completa únicamente la auditoría que sí sea segura.
- Las reglas creativas aprobadas viven en `docs/DECISIONS.md` y `docs/MVP_SCOPE.md`; los números están en `docs/BALANCE_PROVISIONAL.md` y NO son balance definitivo.

## Objetivo y tareas autorizadas
Separar CharacterBody3D, cámara, inventario, acciones y movimiento; sprint, dash, salto, colisiones; mapa de input sin conflicto F/E: F extracción contextual, E curación mantenida fuera de objetos interactuables, tecla de interacción dedicada propuesta R o uso contextual E con precedencia documentada; pedir decisión si choque bloqueante.

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
- Específicos del hito: Unit tests de estados y cooldown; integración raycast/colisión, dash bloqueado por paredes, no doble comando E; smoke con perfiles existentes; matriz de tres dificultades desde H13; regresión H1.
- Ejecuta la suite existente de test y la importación Godot headless, usando los ejecutables/configuración reales registrados en `docs/TEST_STRATEGY.md` (detectar PATH y versión). Si no es posible, registra BLOCKED/NOT_RUN y explicación: NO escribir PASS.
- Comprueba los casos límite, errores de interacción y regresión de H1; no ocultes warnings/errores en log.
- Registra comando EXACTO, fecha, OS, versión Godot, exit code, resultados/contadores y ruta de logs. Nunca inventes una ejecución ni un resultado.

## Criterios de aceptación
Movimiento jugable con estado estable e inputs documentados, sin teletransporte a través de geometría.
- Tests críticos del hito y regresión pasan realmente; sin errores fatales o recursos perdidos.
- `docs/VALIDATION.md` documenta resultados reales, y `docs/HANDOFF.md` incluye estado reproducible y siguientes pasos.
- El usuario debe aprobar manualmente las pruebas jugables/visuales antes de cerrar el hito.

## Entrega final OBLIGATORIA
Devuelve: (a) qué se implementó; (b) archivos cambiados; (c) comandos, exit codes y pruebas PASS/FAIL/BLOCKED/NOT_RUN; (d) pasos concretos de test manual que el creador debe ejecutar en Godot; (e) bugs y decisiones pendientes; (f) resumen para nuevo chat. **No te autoapruebes ni comiences H06.**

## Nota de auditoría documental H02 · 2026-11-20

P-005: prioridad E y tecla dedicada requieren decisión. P-012 resuelta: probar perfiles existentes; matriz de dificultades a partir de H13.

Consulta [DOCUMENTATION_AUDIT](../docs/DOCUMENTATION_AUDIT.md) y [DECISIONS](../docs/DECISIONS.md). Este aviso documenta el estado y no inicia el hito.
