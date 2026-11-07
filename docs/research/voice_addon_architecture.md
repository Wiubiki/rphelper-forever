# Voice addon architecture: Spoken and LoreForever

Research date: **2026-11-07**. Source inspection only; neither addon was run in
Forever for this study. No audio was generated. The corrected scope is Spoken
and LoreForever; Chronicle was not investigated.

## Executive findings

**Proven in inspected code:** both projects deliver installed recordings with
`PlaySoundFile`, retain sound handles, stop their own sounds, manage competing
lines, render local subtitles and distribute voice data separately. Their
selected core TOCs declare Forever Interface 16001. LoreForever's recordings do
not require its optional Willo application.

**Not proven by source inspection:** audible success from RPHelper's automatic
combat/cast callbacks on the owner's exact Forever build, decoder coverage,
latency, native-emote privacy, or the quality of eighteen character identities.
A compatible TOC and an upstream implementation are evidence, not a live test.

**Implication:** private prerecorded RP reactions are technically credible. Use
these architectures as references for a small independent implementation, with
text fallback for unavailable recordings. Do not import their recordings under
the assumption that an MIT code license grants audio rights. The companion
[feasibility study](rphelper_voice_feasibility.md) and
[prototype design](rphelper_voice_prototype.md) make no implementation approval.

## Revisions and compatibility

All code references below are pinned to these revisions; line numbers refer to
those files. Branch heads were resolved through the connected GitHub tools.

| Project | Actual upstream and inspected revision | Version evidence | License / compatibility limits |
| --- | --- | --- | --- |
| Spoken | [rusty-key/spoken-wow](https://github.com/rusty-key/spoken-wow), [`3219d17badfe8ab1a0c57973dd32cdaad9ae7c90`](https://github.com/rusty-key/spoken-wow/commit/3219d17badfe8ab1a0c57973dd32cdaad9ae7c90), 2026-11-06 | Core [`addons/Spoken/Spoken.toc`](https://github.com/rusty-key/spoken-wow/blob/3219d17badfe8ab1a0c57973dd32cdaad9ae7c90/addons/Spoken/Spoken.toc): 3.8.3, Interface 16001. Places pack TOC: 2.1.0, interfaces 11509/20506/16001. | Project-authored code MIT; third-party libraries and creative assets excluded. This is an inspected development revision, not a claim that every older release supports Forever. |
| LoreForever | [mliudev/LoreForever](https://github.com/mliudev/LoreForever), [`066c6968ea3fc2da919b7f46965181ca23aad971`](https://github.com/mliudev/LoreForever/commit/066c6968ea3fc2da919b7f46965181ca23aad971), 2026-11-06 | [`addon/LoreForever/LoreForever.toc`](https://github.com/mliudev/LoreForever/blob/066c6968ea3fc2da919b7f46965181ca23aad971/addon/LoreForever/LoreForever.toc): 1.2.0, Interface 16001; changelog dates 1.2.0 to Nov 6. Default pack also 1.2.0/16001. | Code MIT; lore text CC BY-SA 4.0; default narration all rights reserved. Community packs have their own credits and grants. |

Spoken's author describes the current project as developed for Forever, with
older client code retained. LoreForever's upstream provides `_forever_`
installation instructions and a manual ZIP. This supports using the above
versions as Forever references, without extrapolating permissions from Retail.
Sources: [Spoken README](https://github.com/rusty-key/spoken-wow/blob/3219d17badfe8ab1a0c57973dd32cdaad9ae7c90/README.md),
[LoreForever README](https://github.com/mliudev/LoreForever/blob/066c6968ea3fc2da919b7f46965181ca23aad971/README.md).

## Spoken: inspected implementation

| Concern | Source location and confirmed behaviour |
| --- | --- |
| Playback boundary | [`addons/Spoken/SoundUtils.lua:119–153`](https://github.com/rusty-key/spoken-wow/blob/3219d17badfe8ab1a0c57973dd32cdaad9ae7c90/addons/Spoken/SoundUtils.lua#L119) calls `PlaySoundFile(path, channel)`, stores `willPlay, handle`, and uses `StopSound(handle[, fadeMs])`. `PlaySound(SOUNDKIT.IG_QUEST_LOG_CLOSE, channel)` is a queue cue, not speech synthesis. |
| Audibility | Same file, lines 87–109: checks all-sound enablement, master volume, selected channel toggle and volume. A playback failure alone does not distinguish missing file from muted channel. |
| Queue | [`SoundQueue.lua`](https://github.com/rusty-key/spoken-wow/blob/3219d17badfe8ab1a0c57973dd32cdaad9ae7c90/addons/Spoken/SoundQueue.lua#L503), especially 503–529 and 608–735: one shared queue across sources, duplicate keys, normal/low priority, per-source backlog limits and admission gates. Dropped or missing clips advance the queue. Producer enqueue success is distinct from actual playback start. |
| End/stop | Queue lines 482–529 use recorded duration and optional `C_Sound.IsPlaying` polling to notice a cut voice. Lines 799–848 explain that stop/replay is not seekable pause: replay starts the file again. Do not infer a general audio seek API. |
| Automatic execution | [`Spoken_Places/Core.lua:670–696`](https://github.com/rusty-key/spoken-wow/blob/3219d17badfe8ab1a0c57973dd32cdaad9ae7c90/addons/Spoken_Places/Core.lua#L670) handles ordinary zone events; [`Audio.lua:543–560`](https://github.com/rusty-key/spoken-wow/blob/3219d17badfe8ab1a0c57973dd32cdaad9ae7c90/addons/Spoken_Places/Audio.lua#L543) supplies autoplay clips through the shared player. These are ordinary Lua producer paths, not secure chat-button tricks. Combat/instance gates remain policy choices and must be examined separately from API availability. |
| Quest indexing | [`Spoken_Quests/DataModules.lua:902–920`](https://github.com/rusty-key/spoken-wow/blob/3219d17badfe8ab1a0c57973dd32cdaad9ae7c90/addons/Spoken_Quests/DataModules.lua#L902): quest ID plus accept/progress/complete; gossip uses lookup hashes and aliases. Lines 1109–1180 resolve language, module priority, player-sex filename variants, file path, duration and optional word timings. It is indexed prerecorded content, not arbitrary text synthesis. |
| Places indexing | [`SpokenPlacesAudio/Data/Sounds.lua`](https://github.com/rusty-key/spoken-wow/blob/3219d17badfe8ab1a0c57973dd32cdaad9ae7c90/addons/SpokenPlacesAudio/Data/Sounds.lua#L9) contains `file`/`len` rows keyed by map and area; e.g. `1412\\zone`. The pack's sounds are installed under its `Sounds/` directory. |
| Pack loading | Quest data loader lines 287–327/377–438 discovers addon metadata and loads registered data modules. Places data registers into a shared pack registry. These mechanisms differ: the inspected Places pack is startup-loaded; quest packs can be load-on-demand. A data addon loading tables does not mean every audio file is decoded into Lua memory. |
| Missing content | [`Spoken_Places/Audio.lua:9–35`](https://github.com/rusty-key/spoken-wow/blob/3219d17badfe8ab1a0c57973dd32cdaad9ae7c90/addons/Spoken_Places/Audio.lua#L9) explicitly rejects a stand-in clip. Missing recordings remain silent/unavailable. Quest `Player.lua` reports separate missing-file and outranked-queue reasons. |
| Subtitles | [`UI/Transcript.lua:1–5`](https://github.com/rusty-key/spoken-wow/blob/3219d17badfe8ab1a0c57973dd32cdaad9ae7c90/addons/Spoken/UI/Transcript.lua#L1) uses text captured with each clip; timings are estimated unless supplied by the clip. [`UI/Subtitle.lua`](https://github.com/rusty-key/spoken-wow/blob/3219d17badfe8ab1a0c57973dd32cdaad9ae7c90/addons/Spoken/UI/Subtitle.lua#L42) implements fonts, wrapping, pages/scrolling and highlighting. `UI/MinimalPlayer.lua` has a portrait, speaker name, title and controls. |
| Volume/settings | [`Core.lua:48–106`](https://github.com/rusty-key/spoken-wow/blob/3219d17badfe8ab1a0c57973dd32cdaad9ae7c90/addons/Spoken/Core.lua#L48) defaults sound to Master, line gap to one second, and exposes subtitle appearance. `SoundUtils` can mute/fade Dialog and restores changes on logout. This can affect game NPC dialogue and other addons; it is not independent per-file gain. |

Spoken includes a test-before-queue option that briefly plays/stops a file to
probe it. That is observed source behaviour, **not a recommendation to probe
all RPHelper files at startup**. Known manifests and failure handling are more
appropriate for a small reaction pack. The quest loader also changes an
out-of-date-addon setting temporarily; RPHelper need not adopt that policy.

### Generation and packaging

[`apps/web/src/lib/generation/tts.ts`](https://github.com/rusty-key/spoken-wow/blob/3219d17badfe8ab1a0c57973dd32cdaad9ae7c90/apps/web/src/lib/generation/tts.ts#L55)
implements actual paid-service request construction: voice ID, model, settings,
optional seed, language and pronunciation dictionary locator. Multi-speaker
turns may be generated into one file. This code was inspected, **not executed**.
[`speakers/elevenlabs.ts:21–29,60–115`](https://github.com/rusty-key/spoken-wow/blob/3219d17badfe8ab1a0c57973dd32cdaad9ae7c90/apps/web/src/lib/generation/speakers/elevenlabs.ts#L21)
records a 44.1 kHz/128 kbps MP3 master format and generation provenance.
[`spoken-hash.ts`](https://github.com/rusty-key/spoken-wow/blob/3219d17badfe8ab1a0c57973dd32cdaad9ae7c90/apps/web/src/lib/generation/spoken-hash.ts)
hashes the actual spoken text so obsolete takes can be identified.

The [Places pipeline documentation](https://github.com/rusty-key/spoken-wow/blob/3219d17badfe8ab1a0c57973dd32cdaad9ae7c90/docs/places/VOICE.md)
distinguishes immutable takes and the current live take, pronunciation changes
and stale text. `generate.mjs` there only reports; synthesis happens through the
website. Human-recorded overlays are documented, but that document explicitly
says the addon does not yet read the Places overlay registry. Therefore the
existence of a recording upload/build tool does not prove in-game support for
that recording route.

[`scripts/quests/package-audio.sh:10–43,140–158,216–223`](https://github.com/rusty-key/spoken-wow/blob/3219d17badfe8ab1a0c57973dd32cdaad9ae7c90/scripts/quests/package-audio.sh#L10)
actually transcodes MP3 masters to mono Ogg **Vorbis**, 44.1 kHz, using `oggenc`;
FFmpeg decodes the masters. Alternative profiles include lower-rate Vorbis and
MP3. Duration tables come from the shipped encodes. Its approximately 3.2 GB →
1.3 GB claim is a script comment describing that corpus, not a measurement
performed here. Current release partitions and corpus sizes change; use the
pinned script rather than assuming old README pack counts remain exact.

Code is MIT, but [`THIRD_PARTY.md:181–187`](https://github.com/rusty-key/spoken-wow/blob/3219d17badfe8ab1a0c57973dd32cdaad9ae7c90/THIRD_PARTY.md#L181)
identifies ElevenLabs/fish.audio synthesis and excludes generated packs/game
text from the code grant. Voices and seeds improve controlled production;
source inspection does not establish bit-identical regeneration or blanket
asset reuse rights.

## LoreForever: inspected implementation

| Concern | Source location and confirmed behaviour |
| --- | --- |
| Playback | [`addon/LoreForever/Voice.lua:1836–1913`](https://github.com/mliudev/LoreForever/blob/066c6968ea3fc2da919b7f46965181ca23aad971/addon/LoreForever/Voice.lua#L1836) stops previous narration, resolves candidate paths, protects `PlaySoundFile`, records its handle and clip identity, and returns whether playback started. File fallback is indexed, not synthesis. |
| Stop/state | Same file 1503–1508 stops current and segment-tail handles; 1693–1697 optionally queries `C_Sound.IsPlaying`. Segment transport uses recorded boundaries and timers, including an early handoff. This is pre-split audio, not arbitrary engine seeking. Playback rate is currently fixed at 1. |
| Volume | `Voice.lua:65–136`: Dialog default; selectable SFX/Music/Ambience/Master; volume UI changes the actual chosen channel CVar. When that channel is switched off, it selects Master. This is an upstream design choice; it would conflict with an RPHelper policy that respects a muted channel, so do not copy it automatically. |
| Event-driven autoplay | [`Core.lua:721–744`](https://github.com/mliudev/LoreForever/blob/066c6968ea3fc2da919b7f46965181ca23aad971/addon/LoreForever/Core.lua#L721) calls arrival/combat handlers from zone and regen events. `Voice.lua:2203–2222,2279+` starts arrival playback through the UI controller after policy checks. Group-combat settling is product policy, not proof of a blanket protected audio API. |
| Pack discovery | [`Packs.lua:177–250`](https://github.com/mliudev/LoreForever/blob/066c6968ea3fc2da919b7f46965181ca23aad971/addon/LoreForever/Packs.lua#L177) scans installed addon metadata, validates format, and loads chosen packs; it refuses new pack loading during combat. Loaded tables are retained. |
| Pack registration | [`LoreForever_Voice_Default.toc`](https://github.com/mliudev/LoreForever/blob/066c6968ea3fc2da919b7f46965181ca23aad971/addon/LoreForever_Voice_Default/LoreForever_Voice_Default.toc) declares dependency, load-on-demand, locale and format. [`Clips.lua`](https://github.com/mliudev/LoreForever/blob/066c6968ea3fc2da919b7f46965181ca23aad971/addon/LoreForever_Voice_Default/Clips.lua) calls `LoreForeverPacks.Begin` and populates clip ID → text fingerprint. |
| Naming/version match | `Voice.lua:199–202`: `zone:stormwind#faq3` becomes `Audio\\zone_stormwind__faq3.mp3`; optional extension support. Lines 392–417 check current text fingerprints or scoped recorded scripts. This is particularly relevant to edited RPHelper reactions. |
| Partial/missing pack | An ordered, enabled voice list supplies current recordings; no match remains text. The very first comment in `Voice.lua` explicitly says client-native TTS is no longer used. A separate pack's own words can drive its matching subtitles. |
| Subtitle UI | [`Subtitles.lua:1–23,153+,336+`](https://github.com/mliudev/LoreForever/blob/066c6968ea3fc2da919b7f46965181ca23aad971/addon/LoreForever/Subtitles.lua#L1): local band, title, wrapping, word highlight, scale and Shift-drag movement; it follows the playback controller rather than starting audio. Timing uses transport, recorded duration, or an estimated per-voice reading speed. An approximate highlight is not a phoneme alignment. |
| Competition | `Voice.lua:3042–3123` detects known other voice addons and yields/disables overlapping automatic features. Several name-prefix checks retain older Spoken names, so this is best-effort compatibility, not a universal cross-addon audio lock. |

The [upstream README](https://github.com/mliudev/LoreForever/blob/066c6968ea3fc2da919b7f46965181ca23aad971/README.md)
separates offline recorded narration from optional **Willo**. The latter is an
external product, not a requirement of these `PlaySoundFile` paths. Manual ZIP
installation is supported; an installer is a distribution convenience, not a
process that must run while hearing prerecorded clips.

### Assets, production and rights

[`release/audio.json`](https://github.com/mliudev/LoreForever/blob/066c6968ea3fc2da919b7f46965181ca23aad971/release/audio.json)
records the default pack as **299 files / 124,934,187 bytes**. All 61 listed
packs total **15,765,438,390 bytes**; that is the multi-language/multi-voice
asset manifest, not the required base install or a RAM estimate.
[`scripts/audio_assets.py:59–63,104–191,451+`](https://github.com/mliudev/LoreForever/blob/066c6968ea3fc2da919b7f46965181ca23aad971/scripts/audio_assets.py#L59)
stores deterministic MP3/OGG bundles in GitHub release assets, checks names,
counts, bytes and SHA-256 fingerprints, and reconstructs assets separately from
source Git history. None of its fetch/upload/build commands were run here.

The [author's narrator guide](https://loreforeverwow.com/voices/guide) specifies
exact scripts, matching names, mono 44.1/48 kHz, MP3 or Vorbis delivery, and a
voice-only loudness target. Its upload service converts other input formats;
that does **not** demonstrate that WoW decodes those formats. The
[narrator release](https://loreforeverwow.com/voices/release) grants community
recording distribution separately from voice cloning. These are documented
contributor processes, not an inspected public synthesis engine. The README
says the data-building tool is separate from this repository. A specific
[Ukrainian pack credit](https://github.com/mliudev/LoreForever/blob/066c6968ea3fc2da919b7f46965181ca23aad971/addon/LoreForever_Voice_Default_ukUA/CREDITS.txt)
identifies ElevenLabs, so it would also be wrong to classify all packs as
human-recorded. The default English generation process/settings cannot be
reproduced from the inspected public files.

The [license](https://github.com/mliudev/LoreForever/blob/066c6968ea3fc2da919b7f46965181ca23aad971/LICENSE)
explicitly reserves default narration rights. Community grants, text adaptation
rights and provider terms require separate review; a file being downloadable
is not a general permission to reuse its narrator in RPHelper.

## Shared conclusions and Forever API boundary

- Both addons use installed paths and Lua indexes; neither of the examined
  prerecorded paths needs network streaming or audio generation in WoW.
  Metadata can be registered/loaded separately; sound decoding/caching is the
  client's responsibility. Neither project supplies a measured guarantee of
  zero cold-start delay.
- MP3 and Ogg **Vorbis** have concrete production evidence here. Ogg is a
  container: support for Vorbis does not prove Opus support. WAV/FLAC/AAC/PCM
  generation/export support in an external tool is not Forever playback proof.
- `PlaySoundFile` acceptance is a stronger local playback signal than void chat
  dispatch, but it still does not prove the user heard it: channel mute, zero
  volume, device, alt-tab and audio focus matter. Keep failed/started/stopped
  states distinct. Do not label a file failure as protected without evidence.
- Sound handles identify sounds this addon started. Stop only those handles;
  do not stop all speech, voice chat, or another addon's accessibility output.
- CVar ducking/muting is global shared state. Multiple addons changing Dialog
  volume can undo each other's restoration; RPHelper should start without it.
- Subtitles need independent enablement, readable size/contrast, a stable
  speaker/narrator label, no stolen clicks and a text-only route for missing
  audio. Fine word highlighting is optional polish, not a prerequisite.

For client-native TTS, the mirrored Forever API revision
[`Gethe/wow-ui-source@9dc84f0d3bbae1768ac3405b3716000bd93eda06`](https://github.com/Gethe/wow-ui-source/tree/9dc84f0d3bbae1768ac3405b3716000bd93eda06)
contains [`VoiceChatDocumentation.lua:399,864–880`](https://github.com/Gethe/wow-ui-source/blob/9dc84f0d3bbae1768ac3405b3716000bd93eda06/Interface/AddOns/Blizzard_APIDocumentationGenerated/VoiceChatDocumentation.lua#L864):
`GetTtsVoices`, `SpeakText(voiceID,text,rate,volume,overlap)` and
`StopSpeakingText`. This establishes a candidate native interface, not eighteen
fantasy voices or a live permission/quality guarantee. OS/client voice
availability and whether stopping would interrupt another TTS consumer require
testing. No TTS synthesis was invoked.

The same revision's [Sound documentation](https://github.com/Gethe/wow-ui-source/blob/9dc84f0d3bbae1768ac3405b3716000bd93eda06/Interface/AddOns/Blizzard_APIDocumentationGenerated/SoundDocumentation.lua)
exposes `C_Sound.IsPlaying`, newer sound-kit methods and `SOUNDKIT_FINISHED`.
Their signatures differ from the global APIs used above; the event's existence
does not prove that global `PlaySoundFile` custom clips produce it. Use measured
asset durations until a client test establishes a reliable completion signal.
Similarly, retain the [existing emote API uncertainty](../emote_output_test.md):
public emote permission and private audio permission are separate questions.
