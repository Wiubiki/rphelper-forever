# RPHelper Forever Runtime Wiring Audit

Audit date: 2026-10-09  
Branch inspected: `feat/druid-forms-behaviour`

## Baseline and remediation tracking

This audit is the baseline for implementing RPHelper's executable runtime and tracking remediation of the disconnected components identified below. The original findings and priorities are preserved; update the checklist as work is resolved and verified rather than rewriting the historical audit conclusions.

Verification is deliberately split into two stages:

- **Automated verification:** repository tests, syntax checks, and mocked runtime/event coverage.
- **Live Forever verification:** confirmation inside the current WoW Forever client for APIs, events, restrictions, routing, and observable behavior.

### P0 and P1 remediation checklist

All items are initially unresolved. Record the resolving branch and commit only after implementation exists; mark automated and live verification independently.

| Priority | Remediation item | Status | Resolving branch | Resolving commit | Automated-test verification | Live Forever verification |
| --- | --- | --- | --- | --- | --- | --- |
| P0 | Add the runtime coordinator and route semantic triggers through prepared content selection. | Unresolved | — | — | Not verified | Not verified |
| P0 | Register and validate the minimum V1 gameplay events and trigger mappings. | Unresolved | — | — | Not verified | Not verified |
| P0 | Add centralized dispatch for `say`, `emote`, and `customemote`. | Unresolved | — | — | Not verified | Not verified |
| P0 | Verify and add the correct Forever `## Interface` metadata. | Unresolved | — | — | Not verified | Not verified |
| P0 | Ensure runtime dispatch cannot bypass candidate preparation, keyword safety, or Druid speech suppression. | Unresolved | — | — | Not verified | Not verified |
| P1 | Normalize runtime trigger keys or define an explicit settings-to-content mapping. | Unresolved | — | — | Not verified | Not verified |
| P1 | Enforce enabled state, chance, frequency, global/per-trigger cooldowns, and per-combat output limits. | Unresolved | — | — | Not verified | Not verified |
| P1 | Define and enforce state-consumption order around eligibility, chance, selection, dispatch, and cooldown accounting. | Unresolved | — | — | Not verified | Not verified |
| P1 | Implement activity-aware output routing for open world, five-player instances, and raids. | Unresolved | — | — | Not verified | Not verified |
| P1 | Integrate saved user content and disabled shipped defaults into runtime pooling. | Unresolved | — | — | Not verified | Not verified |
| P1 | Add sequential database migrations and malformed-data handling. | Unresolved | — | — | Not verified | Not verified |
| P1 | Add mocked runtime-level event and output tests while retaining content-engine tests. | Unresolved | — | — | Not verified | Not verified |
| P1 | Reconcile `spell_crit` configuration with the unified `youcrit` contract. | Unresolved | — | — | Not verified | Not verified |

## 1. Executive summary

**Observed fact:** RPHelper is not currently an executable gameplay-reaction system. The addon loads data, initializes its SavedVariables table, and installs a small slash-command handler, but it registers no gameplay events and has no trigger orchestrator or output dispatcher. The only registered WoW event is `ADDON_LOADED` ([`RPHelper.lua:3-12`](../RPHelper/RPHelper.lua#L3)). Therefore no combat, critical-hit, avoidance, death, resurrection, spell, pet, NPC, or level event can currently select or emit content.

The repository contains a substantial, tested content subsystem:

- Generic, race, class, ability, and Druid-form entries register successfully ([`Core/Content.lua:70-145`](../RPHelper/Core/Content.lua#L70)).
- Generic + Race + Class pooling is implemented, with Druid form replacement for authored form/event combinations ([`Core/Content.lua:147-184`](../RPHelper/Core/Content.lua#L147)).
- Template expansion, keyword resolution, eligibility filtering, and random selection are implemented ([`Core/ContentEngine.lua:31-184`](../RPHelper/Core/ContentEngine.lua#L31)).
- Druid form detection and pre-selection speech filtering are implemented ([`Core/DruidForms.lua:47-89`](../RPHelper/Core/DruidForms.lua#L47), [`Core/ContentEngine.lua:140-157`](../RPHelper/Core/ContentEngine.lua#L140)).
- Persistence scaffolding and default merging are implemented ([`Core/Database.lua:15-35`](../RPHelper/Core/Database.lua#L15)).

These components are **implemented but disconnected** from gameplay. There is no end-to-end path from a gameplay event to output.

Highest-priority blockers:

1. **P0:** no gameplay event registration or trigger execution.
2. **P0:** no dispatcher for `say`, `emote`, or `customemote`.
3. **P0:** no runtime coordinator connecting identity/context, content selection, policy, and output.
4. **P1:** all frequency, chance, cooldown, encounter-cap, and activity-routing settings are unenforced.
5. **P1:** user custom content and disabled shipped defaults are persisted but never integrated.

## 2. Runtime component inventory

| Component | Classification | Evidence and notes |
| --- | --- | --- |
| TOC file order | **Implemented and wired** | Defaults → database → resolvers → Druid forms → engine → registries → commands → data → entrypoint is internally coherent ([`RPHelper.toc:7-41`](../RPHelper/RPHelper.toc#L7)). Data registration functions exist before data files load. |
| TOC metadata | **Partially implemented** | Title, notes, author, version, and per-character SavedVariables are declared ([`RPHelper.toc:1-5`](../RPHelper/RPHelper.toc#L1)). No `## Interface` field is present. Whether Forever rejects or merely marks this addon incompatible requires live-client verification. |
| External dependencies | **Implemented and wired** | No external libraries are referenced and no dependency declarations appear necessary based on inspected code. |
| Global initialization | **Implemented and wired** | Each module defensively initializes `RPHelper`; load order supplies referenced modules before use ([`Core/Defaults.lua:1-5`](../RPHelper/Core/Defaults.lua#L1), [`Core/Content.lua:1-6`](../RPHelper/Core/Content.lua#L1)). |
| SavedVariables declaration | **Implemented and wired** | `RPHelperDB` is declared per character in the TOC ([`RPHelper.toc:5`](../RPHelper/RPHelper.toc#L5)) and initialized on addon load ([`RPHelper.lua:6-11`](../RPHelper/RPHelper.lua#L6)). |
| Addon initialization | **Partially implemented** | Initialization merges defaults and registers slash commands only ([`RPHelper.lua:6-12`](../RPHelper/RPHelper.lua#L6)). It does not start gameplay event handling. |
| Slash commands | **Partially implemented** | `/rph on`, `off`, and `status` mutate/read the enabled setting ([`Core/Commands.lua:12-25`](../RPHelper/Core/Commands.lua#L12)); no runtime consumes that setting. `/rph spell` prints a placeholder message only ([`Core/Commands.lua:26-27`](../RPHelper/Core/Commands.lua#L26)). |
| Generic content registry | **Implemented but disconnected** | Registration and lookup work ([`Core/Content.lua:70-85`](../RPHelper/Core/Content.lua#L70)); no runtime caller exists. |
| Race content registry | **Implemented but disconnected** | Registration and lookup work ([`Core/Content.lua:87-96`](../RPHelper/Core/Content.lua#L87)); no player-race acquisition/runtime caller exists. |
| Class content registry | **Implemented but disconnected** | Registration and lookup work ([`Core/Content.lua:98-108`](../RPHelper/Core/Content.lua#L98)); no player-class acquisition/runtime caller exists. |
| Ability content registry | **Implemented but disconnected** | Registration, preparation, and selection work ([`Core/Content.lua:124-145`](../RPHelper/Core/Content.lua#L124)); nothing detects an ability and invokes them. |
| Druid-form content registry | **Implemented but disconnected** | Registration and Bear/Dire Bear aliasing work ([`Core/Content.lua:110-122`](../RPHelper/Core/Content.lua#L110)); no gameplay trigger invokes form-aware selection. |
| Layered character pool | **Implemented but disconnected** | Generic + Race + Class are additive, except authored Druid-form pools replace ordinary layers ([`Core/Content.lua:147-172`](../RPHelper/Core/Content.lua#L147)). No user or combination layer is present. |
| Candidate preparation | **Implemented but disconnected** | Templates, keyword resolution, invalid-candidate rejection, and copying are implemented ([`Core/ContentEngine.lua:31-157`](../RPHelper/Core/ContentEngine.lua#L31)). |
| Random selection | **Implemented but disconnected** | Selection occurs after eligibility filtering ([`Core/ContentEngine.lua:160-184`](../RPHelper/Core/ContentEngine.lua#L160)). |
| Keyword resolvers | **Partially implemented** | Player-owned API values and supplied trigger context are supported ([`Core/KeywordResolvers.lua:35-101`](../RPHelper/Core/KeywordResolvers.lua#L35)). No runtime constructs trigger context; several values intentionally require supplied data ([`Core/KeywordResolvers.lua:90-99`](../RPHelper/Core/KeywordResolvers.lua#L90)). |
| Trigger detector/orchestrator | **Not implemented** | No source function maps a gameplay event to a semantic RPHelper trigger. |
| Output routing/dispatch | **Not implemented** | No `SendChatMessage`, `DoEmote`, local-output UI, or equivalent dispatch call exists anywhere under `RPHelper/`. |
| Anti-spam controller | **Not implemented** | Defaults exist, but there is no runtime state or enforcement code. |
| User custom-content integration | **Not implemented** | `RPHelperDB.custom` is initialized only ([`Core/Database.lua:30`](../RPHelper/Core/Database.lua#L30)); it is never read into a content pool. |
| Disabled-default integration | **Not implemented** | `RPHelperDB.disabledDefaults` is initialized only ([`Core/Database.lua:31`](../RPHelper/Core/Database.lua#L31)); no stable entry identifiers or subtraction step exists. |
| Automated tests | **Implemented and wired for isolated modules** | Tests manually `dofile` modules and data ([`tests/test_content_engine.lua:34-67`](../tests/test_content_engine.lua#L34)); they do not load `RPHelper.lua`, mock `CreateFrame`, or exercise dispatch. Current result: 53 tests passed. |

## 3. End-to-end execution path

### Actual runtime path

```text
TOC loads modules and content
→ RPHelper.lua creates one frame
→ ADDON_LOADED fires
→ RPHelper.InitializeDatabase()
→ slash commands are installed
→ runtime stops
```

Evidence: the frame registers only `ADDON_LOADED`, and its handler performs only database initialization and slash-command installation ([`RPHelper.lua:3-12`](../RPHelper/RPHelper.lua#L3)).

### Available but unreachable content path

```text
caller supplies semantic trigger + race + class + options
→ RPHelper.GetContentPool()
→ Generic + Race + Class, or authored Druid form replacement
→ ContentEngine.PrepareCandidatePool()
→ Druid say suppression
→ template expansion
→ keyword resolution
→ invalid candidates discarded
→ random candidate selected
→ selected table returned to caller
→ no output consumer exists
```

Evidence: combined pool construction and selection entrypoints are present at [`Core/Content.lua:147-184`](../RPHelper/Core/Content.lua#L147); preparation and selection are present at [`Core/ContentEngine.lua:140-184`](../RPHelper/Core/ContentEngine.lua#L140).

### Missing links

No implementation currently performs any of these required steps:

1. Register relevant gameplay events.
2. Validate and translate event payloads into semantic triggers.
3. Obtain the player's canonical race/class identity for the event.
4. Construct safe keyword context.
5. Apply enabled/chance/cooldown/activity/encounter policies.
6. Call `ChooseContentCandidate` or `ChooseAbilityCandidate`.
7. Route the selected candidate based on `type` and activity context.
8. Record cooldown or per-combat output state after successful dispatch.

## 4. Trigger coverage matrix

All gameplay triggers below are **implemented as content/settings at most, but disconnected at runtime**, because the only registered event is `ADDON_LOADED` ([`RPHelper.lua:3-8`](../RPHelper/RPHelper.lua#L3)). “Defined” means data or configuration exists, not that detection works.

| Semantic trigger/content family | Content | Default setting | WoW handler | Runtime status |
| --- | --- | --- | --- | --- |
| `entercombat` | Yes; Generic begins at [`Data/Generic.lua:7-23`](../RPHelper/Data/Generic.lua#L7) | `enter_combat` at [`Defaults.lua:14`](../RPHelper/Core/Defaults.lua#L14) | None | **Implemented but disconnected**; setting/content names also require explicit mapping. |
| `leavecombat` | Yes ([`Data/Generic.lua:25-40`](../RPHelper/Data/Generic.lua#L25)) | `leave_combat` ([`Defaults.lua:15`](../RPHelper/Core/Defaults.lua#L15)) | None | **Implemented but disconnected**; no combat-termination tracking. |
| `youcrit` | Yes ([`Data/Generic.lua:133-153`](../RPHelper/Data/Generic.lua#L133)) | `crit` ([`Defaults.lua:16`](../RPHelper/Core/Defaults.lua#L16)) | None | **Implemented but disconnected**; physical/ranged/spell critical unification is not executed. |
| Spell-critical legacy content | Stored as `deferred_youcritspell` in some class files; tests require no active `youcritspell` ([`tests/test_content_engine.lua:529-540`](../tests/test_content_engine.lua#L529)) | `spell_crit` still exists ([`Defaults.lua:17`](../RPHelper/Core/Defaults.lua#L17)) | None | **Partially implemented/inconsistent**; config exposes a deprecated family with no active content contract. |
| `dodge` | Yes ([`Data/Generic.lua:73-92`](../RPHelper/Data/Generic.lua#L73)) | Yes ([`Defaults.lua:18`](../RPHelper/Core/Defaults.lua#L18)) | None | **Implemented but disconnected**. |
| `parry` | Yes ([`Data/Generic.lua:94-111`](../RPHelper/Data/Generic.lua#L94)) | Yes ([`Defaults.lua:19`](../RPHelper/Core/Defaults.lua#L19)) | None | **Implemented but disconnected**. |
| `block` | Yes ([`Data/Generic.lua:113-131`](../RPHelper/Data/Generic.lua#L113)) | Yes ([`Defaults.lua:20`](../RPHelper/Core/Defaults.lua#L20)) | None | **Implemented but disconnected**. |
| `death` | Yes ([`Data/Generic.lua:155-169`](../RPHelper/Data/Generic.lua#L155)) | Yes ([`Defaults.lua:21`](../RPHelper/Core/Defaults.lua#L21)) | None | **Implemented but disconnected**. |
| `resurrect` | Yes ([`Data/Generic.lua:171-188`](../RPHelper/Data/Generic.lua#L171)) | Yes ([`Defaults.lua:22`](../RPHelper/Core/Defaults.lua#L22)) | None | **Implemented but disconnected**. |
| `hurt` | Yes ([`Data/Generic.lua:42-50`](../RPHelper/Data/Generic.lua#L42)) | No | None | **Implemented but disconnected**; policy/default missing. |
| `absorb` | Yes ([`Data/Generic.lua:52-60`](../RPHelper/Data/Generic.lua#L52)) | No | None | **Implemented but disconnected**. |
| `miss` | Yes ([`Data/Generic.lua:62-71`](../RPHelper/Data/Generic.lua#L62)) | No | None | **Implemented but disconnected**. |
| `level_up` | No shipped content found | Yes ([`Defaults.lua:23`](../RPHelper/Core/Defaults.lua#L23)) | None | **Partially implemented**; setting only. |
| Killing blow | No shipped generic content/default found | No | None | **Not implemented**, though listed as a V1 candidate ([`docs/product_spec.md:51-61`](../docs/product_spec.md#L51)). |
| `monster_emote_help` | Yes ([`Data/Generic.lua:190-201`](../RPHelper/Data/Generic.lua#L190)) | No | None | **Implemented but disconnected**; event/payload/relevance semantics explicitly require verification ([`docs/content_engine.md:139-149`](../docs/content_engine.md#L139)). |
| `monster_emote_fear` | Yes ([`Data/Generic.lua:203-215`](../RPHelper/Data/Generic.lua#L203)) | No | None | **Implemented but disconnected**. |
| `monster_emote_enrage` | Yes ([`Data/Generic.lua:217-229`](../RPHelper/Data/Generic.lua#L217)) | No | None | **Implemented but disconnected**. |
| Pet start/stop/death | Class content exists; Hunter tests prove pools ([`tests/test_content_engine.lua:511-527`](../tests/test_content_engine.lua#L511)) | No | None | **Implemented but disconnected**. |
| Heal/critical heal | Some class content exists | No | None | **Implemented but disconnected**; not in current V1 passive-trigger list. |
| NPC friendly/enemy speech | Some class content exists; template test at [`tests/test_content_engine.lua:486-496`](../tests/test_content_engine.lua#L486) | No | None | **Implemented but disconnected**. |
| Ability/spell use | Extensive ability catalogues exist and selection API exists ([`Core/Content.lua:124-145`](../RPHelper/Core/Content.lua#L124)) | No active policy | None | **Implemented but disconnected**. `/rph spell` is only a print placeholder ([`Commands.lua:26-27`](../RPHelper/Core/Commands.lua#L26)); ability-triggered macro RP is deferred by product scope ([`docs/product_spec.md:63-83`](../docs/product_spec.md#L63)). |
| Enemy cast/channel/interrupt | No content/runtime committed | No | None | **Not implemented**, correctly listed only as future candidates ([`docs/content_engine.md:151-159`](../docs/content_engine.md#L151)). |

## 5. Settings and enforcement matrix

| Setting/state | Stored/defaulted | Runtime enforcement | Classification |
| --- | --- | --- | --- |
| `settings.enabled` | Default exists ([`Defaults.lua:7`](../RPHelper/Core/Defaults.lua#L7)); slash commands modify it ([`Commands.lua:18-25`](../RPHelper/Core/Commands.lua#L18)) | No trigger/output runtime reads it | **Implemented but disconnected** |
| `frequencyPreset` | Default exists ([`Defaults.lua:8`](../RPHelper/Core/Defaults.lua#L8)) | Never read | **Implemented but disconnected** |
| `globalCooldown` | Default exists ([`Defaults.lua:9`](../RPHelper/Core/Defaults.lua#L9)) | No timestamps/state/enforcement | **Implemented but disconnected** |
| `maxAutomaticOutputsPerCombat` | Default exists ([`Defaults.lua:10`](../RPHelper/Core/Defaults.lua#L10)) | No combat lifecycle or counter | **Implemented but disconnected** |
| `suppressSayInForms` | Default and saved-setting lookup exist ([`Defaults.lua:11`](../RPHelper/Core/Defaults.lua#L11), [`DruidForms.lua:72-89`](../RPHelper/Core/DruidForms.lua#L72)) | Enforced by candidate preparation when class/form context reaches it ([`ContentEngine.lua:140-146`](../RPHelper/Core/ContentEngine.lua#L140)); no runtime path invokes preparation | **Implemented but disconnected** end-to-end |
| Per-trigger `enabled` | Defaults exist ([`Defaults.lua:14-23`](../RPHelper/Core/Defaults.lua#L14)) | Never read | **Implemented but disconnected** |
| Per-trigger `chance` | Defaults exist ([`Defaults.lua:14-23`](../RPHelper/Core/Defaults.lua#L14)) | Never read | **Implemented but disconnected** |
| Per-trigger `cooldown` | Defaults exist ([`Defaults.lua:14-23`](../RPHelper/Core/Defaults.lua#L14)) | Never read | **Implemented but disconnected** |
| Activity routing (world/party/instance/raid) | Product behavior specified ([`docs/product_spec.md:20-45`](../docs/product_spec.md#L20)) | No activity detection or policy implementation | **Not implemented** |
| `custom` | Empty persisted table initialized ([`Database.lua:30`](../RPHelper/Core/Database.lua#L30)) | Never read or merged | **Implemented but disconnected** storage; **not implemented** runtime behavior |
| `disabledDefaults` | Empty persisted table initialized ([`Database.lua:31`](../RPHelper/Core/Database.lua#L31)) | Never read/subtracted | **Implemented but disconnected** storage; **not implemented** runtime behavior |

## 6. Missing or disconnected functionality

### P0 functional gaps

- No gameplay-event frame/registration beyond `ADDON_LOADED` ([`RPHelper.lua:3-8`](../RPHelper/RPHelper.lua#L3)).
- No semantic trigger executor.
- No player identity/context assembler for race, class, target, pet, or event-specific values.
- No output dispatcher for any content type.
- No runtime call to `ChooseContentCandidate` or `ChooseAbilityCandidate`; the only references are their definitions and tests.

### P1 runtime-policy gaps

- Enabled state, frequency preset, trigger toggles, chances, cooldowns, and combat output cap have no effect.
- No world/instance/raid routing or local-only saying output exists, despite product requirements ([`docs/product_spec.md:20-45`](../docs/product_spec.md#L20)).
- No user content merge or disabled-default subtraction exists, despite the documented runtime formula ([`docs/data_architecture.md:48-56`](../docs/data_architecture.md#L48)).
- Ability pools have no automatic detection path. This may be acceptable while ability activation remains deferred, but the data must not be mistaken for runtime support.
- Trigger configuration names (`enter_combat`, `leave_combat`, `crit`) differ from content keys (`entercombat`, `leavecombat`, `youcrit`). A future runtime requires one explicit canonical mapping or normalized naming; direct indexing will fail.

### P2 completeness gaps

- No preview/configuration surface exists.
- No exceptional race/class combination layer exists yet.
- No stable per-entry identifiers exist for selectively disabling shipped defaults, which the product spec acknowledges as future design work ([`docs/product_spec.md:103-108`](../docs/product_spec.md#L103)).

## 7. Bugs and architectural risks

### Observed facts

1. **No functional output is possible.** There is no dispatch API call anywhere in addon source.
2. **The on/off command is cosmetic.** It persists a value, but no runtime reads it ([`Commands.lua:18-25`](../RPHelper/Core/Commands.lua#L18)).
3. **The spell command is cosmetic.** It prints the requested key without selecting ability content ([`Commands.lua:26-27`](../RPHelper/Core/Commands.lua#L26)).
4. **Schema versioning does not perform migrations.** Initialization sets a version only when absent and never compares or updates versions ([`Database.lua:25-34`](../RPHelper/Core/Database.lua#L25)). This conflicts with the documented sequential-migration requirement ([`docs/data_architecture.md:58-65`](../docs/data_architecture.md#L58)).
5. **Malformed persisted container types can break initialization.** If an existing `settings` or `triggers` value is non-table, `applyMissing` is still called with it at [`Database.lua:33-34`](../RPHelper/Core/Database.lua#L33), and indexing inside [`Database.lua:15-22`](../RPHelper/Core/Database.lua#L15) is unsafe. Normal addon-created databases use tables, so this concerns corrupted/manual/legacy data.
6. **Content/settings trigger names are inconsistent.** Without an explicit translation layer, enabled/chance/cooldown lookup cannot work reliably.
7. **Tests prove modules, not runtime wiring.** They manually load modules and data ([`tests/test_content_engine.lua:34-67`](../tests/test_content_engine.lua#L34), then directly invoke registries/selection. `RPHelper.lua` and output APIs are not tested.

### Architectural risks for future wiring

1. **Druid suppression can be bypassed by an incorrect dispatcher.** Speech suppression lives in `PrepareCandidate` ([`ContentEngine.lua:140-146`](../RPHelper/Core/ContentEngine.lua#L140)), not in raw pool lookup. A dispatcher that consumes `GetContentPool` directly and emits an entry without using preparation/selection would bypass suppression and keyword safety. The documented pipeline requires preparation before output ([`docs/content_engine.md:122-137`](../docs/content_engine.md#L122)).
2. **Generic-only helpers need context.** `ChooseGenericCandidate` passes caller options through but cannot infer the semantic class argument itself ([`Content.lua:79-85`](../RPHelper/Core/Content.lua#L79)). Druid suppression can still infer class via `UnitClass`, but a runtime should use the combined selection entrypoint and provide canonical class/form context explicitly.
3. **Unknown Druid form intentionally suppresses speech.** API absence/errors map to `UNKNOWN`, and every non-`HUMANOID` value suppresses sayings ([`DruidForms.lua:47-69`](../RPHelper/Core/DruidForms.lua#L47), [`DruidForms.lua:89`](../RPHelper/Core/DruidForms.lua#L89)). This is fail-closed for speech, but requires live confirmation that the API exists and returns expected IDs.
4. **Form-specific replacement is event-specific.** An authored Cat/Bear/Moonkin pool replaces all Generic/Race/Class entries only when that exact form/trigger pool is nonempty ([`Content.lua:149-160`](../RPHelper/Core/Content.lua#L149)). For other triggers, ordinary content remains and sayings are filtered during preparation. This behavior is tested in isolation, not through runtime events ([`tests/test_content_engine.lua:605-650`](../tests/test_content_engine.lua#L605)).
5. **Ability content is deliberately separate from character pooling.** Tests enforce this ([`tests/test_content_engine.lua:503-509`](../tests/test_content_engine.lua#L503)). A future ability event must explicitly choose an ability pool or define a combination policy; it will not appear automatically in `GetContentPool`.
6. **Cooldown semantics must be tied to successful dispatch.** Candidate selection already filters unresolved/suppressed entries before random choice ([`ContentEngine.lua:160-184`](../RPHelper/Core/ContentEngine.lua#L160)), but there is no policy code deciding when chance, cooldown, or encounter counts are consumed.

## 8. Recommended corrections, prioritised

### P0 — prevents addon functioning

1. Add a minimal runtime coordinator that owns trigger execution and calls the existing combined selection API.
2. Register and validate the minimum V1 gameplay events, starting with combat entry/exit and player lifecycle events whose payloads can be trusted in Forever.
3. Add a centralized output router for `say`, `emote`, and `customemote`, respecting activity restrictions and manual-chat boundaries.
4. Verify/add the correct Forever `## Interface` TOC metadata so the client will load the addon normally.
5. Ensure all runtime paths use candidate preparation/selection rather than emitting raw content entries.

### P1 — required for v1.0

1. Define canonical runtime trigger keys or an explicit settings-to-content mapping.
2. Enforce master enabled state, per-trigger enabled/chance/cooldown, global cooldown, frequency preset, and per-combat maximum.
3. Decide and document state-consumption order: eligibility → chance → selection → dispatch → cooldown/count update, with failures not consuming successful opportunities.
4. Implement activity-context routing: open-world local saying, 5-player `/say`, raid suppression, and custom/built-in emote policy.
5. Merge valid `RPHelperDB.custom` entries into the appropriate runtime layer and apply `disabledDefaults` once stable entry IDs exist.
6. Implement sequential schema migrations and safe handling/reporting of malformed persisted structures.
7. Add runtime-level tests with mocked frames/events/output APIs; retain current content-engine unit tests.
8. Reconcile unsupported/deferred trigger settings, especially `spell_crit`, with the unified `youcrit` contract.

### P2 — can wait

1. Add preview and configuration UI after runtime policies stabilize.
2. Add exceptional race/class combination support only where authored behavior requires it.
3. Add stable content-entry IDs and granular default suppression.
4. Revisit deferred ability macro activation and future cast/interrupt triggers after Forever API validation.

## 9. Items requiring live Forever testing

These cannot be established from repository code alone:

- Whether the client accepts a TOC without `## Interface`, and the correct current Forever interface number.
- Exact availability, payload shape, secret-value behavior, and restrictions of candidate combat events.
- Whether a trustworthy API exposes offensive critical hits, dodges, parries, blocks, absorbs, misses, and killing blows in Forever.
- Combat entry/termination ordering and reload/login behavior while already in combat.
- Reliable resurrection detection versus release, corpse run, spirit healer, and combat resurrection.
- `GetShapeshiftFormID()` availability and IDs for Cat, Bear, Dire Bear, Moonkin, Travel, Aquatic, and any Forever-specific forms ([`DruidForms.lua:17-28`](../RPHelper/Core/DruidForms.lua#L17)).
- `UnitClass`, `UnitRace`, target, pet, guild, and other resolver behavior under combat restrictions ([`KeywordResolvers.lua:52-99`](../RPHelper/Core/KeywordResolvers.lua#L52)).
- Which chat/emote APIs are permitted from automatic event handlers, including `/say`, `/e`, built-in emotes, party routing, and instance/raid restrictions.
- Whether protected/hardware-event restrictions affect any proposed ability-trigger or output route.
- Monster emote localization, sender relevance, and event availability, already marked uncertain by the content contract ([`docs/content_engine.md:139-149`](../docs/content_engine.md#L139)).

## Validation performed

- `lua tests/test_content_engine.lua`: **53 tests passed**.
- `git diff --check`: passed.
- No source files or tests were modified by this audit.
