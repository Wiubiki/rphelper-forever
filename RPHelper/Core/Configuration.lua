RPHelper = RPHelper or {}
RPHelper.Configuration = RPHelper.Configuration or {}
local Config = RPHelper.Configuration

local validators = {
    enabled = function(v) return type(v) == "boolean" end,
    reactionChance = function(v) return type(v) == "number" and v == v and v >= 0 and v <= 0.20 end,
    globalCooldown = function(v) return type(v) == "number" and v == v and v >= 5 and v <= 120 and v % 1 == 0 end,
    encounterQuotaEnabled = function(v) return type(v) == "boolean" end,
    maxAutomaticOutputsPerCombat = function(v) return type(v) == "number" and v >= 1 and v <= 10 and v % 1 == 0 end,
    dungeonSayMode = function(v) return v == "broadcast" or v == "local" end,
    chance = function(v) return type(v) == "number" and v == v and v >= 0 and v <= 1 end,
    priority = function(v) return type(v) == "boolean" end,
    weight = function(v) return type(v) == "number" and v >= 1 and v % 1 == 0 end,
}

local function root()
    if type(RPHelperDB) == "table" and RPHelperDB.schemaVersion == RPHelper.CURRENT_SCHEMA_VERSION then return RPHelperDB end
end
local function valid(name, value)
    return validators[name] and validators[name](value) == true
end
local function child(parent, key, create)
    if type(parent) ~= "table" then return nil end
    if parent[key] == nil and create then parent[key] = {} end
    return type(parent[key]) == "table" and parent[key] or nil
end
local function prune(parent, key)
    if type(parent) == "table" and type(parent[key]) == "table" and next(parent[key]) == nil then parent[key] = nil end
end
local function write(container, name, value)
    if not container then return false, "invalid_container" end
    if not valid(name, value) then return false, "invalid_value" end
    container[name] = value
    return true
end

function Config.GetSetting(name)
    local fallback = RPHelper.Defaults.settings[name]
    if fallback == nil then return nil end
    local db = root()
    local value = db and type(db.settings) == "table" and db.settings[name]
    if valid(name, value) then return value end
    return fallback
end
function Config.SetSetting(name, value)
    if RPHelper.Defaults.settings[name] == nil then return false, "unknown_setting" end
    local db = root()
    return write(db and type(db.settings) == "table" and db.settings, name, value)
end
function Config.ResetSetting(name)
    if RPHelper.Defaults.settings[name] == nil then return false, "unknown_setting" end
    local db = root()
    if not db or type(db.settings) ~= "table" then return false, "invalid_container" end
    db.settings[name] = nil
    return true
end

local function eventRecord(layer, owner, event, create)
    local db = root()
    if not db then return nil end
    if layer == "trigger" then return child(db.triggers, event, create) end
    if layer == "ability" then return child(child(db.abilities, owner, create), event, create) end
end
function Config.GetEventSetting(layer, owner, event, name)
    if name ~= "enabled" and name ~= "chance" and name ~= "priority" then return nil end
    local record = eventRecord(layer, owner, event, false)
    local value = record and record[name]
    if valid(name, value) then return value end
    return name == "chance" and Config.GetSetting("reactionChance") or RPHelper.Defaults.event[name]
end
function Config.SetEventSetting(layer, owner, event, name, value)
    if name ~= "enabled" and name ~= "chance" and name ~= "priority" then return false, "unknown_setting" end
    if not valid(name, value) then return false, "invalid_value" end
    return write(eventRecord(layer, owner, event, true), name, value)
end
function Config.ResetEventSetting(layer, owner, event, name)
    local record = eventRecord(layer, owner, event, false)
    if not record then return false, "invalid_container" end
    record[name] = nil
    local db = root()
    if layer == "trigger" then prune(db.triggers, event)
    elseif layer == "ability" then
        local ownerTable = child(db.abilities, owner, false)
        prune(ownerTable, event); prune(db.abilities, owner)
    end
    return true
end

function Config.IsDefaultEnabled(id)
    local db = root()
    return not (db and type(db.disabledDefaults) == "table" and db.disabledDefaults[id] == true)
end
function Config.SetDefaultEnabled(id, enabled)
    if type(id) ~= "string" or not string.match(id, "^default:") then return false, "invalid_id" end
    if type(enabled) ~= "boolean" then return false, "invalid_enabled" end
    local db = root()
    if not db or type(db.disabledDefaults) ~= "table" then return false, "invalid_container" end
    if enabled then db.disabledDefaults[id] = nil else db.disabledDefaults[id] = true end
    return true
end
function Config.GetDefaultWeight(id)
    local db = root()
    local record = db and type(db.reactionOverrides) == "table" and db.reactionOverrides[id]
    local value = type(record) == "table" and record.weight
    return valid("weight", value) and value or RPHelper.Defaults.reaction.weight
end
function Config.SetDefaultWeight(id, weight)
    if type(id) ~= "string" or not string.match(id, "^default:") then return false, "invalid_id" end
    if not valid("weight", weight) then return false, "invalid_value" end
    local db = root()
    return write(db and child(db.reactionOverrides, id, true), "weight", weight)
end
function Config.ResetDefaultWeight(id)
    local db = root()
    if not db or type(db.reactionOverrides) ~= "table" then return false, "invalid_container" end
    local record = db.reactionOverrides[id]
    if type(record) == "table" then record.weight = nil; prune(db.reactionOverrides, id) end
    return true
end
function Config.IsPositiveInteger(value) return valid("weight", value) end
