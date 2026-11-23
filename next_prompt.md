# Prompt para Codex — validación automática de B1

Copia todo el bloque siguiente y pégalo en Codex.

```
Eres el validador técnico (PC Codex, con Godot 4.7.2) del proyecto ALABARDA CYBERPUNK.
Claude ha programado el lote B1 (hitos H05 y H06) en una rama nueva llamada B1, que todavía no tienes en local.
Tu tarea es SOLO ejecutar las pruebas automáticas. Las pruebas manuales (movimiento, dash, interacción, regeneración, combate, muerte, H1) las hará el creador en persona: no las ejecutes.

Repositorio: https://github.com/alejandrodapenasanz/ALABARDA_CYBERPUNK_H1.git

Datos de la entrega:
- Rama: B1
- Candidato C (código exacto a probar): bfe7071b63e756200f4e1ea94160175bc6294644
- Último commit aprobado (main): 796255711fd04c4e6a6d061fba718e86db8cf099
- El paquete de pruebas está en la carpeta validation/B01 de la rama B1 (último commit de origin/B1).

PASO 1 · Bajar la rama B1
- Si ya tienes el repositorio clonado: entra en él y ejecuta
    git fetch origin
    git switch B1        (si no existe en local: git switch -c B1 --track origin/B1)
    git pull --ff-only
- Si no lo tienes: git clone https://github.com/alejandrodapenasanz/ALABARDA_CYBERPUNK_H1.git y luego git switch B1
- Si tienes cambios locales sin guardar, no los borres: guárdalos en una rama aparte y avisa.

PASO 2 · Leer antes de ejecutar
Lee AGENTS.md entero, prompts/_templates/CODEX_VALIDATE_BATCH.md, docs/TEST_STRATEGY.md y validation/B01/TEST_HANDOFF.md (secciones A, E, G, H y K).

PASO 3 · Copia limpia del candidato C
    git -c core.longpaths=true worktree add --detach <carpeta-nueva> bfe7071b63e756200f4e1ea94160175bc6294644
(Sin core.longpaths falla en Windows por rutas largas de assets.)
Después, desde la rama B1:
    python -X utf8 tools/pipeline/validate_manifest.py validation/B01/TEST_MANIFEST.json --ready --candidate <carpeta-nueva>
Si no da PASS (SHA distinto o árbol sucio): estado BLOCKED, para e informa.

PASO 4 · Pruebas automáticas (dentro de <carpeta-nueva>)
    python -X utf8 tools/b1/run_tests.py --godot <ruta a Godot_v4.7.2-stable_win64_console.exe> --output <carpeta de evidencia nueva, fuera del candidato>
Esperado:
- import: PASS
- b1_unit: 37 tests, 0 fallos
- b1_integration: 28 tests, 0 fallos
- b1_sandbox_smoke: PASS
- regression_h1_h03_h04: PASS (H1: RESULT passed=34 failed=0 not_run=1)
También: python -X utf8 tools/pipeline/check_godot_static.py (debe dar PASS).

PASO 5 · Si algo falla
- Fallo pequeño y local (una línea, un nombre, un tipo): corrígelo con un commit nuevo en la rama B1, repite el test afectado y la regresión, y anota el SHA nuevo.
- Fallo estructural o grande: NO lo reescribas. Crea un informe por fallo en validation/B01/bugs/BUG-B1-XX.md usando validation/_templates/BUG_REPORT.md, con pasos, log exacto, SHA y una hipótesis marcada como tal. Lo corregirá Claude.

PASO 6 · Registrar y subir
- Completa el "Intento 01" de validation/B01/TEST_RESULTS.md: SHA realmente probado, versiones reales (Godot, GdUnit, Python, Windows), comando y exit de cada prueba, recuentos JUnit y resultado. No modifiques el Intento 00.
- Deja las pruebas manuales M-01 a M-08 como NOT_RUN con el motivo "las realiza el creador".
- Copia logs, JUnit y summary.json en validation/B01/evidence/attempt_01/.
- Commit en la rama B1 y git push origin B1. No hagas merge a main.

PROHIBIDO: inventar resultados, marcar PASS algo que no has ejecutado, declarar VALIDATED o APPROVED (las pruebas manuales críticas siguen pendientes del creador), empezar B2, usar reset --hard, clean o force-push.

INFORME FINAL (respóndeme con esto):
1. Resultado de las pruebas automáticas: PASS, FAIL o BLOCKED.
2. SHA probado y versiones reales.
3. Tabla por ID: B1-STATIC, B1-IMPORT, B1-UNIT, B1-INTEGRATION, B1-SMOKE, B1-REGRESSION, con exit y recuentos.
4. Fallos encontrados y sus BUG_REPORT.
5. Correcciones que hayas hecho, con sus SHAs.
6. SHA final de la rama B1 tras tu push.
```

Después de Codex: si las automáticas pasan, el creador hace las pruebas manuales M-01 a M-08 descritas en `validation/B01/TEST_HANDOFF.md` (sección F), abriendo `scenes/b1/b1_sandbox.tscn` con F6 (M-08 con F5).
