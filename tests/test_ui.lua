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
    function widget:SetJustifyV(value) self.justifyV = value end
    function widget:SetAutoFocus(value) self.autoFocus = value end
    function widget:SetMultiLine(value) self.multiLine = value end
    function widget:SetFontObject(value) self.fontObject = value end
    function widget:SetTextInsets(...) self.textInsets = { ... } end
    function widget:ClearFocus() self.focusCleared = true end
    function widget:SetFocus() self.focused = true end
    function widget:HighlightText() self.highlighted = true end
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
UnitClass = function() return "Druid", "DRUID" end
UnitRace = function() return "Tauren", "TAUREN" end
GetShapeshiftFormID = function() return 0 end
C_AddOns = {
    GetAddOnMetadata = function(addon, field)
        if addon == "RPHelper" and field == "Version" then return "0.9.0-prerelease" end
    end,
}
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
dofile("RPHelper/Core/KeywordResolvers.lua")
dofile("RPHelper/Core/DruidForms.lua")
dofile("RPHelper/Core/ContentEngine.lua")
dofile("RPHelper/Core/Content.lua")
dofile("RPHelper/Core/UserContent.lua")
dofile("RPHelper/Core/RuntimeAPI.lua")
dofile("RPHelper/Core/Runtime.lua")
dofile("RPHelper/UI/Widgets.lua")
dofile("RPHelper/UI/LibraryData.lua")
dofile("RPHelper/UI/LibraryEditorData.lua")
dofile("RPHelper/UI/LibraryPage.lua")
dofile("RPHelper/UI/LibraryEditorPage.lua")
dofile("RPHelper/UI/GuidePage.lua")
dofile("RPHelper/UI/AboutPage.lua")

local longReaction = "This deliberately long authored reaction remains intact in the detail view so the player can read every part of its meaning, including the ending that would otherwise disappear from a short list row. "
    .. "The final words remain visible through bounded detail pagination."
for index = 1, 7 do
    RPHelper.RegisterGeneric("library_event", {
        id = string.format("default:test:generic:%04d", index),
        type = index == 2 and "emote" or "say",
        text = index == 1 and longReaction or (index == 2 and "WAVE" or "Generic reaction " .. index),
    })
end
RPHelper.RegisterGeneric("dodge", { id = "default:test:generic:dodge", type = "say", text = "Mock dodge." })
RPHelper.RegisterGeneric("entercombat",
    { id = "default:test:generic:entercombat", type = "say", text = "Generic combat entry." })
RPHelper.RegisterRace("TAUREN", "library_event",
    { id = "default:test:race:tauren", type = "customemote", text = "stamps a hoof." })
RPHelper.RegisterRace("TAUREN", "entercombat",
    { id = "default:test:race:entercombat", type = "say", text = "Tauren combat entry." })
RPHelper.RegisterRace("ORC", "library_event",
    { id = "default:test:race:orc", type = "say", text = "Unrelated orc reaction." })
RPHelper.RegisterClass("DRUID", "library_event",
    { id = "default:test:class:druid", type = "say", text = "Druid reaction." })
RPHelper.RegisterClass("DRUID", "entercombat",
    { id = "default:test:class:entercombat", type = "say", text = "Druid combat entry." })
RPHelper.RegisterClass("WARRIOR", "library_event",
    { id = "default:test:class:warrior", type = "say", text = "Unrelated warrior reaction." })
RPHelper.RegisterDruidForm("CAT", "library_event",
    { id = "default:test:form:cat", type = "customemote", text = "flicks its tail." })
RPHelper.RegisterDruidForm("CAT", "entercombat",
    { id = "default:test:form:entercombat", type = "customemote", text = "bares its claws." })
RPHelper.RegisterAbility("PALADIN", "FLASH_OF_LIGHT", {
    id = "default:test:ability:flash_of_light",
    type = "say",
    text = "Light answers.",
})
for index = 1, 11 do
    local ability = string.format("LIBRARY_ABILITY_%02d", index)
    RPHelper.RegisterAbility("DRUID", ability, {
        id = string.format("default:test:ability:%04d", index),
        type = "say",
        text = "Ability reaction " .. index,
    })
end

dofile("RPHelper/UI/MainWindow.lua")
dofile("RPHelper/Core/Commands.lua")

local Config = RPHelper.Configuration
local UI = RPHelper.UI
local Widgets = RPHelper.UIWidgets
local LibraryData = RPHelper.LibraryData
local EditorData = RPHelper.LibraryEditorData
local UserContent = RPHelper.UserContent

local function freshDatabase()
    RPHelperDB = nil
    truthy(RPHelper.InitializeDatabase())
end

local function findReaction(group, id)
    if not group then return nil end
    for _, reaction in ipairs(group.reactions) do if reaction.id == id then return reaction end end
end

local function findGroup(model, id)
    return LibraryData.FindGroup(model, id)
end

local function findVisibleRow(page, id)
    for _, row in ipairs(page.ReactionRows) do
        if row.Reaction and row.Reaction.id == id then return row end
    end
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
        made.editBox = Widgets.CreateEditBox(UIParent, 300, 90, true)
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
    equal(made.editBox.width, 300)
    equal(made.editBox.height, 90)
    equal(made.editBox.multiLine, true)
    equal(made.editBox.autoFocus, false)
    truthy(made.editBox.FallbackBackground)
end)

test("approved navigation reaches implemented pages and returns to Main", function()
    UI.Navigate("library")
    equal(UI.GetCurrentPage(), "library")
    equal(UI.GetPage("library"):IsShown(), true)
    equal(UI.GetPage("main"):IsShown(), false)
    UI.GetControl("libraryBack"):Click()
    equal(UI.GetCurrentPage(), "main")
    UI.Navigate("guide")
    equal(UI.GetCurrentPage(), "guide")
    UI.GetPage("guide").BackButton:Click()
    equal(UI.GetCurrentPage(), "main")
    UI.Navigate("about")
    equal(UI.GetCurrentPage(), "about")
    UI.GetPage("about").BackButton:Click()
    equal(UI.GetCurrentPage(), "main")
    equal(UI.Navigate("unapproved"), false)
end)

test("Guide renders every bounded section and paginates long content", function()
    UI.Navigate("guide")
    local page = UI.GetPage("guide")
    equal(page:GetSectionCount(), 7)
    equal(page.Body.width, 450)
    equal(page.Body.height, 380)
    local renderedPages = 0
    for section = 1, page:GetSectionCount() do
        page.SectionButtons[section]:Click()
        equal(page:GetCurrentSection(), section)
        equal(page:GetCurrentContentPage(), 1)
        truthy(page.SectionTitle:GetText() ~= "")
        local pageCount = page:GetCurrentPageCount()
        truthy(pageCount >= 2)
        for contentPage = 1, pageCount do
            equal(page:GetCurrentContentPage(), contentPage)
            local text = page.Body:GetText()
            truthy(type(text) == "string" and text ~= "")
            truthy(#text < 1300)
            renderedPages = renderedPages + 1
            if contentPage < pageCount then page.Next:Click() end
        end
        equal(page.Next:IsEnabled(), false)
        if pageCount > 1 then
            page.Previous:Click()
            equal(page:GetCurrentContentPage(), pageCount - 1)
        end
    end
    truthy(renderedPages > page:GetSectionCount())
    page.BackButton:Click()
    equal(UI.GetCurrentPage(), "main")
end)

test("About uses metadata fallbacks and keeps external URLs selectable only", function()
    local modern, legacy = C_AddOns, GetAddOnMetadata
    local page = UI.GetPage("about")

    UI.Navigate("about")
    equal(page.VersionText:GetText(), "Version: 0.9.0-prerelease")
    equal(page.URLBox:GetText(), "https://github.com/Wiubiki/rphelper-forever")
    truthy(string.find(page.SupportText:GetText(), "/issues", 1, true))

    C_AddOns = {}
    GetAddOnMetadata = function(addon, field)
        if addon == "RPHelper" and field == "Version" then return "0.8-legacy-api" end
    end
    page:Refresh()
    equal(page.VersionText:GetText(), "Version: 0.8-legacy-api")

    GetAddOnMetadata = nil
    page:Refresh()
    equal(page.VersionText:GetText(), "Version metadata unavailable (prerelease)")

    local externalCalls = 0
    OpenURL = function() externalCalls = externalCalls + 1 end
    page.SelectURL:Click()
    equal(externalCalls, 0)
    equal(page.URLBox.focused, true)
    equal(page.URLBox.highlighted, true)
    equal(page.URLBox:GetText(), "https://github.com/Wiubiki/rphelper-forever")
    OpenURL = nil
    C_AddOns, GetAddOnMetadata = modern, legacy
    page:Refresh()
end)

test("Guide and About browsing is side-effect free and reuses frames", function()
    freshDatabase()
    local database = RPHelperDB
    local settings, triggers, abilities = database.settings, database.triggers, database.abilities
    local customEntries = database.custom.entries
    local combat = RPHelper.Runtime.IsInCombat()
    local oldSend, oldEmote, outputCalls = SendChatMessage, DoEmote, 0
    SendChatMessage = function() outputCalls = outputCalls + 1 end
    DoEmote = function() outputCalls = outputCalls + 1 end
    local frameCount = #frames

    for _ = 1, 12 do
        UI.Navigate("guide")
        UI.GetPage("guide").SectionButtons[7]:Click()
        UI.GetPage("guide").Next:Click()
        UI.Navigate("about")
        UI.GetPage("about").SelectURL:Click()
        UI.Navigate("main")
    end

    SendChatMessage, DoEmote = oldSend, oldEmote
    equal(#frames, frameCount)
    equal(outputCalls, 0)
    equal(RPHelperDB, database)
    equal(database.settings, settings); equal(next(settings), nil)
    equal(database.triggers, triggers); equal(next(triggers), nil)
    equal(database.abilities, abilities); equal(next(abilities), nil)
    equal(database.custom.entries, customEntries); equal(next(customEntries), nil)
    equal(RPHelper.Runtime.IsInCombat(), combat)
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

test("library filters character layers and groups events, abilities, and Druid forms", function()
    freshDatabase()
    local generic = LibraryData.BuildSection("generic")
    truthy(findGroup(generic, "event:generic::library_event"))
    truthy(findGroup(generic, "event:generic::dodge"))

    local race = LibraryData.BuildSection("race")
    truthy(findGroup(race, "event:race:TAUREN:library_event"))
    equal(findGroup(race, "event:race:ORC:library_event"), nil)

    local class = LibraryData.BuildSection("class")
    truthy(findGroup(class, "event:class:DRUID:library_event"))
    truthy(findGroup(class, "ability:DRUID:LIBRARY_ABILITY_01"))
    truthy(findGroup(class, "form:CAT:library_event"))
    equal(findGroup(class, "event:class:WARRIOR:library_event"), nil)

    local empty = LibraryData.BuildSection("race", { race = "GNOME", class = "DRUID" })
    equal(#empty.groups, 0)
    truthy(string.find(empty.emptyMessage, "No registered Race reactions", 1, true))
end)

test("library exposes provenance, raw authored content, activation, weights, and event state", function()
    freshDatabase()
    truthy(Config.SetDefaultWeight("default:test:generic:0001", 4))
    local customID = UserContent.Add(
        { layer = "generic", trigger = "library_event" },
        { type = "customemote", text = "checks a custom library entry." },
        { enabled = false, weight = 3 })
    truthy(customID)

    local model = LibraryData.BuildSection("generic")
    local group = findGroup(model, "event:generic::library_event")
    local builtIn = findReaction(group, "default:test:generic:0001")
    local custom = findReaction(group, customID)
    equal(builtIn.provenance, "Built-in")
    equal(builtIn.typeLabel, "Say")
    equal(builtIn.weight, 4)
    equal(builtIn.text, longReaction)
    equal(custom.provenance, "Custom")
    equal(custom.typeLabel, "Custom Emote")
    equal(custom.enabled, false)
    equal(custom.weight, 3)
    equal(group.settings.supported, false)
    equal(group.settings.detected, false)
    equal(group.settings.configKey, nil)
    equal(group.settings.enabled, nil)
    equal(group.settings.chance, nil)
    equal(group.settings.priority, nil)
    local supported = findGroup(model, "event:generic::dodge").settings
    equal(supported.supported, true)
    equal(supported.detected, true)
    equal(supported.configLayer, "trigger")
    equal(supported.configKey, "dodge")
    equal(supported.enabled, true)
    equal(supported.chance, 0.05)
    equal(supported.priority, false)
    equal(next(RPHelperDB.triggers), nil)
    equal(next(RPHelperDB.abilities), nil)
end)

test("library shares canonical event metadata across layers and Druid forms", function()
    freshDatabase()
    truthy(Config.SetEventSetting("trigger", nil, "enter_combat", "enabled", false))
    truthy(Config.SetEventSetting("trigger", nil, "enter_combat", "chance", 0.37))
    truthy(Config.SetEventSetting("trigger", nil, "enter_combat", "priority", true))

    local groups = {
        findGroup(LibraryData.BuildSection("generic"), "event:generic::entercombat"),
        findGroup(LibraryData.BuildSection("race"), "event:race:TAUREN:entercombat"),
        findGroup(LibraryData.BuildSection("class"), "event:class:DRUID:entercombat"),
        findGroup(LibraryData.BuildSection("class"), "form:CAT:entercombat"),
    }
    for _, group in ipairs(groups) do
        truthy(group)
        equal(group.settings.supported, true)
        equal(group.settings.configLayer, "trigger")
        equal(group.settings.configOwner, nil)
        equal(group.settings.configKey, "enter_combat")
        equal(group.settings.enabled, false)
        equal(group.settings.chance, 0.37)
        equal(group.settings.priority, true)
    end
    equal(RPHelperDB.triggers.entercombat, nil)
    equal(RPHelperDB.triggers.enter_combat.enabled, false)
end)

test("library distinguishes unsupported catalogue triggers from event configuration", function()
    freshDatabase()
    truthy(Config.SetEventSetting("trigger", nil, "library_event", "chance", 0.91))
    local group = findGroup(LibraryData.BuildSection("generic"), "event:generic::library_event")
    equal(group.settings.supported, false)
    equal(group.settings.configKey, nil)
    equal(group.settings.chance, nil)

    UI.Navigate("library")
    local page = UI.GetLibraryPage()
    page:SelectSection("generic")
    page:SelectGroup("event:generic::library_event")
    equal(page.EventState:GetText(), "Not currently detected | Event settings unavailable")
end)

test("library maps supported abilities to canonical class and ability settings", function()
    freshDatabase()
    truthy(Config.SetEventSetting("ability", "PALADIN", "FLASH_OF_LIGHT", "enabled", false))
    truthy(Config.SetEventSetting("ability", "PALADIN", "FLASH_OF_LIGHT", "chance", 0.62))
    truthy(Config.SetEventSetting("ability", "PALADIN", "FLASH_OF_LIGHT", "priority", true))
    local model = LibraryData.BuildSection("class", { class = "PALADIN", race = "HUMAN" })
    local settings = findGroup(model, "ability:PALADIN:FLASH_OF_LIGHT").settings
    equal(settings.supported, true)
    equal(settings.detected, true)
    equal(settings.configLayer, "ability")
    equal(settings.configOwner, "PALADIN")
    equal(settings.configKey, "FLASH_OF_LIGHT")
    equal(settings.enabled, false)
    equal(settings.chance, 0.62)
    equal(settings.priority, true)

    local unsupportedGroup = findGroup(LibraryData.BuildSection("class"),
        "ability:DRUID:LIBRARY_ABILITY_01")
    local unsupported = unsupportedGroup.settings
    equal(unsupported.supported, false)
    equal(unsupported.configKey, nil)
    equal(unsupported.chance, nil)
    local unsupportedDraft, err = EditorData.NewEventDraft(unsupportedGroup)
    equal(unsupportedDraft, nil); equal(err, "unsupported_group")
end)

test("library construction and refresh do not materialize persistence defaults", function()
    freshDatabase()
    UI.Navigate("library")
    local page = UI.GetLibraryPage()
    page:SelectSection("generic")
    page:SelectSection("race")
    page:SelectSection("class")
    page:RefreshLibrary()
    equal(next(RPHelperDB.settings), nil)
    equal(next(RPHelperDB.triggers), nil)
    equal(next(RPHelperDB.abilities), nil)
    equal(next(RPHelperDB.disabledDefaults), nil)
    equal(next(RPHelperDB.reactionOverrides), nil)
    equal(next(RPHelperDB.custom.entries), nil)
end)

test("library activation uses sparse built-in and custom persistence", function()
    freshDatabase()
    local customID = UserContent.Add(
        { layer = "generic", trigger = "custom_ui_event" },
        { type = "say", text = "Custom activation test." },
        { weight = 2 })
    RPHelperDB.custom.entries[customID].futureField = "preserve"

    UI.Navigate("library")
    local page = UI.GetLibraryPage()
    page:SelectSection("generic")
    truthy(page:SelectGroup("event:generic::library_event"))
    local row = page.ReactionRows[1]
    equal(row.Reaction.id, "default:test:generic:0001")
    equal(row.CheckBox:GetChecked(), true)
    row.CheckBox:Click()
    equal(RPHelperDB.disabledDefaults[row.Reaction.id], true)
    equal(row.CheckBox:GetChecked(), false)
    row.CheckBox:Click()
    equal(RPHelperDB.disabledDefaults[row.Reaction.id], nil)
    equal(row.CheckBox:GetChecked(), true)

    truthy(page:SelectGroup("event:generic::custom_ui_event"))
    row = page.ReactionRows[1]
    equal(row.Reaction.id, customID)
    row.CheckBox:Click()
    equal(RPHelperDB.custom.entries[customID].enabled, false)
    equal(RPHelperDB.custom.entries[customID].weight, 2)
    equal(RPHelperDB.custom.entries[customID].futureField, "preserve")
    equal(row.CheckBox:IsEnabled(), true)
    equal(row.CheckBox:GetChecked(), false)
    equal(row.Reaction.id, customID)
    row.CheckBox:Click()
    equal(RPHelperDB.custom.entries[customID].enabled, nil)
    equal(findReaction(findGroup(LibraryData.BuildSection("generic"),
        "event:generic::custom_ui_event"), customID).enabled, true)
    equal(row.CheckBox:GetChecked(), true)
    equal(RPHelperDB.custom.entries[customID].futureField, "preserve")
end)

test("library restores effective state when an activation write is rejected", function()
    freshDatabase()
    UI.Navigate("library")
    local page = UI.GetLibraryPage()
    page:SelectSection("generic")
    truthy(page:SelectGroup("event:generic::library_event"))
    local row = page.ReactionRows[1]
    local original = UserContent.SetDefaultDisabled
    UserContent.SetDefaultDisabled = function() return false, "injected_failure" end
    row.CheckBox:Click()
    UserContent.SetDefaultDisabled = original
    equal(row.CheckBox:GetChecked(), true)
    equal(RPHelperDB.disabledDefaults[row.Reaction.id], nil)
    truthy(string.find(page.Message:GetText(), "could not be saved", 1, true))
end)

test("library activation is isolated per character and survives refresh and reopen", function()
    freshDatabase()
    truthy(UserContent.SetDefaultDisabled("default:test:generic:0001", true))
    local first = RPHelperDB
    local second

    freshDatabase()
    second = RPHelperDB
    local model = LibraryData.BuildSection("generic")
    equal(findReaction(findGroup(model, "event:generic::library_event"),
        "default:test:generic:0001").enabled, true)

    RPHelperDB = first
    UI.Navigate("library")
    local page = UI.GetLibraryPage()
    page:SelectSection("generic")
    page:SelectGroup("event:generic::library_event")
    equal(page.ReactionRows[1].CheckBox:GetChecked(), false)
    UI.Close()
    UI.Open()
    equal(page.ReactionRows[1].CheckBox:GetChecked(), false)
    equal(second.disabledDefaults["default:test:generic:0001"], nil)
end)

test("library activation survives UI module reload", function()
    freshDatabase()
    truthy(UserContent.SetDefaultDisabled("default:test:generic:0001", true))
    RPHelper.UI = nil
    dofile("RPHelper/UI/MainWindow.lua")
    UI = RPHelper.UI
    UI.Initialize()
    UI.Open("library")
    local page = UI.GetLibraryPage()
    page:SelectGroup("event:generic::library_event")
    equal(page.ReactionRows[1].CheckBox:GetChecked(), false)
end)

test("library uses bounded controls and paginates complete long authored text", function()
    freshDatabase()
    UI.Navigate("library")
    local page = UI.GetLibraryPage()
    page:SelectSection("generic")
    page:SelectGroup("event:generic::library_event")
    equal(#page.ReactionRows, 5)
    equal(page:GetVisibleReactionCount(), 5)
    truthy(page.NextReactions:IsEnabled())
    page.ReactionRows[1].Inspect:Click()
    truthy(#page.DetailPages > 1)
    equal(string.find(table.concat(page.DetailPages), "The final words remain visible", 1, true) ~= nil, true)
    local firstPage = page.DetailText:GetText()
    page.NextDetail:Click()
    truthy(page.DetailText:GetText() ~= firstPage)

    local frameCount = #frames
    page:SelectSection("class")
    page:SelectSection("race")
    page:SelectSection("class")
    equal(#frames, frameCount)
    equal(#page.GroupButtons, 9)
    truthy(page.NextGroups:IsEnabled())
end)

test("library handles unavailable context and malformed persistence without unrelated content", function()
    freshDatabase()
    local oldClass, oldRace = RPHelper.RuntimeAPI.GetPlayerClass, RPHelper.RuntimeAPI.GetPlayerRace
    RPHelper.RuntimeAPI.GetPlayerClass = function() error("unavailable") end
    RPHelper.RuntimeAPI.GetPlayerRace = function() return "not-a-token" end
    local race = LibraryData.BuildSection("race")
    local class = LibraryData.BuildSection("class")
    equal(#race.groups, 0)
    equal(race.emptyMessage, "Current character race is unavailable.")
    equal(#class.groups, 0)
    equal(class.emptyMessage, "Current character class is unavailable.")
    truthy(#LibraryData.BuildSection("generic").groups > 0)
    local invalidDraft, invalidErr = EditorData.NewReactionDraft(
        { scope = { layer = "generic", trigger = "dodge" } },
        { provenance = "Custom", entry = nil }, "edit")
    equal(invalidDraft, nil); equal(invalidErr, "invalid_entry")
    RPHelper.RuntimeAPI.GetPlayerClass, RPHelper.RuntimeAPI.GetPlayerRace = oldClass, oldRace

    RPHelperDB = "broken root"
    local model = LibraryData.BuildSection("generic")
    truthy(#model.groups > 0)
    truthy(string.find(model.warning, "Custom reactions are unavailable", 1, true))
    local reaction = findReaction(findGroup(model, "event:generic::library_event"),
        "default:test:generic:0001")
    equal(LibraryData.SetReactionEnabled(reaction, false), false)
    equal(RPHelperDB, "broken root")
    UI.Navigate("library")
    local page = UI.GetLibraryPage()
    page:SelectSection("generic")
    page:SelectGroup("event:generic::library_event")
    page.ReactionRows[1].CheckBox:Click()
    equal(page.ReactionRows[1].CheckBox:GetChecked(), true)
    truthy(string.find(page.Message:GetText(), "could not be saved", 1, true))
    equal(RPHelperDB, "broken root")
end)

test("event editor saves and clears canonical chance overrides", function()
    freshDatabase()
    UI.Navigate("library")
    local library = UI.GetLibraryPage()
    library:SelectSection("generic")
    library:SelectGroup("event:generic::entercombat")
    library.ModifyGroup:Click()
    equal(UI.GetCurrentPage(), "editor")
    local editor = UI.GetLibraryEditorPage()
    equal(editor:GetMode(), "event")
    equal(editor.ChanceOverride:GetChecked(), false)
    truthy(string.find(editor.ChanceLabel:GetText(), "Using global chance", 1, true))
    editor.EventEnabled:Click()
    editor.EventPriority:Click()
    editor.ChanceOverride:Click()
    editor.ChanceSlider:SetValue(0)
    editor.EventSave:Click()
    equal(UI.GetCurrentPage(), "library")
    equal(RPHelperDB.triggers.enter_combat.enabled, false)
    equal(RPHelperDB.triggers.enter_combat.priority, true)
    equal(RPHelperDB.triggers.enter_combat.chance, 0)

    local raceSettings = findGroup(LibraryData.BuildSection("race"),
        "event:race:TAUREN:entercombat").settings
    local classSettings = findGroup(LibraryData.BuildSection("class"),
        "event:class:DRUID:entercombat").settings
    local formSettings = findGroup(LibraryData.BuildSection("class"),
        "form:CAT:entercombat").settings
    for _, settings in ipairs({ raceSettings, classSettings, formSettings }) do
        equal(settings.enabled, false); equal(settings.chance, 0); equal(settings.priority, true)
        equal(settings.configKey, "enter_combat")
    end

    library:SelectSection("generic")
    library:SelectGroup("event:generic::entercombat")
    library.ModifyGroup:Click()
    editor.ChanceOverride:Click()
    editor.EventSave:Click()
    equal(RPHelperDB.triggers.enter_combat.chance, nil)
    equal(Config.GetEventSetting("trigger", nil, "enter_combat", "chance"), 0.05)
end)

test("clearing a chance override immediately displays current global inheritance", function()
    freshDatabase()
    truthy(Config.SetEventSetting("trigger", nil, "enter_combat", "chance", 0.40))
    UI.Navigate("library")
    local library = UI.GetLibraryPage()
    library:SelectSection("generic")
    library:SelectGroup("event:generic::entercombat")
    library.ModifyGroup:Click()
    local editor = UI.GetLibraryEditorPage()
    equal(editor.ChanceLabel:GetText(), "Explicit chance: 40%")
    editor.ChanceOverride:Click()
    equal(editor.ChanceLabel:GetText(), "Using global chance: 5%")
    equal(RPHelperDB.triggers.enter_combat.chance, 0.40)
    editor.EventSave:Click()
    equal(RPHelperDB.triggers.enter_combat, nil)
    equal(Config.GetEventSetting("trigger", nil, "enter_combat", "chance"), 0.05)
end)

test("priority-only save preserves an existing fractional chance override", function()
    freshDatabase()
    truthy(Config.SetEventSetting("trigger", nil, "enter_combat", "chance", 0.125))
    UI.Navigate("library")
    local library = UI.GetLibraryPage()
    library:SelectSection("generic")
    library:SelectGroup("event:generic::entercombat")
    library.ModifyGroup:Click()
    local editor = UI.GetLibraryEditorPage()
    equal(editor.ChanceSlider:GetValue(), 12.5)
    truthy(string.find(editor.ChanceLabel:GetText(), "Stored chance: 12.5%", 1, true))
    truthy(string.find(editor.ChanceLabel:GetText(), "slider changes use whole percentages", 1, true))
    editor.EventPriority:Click()
    editor.EventSave:Click()
    equal(RPHelperDB.triggers.enter_combat.chance, 0.125)
    equal(RPHelperDB.triggers.enter_combat.priority, true)
end)

test("moving the chance slider explicitly replaces a fractional override", function()
    freshDatabase()
    truthy(Config.SetEventSetting("trigger", nil, "enter_combat", "chance", 0.125))
    UI.Navigate("library")
    local library = UI.GetLibraryPage()
    library:SelectSection("generic")
    library:SelectGroup("event:generic::entercombat")
    library.ModifyGroup:Click()
    local editor = UI.GetLibraryEditorPage()
    editor.ChanceSlider:SetValue(37)
    equal(editor.ChanceLabel:GetText(), "Explicit chance: 37%")
    editor.EventSave:Click()
    equal(RPHelperDB.triggers.enter_combat.chance, 0.37)
end)

test("trigger editor saves only explicitly edited event settings", function()
    local function openTriggerEditor()
        UI.Navigate("library")
        local library = UI.GetLibraryPage()
        library:SelectSection("generic")
        library:SelectGroup("event:generic::entercombat")
        library.ModifyGroup:Click()
        return UI.GetLibraryEditorPage()
    end

    freshDatabase()
    openTriggerEditor().EventSave:Click()
    equal(RPHelperDB.triggers.enter_combat, nil)

    freshDatabase()
    local editor = openTriggerEditor()
    editor.ChanceOverride:Click()
    editor.EventSave:Click()
    local record = RPHelperDB.triggers.enter_combat
    equal(record.chance, 0.05)
    equal(record.enabled, nil); equal(record.priority, nil)

    freshDatabase()
    RPHelperDB.triggers.enter_combat = { enabled = false, chance = 0.125, future = "keep" }
    editor = openTriggerEditor()
    editor.EventPriority:Click()
    editor.EventSave:Click()
    record = RPHelperDB.triggers.enter_combat
    equal(record.priority, true); equal(record.enabled, false); equal(record.chance, 0.125)
    equal(record.future, "keep")

    freshDatabase()
    RPHelperDB.triggers.enter_combat = { priority = true, chance = 0.125, future = "keep" }
    editor = openTriggerEditor()
    editor.EventEnabled:Click()
    editor.EventSave:Click()
    record = RPHelperDB.triggers.enter_combat
    equal(record.enabled, false); equal(record.priority, true); equal(record.chance, 0.125)
    equal(record.future, "keep")

    freshDatabase()
    editor = openTriggerEditor()
    editor.EventEnabled:Click()
    editor.EventEnabled:Click()
    editor.EventSave:Click()
    record = RPHelperDB.triggers.enter_combat
    equal(record.enabled, true)
    equal(record.priority, nil); equal(record.chance, nil)
end)

test("ability editor saves sparsely and rejects invalid atomic changes", function()
    local function abilityGroup()
        return findGroup(LibraryData.BuildSection("class", { class = "PALADIN", race = "HUMAN" }),
            "ability:PALADIN:FLASH_OF_LIGHT")
    end
    local editor = UI.GetLibraryEditorPage()

    freshDatabase()
    truthy(editor:OpenEvent(abilityGroup()))
    editor.EventSave:Click()
    equal(RPHelperDB.abilities.PALADIN, nil)

    freshDatabase()
    truthy(editor:OpenEvent(abilityGroup()))
    editor.ChanceOverride:Click()
    editor.ChanceSlider:SetValue(44)
    editor.EventSave:Click()
    local record = RPHelperDB.abilities.PALADIN.FLASH_OF_LIGHT
    equal(record.chance, 0.44)
    equal(record.enabled, nil); equal(record.priority, nil)

    freshDatabase()
    RPHelperDB.abilities.PALADIN = {
        FLASH_OF_LIGHT = { enabled = false, chance = 0.125, future = { keep = true } },
    }
    truthy(editor:OpenEvent(abilityGroup()))
    editor.EventPriority:Click()
    editor.EventSave:Click()
    record = RPHelperDB.abilities.PALADIN.FLASH_OF_LIGHT
    equal(record.priority, true); equal(record.enabled, false); equal(record.chance, 0.125)
    truthy(record.future.keep)

    freshDatabase()
    RPHelperDB.abilities.PALADIN = {
        FLASH_OF_LIGHT = { priority = true, chance = 0.125, future = "keep" },
    }
    truthy(editor:OpenEvent(abilityGroup()))
    editor.EventEnabled:Click()
    editor.EventSave:Click()
    record = RPHelperDB.abilities.PALADIN.FLASH_OF_LIGHT
    equal(record.enabled, false); equal(record.priority, true); equal(record.chance, 0.125)
    equal(record.future, "keep")

    freshDatabase()
    truthy(editor:OpenEvent(abilityGroup()))
    editor.EventPriority:Click()
    editor.EventPriority:Click()
    editor.EventSave:Click()
    record = RPHelperDB.abilities.PALADIN.FLASH_OF_LIGHT
    equal(record.priority, false)
    equal(record.enabled, nil); equal(record.chance, nil)

    freshDatabase()
    RPHelperDB.abilities.PALADIN = {
        FLASH_OF_LIGHT = { chance = 0.125, future = "keep" },
    }
    record = RPHelperDB.abilities.PALADIN.FLASH_OF_LIGHT
    local draft = EditorData.NewEventDraft(abilityGroup())
    draft.enabled, draft.enabledModified = "invalid", true
    draft.priority, draft.priorityModified = true, true
    equal(EditorData.SaveEventDraft(draft), false)
    equal(RPHelperDB.abilities.PALADIN.FLASH_OF_LIGHT, record)
    equal(record.enabled, nil); equal(record.priority, nil); equal(record.chance, 0.125)
    equal(record.future, "keep")
end)

test("unsupported groups cannot create event settings but remain customizable", function()
    freshDatabase()
    UI.Navigate("library")
    local library = UI.GetLibraryPage()
    library:SelectSection("generic")
    library:SelectGroup("event:generic::library_event")
    equal(library.ModifyGroup:IsEnabled(), false)
    library.ModifyGroup:Click()
    equal(UI.GetCurrentPage(), "library")
    equal(RPHelperDB.triggers.library_event, nil)
    equal(library.AddReaction:IsEnabled(), true)
end)

test("supported ability editor writes canonical class and ability settings", function()
    freshDatabase()
    local group = findGroup(LibraryData.BuildSection("class", { class = "PALADIN", race = "HUMAN" }),
        "ability:PALADIN:FLASH_OF_LIGHT")
    local draft = EditorData.NewEventDraft(group)
    draft.enabled, draft.priority = false, true
    draft.useChanceOverride, draft.chancePercent = true, 44
    truthy(EditorData.SaveEventDraft(draft))
    equal(RPHelperDB.abilities.PALADIN.FLASH_OF_LIGHT.enabled, false)
    equal(RPHelperDB.abilities.PALADIN.FLASH_OF_LIGHT.priority, true)
    equal(RPHelperDB.abilities.PALADIN.FLASH_OF_LIGHT.chance, 0.44)

    truthy(Config.SetEventSetting("ability", "PALADIN", "FLASH_OF_LIGHT", "chance", 0.125))
    group = findGroup(LibraryData.BuildSection("class", { class = "PALADIN", race = "HUMAN" }),
        "ability:PALADIN:FLASH_OF_LIGHT")
    draft = EditorData.NewEventDraft(group)
    draft.priority = false
    truthy(EditorData.SaveEventDraft(draft))
    equal(RPHelperDB.abilities.PALADIN.FLASH_OF_LIGHT.chance, 0.125)
    equal(RPHelperDB.abilities.PALADIN.FLASH_OF_LIGHT.priority, false)
end)

test("built-in and Custom row weight controls use sparse validated APIs", function()
    freshDatabase()
    local customID = UserContent.Add(
        { layer = "generic", trigger = "dodge" },
        { type = "say", text = "Weighted custom." })
    UI.Navigate("library")
    local page = UI.GetLibraryPage()
    page:SelectSection("generic")
    page:SelectGroup("event:generic::dodge")
    local builtIn = findVisibleRow(page, "default:test:generic:dodge")
    builtIn.WeightUp:Click()
    equal(Config.GetDefaultWeight("default:test:generic:dodge"), 2)
    equal(RPHelperDB.reactionOverrides["default:test:generic:dodge"].weight, 2)
    builtIn = findVisibleRow(page, "default:test:generic:dodge")
    builtIn.WeightDown:Click()
    equal(Config.GetDefaultWeight("default:test:generic:dodge"), 1)
    equal(RPHelperDB.reactionOverrides["default:test:generic:dodge"], nil)

    local custom = findVisibleRow(page, customID)
    custom.WeightUp:Click()
    equal(UserContent.GetWeight(customID), 2)
    custom = findVisibleRow(page, customID)
    custom.WeightDown:Click()
    equal(UserContent.GetWeight(customID), 1)
    equal(RPHelperDB.custom.entries[customID].weight, nil)
end)

test("reaction weight rejection and malformed storage restore effective UI values", function()
    freshDatabase()
    RPHelperDB.reactionOverrides["default:test:generic:dodge"] = { weight = 11, future = "keep" }
    local customID = UserContent.Add(
        { layer = "generic", trigger = "dodge" }, { type = "say", text = "Malformed weight." })
    RPHelperDB.custom.entries[customID].weight = math.huge
    UserContent.Invalidate()
    local group = findGroup(LibraryData.BuildSection("generic"), "event:generic::dodge")
    equal(findReaction(group, "default:test:generic:dodge").weight, 1)
    equal(findReaction(group, customID).weight, 1)
    equal(RPHelperDB.reactionOverrides["default:test:generic:dodge"].weight, 11)
    equal(RPHelperDB.custom.entries[customID].weight, math.huge)

    UI.Navigate("library")
    local page = UI.GetLibraryPage()
    page:SelectSection("generic"); page:SelectGroup("event:generic::dodge")
    local row = findVisibleRow(page, "default:test:generic:dodge")
    local original = Config.SetDefaultWeight
    Config.SetDefaultWeight = function() return false, "injected_failure" end
    row.WeightUp:Click()
    Config.SetDefaultWeight = original
    row = findVisibleRow(page, "default:test:generic:dodge")
    equal(row.Reaction.weight, 1)
    equal(RPHelperDB.reactionOverrides["default:test:generic:dodge"].weight, 11)
    truthy(string.find(page.Message:GetText(), "could not be saved", 1, true))
end)

test("editor creates Say, Emote, and Custom Emote records in the selected scope", function()
    freshDatabase()
    UI.Navigate("library")
    local library = UI.GetLibraryPage()
    library:SelectSection("generic"); library:SelectGroup("event:generic::dodge")
    local editor = UI.GetLibraryEditorPage()

    library.AddReaction:Click()
    editor.ContentEdit:SetText(longReaction)
    editor.Weight:SetValue(10)
    editor.Save:Click()
    local first = RPHelperDB.custom.entries["custom:1"]
    equal(first.scope.layer, "generic"); equal(first.scope.trigger, "dodge")
    equal(first.entry.type, "say"); equal(first.entry.text, longReaction)
    equal(first.weight, 10)

    library.AddReaction:Click()
    editor.TypeButtons.emote:Click()
    equal(editor:GetDraft().entry.type, "emote")
    editor.EmoteSearch:SetText("wav")
    editor.EmoteSearch.scripts.OnTextChanged(editor.EmoteSearch)
    equal(editor.EmoteToken:GetText(), "Token: WAVE")
    editor.Save:Click()
    equal(RPHelperDB.custom.entries["custom:2"].entry.type, "emote")
    equal(RPHelperDB.custom.entries["custom:2"].entry.text, "WAVE")

    library.AddReaction:Click()
    editor.TypeButtons.customemote:Click()
    editor.ContentEdit:SetText("adjusts a cloak.")
    editor.Active:Click()
    editor.Save:Click()
    equal(RPHelperDB.custom.entries["custom:3"].entry.type, "customemote")
    equal(RPHelperDB.custom.entries["custom:3"].entry.text, "adjusts a cloak.")
    equal(RPHelperDB.custom.entries["custom:3"].enabled, false)
    equal(RPHelperDB.custom.nextID, 4)
end)

test("Custom editor preserves identity and unknown metadata on atomic edits", function()
    freshDatabase()
    local id = UserContent.Add(
        { layer = "generic", trigger = "custom_edit_event" },
        { type = "say", text = "Before edit." }, { weight = 2 })
    RPHelperDB.custom.entries[id].future = { keep = true }
    UI.Navigate("library")
    local library = UI.GetLibraryPage()
    library:SelectSection("generic")
    library:SelectGroup("event:generic::custom_edit_event")
    library.ReactionRows[1].Modify:Click()
    local editor = UI.GetLibraryEditorPage()
    equal(editor:GetDraft().id, id)
    editor.ContentEdit:SetText("After edit.")
    editor.Active:Click()
    editor.Weight:SetValue(10)
    editor.Save:Click()
    equal(RPHelperDB.custom.entries[id].entry.text, "After edit.")
    equal(RPHelperDB.custom.entries[id].enabled, false)
    equal(RPHelperDB.custom.entries[id].weight, 10)
    truthy(RPHelperDB.custom.entries[id].future.keep)
    equal(RPHelperDB.custom.nextID, 2)
end)

test("Custom editor preserves a valid existing emote token outside the shipped selector", function()
    freshDatabase()
    local id = UserContent.Add(
        { layer = "generic", trigger = "custom_emote_edit" },
        { type = "emote", text = "ROAR" })
    UI.Navigate("library")
    local library = UI.GetLibraryPage()
    library:SelectSection("generic"); library:SelectGroup("event:generic::custom_emote_edit")
    library.ReactionRows[1].Modify:Click()
    local editor = UI.GetLibraryEditorPage()
    equal(editor.EmoteToken:GetText(), "Token: ROAR")
    editor.Weight:SetValue(2)
    editor.Save:Click()
    equal(RPHelperDB.custom.entries[id].entry.text, "ROAR")
    equal(RPHelperDB.custom.entries[id].weight, 2)
end)

test("Custom deletion requires confirmation and cancellation preserves content", function()
    freshDatabase()
    local id = UserContent.Add(
        { layer = "generic", trigger = "delete_event" },
        { type = "say", text = "Keep until confirmed." })
    UI.Navigate("library")
    local library = UI.GetLibraryPage()
    library:SelectSection("generic"); library:SelectGroup("event:generic::delete_event")
    library.ReactionRows[1].Modify:Click()
    local editor = UI.GetLibraryEditorPage()
    editor.Delete:Click()
    equal(editor.ConfirmPanel:IsShown(), true)
    editor.CancelDelete:Click()
    truthy(RPHelperDB.custom.entries[id])
    local originalRemove = UserContent.Remove
    UserContent.Remove = function() return false, "injected_failure" end
    editor.Delete:Click()
    editor.ConfirmDelete:Click()
    UserContent.Remove = originalRemove
    truthy(RPHelperDB.custom.entries[id])
    truthy(string.find(editor.Message:GetText(), "was not deleted", 1, true))
    editor.Delete:Click()
    editor.ConfirmDelete:Click()
    equal(RPHelperDB.custom.entries[id], nil)
    equal(RPHelperDB.custom.nextID, 2)
    equal(UI.GetCurrentPage(), "library")
end)

test("Built-in Modify creates an independent Custom copy without changing source preferences", function()
    freshDatabase()
    local source = "default:test:generic:0001"
    truthy(Config.SetDefaultWeight(source, 4))
    truthy(Config.SetDefaultEnabled(source, false))
    UI.Navigate("library")
    local library = UI.GetLibraryPage()
    library:SelectSection("generic"); library:SelectGroup("event:generic::library_event")
    local row = findVisibleRow(library, source)
    row.Modify:Click()
    local editor = UI.GetLibraryEditorPage()
    equal(editor:GetDraft().mode, "copy")
    editor.ContentEdit:SetText("An edited independent copy.")
    editor.Weight:SetValue(3)
    editor.Save:Click()
    local copy = RPHelperDB.custom.entries["custom:1"]
    equal(copy.sourceDefaultID, source)
    equal(copy.entry.text, "An edited independent copy.")
    equal(copy.weight, 3)
    equal(Config.IsDefaultEnabled(source), false)
    equal(Config.GetDefaultWeight(source), 4)
    equal(longReaction, findReaction(findGroup(LibraryData.BuildSection("generic"),
        "event:generic::library_event"), source).text)
end)

test("template-based copies are preserved exactly with an explicit editor limitation", function()
    freshDatabase()
    RPHelper.RegisterGeneric("template_editor", {
        id = "default:test:template_editor",
        type = "say",
        template = "{1}, {PLAYER}!",
        choices = { { "Hello", "Greetings" } },
    })
    local group = findGroup(LibraryData.BuildSection("generic"), "event:generic::template_editor")
    local reaction = findReaction(group, "default:test:template_editor")
    local draft = EditorData.NewReactionDraft(group, reaction, "copy")
    equal(draft.templateLocked, true)
    draft.weight = 2
    local id = EditorData.SaveReaction(draft); truthy(id)
    local saved = RPHelperDB.custom.entries[id]
    equal(saved.entry.template, "{1}, {PLAYER}!")
    equal(saved.entry.choices[1][1], "Hello")
    equal(saved.entry.text, nil)
    equal(Config.IsDefaultEnabled("default:test:template_editor"), true)
end)

test("preview is private, supports unsaved drafts, and reports unresolved content", function()
    freshDatabase()
    UI.Navigate("library")
    local library = UI.GetLibraryPage()
    library:SelectSection("generic"); library:SelectGroup("event:generic::dodge")
    library.AddReaction:Click()
    local editor = UI.GetLibraryEditorPage()
    local oldSend, oldEmote, publicCalls = SendChatMessage, DoEmote, 0
    SendChatMessage = function() publicCalls = publicCalls + 1 end
    DoEmote = function() publicCalls = publicCalls + 1 end
    local nextID = RPHelperDB.custom.nextID
    local combat = RPHelper.Runtime.IsInCombat()

    editor.ContentEdit:SetText("Private preview.")
    editor.Preview:Click()
    truthy(string.find(editor.PreviewText:GetText(), "[Preview] Private preview.", 1, true))
    equal(publicCalls, 0); equal(RPHelperDB.custom.nextID, nextID)
    equal(RPHelper.Runtime.IsInCombat(), combat)

    editor.ContentEdit:SetText("Hello {TARGET}.")
    editor.Preview:Click()
    equal(editor.PreviewText:GetText(), "[Preview unavailable]")
    truthy(string.find(editor.Message:GetText(), "Unresolved context is not invented", 1, true))
    equal(publicCalls, 0); equal(RPHelperDB.custom.nextID, nextID)
    local malformed = EditorData.Copy(editor:GetDraft())
    malformed.entry = { type = "say", template = "{1}", choices = {} }
    local result, err = EditorData.Preview(malformed)
    equal(result, nil); equal(err, "invalid_choices")
    SendChatMessage, DoEmote = oldSend, oldEmote
end)

test("rejected editor writes retain drafts and malformed event containers", function()
    freshDatabase()
    RPHelperDB.triggers.enter_combat = false
    UI.Navigate("library")
    local library = UI.GetLibraryPage()
    library:SelectSection("generic"); library:SelectGroup("event:generic::entercombat")
    library.ModifyGroup:Click()
    local editor = UI.GetLibraryEditorPage()
    editor.EventEnabled:Click()
    editor.EventSave:Click()
    equal(UI.GetCurrentPage(), "editor")
    equal(RPHelperDB.triggers.enter_combat, false)
    truthy(string.find(editor.Message:GetText(), "could not be saved", 1, true))

    UI.Navigate("library")
    library:SelectGroup("event:generic::dodge")
    library.AddReaction:Click()
    editor.ContentEdit:SetText("")
    editor.Save:Click()
    equal(UI.GetCurrentPage(), "editor")
    truthy(string.find(editor.Message:GetText(), "Draft retained", 1, true))
    equal(RPHelperDB.custom.nextID, 1)
end)

test("repeated editor interactions reuse frames and cancellation preserves library position", function()
    freshDatabase()
    UI.Navigate("library")
    local library = UI.GetLibraryPage()
    library:SelectSection("generic"); library:SelectGroup("event:generic::library_event")
    library.NextReactions:Click()
    local frameCount = #frames
    for _ = 1, 3 do
        library.ReactionRows[1].Modify:Click()
        UI.GetLibraryEditorPage().Cancel:Click()
    end
    equal(#frames, frameCount)
    equal(next(RPHelperDB.custom.entries), nil)
    equal(RPHelperDB.custom.nextID, 1)
    equal(library:GetSelectedGroup().id, "event:generic::library_event")
    equal(library.PreviousReactions:IsEnabled(), true)
end)

test("editor-created content and weights remain isolated per character", function()
    freshDatabase()
    truthy(Config.SetDefaultWeight("default:test:generic:dodge", 10))
    local id = UserContent.Add(
        { layer = "generic", trigger = "dodge" }, { type = "say", text = "First character." })
    local first = RPHelperDB
    freshDatabase()
    local second = RPHelperDB
    equal(Config.GetDefaultWeight("default:test:generic:dodge"), 1)
    equal(#UserContent.List(), 0)
    RPHelperDB = first; UserContent.Invalidate()
    equal(Config.GetDefaultWeight("default:test:generic:dodge"), 10)
    equal(UserContent.List()[1].id, id)
    equal(next(second.reactionOverrides), nil)
end)

test("library navigation preserves Global Settings behaviour", function()
    freshDatabase()
    truthy(Config.SetSetting("reactionChance", 0.11))
    UI.Navigate("library")
    local page = UI.GetLibraryPage()
    page:SelectSection("race")
    page.BackButton:Click()
    equal(UI.GetCurrentPage(), "main")
    equal(UI.GetControl("reactionChance"):GetValue(), 11)
    equal(RPHelperDB.settings.reactionChance, 0.11)
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
