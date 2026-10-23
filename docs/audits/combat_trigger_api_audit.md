# Combat trigger API audit

Audited 2026-10-11 on `feat/combat-triggers`. The research below distinguishes
documentation, third-party observations, and pending live tests. The approved
defensive implementation now accompanies this audit; its status is recorded below.

## Implementation status

Implemented with deterministic mocked verification; **live Forever verification
is still pending** for registration, payload readability, attribution, delivery
ordering, and coverage. The required live-client tests below remain outstanding.

- `RuntimeAPI.ClassifyUnitCombat` maps only exact readable `player` with
  DODGE/PARRY/direct BLOCK. It checks `issecretvalue` successfully returns false
  for both required fields before type checks or comparisons. Missing, throwing,
  or invalid inspection results reject detection. Unused fields are not inspected.
- `RuntimeAPI.RegisterDefensiveEvents` protects ordinary UNIT_COMBAT registration.
  Failure disables event detection without preventing combat-transition registration.
- The addon frame forwards payloads to `Runtime.HandleEvent`; it accepts defensive
  events only during an active encounter with successful registration, then calls
  `Runtime.HandleTrigger`. Direct defensive trigger attempts also require combat.
- Existing settings, chance/frequency, cooldowns, encounter quota, preparation,
  Druid safeguards, and output routing remain the policy path. No extra deduplication,
  partial-block flags, offensive criticals, or fallback event sources were added.
- Runtime tests exercise the real classifier with mocked inspection and registration,
  including rejection, unused secret fields, policy consumption, failed dispatch,
  encounter boundaries, frame forwarding, and continued combat transitions on failure.
  Ordinary Lua mocks cannot reproduce the client's actual secret-value enforcement.

Validation: 47 runtime tests and 53 content-engine tests pass; all repository Lua
files pass syntax checks. No live-client tests have been completed by this work.

## Recommendation

Proceed toward a narrowly scoped defensive milestone using `UNIT_COMBAT` for
`dodge`, `parry`, and direct `block` reactions, with live verification before
claiming Forever support. Keep `youcrit` deferred: the inspected contracts do
not identify the attacker. Do not add `COMBAT_TEXT_UPDATE` as a second detection
source or substitute restricted combat-log events or deprecated APIs.

## Repository baseline at initial audit

Sources inspected: [product specification](../product_spec.md),
[content-engine contract](../content_engine.md),
[runtime API assumptions](../runtime_api_assumptions.md),
`RPHelper/RPHelper.lua`, `Core/Runtime.lua`, `Core/RuntimeAPI.lua`,
`Core/Defaults.lua`, and the relevant generic content registrations.

At the initial audit, only combat entry/exit events were registered and forwarded.
`Runtime.HandleEvent` handled encounter transitions; `HandleTrigger` applies settings,
activity policy, chance, cooldowns, content preparation, Druid safeguards, output
routing, and quota accounting. New defensive detections should eventually call
that existing policy path without resetting encounter state. Every successful
automatic output within the encounter, including leave-combat, shares its quota.

Generic content already contains `dodge`, `parry`, `block`, and `youcrit`.
Defensive settings already exist. `youcrit` means player offensive critical damage
from melee, ranged attacks, or damaging spells, excluding healing. Saved settings
called `crit` and `spell_crit` are not proof of detection and do not justify
splitting or broadening that content contract in this milestone.

## Evidence and its limits

**Documented API:** Blizzard's generated
[Unit definition](https://github.com/Gethe/wow-ui-source/blob/live/Interface/AddOns/Blizzard_APIDocumentationGenerated/UnitDocumentation.lua)
contains `UNIT_COMBAT` with five ordered fields. This is Blizzard source mirrored
by a third party; the moving retail `live` branch is not a Forever build guarantee.
Its entry is synchronous and has no explicit secret-payload marker. That absence
does not establish readability in every Forever context.

**Forever-specific documentation export:**
[Atraeau's workspace](https://github.com/Atraeau/WoW-Addons) describes a modern
12.0-based Forever client. Its published
[API export](https://atraeau.github.io/WoW-Addons/api.json) reports version 1.60.1,
build 70170, interface 16001, exported 2026-10-01. It lists both investigated
events and the same five-field `UNIT_COMBAT` signature. This is third-party
client-documentation evidence, not an RPHelper live test or permission guarantee.
Even the restricted combat-log event appears in that catalogue; presence alone
cannot prove registration or delivery works.

**Forever observations:** The library author's
[probe findings, section 8.10](https://github.com/Ralgathor/LibClassicSwingTimerAPI/blob/main/docs/FOREVER_API_FINDINGS.md)
report successful registration on build 70124, 2026-09-30; player parries produced
`player` and `targettarget`, while outgoing dodges produced the defender's
`target` and `nameplate1`. They identify incoming WOUND/DODGE/PARRY/BLOCK feedback.
The record evolves through several superseded hypotheses. Its final timing
analysis reports delayed parry dispatch; earlier apparent coverage gaps must not
be treated as established missing events. A deprecated combat-text accessor
returned nil for PARRY in that probe; this does not establish the modern
namespaced accessor's behaviour. These remain third-party observations.

The inspected [library implementation](https://github.com/Ralgathor/LibClassicSwingTimerAPI/blob/main/LibClassicSwingTimerAPI.lua)
filters `unitTarget == "player"` and action `PARRY` for Forever, using native
events instead of combat-log registration on that client. Its comments describe
defender anchoring, per-token delivery, and plain unit tokens on build 70124.
That supports feasibility, not universal payload safety or complete coverage.
No library dependency is recommended.

The supplied [CurseForge listing](https://www.curseforge.com/wow/addons/libclassicswingtimerapi)
links to that source, but its displayed release is 2.1.5 from 2025-07-07; that
listing is not evidence that the packaged release includes the newer Forever work.

The supplied wiki pages for
[UNIT_COMBAT](https://warcraft.wiki.gg/wiki/Event:UNIT_COMBAT) and
[COMBAT_TEXT_UPDATE](https://warcraft.wiki.gg/wiki/Event:COMBAT_TEXT_UPDATE)
returned HTTP 403 on direct access. Conclusions below use inspected source and
the Forever export rather than assuming those pages establish client behaviour.

## UNIT_COMBAT payload and proposed mappings

The handler receives the registered event name separately from these five
payload arguments. Here, `event` means the payload action, not `"UNIT_COMBAT"`.
Types/order come from the Unit definition and Forever export; semantic
interpretation is corroborated by the probes and Blizzard's
[combat-feedback handler](https://github.com/Gethe/wow-ui-source/blob/live/Interface/AddOns/Blizzard_FrameXML/Mainline/CombatFeedback.lua).

| Field | Contract and relevance |
| --- | --- |
| `unitTarget` | `UnitTokenVariant`: affected recipient/defender token, not attacker identity. Require readable exact `"player"` for defensive reactions. |
| `event` | `cstring`: action such as `DODGE`, `PARRY`, `BLOCK`, `WOUND`, or `HEAL`. Use explicit supported values. |
| `flagText` | `cstring`: feedback qualifier. Blizzard handles `CRITICAL`, `CRUSHING`, `GLANCING`, `BLOCK`, and `BLOCK_REDUCED` in different branches. Not source attribution. |
| `amount` | `number`: feedback magnitude; its meaning varies with action. Defensive identity does not need it. Do not infer a dodge/parry from zero damage. |
| `schoolMask` | `number`: damage-school mask, not an attacker or spell identifier. It cannot reliably distinguish a weapon attack from every damaging spell. |

All five are declared non-nil in the inspected documentation. Actual missing,
unexpected, or restricted values must still be handled safely.

Confidence describes evidence for the mapping, not completed RPHelper validation.

| Proposed condition, after secret checks | Semantic trigger | Confidence / evidence | Decision |
| --- | --- | --- | --- |
| `unitTarget == "player"`, `event == "DODGE"` | `dodge` | Medium: defender contract and Forever probe observations; RPHelper inbound/outbound negative tests pending. | Candidate first increment. |
| `unitTarget == "player"`, `event == "PARRY"` | `parry` | Medium-high: specific Forever probe and library handler, plus documented signature. | Strongest candidate; live validation still required. |
| `unitTarget == "player"`, `event == "BLOCK"` | `block` | Medium: Blizzard feedback branch and Forever observations. Coverage of full/partial blocks is unsettled. | Candidate for direct BLOCK only. |
| Player `WOUND` with `flagText == "BLOCK"` or `"BLOCK_REDUCED"` | Possible `block` | Low for Forever: Blizzard UI recognises these flags, but exact Forever emission and overlap with BLOCK need capture. | Do not add until verified; document any coverage gap. |
| Player `WOUND` with `flagText == "CRITICAL"` | No `youcrit` mapping | High confidence in rejection under defender semantics: player is receiving critical damage. | Ignore. |
| Non-player `WOUND` with `flagText == "CRITICAL"` | No reliable `youcrit` mapping | High confidence that five-field contract lacks attacker identity. | Defer offensive criticals. |
| `HEAL` with `flagText == "CRITICAL"` | No `youcrit` mapping | Blizzard feedback distinguishes healing; product explicitly excludes healing criticals. | Ignore. |
| `COMBAT_TEXT_UPDATE` of any type | None in proposed scope | Contract and UI describe feedback types, not a reliable offensive source. | Diagnostic research only. |

### Attribution risks

An enemy being the current target does not mean the player caused its damage.
Party members, pets, other players, periodic damage, and reflected damage can all
affect that recipient. Solo tests cannot establish correctness in groups.
Do not correlate nearby casts or swing timestamps to manufacture attribution:
latency and simultaneous attacks defeat that inference. `PLAYER_SWING` in the
Forever export carries duration and swing type, not a hit result or critical flag.

Exact `player` filtering identifies our defender without querying target GUIDs,
names, or the current enemy. Pet, vehicle, target, and alias tokens are outside
the initial mapping. Do not convert them to player via identity APIs unless a
separate, verified requirement emerges. This also avoids adding attacker-dependent
keywords to reactions when no attacker context is available.

## COMBAT_TEXT_UPDATE comparison

The [CombatText definition](https://github.com/Gethe/wow-ui-source/blob/live/Interface/AddOns/Blizzard_APIDocumentationGenerated/CombatTextDocumentation.lua)
and Forever export declare one payload field, `combatTextType`. Modern APIs are
`C_CombatText.GetActiveUnit()` and `C_CombatText.GetCurrentEventInfo()`; the retail
definition marks the latter `SecretReturns = true` and supplies no fixed return
schema. It is not a safe general combat-record replacement.

Blizzard's [combat-text UI](https://github.com/Gethe/wow-ui-source/blob/live/Interface/AddOns/Blizzard_CombatText/Shared/CombatText.lua)
reads current-event information during the callback. It displays damage criticals
as incoming negative amounts and healing criticals as positive amounts; it also
handles resources, auras, and partial mitigation. Its active unit can change to a
vehicle. Those display details exceed `UNIT_COMBAT` feedback, but do not supply
a demonstrated player-offensive attribution path. Privileged UI handling is not
proof ordinary addon code may branch on those values.

Recommendation: no additional trigger value for this milestone. Test whether
combat-text CVars, active-unit changes, and secrecy affect delivery only as
diagnostic questions. Do not change the global active unit or user CVars to make
RPHelper work, and do not call deprecated combat-text globals as fallbacks.

## Follow-up: player outgoing critical damage

Investigated 2026-10-11 against the build-70170, interface-16001 export.
**No qualifying, readable player-critical-damage mechanism was established;
`youcrit` remains deferred.** This is a conclusion about the inspected contracts
and evidence, not proof that every future Forever build will lack such a mechanism.
No runtime changes or live registration probes were made for this follow-up.

### Legacy lineage and catalogue absence

The sibling legacy checkout was unavailable in this workspace, so the public
[RPhelper_twow.lua](https://github.com/Wiubiki/RPhelper_twow/blob/main/RPhelper_twow.lua)
was inspected read-only. Lines 170–171 register `CHAT_MSG_COMBAT_SELF_HITS` and
`CHAT_MSG_SPELL_SELF_DAMAGE`; lines 991–1003 compare `arg1` with the Blizzard
formats `COMBATHITCRITSELFOTHER`, `SPELLLOGCRITSELFOTHER`, and
`SPELLLOGCRITSCHOOLSELFOTHER` through `SameEventStrings`. The old code separates
`youcrit` from `youcritspell`. That establishes historical intent, not a modern
event contract or justification to restore the legacy parser.

Exact-name searches across every system's event `literalName` in the
[Forever JSON export](https://atraeau.github.io/WoW-Addons/api.json) found **zero
matches for either legacy event** among 1,806 events. The relevant catalogues
also exclude them:

| Catalogue inspected | Relevant entries / absence |
| --- | --- |
| [ChatInfo, 102 events](https://github.com/Atraeau/WoW-Addons/blob/main/docs/api/Guild-Social-Chat/C_ChatInfo.md#events) | Neither self-hits nor self-spell-damage exists. Remaining `CHAT_MSG_COMBAT_*` entries are FACTION_CHANGE, HONOR_GAIN, MISC_INFO, and XP_GAIN; pet-battle combat messages are a separate family. |
| [CombatLog, four events](https://github.com/Gethe/wow-ui-source/blob/live/Interface/AddOns/Blizzard_APIDocumentationGenerated/CombatLogDocumentation.lua) and corresponding export system | ENTRIES_CLEARED, EVENT, EVENT_UNFILTERED, and MESSAGE_LIMIT_CHANGED under the COMBAT_LOG prefix; neither legacy chat event. |
| [CombatLogSecure, three events](https://github.com/Gethe/wow-ui-source/blob/live/Interface/AddOns/Blizzard_APIDocumentationGenerated/CombatLogSecureDocumentation.lua) and corresponding export system | COMBAT_LOG_APPLY_FILTER_SETTINGS, COMBAT_LOG_MESSAGE, COMBAT_LOG_REFILTER_ENTRIES; neither legacy chat event. |

Confidence is high for **absence from this documented export**, not an assertion
that undocumented engine events were experimentally ruled out. No legacy-event
registration permission or delivery was tested. Even if a localisation constant
survives, that cannot establish availability of an event emitting readable text.

### Availability, permission, readability, and attribution

These are four independent requirements. A name in generated documentation, a
successful registration, or a line visible to the player does not satisfy the others.

| Candidate | Documented availability | Permission / delivery evidence | Readability and source attribution | Decision |
| --- | --- | --- | --- | --- |
| Legacy self-hit/self-spell-damage chat events | Absent from the checked export and catalogues. | Untested; no supported registration path established. | No current payload established. | Do not restore. |
| `COMBAT_LOG_MESSAGE` | Present in CombatLogSecure with message, RGB colours, and order. | Blizzard UI consumes it; ordinary RPHelper delivery on Forever is unverified. | Protected display message; no independent source, damage-kind, or critical-result fields. | No `youcrit` mapping. |
| `C_CombatLog` | Present; filtering, retention, limits, and restriction status. | Raw EVENT/EVENT_UNFILTERED definitions carry restrictions; no registration attempted. | No documented current-event tuple reader in this namespace on build 70170. | Not a readable replacement feed. |
| `C_CombatLogSecure` / Internal | Present as separate interfaces. | Secure namespace is SecureOnly with restricted readers; internal documentation alone is not ordinary-addon permission. | No sanctioned ordinary-addon critical/source contract established. | Do not access through secure/internal substitutes. |
| `C_DamageMeter` | Present; session/source queries and update notifications. | Actual Forever availability must be queried/tested separately. | Aggregates, with no critical-hit field/count in inspected structures. | Insufficient even if some fields are readable. |
| Forever swing extensions | PLAYER_SWING and PLAYER_SWING_RANGE_UPDATE are catalogued. | Prior audit records third-party swing delivery. | Duration/type or range state; no critical result or damaging-spell coverage. | Insufficient. |

The [C_CombatLog definition](https://github.com/Gethe/wow-ui-source/blob/live/Interface/AddOns/Blizzard_APIDocumentationGenerated/CombatLogDocumentation.lua)
contains `IsCombatLogRestricted()` and `AreFilteredEventsEnabled()`, not a
build-70170 `C_CombatLog.GetCurrentEventInfo()` replacement. A false restriction
status would not create a missing reader or prove callback permission.
`DoesObjectMatchFilter()` checks supplied flags; it does not supply the source
flags or a critical-damage result. Tutorials prescribing a namespace rename are
not evidence of a working Forever feed.

The [internal definition](https://github.com/Gethe/wow-ui-source/blob/live/Interface/AddOns/Blizzard_APIDocumentationGenerated/CombatLogInternalDocumentation.lua)
lists `C_CombatLogInternal.GetCurrentEventInfo()` and
`COMBAT_LOG_EVENT_INTERNAL_UNFILTERED`. It provides no documented return schema
or explicit addon-facing permission guarantee. Do not promote an internal entry
to a supported substitute or register it to investigate this milestone.

### Protected combat-chat text

The secure definition explicitly describes COMBAT_LOG_MESSAGE's message as
preformatted text protected by a `|K` wrapper. Its reader functions have
`HasRestrictions`, and the system is `SecureOnly`. The export omits those
security attributes, as explained above. This separates a display callback
from unrestricted access to the underlying combat record.

Blizzard's [combat-log processor](https://github.com/Gethe/wow-ui-source/blob/live/Interface/AddOns/Blizzard_CombatLogProcessor/Blizzard_CombatLogProcessor.lua)
generates text through secure readers and creates messages for current events
and historical entries. The [display driver](https://github.com/Gethe/wow-ui-source/blob/live/Interface/AddOns/Blizzard_CombatLog/Mainline/Blizzard_CombatLog.lua)
passes received text to AddMessage or BackFillMessage according to order. Thus
rendering and history/refilter delivery are not evidence of a new readable hit.

**Inference from this display contract:** ordinary string operations cannot
recover the protected rendered text for matching the legacy critical patterns.
The visible sentence and the Lua wrapper are different information. An
`issecretvalue` result of false on a wrapper would not declassify its contents.
Do not strip wrappers, scrape rendered font strings/chat history, interpret
colour as a critical flag, manipulate filters to obtain a critical-only side
channel, or count display notifications as player hits. KString protection and
Lua secret values are distinct restrictions; both must be respected.

Forever-specific corroboration comes from the author of
[Floating Combat Info v0.20.5a](https://www.curseforge.com/wow/addons/floating-combat-info/files/8924960/additional-files):
the release notes say protected outgoing combat messages can be displayed but
cannot safely be shortened or parsed, and message availability may depend on
filters or chat-tab state. These are third-party observations, not an RPHelper
test or a guarantee about later builds.

### Damage-meter limits

The [DamageMeter definition](https://github.com/Gethe/wow-ui-source/blob/live/Interface/AddOns/Blizzard_APIDocumentationGenerated/DamageMeterDocumentation.lua)
marks four session/source getters `SecretWhenInCombat`. Its source structure
marks `isLocalPlayer` NeverSecret, but spell entries aggregate amount/rate and
related details without a critical flag or critical count. The exported
structures likewise expose no per-hit critical result. Update events identify
a session/type or carry no payload, rather than reporting a particular hit.

Readable local-player identification alone therefore cannot detect a critical.
Post-combat totals do not identify individual results either. Pet aggregation
semantics remain unverified; notably, `combatSpellDetails.isPet` describes the
**target** in the documented structure, not proof that the source is the player
character rather than a pet. Do not infer criticals from amount changes or poll
secret aggregates. This interface fails the critical-result requirement even
before permission, freshness, and pet-source separation are settled.

### Forever extensions and rejected alternatives

The entire export's event names/payload documentation were searched for critical
and swing signals; the relevant Unit, CombatText, CombatLog, DamageMeter, and
SwingTimer contracts were inspected. No documented player-specific outgoing
critical event or equivalent safe structured replacement was found. This search
cannot exclude undocumented additions or later builds.

[ForeverCrit's author](https://www.curseforge.com/wow/addons/forevercrit)
describes matching target hit reports to player casts using timing and damage
school, and acknowledges that another player's critical can be attributed to
the user in a group. That is direct evidence about the author's approximation,
not a qualifying player-source mechanism. Such matching, enemy damage reports,
current-target assumptions, combat-text parsing, and pet-inclusive hit estimates
remain rejected for RPHelper regardless of solo usefulness.

### Remaining uncertainties and reopening criteria

- Repeat catalogue inspection when the actual Forever build changes; retain the
  exact build/interface and original security annotations, not only the simplified
  export. A newly documented event requires its own permission/readability review.
- Confirm supported display-event behaviour and KString handling in ordinary
  addon execution if needed for diagnostics, without parsing or extracting the
  protected content. Do not register restricted/raw/internal combat-log events.
- Damage-meter availability, contextual secrecy, and pet aggregation can be
  researched independently, but resolving them alone cannot supply the absent
  critical-result field.
- Reopen `youcrit` only for a sanctioned readable signal carrying both an actual
  critical-damage result and reliable player-character source attribution. Test
  melee, ranged, damaging spells, group traffic, pets, incoming damage, and
  critical heals in relevant restricted contexts. Reject heals, pets, and other
  combatants without timing or target-based inference; verify replay/duplicates
  and encounter ordering separately.

No inspected mechanism meets those criteria today. The defensive implementation
and its pending live tests are unchanged; **`youcrit` remains deferred**.

## Secret-value handling

The Forever [exporter](https://github.com/Atraeau/WoW-Addons/blob/main/src/WowApiExport/Core.lua)
copies selected signature fields and omits event/function security attributes
such as `SecretPayloads`, `SecretReturns`, and synchrony metadata. Absence of
these attributes in its JSON or generated signatures is not evidence of absence
in the client. The export does list `issecretvalue` and `canaccessvalue`.

Recommended future boundary: check secrecy before equality, string operations,
numeric operations, table lookup by payload key, or diagnostic formatting. For
the direct defensive mappings, only `unitTarget` and action need inspection;
ignore `flagText`, `amount`, and `schoolMask` entirely. If a required field is
secret, malformed, or cannot be safely inspected, reject the attempt without
selecting content or spending cooldown/quota. Secret unused fields alone need
not invalidate a readable defensive action.

On the intended modern client, missing or failing secret-inspection facilities
should disable this new detection path, not imply that payloads are readable.
Type checks and `pcall` alone do not declassify values. Never unwrap secrets,
seek secure execution to inspect them, stringify them for fingerprints, or
reconstruct them from other information. Diagnostic traces should contain only
plain validated fields and a literal marker for withheld fields; never persist
the withheld value. Verify these rules in ordinary addon execution, not solely
through developer macros or Blizzard UI code.

## Duplicates, timing, and encounter boundaries

The reported per-token delivery means one defensive action can appear under
`player` and `targettarget`. Accept only the exact `player` token once through
one event handler. Do not additionally detect the same action through combat
text or register overlapping detection frames. The inspected contract has no
unique combat-action identifier; synchronous dispatch is not a uniqueness promise.

Same-token duplicates remain a live-test question. Do not pre-emptively dedupe
equal action/amount pairs or invent a fixed time window: distinct attacks from
multiple enemies can share both. Existing cooldown/quota policies limit
successful outputs but do not dedupe attempts. In particular, repeated rejected
chance rolls could increase effective probability; zero cooldowns also expose
duplicates. Only add narrow deduplication if captures establish a usable rule.

The author's final timing findings warrant testing delivery relative to
`PLAYER_REGEN_DISABLED`/`ENABLED`. A delayed defensive event arriving after exit
would, under the existing out-of-combat policy, evade the ended encounter's
quota. For the first defensive increment, recommend accepting detections only
while the runtime encounter is active, accepting possible late-event loss rather
than inventing encounter reconstruction. Measure ordering before deciding on
anything more complex. Do not copy swing-timer backdating constants into RPHelper.

## Approved implementation scope

1. Introduce one isolated, fail-closed defensive payload classifier, retaining
   detection, content preparation, and output routing as separate concerns.
2. Route only validated player DODGE/PARRY/direct BLOCK to existing semantic
   triggers and settings. Preserve encounter state, policies, and defaults.
3. Validate whether player-only unit-event registration is supported; otherwise
   use one ordinary UNIT_COMBAT registration plus the exact token filter.
   Registration failure must leave combat transitions functional. Registration
   success alone does not prove event delivery.
4. Require an active runtime encounter for this defensive increment. Add focused
   adapter tests for malformed/secret required fields, unused secret fields,
   non-player negatives, policy consumption, and existing entry/exit interactions.
5. Defer `youcrit`, partial-block flag extensions, additional reaction families,
   target identity lookup, combat-log registration, compatibility substitutes,
   general deduplication infrastructure, and a swing-timer dependency.

## Required live-client tests

Use a temporary diagnostic addon in a later validation step, with public output
disabled and a bounded local trace. No probe was implemented or run by this audit.
Record build/interface, character class/equipment, location, group state, CVars,
and whether code ran as an ordinary addon. Store only validated nonsecret data.

| Test | Required observation / acceptance criterion |
| --- | --- |
| Registration and delivery | On the actual Forever build, test ordinary and player-only unit registration separately. Confirm real callbacks without registering combat-log events. Failure leaves transitions operational. |
| Defensive dodge/parry/block | Use eligible classes/equipment and controlled incoming attacks. Capture all five field types and secrecy states; confirm exact player action and independent visible combat feedback. Do not assume every class can parry/block. |
| Wrong-direction negatives | Have the player's outgoing attacks dodged/parried/blocked. Include pet attacks, an ally defending, and a target attacking someone else. None may produce a player defensive reaction. |
| Full versus partial block | Capture damage remaining after a block and fully mitigated hits. Establish direct BLOCK, WOUND flags, whether both occur for one action, and distinction from absorb/resist/miss. |
| Token aliases and repeated actions | Compare player/targettarget and target/nameplate aliases; then multiple attackers and rapid defenses. Establish counts per real action and same-token duplicate behaviour from raw nonsecret traces. |
| Restricted contexts | Repeat in open world, a five-player dungeon, raid, and available PvP. Check each required field in active combat, not only before a pull. Verify ordinary-addon secret guards suppress safely. |
| Combat-text comparison | Observe type-only callbacks alongside UNIT_COMBAT for diagnostics, with floating text enabled/disabled and vehicle/active-unit changes where applicable. Modern current-event info may be missing or secret; never inspect withheld values. No second trigger path. |
| Offensive attribution falsification | Compare solo player crits, allied/pet crits on the same target, incoming crits, melee/ranged/damaging spell crits, and healing crits. Record the absence of source identity; successful solo coincidence cannot unblock `youcrit`. |
| Encounter ordering | Capture monotonic local arrival order at first/last attack, death, reload in combat, rapid re-entry, and delayed feedback after exit. Confirm quota cannot be bypassed by late defensive events. |
| Policy integration, when implemented | With local output, exercise exhausted quota, leave-combat, disabled settings, zero cooldowns, failed dispatch, and form-restricted Druid speech. One valid detection uses the existing policy exactly once. Public routing remains separately Forever-unverified. |

The strongest evidence establishes that a defensive event path is plausible on
specific beta builds. None of these findings removes the live-validation gate or
establishes a reliable player-offensive critical-hit source.
