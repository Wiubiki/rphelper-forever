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

Runtime content is assembled in this order:

1. Generic
2. Race
3. Class
4. Race + class, if present
5. Ability-specific
6. User custom content

A layer may:
- add to a lower-priority pool;
- replace it;
- suppress the trigger.

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
