# RPHelper

RPHelper is a roleplaying addon for World of Warcraft: Forever that adds contextual flavour through triggered sayings and emotes.

The project carries forward the spirit of the original RoleplayingHelper addon. Development by Wiubiki began by adapting and porting that older addon for Turtle WoW, including compatibility work for Turtle-specific races and abilities. RPHelper for WoW Forever is a new implementation for the modern WoW addon environment rather than a direct code port.

## Goals

- Add occasional, contextual roleplaying flavour without chat spam.
- Support generic, race-specific, class-specific, and ability-specific content.
- Preserve user settings and custom content safely across addon updates.
- Keep shipped defaults separate from user-authored content.
- Prefer a small, reliable V1 over broad but fragile automation.

## Project status

v0.9 prerelease, intended for controlled live testing in WoW Forever. The
game-integration layer has deterministic mocked coverage but is not yet fully
verified in the live client, and this is not a V1.0-stable release.

## Installation

1. Extract `RPHelper-0.9.0-prerelease.zip`. It contains one folder named
   `RPHelper`.
2. With the game closed, place that folder under the Forever client's addon
   directory, illustrated as `<WoW Forever installation>/Interface/AddOns/`.
   Use the installation location reported by the client or launcher rather than
   assuming a platform-specific path.
3. Check that the result is `Interface/AddOns/RPHelper/RPHelper.toc`. Do not leave
   an extra wrapper such as `Interface/AddOns/RPHelper/RPHelper/RPHelper.toc`.
4. Start the client and confirm RPHelper appears in the character-screen addon
   list. This prerelease still requires live verification of the correct client
   Interface metadata; if it is marked incompatible or absent, report the client
   build rather than substituting another WoW flavor.
5. Log in and use `/rph` to open the addon window.

For an update, close the game and replace the installed `RPHelper` addon folder.
Do not intentionally delete the client's per-character SavedVariables. Those are
stored separately from the addon program files; back them up before prerelease
testing when their exact Forever location has been confirmed.

## Origins, Credits and Licensing

RPHelper Forever is a new implementation inspired by the original
RoleplayingHelper and retains elements of its historical reaction catalogue.
Known original authors, contributors, and community adaptations are acknowledged
in [CREDITS.txt](CREDITS.txt); no endorsement by those contributors is implied.

Independently authored Forever software code is released under the
[MIT License](LICENSE). Inherited creative reaction content is excluded from
that grant. See [CONTENT_RIGHTS.txt](CONTENT_RIGHTS.txt) for the exact scope and
[LEGACY_CONTENT.txt](LEGACY_CONTENT.txt) for the reference inventory.


---
[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/V7V71A0D8Q)
