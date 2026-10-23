local failures, tests = 0, 0

local function test(name, callback)
    tests = tests + 1
    local ok, message = pcall(callback)
    if not ok then
        failures = failures + 1
        io.stderr:write("FAIL: " .. name .. "\n  " .. tostring(message) .. "\n")
    end
end

local function truthy(value, message)
    if not value then error(message or "expected a truthy value", 2) end
end

local function equal(actual, expected, message)
    if actual ~= expected then
        error(message or ("expected " .. tostring(expected) .. ", got " .. tostring(actual)), 2)
    end
end

local frames = {}

local function newWidget(frameType, name, parent)
    local widget = {
        frameType = frameType,
        name = name,
        parent = parent,
        scripts = {},
        registered = {},
        shown = true,
        enabled = true,
        checked = false,
    }
    function widget:RegisterEvent(event) self.registered[event] = true end
    function widget:SetScript(script, callback) self.scripts[script] = callback end
    function widget:CreateFontString() return newWidget("FontString", nil, self) end
    function widget:CreateTexture() return newWidget("Texture", nil, self) end
    function widget:SetText(value) self.text = value end
    function widget:GetText() return self.text end
    function widget:SetValue(value)
        self.value = value
        if self.scripts.OnValueChanged then self.scripts.OnValueChanged(self, value) end
    end
    function widget:GetValue() return self.value end
    function widget:SetChecked(value) self.checked = value == true end
    function widget:GetChecked() return self.checked end
    function widget:Show() self.shown = true end
    function widget:Hide() self.shown = false end
    function widget:IsShown() return self.shown end
    function widget:Enable() self.enabled = true end
    function widget:Disable() self.enabled = false end
    function widget:IsEnabled() return self.enabled end
    local function noOperation() end
    for _, method in ipairs({
        "SetSize", "SetWidth", "SetHeight", "SetPoint", "SetAllPoints", "SetMovable",
        "EnableMouse", "SetClampedToScreen", "RegisterForDrag", "StartMoving",
        "StopMovingOrSizing", "SetAlpha", "SetTextColor", "SetJustifyH", "SetJustifyV",
        "SetAutoFocus", "SetMultiLine", "SetFontObject", "SetTextInsets", "ClearFocus",
        "SetFocus", "HighlightText", "SetNormalFontObject", "SetHighlightFontObject",
        "SetDisabledFontObject", "SetNormalTexture", "SetPushedTexture", "SetHighlightTexture",
        "SetCheckedTexture", "SetDisabledCheckedTexture", "SetOrientation", "SetMinMaxValues",
        "SetValueStep", "SetObeyStepOnDrag", "SetThumbTexture", "SetColorTexture", "SetTexture",
    }) do
        widget[method] = noOperation
    end
    table.insert(frames, widget)
    if name then _G[name] = widget end
    return widget
end

local function readManifest(tocPath)
    local entries, seen = {}, {}
    local handle, openError = io.open(tocPath, "r")
    truthy(handle, "cannot open manifest " .. tocPath .. ": " .. tostring(openError))
    for rawLine in handle:lines() do
        local line = rawLine:gsub("\r$", "")
        local trimmed = line:match("^%s*(.-)%s*$")
        if trimmed ~= "" and not trimmed:match("^#") then
            truthy(line == trimmed, "invalid surrounding whitespace in TOC entry: " .. line)
            truthy(trimmed:match("^[%w_%-]+/[%w_/%-]+%.lua$") or trimmed:match("^[%w_%-]+%.lua$"),
                "invalid local Lua TOC entry: " .. trimmed)
            truthy(not trimmed:match("^/") and not trimmed:match("%.%.") and not trimmed:match("\\"),
                "unsafe local Lua TOC entry: " .. trimmed)
            truthy(not seen[trimmed], "duplicate Lua TOC entry: " .. trimmed)
            local file = io.open("RPHelper/" .. trimmed, "r")
            truthy(file, "missing Lua file declared by TOC: " .. trimmed)
            file:close()
            seen[trimmed] = true
            table.insert(entries, trimmed)
        end
    end
    handle:close()

    local finder = io.popen("find RPHelper -type f -name '*.lua' -print")
    truthy(finder, "cannot enumerate production Lua files")
    for path in finder:lines() do
        local entry = path:match("^RPHelper/(.+)$")
        if entry and not entry:match("Archive%.lua$") then
            truthy(seen[entry], "production Lua file omitted from TOC: " .. entry)
        end
    end
    local closed, _, status = finder:close()
    truthy(closed or status == 0, "production Lua file enumeration failed")
    return entries
end

test("real manifest loads the complete addon in order and starts all implemented paths", function()
    local tocPath = "RPHelper/RPHelper.toc"
    local addonIdentity = tocPath:match("^([^/]+)/[^/]+%.toc$")
    equal(addonIdentity, "RPHelper", "unexpected addon identity derived from TOC path")
    local entries = readManifest(tocPath)

    UIParent = newWidget("Frame", "UIParent")
    UISpecialFrames = {}
    GameFontNormal = {}
    GameFontHighlight = {}
    GameFontDisable = {}
    SlashCmdList = {}
    UnitClass = function() return "Paladin", "PALADIN" end
    UnitRace = function() return "Human", "HUMAN" end
    UnitSex = function() return 2 end
    UnitPowerType = function() return 0, "MANA" end
    UnitAffectingCombat = function() return false end
    GetShapeshiftFormID = function() return 0 end
    IsInInstance = function() return false, "none" end
    GetTime = function() return 0 end
    SendChatMessage = function() end
    DoEmote = function() end
    issecretvalue = function() return false end
    DEFAULT_CHAT_FRAME = { AddMessage = function() end }
    C_AddOns = {
        GetAddOnMetadata = function(addon, field)
            if addon == addonIdentity and field == "Version" then return "0.9.0-prerelease" end
        end,
    }
    CreateFrame = function(frameType, name, parent)
        return newWidget(frameType, name, parent)
    end
    RPHelper = nil
    RPHelperDB = nil

    for index, entry in ipairs(entries) do
        local chunk, loadError = loadfile("RPHelper/" .. entry)
        truthy(chunk, "manifest entry " .. index .. " cannot compile (" .. entry .. "): " .. tostring(loadError))
        local loaded, runtimeError = pcall(chunk)
        truthy(loaded, "manifest load failed at entry " .. index .. " (" .. entry .. "): "
            .. tostring(runtimeError))
    end

    local eventFrame
    for _, frame in ipairs(frames) do
        if frame.registered.ADDON_LOADED then eventFrame = frame; break end
    end
    truthy(eventFrame, "RPHelper.lua did not create an ADDON_LOADED event frame")
    truthy(type(eventFrame.scripts.OnEvent) == "function", "addon event frame has no OnEvent callback")
    eventFrame.scripts.OnEvent(eventFrame, "ADDON_LOADED", addonIdentity)

    truthy(type(RPHelperDB) == "table", "ADDON_LOADED did not initialize RPHelperDB")
    equal(RPHelperDB.schemaVersion, 2, "startup did not initialize schema v2")
    truthy(RPHelper.UI and RPHelper.UI.GetWindow and RPHelper.UI.GetWindow(),
        "ADDON_LOADED did not initialize the UI")
    equal(RPHelper.UI.GetWindow():IsShown(), false, "startup UI should be hidden")
    equal(SLASH_RPHELPER1, "/rph", "startup did not register the slash alias")
    equal(SlashCmdList.RPHELPER, RPHelper.HandleSlashCommand,
        "startup did not register the slash handler")
    for _, event in ipairs({
        "PLAYER_REGEN_DISABLED", "PLAYER_REGEN_ENABLED", "UNIT_COMBAT", "UNIT_SPELLCAST_SUCCEEDED",
    }) do
        truthy(eventFrame.registered[event], "startup did not register runtime event: " .. event)
    end
end)

if failures > 0 then
    io.stderr:write(tostring(failures) .. " of " .. tostring(tests) .. " manifest startup tests failed\n")
    os.exit(1)
end

print(tostring(tests) .. " manifest startup test passed")
