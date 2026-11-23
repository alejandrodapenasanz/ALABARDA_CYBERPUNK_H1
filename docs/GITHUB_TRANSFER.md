# Continuar desde otro PC

**2026-11-23 · publicación completa de desarrollo solicitada expresamente por el creador.** Esta entrega incluye código H1–H04, documentación completa de pipeline v2.1, prompts, plantillas, herramientas, históricos, evidencia y recursos redistribuibles. B1 sigue NOT_STARTED; publicar no registra una aprobación manual de gameplay ni de la migración.

## Descargar la versión actual

```powershell
git clone https://github.com/alejandrodapenasanz/ALABARDA_CYBERPUNK_H1.git
cd ALABARDA_CYBERPUNK_H1
git rev-parse HEAD
git status --short
python -X utf8 tools/pipeline/verify_checkout.py
```

La rama principal es **main**. Conservar el SHA que devuelve Git: es la base real para el otro PC. El verificador usa hashes explícitos de esta transferencia, no exige el índice privado del PC original. No ejecuta Godot ni descarga assets. Ejecutarlo antes de editar; después los cambios de B1 deben producir un nuevo candidato y manifest de pruebas, no regenerar automáticamente una baseline para esconder diferencias.

Si ya existe una copia limpia, actualizar mediante `git pull --ff-only`. Si hay cambios propios, conservarlos en una rama antes de actualizar; no resetearlos ni sobreescribirlos.

## Qué contiene

- Todos los documentos activos completos y el documento de migración suministrado.
- Los23 prompts H02–H24, catálogo B0–B8 y las tres plantillas Claude/Codex.
- Plantillas de handoff, manifest, resultados y bugs, schema JSON y herramientas de verificación.
- Código, escenas, Resources, shaders, GdUnit4, tests y scripts de desarrollo actuales.
- Muestras importables y kit H04, incluidas sus fuentes Blender propias.
- Originales de packs con redistribución verificada: CRT, HomeVideo, industria CC BY4.0, oficina y brazos, con atribuciones.
- Históricos/documentos originales y evidencia de validación, con sus estados y fechas originales.

Inventario exacto y SHA-256 por archivo: [checkout_manifest.json](../tools/pipeline/checkout_manifest.json). El manifiesto no se incluye en su propio hash. Las exclusiones figuran en `excluded_files`, con motivo por archivo; no hay omisiones silenciosas de documentación ni prompts.

## Exclusiones necesarias

No se publican `.git` del PC original, cachés `.godot`, `__pycache__`, entornos Python, ejecutables instalados ni credenciales. Git crea un historial/índice nuevo al clonar.

Los archivos siguientes conservan las restricciones documentadas en [ASSET_REGISTRY](ASSET_REGISTRY.md): originales Malorian y `resources/local_experiments/` (solo experimento local, distribución excluida), PSXAmmoBoxes (licencia contradictoria/no redistribuible) y PSX Electronics (trazabilidad de imágenes de terceros sin verificar). No hacen falta para importar el proyecto ni empezar B1. El laboratorio usa fallback propio sin Malorian y cajas propias. El resto de los recursos de prueba verificados sí se incluye. No copiar automáticamente esos archivos excluidos al repositorio público.

## PC Claude, sin Godot ni Blender

Leer [AGENTS](../AGENTS.md) y [HANDOFF](HANDOFF.md), incluyendo contrato de dos barras y pendientes. Python solo hace falta para verificaciones documentales; GDScript/escenas pueden editarse sin Godot. Para schema y tests del paquete:

```powershell
python -m venv .venv
& ./.venv/Scripts/python.exe -m pip install -r tools/pipeline/requirements.txt
& ./.venv/Scripts/python.exe -X utf8 tools/pipeline/test_manifest.py
& ./.venv/Scripts/python.exe -X utf8 tools/pipeline/test_checkout.py
& ./.venv/Scripts/python.exe -X utf8 tools/pipeline/validate_manifest.py validation/_templates/TEST_MANIFEST.json
```

La plantilla válida no es un lote INTEGRATION_READY; falta código B1 y su SHA. Las pruebas Godot siguen NOT_RUN en Claude. No instalar Godot/Blender solo para simular resultados.

Para comenzar B1, usar el bloque de nuevo chat en HANDOFF, reemplazando BASE_SHA por `git rev-parse HEAD`. La validación de la migración y el encargo B1 deben ser expresos en ese nuevo chat. P-015 (tecla de interacción) sigue pendiente: no elegirla por intuición; E queda reservada a curación. H05/H06 no implementan energía/E de H08 ni armas/ultimates de H07/H09.

## PC Codex y validación

Godot probado:4.7.2 estándar, Compatibility; GdUnit4 6.2.3 incluido. Blender4.5.3 solo para regenerar fuentes, no para abrir el juego. `project.godot` → F5 greybox H1; `scenes/art_reference/modern_psx_lab.tscn` → F6 laboratorio H04. La migración sigue documental: el código aún no tiene las nuevas mecánicas.

El runner H03/H04 reconoce la baseline portable cuando existe checkout_manifest.json. Conserva las evidencias antiguas; verifica los archivos publicados en lugar de exigir assets excluidos o el índice del PC anterior. [Resultados de esta transferencia](VALIDATION.md). El procedimiento C/P del workflow se aplica a los candidatos de B1 y siguientes.
