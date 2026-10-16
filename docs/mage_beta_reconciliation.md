# Mage beta ability reconciliation

Research snapshot only. This report proposes dispositions for owner review; it does not authorize catalogue, archive, spell-ID, detection, settings, or content changes.

## Sources and limitations

The primary [Mage spellbook](https://wowforevertalent.com/abilities/mage/) was retrieved on 16 October 2026. It identifies the **16 October 2026 Forever Beta book, client 1.60.1.70425** and contains **197 recorded ranks grouped into 60 class-specific identities**: 39 Arcane, nine Fire, and 12 Frost. Six General-tab records bring the inventory to 66 identities and 203 tooltips. The page reports no Classic-fallback or name-only records, but it is not an in-game check.

The linked [Mage talent reference](https://wowforevertalent.com/mage/reference/) uses the **16 October 2026 Forever export** (`beta-20261016-56046fb6`). Its 11 active talents—Arcane Blast, Arcane Wrath, Presence of Mind, Arcane Power, Pyroblast, Blast Wave, Combustion, Ice Lance, Ice Block, Cold Snap, and Ice Barrier—are all present in the spellbook and add no separate identity.

The retrieved [changelog](https://wowforevertalent.com/changelog/) confirms Frostfire Bolt's recorded beta tooltip and the earlier removal of Fire Vulnerability as a spellbook talent-effect row. No later entry supersedes the 16 October Mage book. The source remains unverified in game.

The pages expose ranks, learn levels, acquisition notes, cast/channel timing, reagents, and requirements, but not numeric spell IDs. Candidate IDs in the CSV come from the repository's earlier mixed-source inventory and remain unverified; blanks are intentional. Spellbook presence does not prove a readable successful-cast event.

Source B is the actual registration path in `RPHelper/Data/Abilities/Mage.lua`. It defines **54 canonical identities and 134 authored reactions**: 80 `say`, zero `emote`, and 54 `customemote`. Every current definition has authored content; there are **no empty shipped pools**. This research changes none of them.

## Reconciliation totals

The CSV retains all 66 beta identities and all 54 RPHelper definitions. Fifty-two identities overlap and two historical definitions are absent, producing **68 reconciled identities**.

| Classification | Identities | Authored reactions | Empty RPHelper definitions |
| --- | ---: | ---: | ---: |
| Confirmed, existing | 52 | 128 | 0 |
| Confirmed, missing | 14 | 0 | 0 |
| Not found in beta | 2 | 6 | 0 |
| **Total** | **68** | **134** | **0** |

All 60 class-specific identities are directly activated and in v1 scope: **52 existing** and **eight missing**. The six General identities remain evidence but are out of scope; Attack, Shoot, and Comprehend Scroll are active, while Armor Proficiency, Dodge, and Languages are passive.

## Existing and missing coverage

The 52 exact existing class identities retain 128 reactions. Coverage includes all six current faction portals, all six corresponding teleports, base Polymorph, the four separately named mana-gem conjurations, Conjure Food, Conjure Water, and all existing talent activations.

Eight beta-confirmed active identities are missing:

- **Arcane Blast** and **Arcane Wrath**, both active Arcane talents.
- **Polymorph (Pig)** and **Polymorph (Turtle)**, separate learned variants rather than aliases of base Polymorph.
- **Teleport: Dalaran**. The source does not list a matching Dalaran portal, so none should be inferred.
- **Frostfire Bolt**, a three-rank Fire spell.
- **Frost Blast**, a three-rank Frost spell distinct from Frostbolt.
- **Ice Lance**, an active Frost talent with six ranks.

The six missing General records are excluded from v1 by policy and should not be promoted automatically.

## Legacy and replacement candidates

- **Detect Magic** and **Icicles** are absent from the current spellbook and talent reference but retain three reactions each. Absence alone does not authorize deletion or loss of content.
- Ice Lance is not an automatic replacement for Icicles; their names and frost theme do not establish mechanical continuity.
- Frost Blast and Frostbolt are separate spellbook identities. Their similar names do not establish an alias.
- Base Polymorph, Polymorph (Pig), and Polymorph (Turtle) are separate source identities. Existing Polymorph reactions must not be copied automatically.
- Teleport: Dalaran does not imply Portal: Dalaran. The latter is absent from the retrieved source.

No supported rename or canonical-key migration is established by current evidence.

## Casting and detection considerations

Arcane Missiles, Evocation, and Blizzard are channelled. Most offensive spells are cast-time or instant; portal and teleport spells have long casts and reagents. Conjuration creates inventory items, mana gems are separate identities, and Polymorph variants share mechanics without sharing source identity. Successful-cast detection must distinguish cast starts, channel starts/completion, interruptions, reagent failures, and triggered talent effects. None of these records authorizes production IDs or runtime changes.

## Owner decisions required

1. Approve or reject empty definitions for the eight missing active class identities.
2. Decide whether Detect Magic and Icicles remain active legacy exceptions or move to a later unloaded archive while preserving their six reactions and player data.
3. Confirm separate canonical identities for Pig and Turtle rather than transferring base Polymorph content.
4. Confirm Teleport: Dalaran without inventing Portal: Dalaran.
5. Defer spell-ID mapping and event handling until cast, channel, conjuration, portal, and Polymorph-variant behavior is verified in client.

## Provisional implementation disposition

Subject to owner approval, a later implementation could retain the 52 confirmed identities and 128 reactions, add the eight missing class identities as empty definitions, and leave all General records out of v1. Detect Magic and Icicles require explicit preservation decisions before production changes. No archive, migration, reaction transfer, spell-ID mapping, or detection change is authorized by this research.

The complete row-level evidence is in [the Mage reconciliation CSV](mage_beta_reconciliation.csv).
