Lee primero `AGENTS.md` íntegro y cumple su orden de lectura. Después lee `docs/DEVELOPMENT_WORKFLOW.md`, el TEST_HANDOFF.md y TEST_MANIFEST.json del lote, `docs/TEST_STRATEGY.md`, `docs/VALIDATION.md`, `docs/HANDOFF.md`, los prompts de sus hitos y la documentación técnica/creativa relevante.

# Codex — validar un lote por commit

Completar: lote B__, SHA candidato C, SHA paquete P, ruta limpia de C, ruta paquete/evidencia, autorización y entorno. No ejecutar esta plantilla sobre la carpeta original sin HEAD ni con campos sin completar.

1. Comprueba schema/completitud, `git rev-parse HEAD` y `git status --porcelain` en C. **Si el SHA no coincide con code_commit, detenerse antes de ejecutar pruebas e informar BLOCKED.** No probar silenciosamente P/HEAD reciente. Tests/scripts deben pertenecer a C. Resolver ejecutables de entorno sin guardar secretos. Verificar Godot y otras herramientas requeridas; Blender solo cuando la prueba lo exija.
2. Usa el handoff y manifest para ejecutar las pruebas ya preparadas y scripts existentes. No reconstruyas requisitos no documentados: devuelve faltas de paquete a Claude. Revisa cada comando antes de un futuro ejecutor; el checker JSON no ejecuta comandos ni autoriza operaciones destructivas.
3. Registra SHA C/P, fecha, entorno/versiones, cwd, argv/comando exacto, timeout, exit/status, asserts/contadores y logs. Evidencia fuera de C, directorio nuevo por intento, sin sobrescribir fallos. Capturas solo si realmente obtenidas; headless no valida aspecto, interacción física ni rendimiento GPU.
4. Ejecuta regresiones pertinentes y pasos manuales técnicos reproducibles. PASS exige condiciones/contadores/logs correctos, no solo exit0. Tests no ejecutados NOT_RUN; dependencia que impide crítico BLOCKED; incumplimiento ejecutado FAIL. No atribuyas cobertura de nuevas mecánicas a tests H03 legados.
5. Corrige solo errores pequeños/locales dentro del alcance, con commit nuevo y repetición de pruebas afectadas. Si es estructural/extenso, crea BUG_REPORT con reproducción/logs/esperado/observado/hipótesis y devuelve a Claude con CLAUDE_FIX_BATCH. No amplíes funcionalidades ni ajustes tests para ocultar defectos.
6. Completa TEST_RESULTS, VALIDATION y HANDOFF con veredicto técnico y checklist del creador. VALIDATED solo si pruebas técnicas críticas satisfechas sin regresión crítica. Nunca APPROVED sin validación expresa humana. No iniciar otro lote ni fusionar trabajo sin validar a estable.

Entrega informe para Claude y creador: alcance probado, SHAs, archivos tocados, resultados y evidencias, bugs con prioridad, pruebas pendientes y pasos de repetición. [Workflow](../../docs/DEVELOPMENT_WORKFLOW.md).
