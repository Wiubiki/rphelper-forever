# Legacy Placeholder Compatibility Audit

## Scope and method

This read-only audit compares the retained Turtle WoW implementation in
`../RPhelper_twow/` with the loaded files listed by `RPHelper/RPHelper.toc` and
Forever's `KeywordResolvers`, `ContentEngine`, runtime context builder, tests,
and user-content documentation. Historical ability archives are not loaded and
were excluded from shipped-content counts.

The legacy baseline is the behavior in `RPhelper_twow_ReplaceKeywords.lua`, the
event-specific `LEVEL` replacement in `RPhelper_twow.lua`, the `BLANK` random
template expansion, `How to Customize.txt`, and actual strings under
`RPhelper_twow/English/`. `NPC`, `TEXT`, and `LANG` are included because the
customization guide promises them and shipped strings use them, but the
inspected legacy code does not actually substitute them. They are documented
intent, not proven working legacy resolver behavior.

## Executive result

The original audit found that Forever did **not** provide reliable
compatibility for every legacy placeholder. Later implementation-status
sections preserve subsequent changes without rewriting that historical result.

- Legacy inventory: **35 unique base keywords**, or **36 exact spellings** when
  `RINSULT!` is recorded separately from `RINSULT`.
- Forever inventory: **29 base keywords**, or **30 exact spellings** including
  `RINSULT!`.
- Classification of the 35 base legacy keywords: **9 supported with equivalent
  semantics**, **1 supported with deliberately different semantics**, **19
  recognized but unreliable without supplied context**, **6 missing**, and **0
  unclear after source review**.
- Missing names: `BGFG`, `EFG`, `LANG`, `MOUNT`, `NPC`, and `TEXT`.
- Forever-only named dynamic placeholders: **none**. Numbered template tokens
  (`{1}`, `{2}`, ...) are Forever-only syntax replacing the separate legacy
  `BLANK` mechanism; they are not dynamic context placeholders.
- Loaded content contains **306 braced occurrences** of **14 unique names**.
  All 14 are accepted by the low-level expansion syntax if a resolver is
  explicitly injected, but `{NPC}` and `{LANG}` are absent from the standard
  resolver vocabulary and make nine occurrences in loaded Warlock NPC-talk
  content ineligible in normal operation.
- No loaded reaction string contains an unbraced legacy keyword.

The machine-readable inventory is in
[`placeholder_compatibility_inventory.csv`](placeholder_compatibility_inventory.csv).
Its 36 rows are unique by exact spelling; the summary counts above combine
`RINSULT` and `RINSULT!` as one base keyword.

## Legacy-to-Forever mapping

| Legacy group | Legacy keywords | Forever result |
| --- | --- | --- |
| Direct player/world values | `PLAYER`, `PLAYER_CLASS`, `PLAYER_RACE`, `PLAYER_GUILDNAME`, `PLAYER_GUILDRANK`, `HOME`, `MAIN_ZONE`, `SUB_ZONE`, `FFG` | Equivalent meaning when the corresponding API returns a nonempty, non-secret value. Missing/error/empty values make the candidate ineligible. |
| Generated insult | `RINSULT`, `RINSULT!` | Production-supported as recorded in the later implementation status. One generated value is cached per candidate. `RINSULT!` strips terminal `.`, `!`, or `?` and adds one `!`; legacy replaced every period and could call `RandInsult()` more than once. |
| Player pronouns and power | `SP`, `OP`, `PP`, `PLAYER_POWER` | Recognized as supplied-only values. The runtime does not derive or supply them. |
| Event value | `LEVEL` | Recognized as supplied-only. Legacy populated it only during `PLAYER_LEVEL_UP`; Forever's current runtime supplies no level value or level-up trigger context. |
| Target values | `TARGET`, `TSP`, `TOP`, `TPP`, `TARGET_CLASS`, `TARGET_GUILDNAME`, `TARGET_GUILDRANK`, `TARGET_POWER` | Recognized as supplied-only. The runtime does not supply them, which is safer than consulting an unrelated current target but means normal reactions requiring them are ineligible. |
| Target race | `TARGET_RACE` | Recognized as supplied-only with intended target-race meaning. Legacy actually called `UnitRace("player")`; Forever deliberately does not reproduce that bug. |
| Pet values | `PNAME`, `PTNAME`, `PTSP`, `PTOP`, `PTPP` | Recognized as supplied-only. The runtime does not populate them. |
| Deferred/removed world values | `EFG`, `BGFG`, `MOUNT` | Missing. This matches the existing design decision to avoid the legacy two-faction, hard-coded battleground, and session mount assumptions. |
| NPC speech values | `NPC`, `TEXT`, `LANG` | Missing from standard validation/resolvers. Legacy documentation and some shipped strings promise them, but the inspected legacy execution path contains no substitution. |

## Syntax and expansion behavior

Forever deliberately requires braces: `{PLAYER}`, not `PLAYER`. The resolver
pattern only expands `{[A-Z][A-Z0-9_]*!?}`. Validation rejects unknown or
malformed braced tokens in user-authored sayings/custom emotes. Unbraced legacy
words remain literal prose; there is no compatibility conversion and none
should be inferred.

This prevents the legacy overlap hazards among `PTSP`, `TSP`, and `SP`, and
among `PLAYER_CLASS` and `PLAYER`. Adjacent tokens and punctuation are safe,
for example `{PTSP}/{TSP}/{SP}` and `Begone, {RINSULT}!`. Resolution uses Lua's
replacement callback, so `%` characters in resolved values are not interpreted
as replacement escapes.

Literal-brace behavior is stricter during authoring than during the low-level
resolver call:

- `ValidateEntry` rejects unmatched braces and unknown `{TOKEN}` values.
- `ResolveKeywords` returns `nil` if a braced word-like token remains.
- There is no documented escape syntax for authoring literal `{...}` text.
- Ordinary braces without a word-like token can pass low-level resolution, but
  user-content validation rejects any remaining brace. This boundary is not
  directly pinned by tests.

Built-in emote entries are different: their text must be a static uppercase
emote command and cannot contain placeholders or templates.

## Semantic findings

### Names, units, and unavailable context

Legacy queried the live `player`, `target`, `pet`, or `pettarget` unit at phrase
preparation time. Forever directly queries only stable player/world APIs.
Target, pet, pronoun, power, and level values must be supplied through
`context.values` or explicit test/caller resolvers. The current runtime builds
only `PLAYER_CLASS` and `PLAYER_RACE`; therefore a syntactically recognized
token is not necessarily operationally supported.

This is a safe failure: a missing, empty, erroring, nonscalar, or secret value
makes the whole candidate ineligible. It does not leak the raw placeholder or
invent a fallback. However, it means much of the migrated target/pet corpus is
currently unavailable through normal runtime dispatch.

Legacy `TARGET_CLASS` and target guild values rejected absent, self, or
non-player targets. Forever's supplied-only contract does not itself enforce
unit type or self-target rules; correctness belongs to the context producer.
The same applies to non-player targets and target relevance to the triggering
event. A caller can inject any nonempty string, so resolver recognition alone
does not prove semantic equivalence.

### Pronouns and grammatical agreement

Legacy English mapped sex 2 to `he/him/his`, sex 3 to `she/her/her`, and all
other values to `it/it/its`; German used a separate hard-coded set. Forever has
no pronoun derivation or agreement policy. `SP`/`OP`/`PP`, target pronouns, and
pet-target pronouns are independent supplied strings. This avoids silently
copying a binary/neutral policy, but users cannot rely on them without a caller
that supplies grammatically appropriate values.

`PP`, `TPP`, and `PTPP` are possessive determiners in the legacy content
(`his/her/its`), not possessive pronouns (`his/hers/its`). Forever preserves the
token names but does not enforce that distinction.

### Race, class, guild, resource, and formatting

`UnitClass` and `UnitRace` first return values are display/localized names, so
Forever's direct player resolvers match legacy intent. `PLAYER_GUILDNAME` and
`PLAYER_GUILDRANK` correctly select the first and second `GetGuildInfo`
results. Empty values are rejected.

Forever does not map numeric power-type IDs to `mana`, `rage`, or `energy`.
`PLAYER_POWER` and `TARGET_POWER` require already formatted supplied strings.
This avoids stale legacy numeric assumptions but is not plug-compatible with a
caller that supplies raw IDs.

`SUB_ZONE` falls back to `MAIN_ZONE`/`GetRealZoneText` when the subzone API is
nil or empty. Resolver results may be strings or numbers and are converted to
text. No automatic capitalization pass is performed; unlike legacy, Forever
does not rewrite lowercase letters after sentence-ending periods.

## Loaded content audit

| Placeholder | Count | Loaded files and scopes | Operational result |
| --- | ---: | --- | --- |
| `TARGET` | 145 | Orc race; multiple class triggers; Warrior, Hunter, Shaman, Druid, Paladin, Mage, Priest, and Warlock abilities | Recognized, but normal runtime supplies no target. |
| `PNAME` | 65 | Hunter/Mage/Priest/Warlock pet triggers; Hunter abilities | Recognized, but normal runtime supplies no pet name. |
| `PP` | 65 | Multiple class triggers and all nine loaded ability catalogues except Rogue | Recognized, but normal runtime supplies no player pronoun. |
| `PTOP` | 9 | Hunter and Warlock `petattackstart` | Recognized, but normal runtime supplies no pet-target pronoun. |
| `NPC` | 7 | Warlock `npctalksfriend`/`npctalksenemy`, including shared templates | Unsupported by standard validation/resolvers; normally ineligible. |
| `SP` | 3 | Warrior and Druid abilities | Recognized, supplied-only. |
| `LANG` | 2 | Warlock `npctalksfriend`/`npctalksenemy` | Unsupported by standard validation/resolvers; normally ineligible. |
| `TARGET_POWER` | 2 | Warrior `dodge` and `parry` | Recognized; requires formatted supplied value. |
| `TARGET_RACE` | 2 | Warrior `dodge` and `parry` | Recognized; requires intended target race, not legacy's erroneous player race. |
| `TSP` | 2 | Rogue `leavecombat` | Recognized, supplied-only. |
| `OP` | 1 | Druid `INNERVATE` | Recognized, supplied-only. |
| `PLAYER_RACE` | 1 | Shaman `block` | Direct resolver available; runtime also supplies it. |
| `PTNAME` | 1 | Priest `petattackstart` | Recognized, supplied-only. |
| `RINSULT` | 1 | Warrior `MOCKING_BLOW` | Recognized and operational through the production English provider described below. |

There are **no** occurrences of `RINSULT!` in loaded Forever content. The scan
also found no unknown braced spelling beyond the known unsupported `NPC` and
`LANG`, and no unbraced legacy keyword in a loaded reaction string.

The NPC counts are seven rather than two because the five first-choice strings
in the shared Warlock NPC template each contain `{NPC}`. Both template
registrations reuse that choice table at runtime, but the source corpus contains
five placeholder occurrences in the shared data plus two static reactions.

## Legacy shipped usage cross-check

The legacy English catalogue uses 24 of the 35 base names. Resolver-supported
but unused names are `PLAYER`, `PLAYER_CLASS`, `PLAYER_GUILDRANK`,
`PLAYER_POWER`, `TOP`, `TPP`, `TARGET_CLASS`, `TARGET_GUILDNAME`,
`TARGET_GUILDRANK`, `PTPP`, and `MAIN_ZONE`. Their absence from shipped strings
does not remove them from the legacy vocabulary: the resolver or documentation
explicitly supports them.

`NPC`, `TEXT`, and `LANG` do occur in legacy shipped reactions. Their usage does
not demonstrate working substitution because no corresponding replacement was
found in the inspected execution code. Conversely, `LEVEL` is not in the
general replacement function but is definitely implemented in the level-up
event path.

`BLANK` is not counted as a context placeholder. It is the legacy random phrase
marker, expanded positionally before keyword replacement. Forever replaces it
with numbered template tokens and independent choice pools. `SELF` is likewise
excluded: it is an emote-target modifier, not reaction text substitution.

## Existing tests and gaps

Existing tests cover successful injected resolution, missing values filtering a
candidate, resolver errors/nonscalar/secret values, numeric conversion,
overlapping names, numbered templates, keywords inside selected fragments,
`RINSULT` caching, punctuation, production generation, failure handling and
lazy invocation, unknown tokens, one migrated target ability,
pet-name/pet-target use, user-authored target and pet filtering, custom
templates, malformed saved entries, and secret custom context. A test can
prepare `{NPC}`/`{LANG}` only by bypassing the standard vocabulary with explicit
resolver functions; this does not establish runtime support.

Important gaps:

1. No table-driven contract test enumerates all 29 Forever base keywords or all
   35 legacy base keywords.
2. Direct API resolvers lack focused tests for nil, empty, error, multiple
   return values, and unavailable API functions.
3. No production-context test proves which supplied-only values the runtime
   populates; currently it supplies only class and race.
4. Pronoun sex/gender mapping and possessive grammar have no implementation or
   tests.
5. Player/target/pet name formatting, realm-qualified names, self-targets,
   non-player targets, stale targets, and restricted combat values are not
   covered.
6. Power types are not tested as formatted labels versus raw numeric/enumerated
   values.
7. Unbraced legacy syntax is not explicitly pinned as literal text.
8. Literal balanced braces, brace escaping, adjacent placeholders, and
   punctuation other than the existing slash/insult cases need boundary tests.
9. User-authored import behavior is not tested for each missing legacy name or
   for unbraced copied legacy content.
10. Loaded-content validation does not flag standard-resolver omissions such as
    `{NPC}` and `{LANG}`; shipped registrations bypass `ValidateEntry`.

## Risks when importing legacy reactions

- Directly pasted unbraced content silently remains literal, for example
  `PNAME! Hurt PTOP badly.` is emitted unchanged if otherwise eligible.
- Manually bracing a missing name causes user-content validation to reject the
  entry (`{NPC}`, `{LANG}`, `{EFG}`, `{BGFG}`, `{MOUNT}`, `{TEXT}`).
- Bracing a supplied-only name makes authoring succeed but may leave the entry
  permanently ineligible under current runtime context.
- `TARGET_RACE` intentionally changes from the legacy implementation's buggy
  player-race result to the intended target-race result.
- At the time of this audit, `RINSULT` content was unusable because no
  production provider existed. The later implementation status below records
  its restoration. Repeated insult tokens share one generated insult within a
  candidate.
- Legacy `BLANK` templates require deliberate conversion to numbered templates;
  there is no automatic migration.
- Legacy capitalization, locale-specific pronouns, faction assumptions, mount
  session state, and NPC speech data are not reproduced.

## Recommended minimal corrections

1. **P0 — Decide and document the runtime context contract.** Specify which
   target, pet, pronoun, power, and level values each trigger may safely supply.
   Add table-driven tests before enabling more migrated reactions.
2. **P0 — Resolve the loaded `{NPC}`/`{LANG}` inconsistency.** Owner must choose
   between implementing validated NPC-speech context, deferring/removing those
   loaded registrations, or explicitly accepting that they remain ineligible.
   This audit does not authorize a content rewrite.
3. **Completed — Install a production insult provider.** The shipped
   `MOCKING_BLOW` reaction now prepares normally; details are recorded below.
4. **P1 — Establish an English pronoun policy.** Define subject, object, and
   possessive-determiner values, treatment of unknown/nonbinary sex data, and
   localization boundaries before runtime derivation.
5. **P1 — Add a vocabulary contract test.** Pin all legacy mappings, all Forever
   names, missing-name rejection, unbraced literal behavior, and brace edges.
6. **P2 — Add import guidance.** Tell users to brace supported keywords, convert
   `BLANK` manually, and expect context-dependent entries to be skipped.
7. **P2 — Keep `EFG`, `BGFG`, and `MOUNT` deferred** unless current Forever APIs
   and product behavior justify narrow replacements; do not recreate legacy
   hard-coded assumptions.

## Decisions requiring owner approval

- Whether NPC speech triggers and `{NPC}`/`{TEXT}`/`{LANG}` belong in V1.
- Whether current-target fallback is ever acceptable, or all target values must
  come from trigger-specific event context.
- The player/target/pet pronoun and localization policy.
- The formatted contract for class, race, names, guild ranks, and power types.
- **Resolved:** ship the active English legacy insult corpus and select each
  part through the content engine's existing random-choice path.
- Whether import tooling or documentation should assist with unbraced keywords
  and `BLANK`; automatic conversion is explicitly outside this audit.
- Whether deferred `EFG`, `BGFG`, and `MOUNT` remain unsupported permanently.

## Validation performed

- Accounted for every replacement in the legacy general resolver, the
  event-specific `LEVEL` path, and documented NPC speech names.
- Accounted for every key returned by `KeywordResolvers.Create` plus the
  `RINSULT`/`RINSULT!` content-engine special case.
- Cross-checked all loaded TOC data files and all legacy English Lua files.
- Verified 36 unique exact-spelling CSV rows and reconciled them to 35 base
  keywords.
- Verified all 306 braced occurrences in loaded content and scanned for
  unbraced legacy names.

## Phase 1 implementation status

Implemented by `feat/runtime-placeholder-context` after this audit:

- `SP`, `OP`, and `PP` are now operational in production runtime preparation.
  They are resolved lazily from `RuntimeAPI.GetPlayerSex`: sex 2 maps to
  `he/him/his`, sex 3 to `she/her/her`, and the recognized neutral/unknown sex
  value 1 to `it/it/its`. Missing, throwing, malformed, out-of-range, or
  restricted values remain unavailable. Explicit `context.values` still take
  precedence.
- `PLAYER_POWER` is now operational when the client returns a readable semantic
  power token. `MANA`, `RAGE`, and `ENERGY` map to `mana`, `rage`, and `energy`.
  Numeric IDs are deliberately ignored, and unknown or restricted tokens leave
  the placeholder unresolved.
- These APIs are lazy resolver dependencies: static reactions do not call
  `UnitSex` or `UnitPowerType`. Multiple player-pronoun forms in one candidate
  share one sex lookup.

No current production event safely populates ordinary target context:

- `PLAYER_REGEN_DISABLED` and `PLAYER_REGEN_ENABLED` identify only combat-state
  transitions and carry no involved target.
- Defensive `UNIT_COMBAT` establishes that the affected unit is `player`; it
  does not identify the attacker whose race, class, power, guild, or pronouns
  a reaction would need.
- `UNIT_SPELLCAST_SUCCEEDED` establishes that the caster is `player`; its
  `unitTarget` field names the caster, not the spell's destination.

Consequently `TARGET`, `TSP`, `TOP`, `TPP`, `TARGET_CLASS`, `TARGET_RACE`,
`TARGET_POWER`, `TARGET_GUILDNAME`, and `TARGET_GUILDRANK` remain supplied-only.
They work when a caller provides explicit relevant `context.values`, but the
production runtime never consults the currently selected `target` as a
fallback. This also means player-only class/guild restrictions cannot be
violated by current production context construction. Enabling any target field
requires a future existing-event payload that proves the involved unit; this
phase adds no event subscriptions, combat-log inference, target tracking, or
GUID cache.

At that phase, pet, NPC speech, insults, mounts, faction/battleground values,
and level-up context remained deferred exactly as recorded above.

### API assumptions requiring client verification

- `UnitSex("player")` exists and returns readable numeric values 1, 2, or 3 in
  the Forever client under all supported runtime states.
- `UnitPowerType("player")` exists and returns a readable semantic token as its
  second result. Only `MANA`, `RAGE`, and `ENERGY` are accepted in this phase.
- `issecretvalue`, when present, can safely inspect those returned values.
  Inspection failure or a secret result fails closed.

Live-client testing should cover login/reload timing, shapeshifts or temporary
power changes, vehicles, dead/ghost state, and combat restrictions. Additional
power tokens must not be enabled until their Forever return values and desired
prose labels are observed. The existing target limitation should be retested
only if a current subscribed event is shown to carry a readable and relevant
unit token.

## Random insult implementation status

Implemented by `feat/legacy-random-insults` after this audit:

- `RPHelper/Data/RandomInsults.lua` installs a production provider through the
  existing `ContentEngine.SetInsultProvider` extension point. The file is
  loaded before reaction data and does not register reactions or change default
  identities.
- The authoritative sources were legacy `English/RInsult.lua` for the active
  English vocabulary and attribution, `RPhelper_twow.lua` for `RandInsult()`,
  `RPhelper_twow_ReplaceKeywords.lua` for `RINSULT`/`RINSULT!` punctuation, and
  `How to Customize.txt` for the documented phrase contract.
- Every active English entry is retained verbatim and in source order. Pool
  counts are `ANY` 17/29/36, `GNOME` 29/0/0, `PALADIN` 154/0/59, and `WARRIOR`
  21/0/2 for parts one/two/three. Empty legacy race/class pools add no material.
  The alternative Shakespearean `ANY` block remains excluded because it was
  commented customization guidance, not active shipped data.
- Generation preserves the legacy structure: concatenate the `ANY`, player
  race, and player class pools for each part; choose each part independently;
  emit `You <part1> <part2> <part3>.`. Forever uses the actual runtime
  race/class rather than restoring the legacy user-editable trait list, which
  would require new settings and SavedVariables behavior.
- Forever intentionally retains braced-only syntax and generates once per
  prepared candidate. The legacy resolver could call `RandInsult()` repeatedly
  during one replacement. `{RINSULT!}` retains Forever's established behavior
  of replacing terminal `.`, `!`, or `?` punctuation with exactly one `!`,
  rather than the legacy global replacement of every period.
- The provider is lazy, uses the content engine's existing controlled random
  chooser, and fails closed for missing pools, invalid choices, errors, empty
  values, nonscalar values, secret values, or generated placeholder-like text.
  Inserted insult text is not recursively expanded.
- The loaded Warrior `MOCKING_BLOW` reaction now prepares through normal
  production context without changing its text or registration. There are no
  loaded `{RINSULT!}` reactions, but the supported authoring contract is tested.

The generator is pure Lua and adds no new WoW client API assumption. Existing
runtime class/race acquisition retains the client-verification caveats already
listed above. English is the only implemented insult language; no localization
framework or standalone insult command was added.
