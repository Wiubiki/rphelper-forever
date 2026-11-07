# Emote output test build

This is an uncommitted correction on `feat/broad-ability-mappings`, based on the
milestone 2 tree. It requires live Forever acceptance. It does not establish
successful public emote delivery.

## Findings

The original routes were world Say → `DEFAULT_CHAT_FRAME:AddMessage`, dungeon
Say → global `SendChatMessage(..., "SAY")`, ordinary Emote → global
`DoEmote(token)`, and Custom Emote → global `SendChatMessage(..., "EMOTE")`.
Both emote types used the same public API in world and dungeon contexts. Raid
and unknown activities were rejected before selection. A raid group outside an
instance still used world routing.

`RuntimeAPI` treated any nonthrowing call without explicit false as successful,
including nil. `Output.Dispatch` accepted that boolean; Runtime set
`emitted=yes outcome=emitted` and spent cooldown/quota. Thus the reported Searing
Totem trace proves selection and dispatch completion, not visible output.
Ordinary Lua errors were caught, but protected-action notifications need not
raise a catchable Lua exception. Silent client rejection and chat-tab filters
were indistinguishable from delivery. No API acknowledgment, server receipt,
or receiving-player observation was recorded.

The supplied `/run` warning establishes a protected-action problem somewhere
in that execution path, not which function failed in ordinary addon execution.
Manual `/em` working does not grant permission to an automatic SUCCEEDED
callback. The likely explanation for world Custom Emote failure is restricted
automatic public chat; its exact enforcement on the installed build remains
unverified. Native Emote failure could additionally involve token support or
legacy-global availability. These causes must not be conflated.

RFC dungeon output is consistent with the old routing, with instance-dependent
permissions, an older client/build, or different chat filters. The supplied
milestone comparison says output files were unchanged. There is no demonstrated
milestone 2 output regression, and this change does not modify detection.

## API evidence and limits

Research date: 2026-11-07. The available primary-content evidence is Blizzard UI
source mirrored in Gethe's **forever** branch, rather than Retail/Classic API
assumptions. A mirror is not a permission guarantee for the owner's installed
build. No authoritative, build-matched guarantee of automatic public emote
permission was obtained.

- [Generated Forever chat API definitions](https://github.com/Gethe/wow-ui-source/blob/forever/Interface/AddOns/Blizzard_APIDocumentationGenerated/ChatInfoDocumentation.lua)
  expose `C_ChatInfo.SendChatMessage` for SAY/EMOTE, with restrictions and no
  delivery result. They expose restricted `C_ChatInfo.PerformEmote` with a
  boolean success result. They also expose chat-lockdown queries; those do not
  establish general permission for automatic output.
- [Blizzard chat edit box](https://github.com/Gethe/wow-ui-source/blob/forever/Interface/AddOns/Blizzard_ChatFrameBase/Shared/ChatFrameEditBox.lua)
  uses namespaced chat and native-emote functions. Its handling names the
  PerformEmote result `restricted` and accepts its negation, conflicting with
  the generated success-result name. This unresolved source discrepancy is a
  specific live-test requirement. The adapter follows the generated contract,
  accepts only true for this API, and falls back privately otherwise; a false
  result may therefore produce a duplicate local line if the installed client
  actually performed the emote. Public delivery is always unverified.
- [Blizzard chat utility](https://github.com/Gethe/wow-ui-source/blob/forever/Interface/AddOns/Blizzard_ChatFrameBase/Shared/ChatFrameUtil.lua)
  assigns `DEFAULT_CHAT_FRAME` and inserts local UI lines with `AddMessage`.
  [Forever's own override](https://github.com/Gethe/wow-ui-source/blob/forever/Interface/AddOns/Blizzard_ChatFrameBase/Camelot/ChatFrameUtilOverrides.lua)
  also uses `AddMessage`. This supports private display independently of
  automated public chat permissions.

The source does not prove that all ordinary tokens are banned in the world,
that dungeon automation is always allowed, or that every token has animation,
sound and text support. No restriction query, secure hook, timer, macro,
hardware-event impersonation or alternate public retry is used to obtain
permission. The test build conservatively chooses private world output.

## Implementation

| Context | Say | Emote | Custom Emote |
| --- | --- | --- | --- |
| World | Existing local display | `[Local only - Emote] TOKEN` | `[Local only - Custom Emote] resolved text` |
| Dungeon | Existing public SAY, or character's local option | Native attempt; private fallback on observable failure | Public EMOTE attempt; private fallback on observable failure |
| Raid / unknown | Suppressed | Suppressed | Suppressed |

All local lines retain the RPHelper prefix. An ordinary private fallback shows
the stored token, without inventing translated action text, playing an
animation or sound, or claiming nearby-player visibility. The Guide explains
this behaviour. There is no new setting or SavedVariables migration.

Adapters prefer the documented namespaced public functions; legacy globals
are used only when their namespaced function is absent. An error/rejection
never triggers another public API attempt. Missing, throwing, false, or
restricted results fail safely. Dungeon emote failure can use private display;
Say failure retains its existing failed-dispatch behaviour. A nonthrowing void
chat call remains public-delivery-unverified. A silent rejection cannot trigger
a reliable fallback without a delivery acknowledgment, so it remains a live
limitation in dungeons.

Keywords, prepared text, stored types, IDs, weights, chance, Priority, cooldown,
quota, character settings, and Druid Say suppression use the existing pipeline.
Only successful public dispatch or successful private insertion consumes normal
frequency accounting. If both native dispatch and fallback fail, neither quota
nor cooldown is spent. No content, mapping, inventory or database files change.

## Diagnostics

The existing debug commands, session-only lifetime and 100-record buffer remain.
Output fields also apply to admitted generic combat and defensive reactions,
so ordinary Emote testing can use the existing Tauren Dodge entry.

| Field | Meaning |
| --- | --- |
| `selected` | Prepared candidate selected; does not imply any API invocation. |
| `dispatchAttempted` | Primary underlying output API invoked. World emotes invoke local display directly. |
| `apiCompleted` | Primary method's underlying API returned without a caught exception; false/restricted return can still mean completed. |
| `apiStatus` | `completed`, `unavailable`, `error`, `rejected`, or `restricted_result`; `not_attempted` before dispatch. Raw errors are discarded. |
| `route` | Final chosen destination: `local` or `public`; inspect status to know whether it succeeded. |
| `publicDelivery` | `not_attempted`, `failed` (observable API failure), or `unverified`. Never server-confirmed. |
| `fallbackReason` | `world_policy`, or the observable failed public call's status. |
| `fallbackStatus` | Subsequent private call's status after public failure. Primary API fields still describe the failed public call. |
| `localDisplayed` | Local chat-frame insertion completed, not proof the player had the frame visible. |
| `emitted` | Compatibility field: successful dispatch or private insertion, never evidence of public delivery. |
| `outcome` | `local_displayed` for local Say, `local_fallback` for emotes routed privately, `public_unverified` for completed public dispatch, or the first rejection including `dispatch_failed`. |

`apiStatus=error` cannot distinguish an ordinary Lua error from a catchable
protected-action error. Notifications outside Lua and silent client rejection
remain unobservable. A successful AddMessage insertion also cannot prove the
chat frame was visible, selected, scrolled to the bottom or unobscured. Public
chat filtering must be checked separately in the player's chat-tab settings;
EMOTE is a message type, not a broadcast into the numbered General channel.

## Controlled client acceptance

1. Exit the game. Back up the current addon and SavedVariables. Replace only
   `Interface/AddOns/RPHelperForever` from
   `dist/RPHelperForever-0.9.0-emote-output-test.zip`. Do not delete SavedVariables.
   Record `GetBuildInfo()` by the usual client inspection method and record addon
   version, character, class, race, activity and chat-tab filters. This ZIP keeps
   Interface 16001 and version 0.9.0-prerelease.
2. Open the existing default chat frame and scroll to its newest messages. Save
   the original reaction/settings values. Enable RPHelper, temporarily disable
   encounter quota, disable unrelated combat-entry/exit reactions for isolation,
   and choose a known global cooldown. Leave Priority off for the timing check.
3. In Character Library → Shaman → Searing Totem, enable the event and set its
   chance override to 100%. Disable both existing Say entries
   (`default:ability:shaman:0045` and `0046`). Enable only existing Custom Emote
   `default:ability:shaman:0047`, weight 10. Do not create or rewrite content.
4. Run `/rph debug clear`, `/rph debug on`, wait out cooldown, then cast Searing
   Totem outside combat in the open world. Confirm ID 3599, class SHAMAN,
   ability SEARING_TOTEM, `eligible=1 selected=yes type=customemote` and the actual
   visible line:

   `[RPHelper] [Local only - Custom Emote] places a totem that launches bursts of fire at nearby foes.`

   Expect `outcome=local_fallback route=local apiStatus=completed`
   `localDisplayed=yes publicDelivery=not_attempted fallbackReason=world_policy`.
   This line is private. No native animation, public message or bubble is
   expected. Do not use `emitted=yes` as the acceptance criterion.
5. Cast again within the shared cooldown, then after expiry: expect cooldown
   rejection followed by one more private line. Stop capture with
   `/rph debug off`, then save `/rph debug show all` before reloading. A missing
   line with `localDisplayed=yes` requires checking frame visibility/scrolling;
   `dispatch_failed` requires saving API status and UI error evidence.
6. For ordinary Emote on the same Tauren Shaman, restore/enable Generic Dodge
   and set its chance to 100%. In that event's layered Library, temporarily
   disable every eligible entry except existing Tauren Emote LAUGH
   (`default:race:tauren:0017`); use weight 10. Disable unrelated reactions,
   clear/start debug, and safely enter combat against a suitable creature.
   Wait until a readable player DODGE arrives after cooldown. Expect
   `[RPHelper] [Local only - Emote] LAUGH`, a UNIT_COMBAT matched record,
   `type=emote outcome=local_fallback route=local localDisplayed=yes`.
   DODGE timing is stochastic; absence of a matched event is a detection result,
   not an output failure. Do not use the currently unsupported generic critical
   trigger for this test. Alternatively, on a Warrior, isolate the existing
   Battle Shout ROAR Emote (`default:ability:warrior:0009`) and cast its mapped
   rank, recording the actual spell ID and the same private-output fields.
7. For Say comparison, restore Searing Totem's first Say entry and disable its
   other entries. Wait cooldown and cast in the world: expect the original
   `[RPHelper] The flames shall find you!`, with `outcome=local_displayed`.
   In a five-player dungeon with dungeon Say routing public, repeat: expect
   `outcome=public_unverified route=public`; check actual chat and, where
   possible, a consenting nearby party member's observation. Switch dungeon
   Say routing local and confirm `local_displayed`. No new Say fallback exists.
8. Repeat isolated Custom Emote and normal Emote tests in a dungeon. A completed
   native attempt reports `publicDelivery=unverified`, even if nothing appears.
   An observable failure reports its primary status, `fallbackStatus=completed`,
   `outcome=local_fallback route=local`. Record ordinary PerformEmote behaviour
   and any duplicate private line: its return contract needs live verification.
   Do not respond to a block by rerunning scripts or trying another public API.
9. Restore a generic entry/exit reaction and verify normal chance/cooldown.
   Enable quota 1 and verify a successful private reaction consumes it like
   Say, while failed output does not. Test Priority's cooldown exemption without
   changing quota. Confirm raids and unsupported activity contexts suppress all
   output, including private fallback; a raid group outside an instance keeps
   world behaviour. Test Druid nonhumanoid Say suppression separately: emotes
   remain eligible but Say must not turn into fallback to evade suppression.
10. Save evidence, restore original settings and activation/weight values, and
    leave debug off. Reload/logout and confirm the existing character settings,
    IDs, custom content and weights persist. Diagnostics should reset disabled
    and empty. Verify another character's settings remain independent.

Actual Forever observation, public delivery, protected notifications and
SavedVariables disk persistence cannot be accepted by offline tests. Record
those results before considering this test build live-verified.
