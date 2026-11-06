# Temporary live-client detection diagnostics

The opt-in diagnostic workflow is preserved. Mapping milestone 1 now loads four
reviewed static IDs, including the two owner-observed Shaman IDs below. The TOC
uses the user-reported, live-tested Forever Interface `16001`; the addon version
remains `0.9.0-prerelease`. See the [mapping test build and acceptance procedure](ability_detection_milestone_1.md).

## Confirmed code findings

- Startup registers combat entry/exit, `UNIT_COMBAT`, and
  `UNIT_SPELLCAST_SUCCEEDED`. The startup frame forwards exactly those gameplay
  events to the runtime. Ability and defensive registration are guarded and
  independent. No combat-log event or combat-log API is used for detection.
- Ability detection uses only `UNIT_SPELLCAST_SUCCEEDED`, with the assumed
  payload positions `(unitTarget, castGUID, spellID)`. Cast GUIDs are ignored.
  Only an exact readable `player` token, a readable positive integer spell ID,
  and a readable supported player class can match. Missing, failing, or
  non-false `issecretvalue` inspection rejects the required value.
- The entire production allowlist is Paladin `19750 -> FLASH_OF_LIGHT` and
  `20288 -> SEAL_OF_RIGHTEOUSNESS`, plus Shaman `325 -> LIGHTNING_SHIELD` and
  `547 -> HEALING_WAVE`. `Data/AbilitySpellMappings.lua` validates these records
  after canonical registration and publishes the index shared by runtime and
  Library. Other ranks and every other class remain unmapped; weapon imbues are
  still unmapped. Raising chance cannot enable an unknown ID. A spell name is
  diagnostic metadata only; it never determines a mapping.
- Mapped abilities pass through activity, optional encounter quota, valid clock,
  shared global cooldown unless Priority, master/event switches, and effective
  chance before preparing eligible content. Per-event chance replaces global
  chance. Combat start/end share the cooldown and quota with abilities.
- Disabled content is omitted; preparation filters unresolved keywords, invalid
  templates, and Druid Say suppression. Runtime ability context supplies player
  class/race, not a cast target. Target-dependent entries can be ineligible even
  when the cast targeted someone. Flash of Light has a target-independent Say
  entry and a target-dependent custom emote; the latter lacks runtime context.
- Selection and dispatch can fail independently. Successful output alone spends
  cooldown/quota. Open-world Say uses local `AddMessage`; dungeon Say defaults to
  public SAY unless configured local. Built-in and custom emotes use their
  ordinary output APIs. Raids and unknown activities suppress reactions.
- Before this increment, `/rph debug` already retained 100 classified records
  and showed the latest ten, including while master reactions were disabled.
  It did not report policy rejection, eligible count, selection, or dispatch.

## Collecting evidence

1. Copy this branch's `RPHelperForever` folder into the Forever client's
   `Interface/AddOns/` directory while the client is closed. Launch and log in.
   Record client build, Interface, character class, spellbook spell name/rank,
   activity (world/dungeon/raid), and combat state for each short test.
2. Run `/rph debug status`. Capture both lines. Fresh capture must be disabled
   and empty. Registration flags indicate whether the calls succeeded, not
   whether the client actually delivers events. Secret-inspection presence
   does not prove that values are readable.
3. For classification-only testing, note the original master setting and run
   `/rph off`. Capture remains active independently of reaction generation.
   Run `/rph debug clear`, then `/rph debug on`.
4. Cast one spell two or three times using the spellbook or normal action bar.
   Start with Lightning Shield, then repeat separately for a heal and a weapon
   imbue. Use the actual available ranks; do not infer IDs from other clients.
   Repeat each short sample outside combat and in normal dungeon combat when
   practical. Clear between samples after saving the previous evidence.
5. Immediately run `/rph debug off`, then `/rph debug show` for the latest ten
   records or `/rph debug show all` for all retained records. Copy the displayed
   lines with any existing chat-copy facility, or take screenshots. Include the
   status lines and which casts were attempted. Local diagnostic UI messages
   are not guaranteed to appear in the game's public chat log.
6. To test the full reaction path on a Shaman or Paladin, restore master reactions, enable
   the mapped ability, and temporarily set its per-ability chance to 100% through
   the UI. Disable quota for this controlled test, wait out the shared cooldown,
   and use local dungeon Say routing if desired. Test the actual spell rank and
   check the captured ID against the four mappings above. The Library's
   **Detected: mapped IDs only** does not mean every rank works. Repeated casts during
   cooldown should produce `outcome=cooldown`, not repeated reactions. Ordinary
   chance can be tested separately; a chance roll at or above the effective
   chance rejects the attempt.
7. Restore the original settings and leave `/rph debug off`. Capture and its
   records are session-only: save evidence **before** `/reload`, logout, or
   restarting the game. Reload starts with diagnostics disabled and empty.

Capture prints no automatic stream and uses no timers, polling, new event
registrations, or combat-log parsing. The buffer holds the latest 100 events;
busy `UNIT_COMBAT` feedback can evict older spell records, so keep samples short
and stop capture promptly. `show all` prints at most 100 records only on request.
`clear` preserves capture state; `off` preserves retained records.

## Reading a spellcast record

Records show the actual event name, inspected unit/ID, optional spell name,
player class, canonical ability when matched, classification `result`, explicit
`matched`, pipeline `outcome`, `eligible`, `selected`, and `emitted`. When the
chance gate is reached they also show the effective `chance` and any valid
numeric `roll`. Chance values are fractions (0.2 means 20%). Time/activity are
retained when the normal policy path obtains them; classification failures do
not perform extra clock/activity queries.

| Signal | Meaning |
| --- | --- |
| `result=unmapped matched=no` | Safe payload but no class/ID mapping; reaction policy was not attempted. |
| `unit_restricted`, `spell_restricted` | Required inspection was unavailable, failed, or reported a restricted value. No value recovery is attempted. |
| `invalid_spell_id`, `invalid_unit_type` | Payload does not match the expected readable type/shape. |
| `wrong_unit` | Notification was not attributed to exact `player`; spell details are intentionally not inspected. |
| `classification_unavailable` | Classifier missing/failed; no raw error or payload is retained. |
| `outcome=not_attempted` | Classification did not admit a canonical ability, or registration was unavailable. |
| `activity_blocked` | Raid or unknown/unsupported activity. |
| `quota`, `cooldown` | First rejecting shared frequency policy. |
| `master_disabled`, `event_disabled` | Respective switch rejected the attempt. |
| `invalid_clock`, `invalid_roll` | Missing, failing, malformed, or out-of-range policy input; backward time also rejects. |
| `chance_zero`, `chance` | Effective chance was zero, or a valid random roll failed. |
| `unknown_ability` | Classifier's canonical key has no registered ability definition. |
| `eligible=not_evaluated` | Preparation was not reached; eligibility is unknown for this attempt. |
| `no_eligible_content eligible=0` | Preparation ran but no candidate survived, including disabled/unresolvable content. |
| `selection_failed` | No candidate selected despite reaching preparation, e.g. invalid selection RNG. |
| `selected=yes emitted=no outcome=dispatch_failed` | A candidate was selected but the ordinary output adapter did not report success. |
| `selected=yes emitted=yes outcome=emitted` | Adapter acknowledged output; type identifies Say/emote/custom emote. Server visibility still needs observation. |

An earlier gate hides later gates; for example cooldown may be reported before
master-disabled. A spell-name lookup can be missing, fail, or return restricted
data independently of a valid ID. In those cases `spellName=unavailable` is
expected and does not block normal reaction processing. Names use optional
`C_Spell.GetSpellName`, or `GetSpellInfo` only if the first API is absent. No
fallback runs after a lookup fails or returns restricted data.

## Unresolved live-client questions

- The owner confirmed registration, inspection availability and repeated readable
  player SHAMAN successes for Lightning Shield 325 and Healing Wave Rank 3 547
  on a Tauren Shaman, Interface 16001. Those samples were unmapped before milestone
  1; mapped-path output acceptance remains pending. Exact build, complete context
  matrix and raw capture files were not supplied.
- Does ordinary SUCCEEDED registration deliver notifications for additional
  spells/ranks and intended combat/activity contexts? Empty
  captures require the registration/status evidence plus the attempted casts.
- Does this client's payload actually use the assumed third-position spell ID?
  This diagnostic mode observes the existing success path only. It does not
  inspect GUIDs or subscribe to START/SENT/FAILED/channel events to guess a
  different layout or alternate activation signal.
- Is `issecretvalue` present and does it return exactly false for required
  player fields in each context? Missing inspection currently suppresses all
  ability detection. Presence alone does not resolve this question.
- Are either spell-name lookup API and its result available/readable in this
  client? Unknown/restricted names must stay unavailable.
- Which exact IDs correspond to each rank and Forever variant? A single safe
  capture is evidence to review, not authorization to add a mapping.
- Do duplicates occur, do failed/cancelled attempts produce success events,
  and does a success notification imply only cast completion as expected?
  Repeated identical ID records alone cannot establish duplicate casts because
  GUIDs and event correlation are deliberately excluded.
- Do local/public output APIs and activity routing behave as expected in each
  permitted context? Adapter success is not proof of server acceptance.
- Are the records readable in the actual chat UI, and do combat samples fit in
  the bounded buffer? Offline tests cannot establish client usability.

Automated coverage uses mocks. The two Shaman mappings use the owner's reported
event evidence; offline results do not establish live reaction/output acceptance,
additional ranks, broader compatibility, or an API-restriction workaround.
