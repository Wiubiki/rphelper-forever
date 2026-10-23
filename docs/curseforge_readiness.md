# CurseForge readiness

**Reviewed:** 2026-10-23

This is a distribution-readiness record, not evidence of client compatibility,
platform approval, or publication. No CurseForge login, project, or upload was
used in this review.

## Package and TOC processing

CurseForge's official project-submission guidance requires an actual ZIP upload
for most games, with a maximum size below 2 GB. Its World of Warcraft guidance
also says the TOC name must begin with the parent addon-folder name and that each
TOC needs an Interface number identifying its WoW flavor.

The local package satisfies the structural part of that guidance:

- one archive root, `RPHelper/`;
- `RPHelper/RPHelper.toc` with matching name and capitalization;
- every manifest-declared Lua file and no development files;
- deterministic ZIP metadata and ordering; and
- license, credits, and content-rights notices under
  `RPHelper/Documentation/`.

`LEGACY_CONTENT.txt` remains the repository-side detailed inventory: it is not
needed by the client and the packaged scope/credit notices identify it for
maintainer review. Historical RPHelper 2 distributions, archived/deferred Lua
catalogues, tests, audits, and packaging tools are not included.

The current TOC has **no `## Interface` field**. This is a confirmed readiness
gap under CurseForge's published WoW guidance and an unresolved live-client
bootstrap issue already recorded by the project. The package deliberately
preserves the source TOC: this milestone does not invent an Interface value or
add flavor-specific TOCs. Establish the value from the supported Forever client,
then make and test that metadata change in a separate task before upload.

Sources:

- [Creating and Submitting a Project](https://support.curseforge.com/support/solutions/articles/9000197241-creating-and-submitting-a-project)
- [Multi-TOC for World of Warcraft Addons](https://support.curseforge.com/support/solutions/articles/9000209856)

## Forever flavor and game version

CurseForge currently exposes an explicit **Forever** flavor. Public addon pages
also show **1.60.1** as a WoW Forever game version; for example, the current
[World of Tools listing](https://www.curseforge.com/wow/addons/world-of-tools)
shows both values. This confirms that the platform has a Forever-specific
classification and that substituting Retail, Classic Era, or another flavor is
unnecessary.

It does not prove RPHelper works with Forever 1.60.1. Before submission, verify
the upload form still offers Forever and the client version actually used for
RPHelper's live tests. Select only the verified Forever version; do not select a
different flavor to make a file eligible. The author upload form was not opened
because no account action was authorized.

## File submission metadata

Official guidance identifies these file-upload fields:

- ZIP file;
- optional display name;
- release type;
- changelog;
- supported game version or versions;
- related projects/dependencies, when applicable; and
- automatic or manual release timing.

`RPHelper-0.9.0-prerelease.zip` is the proposed upload filename and can also be
the GitHub Releases asset name. A short unique display name such as
`RPHelper 0.9.0 prerelease` is sufficient; CurseForge does not require a custom
display name. The reviewed official guidance does not prescribe a separate WoW
archive filename pattern; it says the uploaded filename becomes the default
project-file name.

The project is explicitly a prerelease. **Beta** is the recommended CurseForge
file type after the Interface and live-client gates are closed: current official
guidance describes Beta files as opt-in for app users, while Release files are
the default download. Alpha remains available if the owner decides the first
client build is too provisional for Beta. Do not label this file Release or
V1.0 stable.

The upload must include a concise changelog. Suggested scope:

- first RPHelper Forever v0.9 prerelease for controlled client verification;
- contextual reactions, per-character schema-v2 settings, Character Library,
  Guide/About, and opt-in session diagnostics; and
- known limitation that only the documented generic triggers and two Paladin
  abilities are runtime-mapped.

Source: [File & Project Types and Additional Fields](https://support.curseforge.com/support/solutions/articles/9000197242).

## Project metadata and moderation

Project creation requires a name, English summary and description, license
selection, class/category, and logo; source and issue links can be added after
creation. File and project submissions enter platform moderation, and technical
ZIP compliance does not guarantee approval.

The project page's license presentation must reflect the repository's scoped
position rather than implying the full reaction catalogue is MIT-licensed. Use
[content rights](../CONTENT_RIGHTS.txt), [credits](../CREDITS.txt), and the dated
[licensing audit](licensing_and_attribution_audit.md) when preparing that text.
This packaging milestone does not resolve or recharacterize historical
redistribution permissions.

Source: [Project Submission Guide and Tips](https://support.curseforge.com/support/solutions/articles/9000199552-project-submission-guide-and-tips).

## Readiness conclusion

The generated ZIP is structurally suitable for local installation and for use
as a GitHub Releases asset. CurseForge submission is **not yet ready** because
the verified Forever Interface value is absent and live-client compatibility is
not established. Rights-scope review and platform moderation also remain owner
and platform decisions. See the [release checklist](release_checklist.md).
