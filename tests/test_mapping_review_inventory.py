"""Cross-check every included/excluded review decision against real Lua data."""

import csv
import importlib.util
from pathlib import Path
import unittest

ROOT = Path(__file__).resolve().parents[1]
SPEC = importlib.util.spec_from_file_location("inventory", ROOT / "scripts/export_content_inventory.py")
inventory = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(inventory)


def rows(path):
    with (ROOT / path).open(newline="") as stream:
        return list(csv.DictReader(stream))


class MappingReviewTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.review = rows("docs/audits/ability_mapping_expansion_review.csv")
        cls.actual = {(class_name, int(spell_id)): ability
                      for class_name, abilities in inventory.collect()["abilitySpells"].items()
                      for ability, spell_ids in abilities.items() for spell_id in spell_ids}

    def test_every_production_pair_has_one_included_review_row(self):
        included = [r for r in self.review if r["decision"] == "include"]
        expected = {(r["player_class"], int(r["spell_id"])): r["canonical_key"] for r in included}
        self.assertEqual(len(expected), len(included))
        self.assertEqual(expected, self.actual)
        self.assertEqual(len(expected), 1168)
        self.assertEqual(len({(r["player_class"], r["canonical_key"]) for r in included}), 366)
        self.assertEqual(len({r["player_class"] for r in included}), 9)

    def test_no_excluded_or_uncertain_pair_can_classify(self):
        for row in self.review:
            if row["decision"] == "exclude":
                self.assertTrue(row["exclusion_reason"], row["row_id"])
                self.assertEqual(row["evidence_tier"], "C")
                if row["spell_id"]:
                    self.assertNotIn((row["player_class"], int(row["spell_id"])), self.actual)

    def test_evidence_is_rank_specific_and_only_two_owner_captures_are_A(self):
        observed = []
        for row in self.review:
            self.assertTrue(row["rank_variant"])
            if row["decision"] == "include":
                self.assertIn(row["evidence_tier"], {"A", "B"})
                self.assertEqual(row["activation_mechanism"], "player_success")
                self.assertTrue(row["foreverdb_group"])
                self.assertTrue(row["warcraft_rank"])
                self.assertTrue(row["book_anchor"])
                self.assertIn("https://", row["evidence_source"])
                if row["evidence_tier"] == "B":
                    self.assertEqual(row["event_verification"], "Not RPHelper-live-verified")
            if row["evidence_tier"] == "A":
                observed.append((row["player_class"], int(row["spell_id"])))
        self.assertEqual(set(observed), {("SHAMAN", 325), ("SHAMAN", 547)})

    def test_verification_inventory_distinguishes_production_from_candidates(self):
        verified = rows("docs/audits/ability_detection_verification_inventory.csv")
        self.assertEqual(len(verified), 474)
        expected = {(r["player_class"], r["canonical_key"]):
                    {int(x) for x in r["production_spell_ids"].split(";") if x} for r in verified}
        for pair, ids in expected.items():
            actual = {spell_id for (class_name, spell_id), ability in self.actual.items()
                      if (class_name, ability) == pair}
            self.assertEqual(ids, actual, pair)


if __name__ == "__main__":
    unittest.main()
