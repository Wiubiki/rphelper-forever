"""Verify deterministic installable packages and the optional output path."""

import contextlib
import importlib.util
import io
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest
import zipfile


ROOT = Path(__file__).resolve().parents[1]
SPEC = importlib.util.spec_from_file_location("package_addon", ROOT / "scripts/package_addon.py")
package = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(package)


class PackageTests(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory(prefix="rphelper-package-test-")
        self.addCleanup(self.temporary.cleanup)
        self.output = Path(self.temporary.name) / "nested" / "mapping-test.zip"

    def test_default_output_remains_in_ignored_dist(self):
        self.assertEqual(package.default_archive().parent, ROOT / "dist")
        self.assertEqual(package.default_archive().name, "RPHelperForever-0.9.0-prerelease.zip")
        ignored = subprocess.run(["git", "check-ignore", "dist/probe.zip"], cwd=ROOT, capture_output=True)
        self.assertEqual(ignored.returncode, 0)

    def test_build_creates_parents_and_repeated_build_is_byte_identical(self):
        with contextlib.redirect_stdout(io.StringIO()) as messages:
            package.build(self.output)
            before = self.output.read_bytes()
            package.build(self.output)
            digest, names = package.validate(self.output)
        self.assertEqual(before, self.output.read_bytes())
        self.assertEqual(digest, package.sha256(self.output))
        self.assertIn("unchanged", messages.getvalue())
        _, sources = package.package_sources()
        self.assertEqual(names, [member.as_posix() for _, member in sources])
        self.assertIn("RPHelperForever/Data/AbilitySpellMappings.lua", names)
        with zipfile.ZipFile(self.output) as archive:
            for source, member in sources:
                self.assertEqual(archive.read(member.as_posix()), source.read_bytes())
        allowed_notices = {member.as_posix() for member in package.NOTICES.values()}
        for name in names:
            self.assertTrue(name.startswith("RPHelperForever/"))
            self.assertTrue(name.endswith((".lua", ".toc")) or name in allowed_notices, name)
            self.assertNotIn("Archive.lua", name)

    def test_custom_output_cli_build_and_validate(self):
        for arguments in (["build", "--output", str(self.output)], ["validate", str(self.output)]):
            result = subprocess.run([sys.executable, str(ROOT / "scripts/package_addon.py"), *arguments],
                                    cwd=ROOT, capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertTrue(self.output.is_file())

    def test_existing_different_archive_is_preserved(self):
        self.output.parent.mkdir(parents=True)
        self.output.write_bytes(b"existing artifact")
        with self.assertRaises(package.PackageError):
            package.build(self.output)
        self.assertEqual(self.output.read_bytes(), b"existing artifact")

    def test_validation_rejects_extra_development_files_and_changed_source_bytes(self):
        self.output.parent.mkdir(parents=True)
        package.write_archive(self.output)
        with zipfile.ZipFile(self.output, "a") as archive:
            info = zipfile.ZipInfo("RPHelperForever/tests/unwanted.lua", package.FIXED_TIMESTAMP)
            archive.writestr(info, "unwanted")
        with self.assertRaises(package.PackageError):
            package.validate(self.output)
        package.write_archive(self.output)
        with zipfile.ZipFile(self.output) as archive:
            entries = [(info, archive.read(info.filename)) for info in archive.infolist()]
        with zipfile.ZipFile(self.output, "w") as archive:
            for info, data in entries:
                archive.writestr(info, b"tampered" if info.filename.endswith("AbilitySpellMappings.lua") else data)
        with self.assertRaises(package.PackageError):
            package.validate(self.output)


if __name__ == "__main__":
    unittest.main()
