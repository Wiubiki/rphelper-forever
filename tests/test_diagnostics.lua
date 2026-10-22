local failures, tests = 0, 0

local function test(name, callback)
    tests = tests + 1
    local ok, message = pcall(callback)
    if not ok then
        failures = failures + 1
        io.stderr:write("FAIL: " .. name .. "\n  " .. tostring(message) .. "\n")
    end
end

local function equal(actual, expected)
    if actual ~= expected then error("expected " .. tostring(expected) .. ", got " .. tostring(actual), 2) end
end

local function truthy(value)
    if not value then error("expected a truthy value", 2) end
end

RPHelper = {}
dofile("RPHelper/Core/Defaults.lua")
dofile("RPHelper/Core/Database.lua")
dofile("RPHelper/Core/Configuration.lua")
dofile("RPHelper/Core/KeywordResolvers.lua")
dofile("RPHelper/Core/DruidForms.lua")
dofile("RPHelper/Core/ContentEngine.lua")
dofile("RPHelper/Core/Content.lua")
dofile("RPHelper/Core/UserContent.lua")
dofile("RPHelper/Core/RuntimeAPI.lua")
dofile("RPHelper/Core/Diagnostics.lua")
dofile("RPHelper/Core/Output.lua")
dofile("RPHelper/Core/Runtime.lua")
dofile("RPHelper/Core/Commands.lua")
dofile("RPHelper/Data/RandomInsults.lua")
dofile("RPHelper/Data/Generic.lua")
dofile("RPHelper/Data/Races/Human.lua")
dofile("RPHelper/Data/Classes/Paladin.lua")
dofile("RPHelper/Data/Abilities/Paladin.lua")

local function newFrame()
    local frame = { registered = {} }
    function frame:RegisterEvent(event) self.registered[event] = true end
    return frame
end

local function newAdapter()
    local adapter = { output = {}, policyTime = 0, policyCalls = 0 }
    adapter.ClassifyUnitCombat = RPHelper.RuntimeAPI.ClassifyUnitCombat
    adapter.ClassifySpellcastSucceeded = RPHelper.RuntimeAPI.ClassifySpellcastSucceeded
    adapter.RegisterDefensiveEvents = RPHelper.RuntimeAPI.RegisterDefensiveEvents
    adapter.RegisterAbilityEvents = RPHelper.RuntimeAPI.RegisterAbilityEvents
    function adapter.GetTime() adapter.policyCalls = adapter.policyCalls + 1; return adapter.policyTime end
    function adapter.GetActivity() return "world" end
    function adapter.GetPlayerClass() return "PALADIN" end
    function adapter.GetPlayerRace() return "HUMAN" end
    function adapter.GetShapeshiftFormID() return nil end
    function adapter.IsPlayerInCombat() return false end
    function adapter.Random() return 0 end
    function adapter.RandomIndex() return 1 end
    function adapter.DisplayLocal(text) table.insert(adapter.output, text); return true end
    function adapter.SendSay(text) table.insert(adapter.output, text); return true end
    function adapter.RunEmote(text) table.insert(adapter.output, text); return true end
    function adapter.SendCustomEmote(text) table.insert(adapter.output, text); return true end
    return adapter
end

local function initialize(adapter)
    RPHelperDB = nil
    RPHelper.InitializeDatabase()
    local frame = newFrame()
    truthy(RPHelper.Runtime.Initialize(frame, adapter))
    return frame
end

local function setSetting(name, value)
    truthy(RPHelper.Configuration.SetSetting(name, value))
end

local function setTrigger(trigger, name, value)
    truthy(RPHelper.Configuration.SetEventSetting("trigger", nil, trigger, name, value))
end

local function setAbility(ability, name, value)
    truthy(RPHelper.Configuration.SetEventSetting("ability", "PALADIN", ability, name, value))
end

local function captureCommand(command)
    local oldPrint, messages = print, {}
    print = function(message) table.insert(messages, message) end
    local ok, err = pcall(RPHelper.HandleSlashCommand, command)
    print = oldPrint
    if not ok then error(err, 2) end
    return messages
end

local function recordAt(index)
    return RPHelper.Diagnostics.GetRecords()[index]
end

test("diagnostics are disabled and empty on every runtime initialization", function()
    local adapter = newAdapter()
    initialize(adapter)
    equal(RPHelper.Diagnostics.IsEnabled(), false)
    equal(RPHelper.Diagnostics.Count(), 0)
    RPHelper.Diagnostics.SetEnabled(true)
    RPHelper.Runtime.HandleEvent("PLAYER_REGEN_DISABLED")
    equal(RPHelper.Diagnostics.Count(), 1)
    RPHelper.Runtime.Initialize(newFrame(), adapter)
    equal(RPHelper.Diagnostics.IsEnabled(), false)
    equal(RPHelper.Diagnostics.Count(), 0)
end)

test("diagnostic lifecycle is session-only and independent of SavedVariables", function()
    local adapter = newAdapter()
    initialize(adapter)
    local saved = RPHelperDB
    captureCommand("debug on")
    RPHelper.Runtime.HandleEvent("PLAYER_REGEN_DISABLED")
    captureCommand("debug clear")
    equal(RPHelper.Diagnostics.IsEnabled(), true)
    equal(RPHelper.Diagnostics.Count(), 0)
    RPHelper.Runtime.HandleEvent("PLAYER_REGEN_ENABLED")
    equal(recordAt(1).sequence, 2)
    captureCommand("debug off")
    equal(RPHelper.Diagnostics.Count(), 1)
    RPHelper.Runtime.HandleEvent("PLAYER_REGEN_DISABLED")
    equal(RPHelper.Diagnostics.Count(), 1)
    equal(RPHelperDB, saved)
    equal(saved.debug, nil)
    equal(saved.diagnostics, nil)
    captureCommand("debug clear")
    equal(RPHelper.Diagnostics.Count(), 0)
    equal(RPHelper.Diagnostics.IsEnabled(), false)
end)

test("all four event paths produce compact classified observations", function()
    local oldInspect = issecretvalue
    issecretvalue = function() return false end
    local adapter = newAdapter()
    initialize(adapter)
    setSetting("enabled", false)
    RPHelper.Diagnostics.SetEnabled(true)
    equal(RPHelper.Runtime.HandleEvent("PLAYER_REGEN_DISABLED"), false)
    equal(RPHelper.Runtime.HandleEvent("UNIT_COMBAT", "player", "DODGE", "unused", 99), false)
    equal(RPHelper.Runtime.HandleEvent("UNIT_SPELLCAST_SUCCEEDED", "player", "unused", 19750), false)
    equal(RPHelper.Runtime.HandleEvent("PLAYER_REGEN_ENABLED"), false)
    local records = RPHelper.Diagnostics.GetRecords()
    equal(#records, 4)
    equal(records[1].trigger, "entercombat")
    equal(records[1].activity, "world")
    equal(records[1].time, 0)
    equal(records[2].action, "DODGE")
    equal(records[2].result, "matched")
    equal(records[3].spellID, 19750)
    equal(records[3].ability, "FLASH_OF_LIGHT")
    equal(records[3].result, "mapped")
    equal(records[3].activity, "world")
    equal(records[4].trigger, "leavecombat")
    equal(#adapter.output, 0)
    issecretvalue = oldInspect
end)

test("readable unmapped spell IDs, wrong units, and unsupported actions are retained safely", function()
    local oldInspect = issecretvalue
    issecretvalue = function() return false end
    initialize(newAdapter())
    RPHelper.Diagnostics.SetEnabled(true)
    RPHelper.Runtime.HandleEvent("UNIT_SPELLCAST_SUCCEEDED", "player", nil, 900001)
    RPHelper.Runtime.HandleEvent("PLAYER_REGEN_DISABLED")
    RPHelper.Runtime.HandleEvent("UNIT_COMBAT", "targettarget", "DODGE")
    RPHelper.Runtime.HandleEvent("UNIT_COMBAT", "player", "WOUND")
    local records = RPHelper.Diagnostics.GetRecords()
    equal(records[1].spellID, 900001)
    equal(records[1].result, "unmapped")
    equal(records[3].unit, "targettarget")
    equal(records[3].result, "wrong_unit")
    equal(records[4].action, "unsupported")
    equal(records[4].result, "unsupported_action")
    issecretvalue = oldInspect
end)

test("malformed and restricted values are redacted without coercion or computation", function()
    local oldInspect = issecretvalue
    local hostile = setmetatable({}, {
        __tostring = function() error("must not stringify") end,
        __mod = function() error("must not compute") end,
        __lt = function() error("must not compare") end,
    })
    issecretvalue = function(value) return value == hostile end
    initialize(newAdapter())
    RPHelper.Diagnostics.SetEnabled(true)
    RPHelper.Runtime.HandleEvent("PLAYER_REGEN_DISABLED")
    RPHelper.Runtime.HandleEvent("UNIT_COMBAT", hostile, "DODGE")
    RPHelper.Runtime.HandleEvent("UNIT_COMBAT", "player", hostile)
    RPHelper.Runtime.HandleEvent("UNIT_SPELLCAST_SUCCEEDED", "player", hostile, hostile)
    local records = RPHelper.Diagnostics.GetRecords()
    equal(records[2].unit, "restricted")
    equal(records[2].result, "unit_restricted")
    equal(records[3].action, "restricted")
    equal(records[3].result, "action_restricted")
    equal(records[4].spellID, nil)
    equal(records[4].result, "spell_restricted")
    for _, record in ipairs(records) do truthy(type(RPHelper.Diagnostics.Format(record)) == "string") end

    issecretvalue = nil
    RPHelper.Runtime.HandleEvent("UNIT_COMBAT", "player", "PARRY")
    equal(recordAt(5).result, "unit_restricted")
    issecretvalue = function() error("inspection failed") end
    RPHelper.Runtime.HandleEvent("UNIT_SPELLCAST_SUCCEEDED", "player", nil, 19750)
    equal(recordAt(6).result, "unit_restricted")
    issecretvalue = oldInspect
end)

test("malformed readable payload types receive fixed reasons", function()
    local oldInspect = issecretvalue
    issecretvalue = function() return false end
    initialize(newAdapter())
    RPHelper.Diagnostics.SetEnabled(true)
    RPHelper.Runtime.HandleEvent("UNIT_SPELLCAST_SUCCEEDED", "player", nil, "19750")
    RPHelper.Runtime.HandleEvent("PLAYER_REGEN_DISABLED")
    RPHelper.Runtime.HandleEvent("UNIT_COMBAT", "player", 7)
    local records = RPHelper.Diagnostics.GetRecords()
    equal(records[1].result, "invalid_spell_id")
    equal(records[1].spellID, nil)
    equal(records[3].result, "invalid_action_type")
    issecretvalue = oldInspect
end)

test("ring buffer retains the latest 100 in sequence order", function()
    local adapter = newAdapter()
    initialize(adapter)
    RPHelper.Diagnostics.SetEnabled(true)
    for index = 1, 105 do
        RPHelper.Diagnostics.Observe("TEST_EVENT", "combat", {
            trigger = "entercombat", result = "record_" .. index, matched = true,
        })
    end
    local records = RPHelper.Diagnostics.GetRecords()
    equal(#records, 100)
    equal(records[1].sequence, 6)
    equal(records[1].result, "record_6")
    equal(records[100].sequence, 105)
    local latest = RPHelper.Diagnostics.GetRecords(10)
    equal(latest[1].sequence, 96)
    equal(latest[10].sequence, 105)
end)

test("debug commands cover status help latest-ten show clear and invalid usage", function()
    initialize(newAdapter())
    truthy(string.find(captureCommand("debug status")[1], "disabled", 1, true))
    truthy(#captureCommand("debug help") >= 6)
    truthy(#captureCommand("debug nonsense") >= 6)
    truthy(#captureCommand("debug on extra") >= 6)
    captureCommand("debug on")
    for index = 1, 12 do
        RPHelper.Diagnostics.Observe("TEST_EVENT", "combat", {
            trigger = "entercombat", result = "record_" .. index, matched = true,
        })
    end
    captureCommand("debug off")
    local shown = captureCommand("debug show")
    equal(#shown, 11)
    truthy(string.find(shown[2], "#3 ", 1, true))
    truthy(string.find(shown[11], "#12 ", 1, true))
    captureCommand("debug clear")
    equal(RPHelper.Diagnostics.IsEnabled(), false)
    equal(captureCommand("debug show")[1], "RPHelper diagnostics have no captured records.")
end)

test("capture adds no output, selection, policy spending, registration, or mappings", function()
    local oldInspect = issecretvalue
    issecretvalue = function() return false end
    local adapter = newAdapter()
    local frame = initialize(adapter)
    local mappings = RPHelper.RuntimeAPI.AbilitySpellIDs
    local oldChoose = RPHelper.ChooseAbilityCandidate
    local selections = 0
    RPHelper.ChooseAbilityCandidate = function(...)
        selections = selections + 1
        return oldChoose(...)
    end
    setSetting("enabled", true)
    setSetting("globalCooldown", 5)
    setSetting("encounterQuotaEnabled", true)
    setSetting("maxAutomaticOutputsPerCombat", 1)
    setTrigger("enter_combat", "enabled", false)
    setAbility("FLASH_OF_LIGHT", "chance", 1)
    RPHelper.Diagnostics.SetEnabled(true)
    RPHelper.Runtime.HandleEvent("PLAYER_REGEN_DISABLED")
    equal(adapter.policyCalls, 1)
    RPHelper.Runtime.HandleEvent("UNIT_SPELLCAST_SUCCEEDED", "target", nil, 19750)
    RPHelper.Runtime.HandleEvent("UNIT_SPELLCAST_SUCCEEDED", "player", nil, 900001)
    equal(adapter.policyCalls, 1) -- capture performs no clock or policy query
    equal(selections, 0)
    equal(#adapter.output, 0)
    truthy(RPHelper.Runtime.HandleEvent("UNIT_SPELLCAST_SUCCEEDED", "player", nil, 19750))
    equal(selections, 1)
    equal(#adapter.output, 1)
    equal(adapter.policyCalls, 2)
    equal(RPHelper.Runtime.HandleEvent("UNIT_SPELLCAST_SUCCEEDED", "player", nil, 19750), false)
    equal(selections, 1)
    equal(adapter.policyCalls, 2) -- exhausted quota remains the first policy gate
    equal(RPHelper.RuntimeAPI.AbilitySpellIDs, mappings)
    equal(RPHelper.RuntimeAPI.AbilitySpellIDs.PALADIN[19750], "FLASH_OF_LIGHT")
    local eventCount = 0
    for event in pairs(frame.registered) do
        eventCount = eventCount + 1
        truthy(event == "PLAYER_REGEN_DISABLED" or event == "PLAYER_REGEN_ENABLED"
            or event == "UNIT_COMBAT" or event == "UNIT_SPELLCAST_SUCCEEDED")
    end
    equal(eventCount, 4)
    RPHelper.ChooseAbilityCandidate = oldChoose
    issecretvalue = oldInspect
end)

if failures > 0 then
    io.stderr:write(tostring(failures) .. " of " .. tostring(tests) .. " diagnostic tests failed\n")
    os.exit(1)
end

print(tostring(tests) .. " diagnostic tests passed")
