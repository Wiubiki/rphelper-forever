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
    local adapter = { output = {}, combat = false }
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

    truthy(RPHelper.Output.Dispatch({ type = "say", text = "spoken" }, RPHelper.RuntimeAPI))
    truthy(RPHelper.Output.Dispatch({ type = "customemote", text = "waves." }, RPHelper.RuntimeAPI))
    truthy(RPHelper.Output.Dispatch({ type = "emote", text = "WAVE" }, RPHelper.RuntimeAPI))
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

if failures > 0 then
    io.stderr:write(tostring(failures) .. " of " .. tostring(tests) .. " runtime tests failed\n")
    os.exit(1)
end

print(tostring(tests) .. " runtime tests passed")
