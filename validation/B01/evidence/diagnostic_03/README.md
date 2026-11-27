# Diagnóstico 03 — criterio experimental retirado

Ejecutado el 2026-11-27 en un worktree limpio de `49ecd30a5b78ef18a85390e8929baf132d6b78ff`, verificado mediante [manifest --ready](preflight/manifest_ready.stdout.log) antes de importar. Solo añadía una prueba geométrica, sin modificar gameplay ni posición del arma.

[Resultado real](summary.json): import PASS, unitarias 37/37, integración 28 PASS + 1 FAIL (exit 100), smoke PASS; runner exit 1. Estático y regresión completa NOT_RUN (`--skip-regression`). Godot 4.7.2.stable.official.ed1daf0bf; GdUnit4 6.2.3; Python 3.13.15; Windows 11 Home 10.0.26300. Comandos/cwd/exit en los JSON, versiones y estado posterior en [metadata](metadata.json); logs y JUnit originales cotejados mediante [hashes](raw_artifacts_sha256.json).

El fallo mide que el modelo sobresale de la cápsula del cuerpo. No es una prueba física con pared ni aprobación de la solución de reducir/acercar el arma. La restricción posterior del creador D-030 exige conservar posición y aspecto. Por ello el test fue retirado con `71ce9a24f574b888fe2f9b8ca1c641470703b96a`, preservando este diagnóstico; **el bug manual sigue abierto**. No se repiten automáticamente pruebas ya ejecutadas sobre runtime idéntico ni se atribuye el PASS del intento 02 a este SHA.
