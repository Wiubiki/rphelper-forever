RPHelper = RPHelper or {}

local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")

frame:SetScript("OnEvent", function(_, event, addonName)
    if event == "ADDON_LOADED" and addonName == "RPHelper" then
        RPHelper.InitializeDatabase()

        SLASH_RPHELPER1 = "/rph"
        SlashCmdList = SlashCmdList or {}
        SlashCmdList.RPHELPER = RPHelper.HandleSlashCommand
        RPHelper.Runtime.Initialize(frame)
    elseif event == "PLAYER_REGEN_DISABLED" or event == "PLAYER_REGEN_ENABLED" then
        RPHelper.Runtime.HandleEvent(event)
    end
end)
