# Pet Runtime Feasibility Audit

## Scope and conclusion

This audit evaluates the retained Turtle WoW behavior, all loaded Forever pet
reaction pools, the current resolver/runtime/policy implementation, prior class
reconciliation reports, and the available WoW Forever API declarations. It is
research only: no runtime, content, settings, event subscription, or state was
changed.

Forever cannot safely enable pet reactions from repository evidence alone. The
Forever API surface declares relevant unit APIs and pet-state events, but
declaration is not proof that an addon can observe the player's command or
manual activation. `PET_ATTACK_START` and `PET_ATTACK_STOP` describe pet state;
they do not by themselves establish player agency.

No proposed runtime detector is **Ready to implement** from verified existing
Forever contracts. Player-issued commands and manually activated pet abilities
for Hunter permanent pets and ordinary Warlock demons are **Feasible but
require live-client verification**. Autonomous pet behavior is outside V1.0;
death, Mage eligibility, Priest Mind Control, temporary controlled units,
guardians, and pet critical-hit reactions are **Deferred**.

The row-level classification is in
[`pet_runtime_feasibility_inventory.csv`](pet_runtime_feasibility_inventory.csv).

## Owner-approved product scope

### V1.0 — in scope

- Player-issued pet commands: Attack, Follow, Stay, Passive, and Stop Attack,
  where the controlled unit supports them.
- Manually activated pet abilities, including activations issued through
  macros.
- Hunter permanent pets and ordinary Warlock demons.
- A reaction follows the player's command or activation. Pet execution,
  success, damage, target acquisition, or any other combat outcome is not a
  prerequisite.
- Existing probability, cooldown, activity, quota, preparation, and output
  policies apply.

### Post-V1.0 / optional

- Pet critical-hit reactions.
- Pet-death reactions.
- Mage temporary summons, Priest Mind Control, and unusual controlled units.

### Outside scope

- Autonomous pet attacks, automatic target changes, and automatic pet
  abilities.
- Pet autocast activity and enabling or disabling autocast.
- Pet combat outcomes as prerequisites for command reactions.

The remaining V1.0 research question is whether Forever exposes player-issued
pet commands and manual pet-ability activations—including pet-bar clicks and
macros—through observable, secure addon APIs. No particular command, action-
bar, spellcast, hook, or macro API is considered verified by this audit.

## Evidence and confidence

### Repository and legacy behavior

The legacy addon registered payload-free `PET_ATTACK_START` and
`PET_ATTACK_STOP`. It dispatched the corresponding pools immediately. For
death, it parsed localized `CHAT_MSG_COMBAT_FRIENDLY_DEATH` text and looked for
the current `UnitName("pet")`; its own comment says death arrived before attack
stop and relied on the global delay to suppress the second reaction. This is
fragile evidence, not a design to port: localized text matching can collide on
names, the pet token/name may disappear, and a cooldown is not semantic
deduplication.

The legacy placeholder resolver read `UnitName("pet")` and
`UnitName`/`UnitSex("pettarget")` during phrase preparation. A legacy comment
reports unstable pet-target sex immediately after attack start. That confirms
historical difficulty; it does not establish Forever timing.

### Current client declarations

The [Forever API snapshot](https://atraeau.github.io/WoW-Addons/) was generated
from client `APIDocumentation` for build 70170/interface 16001. It establishes
that the modern Forever surface declares unit APIs/events, but the snapshot
itself warns only through type metadata; it does not provide observed delivery
or ordering. Current generated Blizzard unit documentation is mirrored in
[`UnitDocumentation.lua`](https://github.com/Gethe/wow-ui-source/blob/live/Interface/AddOns/Blizzard_APIDocumentationGenerated/UnitDocumentation.lua),
and Blizzard UI code demonstrably reads `UnitName("pet")` and
`UnitCreatureFamily("pet")` in the
[pet talent UI](https://github.com/Gethe/wow-ui-source/blob/live/Interface/AddOns/Blizzard_TalentUI/Cata/Blizzard_TalentUI.lua).

The current API catalogue describes `UNIT_PET` with one `unitTarget` payload.
The event means that a unit's pet changed; it does not identify why, whether
the old pet died, or whether the new controlled unit is permanent. The
catalogue entry for `PET_ATTACK_START` has no payload and describes only the
player's pet beginning to attack; the corresponding stop event likewise does
not provide a target or cause. The
[Forever event reference](https://warcraft.wiki.gg/wiki/PET_ATTACK_START)
labels `PET_ATTACK_START` as available to Forever and payload-free. These are
useful declaration-level facts, but RPHelper still needs live capture on the
actual supported build.

Modern API metadata also marks some unit identity/stat results secret depending
on unit control and group relation. The current
[`SecretPredicatesDocumentation.lua`](https://github.com/Gethe/wow-ui-source/blob/live/Interface/AddOns/Blizzard_APIDocumentationGenerated/SecretPredicatesDocumentation.lua)
specifically distinguishes player-controlled units from unrelated units.
RPHelper must retain its existing fail-closed treatment for absent, throwing,
empty, malformed, or secret values.

### Current RPHelper subscriptions

Production currently registers only:

- `PLAYER_REGEN_DISABLED` and `PLAYER_REGEN_ENABLED`;
- `UNIT_COMBAT` through the defensive adapter;
- `UNIT_SPELLCAST_SUCCEEDED` through the ability adapter.

`Runtime.EventTrigger` maps only combat entry/exit. Pet spell success is
explicitly rejected because the ability classifier accepts only
`unitTarget == "player"`. There is no `UNIT_PET`, pet attack, pet health,
pet flags, or pet death subscription; no pet state; no `TriggerConfigKey` or
default setting for the three pet triggers; and no runtime construction of pet
placeholder values.

## Loaded content accounting

All pet-trigger registrations occur in four loaded class files:

| Class | `petattackstart` | `petattackstop` | `petdies` | Total |
| --- | ---: | ---: | ---: | ---: |
| Hunter | 12 (10 say, 1 emote, 1 custom) | 8 (7 say, 1 custom) | 7 (4 say, 3 custom) | 27 |
| Warlock | 7 say | 6 say | 6 say | 19 |
| Mage | 3 (2 say, 1 custom) | 3 (2 say, 1 custom) | 0 | 6 |
| Priest | 4 (3 say, 1 custom) | 3 (2 say, 1 custom) | 3 (2 say, 1 custom) | 10 |
| **Total** | **26** | **20** | **16** | **62** |

Across all 62 reactions the type totals are 51 `say`, one `emote`, and ten
`customemote`. No generic or racial file registers these triggers.

Pet-trigger strings contain:

| Placeholder | Occurrences | Where |
| --- | ---: | --- |
| `{PNAME}` | 58 | All four class pools |
| `{PTNAME}` | 1 | Priest `petattackstart` |
| `{PTSP}` | 0 | — |
| `{PTOP}` | 9 | Hunter and Warlock `petattackstart` |
| `{PTPP}` | 0 | — |
| `{PP}` | 3 | Hunter death and Priest start/stop |
| `{TARGET}` | 2 | Hunter and Mage `petattackstart` |

`{PP}` is now operational player context. `{TARGET}` deliberately remains
unavailable without relevant event context and must not be replaced with the
player's selected target. The five pet placeholders remain supplied-only.

Existing tests pin Hunter and Warlock pool totals, demonstrate preparation with
explicit pet values, and assert that no pet triggers or pet spell mappings are
active. Mage/Priest totals are covered by broader class snapshots, but there is
no table-driven four-class pet inventory test. That is a future implementation
test need, not a reason to change tests during this documentation audit.

## Ownership and eligibility

### What the `pet` token proves

When readable and populated, the literal `pet` unit token is the client's
player-owned/currently controlled pet slot. It is much stronger ownership
evidence than a name, creature type, or arbitrary GUID seen elsewhere.
`partyNpet` and `raidNpet` are other players' units and must never qualify.

Even so, `UnitExists("pet")`, `UnitName("pet")`, and `UnitGUID("pet")` only
describe the unit presently occupying that token. They do not establish:

- that it is a permanent Hunter pet rather than a temporary controlled unit;
- that a disappearance means death rather than dismissal, sacrifice, zoning,
  range loss, stable change, control loss, or UI timing;
- that a newly observed unit is the same summon as an earlier unit with the
  same name;
- that an attack transition was explicitly commanded rather than AI/autocast.

`UnitGUID("pet")` is therefore the best candidate for transition identity, not
a sufficient classifier by itself. `UnitClass("pet")` and
`UnitCreatureType("pet")` describe the controlled unit, not ownership or the
owner's class. Creature family/type can assist observed diagnostics but must
not decide eligibility alone. The player class already gives the intended
content scope.

### Per-category recommendation

| Category | Feasibility | Recommendation |
| --- | --- | --- |
| Hunter permanent pets | Feasible but requires live-client verification | First V1 candidate. Verify pet-bar and macro command/activation signals; observe attack, target death, pet death, revive, stable, zone, and reload transitions separately as diagnostic evidence. |
| Ordinary summoned Warlock demons | Feasible but requires live-client verification | Second V1 candidate using the same verified command/activation foundation; separately observe sacrifice, dismiss, resummon, and each demon family. |
| Mage summoned pets | Deferred | Existing reactions assume a controllable `pet`, but the relevant Forever summon roster, token lifecycle, and attack events are not established by repository evidence. |
| Priest Mind Control | Deferred | A controlled former target/channel is semantically different from a persistent pet. Verify whether it occupies `pet`, how control begins/ends, and whether attack/death events fire before using these reactions. |
| Temporary summons/guardians | Deferred | Do not classify guardians merely because they are player-created or have pet-like GUIDs; they may not occupy `pet` or accept commands. |
| Temporarily controlled units | Deferred | Control acquisition/loss and hostility transitions need their own evidence. |
| Other players' pets | Excluded | Never accept `partyNpet`, `raidNpet`, name matches, or arbitrary pet GUIDs as the player's pet. |

For Warlocks, Infernal/Doomguard hostile-to-controlled transitions, Bane-created
guardians, Demonic Sacrifice, Eye of Kilrogg, and loss of control must remain
outside the generic permanent-demon path until individually observed. A
dismissal or sacrifice is not a death reaction.

## Trigger feasibility

### `petattackstart`

The payload-free `PET_ATTACK_START` event is evidence that the pet began
attacking, not that the player issued Attack. It may follow a player command,
defensive/assist AI, autonomous reacquisition, or another state transition.
It therefore cannot be the V1.0 command detector unless live evidence provides
a separate secure player-command signal that can be correlated without using
the pet's successful execution as a prerequisite.

Unresolved questions:

- Does it fire on an explicit Attack command, first actual attack, AI defensive
  acquisition, autocast acquisition, assist behavior, or all of these?
- Does switching directly from target A to B emit stop/start, start only, or no
  transition?
- Are `pettarget` name/GUID/sex readable synchronously, one frame later, or
  already changed again?
- Do repeated Attack commands against the same target emit duplicates?

The event remains useful diagnostic evidence for ordering and optional future
state features. It has no target payload. `{PTNAME}` and pet-target pronouns may
only be read from `pettarget` after live timing proves relevance. `{TARGET}`
must remain unresolved because the selected target is not equivalent.

### `petattackstop`

The payload-free `PET_ATTACK_STOP` event establishes only that the pet ceased
attacking. It does not establish that the player issued Follow, Stay, Passive,
or Stop Attack, and it cannot distinguish those commands from target death,
loss, control effects, or other automatic transitions.

Because V1.0 requires player agency, this event is not an acceptable detector
on its own. It remains diagnostic evidence and may support later state
reconciliation. Pet-target placeholders should not be expected at stop time
because `pettarget` may already be empty.

### Player commands and manual pet abilities

V1.0 detection must happen at the player's command or activation boundary, not
at the resulting pet state/combat boundary. Research must determine whether
Forever exposes a readable, secure signal for pet-bar clicks and equivalent
macro activations for Attack, Follow, Stay, Passive, Stop Attack, and manually
activated pet abilities. It must also establish that the signal excludes
autocast and autonomous AI activity.

The audit does not assume that action-button hooks, protected command APIs,
macro text, `UNIT_SPELLCAST_SUCCEEDED`, or any other candidate mechanism is
observable or safe. Hardware-event and secure-action restrictions must be
respected. If clicks and macros cannot be observed consistently without
intercepting protected behavior or inferring an outcome, that command/ability
must remain unsupported.

### `petdies`

No declaration examined provides an unambiguous own-pet-death event. Potential
signals are all ambiguous alone:

- `UNIT_HEALTH("pet")` reaching zero requires health readability and state, and
  the unit token may disappear before observation;
- `UNIT_PET("player")` reports a pet-slot change, not its cause;
- `UNIT_FLAGS("pet")` reports flag changes, not necessarily death;
- `PET_ATTACK_STOP` reports attack cessation;
- combat-log reconstruction is explicitly out of scope and may be restricted.

Reliable death likely needs a minimal prior snapshot (`pet` GUID and name) plus
a verified event sequence that distinguishes death from dismiss/despawn/
sacrifice/control loss. Because this audit may not add state and no sequence is
verified, `petdies` is deferred. Reading `{PNAME}` after the unit vanishes is
not reliable; a future implementation would need to preserve the last verified
name only for a positively classified death transition.

## Placeholder feasibility

| Placeholder | Required context and candidate source | Trigger-time risk | Classification |
| --- | --- | --- | --- |
| `{PNAME}` | Readable own `pet`; `UnitExists`, `UnitGUID`, then `UnitName("pet")` | Token may vanish on death/dismiss and may change during summon/control transitions | Feasible but requires live-client verification |
| `{PTNAME}` | Verified relevant `pettarget`; `UnitExists`, `UnitGUID`, `UnitName("pettarget")` | May be absent, stale, restricted, or already switched/cleared | Feasible for attack start only after timing verification; otherwise deferred |
| `{PTSP}` | Verified `pettarget` plus readable `UnitSex("pettarget")` | Same timing/secrecy risk; non-player sex semantics may be neutral | Feasible but requires live-client verification |
| `{PTOP}` | Same as `{PTSP}`, object form | Used nine times; absence must filter those candidates | Feasible but requires live-client verification |
| `{PTPP}` | Same as `{PTSP}`, possessive determiner | No loaded use, but contract still requires correct `its/his/her` form | Feasible but requires live-client verification |

The Phase 1 player-pronoun table (`he/him/his`, `she/her/her`, `it/it/its`) can
be factored into a shared internal mapping in a future implementation. The
player lookup/cache must not be reused as pet-target context: the unit token,
availability, secrecy, and lifetime are different. No localization framework
is proposed here.

Every unavailable pet value must leave its dependent candidate ineligible.
Never substitute `target` for `pettarget`, a pet name for a missing target name,
or a neutral pronoun merely because `UnitSex` could not be read.

## State, ordering, and duplicate risk

Event payloads alone identify neither old identity nor cause. A feasible future
implementation probably needs a deliberately small snapshot:

- current readable `pet` GUID and name;
- current readable `pettarget` GUID/name only around a verified start event;
- whether an attack-start transition is active, solely to collapse demonstrated
  duplicate start/stop delivery;
- last confirmed death identity only if live evidence establishes a death
  sequence.

That state should be updated from verified events and cleared on ambiguous
lifecycle changes. It must not become target tracking, combat-log inference, or
a general pet state machine.

The existing global cooldown, per-trigger cooldown, probability, encounter
quota, activity gating, and output routing should remain the policy layer.
They limit visible spam but cannot correct semantic duplicates: a duplicate
event may consume probability/quota or suppress the genuinely intended later
reaction. Detection should collapse proven duplicate signals before policy.

Pet commands outside player combat also expose a policy question. The current
encounter quota applies only while `inCombat`; repeated out-of-combat commands
would still use global/per-trigger cooldowns but not the encounter quota. No
pet trigger defaults/settings exist today, so enabling command reactions
requires an explicit settings contract rather than borrowing an unrelated
trigger key.

Routing needs no pet-specific path: once a safe canonical trigger and context
exist, current world/dungeon/raid permission and `say`/emote/custom-emote
routing are reusable. Raids remain disabled by default.

## Minimal V1.0 proposal

After successful live capture of a secure command/activation signal, the
smallest defensible increment is:

1. Support only permanent Hunter pets and ordinary summoned Warlock demons that
   occupy a readable `pet` token while the player's class matches the content.
2. React to verified player-issued Attack, Follow, Stay, Passive, and Stop
   Attack commands, plus verified manual pet-ability activations from pet-bar
   clicks and macros. Do not wait for successful execution.
3. Exclude autocast and autonomous AI actions. Do not use
   `PET_ATTACK_START`/`PET_ATTACK_STOP` alone as proof of a command.
4. Supply `{PNAME}` from the verified own-pet identity. Supply `PT*` only when
   the command/activation context itself establishes the relevant pet target.
5. Leave `{TARGET}` reactions ineligible unless the command/activation context
   itself can prove the relevant unit; never use the selected target.
6. Keep pet critical hits, pet death, Mage summons, Priest Mind Control, and
   unusual controlled units out of V1.0.
7. Route through the existing probability, cooldown, quota, activity,
   preparation, and output safeguards.
8. Fail closed on detector/API failure, secret/unreadable unit values,
   missing identity, unsupported class/category, and ambiguous transitions.

Until command/activation capture exists, this remains **Feasible but requires
live-client verification**, not implementation-ready.

Potential future spell-specific pet critical-hit reactions would additionally
require a trustworthy pet spell identity, a verified critical result, and
appropriate target context. They are outside V1.0 and must not broaden or
change the existing generic player `youcrit` trigger.

## Required live-client matrix

First determine whether secure observable signals exist for pet-bar clicks and
equivalent macro activations. Capture command/activation identity and guarded
pet context without altering or replaying the action. Separately capture
ordered state events only to understand correlation and false positives:

- Hunter: pet-bar and macro forms of Attack, Follow, Stay, Passive, Stop Attack,
  and manual abilities; repeated commands; autocast; defensive/assist AI; A→B
  target switch; target death; pet death; revive; dismiss; stable swap; player
  death; zoning; reload; dungeon; raid; and PvP.
- Warlock: summon/dismiss/resummon each ordinary demon, attack/stop/switch,
  demon death, sacrifice, owner death, zoning, Infernal/Doomguard control gain
  and loss, and Eye of Kilrogg.
- Mage: every Forever summon that exposes a pet bar/token, including expiry and
  death.
- Priest: Mind Control start, successful control, commanded/AI attack, channel
  interruption/completion, controlled-unit death, and control loss.

At each point record availability/readability of `UnitExists`, `UnitGUID`,
`UnitName`, `UnitClass`, `UnitCreatureType`, `UnitCreatureFamily`, `UnitSex`,
`UnitHealth`, and the same identity calls for `pettarget`. Confirm that no
returned value is secret before logging or comparing it.

## Remaining implementation decisions

- Which secure observable API, if any, provides equivalent identity for pet-bar
  clicks and macros without treating execution outcomes as commands.
- How existing `petattackstart`/`petattackstop` content maps onto the approved
  command set without rewriting reactions; not every phrase necessarily fits
  Follow, Stay, Passive, Stop Attack, or a manual ability.
- Exact default probabilities and cooldown values within the approved existing
  policy model, including out-of-combat command behavior.
- Whether reactions containing unavailable `{TARGET}` remain filtered or are
  later reviewed editorially; this audit authorizes no rewrites.

## Validation summary

- Accounted for all 62 loaded pet-trigger reactions and their type totals.
- Accounted for all five pet placeholders, including unused `{PTSP}`/`{PTPP}`.
- Cross-checked the four legacy class catalogues, legacy generic pet corpus,
  event dispatch, and keyword replacement.
- Cross-checked production subscriptions, resolver behavior, policy routing,
  defaults, and existing tests.
- Distinguished API declarations/client-source usage from Forever behaviors
  that still require live capture.
