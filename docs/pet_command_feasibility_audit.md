# Player-Initiated Pet Actions Feasibility Audit

## Scope and conclusion

This audit asks whether RPHelper Forever can observe deliberate Hunter-pet and
Warlock-demon commands without replacing protected actions or inferring player
intent from pet behavior. It is documentation-only. No runtime, content, test,
SavedVariables, or event subscription changed.

The result is **plausible, but requires live-client verification**. The WoW
Forever API snapshot declares the relevant global command functions,
`CastPetAction`, pet-action inspection helpers, and `hooksecurefunc`. Current
upstream Blizzard UI source demonstrates candidate call paths from pet-bar
buttons and `/pet*` slash commands. Neither source proves that hooks see those
paths in the Forever client, that hook arguments remain readable, or that
pet-ability macros traverse the same functions.

No detection path is yet **supported by verified evidence** on the actual
Forever client. `PET_ATTACK_START`, `PET_ATTACK_STOP`, and pet spellcast success
report behavior or execution, not player initiation, and are not acceptable
substitutes.

The row-level findings and complete spellbook reconciliation are in
[`pet_command_ability_inventory.csv`](pet_command_ability_inventory.csv).

## Governing eligibility rule

V1.0 reacts at the observed player-command or manual-activation boundary:

- eligible: Pet Attack; Follow, Stay, Passive, or another deliberate command
  used to stop an attack; a manually activated pet ability; equivalent macros;
- ineligible: autonomous attacks or target changes, autocast activity,
  autocast toggling, and automatic attack cessation;
- irrelevant to eligibility: whether the pet accepted the command, acquired a
  target, cast successfully, hit, or produced an effect.

Hunter permanent pets and ordinary Warlock demons are the only V1.0 unit
categories. Pet critical hits and deaths remain post-V1.0.

## Evidence boundaries

### Forever declarations

The [Forever API snapshot](https://atraeau.github.io/WoW-Addons/) identifies
itself as `wow_classic_beta`, version `1.60.1`, interface `16001`, build
`70170`, built and exported on 1 October 2026. It declares:

- `PetAttack`, `PetFollow`, `PetWait`, `PetPassiveMode`, `PetStopAttack`, and
  `CastPetAction`;
- `GetPetActionInfo`, `C_PetInfo.GetSpellForPetAction`, and
  `C_PetInfo.IsPetActionPassive`;
- autocast inspection/toggle functions, including
  `C_ActionBar.IsAutoCastPetAction` and
  `C_ActionBar.IsEnabledAutoCastPetAction`;
- `hooksecurefunc`;
- payload-free `PET_ATTACK_START` and `PET_ATTACK_STOP` events.

Declaration establishes availability by name, not invocation path, hookability,
event delivery, argument readability, or protected-action safety. The snapshot
does not include the actual Forever pet-bar and secure macro implementation.

### Upstream implementation evidence

Current Blizzard UI source is comparison evidence, not proof of Forever
behavior. The `live` branch was inspected on 20 October 2026 and does not
identify itself as the Forever build. Its
[`PetActionBar.lua`](https://github.com/Gethe/wow-ui-source/blob/live/Interface/AddOns/Blizzard_ActionBar/Shared/PetActionBar.lua)
calls `CastPetAction(slot)` for a normal left-click or pet-action key binding
and calls `TogglePetAutocast(slot)` for the alternate click. Its
[`SlashCommands.lua`](https://github.com/Gethe/wow-ui-source/blob/live/Interface/AddOns/Blizzard_ChatFrameBase/Shared/SlashCommands.lua)
routes secure `/petattack`, `/petfollow`, `/petstay`, and `/petpassive`
commands to `PetAttack`, `PetFollow`, `PetWait`, and `PetPassiveMode`
respectively after conditional parsing. Its
[`SecureTemplates.lua`](https://github.com/Gethe/wow-ui-source/blob/live/Interface/AddOns/Blizzard_FrameXML/SecureTemplates.lua)
also defines a secure `pet` action that calls `CastPetAction(action, unit)`.

These paths make secure post-hooks plausible because they observe an existing
call rather than issue or replace it. They still require tests on the actual
Forever build. In particular, this audit found no evidence that a `/cast`
macro naming a pet ability must call the Lua-visible `CastPetAction` global.

### Existing and legacy RPHelper behavior

Forever currently subscribes to `UNIT_SPELLCAST_SUCCEEDED` for mapped player
abilities and rejects any `unitTarget` other than `player`. It has no pet
command detector, pet spell mappings, or enabled pet trigger. Existing tests
explicitly preserve that state.

The retained Turtle WoW implementation listened directly to payload-free
`PET_ATTACK_START` and `PET_ATTACK_STOP` and dispatched `petattackstart` and
`petattackstop`. That observed state transitions, not deliberate commands. It
cannot establish the V1.0 eligibility rule and must not be ported as the
detector.

## Command-by-command feasibility

| Player action | Default pet bar | Macro path | Candidate observation | Classification |
| --- | --- | --- | --- | --- |
| Attack | Upstream source calls `CastPetAction(slot)` | Upstream `/petattack` calls `PetAttack(resolvedTarget)` | Secure post-hook(s), with pet-slot classification for bar clicks | Plausible, requires live-client verification |
| Follow | Upstream source calls `CastPetAction(slot)` | Upstream `/petfollow` calls `PetFollow()` | Secure post-hook(s); react to issuance, not observed stopping | Plausible, requires live-client verification |
| Stay | Upstream source calls `CastPetAction(slot)` | Upstream `/petstay` calls `PetWait()` | Secure post-hook(s); Forever uses the declared `PetWait` name | Plausible, requires live-client verification |
| Passive | Upstream source calls `CastPetAction(slot)` | Upstream `/petpassive` calls `PetPassiveMode()` | Secure post-hook(s); do not treat later stop as the command | Plausible, requires live-client verification |
| Stop Attack | No distinct default-button route was established | No `/petstopattack` route was found in inspected upstream slash commands | `PetStopAttack` is declared, but its user-facing invocation path and hook visibility are unknown | Unsupported or deferred pending live evidence |
| Manual pet ability | Upstream source calls `CastPetAction(slot)` | `/cast` and conditional macro routing to `CastPetAction` were not established | Pet-bar post-hook is plausible; macro coverage is unproven | Pet bar plausible; macro form unsupported or deferred |

`PET_ATTACK_START` and `PET_ATTACK_STOP` may be recorded during diagnostics to
measure false correlations, but must never be the proof of player initiation.
Likewise, `UNIT_SPELLCAST_SUCCEEDED("pet", ...)` is an execution result and
cannot distinguish a manual activation from autocast.

### What live verification must establish

For every proposed hook, test that it:

1. runs after both mouse and key-bound default pet-bar activation without
   replacing, blocking, replaying, or tainting the protected action;
2. runs for the corresponding direct macro and a macro with conditions;
3. exposes a stable action slot or command identity before bar state changes;
4. does not run for autonomous behavior or an autocast firing;
5. distinguishes a left-click activation from enabling/disabling autocast;
6. behaves consistently in and out of combat and fails closed on protected,
   secret, missing, or malformed values.

If one command path fails these tests, defer that path. Do not fill the gap
with state events or successful spellcasts.

## Pet ability inventory

The [Hunter spellbook](https://wowforevertalent.com/abilities/hunter/) and
[Warlock spellbook](https://wowforevertalent.com/abilities/warlock/) are both
labelled “16 October 2026 Forever Beta book, client 1.60.1.70425.” The Hunter
Pets tab contains 31 named groups; the Warlock Demons tab contains 16. These
pages explicitly say their ranks have not been checked in game.

The catalogues establish names, rank groups, tooltip descriptions, resources,
cooldowns, and named families. They do not establish spell IDs, pet-bar slot
presence, manual activation, autocast availability, or runtime event behavior.
Accordingly, the CSV defers seven Hunter stat/resistance entries whose
tooltips show no activation, treats two Warlock aura-like entries as unclear,
and records the other 38 entries as candidate activations requiring live
verification. “RP
candidate” means that an intentional activation could reasonably select a
reaction under existing spam controls; it is not a recommendation to add
content.

None of the 47 pet/demon spellbook names has a matching pet-specific ability
identity in Forever's Hunter or Warlock ability catalogue. The existing
`DEMONIC_SACRIFICE` identity is the player's talent, not the Voidwalker's
`Sacrifice`, and must not be reused. Call Pet, Mend Pet, Revive Pet, Feed Pet,
Dismiss Pet, Eyes of the Beast, Bestial Wrath, demon summons, Health Funnel,
and similar player-cast abilities remain separate player abilities.

## Existing reaction coverage

Loaded class content currently contains:

| Class | `petattackstart` | `petattackstop` | `petdies` | Total |
| --- | ---: | ---: | ---: | ---: |
| Hunter | 12 | 8 | 7 | 27 |
| Warlock | 7 | 6 | 6 | 19 |

Thus V1 command-oriented pools contain 20 Hunter and 13 Warlock reactions;
the 13 death reactions remain deferred. The existing start/stop prose was
written for behavioral transitions. Mapping it to Attack versus
Follow/Stay/Passive/Stop Attack requires an explicit content-eligibility review
during implementation; this audit neither rewrites nor moves reactions.

There are no existing per-pet-ability reaction identities or registrations.
Supporting manual pet abilities therefore requires an owner decision about
whether to add individual identities and content later. Detection feasibility
alone does not authorize new reactions.

## Command-time placeholders

| Placeholder | Safe V1 source | Result |
| --- | --- | --- |
| `{PNAME}` | Readable current own `pet` identity at the verified command hook | Plausible; fail closed if unavailable or secret |
| `{PTNAME}` | A unit token explicitly and reliably resolved by the verified command path | Usually unresolved; macro-target handling needs live proof |
| `{PTSP}` | Verified commanded unit plus readable sex/pronoun mapping | Unresolved unless the same command supplies trustworthy target context |
| `{PTOP}` | Same requirement as `{PTSP}` | Unresolved unless proven; affected reactions stay ineligible |
| `{PTPP}` | Same requirement as `{PTSP}` | Unresolved unless proven |

A default pet-bar click commonly supplies only an action slot. The player's
selected target is not proof of the commanded target, and `pettarget` after
execution is too late to prove initiation context. A conditional or mouseover
macro may resolve a target internally, but this audit cannot establish that a
Forever hook exposes that resolved unit. Missing values must remain unresolved;
no pet-target tracker is recommended.

## Minimum V1.0 implementation recommendation

Implementation should remain blocked until the live matrix proves at least one
complete player-initiation path. Once proven, the smallest increment is:

1. Install secure post-hooks only for the verified command/activation
   functions; never call, replace, wrap, or replay the protected action.
2. For pet-bar calls, inspect the slot immediately with declared pet-action
   helpers and classify Attack, Follow, Stay, Passive, or a non-passive ability.
   Explicitly reject alternate-click autocast toggles and passive slots.
3. Add macro support only for command functions demonstrated to reach the same
   observable boundary. Keep `/cast` pet abilities deferred unless independently
   proven observable as manual activations.
4. Confirm a readable own `pet` and Hunter/Warlock player class; supply only
   command-time placeholder values that the observed call actually proves.
5. Dispatch through existing registration/preparation, probability, cooldown,
   quota, activity-aware routing, and output policy.
6. Do not add pet-state tracking, combat-log parsing, behavior-event
   subscriptions, or execution-success prerequisites.

This design can be stateless apart from existing policy state: one observed
player action creates at most one candidate dispatch. If a default click and a
command-function hook both fire for the same input on Forever, choose one
verified boundary rather than adding a general deduplication state machine.

## Explicitly deferred

- any detector based on `PET_ATTACK_START`, `PET_ATTACK_STOP`, pet target
  changes, or pet spellcast success;
- manual pet-ability macros until their player-initiation boundary is observed;
- a distinct Stop Attack path until its user-facing route is established;
- all autonomous activity and autocast firing or toggling;
- pet deaths and critical hits;
- spell IDs and new per-pet-ability reaction identities;
- Mage summons, Priest Mind Control, guardians, and unusual controlled units;
- pet-target tracking solely to fill placeholders.

## Required live-client matrix

On the supported Forever build, capture hook entry only—without instrumenting
or altering protected execution—for:

- each default pet-bar command by mouse and key binding;
- `/petattack`, `/petfollow`, `/petstay`, and `/petpassive`, with empty,
  conditional, selected-target, mouseover, focus, invalid, and no-target cases;
- any documented Stop Attack control;
- every visible Hunter/Warlock active pet slot by left click and key binding;
- direct and conditional macros naming those pet abilities;
- right-click autocast enable/disable and subsequent autonomous casts;
- defensive AI, autonomous acquisition, target switching, target death, and
  automatic cessation as negative controls;
- combat lockdown, world, dungeon, raid, PvP, zoning, pet replacement, and
  missing/secret unit values.

For each input record which hook fired, arguments, slot metadata, pet identity,
resolved target evidence, related state/spellcast events, and any blocked-action
or taint report. API declarations and upstream source remain assumptions until
this matrix succeeds on Forever.

## Validation summary

- Reconciled all 31 Hunter Pets and 16 Warlock Demons spellbook groups against
  the dated beta pages.
- Verified the loaded Hunter and Warlock pet reaction totals: 27 and 19.
- Cross-checked the prior pet-runtime and placeholder audits, current runtime
  classifier/tests, legacy pet event dispatch, and current ability catalogues.
- Distinguished declared Forever APIs, upstream implementation evidence, and
  behaviors requiring live Forever capture.
- The actual Forever client implementation was not available for inspection;
  no missing evidence was replaced with an assumed API behavior.
