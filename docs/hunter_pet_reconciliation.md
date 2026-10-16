# Hunter pet reconciliation and runtime feasibility

Research snapshot only. This report inventories the Forever Hunter Pets tab, accounts for RPHelper's existing pet-event content, and identifies runtime validation gates. It does not authorize pet-ability catalogue entries, events, mappings, or behavior changes.

## Source inventory and scope

The [Hunter spellbook](https://wowforevertalent.com/abilities/hunter/) retrieved on **16 October 2026** identifies client **1.60.1.70425**. Its Pets tab contains **31 identities and 153 ranks**. Seven are passive pet-training effects—Arcane Resistance, Fire Resistance, Frost Resistance, Great Stamina, Natural Armor, Nature Resistance, and Shadow Resistance. The other 24 have action-style tooltips, usually with Focus, range, cooldown, and sometimes a pet-family restriction.

The source does **not** expose action-bar autocast state, whether an action is pet-AI initiated or explicitly commanded, or the combat-event identity observed by an addon. Accordingly, the CSV classifies those 24 as pet actions with the command/autocast distinction unresolved. It does not label them direct player activations.

Family evidence is preserved per row. Examples include Charge for Boars, Furious Howl for Wolves, Prowl for Cats, Shell Shield for Turtles, Thunderstomp for Gorillas, and new family-specific actions such as Dismember, Dust Cloud, Mine!, Pinch, Savage Rend, Sonic Blast, Swipe, Tendon Rip, Trickster's Dance, and Web. Bite, Claw, Dash, and Dive cover multiple families. Blank family evidence means the source did not state a restriction, not that every family is confirmed.

Candidate IDs are inherited from the earlier mixed-source inventory and are not production mappings. The Pets page itself supplies no IDs. Blank IDs and missing ranks are unresolved evidence, not proof that an ability is unavailable.

## Existing RPHelper pet content

`RPHelper/Data/Classes/Hunter.lua` uses `RPHelper.RegisterClass` to define three generic pet-event pools:

| Trigger | `say` | `emote` | `customemote` | Total |
| --- | ---: | ---: | ---: | ---: |
| `petattackstart` | 10 | 1 | 1 | 12 |
| `petattackstop` | 7 | 0 | 1 | 8 |
| `petdies` | 4 | 0 | 3 | 7 |
| **Pet-event content** | **21** | **1** | **5** | **27** |

These are generic contextual reactions, not Bite, Growl, family-skill, or other ability-specific pools. They must not be duplicated into Pets-tab identities. The same class file contains 51 other generic/deferred Hunter reactions, for 78 class reactions total. Combined with 155 reactions in `Data/Abilities/Hunter.lua`, the two Hunter files account for **233 authored reactions**: 155 ability reactions, 27 pet-event reactions, and 51 other class reactions.

Content-engine tests confirm that all three pet pools register and can prepare when `PNAME`, `TARGET`, and `PTOP` are supplied explicitly. This proves content registration and token substitution only; it does not prove a game event can safely supply that context.

## Current runtime support

| Capability | Current state | Evidence and limitation |
| --- | --- | --- |
| Hunter pet-event pools | Implemented and content-tested | Registered through `RegisterClass`; no runtime event maps to the three triggers. |
| Pet keyword preparation | Implemented with supplied context | `PNAME`, `PTNAME`, and pet-target pronouns are supplied-only resolvers. Runtime does not populate them. |
| Player ability success | Narrowly implemented | `UNIT_SPELLCAST_SUCCEEDED` accepts exact readable `player` units only; no Hunter IDs are mapped. |
| Pet spell success | Explicitly rejected | Runtime tests verify a `"pet"` success event does not enter selection. |
| Pet attacks, autocasts, crits, damage, death, dismiss, and summon | Not implemented | No pet lifecycle, pet combat-log, pet unit, or pet spell events are registered. |
| Pet identity and ownership | Not implemented | No runtime use of pet name, GUID, creature family, or owner attribution exists. |

The addon frame currently registers combat transitions, defensive `UNIT_COMBAT`, and ability `UNIT_SPELLCAST_SUCCEEDED`. `Runtime.EventTrigger` maps only player combat entry/exit, while the spell classifier requires the unit string `player`. The product specification also states that pets remain unsupported by the first ability increment.

## Potential API observations requiring in-game verification

These are investigation candidates, not implementation recommendations or claims of Forever support:

- **Pet identity and lifecycle:** test the availability, readability, and ordering of `UNIT_PET` plus guarded `UnitExists("pet")`, `UnitGUID("pet")`, `UnitName("pet")`, and `UnitCreatureFamily("pet")` before and after call, dismiss, revive, death, stable changes, zoning, and relogging.
- **Pet casts and autocasts:** capture whether `UNIT_SPELLCAST_SUCCEEDED` is delivered with `unitTarget == "pet"`, whether spell IDs are readable, and whether manually commanded and autocast executions are distinguishable. Never infer player intent merely because the owner enabled autocast.
- **Attack start/stop:** determine whether any ordinary event reliably represents the pet beginning and ending attacks. A command, target acquisition, first swing, target death, disengagement, and follow/passive mode are different transitions and may duplicate or race.
- **Damage and criticals:** if combat-log or unit-combat evidence is explored, verify access and secrecy in every supported activity, attribute source GUID to the current player pet, and distinguish direct hits, periodic damage, reflected damage, guardians such as Summon Hawk, and other players' pets.
- **Death and ownership:** verify pet death separately from dismiss, despawn, range loss, zoning, stable replacement, and owner death. Cache only the minimum safely readable identity needed to preserve the pet name after the unit token disappears.
- **Pet target context:** verify `UnitExists("pettarget")`, name, GUID, and pronoun inputs at event time. The current target must not be substituted when it is unrelated to the pet's target.

Every candidate needs open-world, dungeon, raid, PvP, combat, and out-of-combat checks as applicable. Registration failure, secret/unreadable values, missing ownership, or ambiguous duplicate events must fail closed. No combat-log payload, target identity, family, or pet action should be assumed readable from Classic or retail behavior.

## Design risks and owner decisions

1. Decide whether future pet reactions should remain three generic lifecycle/combat pools or whether a separately scoped pet-ability layer is wanted. The Pets tab must not be folded into the player's Hunter ability catalogue by default.
2. Define whether reactions may follow pet AI/autocasts, explicit player commands only, or both. The source inventory cannot answer this.
3. Define semantics for attack start/stop and death before choosing events, especially target switches, repeated commands, dismissals, and resummons.
4. Decide the minimum pet context required for eligible output. Existing content frequently requires `PNAME` and sometimes `TARGET` or `PTOP`; unavailable relevant values should make those entries ineligible rather than guessed.
5. Treat Summon Hawk as a Hunter class activation and its later guardian attacks as separate pet/guardian behavior unless client evidence establishes otherwise.

## Provisional disposition

Preserve the 31 Pets-tab records as research evidence and preserve all 27 generic pet-event reactions unchanged. Do not add pet-owned skills to `Data/Abilities/Hunter.lua`, do not create spell-ID mappings, and do not enable the dormant pet triggers until identity, ownership, command/autocast semantics, event ordering, restricted-value behavior, and output context are verified in WoW Forever.

The row-level pet and content evidence is in [the Hunter pet reconciliation CSV](hunter_pet_reconciliation.csv).

## Implementation status

The approved Hunter catalogue implementation leaves this research inventory unchanged. No Pets-tab identity was promoted, no pet-owned ability was registered, and no pet lifecycle, ownership, spellcasting, autocast, combat, or event-dispatch behavior was added. All 78 reactions in `Data/Classes/Hunter.lua`, including the 27 reactions across `petattackstart`, `petattackstop`, and `petdies`, remain active and unchanged as content pools only; their runtime detection status remains deferred.
