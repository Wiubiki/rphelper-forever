RPHelper = RPHelper or {}
RPHelper.RuntimeAPI = RPHelper.RuntimeAPI or {}

local API = RPHelper.RuntimeAPI

local function call(api, ...)
    if type(api) ~= "function" then
        return false
    end
    return pcall(api, ...)
end

-- Forever defensive feedback only. Unused flag/amount/school fields are never read.
function API.ClassifyUnitCombat(unitTarget, action)
    local unitOK, unitSecret = call(issecretvalue, unitTarget)
    local actionOK, actionSecret = call(issecretvalue, action)
    if not unitOK or unitSecret ~= false or not actionOK or actionSecret ~= false then
        return nil
    end
    if type(unitTarget) ~= "string" or type(action) ~= "string" then return nil end
    if unitTarget ~= "player" then return nil end
    if action == "DODGE" then return "dodge" end
    if action == "PARRY" then return "parry" end
    if action == "BLOCK" then return "block" end
end

-- Ordinary registration avoids assuming unit-filtered registration is supported.
-- Registration/delivery and payload readability still need live Forever tests.
function API.RegisterDefensiveEvents(frame)
    local ok, result = pcall(function() return frame:RegisterEvent("UNIT_COMBAT") end)
    return ok and result ~= false
end

-- Exact Forever observations only; no inferred ranks or retail normalization.
-- Evidence: docs/spell_casting_api_audit.md, first runtime increment.
API.AbilitySpellIDs = {
    PALADIN = {
        [19750] = "FLASH_OF_LIGHT",
        [20288] = "SEAL_OF_RIGHTEOUSNESS",
    },
}

-- GUID and cast-bar fields are intentionally unused, including when secret.
function API.ClassifySpellcastSucceeded(unitTarget, castGUID, spellID, class)
    local unitOK, unitSecret = call(issecretvalue, unitTarget)
    if not unitOK or unitSecret ~= false then return nil end
    if type(unitTarget) ~= "string" or unitTarget ~= "player" then return nil end
    local spellOK, spellSecret = call(issecretvalue, spellID)
    if not spellOK or spellSecret ~= false then return nil end
    if type(spellID) ~= "number" or spellID <= 0 or spellID >= math.huge
        or spellID ~= spellID or spellID % 1 ~= 0 then return nil end
    local classOK, classSecret = call(issecretvalue, class)
    if not classOK or classSecret ~= false or type(class) ~= "string" then return nil end
    local spells = API.AbilitySpellIDs[class]
    return spells and spells[spellID] or nil
end

function API.RegisterAbilityEvents(frame)
    local ok, result = pcall(function() return frame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED") end)
    return ok and result ~= false
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
