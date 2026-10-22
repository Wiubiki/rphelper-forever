local failures, tests = 0, 0

local function test(name, callback)
    tests = tests + 1
    local ok, message = pcall(callback)
    if not ok then
        failures = failures + 1
        io.stderr:write("FAIL: " .. name .. "\n  " .. tostring(message) .. "\n")
    end
end

local function equal(actual, expected)
    if actual ~= expected then
        error("expected " .. tostring(expected) .. ", got " .. tostring(actual), 2)
    end
end

local function truthy(value)
    if not value then error("expected a truthy value", 2) end
end

local frames = {}
local rejectTemplates = false
local omitSetSize = false
local omitSliderValueStep = false
local omitColorTexture = false
local rejectedTemplateCount = 0

local function newWidget(frameType, name, parent)
    local widget = {
        frameType = frameType,
        name = name,
        parent = parent,
        scripts = {},
        shown = true,
        enabled = true,
        checked = false,
    }

    function widget:SetSize(width, height) self.width, self.height = width, height end
    function widget:SetWidth(width) self.width = width end
    function widget:SetHeight(height) self.height = height end
    function widget:SetPoint(...) self.point = { ... } end
    function widget:SetAllPoints(...) self.allPoints = { ... } end
    function widget:SetMovable(value) self.movable = value end
    function widget:EnableMouse(value) self.mouseEnabled = value end
    function widget:SetClampedToScreen(value) self.clamped = value end
    function widget:RegisterForDrag(...) self.dragButtons = { ... } end
    function widget:RegisterEvent(event)
        self.registered = self.registered or {}
        self.registered[event] = true
    end
    function widget:StartMoving() self.moving = true end
    function widget:StopMovingOrSizing() self.moving = false end
    function widget:SetScript(script, callback) self.scripts[script] = callback end
    function widget:Show() self.shown = true end
    function widget:Hide() self.shown = false end
    function widget:IsShown() return self.shown end
    function widget:Enable() self.enabled = true end
    function widget:Disable() self.enabled = false end
    function widget:IsEnabled() return self.enabled end
    function widget:SetAlpha(value) self.alpha = value end
    function widget:SetText(value) self.text = value end
    function widget:GetText() return self.text end
    function widget:SetTextColor(...) self.textColor = { ... } end
    function widget:SetJustifyH(value) self.justifyH = value end
    function widget:SetNormalFontObject(value) self.normalFont = value end
    function widget:SetHighlightFontObject(value) self.highlightFont = value end
    function widget:SetDisabledFontObject(value) self.disabledFont = value end
    function widget:SetNormalTexture(value) self.normalTexture = value end
    function widget:SetPushedTexture(value) self.pushedTexture = value end
    function widget:SetHighlightTexture(value) self.highlightTexture = value end
    function widget:SetCheckedTexture(value) self.checkedTexture = value end
    function widget:SetDisabledCheckedTexture(value) self.disabledCheckedTexture = value end
    function widget:SetOrientation(value) self.orientation = value end
    function widget:SetMinMaxValues(minimum, maximum) self.minimum, self.maximum = minimum, maximum end
    function widget:SetValueStep(value) self.valueStep = value end
    function widget:SetObeyStepOnDrag(value) self.obeyStep = value end
    function widget:SetThumbTexture(value) self.thumbTexture = value end
    function widget:SetValue(value)
        self.value = value
        if self.scripts.OnValueChanged then self.scripts.OnValueChanged(self, value) end
    end
    function widget:GetValue() return self.value end
    function widget:SetChecked(value) self.checked = value == true end
    function widget:GetChecked() return self.checked end
    function widget:CreateFontString(_, _, font)
        local label = newWidget("FontString", nil, self)
        label.font = font
        return label
    end
    function widget:CreateTexture()
        local texture = newWidget("Texture", nil, self)
        if not omitColorTexture then
            function texture:SetColorTexture(...) self.color = { ... } end
        end
        function texture:SetTexture(...) self.texture = { ... } end
        return texture
    end
    function widget:Click()
        if not self.enabled then return end
        if self.frameType == "CheckButton" then self.checked = not self.checked end
        if self.scripts.OnClick then self.scripts.OnClick(self) end
    end

    if omitSetSize then widget.SetSize = nil end
    if frameType == "Slider" and omitSliderValueStep then widget.SetValueStep = nil end
    table.insert(frames, widget)
    if name then _G[name] = widget end
    return widget
end

UIParent = newWidget("Frame", "UIParent")
UISpecialFrames = {}
GameFontNormal = {}
GameFontHighlight = {}
GameFontDisable = {}
CreateFrame = function(frameType, name, parent, template)
    if template and rejectTemplates then
        rejectedTemplateCount = rejectedTemplateCount + 1
        error("template unavailable: " .. template)
    end
    return newWidget(frameType, name, parent)
end

RPHelper = {}
dofile("RPHelper/Core/Defaults.lua")
dofile("RPHelper/Core/Database.lua")
dofile("RPHelper/Core/Configuration.lua")
dofile("RPHelper/UI/Widgets.lua")
dofile("RPHelper/UI/MainWindow.lua")
dofile("RPHelper/Core/Commands.lua")

local Config = RPHelper.Configuration
local UI = RPHelper.UI
local Widgets = RPHelper.UIWidgets

local function freshDatabase()
    RPHelperDB = nil
    truthy(RPHelper.InitializeDatabase())
end

test("window initializes hidden and opens, closes, and toggles", function()
    freshDatabase()
    local window = UI.Initialize()
    equal(window.name, "RPHelperMainWindow")
    equal(window.width, 720)
    equal(window.height, 650)
    equal(window:IsShown(), false)
    UI.Open()
    equal(window:IsShown(), true)
    UI.GetControl("close"):Click()
    equal(window:IsShown(), false)
    UI.Toggle()
    equal(window:IsShown(), true)
    UI.Toggle()
    equal(window:IsShown(), false)
    equal(UISpecialFrames[1], "RPHelperMainWindow")
end)

test("widget helpers fall back when templates and newer sizing APIs are unavailable", function()
    local before = rejectedTemplateCount
    local made = {}
    rejectTemplates = true
    omitSetSize = true
    omitSliderValueStep = true
    local ok, message = pcall(function()
        made.button = Widgets.CreateButton(UIParent, "Fallback", 90, 22)
        made.close = Widgets.CreateCloseButton(UIParent)
        made.checkBox = Widgets.CreateCheckBox(UIParent, "Fallback check")
        made.slider = Widgets.CreateSlider(UIParent, 275, 0, 20, 1)
    end)
    rejectTemplates = false
    omitSetSize = false
    omitSliderValueStep = false
    if not ok then error(message) end

    truthy(rejectedTemplateCount >= before + 4)
    equal(made.button.width, 90)
    equal(made.button.height, 22)
    equal(made.button.text, "Fallback")
    equal(made.button.FallbackBackground.color[1], 0.16)
    equal(made.close.text, "X")
    truthy(made.close.FallbackBackground)
    equal(made.checkBox.checkedTexture, "Interface\\Buttons\\UI-CheckBox-Check")
    equal(made.slider.width, 275)
    equal(made.slider.height, 16)
    equal(made.slider.minimum, 0)
    equal(made.slider.maximum, 20)
    equal(made.slider.valueStep, nil)
    equal(made.slider.thumbTexture, "Interface\\Buttons\\UI-SliderBar-Button-Horizontal")
    truthy(made.slider.FallbackTrack)
    equal(made.slider.FallbackTrack.color[1], 0.2)
end)

test("approved navigation reaches placeholders and returns from library", function()
    UI.Navigate("library")
    equal(UI.GetCurrentPage(), "library")
    equal(UI.GetPage("library"):IsShown(), true)
    equal(UI.GetPage("main"):IsShown(), false)
    UI.GetControl("libraryBack"):Click()
    equal(UI.GetCurrentPage(), "main")
    UI.Navigate("guide")
    equal(UI.GetCurrentPage(), "guide")
    UI.Navigate("about")
    equal(UI.GetCurrentPage(), "about")
    equal(UI.Navigate("unapproved"), false)
end)

test("effective defaults display without materializing settings", function()
    freshDatabase()
    UI.Navigate("main")
    UI.Refresh()
    equal(UI.GetControl("enabled"):GetChecked(), true)
    equal(UI.GetControl("reactionChance"):GetValue(), 5)
    equal(UI.GetControl("globalCooldown"):GetValue(), 20)
    equal(UI.GetControl("encounterQuotaEnabled"):GetChecked(), false)
    equal(UI.GetControl("maxAutomaticOutputsPerCombat"):GetValue(), 2)
    equal(UI.GetControl("maxAutomaticOutputsPerCombat"):IsEnabled(), false)
    equal(UI.GetControl("dungeonSayBroadcast"):GetChecked(), true)
    equal(UI.GetControl("dungeonSayLocal"):GetChecked(), false)
    equal(next(RPHelperDB.settings), nil)
end)

test("all global setting controls write through configuration", function()
    freshDatabase()
    UI.Refresh()
    UI.GetControl("enabled"):Click()
    UI.GetControl("reactionChance"):SetValue(12)
    UI.GetControl("globalCooldown"):SetValue(45)
    UI.GetControl("encounterQuotaEnabled"):Click()
    equal(UI.GetControl("maxAutomaticOutputsPerCombat"):IsEnabled(), true)
    UI.GetControl("maxAutomaticOutputsPerCombat"):SetValue(7)
    UI.GetControl("dungeonSayLocal"):Click()
    equal(RPHelperDB.settings.enabled, false)
    equal(RPHelperDB.settings.reactionChance, 0.12)
    equal(RPHelperDB.settings.globalCooldown, 45)
    equal(RPHelperDB.settings.encounterQuotaEnabled, true)
    equal(RPHelperDB.settings.maxAutomaticOutputsPerCombat, 7)
    equal(RPHelperDB.settings.dungeonSayMode, "local")
end)

test("refresh and reopen do not add untouched overrides", function()
    freshDatabase()
    UI.Refresh()
    UI.Close()
    UI.Open()
    UI.Close()
    UI.Open()
    equal(next(RPHelperDB.settings), nil)
end)

test("quota maximum follows the quota toggle", function()
    freshDatabase()
    UI.Refresh()
    equal(UI.GetControl("maxAutomaticOutputsPerCombat"):IsEnabled(), false)
    UI.GetControl("encounterQuotaEnabled"):Click()
    equal(UI.GetControl("maxAutomaticOutputsPerCombat"):IsEnabled(), true)
    UI.GetControl("encounterQuotaEnabled"):Click()
    equal(UI.GetControl("maxAutomaticOutputsPerCombat"):IsEnabled(), false)
    equal(Config.GetSetting("maxAutomaticOutputsPerCombat"), 2)
end)

test("switching character databases refreshes isolated values", function()
    freshDatabase()
    truthy(Config.SetSetting("reactionChance", 0.09))
    truthy(Config.SetSetting("dungeonSayMode", "local"))
    local first = RPHelperDB

    freshDatabase()
    local second = RPHelperDB
    UI.Refresh()
    equal(UI.GetControl("reactionChance"):GetValue(), 5)
    equal(UI.GetControl("dungeonSayBroadcast"):GetChecked(), true)

    RPHelperDB = first
    UI.Refresh()
    equal(UI.GetControl("reactionChance"):GetValue(), 9)
    equal(UI.GetControl("dungeonSayLocal"):GetChecked(), true)
    UI.GetControl("globalCooldown"):SetValue(60)
    equal(first.settings.globalCooldown, 60)
    equal(second.settings.globalCooldown, nil)
end)

test("saved choices survive UI module reload and reopen", function()
    freshDatabase()
    truthy(Config.SetSetting("globalCooldown", 80))
    truthy(Config.SetSetting("enabled", false))

    RPHelper.UI = nil
    dofile("RPHelper/UI/MainWindow.lua")
    UI = RPHelper.UI
    UI.Initialize()
    UI.Open()
    equal(UI.GetControl("globalCooldown"):GetValue(), 80)
    equal(UI.GetControl("enabled"):GetChecked(), false)
end)

test("window background uses the older SetTexture color fallback", function()
    freshDatabase()
    omitColorTexture = true
    RPHelper.UI = nil
    local ok, message = pcall(function()
        dofile("RPHelper/UI/MainWindow.lua")
        RPHelper.UI.Initialize()
    end)
    omitColorTexture = false
    if not ok then error(message) end
    UI = RPHelper.UI

    local background = UI.GetWindow().Background
    truthy(background)
    equal(background.color, nil)
    equal(background.texture[1], 0.035)
    equal(background.texture[2], 0.035)
    equal(background.texture[3], 0.045)
    equal(background.texture[4], 0.96)
end)

test("malformed persistence displays defaults and disables writes", function()
    local malformed = { schemaVersion = 2, settings = false, future = "keep" }
    RPHelperDB = malformed
    UI.Refresh()
    equal(UI.GetControl("reactionChance"):GetValue(), 5)
    equal(UI.GetControl("enabled"):GetChecked(), true)
    equal(UI.GetControl("enabled"):IsEnabled(), false)
    equal(UI.GetControl("reactionChance"):IsEnabled(), false)
    UI.GetControl("enabled"):Click()
    equal(RPHelperDB, malformed)
    equal(malformed.settings, false)
    equal(malformed.future, "keep")

    RPHelperDB = "broken root"
    UI.Refresh()
    equal(UI.GetControl("globalCooldown"):GetValue(), 20)
    equal(UI.GetControl("dungeonSayBroadcast"):GetChecked(), true)
    equal(RPHelperDB, "broken root")
end)

test("rejected setter writes roll the display back", function()
    freshDatabase()
    UI.Refresh()
    local original = Config.SetSetting
    Config.SetSetting = function(name, value)
        if name == "reactionChance" then return false, "injected_failure" end
        return original(name, value)
    end
    UI.GetControl("reactionChance"):SetValue(17)
    Config.SetSetting = original
    equal(UI.GetControl("reactionChance"):GetValue(), 5)
    equal(RPHelperDB.settings.reactionChance, nil)
end)

test("empty slash command toggles UI while existing help remains available", function()
    freshDatabase()
    UI.Close()
    RPHelper.HandleSlashCommand("")
    equal(UI.GetWindow():IsShown(), true)
    RPHelper.HandleSlashCommand("")
    equal(UI.GetWindow():IsShown(), false)

    local oldPrint, messages = print, {}
    print = function(message) table.insert(messages, message) end
    RPHelper.HandleSlashCommand("help")
    print = oldPrint
    truthy(#messages > 1)
    equal(messages[2], "/rph  (toggle settings window)")
end)

test("addon startup initializes the UI and preserves runtime initialization", function()
    freshDatabase()
    local initializedFrame
    RPHelper.Runtime = {
        Initialize = function(eventFrame)
            initializedFrame = eventFrame
            return true
        end,
    }
    SlashCmdList = {}
    local count = #frames
    dofile("RPHelper/RPHelper.lua")
    local eventFrame = frames[count + 1]
    truthy(eventFrame.registered.ADDON_LOADED)
    eventFrame.scripts.OnEvent(eventFrame, "ADDON_LOADED", "RPHelper")
    equal(initializedFrame, eventFrame)
    equal(UI.GetWindow():IsShown(), false)
    equal(SLASH_RPHELPER1, "/rph")
    equal(SlashCmdList.RPHELPER, RPHelper.HandleSlashCommand)
end)

if failures > 0 then
    io.stderr:write(tostring(failures) .. " of " .. tostring(tests) .. " UI tests failed\n")
    os.exit(1)
end

print(tostring(tests) .. " UI tests passed")
