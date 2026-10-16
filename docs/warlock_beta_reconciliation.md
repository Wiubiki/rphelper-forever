# Warlock beta ability reconciliation

Research snapshot only. This report proposes dispositions for owner review; it does not authorize catalogue, archive, spell-ID, detection, settings, migration, or content changes. Demon-owned abilities and demon-event content are covered separately in [the Warlock demon report](warlock_demon_reconciliation.md).

## Sources and limitations

The primary [Warlock spellbook](https://wowforevertalent.com/abilities/warlock/) was retrieved on **16 October 2026**. Contrary to the possible older-export warning in the task, the retrieved page identifies the **16 October 2026 Forever Beta book, client 1.60.1.70425**. It contains **171 recorded ranks grouped into 53 class identities**: 18 Affliction, 25 Demonology, and ten Destruction. Sixteen Demons-tab identities add 63 ranks. Five General records bring the source to 74 identity groups and 239 tooltips. The page reports no Classic-fallback or name-only records, but it is not an in-game check.

The linked [Warlock talent reference](https://wowforevertalent.com/warlock/reference/) uses the same 16 October export (`beta-20261016-56046fb6`). Its 11 active talents—Amplify Curse, Curse of Exhaustion, Siphon Life, Wrack, Demonic Sacrifice, Fel Domination, Soul Link, Shadowburn, Conflagrate, Bane of Havoc, and Incinerate—are all present in the spellbook. The other 41 talent identities are passive or triggered effects, not separate player activations. Demonic Brand and Demonic Pact are retained as explicit supplemental CSV evidence because of their demon interactions.

The retrieved [changelog](https://wowforevertalent.com/changelog/) confirms the 16 October build-70425 update and an 8 October Demonic Brand correction. No later entry supersedes the retrieved book. The source repeatedly warns that records have not all been independently verified in game.

The primary pages expose ranks, levels, talent acquisition, reagents, timing, cooldowns, and requirements, but not numeric spell IDs. Candidate IDs in the CSV come from the earlier mixed-source research inventory and remain unverified; blanks are intentional. Spellbook or talent presence does not establish readable successful-cast events.

Source B is the actual `RPHelper.RegisterAbility` path in `RPHelper/Data/Abilities/Warlock.lua`, including its consolidated empty-definition loop. It defines **58 canonical identities and 56 authored reactions**: 48 `say`, two `emote`, and six `customemote`. Twenty-six definitions have reactions and **32 have empty shipped pools**. This research changes none of them.

## Reconciliation totals

The player CSV contains 70 spellbook/catalogue identity rows plus two supplemental passive-talent rows. Forty-six spellbook identities are exact catalogue matches. Three source names and three historical names form separately retained rename candidates.

| Classification | Identities | Authored reactions | Empty existing definitions |
| --- | ---: | ---: | ---: |
| Confirmed, existing | 46 | 49 | 24 |
| Confirmed, missing | 9 | 0 | 0 |
| Rename/replacement candidate | 6 | 5 | 0 |
| Not found in beta | 9 | 2 | 8 |
| Talent-only passive evidence | 2 | 0 | 0 |
| **CSV total** | **72** | **56** | **32** |

Beta presence, activation eligibility, and scope remain separate:

- All **53 class-tab identities** are direct player activations and in v1 reconciliation scope. Forty-six have exact active definitions, three are proposed successor names, and four are wholly missing.
- The five General entries remain research evidence and are outside v1 scope. Attack and Shoot are activatable controls; Armor Proficiency, Dodge, and Languages are passive.
- The 16 Demons-tab identities are demon-owned and are not player class-catalogue candidates.

## Exact existing and missing coverage

The 46 exact class matches account for 49 reactions. They include all exact current curses, drains, creation spells, armor spells, rituals, existing summon spells, and nine of the 11 active talents.

Four beta-confirmed class abilities are missing without a historical same-mechanic key:

- **Wrack**, an active Affliction talent and channel.
- **Summon Incubus**, a separate Demonology summon identity alongside Summon Succubus.
- **Bane of Havoc**, an active Destruction talent whose later mirrored damage is a triggered effect, not another activation.
- **Incinerate**, an active Destruction talent with three ranks.

The five General records are also technically absent from RPHelper but remain out of scope.

## Rename and replacement evidence

Three pairs warrant explicit migration review:

- **Curse of Agony → Bane of Agony.** The beta retains six ranks at the same learn levels; the comparison text describes the Classic Curse wording, while candidate IDs match the historical family. Mechanics remain the same damage-over-time family but recorded values and Bane exclusivity changed.
- **Curse of Doom → Bane of Doom.** The source directly compares the Bane tooltip with Classic Curse of Doom, and the candidate ID remains `603`. Damage values changed, but the one-minute delayed damage and possible Doomguard result persist.
- **Enslave Demon → Subjugate Demon.** The beta has the same three candidate IDs (`1098`, `11725`, `11726`) and the same control/slowing mechanics under the new name. This is strong rename evidence, not permission to mutate saved data during research.

A later approved implementation would need a narrow, idempotent compatibility decision for user-authored scopes, per-ability settings, and disabled-default IDs. Existing bundled reactions—one for Curse of Agony, three for Curse of Doom, and one for Enslave Demon—must not be duplicated or silently lost. Conflicting or malformed saved values require conservative preservation.

## Legacy-only candidates

Nine existing identities have no current spellbook or active-talent match:

- **Curse of Shadow** retains two reactions. Curse of the Elements now reduces all Magic resistances, but that broader mechanic does not by itself authorize content transfer.
- **Dark Harvest, Dark Pact, Demon Portal, Mana Funnel, Summon Dreadsteed, and Summon Felsteed** are empty historical definitions.
- **Detect Greater Invisibility** and **Detect Lesser Invisibility** are empty historical rank-style identities. The beta groups three ranks under Detect Invisibility, which already exists separately in RPHelper; consolidation is plausible but not established as a canonical migration requirement.

Absence from this snapshot is not proof of permanent removal. Player-owned records under every historical key must remain preserved unless a later implementation explicitly authorizes migration.

## Passive and triggered talent effects

The talent reference marks **Demonic Brand** and **Demonic Pact** passive. Demonic Brand modifies Searing Pain and causes later demon attacks to consume a brand; those pet attacks are triggered outcomes, not player activations of Demonic Brand. Demonic Pact changes whether Demonic Sacrifice persists when another demon is summoned and is likewise not an ability button. Nightfall, Pandemic, Improved Drains, Soul Siphon, Bane, and the other passive talents remain outside direct-activation scope even when they modify confirmed abilities.

## Casting and detection considerations

- Drain Life, Drain Mana, Drain Soul, Health Funnel, Wrack, Hellfire, and Rain of Fire are channelled. A channel start, tick, interruption, and successful activation are different observations.
- Create Firestone, Healthstone, Soulstone, and Spellstone create items and use casts/reagents; item use is a different identity.
- Ritual of Summoning and Ritual of Doom require other participants. Portal interaction, participant sacrifice, and resulting summon behavior must not be attributed as repeat casts.
- Bane of Doom can summon a Doomguard after later damage. Bane of Havoc mirrors later damage. Those triggered effects must not be classified as fresh player activations.
- Inferno and Ritual of Doom create temporary or initially uncontrolled demons. Summon spells, demon appearance, ownership changes, subjugation, and later demon actions require separate evidence.
- Production currently maps no Warlock spell IDs. The shipped classifier accepts only exact readable `player` success events and rejects `pet` events.

## Owner decisions required

1. Approve or reject empty definitions for Wrack, Summon Incubus, Bane of Havoc, and Incinerate.
2. Confirm or reject the three proposed canonical renames and, if approved, authorize narrowly scoped SavedVariables compatibility and bundled-reaction preservation.
3. Decide whether the nine legacy-only identities remain active exceptions or move to an unloaded archive; do not infer that Curse of Shadow content belongs to Curse of the Elements.
4. Confirm Detect Greater/Lesser Invisibility as obsolete historical rank splits rather than independent active identities.
5. Defer all spell-ID and runtime work until channels, rituals, item creation, delayed/triggered effects, summons, and demon ownership are verified in client.

## Provisional implementation disposition

Subject to owner approval, a later catalogue implementation could retain the 46 exact identities and 49 reactions, add the four wholly missing active abilities as empty definitions, and apply separately approved canonical replacements for the three rename pairs. General and Demons-tab records remain outside the player catalogue. The nine legacy-only identities require explicit preservation decisions. No archive, migration, reaction transfer, mapping, or runtime change is authorized by this research.

The complete row-level evidence is in [the Warlock reconciliation CSV](warlock_beta_reconciliation.csv).
