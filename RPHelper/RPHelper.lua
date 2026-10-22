RPHelper = RPHelper or {}

local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")

frame:SetScript("OnEvent", function(_, event, ...)
    local addonName = ...
    if event == "ADDON_LOADED" and addonName == "RPHelper" then
        RPHelper.InitializeDatabase()

        SLASH_RPHELPER1 = "/rph"
        SlashCmdList = SlashCmdList or {}
        SlashCmdList.RPHELPER = RPHelper.HandleSlashCommand
        if RPHelper.UI and RPHelper.UI.Initialize then RPHelper.UI.Initialize() end
        RPHelper.Runtime.Initialize(frame)
    elseif event == "PLAYER_REGEN_DISABLED" or event == "PLAYER_REGEN_ENABLED"
        or event == "UNIT_COMBAT" or event == "UNIT_SPELLCAST_SUCCEEDED" then
        RPHelper.Runtime.HandleEvent(event, ...)
    end
end)
