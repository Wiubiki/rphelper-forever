RPHelper = RPHelper or {}
RPHelper.RuntimeAPI = RPHelper.RuntimeAPI or {}

local API = RPHelper.RuntimeAPI

local function call(api, ...)
    if type(api) ~= "function" then
        return false
    end
    return pcall(api, ...)
end

-- These APIs are established WoW addon APIs but still require live Forever
-- verification. Keeping them behind this adapter makes every assumption
-- replaceable in tests and revisable without changing runtime coordination.
function API.GetPlayerClass()
    local ok, _, classFile = call(UnitClass, "player")
    return ok and classFile or nil
end

function API.GetPlayerRace()
    local ok, _, raceFile = call(UnitRace, "player")
    return ok and raceFile or nil
end

function API.GetShapeshiftFormID()
    if type(GetShapeshiftFormID) ~= "function" then
        error("GetShapeshiftFormID is unavailable", 0)
    end
    local ok, formID = pcall(GetShapeshiftFormID)
    if not ok then
        error(formID, 0)
    end
    return formID
end

function API.IsPlayerInCombat()
    local ok, inCombat = call(UnitAffectingCombat, "player")
    if not ok then
        return nil
    end
    return not not inCombat
end

function API.SendSay(text)
    local ok, result = call(SendChatMessage, text, "SAY")
    return ok and result ~= false
end

function API.RunEmote(token)
    local ok, result = call(DoEmote, token)
    return ok and result ~= false
end

function API.SendCustomEmote(text)
    local ok, result = call(SendChatMessage, text, "EMOTE")
    return ok and result ~= false
end

-- Unknown/unsupported activities never imply permission to transmit.
function API.GetActivity()
    local ok, activity = pcall(function()
        if type(IsInInstance) ~= "function" then return nil end
        local inside, kind = IsInInstance()
        if inside == false and kind == "none" then return "world" end
        if inside == true and kind == "party" then return "dungeon" end
        if inside == true and kind == "raid" then return "raid" end
    end)
    return ok and activity or nil
end

function API.GetTime()
    local ok, value = call(GetTime)
    return ok and value or nil
end

function API.Random()
    return math.random()
end

function API.RandomIndex(size)
    return math.random(size)
end

-- AddMessage is a local UI operation, never a chat transmission.
function API.DisplayLocal(text)
    local ok, result = pcall(function()
        if not DEFAULT_CHAT_FRAME or type(DEFAULT_CHAT_FRAME.AddMessage) ~= "function" then return false end
        DEFAULT_CHAT_FRAME:AddMessage("|cffb8a0df[RPHelper]|r " .. text)
        return true
    end)
    return ok and result == true
end
