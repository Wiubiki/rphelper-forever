RPHelper = RPHelper or {}
RPHelper.Runtime = RPHelper.Runtime or {}

local Runtime = RPHelper.Runtime

Runtime.TriggerConfigKey = {
    entercombat = "enter_combat",
    leavecombat = "leave_combat",
}

Runtime.EventTrigger = {
    PLAYER_REGEN_DISABLED = "entercombat",
    PLAYER_REGEN_ENABLED = "leavecombat",
}

local api = RPHelper.RuntimeAPI
local inCombat = false

local function setting(name, fallback)
    if RPHelperDB and RPHelperDB.settings and RPHelperDB.settings[name] ~= nil then
        return RPHelperDB.settings[name]
    end
    if RPHelper.Defaults and RPHelper.Defaults.settings[name] ~= nil then
        return RPHelper.Defaults.settings[name]
    end
    return fallback
end

local function triggerEnabled(trigger)
    local configKey = Runtime.TriggerConfigKey[trigger]
    if not configKey then
        return false
    end
    if RPHelperDB and RPHelperDB.triggers and RPHelperDB.triggers[configKey] then
        return RPHelperDB.triggers[configKey].enabled ~= false
    end
    local defaults = RPHelper.Defaults and RPHelper.Defaults.triggers
    return defaults and defaults[configKey] and defaults[configKey].enabled ~= false
end

function Runtime.SetAPI(adapter)
    api = adapter or RPHelper.RuntimeAPI
end

function Runtime.HandleTrigger(trigger)
    if setting("enabled", true) == false or not triggerEnabled(trigger) then
        return false
    end

    local class = type(api.GetPlayerClass) == "function" and api.GetPlayerClass() or nil
    local race = type(api.GetPlayerRace) == "function" and api.GetPlayerRace() or nil
    local values = { PLAYER_CLASS = class, PLAYER_RACE = race }
    local candidate = RPHelper.ChooseContentCandidate(trigger, race, class, {
        class = class,
        context = { class = class, values = values },
        getShapeshiftFormID = api.GetShapeshiftFormID,
    })
    if not candidate then
        return false
    end
    return RPHelper.Output.Dispatch(candidate, api)
end

function Runtime.HandleEvent(event)
    local trigger = Runtime.EventTrigger[event]
    if trigger == "entercombat" then
        if inCombat then
            return false
        end
        inCombat = true
    elseif trigger == "leavecombat" then
        if not inCombat then
            return false
        end
        inCombat = false
    else
        return false
    end
    return Runtime.HandleTrigger(trigger)
end

function Runtime.Initialize(frame, adapter)
    Runtime.SetAPI(adapter)
    local currentState = type(api.IsPlayerInCombat) == "function" and api.IsPlayerInCombat() or nil
    inCombat = currentState == true

    if frame == nil or type(frame.RegisterEvent) ~= "function" then
        return false
    end
    frame:RegisterEvent("PLAYER_REGEN_DISABLED")
    frame:RegisterEvent("PLAYER_REGEN_ENABLED")
    return true
end

function Runtime.IsInCombat()
    return inCombat
end
