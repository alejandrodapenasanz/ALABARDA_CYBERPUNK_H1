# Desarrollo por lotes — Claude → Codex → Claude → creador

**v2.1 · 2026-11-22 · migración aprobada por el creador 2026-11-23 (D-028).** Fuente operativa principal, subordinada a [AGENTS](../AGENTS.md) y [DECISIONS](DECISIONS.md). No autoriza iniciar B1. [Roadmap](ROADMAP.md), [plantillas e índice](PROMPTS_INDEX.md). **Actualización2026-11-23:** el creador encarga publicar toda la versión actual para otro PC; [guía de transferencia](GITHUB_TRANSFER.md). Publicación autorizada, aprobación semántica no inferida.

## Responsabilidades y capacidad real

| Entorno | Hace | Límites |
|---|---|---|
| PC Claude, programación principal | GDScript, tscn/tres de texto, arquitectura del lote, tests/fixtures, scripts auxiliares, documentación, commits/checkpoints y paquete completo | Sin Godot ni Blender. Sin ejecución del juego, importación, comprobación visual, animación o profiling. Tests Godot NOT_RUN |
| PC Codex, integración/validación | Verifica SHA y dependencias, importa/ejecuta Godot, automatiza evidencia, valida Blender/GLB cuando proceda, diagnostica bugs | Créditos limitados: reutiliza tests preparados; solo fixes pequeños/locales. Cambios estructurales o extensos vuelven a Claude |
| Creador | Decide pendientes y valida movimiento, gunplay, arte, animación, UI/UX, dificultad y aprobación final | PASS técnico no sustituye esta revisión |

## Estados y puertas

| Estado | Significado / transición |
|---|---|
| NOT_STARTED | Sin trabajo del lote autorizado/iniciado |
| IN_PROGRESS | Trabajo dentro del alcance autorizado |
| CODE_READY | Código y tests escritos, revisión estática y checkpoints; ejecución Godot todavía no demostrada |
| INTEGRATION_READY | CODE_READY + paquete completo, manifest válido, SHA exacto disponible, dependencias y pasos reproducibles |
| VALIDATION_FAILED | Codex ejecutó y encontró fallo; conserva evidencia y bugs, devuelve a IN_PROGRESS para corrección |
| VALIDATED | Todas las comprobaciones técnicas críticas exigidas pasaron en ese commit, sin regresión crítica; aceptación humana pendiente |
| APPROVED | VALIDATED + validación expresa del creador registrada con fecha, commit y alcance |
| BLOCKED | Falta dependencia/decisión/herramienta que impide completar; registrar causa y condición de salida, sin fingir PASS |

Estados de pruebas separados: PASS, FAIL, NOT_RUN, BLOCKED. Una prueba manual de sensaciones puede seguir pendiente tras VALIDATED técnico; una prueba técnica crítica sin ejecutar impide VALIDATED. Al corregir código, la validación previa sigue siendo histórica para su SHA y el nuevo candidato vuelve a IN_PROGRESS/CODE_READY; no hereda PASS automáticamente.

Cada hito tiene checkpoint propio y el lote agrega su estado. Dentro de un lote autorizado Claude puede avanzar entre hitos con interfaces/checkpoints revisados; no necesita fingir aprobación humana de cada hito para programar el siguiente del mismo lote. El cierre exige validación y aprobación del conjunto con alcance por hito. H02 y B0 conservan aprobaciones anteriores; no se recrean handoffs ficticios.

## Secuencia de trabajo

1. Creador autoriza lote/alcance y entrega repo con documentación vigente. Leer AGENTS y prompts individuales; comprobar dependencias/pendientes. Registrar diagnóstico antes de editar.
2. Claude programa por hitos, conserva rutas/funcionalidades, datos configurables y pruebas de borde. Checkpoint: funcionalidad, archivos, interfaces, tests preparados/ejecutados, decisiones, bugs, dependencias y SHA si existe. Commits separados por hito cuando sea posible.
3. Preparar paquete `validation/BXX/` (B01 para lote B1; B00 para B0, etc.): TEST_HANDOFF.md, TEST_MANIFEST.json, TEST_RESULTS.md, evidence/. Añadir bugs/ si hay incidencias. La plantilla contiene campos a completar; **no es INTEGRATION_READY**.
4. Codex verifica manifest, commit, herramientas y recursos antes de ejecutar. Si SHA difiere, **parar la validación** y registrar BLOCKED; no probar otro árbol bajo el SHA solicitado. Importar, ejecutar tests, inspeccionar logs/JUnit, regresiones y probes pertinentes. Capturas solo reales; headless no demuestra imagen ni rendimiento GPU.
5. Un fix local pequeño puede hacerlo Codex con commit nuevo y repetición de pruebas afectadas. Si requiere rediseñar interfaces, ampliar alcance o reescribir sistemas, devolver BUG_REPORT y plantilla CLAUDE_FIX_BATCH. No imponer umbral de líneas como sustituto del criterio técnico.
6. Claude corrige y añade caso de regresión cuando corresponda; nuevo candidato/paquete. Codex repite caso fallido, integración y regresiones afectadas. Conservar cada intento y resultados del anterior.
7. Entregar checklist humano y pasos concretos. Solo el creador concede APPROVED. Actualizar VALIDATION/HANDOFF/ROADMAP, y fusionar a estable únicamente el candidato aprobado. No empezar otro lote por iniciativa del agente.

## Git: sincronización reproducible entre los dos PC

Usar repositorio compartido completo para desarrollo; **una rama por lote desde `main` (D-028)**: `B1`, `B2`… hasta `B8`. Claude programa en `B1` y entrega allí el candidato C y el commit de paquete P. Codex hace fetch de `B1` y valida C en el PC con Godot; las correcciones van en la misma rama (o en `B1-fix-<bug>` si conviene aislarlas) con nuevos SHA. Tras VALIDATED y APPROVED, el creador fusiona `B1` en `main`, repite la verificación sobre `main` y crea `B2` desde ese `main`. `main` (estable) contiene únicamente trabajo validado/aprobado. SHA obligatorio. No reset, limpieza destructiva ni force-push para resolver divergencias. Conservar cambios ajenos y commits de correcciones.

**Situación de entrada:** carpeta de trabajo original en `h02-audit`, índice histórico y sin HEAD. NO ejecutar aquí `git add .` ni inventar un SHA. La copia pública H04 en `C:/dev/ALABARDA_CYBERPUNK_H03_PUBLIC` tiene commit `48f972c6ebeac2a4c7e6ab526e7dead43ad2baba`; contiene documentación pública resumida, no toda la documentación de desarrollo. No basta clonar esa publicación para dar a Claude todos los requisitos.

Por la orden posterior de publicación completa se prepara una **copia de desarrollo aislada** desde H04 con documentación, prompts, herramientas, plantillas, históricos, evidencia y todos los recursos redistribuibles. Los originales con licencia verificada también se incluyen, con atribuciones; Malorian, PSXAmmoBoxes e imágenes sin trazabilidad de Electronics siguen excluidos. La exportación resumida H03/H04 queda histórica y no se usa para sincronizar esta copia. Verificar hashes mediante checkout_manifest.json en ambos PC y usar el commit real de main como base. La publicación no aprueba automáticamente la migración ni programa B1; sus pruebas futuras usan el protocolo siguiente.

### Evitar el SHA autorreferencial del paquete

El candidato **C** contiene código, datos y tests. Commit posterior **P** contiene el paquete con `code_commit=C`; no puede contener su propio SHA dentro de sí mismo. Transferir C y P (ramas Git o bundle sin secretos), comunicar el SHA de P fuera del manifest o en el mensaje de entrega. Leer paquete desde P y ejecutar tests en un worktree limpio de C. `code_commit` siempre significa árbol realmente probado, nunca P por conveniencia.

Ejemplo de PowerShell futuro, con variables rellenadas por el operador, desde una copia Git de desarrollo con commits:

```powershell
git fetch origin
$CodeCommit = '<SHA completo C de TEST_MANIFEST.json>'
$PackageCommit = '<SHA completo P entregado por Claude>'
$CandidatePath = '<directorio nuevo para candidato>'
$PackagePath = '<directorio nuevo para paquete>'
git cat-file -e "$CodeCommit^{commit}"
git cat-file -e "$PackageCommit^{commit}"
git worktree add --detach $CandidatePath $CodeCommit
git worktree add --detach $PackagePath $PackageCommit
git -C $CandidatePath rev-parse HEAD
git -C $CandidatePath status --porcelain
```

Comprobar salidas una por una antes de continuar; un comando fallido bloquea. Comparar HEAD=C y árbol limpio antes de tests. Evidencia nueva se escribe fuera del candidato (paquete de resultados o directorio externo nuevo); no ensuciar el código probado. C debe contener los tests indicados: no leer scripts ejecutables de P como si fueran parte de C. Registrar SHA del paquete y del candidato en resultados. No ejecutar literalmente marcadores `<...>`.

Para devolver: subir rama de corrección/paquete al transporte acordado, comunicar SHAs y bugs, fetch sin mezclar ramas. La aprobación se refiere al último C probado. Conservar anterior commit aprobado como recuperación: nuevo worktree de ese SHA; no resetear trabajo ni borrar saves. Merge final solo si árbol candidato coincide con el validado; si la integración cambia código, validar el nuevo commit resultante antes de declararlo estable aprobado.

## Contrato del paquete

TEST_HANDOFF debe cubrir A–K de la plantilla: identificación exacta, funcionalidad, archivos, dependencias, pruebas automáticas, pasos manuales numerados, regresiones, bugs, checklist humana, aceptación y recuperación. No pedir a Codex reconstruir condiciones desde el código.

TEST_MANIFEST usa [schema 1.0.0](../validation/_schemas/test_manifest.schema.json), comandos como ejecutable + lista de argumentos, cwd relativo al candidato, timeout y códigos de salida esperados. `requires` identifica Godot/Blender/desktop; resultados iniciales NOT_RUN. Cada test tiene ID único, precondiciones/datos, propósito, resultado esperado, PASS/FAIL, dependencias y evidencia. Manuales llevan pasos y no comando. La comprobación del manifest **no ejecuta comandos**. Revisar comandos antes de cualquier futuro ejecutor; no aceptar operaciones destructivas ni rutas que escapen del candidato/evidencia. Una plantilla válida estructuralmente con SHA null sigue sin estar lista.

TEST_RESULTS registra intentos inmutables por SHA, entorno/versiones, comando/cwd, exit/status/log, capturas y límites. El control negativo de GdUnit debe fallar con su exit esperado: no convertir un fallo de arranque en PASS. Una plantilla nunca contiene resultados de Godot inventados. BUG_REPORT distingue observado de hipótesis, incluye reproducibilidad y prueba de regresión.

## Trabajo solapado y ahorro de validación

Solo si el creador autoriza los dos lotes, interfaces del previo están definidas/estables, no existen fallos críticos ni decisiones creativas bloqueantes y la rama siguiente está aislada, Claude puede adelantar el siguiente mientras Codex valida. No fusionar código sin validar; registrar SHAs base y dependencias. Si cambia la interfaz previa, reconciliar y repetir las regresiones antes de integrar. Agrupar import/test/probes y reutilizar suites; no repetir pruebas completas por edición exclusivamente documental salvo nueva duda concreta.
