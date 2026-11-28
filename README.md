# ALABARDA CYBERPUNK — proyecto Godot completo

Abre `project.godot` con **Godot 4.7.2 estándar** y pulsa **F5**. La entrada normal es `scenes/main.tscn`: jugador, movimiento, interacción, salud y combate aprobados de H05/H06, con colisión del arma contra paredes. No hay un juego B1 paralelo.

Controles actuales: WASD, dash WW/AA/SS/DD, Shift, Espacio, ratón/clic, F interactuar y Esc liberar cursor. El arma recarga al vaciarse. E/energía, seis armas/slots y ultimates se implementarán en B2. La arena actual es de entrenamiento; no es el contrato final Yakuza.

**B1 APPROVED por el creador.** [Aprobación](validation/B01/APPROVAL.md), [integración y pruebas](validation/B01/INTEGRATION.md). La rama estable es `main`. Para encargar B2 a Claude, copia [next_prompt.md](next_prompt.md); B2 no se ha implementado en este cierre.

El repositorio incluye escenas, scripts, Resources, shaders, assets redistribuibles, fuentes artísticas propias, GdUnit4, documentación y pruebas útiles. Godot regenera `.godot` al importar: no necesita la caché ni las rutas de este PC. [Guía para otro ordenador](docs/GITHUB_TRANSFER.md).

```powershell
python -X utf8 tools/pipeline/verify_checkout.py
python -X utf8 tools/pipeline/check_godot_static.py
python -X utf8 tools/gameplay/run_tests.py --godot <ruta_console.exe> --output <directorio_nuevo_fuera_del_proyecto>
```

Resuelve los marcadores antes de ejecutar. Cobertura integrada: 37 unitarias y 38 de integración, smoke de la entrada F5 y regresión H1/H03/H04. H1 antiguo solo está en `tests/fixtures/h1`; el laboratorio visual permanece en `scenes/art_reference/modern_psx_lab.tscn` para F6.

Lee [AGENTS](AGENTS.md), [HANDOFF](docs/HANDOFF.md), [arquitectura](docs/ARCHITECTURE.md) y [roadmap](docs/ROADMAP.md). Los históricos de validación se conservan por SHA; los reportes HTML duplicados están archivados y fuera de la importación de Godot.
