# HANDOFF — B1 aprobado e integrado; preparado el encargo B2

**2026-11-28.** El creador confirmó el arreglo de paredes, aprobó B1 y encargó integrar todo en el flujo normal, limpiar elementos innecesarios, publicar el proyecto completo, fusionar a main y eliminar B1. Confirmó conservar el nombre **main**. [Fuente](../validation/B01/APPROVAL.md), D-031. B2 todavía no está implementado.

## Entrada y código que debe ampliar Claude

F5 → `scenes/main.tscn` → `scripts/main.gd`. Jugador único: `scenes/player/player.tscn`, `scripts/player/player_controller.gd` (PlayerController). Combate compartido: `scripts/combat/`, con HitscanWeapon provisional, salud/daño/hitboxes y estados por animación. Interacción en `scripts/interaction/`; peligros de arena en `scripts/world/environment_hazards.gd`.

Se conservan el modelo/posición del arma y su prevención de penetración, dash doble toque, F/E separados y salud/regeneración aprobados. La arena actual se abre con F5, sin rótulos B1 ni instrucciones internas de hitos. Futuras armas/energía/ultimates deben integrarse aquí. No reconstruir otro jugador/sandbox por lote.

## Aprobación, integración y pruebas

- B1 aprobado sobre runtime `1401e05269fc4919f3658788e7de48bc5a4aa148`, paquete `a0c9820`; el creador confirmó «Perfecto, funciona» y «B1 queda aprobado». BUG-B1-02 cerrado con esa confirmación.
- Candidato de integración **`5a622069c4267821ba5e5a16b6404a60ed7ad6a8`**, probado en worktree limpio: estático 45 scripts/12 recursos, importación, 37 unitarias, 38 integración, smoke 600 frames de la entrada configurada y regresiones H1/H03/H04 PASS. Mismo Godot 4.7.2, GdUnit4 6.2.3, Python 3.13.15 y Windows 11 Home 10.0.26300.
- [INTEGRATION](../validation/B01/INTEGRATION.md) registra comandos/evidencia y la verificación posterior al merge. Los resultados manuales anteriores no se inventan como ejecuciones nuevas de la integración.
- Suites normales: `tests/gameplay/unit`, `tests/gameplay/integration`, runner `tools/gameplay/run_tests.py`. Se añadieron tres casos de conexión real de escena principal. H1 antiguo solo en `tests/fixtures/h1`; el probe mantiene sus 34 comprobaciones.

## Limpieza y transferencia

Retiradas rutas de runtime `scripts/b1`, `scenes/b1`, el jugador con nombre de lote y el runner/suites separados. Se preservaron los UIDs existentes y se versionaron para otros PC. Regresiones útiles conservadas. Se retiraron 148 HTML/CSS/logos generados duplicados del árbol visible, archivados byte a byte con hashes; logs/JUnit/JSON intactos. `validation/.gdignore` excluye evidencia de la importación del motor.

Repositorio completo para abrir `project.godot` en otro PC; [GITHUB_TRANSFER](GITHUB_TRANSFER.md) explica instalación/importación. No hacen falta cachés locales ni Blender para abrirlo. Comprobar disponibilidad real de herramientas antes de declarar ausencias o PASS.

## Siguiente encargo

Copiar [next_prompt.md](../next_prompt.md) en Claude: B2 = H07/H08/H09, rama nueva desde main actualizado, checkpoints y paquete `validation/B02`. Leer AGENTS/contratos/prompts completos. La creación del texto no ejecuta B2.

Respetar pendientes P-001/P-005/P-006/P-011/P-017: bindings, duplicados/vacíos, compatibilidad y balance no se deciden por intuición. D-029 (cámara futura de muerte en tercera persona elevada y cuerpo tumbado) queda fuera de B2. D-030 prohíbe esconder penetración cambiando arbitrariamente el encuadre o render del arma; nuevas geometrías/animaciones requieren ampliar la colisión y tests.
