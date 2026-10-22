# User content and persistence runtime

> **Historical runtime detail:** portions of this document describe the former
> unreleased schema-v1 implementation. Schema v2 is now the initial supported
> V1.0 persistence schema, with sparse per-character overrides and permanent
> authored built-in IDs. No compatibility with the development schema is
> provided. [SavedVariables Architecture](savedvariables_architecture.md) is the
> source of truth where this historical detail differs.

Implemented on `feat/user-content-runtime`. Custom content and individual shipped-entry exclusions participate in the existing content selection pipeline. No graphical editor, slash-command editing interface, new gameplay detection or production spell mapping is added. Verification is deterministic/mocked; live Forever output permissions remain unverified.

## Storage and initialization

`RPHelperDB` remains per-character SavedVariables, now schema version **2**.
Initialization creates structural containers only; settings, triggers and
abilities remain sparse. The custom-content containers support:

```lua
RPHelperDB.custom = {
    nextID = 2,
    entries = {
        ["custom:1"] = {
            scope = { layer = "generic", trigger = "dodge" },
            entry = { type = "say", text = "Too slow!" },
        },
    },
}
RPHelperDB.disabledDefaults = {
    ["<shipped defaultID>"] = true,
}
```

Initialization fills only missing fields and recursively applies missing setting defaults. It preserves valid false values, existing table identities, custom records, counters, overrides, obsolete exclusions and unknown fields. It does not bump or overwrite an existing schema version. No migration is introduced: older unrelated custom fields are preserved without guessing their meaning.

Malformed roots/containers/subcontainers are preserved, not reset. An invalid custom container disables custom selection/writes while shipped content and runtime setting fallbacks remain available. A malformed exclusion container has no filtering effect and cannot be written by the customization API. Commands retain their existing behavior for malformed settings. Repeated initialization is safe and invalidates only the in-memory custom index.

A malformed `nextID` prevents additions, but does not prevent supported existing entries from being read, edited or removed. An occupied ID is skipped; deleted IDs are not reused while the persisted counter remains intact. This does not recover IDs after somebody manually resets/deletes the counter.

WoW saves the table through its normal logout/reload lifecycle. The API mutates SavedVariables in memory; it cannot guarantee an immediate disk write or recovery after a client crash. Keep SavedVariables backups. Installing new addon code does not reset user tables; deleting SavedVariables or uninstalling data is outside that guarantee.

## Scope and entry shape

| Layer | Required scope fields | Applies to |
| --- | --- | --- |
| `generic` | `trigger` | That semantic reaction for any race/class |
| `race` | `race`, `trigger` | Matching canonical race token |
| `class` | `class`, `trigger` | Matching canonical class token |
| `ability` | `class`, `ability` | Matching class and canonical ability key |
| `druidForm` | `form`, `trigger` | Matching current Druid form; `DIRE_BEAR` aliases `BEAR` |

Triggers use lower-case semantic keys such as `entercombat`, not settings names such as `enter_combat`. Race/class/form/ability keys use upper-case canonical tokens. Syntactically valid future scopes can be saved without being currently detectable. Saving an ability never enables a spell ID, creates ability defaults or expands event coverage.

Supported entry types are `say`, `emote`, `customemote`. Sayings and custom emotes use either nonblank `text`, or nonblank `template` with ordered `choices`; do not provide both. Numbered template placeholders must reference nonempty arrays of strings. Empty string choices allow optional fragments. Choices cannot contain nested numbered templates. Example:

```lua
{ type = "say", template = "{1}, {PLAYER}!", choices = { { "Well met", "Greetings" } } }
```

Keywords use the existing explicit braced tokens. Validation accepts the current resolver vocabulary plus `RINSULT`/`RINSULT!`, rejects unknown/malformed placeholders, and does not require current target/pet/player values during authoring. Those values must resolve safely during preparation or the candidate is ineligible. Deferred keywords remain unsupported without destroying their saved records. No text evaluates Lua or dispatches slash commands.

Built-in emotes use a static upper-case token, such as `ROAR`; they do not accept templates or keywords. Syntax validation does not prove Blizzard supports an arbitrary token. Token behavior and output permissions still need client verification.

New entries store supported scope/content fields; a supplied `defaultID` cannot turn a custom entry into a shipped exclusion target. Edits preserve pre-existing unknown fields on the record, scope and entry, while replacing the supported scope/content fields. Invalid edits leave the record unchanged. Unsupported/malformed records are retained and omitted from candidates rather than repaired destructively.

## Stable shipped identities

Every registration function assigns a `defaultID` to its registered entry, without changing the caller's input table. Raw shipped pool getters still expose the catalogue and IDs for future editors. Custom entries use separate monotonic `custom:N` keys.

A shipped ID begins `default:v1:` and encodes:

1. Layer and owner (race/class/form where applicable).
2. Semantic trigger or canonical ability key.
3. Output type, exact text or template, and ordered choice arrays.
4. An occurrence suffix among otherwise identical entries in that scope.

Components use length-prefix encoding rather than a hash, so distinct supported attributes cannot collide through hash truncation or delimiters. No locale conversion, punctuation normalization or registration-position ID is used. IDs are longer than hashes; only excluded IDs are persisted, and no per-event identity generation occurs.

Unrelated content additions, ordering changes of different entries and simulated reloads preserve IDs. Identical texts in different scopes/types have different IDs. Exact duplicates within one scope receive distinct occurrence suffixes and can be individually disabled, even if the same input table was registered twice.

Editing text, output type, template choices or scope produces a new identity. The edited/replacement reaction therefore starts enabled; an old exclusion remains stored and harmless. Removing a reaction does not delete its exclusion, so restoring the exact identity restores that choice. Completely identical duplicates have no intrinsic authorship distinction: changing/removing members of that identical group can reassign occurrence suffixes. Preserving a specific indistinguishable member across such edits would require explicit authored IDs, which this milestone does not add. Ordinary unrelated additions do not reassign them.

`disabledDefaults[id] == true` excludes an entry; other values do not. Re-enabling removes that key. Unknown/obsolete IDs remain safe to store. This does not alter or remove shipped content, and exclusions never apply to custom entries.

## One selection and runtime path

Character selection filters shipped Generic/Race/Class candidates, then appends matching custom scopes. Shipped Druid form pools retain their existing replacement behavior, including when all their entries are disabled; humanoid defaults are not reintroduced as a fallback. Matching custom scopes remain additive, and shared preparation suppresses custom speech in restricted/unknown Druid forms. Ability selection combines only the matching shipped/custom class-ability pool.

`GetContentPool` and `GetAbilityContentPool` return applicable candidates before keyword/form preparation. `GetPrepared*`/`Choose*` continue to use `ContentEngine.PrepareCandidate` and the existing chooser. Raw `GetGenericPool`, `GetRacePool`, `GetClassPool`, `GetDruidFormPool`, `GetAbilityPool` remain shipped-catalogue accessors. Filtering occurs before template expansion/resolution.

Prepared custom entries reach `Runtime` and `Output` through the same path as defaults. They obey master/individual settings, chance and frequency, global and reaction cooldowns, the shared combat quota through exit, activity routing and Druid restrictions. Eligible out-of-combat ability activations retain the existing no-encounter-quota behavior. Rejected candidates/failed dispatch consume no cooldown or quota. Empty pools produce no output. Target/pet context is never guessed to make a custom line eligible.

Custom IDs appear as `customID` on candidates; shipped IDs appear as `defaultID`. Preparation copies the candidate before expansion. Pool/registration objects are internal read-only references; callers must not mutate them.

## Programmatic API

Functions live on `RPHelper.UserContent`; no UI is required:

| Function | Success | Failure |
| --- | --- | --- |
| `Add(scope, entry)` | New custom ID | `nil, errorCode` |
| `Edit(id, scope, entry)` | `true`; ID retained | `false, errorCode` |
| `Remove(id)` | `true` | `false, errorCode` |
| `List(scope?)` | ID-sorted array of `{id, scope, entry}` copies | `nil, errorCode` |
| `SetDefaultDisabled(defaultID, boolean)` | `true`; false re-enables | `false, errorCode` |
| `IsDefaultDisabled(defaultID)` | Boolean | Invalid/unavailable reads yield false |
| `IsCustomEligible(id, scope, options?)` | Boolean preparation eligibility | `false`, optionally an error code |
| `Invalidate()` | Clears the in-memory custom index | No saved-data changes |

Error codes include `invalid_container`, `invalid_counter`, `invalid_scope`, `not_found`, `invalid_id`, `invalid_disabled`, `invalid_entry`, `invalid_type`, `invalid_text`, `invalid_emote`, `invalid_template`, `invalid_choices`, `scope_mismatch`.

`List` permits inspection of unsupported table-shaped saved records; it does not make them eligible. Deleted IDs return `not_found`. Eligibility queries require an exact requested scope and valid entry, then use the existing preparation options/context. They do not evaluate runtime enabled settings, random chance, cooldowns, quota or routing, and cannot promise dispatch. For generic/racial queries supply the actual player class/form in options when previewing Druid behavior; class/ability scopes supply their class if options omit it.

Add copies caller data; list returns copies. Management mutations invalidate a single scope-indexed custom cache. Repeated selection uses only applicable cached entries, not a whole custom-store scan. The index is rebuilt after initialization, API mutation, or a detected database/entries-table replacement. Its size is bounded by current valid saved entries; it stores no history or per-context cache. Direct in-place SavedVariables edits require `Invalidate()` or database reinitialization; use the API for editors. Exclusions use direct lookups and need no cache invalidation.

## Verification and remaining work

Deterministic coverage includes CRUD/reload persistence, scope/type/keyword/template eligibility, malformed and future records, empty/duplicate pools, secret/missing context, stable default identities across simulated content updates, obsolete exclusions, cache reuse/invalidation, unknown-field preservation, malformed database containers, guarded cast-success and defensive events, master/individual settings, probability/frequency, cooldown boundaries, shared quotas, failed dispatch, activity routes and Druid speech suppression.

The graphical settings/content editor is not implemented here. Milestone 2B now
requires basic custom-content create/edit/delete/preview for V1.0 and permanently
excludes account-wide settings/profiles, import/export, and character sharing
from V1.0 and the immediate roadmap. Expanded spell/event coverage remains out of
this runtime increment. Schema v2 will ship permanent authored IDs directly; it does
not need aliases for unreleased generated IDs. Live Forever
tests must verify SavedVariables persistence across an actual logout/reload/update
and existing automatic-output permissions; mocked tests do not establish those
client guarantees.

The approved navigation, library, editor, reaction types, and local-preview
behavior are specified in [V1.0 UI/UX Specification](ui_ux_spec.md). Event
priority, reaction weights, Custom activation metadata, and the new global
frequency controls described there are approved but absent from this schema-v1
runtime. Schema v2 removes event/reaction cooldowns, makes quota optional, and
adds per-character dungeon Say routing. It enforces raid suppression and Druid
Say suppression as policies without carrying development toggles forward. This
paragraph describes the approved V1.0 state; the behavior above remains only the
current unreleased implementation.
