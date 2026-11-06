local tests, failures = 0, 0
local function equal(actual, expected)
    if actual ~= expected then error("expected " .. tostring(expected) .. ", got " .. tostring(actual), 2) end
end
local function test(name, callback)
    tests = tests + 1
    local ok, message = pcall(callback)
    if not ok then failures = failures + 1; io.stderr:write("FAIL: " .. name .. "\n  " .. tostring(message) .. "\n") end
end

RPHelper = {}
dofile("RPHelperForever/Core/Defaults.lua")
dofile("RPHelperForever/Core/Database.lua")
dofile("RPHelperForever/Core/Configuration.lua")
dofile("RPHelperForever/Core/KeywordResolvers.lua")
dofile("RPHelperForever/Core/DruidForms.lua")
dofile("RPHelperForever/Core/ContentEngine.lua")
dofile("RPHelperForever/Core/Content.lua")
dofile("RPHelperForever/Core/UserContent.lua")
dofile("RPHelperForever/Core/RuntimeAPI.lua")
for _, class in ipairs({ "Warrior", "Rogue", "Hunter", "Shaman", "Druid", "Paladin", "Mage", "Priest", "Warlock" }) do
    dofile("RPHelperForever/Data/Abilities/" .. class .. ".lua")
end
dofile("RPHelperForever/Data/AbilitySpellMappings.lua")
local Mappings = RPHelper.AbilitySpellMappings
dofile("RPHelperForever/UI/LibraryData.lua")

local function record(id, ability, class)
    if ability == nil then ability = "HEALING_WAVE" end
    return { class = class or "SHAMAN", spellID = id, ability = ability,
        mechanism = "player_success", evidence = "owner_reported_success", evidenceTier = "A", evidenceRef = "test fixture" }
end
local function rejected(records, reason)
    local index, err = Mappings.BuildIndex(records, RPHelper.Ability)
    equal(index, nil)
    equal(err, reason)
end

test("every bundled record resolves exactly with honest evidence and cross-class isolation", function()
    equal(Mappings.validationError, nil)
    equal(#Mappings.Records, 1168)
    local classes = { "WARRIOR", "ROGUE", "HUNTER", "SHAMAN", "DRUID", "PALADIN", "MAGE", "PRIEST", "WARLOCK" }
    local previousInspection = issecretvalue
    issecretvalue = function() return false end
    local observed = 0
    for _, row in ipairs(Mappings.Records) do
        equal(RPHelper.RuntimeAPI.ClassifySpellcastSucceeded("player", nil, row.spellID, row.class), row.ability)
        equal(row.evidenceTier, row.evidence == "owner_reported_success" and "A" or "B")
        if row.evidenceTier == "A" then
            observed = observed + 1
            equal(row.class, "SHAMAN")
            equal(row.spellID == 325 or row.spellID == 547, true)
        end
        for _, other in ipairs(classes) do
            equal(RPHelper.RuntimeAPI.ClassifySpellcastSucceeded("player", nil, row.spellID, other),
                (RPHelper.RuntimeAPI.AbilitySpellIDs[other] or {})[row.spellID])
        end
        equal(RPHelper.RuntimeAPI.ClassifySpellcastSucceeded("pet", nil, row.spellID, row.class), nil)
    end
    equal(observed, 2)
    issecretvalue = previousInspection
end)

test("multiple explicit rank records resolve to the same canonical ability", function()
    -- Synthetic IDs exercise the structure; they never enter the production index.
    local index, err = Mappings.BuildIndex({ record(900001), record(900002) }, RPHelper.Ability)
    equal(err, nil)
    equal(index.SHAMAN[900001], "HEALING_WAVE")
    equal(index.SHAMAN[900002], "HEALING_WAVE")
    equal(RPHelper.RuntimeAPI.AbilitySpellIDs.SHAMAN[900001], nil)
end)

test("real reviewed ranks and every mapped Library group share the authoritative index", function()
    equal(RPHelper.RuntimeAPI.AbilitySpellIDs.MAGE[133], "FIREBALL")
    equal(RPHelper.RuntimeAPI.AbilitySpellIDs.MAGE[143], "FIREBALL")
    equal(RPHelper.RuntimeAPI.AbilitySpellIDs.SHAMAN[331], "HEALING_WAVE")
    equal(RPHelper.RuntimeAPI.AbilitySpellIDs.SHAMAN[547], "HEALING_WAVE")
    RPHelperDB = nil
    RPHelper.InitializeDatabase()
    local pairsSeen, classes = {}, {}
    for _, row in ipairs(Mappings.Records) do
        local pair = row.class .. ":" .. row.ability
        classes[row.class] = true
        if not pairsSeen[pair] then
            pairsSeen[pair] = true
            if #RPHelper.GetAbilityPool(row.class, row.ability) == 0 then
                local id = RPHelper.UserContent.Add({ layer = "ability", class = row.class, ability = row.ability },
                    { type = "say", text = "Mapping support fixture." })
                equal(type(id), "string")
            end
        end
    end
    for class in pairs(classes) do
        local model = RPHelper.LibraryData.BuildSection("class", { class = class, race = "HUMAN" })
        for _, row in ipairs(Mappings.Records) do
            if row.class == class then
                local group = RPHelper.LibraryData.FindGroup(model, "ability:" .. class .. ":" .. row.ability)
                equal(type(group), "table")
                equal(group.settings.detected, true)
                equal(group.settings.configKey, row.ability)
            end
        end
    end
end)

test("duplicate declarations and conflicting assignments both reject the whole index", function()
    rejected({ record(547), record(547) }, "duplicate_spell_id")
    rejected({ record(547), record(547, "LIGHTNING_SHIELD") }, "duplicate_spell_id")
end)

test("IDs are independently scoped by canonical class", function()
    local index = Mappings.BuildIndex({ record(900001), record(900001, "FLASH_OF_LIGHT", "PALADIN") }, RPHelper.Ability)
    equal(index.SHAMAN[900001], "HEALING_WAVE")
    equal(index.PALADIN[900001], "FLASH_OF_LIGHT")
end)

test("invalid numerical and nonnumerical IDs reject without coercion", function()
    for _, id in ipairs({ 0, -1, 1.5, math.huge, -math.huge, 0/0, "547", false, {}, function() end }) do
        rejected({ record(id) }, "invalid_spell_id")
    end
    rejected({ record(nil) }, "invalid_spell_id")
end)

test("unknown classes and canonical abilities reject", function()
    for _, row in ipairs({ record(547, "UNKNOWN"), record(547, "HEALING_WAVE", "PALADIN"),
        record(547, "HEALING_WAVE", "UNKNOWN"), record(547, "healing_wave"), record(547, false) }) do
        rejected({ row }, "unknown_ability")
    end
end)

test("malformed containers sparse arrays and malformed records reject", function()
    rejected(nil, "invalid_container")
    rejected(false, "invalid_container")
    rejected({ [2] = record(547) }, "invalid_record")
    rejected({ [1] = record(547), [3] = record(325) }, "invalid_record")
    rejected({ extra = record(547) }, "invalid_record_list")
    rejected({ false }, "invalid_record")
    equal(Mappings.BuildIndex({ record(547) }, nil), nil)
end)

test("deferred mechanisms and missing or upgraded evidence cannot compile", function()
    local row = record(547)
    row.mechanism = "channel"
    rejected({ row }, "unsupported_mechanism")
    row = record(547); row.evidenceRef = nil
    rejected({ row }, "missing_evidence")
    row = record(547); row.evidence = "all_ranks_verified"
    rejected({ row }, "missing_evidence")
    row = record(547); row.evidence = "forever_reviewed"; row.evidenceTier = "A"
    rejected({ row }, "missing_evidence") -- Source agreement cannot become a live capture.
    row.evidenceTier = "B"
    local index, err = Mappings.BuildIndex({ row }, RPHelper.Ability)
    equal(err, nil)
    equal(index.SHAMAN[547], "HEALING_WAVE")
end)

test("invalid bundled data disables mappings atomically without breaking the adapter", function()
    local canonical = RPHelper.Ability.SHAMAN.LIGHTNING_SHIELD
    local defensive = RPHelper.RuntimeAPI.ClassifyUnitCombat
    RPHelper.Ability.SHAMAN.LIGHTNING_SHIELD = nil
    local ok, err = pcall(function()
        dofile("RPHelperForever/Data/AbilitySpellMappings.lua")
        equal(RPHelper.AbilitySpellMappings.validationError, "unknown_ability")
        equal(next(RPHelper.RuntimeAPI.AbilitySpellIDs), nil)
        equal(RPHelper.RuntimeAPI.ClassifyUnitCombat, defensive)
    end)
    RPHelper.Ability.SHAMAN.LIGHTNING_SHIELD = canonical
    dofile("RPHelperForever/Data/AbilitySpellMappings.lua")
    if not ok then error(err, 2) end
    equal(RPHelper.RuntimeAPI.AbilitySpellIDs.SHAMAN[325], "LIGHTNING_SHIELD")
end)

if failures > 0 then os.exit(1) end
print(tostring(tests) .. " ability mapping tests passed")
