# ALABARDA CYBERPUNK · Prototipo H1

Prototipo 3D greybox para PC creado con Godot 4 y GDScript. **No es una demo final ni está validado aún en el editor.**

## Cómo abrir
1. Instala Godot 4.x (editor normal, no necesitas .NET).
2. Descomprime el ZIP.
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
Abre **Depurador → Errores** y copia el error y la línea. Registra el resultado en `docs/VALIDACION.md` antes de continuar a H2.

El diseño proviene de `JUEGO CYBERPUNK.pdf`, documento del creador. Ver `docs/GDD_TECNICO_H1.md`.
