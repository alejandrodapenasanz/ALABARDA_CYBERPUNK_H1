# ROADMAP — ALABARDA CYBERPUNK FPS
**Versión 1.1 · PRE-H03 · 2026-11-20 · Estado: plan de implementación; requiere aprobación hito a hito.** La actualización artística D-017 está aprobada; los hitos no se dan por ejecutados.

**Estado vigente 2026-11-22:** H1–H04 **CERRADOS Y APROBADOS POR CREADOR**. H04 combina suite técnica PASS y confirmación manual conjunta D-021. D-019/D-020 se conservan. H05 tiene satisfecha su precondición, pero requiere encargo propio y no está iniciado ni autorizado. Los estados inferiores anteriores conservan su contexto histórico.

## Alcance, premisas y puertas
- H1: prototipo FPS reportado funcional por el creador. H02 registra pruebas independientes y sus límites en [VALIDATION](VALIDATION.md); su cierre se apoya además en la confirmación manual posterior del creador, registrada el 2026-11-20.
- Las decisiones aprobadas están en `DECISIONS.md` y `MVP_SCOPE.md`. Un parámetro provisional solo podrá implementarse con autorización del prompt de su hito y sin modificar una regla aprobada; una ambigüedad mecánica requiere decisión del creador. La presencia de números propuestos no autoriza implementarlos.
- Orden: infraestructura → arte vertical temprano → sistemas jugables → IA y sigilo → persistencia y hub → contrato → pulido → exportación.
- Cada hito: un chat de Codex, prompt independiente, tests automáticos relevantes, regresión, revisión manual y handoff. **Codex no aprueba hitos por sí mismo**.
- Si un requisito exige una decisión creativa no aprobada, documentar BLOCKED y entregar lo no bloqueado.

## Tabla de hitos

| ID | Hito | Puerta mínima |
|---|---|---|
| H02 | Auditoría H1 y saneamiento documental — APROBADO POR CREADOR 2026-11-20 | Repo H1 abre, escena inicial permanece jugable, histórico conservado, documentación centralizada, HANDOFF completo, comprobaciones automáticas y confirmación manual posterior registradas. |
| H03 | Infraestructura de pruebas y balance; laboratorio Modern PSX — CERRADO / APROBADO POR CREADOR 2026-11-22 | GdUnit4 6.2.3, ejecutor Windows, 8 unitarias/8 integración y H1 34 PASS; fallo controlado detectado; balance desacoplado, A/B e inventario/licencias. Perfil D-019, legibilidad HomeVideo, animación de brazos y regresión manual H1 confirmados; puerta satisfecha. |
| H04 | Vertical de arte temprano — CERRADO / APROBADO POR CREADOR 2026-11-22 | Misma sala H03 desarrollada, kit Blender→GLB, tres luces, reglas medibles y assets trazados. 4 tests H04 y suites H03/H1 PASS; revisión manual conjunta aprobada D-021. |
| H05 | Núcleo de jugador, interacción y movimiento | Movimiento jugable con estado estable e inputs documentados, sin teletransporte a través de geometría. |
| H06 | Daño, salud, hitzones y estados de ataque | Sistema de daño desacoplado reutilizable; cadencia declarada por animación. |
| H07 | Seis armas y loadout libre | Seis armas usables, acciones y recuperación animadas, libre selección y sin crashes. |
| H08 | Energía, curación y extracción cyborg | Bucle combate→ejecución→energía→curación jugable, sin exploits de energía infinita. |
| H09 | Tres ultimates independientes | Tres habilidades diferenciadas y reversibles sin alterar permanentemente gameplay. |
| H10 | Enemigos base: tres arquetipos y patrullas | Tres tipos de enemigo patrullando y combatiendo en greybox con señalización legible. |
| H11 | Sigilo: memoria, búsqueda y retorno | Infiltración y recuperación de sigilo demostrables, variables de IA configurables. |
| H12 | Cámaras, alarmas y cadáveres | Sistema de seguridad completo con respuesta observable y reinicio limpio. |
| H13 | Persistencia, inventario, créditos y dificultades | Cerrar/reabrir preserva progreso correcto y no persiste daño/alertas de intento. |
| H14 | Firmware árbol de perks y respec | Árbol navegable y testeado con la lista de nodos que apruebe el creador. Doce nodos en tres ramas siguen siendo propuesta, no puerta aprobada. |
| H15 | Mejoras físicas de armas y catálogo comercial | Compras y upgrades persistentes; UI de precios y disponibilidad consistente. |
| H16 | Guarida y ordenador/terminal | Hub jugable con ordenador interactivo y flujo de entrada/salida estable. |
| H17 | Entregas físicas, montaje y USB | Experiencia física compra→timbre→transporte→montaje/USB→uso se completa sin pérdida de progreso. |
| H18 | Arsenal, selección de 3 armas y vitrina | Preparación de loadout libre en la guarida antes del contrato. |
| H19 | Contrato Yakuza: tres plantas + ascensores | Contrato navegable en tres plantas con ascensores y sin softlocks. |
| H20 | Jefe Yakuza: dos fases y recompensa | Boss derrotables en las tres dificultades y flag/trofeo persistentes. |
| H21 | Economía de contratos y objetivos secundarios | Loop guarida→contrato→boss→cobro→guarida repetible y persistente. |
| H22 | Integración, dificultad, UX y accesibilidad básica | Versión funcional integrada lista para pulido; lista objetiva de bugs y pruebas manuales del autor. |
| H23 | Pulido artístico/audio/animación y rendimiento | Vertical slice visualmente coherente, sin bloqueadores jugables ni licencias pendientes. |
| H24 | Release candidate Windows + auditoría final | Windows build probada por creador, todas puertas de calidad PASS, publicación futura opcional no incluida. |

## Criterios de aceptación transversales
1. Importación Godot sin rutas, UID o recursos críticos rotos; `--headless --editor --import --quit` si CLI disponible.
2. Pruebas unitarias y de integración del hito con PASS real, con logs y versión fija de herramienta.
3. Smoke/regresión del sistema previo, tanto automática como manual donde corresponda.
4. Persistencia probada en hitos que manipulen datos, y no reutilización del estado de runs fallidas.
5. Ningún asset externo sin autor, procedencia, licencia y redistribución comercial confirmadas en `ASSET_REGISTRY.md`.
6. `VALIDATION.md` y `HANDOFF.md` actualizados; `ROADMAP.md` solo marcado aprobado tras validación explícita del creador.

## Dependencias y alcance
- H02→H03→H04→...→H24 secuenciales como ruta base. Se podrán dividir hitos solo si se documenta el cambio y el usuario lo aprueba.
- El producto tiene dos gates: MVP funcional (H22) y vertical slice pulido para Windows (H24).
- Duración objetivo 15–25 min **no es compromiso ni benchmark demostrado**.
- Fuera de alcance sugerido y no aprobado individualmente: multiplayer, mundo abierto, otros contratos, vehículos, narrativa ramificada, crafting complejo. Shurikens jugables ya están excluidos por D-010; solo se incluye su flag futuro.

## Utilización
Los 23 prompts recibidos se enlazan por sus nombres reales en [PROMPTS_INDEX](PROMPTS_INDEX.md). No se recibió la versión concatenada que se anunciaba aquí. El prompt H02 de esta conversación añade auditoría documental; prevalece sobre la copia local anterior.

## Preparación documental PRE-H03 · 2026-11-20

D-017 establece **Modern PSX / Retro Industrial Cyberpunk**; [ART_BIBLE](ART_BIBLE.md) es la fuente artística detallada. H03 mantiene su infraestructura y balance y añade, por solicitud expresa PRE-H03, investigación de renderer, glTF/GLB, materiales/filtros, luces/sombras/fog, resolución/escalado, shaders opcionales, rendimiento y Windows. Cada técnica debe justificar utilidad visual, compatibilidad y coste, con estrategia de degradación que preserve la lectura.

H03 construirá una escena comparativa aislada, contrastará materiales/técnicas con y sin efectos, comprobará coherencia y legibilidad, registrará decisiones técnicas provisionales y assets, y tomará capturas cuando sea posible. No requiere producir ya el arte definitivo ni los sistemas futuros de combate/sigilo. Paleta, cifras y presupuestos siguen sujetos a evaluación. H04 conserva su vertical de arte y reutilizará esa referencia; no se renumera ni altera H02→H03→H04.

PRE-H03 solo actualiza documentos y prompts; no ejecuta H03. Durante esta actualización el creador confirma que ha realizado las pruebas y todo funciona; HANDOFF/VALIDATION registran con ello el cierre H02. La documentación está preparada para solicitar H03. La aprobación H02 procede de esa confirmación manual posterior, no de la decisión artística.

## Resultado de revisión H02 · 2026-11-20 — histórico previo a la confirmación posterior

H02 sigue **PENDIENTE, SIN APROBAR**; H03–H24 no iniciados. La secuencia sigue siendo una propuesta y no se reordena en esta auditoría.

P-008/P-009/P-010 resueltas por decisiones expresas del creador: efectos de firmware al instalar USB; alarma general bloquea recuperar sigilo durante el intento; Dead Eye ralentiza mundo con cualquier arma y compatibilidad solo para efectos específicos. Los prompts correspondientes se sincronizan, sin implementar esos hitos.

P-012 corregida: H05/H10 prueban perfiles existentes; las pruebas de tres dificultades y regresiones de movimiento/IA con ellas se ejecutan desde H13 y en H22. P-011/P-013/P-014 son detalles pendientes de H07/H18, H19 y H08 respectivamente; no se imponen como reglas decididas. [Auditoría y resultados actuales](DOCUMENTATION_AUDIT.md). H02 queda listo para revisión final después de corregir defectos y completar verificaciones; no se autoaprueba.

## Estado vigente tras confirmación manual · 2026-11-20

**H02 APROBADO POR CREADOR.** El creador confirma haber hecho las pruebas y que controles, respawn y todo funcionan, después de las correcciones. Se acepta esa validación manual conjunta sobre la petición previa de cerrar H02; no se inventan logs ni se reescriben los FAIL anteriores. H03–H24 siguen sin iniciar. [Registro y límites](VALIDATION.md).
