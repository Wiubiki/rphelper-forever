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

-- Populated by Data/AbilitySpellMappings.lua after canonical abilities load.
API.AbilitySpellIDs = {}

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

function API.HasSecretInspection()
    return type(issecretvalue) == "function"
end

-- Diagnostic-only, optional lookup. No fallback after failure or restriction,
-- no cast GUID/target inspection, and no effect on classification or selection.
function API.GetDiagnosticSpellName(spellID)
    local safeSpell, state = safeField(spellID)
    if state ~= "readable" or type(safeSpell) ~= "number" or safeSpell <= 0
        or safeSpell >= math.huge or safeSpell ~= safeSpell or safeSpell % 1 ~= 0 then return nil end
    local lookup = type(C_Spell) == "table" and C_Spell.GetSpellName or nil
    if type(lookup) ~= "function" then lookup = GetSpellInfo end
    local ok, name = call(lookup, safeSpell)
    if not ok then return nil end
    local safeName, nameState = safeField(name)
    if nameState ~= "readable" or type(safeName) ~= "string" or safeName == "" then return nil end
    -- Bound memory and prevent chat markup/control characters in local display.
    return string.sub(string.gsub(safeName, "[|%c]", ""), 1, 128)
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

local function outputCall(fn, expectsBoolean, ...)
    if type(fn) ~= "function" then return false, "unavailable" end
    local ok, result = pcall(fn, ...)
    if not ok then return false, "error" end
    if not usable(result) then return false, "restricted_result" end
    if result == false or (expectsBoolean and result ~= true) then return false, "rejected" end
    return true, "completed"
end

local function chatAPI()
    local fn = type(C_ChatInfo) == "table" and C_ChatInfo.SendChatMessage or nil
    return type(fn) == "function" and fn or SendChatMessage
end

function API.SendSay(text)
    return outputCall(chatAPI(), false, text, "SAY")
end

function API.RunEmote(token)
    local fn = type(C_ChatInfo) == "table" and C_ChatInfo.PerformEmote or nil
    if type(fn) == "function" then return outputCall(fn, true, token) end
    return outputCall(DoEmote, false, token)
end

function API.SendCustomEmote(text)
    return outputCall(chatAPI(), false, text, "EMOTE")
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
    if not DEFAULT_CHAT_FRAME then return false, "unavailable" end
    return outputCall(DEFAULT_CHAT_FRAME.AddMessage, false, DEFAULT_CHAT_FRAME,
        "|cffb8a0df[RPHelper]|r " .. text)
end
