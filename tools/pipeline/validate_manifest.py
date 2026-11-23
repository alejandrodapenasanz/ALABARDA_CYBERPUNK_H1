"""Validate transfer metadata only. Never execute commands from a manifest."""
from __future__ import annotations

import argparse
from datetime import datetime
import json
from pathlib import Path, PurePosixPath
import re
import subprocess

from jsonschema import Draft202012Validator, FormatChecker

ROOT = Path(__file__).resolve().parents[2]
SCHEMA = ROOT / 'validation/_schemas/test_manifest.schema.json'
BATCHES = {
    'B0': ['H03', 'H04'], 'B1': ['H05', 'H06'], 'B2': ['H07', 'H08', 'H09'],
    'B3': ['H10', 'H11', 'H12'], 'B4': ['H13', 'H14', 'H15'],
    'B5': ['H16', 'H17', 'H18'], 'B6': ['H19', 'H20', 'H21'],
    'B7': ['H22'], 'B8': ['H23', 'H24'],
}
ALLOWED_EXECUTABLES = {
    'python', 'python.exe', '${PYTHON_BIN}', 'powershell', 'powershell.exe',
    'pwsh', 'pwsh.exe', 'godot', 'godot4', '${GODOT_BIN}', '${BLENDER_BIN}', 'git',
}
FORBIDDEN_ARGS = {
    '-c', '/c', '-command', '-encodedcommand', '-enc', '--eval',
    'remove-item', 'del', 'rmdir', 'rm', 'reset', 'clean', 'push',
    '--force', '--force-with-lease', '--hard',
}


def read_json(path: Path):
    def unique_keys(pairs):
        result = {}
        for key, value in pairs:
            if key in result:
                raise ValueError(f'Duplicate JSON key: {key}')
            result[key] = value
        return result

    return json.loads(path.read_text(encoding='utf-8-sig'), object_pairs_hook=unique_keys,
                      parse_constant=lambda value: (_ for _ in ()).throw(ValueError(value)))


def safe_relative(value: str) -> bool:
    return bool(value) and not any(c in value for c in ('\\', ':', '\x00')) and not (
        value.startswith('/') or '..' in PurePosixPath(value).parts
    )


def validate(data, *, ready=False):
    schema = read_json(SCHEMA)
    Draft202012Validator.check_schema(schema)
    errors = [f'{"/".join(map(str, e.absolute_path))}: {e.message}' for e in
              Draft202012Validator(schema, format_checker=FormatChecker()).iter_errors(data)]
    if errors:
        return errors
    # jsonschema's date-time format check is optional when its extra RFC3339
    # dependency is absent. Enforce it explicitly without another dependency.
    timestamp = data['created_at']
    if timestamp is not None:
        try:
            if not re.fullmatch(r'\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(?:\.\d+)?(?:Z|[+-]\d{2}:\d{2})', timestamp):
                raise ValueError('RFC3339 date with timezone required')
            datetime.fromisoformat(timestamp.replace('Z', '+00:00'))
        except ValueError:
            errors.append('created_at: invalid RFC3339 timestamp')
    if data['milestones'] != BATCHES[data['batch_id']]:
        errors.append('Milestones do not match the complete ordered batch')
    tests = data['tests']
    ids = [t['id'] for t in tests]
    if len(ids) != len(set(ids)):
        errors.append('Duplicate test IDs')
    paths = set()
    graph = {t['id']: t['depends_on'] for t in tests}
    for test in tests:
        test_id = test['id']
        if not set(test['milestones']).issubset(data['milestones']):
            errors.append(f'{test_id}: milestones outside batch')
        for dep in test['depends_on']:
            if dep not in graph or dep == test_id:
                errors.append(f'{test_id}: missing/self dependency {dep}')
        if not safe_relative(test['cwd']):
            errors.append(f'{test_id}: unsafe cwd')
        for path in [test['log_path'], *test['artifacts']]:
            if not safe_relative(path) or not path.startswith('evidence/'):
                errors.append(f'{test_id}: evidence must stay under evidence/')
            if path in paths:
                errors.append(f'{test_id}: duplicate evidence path {path}')
            paths.add(path)
        if test['type'] != 'manual':
            cmd = test['command']
            if cmd['executable'] not in ALLOWED_EXECUTABLES:
                errors.append(f'{test_id}: unsupported executable; use an explicit approved binding')
            if any(arg.lower() in FORBIDDEN_ARGS or any(c in arg for c in ('\n', '\r', ';', '`', '|'))
                   or '$(' in arg or '&&' in arg for arg in cmd['args']):
                errors.append(f'{test_id}: destructive/inline shell command is not a test command')
        if ready and re.search(r'EXAMPLE|COMPLETAR|COMPLETE_|TEMPLATE|\bTBD\b',
                               json.dumps(test, ensure_ascii=False), re.I):
            errors.append(f'{test_id}: unfinished template fields')
    visiting, done = set(), set()

    def visit(test_id):
        if test_id in visiting:
            errors.append(f'Dependency cycle at {test_id}')
            return
        if test_id in done or test_id not in graph:
            return
        visiting.add(test_id)
        for dep in graph[test_id]:
            visit(dep)
        visiting.remove(test_id)
        done.add(test_id)

    for test_id in graph:
        visit(test_id)
    if ready:
        if data['is_template'] or not data['code_commit'] or not data['previous_approved_commit']:
            errors.append('A template or missing commit cannot be INTEGRATION_READY')
        if data['state'] != 'INTEGRATION_READY':
            errors.append('Ready transfer must declare INTEGRATION_READY')
        if not data['created_at'] or re.search('TEMPLATE|COMPLETAR|TBD', data['branch'], re.I):
            errors.append('Missing date or branch')
        if not any(t['critical'] and t['type'] != 'manual' for t in tests):
            errors.append('No critical automated test specified')
    return errors


def check_candidate(data, candidate: Path):
    """Read-only Git/path checks. Does not import Godot or execute a test."""
    errors = []
    candidate = candidate.resolve()
    try:
        head = subprocess.check_output(['git', '-C', str(candidate), 'rev-parse', 'HEAD'],
                                       text=True, stderr=subprocess.STDOUT).strip()
        status = subprocess.check_output(['git', '-C', str(candidate), 'status', '--porcelain'], text=True)
    except (OSError, subprocess.CalledProcessError) as exc:
        return [f'Cannot inspect candidate Git commit: {exc}']
    if head != data['code_commit']:
        errors.append(f'Commit mismatch: expected {data["code_commit"]}, actual {head}; STOP before tests')
    if status.strip():
        errors.append('Candidate is dirty; STOP before tests')
    for test in data['tests']:
        cwd = (candidate / test['cwd']).resolve()
        if not cwd.is_relative_to(candidate) or not cwd.is_dir():
            errors.append(f'{test["id"]}: cwd missing/outside candidate')
        if test['manual']:
            scene = (candidate / test['manual']['scene']).resolve()
            if not scene.is_relative_to(candidate) or not scene.is_file():
                errors.append(f'{test["id"]}: scene missing/outside candidate')
        if 'command' in test:
            for arg in test['command']['args']:
                if arg.endswith(('.py', '.ps1', '.gd', '.tscn', '.tres')):
                    path = (candidate / arg[6:]) if arg.startswith('res://') else (cwd / arg)
                    path = path.resolve()
                    if not path.is_relative_to(candidate) or not path.is_file():
                        errors.append(f'{test["id"]}: referenced script/resource missing/outside candidate: {arg}')
    return errors


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('manifest', type=Path)
    parser.add_argument('--ready', action='store_true', help='Require complete transfer and exact clean candidate')
    parser.add_argument('--candidate', type=Path)
    args = parser.parse_args()
    if args.ready and not args.candidate:
        parser.error('--ready requires --candidate')
    try:
        data = read_json(args.manifest)
        errors = validate(data, ready=args.ready)
        if args.ready and not errors:
            errors.extend(check_candidate(data, args.candidate))
    except (ValueError, OSError) as exc:
        errors = [str(exc)]
    print(json.dumps({'status': 'FAIL' if errors else 'PASS', 'mode': 'ready' if args.ready else 'schema',
                      'commands_executed_from_manifest': 0, 'errors': errors}, ensure_ascii=False, indent=2))
    return 1 if errors else 0


if __name__ == '__main__':
    raise SystemExit(main())
