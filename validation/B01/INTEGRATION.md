# Integración de B1 en el juego normal — 2026-11-28

B1 **APPROVED** por el creador; [fuente y autorización de merge/limpieza](APPROVAL.md). Candidato de integración probado: **`5a622069c4267821ba5e5a16b6404a60ed7ad6a8`**. La aprobación del gameplay corresponde al runtime `1401e05`; la incorporación de rutas/entrada normal fue encargada expresamente y se verificó técnicamente de nuevo.

| Antes | Ahora |
|---|---|
| Sandbox B1 separado en F6 | `scenes/main.tscn` / `scripts/main.gd`, entrada F5 |
| B1Player y b1_player.tscn | PlayerController y `scenes/player/player.tscn` |
| FixtureWeapon | HitscanWeapon, misma geometría/materiales/poses/colisión |
| scripts/b1/sandbox_hazards.gd | `scripts/world/environment_hazards.gd` |
| tests/b1 y tools/b1 | `tests/gameplay` y `tools/gameplay/run_tests.py` |
| H1 como entrada viva paralela | `tests/fixtures/h1`, solo regresión histórica |

Las suites conservan todas sus aserciones de comportamiento; solo migran referencias/nombres, y se añaden tres pruebas de escena principal (jugador/interacción, salud/HUD/regeneración y disparo/feedback). Se conservan los UIDs y se versionan para clonar/importar en otro PC. Se retiraron 148 reportes HTML/CSS/logos duplicados, archivados con hashes; no se borraron logs/JUnit/resultados ni regresiones útiles. `validation/.gdignore` evita importar evidencia en Godot.

## Verificación del candidato

Worktree `C:/dev/ALABARDA_INTEGRATION_C_5a62206`, limpio antes de importar, manifest --ready PASS. Entorno: Godot 4.7.2.stable.official.ed1daf0bf, GdUnit4 6.2.3, Python 3.13.15, Windows 11 Home 10.0.26300. Solo automatización; no nueva prueba manual por Codex.

| Check | Exit | Resultado |
|---|---:|---|
| Estático | 0 | PASS, 45 scripts/12 recursos, 20 hallazgos legados y aviso H04 previo |
| Importación | 0 | PASS |
| gameplay_unit | 0 | PASS, 37/37 |
| gameplay_integration | 0 | PASS, 38/38, cero fallos/errores/omitidos |
| game_smoke | 0 | PASS, 600 frames de la entrada configurada sin pasar una escena alternativa |
| H1/H03/H04 | 0 | PASS; H1 34/0/1, H03 8+8, H04 4; control negativo esperado exit 100 |

Comando principal: `python -X utf8 tools/gameplay/run_tests.py --godot <console real> --output C:/dev/ALABARDA_B1_INTEGRATION_20261127/attempt_01`. [Argv/cwd/fechas](evidence/integration_01/preflight/runner.json), [summary](evidence/integration_01/summary.json), [manifest](evidence/integration_01/preflight/manifest_ready.stdout.log). Las rutas con la fecha inicial 20261127 se crearon al comenzar el trabajo; los logs conservan la fecha real de ejecución, 2026-11-28.

## Publicación y fusión

Merge **`be3a94fb9118664ebc95919398a020a968b16074`**, padres `796255711fd04c4e6a6d061fba718e86db8cf099` y `63f0757`. Se comprobó este SHA exacto en `C:/dev/ALABARDA_MAIN_VERIFY_be3a94f`, limpio antes de importar y tras terminar. El contenido de gameplay coincide con el candidato de integración; la fusión no añadió cambios al juego.

Resultado posterior a merge: **PASS**. Importación exit 0; unitarias 37/37 exit 0; integración 38/38 exit 0 (sin fallos/errores/omitidos); entrada F5 600 frames exit 0; regresiones H1/H03/H04 exit 0. H1 34/0/1 headless, H03 8+8, H04 4; control negativo intencionado exit 100. Estático 45 scripts/12 recursos PASS, con 20 hallazgos aceptados y el aviso legado H04 ya descrito. Esquema, tests de manifest, documentación y transferencia PASS (2.920 archivos/707 enlaces). Mismas versiones reales indicadas arriba.

[Summary](evidence/post_merge/summary.json), [argv/cwd/exit](evidence/post_merge/preflight/runner.json), [manifest --ready](evidence/post_merge/preflight/manifest_ready.stdout.log), [pipeline](evidence/post_merge/pipeline/summary.json), [identidad del candidato](evidence/post_merge/identity.json). La automatización no constituye una nueva revisión visual humana; se conserva la aprobación expresa del creador y su encargo de integración.

`git push origin main` publicó el merge; después `git push origin --delete B1` y `git branch -d B1` retiraron la rama remota y local, todos exit 0. [Evidencia de publicación](evidence/post_merge/publication/remote_refs.stdout.log). El historial de B1 permanece en main. La copia principal de trabajo queda en main. El commit posterior que incorpora esta evidencia solo cambia documentación, evidencia y hashes de esos documentos; no modifica el código probado.

Proyecto completo para otro PC y prompt B2 en `next_prompt.md`. B2 no se ha implementado ni creado en este cierre. Los logs originales conservan saltos de línea emitidos por las herramientas; no se normalizan para satisfacer comprobaciones de whitespace de documentación.
