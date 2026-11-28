# Evidencia histórica B1

Logs, JSON y JUnit originales permanecen en sus intentos. Tras la aprobación y la limpieza solicitada se retiraron 148 archivos HTML/CSS/logos duplicados del árbol visible. Se conservan byte a byte en `generated_reports.zip`, con inventario y SHA-256 en `REPORT_ARCHIVE.json`.

Para verificar una entrada de un `raw_artifacts_sha256.json` antiguo: leer su ruta local si existe; si es un reporte archivado, leer la entrada con esa misma ruta relativa a esta carpeta dentro del ZIP. Las rutas absolutas impresas por los procesos son el contexto original de ejecución.

`integration_01` y `post_merge` registran la incorporación al proyecto normal y la verificación posterior a la fusión, cuando estén presentes. Conservan logs, metadatos y JUnit; no duplican esos resultados con copias HTML generadas.
