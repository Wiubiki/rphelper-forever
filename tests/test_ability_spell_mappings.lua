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
dofile("RPHelperForever/Core/DruidForms.lua")
dofile("RPHelperForever/Core/Content.lua")
dofile("RPHelperForever/Core/RuntimeAPI.lua")
dofile("RPHelperForever/Data/Abilities/Paladin.lua")
dofile("RPHelperForever/Data/Abilities/Shaman.lua")
dofile("RPHelperForever/Data/AbilitySpellMappings.lua")
local Mappings = RPHelper.AbilitySpellMappings

local function record(id, ability, class)
    if ability == nil then ability = "HEALING_WAVE" end
    return { class = class or "SHAMAN", spellID = id, ability = ability,
        mechanism = "player_success", evidence = "owner_reported_success", evidenceRef = "test fixture" }
end
local function rejected(records, reason)
    local index, err = Mappings.BuildIndex(records, RPHelper.Ability)
    equal(index, nil)
    equal(err, reason)
end

test("bundled records compile to exactly the four authorized class and ID pairs", function()
    equal(Mappings.validationError, nil)
    equal(#Mappings.Records, 4)
    local expected = { PALADIN = { [19750] = "FLASH_OF_LIGHT", [20288] = "SEAL_OF_RIGHTEOUSNESS" },
        SHAMAN = { [325] = "LIGHTNING_SHIELD", [547] = "HEALING_WAVE" } }
    local count = 0
    for class, spells in pairs(RPHelper.RuntimeAPI.AbilitySpellIDs) do
        for id, ability in pairs(spells) do
            equal(ability, expected[class] and expected[class][id])
            count = count + 1
        end
    end
    equal(count, 4)
    for _, row in ipairs(Mappings.Records) do
        equal(row.evidence, row.class == "PALADIN" and "third_party_success" or "owner_reported_success")
    end
end)

test("multiple explicit rank records resolve to the same canonical ability", function()
    -- Synthetic IDs exercise the structure; they never enter the production index.
    local index, err = Mappings.BuildIndex({ record(900001), record(900002) }, RPHelper.Ability)
    equal(err, nil)
    equal(index.SHAMAN[900001], "HEALING_WAVE")
    equal(index.SHAMAN[900002], "HEALING_WAVE")
    equal(RPHelper.RuntimeAPI.AbilitySpellIDs.SHAMAN[900001], nil)
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
