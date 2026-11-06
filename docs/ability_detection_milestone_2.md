# Ability detection milestone 2: reviewed expansion

Date: 2026-11-06. Baseline: merged milestone 1 on `main`, `c3c4bab`.
Branch: `feat/broad-ability-mappings`. Implementation and test package await
review. No commit, push, merge, tag or release is authorized.

## Result and evidence tiers

Static detection expands from **4 abilities / 4 exact IDs** to **366 abilities /
1,168 exact IDs across all nine classes**. These are also 1,168 distinct numerical
IDs in this snapshot. The increase is 362 abilities and 1,164 IDs. Of the mapped
abilities, 232 have shipped reactions and 134 have empty shipped pools; an empty
pool needs character Custom content to produce output. Coverage is partial and
does not imply every rank or every ability can react in the current context.

| Class | Abilities before | IDs before | Abilities after | IDs after | With shipped reactions |
| --- | ---: | ---: | ---: | ---: | ---: |
| Druid | 0 | 0 | 42 | 165 | 9 |
| Hunter | 0 | 0 | 37 | 97 | 32 |
| Mage | 0 | 0 | 52 | 144 | 48 |
| Paladin | 2 | 2 | 47 | 146 | 40 |
| Priest | 0 | 0 | 37 | 148 | 33 |
| Rogue | 0 | 0 | 29 | 92 | 2 |
| Shaman | 2 | 2 | 50 | 169 | 42 |
| Warlock | 0 | 0 | 37 | 118 | 14 |
| Warrior | 0 | 0 | 35 | 89 | 12 |
| **Total** | **4** | **4** | **366** | **1,168** | **232** |

**A — directly observed: 2 IDs.** The owner reports milestone 1 live acceptance
on Forever Interface 16001 for player Shaman Lightning Shield **325** and Healing
Wave Rank 3 **547**, selection/emission, chance/shared cooldown, Library and
character settings after `/reload`. These are owner-reported RPHelper observations;
no raw capture files, exact build or complete context matrix were supplied. This
task performed no live client testing. Source rank metadata labels 325 as Rank 2;
the earlier owner's shield observation did not itself provide a rank label.

**B — reviewed Forever evidence: 1,166 IDs.** Numerical class/rank records agree
with a second class-spell source and the current class-book identity/mechanism,
without an unresolved activation/helper role for the selected ID. This includes
the original Paladin 19750/20288 observations, whose third-party status is
preserved. Neither those reports nor source/trainer verification is an RPHelper
live capture. All added ranks of the two Shaman abilities are B, not A.

**C — excluded from this detector: 490 review rows.** There are 472 exact numerical
class/ID exclusions and 18 identity-only rows with no defensible numeric candidate.
C describes mapping suitability, including deferred mechanisms; it does not mean
that a well-documented channel or passive does not exist in Forever.

## Per-ID review and source reconciliation

The [decision inventory](audits/ability_mapping_expansion_review.csv) has 1,658
rows covering all 474 current canonical abilities. Each row records class/key,
exact ID when known, rank/variant, A/B/C, inclusion/exclusion, mechanism, source
group/rank/cast evidence, current book anchor and exclusion reasons. Stable row
IDs match each production record's `reviewID`. The
[verification inventory](audits/ability_detection_verification_inventory.csv)
retains research candidates while recording exact implemented IDs separately.

The [source snapshot inventory](audits/ability_mapping_expansion_sources.csv)
records 13 downloaded source artifacts, retrieval date, sizes and SHA-256 values.
Raw extracts remain temporary research material, outside the addon and repository.

- [ForeverDB class/rank data](https://foreverdb.net/data/classes.json) supplies
  trainer groups and spell IDs from talent `sp`/rank fields. Talent node IDs are
  not spell IDs. Retained `src=sod` groups are not treated as learned abilities.
  The [full numeric index](https://foreverdb.net/data/spells.json) corroborates
  exact identities; its 32,109 records also include NPCs, effects and obsolete data.
- [Warcraft Forever's class-spell records](https://warcraftforever.games/spells)
  supply a second class/ID/rank association. `trained`, `verified` and
  `seenInCombat` have their source meanings; an untrained record is not claimed
  to be learned, and a recorder's verification is not RPHelper success evidence.
- [Daybreak's changed class-spell extract](https://daybreakforever.com/static/forever/datamine.json)
  identifies build **1.60.1.70790**, generated **2026-11-05 20:54 UTC**. Cast/rank
  fields and changed identities help exclude effects and conflicts. It omits
  unchanged spells, so absence alone is not removal evidence.
- The current [Forever class books](https://wowforevertalent.com/abilities/)
  were downloaded separately for all nine classes. Their HTML identifies client
  **1.60.1.70755**; metadata/tooltip groups provide names, rank labels, class/General
  placement and activation descriptions, not the numerical ID authority.

These community sources are not synchronized client builds or independent
guarantees of event delivery. Shared underlying client data can explain agreement.
Hashes identify the actual inspected snapshots rather than relying on mutable
links. Earlier repository beta reports establish the approved canonical keys and
historical context; they are not automatically promoted to current ID evidence.

For each current canonical identity, review considered the existing candidate
list and current exact-name class records. Names were compared only offline,
with punctuation/spacing normalization and the explicit Judgement/Judgment spelling
alias. No runtime name resolver was added. No mechanically different predecessor
was accepted merely because of a rename or similar theme.

The B inclusion rule requires a selected ID in an exact non-SoD ForeverDB
trainer/talent spell group, the same class/ID identity in Warcraft Forever, a
matching raw numeric record, and an ordinary active identity in the current
class book. Rank labels must not conflict across available numeric sources or
with the book. Changed-spell cast metadata must not contradict ordinary activation.
Every family was checked against the explicit mechanism exclusions below.
This is a conservative reviewed subset, not an import of the prior 1,634 IDs.

The second numerical source may lack a recorded learned/trained observation.
That limitation remains visible in the CSV. Such agreement supports B identity
review; live learnability, success-ID delivery/readability and output remain
acceptance work. When the evidence failed the inclusion rule, even plausible
abilities such as Warrior Taunt or some player summons were left out rather
than loosening the rule to raise the total.

## Exclusions and partial ranks

All explicit exclusions are in the CSV, including absent or disputed identities.
Notable cases:

- Channels, Druid forms, Warrior stances, Ghost Wolf/Shadowform, queued attacks
  such as Maul/Raptor Strike/Heroic Strike/Cleave, auto-repeat, passives and procs
  remain excluded. Pet-owned attacks never become player casts.
- Ground reticle abilities such as Flamestrike, Flare/Enchanted Flare and Distract,
  tracking modes, remote-view skills, Sentry Totem sight toggles and cooperative
  Ritual of Summoning semantics remain deferred.
- Mutilate's hand/helper variants and disagreeing rank families stay C. Ferocious
  Bite's numeric-source rank disagreement also prevents inclusion in this pass.
- Holy Light/Flash of Light helper IDs and Lightning Bolt instant proc copies
  are not promoted from names. Ordinary trainer ranks are included individually
  where the selected exact ID meets the rule; the excluded variants remain listed.
- Seal of Righteousness alternatives **20154/21084** remain excluded because the
  rank-1 identity conflict is unresolved. Existing **20288** and separately
  reviewed other ranks remain mapped. One accepted rank never approves its peers.
- Current books rename/rework Totemic Projection as Totemic Call. This task
  does not invent equivalence, rename the canonical key, migrate settings or
  enable the former reticle mechanic. Returned/changed talents and absent old
  Blessings are likewise reviewed against current identity before any mapping.
- Priest racial variants, poison creation/application distinctions and other
  incomplete identity evidence remain C where the exact active ID was not clear.
  Universal Fear Ward/Devouring Plague are treated as their current class abilities.

Talent seeds do not implicitly approve higher ranks. Examples such as Arcane
Blast, Ice Lance and Bloodthirst intentionally have partial reviewed coverage.
Sources can expose different rank sets; missing ranks remain safely unmapped.
The review inventory is the exact authority for what this build includes.

## Implementation and preserved behaviour

`Data/AbilitySpellMappings.lua` remains the single mapping module. Class sections
group explicit `{ ID, rank }` entries under each canonical ability. A small data
helper expands these literal entries into the existing validated record list;
there are no ranges, inferred ranks, runtime discoveries or downloaded data.
Records carry `evidenceTier`, truthful `evidence`, `evidenceRef`, rank metadata and
the stable review row ID. The validator accepts reviewed B evidence and rejects
an A/B tier inconsistent with its evidence type.

The module still loads after all canonical definitions, validates once and
publishes the same class/ID index atomically. Duplicate/conflicting records and
invalid data fail closed. Splitting the grouped data into nine loading modules
was unnecessary; the TOC/order and packaging file inventory remain unchanged.

`RuntimeAPI.lua`, `Runtime.lua`, selection/eligibility, output, diagnostics,
configuration and persistence code are unchanged. Master/per-event switches,
chance replacement, Priority, shared cooldown, quota, weights, Druid Say
suppression, world/dungeon/raid routing and character sovereignty retain their
existing policies. Library support follows the shared mapping index with its
existing **Detected: mapped IDs only** wording. Empty pools do not produce a
reaction until eligible Custom content exists. Target-dependent content can
remain ineligible because this increment does not establish cast-target context.

## Validation and package

All **341 Lua tests** and **14 Python tests** pass. Coverage checks every included
ID, every numerical exclusion, exact class scoping, multiple real ranks, invalid
mapping records, restricted/malformed payloads, A/B qualifications, all mapped
Library groups (including empty pools with Custom fixtures), and ordinary dispatch
samples across all nine classes. Existing policy, diagnostic, manifest/startup,
schema, content and packaging regressions pass. Syntax checks cover 65 Lua and
five Python files. Canonical export and whitespace checks pass.

Reaction source files, permanent IDs/text/types/order/choices and `reactions.csv`
are unchanged. Canonical event exports update only runtime mapping/support
metadata and the derived unsupported-detector summary.

```sh
python3 scripts/package_addon.py build --output dist/RPHelperForever-0.9.0-mapping-expanded-test.zip
python3 scripts/package_addon.py validate dist/RPHelperForever-0.9.0-mapping-expanded-test.zip
```

The deterministic ZIP retains the unchanged `0.9.0-prerelease` TOC version,
Interface 16001, one installable `RPHelperForever/` root and 55 required files,
including the existing three distribution notices. Repository docs, CSVs,
tests, scripts and Git metadata are excluded. `dist/` and `tmp/` remain ignored.
The full diff, package checksum/size/contents and verification results are in
`tmp/review.txt`.

## Recommended live samples

Use the [milestone 1 acceptance procedure](ability_detection_milestone_1.md#live-client-acceptance):
save settings, replace only the addon folder with the game closed, record actual
build/rank/context, confirm debug status, and collect short master-off captures
before enabling 100% per-ability chance with sufficient cooldown separation and
eligible content. Start with world-local Say. Record evidence separately for each
B ID; do not label its whole family live-tested.

| Class | Suggested exact sample | Purpose |
| --- | --- | --- |
| Druid | Challenging Roar 5209 | Ordinary activation while form speech suppression remains intact; use its eligible emote. |
| Hunter | Concussive Shot 5116 | Ordinary shot; queued Raptor Strike must stay unmapped. |
| Mage | Fireball 133, then another reviewed learned rank such as 143 | Exact cast/rank resolution without helper or outcome inference. |
| Paladin | Holy Light 635 or 647; retain 19750/20288 baselines | New B cast plus existing mappings; do not use excluded rank-1 Seal alternatives. |
| Priest | Flash Heal 2061 | Heal activation; Penance/Mind Flay remain excluded channels. |
| Rogue | Sprint 2983 | Existing target-independent content; other mapped empty abilities need Custom content. |
| Shaman | Existing 325/547, then learned 324 or 331/332 | Preserve accepted A paths while testing other ranks as B. |
| Warlock | Fear 5782 | Low-level B activation with target-independent Say; verify channels and pet-owned casts cannot react. |
| Warrior | Bloodrage 2687, then Charge 100 for classification | Manual activations; stance changes and queued Heroic Strike remain unmapped. |

For each sample require exact `player` attribution, `result=mapped`, canonical
ability, and the expected downstream outcome. Test cancellation/interruption,
disabled switches/chance, cooldown/Priority/quota, intended combat contexts and
actual visible routing. An eligible pool is required for `emitted=yes`; mapping
alone does not promise output. Verify existing generic reactions and settings/
Custom content after `/reload`. No restricted-value workaround or fallback is
authorized if a B ID proves unreadable, differently attributed or incompatible.
