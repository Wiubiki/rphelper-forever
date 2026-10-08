# Content Engine Specification

This document defines the intended RPHelper Forever content-processing contract. It is a design specification, not a claim that the described keyword or trigger support is implemented.

## Compatibility status

Legacy APIs and assumptions must be validated against the WoW Forever client before implementation. Player-owned information is expected to be the most straightforward. Target and enemy information may be conditional or restricted during combat; pet-target information also requires validation. Guild, zone, mount, and power APIs may differ from their legacy equivalents.

The statuses below mean:

- **V1 supported:** intended for V1, subject to final API and in-game validation.
- **V1 conditional:** intended only when the value is safely available in the current context.
- **Deferred:** retained as a possible later capability, but not required for V1.
- **Dropped/replaced:** the legacy behavior should not be carried forward as designed.

Final statuses may change after WoW Forever testing.

## Legacy keyword inventory

The inventory covers keywords documented in `How to Customize.txt`, implemented in `RPhelper_twow_ReplaceKeywords.lua`, or used by the legacy English catalogue with a dedicated replacement path.

### Generated and player-owned values

| Keyword | Intended meaning | Legacy source | Forever status and caveats |
| --- | --- | --- | --- |
| `RINSULT` | Random insult; `RINSULT!` changes terminal punctuation to an exclamation mark. | `RandInsult()` | **V1 conditional.** Intended to return with the content engine, but the generator must be redesigned for Forever. Availability checking and substitution must use the same resolved insult rather than copying the legacy repeated-random-call behavior. The legacy `RInsult.lua` catalogue can be migrated separately. |
| `PLAYER` | Player name. | `UnitName("player")` | **V1 supported.** Player-owned, but name formatting must be defined. |
| `SP` | Player subject pronoun. | `UnitSex("player")` plus hard-coded locale tables | **V1 supported.** English V1 needs an explicit pronoun policy; do not copy the legacy binary/neutral mapping blindly. |
| `OP` | Player object pronoun. | Same as `SP` | **V1 supported.** Same pronoun and localization caveats. |
| `PP` | Player possessive pronoun. | Same as `SP` | **V1 supported.** Same pronoun and localization caveats. |
| `PLAYER_CLASS` | Player class name. | `UnitClass("player")` | **V1 supported.** Use an appropriate localized or canonical value for the content contract. |
| `PLAYER_RACE` | Player race name. | `UnitRace("player")` | **V1 supported.** Includes WoW Forever races only after client validation. |
| `PLAYER_GUILDNAME` | Player guild name. | `GetGuildInfo("player")` | **V1 conditional.** Ineligible when the player is unguilded or the value is unavailable. |
| `PLAYER_GUILDRANK` | Player guild-rank name. | `GetGuildInfo("player")` | **V1 conditional.** Requires a guild and an available rank name. |
| `PLAYER_POWER` | Player power type, such as mana, rage, or energy. | `UnitPowerType("player")` with legacy numeric mapping | **V1 conditional.** Modern/custom power types and return values require validation. |
| `LEVEL` | Newly reached player level. | `PLAYER_LEVEL_UP` event argument; replaced outside the general legacy resolver | **V1 conditional.** Available only to a trigger carrying a trustworthy new-level value. |

### Target values

| Keyword | Intended meaning | Legacy source | Forever status and caveats |
| --- | --- | --- | --- |
| `TARGET` | Current target name. | `UnitExists("target")`, `UnitName("target")` | **V1 conditional.** The current target may be unrelated to the trigger; require safe, relevant target context. |
| `TSP` | Target subject pronoun. | `UnitSex("target")` | **V1 conditional.** Requires an available relevant target and the same pronoun policy as player pronouns. |
| `TOP` | Target object pronoun. | Same as `TSP` | **V1 conditional.** Same target and pronoun caveats. |
| `TPP` | Target possessive pronoun. | Same as `TSP` | **V1 conditional.** Same target and pronoun caveats. |
| `TARGET_CLASS` | Target class name. | `UnitClass("target")` after player-target checks | **V1 conditional.** Generally meaningful only for player targets and may be restricted in combat. |
| `TARGET_RACE` | Target race name. | Intended `UnitRace("target")` | **V1 conditional.** The legacy implementation incorrectly calls `UnitRace("player")`; that is a bug, not intended behavior. |
| `TARGET_GUILDNAME` | Target guild name. | `GetGuildInfo("target")` after player-target checks | **V1 conditional.** Requires a safely inspectable, guilded player target. |
| `TARGET_GUILDRANK` | Target guild-rank name. | Same as target guild name | **V1 conditional.** Same restrictions; never invent a value when unavailable. |
| `TARGET_POWER` | Target power type. | `UnitPowerType("target")` with legacy numeric mapping | **V1 conditional.** Requires a relevant target; modern/custom power types and combat restrictions need testing. |

### Pet values

| Keyword | Intended meaning | Legacy source | Forever status and caveats |
| --- | --- | --- | --- |
| `PNAME` | Player pet name. | `UnitExists("pet")`, `UnitName("pet")` | **V1 conditional.** Requires an active pet and relevant pet context. |
| `PTNAME` | Pet target name. | `UnitExists("pettarget")`, `UnitName("pettarget")` | **V1 conditional.** Pet-target availability and restrictions require in-game validation. |
| `PTSP` | Pet target subject pronoun. | `UnitSex("pettarget")` | **V1 conditional.** Requires a safely available pet target and a defined pronoun policy. |
| `PTOP` | Pet target object pronoun. | Same as `PTSP` | **V1 conditional.** Same pet-target caveats. |
| `PTPP` | Pet target possessive pronoun. | Same as `PTSP` | **V1 conditional.** Same pet-target caveats. |

### World, faction, and event values

| Keyword | Intended meaning | Legacy source | Forever status and caveats |
| --- | --- | --- | --- |
| `FFG` | Player's friendly faction group. | `UnitFactionGroup("player")` | **V1 conditional.** Validate WoW Forever faction values and neutral/special cases. |
| `EFG` | Opposing faction group. | Inverted legacy Alliance/Horde result | **Deferred.** The old two-faction assumption may not describe every Forever context; replace only with a validated design. |
| `BGFG` | Player-side battleground faction name. | Hard-coded zone/faction table | **Dropped/replaced.** Do not copy mappings for Arathi Basin, Alterac Valley, and Warsong Gulch; a future design must use current data. |
| `HOME` | Hearthstone bind location. | `GetBindLocation()` | **V1 conditional.** Validate current API behavior and availability. |
| `MAIN_ZONE` | Current main zone. | `GetRealZoneText()` | **V1 conditional.** Validate modern zone naming and instance behavior. |
| `SUB_ZONE` | Current subzone, falling back to the main zone. | `GetSubZoneText()`, then `GetRealZoneText()` | **V1 conditional.** Preserve fallback only when both values are trustworthy. |
| `MOUNT` | Current or just-summoned mount name. | Custom session variable `RPH_MyMount` | **Deferred.** Requires a new Forever-safe source; do not copy session tracking that is blank before the first observed mount. |
| `NPC` | Speaking NPC name. | Documented from legacy monster-chat event sender data; not handled by the inspected general resolver | **Deferred.** Only meaningful for validated NPC-speech triggers. |
| `TEXT` | NPC speech text. | Documented from legacy monster-chat event message data; not handled by the inspected general resolver | **Deferred.** Treat event text as contextual data and validate access restrictions. |
| `LANG` | NPC speech language. | Documented from legacy monster-chat event language data; not handled by the inspected general resolver | **Deferred.** Only meaningful when the client supplies a safe language value. |

`NPC`, `TEXT`, and `LANG` were documented as valid only for `npctalksfriend` and `npctalksenemy`. Forever must not generalize them to unrelated triggers without a new contract.

## Keyword safety and candidate eligibility

Keywords declare required dynamic values for a content candidate:

- If every required keyword resolves safely, the candidate remains eligible.
- If any required value cannot be resolved, is unavailable in the current context, or is restricted/secret, the candidate is ineligible.
- RPHelper must not insert a misleading fallback merely to keep a candidate usable.

For example, `"Die, TARGET!"` must not be selected without a safe, relevant target name. Content requiring a pet, pet target, target class, target guild, or similar context is skipped when that context cannot be safely obtained. RPHelper must not attempt to bypass modern WoW information restrictions.

Forever content uses explicit braced tokens such as `{PLAYER}`, `{TARGET}`, and `{RINSULT}`. This prevents overlapping names such as `PTSP`, `TSP`, and `SP` from corrupting one another. Tokens are data only and never evaluate Lua expressions.

## Legacy behavior not to reproduce

- `TARGET_RACE` reads `UnitRace("player")` in the legacy resolver. Forever must query the intended target only when allowed.
- `BGFG` hard-codes three old battleground zone names and faction labels. The mapping is not portable.
- `MOUNT` relies on `RPH_MyMount`, a custom session value, and can remain unresolved before the first observed mount.
- `TARGET_POWER` also has no legacy rejection path when no suitable target exists. Forever must reject the candidate instead of leaking a raw keyword.
- `EFG` assumes every player belongs to one of exactly two opposing factions.
- Pronouns are inferred from `UnitSex` through hard-coded English/German tables. Forever needs an explicit English V1 policy and must not infer unavailable identity details.
- The legacy resolver uses unbounded substring replacement and depends on a fragile replacement order for overlapping tokens such as `PTSP`, `TSP`, and `SP`. Forever should parse explicit tokens.
- `RINSULT` may call its random generator more than once while processing one occurrence. Availability checks and substitution should use the same resolved value.
- `NPC`, `TEXT`, and `LANG` are promised by the customization guide, but the inspected general keyword resolver does not implement them. Treat the legacy documentation as intent, not proof of working behavior.
- `LEVEL` is replaced in a special event handler rather than through the common resolver. Forever should express trigger-provided values consistently.

## Random phrase templates

The legacy random system stores a phrase containing ordered `BLANK` markers and numbered choice pools. Each marker is replaced, in order, by a random value from its corresponding independent pool. Empty strings are valid choices, allowing optional fragments. Chosen fragments may contain ordinary keywords such as `RINSULT`, which are resolved after template expansion. One template can therefore produce many variants without duplicating static lines.

Forever does not retain the `BLANK` syntax. Template entries use numbered braced placeholders:

```lua
{
    template = "I'll {1} your {2}!",
    choices = {
        { "rip", "tear", "hack" },
        { "arms off", "legs off" },
    },
}
```

Each numbered placeholder uses its corresponding choice pool. Template-dependent legacy content should still be reviewed before migration rather than copied mechanically.

## Content-processing contract

The intended behavior is:

```text
trigger detected
-> build applicable content layers
-> prepare candidate pool
-> expand templates as needed
-> resolve required dynamic keywords
-> discard candidates whose required values cannot safely resolve
-> choose from the remaining eligible candidates
-> route output according to activity/context policy
```

The internal implementation may differ, but it must preserve these observable rules. For example, if a pool contains `"Die, TARGET!"` and `"Have at you!"` while `TARGET` cannot safely resolve, the first candidate is discarded and RPHelper can still choose `"Have at you!"`. An invalid dynamic candidate must not consume the selection and cause silence when eligible content remains. Output routing remains separate from trigger detection and content generation.

## Monster-action triggers

The generic catalogue already defines these semantic reactions:

| Trigger | Intended event |
| --- | --- |
| `monster_emote_help` | A relevant monster calls for help. |
| `monster_emote_fear` | A relevant monster begins fleeing in fear. |
| `monster_emote_enrage` | A relevant monster becomes enraged. |

The authored content does not prove that detection works. Event names, payloads, localization, relevance checks, and combat restrictions require WoW Forever API and in-game validation before V1 is considered stable. The legacy implementation matched exact English `CHAT_MSG_MONSTER_EMOTE` strings and required the emitting monster to be the current target; that approach must not be copied without validation.

## Candidate future reactive triggers

These are candidates, not committed V1 functionality:

- Enemy cast start
- Enemy channel start
- Successful player interrupt

A successful interrupt is especially promising because it represents a clear player action. Generic cast and channel reactions could become spammy, so they may require cast-duration, spell-type, cooldown, or other filtering. Available spell, unit, and combat information must be tested under WoW Forever restrictions before any design is committed.
