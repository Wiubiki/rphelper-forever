# Priest beta ability reconciliation

Research snapshot only. This report proposes dispositions for owner review; it does not authorize catalogue, archive, spell-ID, detection, settings, migration, racial-layer, or content changes.

## Sources and limitations

The primary [Priest spellbook](https://wowforevertalent.com/abilities/priest/) was retrieved on **19 October 2026**. It identifies the **16 October 2026 Forever Beta book, client 1.60.1.70425** and lists **238 recorded ranks grouped into 55 non-General identities**: 18 Discipline, 18 Holy, and 19 Shadow. Five General entries bring the source inventory to 60 identities and 243 tooltips. This verifies the stated 55 count. The page reports no Classic-fallback or name-only records, but it is an independent dataset rather than an in-game check.

The [Priest talent reference](https://wowforevertalent.com/priest/reference/) was retrieved the same day. It uses the 16 October export and contains 52 talents across three trees. Its ten direct talent activations—Inner Focus, Penance, Power Infusion, Holy Nova, Binding Heal, Prayer of Mending, Mind Flay, Vampiric Embrace, Silence, and Shadowform—are represented in the spellbook. Remaining talent identities are passive or triggered modifiers, including Renewed Hope, Divine Aegis, Litany of Light, Spirit of Redemption, Devouring Contagion, Early Demise, Improved Mind Flay, and Dark Inspiration. They are evidence about mechanics, not direct-activation catalogue candidates.

The [racial reference](https://wowforevertalent.com/racials/) explicitly says Priests retain race-specific spells, that Fear Ward and Devouring Plague became baseline for every Priest, and that each of the six Priest races has two race-specific spells. Its values derive from the 16 October export and are not independently tested. The [changelog](https://wowforevertalent.com/changelog/) records client build 1.60.1.70425, talent data revision `beta-20261017-9b3c9915`, share-link revision `beta-20261016-56046fb6`, and a 17 October racial refresh which did not change Priest racial spells. No later entry supersedes these Priest sources.

The spellbook exposes names, rank grouping, acquisition hints, costs, ranges, cast/channel times, cooldowns, and requirements, but no numeric spell IDs. Spellbook placement does not establish universal availability or a readable successful-cast event. The CSV therefore leaves spell-ID work deferred and treats the racial reference as controlling evidence for race eligibility.

Repository evidence is the loaded `RPHelper/Data/Abilities/Priest.lua`, `RPHelper/Data/Classes/Priest.lua`, current race catalogues, the earlier coverage audit, and prior reconciliation reports. No current race file registers an ability-specific Priest reaction.

## Reconciliation totals

The CSV contains every current spellbook identity, every General entry, and every existing Priest definition absent from the class tabs.

| Classification | Identities | Current ability reactions | Existing empty definitions |
| --- | ---: | ---: | ---: |
| Confirmed universal, existing | 35 | 105 | 0 |
| Confirmed universal, missing | 8 | 0 | 0 |
| Confirmed race-restricted / missing racial layer | 11 | 0 | 0 |
| Race-restricted rename/scope candidate (`CHASTICE` → Chastise) | 1 spellbook row + 1 historical row | 0 | 1 |
| General-tab exclusion | 5 | 0 | 0 |
| Beta-absent or legacy-only definition | 7 | 3 | 6 |
| Talent-only passive definition | 1 | 3 | 0 |
| **Unique CSV rows** | **69** | **111** | **7** |

The 55 non-General spellbook identities split into **43 universal Priest abilities and 12 race-restricted Priest abilities**. All 43 universal identities are direct player activations; 35 already have definitions and eight are missing. The 12 restricted identities are valid Priest abilities only for their named race and must not enter the universal catalogue.

The ten direct active talent identities are all present in the spellbook. The other 42 talent identities are passive or triggered effects and are not missing universal activation entries. Spirit of Redemption is the only such passive currently registered as an ability identity.

## Universal class reconciliation

The 35 exact existing universal identities cover the established buffs, heals, damage spells, control spells, and active talents. They hold 105 authored reactions: 70 `say` and 35 `customemote`.

Eight universal direct activations are missing:

- **Penance**, **Binding Heal**, and **Prayer of Mending** are new active talents.
- **Shadow Word: Death** is a new trained Shadow spell whose self-backlash is a secondary effect.
- **Prayer of Spirit** and **Prayer of Shadow Protection** are current group buffs.
- **Fear Ward** and **Devouring Plague** are explicitly universal in Forever; their earlier racial exclusion is no longer correct.

There is no universal rename among the current class abilities. `CHASTICE` is a historical misspelling related to race-restricted **Chastise**, not authority to create a universal Chastise definition.

## Formerly racial Priest abilities

Spellbook placement is contradictory only if read without the racial source. The racial page resolves availability for all nine identities named in the task:

| Identity | Current evidence | Current addon state | Proposed layer |
| --- | --- | --- | --- |
| Starshards | Night Elf Priest only | No definition; three historical reactions were excluded | Night Elf/Priest exceptional layer or defer |
| Elune's Grace | Night Elf Priest only | No definition; three historical reactions were excluded | Night Elf/Priest exceptional layer or defer |
| Feedback | Human Priest only | No definition; three historical reactions were excluded | Human/Priest exceptional layer or defer |
| Desperate Prayer | Dwarf Priest only | No definition; four historical reactions were excluded | Dwarf/Priest exceptional layer or defer |
| Fear Ward | Explicitly baseline for every Priest | No current definition; three historical reactions were excluded | Universal Priest catalogue, subject to owner approval |
| Shadowguard | Troll Priest only | No definition; three historical reactions were excluded | Troll/Priest exceptional layer or defer |
| Hex of Weakness | Troll Priest only | No definition; three historical reactions were excluded | Troll/Priest exceptional layer or defer |
| Touch of Weakness | Undead Priest only | No definition; three historical reactions were excluded | Undead/Priest exceptional layer or defer |
| Devouring Plague | Explicitly a regular spell for every Priest | No current definition; three historical reactions were excluded | Universal Priest catalogue, subject to owner approval |

Five additional Forever racial Priest spells are present in the class tabs: Human **Divine Grace**, Dwarf **Chastise**, Gnome **Confounding Flash** and **Contingency Plan**, and Undead **Dark Sacrifice**. They have no current authored reactions. Together with the seven still-restricted historical identities, they produce the source's 12 race-specific spells.

The necessary correction to earlier assumptions is narrow: restore universal status only for Fear Ward and Devouring Plague. The other seven formerly racial identities remain restricted. The sources are internally consistent on this point, but actual learned-spell availability and race gating remain client-unverified.

## Existing definitions absent from the beta class tabs

Spirit of Redemption remains a passive Holy talent whose form triggers on death; it is not a direct activation. Its three reactions would be affected by removal from the active ability catalogue.

Lightwell is absent from both the current spellbook and talent tree and was identified as removed in the earlier official-source audit. It retains three reactions. Champion's Bond, Champion's Resolve, Empower Champion, Pain Spike, Proclaim Champion, and Revive Champion are empty historical definitions absent from the current spellbook and active talents. Their absence does not prove that player-owned SavedVariables records can be discarded.

`CHASTICE` is also an empty historical definition. Current sources support the spelling Chastise and Dwarf-only scope. Any later correction must decide whether old-only valid settings and user-authored scopes migrate to a new racial identity, remain recoverable in an archive, or stay deferred. Existing valid destination data should take precedence if migration is authorized; research invents no disabled-default IDs.

## Authored content preservation

The loaded Priest ability catalogue has **111 reactions across 37 identities**: 74 `say`, zero Blizzard `emote`, and 37 `customemote`. Every authored identity has exactly two sayings and one custom emote. Thirty-five beta-confirmed universal identities account for 105 reactions; Lightwell and Spirit of Redemption account for the remaining six. The CSV records every identity and type count.

The separate class file has **51 reactions**: 34 `say`, one Blizzard `emote`, and 16 `customemote`.

| Trigger | `say` | `emote` | `customemote` | Total |
| --- | ---: | ---: | ---: | ---: |
| `entercombat` | 2 | 0 | 1 | 3 |
| `leavecombat` | 2 | 0 | 1 | 3 |
| `hurt` | 2 | 0 | 1 | 3 |
| `absorb` | 2 | 0 | 1 | 3 |
| `block` | 2 | 0 | 1 | 3 |
| `dodge` | 2 | 0 | 1 | 3 |
| `miss` | 2 | 0 | 1 | 3 |
| `parry` | 2 | 0 | 1 | 3 |
| `youcrit` | 2 | 0 | 1 | 3 |
| `deferred_youcritspell` | 2 | 0 | 1 | 3 |
| `youheal` | 2 | 0 | 1 | 3 |
| `youcritheal` | 2 | 0 | 1 | 3 |
| `petattackstart` | 3 | 0 | 1 | 4 |
| `petattackstop` | 2 | 0 | 1 | 3 |
| `petdies` | 2 | 0 | 1 | 3 |
| `resurrect` | 3 | 1 | 1 | 5 |
| **Total** | **34** | **1** | **16** | **51** |

Current racial catalogues contain generic race-trigger content only; none retain ability-specific Priest reactions under historical identities. The earlier catalogue reconciliation counted **28 excluded historical reactions** across nine formerly racial identities: two sayings and one custom emote each, plus one Blizzard emote for Desperate Prayer. Six belong to the newly universal Fear Ward and Devouring Plague; 22 belong to the seven still-restricted identities. Those reactions are source-corpus preservation obligations, not currently loaded addon content. No text, type, order, restoration, archive, or migration is authorized in Stage 1.

## Runtime feasibility

- Penance, Mind Flay, Mind Control, Mind Vision, and Starshards are channeled. A reaction should correspond to one verified activation, not every damage/heal tick; interruption and full-channel-only talent effects need separate observation.
- Shadow Word: Death's self-backlash is a triggered consequence if the target survives, not another cast. Damage-log visibility must not duplicate the activation.
- Prayer of Mending has an initial successful placement followed by triggered heals and up to five jumps. Initial activation is the only straightforward universal-catalogue event; jump policy remains deferred.
- Renew, Holy Fire, Devouring Plague, Contingency Plan, Feedback, Shadowguard, Touch of Weakness, Vampiric Embrace, and talent procs have later healing, damage, absorb, retaliation, or spread effects. Cast success and proc/aura events must remain distinct.
- Racial abilities require both Priest class and correct race availability. A class-tab listing or spell name alone cannot prove eligibility; client tests should cover learned spellbooks for all six Priest races.
- Resurrection requires a dead friendly target and a completed cast. Binding Heal heals two units; Holy Nova and Prayer of Healing may affect several; target/per-recipient combat events must not duplicate one activation.
- `UNIT_SPELLCAST_SUCCEEDED` may cover readable ordinary casts, but channels, instant spells, triggered effects, restricted values, and failed target/range/resource checks need live client verification. No production spell-ID mapping is proposed.

## SavedVariables implications

Adding empty definitions is low content risk but still changes visible catalogue scope. Removing or archiving existing definitions can strand per-ability settings and user-authored scopes. Renaming `CHASTICE`, restoring Fear Ward or Devouring Plague reactions, or creating race/class exceptional identities requires an explicit canonical-key and migration policy. Unknown fields and malformed or conflicting records must remain recoverable; no broad cleanup is implied.

## Owner decisions required

1. Approve or reject empty universal definitions for Penance, Binding Heal, Prayer of Mending, Shadow Word: Death, Prayer of Spirit, and Prayer of Shadow Protection.
2. Approve universal definitions for Fear Ward and Devouring Plague, correcting the earlier exclusion, and decide whether their six historical reactions are restored unchanged or preserved unloaded.
3. Decide whether the 12 race-specific Priest spells receive exceptional race/class catalogues now or remain deferred. Do not add them to the universal catalogue.
4. Decide whether `CHASTICE` becomes a compatibility source for Dwarf-only `CHASTISE`, remains an unloaded historical key, or stays unchanged.
5. Decide the fate of Lightwell, Spirit of Redemption, and the six other beta-absent historical definitions while preserving six current reactions and all player-owned records.
6. Decide whether the 22 excluded historical reactions for still-restricted racial spells should be placed in future exceptional layers or preserved unloaded.
7. Defer spell IDs and runtime policy until channel completion, backlash, Prayer of Mending jumps, triggered effects, race eligibility, group/rez targeting, and successful-cast readability are verified in the client.

## Provisional Stage 2 disposition

Subject to owner approval, a later implementation could retain the 35 exact universal identities and their 105 reactions; add eight empty universal definitions, with a separate decision about the six historical Fear Ward and Devouring Plague reactions; and keep all 12 race-specific spells out of the universal catalogue. Lightwell, Spirit of Redemption, `CHASTICE`, and the six other beta-absent keys require explicit preservation treatment. All 51 class-trigger reactions remain unchanged.

No production Lua, registration, reaction text, archive, migration, spell-ID mapping, or runtime change is authorized by this research. Complete row-level evidence is in [the Priest reconciliation CSV](priest_beta_reconciliation.csv).
