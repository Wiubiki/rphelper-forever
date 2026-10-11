RPHelper = RPHelper or {}

local function printHelp()
    print("RPHelper pre-alpha commands:")
    print("/rph help")
    print("/rph on")
    print("/rph off")
    print("/rph status")
    print("/rph spell <ability-key>  (reserved for Forever testing)")
end

local function savedSettings()
    if type(RPHelperDB) == "table" and type(RPHelperDB.settings) == "table" then
        return RPHelperDB.settings
    end
end

function RPHelper.HandleSlashCommand(message)
    local command, rest = string.match(message or "", "^(%S*)%s*(.-)$")
    command = string.lower(command or "")

    if command == "" or command == "help" then
        printHelp()
    elseif command == "on" or command == "off" then
        local settings = savedSettings()
        if not settings then
            print("RPHelper cannot save this setting: SavedVariables root or settings container is invalid.")
            return
        end
        settings.enabled = command == "on"
        print("RPHelper " .. (settings.enabled and "enabled" or "disabled") .. ".")
    elseif command == "status" then
        local settings = savedSettings()
        local enabled = settings and settings.enabled
        if type(enabled) ~= "boolean" then enabled = RPHelper.Defaults.settings.enabled end
        print("RPHelper is " .. (enabled and "enabled" or "disabled") .. ".")
    elseif command == "spell" then
        print("RPHelper pre-alpha spell trigger requested: " .. (rest ~= "" and rest or "<missing>"))
    else
        printHelp()
    end
end
