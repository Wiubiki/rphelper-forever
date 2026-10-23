# Milestone 5A offline integration and regression coverage audit

**Audit date:** 2026-10-23

**Audited revision:** `3b8f00d91005395c20df1a7c9d0d8c48f2a5848e`

**Branch:** `audit/milestone-5a-offline-integration`

## Executive summary

The current implementation and its 309 passing automated tests provide sufficient
offline confidence to begin initial live-client testing. The tested runtime uses
one policy path for combat transitions, defensive reactions, and the two mapped
Paladin abilities; it consistently applies activity restrictions, quota,
cooldown/Priority, enablement, chance, content eligibility, weighted selection,
and successful-dispatch-only accounting. Schema-v2 persistence, the Character
Library/editor, immutable Built-ins, independent Custom copies, Druid Say
suppression, output routing, and session-only diagnostics all have substantive
automated coverage.

No confirmed implementation defect was found. In particular, the audit found no
evidence of an initialization failure, incorrect event name, policy-order
contradiction, persistence overwrite, UI/runtime configuration split, or route
that bypasses raid or Druid restrictions.

The principal offline coverage gap is that no test reads `RPHelper.toc` and loads
the complete addon in exactly that declared order. Existing suites collectively
load every production Lua file, exercise the entry point, and preserve the same
dependency ordering in their relevant fixtures, so this is a regression risk
rather than a current defect. A small manifest-driven smoke test is recommended
before packaging. It is not a reason to delay the first controlled live-client
session.

The client remains the only place to establish event delivery and payload
readability, current spell/form identifiers, automatic chat and emote permission,
real SavedVariables persistence, and UI rendering. RPHelper Forever remains a
v0.9 prerelease; these results do not establish V1.0 stability.

## Scope and evidence model

The authoritative policy sources were identified through the
[documentation index](../README.md):

- [Product specification](../product_spec.md) for trigger, policy, routing, and
  release behavior.
- [Content engine specification](../content_engine.md) for preparation,
  eligibility, and reactive-trigger semantics.
- [Data and persistence architecture](../data_architecture.md) and
  [SavedVariables architecture](../savedvariables_architecture.md) for
  per-character ownership and schema v2.
- [UI/UX specification](../ui_ux_spec.md) for the Character Library/editor,
  Priority, weights, preview, Guide, and About behavior.
- [Forever ability reconciliation](../forever_ability_reconciliation.md) for the
  distinction between browsable catalogue content and runtime eligibility.

Supporting implementation boundaries come from
[runtime API assumptions](../runtime_api_assumptions.md) and
[user-content runtime](../user_content_runtime.md). Historical audits were used
as dated background only, not as current policy.

Test classifications in this report mean:

- **Unit:** a module or narrow API is exercised directly.
- **Integration:** multiple real addon modules and their shared state are
  exercised together in one Lua process.
- **Mocked game-API integration:** real addon coordination is exercised behind
  deterministic substitutes for WoW frames, events, globals, or output APIs.

No instrumented line-coverage percentage is available. Conclusions therefore
use behavior assertions and inspected paths, not an inferred percentage.

## Coverage by subsystem

| Subsystem | Specified and implemented behavior | Existing proof | Classification | Still live-client-only |
| --- | --- | --- | --- | --- |
| Addon initialization and event wiring | The TOC orders core, catalogue, UI, then `RPHelper.lua`; `ADDON_LOADED` initializes the character database, commands, UI, runtime, and the four implemented event paths. | `test_runtime.lua`: “addon initialization registers combat events”; `test_ui.lua`: “addon startup initializes the UI and preserves runtime initialization”; all 62 Lua files parse and are loaded across the suites. | Mocked game-API integration | Actual TOC loading, addon-name payload, frame/event availability, and login/reload ordering. |
| Trigger detection | Combat entry/exit map to semantic triggers. `UNIT_COMBAT` accepts only readable player DODGE, PARRY, and direct BLOCK while in an encounter. `UNIT_SPELLCAST_SUCCEEDED` accepts only readable player events for Paladin IDs 19750 and 20288. Unknown/restricted input fails closed. | Runtime tests cover semantic routing, duplicate transitions, initial in-combat state, registration failure, exact defensive classification, secret/malformed fields, two mapped abilities, wrong units/classes/IDs, and full frame forwarding. Diagnostics tests cover all four event paths. | Mocked game-API integration | Whether Forever sends these events with the assumed readable fields, ordering, ranks, and duplication behavior. |
| Eligibility and weighted selection | Generic/Race/Class layers combine; Druid form pools replace applicable shipped layers; Custom entries join their scope; disabled entries and ineligible templates/keywords are removed before integer 1–10 weighting. | Content tests cover layers, templates, keywords, Druid forms, disabled defaults, Custom pools, and deterministic weighted boundaries. Runtime tests cover mixed Built-in/Custom weights and invalid persisted values through dispatch. | Integration plus mocked game-API integration | Client-derived target/pet context and secret-value behavior in actual event conditions. |
| Chance, cooldown, quota, and Priority | A sparse event chance replaces the global chance. Chance precedes pool construction. The cooldown is global and session-only. Priority bypasses only cooldown and never changes its timer. Encounter quota includes every successful in-combat route and exit, and failed/rejected attempts consume no state. | Runtime tests explicitly cover probability boundaries, replacing chance, no early pool construction, exact cooldown expiry, Priority restrictions, shared state across transitions/defenses/abilities, quota reset/exhaustion, reload-in-combat, and failed dispatch. Diagnostics tests prove observation adds no policy spending. | Integration with mocked clock/RNG/game APIs | Timing and event cadence under the client, including duplicate ability delivery. |
| Output restrictions and routing | World Say is local; dungeon Say broadcasts unless the character selects local mode; Emote uses `DoEmote`; Custom Emote uses `EMOTE`; raids and unknown activity suppress all types; unavailable local display has no public fallback. | Runtime tests exercise each output API, every route, dungeon preference, raid/unknown suppression, missing/failing output APIs, and shared quota accounting across routes. | Mocked game-API integration | `IsInInstance` values, server acceptance, automation restrictions, supported emote tokens, and local chat-frame visibility. |
| Druid safety | Recognized, unknown, unavailable, and failing form detection suppresses Say for Built-in and Custom candidates; humanoid nil/0 permits Say; emotes remain eligible. No saved/UI override exists. | Content tests cover form detection and preparation. Runtime tests cover generic, defensive, mapped ability, Priority, unavailable API, and Custom paths. UI tests present the policy as informational rather than configurable. | Integration plus mocked game-API integration | Actual Forever form IDs and form API behavior. |
| Schema-v2 persistence | One per-character `RPHelperDB` stores sparse settings, event/ability overrides, disabled Built-ins, weights, and Custom records. Invalid data is retained and resolved safely; unsupported schemas are not mutated. | All 16 schema tests cover sparse initialization/resolution, atomic writes, malformed preservation, character isolation, Custom CRUD, and independent modified copies. Runtime and UI suites add malformed-startup, database replacement, module reload, and per-character interaction cases. | Unit and integration | Disk persistence across `/reload`, logout/login, crash, addon update, and actual character changes. |
| UI and runtime configuration | Main controls and event/ability editors write through `Configuration`; the runtime reads the same resolvers. Library activation/weighting uses the same Built-in and Custom APIs as selection. Guide/About are implemented and side-effect free. | UI tests cover all controls, sparse writes, rollback, character switching, simulated UI reload, event/ability settings, activation, weights, CRUD/copies, preview, Guide/About, and startup. Runtime tests independently prove that the resulting resolver values govern policy and selection. | Mocked UI integration; compositional runtime integration | Layout, scrolling, focus, input, metadata, and interaction behavior in the real UI. No single existing test clicks a UI control and then fires a runtime event. |
| Built-in and Custom lifecycle | Shipped entries remain immutable. Disabling and weighting use sparse per-character records. Modify creates a new independent Custom entry; CRUD, activation, preview, and selection do not alter the source. | Schema, content, UI, and runtime tests cover source independence, permanent IDs, disabled-entry exclusion, Custom CRUD/cache invalidation, activation/weights, private preview, and Custom runtime policy/routing. | Unit and integration | SavedVariables lifecycle and user interaction in the client. |
| Diagnostics | Capture starts disabled/empty, is session-only, retains a 100-record ring, exposes the six approved commands, sanitizes payloads, and passively describes event delivery/classifier interpretation. | All 9 diagnostic tests cover lifecycle, SavedVariables independence, event paths, sanitization, restricted/malformed values, buffer order, commands, and lack of policy/output side effects. | Unit plus mocked game-API integration | Usefulness and readability during actual client failures. By specification, records do not explain the final chance/cooldown/quota/eligibility/output decision. |

## Interaction findings

The high-risk interactions named for this audit are substantially covered:

- **UI to schema to runtime:** UI assertions prove controls persist through
  `Configuration`; runtime assertions prove the same accessors govern chance,
  cooldown, quota, Priority, routing, and selection. This is strong compositional
  evidence, although there is no single click-to-event black-box test.
- **Disabled Built-ins:** content/runtime tests remove disabled permanent IDs from
  selection, and UI/schema tests prove the per-character exclusion is written and
  restored without changing shipped content.
- **Priority:** tests prove it bypasses only the cooldown, remains subject to
  raid, quota, enablement, chance, eligibility, and dispatch, and does not consume
  state after failure.
- **Rejected events:** chance rejection, invalid clocks/RNG, empty or ineligible
  pools, restricted payloads, unsupported activity, and failed output leave
  cooldown/quota unchanged in the relevant runtime tests.
- **Character isolation:** separate database tables retain independent settings,
  activation, weights, and Custom records through refresh and simulated module
  reload. Actual client serialization remains unverified.
- **Druid safety:** Built-in and Custom Say content is suppressed through generic,
  defensive, and ability routes, regardless of saved/UI settings.
- **Output restrictions:** the shared output path rejects raids and unknown
  contexts for Say, Emote, and Custom Emote; tests also cover world/dungeon Say
  differences and the no-public-fallback rule.
- **Diagnostics:** records accurately report sanitized event/classifier results
  as specified. They deliberately do not claim that output occurred or identify
  the later policy gate that rejected a matched event.

## Launch-critical failure-mode assessment

| Failure mode | Evidence-based assessment |
| --- | --- |
| Initialization or load order | No current defect found. The inspected TOC orders dependencies correctly, individual suites execute the relevant order, and startup tests reach database/UI/runtime initialization. Exact manifest-driven loading is not automated. |
| Nil or unavailable APIs | Runtime adapters use protected calls or fail-closed returns for optional/classification/output APIs, with dedicated tests. Base frame creation and core event registration remain client assumptions. |
| Incorrect event registration | The four intended paths and forwarding are asserted. Real Forever acceptance and delivery are deferred to live testing. |
| Unexpected Lua errors | All 62 source/test Lua files pass `luac -p`; malformed data and unavailable adapter cases are exercised. Lua 5.5.1 is not the embedded client runtime, so syntax success is necessary but not sufficient. |
| SavedVariables failure | Fresh, malformed, unsupported, isolated, and simulated reload states behave safely offline. Real serialization is unverified. |
| UI/runtime divergence | Both sides use `Configuration` and `UserContent`; no conflicting second settings model was found. The missing click-to-event test is a coverage gap, not observed divergence. |
| Duplicate/excess output | Duplicate combat transitions are rejected; chance, cooldown, and quota are shared. Ability-event duplicate suppression is intentionally absent and explicitly requires live observation. |
| Broken output filtering | All output kinds share activity rejection and tests cover raids/unknown contexts. Druid suppression is in shared candidate preparation and covered on each runtime family. No bypass was found. |
| Diagnostic insufficiency | Diagnostics establish delivery/classification safely. They cannot identify which later policy or dispatch gate rejected a matched event; this is a bounded troubleshooting limitation, not a contradiction of the approved diagnostic scope. |

## Findings by severity

### P0

None.

### P1

- **Coverage gap: exact TOC load smoke test.** No test parses the manifest and
  executes every declared file in order before sending `ADDON_LOADED`. A manifest
  omission, duplication, or ordering regression could therefore escape the
  current suites. Inspection found no such defect at the audited revision.

### P2

- **No single UI-to-runtime black-box scenario.** UI persistence and runtime
  consumption are independently well covered through the same APIs, but one
  compact scenario should click settings/activation controls, fire an event, and
  verify the changed eligibility/route and character isolation.
- **Diagnostics stop at classification.** This is exactly the approved scope, but
  a matched record cannot distinguish chance, cooldown, quota, disabled content,
  empty eligibility, or failed dispatch. Consider a narrowly scoped final-decision
  reason only if initial client testing shows this prevents efficient diagnosis;
  it would require a product-spec decision before implementation.

### Deferred

- Confirm the actual TOC/addon-name and all four event registrations and payloads.
- Confirm `issecretvalue`, `UnitAffectingCombat`, `UnitClass`, `UnitRace`,
  `IsInInstance`, `GetTime`, and `GetShapeshiftFormID` behavior in Forever.
- Confirm Paladin spell IDs/ranks and observe duplicate cast-success delivery.
- Confirm automatic `SAY`, `EMOTE`, `DoEmote`, and local display behavior in
  world, dungeon, and raid contexts without attempting restriction workarounds.
- Confirm SavedVariables isolation and persistence across reload, logout/login,
  client restart, and addon update.
- Confirm real UI layout, scrolling, focus, editor flows, and Guide/About display.
- Observe reaction frequency and quota/cooldown behavior under real event cadence.

## Recommended next action

Initial controlled live-client testing can begin now; no confirmed defect blocks
it. Before Milestone 5B packaging, perform one small offline follow-up rather than
a broad test rewrite:

1. Add a manifest-driven mocked smoke test that reads `RPHelper.toc`, loads every
   declared Lua file exactly once in order, sends `ADDON_LOADED`, and asserts the
   database, UI, slash command, and four event registrations initialize.
2. In the same focused task, add one end-to-end UI-to-runtime scenario covering a
   per-character UI change, a disabled Built-in or Custom reaction, and a fired
   event after simulated reload/database replacement.
3. Do not broaden gameplay detection or diagnostics unless live evidence reveals
   a concrete need.

After that bounded P1 coverage increment and the documented live-client checks,
proceed to Milestone 5B packaging. If scheduling requires parallel progress, the
current offline results are strong enough to start the live checks immediately.

## Validation results

Commands were run with Lua 5.5.1 from the audited branch:

| Validation | Result |
| --- | --- |
| `lua tests/test_content_engine.lua` | **PASS — 139 tests** |
| `lua tests/test_runtime.lua` | **PASS — 95 tests** |
| `lua tests/test_schema_v2.lua` | **PASS — 16 tests** |
| `lua tests/test_ui.lua` | **PASS — 50 tests** |
| `lua tests/test_diagnostics.lua` | **PASS — 9 tests** |
| Total | **PASS — 309 tests, 0 failures** |
| `luac -p` over `RPHelper/` and `tests/` | **PASS — 62 files, 0 failures** |

Final whitespace, link, protected-file, and diff checks are recorded in the
generated `tmp/review.txt` review artifact.

## Milestone 5A.1 coverage addendum — 2026-10-23

The two actionable offline integration gaps identified above are now covered:

- `tests/test_manifest_startup.lua` parses the real `RPHelper/RPHelper.toc`
  without maintaining a second entry list. It rejects missing, duplicate,
  unsafe, or malformed Lua entries; detects non-archive production Lua files
  omitted from the manifest; loads every declared file in manifest order; and
  simulates `ADDON_LOADED` with the addon identity derived from the TOC path. It
  verifies schema-v2 database creation, hidden UI initialization, slash-command
  registration, and registration of combat entry, combat exit, defensive, and
  ability event paths.
- `tests/test_ui.lua` now contains a compact UI-to-runtime scenario using the real
  configuration, library, content, output, and runtime modules. A character uses
  actual UI controls to set reaction chance and local dungeon Say routing, then
  disables a Built-in Dodge reaction through its library checkbox. A deterministic
  mocked Dodge event selects the remaining Custom reaction and routes it locally.
  Replacing the character database restores the untouched default Built-in and
  dungeon route; restoring the first database restores its Custom content,
  Built-in exclusion, and local route.

The manifest/load-order P1 gap and UI-to-runtime P2 gap are therefore closed for
offline regression purposes. The diagnostic boundary is unchanged: diagnostics
continue to report event delivery and classifier interpretation, not later policy
rejection reasons.

All suites pass after this increment: 139 content, 95 runtime, 16 schema-v2, 51
UI, 9 diagnostic, and 1 manifest-startup test, for **311 tests total with 0
failures**. These tests remain mocked. They do not reduce the live-client-only
limitations listed above, including client event delivery and secret-value
readability, automatic output permission, activity/form/spell identifiers, real
SavedVariables serialization, or rendered UI behavior.
