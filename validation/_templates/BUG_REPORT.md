# BUG_REPORT — plantilla

- ID único / lote / hito.
- SHA candidato, SHA paquete, rama y entorno real.
- Severidad (bloqueante/crítica/mayor/menor), sistema y alcance afectado.
- Estado: abierto / investigando / fix preparado / retest pendiente / cerrado con evidencia.
- Precondiciones, datos, escena y frecuencia.

## Reproducción

1. Estado inicial preciso.
2. Acción/comando/cwd concretos.
3. Resultado observable.

Esperado según decisión/caso de prueba. Observado real, exit/log/stacktrace y captura si obtenida. Sin evidencia visual, declararlo; no inventarla.

## Diagnóstico

Hechos comprobados separados de **HIPÓTESIS**. Bloqueos y dependencias; por qué vuelve a Claude si requiere cambio estructural.

## Corrección y regresión

Fix commit (pendiente hasta existir), archivos/contrato afectados, ID de prueba de regresión y pasos de retest. Nuevo resultado/commit/evidencia; cierre solo tras retest, aprobación humana aparte si afecta sensaciones/diseño.
