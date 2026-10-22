RPHelper = RPHelper or {}
RPHelper.UI = RPHelper.UI or {}
local UI = RPHelper.UI
local Config = RPHelper.Configuration
local Widgets = RPHelper.UIWidgets
local LibraryPage = RPHelper.LibraryPage

local WINDOW_WIDTH = 720
local WINDOW_HEIGHT = 650
local CONTENT_WIDTH = 650

local pages = {}
local navigation = {}
local controls = {}
local frame
local statusText
local currentPage = "main"
local refreshing = false

local function createText(parent, font, text, width)
    return Widgets.CreateText(parent, font, text, width)
end

local function setEnabled(control, enabled)
    Widgets.SetEnabled(control, enabled)
    if control.Label and control.Label.SetTextColor then
        if enabled then control.Label:SetTextColor(1, 0.82, 0)
        else control.Label:SetTextColor(0.5, 0.5, 0.5) end
    end
end

local function setStatus(message, isError)
    statusText:SetText(message or "")
    if statusText.SetTextColor then
        if isError then statusText:SetTextColor(1, 0.25, 0.25)
        else statusText:SetTextColor(0.7, 0.7, 0.7) end
    end
end

local function saveSetting(name, value)
    if Config.GetSetting(name) == value then
        UI.Refresh()
        return true
    end

    local ok = Config.SetSetting(name, value)
    UI.Refresh()
    if not ok then
        setStatus("That change could not be saved. The current effective value has been restored.", true)
        return false
    end
    return true
end

local function addHeading(parent, text, y)
    local heading = createText(parent, "GameFontNormalLarge", text, CONTENT_WIDTH)
    heading:SetPoint("TOPLEFT", 0, y)
    return heading
end

local function addDescription(parent, text, y)
    local description = createText(parent, "GameFontHighlightSmall", text, CONTENT_WIDTH)
    description:SetPoint("TOPLEFT", 0, y)
    return description
end

local function addSlider(parent, setting, y, minimum, maximum, suffix, toSaved, fromSaved)
    local label = createText(parent, "GameFontNormal", "", 300)
    label:SetPoint("TOPLEFT", 0, y)

    local slider = Widgets.CreateSlider(parent, 390, minimum, maximum, 1)
    slider:SetPoint("TOPLEFT", 8, y - 35)
    slider.ValueLabel = label
    slider.Suffix = suffix
    slider.ToSaved = toSaved or function(value) return value end
    slider.FromSaved = fromSaved or function(value) return value end
    controls[setting] = slider

    slider:SetScript("OnValueChanged", function(self, value)
        local integer = math.floor((tonumber(value) or minimum) + 0.5)
        self.ValueLabel:SetText(self.DisplayName .. ": " .. integer .. self.Suffix)
        if refreshing then return end
        saveSetting(setting, self.ToSaved(integer))
    end)
    return slider
end

local function addCheckBox(parent, setting, label, y)
    local checkBox = Widgets.CreateCheckBox(parent, label)
    checkBox:SetPoint("TOPLEFT", -4, y)
    controls[setting] = checkBox
    checkBox:SetScript("OnClick", function(self)
        if refreshing then return end
        saveSetting(setting, self:GetChecked() == true)
    end)
    return checkBox
end

local function createMainPage(parent)
    local page = CreateFrame("Frame", nil, parent)
    page:SetAllPoints(parent)

    addHeading(page, "Global Settings", 0)
    addCheckBox(page, "enabled", "Enable RPHelper", -29)

    local chance = addSlider(page, "reactionChance", -66, 0, 20, "%",
        function(value) return value / 100 end,
        function(value) return value * 100 end)
    chance.DisplayName = "Reaction chance"
    addDescription(page,
        "Baseline chance for events without their own event-level chance.", -84)

    local cooldown = addSlider(page, "globalCooldown", -139, 5, 120, " seconds")
    cooldown.DisplayName = "Cooldown"
    addDescription(page,
        "The only configurable cooldown; successful non-priority reactions start it.", -157)

    addCheckBox(page, "encounterQuotaEnabled", "Encounter quota", -214)
    local maximum = addSlider(page, "maxAutomaticOutputsPerCombat", -250, 1, 10, "")
    maximum.DisplayName = "Maximum reactions per encounter"

    addHeading(page, "Reaction Output", -320)
    addDescription(page, "Say reactions in 5-player instances:", -348)

    local broadcast = Widgets.CreateCheckBox(page, "Broadcast in /say")
    broadcast:SetPoint("TOPLEFT", -4, -365)
    controls.dungeonSayBroadcast = broadcast
    broadcast:SetScript("OnClick", function()
        if refreshing then return end
        saveSetting("dungeonSayMode", "broadcast")
    end)

    local localOnly = Widgets.CreateCheckBox(page, "Local display only")
    localOnly:SetPoint("TOPLEFT", 205, -365)
    controls.dungeonSayLocal = localOnly
    localOnly:SetScript("OnClick", function()
        if refreshing then return end
        saveSetting("dungeonSayMode", "local")
    end)

    local raid = createText(page, "GameFontNormal", "Raid-safe behaviour", CONTENT_WIDTH)
    raid:SetPoint("TOPLEFT", 0, -406)
    addDescription(page, "All automatic reactions are disabled while in a raid.", -425)

    local druid = createText(page, "GameFontNormal", "Druid form behaviour", CONTENT_WIDTH)
    druid:SetPoint("TOPLEFT", 0, -454)
    addDescription(page,
        "Speech reactions are suppressed while shapeshifted. Emotes remain available.", -473)

    local library = Widgets.CreateButton(page, "Open Character Library", 210, 26)
    library:SetPoint("TOPLEFT", 0, -512)
    library:SetScript("OnClick", function() UI.Navigate("library") end)
    controls.openLibrary = library
    local libraryNote = createText(page, "GameFontHighlightSmall",
        "Browse Generic, Race, and Class reactions for this character.", 420)
    libraryNote:SetPoint("LEFT", library, "RIGHT", 12, 0)

    return page
end

local function createPlaceholder(parent, title, message, withBack)
    local page = CreateFrame("Frame", nil, parent)
    page:SetAllPoints(parent)
    addHeading(page, title, 0)
    addDescription(page, message, -38)
    if withBack then
        local back = Widgets.CreateButton(page, "Back to Main", 140, 26)
        back:SetPoint("TOPLEFT", 0, -82)
        back:SetScript("OnClick", function() UI.Navigate("main") end)
        controls.libraryBack = back
    end
    return page
end

local function createTab(parent, name, text, x)
    local button = Widgets.CreateButton(parent, text, 110, 26)
    button:SetPoint("TOPLEFT", x, -48)
    button:SetScript("OnClick", function() UI.Navigate(name) end)
    navigation[name] = button
end

local function createWindow()
    frame = CreateFrame("Frame", "RPHelperMainWindow", UIParent)
    Widgets.SetSize(frame, WINDOW_WIDTH, WINDOW_HEIGHT)
    frame:SetPoint("CENTER")
    frame:SetMovable(true)
    frame:EnableMouse(true)
    if frame.SetClampedToScreen then frame:SetClampedToScreen(true) end
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", function(self) self:StartMoving() end)
    frame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)

    if frame.CreateTexture then
        local background = frame:CreateTexture(nil, "BACKGROUND")
        background:SetAllPoints(frame)
        Widgets.SetSolidColor(background, 0.035, 0.035, 0.045, 0.96)
        frame.Background = background
    end

    local title = createText(frame, "GameFontNormalLarge", "RPHelper Forever", 560)
    title:SetPoint("TOPLEFT", 22, -18)

    local close = Widgets.CreateCloseButton(frame)
    close:SetPoint("TOPRIGHT", -10, -10)
    close:SetScript("OnClick", function() UI.Close() end)
    controls.close = close

    createTab(frame, "main", "Main", 20)
    createTab(frame, "guide", "Guide", 135)
    createTab(frame, "about", "About", 250)

    local content = CreateFrame("Frame", nil, frame)
    content:SetPoint("TOPLEFT", 35, -92)
    content:SetPoint("BOTTOMRIGHT", -35, 28)

    pages.main = createMainPage(content)
    pages.library = LibraryPage.Create(content, {
        onBack = function() UI.Navigate("main") end,
    })
    controls.libraryBack = pages.library.BackButton
    pages.guide = createPlaceholder(content, "Guide",
        "The in-game guide is planned for a later UI milestone.", false)
    pages.about = createPlaceholder(content, "About",
        "Credits, links, and release information are planned for a later UI milestone.", false)

    statusText = createText(frame, "GameFontHighlightSmall", "", CONTENT_WIDTH)
    statusText:SetPoint("BOTTOMLEFT", 35, 9)

    frame:Hide()
    UISpecialFrames = UISpecialFrames or {}
    local present = false
    for _, name in ipairs(UISpecialFrames) do
        if name == "RPHelperMainWindow" then present = true end
    end
    if not present then table.insert(UISpecialFrames, "RPHelperMainWindow") end
end

local function ensureWindow()
    if not frame then createWindow() end
    return frame
end

function UI.Refresh()
    ensureWindow()
    refreshing = true

    controls.enabled:SetChecked(Config.GetSetting("enabled") == true)

    for setting, control in pairs({
        reactionChance = controls.reactionChance,
        globalCooldown = controls.globalCooldown,
        maxAutomaticOutputsPerCombat = controls.maxAutomaticOutputsPerCombat,
    }) do
        local value = control.FromSaved(Config.GetSetting(setting))
        control:SetValue(value)
        local integer = math.floor(value + 0.5)
        control.ValueLabel:SetText(control.DisplayName .. ": " .. integer .. control.Suffix)
    end

    local quotaEnabled = Config.GetSetting("encounterQuotaEnabled") == true
    controls.encounterQuotaEnabled:SetChecked(quotaEnabled)

    local mode = Config.GetSetting("dungeonSayMode")
    controls.dungeonSayBroadcast:SetChecked(mode == "broadcast")
    controls.dungeonSayLocal:SetChecked(mode == "local")

    local writable = Config.CanWriteSettings()
    setEnabled(controls.enabled, writable)
    setEnabled(controls.reactionChance, writable)
    setEnabled(controls.globalCooldown, writable)
    setEnabled(controls.encounterQuotaEnabled, writable)
    setEnabled(controls.maxAutomaticOutputsPerCombat, writable and quotaEnabled)
    setEnabled(controls.dungeonSayBroadcast, writable)
    setEnabled(controls.dungeonSayLocal, writable)

    refreshing = false
    if writable then
        setStatus("")
    else
        setStatus("Settings cannot be saved because this character's SavedVariables container is unavailable. Existing data was left unchanged.", true)
    end
end

function UI.Navigate(destination)
    ensureWindow()
    if not pages[destination] then return false end
    currentPage = destination
    for name, page in pairs(pages) do
        if name == destination then page:Show() else page:Hide() end
    end
    for name, button in pairs(navigation) do
        setEnabled(button, name ~= destination)
    end
    if destination == "main" then
        UI.Refresh()
    elseif destination == "library" then
        pages.library:RefreshLibrary()
    end
    return true
end

function UI.Initialize()
    ensureWindow()
    UI.Navigate("main")
    UI.Refresh()
    frame:Hide()
    return frame
end

function UI.Open(destination)
    ensureWindow()
    if destination then UI.Navigate(destination) end
    UI.Refresh()
    if currentPage == "library" then pages.library:RefreshLibrary() end
    frame:Show()
end

function UI.Close()
    if frame then frame:Hide() end
end

function UI.Toggle()
    ensureWindow()
    if frame:IsShown() then UI.Close() else UI.Open() end
end

function UI.GetWindow() return frame end
function UI.GetControl(name) return controls[name] end
function UI.GetCurrentPage() return currentPage end
function UI.GetPage(name) return pages[name] end
function UI.GetLibraryPage() return pages.library end
