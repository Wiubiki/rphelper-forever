# v0.9 prerelease preparation checklist

This checklist prepares a future release; it does not authorize publication.

## Build and verify

- [ ] Start from the reviewed release revision with a clean working tree.
- [ ] Run all Lua suites, including `lua tests/test_manifest_startup.lua`.
- [ ] Run `find RPHelper tests -type f -name '*.lua' -print0 | xargs -0 luac -p`.
- [ ] Run `python3 scripts/package_addon.py build`.
- [ ] Run `python3 scripts/package_addon.py validate`.
- [ ] Record the filename, byte size, SHA-256, and 54-member inventory.
- [ ] Confirm a repeated build reports `unchanged` and retains the same hash.
- [ ] Inspect the extracted shape: `RPHelper/RPHelper.toc`, never a nested second
  `RPHelper` folder.

Expected filename: `RPHelper-0.9.0-prerelease.zip`.

## Blocking compatibility and rights checks

- [ ] Obtain the correct current Forever Interface value from the actual
  supported client; add and test it in a separately reviewed TOC change.
- [ ] Complete the live-client checks listed in the
  [Milestone 5A audit](audits/milestone_5a_offline_integration_audit.md), including
  addon recognition, event delivery, output permission, forms, activity routing,
  UI behavior, and SavedVariables reload/logout persistence.
- [ ] Confirm the tested client version matches the intended distribution target.
- [ ] Review [content rights](../CONTENT_RIGHTS.txt), [credits](../CREDITS.txt), and
  the [licensing audit](licensing_and_attribution_audit.md) before public
  distribution; do not represent inherited catalogue text as MIT-licensed.
- [ ] Perform a clean manual install and an update-over-existing-install check
  without deleting per-character SavedVariables.

## GitHub Releases

- [ ] Use a prerelease, not a stable V1.0 release.
- [ ] Attach the exact validated `RPHelper-0.9.0-prerelease.zip`.
- [ ] Verify the uploaded asset's SHA-256 against the local validated archive.
- [ ] Add short release notes and the confirmed client target; do not claim
  broader compatibility.
- [ ] Create a release/tag only in the separately authorized publication task.

## CurseForge

- [ ] Reconfirm the upload form offers flavor **Forever** and select only the
  live-tested Forever game version. Do not substitute another WoW flavor.
- [ ] Select **Beta** for the v0.9 prerelease unless the owner deliberately chooses
  the more limited Alpha channel after reviewing current platform behavior.
- [ ] Use a unique display name such as `RPHelper 0.9.0 prerelease`.
- [ ] Add a concise changelog; do not reuse an unchanged file as a new update.
- [ ] Set manual release timing if the file should remain held after moderation.
- [ ] Confirm project name, English summary/description, relevant addon category,
  logo, source link, issue link, and scoped license explanation.
- [ ] Treat technical validation and moderation approval as separate gates.

See [CurseForge readiness](curseforge_readiness.md) for current evidence and the
unresolved Interface requirement.

## Short changelog draft

RPHelper Forever 0.9.0 prerelease prepares the new implementation for controlled
WoW Forever client verification. It includes contextual reactions, per-character
schema-v2 settings, the Character Library/editor, Guide/About pages, and opt-in
session diagnostics. Runtime detection remains intentionally limited to the
documented generic triggers and two mapped Paladin abilities. This is not the
V1.0 stable release.

## Launch-day checks

- [ ] Re-run package validation immediately before upload.
- [ ] Recheck the platform's Forever flavor/version choice and release-type text.
- [ ] Test the downloaded asset, not only the local source archive.
- [ ] Confirm installation instructions, project links, changelog, and known
  prerelease limitations are visible.
- [ ] Monitor moderation feedback and initial client reports without silently
  changing compatibility or rights claims.
