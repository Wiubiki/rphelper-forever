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

## Installation

1. Visit the [RPHelper Forever Releases page](https://github.com/Wiubiki/rphelper-forever/releases/latest).
2. Download the addon ZIP file (`RPHelperForever-*.zip`) from the release's **Assets** section. **Do not download GitHub's automatically generated Source code ZIP.**
3. Extract the ZIP. It should contain a single folder named `RPHelperForever`.
4. With World of Warcraft Forever closed, copy that folder into your game's `Interface/AddOns/` directory.
5. Verify the resulting structure is `Interface/AddOns/RPHelperForever/RPHelperForever.toc`, without an additional nested folder.
6. Launch the game, confirm **RPHelper Forever** appears in the AddOns list, and enable it.
7. Log into your character and type `/rph` to open the addon.

**Updating:** Close the game and replace the existing `RPHelperForever` addon folder with the version from the new release. Do not delete your character's SavedVariables.

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
