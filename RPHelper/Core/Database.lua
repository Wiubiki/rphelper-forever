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
    if RPHelperDB == nil then RPHelperDB = {} end
    if type(RPHelperDB) ~= "table" then return end
    RPHelperDB.schemaVersion = RPHelperDB.schemaVersion or RPHelper.CURRENT_SCHEMA_VERSION
    if RPHelperDB.settings == nil then RPHelperDB.settings = {} end
    if RPHelperDB.triggers == nil then RPHelperDB.triggers = {} end
    if RPHelperDB.abilities == nil then RPHelperDB.abilities = {} end
    if RPHelperDB.custom == nil then RPHelperDB.custom = {} end
    if RPHelperDB.disabledDefaults == nil then RPHelperDB.disabledDefaults = {} end

    if type(RPHelperDB.settings) == "table" then
        applyMissing(RPHelperDB.settings, RPHelper.Defaults.settings)
    end
    if type(RPHelperDB.triggers) == "table" then
        applyMissing(RPHelperDB.triggers, RPHelper.Defaults.triggers)
    end
    if type(RPHelperDB.abilities) == "table" then
        applyMissing(RPHelperDB.abilities, RPHelper.Defaults.abilities)
    end
end
