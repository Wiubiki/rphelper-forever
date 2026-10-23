# RPHelper Forever v0.9 live-client verification

**Target:** `0.9.0-prerelease`
**Purpose:** controlled verification in the actual World of Warcraft Forever
client. This guide records observations; it does not establish compatibility in
advance.

Use a low-traffic test character and avoid repeatedly broadcasting near other
players. Never work around a client restriction. A test result is **Pass**,
**Fail**, or **Not testable**. Record a failure with the template in Phase E.

## Before testing

- Keep an untouched copy of the validated Milestone 5B ZIP and record its name,
  size, and SHA-256.
- Back up this character's SavedVariables using the location reported by the
  actual client installation. Do not assume a Retail or Classic path.
- Use only the Forever client build and addon directory being reported.
- When a test needs predictable selection, use a supported event, set its event
  chance override to 100%, turn the encounter quota off, and disable unrelated
  eligible reactions. Restore ordinary settings after the test.
- Diagnostics prove event reception and classifier output. They do **not** prove
  that chance, cooldown, quota, content selection, routing, or server acceptance
  allowed a reaction.

## Phase A — Bootstrap

### A01 — Record the client build and Interface value

**Prerequisites:** The intended Forever client can reach the character screen.

**Actions:**

1. Record the client version/build displayed by the client or launcher.
2. In chat, run `/run local v,b,d,i=GetBuildInfo(); print(v,b,d,i)` if the
   client's ordinary Lua command is available. Record the complete output; the
   fourth value is the Interface number.
3. Record the exact installation and `Interface/AddOns` directory selected by
   the launcher/client.
4. Compare the numeric fourth value with the `## Interface` metadata in
   `RPHelper/RPHelper.toc`.

**Expected:** Authoritative evidence from the running Forever client identifies
the build and numeric Interface value. The current v0.9 source TOC has no
`## Interface` line, so it cannot yet match that value.

**Outcome:** Pass / Fail / Not testable: __________

**If unsuccessful, record:** client and launcher versions; exact command and
output or error; addon directory; a text copy or screenshot of the build display.

> **Bootstrap gate:** Do not guess the value or borrow one from another WoW
> flavor. Adding it requires a separately reviewed TOC change and a rebuilt,
> revalidated ZIP. If its absence prevents recognition or loading, record A01 as
> the blocking result and stop tests that require RPHelper to load.

### A02 — Install the validated archive

**Prerequisites:** The validated `RPHelper-0.9.0-prerelease.zip` from Milestone
5B and the addon directory from A01.

**Actions:** Close the game, extract the ZIP, and place its single `RPHelper`
folder in `Interface/AddOns`. Confirm the final path is
`Interface/AddOns/RPHelper/RPHelper.toc`, with no second nested `RPHelper` folder.

**Expected:** One addon folder containing the TOC and all packaged Lua files;
no repository, test, or audit files are installed.

**Outcome:** Pass / Fail / Not testable: __________

**If unsuccessful, record:** archive hash, extraction tool, final directory tree,
and missing or unexpectedly nested files.

### A03 — Confirm character-screen detection

**Prerequisites:** A02 complete and the client restarted.

**Actions:** Open the character-screen addon list. Find RPHelper and inspect its
displayed version and compatibility/load status. Do not enable an option that
forces incompatible addons merely to continue.

**Expected:** RPHelper is listed as `0.9.0-prerelease` without missing-file or
incompatible-metadata errors. Until an Interface value is added separately, a
missing/incompatible result is a known bootstrap blocker, not a reason to select
another client flavor.

**Outcome:** Pass / Fail / Not testable: __________

**If unsuccessful, record:** exact status text, client build, Interface evidence,
and installed path.

### A04 — Initialize and open the UI

**Prerequisites:** The client agrees to load RPHelper normally.

**Actions:** Log in. Note any Lua/load error, then enter `/rph` twice.

**Expected:** Login produces no RPHelper Lua error. The first `/rph` opens the
RPHelper Forever window on **Main**; the second closes it. The Main page shows
Global Settings, Reaction Output, and **Open Character Library**.

**Outcome:** Pass / Fail / Not testable: __________

**If unsuccessful, record:** full first Lua error and stack, whether `/rph` is
unknown, and whether the addon was enabled for this character.

### A05 — Confirm help, About, and diagnostic commands

**Prerequisites:** A04 passes.

**Actions:** Run `/rph help`; open `/rph`, then select **Guide** and **About**;
run `/rph debug help`, `/rph debug status`, and `/rph debug show`.

**Expected:** Help lists `/rph`, `help`, `on`, `off`, `status`, diagnostics, and
the reserved `/rph spell <ability-key>` command. Guide and About render, About
shows `0.9.0-prerelease`, and diagnostic help lists the six commands in Phase E.
On a fresh session diagnostics are disabled with `0/100` records, and `show`
reports no captured records. The reserved `spell` command only prints a request;
it is not a gameplay trigger.

**Outcome:** Pass / Fail / Not testable: __________

**If unsuccessful, record:** command, exact chat output, and any Lua error.

## Phase B — User interface and persistence

Tests B01–B08 need one character. B09 needs a logout/login. B10 needs a second
character. B11 needs a replacement of addon program files.

### B01 — Verify default Global Settings

**Prerequisites:** A fresh character database, or a character known never to
have loaded RPHelper.

**Actions:** Open `/rph` and inspect Main without changing anything.

**Expected:** RPHelper enabled; Reaction chance 5%; Cooldown 20 seconds;
Encounter quota off with retained maximum 2; dungeon Say set to **Broadcast in
/say**. Raid suppression and Druid speech suppression are informational, not
editable controls.

**Outcome:** Pass / Fail / Not testable: __________

**If unsuccessful, record:** every displayed value and whether this character
may already have SavedVariables.

### B02 — Exercise Global Settings bounds

**Prerequisites:** B01 complete.

**Actions:** Set Reaction chance to 0%, then 20%; set Cooldown to 5, then 120
seconds; enable Encounter quota and set its maximum to 1, then 10; switch dungeon
Say between local and broadcast; return to values wanted for later tests.

**Expected:** Labels and controls accept only the documented integer ranges.
The quota maximum is disabled while quota is off and retains its last value when
re-enabled. Reopening Main shows each saved choice.

**Outcome:** Pass / Fail / Not testable: __________

**If unsuccessful, record:** control, attempted value, displayed value, and any
save-error message.

### B03 — Navigate the Character Library

**Prerequisites:** B01 complete.

**Actions:** Select **Open Character Library**. Visit Generic, Race, and Class;
page through groups and reactions; use **View** on a reaction.

**Expected:** The header shows this character's race/class. Entries show type,
Built-in or Custom provenance, enabled state, weight, and complete paged detail.
Browsable groups without a detector say **Not currently detected**. Only combat
entry/exit, Dodge, Parry, Block, and the two mapped Paladin abilities are
runtime-supported; browsing another ability does not make it executable.

**Outcome:** Pass / Fail / Not testable: __________

**If unsuccessful, record:** section, group, character race/class, and wrong or
missing content.

### B04 — Disable and weight a Built-in reaction

**Prerequisites:** A Built-in in a supported group.

**Actions:** Untick the reaction, leave and return to the group, then re-enable
it. Use `+`/`-` to change its weight within 1–10 and revisit the group.

**Expected:** Activation and weight persist in the UI. The Built-in text, type,
and identifier cannot be edited in place. A disabled Built-in is excluded from
runtime selection; D05 checks that behavior under an event.

**Outcome:** Pass / Fail / Not testable: __________

**If unsuccessful, record:** section/group, reaction text/provenance, old and new
state, and any UI message.

### B05 — Create all three Custom reaction types

**Prerequisites:** A selected supported group.

**Actions:** Use **Add Custom** three times. Create a unique Say, select a shipped
Emote token, and create a unique Custom Emote. Preview each locally, save it,
then edit one Custom entry and verify Delete asks for confirmation (cancel it if
the entry is needed later).

**Expected:** Each entry is labelled Custom, keeps its type/text, defaults to
enabled weight 1, and can be edited or deleted. Preview is private and emits no
chat or emote. Emote creation offers verified shipped tokens rather than
free-form tokens.

**Outcome:** Pass / Fail / Not testable: __________

**If unsuccessful, record:** type, exact input, validation message, and whether
preview or save caused public output.

### B06 — Modify a Built-in by independent copy

**Prerequisites:** A non-template Built-in reaction is easiest to inspect.

**Actions:** Select **Modify** on a Built-in, change the new reaction as allowed,
and save. Change the copy's enabled state or weight.

**Expected:** The editor says **Create Modified Copy** and saves a new Custom
reaction. The Built-in remains present and retains its own text, enabled state,
and weight. Template/choice text may remain read-only and is preserved exactly.

**Outcome:** Pass / Fail / Not testable: __________

**If unsuccessful, record:** source Built-in, resulting entries, and which state
unexpectedly changed.

### B07 — Save event settings

**Prerequisites:** A group with **Modify Event** enabled.

**Actions:** Open **Modify Event**. Toggle the event, set and clear a chance
override, set it to 0% and 100%, and toggle Priority, saving after each intended
state. Reopen the editor.

**Expected:** The event switch, explicit chance, and Priority persist. Clearing
the override returns to the current global chance. Priority states that it
bypasses only the global cooldown. **Modify Event** remains unavailable for
groups marked **Not currently detected**.

**Outcome:** Pass / Fail / Not testable: __________

**If unsuccessful, record:** group, values before/after saving, and support label.

### B08 — Persist through `/reload`

**Prerequisites:** Distinctive changes from B02 and B04–B07.

**Actions:** Record the settings and Custom entries, run `/reload`, reopen
RPHelper, and inspect them.

**Expected:** Per-character settings, Built-in overrides, event settings, and
Custom records persist. Diagnostics reset to disabled and empty because they are
session-only.

**Outcome:** Pass / Fail / Not testable: __________

**If unsuccessful, record:** exact lost/changed fields, errors during reload, and
whether `RPHelperDB` was written in the client's SavedVariables location.

### B09 — Persist through logout/login

**Prerequisites:** B08 passes.

**Actions:** Log out normally, exit if needed to flush SavedVariables, log back
into the same character, and inspect the same records.

**Expected:** The character's schema-v2 state is unchanged; diagnostics again
start disabled and empty.

**Outcome:** Pass / Fail / Not testable: __________

**If unsuccessful, record:** logout sequence, SavedVariables file location and
timestamp, and the fields lost.

### B10 — Verify character isolation

**Prerequisites:** A second character; back up SavedVariables first.

**Actions:** Record character A's distinctive settings/content. Log into
character B and make a different small change. Return to A.

**Expected:** B does not inherit A's settings, disabled Built-ins, weights, event
overrides, or Custom reactions. A's state is restored when returning to A.

**Outcome:** Pass / Fail / Not testable: __________

**If unsuccessful, record:** realm/character labels sufficient to distinguish
the test characters, without account identifiers, and the state that leaked.

### B11 — Replace program files without deleting SavedVariables

**Prerequisites:** B09 passes and the same validated ZIP is available.

**Actions:** Close the game. Replace only `Interface/AddOns/RPHelper` with a fresh
extraction of the same validated archive. Do not remove SavedVariables. Restart
and inspect the original character.

**Expected:** All character data survives because program files and
SavedVariables are separate. The addon still initializes without errors.

**Outcome:** Pass / Fail / Not testable: __________

**If unsuccessful, record:** exact directories replaced, archive hash, and lost
state. Restore the SavedVariables backup before further destructive diagnosis.

## Phase C — Implemented runtime detection

Before each case run `/rph debug clear` and `/rph debug on`. Use `/rph debug
show` immediately afterward. To separate event delivery from output, first test
with the master switch off: diagnostics should still record delivery while no
reaction is emitted. Then enable RPHelper, use a 100% event override and eligible
content when testing selection/output.

### C01 — `PLAYER_REGEN_DISABLED` and combat entry

**Prerequisites:** Open world, a safe enemy, diagnostics enabled.

**Actions:** Enter combat normally without starting in combat during login.

**Expected:** Diagnostics include `PLAYER_REGEN_DISABLED`,
`trigger=entercombat`, and `result=matched`. With policy/content prepared, a
reaction may then appear. A diagnostic match alone does not prove selection or
output.

**Outcome:** Pass / Fail / Not testable: __________

**If unsuccessful, record:** whether combat began, diagnostic output, settings,
activity, and any Lua error.

### C02 — `PLAYER_REGEN_ENABLED` and combat exit

**Prerequisites:** C01 delivered and the character is in combat.

**Actions:** End the encounter normally by defeating or safely disengaging from
the enemy.

**Expected:** Diagnostics include `PLAYER_REGEN_ENABLED`,
`trigger=leavecombat`, and `result=matched`. The exit attempt belongs to the
encounter that is ending and remains subject to its quota.

**Outcome:** Pass / Fail / Not testable: __________

**If unsuccessful, record:** how combat ended, diagnostic output, and whether
the client still showed the character in combat.

### C03 — `UNIT_COMBAT`: player Dodge

**Prerequisites:** A character/enemy combination capable of Dodge.

**Actions:** Stay in combat and allow suitable melee attacks until the player
dodges; confirm the outcome using the client's ordinary combat display/log.

**Expected:** Diagnostics include `UNIT_COMBAT unit=player action=DODGE` and
`result=matched`. Events outside RPHelper's tracked encounter are rejected as
`outside_combat`.

**Outcome:** Pass / Fail / Not testable: __________

**If unsuccessful, record:** client combat evidence and the corresponding latest
diagnostic records.

### C04 — `UNIT_COMBAT`: player Parry

**Prerequisites:** A character with a usable parry capability and suitable melee
attacker.

**Actions:** Remain in combat until the player directly parries an attack.

**Expected:** `UNIT_COMBAT unit=player action=PARRY result=matched` appears.

**Outcome:** Pass / Fail / Not testable: __________

**If unsuccessful, record:** the same evidence as C03.

### C05 — `UNIT_COMBAT`: direct player Block

**Prerequisites:** A character equipped and able to block direct melee attacks.

**Actions:** Remain in combat until the player directly blocks an attack.

**Expected:** `UNIT_COMBAT unit=player action=BLOCK result=matched` appears.
Partial-block flags or other combat-log approximations are not supported.

**Outcome:** Pass / Fail / Not testable: __________

**If unsuccessful, record:** the same evidence as C03, including whether the
client described a full or partial block.

### C06 — Paladin Flash of Light mapping

**Prerequisites:** A Paladin able to cast the rank whose delivered spell ID is
`19750`; diagnostics enabled.

**Actions:** Cast Flash of Light normally. Inspect `/rph debug show`.

**Expected:** A readable player `UNIT_SPELLCAST_SUCCEEDED` record contains
`spellID=19750 class=PALADIN ability=FLASH_OF_LIGHT result=mapped`. Other ranks
or IDs may be reported as `unmapped` and must not trigger this ability pool.

**Outcome:** Pass / Fail / Not testable: __________

**If unsuccessful, record:** exact diagnostic record, spell rank shown by the
client, and whether a different ID was delivered.

### C07 — Paladin Seal of Righteousness mapping

**Prerequisites:** A Paladin able to cast the rank whose delivered spell ID is
`20288`; diagnostics enabled.

**Actions:** Cast Seal of Righteousness normally and inspect diagnostics.

**Expected:** A readable player record contains `spellID=20288 class=PALADIN
ability=SEAL_OF_RIGHTEOUSNESS result=mapped`. Other IDs remain unmapped.

**Outcome:** Pass / Fail / Not testable: __________

**If unsuccessful, record:** the same evidence as C06.

### C08 — Browsable content is not a runtime mapping

**Prerequisites:** A class ability visible in the Library other than the two
exact Paladin mappings.

**Actions:** Note its **Not currently detected** state, enable diagnostics, use
the ability normally, and inspect the records.

**Expected:** The ability does not activate its catalogue pool. A spellcast
event may be absent or classified `unmapped`; merely appearing in the Library is
not runtime support.

**Outcome:** Pass / Fail / Not testable: __________

**If unsuccessful, record:** class, ability, delivered event/ID, and any reaction
that incorrectly appeared.

## Phase D — Policy and output behavior

Use distinctive Custom text only in a supported group and a quiet location. For
tests needing a guaranteed policy attempt, set that event's chance override to
100%; the global slider itself intentionally stops at 20%. Restore settings and
delete temporary content afterward.

### D01 — Chance boundaries: 0% and 20%

**Prerequisites:** A repeatable supported event, quota off, no active cooldown.

**Actions:** With no event override, set global chance to 0% and provoke several
eligible events. Then set it to 20% and repeat enough independent encounters to
observe sampling; keep a count of attempts and outputs.

**Expected:** 0% produces no reaction. At 20%, each otherwise eligible event has
a 20% chance; output is neither guaranteed nor expected at a fixed small-sample
ratio. Diagnostics may still show matched events in both cases.

**Outcome:** Pass / Fail / Not testable: __________

**If unsuccessful, record:** attempt/output counts, event settings, cooldown,
quota, eligible content, and diagnostic records.

### D02 — Cooldown endpoints: 5 and 120 seconds

**Prerequisites:** Event chance 100%, quota off, a non-Priority event.

**Actions:** At 5 seconds, provoke one successful output, retry before 5 seconds,
then after 5 seconds. Repeat at 120 seconds without waiting out the full interval
unless practical; confirm an immediate second event is suppressed.

**Expected:** A successful non-Priority output starts the shared cooldown. Events
inside it do not output; one at/after expiry can. Changing to 120 is accepted and
immediate retries are suppressed. Rejected attempts do not start a cooldown.

**Outcome:** Pass / Fail / Not testable: __________

**If unsuccessful, record:** stopwatch times, event sequence, and visible output.

### D03 — Encounter quota and reset

**Prerequisites:** Chance 100%, cooldown 5 seconds, quota maximum 1.

**Actions:** Enable quota. Produce one successful output in combat, wait beyond
cooldown, then provoke another supported in-combat or exit event. Start a new
encounter and provoke another eligible event. Repeat once with quota off.

**Expected:** With quota on, only the first successful automatic reaction in the
encounter emits; the exit is included if the cap is already used. The next
combat entry resets the count. With quota off, no encounter-count cap applies.

**Outcome:** Pass / Fail / Not testable: __________

**If unsuccessful, record:** exact event/output order and timing.

### D04 — Priority bypasses only cooldown

**Prerequisites:** Chance overrides 100% for one non-Priority and one Priority
supported event; quota off; cooldown 5 seconds.

**Actions:** Emit the non-Priority event at time 0. Around second 4, provoke the
Priority event. Just after second 5 from the first output, provoke the
non-Priority event again. Separately set the Priority event chance to 0%, disable
it, and test it after exhausting a quota of 1.

**Expected:** The Priority event can emit during cooldown. It does not start,
reset, or extend that timer, so the later non-Priority event is eligible after
the original 5 seconds. Priority still fails at 0% chance, while disabled, when
quota is exhausted, when content is ineligible, and in suppressed activities.

**Outcome:** Pass / Fail / Not testable: __________

**If unsuccessful, record:** stopwatch times, event configuration, quota, and
each observed output. Manual timing uncertainty is a valid Not-testable reason.

### D05 — Disabled Built-ins never select

**Prerequisites:** A repeatable supported group and an identifiable Built-in.

**Actions:** Disable that Built-in, set event chance to 100%, remove/disable
other eligible reactions where practical, and provoke the event repeatedly.

**Expected:** The disabled text never appears. Re-enable it and confirm it can
again participate; absence in a small random sample alone is not proof.

**Outcome:** Pass / Fail / Not testable: __________

**If unsuccessful, record:** reaction ID/text, all applicable Generic/Race/Class
content, weights, and samples.

### D06 — Weighted selection is observable

**Prerequisites:** At least two enabled eligible reactions in one supported
event, one at weight 1 and one at weight 10; chance 100%; short cooldown and
quota off.

**Actions:** Generate a reasonable series of eligible events, waiting for
cooldown, and tally each output.

**Expected:** Both remain possible; the weight-10 entry should be favored over a
longer sample. Weight is relative among eligible candidates, not a guaranteed
percentage and not a substitute for event chance.

**Outcome:** Pass / Fail / Not testable: __________

**If unsuccessful, record:** candidate list/weights and complete tally.

### D07 — Open-world routes

**Prerequisites:** Open world, controlled Say/Emote/Custom Emote reactions.

**Actions:** Provoke each type separately.

**Expected:** Say appears only as an `[RPHelper]`-prefixed local chat-frame
message, with no public `/say` or speech bubble. Emote uses the native Blizzard
emote route; Custom Emote uses native `/e`-style output, subject to client
permission. If the local display is unavailable, Say has no public fallback.

**Outcome:** Pass / Fail / Not testable: __________

**If unsuccessful, record:** type, local/public observation from a cooperating
tester if available, client restriction/error, and diagnostics.

### D08 — Five-player dungeon Say routing

**Prerequisites:** A cooperative five-player dungeon group; avoid repetitive
public output.

**Actions:** With dungeon mode **Broadcast in /say**, provoke one controlled Say.
Switch to **Local display only** and provoke one more.

**Expected:** Broadcast mode invokes `/say`; local mode shows only the prefixed
local display. Emote routes are unaffected. Server silence despite a completed
API call is a live compatibility finding.

**Outcome:** Pass / Fail / Not testable: __________

**If unsuccessful, record:** instance, setting, observer report, and any client
warning. Do not spam retries.

### D09 — Party channel remains unused

**Prerequisites:** A party, optionally outside and inside a dungeon.

**Actions:** Observe the chat channel used by controlled Say reactions.

**Expected:** RPHelper never sends to the `PARTY` channel. V1 has no party-chat
route or option: open-world Say is local, and five-player-instance Say is `/say`
or local. This is an intentional limitation, not a failed feature.

**Outcome:** Pass / Fail / Not testable: __________

**If unsuccessful, record:** activity, output type, and actual channel.

### D10 — Raid suppression

**Prerequisites:** A cooperative raid instance and a prepared 100% event.

**Actions:** Enable diagnostics and provoke a supported event once for each
reaction type where practical.

**Expected:** No Say, Emote, or Custom Emote is emitted. A diagnostic record may
show event delivery/classification; raid suppression occurs separately.

**Outcome:** Pass / Fail / Not testable: __________

**If unsuccessful, record:** instance, group state, type, diagnostic activity,
and any output. Stop immediately if public output occurs.

### D11 — Unknown activity fails closed

**Prerequisites:** Only a naturally observed state where the client does not
return the strict world, party-instance, or raid-instance shape.

**Actions:** Do not manufacture or bypass a restricted state. If one occurs,
provoke at most one controlled supported event and inspect behavior.

**Expected:** All output is suppressed. Diagnostics may omit an activity label
because only recognized world/dungeon/raid labels are retained.

**Outcome:** Pass / Fail / Not testable: __________

**If unsuccessful, record:** client context and return evidence available
without invasive tooling. Normally this case may be Not testable.

### D12 — Druid form speech suppression

**Prerequisites:** A Druid with at least one recognized shapeshift form; a
supported event containing eligible Say plus Emote/Custom Emote content.

**Actions:** In humanoid form, provoke the controlled Say. Shift to each
available form and repeat. Also test an emote type while shifted.

**Expected:** Humanoid Say may emit according to routing. Every shapeshifted Say,
Built-in or Custom and even Priority, is ineligible. Emote and Custom Emote remain
eligible. The UI provides no override.

**Outcome:** Pass / Fail / Not testable: __________

**If unsuccessful, record:** form name, any safely observable form ID, reaction
type/provenance, settings, and output.

### D13 — Unknown Druid form state suppresses Say

**Prerequisites:** A naturally occurring form whose ID is unknown to RPHelper,
or a naturally unavailable/failing form API.

**Actions:** Do not alter or bypass the API. If such a state occurs, provoke one
controlled Say and one emote event.

**Expected:** Unknown/unavailable form state is treated conservatively as
shapeshifted: Say is suppressed while emotes remain eligible. If no such client
state can be observed, mark Not testable.

**Outcome:** Pass / Fail / Not testable: __________

**If unsuccessful, record:** available form/client evidence and output type.

## Phase E — Evidence and troubleshooting

### E01 — Verify session diagnostics

**Prerequisites:** RPHelper loaded.

**Actions and expected behavior:**

1. `/rph debug on` enables capture for this session.
2. `/rph debug off` stops capture but retains records.
3. `/rph debug status` reports enabled/disabled and `count/100`.
4. `/rph debug show` prints the latest ten retained records in sequence order.
5. `/rph debug clear` removes records without changing enabled state.
6. `/rph debug help` prints these six commands.
7. After collecting a record, run `/reload` and check status again.

**Expected:** Capture is opt-in, local, bounded to 100 records, and resets to
disabled/empty on initialization. It observes the combat-transition,
`UNIT_COMBAT`, and spellcast paths without changing reaction policy or output.
It reports event delivery/classification—not every later rejection reason.

**Outcome:** Pass / Fail / Not testable: __________

**If unsuccessful, record:** command, complete output before/after the action,
and whether reload reset the records.

### Reading a diagnostic record

- `result=matched` on combat/defense means the classifier accepted the event.
- `result=mapped` on spellcast means the exact class/spell ID mapped to an
  ability.
- Fixed results such as `duplicate`, `outside_combat`, `wrong_unit`,
  `unit_restricted`, `action_restricted`, `unmapped`, or
  `registration_unavailable` describe delivery/classification outcomes.
- `activity=world|dungeon|raid` appears only when a matched path reaches activity
  resolution. Its presence does not mean output succeeded.
- No diagnostic record explains a later chance, cooldown, quota, disabled-entry,
  eligibility, selection, or dispatch rejection.

### Failure report template

```text
RPHelper test ID:
Addon version/archive SHA-256:
Forever client version/build:
Observed GetBuildInfo / Interface value:
Installed addon directory:
Character class/race/form (no account details):
Zone and activity type:
Relevant global/event/reaction settings:
Steps to reproduce:
Expected result:
Observed result:
Full first Lua error, if any:
/rph debug status and relevant /rph debug show lines:
Reproduces after /reload: yes / no / not tested
Additional minimal evidence:
```

Prefer copied text over screenshots. Never include account name, email, login
details, real-world identity, or unrelated chat. Preserve the first error and a
small reproducible sequence; repeated public-output attempts are not useful.

## Known interpretation limits

- A missing `## Interface` value is the first bootstrap question and must be
  fixed only after actual-client evidence in a separate implementation task.
- Mocks cannot establish event availability, field readability, form/spell IDs,
  activity return values, chat/emote permission, or disk persistence.
- Diagnostics cannot distinguish most post-classification policy rejections.
- Only the event paths and exact Paladin mappings in Phase C are implemented.
- No party-chat routing, character-attached local speech bubble, combat-log
  fallback, partial-block inference, or automatic retry is implemented.

Related references: [product specification](product_spec.md), [runtime API
assumptions](runtime_api_assumptions.md), [offline integration audit](audits/milestone_5a_offline_integration_audit.md),
and [release checklist](release_checklist.md).
