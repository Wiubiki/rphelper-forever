RPHelper = RPHelper or {}
RPHelper.GuidePage = RPHelper.GuidePage or {}
local GuidePage = RPHelper.GuidePage

local Widgets = RPHelper.UIWidgets

local sections = {
    {
        id = "getting_started",
        label = "Getting Started",
        title = "Getting Started",
        pages = {
            "RPHelper Forever adds occasional contextual sayings and emotes when supported gameplay events occur. It is designed to add roleplaying flavour without turning chat into a combat log.\n\nType /rph to open or close this window. The X button also closes it. On Main, Enable RPHelper is the master switch for automatic reactions.",
            "For a supported event, RPHelper checks the master and event switches, quota, cooldown or Priority, and chance. It then builds the eligible reactions, applies their relative weights, and routes the selected type for the current activity.\n\nA reaction is never guaranteed for every event. Chance, cooldown, quota, unavailable detection, ineligible content, activity restrictions, or failed output can all suppress one safely.",
        },
    },
    {
        id = "global_settings",
        label = "Global Settings",
        title = "Global Settings",
        pages = {
            "Reaction chance is the baseline probability for supported events without their own override. It defaults to 5% and can be set from 0% to 20%.\n\nCooldown is shared by automatic reactions. It defaults to 20 seconds and can be set from 5 to 120 seconds. Only a successfully emitted non-Priority reaction starts or resets it.",
            "Encounter quota is off by default. When enabled, it allows 1 to 10 successful automatic reactions per encounter; its initial retained value is 2. Priority reactions still count.\n\nDungeon Say routing broadcasts in /say by default, or can use local display only. Every setting and all library content are specific to this character.",
        },
    },
    {
        id = "library",
        label = "Character Library",
        title = "Character Library",
        pages = {
            "The Library groups this character's content into Generic, Race, and Class sections. Groups represent gameplay events, class abilities, and applicable Druid-form content.\n\nBuilt-in reactions ship with the addon and are read-only. Custom reactions belong to this character. Either kind can be individually enabled or disabled.",
            "Weight is an integer from 1 to 10 and defaults to 1. It is a relative selection weight among reactions that are already eligible; it does not change event chance.\n\nSupported groups have a runtime detector and editable event settings. Not currently detected means the catalogue can be browsed and customized, but RPHelper has no supported automatic detector for that group. Catalogue abilities are not automatically detected merely because they are listed.",
        },
    },
    {
        id = "event_policies",
        label = "Events & Priority",
        title = "Event and Ability Policies",
        pages = {
            "Supported events and abilities can be enabled or disabled. Their optional chance override replaces the global chance; it never multiplies it. Clear the override to inherit the current global chance again.\n\nUntouched settings remain inherited. Explicit choices, including values equal to current defaults, remain character-specific across supported addon updates.",
            "Priority bypasses only the shared global cooldown. It does not bypass chance, quota, enabled state, reaction eligibility, activity rules, or routing restrictions.\n\nA successful Priority reaction does not start, reset, extend, or otherwise change the global cooldown. It still counts toward an enabled encounter quota.",
        },
    },
    {
        id = "custom_reactions",
        label = "Custom Reactions",
        title = "Custom Reactions",
        pages = {
            "Custom types are Say, Emote, and Custom Emote. Say is spoken text subject to routing rules. Emote uses a standard Blizzard emote token. Custom Emote is free-text /e-style action text.\n\nYou can create, edit, preview, and delete Custom reactions. Deletion always asks for confirmation.",
            "Create Modified Copy starts a new Custom reaction from a Built-in one. The Built-in original remains unchanged and keeps its activation and weight.\n\nPreview is local-only: it never broadcasts chat or emotes and never consumes chance, cooldown, or quota. Structured template/choice content is preserved, but its text and type currently have limited editing support. A preview may be unavailable when required placeholder context cannot be resolved safely.",
        },
    },
    {
        id = "chat_restrictions",
        label = "Chat & Restrictions",
        title = "Chat Behaviour and Restrictions",
        pages = {
            "Open world: Say reactions use an RPHelper-prefixed local chat display visible only to you. They are not sent to other players and do not create an in-world speech bubble. Emote and Custom Emote use native game output when allowed and may be visible to nearby players.\n\nFive-player instances: Say broadcasts to nearby players in /say by default. The Main setting can route only Say to local display instead; it does not change either emote type.",
            "Raids: every automatic RPHelper output is suppressed before normal reaction processing. This is not configurable.\n\nDruids: while shapeshifted, Built-in and Custom Say reactions are ineligible. Emote and Custom Emote remain eligible.\n\nLocal display always means text shown only to this player. RPHelper does not currently implement genuine character-attached local speech bubbles.",
        },
    },
    {
        id = "troubleshooting",
        label = "Help & Glossary",
        title = "Troubleshooting and Glossary",
        pages = {
            "Why didn't my reaction trigger?\nCheck the master switch, the event and reaction switches, chance, cooldown, quota, eligible content, current activity, and output restrictions. The event may also lack a supported detector.\n\nWhy is a group Not currently detected?\nIts catalogue content exists, but no supported runtime detector or verified mapping currently activates it automatically.",
            "Why can't I edit a Built-in reaction directly?\nShipped content is immutable so addon updates remain safe. Use Create Modified Copy for an independent Custom version.\n\nWhy did preview reject a placeholder reaction?\nPreview does not invent missing target, unit, or form context. Try again when the required context is safely available.\n\nWhere is my data?\nSettings and Custom reactions are stored per character in RPHelperDB SavedVariables.",
            "Chance: probability that an otherwise permitted event continues. Cooldown: shared minimum time between successful non-Priority automatic outputs. Priority: bypasses only that cooldown.\n\nQuota: optional cap on successful automatic outputs in one encounter. Weight: relative likelihood among eligible reactions, from 1 to 10. Custom Emote: free-text /e-style action.\n\nFor issue reports include the addon version, event, activity, class/race, reproduction steps, and any errors. Support: github.com/Wiubiki/rphelper-forever/issues",
        },
    },
}

function GuidePage.GetSections()
    return sections
end

function GuidePage.Create(parent, callbacks)
    callbacks = callbacks or {}
    local page = CreateFrame("Frame", nil, parent)
    page:SetAllPoints(parent)
    local state = { section = 1, contentPage = 1 }

    local heading = Widgets.CreateText(page, "GameFontNormalLarge", "Guide", 300)
    heading:SetPoint("TOPLEFT", 0, 0)

    local back = Widgets.CreateButton(page, "Back to Main", 130, 24)
    back:SetPoint("TOPRIGHT", 0, 4)
    back:SetScript("OnClick", function()
        if type(callbacks.onBack) == "function" then callbacks.onBack() end
    end)
    page.BackButton = back

    page.SectionButtons = {}
    for index, section in ipairs(sections) do
        local button = Widgets.CreateButton(page, section.label, 172, 27)
        button:SetPoint("TOPLEFT", 0, -42 - ((index - 1) * 31))
        button:SetScript("OnClick", function()
            state.section, state.contentPage = index, 1
            page:Render()
        end)
        page.SectionButtons[index] = button
    end

    local sectionTitle = Widgets.CreateText(page, "GameFontNormalLarge", "", 450)
    sectionTitle:SetPoint("TOPLEFT", 196, -42)
    page.SectionTitle = sectionTitle

    local body = Widgets.CreateText(page, "GameFontHighlightSmall", "", 450)
    body:SetPoint("TOPLEFT", 196, -78)
    if body.SetHeight then body:SetHeight(380) end
    if body.SetJustifyV then body:SetJustifyV("TOP") end
    page.Body = body

    local previous = Widgets.CreateButton(page, "Previous", 90, 24)
    previous:SetPoint("TOPLEFT", 196, -475)
    previous:SetScript("OnClick", function()
        if state.contentPage > 1 then
            state.contentPage = state.contentPage - 1
            page:Render()
        end
    end)
    page.Previous = previous

    local pageText = Widgets.CreateText(page, "GameFontHighlightSmall", "", 110)
    pageText:SetPoint("LEFT", previous, "RIGHT", 10, 0)
    page.PageText = pageText

    local nextButton = Widgets.CreateButton(page, "Next", 90, 24)
    nextButton:SetPoint("TOPRIGHT", 0, -475)
    nextButton:SetScript("OnClick", function()
        local section = sections[state.section]
        if state.contentPage < #section.pages then
            state.contentPage = state.contentPage + 1
            page:Render()
        end
    end)
    page.Next = nextButton

    function page:Render()
        local section = sections[state.section]
        if state.contentPage > #section.pages then state.contentPage = #section.pages end
        if state.contentPage < 1 then state.contentPage = 1 end
        sectionTitle:SetText(section.title)
        body:SetText(section.pages[state.contentPage])
        pageText:SetText("Page " .. tostring(state.contentPage) .. " of " .. tostring(#section.pages))
        Widgets.SetEnabled(previous, state.contentPage > 1)
        Widgets.SetEnabled(nextButton, state.contentPage < #section.pages)
        for index, button in ipairs(self.SectionButtons) do
            Widgets.SetEnabled(button, index ~= state.section)
        end
    end

    function page:Refresh()
        self:Render()
    end

    function page:GetSectionCount() return #sections end
    function page:GetCurrentSection() return state.section end
    function page:GetCurrentContentPage() return state.contentPage end
    function page:GetCurrentPageCount() return #sections[state.section].pages end

    page:Render()
    return page
end
