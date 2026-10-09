RPHelper = RPHelper or {}
RPHelper.DruidForms = RPHelper.DruidForms or {}

local DruidForms = RPHelper.DruidForms

DruidForms.Form = {
    HUMANOID = "HUMANOID",
    CAT = "CAT",
    BEAR = "BEAR",
    DIRE_BEAR = "DIRE_BEAR",
    MOONKIN = "MOONKIN",
    TRAVEL = "TRAVEL",
    AQUATIC = "AQUATIC",
    UNKNOWN = "UNKNOWN",
}

local formByID = {
    [1] = DruidForms.Form.CAT,
    [3] = DruidForms.Form.TRAVEL,
    [4] = DruidForms.Form.AQUATIC,
    [5] = DruidForms.Form.BEAR,
    [8] = DruidForms.Form.DIRE_BEAR,
    [31] = DruidForms.Form.MOONKIN,
    [32] = DruidForms.Form.MOONKIN,
    [33] = DruidForms.Form.MOONKIN,
    [34] = DruidForms.Form.MOONKIN,
    [35] = DruidForms.Form.MOONKIN,
}

local function playerClass(options)
    options = options or {}
    if options.class then
        return options.class
    end
    if options.context and options.context.class then
        return options.context.class
    end
    if type(UnitClass) == "function" then
        local ok, _, classFile = pcall(UnitClass, "player")
        if ok then
            return classFile
        end
    end
    return nil
end

function DruidForms.GetCurrentForm(options)
    options = options or {}
    if options.form then
        return options.form
    end

    local getFormID = options.getShapeshiftFormID or GetShapeshiftFormID
    if type(getFormID) ~= "function" then
        return DruidForms.Form.UNKNOWN
    end

    local ok, formID = pcall(getFormID)
    if not ok then
        return DruidForms.Form.UNKNOWN
    end
    if formID == nil or formID == 0 then
        return DruidForms.Form.HUMANOID
    end
    return formByID[formID] or DruidForms.Form.UNKNOWN
end

function DruidForms.IsShapeshifted(form)
    return form ~= nil and form ~= DruidForms.Form.HUMANOID
end

function DruidForms.ShouldSuppressSay(options)
    options = options or {}
    if playerClass(options) ~= "DRUID" then
        return false
    end

    local enabled = options.suppressSayInForms
    if enabled == nil and RPHelperDB and RPHelperDB.settings then
        enabled = RPHelperDB.settings.suppressSayInForms
    end
    if enabled == nil and RPHelper.Defaults and RPHelper.Defaults.settings then
        enabled = RPHelper.Defaults.settings.suppressSayInForms
    end
    if enabled == nil then
        enabled = true
    end

    return enabled and DruidForms.IsShapeshifted(DruidForms.GetCurrentForm(options))
end
