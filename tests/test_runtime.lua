local failures = 0
local tests = 0

local function test(name, callback)
    tests = tests + 1
    local ok, message = pcall(callback)
    if not ok then
        failures = failures + 1
        io.stderr:write("FAIL: " .. name .. "\n  " .. tostring(message) .. "\n")
    end
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
dofile("RPHelper/Core/KeywordResolvers.lua")
dofile("RPHelper/Core/DruidForms.lua")
dofile("RPHelper/Core/ContentEngine.lua")
dofile("RPHelper/Core/Content.lua")
dofile("RPHelper/Core/RuntimeAPI.lua")
dofile("RPHelper/Core/Output.lua")
dofile("RPHelper/Core/Runtime.lua")
dofile("RPHelper/Core/Commands.lua")
dofile("RPHelper/Data/Generic.lua")
dofile("RPHelper/Data/Races/Tauren.lua")
dofile("RPHelper/Data/Classes/Druid.lua")

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
    local adapter = { output = {}, combat = false, now = 0, activity = "dungeon", roll = 0 }
    function adapter.GetTime() return adapter.now end
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

local function initialize(adapter)
    RPHelperDB = nil
    RPHelper.InitializeDatabase()
    RPHelperDB.triggers.leave_combat.enabled = true
    RPHelperDB.settings.globalCooldown = 0
    RPHelperDB.triggers.enter_combat.cooldown = 0
    RPHelperDB.triggers.leave_combat.cooldown = 0
    local frame = newFrame()
    truthy(RPHelper.Runtime.Initialize(frame, adapter))
    return frame
end

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
    RPHelperDB.settings.enabled = false
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
    RPHelper.Content.generic.entercombat = { { type = "say", text = "ready" } }
    RPHelper.Content.generic.leavecombat = { { type = "say", text = "done" } }
    return adapter
end
local function fire() return RPHelper.Runtime.HandleTrigger("entercombat") end

test("disabled trigger still tracks combat transitions", function()
    local a = policyAdapter()
    RPHelperDB.triggers.enter_combat.enabled = false
    equal(RPHelper.Runtime.HandleEvent("PLAYER_REGEN_DISABLED"), false)
    equal(RPHelper.Runtime.IsInCombat(), true)
    truthy(RPHelper.Runtime.HandleEvent("PLAYER_REGEN_ENABLED"))
    equal(#a.output, 1)
end)

test("probability uses strict boundaries and skips RNG at zero and one", function()
    local a = policyAdapter()
    a.roll = 0.2
    equal(fire(), false)
    a.roll = 0.1999
    truthy(fire())
    RPHelperDB.triggers.enter_combat.chance = 0
    a.Random = function() error("must not roll") end
    equal(fire(), false)
    RPHelperDB.triggers.enter_combat.chance = 1
    truthy(fire())
end)

test("frequency presets multiply default chance and clamp at one", function()
    local a = policyAdapter()
    for _, case in ipairs({{"low", 0.1}, {"normal", 0.2}, {"high", 0.4}}) do
        RPHelperDB.settings.frequencyPreset = case[1]
        a.roll = case[2]
        equal(fire(), false)
        a.roll = case[2] - 0.001
        truthy(fire())
    end
    RPHelperDB.triggers.enter_combat.chance = 0.8
    a.Random = function() error("clamped chance must not roll") end
    truthy(fire())
end)

test("global and trigger cooldowns expire independently at exact boundaries", function()
    local a = policyAdapter()
    RPHelperDB.settings.globalCooldown = 10
    RPHelperDB.triggers.enter_combat.cooldown = 30
    truthy(fire())
    a.now = 9
    equal(RPHelper.Runtime.HandleTrigger("leavecombat"), false)
    a.now = 10
    truthy(RPHelper.Runtime.HandleTrigger("leavecombat"))
    a.now = 29
    equal(fire(), false)
    a.now = 30
    truthy(fire())
end)

test("quota includes exit and resets only at encounter boundaries", function()
    local a = policyAdapter()
    RPHelperDB.settings.maxAutomaticOutputsPerCombat = 1
    truthy(RPHelper.Runtime.HandleEvent("PLAYER_REGEN_DISABLED"))
    equal(fire(), false)
    equal(RPHelper.Runtime.HandleEvent("PLAYER_REGEN_DISABLED"), false)
    equal(RPHelper.Runtime.HandleEvent("PLAYER_REGEN_ENABLED"), false)
    truthy(RPHelper.Runtime.HandleEvent("PLAYER_REGEN_DISABLED"))
    equal(#a.output, 2)
end)

test("every output route consumes the shared encounter quota including exit", function()
    for _, case in ipairs({
        { "say", "dungeon", "say" }, { "say", "world", "local" },
        { "emote", "dungeon", "emote" }, { "customemote", "world", "customemote" },
    }) do
        local a = policyAdapter()
        a.activity = case[2]
        RPHelperDB.settings.maxAutomaticOutputsPerCombat = 2
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

test("out-of-combat attempts ignore quota but obey chance and cooldowns", function()
    local a = policyAdapter()
    RPHelperDB.settings.maxAutomaticOutputsPerCombat = 0
    RPHelperDB.settings.globalCooldown = 10
    RPHelperDB.triggers.enter_combat.cooldown = 30
    a.roll = 1
    equal(fire(), false)
    a.roll = 0
    truthy(fire())
    equal(RPHelper.Runtime.IsInCombat(), false)
    a.now = 9
    equal(RPHelper.Runtime.HandleTrigger("leavecombat"), false)
    a.now = 10
    truthy(RPHelper.Runtime.HandleTrigger("leavecombat"))
    a.now = 29
    equal(fire(), false)
    a.now = 30
    truthy(fire())
    -- Those successful attempts did not spend the next encounter's quota.
    RPHelperDB.settings.maxAutomaticOutputsPerCombat = 1
    a.now = 60
    truthy(RPHelper.Runtime.HandleEvent("PLAYER_REGEN_DISABLED"))
    a.now = 90
    equal(RPHelper.Runtime.HandleEvent("PLAYER_REGEN_ENABLED"), false)
    equal(#a.output, 4)
end)

test("reload in combat initializes quota without inventing an entry reaction", function()
    local a = policyAdapter()
    a.combat = true
    RPHelper.Runtime.Initialize(newFrame(), a)
    RPHelperDB.settings.maxAutomaticOutputsPerCombat = 1
    equal(RPHelper.Runtime.HandleEvent("PLAYER_REGEN_DISABLED"), false)
    truthy(fire())
    equal(RPHelper.Runtime.HandleEvent("PLAYER_REGEN_ENABLED"), false)
    RPHelperDB.settings.maxAutomaticOutputsPerCombat = 0
    equal(RPHelper.Runtime.HandleEvent("PLAYER_REGEN_DISABLED"), false)
end)

test("failed dispatch and rejected candidates consume neither cooldown nor quota", function()
    local a = policyAdapter()
    RPHelperDB.settings.globalCooldown = 10
    RPHelperDB.triggers.enter_combat.cooldown = 30
    RPHelperDB.settings.maxAutomaticOutputsPerCombat = 1
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
    RPHelperDB.settings.enableInRaids = true
    truthy(fire())
    RPHelper.Content.generic.entercombat = { { type = "say", text = "safe" } }
    truthy(fire())
    equal(a.output[#a.output].type, "local")
    a.activity = "unsupported"
    equal(fire(), false)
    a.GetActivity = function() error("unavailable") end
    equal(fire(), false)
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
    RPHelperDB.settings.frequencyPreset = {}
    RPHelperDB.settings.globalCooldown = -1
    RPHelperDB.triggers.enter_combat.chance = 0/0
    RPHelperDB.triggers.enter_combat.cooldown = math.huge
    truthy(fire())
    a.now = 29
    equal(fire(), false)
    a.now = 30
    truthy(fire())
    equal(RPHelperDB.settings.globalCooldown, -1)
    equal(RPHelperDB.triggers.enter_combat.cooldown, math.huge)
    for _, value in ipairs({false, "broken", 123}) do
        RPHelperDB.settings = value
        RPHelperDB.triggers = value
        RPHelper.InitializeDatabase()
        equal(RPHelperDB.settings, value)
        equal(RPHelperDB.triggers, value)
        RPHelper.Runtime.Initialize(newFrame(), a)
        truthy(fire())
    end
    RPHelperDB = "broken root"
    RPHelper.InitializeDatabase()
    equal(RPHelperDB, "broken root")
    RPHelper.Runtime.Initialize(newFrame(), a)
    truthy(fire())
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
        local saved = { settings = { enabled = enabled, frequencyPreset = "low" },
            custom = { authored = "preserved" } }
        loadAddon(saved)
        equal(captureCommand("status")[1],
            enabled == false and "RPHelper is disabled." or "RPHelper is enabled.")
        equal(saved.settings.enabled, enabled)
        equal(captureCommand("off")[1], "RPHelper disabled.")
        equal(captureCommand("status")[1], "RPHelper is disabled.")
        equal(saved.settings.enabled, false)
        equal(captureCommand("on")[1], "RPHelper enabled.")
        equal(saved.settings.enabled, true)
        equal(saved.settings.frequencyPreset, "low")
        equal(saved.custom.authored, "preserved")
    end
    for _, saved in ipairs({ {}, { settings = {} } }) do
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
    a.now = 10
    truthy(fire())
    a.GetTime = nil
    equal(fire(), false)
end)

test("policy gates run before randomness and content selection", function()
    local a = policyAdapter()
    local calls = 0
    a.Random = function() calls = calls + 1; return 0 end
    RPHelperDB.settings.enabled = false
    equal(fire(), false)
    RPHelperDB.settings.enabled = true
    a.activity = "raid"
    equal(fire(), false)
    equal(calls, 0)
    a.activity = "world"
    truthy(fire())
    equal(calls, 1)
    RPHelperDB.settings.globalCooldown = 10
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

if failures > 0 then
    io.stderr:write(tostring(failures) .. " of " .. tostring(tests) .. " runtime tests failed\n")
    os.exit(1)
end

print(tostring(tests) .. " runtime tests passed")
