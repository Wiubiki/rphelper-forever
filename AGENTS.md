# About RPHelper Forever

RPHelper Forever is a World of Warcraft Forever roleplaying addon.

Its purpose is to add occasional contextual character reactions to gameplay through:

- spoken sayings
- Blizzard emotes
- custom `/e` emotes
- local-only RP messages where public chat automation is restricted

The addon is designed to provide flavour without becoming spammy.

RPHelper Forever is a new implementation inspired by the original RoleplayingHelper (for the original classic WoW and TBC versions) addon and the later RPhelper_twow adaptation for the private Turtle WoW server (a classic+ implementation of the classic game). The legacy Turtle WoW repository is used as a source of content, concepts, and historical reference, not as code to port mechanically.

WoW Forever uses the modern WoW addon environment, so legacy APIs, event handling, chat behaviour, and combat information must not be assumed to remain valid.


# RPHelper Forever Agent Instructions

## Repository workflow

- Work on feature/documentation branches, not directly on `main`.
- Do not commit, push, merge, or modify remote branches unless explicitly instructed.
- Before handing work back for review:
  - run `git diff --check`
  - write the full diff to `tmp/review.txt`
- `tmp/review.txt` is review-only and must not be included in commits.

## Scope and design sources

Use the repository documentation as the source of truth:

- `docs/product_spec.md` for product behaviour and V1 scope.
- `docs/content_engine.md` for keywords, templates, content eligibility, and reactive trigger semantics.

Read only the documentation relevant to the task; do not load the entire docs tree by default.

## Legacy RPHelper source

The sibling repository:

`../RPhelper_twow/`

is read-only reference material.

Useful sources include:

- `English/ANY.lua`
- race and class files under `English/`
- `RInsult.lua`
- `How to Customize.txt`
- `RPhelper_twow_ReplaceKeywords.lua`

Do not modify the legacy repository.
Do not mechanically copy legacy code or content.
Preserve useful content lineage and contributor attribution.

## Content architecture

Content layers are:

1. Generic
2. Race
3. Class
4. Exceptional race/class combination
5. User custom content

Personality may become a future layer.

Do not create race/class combination files for every valid pairing.

## Content conventions

Content types:

- `say` = spoken dialogue
- `emote` = Blizzard built-in emote
- `customemote` = free-text `/e` style content

Generic content should be broadly applicable.
Race/class-specific flavour belongs in the appropriate layer.
Occasional comic material is welcome, but generic content should not become predominantly comedic.

The generic `youcrit` trigger covers offensive critical hits from melee, ranged attacks, and damaging spells. It does not cover healing criticals.

## WoW Forever assumptions

Do not assume legacy WoW APIs or event behaviour remain valid.

Anything dependent on:
- combat-event payloads
- target/enemy identity
- secret/restricted values
- monster emotes
- chat-channel restrictions
- secure/hardware-event behaviour

must remain explicitly testable until verified in WoW Forever.

Do not attempt to work around Blizzard restrictions.

## Implementation discipline

Prefer small, focused changes.
Do not redesign unrelated systems while completing a scoped task.
Do not introduce infrastructure merely because it may be useful later.
Preserve separation between:
- trigger detection
- content selection/generation
- output routing