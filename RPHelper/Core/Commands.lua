RPHelper = RPHelper or {}

local function printHelp()
    print("RPHelper pre-alpha commands:")
    print("/rph help")
    print("/rph on")
    print("/rph off")
    print("/rph status")
    print("/rph spell <ability-key>  (reserved for Forever testing)")
end

function RPHelper.HandleSlashCommand(message)
    local command, rest = string.match(message or "", "^(%S*)%s*(.-)$")
    command = string.lower(command or "")

    if command == "" or command == "help" then
        printHelp()
    elseif command == "on" then
        RPHelperDB.settings.enabled = true
        print("RPHelper enabled.")
    elseif command == "off" then
        RPHelperDB.settings.enabled = false
        print("RPHelper disabled.")
    elseif command == "status" then
        print("RPHelper is " .. (RPHelperDB.settings.enabled and "enabled" or "disabled") .. ".")
    elseif command == "spell" then
        print("RPHelper pre-alpha spell trigger requested: " .. (rest ~= "" and rest or "<missing>"))
    else
        printHelp()
    end
end
