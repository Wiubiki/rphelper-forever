RPHelper = RPHelper or {}

local function copyTable(value)
    if type(value) ~= "table" then
        return value
    end

    local result = {}
    for key, child in pairs(value) do
        result[key] = copyTable(child)
    end
    return result
end

local function applyMissing(target, defaults)
    for key, value in pairs(defaults) do
        if target[key] == nil then
            target[key] = copyTable(value)
        elseif type(value) == "table" and type(target[key]) == "table" then
            applyMissing(target[key], value)
        end
    end
end

function RPHelper.InitializeDatabase()
    RPHelperDB = RPHelperDB or {}
    RPHelperDB.schemaVersion = RPHelperDB.schemaVersion or RPHelper.CURRENT_SCHEMA_VERSION
    RPHelperDB.settings = RPHelperDB.settings or {}
    RPHelperDB.triggers = RPHelperDB.triggers or {}
    RPHelperDB.custom = RPHelperDB.custom or {}
    RPHelperDB.disabledDefaults = RPHelperDB.disabledDefaults or {}

    applyMissing(RPHelperDB.settings, RPHelper.Defaults.settings)
    applyMissing(RPHelperDB.triggers, RPHelper.Defaults.triggers)
end
