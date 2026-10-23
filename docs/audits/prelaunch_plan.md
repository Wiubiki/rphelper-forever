# Pre-launch Development Plan

> **Status note — 2026-10-23:** Superseded planning snapshot. Most repository-side
> implementation items below are complete for the v0.9 prerelease, while the
> client-verification items remain relevant. Current status and validation gates
> are tracked in the [runtime integration audit](runtime_integration_audit.md).

## Can be completed now

- Repository structure and development conventions
- Product specification
- Trigger catalogue
- Content inheritance rules
- SavedVariables schema
- Migration framework
- Slash-command parser
- Content registry and selection logic
- Anti-spam policy and pure logic
- UI wireframe / configuration shell
- Generic content catalogue
- Race-specific content catalogue
- Class-specific content catalogue
- Issue templates and contribution guidance
- Packaging/release checklist

## Must be verified in WoW Forever

- Available event signals
- Combat-result observability
- Secret-value restrictions
- `/say` from addon slash commands invoked through macros
- Ability macro + RPHelper behaviour
- Spell success/failure timing
- Outdoor versus instanced chat restrictions
- Exact spell IDs and new/changed ability names
- New races/classes/combinations
- TOC/interface version and packaging details

## First technical spikes when client access is available

1. `/rph test` -> `/say` from typed command and macro button.
2. `/cast` + `/rph spell <ability>` in one macro.
3. Passive crit/dodge/parry/block event detection.
4. Instance versus outdoor behaviour.
5. Secure-action restrictions and failure cases.
