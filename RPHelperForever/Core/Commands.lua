RPHelper = RPHelper or {}

local function printHelp()
    print("RPHelper prerelease commands:")
    print("/rph  (toggle settings window)")
    print("/rph help")
    print("/rph on")
    print("/rph off")
    print("/rph status")
    print("/rph debug help")
    print("/rph spell <ability-key>  (reserved for Forever testing)")
end

local function printDebugHelp()
    print("RPHelper session diagnostics:")
    print("/rph debug on")
    print("/rph debug off")
    print("/rph debug status")
    print("/rph debug show  (latest 10 records)")
    print("/rph debug clear")
    print("/rph debug help")
end

local function handleDebug(rest)
    local diagnostics = RPHelper.Diagnostics
    if type(diagnostics) ~= "table" then printDebugHelp(); return end
    local subcommand, extra = string.match(rest or "", "^(%S*)%s*(.-)$")
    subcommand = string.lower(subcommand or "")
    if extra ~= "" then printDebugHelp(); return end
    if subcommand == "on" then
        diagnostics.SetEnabled(true)
        print("RPHelper diagnostics enabled for this session.")
    elseif subcommand == "off" then
        diagnostics.SetEnabled(false)
        print("RPHelper diagnostics disabled; captured records retained.")
    elseif subcommand == "status" then
        print("RPHelper diagnostics are " .. (diagnostics.IsEnabled() and "enabled" or "disabled")
            .. "; " .. diagnostics.Count() .. "/" .. diagnostics.Capacity .. " records retained.")
    elseif subcommand == "show" then
        local records = diagnostics.GetRecords(10)
        if #records == 0 then
            print("RPHelper diagnostics have no captured records.")
        else
            print("RPHelper diagnostics (latest " .. #records .. "):")
            for _, record in ipairs(records) do print(diagnostics.Format(record)) end
        end
    elseif subcommand == "clear" then
        diagnostics.Clear()
        print("RPHelper diagnostic records cleared.")
    elseif subcommand == "help" then
        printDebugHelp()
    else
        printDebugHelp()
    end
end

local function savedSettings()
    if type(RPHelperDB) == "table" and type(RPHelperDB.settings) == "table" then
        return RPHelperDB.settings
    end
end

function RPHelper.HandleSlashCommand(message)
    local command, rest = string.match(message or "", "^(%S*)%s*(.-)$")
    command = string.lower(command or "")

    if command == "" then
        if RPHelper.UI and RPHelper.UI.Toggle then RPHelper.UI.Toggle() else printHelp() end
    elseif command == "help" then
        printHelp()
    elseif command == "on" or command == "off" then
        local settings = savedSettings()
        if not settings or not RPHelper.Configuration.SetSetting("enabled", command == "on") then
            print("RPHelper cannot save this setting: SavedVariables root or settings container is invalid.")
            return
        end
        print("RPHelper " .. (RPHelper.Configuration.GetSetting("enabled") and "enabled" or "disabled") .. ".")
    elseif command == "status" then
        local enabled = RPHelper.Configuration.GetSetting("enabled")
        print("RPHelper is " .. (enabled and "enabled" or "disabled") .. ".")
    elseif command == "debug" then
        handleDebug(rest)
    elseif command == "spell" then
        print("RPHelper prerelease spell trigger requested: " .. (rest ~= "" and rest or "<missing>"))
    else
        printHelp()
    end
end
