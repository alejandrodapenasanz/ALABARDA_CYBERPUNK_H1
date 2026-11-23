"""Positive and negative transfer checks; no game implementation or execution."""
import copy
import json
from pathlib import Path
import subprocess
import tempfile
import unittest

from validate_manifest import ROOT, check_candidate, read_json, validate


class ManifestTests(unittest.TestCase):
    def setUp(self):
        self.data = read_json(ROOT / 'validation/_templates/TEST_MANIFEST.json')

    def complete(self):
        data = copy.deepcopy(self.data)
        data.update(is_template=False, code_commit='a' * 40, previous_approved_commit='b' * 40,
                    state='INTEGRATION_READY', branch='claude/B01', created_at='2026-11-23T00:00:00+01:00')
        data['tests'] = data['tests'][:1]
        data['tests'][0].update(id='B01-IMPORT', name='Candidate import')
        return data

    def test_template_schema_valid_but_not_ready(self):
        self.assertEqual(validate(self.data), [])
        self.assertTrue(validate(self.data, ready=True))

    def test_complete_transfer_valid(self):
        self.assertEqual(validate(self.complete(), ready=True), [])

    def test_wrong_schema_and_unknown_field(self):
        for key, value in [('schema_version', '2.0.0'), ('invented', 1)]:
            data = self.complete(); data[key] = value
            self.assertTrue(validate(data))

    def test_no_fake_initial_pass(self):
        self.data['tests'][0]['initial_status'] = 'PASS'
        self.assertTrue(validate(self.data))

    def test_missing_commit_rejected(self):
        data = self.complete(); data['code_commit'] = None
        self.assertTrue(validate(data, ready=True))

    def test_duplicate_id_and_missing_dependency(self):
        for kind in ('duplicate', 'missing'):
            data = copy.deepcopy(self.data)
            if kind == 'duplicate': data['tests'][1]['id'] = data['tests'][0]['id']
            else: data['tests'][0]['depends_on'] = ['ABSENT']
            self.assertTrue(validate(data))

    def test_dependency_cycle(self):
        self.data['tests'][0]['depends_on'] = ['EXAMPLE-MANUAL']
        self.assertTrue(any('cycle' in e for e in validate(self.data)))

    def test_milestones_batch_and_test(self):
        for target in ('batch', 'test'):
            data = copy.deepcopy(self.data)
            if target == 'batch': data['milestones'] = ['H07']
            else: data['tests'][0]['milestones'] = ['H24']
            self.assertTrue(validate(data))

    def test_claude_cannot_own_engine_tests(self):
        self.data['tests'][0]['owner'] = 'CLAUDE'
        self.assertTrue(validate(self.data))

    def test_manual_cannot_have_command(self):
        self.data['tests'][1]['command'] = self.data['tests'][0]['command']
        self.assertTrue(validate(self.data))

    def test_automatic_requires_command(self):
        del self.data['tests'][0]['command']
        self.assertTrue(validate(self.data))

    def test_unsafe_paths_and_colliding_evidence(self):
        for value in ('../escape', 'C:/outside', '/outside', 'evidence/../outside', 'evidence\\bad'):
            data = copy.deepcopy(self.data); data['tests'][0]['log_path'] = value
            self.assertTrue(validate(data), value)
        self.data['tests'][1]['log_path'] = self.data['tests'][0]['log_path']
        self.assertTrue(validate(self.data))

    def test_destructive_or_inline_commands_rejected(self):
        for executable, args in [('powershell', ['-Command', 'Remove-Item']), ('git', ['reset', '--hard']),
                                 ('python', ['-c', 'print(1)']), ('cmd', ['/c', 'del'])]:
            data = self.complete(); data['tests'][0]['command'] = {'executable': executable, 'args': args}
            self.assertTrue(validate(data))

    def test_timeout_date_and_manual_placeholders(self):
        for value in (0, -1, 3601):
            data = self.complete(); data['tests'][0]['timeout_seconds'] = value
            self.assertTrue(validate(data))
        for timestamp in ('not-a-date', '2026-11-23T00:00:00', '2026-02-30T00:00:00Z'):
            data = self.complete(); data['created_at'] = timestamp
            self.assertTrue(validate(data))
        data = self.complete(); data['tests'][0]['expected'] = 'COMPLETAR'
        self.assertTrue(validate(data, ready=True))

    def test_duplicate_json_keys_rejected(self):
        with tempfile.TemporaryDirectory() as folder:
            path = Path(folder) / 'bad.json'; path.write_text('{"a":1,"a":2}', encoding='utf-8')
            with self.assertRaises(ValueError): read_json(path)

    def test_exact_commit_clean_tree_and_script_presence(self):
        # Isolated disposable repository: never touches the project's historical index.
        with tempfile.TemporaryDirectory() as folder:
            root = Path(folder)
            def git(*args):
                return subprocess.check_output(['git', '-C', str(root), *args], text=True, stderr=subprocess.STDOUT).strip()
            git('init', '-q')
            (root/'probe.py').write_text('print("fixture")\n', encoding='utf-8')
            git('add', 'probe.py')
            git('-c', 'user.name=Manifest Test', '-c', 'user.email=manifest-test@example.invalid', 'commit', '-qm', 'fixture')
            data = self.complete(); data['code_commit'] = git('rev-parse', 'HEAD')
            data['tests'][0]['command'] = {'executable': 'python', 'args': ['probe.py']}
            self.assertEqual(check_candidate(data, root), [])
            data['code_commit'] = 'a'*40
            self.assertTrue(any('Commit mismatch' in e for e in check_candidate(data, root)))
            data['code_commit'] = git('rev-parse', 'HEAD')
            data['tests'][0]['command']['args'] = ['missing.py']
            self.assertTrue(any('missing/outside' in e for e in check_candidate(data, root)))
            (root/'dirty.txt').write_text('untracked', encoding='utf-8')
            self.assertTrue(any('dirty' in e for e in check_candidate(data, root)))


if __name__ == '__main__':
    unittest.main(verbosity=2)
