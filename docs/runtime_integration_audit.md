# Runtime Integration and Spell Detection Audit

Audit date: 2026-10-22

Baseline: merged `main` at the start of Milestone 4A

Companion inventory: [runtime ability integration inventory](runtime_ability_integration_inventory.csv)

Milestone 4A was a documentation-only audit. Milestone 4B adds the bounded,
session-only diagnostic described in §7 without adding handlers, spell mappings,
settings, or catalogue content. “Mocked” means deterministic Lua coverage with
replacement frame/API objects; it is not live-client evidence.

## 1. Executive summary

RPHelper has one end-to-end automatic reaction coordinator, but only a narrow
set of inputs can reach it. Combat entry and exit use `PLAYER_REGEN_DISABLED`
and `PLAYER_REGEN_ENABLED`; player defensive dodge, parry, and direct block use
`UNIT_COMBAT`; and exactly two Paladin spell IDs use
`UNIT_SPELLCAST_SUCCEEDED`. All seven resulting semantic identities—five generic
trigger identities across their content layers and two ability identities with
two exact IDs—share the same configuration, chance, cooldown, quota, content
preparation, and output path. Druid-form groups reuse their underlying trigger
configuration rather than introducing form-specific event settings.

No integration is Category A. The repository contains extensive mocked tests
and two third-party Forever spell observations, but no recorded RPHelper live
client session. The five generic trigger identities and two Paladin abilities
are therefore Category B. The ability catalogue contains 474 canonical
definitions across nine playable classes: 282 have shipped reactions and 192
are defined with empty shipped pools. Only `PALADIN/FLASH_OF_LIGHT` spell ID
`19750` and `PALADIN/SEAL_OF_RIGHTEOUSNESS` spell ID `20288` are production
mappings. The detailed inventory classifies 241 more identities as plausible
success-event candidates (C), 16 reaction-bearing catalogue-only gaps (D), and
215 explicitly deferred/unsupported or empty identities (E).

The current code is suitable for a narrow v0.9 live-validation build after the
correct Forever `## Interface` value is established and added in a separate
implementation change. It is not evidence of live compatibility. Full class
ability coverage is neither present nor required for v0.9 or V1; stable V1
requires a deliberately small, documented, live-verified subset and honest UI
status for everything else.

The opt-in diagnostic is now implemented to collect RPHelper live evidence. Its
records do not promote any trigger or ability to Category A: gameplay detectors
remain unchanged, and no mapping has yet gained RPHelper live verification.

## 2. Evidence taxonomy and audit method

| Category | Meaning in this audit |
| --- | --- |
| **A — runtime-wired, live verified** | Production path exists and RPHelper has recorded repeatable live Forever evidence for registration, readable payloads, attribution, policy, and output. |
| **B — runtime-wired, mock verified only** | Production path and deterministic tests exist, but RPHelper live verification is absent. Third-party observations do not promote an item to A. |
| **C — detector candidate, mapping incomplete/unverified** | The success-event adapter is relevant and prior research found an ordinary activation or candidate IDs, but no production mapping exists (or all ranks/variants remain unverified). |
| **D — catalogue only** | Authored reactions exist, but there is no reviewed executable detector/mapping path for the current canonical identity. |
| **E — excluded or deferred** | The mechanism is explicitly outside the current adapter, the shipped pool is empty, or the trigger family is intentionally deferred/unsupported. |

The inventory was derived from the files loaded by [`RPHelper.toc`](../RPHelper/RPHelper.toc),
the canonical definitions and registered pools in `Data/Abilities/*.lua`, the
runtime allowlist in [`RuntimeAPI.lua`](../RPHelper/Core/RuntimeAPI.lua), and the
prior [ability spell-mapping audit](ability_spell_mapping_audit.md). Archive
files are not loaded and are not active catalogue definitions. Existing audit
labels such as “Verified” refer to third-party observations unless explicitly
stated otherwise; this audit reserves Category A for RPHelper live evidence.

For ability rows, ordinary cast candidates are C, “Not found” or newly renamed
reaction-bearing identities without a reviewed row are D, and prior
“Unsupported” mechanisms plus empty shipped pools are E. A C row is still
unreachable in production: catalogue membership and candidate IDs never create
a mapping. A defined-empty E row may accept future custom content through the
library, but mapping it now would still have no shipped output and is outside
this milestone.

## 3. Runtime event and generic-trigger matrix

### Registered runtime events

| Event | Registration | Production handling | Failure behavior | Verification |
| --- | --- | --- | --- | --- |
| `ADDON_LOADED` | Direct on the addon frame at file load | Exact `RPHelper` payload initializes database, slash/UI, then runtime | A direct registration error is not caught | Mocked only; live load pending |
| `PLAYER_REGEN_DISABLED` | Direct in `Runtime.Initialize` | Maps to `entercombat`; begins encounter before policy evaluation | A direct registration error is not caught | Mocked only; live timing pending |
| `PLAYER_REGEN_ENABLED` | Direct in `Runtime.Initialize` | Maps to `leavecombat`; evaluates exit before encounter reset | A direct registration error is not caught | Mocked only; live timing pending |
| `UNIT_COMBAT` | Protected ordinary registration through `RegisterDefensiveEvents` | Classifies only exact readable player `DODGE`, `PARRY`, `BLOCK` during an active encounter | Registration failure disables defensive detection while transitions continue | Mocked only; live registration/payload pending |
| `UNIT_SPELLCAST_SUCCEEDED` | Protected ordinary registration through `RegisterAbilityEvents` | Classifies exact readable player/class/integer spell ID against the two-entry allowlist | Registration failure disables ability detection while other runtime paths continue | Mocked only; live registration/payload pending |

No other gameplay event is registered. The addon frame forwards exactly the
four gameplay event names above; `ADDON_LOADED` is handled as initialization.

### Catalogue trigger matrix

`G/R/C/F` below is the shipped reaction count in Generic, all Race layers, all
Class layers, and Druid Form layers. Canonical configuration keys exist only in
`Runtime.TriggerConfigKey`. All wired rows use schema-v2 effective `enabled`,
`chance`, and `priority` values; absent chance overrides inherit the global
chance. All live-verification cells remain pending.

| Catalogue trigger | G/R/C/F | Canonical config key | Event and detector | Attribution/payload assumptions | Chance/policy path | Automated evidence | Category and live state |
| --- | ---: | --- | --- | --- | --- | --- | --- |
| `entercombat` | 14/52/69/8 | `enter_combat` | `PLAYER_REGEN_DISABLED` → exact event map | Event marks the local runtime encounter boundary; duplicate transitions rejected | Shared path; entry occurs after quota reset | Runtime transition, policy, layered/form tests | **B**; event timing and reload-in-combat pending live verification |
| `leavecombat` | 12/30/28/6 | `leave_combat` | `PLAYER_REGEN_ENABLED` → exact event map | Event marks encounter exit; reaction evaluated before state reset | Shared path; shares active encounter quota | Runtime transition, quota, duplicate tests | **B**; ordering/termination semantics pending live verification |
| `dodge` | 16/9/21/6 | `dodge` | `UNIT_COMBAT`, exact readable `player` + `DODGE` | `unitTarget` is assumed to identify the defender; unused payload ignored | Shared path; accepted only in active encounter | Classifier, secret rejection, state/policy tests | **B**; registration, readability, coverage and attribution pending live verification |
| `parry` | 14/2/20/0 | `parry` | `UNIT_COMBAT`, exact readable `player` + `PARRY` | Same defender assumption; delayed delivery remains possible | Shared path; accepted only in active encounter | Classifier, secret rejection, state/policy tests | **B**; registration, readability, coverage and ordering pending live verification |
| `block` | 15/2/11/0 | `block` | `UNIT_COMBAT`, exact readable `player` + direct `BLOCK` | Does not include `WOUND` partial-block flags | Shared path; accepted only in active encounter | Classifier, secret rejection, state/policy tests | **B**; direct/partial coverage and duplicates pending live verification |
| `absorb` | 5/1/23/0 | — | No runtime handler | No safe event/payload contract selected | Cannot enter policy | Catalogue/content tests only | **D**; catalogue only |
| `death` | 11/16/0/0 | — | No runtime handler | Product candidate; death event/ordering not integrated | Cannot enter policy | Catalogue/content tests only | **D**; catalogue only |
| `hurt` | 5/26/24/6 | — | No runtime handler | No supported damage attribution/threshold contract | Cannot enter policy | Catalogue/content tests only | **D**; catalogue only |
| `miss` | 6/8/18/0 | — | No runtime handler | No supported player-action/result attribution contract | Cannot enter policy | Catalogue/content tests only | **D**; catalogue only |
| `resurrect` | 14/36/19/0 | — | No runtime handler | Product candidate; resurrection source and ordering not integrated | Cannot enter policy | Catalogue/content tests only | **D**; catalogue only |
| `youcrit` | 17/28/34/6 | — | No qualifying detector established | Must mean local player offensive melee/ranged/damaging-spell critical; `UNIT_COMBAT` lacks attacker identity; healing excluded | Cannot enter policy | Negative research and catalogue tests only | **E**; explicitly deferred pending a readable attributed result |
| `deferred_youcritspell` | 0/0/31/0 | — | No runtime handler | Deliberately separated legacy content; not an independent supported trigger | Cannot enter policy | Catalogue/content tests only | **E**; deliberately deferred |
| `youcritheal` | 0/0/13/0 | — | No runtime handler | Healing criticals are expressly outside `youcrit` | Cannot enter policy | Catalogue/content tests only | **E**; excluded from current trigger contract |
| `youheal` | 0/0/10/0 | — | No runtime handler | Heal outcome/target attribution not defined | Cannot enter policy | Catalogue/content tests only | **E**; outside approved V1 trigger set |
| `monster_emote_enrage` | 9/0/0/0 | — | No runtime handler | Localized monster text and relevant-source identity unverified | Cannot enter policy | Catalogue/content tests only | **E**; monster-action detection deferred |
| `monster_emote_fear` | 9/0/0/0 | — | No runtime handler | Same monster-emote restrictions | Cannot enter policy | Catalogue/content tests only | **E**; monster-action detection deferred |
| `monster_emote_help` | 8/0/0/0 | — | No runtime handler | Same monster-emote restrictions | Cannot enter policy | Catalogue/content tests only | **E**; monster-action detection deferred |
| `npctalksenemy` | 0/0/2/0 | — | No runtime handler | NPC/text/language fields are contextual and unverified | Cannot enter policy | Catalogue/content tests only | **E**; NPC speech deferred |
| `npctalksfriend` | 0/0/2/0 | — | No runtime handler | Same NPC-speech restrictions | Cannot enter policy | Catalogue/content tests only | **E**; NPC speech deferred |
| `petattackstart` | 0/0/26/0 | — | No runtime handler | Pet ownership, command/outcome, and target context unresolved | Cannot enter policy | Catalogue/content tests only | **E**; pet runtime deferred |
| `petattackstop` | 0/0/20/0 | — | No runtime handler | Same pet attribution and state restrictions | Cannot enter policy | Catalogue/content tests only | **E**; pet runtime deferred |
| `petdies` | 0/0/16/0 | — | No runtime handler | Pet identity/death attribution and `{PNAME}` context unresolved | Cannot enter policy | Catalogue/content tests only | **E**; pet runtime deferred |
| Level up (spec candidate; no registered key) | 0/0/0/0 | — | No runtime handler | `PLAYER_LEVEL_UP` payload would need validated level context | Cannot enter policy | None | **E**; candidate only, no catalogue/runtime identity |
| Killing blow (spec candidate; no registered key) | 0/0/0/0 | — | No runtime handler | No safe local-player kill attribution selected | Cannot enter policy | None | **E**; candidate only, no catalogue/runtime identity |

The form pools currently cover `entercombat`, `leavecombat`, `dodge`, `hurt`, and
`youcrit`. A form group inherits the same trigger metadata as every Generic,
Race, and Class group for that key. Thus the first three resolve to the B paths
above; `hurt` and `youcrit` remain unsupported. Form identity affects content
pool replacement and Say suppression, not event detection or persistence.

## 4. End-to-end runtime flow and policy status

The executable flow is:

```text
addon frame event
  → Runtime.HandleEvent
  → exact generic map or guarded RuntimeAPI classifier
  → canonical trigger/ability identity
  → shared activity, quota, cooldown/priority, enabled and chance gates
  → prepared Generic/Race/Class/Form pool or class/ability pool
  → weighted eligible candidate
  → Output.Dispatch
  → successful-output cooldown/quota accounting
```

| Concern | Implementation status | Automated status | Live status / gap |
| --- | --- | --- | --- |
| Addon initialization and event forwarding | Implemented for the four event names in `RPHelper.lua` | Mocked frame registration/forwarding | Addon load, event delivery, reload-in-combat pending |
| Combat transitions | Implemented | Mocked | Forever boundary timing/duplicates pending |
| Defensive classification | Implemented with exact nonsecret player/action checks | Mocked, including failure paths | Actual secrecy, unit tokens, direct/partial coverage pending |
| Ability classification | Implemented for two exact Paladin IDs only | Mocked, including unknown/wrong class/unit/secret rejection | Registration, payload readability, rank coverage and duplicate delivery pending |
| Activity gate | World and party instance allowed; raid/unknown suppressed | Mocked | `IsInInstance()` shapes and raid/PvP contexts pending |
| Schema-v2 settings | Effective master, trigger/ability enabled, inherited/replacing chance, priority | Schema/runtime/UI tests | Actual per-character SavedVariables lifecycle pending |
| Anti-spam | Optional encounter quota and one session global cooldown; Priority bypasses only cooldown | Boundary, reset, exhaustion and failed-output tests | Clock readability and real event ordering pending |
| Content preparation | Disabled defaults/custom content, keyword eligibility, Druid pool replacement/Say suppression, weighted selection | Content/runtime/UI tests | Relevant target/pet context remains intentionally absent; form IDs pending |
| Output routing | World/local Say, dungeon broadcast/local Say, built-in emote, custom emote; raid suppressed | Mocked API calls and failures | Automatic `SAY`/`EMOTE`/`DoEmote` permission and server acceptance pending |
| State consumption | Cooldown/quota only after successful adapter dispatch | Mocked | Adapter success cannot prove server acknowledgement |
| Diagnostics | Implemented as an opt-in 100-record session ring over existing classification | Deterministic lifecycle, redaction, command, buffer and isolation tests | Live payload readability and collection workflow pending |

Unknown trigger keys and spell IDs are rejected before content selection. Ability
handling also verifies that the classified canonical key exists in the current
class catalogue. This preserves the intended separation between detection,
content generation, runtime policy, and output.

## 5. Per-class ability inventory

The companion CSV contains one row for every active canonical definition, with
its shipped reaction count, detector status, mapping, category, evidence, and
next action. Counts reconcile exactly to 474 definitions and 783 shipped
reactions.

| Class | Definitions | Reaction-bearing | A | B | C | D | E | Important integration findings |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| Warrior | 41 | 12 | 0 | 0 | 12 | 0 | 29 | All authored identities are ordinary success-event candidates, but none is mapped. Queued `HEROIC_STRIKE` and stance/passive-style empty definitions remain deferred. |
| Rogue | 38 | 2 | 0 | 0 | 2 | 0 | 36 | Only `SPRINT` and `DISARM_TRAP` have shipped reactions; neither is mapped. Most of the class catalogue is defined-empty, so broad spell mapping would add no shipped behavior. |
| Hunter | 58 | 46 | 0 | 0 | 41 | 0 | 17 | High-value unmapped candidates include aspects, shots, traps, and utility casts. Channels (`EAGLE_EYE`, `EYES_OF_THE_BEAST`, `MEND_PET`, `VOLLEY`) and queued `RAPTOR_STRIKE` require separate semantics; tracking activations remain event-shape candidates, not verified mappings. Pet commands are outside this ability catalogue/runtime path. |
| Shaman | 57 | 45 | 0 | 0 | 42 | 1 | 14 | Ordinary shocks, heals, totems, and weapon buffs are unmapped candidates. Current `FIRE_NOVA` lacks a reviewed canonical mapping after catalogue reconciliation. `GHOST_WOLF` form transition and `REINCARNATION` death-interface behavior are deferred. |
| Druid | 58 | 13 | 0 | 0 | 9 | 1 | 48 | The small authored subset is mostly unmapped. `SHIFTING_POWER` lacks reviewed integration evidence. `HURRICANE`/`TRANQUILITY`, form transitions, and queued `MAUL` require mechanisms beyond the current success-only scope; form content groups are generic-event layers, not ability mappings. |
| Paladin | 54 | 43 | 0 | 2 | 40 | 1 | `FLASH_OF_LIGHT` `19750` and `SEAL_OF_RIGHTEOUSNESS` `20288` are the only production mappings. Third-party observations also list `HOLY_LIGHT` `647` and `JUDGEMENT` `20271`, but they are deliberately not production-mapped without RPHelper verification. `SALVATION` lacks a reviewed row after canonical renaming. No other ranks are inferred. |
| Mage | 60 | 52 | 0 | 0 | 49 | 0 | Most authored spells are ordinary candidates. `ARCANE_MISSILES`, `BLIZZARD`, and `EVOCATION` are deferred channels; mapping portals/teleports still requires exact rank/destination verification. |
| Priest | 55 | 44 | 0 | 0 | 31 | 9 | Many ordinary heals, buffs, and attacks are candidates. Newly reconciled racial/special identities account for most D rows and require availability/mechanism review. `MIND_CONTROL`, `MIND_FLAY`, and `MIND_VISION` are deferred channels; `SHADOWFORM` is a form transition. |
| Warlock | 53 | 25 | 0 | 0 | 15 | 4 | Ordinary curses and casts have no production mapping. Renamed Bane identities and `SUBJUGATE_DEMON` need refreshed reconciliation. Drain/channel abilities, `HEALTH_FUNNEL`, `HELLFIRE`, and `RAIN_OF_FIRE` are deferred; demon/pet outcomes remain separate from player cast success. |
| **Total** | **474** | **282** | **0** | **2** | **241** | **16** | **215** | Full class coverage is intentionally not a release criterion. |

Category C does not endorse the candidate IDs listed in older research as
production values. Every supported rank, talent replacement, override, custom
Forever variant, and actual success-event shape must be captured before a
mapping is added. Target-dependent ability reactions currently remain ineligible
because the success payload is not correlated to a safe relevant target.

## 6. WoW API compatibility assumptions

| API/event assumption | Current safeguard | Evidence | Required live check |
| --- | --- | --- | --- |
| `ADDON_LOADED` identifies `RPHelper` and loaded modules are ready | Exact addon-name check before initialization | Existing behavior and mocked frame test | Current Forever load order and error-free startup |
| Ordinary `RegisterEvent` accepts combat, unit-combat, and cast-success events | Defensive/ability registration is protected; transition registration is direct | Modern/Forever documentation and mocks | Registration success/failure on target build |
| `PLAYER_REGEN_DISABLED/ENABLED` are reliable encounter boundaries | Duplicate transitions rejected; current combat queried on init | Established API, no RPHelper live capture | Login/reload in combat, rapid re-entry, delayed feedback |
| `UNIT_COMBAT(unitTarget, action, ...)` exposes readable exact player/action | Required fields pass `issecretvalue == false`; unused fields ignored | Third-party Forever observations plus mocked classifier | Open world, dungeon, raid/PvP secrecy; aliases; direct/partial block; pets/vehicles |
| `UNIT_SPELLCAST_SUCCEEDED(unitTarget, castGUID, spellID)` supplies readable player and integer ID | Exact player, positive finite integer ID and readable class required; GUID ignored | Third-party observations for two IDs plus mocks | Payload order/type, instant/cast-time delivery, ranks/overrides, failures, duplicates, restricted contexts |
| Spell IDs can be mapped by exact `(class, ID)` | Unknown class/ID rejected; no name matching or inferred ranks | Two explicit third-party-observed IDs | Every admitted rank and custom variant; spellbook/base/override relationships |
| Channels, queued attacks, forms, passive procs, auto-attacks, pets, empower/reticle need different semantics | Excluded from production allowlist | Prior spell/pet audits | Separate evidence before any later design; no fallback parsing |
| `UnitClass`/`UnitRace` return canonical file tokens | Adapter returns protected call results | Established API only | Forever races/classes and return positions |
| `GetShapeshiftFormID` is available and IDs match local mapping | Failure becomes unknown form; content engine suppresses conservatively | Mocked form tests | Every Druid form, transition ordering, nil/0 humanoid behavior |
| `IsInInstance` returns strict world/party/raid combinations | Unknown combinations suppress all output | Mocked routing | Dungeons, raids, battleground/PvP, scenarios and group-outside-instance behavior |
| `GetTime` is readable and monotonic in callbacks | Nonfinite, negative, or backward values suppress attempts | Mocked clock tests | Combat/reload behavior on target build |
| `SendChatMessage`, `DoEmote`, and chat-frame `AddMessage` are callable automatically | Protected calls; no retry or public fallback | Mocked output tests | Hardware-event restrictions, silent server rejection, rate limits, token support |
| Secret-value inspection itself is callable | Missing/failing inspection rejects detector inputs | Mocked rejection tests | Actual ordinary-addon availability and behavior in restricted contexts |

The implementation does not parse combat text, access secure/internal combat
logs, infer an attacker from the current target, correlate nearby events, or
substitute spell names for exact IDs. Those omissions are required safety
boundaries, not missing fallbacks.

## 7. Implemented opt-in local diagnostic

The diagnostic defaults off and empty at initialization. `/rph debug on|off`
controls capture for the current session; `status`, `show`, `clear`, and `help`
inspect or manage the retained records. `show` prints at most the latest ten,
oldest-to-newest within that selection. The buffer retains at most 100 records;
disabling does not clear it, clearing does not alter capture state, and no timer,
polling loop, SavedVariable, UI setting, or continuous chat output exists.

The existing runtime calls each defensive or spell classifier once. That
classifier returns its existing canonical result plus a compact sanitized
observation; combat transitions supply their existing semantic trigger. A record
contains `sequence`, optional safe relative `time`, `event`, event `category`,
fixed `result`, and `matched`, with approved optional `activity`, `trigger`,
`unit`, `action`, `spellID`, `class`, and `ability` primitives. Activity is
reused from the normal policy lookup when that lookup occurs, so diagnostics do
not add an activity query. Relative time is likewise reused only when the normal
policy path already obtained a safe monotonic clock value. Diagnostics perform
no additional WoW API queries.

Fields are inspected through the same fail-closed `issecretvalue` boundary used
by production classification before any type test, comparison, arithmetic,
indexing, or display. Missing, failing, restricted, malformed, wrong-unit, and
unsupported values become fixed reasons and labels. `castGUID`, names, target
identity, chat/combat-log text, spell names, raw callback tables, and arbitrary
object strings are neither read for diagnostics nor retained. A readable
positive integer player spell ID is retained even when absent from the current
allowlist and is marked `unmapped`.

Capture is independent of the master reaction-enabled switch but remains
passive. It does not call a handler, select content, evaluate policy a second
time, change cooldown/quota/encounter state, register events, or dispatch local
or public output. Automated tests cover those boundaries. The registered events,
five generic trigger identities, and two Paladin mappings are unchanged.

For live evidence collection, enable capture, perform one documented scenario,
then use `show`. Record the client build/interface, character class, exact
ability and rank, activity, expected event sequence, and observed diagnostic
lines separately from the addon log. Repeat across success/failure, rank,
context, and restricted-value cases. A diagnostic record is an observation, not
automatic proof of a correct canonical mapping, full rank coverage, attribution,
or successful server-side output. Mapping changes require separate review and
must update the inventory only after repeatable evidence.

## 8. v0.9 prerelease blockers and validation gates

### Blockers to installing and beginning live tests

- Establish the exact current Forever interface number and add the corresponding
  `## Interface` metadata. The current TOC has no interface field; guessing it
  from retail or an old export is not acceptable.
- Package/install the unmodified addon and confirm `ADDON_LOADED`, schema-v2
  initialization, slash/UI opening, and clean startup on a disposable character.
- Use the §7 diagnostic for the capture campaign without treating it as a
  restriction bypass or as automatic mapping evidence.

### Broader prerelease validation (not required merely to install)

- Exercise all five B generic identities in open world and five-player content,
  including wrong-unit/actions, encounter boundaries, exhausted quota, disabled
  settings, chance extremes, cooldown/Priority, and Druid forms.
- Exercise both mapped Paladin IDs as their exact observed ranks, plus wrong
  ranks, other players/pets, failures/interruption, rapid repeats, out-of-combat
  use, dungeon/raid/PvP contexts, and target-dependent candidate filtering.
- Validate local Say display, dungeon `SAY` and local mode, custom `EMOTE`,
  `DoEmote`, unconditional raid suppression, and silent/missing API failures.
- Verify per-character persistence across reload/logout and an addon update.

### Deferred from v0.9

Categories C–E, exhaustive class/rank coverage, outgoing criticals, death and
resurrection, monster/NPC/pet triggers, channels, forms as abilities, queued
attacks, passive procs, auto-attacks, target reconstruction, and diagnostics
beyond the implemented narrow opt-in capture tool are not v0.9 blockers.

## 9. V1.0 completeness gaps

V1.0 needs evidence and product honesty, not every catalogue ability. Before a
stable claim:

- Promote each advertised automatic identity to Category A with versioned live
  evidence, or remove/label it as not currently detected. A deliberately small
  supported set is acceptable.
- Decide the minimum stable trigger set from the product candidates. Death,
  resurrection, level up, killing blow, and offensive critical are not
  implemented; they should not be implied by catalogue content or UI.
- Validate the exact Interface metadata and supported client build range.
- Complete live routing/restriction and per-character SavedVariables tests.
- Document exact supported spell ranks/variants. Unknown IDs must continue to
  fail closed; full class coverage remains optional.
- Reconcile the 16 D ability identities before considering them for mapping,
  and retain E mechanisms as explicit exclusions until separately designed.
- Keep target/pet-dependent reactions ineligible when relevant context cannot be
  safely attributed; do not weaken keyword safety to increase apparent coverage.

Stable V1 does not require Categories C–E to become wired. It requires the
shipped UI, guide, catalogue status, and release notes to accurately distinguish
supported automatic behavior from browsable/customizable content.

## 10. Recommended next implementation milestones

1. **Live-test bootstrap:** verify and add Interface metadata, then use the
   bounded local diagnostic specified in §7 for focused captures.
2. **Generic Category-B validation:** run the combat-transition and defensive
   capture matrix. Promote only evidence-backed rows to A; correct or disable a
   detector if attribution/readability fails.
3. **First ability validation:** capture the two mapped Paladin IDs across ranks,
   contexts, failures, and duplicate scenarios. Do not expand the allowlist in
   this step.
4. **Small mapping increment:** choose a few high-value C abilities only after
   live captures establish exact IDs and success semantics. Add mappings and
   regression tests in a separate implementation branch.
5. **V1 trigger decision:** explicitly select, investigate, or defer the
   remaining product-candidate generic triggers. Preserve conservative failure
   and avoid combat-log/text parsing.

No milestone should bulk-map candidate database IDs. Each production addition
needs a canonical catalogue identity, exact client evidence, a compatible event
mechanism, mocked regression coverage, and a stated live-verification status.
