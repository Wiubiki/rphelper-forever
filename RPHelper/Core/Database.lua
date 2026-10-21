RPHelper = RPHelper or {}

local structuralDefaults = {
    settings = {}, triggers = {}, abilities = {},
    custom = { nextID = 1, entries = {} },
    disabledDefaults = {}, reactionOverrides = {},
}

local function copy(value)
    if type(value) ~= "table" then return value end
    local result = {}
    for key, child in pairs(value) do result[key] = copy(child) end
    return result
end

function RPHelper.InitializeDatabase()
    if RPHelperDB == nil then
        RPHelperDB = { schemaVersion = RPHelper.CURRENT_SCHEMA_VERSION }
        for key, value in pairs(structuralDefaults) do RPHelperDB[key] = copy(value) end
    end
    if type(RPHelperDB) ~= "table" then return false, "invalid_root" end
    if RPHelperDB.schemaVersion ~= RPHelper.CURRENT_SCHEMA_VERSION then
        return false, "unsupported_schema"
    end
    for key, value in pairs(structuralDefaults) do
        if RPHelperDB[key] == nil then RPHelperDB[key] = copy(value) end
    end
    if RPHelper.UserContent then RPHelper.UserContent.Invalidate() end
    return true
end
