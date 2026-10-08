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
- Melee critical hit
- Spell critical hit
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

## User-facing configuration

V1 target:
- Enable/disable RPHelper
- Frequency preset
- Trigger toggles
- Per-trigger advanced chance/cooldown
- Activity suppression where practical
- Preview generated content
- SavedVariables persistence

## Explicitly deferred

- Personality packs
- TRP3/MRP integration
- Localization beyond English
- Complex profile sharing
- Spec-specific content packs
- Full in-game content editor unless implementation proves small and robust
- Local speech-bubble display for sayings (Investigate as a post-V1 alternative to the local sayings feed, not as a replacement.)
- Player-macro-triggered ability sayings
