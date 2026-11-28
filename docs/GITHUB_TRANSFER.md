# Abrir y continuar el proyecto desde otro PC

**2026-11-28 · entrega completa solicitada por el creador.** B1 está aprobado e integrado. GitHub contiene el proyecto Godot completo y la rama estable se llama **main**.

```powershell
git clone https://github.com/alejandrodapenasanz/ALABARDA_CYBERPUNK_H1.git
cd ALABARDA_CYBERPUNK_H1
git switch main
git rev-parse HEAD
git status --short
python -X utf8 tools/pipeline/verify_checkout.py
```

En una copia existente conserva cambios propios y actualiza con `git fetch origin` y `git pull --ff-only`. No resetear ni limpiar trabajo ajeno. Registra el SHA real como base.

## Abrir Godot

Instala o localiza Godot 4.7.2 estándar (Compatibility), importa el `project.godot` de esta carpeta y pulsa F5. Arranca `scenes/main.tscn` con el jugador y combate compartidos. No requiere abrir un sandbox B1 ni instalar Blender. Los `.gd.uid` están versionados y la caché `.godot` se regenera al importar. El laboratorio artístico se abre con F6 en `scenes/art_reference/modern_psx_lab.tscn`.

No hay dependencia de rutas absolutas de este PC en el runtime. Los logs históricos sí conservan las rutas donde se ejecutaron; no son configuración del juego. Si el PC de Claude dispone de Godot, puede abrir y probar el proyecto. Si no dispone de él, debe declarar NOT_RUN para las pruebas de motor y usar las comprobaciones estáticas disponibles.

## Contenido y verificaciones

Se incluyen código, escenas, Resources, shaders, assets redistribuibles y atribuciones, fuentes Blender propias H04, GdUnit4 6.2.3, pruebas útiles, prompts, plantillas, documentos y evidencia por SHA. Inventario/hashes de la transferencia en [checkout_manifest.json](../tools/pipeline/checkout_manifest.json). Compruébalo antes de editar; no regeneres hashes automáticamente para ocultar cambios.

Python solo hace falta para los runners y verificaciones, no para abrir Godot. Dependencias en `tools/pipeline/requirements.txt` (usar un venv). Comandos en [TEST_STRATEGY](TEST_STRATEGY.md); [resultados reales](../validation/B01/INTEGRATION.md).

No se versionan cachés `.godot`, `__pycache__`, entornos Python, ejecutables instalados ni credenciales. Las muestras locales excluidas por licencia/trazabilidad (Malorian, PSXAmmoBoxes y Electronics no verificadas) mantienen las restricciones de [ASSET_REGISTRY](ASSET_REGISTRY.md); no son dependencias del juego. El laboratorio contiene fallback propio. Todos los recursos necesarios para importar y ejecutar están publicados.

## Empezar B2

Leer [HANDOFF](HANDOFF.md) y entregar [next_prompt.md](../next_prompt.md) a Claude. El prompt crea B2 desde el main actualizado y exige extender el mismo runtime. H07/H08/H09 son el siguiente encargo, no una consecuencia automática de abrir el proyecto. H1 queda solo como fixture de regresión; B1 se conserva como historial de validación, no como rama o implementación paralela.
