# Validación pública H03

2026-11-22, D-019: el creador confirma mediante captura su elección visual actual y revisable: nearest+mips, atmósfera, 1280×720, retro off, sombras on, niebla off. APROBADO ese perfil, no aprobación global inferida de pruebas no mencionadas. Inicio y reset ajustados a la selección; el resto del comportamiento y assets de prueba se conservan.

Tras aplicar D-019, suite local run_06_selected_profile con gráficos PASS global/exit 0: 8 unitarias, 8 integración, 34 comprobaciones H1 y un caso físico NOT_RUN; negativo esperado detectado, importación/integridad/gráficos/legibilidad PASS. Se conserva el mismo shader y recursos; cambió la iluminación predeterminada.

Copia pública con ese cambio: integración repetida, 8 tests PASS sin fallos/errores/skips, exit 0; integridad pública PASS/exit 0. No se repite toda la suite pública para esta selección de un valor inicial; la suite completa local sí se ejecutó.

Corrección 2026-11-22 validada localmente: 8 unitarias + 8 integración PASS, H1 34 PASS/0 FAIL/1 NOT_RUN; importación, arranque, integridad, gráficos y nuevo probe de legibilidad PASS. Retro a intensidad cero no cambia píxeles; a 0.70 produce diferencia media de 4.839/255 en región de prueba local. Controles/panel tipográfico sin invadir el rectángulo 3D a 1280×720 y 960×540. No equivale a aprobación artística. La nueva serie breve de rendimiento tiene una meseta de 8.333 ms en varias variantes, sin control del foco de ventana; no se usa para comparar costes ni afirmar mejoras. Los datos inferiores corresponden a la entrega inicial del 2026-11-21.

La copia pública corregida también se ejecutó sin Malorian ni originales locales: suite public_readability con -Graphics PASS global/exit 0; ocho tests unitarios y ocho de integración, fallback propio, 34 comprobaciones H1, control negativo esperado, importación/integridad y ambos probes gráficos PASS. La prueba de píxeles exige cambio visible técnicamente y retorno exacto a intensidad cero. Evidencias locales del creador; el runner permite reproducirlas.

**Copia pública comprobada desde cero antes de publicar:** importación, 8 unitarias, 5 integración, control negativo, arranque, regresión H1, integridad pública y ventana gráfica PASS; runner salida 0. Ejecución public_fresh del 2026-11-21, mismos motor/equipo descritos abajo. Evidencia completa conservada localmente por el creador; puede regenerarse con el runner. No sustituye validación manual.

2026-11-21. Implementación técnica PASS en workspace de desarrollo; aprobación artística/manual pendiente. Registro original conservado localmente, con fallos iniciales y correcciones, sin publicar rutas personales ni conversaciones.

Godot 4.7.2.stable.official.ed1daf0bf, GdUnit4 6.2.3, Windows 11 build 26200, Python 3.13.15. Suite final: importación/arranque exit 0; ocho tests unitarios y cinco de integración PASS; control negativo exactamente un fallo esperado, exit 100, detección PASS; regresión H1 34 PASS/0 FAIL/1 NOT_RUN (clic físico en headless). Integridad local 908 archivos originales/históricos preservados; no se atribuye esa cobertura al baseline público.

Medición gráfica real, RTX 4050 Laptop, Ryzen 7 7735HS, OpenGL 3.3.0 NVIDIA 621.24; ventana 1280×720, VSync desactivado, 60 frames de calentamiento y 180 muestras por variante. 33 meshes/34 materiales. Media de intervalo entre frames dibujados en ms: nearest 3.060, linear 3.072, atmósfera 3.000, 640×360 3.250, retro 3.165, sin sombras 2.449, niebla 3.303. Base 198 draw calls, sin sombras 91. No son tiempos GPU exclusivos ni un objetivo de FPS; muestras breves, sin combate y un único equipo.

Pruebas manuales del creador H03: PENDIENTES. Export Windows, otros equipos, sesiones largas y adaptación Blender: NOT_RUN. Ningún recurso VISUALLY_APPROVED. [Reproducción](../README.md) genera nuevas evidencias sin sobrescribir las previas.
