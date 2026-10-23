# WoW Forever ability coverage audit

Research snapshot: 2026-10-11. Branch: `research/forever-ability-coverage`.
Research only; no catalogue, authored content, production mappings, runtime, defaults or SavedVariables changes. A subsequent owner-authorized test correction aligns Banish expectations with its intentional custom-emote content type.

> **Status:** This October 11, 2026 audit remains valuable supporting research,
> but its merged-source inventory is neither a definitive Forever beta spellbook
> nor an implementation allowlist. The [Forever ability reconciliation](../forever_ability_reconciliation.md)
> specification now defines the Milestone 2B methodology. The original findings,
> counts, classifications and comparison CSV remain intact.

## Finding and scope

**No genuinely official, complete, versioned catalogue of all learnable Forever player abilities and their spell IDs was established.** Blizzard's Forever class previews provide the strongest evidence for specific identities, changes and removals. Community client extracts provide the broadest numerical coverage, but retain effects, obsolete records and SoD-labelled entries. Their union is a review inventory, not an official spellbook or a production allowlist.

The comparison loads the current nine class catalogues through the actual registration functions and checks every canonical pair against the merged [historical reconciliation inventory](ability_catalogue_reconciliation_inventory.csv). It includes **465 canonical abilities, 842 authored reactions, 298 nonempty pools and 167 empty pools**. Empty definitions, authored reactions and runtime mappings are separate coverage dimensions. Only Paladin Flash of Light `19750` and Seal of Righteousness `20288` currently have production mappings.

Baseline abilities and talent-granted identities are included, including passive talents and abilities outside current detection scope. Ranks are grouped by class and normalized English name; distinct forms and genuinely differently named variants remain separate. Cross-name equivalence requires an explicit reviewed alias candidate. The CSV also retains racial, pet, item/set and ambiguous special records so filtering does not silently erase difficult cases. No exhaustive player-learnable denominator can be justified from these sources.
The [comparison CSV](forever_ability_coverage_inventory.csv) has **1,434 rows**. Among the 465 existing definitions: **394 Covered, 6 Rename/alias candidates, 8 Orphan candidates and 57 Unresolved**. Additional class records include **120 officially named missing identities**, of which **38 are ordinary active candidates**; the remainder include forms, channels, passive/proc talents and unresolved mechanics. These are catalogue gaps, not approved automatic triggers.

## Source assessment

| Source | Provenance/version | Coverage and limitations |
| --- | --- | --- |
| [Blizzard Hunter/Druid](https://news.blizzard.com/en-us/article/24301515), [Priest/Warrior](https://news.blizzard.com/en-us/article/24301514) | Official developer articles, September 30, 2026; no numeric client build attached | Authoritative named changes and selected baseline/talent abilities; incomplete rank lists and no numerical spell IDs. Some changes were explicitly scheduled for a subsequent build. |
| [Blizzard Mage/Shaman](https://news.blizzard.com/en-us/article/24302097), [Rogue/Warlock](https://news.blizzard.com/en-us/article/24310968) | Official October 7, 2026 previews; beta subject to change | Named spells, passive talents, replacements and removals; not complete spellbooks. |
| [Blizzard deep-dive recap](https://worldofwarcraft.blizzard.com/en-us/news/24303313) | Official announcement-era design article, September 2026 | Paladin examples and racial design; selective, earlier than current beta, no rank IDs. |
| [Blizzard development notes](https://us.forums.blizzard.com/en/wow/t/wow-forever-beta-development-notes-%E2%80%93-updated-october-8/2360696) | Official, evolving September–October 8 thread | Changes/known issues override older previews when explicit. Visibility of a SoD rune ability was a bug: retained data is insufficient availability evidence. |
| [Daybreak](https://daybreakforever.com/), [JSON](https://daybreakforever.com/static/forever/datamine.json) | Guild-maintained, explicitly unofficial client datamine; `1.60.1.70338`, generated `2026-10-10 05:12 UTC`, comparison baseline `1.15.9.69722` | 1,282 new/changed class-linked spell records and 243 curated ability/effect records in the examined snapshot. Supplies names, numerical IDs, rank/cast fields and source categories; not a complete baseline spellbook. Includes items, set bonuses, helper effects and unfinished data. |
| [ForeverDB](https://foreverdb.net/), [class JSON](https://foreverdb.net/data/classes.json), [spell JSON](https://foreverdb.net/data/spells.json) | Unofficial local-client extraction; raw examined index has 31,849 records; class JSON refreshed October 11 and matches the earlier research snapshot | Nine classes, 560 ability groups and 466 talent nodes before semantic grouping. Trainer/quest/talent/SoD provenance useful. Current site and cached spell pages disagree on build labels (70291/70338); JSON itself is not independently version-pinned. Raw spells include NPC, item, pet, aura, effect and obsolete data. Talent node/entry IDs are not spell IDs. |
| [Warcraft Forever spell table](https://warcraftforever.games/spells) | Community class/trainer table; reused October 11 research snapshot, 2,473 embedded rows; exact build unspecified | Numerical IDs, levels/ranks and `trained`/`verified` fields. These fields do not establish readable player success events. Untrained rows include old talents, racial records and effects. Zero-ID placeholders excluded from candidate IDs. |
| [The Forever Era](https://theforeverera.com/en/changes/) | Community beta comparisons, some pages build 70245 | Supplemental removal reports. A talent disappearing from a tree can mean baseline promotion rather than ability removal; class-line absence alone is not conclusive. |
| [Atraeau API export](https://atraeau.github.io/WoW-Addons/api.json) and [spellbook definitions](https://github.com/Atraeau/WoW-Addons/blob/main/docs/api/Spells-Auras-Talents/C_SpellBook.md) | Third-party export of Forever API, build 70170/interface 16001, October 1 | Interface/event surface, not a catalogue of learned abilities or numerical spell IDs. Registration, readable fields and delivery require client verification. |
| [LibClassicSwingTimerAPI observations](https://github.com/Ralgathor/LibClassicSwingTimerAPI/blob/main/docs/FOREVER_API_FINDINGS.md) | Addon author's documented Forever observations | Five previously identified exact catalogue IDs with player success-event observations; not comprehensive rank coverage or our own live testing. |
| [Original Turtle addon](https://github.com/Wiubiki/RPhelper_twow/blob/main/localization.lua) | Historical content/naming lineage | Useful canonical names and legacy categories; does not verify Forever existence, learnability or IDs. |

Other investigated community indexes, [60.tools](https://www.60.tools/spells) and [WoW Handbook](https://wowhandbook.com/spellbook/), advertise different curated totals/builds (245 records/build 70245 and 403 spells/build 69977 respectively). They do not supersede current client-linked data or establish a complete official catalogue. Generic retail class pages and non-Forever spell databases were not used to verify Forever IDs.

The strongest practical catalogue is therefore **official named changes plus community class/trainer/talent groups, followed by actual learned-spell verification**. Multiple community sites may share extracted data; agreement does not imply independent observation. Direct Blizzard News mirrors were readable where the main site's article URLs returned 403; search index publication labels sometimes incorrectly say “last year,” so article dates and build metadata are kept separate.

## Classification and CSV contract

| Classification | Meaning |
| --- | --- |
| Covered | A matching current canonical identity has official or community class/trainer/talent evidence. Confidence explicitly identifies which. This does not assert all listed IDs are castable. |
| Missing | An officially named class identity has no matching canonical key or reviewed alias. May be passive, a channel or a form; not automatically suitable for reactions. |
| Rename/alias candidate | Explicit spelling or semantic relationship requiring review; no migration is implied. |
| Orphan candidate | Explicit official or community removal/replacement report conflicts with a retained canonical entry. Confirm the current client and preserve content before considering removal. |
| Unresolved | Uncorroborated/retained-only records, ambiguous activation, conflicting identity or no adequate match. Absence from these sources is not proof of removal. |

`scope` separates class identities from racial, racial-associated class records, pets, item/set effects and ambiguous special records. Every existing canonical key occurs exactly once even if its eventual scope is racial. The full CSV classifications apply to research records, not unique proven learnable abilities.

`existence_confidence`, `id_confidence`, `availability_evidence` and `detection_status` are deliberately separate. `candidate_spell_ids` is a union of positive source IDs for that named family, **including unverified client variants**. `rank_source_records` preserves each source's rank/level labels; `id_roles` distinguishes trainer candidates, talent IDs, untrained records and possible aura/proc/trigger/helper variants. A role marked unresolved has not been resolved into a player-cast ID. `ambiguous_raw_ids` holds raw same-name matches excluded from the candidate family; these can be NPC or obsolete IDs. `prior_success_event_ids` preserves narrower earlier observation evidence without promoting other ranks. Source URLs and origin tags allow lookup of each exact class/name/ID in the public datasets.

An empty ID field means no qualifying class-linked numerical evidence, not absence of the ability. Empty content counts on additional rows mean RPHelper has no matching definition/pool; canonical empty pools also have zero counts. `mechanism_basis` identifies historical categories, official descriptions or inference; unresolved talent mechanics should not be treated as active abilities.

## Per-class coverage

Existing columns sum to the current canonical count. Missing/other unresolved columns cover additional class records only, excluding special scopes. They are not percentages of a complete Forever spellbook.

| Class | Canonical | Covered | Alias | Orphan | Unresolved existing | Reactions | Official missing identities | Other unresolved class records |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Druid | 55 | 52 | 0 | 0 | 3 | 28 | 7 | 78 |
| Hunter | 49 | 46 | 0 | 0 | 3 | 155 | 15 | 76 |
| Mage | 54 | 52 | 0 | 1 | 1 | 134 | 14 | 58 |
| Paladin | 53 | 46 | 1 | 2 | 4 | 103 | 19 | 70 |
| Priest | 44 | 36 | 0 | 1 | 7 | 111 | 17 | 58 |
| Rogue | 49 | 32 | 1 | 0 | 16 | 4 | 12 | 50 |
| Shaman | 60 | 49 | 0 | 2 | 9 | 230 | 14 | 56 |
| Warlock | 58 | 45 | 4 | 2 | 7 | 56 | 11 | 69 |
| Warrior | 43 | 36 | 0 | 0 | 7 | 21 | 11 | 61 |
| **Total** | **465** | **394** | **6** | **8** | **57** | **842** | **120** | **576** |

## Officially named gaps

The following lists enumerate the CSV’s Missing class identities. Passive/modifier identities remain in the comparison; catalogue completeness does not justify a trigger for their automatic effects. Each list links to its official identity evidence. Numerical candidates and rank labels are in the corresponding CSV rows.

- **[Druid](https://news.blizzard.com/en-us/article/24301515):** Bear Form; Growl; Lacerate; Primal Bite; Revive; Shifting Power; Wild Growth.

- **[Hunter](https://news.blizzard.com/en-us/article/24301515):** Careful Aim; Deadly Aspects; Focused Fire; Improved Tracking; Intimidation; Lacerating Strikes; Lone Wolf; Predator's Edge; Rapid Killing; Rapid Recuperation; Resourcefulness; Sniper Shot; Strider Kick; Summon Hawk; Survival Tactics.

- **[Mage](https://news.blizzard.com/en-us/article/24302097):** Arcane Blast; Arcane Geometry; Arcane Impact; Arcane Shielding; Comprehend Scroll; Fingers of Frost; Frostfire Bolt; Heating Up; Ice Lance; Ignite; Impact; Improved Channeling; Missile Barrage; Wake of Fire.

- **[Paladin](https://news.blizzard.com/en-us/article/24303313):** Champion of the Light; Consecrated Ground; Holy Strike; Improved Holy Strike; Improved Seal of Fury; Infusion of Light; Instrument of the Law; Iron Creed; Light's Vigil; Reckoning; Reverence; Sacred Arbiter; Seal of Fury; Shield Specialization; Swift Judgment; Templar's Bulwark; Twist of Light; Vindication; Voice of Truth.

- **[Priest](https://news.blizzard.com/en-us/article/24301514):** Binding Heal; Devouring Contagion; Devouring Plague; Divine Aegis; Early Demise; Fear Ward; Holy Precision; Improved Mind Flay; Litany of Light; Penance; Power in Light; Prayer of Mending; Renewed Hope; Shadow Word: Death; Soul Warding; Twilight Focus; Twin Disciplines.

- **[Rogue](https://news.blizzard.com/en-us/article/24310968):** Cutthroat; Dirty Tricks; Flawless Execution; Hack and Slash; Improved Distract; Mutilate; Puncturing Wounds; Quietus; Seal Fate; Thousand Cuts; Venom; Vigor.

- **[Shaman](https://news.blizzard.com/en-us/article/24302097):** Call of Thunder; Call of the Ancestors; Call of the Elements; Call of the Spirits; Earthbound; Elemental Alacrity; Fire Nova; Improved Fire Nova; Lava Burst; Maelstrom Weapon; Mindfulness; Rage of the Farseer; Riptide; Totemic Projection.

- **[Warlock](https://news.blizzard.com/en-us/article/24310968):** Bane of Havoc; Demonic Aegis; Demonic Brand; Demonic Energies; Demonic Knowledge; Demonic Pact; Fel Vitality; Incinerate; Pandemic; Soul Harvest; Wrack.

- **[Warrior](https://news.blizzard.com/en-us/article/24301514):** Bastion; Bloodthrill; Focused Rage; Master of Defense; Raging Blows; Spearing Strike; Tactical Mastery; Taunt; Vanguard; Victory Rush; Weaponmaster.

Important scope corrections:

- **Fear Ward and Devouring Plague are now universal Priest abilities**, according to Blizzard, so their prior exclusion as historical racials is no longer a valid Forever justification. Their numerical candidates remain community-derived. Chastise and the other Priest racial spells stay race-restricted.
- **Fire Nova replaces Fire Nova Totem** with a different activation. Do not automatically redirect totem-creation content to the replacement. Tranquil Air Totem is officially removed but has no current canonical entry; its data is not an additional supported gap.
- Talent promotion is not removal: Divine Spirit, Blessing of Kings, Aimed Shot, Nature's Grasp and Omen of Clarity remain existing covered identities despite talent-tree changes.
- Hunter pet training entries are not player casts of the pet's attack. Preserve player commands such as Call Pet, Feed Pet, Revive Pet, Dismiss Pet and Tame Beast as research candidates; do not merge them with pet-owned abilities.

## Orphans and identity review

| CSV row | Class/key | Evidence | Recommended review |
| --- | --- | --- | --- |
| F0321 | MAGE / `DETECT_MAGIC` → Detect Magic | [moderate: community removal report](ability_catalogue_reconciliation_inventory.csv) | Review current-client absence/replacement and existing sayings; do not remove automatically. |
| F0416 | PALADIN / `BLESSING_OF_SANCTUARY` → Blessing of Sanctuary | [moderate: community removal report](ability_catalogue_reconciliation_inventory.csv) | Review current-client absence/replacement and existing sayings; do not remove automatically. |
| F0487 | PALADIN / `JUDGEMENT` → Judgement | [moderate: explicit semantic alias candidate](https://daybreakforever.com/static/forever/datamine.json) | Review semantic/content equivalence; do not migrate or alias automatically. |
| F0516 | PALADIN / `SANCTITY_AURA` → Sanctity Aura | [moderate: community removal report](https://foreverdb.net/data/spells.json) | Review current-client absence/replacement and existing sayings; do not remove automatically. |
| F0600 | PRIEST / `LIGHTWELL` → Lightwell | [high: official removal statement](https://news.blizzard.com/en-us/article/24301514) | Review current-client absence/replacement and existing sayings; do not remove automatically. |
| F0672 | ROGUE / `BLADE_FURY` → Blade Flurry | [moderate: explicit semantic alias candidate](https://foreverdb.net/data/classes.json) | Review semantic/content equivalence; do not migrate or alias automatically. |
| F0806 | SHAMAN / `ELEMENTAL_MASTERY` → Elemental Mastery | [high: official removal statement](https://news.blizzard.com/en-us/article/24302097) | Review current-client absence/replacement and existing sayings; do not remove automatically. |
| F0819 | SHAMAN / `FIRE_NOVA_TOTEM` → Fire Nova Totem | [high: official removal statement](https://news.blizzard.com/en-us/article/24302097) | Review current-client absence/replacement and existing sayings; do not remove automatically. |
| F0921 | WARLOCK / `CURSE_OF_AGONY` → Bane of Agony | [high: official rename identity; candidate IDs](https://news.blizzard.com/en-us/article/24310968) | Review semantic/content equivalence; do not migrate or alias automatically. |
| F0922 | WARLOCK / `CURSE_OF_DOOM` → Bane of Doom | [high: official rename identity; candidate IDs](https://news.blizzard.com/en-us/article/24310968) | Review semantic/content equivalence; do not migrate or alias automatically. |
| F0925 | WARLOCK / `CURSE_OF_SHADOW` → Curse of Shadow | [high: official removal statement](https://news.blizzard.com/en-us/article/24310968) | Review current-client absence/replacement and existing sayings; do not remove automatically. |
| F0933 | WARLOCK / `DARK_PACT` → Dark Pact | [high: official removal statement](https://news.blizzard.com/en-us/article/24310968) | Review current-client absence/replacement and existing sayings; do not remove automatically. |
| F0958 | WARLOCK / `ENSLAVE_DEMON` → Subjugate Demon | [moderate: explicit semantic alias candidate](https://foreverdb.net/data/classes.json) | Review semantic/content equivalence; do not migrate or alias automatically. |
| F0959 | WARLOCK / `EYE_OF_KILROGG` → Eye of Kilrogg | [moderate: explicit semantic alias candidate](https://foreverdb.net/data/classes.json) | Review semantic/content equivalence; do not migrate or alias automatically. |

Warlock Bane of Agony and Bane of Doom have official rename evidence. Subjugate Demon, Eyes of Kilrogg, Judgment and Rogue Blade Fury/Blade Flurry are explicit identity/spelling candidates with weaker or historical evidence. Priest `CHASTICE` is a historical spelling candidate for race-restricted Chastise and is retained as a racial unresolved row; do not convert it into a universal Priest ability.

Other unmatched historical entries, including Turtle-specific Champion spells, Aspect of the Wolf, Spirit Link and unusual Shaman attacks, remain Unresolved. Weapon attacks, poison application and mount variants may lack class-linked groups while having raw-name records; that is not a removal finding. Removed talents still present in untrained records likewise remain unresolved data, not supported new player abilities.

## Racial and special categories

The racial inventory includes the examined Daybreak racial records, including class-specific resource variants of Eureka!/Expansive Mind/Touch of the Grave, plus the twelve official Priest racial identities across six races. Multiple variants are deliberately not counted as separate canonical class abilities. Skyborne faction restrictions, actual learned variants and passive/active identity require client confirmation. Official [race/class design](https://worldofwarcraft.blizzard.com/en-us/news/24304075) and [deep-dive recap](https://worldofwarcraft.blizzard.com/en-us/news/24303313) take precedence over generic retail race pages.

Blizzard's Hunter article distinguishes pet-family attacks from player abilities. The CSV retains recognized pet names separately, but ambiguous training/trigger records still require review. Item/set entries are separately scoped even when they have a class label. Obsolete, NPC, hidden helper and automatic effect identities can appear in untrained records or raw-name matches. No row of these categories authorizes a player activation trigger. Passives/procs and automatic attacks belong to existence coverage but remain outside the ordinary-activation implementation scope.

## Spell-ID and rank findings
The CSV records **2,769 distinct positive candidate IDs** across all scopes; **404 of the 465 current canonical abilities** have class-linked candidate IDs. This is neither a verified-ID total nor an event-compatible coverage count. No new success-event ID was verified by this task.

| Identity | Representative candidates | Evidence/qualification |
| --- | --- | --- |
| Priest Fear Ward / Devouring Plague | `6346` / `2944;19276;19277;19278;19279;19280` | Official universal identities; community rank IDs. Old race restrictions must be rechecked. |
| Warrior Taunt / Spearing Strike | `355` / `1310222` | Official identities; class/talent numerical candidates, no new event capture. |
| Druid Revive / Lacerate | `437138;1237948;1237949;1237950;1237951` / `414644;1235826;1235827` | Official identities; retained/revised client variants. Select actual learned cast ID, not every same-name effect. |
| Mage Arcane Blast / Frostfire Bolt | `400574;1239696;1239697;1239699;1239700` / `401502;1237312;1237313` | Official Forever spells; prior expansion/SoD-looking numbers do not verify every variant. |
| Paladin Holy Strike | `678;679;680;1866;2495;5569;10332;10333` | Community class/rank records support candidates; original Turtle identity/numbers alone would be insufficient. |
| Rogue Mutilate | `399956;399960;399961;1241582;1241584;1241585;1241586;1241588;1241590;1310705;1310706;1310707` | Official activation; family includes potential separate hand/effect/variant IDs. Not a bulk mapping proposal. |
| Warlock Wrack | `1316697` | Official drain-style description, community Instant field. Neither alone establishes channel semantics; defer activation outcome classification. |

Actual pre-existing third-party player success observations remain limited to Flash of Light `19750`, Seal of Righteousness `20288`, Judgement `20271`, Holy Light `647` and queued Raptor Strike `2973`; see the [earlier ID audit](ability_spell_mapping_audit.md). Only the first two are already allowlisted. Capture evidence for one rank does not verify all other candidates or update previous confidence automatically.

Rank/variant limitations requiring review:

- Talent `id`, `e`, `df`, spell `sp` and trained rank IDs have different meanings. The inventory uses `sp`/spell rank arrays and `train` IDs, never talent node IDs as spell mappings. Repeated numerical IDs across talent point ranks represent scaling, not separate cast ranks.
- New/changed-only extracts omit unchanged ranks. A numbered sequence in one source is not a completeness guarantee. Rank labels and level requirements may disagree across sources; there is no inferred numeric ID range.
- Holy Light/Flash of Light instant helper variants, Mutilate hand effects, Penance damage/heal components, Bane of Doom Effect, trap effects and Lightning Bolt proc copies must not be accepted merely because their name matches. Per-ID role remains unresolved until a readable learned spell/event establishes it.
- **Call spell levels conflict:** Blizzard's October 7 article assigns Spirits to 30 and Ancestors to 40, while [ForeverDB Ancestors](https://foreverdb.net/spell/66843) assigns Ancestors to 30 and Spirits to 40. Preserve both identities/ID candidates; verify current learned names/levels instead of silently choosing a rank order.
- Older removed-rank lists can report missing Multi-Shot/Scorpid Sting spell rows while class-line rows survive. Official previews still discuss those abilities; do not remove a whole family from absence of particular records.

## Recommended next milestone

1. **Review canonical gaps before runtime expansion.** Start with officially named ordinary activations: universal Priest Fear Ward/Devouring Plague, Druid Growl/Revive, Warrior Taunt, and low-level Paladin Holy Strike/Seal of Fury. Their respective class articles/Paladin recap support identity proposals; numerical candidates require learned-spell capture. Adding an empty definition is a separate content decision, not a reason to enable detection.
2. **Review replacements and aliases independently.** Use the linked official Warlock rename/removal notes and Shaman replacement/removal notes; preserve authored text and user content. Review community-only removals against the current client. Do not migrate or delete automatically.
3. **Prefer content that already exists when expanding exact mappings.** Consider the previously observed Holy Light `647` and Judgement `20271` only after current-build capture and review of existing content/guards. Keep the current two-ID allowlist unchanged during this research.
4. **Validate active talent groups next.** Official Mage/Shaman/Rogue/Warlock/Hunter previews support identity groups, but high-level availability, ranks, variants and event delivery remain unverified. Defer channels, form transitions, queued attacks, automatic procs and pet-owned casts under the current [spellcasting contract](../spell_casting_api_audit.md).
5. **Keep catalogue coverage separate from reaction coverage.** Passive talents can remain documented without inventing output. Racial content belongs in a race or exceptional race/class layer. Use the [product philosophy](../product_spec.md) and [content contracts](../content_engine.md): simple event-driven flavour, conservative readable exact IDs, no polling, correlations, combat reconstruction or automatic full-catalogue activation.

## Live-client verification checklist

- Record client build/interface/date, class/race, level, talents and learned rank. Capture learned player spellbook IDs using supported readable interfaces outside combat; distinguish pet banks and nonlearned/future entries.
- Confirm baseline and talent learnability from a trainer/quest/current talent panel. Test rank upgrades, downgrades, overrides and race-specific mounts; document conflicting community IDs rather than guessing.
- For each proposed exact ordinary mapping, capture `UNIT_SPELLCAST_SUCCEEDED` with exact readable `player` and spell ID after safe secret inspection. Unsupported inspection/registration must fail closed. No preceding START/SENT requirement or hit/effect confirmation.
- Verify failed, cancelled and interrupted casts do not produce the proposed activation; test instant abilities separately. For pet commands/summons distinguish player's button execution from pet attacks.
- Capture repeat/duplicate behavior and unusual mechanics before proposing deduplication. Separate channels, shapeshifts, queued melee, reticles, passive procs and automatic attacks.
- Check official removals, baseline promotions and rename semantics in the current build; resolve Priest racial restrictions and the conflicting Call spell levels.
- Confirm existing settings/chance/cooldowns, shared encounter quota, out-of-combat eligibility, output routing and Druid speech restrictions when a later implementation is authorized. This audit does not alter generic combat triggers.
- Obtain high-level verification when available; beta level restrictions mean a data record for level 40/60 cannot substitute for observed learnability.

## Validation and snapshot identity

A temporary Lua inventory exporter and Python consistency checks (not production additions) verified all 465 unique canonical pairs against the merged reconciliation, all per-type reaction counts, 842 total reactions, positive candidate IDs, official references on Missing rows and source-linked numerical evidence. The report's tables and gap lists were generated from the CSV. All current definitions/content/mappings remain unchanged.

`lua tests/test_runtime.lua`: **79 passed**. `lua tests/test_content_engine.lua`: **96 passed** after an owner-authorized follow-up corrected the stale Banish test. The catalogue intentionally registers `customemote`; the regression now checks that both its registered pool and prepared candidate preserve this type, while retaining the required-target and substituted-text assertions. Syntax checks passed for all 41 Lua files under `RPHelper` and `tests`. Lua 5.5.1 is installed; Lua 5.1 is unavailable. Whitespace/staged-diff checks passed; review includes both new deliverables and the Banish test correction. No live Forever verification, commit or push.

The raw research downloads are temporary, not committed vendor data. These SHA-256 values identify the exact inspected numerical snapshots; mutable URLs may later return different data:

| Dataset | SHA-256 |
| --- | --- |
| rph-coverage-classes.json | `e4426ed94be45c9129571c2e98b5be5fab07fe7d0a9a95ce0c85a76366c99b9a` |
| rph-map-datamine.json | `4df938d4b49fb13875360462c7744b5d436b5aca70dd435ec77c5f86ee84dfd6` |
| rph-map-warcraft-rows.json | `e2c975f788482736a87a5f26dc8110de95afafe19efb255ff3f7a42e54d45fd5` |
| rph-map-fdb-spells.json | `bd1207cd33e2dc5e8edfa810e3f71c8014023d21423411142807d48e4032d0a4` |
