# Proposed private voice prototype

**Design only — 2026-11-07.** No Lua, settings, reaction text, audio assets,
provider accounts or production integration are changed. This proposal requires
human review before implementation or paid generation. It follows the
[feasibility recommendation](rphelper_voice_feasibility.md) and the
[pinned source investigation](voice_addon_architecture.md).

## Decision this prototype should answer

Can a few short, recognisable character voices and a separate narrator make
RPHelper feel more immersive, while preserving the existing selection engine
and delivering reliable private playback in Forever Interface 16001?

A pass would justify a separately scoped implementation/production decision.
It would not prove that all eighteen profiles, every template and arbitrary
player-written text can receive prerecorded audio.

## Voices and sample coverage

Four **original adult** identities, with no actor/character imitation:

| Profile | Initial direction, subject to audition |
| --- | --- |
| `tauren_male` | Low resonant register, warm texture, unhurried and grounded, clear short exclamations; no borrowed performance. |
| `orc_male` | Distinct mid-low register, forward energy, measured roughness and firm consonants; intelligibility before distortion. |
| `nightelf_female` | Clear adult mid register, restrained intensity, flowing but precise delivery; distinguishable without added effects. |
| `narrator` | Neutral, close, calm second-person narration, moderate pace; separate identity from all three characters. |

Use the same short calibration passages when comparing takes across days. Keep
one selected voice ID/reference set per profile and version it. A descriptive
prompt is not the identity identifier. Dialogue should sound like the
character speaking; narration should sound like an observing inner storyteller.
Do not use extreme pitch shifting to manufacture nominally different profiles.

### Ten Say reaction IDs

These are existing inventory entries. Nothing in this table edits them. Six
broad lines can be recorded in all three voices; racial lines stay within their
own race. The template is exhaustively covered only for Tauren.

| Existing ID | Source text / variant | Profiles | Takes |
| --- | --- | --- | ---: |
| `default:generic:0001` | So be it. | Three characters | 3 |
| `default:generic:0003` | Come on, then. | Three characters | 3 |
| `default:generic:0007` | Then we fight. | Three characters | 3 |
| `default:generic:0015` | That's done. | Three characters | 3 |
| `default:generic:0017` | Finished. | Three characters | 3 |
| `default:generic:0032` | Didn't even scratch me! | Three characters | 3 |
| `default:race:tauren:0001` | For my ancestors! | Tauren male | 1 |
| `default:race:orc:0001` | Strength and honor! | Orc male | 1 |
| `default:race:nightelf:0001` | For Cenarius! | Night Elf female | 1 |
| `default:race:tauren:0007` | Existing three-slot template, 2 × 2 × 3 combinations | Tauren male | 12 |
| **Total** | **10 IDs, with one finite randomized template** | | **33** |

The template must retain its exact canonical wording, punctuation and choice
order. Record the full concrete sentence for each of its twelve variants.
Do not concatenate separately voiced slots or randomly choose a recording
independently of the engine's already selected choices.

### Five Custom Emote scripts

The following are **proposed audio scripts in documentation**, not replacement
reaction content. Each needs an editorial/source-rights decision. A sidecar
script lets the original third-person chat text and reaction ID remain intact.

| Existing ID | Proposed narrator script | What it tests |
| --- | --- | --- |
| `default:generic:0009` | You set your stance and prepare for the fight. | Plain second-person agreement, short combat entry. |
| `default:generic:0021` | You lower your guard and survey the aftermath. | Post-combat narration and interruption policy. |
| `default:race:tauren:0013` | You plant your hooves and refuse to yield. | Anatomy remains race-specific; not reused for Orc/Night Elf. |
| `default:ability:shaman:0047` | You place a totem that launches bursts of fire at nearby foes. | The owner's Searing Totem case, without public chat. |
| `default:class:hunter:0019` | You grimace as the attack lands but steady your stance. | Stored `{PP}` resolves he/she/it possessive forms; explicit you/your script uses one recording. |

Five narrator recordings give **38 clips total**. The `hurt` and `absorb` detectors are
not currently implemented. Evaluate the Hunter hurt, Tauren hurt and Generic
absorb entries through a planned private prepared-candidate audition fixture,
not by pretending those live detectors exist. The same separation applies to
any unavailable template trigger.

Additional **unrecorded test fixture**, using existing content:
`default:ability:shaman:0130` / Ancestral Spirit Say contains `{TARGET}`. With no
reliable recipient context it must remain ineligible. A future private audition
fixture may supply an explicitly permitted target snapshot to exercise the
resolved-text/no-audio fallback. This does not authorize adding target
inference to the runtime or changing resurrection detection. It has no generic
name-substitute recording, and no additional production take is budgeted.

## Proposed assets and index

Possible future folders, **not created by this study**:

```text
RPHelperForever/                         existing addon
  Core/VoicePlayback.lua                proposed private playback boundary
  Data/VoiceProfiles.lua                 explicit verified player-token mapping
RPHelperForever_Voice_TaurenMale/
  RPHelperForever_Voice_TaurenMale.toc
  Manifest.lua
  Audio/enUS/say/<asset-key>.ogg
RPHelperForever_Voice_OrcMale/            same pack structure
RPHelperForever_Voice_NightElfFemale/     same pack structure
RPHelperForever_Voice_Narrator/
  RPHelperForever_Voice_Narrator.toc
  Manifest.lua
  Audio/enUS/narration/<asset-key>.ogg
audio-production/                       developer workspace outside addon ZIP
  scripts.json                          reviewed sidecar scripts/variant tuples
  profiles.json                         voice IDs, versioned direction/lexicon
  takes/                                immutable approved masters/provenance
```

Pack TOCs would declare Interface 16001, dependency, locale and pack format.
For this small test, register the installed manifest tables before combat;
load larger optional packs outside combat in a future design. Metadata and
file paths are cheap; do not “preload” by playing all sounds. Audio files are
installed assets, not Lua strings or entries requiring an individual TOC row.
New pack/file detection should use a **full client restart** as the reliable
prototype installation procedure; test `/reload` behaviour separately rather
than promising every newly copied file can be discovered mid-session.

An example naming pattern:

`rph1__say__generic_0001__v01__tauren_male__<digest>.ogg`

The build can derive `<digest>` from a complete tuple: original reaction ID,
source text/template revision, selected slot values, narration-script revision
where relevant, locale and voice-production version. Use filesystem-safe ASCII
segments; preserve the original ID in the manifest. Duplicate IDs may share a
single asset only when their approved script, profile and language agree.

For each entry, a proposed manifest records:

| Field | Purpose |
| --- | --- |
| Original reaction ID | Preserve weights, activation and character settings. |
| Profile and locale | Prevent cross-race or wrong-language fallback. |
| Exact source match / source revision | Reject stale recordings after edits; preserve meaningful punctuation/names. |
| Variant tuple | Tie the audio to the actual template expansion, not another random draw. |
| Approved audio script and its revision | Bind third-person source to a reviewed second-person narration. |
| Asset path, duration, content digest | Playback, subtitle lifetime and build-time integrity. |
| Voice version / provenance / rights reference | Reproducible packaging and reviewable ownership/consent history. |

A runtime need not calculate a cryptographic digest over arbitrary text:
lookup by ID/profile and compare the prepared concrete wording to the manifest's
exact expected source. For controlled pronouns, list the accepted resolved
forms explicitly. The offline build can hash the full source/script record.
This avoids treating a stable ID as proof an edited line still matches.

## Required future code changes, not implemented

1. Add small runtime-adapter methods for local playback, stopping an owned
   handle, and optional playback-state/audibility checks. Handle missing APIs,
   throwing calls, false/no-handle results and secret inputs defensively.
2. Add pack registration/lookup and the explicit profile map. Do not alter
   spell mappings, canonical content, SavedVariables schema or reaction IDs for
   the proof of concept. Test-only configuration can be session-local on a
   separate future prototype branch; persistent product settings need their
   own approved design.
3. Add a private output path after the existing candidate selection. Preserve
   Druid Say suppression, chance, Priority, quotas and activity gates. Existing
   templates may require retaining their chosen tuple, or matching the already
   expanded string; neither approach should make an extra random call.
4. Add one current-playback record with ID, source snapshot, time, duration,
   handle and generation token. Use a token to make late timers harmless after
   stop/replacement. No speculative long queue is needed for the prototype.
5. Add optional local subtitles showing the actual character or **Narrator**
   and the exact words heard. Text-only fallback remains distinguishable.
   Speaker name need not be spoken. Provide a stop control and keyboard access;
   subtitles should not intercept ordinary world/camera clicks.
6. Extend diagnostics with audio lookup outcome, queued/started/failed/stopped,
   chosen profile, fallback reason and local subtitle insertion. Do not use
   “heard” or “delivered to player” based on a boolean API return.
7. Add a private developer audition fixture for the chosen IDs and controlled
   prepared contexts. It must not transmit chat, introduce new event detectors,
   bypass missing required context in ordinary gameplay, or execute user text.

These are reviewable scope items, not changes applied to the current branch.
A future addon test build/packager must include only approved assets, manifest
and required notices. No provider key, paid-service client or master recording
belongs in the addon distribution.

## Proposed playback policy

- Fully private prototype mode: **no calls to public chat or native emote
  transmission APIs**, including in dungeons. This tests the proposed direction,
  while today's implementation remains unchanged by this research.
- World and five-player dungeons eligible under existing policy; raids and
  unknown activities muted. Druid nonhumanoid Say stays suppressed before
  playback; narration must not be used to relabel prohibited Say.
- Use a tested channel, initially Dialog, respecting master/channel enablement
  and volume. Do not silently switch to Master when Dialog is muted. Normalize
  recording loudness offline; no global CVar ducking or volume restoration logic
  is needed in the prototype.
- One owned sound at a time. For ordinary automatic reactions, an active line
  causes the new audio to drop to explicit local text rather than queue stale
  speech or interrupt. Preserve the already selected text and ID. Priority
  continues to mean the existing cooldown exception; it is not audio preemption.
- An explicit Stop ends the owned handle and its subtitle; entering a raid,
  disabling the prototype or unloading also stops owned playback. No automatic
  retry loop. Replay, if offered, restarts an approved local take and does not
  send chat or rerun event selection.
- Preserve normal successful-output accounting: successful audio start **or**
  successful local text fallback counts once; a failure of both counts zero.
  A busy/missing/muted recording must not bypass cooldown/quota via a second
  presentation attempt. Do not debit twice for audio plus its subtitle.
- No matching/stale file → local text, no replacement reaction or voice.
  If an approved narration script is absent, show the existing resolved source
  as text; do not manufacture a second-person sentence at runtime.
- Ordinary Emote tokens are excluded from voice generation. Test native Emote
  behaviour separately with explicit acknowledgement that it may be public;
  the private prototype must not claim it supplies an in-world animation.

## Proposed production process and budget

After explicit approval and rights clearance: audition four identities, freeze
voice IDs/reference takes and a short pronunciation guide, record/generate the
38 takes, verify every word, then normalize and encode one release format.
Keep accepted masters unchanged; new provider output is a new take. Do not
assume a seed/prompt recreates the same waveform. Human review must catch
omitted words, invented exclamations, drifting accent and unintended effects.

Use mono MP3 or Ogg Vorbis based on the codec test. Never rename Opus to `.ogg`
and assume Vorbis compatibility. A 3-second Say / 4.5-second narration budget
is **121.5 seconds** of finished audio. With the feasibility study's 8% allowance:

| Scenario | Approximate installed audio |
| --- | ---: |
| Vorbis at nominal 48 kbps | 0.79 MB |
| MP3 at 80 kbps | 1.31 MB |
| MP3 at 128 kbps | 2.10 MB |
| Uncompressed 44.1 kHz/16-bit mono masters, before allowance | 10.72 MB |

These are bitrate arithmetic, not encoded sizes or quality measurements. Some
Tauren template variants will exceed three seconds; allow **1–3 MB compressed**
for the listening build and record actual durations after production.

Using current GPT-Live session pricing from the [feasibility study](rphelper_voice_feasibility.md#cost-estimates-not-authorized-spending),
the finished-speech-only floor is about **$0.10**. A practical first audition
plan with 12–30 active session minutes is **$0.60–$1.50** in voice-session
charges. Reserve **$1–$5** for additional takes/idle time, plus any backend usage;
that is a planning allowance, not a purchase or a guarantee of model access or
verbatim quality. Human acting/editing, script clearance and listening dominate
the real production effort. No money was spent and no sample audio was made.

Current saved prompt voices require GPT-Live, not the legacy Speech endpoint.
Its conversational output must pass script-fidelity review. An offline tool
would capture approved output, trim it and package files; it is not installed
or running during gameplay. Evaluate a human-recorded option if exact short
script delivery or cross-session identity is unsatisfactory.

## Acceptance procedure in Forever

The procedure applies only to a future approved prototype build.

1. Record complete `GetBuildInfo()`, OS, audio device and addon versions. Back up
   the addon and SavedVariables. Install base plus the four test packs with a
   full game restart; confirm no companion or voice-service process is running.
   Keep the current test build available for rollback.
2. With sound enabled, audition a known fixed line manually, then trigger the
   same approved recording through an ordinary event callback. Confirm audible
   speech and matching local subtitle; retain API result/handle observations.
   Test automatic combat entry/exit and Searing Totem 3599 separately. A manual
   button success alone does not establish automatic-callback permission.
3. On Tauren male, Orc male and Night Elf female characters, verify race/sex
   mapping and the six shared Say lines. Ensure their racial lines never enter
   the other race's pool. Unknown profile or missing sex inspection must yield
   text, never a guessed voice. Other playable profiles are text-only for now.
4. For Searing Totem, isolate existing Custom Emote 0047 at 100% chance and weight
   10, with both Say entries disabled. Expect the narrator's exact approved
   second-person sentence, a local-only subtitle and one counted output. Repeat
   in world and dungeon. Confirm a consenting nearby observer sees no public
   reaction from this private prototype; inspect its output-adapter call log.
5. Audition all twelve Tauren template tuples deterministically through the
   private fixture, then normal random selections. Compare chosen text and
   recorded words. There must be no extra RNG draw or mismatch. Do not require
   an unimplemented trigger to fire simply to test its content template.
6. Test Hunter 0019 with each approved `{PP}` form in the private fixture. Listen
   for the same grammatical you/your script. For the unrecorded Ancestral Spirit
   target fixture: missing/restricted/irrelevant name remains ineligible;
   explicitly safe resolved context yields local text and `audio_missing`.
   Never expect current cast detection to identify a recipient it does not know.
7. In a temporary test-pack copy, remove a known file and also try an invalid
   path and stale manifest/text pair. Expect honest audio failure plus the same
   selected local text, not silence labelled “played,” another reaction, raw
   braces, guessed names or public chat. Restore the test pack afterward.
8. Fire multiple eligible attempts inside and outside cooldown; enable quota 1
   and exercise Priority. Verify exact existing accounting plus the busy-audio
   policy. Stop during playback, then start another line: old callbacks must not
   hide/stop the new one. Verify disabling and entering a raid stop playback.
9. Test master mute, Dialog mute, zero volume, missing device where practical,
   alt-tab and background-sound settings. The prototype must respect those
   settings; muted output does not switch channels. Subtitles/text remain useful.
10. Test raids/unknown activity and Druid humanoid versus nonhumanoid Say.
    Existing suppression must hold even with an installed recording. Inspect
    ordinary emotes separately for public side effects; never speak raw tokens.
11. Test with Spoken and LoreForever enabled individually and together. Check
    overlapping dialogue, captions and sound settings. Without a supported
    shared arbitration API, document a user choice to disable competing
    autoplay; do not promise a universal audio lock or modify their settings.
12. Reload/logout and restart: existing reaction IDs/settings/content must
    persist unchanged, active sounds must not resume unexpectedly, and the next
    eligible reaction must still work. Verify a second character's settings are
    independent. Save evidence before diagnostic capture resets.

## Acceptance criteria and evidence sheet

| Area | Proposed pass criterion |
| --- | --- |
| Privacy | Zero public output API invocations from the proposed mode; no nearby observer's RP output during controlled world/dungeon samples. |
| Playback | All 38 known assets start audibly when unmuted on the tested client; repeated automatic callback trials show no protected-action warning. Record 20 starts per profile, including narration. |
| Responsiveness | Measure cold and warm start separately from callback timestamp to audible onset using external test recording if needed. Initial target: warm p95 ≤250 ms, cold p95 ≤500 ms on the test machine; report actual method/results, not just call timing. These are proposed thresholds. |
| Script fidelity | No added/missing words or unresolved placeholders in accepted takes; all twelve template tuple/audio matches exact. |
| Identity | Two listeners can reliably distinguish the three character identities in blinded samples, target ≥90% identification; narrator never confused with character speech. Cross-session takes have no obvious identity drift. |
| Naturalness | Owner rates each identity and narration at least 4/5 for intelligibility and immersion; no unacceptable clipped starts, robotic joins or recurrent pronunciation errors. |
| Stop/overlap | Stop audibly ends only the owned clip, target ≤250 ms on test hardware; no accidental overlap of two RPHelper lines, no stale callback interference. |
| Failure safety | Missing/stale/busy/muted audio remains an honest local-text result or a documented user-mute outcome; no reroll, public escalation or double quota charge. |
| Preservation | Existing chance, cooldown, Priority, quota, Druid restrictions, activity restrictions, weights, IDs and persistence tests remain unchanged in behaviour. |
| Distribution | Archive has four optional data packs, no credentials/masters, correct paths, checked fingerprints and asset rights/credits. Works with no external gameplay app. |

For every trial save: build/OS/profile, event/ID, context, selected reaction and
variant, expected/actual spoken text, file/profile/revision, API result/handle,
start/stop/subtitle timing, audio settings and visible errors. Keep listening
judgements separate from API diagnostics. If the playback, privacy, identity or
rights gates fail, stop broad pack production and review the design.
