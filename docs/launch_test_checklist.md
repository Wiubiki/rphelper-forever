# RPHelper Forever launch-session checklist

Use this beside the game with the full [live-client verification guide](live_client_verification.md).
The time labels are priority groups, not duration promises. Record each item as
Pass, Fail, or Not testable; stop if the missing `## Interface` metadata blocks
normal loading.

## First 10–15 minutes

- [ ] Record Forever version/build, full `GetBuildInfo()` evidence, numeric
  Interface value, and exact addon directory (A01).
- [ ] Confirm `Interface/AddOns/RPHelper/RPHelper.toc`, with no nested duplicate
  folder (A02).
- [ ] Find RPHelper `0.9.0-prerelease` in the character-screen addon list; record
  any incompatible/missing status without forcing it to load (A03).
- [ ] Log in with no Lua/load error; use `/rph` to open and close the UI (A04).
- [ ] Run `/rph help`; open Main, Guide, About, and Character Library (A05/B03).
- [ ] Run `/rph debug help`, `status`, and `show`; confirm fresh diagnostics are
  disabled and empty (A05/E01).
- [ ] Check defaults: enabled, chance 5%, cooldown 20s, quota off/max 2, dungeon
  Say broadcast (B01).

## First gameplay session

- [ ] Make a distinctive setting and Library change; verify it survives
  `/reload` and diagnostics reset (B02/B04/B08).
- [ ] Create and privately preview a Custom reaction; confirm no preview is
  publicly transmitted (B05).
- [ ] Enable diagnostics and capture combat entry and exit (C01/C02).
- [ ] When naturally available, capture player Dodge, Parry, and direct Block;
  keep event delivery separate from output success (C03–C05).
- [ ] Check chance 0% prevents output; use a 100% event override for controlled
  routing tests (D01).
- [ ] Check the 5-second cooldown with quota off (D02).
- [ ] Check quota maximum 1 within one encounter and reset on the next (D03).
- [ ] Confirm an open-world Say is `[RPHelper]` local display only (D07).
- [ ] Confirm one native Emote and one Custom Emote route only when permitted
  (D07).
- [ ] Save concise evidence using the Phase E report template; do not spam public
  channels.

## Conditional later checks

- [ ] Same-character logout/login persistence (B09).
- [ ] Second-character isolation (B10).
- [ ] Program-folder replacement without deleting SavedVariables (B11).
- [ ] Five-player dungeon `/say` versus local setting; no `PARTY` route (D08/D09).
- [ ] Raid suppresses Say, Emote, and Custom Emote (D10).
- [ ] Priority bypasses only cooldown and does not reset it (D04).
- [ ] Disabled Built-ins and weighted selection over repeated events (D05/D06).
- [ ] Paladin exact spell IDs `19750` and `20288`; other IDs unmapped (C06/C07).
- [ ] Druid humanoid versus known shapeshift Say behavior (D12).
- [ ] Naturally observed unknown activity or Druid form state fails closed; do
  not manufacture restricted states (D11/D13).
- [ ] Replace addon files from the same validated ZIP and confirm character data
  remains (B11).

Before finishing, run `/rph debug show`, copy only relevant records, note whether
the issue survives `/reload`, and restore ordinary settings.
