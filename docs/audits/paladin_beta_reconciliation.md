# Paladin beta ability reconciliation

Research snapshot only. This report proposes dispositions for owner review; it does not authorize catalogue, archive, spell-ID, detection, settings, migration, or content changes.

## Sources and limitations

The primary [Paladin spellbook](https://wowforevertalent.com/abilities/paladin/) was retrieved on **19 October 2026**. It identifies the **16 October 2026 Forever Beta book, client 1.60.1.70425** and contains **167 recorded ranks grouped into 54 non-General identities**: 23 Holy, 23 Protection, and eight Retribution. Six General entries bring the source inventory to 60 identities and 173 recorded tooltips. This independently verifies the stated 23/23/8 totals. The page reports no Classic-fallback or name-only records, but it is an independent dataset rather than an in-game check.

The [Paladin talent reference](https://wowforevertalent.com/paladin/reference/) was retrieved the same day. It uses the 16 October export and contains 50 talents across three trees. Its eight direct activations—Voice of Truth, Divine Favor, Holy Shock, Light's Vigil, Swift Judgement, Templar's Bulwark, Holy Shield, and Repentance—are all represented in the spellbook. The other 42 talent identities are passive or triggered modifiers. Blessing of Kings and Consecration are now trainable rather than talents.

The [changelog](https://wowforevertalent.com/changelog/) records client build 1.60.1.70425, talent data revision `beta-20261017-9b3c9915`, and share-link revision `beta-20261016-56046fb6`. Its 16 October entry says talents and spellbooks use the build-70425 export; the 17 October baseline correction adds Salvation/Revoke notes without superseding the identity inventory. The [racial reference](https://wowforevertalent.com/racials/) states that Priests remain the one class with race-specific spells. It exposes ordinary playable-race abilities for Paladin races, but no Paladin-specific racial spell catalogue.

The sources expose names, ranks, levels, acquisition hints, costs, ranges, cast times, cooldowns, requirements, and tooltip effects, but no numeric spell IDs. They have not verified the spells in game. Spellbook presence does not establish learned availability, successful-cast readability, or event semantics.

Repository evidence is the loaded `RPHelper/Data/Abilities/Paladin.lua`, `RPHelper/Data/Classes/Paladin.lua`, `RPHelper/Core/Content.lua`, the earlier coverage audit and inventory, and prior class reconciliation reports.

## Reconciliation totals

The CSV contains every current spellbook identity, every General entry, and every current Paladin definition absent from the class tabs.

| Classification | Rows | Current ability reactions | Existing empty definitions |
| --- | ---: | ---: | ---: |
| Confirmed, existing | 45 | 86 | 3 |
| Confirmed, missing | 7 | 0 | 0 |
| Rename/replacement candidate | 2 | 0 | 0 |
| Historical replacement source | 2 | 2 | 1 |
| Not found in beta | 6 | 15 | 0 |
| General-tab exclusion | 6 | 0 | 0 |
| **CSV total** | **68** | **103** | **4** |

All 54 class-tab identities are universal Paladin abilities; the current sources identify no Paladin-specific racial abilities. Forty-five already have exact canonical definitions, including the empty Greater Blessing of Kings, Light, and Wisdom pools. Nine beta identities are absent: seven wholly missing identities and two explicit Salvation-family replacement candidates.

The current catalogue has **53 definitions**: 49 populated pools and four empty Greater Blessing definitions. Eight definitions are absent from the beta class tabs. Every current definition is accounted for in the CSV.

## Active talents and triggered effects

The eight direct talent activations split evenly:

- Existing: Divine Favor, Holy Shock, Holy Shield, and Repentance.
- Missing: Light's Vigil, Voice of Truth, Swift Judgement, and Templar's Bulwark.

The remaining 42 talent identities are passive or triggered effects and are not missing direct-activation catalogue entries. Examples include Improved Seal of Fury, Infusion of Light, Consecrated Ground, Reckoning, Iron Creed, Sacred Arbiter, Sanctified Judgement, and Twist of Light. Named procs, echoes, cooldown resets, mana returns, retaliation, and triggered damage or healing do not warrant separate registrations.

## Seals and Judgement

The beta has seven player-cast seals:

| Spellbook section | Seals |
| --- | --- |
| Holy | Seal of Light, Seal of Righteousness, Seal of Wisdom |
| Protection | Seal of Fury, Seal of Justice |
| Retribution | Seal of Command, Seal of the Crusader |

Six exactly match populated definitions. **Seal of Fury** is the missing new tanking seal. Its melee Holy damage, shield-dependent absorb, full-absorb mana restoration talent, and Judgement taunt are triggered or conditional effects, not extra player activations.

**Judgement** remains one player-cast Retribution identity and retains two reactions. It no longer consumes the active seal. The effect released depends on the active seal; judging Seal of Fury additionally taunts for four seconds. A seal cast, a Judgement cast, on-hit seal effects, shield absorbs, and the taunt consequence are distinct runtime observations.

Crusader Strike is absent while Holy Strike is a new baseline strike. Their theme overlaps, but the sources call Holy Strike new and do not state that it is a canonical rename. Reassociation of Crusader Strike's three reactions therefore requires an owner decision rather than an automatic migration.

## Blessings and Salvation

The beta contains seven individual Blessings: Light, Wisdom, Freedom, Kings, Protection, Sacrifice, and Might. It contains exactly four Greater Blessings: Light, Wisdom, Kings, and Might. All eleven already have definitions; the Greater Light, Wisdom, and Kings pools are empty. No Greater Blessing of Sanctuary is implied by Blessing availability, and neither individual nor Greater Sanctuary appears.

Salvation and Mass Salvation are now standalone Protection spells which can coexist with Blessings. The source explicitly says they replace the former blessings:

- `BLESSING_OF_SALVATION` → **Salvation** is a strong canonical replacement candidate. The historical key retains two reactions.
- `GREATER_BLESSING_OF_SALVATION` → **Mass Salvation** is a strong canonical replacement candidate. The historical definition is empty.
- **Revoke** is a new cast which removes Salvation or Mass Salvation from a party or raid member. It is not a passive modifier and is missing.

Blessing of Sanctuary is beta-absent with two reactions. Greater Blessing of Salvation is the fourth current empty definition. Any removal, rename, or reassociation must preserve player-owned settings, custom scopes, authored order, and historical keys recoverably.

## Auras

Six player-activated auras are confirmed: Concentration, Devotion, Fire Resistance, Frost Resistance, Shadow Resistance, and Retribution. All six have populated definitions with two reactions each.

Sanctity Aura is absent from the spellbook and active talent list but retains two reactions. Aura activation is distinct from the persistent aura state, resistance/mitigation, and Retribution Aura's triggered damage. No passive aura tick or retaliation effect should become a separate registration.

## Other missing and historical identities

Beyond the four missing active talents, Seal of Fury, and Revoke, **Holy Strike** is a missing baseline ability. Salvation and Mass Salvation are replacement candidates as described above.

Six current identities are simply absent from the beta sources: Blessing of Sanctuary, Bulwark of the Righteous, Crusader Strike, Hand of Reckoning, Sanctity Aura, and Summon Warhorse. Absence is not proof that their player-owned records may be deleted.

There are thematic relationships that are insufficient for automatic canonical migration:

- Bulwark of the Righteous and Templar's Bulwark have different names and recorded mechanics; the former holds three reactions.
- Crusader Strike and Holy Strike are both melee Holy attacks; the former holds three reactions, but Holy Strike is explicitly described as new.
- Hand of Reckoning and Judgement of Seal of Fury can both taunt; Hand of Reckoning holds three reactions, while the beta represents the new taunt as a conditional Judgement effect rather than an independent spellbook identity.
- Summon Warhorse is absent from the class tabs and may now be represented through the mount system rather than a class spell. It retains two reactions.

These require owner decisions on retention, archive, or carefully scoped reassociation. Research does not infer renames from thematic similarity.

## Authored content preservation

`Data/Abilities/Paladin.lua` contains **103 reactions across 49 populated identities**: 54 `say`, zero Blizzard `emote`, and 49 `customemote`. Four additional definitions have empty pools. The CSV records counts for every identity.

The 45 beta-confirmed existing identities account for 86 reactions. The eight beta-absent definitions account for the remaining 17: Blessing of Salvation two, Blessing of Sanctuary two, Bulwark of the Righteous three, Crusader Strike three, Greater Blessing of Salvation zero, Hand of Reckoning three, Sanctity Aura two, and Summon Warhorse two.

The separate class file contains **50 reactions**: 37 `say`, two Blizzard `emote`, and 11 `customemote`.

| Trigger | `say` | `emote` | `customemote` | Total |
| --- | ---: | ---: | ---: | ---: |
| `entercombat` | 10 | 1 | 1 | 12 |
| `leavecombat` | 2 | 0 | 1 | 3 |
| `hurt` | 2 | 0 | 1 | 3 |
| `absorb` | 2 | 0 | 1 | 3 |
| `block` | 2 | 0 | 1 | 3 |
| `dodge` | 2 | 0 | 1 | 3 |
| `miss` | 2 | 0 | 1 | 3 |
| `parry` | 2 | 0 | 1 | 3 |
| `youcrit` | 3 | 1 | 0 | 4 |
| `deferred_youcritspell` | 2 | 0 | 1 | 3 |
| `youheal` | 2 | 0 | 1 | 3 |
| `youcritheal` | 2 | 0 | 1 | 3 |
| `resurrect` | 4 | 0 | 0 | 4 |
| **Total** | **37** | **2** | **11** | **50** |

The ability file repeats each populated identity heading before its `say` group and again before its `customemote` group, producing 49 duplicate heading pairs. It uses a consolidated loop for four empty definitions and is not organized by current specialization. These are formatting and authoring inconsistencies only; Stage 1 changes none of them. No duplicate reaction registration was found beyond intentional multiple reactions per identity.

## Racial and historical considerations

The racial source identifies no Paladin-specific racial spells and explicitly reserves class-specific racial spells to Priests. Human, Dwarf, and Undead Paladins have their ordinary race abilities, but those belong to the race layer rather than `Paladin.lua`.

Historical mount handling, Sanctuary, and beta-absent talent or custom identities remain preservation questions. A later archive or migration must not delete or rewrite player-owned settings, disabled-default IDs, or custom reaction records merely because an identity is no longer active.

## Runtime feasibility

- Seal activation, seal replacement, Judgement, on-hit effects, Twist of Light echoes, Seal of Fury absorbs, and Judgement of Fury's taunt must be distinguished. Judgement not consuming the seal changes state assumptions but does not create another activation.
- Auras are persistent toggles. Activation is the candidate event; passive resistance, mitigation, threat, or retaliation is not a repeated cast.
- Individual and Greater Blessings are separate casts. Salvation and Mass Salvation are separate non-Blessing buffs, and Revoke is its own targeted removal cast.
- Flash of Light, Holy Light, Light's Vigil, Redemption, Hammer of Wrath, and other cast-time spells require completed-cast observation; instant heals such as Holy Shock and Lay on Hands still require successful-target and restriction checks.
- Light's Vigil's later Holy Shock interaction, refund, damage/heal, and party heal are triggered consequences. Divine Favor and Swift Judgement modify a later spell rather than recasting it.
- Holy Shield activation is distinct from block-triggered damage and charge use. Seal of Fury's shield effects require a shield and must not be inferred from the seal button press alone.
- Blessing of Protection, Divine Protection, Divine Shield, Templar's Bulwark, and Lay on Hands interact with Forbearance or other restrictions. Failed attempts must not react.
- `UNIT_SPELLCAST_SUCCEEDED` may be relevant for readable ordinary casts, but restricted payloads, instant attacks, aura toggles, conditional/reactive actions, target validation, and triggered effects require client verification. No Paladin spell IDs are added or endorsed here.

## Owner decisions required

1. Approve or reject empty definitions for Light's Vigil, Voice of Truth, Revoke, Seal of Fury, Swift Judgement, Templar's Bulwark, and Holy Strike.
2. Approve `BLESSING_OF_SALVATION` → `SALVATION` and `GREATER_BLESSING_OF_SALVATION` → `MASS_SALVATION`, including SavedVariables compatibility and preservation of the two existing Salvation reactions.
3. Decide whether Bulwark of the Righteous, Crusader Strike, and Hand of Reckoning content is retained under historical identities, archived, or explicitly reassociated with Templar's Bulwark, Holy Strike, or Judgement. The sources do not prove canonical renames.
4. Decide preservation treatment for Blessing of Sanctuary, Sanctity Aura, and Summon Warhorse and their six reactions.
5. Confirm the four actual Greater Blessings and reject inference of nonexistent Greater variants.
6. Defer spell-ID and runtime work until seal/Judgement state, triggered effects, aura toggles, Salvation buffs, healing/rez targeting, shield requirements, Forbearance, and readable success events are verified in the client.

## Provisional Stage 2 disposition

Subject to owner approval, a later implementation could retain the 45 exact beta identities and their 86 reactions; add seven empty definitions; and replace the two Salvation keys through explicit narrow migrations, preserving their two reactions and all player-owned records. The other six beta-absent identities should remain active exceptions or move to an unloaded archive only after individual preservation decisions. No reaction should be transferred among Bulwark, Strike, or taunt identities merely because their themes overlap.

All 50 class-trigger reactions remain unchanged. No race-specific Paladin section, archive, migration, reaction transfer, spell-ID mapping, or runtime change is authorized by this research. Complete row-level evidence is in [the Paladin reconciliation CSV](paladin_beta_reconciliation.csv).

## Approved Implementation Disposition

The owner-approved implementation registers exactly 54 active identities, organized under Holy, Protection, and Retribution. It retains the 45 exact beta identities and their 86 reactions, adds empty definitions for Light's Vigil, Voice of Truth, Revoke, Seal of Fury, Swift Judgement, Templar's Bulwark, and Holy Strike, and adds empty `MASS_SALVATION` as the approved replacement for `GREATER_BLESSING_OF_SALVATION`.

`BLESSING_OF_SALVATION` is replaced by `SALVATION`, preserving its two reactions byte-for-byte. A narrow, idempotent SavedVariables migration covers only these two approved identity mappings. Old-only settings move to the canonical key; when both keys exist, the canonical destination wins and the historical record remains recoverable. Matching Paladin ability custom scopes are updated without changing their content or metadata. Disabled-default migration is limited to the two shipped Blessing of Salvation reaction IDs; no Greater Blessing default-ID mapping or prefix-wide inference is made.

An unloaded archive preserves eight historical keys. The two replaced Salvation keys have empty archive pools; Blessing of Sanctuary, Bulwark of the Righteous, Crusader Strike, Hand of Reckoning, Sanctity Aura, and Summon Warhorse retain their 15 reactions under their original identities. No Bulwark, Strike, or taunt content is reassociated.

The implemented preservation total is **153 authored reactions**: 88 active ability reactions, 15 unloaded archive reactions, and 50 unchanged class-trigger reactions. Paladin spell IDs, event mappings, and all client-dependent runtime behavior remain deferred.
