# Druid beta ability reconciliation

Research snapshot only. This report proposes dispositions for owner review; it does not authorize catalogue, archive, spell-ID, form, detection, settings, or content changes.

## Sources and limitations

The primary [Druid spellbook](https://wowforevertalent.com/abilities/druid/) was retrieved on 16 October 2026. It identifies its source as the **14 October 2026 Forever Beta book, client 1.60.1.70291** and contains **209 recorded ranks grouped into 60 class-specific identities**: 15 Balance, 30 Feral Combat, and 15 Restoration. Four additional General-tab identities bring the source inventory to 64 records and 213 tooltips. The page says all tooltips came from beta/demo data, with no Classic fallback and no name-only rows, but also says this is not an in-game check and may change before launch.

The linked [Druid talent reference](https://wowforevertalent.com/druid/reference/) identifies its data as the **8 October 2026 Forever export** (`beta-20261008-cc66e694`). Its nine active talents—Insect Swarm, Moonkin Form, Feral Charge, Shifting Power, Primal Bite, Berserk, Swiftmend, Nature's Swiftness, and Wild Growth—are all represented in the spellbook. It contributes talent placement and prerequisites, but no additional active identity.

The retrieved [changelog](https://wowforevertalent.com/changelog/) contains no post-14 October Druid ability update. Earlier entries corroborate Shifting Power's addition and Tiger's Fury's removal from the then-current books. One conflict remains: the 21 September entry says Mangle was added, while Mangle is absent from both the 14 October spellbook and 8 October talent reference. Mangle is therefore a separate unresolved CSV row, not a beta-confirmed ability.

The primary pages expose names, ranks, learn levels, acquisition notes, form requirements, and activation mechanics, but not numeric game spell IDs. Candidate IDs in the CSV are supplementary values from the repository's earlier audit inventories and remain unverified candidates. Blank ID cells are intentional. Neither source establishes readable successful-cast events in WoW Forever.

Source B is the actual `RPHelper.RegisterAbility` path in `RPHelper/Data/Abilities/Druid.lua`. It currently defines **55 canonical identities and 28 authored reactions**: 14 `say`, five `emote`, and nine `customemote`; **42 definitions have empty shipped pools**. The research does not change any definition or reaction.

## Reconciliation totals

The CSV retains all 64 beta source records, all 55 RPHelper definitions, and the changelog-only Mangle conflict. Moonfire maps to the existing historical `MOON_FIRE` spelling, and Teleport: Moonglade maps to `TELEPORT_MOONGLADE`; these display-name normalizations do not create extra identities. Primal Bite and Savage Bite remain separate rows. The result is **69 reconciled identities**.

| Classification | Identities | Authored reactions | Empty RPHelper definitions |
| --- | ---: | ---: | ---: |
| Confirmed, existing | 51 | 26 | 39 |
| Confirmed, missing | 12 | 0 | 0 |
| Not found in beta | 3 | 2 | 2 |
| Rename/replacement candidate | 2 | 0 | 1 |
| Unresolved | 1 | 0 | 0 |
| **Total** | **69** | **28** | **42** |

Beta presence, activation eligibility, and v1 scope are separate:

- The beta has 60 class-specific and four General-tab identities.
- Of the 60 class identities, **58 are directly player activated**. Omen of Clarity and Feline Grace are passive.
- All four General entries remain evidence but are out of v1 class-catalogue scope. Attack remains recorded as active; Armor Proficiency, Dodge, and Languages remain passive.
- The 58 v1-eligible active identities comprise **50 confirmed existing**, **seven confirmed missing**, and **Primal Bite as one rename/replacement candidate**.

## Confirmed existing coverage

The 51 exact or normalized identity matches are:

Abolish Poison; Barkskin; Bash; Berserk; Cat Form; Challenging Roar; Claw; Cower; Cure Poison; Dash; Demoralizing Roar; Dire Bear Form; Enrage; Entangling Roots; Faerie Fire; Feral Charge; Ferocious Bite; Frenzied Regeneration; Gift of the Wild; Healing Touch; Hibernate; Hurricane; Innervate; Insect Swarm; Mark of the Wild; Maul; Moonkin Form; Moonfire; Nature's Grasp; Nature's Swiftness; Omen of Clarity; Pounce; Prowl; Rake; Ravage; Rebirth; Regrowth; Rejuvenation; Remove Curse; Rip; Shred; Soothe Animal; Starfire; Swiftmend; Swipe; Teleport: Moonglade; Thorns; Track Humanoids; Tranquility; Travel Form; Wrath.

These identities account for 26 reactions and 39 empty pools. Important distinctions include:

- **Nature's Grasp** is now a trainable Balance spell with six ranks beginning at level 10; it is absent from the talent tree. Its existing empty canonical identity can be retained without assuming runtime detection.
- **Omen of Clarity** is also now trainable at level 20 and absent from the talent tree, but its spellbook metadata says Passive. It is beta-confirmed and existing, yet outside direct-activation scope.
- **Berserk** is already an empty RPHelper identity and is an active Feral capstone requiring Cat, Bear, or Dire Bear Form.
- **Moonfire** is treated as the existing `MOON_FIRE` identity, not an automatic canonical-key rename.
- Maul's “Next melee” behavior, channels, shapeshifts, stealth/openers, and form-restricted attacks remain event-verification concerns even when beta-confirmed.

## Confirmed missing

Seven beta-confirmed, directly activated class abilities are absent from RPHelper:

- **Aquatic Form** and **Bear Form** — direct shapeshifts. Their form enums already exist, but that is not an ability registration.
- **Growl** and **Lacerate** — Bear/Dire Bear abilities; Lacerate has three recorded ranks at levels 42, 50, and 58.
- **Revive** — a five-rank, out-of-combat resurrection cast distinct from Rebirth.
- **Shifting Power** — an active Cat-form talent at Feral row 4, requiring Shredding Attacks.
- **Wild Growth** — an active Restoration capstone with three recorded ranks.

**Feline Grace** is the eighth class-specific missing identity but is explicitly Passive and should not be proposed as an active ability. The four other missing rows—Attack, Armor Proficiency, Dodge, and Languages—are General-tab evidence and out of v1 scope.

## Rename and replacement candidate

**Primal Bite** is a beta-confirmed active Bear/Dire Bear talent with four ranks. RPHelper instead has the empty historical identity `SAVAGE_BITE`, which is absent from the beta sources. The names and bear-bite theme make them a possible succession pair, but the evidence does not establish identity equivalence, persistence compatibility, or permission to rename. Both remain separate rows pending an explicit owner decision.

No content transfer is involved today because Savage Bite's shipped pool is empty, but user-authored content and saved settings could still exist under the historical key.

## Legacy and unresolved candidates

- **Faerie Fire (Feral)** is an empty legacy definition absent from the spellbook. The beta has Faerie Fire, but its tooltip does not establish that the separate historical Feral identity survives; do not merge the keys automatically.
- **Tiger's Fury** is absent from the current spellbook and retains two reactions. The 2 October changelog explicitly says it was removed from the then-current books. Preserve its content until archival/removal is approved.
- **Tree of Life Form** is an empty legacy definition absent from both current beta sources. Absence is not proof of permanent removal.
- **Mangle** is unresolved: an earlier changelog says it was added, but neither current source contains it. Later beta/client evidence is required before proposing an identity.

## Form-specific architecture considerations

The ability catalogue and form reaction pools are separate systems:

- `RPHelper/Data/Abilities/Druid.lua` contains ability-triggered reactions.
- `RPHelper/Data/Classes/Druid.lua` contains 32 form-specific contextual reactions: 11 Cat, 11 Bear, and 10 Moonkin. Dire Bear intentionally shares the Bear pool.
- `RPHelper/Core/DruidForms.lua` recognizes Cat, Bear, Dire Bear, Moonkin, Travel, and Aquatic forms, plus Humanoid and Unknown. Recognition of a form does not create a corresponding ability identity.

No form-pool content should be duplicated into Cat Form, Bear Form, Dire Bear Form, Moonkin Form, Travel Form, or Aquatic Form ability pools. Form pools respond to contextual triggers such as entering combat, critical hits, dodges, damage, and leaving combat; an ability pool would respond to a successful activation and has different semantics.

By default, candidate preparation suppresses `say` output whenever a Druid is in any recognized non-humanoid form or the form is unreadable/unknown. Emotes and custom emotes remain eligible. This applies uniformly to ability content, but does not prove when the post-cast form becomes readable relative to a shapeshift success event. Existing tests use synthetic detection only; production has no verified Druid spell-ID mapping. Form changes, queued Maul, Prowl/openers, and form-restricted abilities all require in-client event and timing checks before detection work.

## Owner decisions recorded

The implementation approval resolved the catalogue decisions below. The owner
explicitly excluded Mangle from this implementation; no further Mangle research
is required for this milestone. Runtime-detection questions remain deferred, and
no form identity, form-content, or suppression behavior changes were approved.

## Approved implementation disposition

The owner approved the following catalogue-only disposition after this research:

- Retain the 50 beta-confirmed active identities already present and add empty definitions for Aquatic Form, Bear Form, Growl, Lacerate, Revive, and Wild Growth.
- Replace the empty historical `SAVAGE_BITE` identity with empty `PRIMAL_BITE`, with an idempotent saved-data migration for exact Druid ability scopes, settings, and disabled-default references.
- Remove passive Omen of Clarity from the active catalogue and leave passive Feline Grace absent.
- Replace `TIGERS_FURY` with `SHIFTING_POWER`, retaining its emote and custom-emote reactions unchanged and in order. Migrate exact Druid user content, settings, and disabled-default references; do not create an archive.
- Remove the empty Faerie Fire (Feral) and Tree of Life Form definitions without deleting player-owned saved records. Keep Mangle absent by owner decision and keep all General-tab identities out of v1 scope.

The resulting active Druid catalogue has **58 unique identities**, of which **45 have empty shipped reaction pools**. The active catalogue retains 28 authored reactions, including the two inherited by Shifting Power. Their roar wording may not describe Shifting Power's actual mechanics and requires manual content review; it is intentionally unchanged in this task. This approval does not authorize form-content duplication, shapeshift changes, spell-ID mappings, detection work, or other authored reaction changes.

The row-level ranks, learn levels, candidate IDs, acquisition notes, activation/form mechanics, evidence, reaction counts, scope, and provisional dispositions are in [the Druid reconciliation CSV](druid_beta_reconciliation.csv).
