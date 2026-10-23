# Warlock demon reconciliation and runtime feasibility

Research snapshot only. This report inventories the Forever Warlock Demons tab, accounts for existing demon-related content, and identifies runtime verification gates. It does not authorize demon-ability registrations, events, spell mappings, or behavior changes.

## Demons-tab inventory

The [Warlock spellbook](https://wowforevertalent.com/abilities/warlock/) retrieved on **16 October 2026** identifies client **1.60.1.70425**. Its Demons tab contains **16 identities and 63 ranks**, divided evenly by demon family:

- **Imp:** Blood Pact, Fire Shield, Firebolt, and Phase Shift.
- **Voidwalker:** Consume Shadows, Sacrifice, Suffering, and Torment.
- **Succubus/Incubus (Sayaad):** Lash of Pain, Lesser Invisibility, Seduction, and Soothing Kiss.
- **Felhunter:** Devour Magic, Paranoia, Spell Lock, and Tainted Blood.

The source identifies each demon family, ranks, resource costs, ranges, timing, and cooldowns. It does **not** expose numeric IDs, action-bar autocast state, or whether an execution was demon-AI initiated or explicitly commanded. Blood Pact and Paranoia are recorded conservatively as demon auras with activation/autocast unresolved; the other 14 are demon actions with command/autocast status unresolved. None is a direct player class activation.

Firebolt, Torment, Suffering, Lash of Pain, Soothing Kiss, and several utility skills are commonly compatible with repeated demon use, but no retail or Classic behavior is assumed for Forever. Devour Magic, Spell Lock, Seduction, Sacrifice, and other manually useful commands still cannot be classified as player intent from the spellbook alone.

## Existing demon-related content

`RPHelper/Data/Classes/Warlock.lua` registers three generic pet-event pools:

| Trigger | `say` | `emote` | `customemote` | Total |
| --- | ---: | ---: | ---: | ---: |
| `petattackstart` | 7 | 0 | 0 | 7 |
| `petattackstop` | 6 | 0 | 0 | 6 |
| `petdies` | 6 | 0 | 0 | 6 |
| **Demon-event content** | **19** | **0** | **0** | **19** |

These pools use `PNAME` and sometimes `PTOP`, but contain no demon-family branching. They are generic contextual reactions, not Firebolt, Torment, Seduction, Spell Lock, or other ability pools.

The same class file contains **19 non-demon-event reactions**: 13 enter-combat reactions, one absorb emote, one resurrection saying, two direct NPC-talk sayings, and two generated NPC-talk templates. It therefore registers **38 authored class reactions**: 32 `say` (including two templates) and six `emote`.

`Data/Abilities/Warlock.lua` separately contains 56 ability reactions. Eighteen belong to the player-cast Summon Imp, Summon Succubus, and Summon Voidwalker pools; Summon Felhunter is empty and Summon Incubus is absent. Health Funnel, Enslave Demon, Demonic Sacrifice, Inferno, and rituals are player ability identities, not Demons-tab skills. Across the two Warlock files, **94 authored reactions** are accounted for: 56 ability reactions, 19 demon-event reactions, and 19 other class reactions.

Existing content registration does not establish a working runtime detector. The current tests exercise generic content preparation, not Warlock demon lifecycle events.

## Current runtime support

| Capability | Current state | Evidence and limitation |
| --- | --- | --- |
| Warlock demon-event pools | Registered as content only | No runtime event maps to `petattackstart`, `petattackstop`, or `petdies`. |
| Pet/demon keywords | Supplied context only | `PNAME`, `PTNAME`, and pet-target pronouns are not populated by runtime. |
| Player spell success | Narrowly implemented | Exact readable `player` unit required; no Warlock IDs are mapped. |
| Demon spell success | Explicitly rejected | The spell classifier rejects `unitTarget == "pet"`. |
| Demon attack, damage, critical, death, summon, and dismiss detection | Not implemented | No pet lifecycle, pet combat-log, pet unit, or pet spell events are registered. |
| Demon identity, family, and ownership | Not implemented | Runtime does not read pet name, GUID, creature family, or owner attribution. |

The probability, cooldown, encounter quota, activity gating, form-safe content preparation, and output routing policies are reusable only after a detector supplies a safe canonical trigger and context. Their existence does not validate a pet event or justify bypassing the shared Hunter pet foundation.

## Candidate observations requiring in-game verification

These are test candidates, not implementation recommendations or claims of Forever support:

- **Identity and ownership:** test guarded `UnitExists("pet")`, `UnitGUID("pet")`, `UnitName("pet")`, and `UnitCreatureFamily("pet")`, plus `UNIT_PET` ordering, for each permanent demon, subjugated demons, summons, sacrifice, death, despawn, zoning, and resummoning.
- **Spellcasts and autocasts:** capture whether `UNIT_SPELLCAST_SUCCEEDED` arrives for `pet`, whether IDs and unit tokens are readable, and whether manual commands can be distinguished from autocast or AI decisions. An enabled autocast is not proof of player initiation.
- **Attack start/stop:** distinguish a command from target acquisition, first attack, target switch, target death, passive/follow mode, crowd control, and loss of ownership. Deduplicate only from verified event identity.
- **Combat attribution:** if combat-log or unit-combat signals are explored, verify restricted-value behavior and match the current owned demon GUID. Separate direct hits, periodic effects, reflected effects such as Fire Shield or Tainted Blood, and other players' demons.
- **Death and disappearance:** distinguish death from Demonic Sacrifice, Voidwalker Sacrifice, dismissal, subjugation expiry, range loss, zoning, and summon replacement. Cache only the minimum safe identity necessary for content after the unit token disappears.
- **Targets and names:** verify `pettarget` availability and relevance at event time. Never substitute the player's current target when it may differ.

Tests must cover open world, dungeon, raid, PvP, combat, and out-of-combat contexts as applicable. Unreadable values, missing ownership, ambiguous guardians, duplicate events, and registration failure must fail closed.

## Temporary and uncontrolled demon cases

- **Inferno** initially creates an Infernal under the caster's command for five minutes and can later lose control. Ownership and the transition to a hostile/uncontrolled unit require explicit observation.
- **Ritual of Doom** summons a Doomguard that must be subjugated. The ritual cast, participant sacrifice, summon, hostile phase, Subjugate Demon cast, controlled phase, and eventual loss are separate events.
- **Bane of Doom** may produce a Doomguard after delayed damage. That guardian is not the original Bane activation and must not be treated as a normal permanent demon without evidence.
- **Demonic Sacrifice** deliberately removes the summoned demon; **Demonic Pact** changes later resummoning interactions. Neither should automatically produce a generic `petdies` reaction.
- **Eye of Kilrogg** and other controlled/summoned units may use non-pet unit semantics and must not be folded into demon handling from names alone.

## Owner decisions required

1. Keep future demon reactions generic or introduce a separately approved demon-family content layer; do not duplicate existing pools into all 16 skills.
2. Define whether explicit commands, autocasts, AI actions, or some reviewed subset may trigger reactions.
3. Define attack-start, attack-stop, death, sacrifice, despawn, and ownership-transition semantics before selecting client events.
4. Decide whether the Sayaad pair shares family-aware content while retaining separate player summon identities.
5. Reuse the eventual Hunter pet detection foundation where semantics overlap, adding Warlock-specific ownership states only when verified evidence requires them.

## Provisional disposition

Preserve all 16 Demons-tab records as research evidence and all 19 generic demon-event reactions unchanged. Do not add demon skills to `Data/Abilities/Warlock.lua`, create IDs, or enable the dormant triggers until ownership, family, command/autocast semantics, temporary guardians, event ordering, restricted values, and required context are verified in WoW Forever.

The complete row-level inventory is in [the Warlock demon reconciliation CSV](warlock_demon_reconciliation.csv).

## Implementation status

The approved Warlock catalogue implementation leaves all 16 Demons-tab identities research-only. No demon-owned ability, spell-ID mapping, lifecycle handling, ownership logic, autocast detection, or pet/demon event dispatch was added. `Data/Classes/Warlock.lua` remains byte-for-byte unchanged with all 38 reactions, including the 19 generic reactions across `petattackstart`, `petattackstop`, and `petdies`.
