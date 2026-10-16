# Rogue beta ability reconciliation

Research snapshot only. This report proposes dispositions for owner review; it does not authorize catalogue, archive, spell-ID, detection, settings, migration, or content changes.

## Sources and limitations

The primary [Rogue spellbook](https://wowforevertalent.com/abilities/rogue/) was retrieved on **16 October 2026**. The live page identifies the **16 October 2026 Forever Beta book, client 1.60.1.70425**, revision `beta-20261016-56046fb6`. It contains **121 recorded ranks grouped into 40 non-General identities**: 11 Assassination, ten Combat, 13 Subtlety, and six Poisons. Eleven General entries bring the source inventory to 51 identities and 132 recorded tooltips. The source reports no Classic-fallback or name-only records, but it is an independent dataset and not an in-game check.

The linked [Rogue talent reference](https://wowforevertalent.com/rogue/reference/) uses the same 16 October export. Its ten direct activations—Cold Blood, Mutilate, Venom, Riposte, Blade Flurry, Adrenaline Rush, Ghostly Strike, Premeditation, Preparation, and Hemorrhage—are all represented in the spellbook. The other 43 talent identities are passive or triggered effects. Relentless Strikes is retained as supplemental evidence because RPHelper currently registers that passive identity.

The retrieved [changelog](https://wowforevertalent.com/changelog/) confirms that the 16 October build-70425 export supersedes the 14 October book. Its 15 October Rogue entry corrects Classic comparison labels and poison descriptions, not the identity inventory. No later entry supersedes the retrieved Rogue sources.

The spellbook exposes rank labels, learn levels, talent acquisition, requirements, resources, cast times, cooldowns, and reagents, but no numeric spell IDs. Candidate IDs in the CSV come from the earlier mixed-source audit and remain unverified; blanks are intentional. Spellbook or talent presence does not establish a readable successful-cast event.

Source B is the actual `RPHelper.RegisterAbility` path in `RPHelper/Data/Abilities/Rogue.lua`, including its consolidated empty-definition loop. It defines **49 canonical identities and four authored ability reactions**: two `say`, zero `emote`, and two `customemote`. Four definitions have reactions and **45 have empty shipped pools**. `RPHelper/Data/Classes/Rogue.lua` separately contains **40 class-trigger reactions**: 39 `say` and one `emote`. Research does not reassign either content layer.

## Reconciliation totals

The CSV contains the 51 spellbook identities, a separate row for historical `BLADE_FURY`, five beta-absent definitions, and one existing passive-talent definition.

| Classification | Identities | Authored ability reactions | Existing empty definitions |
| --- | ---: | ---: | ---: |
| Confirmed, existing | 42 | 4 | 38 |
| Confirmed, missing | 8 | 0 | 0 |
| Rename/replacement candidate | 2 | 0 | 1 |
| Not found in beta | 5 | 0 | 5 |
| Talent-only passive evidence | 1 | 0 | 1 |
| **CSV total** | **58** | **4** | **45** |

Beta presence, activation eligibility, and v1 scope remain separate:

- The **40 non-General spellbook identities** comprise 38 direct player activations and two passive entries, Detect Traps and Safe Fall.
- Of the 38 eligible identities, 35 exactly match active definitions, Mutilate and Venom are missing, and Blade Flurry has the historical `BLADE_FURY` canonical candidate.
- The Poisons tab is class-specific source material and remains in v1 reconciliation scope. Its six entries are player-activated three-second creation casts; later weapon application and poison procs are separate actions.
- The **11 General entries** remain evidence outside v1 scope. Attack, Pick Lock, Shoot Bow, Shoot Crossbow, Shoot Gun, and Throw are activatable controls; Dual Wield, Armor Proficiency, Dodge, Parry, and Languages are passive.

## Existing coverage and missing active abilities

The 35 exact eligible class matches include all recorded openers, builders, finishers, cooldowns, stealth controls, and poison-creation spells except the two new Assassination talents. Sprint and Disarm Trap hold the two in-scope authored reactions.

Two eligible beta identities are wholly missing:

- **Mutilate**, an active Assassination talent with four recorded ranks, is a dagger-restricted two-weapon attack and combo-point builder.
- **Venom**, an active Assassination talent and finishing move, requires Mutilate and modifies poison damage and application chance.

Six General identities are also absent, but General is excluded from v1. This is not evidence that those abilities are absent from Forever.

## Rename candidate

The beta consistently names **Blade Flurry**, while RPHelper registers `BLADE_FURY`. The talent reference and spellbook both describe the active Combat cooldown; the catalogue spelling is therefore a strong canonical-correction candidate, but research does not authorize an alias or rename. A later approval must decide whether `BLADE_FURY` becomes `BLADE_FLURRY` and whether user-authored scopes, per-ability settings, and disabled-default IDs need narrow idempotent compatibility. The existing definition has no bundled reactions.

## Passive and historical identities

Detect Traps and Safe Fall are beta-confirmed passive spellbook entries. Relentless Strikes is a beta-confirmed passive talent. All three are outside direct-activation scope even though RPHelper currently defines them with empty pools.

Five other empty definitions are absent from both the current spellbook and active-talent list: Agitating Poison, Deadly Throw, Exploit Weakness, Flourish, and Surprise Attack. Their absence is not proof of permanent removal. A later implementation may remove them from the active catalogue or record them in an unloaded archive, but must preserve player-owned records under their historical keys.

General-tab Pick Lock, Shoot Bow, Shoot Crossbow, Shoot Gun, and Throw are currently registered. Shoot Bow and Throw each retain one `customemote`; any later General-tab cleanup must preserve those authored reactions rather than silently discard or transfer them.

## Authored content preservation

The ability catalogue reactions are exactly:

| Canonical key | `say` | `emote` | `customemote` | Total | Scope note |
| --- | ---: | ---: | ---: | ---: | --- |
| `DISARM_TRAP` | 1 | 0 | 0 | 1 | In-scope class ability |
| `SPRINT` | 1 | 0 | 0 | 1 | In-scope class ability |
| `SHOOT_BOW` | 0 | 0 | 1 | 1 | General-tab, outside v1 |
| `THROW` | 0 | 0 | 1 | 1 | General-tab, outside v1 |

The separate class file has 10 enter-combat, nine leave-combat, one dodge, ten `youcrit`, and ten deferred `youcritspell` reactions. It contains two `ENTERCOMBAT` headings, but the headings do not change registration behavior. These 40 class reactions must not be mistaken for ability reactions or moved during catalogue reconciliation.

## Runtime and special-case considerations

- Stealth and Vanish change aura/state as well as invoking an ability. Entering stealth, leaving stealth, Vanish success, and a later opener are distinct observations.
- Ambush, Cheap Shot, Garrote, Sap, and Pick Pocket have stealth, position, target-type, or weapon constraints. A button press or cast start does not prove success.
- Riposte is only enabled after a parry. Preparation resets other cooldowns; those resets are not new casts of the affected abilities.
- Builders and finishers depend on target-bound combo points. Target death, insufficient points, or target changes can complicate attribution.
- Mutilate, Backstab, Ambush, and Hemorrhage have weapon requirements or weapon-dependent behavior.
- The Poisons entries create consumable items. Applying a created poison is an item action, and later poison applications or damage are automatic procs, not repeated casts of the creation spell.
- Blind consumes Blinding Powder, Vanish consumes Flash Powder, and Disarm Trap uses Thieves' Tools. Failed reagent, tool, range, or target checks must not produce reactions.
- Shoot and Throw controls are General-tab actions and excluded from v1 even though they are player activated.
- `UNIT_SPELLCAST_SUCCEEDED` may be relevant for ordinary readable player casts, but instant attacks, stealth transitions, reactive Riposte, item creation/application, and restricted or failed actions require client verification. No Rogue production spell IDs currently establish these cases here.

## Owner decisions required

1. Approve or reject empty active definitions for Mutilate and Venom.
2. Approve or reject `BLADE_FURY` → `BLADE_FLURRY`, including narrowly scoped SavedVariables compatibility if renamed.
3. Confirm removal from the active catalogue of beta-confirmed passive Detect Traps, Safe Fall, and Relentless Strikes while preserving player-owned records.
4. Decide whether the five beta-absent empty identities remain active exceptions, are removed, or are recorded in an unloaded archive.
5. Confirm that the five existing General definitions leave the active class catalogue, and choose preservation treatment for the Shoot Bow and Throw reactions without reassociating them automatically.
6. Defer spell-ID and runtime work until stealth state, reactive abilities, combo points, item creation/application, and poison procs are verified in the client.

## Provisional Stage 2 disposition

Subject to owner approval, a later implementation could retain the 35 exact eligible class identities and their two reactions, add Mutilate and Venom as empty definitions, and correct Blade Flurry through an explicitly approved canonical migration. The three passive definitions and five beta-absent definitions are candidates for removal from the active catalogue. General entries remain outside v1, with the two authored General reactions preserved recoverably. All 40 class-trigger reactions remain unchanged. No archive, migration, reaction transfer, spell-ID mapping, or runtime change is authorized by this research.

Complete row-level evidence is in [the Rogue reconciliation CSV](rogue_beta_reconciliation.csv).
