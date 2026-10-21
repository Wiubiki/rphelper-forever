# SavedVariables Architecture

## Status

Milestone 2B approves the schema described here, but it is **not yet implemented**.
Production currently uses per-character `RPHelperDB` schema version 1, which
materializes missing shipped defaults and generates content-derived built-in IDs.
See [User content and persistence runtime](user_content_runtime.md) for exact
schema-v1 behavior.

Approved schema version 2 remains per-character. It adds sparse explicit
overrides, permanent authored built-in IDs, and sequential migrations. There is
no account database, profile system, import/export, or character-to-character
sharing in V1.0 or the immediate roadmap.

## Ownership and separation

`RPHelperDB` remains the only SavedVariable and is declared per character.
Settings, built-in exclusions, and custom entries belong to that character.
Shipped defaults and content remain immutable addon data. SavedVariables store
only player-owned choices: explicit setting overrides, custom entries, disabled
built-in IDs, and migration/version metadata.

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
    settings = {},  -- sparse explicit choices only
    triggers = {
        -- dodge = { enabled = false, chance = 0.05 }
    },
    abilities = {
        -- PALADIN = { FLASH_OF_LIGHT = { cooldown = 45 } }
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

## Migration from schema version 1

Schema v1 materializes missing defaults and stores no provenance indicating
whether a value was inserted by initialization or chosen by the player. Those
cases cannot be distinguished losslessly.

The v1-to-v2 migration therefore preserves every existing valid setting,
trigger, and ability leaf as an explicit v2 override, including values equal to
the old default. A migrated character retains materialized v1 values until the
player resets them; new v2 characters are sparse immediately.

Migration rules:

1. An absent database becomes a v2 root with structural containers only.
2. A non-table root is preserved; writes are disabled and safe defaults are used.
3. A missing version may be treated as v1 only when its shape is recognizable;
   ambiguous data is preserved and fails safely.
4. Existing valid leaves remain in place. Migration inserts no shipped leaves.
5. Custom records and IDs, `nextID`, exclusions, unknown fields, and malformed or
   future records are preserved.
6. Approved ability-key and built-in-ID changes run as explicit, idempotent steps.
7. `schemaVersion` advances only after the required step succeeds.
8. A newer-than-supported version is not mutated or downgraded.
9. Later changes migrate sequentially (`1 -> 2`, then `2 -> 3`).

Migration failure must never wipe or normalize recoverable data. V1.0 does not
add import/export; recovery uses non-destructive failure, diagnostics, granular
reset actions, and ordinary external SavedVariables backups.

## Permanent built-in IDs

Schema v1 derives `default:v1:` IDs from scope, exact content, and an occurrence
suffix. Wording changes therefore change identity, and identical duplicates can
exchange occurrence identities. Schema v2 replaces these with explicit authored
IDs:

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

Moving semantic scope normally creates a new ID unless a reviewed migration
preserves it. Exclusions for removed IDs remain stored harmlessly for downgrade
or later reintroduction.

## Legacy built-in ID aliases

The authored-ID cutover includes a reviewed alias map:

```lua
legacyDefaultIDAliases = {
    ["default:v1:..."] = { "default:generic:dodge:0007" },
}
```

If a legacy ID is disabled, all mapped successors become disabled. For
many-to-one consolidation, the successor is disabled if any predecessor was
disabled. Old exclusion keys remain stored, and unmapped obsolete keys remain
untouched and ineffective. Aliases are maintainer-authored; migration never
fuzzy-matches text. Exact duplicate groups require manual review because legacy
occurrence IDs do not carry intrinsic authorship.

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
- A modified built-in copy may store `sourceDefaultID` as UI provenance. Runtime
  still uses addition plus exclusion, not a separate override engine.
- Creating a modified copy and disabling its source is one logical operation;
  failure of either write rolls back the other.
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

### Migration

- Fully materialized and partial v1 fixtures preserve every existing valid leaf
  without adding defaults.
- Custom data, counters, exclusions, false/zero values, unknown fields, and
  malformed/future records are preserved as specified.
- Missing, malformed, ambiguous, failed, repeated, and newer-version cases are
  non-destructive and version advancement is atomic.
- Every approved canonical rename has conflict, malformed, and repeated-run tests.

### Built-in identities

- Every shipped entry has a nonblank, repository-unique authored ID.
- IDs survive appropriate content and registration-order revisions.
- Exact duplicates retain distinct IDs across reordering or sibling deletion.
- Deleted IDs are not reused.
- The cutover alias map covers every shipped legacy ID.
- One-to-one, one-to-many, many-to-one, unmapped, and repeated alias migrations
  preserve exclusions and old keys.

### Custom content and regression

- CRUD/reload covers every supported scope and type.
- Modified-copy success and injected failures prove atomic rollback.
- Preview uses normal preparation without output or runtime-state mutation.
- Existing routing, Druid suppression, probability/frequency, cooldown, quota,
  out-of-combat, and dispatch-accounting tests remain green.
- Live Forever tests cover character isolation, `/reload`, logout/login, the
  v1-to-v2 update, exclusions, custom CRUD, and local preview persistence.
