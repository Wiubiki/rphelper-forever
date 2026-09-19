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

Lives in WoW SavedVariables and must survive addon updates.

Proposed SavedVariable:

`RPHelperDB`

Conceptual shape:

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

Do not copy shipped defaults into SavedVariables.

Runtime content should be:

`current shipped defaults + user custom entries - explicitly disabled shipped entries`

This ensures users automatically receive new default content in future releases without losing their own additions.

## Schema migrations

Every persisted schema change must be migratable.

- Store `schemaVersion`.
- Apply migrations sequentially.
- Never silently wipe user data because a schema changed.
- If migration is impossible, fail safely and expose recovery/export guidance.
