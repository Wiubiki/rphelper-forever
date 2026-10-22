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

The implementation uses schema version 2 as the initial supported V1.0 release
schema. The design keeps `RPHelperDB`
character-specific, stores settings as sparse explicit overrides, and adds
permanent authored built-in IDs plus future sequential migrations. See
[SavedVariables Architecture](savedvariables_architecture.md).

Schema-v2 conceptual shape:

```lua
RPHelperDB = {
    schemaVersion = 2,
    settings = {}, -- sparse explicit overrides
    triggers = {},
    abilities = {},
    custom = { nextID = 1, entries = {} },
    disabledDefaults = {},
    reactionOverrides = {},
}
```

## Runtime pool

Schema v2 does not copy shipped defaults into SavedVariables and does not
migrate or support unreleased development data.

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

The approved character-facing controls and their sparse schema fields are
documented in [V1.0 UI/UX Specification](ui_ux_spec.md). Runtime policy v2 now
implements their chance, cooldown, optional quota, priority, weight, activation,
and dungeon-routing semantics. The first UI milestone binds global chance,
cooldown, quota, master activation, and dungeon routing through the shared
configuration API. Milestone 2A adds effective event/reaction metadata and sparse
individual activation. Milestone 2B adds canonical event/ability editing, 1–10
weights, Custom CRUD, independent Built-in copies, and private preview through
the same APIs.

Library event metadata is resolved only through the runtime's canonical trigger
mapping. Generic, Race, Class, and Druid-form groups for the same trigger therefore
share one `triggers[canonicalKey]` record; Druid forms do not own event settings.
Catalogue-only triggers without a runtime detector have no synthetic raw-key
configuration. Supported abilities continue to use `abilities[class][ability]`.

Reaction weights are validated integers from 1 through 10. Invalid persisted
weights remain stored for recovery but resolve to 1 in runtime and UI reads.
Modified copies allocate a Custom record with source provenance and never change
the source Built-in's activation, weight, or immutable catalogue object.
