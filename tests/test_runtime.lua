local failures = 0
local tests = 0
local cleanups

local function test(name, callback)
    tests = tests + 1
    cleanups = {}
    local ok, message = pcall(callback)
    for index = #cleanups, 1, -1 do
        local cleaned, cleanupError = pcall(cleanups[index])
        if ok and not cleaned then ok, message = false, cleanupError end
    end
    cleanups = nil
    if not ok then
        failures = failures + 1
        io.stderr:write("FAIL: " .. name .. "\n  " .. tostring(message) .. "\n")
    end
end

local function afterEach(callback)
    table.insert(cleanups, callback)
end

local function equal(actual, expected)
    if actual ~= expected then
        error("expected " .. tostring(expected) .. ", got " .. tostring(actual), 2)
    end
end

local function truthy(value)
    if not value then
        error("expected a truthy value", 2)
    end
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
dofile("RPHelper/Data/Races/Tauren.lua")
dofile("RPHelper/Data/Classes/Druid.lua")
dofile("RPHelper/Data/Abilities/Paladin.lua")
dofile("RPHelper/Data/Abilities/Druid.lua")

local function newFrame()
    local frame = { registered = {} }
    function frame:RegisterEvent(event)
        self.registered[event] = true
    end
    function frame:SetScript(script, callback)
        self[script] = callback
    end
    return frame
end

local function newAdapter(class, race, formID)
    local adapter = { output = {}, combat = false, now = 0, clockStep = 5, activity = "dungeon", roll = 0 }
    adapter.ClassifyUnitCombat = RPHelper.RuntimeAPI.ClassifyUnitCombat
    adapter.RegisterDefensiveEvents = RPHelper.RuntimeAPI.RegisterDefensiveEvents
    adapter.ClassifySpellcastSucceeded = RPHelper.RuntimeAPI.ClassifySpellcastSucceeded
    adapter.RegisterAbilityEvents = RPHelper.RuntimeAPI.RegisterAbilityEvents
    function adapter.GetTime()
        local now = adapter.now
        adapter.now = adapter.now + adapter.clockStep
        return now
    end
    function adapter.GetActivity() return adapter.activity end
    function adapter.Random() return adapter.roll end
    function adapter.RandomIndex() return 1 end
    function adapter.DisplayLocal(text)
        table.insert(adapter.output, { type = "local", text = text })
        return true
    end
    function adapter.GetPlayerClass() return class end
    function adapter.GetPlayerRace() return race end
    function adapter.GetShapeshiftFormID() return formID end
    function adapter.IsPlayerInCombat() return adapter.combat end
    function adapter.SendSay(text)
        table.insert(adapter.output, { type = "say", text = text })
        return true
    end
    function adapter.RunEmote(text)
        table.insert(adapter.output, { type = "emote", text = text })
        return true
    end
    function adapter.SendCustomEmote(text)
        table.insert(adapter.output, { type = "customemote", text = text })
        return true
    end
    return adapter
end

local function setSetting(name, value)
    local ok, err = RPHelper.Configuration.SetSetting(name, value)
    if not ok then error("cannot set " .. name .. ": " .. tostring(err), 2) end
end

local function setTrigger(trigger, name, value)
    local ok, err = RPHelper.Configuration.SetEventSetting("trigger", nil, trigger, name, value)
    if not ok then error("cannot set trigger " .. trigger .. "." .. name .. ": " .. tostring(err), 2) end
end

local function setAbility(class, ability, name, value)
    local ok, err = RPHelper.Configuration.SetEventSetting("ability", class, ability, name, value)
    if not ok then error("cannot set ability " .. class .. "." .. ability .. "." .. name .. ": " .. tostring(err), 2) end
end

local function enableQuota(maximum)
    setSetting("maxAutomaticOutputsPerCombat", maximum)
    setSetting("encounterQuotaEnabled", true)
end

local function setDefaultWeight(id, weight)
    local ok, err = RPHelper.Configuration.SetDefaultWeight(id, weight)
    if not ok then error("cannot set reaction weight: " .. tostring(err), 2) end
end

local function initialize(adapter)
    RPHelperDB = nil
    RPHelper.InitializeDatabase()
    setSetting("enabled", true)
    setSetting("globalCooldown", 5)
    setSetting("encounterQuotaEnabled", false)
    for _, trigger in ipairs({ "enter_combat", "leave_combat", "dodge", "parry", "block" }) do
        setTrigger(trigger, "enabled", true)
        setTrigger(trigger, "chance", 1)
    end
    for _, ability in ipairs({ "FLASH_OF_LIGHT", "SEAL_OF_RIGHTEOUSNESS" }) do
        setAbility("PALADIN", ability, "enabled", true)
        setAbility("PALADIN", ability, "chance", 1)
    end
    local frame = newFrame()
    truthy(RPHelper.Runtime.Initialize(frame, adapter))
    return frame
end

test("historical reconciliation does not enable additional production ability mappings", function()
    local mappings = RPHelper.RuntimeAPI.AbilitySpellIDs
    local count = 0
    for class, spells in pairs(mappings) do
        equal(class, "PALADIN")
        for id, ability in pairs(spells) do
            count = count + 1
            truthy((id == 19750 and ability == "FLASH_OF_LIGHT")
                or (id == 20288 and ability == "SEAL_OF_RIGHTEOUSNESS"))
        end
    end
    equal(count, 2)
    local a = newAdapter("ROGUE", "HUMAN", nil)
    initialize(a)
    truthy(RPHelper.UserContent.Add({ layer = "ability", class = "ROGUE", ability = "EVISCERATE" },
        { type = "say", text = "My custom ability." }))
    equal(RPHelper.Runtime.HandleEvent("UNIT_SPELLCAST_SUCCEEDED", "player", nil, 2098), false)
    equal(#a.output, 0)
end)

test("addon initialization registers combat events", function()
    local frame = newFrame()
    local previousCreateFrame = CreateFrame
    CreateFrame = function() return frame end
    SlashCmdList = {}
    RPHelperDB = nil

    dofile("RPHelper/RPHelper.lua")
    truthy(frame.registered.ADDON_LOADED)
    truthy(not frame.registered.PLAYER_REGEN_DISABLED)
    frame.OnEvent(frame, "ADDON_LOADED", "DifferentAddon")
    truthy(not frame.registered.PLAYER_REGEN_DISABLED)
    frame.OnEvent(frame, "ADDON_LOADED", "RPHelper")
    truthy(frame.registered.PLAYER_REGEN_DISABLED)
    truthy(frame.registered.PLAYER_REGEN_ENABLED)
    truthy(RPHelperDB)
    equal(SLASH_RPHELPER1, "/rph")
    truthy(type(SlashCmdList.RPHELPER) == "function")
    CreateFrame = previousCreateFrame
end)

test("entering and leaving combat map to semantic content triggers", function()
    local adapter = newAdapter("WARRIOR", "TAUREN", nil)
    initialize(adapter)
    local previousChoose = RPHelper.ChooseContentCandidate
    local seen = {}
    RPHelper.ChooseContentCandidate = function(trigger)
        table.insert(seen, trigger)
        return { type = "say", text = trigger }
    end

    truthy(RPHelper.Runtime.HandleEvent("PLAYER_REGEN_DISABLED"))
    truthy(RPHelper.Runtime.HandleEvent("PLAYER_REGEN_ENABLED"))
    equal(seen[1], "entercombat")
    equal(seen[2], "leavecombat")
    equal(adapter.output[1].text, "entercombat")
    equal(adapter.output[2].text, "leavecombat")
    RPHelper.ChooseContentCandidate = previousChoose
end)

test("runtime selects from existing layered content", function()
    local adapter = newAdapter("WARRIOR", "TAUREN", nil)
    initialize(adapter)
    truthy(RPHelper.Runtime.HandleEvent("PLAYER_REGEN_DISABLED"))
    equal(#adapter.output, 1)
    truthy(adapter.output[1].text ~= "")
end)

test("runtime dispatches say emote and customemote distinctly", function()
    local adapter = newAdapter("WARRIOR", "TAUREN", nil)
    initialize(adapter)
    local previousChoose = RPHelper.ChooseContentCandidate
    for _, candidate in ipairs({
        { type = "say", text = "spoken" },
        { type = "emote", text = "ROAR" },
        { type = "customemote", text = "raises a hand." },
    }) do
        RPHelper.ChooseContentCandidate = function() return candidate end
        truthy(RPHelper.Runtime.HandleTrigger("entercombat"))
    end
    equal(adapter.output[1].type, "say")
    equal(adapter.output[2].type, "emote")
    equal(adapter.output[3].type, "customemote")
    RPHelper.ChooseContentCandidate = previousChoose
end)

test("default output adapter uses distinct WoW output APIs", function()
    local previousSendChatMessage = SendChatMessage
    local previousDoEmote = DoEmote
    local calls = {}
    SendChatMessage = function(text, channel)
        table.insert(calls, { api = "chat", text = text, channel = channel })
    end
    DoEmote = function(token)
        table.insert(calls, { api = "emote", text = token })
    end

    truthy(RPHelper.Output.Dispatch({ type = "say", text = "spoken" }, RPHelper.RuntimeAPI, "dungeon"))
    truthy(RPHelper.Output.Dispatch({ type = "customemote", text = "waves." }, RPHelper.RuntimeAPI, "dungeon"))
    truthy(RPHelper.Output.Dispatch({ type = "emote", text = "WAVE" }, RPHelper.RuntimeAPI, "dungeon"))
    equal(calls[1].channel, "SAY")
    equal(calls[2].channel, "EMOTE")
    equal(calls[3].api, "emote")

    SendChatMessage = previousSendChatMessage
    DoEmote = previousDoEmote
end)

test("master disabled setting prevents automatic output", function()
    local adapter = newAdapter("WARRIOR", "TAUREN", nil)
    initialize(adapter)
    setSetting("enabled", false)
    equal(RPHelper.Runtime.HandleEvent("PLAYER_REGEN_DISABLED"), false)
    equal(#adapter.output, 0)
end)

test("Druid speech suppression is preserved through runtime", function()
    local adapter = newAdapter("DRUID", "TAUREN", 3)
    initialize(adapter)
    local previousGeneric = RPHelper.Content.generic.entercombat
    local previousRace = RPHelper.Content.race.TAUREN.entercombat
    local previousClass = RPHelper.Content.class.DRUID.entercombat
    RPHelper.Content.generic.entercombat = { { type = "say", text = "generic speech" } }
    RPHelper.Content.race.TAUREN.entercombat = { { type = "say", text = "race speech" } }
    RPHelper.Content.class.DRUID.entercombat = { { type = "say", text = "class speech" } }

    equal(RPHelper.Runtime.HandleEvent("PLAYER_REGEN_DISABLED"), false)
    equal(#adapter.output, 0)

    RPHelper.Content.generic.entercombat = previousGeneric
    RPHelper.Content.race.TAUREN.entercombat = previousRace
    RPHelper.Content.class.DRUID.entercombat = previousClass
end)

test("unavailable and failing shapeshift API suppress Druid speech through runtime", function()
    local previousGetShapeshiftFormID = GetShapeshiftFormID
    local adapter = newAdapter("DRUID", "TAUREN", nil)
    adapter.GetShapeshiftFormID = RPHelper.RuntimeAPI.GetShapeshiftFormID
    initialize(adapter)
    local previousGeneric = RPHelper.Content.generic.entercombat
    local previousRace = RPHelper.Content.race.TAUREN.entercombat
    local previousClass = RPHelper.Content.class.DRUID.entercombat
    RPHelper.Content.generic.entercombat = { { type = "say", text = "generic speech" } }
    RPHelper.Content.race.TAUREN.entercombat = { { type = "say", text = "race speech" } }
    RPHelper.Content.class.DRUID.entercombat = { { type = "say", text = "class speech" } }
    GetShapeshiftFormID = nil

    equal(RPHelper.Runtime.HandleEvent("PLAYER_REGEN_DISABLED"), false)
    equal(#adapter.output, 0)

    initialize(adapter)
    GetShapeshiftFormID = function() error("restricted") end
    equal(RPHelper.Runtime.HandleEvent("PLAYER_REGEN_DISABLED"), false)
    equal(#adapter.output, 0)

    GetShapeshiftFormID = previousGetShapeshiftFormID
    RPHelper.Content.generic.entercombat = previousGeneric
    RPHelper.Content.race.TAUREN.entercombat = previousRace
    RPHelper.Content.class.DRUID.entercombat = previousClass
end)

test("legitimate nil and zero shapeshift results permit humanoid Druid speech", function()
    local previousGetShapeshiftFormID = GetShapeshiftFormID
    local adapter = newAdapter("DRUID", "TAUREN", nil)
    adapter.GetShapeshiftFormID = RPHelper.RuntimeAPI.GetShapeshiftFormID
    initialize(adapter)
    local previousGeneric = RPHelper.Content.generic.entercombat
    local previousRace = RPHelper.Content.race.TAUREN.entercombat
    local previousClass = RPHelper.Content.class.DRUID.entercombat
    RPHelper.Content.generic.entercombat = { { type = "say", text = "humanoid speech" } }
    RPHelper.Content.race.TAUREN.entercombat = {}
    RPHelper.Content.class.DRUID.entercombat = {}
    local formID = nil
    GetShapeshiftFormID = function() return formID end

    truthy(RPHelper.Runtime.HandleEvent("PLAYER_REGEN_DISABLED"))
    equal(#adapter.output, 1)
    equal(adapter.output[1].text, "humanoid speech")

    formID = 0
    initialize(adapter)
    truthy(RPHelper.Runtime.HandleEvent("PLAYER_REGEN_DISABLED"))
    equal(#adapter.output, 2)
    equal(adapter.output[2].text, "humanoid speech")

    GetShapeshiftFormID = previousGetShapeshiftFormID
    RPHelper.Content.generic.entercombat = previousGeneric
    RPHelper.Content.race.TAUREN.entercombat = previousRace
    RPHelper.Content.class.DRUID.entercombat = previousClass
end)

test("duplicate combat notifications produce no duplicate output", function()
    local adapter = newAdapter("WARRIOR", "TAUREN", nil)
    initialize(adapter)
    local previousChoose = RPHelper.ChooseContentCandidate
    RPHelper.ChooseContentCandidate = function(trigger)
        return { type = "say", text = trigger }
    end

    truthy(RPHelper.Runtime.HandleEvent("PLAYER_REGEN_DISABLED"))
    equal(RPHelper.Runtime.HandleEvent("PLAYER_REGEN_DISABLED"), false)
    truthy(RPHelper.Runtime.HandleEvent("PLAYER_REGEN_ENABLED"))
    equal(RPHelper.Runtime.HandleEvent("PLAYER_REGEN_ENABLED"), false)
    equal(#adapter.output, 2)
    RPHelper.ChooseContentCandidate = previousChoose
end)

test("initial combat state prevents a repeated enter notification", function()
    local adapter = newAdapter("WARRIOR", "TAUREN", nil)
    adapter.combat = true
    initialize(adapter)
    equal(RPHelper.Runtime.IsInCombat(), true)
    equal(RPHelper.Runtime.HandleEvent("PLAYER_REGEN_DISABLED"), false)
    equal(#adapter.output, 0)
end)

test("unavailable game APIs fail without throwing", function()
    local adapter = {}
    local frame = initialize(adapter)
    truthy(frame.registered.PLAYER_REGEN_DISABLED)
    local ok, result = pcall(RPHelper.Runtime.HandleEvent, "PLAYER_REGEN_DISABLED")
    truthy(ok)
    equal(result, false)
end)

test("unknown events are ignored", function()
    local adapter = newAdapter("WARRIOR", "TAUREN", nil)
    initialize(adapter)
    equal(RPHelper.Runtime.HandleEvent("SOME_OTHER_EVENT"), false)
    equal(#adapter.output, 0)
end)


-- Policy cases use real preparation with a small deterministic pool.
local function policyAdapter()
    local adapter = newAdapter("WARRIOR", "POLICY_TEST", nil)
    initialize(adapter)
    local enterPool = RPHelper.Content.generic.entercombat
    local leavePool = RPHelper.Content.generic.leavecombat
    afterEach(function()
        RPHelper.Content.generic.entercombat = enterPool
        RPHelper.Content.generic.leavecombat = leavePool
    end)
    RPHelper.Content.generic.entercombat = { { type = "say", text = "ready" } }
    RPHelper.Content.generic.leavecombat = { { type = "say", text = "done" } }
    return adapter
end
local function fire() return RPHelper.Runtime.HandleTrigger("entercombat") end

test("disabled trigger still tracks combat transitions", function()
    local a = policyAdapter()
    setTrigger("enter_combat", "enabled", false)
    equal(RPHelper.Runtime.HandleEvent("PLAYER_REGEN_DISABLED"), false)
    equal(RPHelper.Runtime.IsInCombat(), true)
    truthy(RPHelper.Runtime.HandleEvent("PLAYER_REGEN_ENABLED"))
    equal(#a.output, 1)
end)

test("probability uses strict boundaries and skips RNG at zero and one", function()
    local a = policyAdapter()
    setTrigger("enter_combat", "chance", 0.2)
    a.roll = 0.2
    equal(fire(), false)
    a.roll = 0.1999
    truthy(fire())
    setTrigger("enter_combat", "chance", 0)
    a.Random = function() error("must not roll") end
    equal(fire(), false)
    setTrigger("enter_combat", "chance", 1)
    truthy(fire())
end)

test("event chance replaces the global chance", function()
    local a = policyAdapter()
    setSetting("reactionChance", 0.2)
    setTrigger("enter_combat", "chance", 0.4)
    a.roll = 0.4
    equal(fire(), false)
    a.roll = 0.399
    truthy(fire())
    truthy(RPHelper.Configuration.ResetEventSetting("trigger", nil, "enter_combat", "chance"))
    a.roll = 0.2
    equal(fire(), false)
end)

test("chance rejection occurs before candidate-pool construction", function()
    local a = policyAdapter()
    setTrigger("enter_combat", "chance", 0.2)
    a.roll = 0.2
    local choose = RPHelper.ChooseContentCandidate
    RPHelper.ChooseContentCandidate = function() error("pool must not be constructed") end
    local ok, result = pcall(fire)
    RPHelper.ChooseContentCandidate = choose
    truthy(ok)
    equal(result, false)
end)

test("global cooldown expires at the exact boundary", function()
    local a = policyAdapter()
    a.clockStep = 0
    setSetting("globalCooldown", 10)
    truthy(fire())
    a.now = 9
    equal(RPHelper.Runtime.HandleTrigger("leavecombat"), false)
    a.now = 10
    truthy(RPHelper.Runtime.HandleTrigger("leavecombat"))
    a.now = 19
    equal(fire(), false)
    a.now = 20
    truthy(fire())
end)

test("priority bypasses cooldown and does not reset it", function()
    local a = policyAdapter()
    a.clockStep = 0
    setSetting("globalCooldown", 20)
    truthy(fire())
    setTrigger("leave_combat", "priority", true)
    a.now = 1
    truthy(RPHelper.Runtime.HandleTrigger("leavecombat"))
    a.now = 19
    equal(fire(), false)
    a.now = 20
    truthy(fire())
    equal(#a.output, 3)
end)

test("priority remains subject to quota and raid suppression", function()
    local a = policyAdapter()
    setTrigger("enter_combat", "priority", true)
    enableQuota(1)
    a.activity = "raid"
    equal(RPHelper.Runtime.HandleEvent("PLAYER_REGEN_DISABLED"), false)
    a.activity = "dungeon"
    setTrigger("enter_combat", "enabled", false)
    equal(fire(), false)
    setTrigger("enter_combat", "enabled", true)
    setTrigger("enter_combat", "chance", 0)
    equal(fire(), false)
    setTrigger("enter_combat", "chance", 1)
    truthy(fire())
    setTrigger("leave_combat", "priority", true)
    equal(RPHelper.Runtime.HandleEvent("PLAYER_REGEN_ENABLED"), false)
    equal(#a.output, 1)
end)

test("failed priority dispatch consumes neither quota nor cooldown", function()
    local a = policyAdapter()
    a.clockStep = 0
    enableQuota(1)
    setSetting("globalCooldown", 20)
    setTrigger("enter_combat", "priority", true)
    local send = a.SendSay
    a.SendSay = function() return false end
    equal(RPHelper.Runtime.HandleEvent("PLAYER_REGEN_DISABLED"), false)
    a.SendSay = send
    setTrigger("enter_combat", "priority", false)
    truthy(fire())
    equal(fire(), false)
    equal(#a.output, 1)
end)

test("priority still requires a valid monotonic clock", function()
    local a = policyAdapter()
    a.clockStep = 0
    setTrigger("enter_combat", "priority", true)
    for _, value in ipairs({ -1, math.huge, 0/0, "bad" }) do
        a.now = value
        equal(fire(), false)
    end
    a.now = 0
    truthy(fire())
end)

test("quota includes exit and resets only at encounter boundaries", function()
    local a = policyAdapter()
    enableQuota(1)
    truthy(RPHelper.Runtime.HandleEvent("PLAYER_REGEN_DISABLED"))
    equal(fire(), false)
    equal(RPHelper.Runtime.HandleEvent("PLAYER_REGEN_DISABLED"), false)
    equal(RPHelper.Runtime.HandleEvent("PLAYER_REGEN_ENABLED"), false)
    truthy(RPHelper.Runtime.HandleEvent("PLAYER_REGEN_DISABLED"))
    equal(#a.output, 2)
end)

test("outputs while quota is disabled do not pre-consume a later enabled quota", function()
    local a = policyAdapter()
    truthy(RPHelper.Runtime.HandleEvent("PLAYER_REGEN_DISABLED"))
    truthy(fire())
    enableQuota(1)
    truthy(fire())
    equal(fire(), false)
    equal(RPHelper.Runtime.HandleEvent("PLAYER_REGEN_ENABLED"), false)
    equal(#a.output, 3)
end)

test("every output route consumes the shared encounter quota including exit", function()
    for _, case in ipairs({
        { "say", "dungeon", "say" }, { "say", "world", "local" },
        { "emote", "dungeon", "emote" }, { "customemote", "world", "customemote" },
    }) do
        local a = policyAdapter()
        a.activity = case[2]
        enableQuota(2)
        RPHelper.Content.generic.entercombat = { { type = case[1], text = "WAVE" } }
        RPHelper.Content.generic.leavecombat = { { type = case[1], text = "WAVE" } }
        truthy(RPHelper.Runtime.HandleEvent("PLAYER_REGEN_DISABLED"))
        truthy(fire())
        equal(RPHelper.Runtime.HandleTrigger("leavecombat"), false)
        equal(RPHelper.Runtime.HandleEvent("PLAYER_REGEN_ENABLED"), false)
        equal(RPHelper.Runtime.IsInCombat(), false)
        equal(#a.output, 2)
        equal(a.output[1].type, case[3])
        equal(a.output[2].type, case[3])
        -- A fresh encounter leaves room for both entry and exit.
        truthy(RPHelper.Runtime.HandleEvent("PLAYER_REGEN_DISABLED"))
        truthy(RPHelper.Runtime.HandleEvent("PLAYER_REGEN_ENABLED"))
        equal(RPHelper.Runtime.HandleEvent("PLAYER_REGEN_ENABLED"), false)
        equal(#a.output, 4)
    end
end)

test("out-of-combat attempts ignore enabled quota but obey chance and global cooldown", function()
    local a = policyAdapter()
    a.clockStep = 0
    enableQuota(1)
    setSetting("globalCooldown", 10)
    setTrigger("enter_combat", "chance", 0.2)
    a.roll = 1
    equal(fire(), false)
    a.roll = 0
    truthy(fire())
    equal(RPHelper.Runtime.IsInCombat(), false)
    a.now = 9
    equal(RPHelper.Runtime.HandleTrigger("leavecombat"), false)
    a.now = 10
    truthy(RPHelper.Runtime.HandleTrigger("leavecombat"))
    a.now = 20
    truthy(fire())
    -- Those successful attempts did not spend the next encounter's quota.
    a.now = 30
    truthy(RPHelper.Runtime.HandleEvent("PLAYER_REGEN_DISABLED"))
    a.now = 40
    equal(RPHelper.Runtime.HandleEvent("PLAYER_REGEN_ENABLED"), false)
    equal(#a.output, 4)
end)

test("reload in combat initializes quota without inventing an entry reaction", function()
    local a = policyAdapter()
    a.combat = true
    RPHelper.Runtime.Initialize(newFrame(), a)
    enableQuota(1)
    equal(RPHelper.Runtime.HandleEvent("PLAYER_REGEN_DISABLED"), false)
    truthy(fire())
    equal(RPHelper.Runtime.HandleEvent("PLAYER_REGEN_ENABLED"), false)
    setSetting("encounterQuotaEnabled", false)
    truthy(RPHelper.Runtime.HandleEvent("PLAYER_REGEN_DISABLED"))
end)

test("failed dispatch and rejected candidates consume neither cooldown nor quota", function()
    local a = policyAdapter()
    setSetting("globalCooldown", 10)
    enableQuota(1)
    local send = a.SendSay
    a.SendSay = function() return false end
    equal(RPHelper.Runtime.HandleEvent("PLAYER_REGEN_DISABLED"), false)
    a.SendSay = function() error("restricted") end
    equal(fire(), false)
    a.SendSay = send
    RPHelper.Content.generic.entercombat = { { type = "say", text = "{TARGET}" } }
    equal(fire(), false)
    RPHelper.Content.generic.entercombat = { { type = "say", text = "safe" } }
    truthy(fire())
    equal(fire(), false)
end)

test("activity routing preserves local say and both emote types", function()
    local a = policyAdapter()
    a.activity = "world"
    truthy(fire())
    equal(a.output[1].type, "local")
    for _, kind in ipairs({"emote", "customemote"}) do
        RPHelper.Content.generic.entercombat = { { type = kind, text = "WAVE" } }
        truthy(fire())
        equal(a.output[#a.output].type, kind)
    end
    a.activity = "raid"
    equal(fire(), false)
    a.activity = "unsupported"
    equal(fire(), false)
    a.GetActivity = function() error("unavailable") end
    equal(fire(), false)
end)

test("dungeon Say routing respects the local-only preference", function()
    local a = policyAdapter()
    truthy(fire())
    equal(a.output[1].type, "say")
    setSetting("dungeonSayMode", "local")
    truthy(fire())
    equal(a.output[2].type, "local")
    RPHelper.Content.generic.entercombat = { { type = "emote", text = "ROAR" } }
    truthy(fire())
    equal(a.output[3].type, "emote")
    RPHelper.Content.generic.entercombat = { { type = "customemote", text = "nods." } }
    truthy(fire())
    equal(a.output[4].type, "customemote")
end)

test("weighted selection combines built-in and custom reaction weights", function()
    local a = newAdapter("WEIGHT_TEST", "NO_RACE", nil)
    initialize(a)
    local previous = RPHelper.Content.generic.entercombat
    afterEach(function() RPHelper.Content.generic.entercombat = previous end)
    local defaultID = "default:test:runtime_weighted_builtin"
    RPHelper.Content.generic.entercombat = {
        { type = "say", text = "Built-in.", defaultID = defaultID },
    }
    setDefaultWeight(defaultID, 2)
    local customID = RPHelper.UserContent.Add(
        { layer = "generic", trigger = "entercombat" },
        { type = "say", text = "Custom." },
        { weight = 3 })
    truthy(customID)

    local selections = { 2, 3 }
    a.RandomIndex = function(size)
        equal(size, 5)
        return table.remove(selections, 1)
    end
    truthy(RPHelper.Runtime.HandleTrigger("entercombat"))
    truthy(RPHelper.Runtime.HandleTrigger("entercombat"))
    equal(a.output[1].text, "Built-in.")
    equal(a.output[2].text, "Custom.")

    truthy(RPHelper.UserContent.SetDefaultDisabled(defaultID, true))
    a.RandomIndex = function(size) equal(size, 3); return 1 end
    truthy(RPHelper.Runtime.HandleTrigger("entercombat"))
    equal(a.output[3].text, "Custom.")
    truthy(RPHelper.UserContent.SetEnabled(customID, false))
    equal(RPHelper.Runtime.HandleTrigger("entercombat"), false)
end)

test("weighted selection filters ineligible content and falls back from invalid weights", function()
    local a = newAdapter("WEIGHT_TEST", "NO_RACE", nil)
    initialize(a)
    local previous = RPHelper.Content.generic.entercombat
    afterEach(function() RPHelper.Content.generic.entercombat = previous end)
    local defaultID = "default:test:runtime_weighted_ineligible"
    local invalidDefaultID = "default:test:runtime_weighted_invalid"
    RPHelper.Content.generic.entercombat = {
        { type = "say", text = "Attack {TARGET}.", defaultID = defaultID },
        { type = "say", text = "Built-in fallback.", defaultID = invalidDefaultID },
    }
    RPHelperDB.reactionOverrides[defaultID] = { weight = 100 }
    RPHelperDB.reactionOverrides[invalidDefaultID] = { weight = 0 }
    local customID = RPHelper.UserContent.Add(
        { layer = "generic", trigger = "entercombat" },
        { type = "say", text = "Safe." },
        { weight = 4 })
    truthy(customID)
    RPHelperDB.custom.entries[customID].weight = 0
    RPHelper.UserContent.Invalidate()
    a.RandomIndex = function(size) equal(size, 2); return 2 end
    truthy(RPHelper.Runtime.HandleTrigger("entercombat"))
    equal(a.output[1].text, "Safe.")
    equal(RPHelperDB.custom.entries[customID].weight, 0)
    equal(RPHelperDB.reactionOverrides[invalidDefaultID].weight, 0)
end)

test("weighted selection accepts weight ten and rejects oversized persisted weights", function()
    local a = newAdapter("WEIGHT_TEST", "NO_RACE", nil)
    initialize(a)
    local previous = RPHelper.Content.generic.entercombat
    afterEach(function() RPHelper.Content.generic.entercombat = previous end)
    local firstID = "default:test:runtime_weighted_ten"
    local secondID = "default:test:runtime_weighted_oversized"
    RPHelper.Content.generic.entercombat = {
        { type = "say", text = "First.", defaultID = firstID },
        { type = "say", text = "Second.", defaultID = secondID },
    }
    setDefaultWeight(firstID, 10)
    RPHelperDB.reactionOverrides[secondID] = { weight = 11 }
    a.RandomIndex = function(size) equal(size, 11); return 11 end
    truthy(RPHelper.Runtime.HandleTrigger("entercombat"))
    equal(a.output[1].text, "Second.")
    equal(RPHelperDB.reactionOverrides[secondID].weight, 11)
end)

test("missing local display never falls back to transmission", function()
    local a = policyAdapter()
    a.activity = "world"
    a.DisplayLocal = nil
    equal(fire(), false)
    equal(#a.output, 0)
end)

test("invalid settings fall back without rewriting saved preferences", function()
    local a = policyAdapter()
    a.clockStep = 0
    RPHelperDB.settings.globalCooldown = -1
    RPHelperDB.triggers.enter_combat.chance = 0/0
    truthy(fire())
    a.now = 19
    equal(fire(), false)
    a.now = 20
    truthy(fire())
    equal(RPHelperDB.settings.globalCooldown, -1)
    for _, value in ipairs({false, "broken", 123}) do
        RPHelperDB.settings = value
        RPHelperDB.triggers = value
        RPHelper.InitializeDatabase()
        equal(RPHelperDB.settings, value)
        equal(RPHelperDB.triggers, value)
        RPHelper.Runtime.Initialize(newFrame(), a)
        a.roll = 0.05
        equal(fire(), false)
    end
    RPHelperDB = "broken root"
    RPHelper.InitializeDatabase()
    equal(RPHelperDB, "broken root")
    RPHelper.Runtime.Initialize(newFrame(), a)
    a.roll = 0.05
    equal(fire(), false)
end)

local function captureCommand(command)
    local previousPrint = print
    local messages = {}
    print = function(message) table.insert(messages, message) end
    local ok, err = pcall(SlashCmdList.RPHELPER or RPHelper.HandleSlashCommand, command)
    print = previousPrint
    if not ok then error(err, 2) end
    return messages
end

local function loadAddon(saved)
    local previousCreateFrame = CreateFrame
    local frame = newFrame()
    CreateFrame = function() return frame end
    local ok, err = pcall(dofile, "RPHelper/RPHelper.lua")
    CreateFrame = previousCreateFrame
    if not ok then error(err, 2) end
    RPHelperDB = saved
    frame.OnEvent(frame, "ADDON_LOADED", "RPHelper")
    truthy(frame.registered.PLAYER_REGEN_DISABLED)
    truthy(frame.registered.PLAYER_REGEN_ENABLED)
    return frame
end

test("malformed saved roots survive addon initialization and all slash commands", function()
    for _, saved in ipairs({ false, true, 42, "broken" }) do
        loadAddon(saved)
        equal(captureCommand("status")[1], "RPHelper is enabled.")
        for _, command in ipairs({ "on", "off" }) do
            truthy(string.find(captureCommand(command)[1], "cannot save", 1, true))
            equal(RPHelperDB, saved)
        end
        for _, command in ipairs({ "", "help", "spell rebirth", "unknown" }) do
            truthy(#captureCommand(command) > 0)
            equal(RPHelperDB, saved)
        end
    end
end)

test("malformed settings preserve recoverable data through startup and commands", function()
    for _, settings in ipairs({ false, true, 42, "broken" }) do
        local custom = { authored = { "My line." } }
        local disabled = { preserved = true }
        local triggers = { enter_combat = { enabled = false, chance = 0.7 } }
        local saved = { settings = settings, custom = custom, disabledDefaults = disabled,
            triggers = triggers, schemaVersion = 7, extra = "preserved" }
        loadAddon(saved)
        equal(captureCommand("status")[1], "RPHelper is enabled.")
        for _, command in ipairs({ "on", "off" }) do
            truthy(string.find(captureCommand(command)[1], "cannot save", 1, true))
            equal(saved.settings, settings)
        end
        equal(RPHelperDB, saved)
        equal(saved.custom, custom)
        equal(custom.authored[1], "My line.")
        equal(saved.disabledDefaults, disabled)
        equal(disabled.preserved, true)
        equal(saved.triggers, triggers)
        equal(triggers.enter_combat.enabled, false)
        equal(triggers.enter_combat.chance, 0.7)
        equal(saved.schemaVersion, 7)
        equal(saved.extra, "preserved")
    end
end)

test("status validates enabled and toggles modify only that preference", function()
    for _, enabled in ipairs({ false, true, 0, "broken", {} }) do
        local saved = { schemaVersion = 2, settings = { enabled = enabled },
            custom = { nextID = 1, entries = {}, authored = "preserved" } }
        loadAddon(saved)
        equal(captureCommand("status")[1],
            enabled == false and "RPHelper is disabled." or "RPHelper is enabled.")
        equal(saved.settings.enabled, enabled)
        equal(captureCommand("off")[1], "RPHelper disabled.")
        equal(captureCommand("status")[1], "RPHelper is disabled.")
        equal(saved.settings.enabled, false)
        equal(captureCommand("on")[1], "RPHelper enabled.")
        equal(saved.settings.enabled, true)
        equal(saved.custom.authored, "preserved")
    end
    for _, saved in ipairs({ { schemaVersion = 2 }, { schemaVersion = 2, settings = {} } }) do
        loadAddon(saved)
        equal(captureCommand("off")[1], "RPHelper disabled.")
        equal(saved.settings.enabled, false)
    end
    loadAddon(nil)
    equal(captureCommand("off")[1], "RPHelper disabled.")
    equal(RPHelperDB.settings.enabled, false)
end)

test("bad clock and randomness fail safely before dispatch", function()
    local a = policyAdapter()
    a.clockStep = 0
    setTrigger("enter_combat", "chance", 0.5)
    for _, value in ipairs({-1, math.huge, 0/0, "bad"}) do
        a.now = value
        equal(fire(), false)
    end
    a.now = 10
    for _, value in ipairs({-1, 1, math.huge, 0/0, "bad"}) do
        a.roll = value
        equal(fire(), false)
    end
    a.roll = 0
    truthy(fire())
    a.now = 9
    equal(fire(), false)
    a.now = 20
    truthy(fire())
    a.GetTime = nil
    equal(fire(), false)
end)

test("policy gates run before randomness and content selection", function()
    local a = policyAdapter()
    local calls = 0
    a.Random = function() calls = calls + 1; return 0 end
    setTrigger("enter_combat", "chance", 0.5)
    setSetting("enabled", false)
    equal(fire(), false)
    setSetting("enabled", true)
    a.activity = "raid"
    equal(fire(), false)
    equal(calls, 0)
    a.activity = "world"
    truthy(fire())
    equal(calls, 1)
    setSetting("globalCooldown", 10)
    equal(fire(), false)
    equal(calls, 1)
end)

test("activity adapter rejects missing inconsistent and unsupported context", function()
    local previous = IsInInstance
    for _, case in ipairs({
        {false, "none", "world"}, {true, "party", "dungeon"},
        {true, "raid", "raid"}, {false, "party"}, {true, "pvp"}, {"bad", "none"},
    }) do
        IsInInstance = function() return case[1], case[2] end
        equal(RPHelper.RuntimeAPI.GetActivity(), case[3])
    end
    IsInInstance = nil
    equal(RPHelper.RuntimeAPI.GetActivity(), nil)
    IsInInstance = function() error("restricted") end
    equal(RPHelper.RuntimeAPI.GetActivity(), nil)
    IsInInstance = previous
end)

test("player sex and power adapters validate API values without numeric power assumptions", function()
    local oldSex, oldPower, oldSecret = UnitSex, UnitPowerType, issecretvalue
    local ok, err = pcall(function()
        issecretvalue = function() return false end
        for sex = 1, 3 do
            UnitSex = function(unit) equal(unit, "player"); return sex end
            equal(RPHelper.RuntimeAPI.GetPlayerSex(), sex)
        end
        for token, label in pairs({ MANA = "mana", RAGE = "rage", ENERGY = "energy" }) do
            UnitPowerType = function(unit) equal(unit, "player"); return 99, token end
            equal(RPHelper.RuntimeAPI.GetPlayerPowerLabel(), label)
        end
        UnitPowerType = function() return 0 end
        equal(RPHelper.RuntimeAPI.GetPlayerPowerLabel(), nil)
        UnitPowerType = function() return 0, "FOCUS" end
        equal(RPHelper.RuntimeAPI.GetPlayerPowerLabel(), nil)
        UnitSex = function() return 0 end
        equal(RPHelper.RuntimeAPI.GetPlayerSex(), nil)
        UnitSex = function() error("unavailable") end
        UnitPowerType = function() error("unavailable") end
        equal(RPHelper.RuntimeAPI.GetPlayerSex(), nil)
        equal(RPHelper.RuntimeAPI.GetPlayerPowerLabel(), nil)
        UnitSex = function() return 2 end
        UnitPowerType = function() return 0, "MANA" end
        issecretvalue = function(value) return value == 2 or value == "MANA" end
        equal(RPHelper.RuntimeAPI.GetPlayerSex(), nil)
        equal(RPHelper.RuntimeAPI.GetPlayerPowerLabel(), nil)
        issecretvalue = function() error("restricted") end
        equal(RPHelper.RuntimeAPI.GetPlayerSex(), nil)
        equal(RPHelper.RuntimeAPI.GetPlayerPowerLabel(), nil)
    end)
    UnitSex, UnitPowerType, issecretvalue = oldSex, oldPower, oldSecret
    if not ok then error(err) end
end)

test("runtime supplies player placeholders lazily and never falls back to selected target", function()
    local a = newAdapter("CONTEXT_TEST", "NO_RACE", nil)
    local sexCalls, powerCalls = 0, 0
    a.GetPlayerSex = function() sexCalls = sexCalls + 1; return 2 end
    a.GetPlayerPowerLabel = function() powerCalls = powerCalls + 1; return "rage" end
    initialize(a)
    setTrigger("enter_combat", "chance", 1)
    local previous = RPHelper.Content.generic.entercombat

    RPHelper.Content.generic.entercombat = { { type = "say", text = "Static." } }
    truthy(RPHelper.Runtime.HandleEvent("PLAYER_REGEN_DISABLED"))
    equal(sexCalls, 0); equal(powerCalls, 0)
    RPHelper.Runtime.HandleEvent("PLAYER_REGEN_ENABLED")

    RPHelper.Content.generic.entercombat = {
        { type = "say", text = "{SP} spends {PP} {PLAYER_POWER}." },
    }
    truthy(RPHelper.Runtime.HandleEvent("PLAYER_REGEN_DISABLED"))
    equal(a.output[#a.output].text, "he spends his rage.")
    equal(sexCalls, 1); equal(powerCalls, 1)
    RPHelper.Runtime.HandleEvent("PLAYER_REGEN_ENABLED")

    local oldName = UnitName
    local targetCalls = 0
    UnitName = function(unit)
        if unit == "target" then targetCalls = targetCalls + 1; return "Unrelated" end
        return "Player"
    end
    RPHelper.Content.generic.entercombat = { { type = "say", text = "Attack {TARGET}." } }
    equal(RPHelper.Runtime.HandleEvent("PLAYER_REGEN_DISABLED"), false)
    equal(targetCalls, 0)
    UnitName = oldName
    RPHelper.Content.generic.entercombat = previous
end)

-- Exercise the real classifier/registration with scoped secret-inspection mocks.
local function defensiveTest(name, callback)
    test(name, function()
        local previousInspect = issecretvalue
        issecretvalue = function() return false end
        local a = newAdapter("WARRIOR", "DEFENSIVE_TEST", nil)
        local frame = initialize(a)
        setTrigger("enter_combat", "enabled", false)
        setTrigger("leave_combat", "chance", 1)
        for _, trigger in ipairs({ "dodge", "parry", "block" }) do
            setTrigger(trigger, "chance", 1)
        end
        local previousPools = {}
        for _, trigger in ipairs({ "dodge", "parry", "block", "leavecombat" }) do
            previousPools[trigger] = RPHelper.Content.generic[trigger]
            RPHelper.Content.generic[trigger] = { { type = "say", text = trigger } }
        end
        local ok, err = pcall(callback, a, frame)
        issecretvalue = previousInspect
        for trigger, pool in pairs(previousPools) do RPHelper.Content.generic[trigger] = pool end
        if not ok then error(err, 2) end
    end)
end

local function defend(action, unit, ...)
    return RPHelper.Runtime.HandleEvent("UNIT_COMBAT", unit or "player", action, ...)
end

defensiveTest("exact player defensive actions map through the policy path", function(a, frame)
    truthy(frame.registered.UNIT_COMBAT)
    equal(RPHelper.Runtime.HandleEvent("PLAYER_REGEN_DISABLED"), false)
    for index, action in ipairs({ "DODGE", "PARRY", "BLOCK" }) do
        truthy(defend(action, "player", "", 0, 1))
        equal(a.output[index].text, string.lower(action))
    end
    equal(#a.output, 3)
    equal(RPHelper.Runtime.IsInCombat(), true)
end)

defensiveTest("non-player units and unsupported actions never react", function(a)
    RPHelper.Runtime.HandleEvent("PLAYER_REGEN_DISABLED")
    for _, unit in ipairs({ "target", "targettarget", "pet", "vehicle", "nameplate1", "party1", "Player", "" }) do
        for _, action in ipairs({ "DODGE", "PARRY", "BLOCK" }) do equal(defend(action, unit), false) end
    end
    for _, action in ipairs({ "WOUND", "HEAL", "MISS", "ABSORB", "RESIST", "dodge", "", "CRITICAL" }) do
        equal(defend(action, "player", "BLOCK", 0, 1), false)
        equal(defend(action, "player", "BLOCK_REDUCED", 10, 1), false)
        equal(defend(action, "player", "CRITICAL", 10, 1), false)
    end
    equal(RPHelper.Runtime.HandleEvent("COMBAT_TEXT_UPDATE", "PARRY"), false)
    equal(#a.output, 0)
end)

defensiveTest("required fields are inspected before malformed payloads are rejected", function(a)
    RPHelper.Runtime.HandleEvent("PLAYER_REGEN_DISABLED")
    local bad = setmetatable({}, { __tostring = function() error("must not stringify") end })
    for _, value in ipairs({ false, true, 1, bad, function() end }) do
        equal(RPHelper.Runtime.HandleEvent("UNIT_COMBAT", value, "DODGE"), false)
        equal(RPHelper.Runtime.HandleEvent("UNIT_COMBAT", "player", value), false)
    end
    equal(RPHelper.Runtime.HandleEvent("UNIT_COMBAT"), false)
    equal(RPHelper.Runtime.HandleEvent("UNIT_COMBAT", nil, "PARRY"), false)
    equal(RPHelper.Runtime.HandleEvent("UNIT_COMBAT", "player", nil), false)
    equal(#a.output, 0)
    truthy(defend("DODGE"))
end)

defensiveTest("secret required fields fail closed without spending policies", function(a)
    RPHelper.Runtime.HandleEvent("PLAYER_REGEN_DISABLED")
    enableQuota(1)
    setSetting("globalCooldown", 10)
    -- Mark otherwise valid strings secret: type checks alone would accept them.
    issecretvalue = function(value) return value == "player" end
    equal(defend("DODGE"), false)
    issecretvalue = function(value) return value == "DODGE" end
    equal(defend("DODGE"), false)
    equal(#a.output, 0)
    issecretvalue = function() return false end
    truthy(defend("DODGE"))
    equal(defend("PARRY"), false)
end)

defensiveTest("missing failing or invalid secret inspection disables only defense", function(a)
    RPHelper.Runtime.HandleEvent("PLAYER_REGEN_DISABLED")
    issecretvalue = nil
    equal(defend("DODGE"), false)
    issecretvalue = false
    equal(defend("PARRY"), false)
    issecretvalue = function() error("unavailable") end
    equal(defend("BLOCK"), false)
    for _, value in ipairs({ "false", 0, {} }) do
        issecretvalue = function() return value end
        equal(defend("BLOCK"), false)
    end
    issecretvalue = function() return nil end
    equal(defend("BLOCK"), false)
    truthy(RPHelper.Runtime.HandleEvent("PLAYER_REGEN_ENABLED"))
    equal(a.output[1].text, "leavecombat")
end)

defensiveTest("unused secret fields are never inspected or used", function(a)
    RPHelper.Runtime.HandleEvent("PLAYER_REGEN_DISABLED")
    local unused = setmetatable({}, { __tostring = function() error("unused secret") end })
    local inspected = 0
    issecretvalue = function(value)
        if value == unused then error("must not inspect unused fields") end
        inspected = inspected + 1
        return false
    end
    truthy(defend("BLOCK", "player", unused, unused, unused))
    truthy(defend("PARRY")) -- absent unused fields are also irrelevant
    equal(inspected, 4)
    equal(#a.output, 2)
end)

defensiveTest("missing or failing classifier adapters suppress only defensive events", function(a)
    RPHelper.Runtime.HandleEvent("PLAYER_REGEN_DISABLED")
    a.ClassifyUnitCombat = nil
    equal(defend("DODGE"), false)
    a.ClassifyUnitCombat = function() error("adapter failed") end
    equal(defend("PARRY"), false)
    truthy(RPHelper.Runtime.HandleEvent("PLAYER_REGEN_ENABLED"))
    equal(#a.output, 1)
end)

defensiveTest("defensive individual toggles and master switch preserve encounter state", function(a)
    RPHelper.Runtime.HandleEvent("PLAYER_REGEN_DISABLED")
    for _, action in ipairs({ "DODGE", "PARRY", "BLOCK" }) do
        local trigger = string.lower(action)
        setTrigger(trigger, "enabled", false)
        equal(defend(action), false)
        setTrigger(trigger, "enabled", true)
        setSetting("enabled", false)
        equal(defend(action), false)
        setSetting("enabled", true)
        truthy(defend(action))
    end
    equal(#a.output, 3)
    equal(RPHelper.Runtime.IsInCombat(), true)
end)

defensiveTest("defensive chance and global cooldown retain exact boundaries", function(a)
    a.clockStep = 0
    RPHelper.Runtime.HandleEvent("PLAYER_REGEN_DISABLED")
    setTrigger("dodge", "chance", 0.2)
    a.roll = 0.2
    equal(defend("DODGE"), false)
    a.roll = 0.199
    setSetting("globalCooldown", 10)
    truthy(defend("DODGE"))
    a.now = 9
    equal(defend("PARRY"), false)
    a.now = 10
    truthy(defend("PARRY"))
    a.now = 19
    equal(defend("DODGE"), false)
    a.now = 20
    truthy(defend("DODGE"))
    equal(#a.output, 3)
end)

defensiveTest("defenses share entry and exit quota without resetting it", function(a)
    setTrigger("enter_combat", "enabled", true)
    setTrigger("enter_combat", "chance", 1)
    enableQuota(2)
    truthy(RPHelper.Runtime.HandleEvent("PLAYER_REGEN_DISABLED"))
    truthy(defend("DODGE"))
    equal(defend("PARRY"), false)
    equal(defend("BLOCK"), false)
    equal(RPHelper.Runtime.HandleEvent("PLAYER_REGEN_DISABLED"), false)
    equal(RPHelper.Runtime.HandleEvent("PLAYER_REGEN_ENABLED"), false)
    equal(RPHelper.Runtime.IsInCombat(), false)
    equal(#a.output, 2)
    setTrigger("enter_combat", "enabled", false)
    RPHelper.Runtime.HandleEvent("PLAYER_REGEN_DISABLED")
    truthy(defend("BLOCK"))
    truthy(RPHelper.Runtime.HandleEvent("PLAYER_REGEN_ENABLED"))
    equal(#a.output, 4)
end)

defensiveTest("failed defensive dispatch and ineligible content spend no cooldown or quota", function(a)
    RPHelper.Runtime.HandleEvent("PLAYER_REGEN_DISABLED")
    setSetting("globalCooldown", 10)
    enableQuota(1)
    local send = a.SendSay
    a.SendSay = function() return false end
    equal(defend("DODGE"), false)
    a.SendSay = function() error("restricted") end
    equal(defend("DODGE"), false)
    a.SendSay = send
    RPHelper.Content.generic.dodge = { { type = "say", text = "{TARGET}" } }
    equal(defend("DODGE"), false)
    RPHelper.Content.generic.dodge = { { type = "say", text = "safe" } }
    truthy(defend("DODGE"))
    equal(defend("BLOCK"), false)
    equal(#a.output, 1)
end)

defensiveTest("defenses require an active encounter including direct trigger attempts", function(a)
    for _, action in ipairs({ "DODGE", "PARRY", "BLOCK" }) do
        equal(defend(action), false)
        equal(RPHelper.Runtime.HandleTrigger(string.lower(action)), false)
    end
    a.combat = true
    RPHelper.Runtime.Initialize(newFrame(), a)
    equal(#a.output, 0) -- reload in combat invents no entry reaction
    truthy(defend("PARRY"))
    truthy(RPHelper.Runtime.HandleEvent("PLAYER_REGEN_ENABLED"))
    equal(defend("BLOCK"), false) -- late delivery cannot escape quota
    equal(RPHelper.Runtime.HandleTrigger("block"), false)
    RPHelper.Runtime.HandleEvent("PLAYER_REGEN_DISABLED")
    truthy(defend("BLOCK"))
    equal(#a.output, 3)
end)

defensiveTest("defensive routing and Druid suppression use existing preparation", function(a)
    RPHelper.Runtime.HandleEvent("PLAYER_REGEN_DISABLED")
    a.activity = "raid"
    equal(defend("DODGE"), false)
    a.activity = "unsupported"
    equal(defend("DODGE"), false)
    a.activity = "world"
    truthy(defend("DODGE"))
    equal(a.output[1].type, "local")
    a.GetPlayerClass = function() return "DRUID" end
    a.GetShapeshiftFormID = function() return 3 end
    equal(defend("DODGE"), false)
    RPHelper.Content.generic.dodge = { { type = "customemote", text = "sidesteps." } }
    truthy(defend("DODGE"))
    equal(a.output[2].type, "customemote")
    RPHelper.Content.generic.block = { { type = "emote", text = "ROAR" } }
    truthy(defend("BLOCK"))
    equal(a.output[3].type, "emote")
    equal(#a.output, 3)
end)

defensiveTest("failed defensive registration leaves combat transitions usable", function(a)
    for _, mode in ipairs({ "false", "error", "missing adapter", "failing adapter" }) do
        local frame = newFrame()
        local register = frame.RegisterEvent
        function frame:RegisterEvent(event)
            if event == "UNIT_COMBAT" then
                if mode == "error" then error("unsupported") end
                return false
            end
            register(self, event)
        end
        a.RegisterDefensiveEvents = RPHelper.RuntimeAPI.RegisterDefensiveEvents
        if mode == "missing adapter" then a.RegisterDefensiveEvents = nil end
        if mode == "failing adapter" then a.RegisterDefensiveEvents = function() error("unsupported") end end
        truthy(RPHelper.Runtime.Initialize(frame, a))
        truthy(frame.registered.PLAYER_REGEN_DISABLED)
        truthy(frame.registered.PLAYER_REGEN_ENABLED)
        RPHelper.Runtime.HandleEvent("PLAYER_REGEN_DISABLED")
        equal(defend("DODGE"), false)
        truthy(RPHelper.Runtime.HandleEvent("PLAYER_REGEN_ENABLED"))
    end
    equal(#a.output, 4)
end)

defensiveTest("addon frame forwards defensive payloads and introduces no deduplication", function(a)
    local previousCreateFrame = CreateFrame
    local frame = newFrame()
    CreateFrame = function() return frame end
    local ok, err = pcall(dofile, "RPHelper/RPHelper.lua")
    CreateFrame = previousCreateFrame
    if not ok then error(err) end
    frame.OnEvent(frame, "ADDON_LOADED", "RPHelper")
    RPHelper.Runtime.SetAPI(a)
    frame.OnEvent(frame, "PLAYER_REGEN_DISABLED")
    frame.OnEvent(frame, "UNIT_COMBAT", "targettarget", "DODGE", "", 0, 1)
    frame.OnEvent(frame, "UNIT_COMBAT", "player", "DODGE", "", 0, 1)
    frame.OnEvent(frame, "UNIT_COMBAT", "player", "DODGE", "", 0, 1)
    equal(#a.output, 2) -- identical valid attempts still obey configured policies only
    equal(a.output[1].text, "dodge")
    equal(a.output[2].text, "dodge")
    for event in pairs(frame.registered) do
        truthy(event == "ADDON_LOADED" or event == "PLAYER_REGEN_DISABLED"
            or event == "PLAYER_REGEN_ENABLED" or event == "UNIT_COMBAT"
            or event == "UNIT_SPELLCAST_SUCCEEDED")
    end
end)

local function abilityTest(name, callback)
    test("ability: " .. name, function()
        local inspect = issecretvalue
        issecretvalue = function() return false end
        local a = newAdapter("PALADIN", "HUMAN", nil)
        local frame = initialize(a)
        setTrigger("enter_combat", "enabled", false)
        setTrigger("leave_combat", "chance", 1)
        setAbility("PALADIN", "FLASH_OF_LIGHT", "chance", 1)
        setAbility("PALADIN", "SEAL_OF_RIGHTEOUSNESS", "chance", 1)
        local ok, err = pcall(callback, a, frame)
        issecretvalue = inspect
        if not ok then error(err, 2) end
    end)
end

local function activate(id, unit, guid)
    return RPHelper.Runtime.HandleEvent("UNIT_SPELLCAST_SUCCEEDED", unit or "player", guid, id)
end

abilityTest("success alone selects existing cast-time and instant content", function(a, frame)
    truthy(frame.registered.UNIT_SPELLCAST_SUCCEEDED)
    truthy(activate(19750))
    equal(a.output[1].text, "A swift blessing of the Light!")
    truthy(activate(20288))
    equal(a.output[2].text, "My strikes are guided by divine will!")
    equal(RPHelper.Runtime.IsInCombat(), false)
    for _, event in ipairs({ "UNIT_SPELLCAST_START", "UNIT_SPELLCAST_SENT",
        "UNIT_SPELLCAST_STOP", "UNIT_SPELLCAST_FAILED", "UNIT_SPELLCAST_CHANNEL_START",
        "UNIT_SPELLCAST_EMPOWER_STOP", "UNIT_SPELLCAST_RETICLE_TARGET" }) do
        equal(RPHelper.Runtime.HandleEvent(event, "player", "guid", 19750), false)
        equal(frame.registered[event], nil)
    end
    equal(#a.output, 2)
end)

abilityTest("production random insult provider participates in normal runtime preparation", function(a)
    local original = RPHelper.Content.ability.PALADIN.FLASH_OF_LIGHT
    RPHelper.Content.ability.PALADIN.FLASH_OF_LIGHT = {
        { type = "say", text = "Over here! {RINSULT}" },
    }
    local ok, err = pcall(function()
        truthy(activate(19750))
        equal(a.output[1].text, "Over here! You annoying lump of armpit hairs.")
    end)
    RPHelper.Content.ability.PALADIN.FLASH_OF_LIGHT = original
    if not ok then error(err, 2) end
end)

abilityTest("addon frame forwards successful activations to runtime", function(a)
    local frame = newFrame()
    local previousCreateFrame = CreateFrame
    CreateFrame = function() return frame end
    local ok, err = pcall(function() dofile("RPHelper/RPHelper.lua") end)
    CreateFrame = previousCreateFrame
    if not ok then error(err) end
    frame.OnEvent(frame, "ADDON_LOADED", "RPHelper")
    RPHelper.Runtime.SetAPI(a)
    truthy(frame.registered.UNIT_SPELLCAST_SUCCEEDED)
    frame.OnEvent(frame, "UNIT_SPELLCAST_SUCCEEDED", "pet", nil, 19750)
    frame.OnEvent(frame, "UNIT_SPELLCAST_START", "player", nil, 19750)
    equal(#a.output, 0)
    frame.OnEvent(frame, "UNIT_SPELLCAST_SUCCEEDED", "player", nil, 19750)
    equal(#a.output, 1)
    equal(a.output[1].text, "A swift blessing of the Light!")
end)

abilityTest("other units unknown IDs and unsupported variants reject before selection", function(a)
    local choose = RPHelper.ChooseAbilityCandidate
    RPHelper.ChooseAbilityCandidate = function() error("selection should not run") end
    local ok, err = pcall(function()
        for _, unit in ipairs({ "pet", "target", "party1", "vehicle", "Player", "" }) do
            equal(activate(19750, unit), false)
        end
        for _, id in ipairs({ 1, 19751, 6603, 6803, 2973, 20271 }) do
            equal(activate(id), false)
        end
    end)
    RPHelper.ChooseAbilityCandidate = choose
    if not ok then error(err) end
    equal(#a.output, 0)
end)

abilityTest("Hunter reconciliation adds no pet dispatch or spell mappings", function(a)
    equal(RPHelper.Runtime.EventTrigger.petattackstart, nil)
    equal(RPHelper.Runtime.EventTrigger.petattackstop, nil)
    equal(RPHelper.Runtime.EventTrigger.petdies, nil)
    equal(RPHelper.RuntimeAPI.AbilitySpellIDs.HUNTER, nil)
    equal(RPHelper.Runtime.HandleEvent("UNIT_SPELLCAST_SUCCEEDED", "pet", nil, 2973), false)
    equal(RPHelper.Runtime.HandleEvent("UNIT_SPELLCAST_SUCCEEDED", "player", nil, 2973), false)
    equal(#a.output, 0)
end)

abilityTest("Warlock reconciliation adds no demon dispatch or spell mappings", function(a)
    equal(RPHelper.Runtime.EventTrigger.petattackstart, nil)
    equal(RPHelper.Runtime.EventTrigger.petattackstop, nil)
    equal(RPHelper.Runtime.EventTrigger.petdies, nil)
    equal(RPHelper.RuntimeAPI.AbilitySpellIDs.WARLOCK, nil)
    equal(RPHelper.Runtime.HandleEvent("UNIT_SPELLCAST_SUCCEEDED", "pet", nil, 688), false)
    equal(RPHelper.Runtime.HandleEvent("UNIT_SPELLCAST_SUCCEEDED", "player", nil, 688), false)
    equal(#a.output, 0)
end)

abilityTest("malformed required fields cannot enter the policy path", function(a)
    local bad = setmetatable({}, { __tostring = function() error("no stringify") end })
    for _, value in ipairs({ false, true, "19750", bad, function() end, 0, -1, 1.5, math.huge, -math.huge, 0/0 }) do
        equal(activate(value), false)
        equal(RPHelper.Runtime.HandleEvent("UNIT_SPELLCAST_SUCCEEDED", value, nil, 19750), false)
    end
    equal(RPHelper.Runtime.HandleEvent("UNIT_SPELLCAST_SUCCEEDED"), false)
    equal(RPHelper.Runtime.HandleEvent("UNIT_SPELLCAST_SUCCEEDED", nil, nil, 19750), false)
    equal(activate(nil), false)
    equal(#a.output, 0)
    truthy(activate(19750))
end)

abilityTest("secret unit spell and class fields fail closed without spending cooldown", function(a)
    setSetting("globalCooldown", 10)
    for _, fieldValue in ipairs({ "player", 19750, "PALADIN" }) do
        issecretvalue = function(value) return value == fieldValue end
        equal(activate(19750), false)
    end
    issecretvalue = function() return false end
    truthy(activate(19750))
    equal(#a.output, 1)
end)

abilityTest("missing failing and invalid inspection disables detection", function(a)
    issecretvalue = nil
    equal(activate(19750), false)
    issecretvalue = function() error("inspection unavailable") end
    equal(activate(19750), false)
    for _, invalid in ipairs({ true, "false", 0, {} }) do
        issecretvalue = function() return invalid end
        equal(activate(19750), false)
    end
    issecretvalue = function() return nil end
    equal(activate(19750), false)
    equal(#a.output, 0)
    -- Generic combat functionality does not depend on the new inspector.
    setTrigger("enter_combat", "enabled", true)
    setTrigger("enter_combat", "chance", 1)
    truthy(RPHelper.Runtime.HandleEvent("PLAYER_REGEN_DISABLED"))
end)

abilityTest("unused GUID and cast-bar fields are never inspected", function(a)
    local unused = setmetatable({}, { __tostring = function() error("unused secret") end })
    local count = 0
    issecretvalue = function(value)
        if value == unused then error("unused field inspected") end
        count = count + 1
        return false
    end
    equal(RPHelper.RuntimeAPI.ClassifySpellcastSucceeded("player", unused, 19750, "PALADIN"), "FLASH_OF_LIGHT")
    equal(count, 3)
    truthy(RPHelper.Runtime.HandleEvent("UNIT_SPELLCAST_SUCCEEDED", "player", unused, 19750, unused))
    truthy(activate(20288, "player", nil))
    -- No speculative deduplication, including repeated opaque GUIDs.
    truthy(activate(19750, "player", "same"))
    truthy(activate(19750, "player", "same"))
    equal(#a.output, 4)
end)

abilityTest("mapping is class specific and class adapter failures are safe", function(a)
    for _, class in ipairs({ "WARRIOR", "DRUID", "", false, {} }) do
        a.GetPlayerClass = function() return class end
        equal(activate(19750), false)
    end
    a.GetPlayerClass = function() error("class unavailable") end
    equal(activate(19750), false)
    a.GetPlayerClass = nil
    equal(activate(20288), false)
    equal(#a.output, 0)
end)

abilityTest("master and individual switches reject before content selection", function(a)
    local choose = RPHelper.ChooseAbilityCandidate
    RPHelper.ChooseAbilityCandidate = function() error("disabled selection") end
    setSetting("enabled", false)
    local first = activate(19750)
    setSetting("enabled", true)
    setAbility("PALADIN", "FLASH_OF_LIGHT", "enabled", false)
    local second = activate(19750)
    RPHelper.ChooseAbilityCandidate = choose
    equal(first, false)
    equal(second, false)
    truthy(activate(20288))
    equal(#a.output, 1)
end)

abilityTest("ability chance and global cooldown boundaries use the shared policy", function(a)
    a.clockStep = 0
    setAbility("PALADIN", "FLASH_OF_LIGHT", "chance", 0.2)
    setSetting("globalCooldown", 10)
    a.roll = 0.2
    equal(activate(19750), false)
    a.roll = 0.199
    truthy(activate(19750))
    a.now = 9
    equal(activate(20288), false)
    a.now = 10
    truthy(activate(20288))
    a.now = 19
    equal(activate(19750), false)
    a.now = 20
    truthy(activate(19750))
    equal(#a.output, 3)
    setAbility("PALADIN", "FLASH_OF_LIGHT", "chance", 0)
    a.now = 100
    equal(activate(19750), false)
end)

abilityTest("entry abilities defenses and exit share encounter quota", function(a)
    enableQuota(3)
    setTrigger("enter_combat", "enabled", true)
    setTrigger("enter_combat", "chance", 1)
    setTrigger("dodge", "chance", 1)
    truthy(RPHelper.Runtime.HandleEvent("PLAYER_REGEN_DISABLED"))
    truthy(activate(19750))
    truthy(defend("DODGE"))
    equal(activate(20288), false)
    equal(RPHelper.Runtime.HandleEvent("PLAYER_REGEN_ENABLED"), false)
    equal(#a.output, 3)
    truthy(activate(20288)) -- quota ended, cooldowns still apply normally
    setTrigger("enter_combat", "enabled", false)
    RPHelper.Runtime.HandleEvent("PLAYER_REGEN_DISABLED")
    truthy(activate(19750))
    truthy(RPHelper.Runtime.HandleEvent("PLAYER_REGEN_ENABLED"))
    equal(#a.output, 6)
end)

abilityTest("outside combat has no quota and initialization inside combat does", function(a)
    enableQuota(1)
    truthy(activate(19750))
    truthy(activate(20288))
    a.combat = true
    RPHelper.Runtime.Initialize(newFrame(), a)
    truthy(activate(19750))
    equal(activate(20288), false)
    equal(#a.output, 3)
    RPHelper.Runtime.HandleEvent("PLAYER_REGEN_ENABLED")
    truthy(activate(19750))
end)

abilityTest("failed dispatch and ineligible content spend no cooldown or quota", function(a)
    setSetting("globalCooldown", 10)
    enableQuota(1)
    RPHelper.Runtime.HandleEvent("PLAYER_REGEN_DISABLED")
    local send = a.SendSay
    a.SendSay = function() return false end
    equal(activate(19750), false)
    a.SendSay = function() error("restricted") end
    equal(activate(19750), false)
    a.SendSay = send
    local pool = RPHelper.Content.ability.PALADIN.FLASH_OF_LIGHT
    RPHelper.Content.ability.PALADIN.FLASH_OF_LIGHT = { { type = "say", text = "{TARGET}" } }
    local rejected = activate(19750)
    RPHelper.Content.ability.PALADIN.FLASH_OF_LIGHT = pool
    equal(rejected, false)
    truthy(activate(19750))
    equal(activate(20288), false)
    equal(#a.output, 1)
end)

abilityTest("ability and generic outputs share the global cooldown both ways", function(a)
    a.clockStep = 0
    setSetting("globalCooldown", 10)
    truthy(activate(19750))
    RPHelper.Runtime.HandleEvent("PLAYER_REGEN_DISABLED")
    equal(RPHelper.Runtime.HandleEvent("PLAYER_REGEN_ENABLED"), false)
    a.now = 10
    RPHelper.Runtime.HandleEvent("PLAYER_REGEN_DISABLED")
    truthy(RPHelper.Runtime.HandleEvent("PLAYER_REGEN_ENABLED"))
    a.now = 19
    equal(activate(20288), false)
    a.now = 20
    truthy(activate(20288))
end)

abilityTest("priority ability bypasses cooldown without delaying normal events", function(a)
    a.clockStep = 0
    setSetting("globalCooldown", 20)
    truthy(activate(19750))
    setAbility("PALADIN", "SEAL_OF_RIGHTEOUSNESS", "priority", true)
    a.now = 1
    truthy(activate(20288))
    a.now = 19
    equal(activate(19750), false)
    a.now = 20
    truthy(activate(19750))
    equal(#a.output, 3)
end)

abilityTest("activity routing uses local sayings in world and suppresses raids", function(a)
    a.activity = "world"
    truthy(activate(19750))
    equal(a.output[1].type, "local")
    a.activity = "raid"
    equal(activate(19750), false)
    a.activity = "unknown"
    equal(activate(19750), false)
end)

abilityTest("Druid fixture keeps speech suppression and eligible emotes for priority", function(a)
    -- Synthetic ID is test-only: no production Druid IDs are established.
    local mapping = RPHelper.RuntimeAPI.AbilitySpellIDs.DRUID
    local ability = RPHelper.Ability.DRUID.INNERVATE
    local pool = RPHelper.Content.ability.DRUID.INNERVATE
    RPHelper.RuntimeAPI.AbilitySpellIDs.DRUID = { [900001] = "INNERVATE" }
    RPHelper.Ability.DRUID.INNERVATE = "INNERVATE"
    setAbility("DRUID", "INNERVATE", "chance", 1)
    setAbility("DRUID", "INNERVATE", "priority", true)
    RPHelper.Content.ability.DRUID.INNERVATE = { { type = "say", text = "speech" } }
    a.GetPlayerClass = function() return "DRUID" end
    local ok, err = pcall(function()
        for _, form in ipairs({ 1, 5, 31, 999 }) do
            a.GetShapeshiftFormID = function() return form end
            equal(activate(900001), false)
        end
        a.GetShapeshiftFormID = function() error("form unreadable") end
        equal(activate(900001), false)
        table.insert(RPHelper.Content.ability.DRUID.INNERVATE, { type = "customemote", text = "emote" })
        truthy(activate(900001))
        equal(a.output[1].type, "customemote")
        a.GetShapeshiftFormID = function() return 0 end
        truthy(activate(900001))
        equal(a.output[2].type, "say")
    end)
    RPHelper.RuntimeAPI.AbilitySpellIDs.DRUID = mapping
    RPHelper.Ability.DRUID.INNERVATE = ability
    RPHelper.Content.ability.DRUID.INNERVATE = pool
    if not ok then error(err) end
end)

abilityTest("registration failures disable abilities and preserve generic events", function(a)
    for _, mode in ipairs({ "throw", "false", "missing" }) do
        local frame = newFrame()
        local register = frame.RegisterEvent
        frame.RegisterEvent = function(self, event)
            if event == "UNIT_SPELLCAST_SUCCEEDED" then
                if mode == "throw" then error("unsupported event") end
                return false
            end
            return register(self, event)
        end
        a.RegisterAbilityEvents = mode ~= "missing" and RPHelper.RuntimeAPI.RegisterAbilityEvents or nil
        truthy(RPHelper.Runtime.Initialize(frame, a))
        truthy(frame.registered.PLAYER_REGEN_DISABLED)
        truthy(frame.registered.PLAYER_REGEN_ENABLED)
        truthy(frame.registered.UNIT_COMBAT)
        equal(activate(19750), false)
        RPHelper.Runtime.HandleEvent("PLAYER_REGEN_DISABLED")
        truthy(RPHelper.Runtime.HandleEvent("PLAYER_REGEN_ENABLED"))
    end
end)

abilityTest("missing failing and unsupported classifier adapters fail safely", function(a)
    a.ClassifySpellcastSucceeded = nil
    equal(activate(19750), false)
    a.ClassifySpellcastSucceeded = function() error("classifier unavailable") end
    equal(activate(19750), false)
    a.ClassifySpellcastSucceeded = function() return "UNKNOWN" end
    equal(activate(19750), false)
    a.RegisterAbilityEvents = function() error("registration adapter unavailable") end
    truthy(RPHelper.Runtime.Initialize(newFrame(), a))
    equal(activate(19750), false)
    equal(#a.output, 0)
end)

abilityTest("malformed saved ability settings preserve data and use conservative defaults", function(a)
    for _, malformed in ipairs({ "broken", false, 42 }) do
        RPHelperDB.abilities = malformed
        RPHelper.InitializeDatabase()
        equal(RPHelperDB.abilities, malformed)
        a.roll = 0.05
        equal(activate(19750), false) -- conservative chance boundary
    end
    for _, container in ipairs({
        { PALADIN = false },
        { PALADIN = { FLASH_OF_LIGHT = "broken" } },
        { PALADIN = { FLASH_OF_LIGHT = { enabled = "yes", chance = 0/0, cooldown = -1 } } },
    }) do
        RPHelperDB.abilities = container
        RPHelper.InitializeDatabase()
        equal(RPHelperDB.abilities, container)
        a.roll = 0.05
        equal(activate(19750), false)
    end
    local saved = { enabled = false, chance = 0.7, cooldown = 55, extra = "keep" }
    RPHelperDB.abilities = { PALADIN = { FLASH_OF_LIGHT = saved } }
    RPHelper.InitializeDatabase()
    equal(RPHelperDB.abilities.PALADIN.FLASH_OF_LIGHT, saved)
    equal(saved.chance, 0.7)
    equal(saved.extra, "keep")
    equal(activate(19750), false)
end)

test("local display is prefixed and reports unavailable UI", function()
    local previous = DEFAULT_CHAT_FRAME
    DEFAULT_CHAT_FRAME = nil
    equal(RPHelper.RuntimeAPI.DisplayLocal("hello"), false)
    local text
    DEFAULT_CHAT_FRAME = { AddMessage = function(_, value) text = value end }
    truthy(RPHelper.RuntimeAPI.DisplayLocal("hello"))
    truthy(string.find(text, "[RPHelper]", 1, true))
    truthy(string.find(text, "hello", 1, true))
    DEFAULT_CHAT_FRAME = previous
end)

local function disableShippedTrigger(trigger, class, race, options)
    for _, entry in ipairs(RPHelper.GetContentPool(trigger, race, class, options)) do
        if entry.defaultID then truthy(RPHelper.UserContent.SetDefaultDisabled(entry.defaultID, true)) end
    end
end
local function customAbilityOnly(ability, entry)
    for _, shipped in ipairs(RPHelper.GetAbilityPool("PALADIN", ability)) do
        truthy(RPHelper.UserContent.SetDefaultDisabled(shipped.defaultID, true))
    end
    return RPHelper.UserContent.Add({ layer = "ability", class = "PALADIN", ability = ability }, entry)
end

abilityTest("saved custom ability content is selected by guarded successful activation", function(a)
    local id = customAbilityOnly("FLASH_OF_LIGHT", { type = "say", text = "Custom blessing." })
    truthy(id)
    equal(activate(19750, "target"), false)
    equal(activate(999999), false)
    truthy(activate(19750))
    equal(a.output[1].text, "Custom blessing.")
    RPHelper.InitializeDatabase()
    truthy(activate(19750))
    equal(a.output[2].text, "Custom blessing.")
    truthy(RPHelper.UserContent.Remove(id))
    equal(activate(19750), false)
end)

abilityTest("custom ability respects master individual and chance settings", function(a)
    truthy(customAbilityOnly("FLASH_OF_LIGHT", { type = "say", text = "Mine." }))
    setSetting("enabled", false)
    equal(activate(19750), false)
    setSetting("enabled", true)
    setAbility("PALADIN", "FLASH_OF_LIGHT", "enabled", false)
    equal(activate(19750), false)
    setAbility("PALADIN", "FLASH_OF_LIGHT", "enabled", true)
    setAbility("PALADIN", "FLASH_OF_LIGHT", "chance", 0.4)
    a.roll = 0.4;equal(activate(19750), false)
    a.roll = 0.399;truthy(activate(19750))
    equal(#a.output, 1)
end)

abilityTest("custom abilities share the global cooldown boundary", function(a)
    truthy(customAbilityOnly("FLASH_OF_LIGHT", { type = "say", text = "First." }))
    truthy(customAbilityOnly("SEAL_OF_RIGHTEOUSNESS", { type = "say", text = "Second." }))
    a.clockStep = 0
    setSetting("globalCooldown", 5)
    truthy(activate(19750))
    a.now = 4.999;equal(activate(20288), false)
    a.now = 5;truthy(activate(20288))
    a.now = 9.999;equal(activate(19750), false)
    a.now = 10;truthy(activate(19750))
    equal(#a.output, 3)
end)

abilityTest("custom activations share encounter quota with defensive and exit reactions", function(a)
    truthy(customAbilityOnly("FLASH_OF_LIGHT", { type = "say", text = "Cast." }))
    setTrigger("dodge", "chance", 1)
    enableQuota(2)
    disableShippedTrigger("dodge", "PALADIN", "HUMAN")
    truthy(RPHelper.UserContent.Add({ layer = "generic", trigger = "dodge" }, { type = "customemote", text = "sidesteps." }))
    equal(RPHelper.Runtime.HandleEvent("UNIT_COMBAT", "player", "DODGE"), false)
    equal(RPHelper.Runtime.HandleEvent("PLAYER_REGEN_DISABLED"), false)
    truthy(activate(19750))
    truthy(RPHelper.Runtime.HandleEvent("UNIT_COMBAT", "player", "DODGE"))
    equal(activate(19750), false)
    equal(RPHelper.Runtime.HandleEvent("PLAYER_REGEN_ENABLED"), false)
    truthy(activate(19750))
    truthy(activate(19750))
    equal(#a.output, 4)
end)

abilityTest("failed custom dispatch consumes neither quota nor cooldown", function(a)
    truthy(customAbilityOnly("FLASH_OF_LIGHT", { type = "say", text = "Mine." }))
    setSetting("globalCooldown", 100)
    enableQuota(1)
    RPHelper.Runtime.HandleEvent("PLAYER_REGEN_DISABLED")
    local send = a.SendSay
    a.SendSay = function() return false end
    equal(activate(19750), false)
    a.SendSay = function() error("blocked") end
    equal(activate(19750), false)
    a.SendSay = send
    truthy(activate(19750))
    equal(activate(19750), false)
    equal(#a.output, 1)
end)

abilityTest("custom say emote and customemote use existing activity routes", function(a)
    local id = customAbilityOnly("FLASH_OF_LIGHT", { type = "say", text = "Speech." })
    local scope = { layer = "ability", class = "PALADIN", ability = "FLASH_OF_LIGHT" }
    a.activity = "world";truthy(activate(19750));equal(a.output[1].type, "local")
    a.activity = "dungeon";truthy(activate(19750));equal(a.output[2].type, "say")
    a.activity = "raid";equal(activate(19750), false)
    truthy(RPHelper.UserContent.Edit(id, scope, { type = "emote", text = "ROAR" }))
    a.activity = "world";truthy(activate(19750));equal(a.output[3].type, "emote")
    truthy(RPHelper.UserContent.Edit(id, scope, { type = "customemote", text = "gestures." }))
    truthy(activate(19750));equal(a.output[4].type, "customemote")
    a.activity = "unknown";equal(activate(19750), false)
end)

abilityTest("missing custom target pet and invalid saved content do not consume quota", function(a)
    local id = customAbilityOnly("FLASH_OF_LIGHT", { type = "say", text = "Hello {TARGET}." })
    local scope = { layer = "ability", class = "PALADIN", ability = "FLASH_OF_LIGHT" }
    enableQuota(1)
    RPHelper.Runtime.HandleEvent("PLAYER_REGEN_DISABLED")
    equal(activate(19750), false)
    truthy(RPHelper.UserContent.Edit(id, scope, { type = "say", text = "Hello {PNAME}." }))
    equal(activate(19750), false)
    RPHelperDB.custom.entries[id].entry.type = "invalid"
    RPHelper.UserContent.Invalidate()
    equal(activate(19750), false)
    truthy(RPHelper.UserContent.Edit(id, scope, { type = "say", text = "Safe." }))
    truthy(activate(19750))
    equal(#a.output, 1)
end)

abilityTest("custom defensive and combat-entry settings remain enforced", function(a)
    a.RandomIndex = function(size) return size end
    setTrigger("enter_combat", "enabled", true)
    setTrigger("enter_combat", "chance", 1)
    disableShippedTrigger("entercombat", "PALADIN", "HUMAN")
    truthy(RPHelper.UserContent.Add({ layer = "class", class = "PALADIN", trigger = "entercombat" }, { type = "say", text = "Ready." }))
    truthy(RPHelper.Runtime.HandleEvent("PLAYER_REGEN_DISABLED"))
    equal(a.output[1].text, "Ready.")
    disableShippedTrigger("block", "PALADIN", "HUMAN")
    truthy(RPHelper.UserContent.Add({ layer = "generic", trigger = "block" }, { type = "emote", text = "ROAR" }))
    setTrigger("block", "enabled", false)
    equal(RPHelper.Runtime.HandleEvent("UNIT_COMBAT", "player", "BLOCK"), false)
    setTrigger("block", "enabled", true)
    setTrigger("block", "chance", 1)
    truthy(RPHelper.Runtime.HandleEvent("UNIT_COMBAT", "player", "BLOCK"))
    equal(a.output[2].type, "emote")
end)

abilityTest("secret spell payloads cannot reach custom content selection", function(a)
    truthy(customAbilityOnly("FLASH_OF_LIGHT", { type = "say", text = "Mine." }))
    issecretvalue = function(value) return value == 19750 end
    equal(activate(19750), false)
    issecretvalue = nil
    equal(activate(19750), false)
    issecretvalue = function() error("inspection failure") end
    equal(activate(19750), false)
    equal(#a.output, 0)
end)

abilityTest("default toggles affect live ability selection without catalogue mutation", function(a)
    local pool = RPHelper.GetAbilityPool("PALADIN", "FLASH_OF_LIGHT")
    local count = #pool
    for _, entry in ipairs(pool) do truthy(RPHelper.UserContent.SetDefaultDisabled(entry.defaultID, true)) end
    equal(activate(19750), false)
    equal(#pool, count)
    truthy(RPHelper.UserContent.SetDefaultDisabled(pool[1].defaultID, false))
    truthy(activate(19750))
    equal(a.output[1].text, pool[1].text)
end)

abilityTest("custom-only unknown abilities do not expand automatic spell coverage", function(a)
    truthy(RPHelper.UserContent.Add({ layer = "ability", class = "PALADIN", ability = "FUTURE_ABILITY" }, { type = "say", text = "Future." }))
    equal(activate(900999), false)
    equal(RPHelper.Runtime.HandleTrigger("future_trigger"), false)
    equal(#a.output, 0)
end)

test("customization: Druid custom content cannot bypass form speech suppression", function()
    local a = newAdapter("DRUID", "TAUREN", 1)
    initialize(a)
    setTrigger("enter_combat", "chance", 1)
    disableShippedTrigger("entercombat", "DRUID", "TAUREN", { class = "DRUID", form = "CAT" })
    local scope = { layer = "generic", trigger = "entercombat" }
    local id = RPHelper.UserContent.Add(scope, { type = "say", text = "Forbidden speech." })
    truthy(id)
    equal(RPHelper.Runtime.HandleEvent("PLAYER_REGEN_DISABLED"), false)
    setTrigger("leave_combat", "enabled", false)
    RPHelper.Runtime.HandleEvent("PLAYER_REGEN_ENABLED")
    truthy(RPHelper.UserContent.Edit(id, scope, { type = "customemote", text = "bares its fangs." }))
    truthy(RPHelper.Runtime.HandleEvent("PLAYER_REGEN_DISABLED"))
    equal(a.output[1].type, "customemote")
end)

if failures > 0 then
    io.stderr:write(tostring(failures) .. " of " .. tostring(tests) .. " runtime tests failed\n")
    os.exit(1)
end

print(tostring(tests) .. " runtime tests passed")
