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
