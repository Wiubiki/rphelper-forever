# SavedVariables Architecture

## Status

Schema version 2 is implemented as the **initial supported V1.0 release
schema**. No released installation used the earlier development schema, so V1.0
has no v1-to-v2 compatibility requirement.

Schema version 2 remains per-character. It uses sparse explicit overrides,
permanent authored built-in IDs, and future versioned migrations. There is
no account database, profile system, import/export, or character-to-character
sharing in V1.0 or the immediate roadmap.

## Ownership and separation

`RPHelperDB` remains the only SavedVariable and is declared per character.
Settings, built-in exclusions, and custom entries belong to that character.
Shipped defaults and content remain immutable addon data. SavedVariables store
only player-owned choices: explicit setting overrides, custom entries, disabled
built-in IDs, and schema-version metadata.

Opt-in runtime diagnostics are deliberately outside this database. Their enabled
state, sequence counter, and bounded records are session-only, start disabled and
empty on addon initialization, and are never materialized in `RPHelperDB`.

Runtime content remains:

```text
current shipped content + character custom entries - disabled shipped entries
```

Custom entries use the same preparation and runtime policies as built-ins. This
work must not alter Druid speech suppression, activity routing,
probability/frequency, cooldowns, encounter quotas, or successful-dispatch-only
state consumption.

## Approved schema version 2

```lua
RPHelperDB = {
    schemaVersion = 2,
    settings = {
        -- reactionChance = 0.05,
        -- globalCooldown = 20,
        -- encounterQuotaEnabled = false,
        -- maxAutomaticOutputsPerCombat = 2,
        -- dungeonSayMode = "local",
    },  -- sparse explicit choices only
    triggers = {
        -- dodge = { enabled = false, chance = 0.05, priority = true }
    },
    abilities = {
        -- PALADIN = { FLASH_OF_LIGHT = { chance = 0.03, priority = false } }
    },
    custom = {
        nextID = 1,
        entries = {
            -- ["custom:1"] = {
            --     scope = { layer = "generic", trigger = "dodge" },
            --     entry = { type = "say", text = "Too slow!" },
            --     sourceDefaultID = "default:generic:dodge:0007",
            -- }
        },
    },
    disabledDefaults = {
        -- ["default:generic:dodge:0007"] = true,
    },
    reactionOverrides = {
        -- ["default:generic:dodge:0007"] = { weight = 2 },
    },
}
```

The existing top-level names are retained; no profiles or `overrides` wrapper is
needed.

## Sparse override resolution

Every setting leaf resolves independently:

```text
valid explicit RPHelperDB value -> current shipped default
```

A missing leaf means untouched. A valid saved value is explicit even when it is
`false`, `0`, or equal to the current default. Invalid values are preserved for
recovery but ignored when resolving the effective value.

The UI writes a leaf only after an explicit player change. “Reset to default”
deletes that leaf and prunes empty parents; it never copies the current default.
Initialization creates required structural containers but does not populate
`settings`, `triggers`, or `abilities` from shipped defaults. Runtime, commands,
and UI must use one validated resolver.

The approved V1.0 UI adds a global reaction-chance baseline, an independent
encounter-quota toggle, event priority, Custom activation state, and individual
reaction weights. Built-in weights use sparse `reactionOverrides` records keyed
by permanent built-in ID; Built-in activation continues to use
`disabledDefaults`. Custom activation and weight are metadata on the custom
record. The shipped `dungeonSayMode` default is `"broadcast"`; only a character
choosing local dungeon Say output stores `"local"`. Raid suppression and Druid
Say suppression are unconditional runtime policies and are not schema-v2 settings.
See [V1.0 UI/UX Specification](ui_ux_spec.md).

Schema-v2 shipped defaults and semantics are:

- global reaction chance `0.05`; a sparse event chance replaces rather than
  multiplies it;
- global cooldown `20` seconds; there are no event/reaction cooldowns;
- encounter quota disabled, with retained value `2` and enabled range 1–10;
- priority stored per event and bypassing only the global cooldown;
- reaction weight `1`, overridden only by integers from 1 through 10;
- dungeon Say mode `"broadcast"`, with optional per-character `"local"`.

Only successful emission increments enabled quota. Only successful non-priority
emission starts/resets cooldown; priority emission leaves the timer unchanged.
Quota resets at the beginning of an encounter. All failures consume neither.

## Initial release and future migrations

V1.0 starts directly with schema version 2:

1. A fresh installation creates the v2 root and structural containers only.
2. It does not copy shipped setting, event, ability, or reaction defaults into
   SavedVariables.
3. Missing values resolve to current shipped defaults through the shared
   resolver.
4. A player action writes only the corresponding sparse explicit override.
5. Reset deletes that override and resumes following shipped defaults.
6. Unreleased schema-v1 development data, legacy-addon settings, and generated
   development IDs are not imported, converted, or supported by release code.

Approved legacy **content** may be reviewed and shipped in the immutable built-in
catalogue with contributor attribution. That content lineage does not make old
addon settings or unreleased development SavedVariables part of the V1.0 data
contract.

From V1.0 onward, every supported persisted schema change must migrate
sequentially and idempotently. Explicit player settings, custom entries,
exclusions, weights, permanent IDs, and unknown fields must survive supported
updates. A future migration advances `schemaVersion` only after success; a newer
unsupported version is never mutated or downgraded. Migration failure must not
silently wipe recoverable release data.

## Permanent built-in IDs

V1.0 ships explicit authored IDs from its first supported release:

```lua
{ id = "default:generic:dodge:0007", type = "say", text = "Too slow!" }
{ id = "default:generic:dodge:0008", type = "say", text = "Too slow!" }
```

An ID identifies a conceptual entry rather than its text. Normal text,
punctuation, template-choice, type, and registration-order revisions retain the
ID when the concept remains the same. Exact duplicates receive distinct authored
IDs. IDs are repository-wide unique, never reused, and never derived from hashes,
normalized text, array positions, or duplicate occurrence counts. A genuinely
new or repurposed entry receives a new ID.

Moving semantic scope normally creates a new ID unless a future supported
release migration deliberately preserves it. Exclusions for removed release IDs
remain stored harmlessly for downgrade or later reintroduction. V1.0 needs no
alias map for unreleased content-derived development IDs.

## Custom-content persistence

V1.0 includes basic create, edit, delete, and preview for current supported
scopes (`generic`, `race`, `class`, `ability`, and `druidForm`) and types (`say`,
`emote`, and `customemote`). The monotonic `custom:N` IDs and `custom.nextID`
remain character-specific.

- Editing retains the custom ID; deletion does not reuse IDs while the counter
  remains valid.
- Unsupported or malformed records remain stored but are ineligible.
- CRUD uses the management API, preserves promised unknown fields, invalidates
  its index, and never mutates shipped catalogue tables.
- Adding ability content does not add detection or a spell mapping.
- A modified built-in copy may store `sourceDefaultID` as UI provenance. Creating
  or editing the copy never changes the source activation, weight, or content.
- Custom records may store sparse `enabled` metadata and integer `weight` values
  from 1 through 10. Built-in weights live under `reactionOverrides` so shipped entries
  remain immutable.
- Modified-copy cancellation creates nothing; a successful save allocates one
  monotonic Custom ID and leaves all Built-in preferences unchanged.
- Preview uses ordinary template, keyword, and Druid eligibility preparation but
  is local-only. It never dispatches output, applies probability, records
  cooldowns, or consumes encounter quota.

## Required verification

### Sparse settings

- Fresh v2 initialization stores no shipped leaves.
- Missing leaves resolve to current defaults.
- Explicit false, zero, boundary, and default-equal values remain explicit.
- Invalid values remain stored and resolve to defaults.
- Changed defaults affect untouched fields only.
- Reset deletes one leaf, prunes parents, and exposes the default.
- Runtime, commands, and UI report identical effective values.
- Absent v2 fields resolve to 5% chance, 20-second cooldown, quota disabled/value
  2, weight 1, and dungeon broadcast.
- An event chance replaces rather than multiplies global chance.
- No event/reaction cooldown setting exists or affects resolution.

### Initial release and future migrations

- A fresh installation creates schema v2 structural containers with no setting
  or reaction overrides.
- Unreleased schema-v1 and legacy-addon settings are not imported or interpreted.
- Explicit schema-v2 settings, custom content, exclusions, weights, counters, and
  unknown fields survive simulated V1.0-to-later supported updates.
- Future migration success is idempotent and advances the version atomically.
- Future migration failure and newer-version cases are non-destructive.
- Reset removes only the selected explicit override.

### Built-in identities

- Every shipped entry has a nonblank, repository-unique authored ID.
- IDs survive appropriate content and registration-order revisions.
- Exact duplicates retain distinct IDs across reordering or sibling deletion.
- Deleted IDs are not reused.
- No release compatibility table exists for unreleased generated IDs.

### Custom content and regression

- CRUD/reload covers every supported scope and type.
- Modified-copy success and injected failures prove atomic rollback.
- Preview uses normal preparation without output or runtime-state mutation.
- Raid events never enter the normal pipeline.
- Quota exhaustion precedes cooldown/priority; priority bypasses only cooldown.
- Priority success increments quota without changing the cooldown timestamp;
  non-priority success starts/resets it; every failure changes neither.
- Chance failure is proven not to construct/filter a reaction pool.
- Druid filtering removes Built-in and Custom Say reactions while retaining
  Emote and Custom Emote candidates; final output safeguards still run.
- Weighted selection covers weights 1 and 10, disabled/ineligible entries,
  deterministic boundaries, and every malformed/out-of-range saved weight.
- Dungeon Say broadcast/local routing changes Say only.
- Existing routing, Druid suppression, probability/frequency, cooldown, quota,
  out-of-combat, and dispatch-accounting tests remain green.
- Live Forever tests cover character isolation, `/reload`, logout/login, a fresh
  V1.0 installation, exclusions, custom CRUD, and local preview persistence.
