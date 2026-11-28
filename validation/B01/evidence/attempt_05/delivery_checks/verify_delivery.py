import hashlib
import json
import re
import subprocess
import xml.etree.ElementTree as ET
from pathlib import Path

root=Path('C:/dev/ALABARDA_CYBERPUNK_H1')
pkg=root/'validation/B01'
C='1401e05269fc4919f3658788e7de48bc5a4aa148'
def git(*args):
    return subprocess.check_output(['git',*args],cwd=root)
old=git('show','f951cb6892e2867f28ceb3edebb823377c6ecd8f:validation/B01/TEST_RESULTS.md')
old=old[old.index(b'## Intento 00'):old.index('## Veredicto técnico'.encode())]
results=(pkg/'TEST_RESULTS.md').read_bytes()
assert results[results.index(b'## Intento 00'):results.index(b'## Intento 01')]==old
assert (root/'docs/VALIDATION.md').read_bytes().endswith(git('show','39d5412:docs/VALIDATION.md'))
raw=0
for attempt in ['attempt_01','attempt_02','diagnostic_03','attempt_04','attempt_05']:
    folder=pkg/'evidence'/attempt
    for name,digest in json.loads((folder/'raw_artifacts_sha256.json').read_text()).items():
        assert hashlib.sha256((folder/name).read_bytes()).hexdigest()==digest,(attempt,name)
        raw+=1
def xml_counts(path):
    cases=list(ET.parse(path).getroot().iter('testcase'))
    return dict(tests=len(cases), failed_cases=sum(c.find('failure') is not None for c in cases),
        assertions=sum(len(c.findall('failure')) for c in cases), errors=sum(c.find('error') is not None for c in cases),
        skipped=sum(c.find('skipped') is not None for c in cases))
red=xml_counts(pkg/'evidence/attempt_04/red_full/reports/report_1/results.xml')
assert red==dict(tests=7,failed_cases=5,assertions=10,errors=0,skipped=0),red
green=[]
for xml in (pkg/'evidence/attempt_05').rglob('results.xml'):
    counts=xml_counts(xml)
    if 'negative_control_reports' in xml.parts:
        assert counts==dict(tests=1,failed_cases=1,assertions=1,errors=0,skipped=0)
    else:
        assert counts['failed_cases']==counts['errors']==counts['skipped']==0
    green.append(dict(path=xml.relative_to(pkg).as_posix(),**counts))
summary=json.loads((pkg/'evidence/attempt_05/summary.json').read_text())
assert summary['status']=='PASS'
for entry in summary['results']:
    if entry['label'] in ['b1_unit','b1_integration']:
        assert entry['junit']['tests']==(37 if entry['label']=='b1_unit' else 35)
assert not git('diff',C,'--name-only','--','scripts','scenes','resources','tests','addons','art_sources','project.godot','tools').strip()
assert not git('diff','39d5412',C,'--name-only','--','scenes','scripts/combat/fixture_weapon.gd','scripts/combat/attack_state_machine.gd','resources','project.godot').strip()
assert not git('diff','f9f215b',C,'--name-only','--','tests').strip()
manifest=json.loads((pkg/'TEST_MANIFEST.json').read_text(encoding='utf-8'))
assert manifest['code_commit']==C and manifest['state']=='INTEGRATION_READY'
for t in manifest['tests']:
    assert (pkg/t['log_path']).exists(),t['id']
    for name in t['artifacts']: assert (pkg/name).exists(),name
    if t['type']=='manual':
        assert 'NOT_RUN' in (pkg/t['log_path']).read_text(encoding='utf-8')
links=0
files=[root/name for name in git('diff','--name-only').decode().splitlines() if name.endswith('.md')]
files.extend((pkg/'evidence/attempt_05/manual').glob('*.md'))
for file in files:
    text=re.sub(r'```.*?```','',file.read_text(encoding='utf-8'),flags=re.S)
    for target in re.findall(r'(?<!!)\[[^\]\n]+\]\(([^)\n]+)\)',text):
        if target.startswith(('http:','https:','mailto:')): continue
        path=target.split('#',1)[0].strip('<>')
        if path:
            assert (file.parent/path).exists(),(file,target)
            links+=1
print(json.dumps(dict(status='PASS',code_commit=C,raw_artifacts_verified=raw,local_links_verified=links,
    original_attempt_00_preserved=True,historical_validation_preserved=True,appearance_sources_unchanged=True,
    tests_unchanged_between_red_and_green=True,red_new_suite=red,final_junit=green),indent=2))
