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
local combatOutputs = 0

local function field(container, key)
    if type(container) == "table" then return container[key] end
end

local function finite(value)
    return type(value) == "number" and value == value and value > -math.huge and value < math.huge
end

local function setting(name, configKey, abilityClass)
    if configKey then
        return RPHelper.Configuration.GetEventSetting(abilityClass and "ability" or "trigger",
            abilityClass, configKey, name)
    end
    return RPHelper.Configuration.GetSetting(name)
end

local function call(name, ...)
    local fn = field(api, name)
    if type(fn) ~= "function" then return nil end
    local ok, value, detail = pcall(fn, ...)
    if ok then return value, detail end
end

local function observe(event, category, detail)
    local diagnostics = field(RPHelper, "Diagnostics")
    if type(diagnostics) == "table" and type(diagnostics.Observe) == "function" then
        diagnostics.Observe(event, category, detail)
    end
end

function Runtime.SetAPI(adapter)
    api = adapter or RPHelper.RuntimeAPI
end

local function handleReaction(trigger, abilityClass)
    if not abilityClass and defensiveTriggers[trigger] and not inCombat then return false end
    local key = abilityClass and trigger or Runtime.TriggerConfigKey[trigger]
    if not key then return false end
    local activity = call("GetActivity")
    if not RPHelper.Output.IsActivityAllowed(activity) then return false, activity end

    -- Encounter quota is the first configurable policy gate. Exit reactions are
    -- evaluated while the encounter is still active and therefore share it.
    local quotaEnabled = setting("encounterQuotaEnabled")
    if quotaEnabled and inCombat
        and combatOutputs >= setting("maxAutomaticOutputsPerCombat") then return false, activity end

    local priority = setting("priority", key, abilityClass)
    local now = call("GetTime")
    if not finite(now) or now < 0 or (lastObserved and now < lastObserved) then return false, activity end
    lastObserved = now
    if not priority and lastGlobal and now - lastGlobal < setting("globalCooldown") then
        return false, activity, now
    end

    if not setting("enabled") or not setting("enabled", key, abilityClass) then
        return false, activity, now
    end

    local chance = setting("chance", key, abilityClass)
    if chance <= 0 then return false, activity, now end
    if chance < 1 then
        local roll = call("Random")
        if not finite(roll) or roll < 0 or roll >= 1 or roll >= chance then
            return false, activity, now
        end
    end

    local class = abilityClass or call("GetPlayerClass")
    if type(class) ~= "string" or class == "" then return false, activity, now end
    local race = call("GetPlayerRace")
    if type(race) ~= "string" then race = nil end
    local values = { PLAYER_CLASS = class, PLAYER_RACE = race }
    local options = {
        class = class,
        context = { class = class, values = values, api = api },
        getShapeshiftFormID = function()
            local fn = field(api, "GetShapeshiftFormID")
            if type(fn) ~= "function" then error("form API unavailable") end
            return fn()
        end,
        randomIndex = field(api, "RandomIndex"),
        randomWeight = field(api, "Random"),
    }
    local candidate
    if abilityClass then
        candidate = RPHelper.ChooseAbilityCandidate(class, trigger, options)
    else
        candidate = RPHelper.ChooseContentCandidate(trigger, race, class, options)
    end
    if not candidate or not RPHelper.Output.Dispatch(candidate, api, activity,
        setting("dungeonSayMode")) then
        return false, activity, now
    end
    if not priority then lastGlobal = now end
    if quotaEnabled and inCombat then combatOutputs = combatOutputs + 1 end
    return true, activity, now
end

function Runtime.HandleTrigger(trigger)
    return handleReaction(trigger)
end

local function handleAbility(class, ability)
    if type(class) ~= "string" or type(ability) ~= "string" then return false end
    if field(field(RPHelper.Ability, class), ability) ~= ability then return false end
    return handleReaction(ability, class)
end

function Runtime.HandleEvent(event, ...)
    if event == "UNIT_SPELLCAST_SUCCEEDED" then
        if not abilityEventsRegistered then
            observe(event, "spellcast", { result = "registration_unavailable", matched = false })
            return false
        end
        local unitTarget, castGUID, spellID = ...
        local class = call("GetPlayerClass")
        local ability, detail = call("ClassifySpellcastSucceeded", unitTarget, castGUID, spellID, class)
        detail = detail or { result = "classification_unavailable", matched = false }
        if not ability then observe(event, "spellcast", detail); return false end
        local dispatched, activity, now = handleAbility(class, ability)
        detail.activity, detail.time = activity, now
        observe(event, "spellcast", detail)
        return dispatched
    end
    if event == "UNIT_COMBAT" then
        if not defensiveEventsRegistered then
            observe(event, "defense", { result = "registration_unavailable", matched = false })
            return false
        end
        if not inCombat then
            observe(event, "defense", { result = "outside_combat", matched = false })
            return false
        end
        local defensive, detail = call("ClassifyUnitCombat", ...)
        detail = detail or { result = "classification_unavailable", matched = false }
        if not defensiveTriggers[defensive] then observe(event, "defense", detail); return false end
        local dispatched, activity, now = Runtime.HandleTrigger(defensive)
        detail.activity, detail.time = activity, now
        observe(event, "defense", detail)
        return dispatched
    end
    local trigger = Runtime.EventTrigger[event]
    if trigger == "entercombat" then
        if inCombat then
            observe(event, "combat", { trigger = trigger, result = "duplicate", matched = false })
            return false
        end
        inCombat = true
        combatOutputs = 0
    elseif trigger == "leavecombat" then
        if not inCombat then
            observe(event, "combat", { trigger = trigger, result = "duplicate", matched = false })
            return false
        end
        -- The exit reaction belongs to the encounter that is ending.
        local dispatched, activity, now = Runtime.HandleTrigger(trigger)
        observe(event, "combat", { trigger = trigger, result = "matched", matched = true,
            activity = activity, time = now })
        inCombat = false
        combatOutputs = 0
        return dispatched
    else
        return false
    end
    local dispatched, activity, now = Runtime.HandleTrigger(trigger)
    observe(event, "combat", { trigger = trigger, result = "matched", matched = true,
        activity = activity, time = now })
    return dispatched
end

function Runtime.Initialize(frame, adapter)
    Runtime.SetAPI(adapter)
    local diagnostics = field(RPHelper, "Diagnostics")
    if type(diagnostics) == "table" and type(diagnostics.Initialize) == "function" then
        diagnostics.Initialize()
    end
    defensiveEventsRegistered = false
    abilityEventsRegistered = false
    lastGlobal, lastObserved = nil, nil
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
