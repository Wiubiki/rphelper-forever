# V1.0 UI Technical Feasibility Audit

## Scope and evidence levels

This document began as the read-only pre-implementation audit. Its feasibility
findings use:

- the current RPHelper repository and tests;
- the community-maintained [WoW: Forever API reference](https://github.com/Atraeau/WoW-Addons/blob/main/docs/api/README.md), whose inventory includes UI Widgets & Frames;
- Blizzard UI source mirrors and generated widget documentation as comparative
  evidence, not proof of Forever behavior;
- the [DoEmote API reference](https://warcraft.wiki.gg/wiki/API_DoEmote) and
  Blizzard chat-frame source for emote-token behavior;
- Blizzard's published [UI Add-On Development Policy](https://us.forums.blizzard.com/en/wow/t/ui-add-on-development-policy/24534).

“Documented” means a relevant API/source surface was found. “Existing” means the
repository uses it now. Neither substitutes for live testing in WoW Forever.

## Current repository state

- The addon-owned window provides Main, Guide, and About navigation. Main contains
  working global controls and a Character Library entry point. Milestone 2A adds
  bounded Generic, current-Race, and current-Class browsing with reaction
  inspection and activation. Milestone 2B adds event settings, 1–10 weights,
  Custom CRUD, independent Built-in copies, and private preview. Milestone 3
  replaces the Guide and About placeholders with bounded paginated reference
  content, metadata-backed prerelease identity, attribution, and a selectable
  repository URL.
- `RPHelper.lua` creates one event frame, initializes `RPHelperDB`, initializes
  the UI, registers slash commands, and starts the runtime.
- `/rph` toggles the window while `/rph on`, `/rph off`, `/rph status`, and help
  remain available. The Library reads through the configuration/content APIs and
  uses shared configuration and user-content APIs for activation, event settings,
  weighting, creation, editing, deletion, and preview.
- Current output uses global `DoEmote(token)`, `SendChatMessage(..., "EMOTE")`,
  `SendChatMessage(..., "SAY")`, and local chat-frame display through an adapter.
- Schema v2 and runtime policy v2 are implemented; no development-settings
  migration is required.
- Current selection is weighted after eligibility; event Priority bypasses only
  the shared cooldown, and dungeon Say routing is character-configurable.

## UI API and widget feasibility

The Forever API reference reports a substantial UI Widgets & Frames surface.
The existing addon already proves `CreateFrame("Frame")`, event registration,
and scripts are expected by this codebase, though live Forever validation remains
pending.

Generated Blizzard widget documentation exposes Slider, EditBox, Button,
CheckButton, and ScrollFrame script objects. The Forever reference inventory is
strong evidence that ordinary frame widgets exist, but Retail template names,
mixins, Settings-panel registration, ScrollBox helpers, and exact method security
annotations must not be assumed.

| Proposed capability | Assessment | Conservative implementation boundary |
| --- | --- | --- |
| Tabs, labels, buttons, policy text | Feasible with basic Frame/Button/FontString primitives. | Prefer addon-owned frames; verify templates, fonts, focus, escape handling, scale, and combat behavior live. |
| Chance/cooldown/quota sliders | Feasible with Slider plus numeric labels. | Verify `SetMinMaxValues`, step/obey-step behavior, mouse wheel, keyboard access, and templates. Store integer values only. |
| Scrollable reaction library | Feasible with a basic ScrollFrame and recycled or bounded rows. | Do not assume modern ScrollBox mixins. Start with documented/basic scrolling; test large catalogues and resize/scale. |
| Searchable emote selector | Feasible with EditBox filtering an in-memory token catalogue and a scrollable list. | Do not filter on each rendered frame; debounce or filter on text changes. Verify text APIs, Unicode/localized matching, and focus restrictions. |
| Multiline reaction text | Likely feasible with EditBox. | Verify multiline input, UTF-8 limits, cursor/focus, paste, and secret-text restrictions in Forever. |
| Standard settings-panel integration | Unresolved. | Audit the exact Forever Settings API before choosing native registration. An addon-owned window opened by `/rph` is the safe fallback. |

No proposed editor operation needs secure action buttons or target manipulation.
Creating ordinary non-secure UI should be independent of combat actions, but
frame creation/showing, focus, and text behavior still require in-client checks.

## Slider and list behavior

The specified integer ranges are modest and technically straightforward:

- chance: 0–20;
- cooldown: 5–120;
- enabled quota: 1–10;
- event chance: 0–100.

Each slider should render an exact numeric label and normalize saved/input values
through the same validator. The UI must not write continuously if dragging would
cause excessive SavedVariables churn; updating the in-memory explicit value on
confirmed changes is sufficient because WoW persists at its normal lifecycle.

The library size is manageable, but a scroll view should avoid constructing a
new complex row on every scroll action. A simple recycled-row list is adequate;
no general UI framework is justified for V1.0.

Search can be a lowercased substring match over precomputed localized labels and
canonical tokens. Locale-aware case folding and token availability require live
verification. Search state need not persist.

## Blizzard emote catalogue and targeting

The standard-emote path is distinct from custom `/e` output. The
[DoEmote reference](https://warcraft.wiki.gg/wiki/API_DoEmote) documents a token
argument and says omitting the optional unit uses the current target. Current
RPHelper already calls `DoEmote(token)` with no explicit unit, which preserves
ordinary targeting behavior.

Blizzard chat-frame source builds emote lookup data from globals such as
`MAXEMOTEINDEX`, `EMOTE<n>_TOKEN`, and localized `EMOTE<n>_CMD<m>` strings. Its
[token-import implementation](https://github.com/Gethe/wow-ui-source/blob/live/Interface/AddOns/Blizzard_ChatFrameBase/Shared/ChatFrameUtil.lua)
is useful evidence for generating a localized searchable catalogue without
hard-coding English slash commands. Current mainline source uses
`C_ChatInfo.PerformEmote`, while RPHelper uses the legacy global `DoEmote`; the
correct Forever call and return behavior must be verified rather than inferred
from Retail.

The final catalogue must be captured and tested in the supported Forever build:

1. Confirm the available token/count globals or another documented enumeration.
2. Record canonical token, localized display command/name, faction/race
   restrictions, and whether the token produces text, animation, both, or a
   restricted/unrecognized result.
3. Verify invocation from ordinary addon code, throttling, and behavior in world,
   dungeon, raid, combat, dead, shapeshifted, and targeted/untargeted contexts.
4. Confirm omitting the unit preserves the game's target behavior, including NPC
   quirks, without RPHelper changing target.
5. Exclude unsupported or restricted tokens from the selectable list, or label
   them only if failure behavior is safe and clear.
6. Repeat after relevant Forever client updates; a Retail-era static list is not
   authoritative.

Preview must not execute the emote. It should show its localized label/token and
a local textual sample only.

## Runtime and schema-v2 interactions

The UI design uses the following implemented runtime data and behavior:

- global `reactionChance` baseline;
- optional per-event chance replacing that baseline;
- event priority;
- enable/disable encounter quota separately from its retained value;
- individual built-in/custom weights and weighted choice;
- activation state for Custom reactions;
- per-built-in weight storage keyed by permanent ID.
- per-character dungeon Say routing (`broadcast` or `local`).

Schema v2 uses sparse character fields plus
`reactionOverrides[permanentID].weight`; Built-in activation continues to use
`disabledDefaults`, while Custom activation/weight live on each custom record.
All UI reads/writes must go through shared validation/resolution APIs and retain
schema-v2 sparse-default behavior and V1.0-onward update guarantees.

### Implemented runtime transition

| Area | Retired development behavior | Implemented V1.0 behavior | Release treatment |
| --- | --- | --- | --- |
| Baseline chance | Per-trigger defaults vary and a preset multiplies them. | Global 5%, replaced by optional event override. | Do not import v1 settings. Fresh schema v2 inherits 5% until the player writes an override. |
| Cooldown | Global default 10 seconds plus per-trigger cooldowns. | One global cooldown, default 20; priority bypasses only it. | Do not import v1 cooldowns. Schema v2 contains no event/reaction cooldown fields. |
| Encounter quota | Active by default at 2. | Disabled by default; retained value 2 when enabled. | Do not import v1 quota state. Fresh schema v2 inherits disabled/value 2 without materializing overrides. |
| Raid policy | `enableInRaids` can be true. | Unconditional pre-pipeline suppression. | Do not carry the development toggle into schema v2. No release setting can override policy. |
| Druid speech | Suppression can be false. | Unconditional Say filtering while shapeshifted. | Do not carry the development toggle into schema v2. Apply policy to Built-in and Custom Say candidates. |
| Selection | Uniform among eligible candidates. | Integer reaction weights from 1 through 10. | Weighted selection runs after eligibility without changing chance, routing, cooldown, or quota order. |
| Priority | No priority behavior existed. | Bypasses global cooldown only and never modifies its timer. | Implemented at the cooldown gate; it still obeys quota, enabled state, chance, eligibility, routing, and final safety. No queue exists. |
| Dungeon Say | Dungeon Say always broadcast. | Per-character broadcast default or local-only. | Sparse `dungeonSayMode`; a fresh absent value inherits `broadcast`. This affects Say only. |

These runtime dependencies are implemented and tested. Main settings and the
Library/editor bind through existing shared APIs rather than duplicating policy
logic.

### Policy preservation

- Raid events are rejected before pipeline entry.
- Quota and cooldown/priority checks precede event enabled and chance checks.
- Disabled events/reactions are rejected before selection.
- Druid suppression remains part of candidate preparation.
- Output adapters retain final safety checks after selection.
- Effective event chance is rolled before any candidate pool is built or filtered.
- Eligible candidates are selected with integer weights from 1 through 10, default 1.
- Environmental routing is owned by the output layer; do not add redundant
  activity checks inside the normal pipeline.
- Failed preview, ineligible candidates, and failed dispatch consume no runtime
  cooldown or quota.
- Encounter quota, when enabled, counts all successful automatic reactions,
  including priority, and resets at new-encounter start.
- Only successful non-priority output starts/resets global cooldown. Priority
  output leaves the timer unchanged.
- Standard emote selection does not authorize target inspection/manipulation.
- UI availability must not imply an event detector exists. Unsupported events
  need an explicit “not currently detected” state or must be hidden.

## Donation-link policy

Blizzard's published
[UI Add-On Development Policy](https://us.forums.blizzard.com/en/wow/t/ui-add-on-development-policy/24534)
states that addons must be free, may not solicit donations, and that donation
requests should be limited to the addon website or distribution site rather than
appearing in game. That is verified general WoW policy evidence.

The requested in-game Ko-fi link is therefore not cleared merely by labeling it
“pending policy verification.” A direct in-game donation link is reasonably
likely to be treated as solicitation. The repository README may link externally,
but the in-game About tab should omit the Ko-fi row unless Blizzard/Forever policy
owners provide affirmative, current clarification for this client and exact
presentation. The addon must remain fully free with no paid features or services.

Unresolved questions:

- whether WoW Forever publishes a product-specific addon policy that modifies or
  incorporates the general policy;
- whether a non-clickable creator-support reference is treated differently from
  a donation request;
- whether external hyperlinks can or should be made interactive in this client.

Until resolved, the specification records the desired URL for editorial planning
but blocks it from release UI.

## Other live-verification requirements

- Exact Settings API or addon-compartment availability and registration.
- Supported frame templates, backdrops, scroll helpers, and widget method names.
- UI behavior at supported resolutions, scales, locales, and accessibility input.
- Combat lockdown/taint effects when opening, closing, focusing, or rebuilding UI.
- SavedVariables persistence after `/reload`, logout/login, fresh V1.0 install,
  and a later supported release update.
- UTF-8 entry/search behavior and maximum safe text sizes.
- Local preview rendering and guarantee that no public output API is called.
- Final emote catalogue, call path, restrictions, targeting, and throttle behavior.
- Whether external links can be selected/copied safely without protected actions.

## Feasibility conclusion

The implemented milestones confirm that the addon-owned window, navigation,
checkboxes, sliders, routing selection, and bounded library rows can use ordinary
frame/widget primitives. Mocked tests do not replace Forever-client verification
of templates, widget behavior, scale, input, and combat safety. Editor and search
work remains subject to catalogue, input, policy, and live-client checks above.
The current Emote editor deliberately limits selection to tokens already present
in shipped content until the complete Forever catalogue is verified. Approved
schema-v2 priority, raid, Druid, and dungeon-routing semantics are no longer open
questions.
