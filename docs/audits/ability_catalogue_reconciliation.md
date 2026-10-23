# Historical ability catalogue reconciliation

Branch: `feat/ability-catalogue-reconciliation`. Historical baseline reconciliation only; no new player event detection, spell-ID mapping, settings policy or SavedVariables schema.

## Result

**492 distinct historical class/key records** are accounted for. The existing **297 canonical abilities** become **465**: **168 restored definitions**, of which **167 have empty shipped pools** and one has a recovered saying. All **841 pre-existing authored reactions** and their shipped identities are preserved; there are **842 reactions** afterward.

The [machine-readable reconciliation inventory](ability_catalogue_reconciliation_inventory.csv) records every historical key, canonical outcome, English/localization presence, historical reaction counts, previous catalogue presence, mechanism and unresolved status. It is a provenance inventory, not a spell-ID allowlist.

| Class | English definitions | Localization definitions | Historical union | Before | Added definitions | Existing reactions | Recovered reactions | Excluded/deferred | Rank aliases | After |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Druid | 55 | 55 | 55 | 13 | 42 | 28 | 0 | 0 | 0 | 55 |
| Hunter | 49 | 49 | 49 | 49 | 0 | 155 | 0 | 0 | 0 | 49 |
| Mage | 54 | 54 | 54 | 54 | 0 | 134 | 0 | 0 | 0 | 54 |
| Paladin | 49 | 54 | 54 | 49 | 4 | 103 | 0 | 1 | 0 | 53 |
| Priest | 54 | 54 | 54 | 37 | 7 | 111 | 0 | 10 | 0 | 44 |
| Rogue | 44 | 64 | 64 | 4 | 45 | 4 | 0 | 0 | 15 | 49 |
| Shaman | 54 | 60 | 60 | 54 | 6 | 230 | 0 | 0 | 0 | 60 |
| Warlock | 55 | 58 | 58 | 25 | 33 | 55 | 1 | 0 | 0 | 58 |
| Warrior | 40 | 43 | 44 | 12 | 31 | 21 | 0 | 1 | 0 | 43 |
| **Total** | **454** | **491** | **492** | **297** | **168** | **841** | **1** | **12** | **15** | **465** |

## Sources and inclusion rules

Inspected the read-only sibling `../../RPhelper_twow/`, clean at commit [`0b0b1ef94aa7a664842fae7046c60305991234a0`](https://github.com/Wiubiki/RPhelper_twow/tree/0b0b1ef94aa7a664842fae7046c60305991234a0), especially all nine `English/CLASS.lua` files, `English/ANY.lua`, `localization.lua` and the legacy random-phrase routing. Current contracts come from `Core/Content.lua`, `Core/UserContent.lua`, the content/runtime suites and [data architecture](../data_architecture.md), [content engine](../content_engine.md), [user content runtime](../user_content_runtime.md) and prior spell audits.

Historical definition counts use unique keys from the union of:

- Class-specific base `RPWORDLIST.key.CLASS = ...` assignments in the English file, subtracting generic reaction keys declared by `English/ANY.lua`.
- Class-specific `SPELLS.category.CLASS.key = "Name"` assignments in localization.

An English empty pool is still a definition. Localization-only keys are also investigated. Repeated definitions count once: Mage repeats eight Fire keys and Priest repeats Silence. Some later historical assignments overwrite earlier pools; they are not instructions to erase migrated content. Historical pool counts describe the final English-file tables; pre-existing Forever content is separately preserved and counted.

Pre-reconciliation counts were measured by loading the current class files and examining `RPHelper.Ability`, rather than assuming reaction count proves existence. Per-key comparisons, not file length, determine outcomes. The preliminary Druid/Warrior figures are not acceptance targets: this snapshot has 55 unique Druid keys and 40 English Warrior keys; Warrior's localization contributes four additional keys, while English-only Shadowmeld makes the union 44.

No official Forever catalogue replacement is attempted. Historical presence establishes provenance, including Turtle additions and questionable categories. Existing earlier audit evidence remains separate; newly restored definitions have no spell IDs verified by this task.

## Architecture

`RPHelper.RegisterAbility(class, ability, entry)` now always establishes the canonical `RPHelper.Ability[class][ability]` and shipped pool. Omitting `entry` registers an empty definition, without a dummy reaction or a shipped identity. Repeating a definition is idempotent. Supplying an entry retains the existing reaction registration/identity behavior.

Missing definitions are appended within their existing class files. Existing sayings, emotes, template data and registration order remain unchanged. There is no second catalogue or selection engine. Empty abilities are discoverable through `RPHelper.Ability` and their actual `Content.ability` pool; `GetAbilityPool` contains zero entries, and selection returns nil until matching user content exists.

Users can attach ordinary custom reactions to these canonical keys through the unchanged `UserContent.Add` API. They use the same preparation and restrictions. Catalogue existence alone does **not** enable an automatic activation: the existing explicit spell-ID allowlist and ability defaults still control runtime coverage. Restored empty abilities receive neither automatic settings defaults nor new mappings. No cooldown, chance, quota, output routing, Druid restriction or persistent schema is changed.

## Per-class decisions

### Druid

Restore 42 empty definitions: `ABOLISH_POISON`, `BARKSKIN`, `BASH`, `BERSERK`, `CAT_FORM`, `CLAW`, `COWER`, `CURE_POISON`, `DASH`, `FAERIE_FIRE`, `FAERIE_FIRE_FERAL`, `FERAL_CHARGE`, `FEROCIOUS_BITE`, `FRENZIED_REGENERATION`, `HEALING_TOUCH`, `INSECT_SWARM`, `MARK_OF_THE_WILD`, `MAUL`, `MOONKIN_FORM`, `MOON_FIRE`, `NATURES_GRASP`, `NATURES_SWIFTNESS`, `OMEN_OF_CLARITY`, `POUNCE`, `PROWL`, `RAKE`, `RAVAGE`, `REGROWTH`, `REJUVENATION`, `REMOVE_CURSE`, `RIP`, `SAVAGE_BITE`, `SHRED`, `SOOTHE_ANIMAL`, `STARFIRE`, `SWIFTMEND`, `SWIPE`, `THORNS`, `TRACK_HUMANOIDS`, `TRAVEL_FORM`, `TREE_OF_LIFE_FORM`, `WRATH`.

Retain historical `MOON_FIRE` spelling rather than silently rename it. Omen of Clarity is proc-related; whether its current version is a manual buff or passive talent remains unresolved. Forms and historically queued Maul are not newly supported ordinary activations. Their definitions remain available without claiming event compatibility. Berserk, Savage Bite and Tree of Life require the separate Forever availability comparison. No additional Druid sayings are invented.

### Hunter and Mage

Every historical key is already represented. No class file changes or new reactions. Retain currently authored questionable/removed mechanisms for the separate official comparison; this reconciliation does not remove content or reverse prior audit findings. Mage's repeated historical Fire assignments are deduplicated as definitions, not duplicated as registrations.

### Paladin

Restore localization-only empty definitions `GREATER_BLESSING_OF_KINGS`, `GREATER_BLESSING_OF_LIGHT`, `GREATER_BLESSING_OF_SALVATION`, `GREATER_BLESSING_OF_WISDOM`.

Defer `GREATER_BLESSING_OF_SANCTUARY`: a [Forever beta reference](https://theforeverera.com/en/spells/paladin/greater-blessing-of-sanctuary/) reports it removed in build 70245. This third-party older-build report is sufficient reason not to restore it automatically, but is not our own current-client verification. Existing authored Blessing of Sanctuary/Sanctity Aura remain unchanged; future official-list reconciliation must address those separately.

### Priest

Restore seven empty non-racial Turtle definitions: `CHAMPIONS_BOND`, `CHAMPIONS_RESOLVE`, `CHASTICE`, `EMPOWER_CHAMPION`, `PAIN_SPIKE`, `PROCLAIM_CHAMPION`, `REVIVE_CHAMPION`. Preserve historical `CHASTICE` spelling; do not assume it means another similarly named modern spell. Their Forever availability is unresolved.

Preserve the universal-Priest exclusion of ten racials: `DESPERATE_PRAYER`, `DEVOURING_PLAGUE`, `ELUNES_GRACE`, `FEAR_WARD`, `FEEDBACK`, `HEX_OF_WEAKNESS`, `SEARING_SHOT`, `SHADOWGUARD`, `STARSHARDS`, `TOUCH_OF_WEAKNESS`. Localization explicitly marks their race restrictions. Nine have historical authored reactions (28 total); Searing Shot is empty. No universal racial definitions/reactions are restored. Proper racial ability handling remains deferred.

### Rogue

Restore the 40 missing English-file definitions, plus localization-only `AGITATING_POISON`, `DEADLY_THROW`, `EXPLOIT_WEAKNESS`, `FLOURISH`, `SURPRISE_ATTACK`: 45 empty additions. The inventory lists each key rather than relying on this summary.

Fifteen localization-only poison rank keys are represented by the canonical poison families rather than additional semantic abilities:

| Historical keys | Canonical family |
| --- | --- |
| `CRIPPLINGPOISON_II` | `CRIPPLING_POISON` |
| `MIND_NUMBINGPOISON_II`, `MIND_NUMBINGPOISON_III` | `MIND_NUMBING_POISON` |
| `INSTANT_POISON_II`, `_III`, `_IV`, `INSTANT_POISON__V`, `_VI` | `INSTANT_POISON` |
| `DEADLY_POISON_II`, `_III`, `_IV`, `_V` | `DEADLY_POISON` |
| `WOUND_POISON_II`, `_III`, `_IV` | `WOUND_POISON` |

These are explicit historical semantic aliases, not a new runtime resolver or spell-ID/rank mapping. Spelling inconsistencies are preserved in the inventory. Safe Fall and Relentless Strikes are passive/proc mechanisms; ranged auto-attack selections, poisons and Turtle additions need individual Forever/event assessment. No blanket ordinary-activation support is implied.

### Shaman

Restore six localization-only empty definitions: `ASTRAL_RECALL`, `ELEMENTAL_FOCUS`, `ELEMENTAL_MASTERY`, `FAR_SIGHT`, `WATER_BREATHING`, `WATER_WALKING`. Elemental Focus is passive/proc-driven; Far Sight's remote-view/casting behavior requires verification rather than reliance on the historical casting-category label. All existing 230 reactions remain unchanged.

### Warlock

Restore 33 definitions, including localization-only `DARK_HARVEST`, `DEMON_PORTAL`, `MANA_FUNNEL`. Thirty-two remain empty. Preserve historical `EYE_OF_KILROGG` spelling; invisibility variants, portal/funnel additions, channels and passive/talent effects require subsequent official/client comparison.

**Banish recovery:** the English source puts the literal `banishes TARGET from this plane briefly.` inside `.random`, where the legacy chooser expects structured phrase records. It is malformed historical data, not evidence of a working random template. The legacy caller explicitly joins generated random phrases into sayings. Recover the literal as one `say` entry, converting only `TARGET` to `{TARGET}`. Do not silently change it to `/e` because its wording is third person. Without relevant target context it is ineligible; no Banish detection is enabled. This preserves authored text intent while repairing the storage shape. The output-type/editorial choice merits manual review.

### Warrior

Restore 31 empty class definitions, including localization-only `COUNTERATTACK`, `DECISIVE_STRIKE`, `DISARM`, `INTERVENE`. Anger Management is passive; queued Heroic Strike/Cleave and ranged attack controls remain outside new detection scope.

Exclude English-only `SHADOWMELD` from the universal Warrior catalogue: it is a Night Elf racial misplaced in this historical class source. Its three authored custom emotes are recorded here for future racial handling, without enabling them universally:

- `fades into the shadows.`
- `disappears for a bit.`
- `thinks SP'll hide now.`

## Unresolved scope and verification

All restored identities remain historical baseline definitions pending the **separate** official Forever ability comparison and per-ID activation validation. Passive/proc mechanisms may legitimately stay in a historical/custom-content catalogue while remaining unsuitable for ordinary `UNIT_SPELLCAST_SUCCEEDED` detection. Forms, channels, queued/ranged attacks, poison crafting/application and Turtle additions need their own assessment. The inventory marks these concerns; it does not silently discard them or claim availability.

The previous [spell-ID audit](ability_spell_mapping_audit.md) and its CSV examined the **297 pre-reconciliation, authored-content-driven catalogue pairs**. Their 1,009 candidate IDs are not coverage for this enlarged 465-definition baseline. The old inventory remains a dated research snapshot and is not expanded with guesses.

Regression coverage pins every historical key and exception, checks canonical existence independently of shipped reaction count, permits custom content on an empty ability, verifies idempotent registration, checks every pre-existing class reaction/identity against its baseline, tests Banish context eligibility, and verifies the exact two production Paladin mappings remain unchanged. Existing policy/content tests remain required. Live Forever ability availability and persistence/output verification are not claimed.
