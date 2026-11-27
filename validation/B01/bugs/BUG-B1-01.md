# BUG-B1-01 — la suite de combate no se puede descubrir en Godot

- Lote / hito: B1 / H06; severidad bloqueante para B1-INTEGRATION.
- Candidato fallido: `bfe7071b63e756200f4e1ea94160175bc6294644`.
- Paquete leído: `f951cb6892e2867f28ceb3edebb823377c6ecd8f`, rama `B1`.
- Entorno observado el 2026-11-23: Windows 11 Home 10.0.26200, Godot `4.7.2.stable.official.ed1daf0bf`, GdUnit4 `6.2.3`, Python `3.13.15`.
- Estado: cerrado técnicamente el 2026-11-27 tras retest del fix `94e4880b03b60d1517917d11ab98dce786499d69`. Aprobación manual del lote pendiente.

## Reproducción

1. Crear un worktree limpio del candidato e importar con Godot 4.7.2.
2. Desde su raíz, ejecutar `${GODOT_BIN} --headless --path . -s res://addons/gdUnit4/bin/GdUnitCmdTool.gd -a res://tests/b1/integration --ignoreHeadlessMode -rd <evidencia nueva>`.
3. GdUnit sale con **105** durante el descubrimiento, antes de ejecutar los 28 casos; no produce JUnit. El argv y cwd reales están en [b1_integration.json](../evidence/attempt_01/b1_integration.json).

Esperado: 28 casos ejecutables. Observado en [stderr íntegro](../evidence/attempt_01/b1_integration.stderr.log):

```text
SCRIPT ERROR: Parse Error: Cannot infer the type of "wall" variable because the value doesn't have a set type.
   at: GDScript::reload (res://tests/b1/integration/combat_test.gd:69)
SCRIPT ERROR: Parse Error: Cannot infer the type of "player" variable because the value doesn't have a set type.
   at: GDScript::reload (res://tests/b1/integration/combat_test.gd:208)
```

El mismo error de `player` aparece en las líneas 218 y 235. Sin captura visual: ejecución automática headless.

## Diagnóstico

Hecho: `world` se declaraba como `Node3D`, pero `add_block` y `spawn_player` pertenecen al script precargado `World`. El parser no podía inferir sus retornos en los cuatro usos de `:=`.

Hipótesis inicial, confirmada por el retest: conservar el tipo concreto `World` permite resolver esas inferencias sin modificar ninguna aserción, fixture ni mecánica.

## Corrección y regresión

Corrección local autorizada: una línea, `var world: World`, en `tests/b1/integration/combat_test.gd`. El mismo commit actualiza **solo** el hash de ese archivo en `tools/pipeline/checkout_manifest.json`, de `c1e2a46c658774179349585dab18436b78c8ffb3a03438b075c32711f35a5648` a `aa40f887823d31ab74d4d36567c72665b0aad69aa178feaf265f0b2268e82a82`. No se regeneró la baseline completa ni se cambiaron expectativas para ocultar el fallo.

Retest: candidato limpio del fix, paquete comprobado con `validate_manifest.py --ready`, B1-STATIC y runner completo con B1-INTEGRATION y regresiones H1/H03/H04; evidencia nueva en `attempt_02`. El intento 01 se conserva.

Resultado real: [B1-INTEGRATION](../evidence/attempt_02/b1_integration.json) exit 0, 28 tests, 0 fallos/errores/omitidos. [Runner completo](../evidence/attempt_02/summary.json) PASS: unitarias 37/37, importación, smoke y regresión PASS. [H03/H1](../evidence/attempt_02/regression/regression/summary.json): 8+8 positivos, control negativo con su fallo esperado y exit 100, H1 34 PASS / 0 FAIL / 1 NOT_RUN; [H04](../evidence/attempt_02/regression/summary.json) 4/4 e integridad PASS. El cambio resuelve la causa observada. Manuales M-01…M-08 NOT_RUN: las realiza el creador.
