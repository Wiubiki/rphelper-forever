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
    local ok = call(SendChatMessage, text, "SAY")
    return ok
end

function API.RunEmote(token)
    local ok = call(DoEmote, token)
    return ok
end

function API.SendCustomEmote(text)
    local ok = call(SendChatMessage, text, "EMOTE")
    return ok
end
