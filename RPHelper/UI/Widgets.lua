RPHelper = RPHelper or {}
RPHelper.UIWidgets = RPHelper.UIWidgets or {}
local Widgets = RPHelper.UIWidgets
local nextWidgetID = 0

local function uniqueName(prefix)
    nextWidgetID = nextWidgetID + 1
    return "RPHelper" .. prefix .. tostring(nextWidgetID)
end

local function createFrame(frameType, name, parent, template)
    if template then
        local ok, frame = pcall(CreateFrame, frameType, name, parent, template)
        if ok and frame then return frame, true end
    end
    return CreateFrame(frameType, nil, parent), false
end

local function setTexture(widget, method, path)
    if widget[method] then widget[method](widget, path) end
end

local function setButtonFont(button)
    if button.SetNormalFontObject and GameFontNormal then
        button:SetNormalFontObject(GameFontNormal)
    end
    if button.SetHighlightFontObject and GameFontHighlight then
        button:SetHighlightFontObject(GameFontHighlight)
    end
    if button.SetDisabledFontObject and GameFontDisable then
        button:SetDisabledFontObject(GameFontDisable)
    end
end

local function addFallbackButtonBackground(button)
    if not button.CreateTexture then return end
    local background = button:CreateTexture(nil, "BACKGROUND")
    background:SetAllPoints(button)
    Widgets.SetSolidColor(background, 0.16, 0.16, 0.2, 1)
    button.FallbackBackground = background
end

function Widgets.CreateButton(parent, text, width, height)
    local button, templated = createFrame("Button", nil, parent, "UIPanelButtonTemplate")
    Widgets.SetSize(button, width, height)
    setButtonFont(button)
    button:SetText(text)
    if not templated then addFallbackButtonBackground(button) end
    return button
end

function Widgets.CreateCloseButton(parent)
    local button, templated = createFrame("Button", nil, parent, "UIPanelCloseButton")
    Widgets.SetSize(button, 28, 28)
    if not templated then
        addFallbackButtonBackground(button)
        setButtonFont(button)
        button:SetText("X")
    end
    return button
end

function Widgets.CreateCheckBox(parent, labelText)
    local checkBox, templated = createFrame("CheckButton", nil, parent, "UICheckButtonTemplate")
    Widgets.SetSize(checkBox, 24, 24)
    if not templated then
        setTexture(checkBox, "SetNormalTexture", "Interface\\Buttons\\UI-CheckBox-Up")
        setTexture(checkBox, "SetPushedTexture", "Interface\\Buttons\\UI-CheckBox-Down")
        setTexture(checkBox, "SetHighlightTexture", "Interface\\Buttons\\UI-CheckBox-Highlight")
        setTexture(checkBox, "SetCheckedTexture", "Interface\\Buttons\\UI-CheckBox-Check")
        setTexture(checkBox, "SetDisabledCheckedTexture", "Interface\\Buttons\\UI-CheckBox-Check-Disabled")
    end

    local label = checkBox:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    label:SetPoint("LEFT", checkBox, "RIGHT", 4, 0)
    label:SetText(labelText)
    checkBox.Label = label
    return checkBox
end

function Widgets.CreateSlider(parent, width, minimum, maximum, step)
    local slider, templated = createFrame("Slider", uniqueName("Slider"), parent, "OptionsSliderTemplate")
    Widgets.SetSize(slider, width, 16)
    if slider.SetOrientation then slider:SetOrientation("HORIZONTAL") end
    if slider.SetMinMaxValues then slider:SetMinMaxValues(minimum, maximum) end
    if slider.SetValueStep then slider:SetValueStep(step) end
    if slider.SetObeyStepOnDrag then slider:SetObeyStepOnDrag(true) end
    if not templated then
        if slider.CreateTexture then
            local track = slider:CreateTexture(nil, "BACKGROUND")
            track:SetPoint("LEFT", slider, "LEFT", 0, 0)
            track:SetPoint("RIGHT", slider, "RIGHT", 0, 0)
            if track.SetHeight then track:SetHeight(6) end
            Widgets.SetSolidColor(track, 0.2, 0.2, 0.24, 1)
            slider.FallbackTrack = track
        end
        if slider.SetThumbTexture then
            slider:SetThumbTexture("Interface\\Buttons\\UI-SliderBar-Button-Horizontal")
        end
    end
    return slider
end

function Widgets.SetSize(region, width, height)
    if region.SetSize then
        region:SetSize(width, height)
    else
        if region.SetWidth then region:SetWidth(width) end
        if region.SetHeight then region:SetHeight(height) end
    end
end

function Widgets.SetSolidColor(texture, red, green, blue, alpha)
    if texture.SetColorTexture then
        texture:SetColorTexture(red, green, blue, alpha)
        return true
    end
    if texture.SetTexture then
        texture:SetTexture(red, green, blue, alpha)
        return true
    end
    return false
end

function Widgets.SetEnabled(widget, enabled)
    if enabled then
        if widget.Enable then widget:Enable() end
        if widget.SetAlpha then widget:SetAlpha(1) end
    else
        if widget.Disable then widget:Disable() end
        if widget.SetAlpha then widget:SetAlpha(0.5) end
    end
end

function Widgets.CreateText(parent, font, text, width)
    local label = parent:CreateFontString(nil, "OVERLAY", font or "GameFontNormal")
    if width then
        label:SetWidth(width)
        label:SetJustifyH("LEFT")
    end
    label:SetText(text or "")
    return label
end
