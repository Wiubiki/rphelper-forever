# Ability detection milestone 1: mapping foundation and Shaman test build

**Later status:** the owner reports successful live acceptance on Interface
16001 for exact Shaman 325/547, reaction output, chance/shared cooldown, Library
and settings after `/reload`. The foundation below records milestone 1; current
coverage and unverified B ranks are documented in [milestone 2](ability_detection_milestone_2.md).

Implementation date: 2026-11-06. Branch: `diagnostics/live-client-ability-events`.
This is a local test build awaiting human review and manual Forever acceptance;
no release is authorized. It implements only the static mapping foundation from
the [architecture proposal](ability_detection_architecture.md).

## Evidence and rank limits

Exactly four class/ID mappings are bundled:

| Class | Event spell ID | Canonical ability | Evidence |
| --- | ---: | --- | --- |
| PALADIN | 19750 | FLASH_OF_LIGHT | Inherited third-party Forever success report; unchanged evidence status. |
| PALADIN | 20288 | SEAL_OF_RIGHTEOUSNESS | Inherited third-party Forever success report; unchanged evidence status. |
| SHAMAN | 325 | LIGHTNING_SHIELD | Owner reports repeated readable player successes on a Tauren Shaman, Interface 16001. |
| SHAMAN | 547 | HEALING_WAVE | Same owner report, explicitly Healing Wave Rank 3. |

The Shaman report confirms event registration, availability of secret inspection,
readable `UNIT_SPELLCAST_SUCCEEDED` samples, `player`, `SHAMAN`, and the two
spell names. Those samples were `unmapped` before this implementation. The
report does not supply raw capture files, exact client build, full combat/activity
coverage, or negative-case results. It establishes identity/event evidence for
these IDs, not live acceptance of the newly mapped reaction path. No new live
tests were performed during implementation.

Other ranks remain unmapped, including Lightning Shield 324 and Healing Wave
331/332. Names do not enable them. The Library's **Detected: mapped IDs only**
means at least one ID has a supported detector; it does not promise every rank.
The Paladin entries remain based on the
[original evidence](spell_casting_api_audit.md#6-first-runtime-increment), without
being upgraded to RPHelper live verification.

## Implementation and future additions

`Data/AbilitySpellMappings.lua` holds a list of explicit records with `class`,
`spellID`, `ability`, `mechanism`, `evidence`, and `evidenceRef`. It loads after
all `Data/Abilities/*.lua` files and before the Library/startup files, so validation
can check actual canonical definitions. `Core/RuntimeAPI.lua` starts with an empty
index and contains no production ID declarations.

`AbilitySpellMappings.BuildIndex(records, abilities)` validates the complete list
once. It rejects malformed containers/sparse lists, nonpositive/nonfinite/
fractional/nonnumeric IDs, unknown class/ability pairs, duplicate class/ID records
(including identical duplicates), conflicting assignments, unsupported mechanisms,
and missing/unrecognized evidence metadata. Multiple explicitly approved IDs may
map to one key; an ID in another class is independently scoped. Candidate IDs
and special mechanisms never enter this list.

The index is published atomically as `RuntimeAPI.AbilitySpellIDs[class][spellID]`.
Any invalid record discards the entire candidate index and leaves mappings empty;
`AbilitySpellMappings.validationError` contains a fixed reason for offline/manual
inspection. Generic and defensive adapters remain intact. This deliberately
retains the existing public index shape: runtime classification, Library status
and the offline exporter consume the same authoritative data. The exporter now
loads the adapter before TOC data, matching this dependency without overwriting
the compiled index afterward.

The event classifier's guards, exact lookup, return shape and diagnostic records
are unchanged. No runtime scans, name matching, rank inference, discovery caches,
extra event registrations or spellbook APIs were added. Resolved Shaman keys
enter the existing reaction coordinator with no new policy path. Content,
permanent reaction IDs, eligibility, weights, settings, existing migrations,
per-character schema v2, chance, cooldown/Priority, quota, Druid suppression and
activity routing remain unchanged.

To add a mapping in a future authorized increment:

1. Record the exact readable player-success ID, build/Interface, learned ability
   and rank, class/race, locale, date and tested contexts. Resolve helper/effect,
   alias and activation-mechanism ambiguity. Do not promote a whole candidate family.
2. Review the existing canonical key and eligible content. Preserve its reaction
   IDs and all saved customization; no new canonical key is needed for another rank.
3. Add one explicit record per approved ID, retaining truthful evidence metadata
   and a reference to the reviewed observations. Keep research lists outside the
   addon. Run index validation and add exact positive/negative classification,
   policy and diagnostic coverage for the proposed IDs.
4. Refresh only intentional runtime-support metadata in the canonical inventory,
   update current support/evidence documentation, and verify reaction data stays
   unchanged. Rebuild and manually accept the supported contexts before release.

The architecture's discovery proposal and separate Library resolver query are
deferred. The existing shared index suffices for this static increment.

## Offline validation

All available suites passed: **339 Lua tests** across mapping validation (9),
content engine (139), diagnostics (19), manifest/startup (2), runtime (102),
schema v2 (16), and Library/UI (52); **10 Python tests** cover inventory export
and packaging. Syntax checks passed for all 65 addon/test Lua files (including
unloaded archives) and four Python files. Tools: Lua 5.5.1 and Python 3.14.9;
these checks do not establish the client's Lua/API compatibility.

`python3 scripts/export_content_inventory.py --check` and `git diff --check`
passed. Canonical exports changed only the two Shaman runtime-support records,
the manifest data-file list, and the derived unsupported-detector summary.
All existing reaction-source files and `reactions.csv` remain byte-identical;
JSON reaction IDs/text/types/order/choices and source locators are unchanged.
Startup tests retain existing Shaman/Paladin settings without a schema migration.

## Packaging

Generated addon ZIPs belong under ignored `dist/`. This convention already
existed; `tmp/` remains for logs, reports, scratch data and `review.txt`.
`scripts/package_addon.py` now accepts an optional build output path:

```sh
python3 scripts/package_addon.py build --output dist/RPHelperForever-0.9.0-mapping-test.zip
python3 scripts/package_addon.py validate dist/RPHelperForever-0.9.0-mapping-test.zip
```

The default build/validate commands retain the existing version-derived archive
name under `dist/`; the TOC version stays `0.9.0-prerelease`. The builder creates
missing parent directories, uses fixed timestamps/order/permissions/compression,
and never stages files. An identical rebuild reports `unchanged`. It refuses to
overwrite a different existing archive; deliberately move an obsolete local
artifact before rebuilding into the same filename.

The archive contains one top-level `RPHelperForever/` folder: its TOC, all 51
TOC-listed Lua files, and three required distribution notices under
`RPHelperForever/Documentation/` (`LICENSE`, `CONTENT_RIGHTS.txt`, `CREDITS.txt`).
These notices are required addon distribution files retained from the existing
packaging contract. Repository documentation, archives, tests, scripts, reports,
Git metadata and other development files are excluded. There are **55 files**.
Validation checks the complete member list, bytes against current sources,
extracted folder shape and byte-identical independent rebuilds, then prints
SHA-256. See `tmp/review.txt` for this build's byte size, checksum and full contents.

## Live-client acceptance

Use the Tauren Shaman with the actual spellbook abilities emitting IDs 325 and
547. Keep the first output tests outside combat in the open world so Say is local.
Do not change client restrictions or infer targets to make a reaction eligible.

1. Save the current character's master setting, global cooldown, quota, and both
   abilities' enable/chance/Priority settings, including whether chance is inherited.
   With the game closed, back up that character's `RPHelperForever.lua` SavedVariables
   file and replace only `Interface/AddOns/RPHelperForever/` with the ZIP's addon
   folder. Do not delete SavedVariables or copy repository source folders.
2. Log in and record client build, Interface, class/race, level, locale, actual
   spellbook rank, activity and combat state. Confirm no Lua errors and that
   prior settings/custom reactions/weights/exclusions survived replacement.
3. Run `/rph debug status`. Expected: spellcast registration successful, secret
   inspection available, capture initially disabled/empty. Presence alone does
   not prove every field readable in every context. Missing registration/inspection
   is an acceptance failure, not permission to bypass guards.
4. For classification, run `/rph off`, `/rph debug clear`, `/rph debug on`.
   Cast Lightning Shield from the normal spellbook/action bar two or three times.
   Then `/rph debug off`, `/rph debug show all`. Save the output before reload.
   Expect ID 325, class SHAMAN, unit player, `result=mapped`, `matched=yes`,
   `ability=LIGHTNING_SHIELD`. With master off expect `outcome=master_disabled`
   and no emitted reaction. Repeat separately for Healing Wave Rank 3: ID 547,
   `ability=HEALING_WAVE`. A different actual ID should remain `unmapped`.
5. Open `/rph`, Character Library, Class. Both groups should show
   **Detected: mapped IDs only** and allow Modify Event. Check an unmapped group,
   such as Lightning Bolt, still shows **Not currently detected** and has no
   event-settings controls. Editing Custom reactions remains its existing feature.
6. Enable master reactions and both mapped abilities; temporarily set both
   per-ability chances to **100%**, Priority off, quota off, and dungeon Say to local
   if a later dungeon sample is planned. Leave enabled shipped Say content in
   each pool. Use the normal global cooldown (default 20 seconds) and wait its
   full duration before each cast. Defaults/customization can suppress candidates;
   changing chance does not force ineligible content to qualify.
7. Clear/start capture and cast 325 once. Stop/show/save. Expect `result=mapped`,
   `eligible` positive, `selected=yes`, `emitted=yes`, `outcome=emitted`, and an
   actually visible reaction. Wait out the cooldown and repeat for 547. Healing
   Wave's target-dependent custom emote remains ineligible without a safe cast
   target; its four shipped Say entries need no target context.
8. During the cooldown, cast the other mapped spell and expect `outcome=cooldown`
   without another reaction. Separately test chance 0%, each ability disabled,
   master disabled and quota exhaustion, restoring the controlled settings between
   cases. Confirm these suppress output without Lua errors. Test failed/cancelled/
   interrupted Healing Wave attempts; they must not create a success reaction.
9. In a safe encounter, confirm previously working generic entry/exit/defensive
   reactions still behave normally. Repeat short Shaman captures in intended
   combat/activity contexts, keeping samples short enough for the 100-record buffer.
   Unknown activity and raids must suppress automatic output. Public dungeon
   visibility, if tested, needs observation; adapter success alone is insufficient.
10. Restore the saved settings, including inherited chance via Reset Chance if
    appropriate; leave `/rph debug off`. Reload/logout/login and verify settings,
    Custom records, weights and exclusions persist. Diagnostics must restart
    disabled/empty. Save evidence before reload because it is not persisted.

Acceptance requires repeatable results for both IDs, actual visible permitted
output, accurate Library status, no new Lua errors, intact generic reactions and
unchanged character persistence. Offline tests do not substitute for this pass.
