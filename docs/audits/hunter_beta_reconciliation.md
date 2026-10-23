# Hunter beta ability reconciliation

Research snapshot only. This report proposes dispositions for owner review; it does not authorize catalogue, archive, spell-ID, detection, settings, or content changes. Pet-owned abilities and pet-event content are covered separately in [the Hunter pet report](hunter_pet_reconciliation.md).

## Sources and limitations

The primary [Hunter spellbook](https://wowforevertalent.com/abilities/hunter/) was retrieved on **16 October 2026**. It identifies the **16 October 2026 Forever Beta book, client 1.60.1.70425** and contains **145 recorded ranks grouped into 58 class-specific identities**: 20 Beast Mastery, 17 Marksmanship, and 21 Survival. The same page has 31 Pets-tab identities (153 ranks) and eight General records, for 97 identity groups and 306 tooltips overall. It reports no Classic-fallback or name-only records, but it is not an in-game check.

The linked [Hunter talent reference](https://wowforevertalent.com/hunter/reference/) uses the same 16 October export (`beta-20261016-56046fb6`). Its nine active talents—Summon Hawk, Intimidation, Bestial Wrath, Trueshot Aura, Scatter Shot, Sniper Shot, Deterrence, Counterattack, and Strider Kick—are all present in the spellbook, so the talent audit adds no separate identity.

The retrieved [changelog](https://wowforevertalent.com/changelog/) says talents and spellbooks moved to build 70425 on 16 October and records an earlier 4 October Summon Hawk tooltip correction. No later entry supersedes this book. The site explicitly says the records have not all been independently checked in game.

The source exposes ranks, levels, talent acquisition, ranges, timing, cooldowns, and requirements, but not numeric spell IDs. Candidate IDs in the CSV are carried from the earlier mixed-source research inventory and remain unverified; blanks are intentional. Spellbook presence does not prove that `UNIT_SPELLCAST_SUCCEEDED` supplies a readable, attributable event for any identity.

Source B is the actual `RPHelper.RegisterAbility` path in `RPHelper/Data/Abilities/Hunter.lua`. It defines **49 canonical identities and 155 authored reactions**: 106 `say`, one `emote`, and 48 `customemote`. Every definition has authored content; there are **no empty shipped pools**. This research changes none of them.

## Reconciliation totals

The CSV retains all 66 beta class/General identities and all 49 RPHelper identities. Forty-six identities overlap and three historical definitions are absent, producing **69 reconciled identities**.

| Classification | Identities | Authored reactions | Empty RPHelper definitions |
| --- | ---: | ---: | ---: |
| Confirmed, existing | 46 | 141 | 0 |
| Confirmed, missing | 20 | 0 | 0 |
| Not found in beta | 3 | 14 | 0 |
| **Total** | **69** | **155** | **0** |

Beta presence, activation eligibility, and v1 inclusion are separate:

- All **58 class-tab identities** are directly player activated and in v1 reconciliation scope. They comprise **46 existing** and **12 missing** definitions.
- The eight General identities remain research evidence but are outside v1 scope. Attack, Throw, and Beast Training are activatable controls; Dual Wield, Armor Proficiency, Dodge, Parry, and Languages are passive. Their exclusion is a scope decision, not a claim of absence.
- The 31 Pets-tab identities are neither counted as class activations nor automatically promoted. Their ownership and activation questions are in the paired pet inventory.

## Existing coverage

The 46 exact class matches account for 141 reactions. Coverage includes every currently listed Aspect, the existing tracking set, all four traps, the established ranged attacks and stings, and the active talents Bestial Wrath, Trueshot Aura, Scatter Shot, Deterrence, and Counterattack.

Raptor Strike, Mongoose Bite, and Counterattack are already separately represented and must remain distinct. Their melee conditions differ: Raptor Strike is queued for the next melee swing, Mongoose Bite is reactive after a dodge, and Counterattack is reactive after a parry and talent-granted. Similar Survival placement does not make them aliases.

## Missing active abilities

Twelve beta-confirmed class activations are absent from the catalogue:

- **Beast Mastery:** Call Pet, Dismiss Pet, Feed Pet, Intimidation, Revive Pet, Summon Hawk, and Tame Beast.
- **Marksmanship:** Auto Shot, Enchanted Flare, and Sniper Shot.
- **Survival:** Lacerate and Strider Kick.

Summon Hawk, Sniper Shot, Intimidation, and Strider Kick are active talents. The talent reference adds no active ability missing from the spellbook. Enchanted Flare and Flare are separately listed identities with different cooldowns and should not be merged. Auto Shot is a player control even though its repeated attacks are automatic after activation.

The eight missing General records are out of scope and should not be promoted automatically. Feed Pet is not on the General tab in this snapshot—it is a Beast Mastery class identity—so the earlier policy example does not exclude it here.

## Legacy, rename, and replacement candidates

- **Aspect of the Wolf**, **Carve**, and **Steady Shot** are absent from the current spellbook and active-talent reference. Together they retain 14 authored reactions. Snapshot absence does not establish permanent removal or authorize content deletion.
- The book lists Lacerate but not Carve. This is not sufficient evidence that Lacerate replaced Carve, and their mechanics and content should not be transferred without an explicit owner decision.
- Sniper Shot is not an automatic rename of Steady Shot. Their names, talent/training provenance, timing, and recorded mechanics differ.
- Enchanted Flare is a separate spellbook identity, not an alias or upgraded rank of Flare.

No supported canonical rename or SavedVariables migration is established by this research.

## Activation and detection considerations

- Raptor Strike is a queued **next-melee** action. A button activation, successful queue, replacement of a queued strike, and eventual weapon impact are different observations.
- Mongoose Bite and Counterattack become available after dodge/parry conditions; availability and proc highlighting are not activations. Strider Kick is an ordinary talent activation, while Lacerate is an instant trained melee attack.
- Auto Shot is a toggle/control whose subsequent repeated shots must not be treated as repeated player activations without verified event semantics.
- Eagle Eye, Mend Pet, Tame Beast, and Volley are channelled; Dismiss Pet, Eyes of the Beast, Aimed Shot, Scare Beast, and Sniper Shot have cast times. Interrupted starts and channel ticks are not successful activations.
- Traps, Flare, and Enchanted Flare create placed effects. Placement, triggering, damage, and aura application must not be conflated with the player's activation.
- Call, Dismiss, Feed, Mend, Revive, Tame, Eyes of the Beast, Bestial Wrath, and Intimidation interact with pet state. A hunter command is not the same identity as a later pet-owned cast or attack.

Production currently maps no Hunter spell IDs. The existing runtime accepts only exact readable `player` success events and explicitly rejects `pet`, so neither class presence nor candidate IDs establish detectability.

## Owner decisions required

1. Approve or reject empty definitions for the 12 missing class identities, retaining Enchanted Flare separately from Flare.
2. Decide whether Aspect of the Wolf, Carve, and Steady Shot remain active legacy exceptions or move to a later unloaded archive while preserving all 14 reactions and player-owned data.
3. Confirm that no reactions or saved settings move from Carve to Lacerate or from Steady Shot to Sniper Shot without separately verified replacement evidence.
4. Defer spell-ID mapping and event handling until queued melee, Auto Shot, channels, traps, and hunter-command versus pet-action behavior are verified in client.

## Provisional implementation disposition

Subject to owner approval, a later catalogue-only implementation could retain the 46 confirmed identities and 141 reactions, add the 12 missing class identities as empty definitions, and leave all General and Pets-tab records outside the player class catalogue. The three beta-absent definitions require explicit preservation dispositions. No archive, migration, reaction transfer, pet-ability registration, spell-ID mapping, or runtime change is authorized by this research.

The complete row-level evidence is in [the Hunter reconciliation CSV](hunter_beta_reconciliation.csv).

## Approved implementation disposition

The owner approved a catalogue-only implementation after this research:

- Retain all 46 beta-confirmed identities and their 141 authored reactions without changing canonical associations, text, types, within-ability ordering, or generated default IDs.
- Add empty definitions for Call Pet, Dismiss Pet, Feed Pet, Intimidation, Revive Pet, Summon Hawk, Tame Beast, Auto Shot, Enchanted Flare, Sniper Shot, Lacerate, and Strider Kick. Flare/Enchanted Flare, Carve/Lacerate, and Steady Shot/Sniper Shot remain distinct identities with no reaction transfer.
- Remove Aspect of the Wolf, Carve, and Steady Shot from the active catalogue and preserve their 14 reactions unchanged and in order in an unloaded archive.
- Keep all General-tab and Pets-tab identities outside the Hunter ability catalogue. Preserve player-owned settings and custom reactions under archived keys without migration or deletion.

The resulting active catalogue contains **58 unique Hunter identities**, **141 active authored reactions**, and 12 empty shipped pools. The unloaded archive accounts for 14 additional reactions; the unchanged Hunter class-content file accounts for 78, preserving all **233 authored Hunter reactions** overall. No pet implementation, persistence migration, spell-ID mapping, or runtime-detection change is authorized.
