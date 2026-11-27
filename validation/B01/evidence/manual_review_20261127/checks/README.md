# Comprobaciones de la actualización documental — 2026-11-27

Ejecutadas en la copia de trabajo B1, HEAD `71ce9a24f574b888fe2f9b8ca1c641470703b96a` más los cambios documentales. No son una nueva ejecución completa de aceptación sobre un candidato distinto. El runtime/tests sigue idéntico a C `94e4880`.

- `static`: PASS, exit 0; 42 scripts, 12 recursos, 20 hallazgos legados aceptados y un aviso H04 previo.
- `manifest_schema`: FAIL inicial del borrador documental por reutilizar la misma ruta de evidencia en ocho casos manuales. Se asignaron fichas individuales; no fue un fallo del juego.
- `manifest_schema_fixed`: PASS, exit 0. Estado del manifest **VALIDATION_FAILED** intencionado por M-02; no se ejecuta --ready ni se presenta una transferencia lista.
- `historical_integrity`: PASS, exit 0; 213 artefactos de intentos 01/02 verificados, Intento 00 y VALIDATION histórico intactos, runtime igual al candidato probado.
- `manual_delivery`: PASS, exit 0; 41 artefactos del diagnóstico, 354 enlaces locales y siete resultados manuales PASS/un FAIL cotejados. Posición, apariencia y animaciones del arma sin cambios.

Los JSON de cada comprobación conservan argv/cwd/fecha/exit. Logs copiados byte a byte y cotejados en `raw_artifacts_sha256.json`; script de verificación incluido. No se modificaron aserciones para esconder el bug: BUG-B1-02 continúa abierto y el diagnóstico experimental retirado conserva su fallo.
