# ROADMAP — ALABARDA CYBERPUNK FPS
**Versión 1.0 · 2026-11-20 · Estado: plan de implementación propuesto; requiere aprobación hito a hito.**

## Alcance, premisas y puertas
- H1: prototipo FPS reportado funcional por el creador, **sin auditoría automatizada independiente aquí**.
- Las decisiones aprobadas están en `DECISIONS.md` y `MVP_SCOPE.md`; lo aún pendiente se implementará como **parámetro provisional** solo si no modifica una regla de diseño aprobada.
- Orden: infraestructura → arte vertical temprano → sistemas jugables → IA y sigilo → persistencia y hub → contrato → pulido → exportación.
- Cada hito: un chat de Codex, prompt independiente, tests automáticos relevantes, regresión, revisión manual y handoff. **Codex no aprueba hitos por sí mismo**.
- Si un requisito exige una decisión creativa no aprobada, documentar BLOCKED y entregar lo no bloqueado.

## Tabla de hitos

| ID | Hito | Puerta mínima |
|---|---|---|
| H02 | Auditoría H1 y saneamiento documental | Repo H1 abre, escena inicial permanece jugable, no se elimina información histórica, documentación centralizada y HANDOFF completo. |
| H03 | Infraestructura de pruebas y balance | Comando local reproducible documentado, suite automatizada PASS, parámetros editables sin hardcodear, CI opcional sin credenciales. |
| H04 | Vertical de arte temprano | Sala de referencia aprobable y reglas visuales medibles; ningún asset sin trazabilidad. |
| H05 | Núcleo de jugador, interacción y movimiento | Movimiento jugable con estado estable e inputs documentados, sin teletransporte a través de geometría. |
| H06 | Daño, salud, hitzones y estados de ataque | Sistema de daño desacoplado reutilizable; cadencia declarada por animación. |
| H07 | Seis armas y loadout libre | Seis armas usables, acciones y recuperación animadas, libre selección y sin crashes. |
| H08 | Energía, curación y extracción cyborg | Bucle combate→ejecución→energía→curación jugable, sin exploits de energía infinita. |
| H09 | Tres ultimates independientes | Tres habilidades diferenciadas y reversibles sin alterar permanentemente gameplay. |
| H10 | Enemigos base: tres arquetipos y patrullas | Tres tipos de enemigo patrullando y combatiendo en greybox con señalización legible. |
| H11 | Sigilo: memoria, búsqueda y retorno | Infiltración y recuperación de sigilo demostrables, variables de IA configurables. |
| H12 | Cámaras, alarmas y cadáveres | Sistema de seguridad completo con respuesta observable y reinicio limpio. |
| H13 | Persistencia, inventario, créditos y dificultades | Cerrar/reabrir preserva progreso correcto y no persiste daño/alertas de intento. |
| H14 | Firmware árbol de perks y respec | Árbol navegable y testeado con los 12 nodos provisionales revisados en H14, sin exceder alcance. |
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
- Fuera de alcance sugerido y no aprobado individualmente: multiplayer, mundo abierto, otros contratos, vehículos, shurikens jugables, narrativa ramificada, crafting complejo.

## Utilización
Cada prompt completo está en `prompts/Hxx_*.md`. Existe una versión concatenada en `PROMPTS_TODOS.md`. Empezar por H02, no saltar directamente a combate.
