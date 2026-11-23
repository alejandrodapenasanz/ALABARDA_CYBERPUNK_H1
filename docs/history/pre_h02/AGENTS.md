# ALABARDA STUDIOS — CYBERPUNK FPS | Instrucciones permanentes para Codex

**Versión:** 0.2 · 2026-11-20  
**Estado:** Preproducción. Este documento define el proceso; NO autoriza a implementar hitos futuros.  
**Propósito:** Este archivo debe permanecer en la **raíz del repositorio Godot**, con nombre exacto `AGENTS.md`. Se lee al comienzo de CADA nueva conversación/hito de Codex.

## 0. Orden de lectura obligatorio al iniciar cada hito
1. Este `AGENTS.md` completo.
2. `docs/GAME_VISION.md` y `docs/MVP_SCOPE.md` (cuando existan).
3. `docs/DECISIONS.md` y `docs/ROADMAP.md` (cuando existan).
4. `docs/ARCHITECTURE.md` y `docs/GAME_DESIGN.md` (cuando existan).
5. `docs/ART_BIBLE.md` y `docs/ASSET_REGISTRY.md` si se modifican imágenes, escenas, modelos o audio.
6. `docs/VALIDATION.md` y la implementación actual del proyecto.
7. El prompt del hito actual.

Si algún archivo todavía NO existe, señalarlo en el informe inicial y continuar con los documentos realmente disponibles. **No fingir que se ha leído.** Por ahora existen `docs/GDD_TECNICO_H1.md` y, en el paquete H1 original, `docs/DECISIONES.md` y `docs/VALIDACION.md`. Conservar esos nombres existentes hasta aprobar una migración; no crear documentos duplicados contradictorios.

## 1. Jerarquía de autoridad
1. Decisiones expresas más recientes del creador en el prompt del hito o en `docs/DECISIONS.md`.
2. Decisiones aprobadas documentadas en `docs/GAME_VISION.md`, `docs/MVP_SCOPE.md`, `docs/GAME_DESIGN.md` y `docs/ART_BIBLE.md`.
3. El PDF original `JUEGO CYBERPUNK.pdf` y `docs/GDD_TECNICO_H1.md` como fuentes históricas.
4. Propuestas y prototipos previos, solo si no contradicen decisiones aprobadas.

Ante una contradicción material, parar la funcionalidad afectada, documentar la discrepancia y solicitar decisión. No reinterpretar una **PROPUESTA** como decisión aprobada. No modificar el alcance sin permiso.

## 2. Decisiones creativas APROBADAS a 2026-11-20
Consultar **`docs/DECISIONS.md` como registro detallado y autoritativo** y `docs/MVP_SCOPE.md` como alcance consolidado. Los siguientes puntos son resumen, no sustituyen esos archivos:
- PC/Windows, Godot 4, FPS, cyborg brazo izquierdo, estética retro industrial + cyberpunk PS1.
- Vertical slice: guarida interactiva y un contrato Yakuza repetible de tres plantas, tres dificultades, boss dos fases, 15–25 minutos como objetivo.
- Tres armas cualesquiera de seis; katana, pistola silenciada y escopeta doble cañón iniciales; reserva infinita, cargadores y recarga animada; árbol de firmware con costes/dependencias/respec, perks compradas activas.
- Sigilo reversible con percepción y memoria, alarmas, cámaras, detección de cadáveres; los tres arquetipos patrullan.
- Energía 0–150, extracción mantenida con F, curación continua E, ascensores recargan 150; ejecuciones y reducción de daño conforme a `GAME_DESIGN.md`.
- Ultimates Dead Eye, Aimbot, Overdrive; una equipada, >=100 energía, consume toda y escala duración; efectos solo en armas compatibles.
- Compras en PC → timbre → paquete transportado → montaje 3–4 pasos o instalación USB → equipar; economía en créditos, guardado automático, progreso persistente. Jefe otorga trofeo y flag de shurikens futuro.
- Arte basado en assets gratuitos seleccionados/adaptados, con registro de licencias y coherencia visual.

## 3. PENDIENTE (no implementar por intuición)
- Todo parámetro numérico no aprobado: daño, HP enemigos, duraciones, costes y velocidades; sistemas de dificultades y objetivos concretos.
- Lista y dependencias concretas de perks, precios, recompensas y efectos físicos de mejoras de armas.
- Compatibilidades definitivas arma/ultimate, lógica exacta de parry automático, F/E contextuales y detalles de ejecución.
- Nivel detallado (salas, rutas, densidad), estados de IA y telemetría, fases de boss, feedback de cámaras/alarma/cadáveres.
- Selección y licencia *específica* de assets, convenciones de arte, animación, sonido, UI, controles, accesibilidad.
- Exclusiones del MVP propuestas en `docs/MVP_SCOPE.md` y criterio final de cierre: requieren revisión del creador.

## 4. Estructura documental objetivo
```text
AGENTS.md                          # Este contrato de trabajo, siempre en la raíz
project.godot
README.md
docs/
  GDD_TECNICO_H1.md                # Referencia histórica existente
  GAME_VISION.md                   # Pilares y experiencia aprobada
  MVP_SCOPE.md                     # Inclusiones, exclusiones y DoD final
  GAME_DESIGN.md                   # Mecánicas y reglas consolidadas
  ART_BIBLE.md                     # Paleta, geometría, pixelación, FX y UI
  ASSET_REGISTRY.md                # Fuente, autor, URL, licencia, versión, uso, modificaciones
  ARCHITECTURE.md                  # Escenas, scripts, señales, data y guardado
  ROADMAP.md                       # Hitos, dependencias y criterios verificables
  DECISIONS.md                     # Registro de decisiones aprobadas/pendientes
  VALIDATION.md                    # Pruebas realizadas, resultados y limitaciones
  HANDOFF.md                       # Estado ejecutable y siguientes pasos por hito
scenes/
scripts/
assets/
tests/
```
Los documentos objetivo pueden crearse en un hito de documentación aprobado; **no renombrar** archivos de la versión previa sin migración explícita. Los nombres nuevos no significan que ya existan.

## 5. Procedimiento obligatorio por hito
**Antes de editar:**
- Leer lo indicado en §0, examinar los archivos reales y `git status`.
- Resumir alcance, criterios de aceptación, componentes afectados y dependencias.
- Verificar versión de Godot disponible y cómo ejecutar el proyecto/tests.
- Identificar dudas que bloquean la implementación; preguntar solo por decisiones verdaderamente necesarias.

**Durante:**
- Implementar solamente el hito autorizado, en incrementos pequeños.
- Conservar funcionalidades anteriores, rutas de escenas y bindings de Input Map.
- Preferir escenas reutilizables, `Resource` para datos de configuración y señales desacopladas cuando aporten claridad.
- Evitar plugins/dependencias innecesarias y cambios masivos sin justificación.
- No descargar ni integrar assets sin licencia verificable y entrada en `ASSET_REGISTRY.md`.
- Todo código y comentario en estilo coherente con el repositorio; documentar parámetros de balance.

**Después:**
- Ejecutar los tests pertinentes, guardar comandos + resultados reales.
- Diferenciar `PASS`, `FAIL`, `BLOCKED` y `NOT_RUN`; NUNCA atribuir PASS a algo no ejecutado.
- Actualizar `docs/VALIDATION.md` y `docs/HANDOFF.md` con cambios, rutas y pasos de reproducción.
- Actualizar solo los documentos de diseño afectados por decisiones **aprobadas**, no por conjeturas.
- Entregar informe: resumen, archivos cambiados, test ejecutados, fallos/bloqueos y pruebas manuales pendientes.
- **No marcar el hito cerrado ni empezar el siguiente sin la validación expresa del creador.**

## 6. Pruebas y puertas de calidad
Cada futuro prompt de hito debe especificar tests concretos, sus datos de entrada, condiciones de éxito y regresiones que no deben romperse. Como mínimo:
1. **Integridad/importación:** abrir/importar Godot sin rutas o recursos rotos; ejecutar comprobación headless cuando el entorno lo permita.
2. **Unitarias:** lógica pura de daño, inventario, energía, costes, estados y persistencia cuando esos sistemas existan.
3. **Integración:** escenas e interacciones reales del hito, señales, nodos y transición entre estados.
4. **Regresión:** verificar funcionalidades de hitos anteriores mediante tests automatizados y smoke tests.
5. **Manual:** sensaciones de movimiento/disparo, legibilidad, feedback, sonido, IA de combate/sigilo y UX; requieren aprobación humana.
6. **Compilación/exportación Windows:** al cerrar el MVP y en hitos que afecten exportación.

Si se adopta un framework de pruebas (p. ej. GdUnit4), fijar versión compatible con Godot, instalación reproducible y comandos de ejecución **en `docs/ARCHITECTURE.md`**, sin asumir que ya está instalado. Tests headless no sustituyen pruebas manuales de jugabilidad.

**Puerta del hito:** requisitos satisfechos + tests obligatorios PASS + no regresiones críticas + informe de validación + aprobación manual explícita. Si no puede correrse un test crítico, el hito queda **PENDIENTE**, no PASS.

## 7. Política de assets y licencias
- Se priorizan packs gratuitos coherentes con la `ART_BIBLE.md`, optimizados para Godot 4 y Windows.
- Registrar antes de incorporar: nombre y versión del pack; creador; URL oficial; licencia EXACTA y fecha de consulta; si permite modificación, distribución incorporada al juego y uso comercial; atribución requerida; elementos excluidos; ruta en proyecto.
- Evitar copiar assets de otros videojuegos o asumir que una imagen de referencia autoriza reutilización.
- Si una licencia o autoría es ambigua, bloquear la incorporación hasta aclararla.
- Mantener la autoría y atribuciones exigidas en un archivo `THIRD_PARTY_NOTICES.md` cuando corresponda.
- No combinar packs con estilos incompatibles sin revisión artística.

## 8. Prompt estándar para comenzar cualquier hito
Todo prompt de Codex debe **empezar** por un bloque equivalente a este:

> Lee primero `AGENTS.md` desde la raíz del repositorio y cumple todas sus reglas. Después lee los documentos aplicables en `docs/`, especialmente `ROADMAP.md`, `DECISIONS.md`, `ARCHITECTURE.md`, `VALIDATION.md` y `HANDOFF.md` si existen. Antes de editar, indica el alcance del hito, el estado actual del repo y cualquier documento ausente. Implementa solo el hito indicado; ejecuta y documenta sus pruebas automáticas y regresiones; deja las pruebas manuales pendientes para mi validación. Actualiza el handoff. No declares el hito terminado ni comiences otro sin mi aprobación.

A continuación deben aparecer: **ID de hito / objetivo / requisitos aprobados / fuera de alcance / archivos probables / pruebas exigidas / criterios de aceptación / entregables**.

## 9. Validación H1 existente
El creador ha confirmado que **el prototipo H1 funciona en su PC**. Esa afirmación valida el arranque y jugabilidad básica desde la experiencia del creador, **no demuestra que todos los tests automáticos hayan pasado**. No reescribir retroactivamente su historial de pruebas.

## 10. Gestión de cambios
- Las decisiones deben llevar fecha y estado: `APROBADA`, `PENDIENTE` o `DESCARTADA`.
- Si cambia un requisito ya aprobado, registrar en `DECISIONS.md` la sustitución y qué hitos afecta.
- Si surge un requisito nuevo que altere alcance del MVP, pedir aprobación explícita antes de añadirlo al roadmap.
- Los ejemplos y valores propuestos nunca son especificaciones hasta que el creador los confirme.
