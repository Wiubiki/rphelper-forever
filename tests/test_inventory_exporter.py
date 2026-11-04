"""Exercise current source extraction and read-only historical inventory checks."""

import csv
import importlib.util
import json
from pathlib import Path
import shutil
import tempfile
import unittest


ROOT = Path(__file__).resolve().parents[1]
SPEC = importlib.util.spec_from_file_location("inventory", ROOT / "scripts/export_content_inventory.py")
inventory = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(inventory)


class InventoryExporterTests(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory(prefix="rphelper-inventory-test-")
        self.addCleanup(self.temporary.cleanup)
        self.output = Path(self.temporary.name)
        for path in inventory.OUTPUT.iterdir():
            if path.is_file():
                shutil.copyfile(path, self.output / path.name)

    def snapshot(self):
        return {path.name: path.read_bytes() for path in self.output.iterdir()}

    def assert_check_fails_without_writing(self):
        before = self.snapshot()
        with self.assertRaises(AssertionError):
            inventory.check_exports(self.output)
        self.assertEqual(self.snapshot(), before)

    def test_historical_inventory_matches_current_sources_without_writes(self):
        before = self.snapshot()
        inventory.check_exports(self.output)
        self.assertEqual(self.snapshot(), before)

    def test_generated_sources_resolve_under_current_directory(self):
        inventory.payloads(self.output)
        inventory.validate(self.output)
        document = json.loads((self.output / "events.json").read_text())
        paths = document["metadata"]["active_manifest_data_files"]
        paths += document["metadata"]["excluded_archive_files"]
        for event in document["events"]:
            paths += [source["file"] for source in event["registration_sources"]]
            if event["runtime_source"]:
                paths.append(event["runtime_source"]["file"])
            for reactions in event["reactions"].values():
                paths += [reaction["source"]["file"] for reaction in reactions]
        self.assertTrue(paths)
        for path in paths:
            self.assertTrue(path.startswith("RPHelperForever/"), path)
            self.assertTrue((ROOT / path).is_file(), path)

    def test_content_changes_are_rejected_even_when_csv_and_json_agree(self):
        json_path = self.output / "events.json"
        document = json.loads(json_path.read_text())
        reaction = next(reaction for event in document["events"]
                        for reactions in event["reactions"].values() for reaction in reactions)
        # A path inside authored text must never be normalized as source metadata.
        reaction["text"] = "I kept RPHelper/Data/ in my own words."
        reaction["template"] = None
        json_path.write_text(json.dumps(document))
        csv_path = self.output / "reactions.csv"
        with csv_path.open(newline="") as handle:
            reader = csv.DictReader(handle)
            fields, rows = reader.fieldnames, list(reader)
        for row in rows:
            if row["reaction_id"] == reaction["reaction_id"]:
                row["reaction_text"] = reaction["text"]
        with csv_path.open("w", newline="") as handle:
            writer = csv.DictWriter(handle, fieldnames=fields)
            writer.writeheader()
            writer.writerows(rows)
        inventory.validate(self.output)
        self.assert_check_fails_without_writing()

    def test_source_line_changes_are_rejected_without_writes(self):
        path = self.output / "events.json"
        document = json.loads(path.read_text())
        document["events"][0]["source"]["line"] += 1
        path.write_text(json.dumps(document))
        self.assert_check_fails_without_writing()

    def test_unrecognized_source_roots_are_rejected_without_writes(self):
        path = self.output / "events.json"
        document = json.loads(path.read_text())
        document["events"][0]["source"]["file"] = "OtherAddon/Data/Generic.lua"
        path.write_text(json.dumps(document))
        self.assert_check_fails_without_writing()


if __name__ == "__main__":
    unittest.main()
