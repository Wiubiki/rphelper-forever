RPHelper = RPHelper or {}
RPHelper.LibraryEditorPage = RPHelper.LibraryEditorPage or {}
local EditorPage = RPHelper.LibraryEditorPage

local Data = RPHelper.LibraryEditorData
local Widgets = RPHelper.UIWidgets

local function rounded(value)
    return math.floor((tonumber(value) or 1) + 0.5)
end

local function percentText(value)
    if type(value) == "number" and value % 1 == 0 then return tostring(math.floor(value)) end
    return tostring(value)
end

function EditorPage.Create(parent, callbacks)
    callbacks = callbacks or {}
    local page = CreateFrame("Frame", nil, parent)
    page:SetAllPoints(parent)
    local state = { mode = nil, draft = nil, context = nil, refreshing = false, emotes = {} }

    local heading = Widgets.CreateText(page, "GameFontNormalLarge", "Library Editor", 430)
    heading:SetPoint("TOPLEFT", 0, 0)
    page.Heading = heading

    local scopeText = Widgets.CreateText(page, "GameFontHighlightSmall", "", 650)
    scopeText:SetPoint("TOPLEFT", 0, -34)
    page.ScopeText = scopeText

    local message = Widgets.CreateText(page, "GameFontHighlightSmall", "", 650)
    message:SetPoint("TOPLEFT", 0, -57)
    if message.SetHeight then message:SetHeight(28) end
    page.Message = message

    function page:SetMessage(text, isError)
        message:SetText(text or "")
        if message.SetTextColor then
            if isError then message:SetTextColor(1, 0.25, 0.25)
            else message:SetTextColor(0.7, 0.7, 0.7) end
        end
    end

    local eventPanel = CreateFrame("Frame", nil, page)
    eventPanel:SetAllPoints(page)
    page.EventPanel = eventPanel

    local eventEnabled = Widgets.CreateCheckBox(eventPanel, "Event or ability enabled")
    eventEnabled:SetPoint("TOPLEFT", -4, -95)
    page.EventEnabled = eventEnabled

    local eventPriority = Widgets.CreateCheckBox(eventPanel, "Priority (bypasses only the global cooldown)")
    eventPriority:SetPoint("TOPLEFT", -4, -132)
    page.EventPriority = eventPriority

    local chanceOverride = Widgets.CreateCheckBox(eventPanel, "Use event/ability chance override")
    chanceOverride:SetPoint("TOPLEFT", -4, -169)
    page.ChanceOverride = chanceOverride

    local chanceLabel = Widgets.CreateText(eventPanel, "GameFontNormal", "", 400)
    chanceLabel:SetPoint("TOPLEFT", 8, -207)
    page.ChanceLabel = chanceLabel

    local chanceSlider = Widgets.CreateSlider(eventPanel, 400, 0, 100, 1)
    chanceSlider:SetPoint("TOPLEFT", 8, -239)
    page.ChanceSlider = chanceSlider

    local eventHelp = Widgets.CreateText(eventPanel, "GameFontHighlightSmall",
        "An override replaces the global chance. Priority still respects chance, quota, eligibility, and routing.", 620)
    eventHelp:SetPoint("TOPLEFT", 0, -286)

    local eventSave = Widgets.CreateButton(eventPanel, "Save Settings", 130, 25)
    eventSave:SetPoint("TOPLEFT", 0, -345)
    page.EventSave = eventSave
    local eventCancel = Widgets.CreateButton(eventPanel, "Cancel", 100, 25)
    eventCancel:SetPoint("LEFT", eventSave, "RIGHT", 10, 0)
    page.EventCancel = eventCancel

    local reactionPanel = CreateFrame("Frame", nil, page)
    reactionPanel:SetAllPoints(page)
    page.ReactionPanel = reactionPanel

    local typeLabel = Widgets.CreateText(reactionPanel, "GameFontNormal", "Reaction type", 150)
    typeLabel:SetPoint("TOPLEFT", 0, -92)
    page.TypeButtons = {}
    for index, definition in ipairs({
        { "say", "Say" }, { "emote", "Emote" }, { "customemote", "Custom Emote" },
    }) do
        local button = Widgets.CreateButton(reactionPanel, definition[2], 115, 24)
        button:SetPoint("TOPLEFT", (index - 1) * 120, -116)
        button.EntryType = definition[1]
        page.TypeButtons[definition[1]] = button
    end

    local contentLabel = Widgets.CreateText(reactionPanel, "GameFontNormal", "Reaction content", 300)
    contentLabel:SetPoint("TOPLEFT", 0, -153)
    page.ContentLabel = contentLabel

    local contentEdit = Widgets.CreateEditBox(reactionPanel, 620, 118, true)
    contentEdit:SetPoint("TOPLEFT", 0, -176)
    page.ContentEdit = contentEdit

    local previousEmote = Widgets.CreateButton(reactionPanel, "<", 30, 24)
    previousEmote:SetPoint("TOPLEFT", 0, -181)
    page.PreviousEmote = previousEmote
    local emoteToken = Widgets.CreateText(reactionPanel, "GameFontNormal", "", 300)
    emoteToken:SetPoint("LEFT", previousEmote, "RIGHT", 10, 0)
    page.EmoteToken = emoteToken
    local nextEmote = Widgets.CreateButton(reactionPanel, ">", 30, 24)
    nextEmote:SetPoint("TOPLEFT", 350, -181)
    page.NextEmote = nextEmote
    local emoteSearch = Widgets.CreateEditBox(reactionPanel, 300, 24, false)
    emoteSearch:SetPoint("TOPLEFT", 0, -222)
    page.EmoteSearch = emoteSearch
    local emoteSearchHelp = Widgets.CreateText(reactionPanel, "GameFontHighlightSmall",
        "Search shipped emote tokens", 250)
    emoteSearchHelp:SetPoint("LEFT", emoteSearch, "RIGHT", 10, 0)
    page.EmoteSearchHelp = emoteSearchHelp

    local templateNote = Widgets.CreateText(reactionPanel, "GameFontHighlightSmall", "", 620)
    templateNote:SetPoint("TOPLEFT", 0, -301)
    page.TemplateNote = templateNote

    local active = Widgets.CreateCheckBox(reactionPanel, "Reaction enabled")
    active:SetPoint("TOPLEFT", -4, -329)
    page.Active = active

    local weightLabel = Widgets.CreateText(reactionPanel, "GameFontNormal", "Weight: 1", 180)
    weightLabel:SetPoint("TOPLEFT", 245, -329)
    page.WeightLabel = weightLabel
    local weight = Widgets.CreateSlider(reactionPanel, 240, 1, 10, 1)
    weight:SetPoint("TOPLEFT", 245, -361)
    page.Weight = weight

    local preview = Widgets.CreateButton(reactionPanel, "Preview Locally", 125, 25)
    preview:SetPoint("TOPLEFT", 0, -396)
    page.Preview = preview
    local save = Widgets.CreateButton(reactionPanel, "Save", 90, 25)
    save:SetPoint("LEFT", preview, "RIGHT", 10, 0)
    page.Save = save
    local cancel = Widgets.CreateButton(reactionPanel, "Cancel", 90, 25)
    cancel:SetPoint("LEFT", save, "RIGHT", 10, 0)
    page.Cancel = cancel
    local deleteButton = Widgets.CreateButton(reactionPanel, "Delete", 90, 25)
    deleteButton:SetPoint("LEFT", cancel, "RIGHT", 10, 0)
    page.Delete = deleteButton

    local previewText = Widgets.CreateText(reactionPanel, "GameFontHighlightSmall", "", 620)
    previewText:SetPoint("TOPLEFT", 0, -438)
    if previewText.SetHeight then previewText:SetHeight(72) end
    if previewText.SetJustifyV then previewText:SetJustifyV("TOP") end
    page.PreviewText = previewText

    local confirmPanel = CreateFrame("Frame", nil, page)
    confirmPanel:SetAllPoints(page)
    page.ConfirmPanel = confirmPanel
    local confirmTitle = Widgets.CreateText(confirmPanel, "GameFontNormalLarge", "Delete Custom Reaction?", 500)
    confirmTitle:SetPoint("TOPLEFT", 0, -110)
    local confirmText = Widgets.CreateText(confirmPanel, "GameFontHighlightSmall",
        "This removes only the selected Custom reaction. Its ID will not be reused.", 600)
    confirmText:SetPoint("TOPLEFT", 0, -150)
    local confirmDelete = Widgets.CreateButton(confirmPanel, "Confirm Delete", 140, 26)
    confirmDelete:SetPoint("TOPLEFT", 0, -205)
    page.ConfirmDelete = confirmDelete
    local cancelDelete = Widgets.CreateButton(confirmPanel, "Keep Reaction", 130, 26)
    cancelDelete:SetPoint("LEFT", confirmDelete, "RIGHT", 12, 0)
    page.CancelDelete = cancelDelete

    local function syncReactionDraft()
        local draft = state.draft
        if not draft then return end
        draft.enabled = active:GetChecked() == true
        draft.weight = rounded(weight:GetValue())
        if not draft.templateLocked and draft.entry.type ~= "emote" then
            draft.entry.text = contentEdit:GetText()
            draft.entry.template, draft.entry.choices = nil, nil
        end
    end

    local function renderChance()
        local draft = state.draft
        if not draft or state.mode ~= "event" then return end
        if draft.useChanceOverride then
            local percent = draft.chancePercent
            if not draft.chanceModified and draft.storedChanceOverride ~= nil
                and percent % 1 ~= 0 then
                chanceLabel:SetText("Stored chance: " .. percentText(percent)
                    .. "% (kept unchanged; slider changes use whole percentages)")
            else
                chanceLabel:SetText("Explicit chance: " .. percentText(percent) .. "%")
            end
        else
            local inherited = Data.GetInheritedChance()
            chanceLabel:SetText("Using global chance: "
                .. percentText(inherited * 100) .. "%")
        end
        Widgets.SetEnabled(chanceSlider, draft.useChanceOverride)
    end

    eventEnabled:SetScript("OnClick", function(self)
        if state.refreshing or not state.draft then return end
        state.draft.enabled = self:GetChecked() == true
        state.draft.enabledModified = true
    end)
    eventPriority:SetScript("OnClick", function(self)
        if state.refreshing or not state.draft then return end
        state.draft.priority = self:GetChecked() == true
        state.draft.priorityModified = true
    end)
    chanceOverride:SetScript("OnClick", function(self)
        if state.refreshing or not state.draft then return end
        state.draft.useChanceOverride = self:GetChecked() == true
        state.draft.chanceOverrideModified = true
        renderChance()
    end)
    chanceSlider:SetScript("OnValueChanged", function(_, value)
        if state.refreshing or not state.draft then return end
        state.draft.chancePercent = rounded(value)
        state.draft.chanceModified = true
        renderChance()
    end)
    weight:SetScript("OnValueChanged", function(_, value)
        local valueInteger = rounded(value)
        weightLabel:SetText("Weight: " .. tostring(valueInteger) .. " (1-10)")
        if not state.refreshing and state.draft then state.draft.weight = valueInteger end
    end)

    local function selectType(entryType)
        local draft = state.draft
        if not draft or draft.templateLocked then return end
        if entryType == "emote" then
            if #state.emotes == 0 then
                page:SetMessage("No verified authored emote tokens are available in this catalogue.", true)
                return
            end
            draft.emoteIndex = draft.emoteIndex or 1
            draft.entry = { type = "emote", text = state.emotes[draft.emoteIndex] }
        else
            local oldText = draft.entry.type ~= "emote" and draft.entry.text or ""
            draft.entry = { type = entryType, text = oldText or "" }
        end
        page:RenderReaction()
    end
    for entryType, button in pairs(page.TypeButtons) do
        button:SetScript("OnClick", function() selectType(entryType) end)
    end

    local function updateEmoteMatches(query)
        query = string.lower(type(query) == "string" and query or "")
        state.filteredEmotes = {}
        for _, token in ipairs(state.emotes) do
            if query == "" or string.find(string.lower(token), query, 1, true) then
                state.filteredEmotes[#state.filteredEmotes + 1] = token
            end
        end
        local draft = state.draft
        if draft and draft.entry.type == "emote" and #state.filteredEmotes > 0 then
            local found
            for index, token in ipairs(state.filteredEmotes) do
                if token == draft.entry.text then found = index end
            end
            draft.emoteIndex = found or 1
            if not found then draft.entry.text = state.filteredEmotes[1] end
            emoteToken:SetText("Token: " .. tostring(draft.entry.text))
        elseif draft and draft.entry.type == "emote" then
            emoteToken:SetText("No matching shipped emote token")
        end
        Widgets.SetEnabled(previousEmote, #state.filteredEmotes > 1)
        Widgets.SetEnabled(nextEmote, #state.filteredEmotes > 1)
    end
    emoteSearch:SetScript("OnTextChanged", function(self)
        if not state.refreshing then updateEmoteMatches(self:GetText()) end
    end)

    local function cycleEmote(delta)
        local draft = state.draft
        local emotes = state.filteredEmotes or state.emotes
        if not draft or draft.entry.type ~= "emote" or #emotes == 0 then return end
        local index = (draft.emoteIndex or 1) + delta
        if index < 1 then index = #emotes elseif index > #emotes then index = 1 end
        draft.emoteIndex = index
        draft.entry.text = emotes[index]
        page:RenderReaction()
    end
    previousEmote:SetScript("OnClick", function() cycleEmote(-1) end)
    nextEmote:SetScript("OnClick", function() cycleEmote(1) end)

    function page:RenderReaction()
        local draft = state.draft
        if not draft then return end
        state.refreshing = true
        heading:SetText(draft.mode == "edit" and "Edit Custom Reaction"
            or draft.mode == "copy" and "Create Modified Copy" or "Add Custom Reaction")
        scopeText:SetText("Scope: " .. tostring(draft.groupLabel or "Selected group"))
        for entryType, button in pairs(self.TypeButtons) do
            Widgets.SetEnabled(button, not draft.templateLocked and draft.entry.type ~= entryType)
        end
        local emoteMode = draft.entry.type == "emote"
        if emoteMode then
            contentEdit:Hide(); previousEmote:Show(); nextEmote:Show(); emoteToken:Show()
            emoteSearch:Show(); emoteSearchHelp:Show()
            local found = 1
            for index, token in ipairs(state.emotes) do if token == draft.entry.text then found = index end end
            draft.emoteIndex = found
            emoteToken:SetText("Token: " .. tostring(draft.entry.text))
            updateEmoteMatches(emoteSearch:GetText())
        else
            contentEdit:Show(); previousEmote:Hide(); nextEmote:Hide(); emoteToken:Hide()
            emoteSearch:Hide(); emoteSearchHelp:Hide()
            contentEdit:SetText(draft.entry.text or draft.entry.template or "")
            Widgets.SetEnabled(contentEdit, not draft.templateLocked)
        end
        if draft.templateLocked then
            templateNote:SetText("Template-based content is preserved exactly; text and type are read-only in this editor.")
        else
            templateNote:SetText(emoteMode
                and "Choose from emote tokens already authored in the shipped catalogue. Preview never executes it."
                or "Long content is retained in full; validation runs before preview or save.")
        end
        active:SetChecked(draft.enabled == true)
        weight:SetValue(draft.weight)
        weightLabel:SetText("Weight: " .. tostring(draft.weight) .. " (1-10)")
        if draft.mode == "edit" then deleteButton:Show() else deleteButton:Hide() end
        state.refreshing = false
    end

    function page:OpenEvent(group)
        local draft, err = Data.NewEventDraft(group)
        if not draft then return false, err end
        state.mode, state.draft = "event", draft
        heading:SetText("Modify Event / Ability")
        scopeText:SetText("Configuration: " .. tostring(group.label))
        state.refreshing = true
        eventEnabled:SetChecked(draft.enabled)
        eventPriority:SetChecked(draft.priority)
        chanceOverride:SetChecked(draft.useChanceOverride)
        chanceSlider:SetValue(draft.chancePercent)
        state.refreshing = false
        renderChance()
        eventPanel:Show(); reactionPanel:Hide(); confirmPanel:Hide()
        self:SetMessage("")
        return true
    end

    function page:OpenReaction(group, reaction, mode, context)
        local draft, err = Data.NewReactionDraft(group, reaction, mode)
        if not draft then return false, err end
        state.mode, state.draft, state.context = "reaction", draft, context
        state.emotes = Data.ListEmoteTokens()
        if draft.entry.type == "emote" then
            local present = false
            for _, token in ipairs(state.emotes) do if token == draft.entry.text then present = true end end
            if not present then
                state.emotes[#state.emotes + 1] = draft.entry.text
                table.sort(state.emotes)
            end
        end
        state.filteredEmotes = state.emotes
        emoteSearch:SetText("")
        if draft.entry.type == "emote" then
            for index, token in ipairs(state.emotes) do
                if token == draft.entry.text then draft.emoteIndex = index end
            end
        end
        eventPanel:Hide(); reactionPanel:Show(); confirmPanel:Hide()
        self.PreviewText:SetText("")
        self:SetMessage("")
        self:RenderReaction()
        return true
    end

    eventSave:SetScript("OnClick", function()
        local draft = state.draft
        if not draft then return end
        draft.enabled = eventEnabled:GetChecked() == true
        draft.priority = eventPriority:GetChecked() == true
        local ok = Data.SaveEventDraft(draft)
        if ok then
            if type(callbacks.onSaved) == "function" then callbacks.onSaved() end
        else
            page:SetMessage("Those event settings could not be saved. Existing values were preserved.", true)
        end
    end)
    eventCancel:SetScript("OnClick", function()
        if type(callbacks.onCancel) == "function" then callbacks.onCancel() end
    end)

    preview:SetScript("OnClick", function()
        syncReactionDraft()
        local text, err = Data.Preview(state.draft, state.context)
        if text then
            previewText:SetText(text); page:SetMessage("Private preview only; nothing was transmitted.")
        else
            previewText:SetText("[Preview unavailable]")
            page:SetMessage("Preview failed: " .. tostring(err)
                .. ". Unresolved context is not invented and nothing was transmitted.", true)
        end
    end)
    save:SetScript("OnClick", function()
        syncReactionDraft()
        local id, err = Data.SaveReaction(state.draft)
        if id then
            if type(callbacks.onSaved) == "function" then callbacks.onSaved(id) end
        else
            page:SetMessage("Reaction could not be saved: " .. tostring(err) .. ". Draft retained.", true)
        end
    end)
    cancel:SetScript("OnClick", function()
        if contentEdit.ClearFocus then contentEdit:ClearFocus() end
        if type(callbacks.onCancel) == "function" then callbacks.onCancel() end
    end)
    deleteButton:SetScript("OnClick", function()
        reactionPanel:Hide(); confirmPanel:Show()
    end)
    cancelDelete:SetScript("OnClick", function()
        confirmPanel:Hide(); reactionPanel:Show()
    end)
    confirmDelete:SetScript("OnClick", function()
        local ok, err = Data.DeleteReaction(state.draft)
        if ok then
            if type(callbacks.onSaved) == "function" then callbacks.onSaved(nil, true) end
        else
            confirmPanel:Hide(); reactionPanel:Show()
            page:SetMessage("Reaction was not deleted: " .. tostring(err) .. ".", true)
        end
    end)

    function page:GetDraft() return state.draft end
    function page:GetMode() return state.mode end

    eventPanel:Hide(); reactionPanel:Hide(); confirmPanel:Hide()
    return page
end
