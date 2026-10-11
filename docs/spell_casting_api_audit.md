# Spellcasting and ability API compatibility audit

Research date: 2026-10-11. The research findings remain unverified by RPHelper in the live client; §6 records the first runtime increment. This audit complements [the combat API audit](combat_trigger_api_audit.md); it does not change generic combat triggers or the deferred status of `youcrit`.

## Evidence and boundaries

- **Legacy source:** inspected public `main` versions of [RPhelper_twow.lua](https://github.com/Wiubiki/RPhelper_twow/blob/main/RPhelper_twow.lua), [localization.lua](https://github.com/Wiubiki/RPhelper_twow/blob/main/localization.lua), the XML/TOC load order, `RPhelper_twow_Other.lua`, and English `WARRIOR.lua`/`DRUID.lua`. The sibling legacy checkout was unavailable; downloaded references were read only. The TOC specifies interface 11200. Source links are mutable, not release-pinned.
- **Forever export:** [API snapshot](https://atraeau.github.io/WoW-Addons/api.json), exported October 1, 2026, version 1.60.1, build **70170**, interface **16001**, product `wow_classic_beta`. Searches below covered all exported event definitions, function definitions and global names. This is a community export of client documentation, not a promise of registration permission or readable values.
- **Blizzard definitions:** generated Lua documentation distributed through [Gethe/wow-ui-source](https://github.com/Gethe/wow-ui-source/tree/live/Interface/AddOns/Blizzard_APIDocumentationGenerated). Its mutable retail `live` branch supplies security annotations for comparison; it is not the exact Forever build. The Forever [exporter](https://github.com/Atraeau/WoW-Addons/blob/main/src/WowApiExport/Core.lua) preserves selected signature fields but omits security annotations. Missing annotations in its output cannot establish unrestricted access.
- **Third-party observations:** library author's [Forever API findings](https://github.com/Ralgathor/LibClassicSwingTimerAPI/blob/main/docs/FOREVER_API_FINDINGS.md), especially §§4.3, 8.11 and later verification entries, plus [capture evidence](https://github.com/Ralgathor/LibClassicSwingTimerAPI/tree/main/docs/evidence). These are reports from particular beta builds/classes/contexts, not our own verification and not universal API guarantees.
- **Repository contracts:** [product specification](product_spec.md), [content-engine specification](content_engine.md), and current `Runtime.lua`, `RuntimeAPI.lua`, `Content.lua`, `ContentEngine.lua` and `DruidForms.lua`. Authored catalogue entries establish content identity, not whether a spell exists on Forever.

## 1. What the original addon actually does

### Detection and identity

`RP_OnLoad` directly registers `SPELLCAST_START`, `SPELLCAST_CHANNEL_START`, `SPELLCAST_CHANNEL_UPDATE`, `SPELLCAST_FAILED`, `SPELLCAST_STOP` and `SPELLCAST_INTERRUPTED`. `STOP` is registered even though it is commented out in the debug-event list. These old casting events are implicitly self-casting; the handler has no explicit caster-unit check.

For cast-time spells, `SPELLCAST_START` compares `arg1` with names in `SPELLS.casttime[englishClass]`, first exact equality and then `string.find`. The reaction occurs at **start**, not successful completion. Separate name checks cover mounts, Hearthstone and Alterac Valley Recall. Interrupting later cannot retract the reaction.

For instant, next-melee and channeled spells, global replacements wrap `CastSpell`, `CastSpellByName` and `UseAction`. They call the original function first, then record a tooltip name or supplied spell-name string in shared pending globals. `CastSpell`'s parameter is a spellbook slot, not a stable spell ID. `UseAction` explicitly skips actions for which `GetActionText` identifies a macro. `SpellTargetUnit` and `TargetUnit` wrappers move pending targeting state into `RPHelper_EndCast`; `SpellStopTargeting` clears it conditionally. The mouse/camera targeting replacement is commented out and provides no active coverage.

`SPELLCAST_STOP` searches the pending name against the merged `instant`, `next_melee` and `channeled` class tables. `FAILED`/`INTERRUPTED` clear state only when `RPHelper_EndCast` exists. The source itself notes that STOP can precede INTERRUPTED, and can also occur on targeting cancellation. This mechanism observes a local action request plus a stop notification; it does not reliably prove execution. Channels set `IsChanneling` at CHANNEL_START and clear it when CHANNEL_UPDATE has zero duration; these notifications do not directly select ability content.

### Content and policy

[localization.lua](https://github.com/Wiubiki/RPhelper_twow/blob/main/localization.lua) supplies lower-case semantic keys mapped to human spell names, grouped into four casting categories. Ranks/name variants are grouped through substring matching, not numeric identity. Its list includes Turtle additions and passive entries such as Anger Management; being listed does not make an ability castable or detectable.

`GetPhrase(key)` collects the enabled trait pools in `RPWORDLIST[key]`, including sayings, built-in/custom emotes and generated phrases. For example, [Warrior Charge](https://github.com/Wiubiki/RPhelper_twow/blob/main/English/WARRIOR.lua) has authored emote content; its Heroic Strike pool is empty. [Druid Tranquility](https://github.com/Wiubiki/RPhelper_twow/blob/main/English/DRUID.lua) has channel-related sayings/custom emotes. Detection can therefore succeed without any output.

Each matched spell checks its configured chance and delay against **shared** `LastRP`; defaults are 3% and eight seconds. One random roll is generated per event. `Roleplay` chooses among available outputs, suppresses built-in emotes while `IsChanneling`, and sets `JustRPed`; the event tail updates `LastRP`. There is no modern encounter quota or activity routing. `UseSpellRPs` allows class content in `GetPhrase` without the class trait, but the STOP handler still requires that trait: cast-time and instant behaviour are inconsistent.

### Limitations and bugs to avoid carrying forward

- Start reactions can announce failed casts. STOP-based reactions can announce cancelled targeting or interrupted casts, or miss instant events occurring before post-call pending state is recorded.
- One pending spell/target can be overwritten by another action. No cast GUID correlates success/failure with that state. Failure while only `RPHelper_Spell` exists leaves pending state behind.
- Substring searches are Lua pattern searches and can confuse overlapping names. Exact matching is local to each entry, not a global exact-match pass; iteration does not guarantee the best match. Returning from a `table.foreach` callback does not stop the whole search.
- Macros are skipped by the action wrapper; other invocation paths may still reach a wrapped casting function, so complete macro exclusion or coverage is not established. Items, ground targeting and queued attacks depend on tooltip/state/event behaviour rather than an execution contract.
- The section labelled racial defaults loops over **class** tables again, and casting handlers search class tables rather than race tables. Separate racial catalogue entries are not reliably covered.
- Channel tracking is simplistic and bypassed when the addon is disabled; built-in emote suppression does not also suppress custom emotes. Passive talent effects, auto-attacks, periodic ticks and effects caused by pets are not reliably detected as player ability executions.

These findings follow the legacy handler and wrapper branches above; source comments about event ordering describe legacy assumptions, not Forever behaviour.

## 2. Forever mechanisms and compatibility

The six legacy `SPELLCAST_*` names and `CHAT_MSG_SPELL_SELF_BUFF` are **absent** from the October export's event catalogue. Conversely, `CastSpell`, `CastSpellByName`, `UseAction`, `SpellTargetUnit`, `TargetUnit`, `SpellStopTargeting` and `SpellIsTargeting` are present as function-valued globals. Their global presence does not establish identical signatures, permission to replace/call them, or successful execution. `C_SpellBook.CastSpellBookItem` also exists. None is needed as a detection hook. [Snapshot](https://atraeau.github.io/WoW-Addons/api.json), [Forever spellbook definitions](https://github.com/Atraeau/WoW-Addons/blob/main/docs/api/Spells-Auras-Talents/C_SpellBook.md).

### Modern event contract

The [Forever Unit catalogue](https://github.com/Atraeau/WoW-Addons/blob/main/docs/api/Units-Combat-PvP/Unit.md) exports these notifications:

| Event family | Payload relevant to this audit | Proposed meaning/use |
| --- | --- | --- |
| `UNIT_SPELLCAST_SENT` | `unitTarget`, `target`, `castGUID`, `spellID` | Request sent; not success. Target is a name string, not a target unit/GUID. |
| `START`, `DELAYED`, `STOP` | `unitTarget`, `castGUID`, `spellID`, optional `castBarID` | Cast-bar lifecycle; STOP alone is not an execution criterion. |
| `SUCCEEDED` | Same four fields | Best candidate for confirmed cast success; not proof of damage, healing or aura application. |
| `FAILED`, `FAILED_QUIET`, `INTERRUPTED` | Common fields; INTERRUPTED also has `interruptedBy` | Failure/cancellation observations; no reaction. |
| `CHANNEL_START`, `CHANNEL_UPDATE`, `CHANNEL_STOP` | Common fields; STOP also has `interruptedBy` | Channel lifecycle, not proof that every tick or full channel completed. |
| `EMPOWER_START`, `EMPOWER_UPDATE`, `EMPOWER_STOP` | Common fields; STOP adds `complete`, `interruptedBy` | Separate casting mode; defer. |
| `RETICLE_TARGET`, `RETICLE_CLEAR` | `unitTarget`, `castGUID`, `spellID` | Targeting lifecycle, not successful effect execution. |

Names abbreviated in this table have the `UNIT_SPELLCAST_` prefix. `unitTarget` identifies the **casting unit**, despite its name. Accepting exact readable `"player"` excludes `"pet"`, targets and other combatants; generic registration itself is not a player filter. No name or rank is supplied by these success payloads. The export defines optional `castBarID` as `UnitCastBarID`; do not assume the retail representation.

### Permission and secrets

[Blizzard Unit definitions](https://github.com/Gethe/wow-ui-source/blob/live/Interface/AddOns/Blizzard_APIDocumentationGenerated/UnitDocumentation.lua) annotate casting events with `SecretWhenUnitSpellCastRestricted`; SENT's target is `ConditionalSecret`, while optional cast-bar IDs are `NeverSecret`. These annotations do not promise readable player IDs in Forever. Fail closed if `issecretvalue` is missing, throws, or cannot give a trustworthy plain boolean. Inspect each required value before comparisons, numeric validation, indexing, concatenation or logging. A secret spell ID cannot become a catalogue key. Unused secret fields should remain untouched. A readable cast-bar ID cannot recover a secret spell ID or establish source identity.

**Third-party evidence:** the library reports successful ordinary-addon registration and receipt of player SUCCEEDED events in combat, readable classic spell IDs, and later captures covering failure/channel families. It also records secret target START IDs during restricted combat, contradicting its earlier broad readability claim. Raptor Strike success coincides with the consuming swing; attack-toggle ID 6803 appears at attack start. These reports support a guarded player-success path, not an unrestricted casting API. [Findings and corrections](https://github.com/Ralgathor/LibClassicSwingTimerAPI/blob/main/docs/FOREVER_API_FINDINGS.md).

Registration, receipt, safe readability and ability identity remain four separate gates. Protect new registration in the adapter; failure must disable only ability detection. Verify `RegisterUnitEvent(..., "player")` on Forever rather than assuming export presence demonstrates permission.

### Comparison and migration decisions

“Replaceable” means a supported modern candidate exists for the stated cast-success semantics, with live acceptance tests still required; it does not promise complete category coverage.

| Original mechanism | Compatibility | Recommended Forever implementation and confidence |
| --- | --- | --- |
| Cast-time START + spell-name lookup | **Replaceable** for success reactions | Player SUCCEEDED + explicit IDs. High confidence in exported signature; medium in deployment coverage. Deliberately changes premature start semantics. |
| Cast/action wrappers + pending name + STOP for instant abilities | **Replaceable** for verified active spells | Same success path regardless of action-bar/spellbook/user-macro origin. No wrappers or macro fallback. Medium confidence; test instant and off-GCD abilities. |
| `next_melee` wrapper/STOP | **Replaceable**, per verified ability | SUCCEEDED at consumption, not queue selection. Medium confidence from Raptor Strike/Heroic Strike reports; cancellation and other queued abilities remain unverified. |
| Channel START/UPDATE flag plus STOP lookup | **Adaptable** as lifecycle concept; old events unavailable | Separate channel initiation from completion. First release defers channels; medium confidence lifecycle exists, low in universal completion semantics. |
| Name/substrings for spell families and ranks | **Adaptable** semantic grouping | Preserve canonical ability keys; replace detection lookup with explicit rank/variant IDs. High architectural confidence, per-ID verification pending. |
| Targeting wrappers/current-target snapshot | **Unsupported** as reliable effect-target attribution | No target-dependent first increment. SENT correlation could later supply a safe name, but does not establish a unit or successful affected target. |
| START name specials: mount/Hearthstone/Recall | **Replaceable** for individually verified cast success; **Unsupported** for assumed final outcome | Dedicated verified spell IDs could prove a cast, not arrival/mount persistence. Defer this separate gameplay scope. |
| Self-buff chat pattern matching for heals/crits | **Unsupported** for equivalent outcome information | Missing event; cast success does not establish heal amount/critical result. No parsing substitute. |
| Auto-repeat/next-swing comments and passive catalogue entries | **Unsupported** for general per-execution ability identity | Auto-repeat notifications identify mode changes; swing notifications lack spell identity. Do not infer proc/attack identity. |
| Chance/delay/content semantic keys | **Adaptable** | Reuse current policy and preparation contracts, not legacy state/output code. High confidence from repository implementation. |

No original detection path is classified Reusable unchanged. Availability of an invocation global does not make its legacy replacement a compatible observer.

## 3. Category boundaries and identifiers

**Ordinary cast-time, instant, buffs and active melee abilities:** player SUCCEEDED is the preferred execution notification. A miss, resist, immune target or ineffective buff can follow a successful cast. Content may describe using an ability, but detection must not claim a landed hit or completed heal. Talent-driven instant versions need the same verified ID mapping, not a requirement to see START first.

**Channels:** success may represent initiation rather than completion; channel-start and success can describe the same use. Do not emit on both. Natural stop, movement cancellation, damage interruption and ticks require separate live traces and an explicit authored semantic choice. Neither empty `interruptedBy` nor elapsed duration is established here as universal completion proof.

**Shapeshifts/stances:** exported `UPDATE_SHAPESHIFT_FORM`/`UPDATE_SHAPESHIFT_FORMS` report state changes without cast identity. They can help read current form but do not prove an intentional ability use. Do not react both to a cast and a state update. Verify event ordering relative to RPHelper's form query before supporting transitions. [Forever spellbook catalogue](https://github.com/Atraeau/WoW-Addons/blob/main/docs/api/Spells-Auras-Talents/C_SpellBook.md).

**Passive procs, pets, auto-attacks and periodic effects:** exclude from the initial scope. Third-party raw evidence reports Redoubt aura applications without SUCCEEDED, while player Slice and Dice/Seal/Judgement success IDs remained readable in tested combat. This demonstrates that ability execution and aura changes are different signals. [Evidence index](https://github.com/Ralgathor/LibClassicSwingTimerAPI/blob/main/docs/evidence/README.md). `UNIT_AURA` can include effects applied by other sources or passive procs; it is not a general casting fallback, and [aura APIs carry their own access/secret restrictions](https://github.com/Gethe/wow-ui-source/blob/live/Interface/AddOns/Blizzard_APIDocumentationGenerated/UnitAuraDocumentation.lua).

**Ranks and custom spells:** use a small explicit mapping `(player class, spellID) → existing RPHelper.Ability key`. Multiple verified rank IDs may map to one key. Do not treat retail IDs, Turtle catalogue names or third-party spell identification as an exhaustive Forever database. Unknown IDs yield no reaction. Names are for readable diagnostics/manual verification, never substring dispatch. The exported [C_Spell API](https://github.com/Atraeau/WoW-Addons/blob/main/docs/api/Spells-Auras-Talents/C_Spell.md) includes `GetSpellName`, `GetSpellInfo`, `GetBaseSpell` and `GetOverrideSpell`; [Blizzard spell definitions](https://github.com/Gethe/wow-ui-source/blob/live/Interface/AddOns/Blizzard_APIDocumentationGenerated/SpellDocumentation.lua) describe their signatures. Base/override resolution is not evidence that every Classic rank normalizes to one ID. Only normalize relationships verified for the supported ability, guarding returned values as well.

Cooldown/action-bar notifications report refreshes, including shared/global cooldown changes. They do not prove a specific successful cast. Spellbook enumeration can establish known IDs but not when those abilities executed. No target/timing correlation, combat-text parsing or restricted combat-log mechanism is proposed.

## 4. Recommended architecture and first increment

This architecture is conditional on live verification of readable player-success payloads. If that gate fails in a context, automatic ability detection remains disabled there.

1. Keep registration, payload secret inspection, player filtering, optional spell API calls and Forever-specific event assumptions in `RuntimeAPI.lua`. Validate readable unit and positive finite integer spell ID before classification. Return only a canonical ability identity and safely usable cast identity; never pass unchecked payloads into content or policy code.
2. Extend the existing runtime policy path narrowly to accept ability identities and choose `ChooseAbilityCandidate(class, ability, options)`. At initial audit time, `HandleTrigger` accepted only its five generic keys and called `ChooseContentCandidate`; simply sending a new ability string would be rejected. Ability pools already have preparation/selection helpers. Ability detection needs explicit ability enable/chance/cooldown settings, not accidental defaults borrowed from an unrelated generic trigger.
3. Preserve global cooldown, frequency scaling, activity gating/routing and the shared encounter quota. Count only successfully dispatched output. Ability uses outside combat may be valid, obeying settings/probability/cooldowns without an encounter quota; do not impose the defensive reactions' combat-only rule on buffs. Keep combat entry/exit unchanged, and ensure an in-combat ability cannot bypass encounter accounting.
4. Pass the same Druid suppression/form-query options through content preparation. Ability content must not bypass form suppression or invent generic form reactions. Unknown/unreadable forms remain conservative. First scope excludes shapeshift transitions until ordering is verified. Do not expand or rewrite content pools.
5. First scope supplies only safely established player context. Omit cast-target values; candidates requiring missing relevant target/pet data stay ineligible. The current target at success can differ from a mouseover/self/ground cast's target.
6. React from one success event only; SENT/START/STOP/updates/failures do not independently roll or dispatch. Do not require a START precursor for instant spells. Use a readable opaque `castGUID` only for correlation, never parse it. If live captures establish repeated successes for one cast, add bounded exact-GUID duplicate suppression before policy selection; do not deduplicate by spell ID, fixed time windows or swing coincidence. If a supported ability lacks usable identity and produces indistinguishable duplicates, defer it rather than infer identity. A policy-rejected duplicate should not obtain repeated probability rolls.

**Narrow proposal:** after the checklist below passes, implement player `UNIT_SPELLCAST_SUCCEEDED` for a handful of existing non-channel, non-form active abilities with verified IDs and target-independent eligible content. Include a cast-time spell and an instant/buff or active melee spell to exercise both paths. Select the actual abilities/IDs from captures; this audit does not authorize an invented ID list. Add mocked payload, settings, quota, failed-dispatch and form tests around that path. No pending-cast state machine is necessary for the first success-only subset.

Defer channels, empower/reticle special cases, queued abilities without confirmed consumption semantics, auto-repeat attacks, passive procs, form transitions, mounts/travel outcomes and target attribution. Generic enter/leave/dodge/parry/block remain intact; offensive critical-hit detection remains deferred. No macro trigger, legacy hook, combat text or combat log is a fallback.

## 5. Live-client acceptance checklist

Record build/interface, class, spell rank/ID, activity, event sequence and secret flags. Inspect values before logging; log only safe fields. Captures should use ordinary addon event registration, not privileged tooling to justify addon access.

- Verify protected registration of player-scoped SUCCEEDED, successful receipt and safe rejection when registration/inspection facilities fail. Confirm existing combat events continue working independently.
- Test required unit/spell ID and cast GUID readability separately in open world, dungeon combat, raid combat, PvP and outside combat. Repeat while other units cast; reject pets, target and other players. Verify optional cast-bar type/availability without using it to recover restricted information.
- Capture successful, movement-cancelled, interrupted, out-of-range, insufficient-resource and cooldown-blocked cast attempts. Compare SENT/START/STOP/SUCCEEDED/FAILED/FAILED_QUIET ordering. Confirm no success reaction on cancellation or failure.
- Exercise instant, off-GCD, melee and self/ally buffs, spellbook/action-bar invocation, and existing user casting macros. Observe execution events without adding a macro RP fallback. Include repeated fast recasts and multiple effects from one cast.
- For each proposed ability, confirm every supported rank, talent replacement and custom Forever variant maps to the intended canonical key. Unknown IDs must be skipped. Check passive effects and attack toggles cannot accidentally match.
- Before admitting queued attacks, capture queue, unqueue, target death and actual consumption for Heroic Strike/Raptor Strike/Maul separately. Prove SUCCEEDED represents consumption, and examine repeat/empty GUIDs. Do not use simultaneous PLAYER_SWING as detection.
- Before admitting channels, capture start/success/ticks/natural stop/movement cancel/damage interruption and recasting. Establish one reaction point consistent with content meaning and verify outputs cannot interrupt gameplay.
- Before admitting form changes, capture success and form-state update order for all supported Druid forms and cancellation. Verify form suppression for sayings and conservative behaviour on unreadable/unknown form state.
- Check target-dependent candidates remain ineligible for mouseover/self/ground casts without safe relevant context. Confirm success does not falsely imply hit, heal, crit or effect application.
- Verify disabled ability/global settings, probability, per-ability/global cooldowns, shared encounter quota including leave-combat, out-of-combat buffs, failed dispatch and activity routing. Check at most one policy attempt per verified execution and no interference with generic combat reactions.

## 6. First runtime increment

Implemented: protected ordinary registration of `UNIT_SPELLCAST_SUCCEEDED`, a
single adapter classifier and shared runtime policy evaluation with separate
ability-content selection. Only the exact nonsecret player unit, valid nonsecret
spell ID and nonsecret class are used. Inspection must return exactly false for
each required field; missing/failing inspection suppresses detection. GUID and
cast-bar values are untouched. No START/SENT requirement, outcome reconstruction,
pending-cast state or duplicate cache exists. The recommendations in §4 describe
the pre-implementation runtime; generic `HandleTrigger` still accepts its five
keys, while the internal ability path now shares its policy evaluation.

### Production ID evidence

| Class | Exact spell ID | Existing canonical ability | Evidence and limits |
| --- | --- | --- | --- |
| PALADIN | 19750 | FLASH_OF_LIGHT | Library author's §4.3 Paladin dungeon SUCCEEDED observation names this readable Flash of Light ID. Ordinary cast-time ability; other ranks/instant variants not inferred. |
| PALADIN | 20288 | SEAL_OF_RIGHTEOUSNESS | Same Paladin observation names this readable Seal of Righteousness ID. Instant buff activation; other ranks not inferred. |

Source: [Forever API findings, §4.3 and its correction](https://github.com/Ralgathor/LibClassicSwingTimerAPI/blob/main/docs/FOREVER_API_FINDINGS.md).
These are documented **third-party Forever observations**, not RPHelper client
tests, retail-ID assumptions or guarantees across builds/contexts. The source
separately identifies another unit's Rend and an attack toggle; neither is
included. Only these two exact IDs enter production. A synthetic Druid ID appears
solely in a scoped mocked fixture to verify form restrictions, not in the
production allowlist. Catalogue membership never enables detection by itself.

Defaults are enabled/3%/30 seconds for each mapped ability, overridden through
`RPHelperDB.abilities.PALADIN[canonicalAbility]`. Defaults merge only into valid
containers and missing fields; malformed/recoverable data is preserved and
runtime validation falls back without rewriting it. No migration or schema bump
is introduced. Master enable, frequency, global cooldown, activity rules and
encounter quotas are shared with generic reactions. Ability cooldowns are
independent; out-of-combat activations do not spend an encounter quota.

Existing ability preparation discards candidates with unresolved target context
and applies Druid speech suppression. No current-target correlation is added.
Channels, form transitions, queued abilities, passive procs, automatic attacks,
empower/reticle behaviour and pets remain outside the allowlist.

No evidence here establishes that cast GUIDs are readable, populated and unique
for every supported activation, or that repeated SUCCEEDED delivery needs
suppression. Therefore no deduplication infrastructure is implemented; repeated
valid notifications are ordinary policy attempts. Live captures must establish
duplicate delivery/identity before adding an exact-GUID safeguard. The checklist
in §5 remains open, especially player payload readability across restricted
contexts, exact rank IDs, registration/delivery, output permission and duplicate
behaviour. Automated coverage is mocked and makes no live compatibility claim.
