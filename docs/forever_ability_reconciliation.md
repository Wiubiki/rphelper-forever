# Forever ability reconciliation

Milestone 2B defines how the inherited RPHelper ability catalogue will be
reconciled with the WoW Forever beta. It records review policy only; it does not
authorize catalogue or runtime changes.

## Sources and objective

The provisional primary reference is the [Forever beta spellbook](https://wowforevertalent.com/).
Each reconciliation pass should record the source date, available client build
and known limitations. Beta evidence is provisionally authoritative, not
permanent or infallible. Official Blizzard announcements and existing project
research should supplement it when evidence is ambiguous.

The comparison baseline is RPHelper's existing 465 canonical abilities across
nine classes. This catalogue contains historical material inherited from earlier
RPHelper versions, including potentially obsolete or non-Forever abilities. Its
existing `say`, `emote` and `customemote` reactions must remain recoverable
throughout reconciliation.

The objective is to make the active catalogue represent the current Forever
beta rather than historical RPHelper content.

## Eligibility and classification

Include abilities that require direct player activation, whether instant,
cast-time or channelled, and whether trainer-learned, baseline or talent-granted.
Exclude passive talents, automatic procs and effects that require no direct
player activation. Catalogue inclusion does not mean runtime detection exists or
has been verified.

For v1, the primary reconciliation scope is player-activated abilities from the
class-specific spellbook tabs. The **General** tab is excluded by default, even
for technically player-activated entries such as Attack. Individual General
abilities may be considered later as explicit, spell-by-spell exceptions;
possible examples include Hunter Feed Pet and Rogue poison-related actions where
applicable. General entries should remain visible in research inventories when
the source provides them, but must not be promoted automatically into class
catalogues. This is a product scope boundary, not evidence that a General
ability is absent from Forever. The direct-activation eligibility rules above
continue to apply unchanged to class-specific spells.

Classify each reviewed identity as one of:

- **Confirmed in Forever beta:** eligible active ability found in the reference
  spellbook.
- **Not found in Forever beta:** historical RPHelper ability absent from the
  reference. Absence is not proof of permanent removal.
- **Rename/replacement candidate:** possible renamed identity or mechanical
  successor requiring explicit review.
- **Unresolved:** insufficient or conflicting evidence.

## Intended catalogue structure

After review and separate implementation approval, each
`Data/Abilities/<Class>.lua` file should have two sections:

1. **Confirmed in Forever Beta**, containing active catalogue registrations.
2. **Not Found in Forever Beta — legacy content pending review**, retaining
   historical authored content without registering active reactions.

This is an intended structure, not an instruction to reorganize files in
Milestone 2B. Existing content must remain recoverable until deletion or
migration is explicitly reviewed and approved. A confirmed ability remains a
valid catalogue identity without bundled reactions; do not add empty reaction
strings as placeholders.

## Identity and customization preservation

Preserve existing reactions, user-defined content and settings. Never transfer
content automatically between mechanically different abilities. Renames require
an explicit identity mapping and compatibility review. Before changing canonical
keys, inspect SavedVariables and customization handling rather than assuming the
change is safe.

Use Shaman as the first reconciliation pilot. Examples for review include:

- **Ancestral Spirit:** existing confirmed ability with authored content.
- **Astral Recall:** confirmed ability whose reaction coverage needs review.
- **Hex:** suspected legacy-only ability pending verification.
- **Fire Nova Totem → Fire Nova:** mechanical replacement, not an automatic
  content migration.
- **Curse of Agony → Bane of Agony:** officially documented rename requiring
  compatibility handling.

These examples do not authorize catalogue changes.

## Runtime boundary

Milestone 2B does not authorize new production spell-ID mappings, changes to
spellcasting detection, automatic enabling of newly catalogued abilities, or
changes to output routing, probabilities or cooldown policies. Candidate spell
IDs and verification evidence belong in research documentation until separately
approved for implementation.
