# Licensing, attribution and redistribution audit

Audit date: 2026-10-23

Scope: repository state at `42fd249` (`main`) and the historical sources identified below

This is an evidence and risk audit for project planning. It is not legal advice,
a legal conclusion, a license grant, or a substitute for confirmation from the
relevant rights holders. In particular, attribution and public source
availability are evidence of lineage, not permission to copy, modify, or
redistribute a work.

## 1. Executive summary

RPHelper Forever's runtime, persistence, and user interface are a new
implementation in the current repository. The reaction catalogue is different:
its Git history, source headers, and prior reconciliation work show substantial
creative-text lineage through the Turtle WoW adaptation and RPHelper 2 to the
original RoleplayingHelper. The current organization, identifiers, corrections,
and some entries are Forever work, but many sayings, emotes, race/class pools,
ability reactions, and random-insult fragments are preserved or adapted upstream
material.

No `LICENSE`, `COPYING`, or `NOTICE` file and no explicit general grant of rights
was found in the Forever repository, the locally available Turtle adaptation, the
retrieved RPHelper 2 archive, or the recovered material from an older Turtle fork.
The evidence confirms historical publication and contributor acknowledgements;
it does **not** establish permission to redistribute or modify all inherited
material. GitHub also explains that a public repository without a license remains
subject to default copyright rules, apart from the limited GitHub Terms of
Service rights to view and fork it.

Accordingly, the available record does not yet establish clean redistribution
readiness for a package containing the inherited catalogue on GitHub Releases,
CurseForge, or another addon directory. CurseForge's current moderation policy
specifically requires a fork to be allowed by the upstream license and requires
license permission or explicit permission for other authors' copyrighted
content, together with credit. Existing attribution is valuable and should be
preserved, but it does not resolve that requirement.

The practical next decision is whether to seek written permission from the
relevant rights holders or to prepare an independently authored content set that
can be distributed without the unresolved catalogue. A separately scoped license
for original Forever code may be possible, but the project owner should not apply
a repository-wide license until the scope and ownership of mixed files have been
resolved. Counsel should review any legal characterization and the wording of any
future license or permission.

## 2. Project lineage and verified contributors

### Evidence standard

- **Verified** means directly supported by a file header, repository history,
  archived distribution metadata, or an attributable author statement.
- **Corroborated** means repeated across independent historical artefacts, but not
  necessarily proof of copyright ownership or permission.
- **Inferred** means the most reasonable technical explanation of the available
  record. An inference is not treated as a rights grant.

### Lineage

1. **Original RoleplayingHelper (2006 era).** The recovered historical material
   identifies Talyn as the original addon's TOC author. Current Forever and Turtle
   credits also name Overlord-Q as an original developer. The older fork's
   `credit.txt` calls Talyn the creator and names “mythik”, ArminAce, and Isjari as
   helpers. A contemporary original distribution and its complete legal metadata
   were not recovered, so original authorship details and permissions remain
   incomplete.
2. **RPHelper 2.** The official historical
   [WoWInterface listing](https://www.wowinterface.com/downloads/info9721-RoleplayingHelper2.html)
   attributes version 2.21 to Duerma. The retrieved archive's TOC names Duerma as
   author and credits Privelgus, Talyn and Overlord-Q, and mithyk. It retains
   reaction files and contributor headers from the earlier lineage. Publication
   on WoWInterface verifies distribution by Duerma, not a downstream license.
3. **Turtle WoW adaptation.** The locally available `RPhelper_twow` repository at
   commit [`0b0b1ef`](https://github.com/Wiubiki/RPhelper_twow/tree/0b0b1ef94aa7a664842fae7046c60305991234a0)
   identifies Wiubiki's Turtle WoW adaptation, credits Talyn, Overlord-Q, mithyk,
   and Duerma, and states that contributor history is difficult to reconstruct.
   An older public
   [TurtleRoleplayingHelper fork](https://github.com/vaaslite/TurtleRoleplayingHelper)
   identifies Vaaslite as modifier and Talyn as original author. These repositories
   corroborate lineage but contain no located general license grant.
4. **RPHelper Forever.** The current [README](../README.md) describes a new
   implementation inspired by the prior addons rather than a mechanical code
   port. Repository history supports that statement for the runtime architecture,
   UI, and persistence. Separate commits explicitly describe migration of generic
   Turtle content, addition of race/class/ability layers, and integration of the
   legacy random-insult system. The [ability reconciliation audit](audits/ability_catalogue_reconciliation.md)
   also records direct use of the Turtle English and localization files as
   historical content sources.

### Names preserved in the available record

| Person or alias | Verified or corroborated role | Limit of the evidence |
| --- | --- | --- |
| Talyn | Original TOC author/creator; original developer in later credits | No license or current contact/rights confirmation located. |
| Overlord-Q | Original developer in RPHelper 2, Turtle, and Forever credits | Role is corroborated, but not described in the recovered original TOC. |
| mithyk / “mythik” | Large body of default English reactions; named in generic, race, Rogue, and random-insult headers | Spelling varies historically; contribution does not itself identify the present rights holder or terms. |
| Syrsa | Named on generic and several race files; credited by Forever | Recovered sources do not contain a permission statement. |
| crashinbrn | Named in preserved Rogue lineage | Scope appears narrow; no permission statement located. |
| Duerma | RPHelper 2 author and historical distributor | Any permission Duerma could give may cover only Duerma's own contribution unless upstream authority is shown. |
| Privelgus | German translations credited by RPHelper 2 | Those translations are not identified as current Forever payload, but the credit is lineage evidence. |
| ArminAce and Isjari | German translation/help credits in older material | Those translations are not identified as current Forever payload; no grant located. |
| Vaaslite | Modifier/maintainer of an older Turtle fork | A later fork does not establish authority over earlier content. |
| Wiubiki | Turtle adaptation and Forever rewrite/project stewardship | Git history uses Wiubiki and Aristeidis Kypriotis with the same recorded email. Confirm the legal contributor identity before relying on this as ownership evidence. |

The recovered sources are not fully consistent: later credits name Talyn and
Overlord-Q, while the recovered original-style TOC names Talyn alone, and some
secondary descriptions assign a larger creator/maintainer role to Syrsa. This
audit preserves those differences rather than selecting a rights holder without
evidence.

## 3. File and content provenance matrix

The classifications describe provenance, not whether a particular element is
copyrightable. “Original Forever” means repository evidence supports creation in
this project; it does not replace contributor identity or assignment checks.

| Current material | Classification | Evidence and qualification | Confidence |
| --- | --- | --- | --- |
| `RPHelper/RPHelper.lua`, `RPHelper/Core/` | Original Forever implementation | Current architecture separates detection, selection, routing, schema-v2 storage, diagnostics, and adapters; no mechanically ported legacy runtime was identified. Concepts and catalogue semantics remain historically inspired. | High |
| `RPHelper/UI/` | Original Forever implementation | Character Library/editor, Guide, About, and widget structure were introduced in current repository history. About preserves historical credits. | High |
| SavedVariables/schema implementation in `RPHelper/Core/` | Original Forever implementation | Character-specific schema-v2 persistence, sparse overrides, and immutable built-ins are current designs documented by the [SavedVariables architecture](savedvariables_architecture.md). | High |
| `RPHelper/Data/Generic.lua` | Mixed: adapted/preserved prior creative content plus Forever structure and edits | Header names mithyk and Syrsa; commit `e6abcc0` explicitly says “Generic content migration from TWoW version.” Exact wording also overlaps the Turtle source. | High |
| `RPHelper/Data/Races/*.lua` | Mixed: adapted/preserved prior creative content plus Forever registration and edits | Race headers preserve mithyk and/or Syrsa where known; Turtle race files contain corresponding pools. Human has no named source contributor in the available header, so its granular authorship is uncertain. | High at layer level; mixed/uncertain per entry |
| `RPHelper/Data/Classes/*.lua` | Mixed: preserved or adapted prior class reactions plus Forever organization/edits | Current data was introduced as a class/ability content layer. Rogue names mithyk and crashinbrn; other current class files state that the legacy source carried no named contributor. | High at layer level; uncertain per entry |
| `RPHelper/Data/Abilities/*.lua` | Mixed: preserved upstream reactions, Forever canonical identities/formatting, and later reconciliation | Turtle class files supplied historical ability reactions. Rogue names mithyk and crashinbrn. Reconciliation added canonical definitions and repaired/archived data without making the inherited prose newly original. | High at layer level; mixed per entry |
| `RPHelper/Data/Abilities/*Archive.lua` | Preserved upstream creative content in a Forever archival representation | The archives retain historically authored but currently excluded/deferred reactions for provenance and review. Archiving does not create redistribution permission. | High |
| `RPHelper/Data/RandomInsults.lua` | Adapted/preserved prior creative content | Header attributes mithyk; implementation explicitly integrates the legacy `RINSULT` data and retains a note about a Shakespearean insult generator. The generator/word-list source and its terms were not identified. | High for immediate lineage; low for ultimate word-list source |
| Root README, `docs/*.md`, `docs/audits/*` and audit CSVs | Primarily original Forever documentation and research; some quoted/preserved lineage facts | Current specifications, inventories, and audits were authored for Forever. They reference upstream names, URLs, keys, and findings; the CSVs are evidence inventories, not grants of rights. | High |
| `.github/ISSUE_TEMPLATE/*.md`, `AGENTS.md` | Original Forever project workflow material | No upstream provenance indicator found. | High |
| Third-party libraries/assets in the distributable addon | None identified | Unlike the historical RPHelper 2 archive, Forever does not bundle Ace libraries. WoW/Blizzard names and APIs and external reference sites remain third-party references, not project-owned assets. | High for current tree |

The audit did not assign every individual reaction to a single author. The
historical sources themselves lack complete per-entry authorship, and current
files combine inherited wording with new identifiers, formatting, corrections,
or entries. A rights ledger will need entry- or source-batch granularity wherever
permission differs.

## 4. License and permissions evidence

### Confirmed evidence

| Source | Located evidence | What it establishes | What it does not establish |
| --- | --- | --- | --- |
| Forever repository | No license/notice file or explicit grant; README and Lua headers preserve credits | Current repository state and claimed lineage | Permission to reproduce, modify, redistribute, sublicense, or use commercially |
| Original RoleplayingHelper | Historical TOC/readme fragments and later credits | Existence, approximate distribution history, Talyn-era authorship evidence | Complete contributor set, governing terms, or a grant to later forks |
| RPHelper 2 | Official WoWInterface listing and archive; TOC author Duerma and credits | Duerma distributed RPHelper 2 and acknowledged earlier contributors | A license from the original contributors or permission for later redistribution |
| Turtle adaptation | Public repositories, readmes, content headers, and version history | Adaptation history and preservation of contributor names | A general license; authority of a later maintainer to license all earlier material |
| GitHub | [Official licensing guidance](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/licensing-a-repository) | GitHub states that without a license default copyright rules apply and public visibility/forking does not create general reuse rights | A conclusion about ownership of any RPHelper element |
| CurseForge | [Current moderation policies](https://support.curseforge.com/support/solutions/articles/9000197279) | Forking must be allowed by the upstream license; third-party copyrighted content requires applicable license permission or explicit permission and credit | Approval of this project or a determination of who owns its content |

No supporting source reviewed for the inherited RPHelper material stated an
explicit permission scope for redistribution, modification, commercial use,
sublicensing, or a required notice. That is missing evidence, not evidence of a
prohibition authored by a particular contributor. Likewise, no conflicting
license texts were located; the problem is absence and incomplete provenance,
not a demonstrated incompatibility between two grants.

### Unverified claims and limitations

- Later readmes imply that prior releases were found, ported, and publicly
  distributed. They do not say that each relevant contributor authorized those
  acts or under what terms.
- Public GitHub repositories and WoWInterface downloads demonstrate availability.
  They do not by themselves provide a downstream redistribution license.
- Credit strings are internally useful evidence and should remain intact. They do
  not say that attribution is the only condition for reuse.
- The original 2006-era download, author correspondence, and any license bundled
  outside the recovered fragments were unavailable. Web archives or personal
  records may contain evidence not reviewed here.
- The historical RPHelper 2 archive bundles Ace libraries, but their own licenses
  would apply only to those libraries. Forever does not bundle them, and their
  terms cannot grant rights to RPHelper reaction content.
- The Shakespearean insult-generator attribution is not specific enough to
  identify a source, author, edition, or license. That sub-source remains
  unresolved.

## 5. Outstanding questions and risks

1. Who presently controls rights in the original program and each major batch of
   English reaction text? Do Talyn, Overlord-Q, mithyk, Syrsa, and later authors
   retain those rights, or were any rights assigned?
2. Did original releases include a license, upload agreement, or author statement
   that is no longer present in the recovered copies?
3. Did Duerma, Vaaslite, or Wiubiki receive private permission, and if so did its
   scope cover modification, onward redistribution, multiple platforms,
   monetized/reward programs, and sublicensing?
4. Which current reactions were newly written for Forever, and under what
   contributor terms? Git commits show when files entered this repository but do
   not alone prove authorship of every embedded string.
5. What is the source and status of the Shakespearean insult word lists?
6. Does the project owner want a permissive, copyleft, source-available, or other
   treatment for the original Forever code? That policy choice cannot safely be
   applied to inherited content without a compatible grant.
7. Are any historical author aliases misspelled or shared? In particular,
   “mithyk” and “mythik” should be confirmed before contacting or crediting a
   legal identity.

The main practical risk is representing the complete repository or release
archive as reusable under a new license when the available evidence supports
that representation only for some material. Platform rejection or a later
copyright complaint is also possible. Questions about copyrightability of short
phrases, selection/arrangement, derivative works, and ownership require legal
advice; this technical audit does not resolve them.

## 6. Distribution readiness implications

| Distribution/use | Established | Unresolved implication |
| --- | --- | --- |
| Public GitHub source repository | The repository is already public and exposes its history and attribution. | Public visibility is not a reuse license. The owner should avoid a whole-repository license claim until mixed material is resolved. Existing publication does not cure missing permission evidence. |
| GitHub Releases | Forever can technically be packaged, and current code provenance is substantially documented. | A release archive would redistribute inherited reactions. Readiness is not established on the reviewed evidence. |
| CurseForge | Project lineage and credit can be disclosed. | Current policy calls for license permission or explicit permission for other authors' content and requires credit; that evidence is not yet available for the full catalogue. |
| Other addon directories | Historical platforms distributed earlier versions. | Each platform's current uploader terms must be checked at submission time. Older WoWInterface guidance likewise expected uploaders to hold copyright or permission; historical availability is not a safe substitute. |
| Inherited sayings and reactions | Immediate source lineage and several contributors are documented. | Modification and redistribution scope, ultimate ownership, and some per-entry authorship remain unresolved. |
| Original Forever code licensed separately | The architecture/runtime/UI/persistence appear separable in provenance from the creative catalogue. | Mixed files, package presentation, license scope/exclusions, contributor identity, and combination with uncleared content require deliberate drafting and preferably legal review. No new license is recommended by this audit. |
| Historical acknowledgements | README, About page, and file headers preserve substantial credit. | Credits are incomplete and occasionally inconsistent, but should be retained and corrected only from evidence. Permission, if obtained, may add mandatory wording rather than replace existing history. |

Until the rights evidence changes, “not established for public redistribution” is
the cautious readiness status for the **complete** addon package. That status is
not a legal conclusion that distribution is prohibited; it records that the
project cannot presently demonstrate the necessary grant.

## 7. Possible resolution paths

1. **Recover contemporaneous evidence.** Search archived original downloads,
   project pages, author correspondence, and local backups for a license or
   permission statement. Preserve the complete artefact, URL, retrieval date, and
   checksum rather than only a screenshot or paraphrase.
2. **Seek written permission from actual rights holders.** Contact the original
   and later contributors, recognizing that a porter can normally speak only for
   their own contribution unless they document broader authority. Ask explicitly
   about reproduction, modification, source and packaged distribution, GitHub,
   CurseForge and other directories, worldwide/non-exclusive scope, commercial
   platform or reward-program use, sublicensing under a proposed license, and
   required attribution/notices.
3. **Build a rights ledger.** Map each current reaction or defensible source batch
   to its source, author evidence, transformation, permission record, and allowed
   uses. Preserve permanent content identities while doing so; identity stability
   is independent of licensing status.
4. **Isolate unresolved material.** Design a distributable boundary in which
   uncleared catalogues are excluded or supplied separately only by a party with
   authority. This would be a later implementation/release task and must not be
   mistaken for permission to distribute the isolated files elsewhere.
5. **Replace inherited creative text.** Commission or accept independently
   authored reactions under written contribution terms, while retaining factual
   lineage acknowledgements. New contributors should affirm originality and the
   project's intended distribution/license scope.
6. **Consider code-only licensing.** After confirming contributors and obtaining
   advice, license only demonstrably original Forever code with explicit path and
   content exclusions. Avoid ambiguous repository-level badges or metadata that
   imply inherited material receives the same grant.
7. **Obtain legal review.** Have counsel assess the recovered evidence, mixed-file
   boundaries, short-phrase and compilation questions, contemplated platforms,
   and any proposed permission or license wording.

No inherited content should be removed merely on the basis of this audit. Any
isolation or replacement decision should be a separately reviewed milestone that
preserves provenance and acknowledgements.

## 8. Recommended next decisions for the project owner

1. Decide whether the preferred path is permissions-first, replacement-first, or
   a code-only interim distribution. Treat the current complete package as not
   yet demonstrated ready while that decision is open.
2. Authorize a contributor/contact register and nominate who will approach Talyn,
   Overlord-Q, mithyk, Syrsa, crashinbrn, Duerma, and other contributors whose
   material remains in scope. Do not assume one later maintainer can authorize
   all earlier work.
3. Choose the intended license policy for original Forever code **in principle**,
   then ask counsel to confirm its boundary and compatibility. Do not create a
   `LICENSE`, `COPYING`, or `NOTICE` file until that review and the rights ledger
   support the claim.
4. Decide whether a release may omit unresolved catalogue material if permissions
   cannot be obtained. Assess user experience, packaging, and preservation as a
   separate milestone; this audit makes no production change.
5. Require every future content contribution to include an explicit contribution
   and redistribution grant, authorship/provenance declaration, preferred credit,
   and confirmation regarding third-party or generated material.
6. Preserve the current README/About/file-header acknowledgements, and prepare a
   consolidated notice only after permissions specify the wording and placement.
7. Re-run this audit before GitHub Release or CurseForge submission, checking the
   platforms' then-current terms and attaching the permission evidence to the
   internal release checklist.

### Sources reviewed

- Current [RPHelper Forever README](../README.md), source headers, Git history,
  documentation, and historical audit inventories at commit `42fd249`.
- Local Turtle adaptation at `../RPhelper_twow`, commit `0b0b1ef`; public
  [repository snapshot](https://github.com/Wiubiki/RPhelper_twow/tree/0b0b1ef94aa7a664842fae7046c60305991234a0).
- [RPHelper 2 historical listing](https://www.wowinterface.com/downloads/info9721-RoleplayingHelper2.html)
  and its version 2.21 archive, inspected 2026-10-23.
- [TurtleRoleplayingHelper historical fork](https://github.com/vaaslite/TurtleRoleplayingHelper),
  including its readme, `credit.txt`, version history, and TOC, inspected
  2026-10-23.
- GitHub, [Licensing a repository](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/licensing-a-repository),
  inspected 2026-10-23.
- CurseForge, [Moderation policies](https://support.curseforge.com/support/solutions/articles/9000197279)
  and [copyright-claim guidance](https://support.curseforge.com/support/solutions/articles/9000222335-submitting-a-copyright-claim-on-curseforge),
  inspected 2026-10-23.
- Historical WoWInterface uploader discussions on
  [upload authority](https://www.wowinterface.com/forums/archive/index.php/t-23667.html)
  and [modified-addon permission](https://www.wowinterface.com/forums/showthread.php?t=46764),
  used only as platform-history context, not current terms or legal authority.
