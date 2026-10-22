RPHelper = RPHelper or {}
RPHelper.LibraryPage = RPHelper.LibraryPage or {}
local LibraryPage = RPHelper.LibraryPage

local Data = RPHelper.LibraryData
local EditorData = RPHelper.LibraryEditorData
local Widgets = RPHelper.UIWidgets

local GROUP_ROWS = 9
local REACTION_ROWS = 5

local function pagesFor(count, pageSize)
    return math.max(1, math.ceil(count / pageSize))
end

local function clamp(value, minimum, maximum)
    if value < minimum then return minimum end
    if value > maximum then return maximum end
    return value
end

local function chanceText(chance)
    if type(chance) ~= "number" then return "Unavailable" end
    return tostring(math.floor(chance * 100 + 0.5)) .. "%"
end

local function enabledText(value)
    return value and "Enabled" or "Disabled"
end

local function paginateText(text, limit)
    local result, current = {}, ""
    for word in string.gmatch(text or "", "%S+%s*") do
        if current ~= "" and string.len(current) + string.len(word) > limit then
            result[#result + 1] = current
            current = word
        else
            current = current .. word
        end
    end
    if current ~= "" then result[#result + 1] = current end
    if #result == 0 then result[1] = "" end
    return result
end

function LibraryPage.Create(parent, callbacks)
    callbacks = callbacks or {}
    local page = CreateFrame("Frame", nil, parent)
    page:SetAllPoints(parent)

    local state = {
        section = "generic",
        model = nil,
        groupPage = 1,
        reactionPage = 1,
        selectedBySection = {},
        detailReactionID = nil,
        detailPage = 1,
        refreshing = false,
    }

    local heading = Widgets.CreateText(page, "GameFontNormalLarge", "Character Library", 300)
    heading:SetPoint("TOPLEFT", 0, 0)

    local back = Widgets.CreateButton(page, "Back to Main", 130, 24)
    back:SetPoint("TOPRIGHT", 0, 4)
    back:SetScript("OnClick", function()
        if type(callbacks.onBack) == "function" then callbacks.onBack() end
    end)
    page.BackButton = back

    page.SectionButtons = {}
    for index, definition in ipairs({
        { "generic", "Generic" },
        { "race", "Race" },
        { "class", "Class" },
    }) do
        local section, label = definition[1], definition[2]
        local button = Widgets.CreateButton(page, label, 105, 24)
        button:SetPoint("TOPLEFT", (index - 1) * 110, -34)
        button:SetScript("OnClick", function() page:SelectSection(section) end)
        page.SectionButtons[section] = button
    end

    local contextText = Widgets.CreateText(page, "GameFontHighlightSmall", "", 650)
    contextText:SetPoint("TOPLEFT", 0, -66)
    page.ContextText = contextText

    local groupHeading = Widgets.CreateText(page, "GameFontNormal", "Events and abilities", 200)
    groupHeading:SetPoint("TOPLEFT", 0, -94)

    page.GroupButtons = {}
    for index = 1, GROUP_ROWS do
        local button = Widgets.CreateButton(page, "", 205, 26)
        button:SetPoint("TOPLEFT", 0, -116 - ((index - 1) * 30))
        button:SetScript("OnClick", function(self)
            if self.GroupID then page:SelectGroup(self.GroupID) end
        end)
        page.GroupButtons[index] = button
    end

    local previousGroups = Widgets.CreateButton(page, "<", 30, 22)
    previousGroups:SetPoint("TOPLEFT", 0, -393)
    previousGroups:SetScript("OnClick", function()
        if state.groupPage > 1 then state.groupPage = state.groupPage - 1; page:Render() end
    end)
    page.PreviousGroups = previousGroups

    local groupPageText = Widgets.CreateText(page, "GameFontHighlightSmall", "", 110)
    groupPageText:SetPoint("LEFT", previousGroups, "RIGHT", 7, 0)
    page.GroupPageText = groupPageText

    local nextGroups = Widgets.CreateButton(page, ">", 30, 22)
    nextGroups:SetPoint("TOPLEFT", 175, -393)
    nextGroups:SetScript("OnClick", function()
        local count = state.model and #state.model.groups or 0
        if state.groupPage < pagesFor(count, GROUP_ROWS) then
            state.groupPage = state.groupPage + 1
            page:Render()
        end
    end)
    page.NextGroups = nextGroups

    local groupTitle = Widgets.CreateText(page, "GameFontNormalLarge", "", 205)
    groupTitle:SetPoint("TOPLEFT", 225, -94)
    page.GroupTitle = groupTitle

    local modifyGroup = Widgets.CreateButton(page, "Modify Event", 100, 22)
    modifyGroup:SetPoint("TOPLEFT", 440, -94)
    modifyGroup:SetScript("OnClick", function()
        local group = page:GetSelectedGroup()
        if group and group.settings and group.settings.supported
            and type(callbacks.onModifyGroup) == "function" then callbacks.onModifyGroup(group) end
    end)
    page.ModifyGroup = modifyGroup

    local addReaction = Widgets.CreateButton(page, "Add Custom", 100, 22)
    addReaction:SetPoint("TOPLEFT", 550, -94)
    addReaction:SetScript("OnClick", function()
        local group = page:GetSelectedGroup()
        if group and type(callbacks.onAddReaction) == "function" then callbacks.onAddReaction(group) end
    end)
    page.AddReaction = addReaction

    local eventState = Widgets.CreateText(page, "GameFontHighlightSmall", "", 425)
    eventState:SetPoint("TOPLEFT", 225, -120)
    page.EventState = eventState

    page.ReactionRows = {}
    for index = 1, REACTION_ROWS do
        local row = CreateFrame("Frame", nil, page)
        Widgets.SetSize(row, 425, 47)
        row:SetPoint("TOPLEFT", 225, -151 - ((index - 1) * 49))

        local checkBox = Widgets.CreateCheckBox(row, "")
        checkBox:SetPoint("TOPLEFT", -4, 2)
        row.CheckBox = checkBox

        local metadata = Widgets.CreateText(row, "GameFontNormal", "", 220)
        metadata:SetPoint("TOPLEFT", 28, 0)
        row.Metadata = metadata

        local text = Widgets.CreateText(row, "GameFontHighlightSmall", "", 255)
        text:SetPoint("TOPLEFT", 28, -20)
        row.Summary = text

        local inspect = Widgets.CreateButton(row, "View", 65, 21)
        inspect:SetPoint("TOPRIGHT", 0, 1)
        inspect:SetScript("OnClick", function()
            if row.Reaction then
                state.detailReactionID = row.Reaction.id
                state.detailPage = 1
                page:RenderDetail()
            end
        end)
        row.Inspect = inspect

        local modify = Widgets.CreateButton(row, "Modify", 65, 21)
        modify:SetPoint("TOPRIGHT", 0, -23)
        modify:SetScript("OnClick", function()
            local group = page:GetSelectedGroup()
            if group and row.Reaction and type(callbacks.onModifyReaction) == "function" then
                local mode = row.Reaction.provenance == "Built-in" and "copy" or "edit"
                callbacks.onModifyReaction(group, row.Reaction, mode)
            end
        end)
        row.Modify = modify

        local weightDown = Widgets.CreateButton(row, "-", 22, 20)
        weightDown:SetPoint("TOPLEFT", 252, 1)
        row.WeightDown = weightDown
        local weightUp = Widgets.CreateButton(row, "+", 22, 20)
        weightUp:SetPoint("LEFT", weightDown, "RIGHT", 3, 0)
        row.WeightUp = weightUp
        local function changeWeight(delta)
            if not row.Reaction then return end
            local desired = clamp((row.Reaction.weight or 1) + delta, 1, 10)
            if desired == row.Reaction.weight then return end
            state.detailReactionID = row.Reaction.id
            local ok = EditorData.SetReactionWeight(row.Reaction, desired)
            page:RefreshLibrary()
            if not ok then
                page:SetMessage("That weight change could not be saved. The effective value was restored.", true)
            end
        end
        weightDown:SetScript("OnClick", function() changeWeight(-1) end)
        weightUp:SetScript("OnClick", function() changeWeight(1) end)

        checkBox:SetScript("OnClick", function(self)
            if state.refreshing or not row.Reaction then return end
            state.detailReactionID = row.Reaction.id
            state.detailPage = 1
            local ok = Data.SetReactionEnabled(row.Reaction, self:GetChecked() == true)
            page:RefreshLibrary()
            if not ok then
                page:SetMessage("That activation change could not be saved. The displayed state was restored.", true)
            end
        end)
        page.ReactionRows[index] = row
    end

    local previousReactions = Widgets.CreateButton(page, "<", 30, 22)
    previousReactions:SetPoint("TOPLEFT", 225, -397)
    previousReactions:SetScript("OnClick", function()
        if state.reactionPage > 1 then
            state.reactionPage = state.reactionPage - 1
            page:Render()
        end
    end)
    page.PreviousReactions = previousReactions

    local reactionPageText = Widgets.CreateText(page, "GameFontHighlightSmall", "", 120)
    reactionPageText:SetPoint("LEFT", previousReactions, "RIGHT", 7, 0)
    page.ReactionPageText = reactionPageText

    local nextReactions = Widgets.CreateButton(page, ">", 30, 22)
    nextReactions:SetPoint("TOPLEFT", 620, -397)
    nextReactions:SetScript("OnClick", function()
        local group = page:GetSelectedGroup()
        local count = group and #group.reactions or 0
        if state.reactionPage < pagesFor(count, REACTION_ROWS) then
            state.reactionPage = state.reactionPage + 1
            page:Render()
        end
    end)
    page.NextReactions = nextReactions

    local detailHeading = Widgets.CreateText(page, "GameFontNormal", "Selected reaction", 425)
    detailHeading:SetPoint("TOPLEFT", 225, -431)

    local detailText = Widgets.CreateText(page, "GameFontHighlightSmall", "", 425)
    detailText:SetPoint("TOPLEFT", 225, -451)
    if detailText.SetHeight then detailText:SetHeight(54) end
    if detailText.SetJustifyV then detailText:SetJustifyV("TOP") end
    page.DetailText = detailText

    local previousDetail = Widgets.CreateButton(page, "<", 30, 20)
    previousDetail:SetPoint("TOPLEFT", 225, -507)
    previousDetail:SetScript("OnClick", function()
        if state.detailPage > 1 then state.detailPage = state.detailPage - 1; page:RenderDetail() end
    end)
    page.PreviousDetail = previousDetail

    local detailPageText = Widgets.CreateText(page, "GameFontHighlightSmall", "", 120)
    detailPageText:SetPoint("LEFT", previousDetail, "RIGHT", 7, 0)
    page.DetailPageText = detailPageText

    local nextDetail = Widgets.CreateButton(page, ">", 30, 20)
    nextDetail:SetPoint("TOPLEFT", 620, -507)
    nextDetail:SetScript("OnClick", function()
        local detailPages = page.DetailPages or { "" }
        if state.detailPage < #detailPages then state.detailPage = state.detailPage + 1; page:RenderDetail() end
    end)
    page.NextDetail = nextDetail

    local message = Widgets.CreateText(page, "GameFontHighlightSmall", "", 205)
    message:SetPoint("TOPLEFT", 0, -431)
    if message.SetHeight then message:SetHeight(70) end
    if message.SetJustifyV then message:SetJustifyV("TOP") end
    page.Message = message

    function page:SetMessage(text, isError)
        self.Message:SetText(text or "")
        if self.Message.SetTextColor then
            if isError then self.Message:SetTextColor(1, 0.25, 0.25)
            else self.Message:SetTextColor(0.7, 0.7, 0.7) end
        end
    end

    function page:GetSelectedGroup()
        local id = state.selectedBySection[state.section]
        return Data.FindGroup(state.model, id)
    end

    function page:RenderDetail()
        local group = self:GetSelectedGroup()
        local selected
        if group then
            for _, reaction in ipairs(group.reactions) do
                if reaction.id == state.detailReactionID then selected = reaction end
            end
            selected = selected or group.reactions[1]
        end
        if not selected then
            state.detailReactionID = nil
            state.detailPage = 1
            self.DetailPages = { "Select a reaction to inspect its full authored content." }
            self.DetailText:SetText("Select a reaction to inspect its full authored content.")
            self.DetailPageText:SetText("Details 1 / 1")
            Widgets.SetEnabled(self.PreviousDetail, false)
            Widgets.SetEnabled(self.NextDetail, false)
            return
        end
        state.detailReactionID = selected.id
        self.DetailPages = paginateText(selected.typeLabel .. " | " .. selected.provenance .. " | "
            .. enabledText(selected.enabled) .. " | Weight " .. tostring(selected.weight) .. "\n"
            .. selected.text, 220)
        state.detailPage = clamp(state.detailPage, 1, #self.DetailPages)
        self.DetailText:SetText(self.DetailPages[state.detailPage])
        self.DetailPageText:SetText("Details " .. tostring(state.detailPage) .. " / "
            .. tostring(#self.DetailPages))
        Widgets.SetEnabled(self.PreviousDetail, state.detailPage > 1)
        Widgets.SetEnabled(self.NextDetail, state.detailPage < #self.DetailPages)
    end

    function page:Render()
        local model = state.model or { groups = {}, context = {} }
        local context = model.context or {}
        self.ContextText:SetText("Character context: " .. (context.race or "Race unavailable")
            .. " / " .. (context.class or "Class unavailable"))
        for name, button in pairs(self.SectionButtons) do
            Widgets.SetEnabled(button, name ~= state.section)
        end

        local groupPages = pagesFor(#model.groups, GROUP_ROWS)
        state.groupPage = clamp(state.groupPage, 1, groupPages)
        self.GroupPageText:SetText("Groups " .. tostring(state.groupPage) .. " / " .. tostring(groupPages))
        Widgets.SetEnabled(self.PreviousGroups, state.groupPage > 1)
        Widgets.SetEnabled(self.NextGroups, state.groupPage < groupPages)
        local groupStart = (state.groupPage - 1) * GROUP_ROWS
        for index, button in ipairs(self.GroupButtons) do
            local group = model.groups[groupStart + index]
            button.GroupID = group and group.id or nil
            if group then
                button:SetText(group.label .. " (" .. tostring(#group.reactions) .. ")")
                button:Show()
                Widgets.SetEnabled(button, state.selectedBySection[state.section] ~= group.id)
            else
                button:Hide()
            end
        end

        local group = self:GetSelectedGroup()
        if not group then
            self.GroupTitle:SetText("No group selected")
            self.EventState:SetText("")
            Widgets.SetEnabled(self.ModifyGroup, false)
            Widgets.SetEnabled(self.AddReaction, false)
        else
            self.GroupTitle:SetText(group.label)
            local settings = group.settings or {}
            Widgets.SetEnabled(self.ModifyGroup, settings.supported == true)
            Widgets.SetEnabled(self.AddReaction, true)
            if settings.supported then
                self.EventState:SetText(enabledText(settings.enabled) .. " | Effective chance "
                    .. chanceText(settings.chance) .. " | Priority "
                    .. (settings.priority and "On" or "Off") .. " | Runtime detector supported")
            else
                self.EventState:SetText("Not currently detected | Event settings unavailable")
            end
        end

        local reactions = group and group.reactions or {}
        local reactionPages = pagesFor(#reactions, REACTION_ROWS)
        state.reactionPage = clamp(state.reactionPage, 1, reactionPages)
        self.ReactionPageText:SetText("Reactions " .. tostring(state.reactionPage)
            .. " / " .. tostring(reactionPages))
        Widgets.SetEnabled(self.PreviousReactions, state.reactionPage > 1)
        Widgets.SetEnabled(self.NextReactions, state.reactionPage < reactionPages)
        local reactionStart = (state.reactionPage - 1) * REACTION_ROWS
        state.refreshing = true
        for index, row in ipairs(self.ReactionRows) do
            local reaction = reactions[reactionStart + index]
            row.Reaction = reaction
            if reaction then
                row.CheckBox:SetChecked(reaction.enabled == true)
                Widgets.SetEnabled(row.CheckBox, reaction.canActivate == true)
                row.Metadata:SetText(reaction.typeLabel .. " | " .. reaction.provenance
                    .. " | Weight " .. tostring(reaction.weight))
                row.Modify:SetText("Modify")
                row.Summary:SetText(reaction.summary)
                row:Show()
            else
                row:Hide()
            end
        end
        state.refreshing = false
        self:RenderDetail()

        local note = model.warning or model.emptyMessage or ""
        self:SetMessage(note, model.warning ~= nil)
    end

    function page:RefreshLibrary()
        local previousGroup = state.selectedBySection[state.section]
        local model, err = Data.BuildSection(state.section)
        state.model = model or { groups = {}, context = {}, emptyMessage = tostring(err or "Library unavailable.") }
        local selected = Data.FindGroup(state.model, previousGroup)
        if not selected then
            selected = state.model.groups[1]
            state.selectedBySection[state.section] = selected and selected.id or nil
            state.groupPage = 1
            state.reactionPage = 1
            state.detailReactionID = nil
            state.detailPage = 1
        end
        self:Render()
    end

    function page:SelectSection(section)
        if section ~= "generic" and section ~= "race" and section ~= "class" then return false end
        state.section = section
        state.groupPage = 1
        state.reactionPage = 1
        state.detailReactionID = nil
        state.detailPage = 1
        self:RefreshLibrary()
        return true
    end

    function page:SelectGroup(id)
        local group = Data.FindGroup(state.model, id)
        if not group then return false end
        state.selectedBySection[state.section] = id
        state.reactionPage = 1
        state.detailReactionID = group.reactions[1] and group.reactions[1].id or nil
        state.detailPage = 1
        self:Render()
        return true
    end

    function page:GetModel() return state.model end
    function page:GetSection() return state.section end
    function page:GetVisibleReactionCount()
        local count = 0
        for _, row in ipairs(self.ReactionRows) do if row:IsShown() then count = count + 1 end end
        return count
    end

    page:RefreshLibrary()
    return page
end
