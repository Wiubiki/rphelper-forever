# Forever ability spell-ID mapping audit

Research snapshot: 2026-10-11. Branch: `research/ability-spell-mappings`.
Research only: no runtime, production mapping, authored content, settings or test changes.

## Result and interpretation

The existing catalogues contain **297 class/ability pairs and 841 authored reactions**. The companion [CSV inventory](ability_spell_mapping_inventory.csv) includes every pair, counts of `say`, `emote` and `customemote` entries, original names/categories, detection mechanisms, source-linked IDs/ranks, evidence and unresolved cases. Counts come from loading the actual content registration functions, rather than counting source comments.

Public Forever datasets establish **1,009 candidate ID associations, comprising 1,009 distinct positive IDs, across 275 abilities**. These are research candidates, not an approved production allowlist. Class-linked datasets include same-name helper spells, retained variants and effects. Five specific catalogue IDs have third-party player success-event evidence; four belong to ordinary activations and one to a deferred queued attack. No live-client testing was performed for this audit.

The overall classifications are **4 Verified, 236 Strong candidate, 21 Uncertain, 30 Unsupported and 6 Not found**. Classification is a recommendation for an ability family, not a blanket statement about every rank. ID evidence and trigger compatibility are separate CSV fields:

| Classification | Meaning in this audit |
| --- | --- |
| Verified | A specific readable player `UNIT_SPELLCAST_SUCCEEDED` ID is reported by a Forever addon author, and the ordinary activation fits the current adapter. Other listed ranks remain candidates. This is third-party evidence, not our own client verification. |
| Strong candidate | A class-linked Forever spell record supports the identity and ordinary activation is plausible; event delivery, readability and the actual learned variant still need verification. |
| Uncertain | There is conflicting, retained-only or ambiguous ID evidence, or activation semantics need examination. |
| Unsupported | Removed/replaced historical ability, or mechanism outside the current ordinary-activation scope. An ID can nevertheless have excellent evidence. |
| Not found | No corresponding player-class or exact-name client ID was found in the surveyed sources. This does not prove absence from Forever. |

### Coverage by class

| Class | Abilities | With candidate IDs | Verified | Strong candidate | Uncertain | Unsupported | Not found |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Druid | 13 | 13 | 0 | 10 | 0 | 3 | 0 |
| Hunter | 49 | 47 | 0 | 33 | 10 | 5 | 1 |
| Mage | 54 | 52 | 0 | 49 | 0 | 5 | 0 |
| Paladin | 49 | 43 | 4 | 39 | 3 | 2 | 1 |
| Priest | 37 | 37 | 0 | 32 | 0 | 5 | 0 |
| Rogue | 4 | 2 | 0 | 2 | 2 | 0 | 0 |
| Shaman | 54 | 45 | 0 | 42 | 5 | 3 | 4 |
| Warlock | 25 | 24 | 0 | 17 | 1 | 7 | 0 |
| Warrior | 12 | 12 | 0 | 12 | 0 | 0 | 0 |
| **Total** | **297** | **275** | **4** | **236** | **21** | **30** | **6** |

## Sources and method

The repository contracts are [the product specification](../product_spec.md), [the content engine](../content_engine.md), [the spellcasting audit](../spell_casting_api_audit.md) and the existing `RuntimeAPI.lua`/`Runtime.lua`. The production adapter currently permits only Paladin `19750` and `20288`, guards required event fields using secret inspection, accepts exact `player`, and routes semantic ability keys through existing runtime policies. The broader research inventory does not change that allowlist.

1. **Historical naming/category reference:** [RPhelper_twow localization.lua](https://github.com/Wiubiki/RPhelper_twow/blob/main/localization.lua). All catalogue keys were compared with its class-specific `SPELLS.casttime`, `instant`, `channeled` and `next_melee` definitions. These categories are historical evidence only: for example, it calls Spirit of Redemption an instant ability and Eagle Eye instant, although their mechanics need different treatment. Turtle additions are not Forever evidence. The sibling checkout was unavailable; the public reference was read only.
2. **Forever API export:** [Atraeau API export](https://atraeau.github.io/WoW-Addons/api.json), metadata version `1.60.1`, build **70170**, interface **16001**, exported 2026-10-01. It contains `UNIT_SPELLCAST_SUCCEEDED` and the modern `C_SpellBook` interfaces discussed below. Export presence proves the documented surface, not universal registration permission, delivered events or readable payloads.
3. **Client datamine:** [Daybreak data](https://daybreakforever.com/static/forever/datamine.json), exposed by its [abilities page](https://daybreakforever.com/abilities). Downloaded metadata: build **1.60.1.70338**, baseline **1.15.9.69722**, generated **2026-10-10 05:12 UTC**. `class_abilities.spells` contains 1,282 new/changed class-linked records, not the complete baseline spellbook. It supplies numerical IDs, names, ranks, cast fields and changes. An `Instant` cast field does not establish a non-channel or directly usable player spell.
4. **Full client index and class grouping:** [ForeverDB spell index](https://foreverdb.net/spells), [class data](https://foreverdb.net/data/classes.json), [raw spell data](https://foreverdb.net/data/spells.json). The downloaded site reports build **1.60.1.70338**, extracted 2026-10-11, with **31,849** spell records. Class groups supply rank IDs, trainer/talent/rune provenance. Raw name matches can be NPC, helper, obsolete or retained SoD records; their IDs appear only in `excluded_ambiguous_client_ids` when no accepted class-linked match supports them. SoD-labelled groups are not promoted on that source alone.
5. **Third-party character/trainer records:** [Warcraft Forever spell catalogue](https://warcraftforever.games/spells). Its embedded table contains **2,473** class-linked rows, with IDs, ranks, `trained`, `verified` and optional `seenInCombat` fields. An exact build is not established by the downloaded page. Trainer verification is useful corroboration, but neither `verified` nor `seenInCombat` establishes a readable player success-event payload. Zero-ID placeholder rows are rejected.
6. **Actual event observations:** [LibClassicSwingTimerAPI author's Forever findings](https://github.com/Ralgathor/LibClassicSwingTimerAPI/blob/main/docs/FOREVER_API_FINDINGS.md), especially §§4.3, 8.11 and the later Raptor Strike capture. These distinguish live observations from the author's datamine research. We use only explicitly identified catalogue IDs; another combatant's Rend and unknown item effects are excluded.
7. **Removal cross-checks:** The Forever Era's class change pages report [Detect Magic removed](https://theforeverera.com/en/spells/mage/detect-magic/), [Blessing of Sanctuary removed](https://theforeverera.com/en/spells/paladin/blessing-of-sanctuary/), [Sanctity Aura removed](https://theforeverera.com/en/spells/paladin/sanctity-aura/) and [Curse of Shadow removed](https://theforeverera.com/en/spells/warlock/curse-of-shadow/). These are third-party reports, some from older beta builds; recheck against the live build rather than treating historical absence as permanent.

Downloads are a dated snapshot of mutable public sources, not independent confirmation of Blizzard's database or of learned abilities. Search results/pages sometimes retain build 70245 while current downloadable datasets report 70338. The API export remains 70170. These versions are deliberately not presented as one synchronized release.

Every ability was searched using exact class plus normalized English name (punctuation/spacing normalization only). Three explicit historical rename candidates were investigated separately. The full client index was also searched for unmatched historical names. No retail, Classic or Turtle spell ID was imported merely because its number looks familiar. No substring matching, target inference or timing correlation was used.

## Specific IDs and rank/variant limitations

| Class/key | ID with player event evidence | Evidence and recommendation |
| --- | ---: | --- |
| PALADIN / FLASH_OF_LIGHT | 19750 | Author §4.3 reports readable success; already in production. Other ranks and same-name helpers are not thereby approved. |
| PALADIN / SEAL_OF_RIGHTEOUSNESS | 20288 | Same Paladin observation; already in production. Source disagreement includes 20154 versus 21084 and additional ranks. |
| PALADIN / JUDGEMENT | 20271 | Readable instant success reported; a narrow future mapping candidate. Do not equate the subsequent seal damage effect with the activation. |
| PALADIN / HOLY_LIGHT | 647 | §8.11 reports START plus SUCCEEDED for this rank and an interrupted cast without success. A narrow future mapping candidate; no preceding START should be required. |
| HUNTER / RAPTOR_STRIKE | 2973 | Later report captures success at queued attack consumption. ID evidence is strong, but queued-melee semantics remain outside the current implementation scope. |

Examples of class-linked **candidates**, not additional verified events: Warrior Charge `100;6178;11578`, Mage Fireball `133;143;145;3140;8400;8401;8402;10148;10149;10150;10151;25306`, and Shaman Water Shield `408510`. The CSV supplies the complete candidate/rank list for every ability and the contributing sources for each ID.

Rank coverage must not be inferred from the first/last number or from an API's base ID. Some datasets omit unchanged ranks; others retain effects alongside castable spells. Examples:

- Flash of Light also has Daybreak-only IDs `1313342`–`1313346`; `1313342` describes an instant heal for 1 with unrestricted range. Holy Light has similarly suspicious helper records, including `19968` and `1313348`–`1313352`. These remain explicitly unverified variants, not ordinary cast ranks ready for production.
- Raptor Strike has the historical `2973` rank family and a trainer-labelled `409691` family in another source. Which family a current learned spell emits, and whether either is queued or direct, requires capture. The name alone cannot resolve this conflict.
- Lightning Bolt has ordinary rank records and additional instant variants such as `408439`. Tiger's Fury includes `5217` and `417045`, the latter describing an energy grant. Do not map a triggered effect as a separate manual ability activation without evidence.
- Carve `425711` and Earth Shield `408514` appear in class-linked records but also carry retained SoD provenance without the corroboration needed to establish current learnability. They are **Uncertain**, not ready for production.

`rank_variants` records the source-reported rank label for every candidate; `id_source_records` and `id_review_status` identify each ID's evidence. `trainer_verified_ids` means trainer-record corroboration only. `observed_player_success_ids` is the narrower event-evidence column. `rank_variant_gaps` lists observed numbered ranks and internal gaps (none found in the union of surveyed records), while keeping unlearned/overridden variants unresolved; the CSV is not a complete list of every future rank. No production mapping should be generated directly from `candidate_spell_ids`.

### Historical renames and missing matches

These have class-linked Forever identity candidates, but need authored-content review before adopting the alias:

| Historical key | Forever name | Candidate IDs |
| --- | --- | --- |
| CURSE_OF_AGONY | Bane of Agony | 980;1014;6217;11711;11712;11713 |
| CURSE_OF_DOOM | Bane of Doom | 603 |
| ENSLAVE_DEMON | Subjugate Demon | 1098;11725;11726 |

Fire Nova Totem is not safely interchangeable with [Fire Nova `408341`](https://foreverdb.net/spell/408341) and its `408342`–`408345` ranks. The latter is a changed activation, not evidence of historical totem creation; `408339` is a passive rune wrapper. Curse of Shadow's merged effects do not justify mapping its sayings onto Curse of the Elements automatically.

**Not found:** Hunter Aspect of the Wolf; Paladin Bulwark of the Righteous; Shaman Spirit Link, Earthshaker Slam, Calm Elements and Totemic Slam. No Forever player IDs are asserted for them.

**Raw-name records without an established player-class mapping:** Hunter Steady Shot; Paladin Crusader Strike, Hand of Reckoning and Summon Warhorse; Rogue Shoot Bow and Throw; Shaman Bloodlust, Lightning Strike, Feral Spirit and Hex. The CSV preserves the rejected IDs for traceability. Multiple Summon Warhorse records and race-specific names also require explicit mount/race variant investigation. A retained Crusader Strike record or rune tooltip is insufficient proof of a learned Paladin ability.

## Detection compatibility

Ordinary cast-time spells and instant manual activations are the intended candidate group. Buffs, heals, utility casts, summons, stings, shots and direct melee abilities can qualify without checking their eventual effects. Talent-driven cast-time changes do not require a pending-cast machine: a readable player success is sufficient. Learnability and event identity must still be established individually.

The **30 Unsupported** entries comprise 25 deferred mechanisms and 5 removed/replaced abilities. They include:

- Channels: Druid Hurricane/Tranquility; Hunter Mend Pet, Volley, Eagle Eye and Eyes of the Beast; Mage Arcane Missiles, Blizzard, Evocation and legacy Icicles; Priest Mind Flay, Mind Vision and Mind Control; Warlock Drain Life, Drain Mana, Drain Soul, Health Funnel, Hellfire and Rain of Fire. A channel can have an instant initialization field; success does not prove completion. Icicles has no matching Forever ID in the surveyed data, in addition to being historically channelled.
- Forms: Dire Bear Form, Ghost Wolf and Shadowform. Defer transitions rather than treating them as ordinary buff casts.
- Raptor Strike's unresolved queued/direct variant families; passive/death-triggered Spirit of Redemption; Reincarnation's special death-interface behavior. A learned passive ID `20608` and effect `21169` are not proof of an ordinary successful cast.
- Detect Magic, Blessing of Sanctuary, Sanctity Aura, Curse of Shadow and historical Fire Nova Totem.

Hunter tracking selections and Warlock Sense Demons are **Uncertain**: they may be handled as modes rather than ordinary activations. Rogue Shoot Bow and Throw also need evidence distinguishing auto-repeat/action toggles from a manual ability success. Pet casts, passive procs, automatic attacks, empower and reticle behaviors remain deferred; this audit does not add such detection. Hunter Mend Pet concerns a player channel, not permission to accept pet-unit events.

Existing generic combat triggers and Druid speech/form restrictions remain unchanged. A candidate with only target-dependent content may produce no eligible reaction when target data is unavailable; mapping it does not authorize reconstructing a target. Ability reactions must retain master/individual settings, probability, global/ability cooldowns, activity routing, failed-dispatch accounting and the shared encounter quota. Out-of-combat eligible activations remain exempt from the encounter quota.

## Dynamic spellbook mapping assessment

### Documented surface

Build 70170 exports `C_SpellBook.GetNumSpellBookSkillLines`, `GetSpellBookSkillLineInfo`, `GetSpellBookItemInfo`, `GetSpellBookItemName`, `GetSpellBookItemType`, `IsSpellKnown`, `IsSpellInSpellBook`, `FindBaseSpellByID` and `FindSpellOverrideByID`. See the [Forever spellbook documentation](https://github.com/Atraeau/WoW-Addons/blob/main/docs/api/Spells-Auras-Talents/C_SpellBook.md) and [Blizzard generated spellbook documentation](https://github.com/Gethe/wow-ui-source/blob/live/Interface/AddOns/Blizzard_APIDocumentationGenerated/SpellBookDocumentation.lua).

The intended enumeration uses `Enum.SpellBookSpellBank.Player`, skill-line `itemIndexOffset + 1` through `itemIndexOffset + numSpellBookItems`, and spell item types only. `GetSpellBookItemInfo` exposes `actionID`, optional `spellID`, `itemType`, `name`, `subName`, `isPassive` and `isOffSpec`. `actionID` may be a flyout/action ID rather than a spell; `spellID` may be an override. Slot indices are not stable spell identities. Flyouts need separate verified expansion behavior; skip them initially. Do not enumerate the pet bank.

The export is not a security guarantee. Corresponding generated documentation permits secret arguments under particular conditions on some functions and allows missing results; it does not prove all Forever return fields are readable in combat. Names can be empty while spell text loads. Locale, rank labels and override relations must be tested on Forever. `IsSpellKnown` can include temporarily known abilities; `IsSpellInSpellBook` with overrides is not a universal learned-spell test.

### Safety, identity and costs

A bounded, guarded spellbook scan during safe initialization could discover learned IDs without maintaining every rank manually. Capability checks, protected calls, readable positive numeric IDs and secret inspection must precede comparison, indexing, formatting or name normalization. Inspect only fields actually needed; an unused secret field should not invalidate an otherwise supported item. Missing/failing inspection facilities must fail closed, as the current event adapter does. No caching, name lookup or secondary API query may be used to recover a secret event ID.

Spellbook APIs do **not** supply an RPHelper canonical key. A resolver still needs curated class-scoped semantic seeds or reviewed localized aliases. Automatic uppercasing/underscoring of arbitrary spell names is insufficient: renames, collisions, effect records, language differences and cast-versus-passive identities remain. Base/override helpers can extend a specifically validated family, not prove that all similarly named IDs are interchangeable or emit the same success ID.

An unlearned ability cannot be discovered from the current character's spellbook; absence must mean “not currently discovered,” not removal from Forever. Scanning one low-level character cannot validate all ranks, talent replacements, quest rewards, races or equipment-driven variants.

| Approach | Benefits | Costs/risks | Assessment |
| --- | --- | --- | --- |
| Explicit class + spell-ID allowlist | Deterministic, cheap event lookup, traceable per-ID evidence; works without spellbook API availability | Reviewed rank/variant maintenance; newly learned unsupported ranks are safely ignored | Best immediate strategy |
| Dynamic name-to-key resolver | Discovers current learned ranks with fewer hand-maintained IDs | Still needs curated identity rules, localization, passive/flyout handling and secrecy safeguards; cannot discover absent spells | Not established as a safe automatic replacement |
| Hybrid semantic allowlist + bounded spellbook cache | Explicit scope with discovery of validated learned base/override relations | More adapter work and live tests; never auto-enables all catalogues | Potential later improvement if rank maintenance becomes burdensome |

A hybrid should refresh a bounded cache at initialization and a coalesced `SPELLS_CHANGED` invalidation, deferred out of combat if the client requires it. No continuous polling or combat-time spellbook enumeration is needed. Each success event should remain an inexpensive class/ID lookup after required-field guards. Event processing costs CPU/memory; public output generates chat traffic. Spellbook calls do not inherently add network “ping” costs.

These are architectural recommendations, not an implemented resolver or proof that the dynamic path is achievable on Forever. Spellbook capability probes, safe enumeration and optional lineage helpers belong in the runtime API adapter; content selection and policy decisions remain separate.

## Prioritized production proposal

1. **Small evidence-backed addition:** after review, consider only Paladin Holy Light `647` and Judgement `20271` alongside the two existing IDs. Add explicit settings/mappings and deterministic policy tests in a separate implementation task. Keep all other ranks disabled until supported by attributable evidence. No mapping is changed by this research.
2. **Live validation of ordinary candidates:** prioritize rank families already corroborated by multiple class sources, and abilities with useful target-independent authored reactions. Include at least one ordinary cast, instant buff, utility activation and direct melee ability across classes. Capture actual learned IDs before choosing a small next allowlist; do not deploy all 236 strong candidates together.
3. **Later maintenance improvement:** evaluate the hybrid only after actual rank/override captures show a benefit. Start with explicit class-scoped identities and a bounded learned-spell scan; do not infer identity from arbitrary names.
4. **Continue deferral:** ambiguous SoD records, historical renames needing content review, special categories, missing abilities and undocumented variant families. Generic offensive critical detection remains separately deferred; this work does not introduce combat-log or combat-text alternatives.

No cast GUID deduplication or pending-cast state is justified by these datasets. Capture whether repeated identical success events occur before adding any safeguard. Successful activation remains sufficient even if the spell later misses or has no effective outcome.

## Required Forever live-client verification

- Record client build/interface, class, race, level, locale, talents and equipment. Capture the learned spellbook record and actual player success ID together for each proposed mapping, with readable-field checks before displaying data. Do not print or stringify secret values.
- Confirm protected registration works and failures leave generic combat entry/exit and defensive events functional. Test absent/failing secret inspection and unavailable spellbook capabilities.
- For `647` and `20271`, verify player source/readability inside and outside combat, interruption/failure behavior, and ordinary instant success without START/SENT. Verify only the exact player unit is accepted; exclude pets and other units.
- Exercise low/high ranks, downranking where available, renamed abilities, talent-instant versions and overriding spells. Resolve Raptor Strike families, Seal rank-1 alternatives and same-name helper records before adding them.
- Enumerate the player bank in and out of combat, checking item types, readable fields, zero/missing IDs, passives, flyouts, off-spec entries, localized names, delayed text and base/override helpers. Verify `SPELLS_CHANGED` refresh behavior after learning/respec without polling. Repeat on a character that lacks the ability.
- Independently establish current learnability of Carve/Earth Shield and the unresolved mount/race, tracking and ranged categories. Recheck reported removals against the tested build. Keep deferred mechanisms disabled during these investigations.
- Measure events per one physical activation; test spam-clicking, queued input, cancel/fail and repeated activations. Capture duplicate identities without inferring outcomes from timing or target state.
- Verify existing policy behavior: enabled/disabled settings, probability/cooldowns, shared combat quota and no encounter quota out of combat, failed dispatch, content preparation, activity routing and Druid speech suppression. No combat parser, target correlation, polling, macro fallback or restricted API workaround is proposed.

## Historical catalogue scope clarification

The original ability-spell discovery inventory covered the **297 pre-reconciliation,
authored-content-driven class/ability pairs**, not every historical definition.
[Historical catalogue reconciliation](ability_catalogue_reconciliation.md) now
accounts for 492 historical keys and 465 canonical definitions, including empty
abilities. Its additional definitions do not imply new verified spell IDs,
production mappings, event support or enabled ability settings. The original
spell-ID inventory remains a dated research snapshot; it is not automatically
extended by catalogue existence. A separate official Forever comparison and
per-ID validation remain necessary.
