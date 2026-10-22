RPHelper = RPHelper or {}
RPHelper.LibraryEditorData = RPHelper.LibraryEditorData or {}
local EditorData = RPHelper.LibraryEditorData

local Config = RPHelper.Configuration
local UserContent = RPHelper.UserContent
local ContentEngine = RPHelper.ContentEngine

local function copy(value, seen)
    if type(value) ~= "table" then return value end
    seen = seen or {}
    if seen[value] then return seen[value] end
    local result = {}
    seen[value] = result
    for key, child in pairs(value) do result[key] = copy(child, seen) end
    return result
end

local function validGroup(group)
    return type(group) == "table" and type(group.scope) == "table"
end

function EditorData.NewReactionDraft(group, reaction, mode)
    if not validGroup(group) then return nil, "invalid_scope" end
    if mode ~= "create" and mode ~= "edit" and mode ~= "copy" then
        return nil, "invalid_mode"
    end
    if mode ~= "create" and type(reaction) ~= "table" then return nil, "invalid_reaction" end
    if mode == "edit" and reaction.provenance ~= "Custom" then return nil, "immutable_builtin" end
    if mode == "copy" and reaction.provenance ~= "Built-in" then return nil, "invalid_reaction" end

    local entry
    if reaction then entry = copy(reaction.entry) else entry = { type = "say", text = "" } end
    if type(entry) ~= "table" then return nil, "invalid_entry" end
    local enabled = true
    if reaction then enabled = reaction.enabled ~= false end
    return {
        mode = mode,
        id = mode == "edit" and reaction.id or nil,
        sourceDefaultID = mode == "copy" and reaction.id or nil,
        scope = copy(group.scope),
        groupLabel = group.label,
        entry = entry,
        enabled = enabled,
        weight = reaction and reaction.weight or 1,
        templateLocked = type(entry.template) == "string",
    }
end

function EditorData.SaveReaction(draft)
    if type(draft) ~= "table" or type(draft.scope) ~= "table"
        or type(draft.entry) ~= "table" then return nil, "invalid_draft" end
    if type(draft.enabled) ~= "boolean" then return nil, "invalid_enabled" end
    if not Config.IsValidWeight(draft.weight) then return nil, "invalid_weight" end
    local valid, err = ContentEngine.ValidateEntry(draft.entry)
    if not valid then return nil, err end
    local metadata = { enabled = draft.enabled, weight = draft.weight }
    if draft.mode == "create" then
        return UserContent.Add(draft.scope, draft.entry, metadata)
    end
    if draft.mode == "copy" then
        return UserContent.CreateModifiedCopy(draft.sourceDefaultID, draft.scope, draft.entry, metadata)
    end
    if draft.mode == "edit" then
        local ok, editErr = UserContent.Edit(draft.id, draft.scope, draft.entry, metadata)
        return ok and draft.id or nil, editErr
    end
    return nil, "invalid_mode"
end

function EditorData.DeleteReaction(draft)
    if type(draft) ~= "table" or draft.mode ~= "edit" or type(draft.id) ~= "string" then
        return false, "invalid_reaction"
    end
    return UserContent.Remove(draft.id)
end

function EditorData.SetReactionWeight(reaction, weight)
    if type(reaction) ~= "table" or not Config.IsValidWeight(weight) then
        return false, "invalid_weight"
    end
    if reaction.provenance == "Built-in" then
        if weight == 1 then return Config.ResetDefaultWeight(reaction.id) end
        return Config.SetDefaultWeight(reaction.id, weight)
    end
    if reaction.provenance == "Custom" then return UserContent.SetWeight(reaction.id, weight) end
    return false, "invalid_reaction"
end

function EditorData.NewEventDraft(group)
    local settings = type(group) == "table" and group.settings
    if type(settings) ~= "table" or not settings.supported then return nil, "unsupported_group" end
    local storedChanceOverride = settings.chanceOverride
    local inheritedChance = Config.GetSetting("reactionChance") or 0
    local enabled = settings.enabled == true
    local priority = settings.priority == true
    local useChanceOverride = storedChanceOverride ~= nil
    local chancePercent = (storedChanceOverride or inheritedChance) * 100
    return {
        group = group,
        enabled = enabled,
        priority = priority,
        useChanceOverride = useChanceOverride,
        storedChanceOverride = storedChanceOverride,
        chancePercent = chancePercent,
        originalEnabled = enabled,
        originalPriority = priority,
        originalUseChanceOverride = useChanceOverride,
        originalChancePercent = chancePercent,
        enabledModified = false,
        priorityModified = false,
        chanceOverrideModified = false,
        chanceModified = false,
    }
end

function EditorData.GetInheritedChance()
    return Config.GetSetting("reactionChance") or 0
end

function EditorData.SaveEventDraft(draft)
    local settings = type(draft) == "table" and type(draft.group) == "table"
        and draft.group.settings
    if type(settings) ~= "table" or not settings.supported then return false, "unsupported_group" end
    if type(draft.useChanceOverride) ~= "boolean" then return false, "invalid_value" end
    local enabledChanged = draft.enabledModified == true or draft.enabled ~= draft.originalEnabled
    local priorityChanged = draft.priorityModified == true or draft.priority ~= draft.originalPriority
    local chanceChanged = draft.chanceModified == true or draft.chanceOverrideModified == true
        or draft.useChanceOverride ~= draft.originalUseChanceOverride
        or draft.chancePercent ~= draft.originalChancePercent
    local changes = {}
    if enabledChanged then
        if type(draft.enabled) ~= "boolean" then return false, "invalid_value" end
        changes.enabled = draft.enabled
    end
    if priorityChanged then
        if type(draft.priority) ~= "boolean" then return false, "invalid_value" end
        changes.priority = draft.priority
    end
    if chanceChanged then
        if draft.useChanceOverride then
            local chance
            if not draft.chanceModified and draft.storedChanceOverride ~= nil then
                chance = draft.storedChanceOverride
                if type(chance) ~= "number" or chance ~= chance or chance < 0 or chance > 1 then
                    return false, "invalid_value"
                end
            else
                if type(draft.chancePercent) ~= "number" or draft.chancePercent ~= draft.chancePercent
                    or draft.chancePercent < 0 or draft.chancePercent > 100
                    or draft.chancePercent % 1 ~= 0 then return false, "invalid_value" end
                chance = draft.chancePercent / 100
            end
            changes.chance = chance
        else
            changes.resetChance = true
        end
    end
    if next(changes) == nil then return true end
    return Config.UpdateEventSettings(
        settings.configLayer, settings.configOwner, settings.configKey, changes)
end

local function previewOptions(scope, context)
    context = context or {}
    local class = scope.class or context.class or (scope.layer == "druidForm" and "DRUID" or nil)
    local race = scope.race or context.race
    local api = RPHelper.RuntimeAPI or {}
    local options = {
        class = class,
        context = {
            class = class,
            values = { PLAYER_CLASS = class, PLAYER_RACE = race },
            api = api,
        },
        randomIndex = function(size) return size > 0 and 1 or nil end,
    }
    if scope.layer == "druidForm" then options.form = scope.form end
    if api.GetShapeshiftFormID then options.getShapeshiftFormID = api.GetShapeshiftFormID end
    return options
end

function EditorData.Preview(draft, context)
    if type(draft) ~= "table" or type(draft.entry) ~= "table"
        or type(draft.scope) ~= "table" then return nil, "invalid_draft" end
    local valid, err = ContentEngine.ValidateEntry(draft.entry)
    if not valid then return nil, err end
    local prepared = ContentEngine.PrepareCandidate(copy(draft.entry), previewOptions(draft.scope, context))
    if not prepared then return nil, "unresolved_or_ineligible" end
    if prepared.type == "emote" then return "[Preview] Emote token: " .. prepared.text .. " (not executed)" end
    if prepared.type == "customemote" then
        local player = "Player"
        if type(UnitName) == "function" then
            local ok, value = pcall(UnitName, "player")
            if ok and type(value) == "string" and value ~= "" then player = value end
        end
        return "[Preview] " .. player .. " " .. prepared.text
    end
    return "[Preview] " .. prepared.text
end

function EditorData.ListEmoteTokens()
    local tokens, seenTables = {}, {}
    local function scan(value)
        if type(value) ~= "table" or seenTables[value] then return end
        seenTables[value] = true
        if value.type == "emote" and type(value.text) == "string"
            and string.match(value.text, "^[A-Z][A-Z_]*$") then
            tokens[value.text] = true
        end
        for _, child in pairs(value) do if type(child) == "table" then scan(child) end end
    end
    scan(RPHelper.Content)
    local result = {}
    for token in pairs(tokens) do result[#result + 1] = token end
    table.sort(result)
    return result
end

function EditorData.Copy(value) return copy(value) end
