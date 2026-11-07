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

local function reactionTrace(detail)
    if RPHelper.Diagnostics and RPHelper.Diagnostics.IsEnabled() then
        detail.outcome, detail.eligible = "not_attempted", "not_evaluated"
        detail.selected, detail.emitted = false, false
        return detail
    end
end

function Runtime.SetAPI(adapter)
    api = adapter or RPHelper.RuntimeAPI
end

local function handleReaction(trigger, abilityClass, trace)
    local function reject(reason, activity, now)
        if trace then trace.outcome = reason end
        return false, activity, now
    end
    if not abilityClass and defensiveTriggers[trigger] and not inCombat then return false end
    local key = abilityClass and trigger or Runtime.TriggerConfigKey[trigger]
    if not key then return false end
    local activity = call("GetActivity")
    if not RPHelper.Output.IsActivityAllowed(activity) then return reject("activity_blocked", activity) end

    -- Encounter quota is the first configurable policy gate. Exit reactions are
    -- evaluated while the encounter is still active and therefore share it.
    local quotaEnabled = setting("encounterQuotaEnabled")
    if quotaEnabled and inCombat
        and combatOutputs >= setting("maxAutomaticOutputsPerCombat") then return reject("quota", activity) end

    local priority = setting("priority", key, abilityClass)
    local now = call("GetTime")
    if not finite(now) or now < 0 or (lastObserved and now < lastObserved) then
        return reject("invalid_clock", activity)
    end
    lastObserved = now
    if not priority and lastGlobal and now - lastGlobal < setting("globalCooldown") then
        return reject("cooldown", activity, now)
    end

    if not setting("enabled") then return reject("master_disabled", activity, now) end
    if not setting("enabled", key, abilityClass) then return reject("event_disabled", activity, now) end

    local chance = setting("chance", key, abilityClass)
    if trace then trace.chance = chance end
    if chance <= 0 then return reject("chance_zero", activity, now) end
    if chance < 1 then
        local roll = call("Random")
        if trace and finite(roll) then trace.roll = roll end
        if not finite(roll) or roll < 0 or roll >= 1 or roll >= chance then
            local reason = finite(roll) and roll >= 0 and roll < 1 and "chance" or "invalid_roll"
            return reject(reason, activity, now)
        end
    end

    local class = abilityClass or call("GetPlayerClass")
    if type(class) ~= "string" or class == "" then return reject("class_unavailable", activity, now) end
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
        -- Observe the pool already prepared for this attempt; never prepare a
        -- second pool or draw extra random values merely for diagnostics.
        diagnostics = trace,
    }
    local candidate
    if abilityClass then
        candidate = RPHelper.ChooseAbilityCandidate(class, trigger, options)
    else
        candidate = RPHelper.ChooseContentCandidate(trigger, race, class, options)
    end
    if not candidate then
        return reject(trace and trace.eligible == 0 and "no_eligible_content" or "selection_failed", activity, now)
    end
    if trace then trace.selected = true; trace.outputType = candidate.type end
    local dispatched, output = RPHelper.Output.Dispatch(candidate, api, activity, setting("dungeonSayMode"))
    if trace then
        for name, value in pairs(output) do trace[name] = value end
    end
    if not dispatched then
        return reject("dispatch_failed", activity, now)
    end
    if trace then
        trace.emitted = true -- compatibility field: dispatch, not public delivery
        trace.outcome = output.localDisplayed and (output.fallbackReason and "local_fallback" or "local_displayed")
            or "public_unverified"
    end
    if not priority then lastGlobal = now end
    if quotaEnabled and inCombat then combatOutputs = combatOutputs + 1 end
    return true, activity, now
end

function Runtime.HandleTrigger(trigger, trace)
    return handleReaction(trigger, nil, trace)
end

local function handleAbility(class, ability, trace)
    if type(class) ~= "string" or type(ability) ~= "string" then return false end
    if field(field(RPHelper.Ability, class), ability) ~= ability then
        if trace then trace.outcome = "unknown_ability" end
        return false
    end
    return handleReaction(ability, class, trace)
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
        local trace = reactionTrace(detail)
        if trace then
            -- Only the classifier's inspected ID reaches the optional name API.
            if detail.spellID then trace.spellName = call("GetDiagnosticSpellName", detail.spellID) end
        end
        if not ability then observe(event, "spellcast", detail); return false end
        local dispatched, activity, now = handleAbility(class, ability, trace)
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
        local dispatched, activity, now = Runtime.HandleTrigger(defensive, reactionTrace(detail))
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
        local detail = { trigger = trigger, result = "matched", matched = true }
        local dispatched, activity, now = Runtime.HandleTrigger(trigger, reactionTrace(detail))
        detail.activity, detail.time = activity, now
        observe(event, "combat", detail)
        inCombat = false
        combatOutputs = 0
        return dispatched
    else
        return false
    end
    local detail = { trigger = trigger, result = "matched", matched = true }
    local dispatched, activity, now = Runtime.HandleTrigger(trigger, reactionTrace(detail))
    detail.activity, detail.time = activity, now
    observe(event, "combat", detail)
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

-- Query on demand, including when registration failure means no events arrive.
function Runtime.GetDetectionStatus()
    return {
        abilityEventsRegistered = abilityEventsRegistered,
        defensiveEventsRegistered = defensiveEventsRegistered,
        secretInspectionAvailable = call("HasSecretInspection") == true,
    }
end
