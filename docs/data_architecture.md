# Data and Persistence Architecture

## Separation of concerns

RPHelper must never require users to edit shipped addon files to preserve custom content.

### Shipped data

Lives under `RPHelper/Data/` and is replaced normally when the addon is updated.

Includes:
- Default sayings/emotes
- Race content
- Class content
- Ability content
- Default trigger configuration

### User data

Lives in WoW SavedVariables and must survive supported addon updates from V1.0
onward.

The implemented SavedVariable is per-character:

`RPHelperDB`

The current unreleased development implementation uses schema version 1.
Milestone 2B approves schema version 2 as the initial supported V1.0 release
schema, but it is not implemented yet. The approved design keeps `RPHelperDB`
character-specific, stores settings as sparse explicit overrides, and adds
permanent authored built-in IDs plus future sequential migrations. See
[SavedVariables Architecture](savedvariables_architecture.md).

Current schema-v1 conceptual shape:

```lua
RPHelperDB = {
    schemaVersion = 1,
    settings = {
        enabled = true,
        frequencyPreset = "normal",
        globalCooldown = 10,
    },
    triggers = {
        crit = {
            enabled = true,
            chance = 0.08,
            cooldown = 20,
        },
    },
    custom = {},
    disabledDefaults = {},
}
```

## Runtime pool

Schema v2 must not copy shipped defaults into SavedVariables. The unreleased
schema-v1 implementation currently does materialize them, but V1.0 does not
migrate or support that development data.

Runtime content should be:

`current shipped defaults + user custom entries - explicitly disabled shipped entries`

This ensures users automatically receive new default content in future releases without losing their own additions.

## Release schema migrations

Schema v2 is the initial supported release schema. No legacy-addon or unreleased
development-settings migration is required. From V1.0 onward, every persisted
schema change must be migratable.

- Store `schemaVersion`.
- Apply migrations sequentially.
- Never silently wipe user data because a schema changed.
- If migration is impossible, fail safely and expose recovery guidance without
  overwriting the saved data.

V1.0 and the immediate roadmap do not include account-wide settings, profiles,
import/export, or character-to-character sharing.

The approved character-facing controls and their additional sparse schema needs
are documented in [V1.0 UI/UX Specification](ui_ux_spec.md). They remain
unimplemented and do not describe current schema-v1 runtime behavior.
