"""Exercise transport integrity on isolated files, not on the real repository."""
import hashlib
import json
from pathlib import Path
import tempfile
import unittest

from verify_checkout import check


class CheckoutTests(unittest.TestCase):
    def test_preserved_missing_modified_excluded_and_unsafe_files(self):
        with tempfile.TemporaryDirectory() as folder:
            root=Path(folder)
            (root/'tools/pipeline').mkdir(parents=True)
            (root/'scripts').mkdir()
            path=root/'scripts/fixture.gd'
            path.write_text('extends Node\n',encoding='utf-8')
            manifest={'schema_version':1,'scope':'portable-development-checkout',
                      'files':{'scripts/fixture.gd':hashlib.sha256(path.read_bytes()).hexdigest()},
                      'excluded_files':{'local_only.bin':'Test exclusion'}}
            dest=root/'tools/pipeline/checkout_manifest.json'
            def save(): dest.write_text(json.dumps(manifest),encoding='utf-8')
            save()
            self.assertEqual(check(root,True)['status'],'PASS')
            path.write_text('changed\n',encoding='utf-8')
            self.assertTrue(any('Changed' in e for e in check(root,True)['errors']))
            path.unlink()
            self.assertTrue(any('Missing' in e for e in check(root,True)['errors']))
            (root/'local_only.bin').write_bytes(b'fixture')
            self.assertTrue(any('Excluded' in e for e in check(root,True)['errors']))
            manifest['files']['scripts/../../outside']='0'*64
            save()
            self.assertTrue(any('Unsafe' in e for e in check(root,True)['errors']))


if __name__=='__main__':
    unittest.main(verbosity=2)
