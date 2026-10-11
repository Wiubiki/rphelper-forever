# Runtime API assumptions

The minimal runtime core isolates every WoW API dependency in `Core/RuntimeAPI.lua`. None is treated as Forever-verified until exercised in the live client.

| API/event | Runtime use | Evidence level | Required live verification |
| --- | --- | --- | --- |
| `CreateFrame`, `RegisterEvent`, `SetScript` | Addon event frame | Established WoW addon API; already required by the pre-runtime addon | Confirm normal behavior in the current Forever build. |
| `ADDON_LOADED` | Database and runtime initialization | Existing addon behavior | Confirm addon-name payload and load ordering. |
| `PLAYER_REGEN_DISABLED` | Enter-combat signal | Established WoW event; Forever behavior unverified | Confirm firing order, duplicates, login/reload-in-combat behavior, and restrictions. |
| `PLAYER_REGEN_ENABLED` | Leave-combat signal | Established WoW event; Forever behavior unverified | Confirm firing order and combat-termination semantics. |
| `UnitAffectingCombat("player")` | Initialize defensive combat state | Established WoW API; Forever availability unverified | Confirm availability and return behavior during addon load. |
| `UnitClass("player")` | Stable class file token | Established WoW API; Forever return shape unverified | Confirm the second return remains the canonical file token. |
| `UnitRace("player")` | Stable race file token | Established WoW API; Forever return shape unverified | Confirm the second return remains the canonical file token, including Forever races. |
| `GetShapeshiftFormID()` | Druid form-aware selection and speech suppression | Existing isolated implementation; Forever IDs unverified | Confirm availability and all Druid form IDs. Missing/failing calls deliberately raise into the protected form detector so it returns `UNKNOWN`; successful `nil` or `0` means humanoid. |
| `SendChatMessage(text, "SAY")` | Spoken saying output | Established WoW API; automatic use may be restricted | Confirm automatic-event permission and activity restrictions. |
| `SendChatMessage(text, "EMOTE")` | Custom `/e` output | Established WoW API; automatic use may be restricted | Confirm automatic-event permission and activity restrictions. |
| `DoEmote(token)` | Blizzard built-in emote output | Established WoW API; automatic use may be restricted | Confirm token support and automatic-event permission. |

Adapter methods fail safely when their underlying global is unavailable. The shapeshift adapter deliberately raises on API failure so the existing protected form detector can distinguish failure (`UNKNOWN`) from a legitimate humanoid `nil`/`0` result. Automated tests replace the adapter entirely; live Forever testing remains a separate verification stage.


## Runtime policy adapter additions

| API | Use | Live verification still required |
| --- | --- | --- |
| `IsInInstance()` | Strict `false, "none"` → world; `true, "party"` → dungeon; `true, "raid"` → raid. Other or failing results are unknown and suppress output. | Confirm Forever return values and instance classification. Raid grouping outside an instance retains world routing. |
| `GetTime()` | Session monotonic cooldown clock, injectable through the adapter. | Confirm availability and readable values during combat. Backward/nonfinite readings suppress attempts. |
| `DEFAULT_CHAT_FRAME:AddMessage(text)` | Minimal local-only sayings display with an RPHelper prefix. | Confirm visibility and availability; no public fallback exists. |
| `math.random()`, `math.random(size)` | Probability rolls and content selection, separately injectable. | Standard Lua assumptions; no random seed changes. |
| `UNIT_COMBAT` / `RegisterDefensiveEvents(frame)` | Protected ordinary registration; failure leaves combat transitions functional. | Confirm registration and delivery on the actual Forever build. |
| `issecretvalue` / `ClassifyUnitCombat(unitTarget, action)` | Required fields must inspect as nonsecret strings; exact player DODGE/PARRY/direct BLOCK only. Missing/failing inspection rejects detection; unused fields are ignored. | Confirm readability and attribution in ordinary addon execution, restricted contexts, and encounter-boundary ordering. See [combat audit](combat_trigger_api_audit.md). |
| `UNIT_SPELLCAST_SUCCEEDED` / `RegisterAbilityEvents(frame)` | Protected ordinary registration; failure disables only ability detection. | Confirm ordinary-addon registration and delivery across activities; no unit-filtered registration assumption. |
| `issecretvalue` / `ClassifySpellcastSucceeded(unitTarget, castGUID, spellID, class)` | Exact readable player unit, valid readable positive integer ID and readable class; two explicit Paladin mappings. GUID/cast-bar fields ignored. | Verify readability across restricted contexts, rank IDs and duplicate delivery. ID evidence is third-party, not RPHelper live verification; see [spellcasting audit](spell_casting_api_audit.md#6-first-runtime-increment). |

Output adapter success means the API invocation completed without an exception
or explicit false result, not that the server acknowledged delivery. WoW output
APIs commonly return nil on successful invocation; silent server rejection cannot
be observed here. No restriction bypass or automatic retry is attempted.
Automatic chat/emote permissions still require live Forever verification.

## Remediation tracking: feat/runtime-policies

This section supplements the historical runtime wiring audit without changing its
findings. No commit has been created for this work.

| Audit remediation | Implementation / automated verification | Live Forever |
| --- | --- | --- |
| Enabled state, chance, frequency, cooldowns, encounter cap | Implemented; mocked boundary, interaction, exhaustion/reset and malformed-setting tests pass. All output routes share the encounter quota through exit; out-of-combat attempts retain chance/cooldowns without consuming quota. | Pending |
| Evaluation and state-consumption order | Implemented; failed dispatch and rejected candidates consume no cooldown/quota. | Pending |
| Activity-aware routing | Implemented; world local sayings, dungeon SAY, default raid suppression, separate emote routes and unknown-context suppression tested. | Pending |
| Preserve preparation, keyword safety and Druid suppression | Existing content-engine and runtime suites pass. | Pending |
| Malformed saved settings | Startup and registered slash-command tests cover malformed root/settings containers and preservation of recoverable user data. Status uses the effective enabled default; on/off report unsavable settings without replacing malformed containers. General migrations remain deferred. | Pending |

Gameplay event coverage includes combat entry/exit, the three audited defensive
reactions (active encounters only), and the two mapped Paladin abilities through
guarded cast-success events. RPHelper verification remains mocked only.
Offensive criticals, partial-block flags, and combat-text/combat-log fallbacks
remain unimplemented. Interface metadata,
other triggers, a graphical settings editor, and general migrations remain
unimplemented. User-content pooling and disabled-default filtering are now
implemented through the existing selection/policy path; see
[User content runtime](user_content_runtime.md). Customization adds no game APIs
or events. Actual SavedVariables persistence across logout/reload and addon
updates still requires live Forever verification.
