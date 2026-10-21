# RPHelper V1 Product Specification

## Purpose

RPHelper adds occasional contextual sayings and emotes in response to character actions and game events. The addon should make an RP character feel more expressive without turning combat chat into a running combat log.

## V1 principles

1. Flavour, not spam.
2. User data must survive addon updates.
3. Shipped defaults and user-authored content are separate layers.
4. Generic content provides coverage; race/class/ability content adds or replaces flavour.
5. Game-version-dependent event handling is isolated from content and settings.
6. Any behaviour that depends on WoW Forever restrictions must remain explicitly testable until verified in-game.
7. Lightweight detection and unobtrusive output take priority over exhaustive combat accuracy or trigger coverage.

## Detection philosophy

RPHelper is a roleplaying flavour addon, not a combat analysis or reporting addon. Detection should be sufficiently reliable to support occasional contextual reactions, with low processing overhead and low public chat volume.

React to relevant game events rather than continuously polling game state. Reject irrelevant events, unknown ability identifiers and disabled triggers before content selection or other expensive work. Maintain only the state needed for detection and runtime policies; combat-log reconstruction, combat histories, damage records, target correlations and elaborate casting state machines are outside V1's detection scope.

For an ability-use reaction, a safely readable, player-attributed `UNIT_SPELLCAST_SUCCEEDED` notification is sufficient once its behaviour is verified for the supported ability. Detection does not need to establish whether the spell subsequently hit, healed or applied its effect. Missing a reaction, or occasionally reacting to a successful cast whose attack later misses, is acceptable. This tolerance concerns the eventual outcome; it does not justify unsafe payload inspection, speculative player attribution or content claiming an outcome that detection cannot establish.

When detection is uncertain, prefer a simple conservative implementation, or defer the trigger, over a complex approximation. A trigger that requires substantial combat parsing merely to produce an occasional emote does not belong in V1. Existing API restrictions, content eligibility checks and Druid-form safeguards still apply.

Ordinary addon event processing does not inherently generate network traffic. Its main costs are CPU and memory; actual public chat messages also create server traffic and affect other players. Optimise for avoiding unnecessary processing and excessive public output, rather than an assumed API-related ping cost.

## Output behaviour by context

RPHelper distinguishes between custom emotes, spoken sayings, and local-only sayings.

### Open world

Default:
- Custom emotes: enabled
- Local sayings: enabled
- Party-channel sayings: disabled
- Automated /say: not used

Local sayings are displayed only to the player through RPHelper's UI and are not transmitted to a WoW chat channel.

An optional setting may allow sayings to be redirected to party chat while grouped.

### 5-player instances

Default:
- Custom emotes: enabled
- /say sayings: enabled

This represents RPHelper's full immersive behaviour where automated /say is permitted.

### Raids

Default:
- RPHelper output: disabled

Raids are communication-heavy environments and RPHelper should not add unsolicited chat or emote traffic unless explicitly enabled by the user.

## Trigger families

### Passive event triggers

Candidates for V1, subject to API verification:
- Enter combat
- Leave combat
- Offensive critical hit (`youcrit`: melee, ranged, or damaging spell; not healing)
- Dodge
- Parry
- Block
- Player death
- Resurrection
- Level up
- Killing blow

### Active macro triggers

Ability-specific RP triggered through player macros is deferred beyond V1.

Earlier designs considered macros such as:

```text
#showtooltip Rebirth
/cast [@mouseover,help,dead] Rebirth
/rph spell rebirth
```

as a way to associate player-initiated abilities with RP sayings while retaining a hardware-event context.

For V1, RPHelper will instead prioritise automatic trigger detection where available and route sayings according to activity context:

- open world -> local sayings
- 5-player instances -> `/say`
- raids -> disabled by default

Macro-triggered ability RP may be revisited in a later release where it provides useful behaviour that cannot be achieved reliably through normal event detection.

## Content resolution

The content engine's keyword contract, candidate eligibility rules, future template model, and reactive-trigger semantics are specified in [Content Engine](content_engine.md).

Runtime content follows this character-content hierarchy, from lowest to highest priority:

1. Generic
2. Race
3. Class
4. Exceptional race + class combination, if authored
5. User custom content

Personality may become a future layer, but is not part of V1. Ability-specific content may further refine the pool for an ability trigger without changing the character-content hierarchy above.

Race/class combination files are exceptions, not a matrix to complete. Do not create a file for every valid pairing. A dedicated combination is appropriate only when the interaction needs additions, replacements, or suppression that neither layer expresses well on its own. Forsaken/Undead Paladin is the primary example: it may require dedicated lines, replacement of normal Paladin lines, or suppression of class content that does not fit that combination.

Missing race content is valid. Unsupported or unauthored races fall back gracefully to Generic + Class content; empty placeholder race files are not required. Skyborne-specific authored content is explicitly out of scope for V1. Skyborne characters still receive Generic + Class content and user custom content, and future community contributions may add a Skyborne race layer.

A layer may:
- add to a lower-priority pool;
- replace it;
- suppress the trigger.

Content entries should eventually have stable identifiers so a higher layer or user setting can suppress or replace a specific inherited entry without matching its display text. The identifier system is not required for the initial content migration and should be designed before runtime implementation.

## English content migration

Existing `RPhelper_twow` English content is source material, not a catalogue to copy unchanged:

- `ANY.lua` maps to the Generic layer.
- Race files map to the Race layer.
- Class files map to the Class layer.
- Exceptional material may move to a race/class combination layer.
- Every candidate line should be reviewed and may be kept, rewritten, dropped, moved to a combination layer, or reserved for a possible future Personality layer.

## V1 localization policy

The V1 UI and bundled default content are English-only. Users may author
reactions in any language supported by their WoW client, and community-authored
language-specific content is welcome. Canonical ability identifiers must remain
stable and must not depend on localized display names.

A lightweight contribution mechanism may be supported in V1 if it fits the
existing architecture with minimal effort. Full UI localization, translation
management and comprehensive language-pack infrastructure are outside V1 scope.
UTF-8 compatibility for authored content should be verified where appropriate.

## Output routing

Trigger detection and content selection must be independent from output routing.

A selected entry may be routed according to context:

- `say` -> real /say, local display, optional party chat, or suppressed
- `customemote` -> /e when enabled
- `emote` -> Blizzard built-in emote where permitted/enabled

The content catalogue must not hard-code the destination channel.

## Anti-spam

V1 should support:
- Global cooldown
- Per-trigger cooldown
- Trigger chance/frequency
- Maximum automatic outputs per combat encounter

Defaults should be conservative.

### Implemented minimal runtime policy

The current runtime detects combat entry/exit and player defensive DODGE, PARRY,
and direct BLOCK feedback through `UNIT_COMBAT`. Defensive detection requires
readable unit/action fields and an active runtime encounter; live Forever
verification remains pending (see [Combat trigger API audit](combat_trigger_api_audit.md)).
It evaluates each
supported trigger in this order:

1. Check master and individual trigger enabled settings, then activity permission.
2. Read monotonic time; check global cooldown, per-trigger cooldown, and encounter quota.
3. Apply the trigger probability multiplied by the frequency preset.
4. Prepare and select eligible content using the existing keyword and Druid-form safeguards.
5. Route and dispatch the selected candidate.
6. Record cooldown timestamps and increment the encounter count only on successful dispatch.

Frequency presets are `low` (0.5×), `normal` (1×), and `high` (2×). They multiply
probability only, capped at 1; they do not shorten cooldowns or raise quotas.
Existing default probabilities remain unchanged (combat entry 0.20, exit 0.15).
A uniform roll in [0, 1) succeeds strictly below the effective probability;
zero always rejects and one always passes without drawing a roll.

Cooldowns use seconds and allow output at the exact expiry boundary. Both global
and per-trigger cooldowns must expire. Defaults remain 10 seconds globally,
30 seconds for each combat transition, and two automatic outputs per encounter.
Zero cooldown permits immediate reuse; zero quota prevents all encounter output.
All successfully dispatched types, including local sayings, count equally.

An encounter begins before the entry reaction and ends after the exit reaction,
so both share its quota. Duplicate combat events neither emit nor reset the
counter. Initialization while already in combat starts an empty session quota
without inventing an entry reaction. Exit clears the counter, and the next entry
starts a new encounter. Cooldowns persist across encounters but are session-only;
reloading resets cooldowns and quota. Disabled or suppressed reactions still
update encounter state.

Outside an encounter, trigger attempts obey the same enabled, activity,
probability, and cooldown policies, but neither check nor consume the combat
quota (even when it is zero). They still record successful output cooldowns.
Defensive triggers are accepted only during an active encounter, including direct
trigger attempts. Supported ability activations may also react outside combat.

### Implemented first ability increment

`UNIT_SPELLCAST_SUCCEEDED` is the sole ability-activation signal. The adapter
requires an exact readable `player` unit, a readable positive integer spell ID
and a readable player class. Missing/failing secret inspection rejects detection;
unused GUID and cast-bar fields are ignored. Registration failure disables only
ability detection. No cast-start notification or combat-outcome check is required.

Only Paladin Flash of Light (`19750`) and Seal of Righteousness (`20288`) are
mapped, based on attributable third-party Forever observations. Other ranks and
variants are not inferred. See the [spellcasting audit](spell_casting_api_audit.md#6-first-runtime-increment)
for evidence and pending live checks; this is not RPHelper live verification.

Each mapped ability defaults to enabled, 3% chance and a 30-second cooldown.
Individual overrides live at `RPHelperDB.abilities[class][canonicalAbility]`,
with `enabled`, `chance` and `cooldown` fields. Missing/malformed values use
these defaults without overwriting recoverable data. There is no ability settings
editor in this increment.

Ability reactions use existing ability-content preparation, keyword eligibility
and Druid speech suppression. They share the master switch, frequency multiplier,
global cooldown, activity routing and combat encounter quota with generic
reactions; ability cooldowns are distinct. Only successful dispatch spends
cooldowns/quota. Outside combat, no encounter quota applies. Target context is
not guessed.

Channels, form transitions, passive procs, auto-attacks, queued melee exceptions,
empower/reticle behaviour and pets remain unsupported. No pending-cast state or
duplicate suppression is introduced; duplicate delivery remains a live-validation
question. Generic combat reactions retain their existing semantics.

Open-world sayings use a prefixed `[RPHelper]` message in the player's existing
chat display via `AddMessage`; no chat message is transmitted. Dungeon sayings
use `SAY`. Custom emotes use `EMOTE`; built-in emotes use `DoEmote`.
The additive boolean setting `enableInRaids` defaults to false. When explicitly
enabled, raid sayings remain local and both emote types are permitted.
Unknown, inconsistent, or unsupported activity contexts suppress all output.
Missing local display never falls back to public chat. Optional party redirection
is not implemented.

Runtime settings are validated without rewriting saved values. Missing or invalid
values fall back to shipped defaults: toggles must be booleans, probabilities
finite numbers in [0, 1], cooldowns finite nonnegative numbers, quotas finite
nonnegative integers, and presets one of the three names above. Database startup
preserves malformed existing containers and skips default merging into them.
No schema version change or migration is introduced.
`/rph status` reports the effective enabled value, falling back to the default
for invalid saved values. `/rph on` and `/rph off` update a valid settings table;
if the root or settings container is malformed, they report that the setting
cannot be saved and preserve the existing data.

The injected runtime API supplies `GetTime()` (finite, nonnegative monotonic
seconds), `Random()` (probability rolls), and `RandomIndex(size)` (content/template
selection). Missing, failing, invalid, or backward-moving clock readings suppress
output; invalid probability rolls suppress that attempt. Class detection failure
also suppresses output to avoid bypassing Druid speech restrictions.


## User-facing configuration

V1 target:
- Enable/disable RPHelper
- Frequency preset
- Trigger toggles
- Per-trigger advanced chance/cooldown
- Activity suppression where practical
- Preview generated content
- SavedVariables persistence
- Basic create/edit/delete for supported custom content

### Approved SavedVariables ownership and update policy

`RPHelperDB` is the sole SavedVariable and remains per-character. All settings,
built-in exclusions, and custom content belong to that character. V1.0 and the
immediate roadmap do not include account-wide settings, profiles, import/export,
or character-to-character sharing.

Shipped content is immutable. Players may disable a shipped entry or create a
modified custom copy. Untouched settings follow current shipped defaults, while
explicit player choices survive addon updates. Milestone 2B approves sparse
explicit overrides, sequential migration from current schema version 1, and
permanent authored built-in IDs for schema version 2. Schema v2 is not yet
implemented; see [SavedVariables Architecture](savedvariables_architecture.md).

## Explicitly deferred

- Personality packs
- TRP3/MRP integration
- Full UI localization, translation management and comprehensive language packs
- Spec-specific content packs
- Advanced content-management features beyond basic create/edit/delete/preview
- Local speech-bubble display for sayings (Investigate as a post-V1 alternative to the local sayings feed, not as a replacement.)
- Player-macro-triggered ability sayings

## Implemented user-content persistence

User-authored generic, race, class, ability and Druid-form entries now participate
in the ordinary content and runtime policy path. Shipped entries have stable
content-derived identities and can be individually disabled without editing the
catalogue. Per-character SavedVariables preserve custom content, exclusions,
settings and unknown fields through repeated initialization and normal code
updates; malformed containers are retained rather than reset. Editing shipped
text creates a new identity, and exact duplicate groups have documented occurrence
limits. The internal management API is implemented; graphical editing is not.
Basic create/edit/delete/preview is approved for V1.0. See
[User content runtime](user_content_runtime.md) for current schema-v1 storage,
validation, identity rules, API errors and guarantees, and
[SavedVariables Architecture](savedvariables_architecture.md) for the approved
but unimplemented schema-v2 design. Live Forever persistence/output verification
remains pending.
