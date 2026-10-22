RPHelper = RPHelper or {}
RPHelper.RuntimeAPI = RPHelper.RuntimeAPI or {}

local API = RPHelper.RuntimeAPI

local playableClasses = {
    WARRIOR = true, ROGUE = true, HUNTER = true, SHAMAN = true, DRUID = true,
    PALADIN = true, MAGE = true, PRIEST = true, WARLOCK = true,
}

local function call(api, ...)
    if type(api) ~= "function" then
        return false
    end
    return pcall(api, ...)
end

-- Forever defensive feedback only. Unused flag/amount/school fields are never read.
local function safeField(value)
    local ok, secret = call(issecretvalue, value)
    if not ok or secret ~= false then return nil, "restricted" end
    return value, "readable"
end

local function safeUnitToken(value)
    if type(value) ~= "string" then return "invalid" end
    if value == "player" then return "player" end
    if value == "target" or value == "targettarget" or value == "focus"
        or value == "pet" or value == "vehicle" or value == "mouseover"
        or string.match(value, "^party%d+$") or string.match(value, "^raid%d+$")
        or string.match(value, "^nameplate%d+$") or string.match(value, "^boss%d+$")
        or string.match(value, "^arena%d+$") then return value end
    return "other"
end

function API.ClassifyUnitCombat(unitTarget, action)
    local safeUnit, unitState = safeField(unitTarget)
    local safeAction, actionState = safeField(action)
    local detail = {
        unit = unitState == "readable" and safeUnitToken(safeUnit) or "restricted",
        action = actionState == "readable" and type(safeAction) == "string"
            and ({ DODGE = "DODGE", PARRY = "PARRY", BLOCK = "BLOCK" })[safeAction]
            or (actionState == "readable" and "unsupported" or "restricted"),
        matched = false,
    }
    if unitState ~= "readable" then detail.result = "unit_restricted"; return nil, detail end
    if actionState ~= "readable" then detail.result = "action_restricted"; return nil, detail end
    if type(safeUnit) ~= "string" then detail.result = "invalid_unit_type"; return nil, detail end
    if type(safeAction) ~= "string" then detail.result = "invalid_action_type"; return nil, detail end
    if safeUnit ~= "player" then detail.result = "wrong_unit"; return nil, detail end
    local trigger
    if safeAction == "DODGE" then trigger = "dodge" end
    if safeAction == "PARRY" then trigger = "parry" end
    if safeAction == "BLOCK" then trigger = "block" end
    if not trigger then detail.result = "unsupported_action"; return nil, detail end
    detail.result, detail.matched = "matched", true
    return trigger, detail
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
    local safeUnit, unitState = safeField(unitTarget)
    local detail = {
        unit = unitState == "readable" and safeUnitToken(safeUnit) or "restricted",
        class = "unavailable",
        matched = false,
    }
    if unitState ~= "readable" then detail.result = "unit_restricted"; return nil, detail end
    if type(safeUnit) ~= "string" then detail.result = "invalid_unit_type"; return nil, detail end
    if safeUnit ~= "player" then detail.result = "wrong_unit"; return nil, detail end

    local safeSpell, spellState = safeField(spellID)
    if spellState ~= "readable" then detail.result = "spell_restricted"; return nil, detail end
    if type(safeSpell) ~= "number" or safeSpell <= 0 or safeSpell >= math.huge
        or safeSpell ~= safeSpell or safeSpell % 1 ~= 0 then
        detail.result = "invalid_spell_id"; return nil, detail
    end
    detail.spellID = safeSpell

    local safeClass, classState = safeField(class)
    if classState ~= "readable" or type(safeClass) ~= "string" or not playableClasses[safeClass] then
        detail.result = "unmapped"; return nil, detail
    end
    detail.class = safeClass
    local spells = API.AbilitySpellIDs[safeClass]
    local ability = spells and spells[safeSpell] or nil
    if not ability then detail.result = "unmapped"; return nil, detail end
    detail.result, detail.matched, detail.ability = "mapped", true, ability
    return ability, detail
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

local function usable(value)
    if type(issecretvalue) ~= "function" then return true end
    local ok, secret = pcall(issecretvalue, value)
    return ok and secret == false
end

function API.GetPlayerSex()
    local ok, sex = call(UnitSex, "player")
    if not ok or not usable(sex) then return nil end
    if sex == 1 or sex == 2 or sex == 3 then return sex end
end

-- Use the semantic token returned by the client rather than assuming numeric
-- power IDs. Additional Forever power tokens require live verification.
function API.GetPlayerPowerLabel()
    local ok, _, token = call(UnitPowerType, "player")
    if not ok or not usable(token) or type(token) ~= "string" then return nil end
    local labels = { MANA = "mana", RAGE = "rage", ENERGY = "energy" }
    return labels[token]
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
