# ARCHITECTURE — contrato de diseño técnico
**Estado:** propuesta de organización, NO inventario verificado del H1; H02 debe documentar la arquitectura REAL y la migración antes de cambiar paths.

## Principios
- Godot 4, GDScript, PC Windows. Preferir composición de escenas y componentes a mega scripts.
- `Resource` tipados para WeaponData, EnemyData, BalanceProfile, FirmwareData, ContractData, Loot/UpgradeData.
- Señales/eventos para daño, gastos, puertas, alertas y transiciones. Mantener API verificable por tests.
- Separar modelos puros testeables de presentación y animación 3D.
- SaveData persistente **distinto de** RuntimeRunState efímero. Versionado y migración idempotente.
- No redefinir inputs del H1 sin documentar migración y tests.

## Posible estructura (H02 validará/modificará)
```text
project.godot
AGENTS.md
README.md
docs/{ROADMAP,DECISIONS,GAME_DESIGN,ART_BIBLE,ASSET_REGISTRY,ARCHITECTURE,TEST_STRATEGY,BALANCE_PROVISIONAL,VALIDATION,HANDOFF}.md
prompts/
scenes/{player,weapons,enemies,hub,contract,ui,tests}/
scripts/{components,controllers,ai,systems,data}/
assets/{external,custom}/
tests/{unit,integration,fixtures}/
```
## API y nomenclatura
Nombres de IDs estables en snake_case. No usar rutas de escenas o nombres de nodos como identificadores de guardado; utilizar IDs persistentes. Las transacciones de créditos y entrega deben tener identificadores únicos para idempotencia. Cada escena nueva debe tener modo mínimo de prueba.

## Reglas específicas
- Arma: READY → ATTACK → RECOVERY → READY, además RELOAD/INTERRUPTED; un evento de animación genera daño máximo una vez por ataque.
- Ultimates: desacoplar escala de tiempo del mundo de velocidad del jugador en Dead Eye; restaurar sin excepción al terminar, morir o abandonar.
- IA: percepción separada de acciones y navegación; permite simulaciones deterministas.
- Sound/asset: trazabilidad `ASSET_REGISTRY.md` obligatoria y compatibilidad de licencia.
- Cambios de arquitectura: ADR breve en DECISIONS.md (técnico/provisional vs decisión creativa).
