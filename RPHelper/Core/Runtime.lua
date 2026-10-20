RPHelper = RPHelper or {}
RPHelper.Runtime = RPHelper.Runtime or {}

local Runtime = RPHelper.Runtime

Runtime.TriggerConfigKey = {
    entercombat = "enter_combat",
    leavecombat = "leave_combat",
    dodge = "dodge",
    parry = "parry",
    block = "block",
}

Runtime.EventTrigger = {
    PLAYER_REGEN_DISABLED = "entercombat",
    PLAYER_REGEN_ENABLED = "leavecombat",
}

local api = RPHelper.RuntimeAPI
local inCombat = false
local defensiveEventsRegistered = false
local abilityEventsRegistered = false
local defensiveTriggers = { dodge = true, parry = true, block = true }

local lastGlobal, lastObserved
local lastTrigger = {}
local lastAbility = {}
local combatOutputs = 0

Runtime.FrequencyMultipliers = { low = 0.5, normal = 1, high = 2 }

local function field(container, key)
    if type(container) == "table" then return container[key] end
end

local function finite(value)
    return type(value) == "number" and value == value and value > -math.huge and value < math.huge
end

local function valid(value, fallback, name)
    if type(fallback) == "boolean" then return type(value) == "boolean" end
    if type(fallback) == "number" then
        return finite(value) and value >= 0
            and (name ~= "chance" or value <= 1)
            and (name ~= "maxAutomaticOutputsPerCombat" or value % 1 == 0)
    end
    return type(value) == "string" and Runtime.FrequencyMultipliers[value] ~= nil
end

local function setting(name, configKey, abilityClass)
    local section = abilityClass and "abilities" or (configKey and "triggers" or "settings")
    local defaults = RPHelper.Defaults[section]
    local saved = field(RPHelperDB, section)
    if abilityClass then
        defaults = defaults[abilityClass]
        saved = field(saved, abilityClass)
    end
    if configKey then
        defaults = defaults[configKey]
        saved = field(saved, configKey)
    end
    local fallback = defaults[name]
    local value = field(saved, name)
    if valid(value, fallback, name) then return value end
    return fallback
end

local function call(name, ...)
    local fn = field(api, name)
    if type(fn) ~= "function" then return nil end
    local ok, value = pcall(fn, ...)
    if ok then return value end
end

function Runtime.SetAPI(adapter)
    api = adapter or RPHelper.RuntimeAPI
end

local function handleReaction(trigger, abilityClass)
    if not abilityClass and defensiveTriggers[trigger] and not inCombat then return false end
    local key = abilityClass and trigger or Runtime.TriggerConfigKey[trigger]
    if not key or not setting("enabled") or not setting("enabled", key, abilityClass) then return false end
    local activity = call("GetActivity")
    if not RPHelper.Output.IsActivityAllowed(activity, setting("enableInRaids")) then return false end

    local now = call("GetTime")
    if not finite(now) or now < 0 or (lastObserved and now < lastObserved) then return false end
    lastObserved = now
    if lastGlobal and now - lastGlobal < setting("globalCooldown") then return false end
    local previous
    if abilityClass then previous = field(lastAbility[abilityClass], trigger)
    else previous = lastTrigger[trigger] end
    if previous and now - previous < setting("cooldown", key, abilityClass) then return false end
    -- Every automatic output during an encounter shares its quota, including exit.
    -- Out-of-combat attempts still obey probability and cooldowns.
    if inCombat and combatOutputs >= setting("maxAutomaticOutputsPerCombat") then return false end

    local chance = math.min(1, setting("chance", key, abilityClass) * Runtime.FrequencyMultipliers[setting("frequencyPreset")])
    if chance <= 0 then return false end
    if chance < 1 then
        local roll = call("Random")
        if not finite(roll) or roll < 0 or roll >= 1 or roll >= chance then return false end
    end

    local class = abilityClass or call("GetPlayerClass")
    if type(class) ~= "string" or class == "" then return false end
    local race = call("GetPlayerRace")
    if type(race) ~= "string" then race = nil end
    local values = { PLAYER_CLASS = class, PLAYER_RACE = race }
    local options = {
        class = class,
        context = { class = class, values = values, api = api },
        suppressSayInForms = setting("suppressSayInForms"),
        getShapeshiftFormID = function()
            local fn = field(api, "GetShapeshiftFormID")
            if type(fn) ~= "function" then error("form API unavailable") end
            return fn()
        end,
        randomIndex = field(api, "RandomIndex"),
    }
    local candidate
    if abilityClass then
        candidate = RPHelper.ChooseAbilityCandidate(class, trigger, options)
    else
        candidate = RPHelper.ChooseContentCandidate(trigger, race, class, options)
    end
    if not candidate or not RPHelper.Output.Dispatch(candidate, api, activity, setting("enableInRaids")) then
        return false
    end
    lastGlobal = now
    if abilityClass then
        lastAbility[class] = lastAbility[class] or {}
        lastAbility[class][trigger] = now
    else
        lastTrigger[trigger] = now
    end
    if inCombat then combatOutputs = combatOutputs + 1 end
    return true
end

function Runtime.HandleTrigger(trigger)
    return handleReaction(trigger)
end

local function handleAbility(class, ability)
    if type(class) ~= "string" or type(ability) ~= "string" then return false end
    if not field(field(RPHelper.Defaults.abilities, class), ability) then return false end
    if field(field(RPHelper.Ability, class), ability) ~= ability then return false end
    return handleReaction(ability, class)
end

function Runtime.HandleEvent(event, ...)
    if event == "UNIT_SPELLCAST_SUCCEEDED" then
        if not abilityEventsRegistered or not setting("enabled") then return false end
        local unitTarget, castGUID, spellID = ...
        local class = call("GetPlayerClass")
        local ability = call("ClassifySpellcastSucceeded", unitTarget, castGUID, spellID, class)
        if not ability then return false end
        return handleAbility(class, ability)
    end
    if event == "UNIT_COMBAT" then
        if not inCombat or not defensiveEventsRegistered then return false end
        local defensive = call("ClassifyUnitCombat", ...)
        if not defensiveTriggers[defensive] then return false end
        return Runtime.HandleTrigger(defensive)
    end
    local trigger = Runtime.EventTrigger[event]
    if trigger == "entercombat" then
        if inCombat then
            return false
        end
        inCombat = true
        combatOutputs = 0
    elseif trigger == "leavecombat" then
        if not inCombat then
            return false
        end
        -- The exit reaction belongs to the encounter that is ending.
        local dispatched = Runtime.HandleTrigger(trigger)
        inCombat = false
        combatOutputs = 0
        return dispatched
    else
        return false
    end
    return Runtime.HandleTrigger(trigger)
end

function Runtime.Initialize(frame, adapter)
    Runtime.SetAPI(adapter)
    defensiveEventsRegistered = false
    abilityEventsRegistered = false
    lastGlobal, lastObserved = nil, nil
    lastTrigger = {}
    lastAbility = {}
    combatOutputs = 0
    local currentState = call("IsPlayerInCombat")
    inCombat = currentState == true

    if frame == nil or type(frame.RegisterEvent) ~= "function" then
        return false
    end
    frame:RegisterEvent("PLAYER_REGEN_DISABLED")
    frame:RegisterEvent("PLAYER_REGEN_ENABLED")
    defensiveEventsRegistered = call("RegisterDefensiveEvents", frame) == true
    abilityEventsRegistered = call("RegisterAbilityEvents", frame) == true
    return true
end

function Runtime.IsInCombat()
    return inCombat
end
