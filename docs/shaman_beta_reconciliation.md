# Shaman beta ability reconciliation

Research snapshot only. This report does not authorize catalogue, spell-ID, detection, settings, or content changes.

## Sources and limits

The primary [Shaman spellbook](https://wowforevertalent.com/abilities/shaman/) was retrieved on 16 October 2026. The page identifies its source as the **14 October 2026 Forever Beta book, client 1.60.1.70291** and contains **181 recorded ranks grouped into 56 class-spellbook identities**, plus **five General-tab identities**. All 186 tooltips say they came from the beta or demo data; none falls back to a Classic tooltip and none is name-only. The site expressly says this is not an in-game check and may change before launch.

The separate [Shaman talent reference](https://wowforevertalent.com/shaman/reference/) identifies its data as the **8 October 2026 Forever export** (`beta-20261008-cc66e694`). Its seven active talents—Lava Burst, Stormstrike, Rage of the Farseer, Water Shield, Mana Tide Totem, Nature's Swiftness, and Riptide—are all already represented in the spellbook. No active talent ability was found only in the calculator.

The primary pages provide names, recorded ranks, learn levels, tooltip mechanics, and explicit talent acquisition notes, but do **not** expose numeric game spell IDs. Candidate IDs in the CSV therefore come from the repository's earlier research inventories and remain unverified candidates; blank cells are intentional. An empty acquisition field on the source is recorded as “Not stated by source,” not assumed to mean trainer-learned.

Source B is the actual registration path in `RPHelper/Data/Abilities/Shaman.lua`: each `add(...)` call registers one authored reaction through `RPHelper.RegisterAbility`, while the final direct registrations establish definitions with empty shipped pools. It contains **60 canonical definitions and 230 reactions**: 161 `say`, 0 `emote`, and 69 `customemote`; six definitions have empty pools.

## Totals

The CSV retains one row for each identity in the union of all **61 beta source records** and all 60 RPHelper definitions. Fire Nova and Fire Nova Totem remain separate identities, producing **73 reconciled rows**. Research retention is broader than v1 catalogue scope.

| Classification | Identities | Authored reactions | Empty RPHelper definitions |
| --- | ---: | ---: | ---: |
| Confirmed, existing | 48 | 186 | 4 |
| Confirmed, missing | 12 | 0 | 0 |
| Not found in beta | 11 | 42 | 2 |
| Rename/replacement candidate | 2 | 2 | 0 |
| **Total** | **73** | **230** | **6** |

The three relevant dimensions are independent:

- **Beta presence:** 56 class-tab identities and five General-tab identities are present in the retrieved source.
- **Activation eligibility:** of the 56 class identities, **55 require direct player activation**. Reincarnation is beta-confirmed but labelled Passive, so it is outside direct-activation eligibility. Attack remains correctly recorded as directly activated; the other four General entries are passive.
- **V1 inclusion scope:** all five General-tab identities are excluded by product policy regardless of activation mechanics. The resulting v1-eligible Shaman beta catalogue therefore contains **55 identities**, including Fire Nova.

Within those 55 v1-eligible identities, 47 are confirmed existing in RPHelper, **seven are confirmed missing**, and Fire Nova is the separate replacement candidate. “Confirmed” describes beta identity evidence, not runtime detectability, v1 scope, or approval to add it.

## Confirmed, existing

The 48 exact-name matches are:

Ancestral Spirit; Astral Recall; Chain Heal; Chain Lightning; Cure Disease; Cure Poison; Disease Cleansing Totem; Earthbind Totem; Earth Shock; Far Sight; Fire Resistance Totem; Flametongue Totem; Flametongue Weapon; Flame Shock; Frostbrand Weapon; Frost Resistance Totem; Frost Shock; Ghost Wolf; Grace of Air Totem; Grounding Totem; Healing Stream Totem; Healing Wave; Lesser Healing Wave; Lightning Bolt; Lightning Shield; Magma Totem; Mana Spring Totem; Mana Tide Totem; Nature's Swiftness; Nature Resistance Totem; Poison Cleansing Totem; Purge; Reincarnation; Rockbiter Weapon; Searing Totem; Sentry Totem; Stoneclaw Totem; Stoneskin Totem; Stormstrike; Strength of Earth Totem; Totemic Recall; Tremor Totem; Water Breathing; Water Shield; Water Walking; Windfury Totem; Windfury Weapon; Windwall Totem.

Important status distinctions:

- **Ancestral Spirit** is an eligible 10-second cast with five recorded ranks and six authored reactions.
- **Astral Recall** is an eligible 10-second cast with a 15-minute cooldown, but its existing definition has an empty content pool.
- Far Sight, Water Breathing, and Water Walking are also confirmed active definitions with empty pools. Empty content is a coverage fact, not an eligibility failure.
- **Reincarnation** exists in both sources and has four historical reactions, but the beta labels it Passive. Its presence and content do not make it eligible for direct-activation handling.
- Totem placement spells are direct player activations and are eligible identities. Their autonomous pulses, attacks, cleansing attempts, or other totem effects are not separate player activations.
- Lightning Shield and Water Shield are eligible when the player casts the shield. Their later reactive charges/procs are not additional catalogue activations.

## Confirmed, missing

Seven v1-eligible, class-specific beta abilities lack RPHelper definitions:

- Call of the Ancestors, Call of the Elements, and Call of the Spirits: three-second casts that deploy saved Totem Bar sets.
- Lava Burst, Rage of the Farseer, and Riptide: talent-granted active abilities.
- Totemic Projection: an instant spell that relocates active totems.

The five General-tab records are retained in the research inventory but are out of v1 class-catalogue scope. Attack remains recorded as directly player-activated; Armor Proficiency, Block, Dodge, and Languages remain recorded as passive. All five remain “Confirmed, missing” at the identity layer because beta presence, activation eligibility, and v1 inclusion scope answer different questions.

## Possible rename or replacement

**Fire Nova** and **Fire Nova Totem** are deliberately separate rows and both are classified as rename/replacement candidates. The beta spell is an instant, 30-yard activated spell with a 10-second cooldown that damages enemies around an already active Fire totem. RPHelper instead contains Fire Nova Totem with two reactions. These are mechanically different activations, so neither the canonical key nor its authored reactions should be transferred automatically.

No other similar name was treated as an identity match without direct evidence.

## Legacy-only candidates

Eleven RPHelper definitions were not found in the retrieved beta spellbook:

Bloodlust; Calm Elements; Earthshaker Slam; Earth Shield; Elemental Focus; Elemental Mastery; Feral Spirit; Hex; Lightning Strike; Spirit Link; Totemic Slam.

Together they preserve 42 authored reactions. Elemental Focus and Elemental Mastery have empty pools. Absence from this beta reference is provisional rather than proof of permanent removal.

- **Hex** has three authored reactions but is absent from both the spellbook and the active-talent reference.
- **Feral Spirit** is absent; no Shaman pet-summon or pet-command record appears in the retrieved beta sources. Historical reactions must remain recoverable pending review.
- Elemental Focus appears in the talent reference only as a passive proc talent, not an active spellbook entry. This supports ineligibility for direct activation but does not authorize deleting its historical definition.
- Bloodlust, Earth Shield, Spirit Link, and the other apparent removals have no exact beta row or demonstrated successor in these sources. Similar themes or mechanics are not sufficient to transfer content.

## Unresolved review points

- Candidate numeric IDs are supplementary research, not values retrieved from the 14 October spellbook and not verified `UNIT_SPELLCAST_SUCCEEDED` payloads.
- The source does not state acquisition for ordinary spellbook rows. Only talent-granted rows are positively labelled; baseline versus trainer acquisition remains unstated.
- General Attack is visibly player-controlled but is excluded from v1 because it appears on the General tab. A future explicit exception would still require catalogue-ownership and event-behavior review.
- Far Sight, channels/casts, totem-set calls, totem relocation, weapon imbues, self-resurrection, and target-dependent spells still need in-client activation and restricted-value testing.
- No separate pet attacks, totem pulses, proc effects, or passive talent effects were promoted to direct player abilities. No similar names were merged.

## Preservation guidance

All 230 existing reactions and all six empty definitions should remain recoverable until individual implementation decisions are approved. In particular, do not migrate Fire Nova Totem content to Fire Nova, discard Hex/Feral Spirit/Bloodlust content because of beta absence, or treat Reincarnation/proc content as ordinary direct activations. Adding a confirmed missing identity, accepting candidate IDs, and authoring reactions are three separate decisions.

The practical row-level evidence, rank coverage, candidate IDs, acquisition notes, activation summaries, eligibility, content counts, and proposed dispositions are in [the reconciliation CSV](shaman_beta_reconciliation.csv).
