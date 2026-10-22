RPHelper = RPHelper or {}
RPHelper.AboutPage = RPHelper.AboutPage or {}
local AboutPage = RPHelper.AboutPage

local Widgets = RPHelper.UIWidgets
local ADDON_NAME = "RPHelper"
local REPOSITORY_URL = "https://github.com/Wiubiki/rphelper-forever"
local SUPPORT_URL = REPOSITORY_URL .. "/issues"

local function readMetadata(getter, field)
    if type(getter) ~= "function" then return nil end
    local ok, value = pcall(getter, ADDON_NAME, field)
    if ok and value ~= nil and tostring(value) ~= "" then return tostring(value) end
end

local function metadata(field)
    local modern = type(C_AddOns) == "table" and C_AddOns.GetAddOnMetadata
    return readMetadata(modern, field) or readMetadata(GetAddOnMetadata, field)
end

function AboutPage.GetVersion()
    return metadata("Version")
end

function AboutPage.GetRepositoryURL()
    return REPOSITORY_URL
end

function AboutPage.GetSupportURL()
    return SUPPORT_URL
end

function AboutPage.Create(parent, callbacks)
    callbacks = callbacks or {}
    local page = CreateFrame("Frame", nil, parent)
    page:SetAllPoints(parent)

    local heading = Widgets.CreateText(page, "GameFontNormalLarge", "About", 300)
    heading:SetPoint("TOPLEFT", 0, 0)

    local back = Widgets.CreateButton(page, "Back to Main", 130, 24)
    back:SetPoint("TOPRIGHT", 0, 4)
    back:SetScript("OnClick", function()
        if type(callbacks.onBack) == "function" then callbacks.onBack() end
    end)
    page.BackButton = back

    local name = Widgets.CreateText(page, "GameFontNormalLarge", "RPHelper Forever", 620)
    name:SetPoint("TOPLEFT", 0, -42)

    local purpose = Widgets.CreateText(page, "GameFontHighlightSmall",
        "Occasional contextual character reactions that make roleplay more expressive without becoming spammy.", 620)
    purpose:SetPoint("TOPLEFT", 0, -72)
    if purpose.SetHeight then purpose:SetHeight(38) end

    local versionText = Widgets.CreateText(page, "GameFontNormal", "", 620)
    versionText:SetPoint("TOPLEFT", 0, -118)
    page.VersionText = versionText

    local status = Widgets.CreateText(page, "GameFontHighlightSmall",
        "Prerelease for live testing. WoW Forever client verification is still pending; this is not a V1.0-stable claim.", 620)
    status:SetPoint("TOPLEFT", 0, -143)
    if status.SetHeight then status:SetHeight(38) end

    local backgroundHeading = Widgets.CreateText(page, "GameFontNormal", "Project background", 620)
    backgroundHeading:SetPoint("TOPLEFT", 0, -190)
    local background = Widgets.CreateText(page, "GameFontHighlightSmall",
        "A new modern-environment implementation inspired by the original RoleplayingHelper. Wiubiki first adapted that lineage for Turtle WoW and maintains the WoW Forever rewrite; this is not a mechanical port of the legacy code.", 620)
    background:SetPoint("TOPLEFT", 0, -213)
    if background.SetHeight then background:SetHeight(58) end

    local creditsHeading = Widgets.CreateText(page, "GameFontNormal", "Credits and attribution", 620)
    creditsHeading:SetPoint("TOPLEFT", 0, -280)
    local credits = Widgets.CreateText(page, "GameFontHighlightSmall",
        "Original RoleplayingHelper: Talyn and Overlord-Q. Original content attribution: mithyk and Syrsa, with crashinbrn credited for preserved Rogue material. RPHelper 2: Duerma. Turtle WoW adaptation and WoW Forever rewrite: Wiubiki.", 620)
    credits:SetPoint("TOPLEFT", 0, -303)
    if credits.SetHeight then credits:SetHeight(72) end

    local ai = Widgets.CreateText(page, "GameFontHighlightSmall",
        "Development and content review have used AI-assisted tools under human direction and repository review.", 620)
    ai:SetPoint("TOPLEFT", 0, -383)
    if ai.SetHeight then ai:SetHeight(36) end

    local repositoryHeading = Widgets.CreateText(page, "GameFontNormal", "Repository and support", 620)
    repositoryHeading:SetPoint("TOPLEFT", 0, -425)

    local urlBox = Widgets.CreateEditBox(page, 470, 26, false)
    urlBox:SetPoint("TOPLEFT", 0, -450)
    urlBox:SetText(REPOSITORY_URL)
    page.URLBox = urlBox
    local restoringURL = false
    urlBox:SetScript("OnTextChanged", function(self)
        if restoringURL or self:GetText() == REPOSITORY_URL then return end
        restoringURL = true
        self:SetText(REPOSITORY_URL)
        restoringURL = false
    end)
    urlBox:SetScript("OnEditFocusGained", function(self)
        if self.HighlightText then self:HighlightText() end
    end)
    urlBox:SetScript("OnEscapePressed", function(self)
        if self.ClearFocus then self:ClearFocus() end
    end)

    local selectURL = Widgets.CreateButton(page, "Select URL", 120, 24)
    selectURL:SetPoint("LEFT", urlBox, "RIGHT", 12, 0)
    selectURL:SetScript("OnClick", function()
        urlBox:SetText(REPOSITORY_URL)
        if urlBox.SetFocus then urlBox:SetFocus() end
        if urlBox.HighlightText then urlBox:HighlightText() end
    end)
    page.SelectURL = selectURL

    local support = Widgets.CreateText(page, "GameFontHighlightSmall", "Issues and support: " .. SUPPORT_URL, 620)
    support:SetPoint("TOPLEFT", 0, -486)
    page.SupportText = support

    function page:Refresh()
        local version = AboutPage.GetVersion()
        if version then
            versionText:SetText("Version: " .. version)
        else
            versionText:SetText("Version metadata unavailable (prerelease)")
        end
        if urlBox:GetText() ~= REPOSITORY_URL then urlBox:SetText(REPOSITORY_URL) end
    end

    page:Refresh()
    return page
end
