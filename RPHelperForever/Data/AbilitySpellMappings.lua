-- Reviewed player-success IDs only. Candidate ranks/effects belong in research.
-- Loaded after Data/Abilities so validation uses the complete canonical registry.
RPHelper.AbilitySpellMappings = {}
local Mappings = RPHelper.AbilitySpellMappings

Mappings.Records = {
    { class = "PALADIN", spellID = 19750, ability = "FLASH_OF_LIGHT",
        mechanism = "player_success", evidence = "third_party_success",
        evidenceRef = "docs/spell_casting_api_audit.md#6-first-runtime-increment" },
    { class = "PALADIN", spellID = 20288, ability = "SEAL_OF_RIGHTEOUSNESS",
        mechanism = "player_success", evidence = "third_party_success",
        evidenceRef = "docs/spell_casting_api_audit.md#6-first-runtime-increment" },
    { class = "SHAMAN", spellID = 325, ability = "LIGHTNING_SHIELD",
        mechanism = "player_success", evidence = "owner_reported_success",
        evidenceRef = "docs/ability_detection_milestone_1.md#evidence-and-rank-limits" },
    { class = "SHAMAN", spellID = 547, ability = "HEALING_WAVE",
        mechanism = "player_success", evidence = "owner_reported_success",
        evidenceRef = "docs/ability_detection_milestone_1.md#evidence-and-rank-limits" },
}

local function validID(value)
    return type(value) == "number" and value > 0 and value < math.huge
        and value == value and value % 1 == 0
end

-- Validate bundled plain Lua data once, not event payloads. A record list keeps
-- duplicate declarations visible; a keyed Lua literal would overwrite them.
-- Publish no partial index if any record is invalid.
function Mappings.BuildIndex(records, abilities)
    if type(records) ~= "table" or type(abilities) ~= "table" then
        return nil, "invalid_container"
    end
    local count = 0
    for position in pairs(records) do
        if not validID(position) then return nil, "invalid_record_list" end
        count = count + 1
    end
    local index = {}
    for position = 1, count do
        local record = records[position]
        if type(record) ~= "table" then return nil, "invalid_record" end
        if not validID(record.spellID) then return nil, "invalid_spell_id" end
        local class, ability = record.class, record.ability
        if type(class) ~= "string" or type(ability) ~= "string"
            or type(abilities[class]) ~= "table" or abilities[class][ability] ~= ability then
            return nil, "unknown_ability"
        end
        if record.mechanism ~= "player_success" then return nil, "unsupported_mechanism" end
        if (record.evidence ~= "third_party_success" and record.evidence ~= "owner_reported_success")
            or type(record.evidenceRef) ~= "string" or record.evidenceRef == "" then
            return nil, "missing_evidence"
        end
        index[class] = index[class] or {}
        if index[class][record.spellID] ~= nil then return nil, "duplicate_spell_id" end
        index[class][record.spellID] = ability
    end
    return index
end

local index, validationError = Mappings.BuildIndex(Mappings.Records, RPHelper.Ability)
Mappings.validationError = validationError
-- The adapter, Library and offline exporter share this single compiled index.
-- Bad bundled data disables ability mappings; generic detection stays available.
RPHelper.RuntimeAPI.AbilitySpellIDs = index or {}
