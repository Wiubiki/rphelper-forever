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
dofile("RPHelperForever/Core/Defaults.lua")
dofile("RPHelperForever/Core/Database.lua")
dofile("RPHelperForever/Core/Configuration.lua")
dofile("RPHelperForever/Core/KeywordResolvers.lua")
dofile("RPHelperForever/Core/DruidForms.lua")
dofile("RPHelperForever/Core/ContentEngine.lua")
dofile("RPHelperForever/Core/Content.lua")
dofile("RPHelperForever/Core/UserContent.lua")
dofile("RPHelperForever/Core/RuntimeAPI.lua")
dofile("RPHelperForever/Core/Diagnostics.lua")
dofile("RPHelperForever/Core/Output.lua")
dofile("RPHelperForever/Core/Runtime.lua")
dofile("RPHelperForever/Core/Commands.lua")
dofile("RPHelperForever/Data/RandomInsults.lua")
dofile("RPHelperForever/Data/Generic.lua")
dofile("RPHelperForever/Data/Races/Human.lua")
dofile("RPHelperForever/Data/Classes/Paladin.lua")
dofile("RPHelperForever/Data/Abilities/Paladin.lua")
dofile("RPHelperForever/Data/Abilities/Shaman.lua")
dofile("RPHelperForever/Data/AbilitySpellMappings.lua")

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
    adapter.HasSecretInspection = RPHelper.RuntimeAPI.HasSecretInspection
    adapter.GetDiagnosticSpellName = RPHelper.RuntimeAPI.GetDiagnosticSpellName
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

local function withInspection(callback)
    local old = issecretvalue
    issecretvalue = function() return false end
    local ok, err = pcall(callback)
    issecretvalue = old
    if not ok then error(err, 2) end
end

local function cast()
    return RPHelper.Runtime.HandleEvent("UNIT_SPELLCAST_SUCCEEDED", "player", nil, 19750)
end

local function latest()
    return RPHelper.Diagnostics.GetRecords(1)[1]
end

test("each early policy rejection is reported without preparing content", function()
    withInspection(function()
        local cases = {
            { "activity_blocked", function(a) a.GetActivity = function() return "raid" end end },
            { "activity_blocked", function(a) a.GetActivity = function() return nil end end },
            { "invalid_clock", function(a) a.policyTime = -1 end },
            { "invalid_clock", function(a) a.GetTime = function() error("missing") end end },
            { "master_disabled", function() setSetting("enabled", false) end },
            { "event_disabled", function() setAbility("FLASH_OF_LIGHT", "enabled", false) end },
            { "chance_zero", function() setAbility("FLASH_OF_LIGHT", "chance", 0) end },
            { "chance", function(a)
                setAbility("FLASH_OF_LIGHT", "chance", 0.2)
                a.Random = function() return 0.2 end
            end },
            { "invalid_roll", function(a)
                setAbility("FLASH_OF_LIGHT", "chance", 0.2)
                a.Random = function() return 1 end
            end },
        }
        for _, case in ipairs(cases) do
            local a = newAdapter()
            initialize(a)
            setAbility("FLASH_OF_LIGHT", "chance", 1)
            case[2](a)
            RPHelper.Diagnostics.SetEnabled(true)
            local oldPool, poolCalls = RPHelper.GetAbilityContentPool, 0
            RPHelper.GetAbilityContentPool = function(...)
                poolCalls = poolCalls + 1
                return oldPool(...)
            end
            local ok, result = pcall(cast)
            RPHelper.GetAbilityContentPool = oldPool
            truthy(ok)
            equal(result, false)
            equal(poolCalls, 0)
            local record = latest()
            equal(record.result, "mapped")
            equal(record.outcome, case[1])
            equal(record.eligible, "not_evaluated")
            equal(record.selected, false)
            equal(record.emitted, false)
            equal(#a.output, 0)
        end
    end)
end)

test("cooldown quota and backward clocks preserve first-gate ordering", function()
    withInspection(function()
        local a = newAdapter()
        initialize(a)
        setAbility("FLASH_OF_LIGHT", "chance", 1)
        RPHelper.Diagnostics.SetEnabled(true)
        truthy(cast())
        equal(cast(), false)
        equal(latest().outcome, "cooldown")
        a.policyTime = -1
        equal(cast(), false)
        equal(latest().outcome, "invalid_clock")
        a.policyTime = 25
        truthy(cast())
        a.policyTime = 24
        equal(cast(), false)
        equal(latest().outcome, "invalid_clock")

        initialize(a)
        a.policyTime = 0
        setSetting("encounterQuotaEnabled", true)
        setSetting("maxAutomaticOutputsPerCombat", 1)
        setTrigger("enter_combat", "enabled", false)
        setAbility("FLASH_OF_LIGHT", "chance", 1)
        RPHelper.Diagnostics.SetEnabled(true)
        RPHelper.Runtime.HandleEvent("PLAYER_REGEN_DISABLED")
        truthy(cast())
        setSetting("enabled", false)
        equal(cast(), false)
        equal(latest().outcome, "quota")
        equal(latest().eligible, "not_evaluated")
    end)
end)

test("eligibility selection dispatch failure and emission are distinct", function()
    withInspection(function()
        local a = newAdapter()
        initialize(a)
        setAbility("FLASH_OF_LIGHT", "chance", 1)
        RPHelper.Diagnostics.SetEnabled(true)
        truthy(cast())
        local record = latest()
        equal(record.eligible, 1) -- TARGET-dependent custom emote is ineligible
        equal(record.selected, true)
        equal(record.emitted, true)
        equal(record.outcome, "emitted")
        equal(record.outputType, "say")
        truthy(string.find(RPHelper.Diagnostics.Format(record), "matched=yes", 1, true))
        a.policyTime = 25
        a.RandomIndex = function() return 0 end
        equal(cast(), false)
        equal(latest().eligible, 1)
        equal(latest().selected, false)
        equal(latest().outcome, "selection_failed")
        a.RandomIndex = function() return 1 end
        a.DisplayLocal = function() error("blocked") end
        equal(cast(), false)
        equal(latest().eligible, 1)
        equal(latest().selected, true)
        equal(latest().emitted, false)
        equal(latest().outcome, "dispatch_failed")
        truthy(RPHelper.Configuration.SetDefaultEnabled("default:ability:paladin:0014", false))
        equal(cast(), false)
        equal(latest().eligible, 0)
        equal(latest().outcome, "no_eligible_content")
        equal(latest().selected, false)
    end)
end)

test("unmapped Shaman spells remain observable with master reactions off", function()
    withInspection(function()
        local a = newAdapter()
        a.GetPlayerClass = function() return "SHAMAN" end
        a.GetDiagnosticSpellName = function(id) equal(id, 900001); return "Test shield" end
        initialize(a)
        setSetting("enabled", false)
        RPHelper.Diagnostics.SetEnabled(true)
        RPHelper.Runtime.HandleEvent("UNIT_SPELLCAST_SUCCEEDED", "player", nil, 900001)
        local record = latest()
        equal(record.event, "UNIT_SPELLCAST_SUCCEEDED")
        equal(record.class, "SHAMAN")
        equal(record.spellID, 900001) -- synthetic fixture, never a production mapping
        equal(record.spellName, "Test shield")
        equal(record.result, "unmapped")
        equal(record.matched, false)
        equal(record.outcome, "not_attempted")
        equal(record.eligible, "not_evaluated")
        equal(a.policyCalls, 0)
    end)
end)

test("both observed Shaman IDs report mapped identities and downstream outcomes", function()
    withInspection(function()
        for id, ability in pairs({ [325] = "LIGHTNING_SHIELD", [547] = "HEALING_WAVE" }) do
            local a = newAdapter()
            a.GetPlayerClass = function() return "SHAMAN" end
            a.GetPlayerRace = function() return "TAUREN" end
            a.GetDiagnosticSpellName = function() error("optional lookup unavailable") end
            initialize(a)
            truthy(RPHelper.Configuration.SetEventSetting("ability", "SHAMAN", ability, "chance", 1))
            RPHelper.Diagnostics.SetEnabled(true)
            setSetting("enabled", false)
            equal(RPHelper.Runtime.HandleEvent("UNIT_SPELLCAST_SUCCEEDED", "player", nil, id), false)
            equal(latest().result, "mapped")
            equal(latest().matched, true)
            equal(latest().ability, ability)
            equal(latest().outcome, "master_disabled")
            equal(latest().eligible, "not_evaluated")
            setSetting("enabled", true)
            truthy(RPHelper.Runtime.HandleEvent("UNIT_SPELLCAST_SUCCEEDED", "player", nil, id))
            equal(latest().class, "SHAMAN")
            equal(latest().spellID, id)
            equal(latest().ability, ability)
            equal(latest().eligible, id == 325 and 6 or 4)
            equal(latest().selected, true)
            equal(latest().emitted, true)
            equal(latest().outcome, "emitted")
            equal(#a.output, 1)
            equal(RPHelper.Runtime.HandleEvent("UNIT_SPELLCAST_SUCCEEDED", "player", nil, id), false)
            equal(latest().outcome, "cooldown")
            equal(latest().emitted, false)
            local lines = captureCommand("debug show all")
            truthy(string.find(table.concat(lines, "\n"), "ability=" .. ability, 1, true))
        end
    end)
end)

test("optional spell names require inspected IDs and inspected bounded text", function()
    local oldInspect, oldSpell, oldInfo = issecretvalue, C_Spell, GetSpellInfo
    local ok, err = pcall(function()
        local hostile = setmetatable({}, { __tostring = function() error("must not stringify") end })
        local lookupCalls, fallbackCalls = 0, 0
        issecretvalue = function(value) return value == hostile end
        C_Spell = { GetSpellName = function()
            lookupCalls = lookupCalls + 1
            return "|Hunsafe\n" .. string.rep("a", 200)
        end }
        GetSpellInfo = function() fallbackCalls = fallbackCalls + 1; return "Legacy spell" end
        local name = RPHelper.RuntimeAPI.GetDiagnosticSpellName(19750)
        equal(#name, 128)
        equal(string.find(name, "[|%c]"), nil)
        equal(RPHelper.RuntimeAPI.GetDiagnosticSpellName(hostile), nil)
        equal(RPHelper.RuntimeAPI.GetDiagnosticSpellName("19750"), nil)
        equal(lookupCalls, 1)
        C_Spell.GetSpellName = function() return hostile end
        equal(RPHelper.RuntimeAPI.GetDiagnosticSpellName(19750), nil)
        C_Spell.GetSpellName = function() error("restricted lookup") end
        equal(RPHelper.RuntimeAPI.GetDiagnosticSpellName(19750), nil)
        equal(fallbackCalls, 0)
        C_Spell = nil
        equal(RPHelper.RuntimeAPI.GetDiagnosticSpellName(19750), "Legacy spell")
        equal(fallbackCalls, 1)
        GetSpellInfo = nil
        equal(RPHelper.RuntimeAPI.GetDiagnosticSpellName(19750), nil)
        issecretvalue = nil
        equal(RPHelper.RuntimeAPI.GetDiagnosticSpellName(19750), nil)
    end)
    issecretvalue, C_Spell, GetSpellInfo = oldInspect, oldSpell, oldInfo
    if not ok then error(err) end
end)

test("restricted or wrong-unit events never invoke the name lookup", function()
    withInspection(function()
        local a, calls = newAdapter(), 0
        a.GetDiagnosticSpellName = function() calls = calls + 1 end
        initialize(a)
        RPHelper.Diagnostics.SetEnabled(true)
        RPHelper.Runtime.HandleEvent("UNIT_SPELLCAST_SUCCEEDED", "target", nil, 19750)
        issecretvalue = function(value) return value == 19750 end
        cast()
        equal(latest().result, "spell_restricted")
        equal(calls, 0)
    end)
end)

test("status exposes failed registration and missing inspection without waiting for events", function()
    withInspection(function()
        local a = newAdapter()
        a.RegisterAbilityEvents = function() error("unsupported event") end
        initialize(a)
        issecretvalue = nil
        local messages = captureCommand("debug status")
        truthy(string.find(messages[2], "UNIT_SPELLCAST_SUCCEEDED=false", 1, true))
        truthy(string.find(messages[2], "UNIT_COMBAT=true", 1, true))
        truthy(string.find(messages[2], "inspection function present=false", 1, true))
        equal(RPHelper.Diagnostics.Count(), 0)
    end)
end)

test("show all dumps the bounded buffer only on explicit request", function()
    initialize(newAdapter())
    captureCommand("debug on")
    for index = 1, 105 do
        RPHelper.Diagnostics.Observe("TEST_EVENT", "combat", { result = "matched" })
    end
    captureCommand("debug off")
    local messages = captureCommand("debug show all")
    equal(#messages, 101)
    truthy(string.find(messages[2], "#6 ", 1, true))
    truthy(string.find(messages[101], "#105 ", 1, true))
    truthy(#captureCommand("debug show 1000") <= 7)
end)

test("on and off produce identical runtime calls random draws outputs and policy results", function()
    withInspection(function()
        local runs = {}
        for _, enabled in ipairs({ false, true }) do
            local a, calls, nameCalls = newAdapter(), {}, 0
            for _, key in ipairs({ "GetTime", "GetActivity", "GetPlayerClass", "GetPlayerRace",
                "Random", "RandomIndex", "DisplayLocal", "SendSay", "RunEmote", "SendCustomEmote" }) do
                local original = a[key]
                a[key] = function(...)
                    calls[#calls + 1] = key
                    return original(...)
                end
            end
            a.GetDiagnosticSpellName = function() nameCalls = nameCalls + 1; return "Flash of Light" end
            initialize(a)
            setAbility("FLASH_OF_LIGHT", "chance", 0.2)
            setTrigger("enter_combat", "enabled", false)
            setSetting("encounterQuotaEnabled", true)
            setSetting("maxAutomaticOutputsPerCombat", 2)
            RPHelper.Diagnostics.SetEnabled(enabled)
            local results = {}
            local function attempt(event, ...)
                results[#results + 1] = tostring(RPHelper.Runtime.HandleEvent(event, ...))
            end
            attempt("UNIT_SPELLCAST_SUCCEEDED", "player", nil, 19750)
            attempt("UNIT_SPELLCAST_SUCCEEDED", "player", nil, 19750) -- cooldown
            attempt("PLAYER_REGEN_DISABLED")
            a.policyTime = 25
            attempt("UNIT_SPELLCAST_SUCCEEDED", "player", nil, 19750)
            a.policyTime = 50
            attempt("UNIT_SPELLCAST_SUCCEEDED", "player", nil, 19750)
            a.policyTime = 75
            attempt("UNIT_SPELLCAST_SUCCEEDED", "player", nil, 19750) -- quota
            attempt("PLAYER_REGEN_ENABLED")
            runs[#runs + 1] = { calls = table.concat(calls, ","),
                results = table.concat(results, ","), output = table.concat(a.output, ",") }
            if not enabled then
                equal(RPHelper.Diagnostics.Count(), 0)
                equal(nameCalls, 0)
            else
                truthy(nameCalls > 0)
                truthy(RPHelper.Diagnostics.Count() > 0)
            end
        end
        equal(runs[1].calls, runs[2].calls)
        equal(runs[1].results, runs[2].results)
        equal(runs[1].output, runs[2].output)
    end)
end)

if failures > 0 then
    io.stderr:write(tostring(failures) .. " of " .. tostring(tests) .. " diagnostic tests failed\n")
    os.exit(1)
end

print(tostring(tests) .. " diagnostic tests passed")
