# DOCUMENTATION_AUDIT — migración v2.1

**2026-11-23 · revisión para validación del creador.** [Informe y archivos](PIPELINE_MIGRATION_REPORT.md), [pruebas](VALIDATION.md). Auditoría H02/PRE-H03 íntegra en [histórico](history/pre_pipeline_v2_1/docs/DOCUMENTATION_AUDIT.md); sus matrices REQ-001…REQ-033 no se presentan como estado actual.

## Diagnóstico y tratamiento

| Hallazgo | Tratamiento / límite |
|---|---|
| Archivo fuente v2_1 con título v2.0 | Se aplica petición v2.1; fuente conservada por hash, discrepancia editorial explícita |
| AGENTS/prompts presuponían Codex programa+ejecuta por hito | Roles asimétricos, checkpoints por hito dentro de lote, puertas por commit y aprobación humana |
| No existían workflow compartido ni validation/templates | Creados y enlazados;23 prompts/IDs/rutas conservados; no PROMPTS_TODOS recibido |
| Visión/diseño/alcance/H08 exigían F y energía por duración | SUPERSEDED; pasiva hasta100+bajas hasta150, sin curación directa de HP |
| F estaba ligada a ejecuciones y protección | No borrar remates: antecedente preservado y adaptación P-017; no transferir protección a E/regeneración |
| AutoHP ausente, E confundida con interacción | Contrato completo: delay/reset/tasa/cap/muerte, E coste real y pausa auto; E exclusiva, binding interacción P-015 |
| «Solo bajas100–150» frente a ascensor150 | Excepción explícita; ascensor deja HP intacto, resuelve parte de P-013 |
| Etiquetas slots vs tres armas cualesquiera | Separar etiqueta/slot/arma/restricción; no imponer categorías, P-016; P-011 conserva duplicados/vacíos |
| Resource/tests H03 aún conservan extracción | Bytes intactos, legado SUPERSEDED para nuevo diseño; adaptar en B1/B2, no contar PASS viejos como nuevas mecánicas |
| Documentos acumulaban «pendiente» anterior a cierre H04 | Guías activas actualizadas; históricos fechados e informes originales conservados; H1–H04 no reabiertos |
| Carpeta local sin HEAD/índice histórico; copia pública resumida aparte | No inventar SHA ni git add global; baseline documental en copia aislada tras validación, transferencia completa según workflow |
| Paquete que intentase contener su propio SHA | Candidato C y paquete posterior P; probar C limpio, registrar P externamente |
| Runner histórico conserva hash de AGENTS previo | No falsear excepción histórica. Nueva comprobación v2.1 preserva runtime; política de baseline aprobado pendiente de incorporar al preparar B1 |
| Plantillas públicas H03/H04 tienen estados antiguos | Snapshots de esas publicaciones, protegidos por hash; no guías de desarrollo ni medio de sincronizar esta migración |

## Fuentes y cobertura

DECISIONS mantiene D-001…D-026 y P-001…P-017, sustituciones fechadas e histórico. GAME_DESIGN/MVP_SCOPE/GAME_VISION/AGENTS y prompts relevantes comparten dos barras, E y energía; BALANCE clasifica límites vs hipótesis. HEALTH_ENERGY_CONTRACT es detalle común;29 SB y10 CT alimentan paquetes futuros sin programar B1.

ART_BIBLE y ASSET_REGISTRY conservan dirección/permisos y aprobaciones limitadas al contexto experimental. GDD H1 permanece histórico byte a byte. Sin assets nuevos, sin bibliotecas del juego ni cambios de motor. La dependencia Python JSON Schema está aislada fuera del proyecto y fijada para validar metadata, no se incorpora al juego.

41 documentos de entrada archivados por SHA en [manifiesto](history/pre_pipeline_v2_1/manifest.json);2746 archivos inventariados antes de editar. VALIDATION conserva íntegros sus bytes previos con sección nueva antepuesta. No recrear alias ni duplicados activos: el archivo histórico tiene propósito y manifiesto explícitos.

## Límites

Comprobación automática de archivos/links/schema/IDs/valores y revisión semántica complementaria, no prueba de jugabilidad. No consultar/validar URLs externas ni licencias nuevas en esta tarea; no se incorporaron assets. La aprobación de migración es PENDING_APPROVAL y los tests futuros NOT_RUN. Resultados reales y fallos de herramienta, si los hay, se registran en VALIDATION sin sobrescribirlos.
