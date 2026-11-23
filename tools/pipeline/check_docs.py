"""Audit this documentary migration against its immutable entry snapshot."""
from __future__ import annotations

import hashlib
import json
from pathlib import Path
import re
from urllib.parse import unquote

ROOT = Path(__file__).resolve().parents[2]


def digest(path):
    with path.open('rb') as stream:
        return hashlib.file_digest(stream, 'sha256').hexdigest()


def active_docs():
    return [ROOT/'AGENTS.md', ROOT/'README.md', *sorted((ROOT/'docs').glob('*.md')),
            *sorted((ROOT/'prompts').rglob('*.md')), *sorted((ROOT/'validation/_templates').glob('*.md'))]


def check():
    errors = []
    before = json.loads((ROOT/'docs/evidence/pipeline_v2_1/before.json').read_text(encoding='utf-8'))
    archived = json.loads((ROOT/'docs/history/pre_pipeline_v2_1/manifest.json').read_text(encoding='utf-8'))
    checked, preserved = 0, 0
    for name, expected in before['files'].items():
        path = ROOT/name
        editable = name in ('AGENTS.md', 'README.md') or (
            name.endswith('.md') and (name.startswith('prompts/') or (name.startswith('docs/') and name.count('/') == 1)))
        if not path.is_file():
            errors.append('Entry file removed: '+name)
        elif not editable:
            checked += 1
            if digest(path) != expected:
                errors.append('Protected entry file changed: '+name)
            else:
                preserved += 1
    if digest(ROOT/'.git/index') != before['git_index_sha256']:
        errors.append('Historical Git index changed')
    for row in archived['entries']:
        path = ROOT/row['archive']
        if not path.is_file() or digest(path) != row['sha256']:
            errors.append('Historical document changed: '+row['source'])
    original_prompts = sorted(n for n in before['files'] if re.match(r'prompts/H\d\d_[^/]+\.md$', n))
    prompts = sorted(p.relative_to(ROOT).as_posix() for p in (ROOT/'prompts').glob('H*.md'))
    if prompts != original_prompts or [p[9:11] for p in prompts] != [f'{n:02d}' for n in range(2,25)]:
        errors.append('Milestone IDs/paths changed or missing')
    for name in prompts:
        text = (ROOT/name).read_text(encoding='utf-8')
        for token in ('Lee primero `AGENTS.md`', 'Claude', 'Codex', 'sin Godot ni Blender',
                      'NOT_RUN', 'TEST_MANIFEST.json', 'checkpoint', 'commit', '## Aceptación'):
            if token not in text:
                errors.append(f'{name}: missing {token}')
        if int(name[9:11]) >= 5 and 'NOT_STARTED' not in text:
            errors.append(f'{name}: future milestone status missing')
        for stale in ('F extracción contextual', 'E curación mantenida fuera de objetos', 'mantener F en víctima',
                      'bucle combate→ejecución→energía', 'no te autoapruebes ni comiences H'):
            if stale.casefold() in text.casefold():
                errors.append(f'{name}: obsolete instruction {stale}')
    required = ['docs/DEVELOPMENT_WORKFLOW.md', 'docs/HEALTH_ENERGY_CONTRACT.md', 'docs/CONTROLS.md',
                'docs/HEALTH_ENERGY_TEST_CASES.md', 'docs/PIPELINE_MIGRATION_REPORT.md',
                'prompts/BATCH_PROMPTS.md', 'validation/_schemas/test_manifest.schema.json',
                'validation/_templates/TEST_MANIFEST.json']
    required += [f'prompts/_templates/{n}.md' for n in ('CLAUDE_IMPLEMENT_BATCH','CODEX_VALIDATE_BATCH','CLAUDE_FIX_BATCH')]
    required += [f'validation/_templates/{n}.md' for n in ('TEST_HANDOFF','TEST_RESULTS','BUG_REPORT')]
    for name in required:
        if not (ROOT/name).is_file(): errors.append('Required file absent: '+name)
    refs = 0
    for path in active_docs():
        content = path.read_text(encoding='utf-8-sig')
        # Fenced command/examples are not live Markdown links.
        content = re.sub(r'```.*?```', '', content, flags=re.S)
        for match in re.finditer(r'(?<!!)\[[^\]\n]+\]\(([^)\n]+)\)', content):
            raw = match.group(1).strip().strip('<>')
            if raw.startswith(('http:', 'https:', 'mailto:')):
                continue
            target, _, anchor = raw.partition('#')
            destination = (path.parent/unquote(target)).resolve() if target else path
            refs += 1
            if not destination.exists():
                errors.append(f'Broken Markdown link {path.relative_to(ROOT)} -> {raw}')
            elif anchor and destination.suffix == '.md':
                headings = re.findall(r'^#+\s+(.+)$', destination.read_text(encoding='utf-8-sig'), re.M)
                slugs = {re.sub(r'[^\w\- ]','',h.lower()).replace(' ','-') for h in headings}
                if unquote(anchor) not in slugs:
                    errors.append(f'Broken heading {path.relative_to(ROOT)} -> {raw}')
    balance = (ROOT/'docs/BALANCE_PROVISIONAL.md').read_text(encoding='utf-8')
    for key, value in {'health_max':'100','energy_max':'150','energy_passive_cap':'100',
                       'ultimate_activation_min':'100','health_auto_regen_delay_s':'5.0',
                       'health_auto_regen_hp_per_s':'5.0','health_manual_heal_hp_per_s':'25.0',
                       'health_manual_energy_cost_per_s':'25.0','energy_passive_regen_per_s':'8.0',
                       'energy_per_kill':'15.0','manual_heal_pauses_auto_regen':'true',
                       'ultimate_duration_at_100_s':'6.0','ultimate_duration_at_150_s':'10.0'}.items():
        classification = 'APPROVED_RULE' if key in ('health_max','energy_max','energy_passive_cap','ultimate_activation_min') else 'PROVISIONAL_VALUE / PENDING_PLAYTEST'
        if f'| {key} | {value} | {classification} |' not in balance:
            errors.append('Balance rule/value/status mismatch: '+key)
    critical_docs = ['docs/GAME_DESIGN.md','docs/DECISIONS.md','docs/BALANCE_PROVISIONAL.md']
    critical_docs += [p for p in prompts if int(p[9:11]) in (6,8,9,13,14,15,19,22)]
    for name in critical_docs:
        content=(ROOT/name).read_text(encoding='utf-8')
        for token in ('5 s sin daño','5 HP/s','25 HP/s','25 energía/s','8/s hasta 100','+15 hasta 150',
                      'PROVISIONAL_VALUE / PENDING_PLAYTEST','SUPERSEDED','sin curación directa de HP'):
            if token not in content: errors.append(f'{name}: health contract marker missing: {token}')
    cases = (ROOT/'docs/HEALTH_ENERGY_TEST_CASES.md').read_text(encoding='utf-8')
    if re.findall(r'^\| (SB-\d\d) \|', cases, re.M) != [f'SB-{i:02d}' for i in range(1,30)]:
        errors.append('29 health/energy cases missing/duplicated')
    controls=(ROOT/'docs/CONTROLS.md').read_text(encoding='utf-8')
    if re.findall(r'^\| (CT-\d\d) \|', controls, re.M) != [f'CT-{i:02d}' for i in range(1,11)]:
        errors.append('10 input cases missing/duplicated')
    roadmap=(ROOT/'docs/ROADMAP.md').read_text(encoding='utf-8')
    for b in range(9):
        if f'| B{b} |' not in roadmap: errors.append(f'Batch B{b} missing')
    # This is an append-only validation update, not a rewrite of historical results.
    validation=(ROOT/'docs/VALIDATION.md').read_bytes()
    original=(ROOT/'docs/history/pre_pipeline_v2_1/docs/VALIDATION.md').read_bytes()
    if not validation.endswith(original): errors.append('Historical VALIDATION bytes were not preserved')
    return {'status':'FAIL' if errors else 'PASS','protected_files_checked':checked,
            'protected_files_unchanged':preserved,'historical_documents':len(archived['entries']),
            'milestone_prompts':len(prompts),'active_markdown_files':len(active_docs()),'local_links':refs,
            'health_energy_cases':29,'control_cases':10,'git_index_unchanged':digest(ROOT/'.git/index') == before['git_index_sha256'],
            'errors':errors,'limits':['No external URLs checked','No engine/gameplay tests executed',
                                     'Historical/public snapshot links are not active guides; originals protected by hash',
                                     'Semantic review complements token checks; no human approval inferred']}


if __name__=='__main__':
    # The migration-entry index belongs to the original PC. A published clone
    # uses its explicitly recorded transfer baseline, never that private index.
    if (ROOT/'tools/pipeline/checkout_manifest.json').is_file():
        from verify_checkout import check as check_checkout
        result=check_checkout(ROOT)
    else:
        result=check()
    print(json.dumps(result,ensure_ascii=False,indent=2))
    raise SystemExit(1 if result['errors'] else 0)
