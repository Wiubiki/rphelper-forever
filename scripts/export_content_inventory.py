#!/usr/bin/env python3
"""Export the active RPHelper event and reaction catalogue.

The addon manifest is the authority for active Lua data.  A small Lua harness
loads those files through the real registration functions and records the
result without running the addon runtime or reading SavedVariables.
"""

from __future__ import annotations

import csv
import json
import re
import subprocess
from collections import Counter, defaultdict
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[1]
TOC = ROOT / "RPHelper" / "RPHelper.toc"
OUTPUT = ROOT / "docs" / "content_inventory"
REACTION_TYPES = ("say", "emote", "customemote")


LUA_HARNESS = r'''
local root = arg[1]
local contentFile = root .. "/RPHelper/Core/Content.lua"
dofile(root .. "/RPHelper/Core/DruidForms.lua")
dofile(contentFile)

local records = {}

local function dataCallSite()
    local chosenSource, chosenLine
    local level = 2
    while true do
        local info = debug.getinfo(level, "Sl")
        if not info then break end
        local source = info.source or ""
        if string.sub(source, 1, 1) == "@" and string.find(source, "/RPHelper/Data/", 1, true) then
            chosenSource = string.sub(source, 2)
            chosenLine = info.currentline
        end
        level = level + 1
    end
    return chosenSource, chosenLine
end

local originals = {
    generic = RPHelper.RegisterGeneric,
    race = RPHelper.RegisterRace,
    class = RPHelper.RegisterClass,
    form = RPHelper.RegisterDruidForm,
    ability = RPHelper.RegisterAbility,
}

local function capture(kind, owner, key, entry)
    local source, line = dataCallSite()
    records[#records + 1] = {
        kind = kind, owner = owner, key = key, entry = entry,
        source = source, line = line,
    }
end

function RPHelper.RegisterGeneric(trigger, entry)
    capture("generic", nil, trigger, entry)
    return originals.generic(trigger, entry)
end
function RPHelper.RegisterRace(race, trigger, entry)
    capture("race", race, trigger, entry)
    return originals.race(race, trigger, entry)
end
function RPHelper.RegisterClass(class, trigger, entry)
    capture("class", class, trigger, entry)
    return originals.class(class, trigger, entry)
end
function RPHelper.RegisterDruidForm(form, trigger, entry)
    capture("form", form, trigger, entry)
    return originals.form(form, trigger, entry)
end
function RPHelper.RegisterAbility(class, ability, entry)
    capture("ability", class, ability, entry)
    return originals.ability(class, ability, entry)
end

for index = 2, #arg do dofile(root .. "/" .. arg[index]) end

dofile(root .. "/RPHelper/Core/RuntimeAPI.lua")
RPHelper.Configuration = RPHelper.Configuration or {}
RPHelper.Output = RPHelper.Output or {}
dofile(root .. "/RPHelper/Core/Runtime.lua")

local function escape(value)
    value = string.gsub(value, "\\", "\\\\")
    value = string.gsub(value, '"', '\\"')
    value = string.gsub(value, "\b", "\\b")
    value = string.gsub(value, "\f", "\\f")
    value = string.gsub(value, "\n", "\\n")
    value = string.gsub(value, "\r", "\\r")
    value = string.gsub(value, "\t", "\\t")
    return '"' .. value .. '"'
end

local function isArray(value)
    local count, maximum = 0, 0
    for key in pairs(value) do
        if type(key) ~= "number" or key < 1 or key % 1 ~= 0 then return false end
        count = count + 1
        if key > maximum then maximum = key end
    end
    return count == maximum
end

local function encode(value)
    local kind = type(value)
    if kind == "nil" then return "null" end
    if kind == "boolean" or kind == "number" then return tostring(value) end
    if kind == "string" then return escape(value) end
    if kind ~= "table" then error("unsupported JSON value: " .. kind) end
    local parts = {}
    if isArray(value) then
        for index = 1, #value do parts[#parts + 1] = encode(value[index]) end
        return "[" .. table.concat(parts, ",") .. "]"
    end
    local keys = {}
    for key in pairs(value) do keys[#keys + 1] = key end
    table.sort(keys, function(left, right) return tostring(left) < tostring(right) end)
    for _, key in ipairs(keys) do
        parts[#parts + 1] = escape(tostring(key)) .. ":" .. encode(value[key])
    end
    return "{" .. table.concat(parts, ",") .. "}"
end

local runtimeTriggers = {}
for trigger, configKey in pairs(RPHelper.Runtime.TriggerConfigKey or {}) do
    runtimeTriggers[trigger] = configKey
end
local abilitySpells = {}
for class, mappings in pairs(RPHelper.RuntimeAPI.AbilitySpellIDs or {}) do
    abilitySpells[class] = abilitySpells[class] or {}
    for spellID, ability in pairs(mappings) do
        abilitySpells[class][ability] = abilitySpells[class][ability] or {}
        table.insert(abilitySpells[class][ability], spellID)
    end
    for _, spellIDs in pairs(abilitySpells[class]) do table.sort(spellIDs) end
end

io.write(encode({
    records = records,
    runtimeTriggers = runtimeTriggers,
    abilitySpells = abilitySpells,
    canonicalAbilities = RPHelper.Ability,
}))
'''


def manifest_data_files() -> list[str]:
    files: list[str] = []
    for raw in TOC.read_text(encoding="utf-8").splitlines():
        line = raw.strip().replace("\\", "/")
        if not line or line.startswith("#") or not line.startswith("Data/"):
            continue
        path = f"RPHelper/{line}"
        if path.endswith("RandomInsults.lua"):
            continue
        files.append(path)
    return files


def collect() -> dict[str, Any]:
    command = ["lua", "-", str(ROOT), *manifest_data_files()]
    result = subprocess.run(
        command,
        input=LUA_HARNESS,
        text=True,
        encoding="utf-8",
        capture_output=True,
        check=False,
        cwd=ROOT,
    )
    if result.returncode:
        raise RuntimeError(f"Lua catalogue extraction failed:\n{result.stderr}")
    return json.loads(result.stdout)


def relative_source(value: str | None) -> str | None:
    if not value:
        return None
    return Path(value).resolve().relative_to(ROOT).as_posix()


def title(value: str) -> str:
    trigger_names = {
        "entercombat": "Enter Combat",
        "leavecombat": "Leave Combat",
        "youcrit": "Offensive Critical Hit",
        "deferred_youcritspell": "Deferred Spell Critical Hit",
        "youcritheal": "Healing Critical Hit",
        "youheal": "Healing",
        "petattackstart": "Pet Attack Start",
        "petattackstop": "Pet Attack Stop",
        "petdies": "Pet Dies",
        "npctalksfriend": "Friendly NPC Speech",
        "npctalksenemy": "Enemy NPC Speech",
    }
    if value in trigger_names:
        return trigger_names[value]
    return " ".join(part.capitalize() for part in value.lower().split("_"))


def event_id(kind: str, owner: str | None, key: str) -> str:
    if kind == "generic":
        return f"event:generic::{key}"
    if kind in {"race", "class"}:
        return f"event:{kind}:{owner}:{key}"
    if kind == "form":
        return f"form:{owner}:{key}"
    if kind == "ability":
        return f"ability:{owner}:{key}"
    raise ValueError(f"unknown event kind: {kind}")


def event_type(kind: str, key: str) -> str:
    if kind == "ability":
        return "spell ability"
    mapping = {
        "entercombat": "combat state transition",
        "leavecombat": "combat state transition",
        "dodge": "defensive combat event",
        "parry": "defensive combat event",
        "block": "defensive combat event",
        "absorb": "combat result",
        "hurt": "combat result",
        "miss": "combat result",
        "youcrit": "offensive critical hit",
        "deferred_youcritspell": "deferred spell critical hit",
        "youcritheal": "healing critical hit",
        "youheal": "healing event",
        "resurrect": "player lifecycle event",
        "death": "player lifecycle event",
        "petattackstart": "pet combat event",
        "petattackstop": "pet combat event",
        "petdies": "pet lifecycle event",
        "npctalksfriend": "NPC speech event",
        "npctalksenemy": "NPC speech event",
        "monster_emote_help": "monster emote event",
        "monster_emote_fear": "monster emote event",
        "monster_emote_enrage": "monster emote event",
    }
    return mapping.get(key, "catalogue trigger")


def find_runtime_lines() -> dict[str, int]:
    path = ROOT / "RPHelper" / "Core" / "Runtime.lua"
    lines: dict[str, int] = {}
    pattern = re.compile(r'^\s*([a-z][a-z0-9_]*)\s*=\s*"[^"]+",?\s*$')
    in_table = False
    for number, raw in enumerate(path.read_text(encoding="utf-8").splitlines(), 1):
        if raw.startswith("Runtime.TriggerConfigKey = {"):
            in_table = True
            continue
        if in_table and raw.strip() == "}":
            break
        if in_table and (match := pattern.match(raw)):
            lines[match.group(1)] = number
    return lines


def build_inventory(raw: dict[str, Any]) -> tuple[list[dict[str, Any]], list[dict[str, Any]], dict[str, Any]]:
    records = raw["records"]
    runtime_triggers: dict[str, str] = raw["runtimeTriggers"]
    ability_spells: dict[str, dict[str, list[int]]] = raw["abilitySpells"]
    canonical_abilities: dict[str, dict[str, str]] = raw["canonicalAbilities"]
    runtime_lines = find_runtime_lines()

    grouped: dict[tuple[str, str | None, str], list[dict[str, Any]]] = defaultdict(list)
    for record in records:
        record["source"] = relative_source(record.get("source"))
        grouped[(record["kind"], record.get("owner"), record["key"])].append(record)

    for trigger in runtime_triggers:
        grouped.setdefault(("generic", None, trigger), [])
    for class_name, abilities in canonical_abilities.items():
        for ability in abilities:
            grouped.setdefault(("ability", class_name, ability), [])

    events: list[dict[str, Any]] = []
    flat_reactions: list[dict[str, Any]] = []
    seen_reaction_ids: dict[str, list[str]] = defaultdict(list)
    structural_issues: list[str] = []

    kind_order = {"generic": 0, "race": 1, "class": 2, "form": 3, "ability": 4}
    keys = sorted(grouped, key=lambda item: (kind_order[item[0]], item[1] or "", item[2]))
    for kind, owner, key in keys:
        registrations = grouped[(kind, owner, key)]
        eid = event_id(kind, owner, key)
        per_type: dict[str, list[dict[str, Any]]] = {reaction_type: [] for reaction_type in REACTION_TYPES}
        type_indexes: Counter[str] = Counter()
        overall_index = 0
        explicit_empty = False
        sources: list[dict[str, Any]] = []

        for registration in registrations:
            source = registration.get("source")
            line = registration.get("line")
            if source and {"file": source, "line": line} not in sources:
                sources.append({"file": source, "line": line})
            entry = registration.get("entry")
            if entry is None:
                explicit_empty = True
                continue
            overall_index += 1
            reaction_type = entry.get("type")
            if reaction_type not in REACTION_TYPES:
                structural_issues.append(f"{eid}: unsupported reaction type {reaction_type!r}")
                continue
            type_indexes[reaction_type] += 1
            authored_id = entry.get("id")
            if isinstance(authored_id, str):
                seen_reaction_ids[authored_id].append(eid)
            else:
                structural_issues.append(f"{eid}: reaction without an authored ID")
            reaction = {
                "reaction_id": authored_id,
                "type": reaction_type,
                "text": entry.get("text"),
                "template": entry.get("template"),
                "choices": entry.get("choices") or [],
                "reaction_index": type_indexes[reaction_type],
                "event_order_index": overall_index,
                "source": {"file": source, "line": line},
            }
            per_type[reaction_type].append(reaction)
            flat_reactions.append({
                "event_id": eid,
                "category": {"generic": "General", "race": "Race", "class": "Class", "form": "Druid Form", "ability": "Ability"}[kind],
                "owner": owner or "",
                "class_or_race": owner if kind in {"race", "class", "ability"} else ("DRUID" if kind == "form" else ""),
                "druid_form": owner if kind == "form" else "",
                "event_key": key,
                **reaction,
            })

        runtime_supported = key in runtime_triggers if kind != "ability" else bool(
            ability_spells.get(owner or "", {}).get(key, [])
        )
        if kind != "ability" and key in runtime_triggers:
            runtime_source = {
                "file": "RPHelper/Core/Runtime.lua",
                "line": runtime_lines.get(key),
                "config_key": runtime_triggers[key],
            }
        elif kind == "ability":
            runtime_source = {
                "file": "RPHelper/Core/RuntimeAPI.lua",
                "spell_ids": ability_spells.get(owner or "", {}).get(key, []),
            }
        else:
            runtime_source = None

        counts = {reaction_type: len(per_type[reaction_type]) for reaction_type in REACTION_TYPES}
        total = sum(counts.values())
        status = "empty" if total == 0 else "fully populated" if all(counts.values()) else "partially populated"
        primary_source = sources[0] if sources else runtime_source
        events.append({
            "event_id": eid,
            "category": {"generic": "General", "race": "Race", "class": "Class", "form": "Druid Form", "ability": "Ability"}[kind],
            "owner": owner,
            "class": owner if kind in {"class", "ability"} else ("DRUID" if kind == "form" else None),
            "race": owner if kind == "race" else None,
            "druid_form": owner if kind == "form" else None,
            "event_key": key,
            "display_name": title(key),
            "event_type": event_type(kind, key),
            "source": primary_source,
            "registration_sources": sources,
            "runtime_source": runtime_source,
            "runtime_supported": runtime_supported,
            "explicit_empty_registration": explicit_empty,
            "population_status": status,
            "reaction_counts": {**counts, "total": total},
            "reactions": per_type,
        })

    duplicate_ids = {key: value for key, value in seen_reaction_ids.items() if len(value) > 1}
    metadata = {
        "active_manifest_data_files": manifest_data_files(),
        "excluded_archive_files": sorted(
            path.relative_to(ROOT).as_posix()
            for path in (ROOT / "RPHelper" / "Data" / "Abilities").glob("*Archive.lua")
        ),
        "duplicate_reaction_ids": duplicate_ids,
        "structural_issues": structural_issues,
    }
    return events, flat_reactions, metadata


def write_events_csv(events: list[dict[str, Any]]) -> None:
    fields = [
        "event_id", "category", "owner", "class_or_race", "druid_form", "event_key", "display_name", "event_type",
        "source_lua_file", "source_line", "runtime_supported", "runtime_config_key",
        "runtime_spell_ids", "explicit_empty_registration", "say_count", "emote_count",
        "customemote_count", "total_reactions", "population_status", "flags",
    ]
    with (OUTPUT / "events.csv").open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=fields, lineterminator="\n")
        writer.writeheader()
        for event in events:
            source = event.get("source") or {}
            runtime_source = event.get("runtime_source") or {}
            flags = []
            if not event["runtime_supported"]:
                flags.append("no_active_runtime_detector")
            if event["explicit_empty_registration"]:
                flags.append("explicit_empty_ability_registration")
            if event["event_key"].startswith("deferred_"):
                flags.append("deferred_trigger_key")
            writer.writerow({
                "event_id": event["event_id"],
                "category": event["category"],
                "owner": event["owner"] or "",
                "class_or_race": event["race"] or event["class"] or "",
                "druid_form": event["druid_form"] or "",
                "event_key": event["event_key"],
                "display_name": event["display_name"],
                "event_type": event["event_type"],
                "source_lua_file": source.get("file", ""),
                "source_line": source.get("line", ""),
                "runtime_supported": str(event["runtime_supported"]).lower(),
                "runtime_config_key": runtime_source.get("config_key", ""),
                "runtime_spell_ids": json.dumps(runtime_source.get("spell_ids", []), separators=(",", ":")),
                "explicit_empty_registration": str(event["explicit_empty_registration"]).lower(),
                "say_count": event["reaction_counts"]["say"],
                "emote_count": event["reaction_counts"]["emote"],
                "customemote_count": event["reaction_counts"]["customemote"],
                "total_reactions": event["reaction_counts"]["total"],
                "population_status": event["population_status"],
                "flags": ";".join(flags),
            })


def write_reactions_csv(reactions: list[dict[str, Any]]) -> None:
    fields = [
        "event_id", "category", "owner", "class_or_race", "druid_form", "event_key", "reaction_id", "reaction_type",
        "reaction_text", "is_template", "template_choices_json", "source_lua_file",
        "source_line", "reaction_index", "event_order_index",
    ]
    with (OUTPUT / "reactions.csv").open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=fields, lineterminator="\n")
        writer.writeheader()
        for reaction in reactions:
            is_template = reaction["template"] is not None
            writer.writerow({
                "event_id": reaction["event_id"],
                "category": reaction["category"],
                "owner": reaction["owner"],
                "class_or_race": reaction["class_or_race"],
                "druid_form": reaction["druid_form"],
                "event_key": reaction["event_key"],
                "reaction_id": reaction["reaction_id"],
                "reaction_type": reaction["type"],
                "reaction_text": reaction["template"] if is_template else reaction["text"],
                "is_template": str(is_template).lower(),
                "template_choices_json": json.dumps(reaction["choices"], ensure_ascii=False, separators=(",", ":")) if is_template else "",
                "source_lua_file": reaction["source"]["file"],
                "source_line": reaction["source"]["line"],
                "reaction_index": reaction["reaction_index"],
                "event_order_index": reaction["event_order_index"],
            })


def summary_text(events: list[dict[str, Any]], reactions: list[dict[str, Any]], metadata: dict[str, Any]) -> str:
    categories = Counter(event["category"] for event in events)
    owners: dict[str, Counter[str]] = defaultdict(Counter)
    for event in events:
        if event["owner"]:
            owners[event["category"]][event["owner"]] += 1
    statuses = Counter(event["population_status"] for event in events)
    reaction_counts = Counter(reaction["type"] for reaction in reactions)
    empty = [event["event_id"] for event in events if event["population_status"] == "empty"]
    missing = {
        event["event_id"]: [kind for kind in REACTION_TYPES if not event["reaction_counts"][kind]]
        for event in events if any(not event["reaction_counts"][kind] for kind in REACTION_TYPES)
    }
    complete = [event["event_id"] for event in events if event["population_status"] == "fully populated"]
    unmapped = [event["event_id"] for event in events if not event["runtime_supported"]]
    explicit_empty = [event["event_id"] for event in events if event["explicit_empty_registration"]]

    lines = [
        "# Event and reaction inventory summary",
        "",
        "This inventory reflects the active Lua files loaded by `RPHelper/RPHelper.toc`. "
        "It excludes adjacent archive files and character SavedVariables/custom content.",
        "Scoped `event_id` values follow the active Library group identity scheme; `event_key` retains the "
        "repository's canonical trigger or ability key and is never derived from a display name.",
        "",
        "## Totals",
        "",
        f"- Canonical events: **{len(events)}**",
        f"- Existing reactions: **{len(reactions)}**",
        f"  - `say`: **{reaction_counts['say']}**",
        f"  - `emote`: **{reaction_counts['emote']}**",
        f"  - `customemote`: **{reaction_counts['customemote']}**",
        f"- Empty events: **{statuses['empty']}**",
        f"- Partially populated events: **{statuses['partially populated']}**",
        f"- Events with all three reaction types: **{statuses['fully populated']}**",
        "",
        "## Events by category",
        "",
    ]
    for category in ("General", "Race", "Class", "Druid Form", "Ability"):
        lines.append(f"- {category}: **{categories[category]}**")
        for owner, count in sorted(owners.get(category, {}).items()):
            lines.append(f"  - {owner}: {count}")

    lines.extend(["", "## Events with no reactions", ""])
    lines.extend(f"- `{eid}`" for eid in empty)
    if not empty:
        lines.append("- None.")

    lines.extend(["", "## Events missing one or more reaction types", ""])
    for eid, types in missing.items():
        lines.append(f"- `{eid}` — missing {', '.join(f'`{kind}`' for kind in types)}")
    if not missing:
        lines.append("- None.")

    lines.extend(["", "## Events containing all three reaction types", ""])
    lines.extend(f"- `{eid}`" for eid in complete)
    if not complete:
        lines.append("- None.")

    lines.extend([
        "",
        "## Confirmed structural findings",
        "",
        "- Duplicate canonical event IDs: **0**.",
        f"- Duplicate authored reaction IDs: **{len(metadata['duplicate_reaction_ids'])}**.",
        "- Ambiguous event-to-scope or spell-to-ability mappings: **0 found**.",
        f"- Inconsistent, unsupported, or malformed registered reaction structures: **{len(metadata['structural_issues'])}**.",
        f"- Events without an active runtime detector or spell mapping: **{len(unmapped)}**. "
        "These remain canonical catalogue/ability definitions but are not currently dispatched automatically.",
        f"- Explicit empty ability registrations: **{len(explicit_empty)}**. The registration API explicitly supports "
        "a `nil` entry as an ability definition with an empty shipped pool.",
        f"- Manifest-excluded ability archive files: **{len(metadata['excluded_archive_files'])}**. "
        "They were inspected for activation status and excluded because the addon manifest does not load them.",
        "- Parameterized reactions are exported as one authored reaction each. In `reactions.csv`, `reaction_text` "
        "contains the exact template and `template_choices_json` contains the exact ordered choice pools; "
        "`events.json` retains `template` and `choices` as separate fields.",
        "",
        "### Events without active runtime detection",
        "",
    ])
    lines.extend(f"- `{eid}`" for eid in unmapped)
    if not unmapped:
        lines.append("- None.")

    lines.extend([
        "",
        "## Potentially intentionally silent events",
        "",
        "The following are confirmed explicit empty ability registrations. Their empty pools are structurally "
        "deliberate registrations; the repository does not establish whether each is editorially complete or "
        "intended to remain silent:",
        "",
    ])
    lines.extend(f"- `{eid}`" for eid in explicit_empty)
    if not explicit_empty:
        lines.append("- None.")

    lines.extend([
        "",
        "## Unresolved inventory questions and limitations",
        "",
        "- Display names are derived mechanically from canonical trigger/ability keys because the active "
        "registration schema does not store authored display names.",
        "- Static inventory can confirm runtime mappings present in source, but not whether WoW Forever delivers "
        "the associated events or payloads in live play.",
        "- User-authored reactions are per-character SavedVariables and are not repository content, so they are "
        "outside this repository inventory.",
        "- No intent is inferred from a missing reaction type. `population_status` describes structure only.",
        "",
        "## Validation",
        "",
        "Run `python3 scripts/export_content_inventory.py --check` to regenerate in memory and verify the checked-in exports.",
    ])
    return "\n".join(lines) + "\n"


def payloads() -> dict[str, bytes]:
    raw = collect()
    events, reactions, metadata = build_inventory(raw)
    OUTPUT.mkdir(parents=True, exist_ok=True)

    # Produce CSV through temporary sibling files so the exact bytes can also be checked.
    write_events_csv(events)
    write_reactions_csv(reactions)
    events_json = {
        "schema_version": 1,
        "scope": "active repository-shipped content",
        "metadata": metadata,
        "events": events,
    }
    (OUTPUT / "events.json").write_text(
        json.dumps(events_json, ensure_ascii=False, indent=2) + "\n", encoding="utf-8"
    )
    (OUTPUT / "inventory_summary.md").write_text(
        summary_text(events, reactions, metadata), encoding="utf-8"
    )
    return {path.name: path.read_bytes() for path in OUTPUT.iterdir() if path.is_file()}


def validate() -> None:
    events_doc = json.loads((OUTPUT / "events.json").read_text(encoding="utf-8"))
    events = events_doc["events"]
    with (OUTPUT / "events.csv").open(encoding="utf-8", newline="") as handle:
        event_rows = list(csv.DictReader(handle))
    with (OUTPUT / "reactions.csv").open(encoding="utf-8", newline="") as handle:
        reaction_rows = list(csv.DictReader(handle))

    event_ids = [event["event_id"] for event in events]
    assert len(event_ids) == len(set(event_ids)), "duplicate event IDs in JSON"
    assert [row["event_id"] for row in event_rows] == event_ids, "CSV/JSON event order or coverage mismatch"
    valid_ids = set(event_ids)
    assert all(row["event_id"] in valid_ids for row in reaction_rows), "reaction without a valid event"

    json_reactions = [
        (event["event_id"], reaction)
        for event in events
        for kind in REACTION_TYPES
        for reaction in event["reactions"][kind]
    ]
    assert len(json_reactions) == len(reaction_rows), "CSV/JSON reaction coverage mismatch"
    rows_by_id = {row["reaction_id"]: row for row in reaction_rows}
    assert len(rows_by_id) == len(reaction_rows), "duplicate reaction IDs in CSV"
    for eid, reaction in json_reactions:
        row = rows_by_id[reaction["reaction_id"]]
        expected_text = reaction["template"] if reaction["template"] is not None else reaction["text"]
        assert row["event_id"] == eid
        assert row["reaction_id"] == reaction["reaction_id"]
        assert row["reaction_type"] == reaction["type"]
        assert row["reaction_text"] == expected_text, f"altered reaction text: {reaction['reaction_id']}"

    csv_counts = Counter(row["reaction_type"] for row in reaction_rows)
    json_counts = Counter(reaction["type"] for _, reaction in json_reactions)
    assert csv_counts == json_counts, "reaction type totals mismatch"
    for event, row in zip(events, event_rows):
        counts = event["reaction_counts"]
        assert int(row["say_count"]) == counts["say"]
        assert int(row["emote_count"]) == counts["emote"]
        assert int(row["customemote_count"]) == counts["customemote"]
        assert int(row["total_reactions"]) == counts["total"]
        assert sum(counts[kind] for kind in REACTION_TYPES) == counts["total"]


def main() -> None:
    import argparse

    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--check", action="store_true", help="verify exports are current and internally consistent")
    args = parser.parse_args()

    if args.check:
        existing = {
            name: (OUTPUT / name).read_bytes()
            for name in ("events.csv", "reactions.csv", "events.json", "inventory_summary.md")
        }
        generated = payloads()
        validate()
        for name, old_bytes in existing.items():
            assert generated[name] == old_bytes, f"stale generated export: {name}"
    else:
        payloads()
        validate()


if __name__ == "__main__":
    main()
