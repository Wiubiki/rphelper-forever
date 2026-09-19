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

Ability-specific RP may be requested explicitly from a player macro, for example:

```
#showtooltip Rebirth
/cast [@mouseover,help,dead] Rebirth
/rph spell rebirth
```

Exact WoW Forever behaviour, especially /say behaviour and spell success/failure semantics, must be tested before V1 is declared stable.

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
