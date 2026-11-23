# ALABARDA CYBERPUNK · Prototipo H1

**H04 CERRADO Y APROBADO POR CREADOR · 2026-11-22.** Suite técnica PASS y revisión manual conjunta aceptada (D-021). H1–H04 cerrados; el taller permanece referencia experimental con assets de prueba. H05 no iniciado. El estado pendiente de la entrega inferior es histórico; [estado vigente y continuidad](docs/HANDOFF.md).

**H04 implementado para revisión · 2026-11-22.** El laboratorio existente ahora es un taller de referencia Modern PSX, con kit propio exportado desde Blender, materiales compartidos, señales HomeVideo y tres luces comparables. H1–H03 siguen cerrados; H04 tiene pruebas automáticas PASS y queda pendiente de tu aprobación visual. [Pasos de revisión y continuidad](docs/HANDOFF.md), [resultados](docs/VALIDATION.md).

Abre `scenes/art_reference/modern_psx_lab.tscn` y pulsa **F6**: cabecera **ALABARDA / H04**. **L** recorre atmósfera/neutra/alarma de muestra; **0** restaura el perfil aprobado. **1–4**, **A**, **F**, **X/B** y **M** conservan las comparaciones. **F5 sigue iniciando H1**.

Suite H04 completa: `python -X utf8 tools/h04/run_tests.py --godot $env:GODOT_BIN --output docs/evidence/h04/nueva_ejecucion --graphics`. Fuentes Blender en `art_sources/h04/`, GLB en `resources/art_kit/`; Blender solo es necesario para regenerar, no para abrir el proyecto.

Los apartados H03 inferiores describen la entrega anterior; su estado «H04 no iniciado» queda sustituido por esta cabecera.

Prototipo 3D greybox para PC creado con Godot 4 y GDScript. **H02 APROBADO POR CREADOR · 2026-11-20:** auditoría, limpieza y tres bugs corregidos, regresión headless en Godot 4.7.2 y confirmación manual posterior del creador de que ha hecho las pruebas y todo funciona. Resultados y alcance de la confirmación en [VALIDATION](docs/VALIDATION.md).

**H03 CERRADO Y APROBADO POR CREADOR · 2026-11-22:** GdUnit4 6.2.3, ejecutor Windows, Resources de balance y laboratorio **Modern PSX / Retro Industrial Cyberpunk** con assets experimentales. Suite automática PASS y confirmación humana de H1, HomeVideo y animación de brazos; perfil visual D-019 aprobado, HomeVideo preferida D-020. [Biblia](docs/ART_BIBLE.md), [registro/licencias](docs/ASSET_REGISTRY.md), [validación y límites](docs/VALIDATION.md). H04 no iniciado.

Para abrir el laboratorio: selecciona `scenes/art_reference/modern_psx_lab.tscn` y pulsa **F6**. **F5 sigue iniciando H1**. Controles y comparaciones en [HANDOFF](docs/HANDOFF.md).

Pruebas desde raíz (GODOT_BIN = ejecutable Godot console de tu instalación):

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File tools/run_tests.ps1 -Godot $env:GODOT_BIN
```

Añade -Graphics para capturas/mediciones con ventana real. Requiere Godot 4.7.2 estándar y Python 3.11+. [Instalación y comandos](docs/ARCHITECTURE.md).

## Cómo abrir
1. Usa Godot 4.7.2 estándar, versión localizada y probada en H02 (no necesitas .NET).
2. Abre esta carpeta de proyecto.
3. Abre Godot → **Importar** → selecciona el archivo `project.godot`.
4. Abre el proyecto y pulsa **F6** con la escena `main.tscn` seleccionada, o **F5** para iniciar el proyecto.

## Controles
- WASD: mover
- Ratón: apuntar
- Clic izquierdo: disparar (sin munición limitada)
- Shift: sprint
- Q + movimiento: dash
- Espacio: saltar
- Esc: liberar cursor / clic: capturar cursor
- R: regenerar blancos cuando se eliminan los 5

## Alcance real del prototipo
Arena generada con formas simples; cinco blancos estáticos (dos frágiles, tres de ataque a distancia por comprobación de rango); pistola hitscan y retroceso visual básico; 100 HP y respawn; HUD de vida y enemigos. **No contiene aún energía, brazo ejecutor, verdadera IA móvil, armas montables ni apartamento.**

## Si algo falla
Abre **Depurador → Errores** y copia el error y la línea. Registra el resultado en [docs/VALIDATION.md](docs/VALIDATION.md). La numeración H2–H5 es histórica; H02 y H03 están aprobados por el creador.

El diseño cita históricamente `JUEGO CYBERPUNK.pdf`, ausente del repo recibido. Ver [GDD histórico](docs/GDD_TECNICO_H1.md), [reglas vigentes](docs/DECISIONS.md), [pruebas y comandos](docs/TEST_STRATEGY.md) y [handoff](docs/HANDOFF.md).
# Corrección visual H03 · 2026-11-22

**Selección posterior aprobada D-019:** abrir/restaurar ahora usa nearest+mips, luz atmosférica, 1280×720, retro desactivado, sombras sí y niebla no. Vigente y revisable; prevalece sobre la luz neutra de diagnóstico descrita debajo. Los assets siguen de prueba.

Abrir `scenes/art_reference/modern_psx_lab.tscn` y **F6**. Controles laterales y cámara identificada; fuentes ocultas hasta pulsar **F**. **X** activa retro, **B** compara A/B y el slider regula intensidad; **0** restaura el perfil atmosférico aprobado. La Malorian suministrada aparece como muestra local en primera persona; el GitHub público conserva sustituto propio, sin ese modelo. **F5** sigue abriendo H1. Revisión humana H03 aprobada; assets de prueba, sin inicio de H04.
