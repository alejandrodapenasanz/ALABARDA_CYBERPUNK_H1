"""Añade avisos editoriales H02 sin ejecutar ni aprobar futuros hitos."""
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
notes = {
    "H05": "P-005: prioridad E y tecla dedicada requieren decisión. P-012 resuelta: probar perfiles existentes; matriz de dificultades a partir de H13.",
    "H07": "P-006/P-011: compatibilidad de deflexión/ultimates y duplicados del mismo modelo en loadout siguen PENDING_APPROVAL.",
    "H08": "P-014: soltar F, momento de muerte y mínimo de extracción siguen PENDING_APPROVAL; fórmulas provisionales no deciden la mecánica.",
    "H09": "P-010 resuelta: Dead Eye ralentiza el mundo con cualquier arma; compatibilidad solo para efectos específicos. P-006 conserva la tabla de bonus pendiente.",
    "H10": "P-012 resuelta: probar perfiles existentes; repetir regresión de IA en tres dificultades desde H13 y en H22.",
    "H11": "D-003 revisada: retorno al sigilo posible salvo alarma general, que lo impide durante el resto del intento.",
    "H12": "P-009 resuelta por el creador: alarma general impide recuperar sigilo durante el intento; se reinicia al iniciar otro intento.",
    "H14": "P-002: doce nodos y tres ramas son propuestas. Lista/efectos requieren aprobación. D-006: efectos solo después de instalar USB.",
    "H17": "P-008 resuelta: la compra no activa efectos; el firmware comienza a aplicarse al instalar USB. Autosave intermedio detallado sigue P-005.",
    "H18": "D-006: perks instaladas activas. P-011: duplicados/slots vacíos requieren decisión antes de sus tests específicos.",
    "H19": "P-013: decidir retorno entre plantas y salud del ascensor en H19; H02 no impone restricciones nuevas. Recarga de energía hasta 150 ya aprobada.",
}
replacements = {
    "H05": {"smoke de 3 dificultades": "smoke con perfiles existentes; matriz de tres dificultades desde H13"},
    "H09": {"Definir compatibilidades en datos.": "Dead Eye ralentiza el mundo con cualquier arma; definir en datos solo compatibilidades de efectos específicos de arma."},
    "H10": {"3 dificultades parametrizadas": "perfiles existentes (matriz de tres dificultades desde H13)"},
    "H12": {"optional sigilo bloqueado cuando se activa alarma general.": "una alarma general bloquea recuperar sigilo durante el resto del intento, según D-003 revisada."},
    "H14": {"todas adquiridas activas": "todas las instaladas activas",
            "Revisar y registrar lista final como balance provisional antes de codear.": "Obtener aprobación de la lista y efectos antes de implementarlos. Los efectos comienzan al instalar USB; comprar no basta.",
            "Árbol navegable y testeado con los 12 nodos provisionales revisados en H14, sin exceder alcance.": "Árbol navegable y testeado con la lista de nodos que apruebe el creador; doce nodos siguen siendo propuesta."},
    "H17": {"sólo al instalar se marca armamento utilizable/perk efectiva según decisión del modelo de compra": "solo al instalar se marca armamento utilizable/perk efectiva; el creador aprobó que comprar firmware no active efectos"},
    "H18": {"perks activas por árbol": "perks instaladas activas por árbol"},
    "H19": {"no salud automática": "política de salud pendiente de aprobación en H19",
            "retorno indebido bloqueado": "retorno según la política que se apruebe en H19",
            "ascensor energia 150 sin cura": "ascensor energia 150"},
}
index = ["# Índice de prompts — rutas verificadas en H02\n\n",
         "2026-11-20. H02 en revisión; H03–H24 no iniciados. Son documentos propuestos, no autorizaciones. "
         "La precondición de cada hito requiere validación expresa del anterior. No se recibió un archivo concatenado.\n\n",
         "| Hito | Prompt recibido | Nota H02 |\n|---|---|---|\n"]
paths = sorted((ROOT / "prompts").glob("*.md"))
for path in paths:
    text = path.read_text(encoding="utf-8")
    match = re.search(r"^# (H\d+) — (.+)$", text, re.M)
    identifier, title = match.groups()
    note = notes.get(identifier, "Pendiente de autorización en su propio hito.")
    if identifier == "H02":
        note = "El prompt actual añade auditoría de todos los Markdown, matriz, enlaces, referencias e IDs; no cerrar con contradicciones materiales."
    marker = "\n## Nota de auditoría documental H02 · 2026-11-20\n"
    text = text.partition(marker)[0]
    for old, new in replacements.get(identifier, {}).items():
        if old not in text and new not in text:
            raise ValueError(f"Texto inesperado en {identifier}: {old}")
        text = text.replace(old, new)
    text += marker + "\n" + note + "\n\nConsulta [DOCUMENTATION_AUDIT](../docs/DOCUMENTATION_AUDIT.md) y [DECISIONS](../docs/DECISIONS.md). Este aviso documenta el estado y no inicia el hito.\n"
    if path.read_text(encoding="utf-8") != text:
        path.write_text(text, encoding="utf-8", newline="\n")
    index.append(f"| {identifier} | [{title}](<../prompts/{path.name}>) | {note} |\n")
(ROOT / "docs/PROMPTS_INDEX.md").write_text("".join(index), encoding="utf-8", newline="\n")
print(f"PROMPTS {len(paths)} revisados; notas documentales e índice de rutas reales actualizados")
