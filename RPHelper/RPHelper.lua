RPHelper = RPHelper or {}

local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")

frame:SetScript("OnEvent", function(_, event, addonName)
    if event == "ADDON_LOADED" and addonName == "RPHelper" then
        RPHelper.InitializeDatabase()

        SLASH_RPHELPER1 = "/rph"
        SlashCmdList.RPHELPER = RPHelper.HandleSlashCommand
    end
end)
