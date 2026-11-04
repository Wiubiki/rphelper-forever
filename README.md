# RPHelper Forever

RPHelper Forever is a roleplaying addon for World of Warcraft: Forever that adds contextual flavour through triggered sayings and emotes.

The project carries forward the spirit of the original RoleplayingHelper addon. I began by adapting and porting that older addon for [Turtle WoW](https://github.com/Wiubiki/RPhelper_twow), including compatibility work for Turtle-specific races and abilities. RPHelper Forever is a new implementation for the modern WoW addon environment rather than a direct code port.

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

1. Extract `RPHelperForever-0.9.0-prerelease.zip`. It contains one folder named
   `RPHelperForever`.
2. With the game closed, place that folder under the Forever client's addon
   directory, illustrated as `<WoW Forever installation>/Interface/AddOns/`.
   Use the installation location reported by the client or launcher rather than
   assuming a platform-specific path.
3. Check that the result is `Interface/AddOns/RPHelperForever/RPHelperForever.toc`. Do not leave
   an extra wrapper such as `Interface/AddOns/RPHelperForever/RPHelperForever/RPHelperForever.toc`.
4. Start the client and confirm RPHelper Forever appears in the character-screen addon
   list. This prerelease still requires live verification of the correct client
   Interface metadata; if it is marked incompatible or absent, report the client
   build rather than substituting another WoW flavor.
5. Log in and use `/rph` to open the addon window.

For an update, close the game and replace the installed `RPHelperForever` addon
folder. The addon still appears as **RPHelper Forever** in the game.

If updating a prerelease installed as `RPHelper` or `RPHelper Forever`, back up
each character's SavedVariables first. In that character's actual SavedVariables
directory, copy the old `RPHelper.lua` or `RPHelper Forever.lua` save file to
`RPHelperForever.lua` before starting the renamed addon. Keep the `RPHelperDB`
table inside unchanged. If a destination file already exists, back up both and
choose which character data to retain rather than overwriting it blindly.
Remove the old addon program folder so only `RPHelperForever` loads; retain your
save-file backups. The namespace, reaction IDs, and schema-v2 data are unchanged.
See [SavedVariables compatibility](docs/savedvariables_architecture.md#addon-identity-and-filename-compatibility)
for the filename convention and required live-client checks.

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
