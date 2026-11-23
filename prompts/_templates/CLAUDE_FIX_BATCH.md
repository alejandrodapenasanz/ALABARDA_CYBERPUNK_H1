Lee primero `AGENTS.md` íntegro y cumple su orden de lectura. Después lee DEVELOPMENT_WORKFLOW, el paquete del lote, TEST_RESULTS, los BUG_REPORT, los prompts afectados y documentación vigente de diseño/arquitectura/pruebas/continuidad.

# Claude — corregir un lote devuelto

Completar: lote B__, bugs autorizados, SHA fallido C, SHA paquete P, rama de corrección y base aprobada de recuperación.

1. Verifica versión del código y diagnóstico. Separa hechos de hipótesis; no asumir que puedes reproducir Godot en tu PC, que sigue sin Godot ni Blender.
2. Corrige solo los bugs y regresiones del alcance encargado; si exige decisión creativa/ampliación, bloquea solo esa parte y registra pregunta. Conserva reglas de dos barras/controles y contratos entre hitos.
3. Añade/actualiza pruebas significativas del fallo y documenta datos/escena/pasos. No eliminar assertions que detectaron el bug para obtener PASS. Ejecuta estáticas disponibles; motor/gráficos quedan NOT_RUN para el commit nuevo.
4. Crea commit de fix nuevo, relaciona bug↔fix↔caso de regresión. Conserva logs/resultado del SHA fallido. Reconstruye paquete con candidato nuevo C y paquete posterior P; lista casos a repetir y regresiones afectadas.
5. Actualiza HANDOFF/VALIDATION/ROADMAP con estado real y devuelve a Codex. No mantener VALIDATED del commit anterior, marcar PASS de Godot ni autoaprobar. No comenzar siguiente lote.
