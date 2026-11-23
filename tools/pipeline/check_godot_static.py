"""Static checks of Godot text files WITHOUT Godot (PC Claude).

Catches cheap errors before spending Codex credits. It is NOT a substitute for
Godot import/tests: a PASS here never means VALIDATED (see TEST_STRATEGY).

Checks:
  FAIL  GDScript that does not parse (gdtoolkit grammar, Godot 4 syntax).
  FAIL  Duplicate `class_name` across scripts.
  FAIL  .tscn/.tres: missing res:// targets, duplicate or undeclared
        ExtResource/SubResource ids, node `parent=` paths that do not exist.
  FAIL  project.godot res:// references that do not exist.
  WARN  gdlint findings (style/design, configured by ./gdlintrc).

Usage: python -X utf8 tools/pipeline/check_godot_static.py [--json OUT] [paths...]
Requires: pip install gdtoolkit==4.5.0 (tools/pipeline/requirements.txt).
"""
from __future__ import annotations

import argparse
import json
from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parents[2]
SKIP_DIRS = {'.git', '.godot', 'addons', 'docs'}
RES_RE = re.compile(r'"res://([^"]+)"')
HEADER_RE = re.compile(r'^\[(\w+)([^\]]*)\]\s*$')
ATTR_RE = re.compile(r'(\w+)=("([^"]*)"|[^\s\]]+)')
REF_RE = re.compile(r'\b(ExtResource|SubResource)\(\s*"?([^")\s]+)"?\s*\)')
CLASS_RE = re.compile(r'^class_name\s+(\w+)', re.M)


def iter_files(paths, suffixes):
    for base in paths:
        base = base.resolve()
        if base.is_file():
            if base.suffix in suffixes:
                yield base
            continue
        for p in base.rglob('*'):
            if p.suffix in suffixes and p.is_file() and not (set(p.relative_to(ROOT).parts) & SKIP_DIRS):
                yield p


def rel(p):
    return p.relative_to(ROOT).as_posix()


def res_exists(target):
    if '%' in target or '{' in target:
        return True  # format-string template built at runtime, not a literal path
    return (ROOT / target.split('::')[0]).exists()


def load_baseline():
    path = ROOT / 'tools/pipeline/static_baseline.json'
    if not path.is_file():
        return []
    return [row['prefix'] for row in json.loads(path.read_text(encoding='utf-8'))['accepted']]


def load_lint_config():
    from gdtoolkit.linter import DEFAULT_CONFIG
    config = dict(DEFAULT_CONFIG)
    rc = ROOT / 'gdlintrc'
    if rc.is_file():
        import yaml  # dependency of gdtoolkit
        config.update(yaml.safe_load(rc.read_text(encoding='utf-8')) or {})
    return config


def check_gd(files, errors, warnings):
    from gdtoolkit.parser import parser
    from gdtoolkit.linter import lint_code
    config = load_lint_config()
    classes = {}
    for f in files:
        code = f.read_text(encoding='utf-8-sig')
        try:
            parser.parse(code)
        except Exception as exc:  # lark raises several exception types
            first = str(exc).strip().splitlines()[0] if str(exc).strip() else type(exc).__name__
            errors.append(f'{rel(f)}: GDScript parse error: {first}')
            continue
        for problem in lint_code(code, config):
            warnings.append(f'{rel(f)}:{problem.line}: {problem.description} ({problem.name})')
        for name in CLASS_RE.findall(code):
            classes.setdefault(name, []).append(rel(f))
        for target in RES_RE.findall(code):
            if not res_exists(target):
                errors.append(f'{rel(f)}: missing res://{target}')
    for name, where in classes.items():
        if len(where) > 1:
            errors.append(f'Duplicate class_name {name}: {", ".join(where)}')


def check_text_resource(f, errors):
    ext, sub, nodes = set(), set(), set()
    body_refs = []
    for n, line in enumerate(f.read_text(encoding='utf-8-sig').splitlines(), 1):
        m = HEADER_RE.match(line)
        if m:
            kind = m.group(1)
            attrs = {k: (q if q is not None and v.startswith('"') else v) for k, v, q in ATTR_RE.findall(m.group(2))}
            if kind == 'ext_resource':
                rid = attrs.get('id')
                if rid in ext:
                    errors.append(f'{rel(f)}:{n}: duplicate ext_resource id {rid}')
                ext.add(rid)
                path = attrs.get('path', '')
                if path.startswith('res://') and not res_exists(path[6:]):
                    errors.append(f'{rel(f)}:{n}: missing {path}')
            elif kind == 'sub_resource':
                rid = attrs.get('id')
                if rid in sub:
                    errors.append(f'{rel(f)}:{n}: duplicate sub_resource id {rid}')
                sub.add(rid)
            elif kind == 'node':
                name, parent = attrs.get('name'), attrs.get('parent')
                if parent is None:
                    nodes.add('.')
                else:
                    if parent not in nodes:
                        errors.append(f'{rel(f)}:{n}: node "{name}" has unknown parent "{parent}"')
                    nodes.add(name if parent == '.' else f'{parent}/{name}')
            body_refs.extend((n, k, v) for k, v in REF_RE.findall(line))
            continue
        body_refs.extend((n, k, v) for k, v in REF_RE.findall(line))
        for target in RES_RE.findall(line):
            if not res_exists(target):
                errors.append(f'{rel(f)}:{n}: missing res://{target}')
    for n, kind, rid in body_refs:
        if rid not in (ext if kind == 'ExtResource' else sub):
            errors.append(f'{rel(f)}:{n}: {kind}("{rid}") not declared')


def check_project(errors):
    project = ROOT / 'project.godot'
    for target in RES_RE.findall(project.read_text(encoding='utf-8-sig')):
        if not res_exists(target.lstrip('*')):
            errors.append(f'project.godot: missing res://{target}')


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('paths', nargs='*', type=Path)
    ap.add_argument('--json', type=Path, help='write the result as JSON')
    args = ap.parse_args()
    paths = args.paths or [ROOT]
    errors, warnings = [], []
    try:
        import gdtoolkit  # noqa: F401
    except ImportError:
        print('gdtoolkit not installed: pip install -r tools/pipeline/requirements.txt', file=sys.stderr)
        return 2
    gd = sorted(iter_files(paths, {'.gd'}))
    res = sorted(iter_files(paths, {'.tscn', '.tres'}))
    check_gd(gd, errors, warnings)
    for f in res:
        check_text_resource(f, errors)
    check_project(errors)
    baseline = load_baseline()
    known = [e for e in errors if any(e.startswith(p) for p in baseline)]
    errors = [e for e in errors if e not in known]
    result = {'status': 'FAIL' if errors else 'PASS', 'gd_files': len(gd), 'text_resources': len(res),
              'errors': errors, 'known_accepted': len(known), 'lint_warnings': warnings,
              'scope': 'Static only, no Godot. PASS never implies import/test/VALIDATED.'}
    out = json.dumps(result, ensure_ascii=False, indent=2)
    if args.json:
        args.json.write_text(out + '\n', encoding='utf-8')
    print(out)
    return 1 if errors else 0


if __name__ == '__main__':
    raise SystemExit(main())
