RPHelper = RPHelper or {}
RPHelper.LibraryData = RPHelper.LibraryData or {}
local LibraryData = RPHelper.LibraryData

local Config = RPHelper.Configuration
local UserContent = RPHelper.UserContent

local typeLabels = {
    say = "Say",
    emote = "Emote",
    customemote = "Custom Emote",
}

local groupOrder = { event = 1, form = 2, ability = 3 }

local function canonicalToken(value)
    if type(value) ~= "string" or not string.match(value, "^[A-Z][A-Z0-9_]*$") then return nil end
    return value
end

local function safeCall(fn)
    if type(fn) ~= "function" then return nil end
    local ok, value = pcall(fn)
    if ok then return value end
end

local function title(value)
    if type(value) ~= "string" then return "Unavailable" end
    local text = string.lower(string.gsub(value, "_", " "))
    return (string.gsub(text, "(%a)([%w']*)", function(first, rest)
        return string.upper(first) .. rest
    end))
end

local function entryText(entry)
    if type(entry) ~= "table" then return "[Unavailable reaction data]" end
    if type(entry.text) == "string" and entry.text ~= "" then return entry.text end
    if type(entry.template) ~= "string" or entry.template == "" then
        return "[Unavailable reaction data]"
    end

    local details = entry.template
    if type(entry.choices) == "table" then
        local choiceGroups = {}
        for index, choices in ipairs(entry.choices) do
            if type(choices) == "table" then
                local values = {}
                for _, choice in ipairs(choices) do
                    if type(choice) == "string" then values[#values + 1] = choice end
                end
                if #values > 0 then
                    choiceGroups[#choiceGroups + 1] = tostring(index) .. ": " .. table.concat(values, " | ")
                end
            end
        end
        if #choiceGroups > 0 then details = details .. "  Choices: " .. table.concat(choiceGroups, "; ") end
    end
    return details
end

local function summary(text)
    text = string.gsub(text or "", "[%c]+", " ")
    if string.len(text) <= 52 then return text end
    return string.sub(text, 1, 49) .. "..."
end

local function builtInReaction(entry)
    local id = type(entry) == "table" and entry.defaultID or nil
    local text = entryText(entry)
    return {
        id = id,
        type = type(entry) == "table" and entry.type or nil,
        typeLabel = typeLabels[type(entry) == "table" and entry.type or nil] or "Unknown",
        provenance = "Built-in",
        enabled = type(id) == "string" and Config.IsDefaultEnabled(id) or false,
        weight = type(id) == "string" and Config.GetDefaultWeight(id) or 1,
        text = text,
        summary = summary(text),
        canActivate = type(id) == "string" and string.match(id, "^default:") ~= nil,
    }
end

local function customReaction(record)
    local id = record.id
    local text = entryText(record.entry)
    local weight = UserContent.GetWeight(id)
    return {
        id = id,
        type = type(record.entry) == "table" and record.entry.type or nil,
        typeLabel = typeLabels[type(record.entry) == "table" and record.entry.type or nil] or "Unknown",
        provenance = "Custom",
        enabled = UserContent.IsEnabled(id),
        weight = type(weight) == "number" and weight or 1,
        text = text,
        summary = summary(text),
        canActivate = type(id) == "string" and string.match(id, "^custom:[1-9]%d*$") ~= nil,
    }
end

local function abilityDetected(class, ability)
    local mappings = RPHelper.RuntimeAPI and RPHelper.RuntimeAPI.AbilitySpellIDs
    local spells = type(mappings) == "table" and mappings[class]
    if type(spells) ~= "table" then return false end
    for _, mappedAbility in pairs(spells) do
        if mappedAbility == ability then return true end
    end
    return false
end

local function groupSettings(group)
    local layer, owner, key
    if group.kind == "ability" then
        if abilityDetected(group.class, group.ability) then
            layer, owner, key = "ability", group.class, group.ability
        end
    else
        local mapping = RPHelper.Runtime and RPHelper.Runtime.TriggerConfigKey
        key = type(mapping) == "table" and mapping[group.trigger]
        if type(key) == "string" then layer = "trigger" end
    end
    if not layer then
        return {
            supported = false,
            detected = false,
        }
    end
    return {
        supported = true,
        configLayer = layer,
        configOwner = owner,
        configKey = key,
        enabled = Config.GetEventSetting(layer, owner, key, "enabled") == true,
        chance = Config.GetEventSetting(layer, owner, key, "chance"),
        priority = Config.GetEventSetting(layer, owner, key, "priority") == true,
        detected = true,
    }
end

local function newGroup(groups, id, kind, label, scope, fields)
    local group = groups[id]
    if group then return group end
    group = { id = id, kind = kind, label = label, scope = scope, reactions = {} }
    for key, value in pairs(fields or {}) do group[key] = value end
    groups[id] = group
    return group
end

local function addBuiltIns(group, pool)
    if type(pool) ~= "table" then return end
    for _, entry in ipairs(pool) do group.reactions[#group.reactions + 1] = builtInReaction(entry) end
end

local function addEventGroups(groups, section, owner, container)
    if type(container) ~= "table" then return end
    for trigger, pool in pairs(container) do
        if type(trigger) == "string" and type(pool) == "table" and #pool > 0 then
            local id = "event:" .. section .. ":" .. (owner or "") .. ":" .. trigger
            local scope = { layer = section, trigger = trigger }
            if section == "race" then scope.race = owner end
            if section == "class" then scope.class = owner end
            local group = newGroup(groups, id, "event", "Event: " .. title(trigger), scope,
                { trigger = trigger })
            addBuiltIns(group, pool)
        end
    end
end

local function addAbilityGroups(groups, class, container)
    if type(container) ~= "table" then return end
    for ability, pool in pairs(container) do
        if type(ability) == "string" and type(pool) == "table" and #pool > 0 then
            local id = "ability:" .. class .. ":" .. ability
            local scope = { layer = "ability", class = class, ability = ability }
            local group = newGroup(groups, id, "ability", "Ability: " .. title(ability), scope,
                { class = class, ability = ability })
            addBuiltIns(group, pool)
        end
    end
end

local function normalizedForm(form)
    return form == "DIRE_BEAR" and "BEAR" or form
end

local function addDruidFormGroups(groups, container)
    if type(container) ~= "table" then return end
    for rawForm, events in pairs(container) do
        local form = normalizedForm(rawForm)
        if canonicalToken(form) and type(events) == "table" then
            for trigger, pool in pairs(events) do
                if type(trigger) == "string" and type(pool) == "table" and #pool > 0 then
                    local id = "form:" .. form .. ":" .. trigger
                    local scope = { layer = "druidForm", form = form, trigger = trigger }
                    local group = newGroup(groups, id, "form",
                        "Druid Form: " .. title(form) .. " / " .. title(trigger), scope,
                        { form = form, trigger = trigger })
                    addBuiltIns(group, pool)
                end
            end
        end
    end
end

local function customGroup(groups, section, context, record)
    local scope = type(record) == "table" and record.scope
    if type(scope) ~= "table" then return nil end
    if section == "generic" and scope.layer == "generic" and type(scope.trigger) == "string" then
        return newGroup(groups, "event:generic::" .. scope.trigger, "event",
            "Event: " .. title(scope.trigger), { layer = "generic", trigger = scope.trigger },
            { trigger = scope.trigger })
    end
    if section == "race" and scope.layer == "race" and scope.race == context.race
        and type(scope.trigger) == "string" then
        return newGroup(groups, "event:race:" .. context.race .. ":" .. scope.trigger, "event",
            "Event: " .. title(scope.trigger),
            { layer = "race", race = context.race, trigger = scope.trigger },
            { trigger = scope.trigger })
    end
    if section ~= "class" then return nil end
    if scope.layer == "class" and scope.class == context.class and type(scope.trigger) == "string" then
        return newGroup(groups, "event:class:" .. context.class .. ":" .. scope.trigger, "event",
            "Event: " .. title(scope.trigger),
            { layer = "class", class = context.class, trigger = scope.trigger },
            { trigger = scope.trigger })
    end
    if scope.layer == "ability" and scope.class == context.class and type(scope.ability) == "string" then
        return newGroup(groups, "ability:" .. context.class .. ":" .. scope.ability, "ability",
            "Ability: " .. title(scope.ability),
            { layer = "ability", class = context.class, ability = scope.ability },
            { class = context.class, ability = scope.ability })
    end
    if context.class == "DRUID" and scope.layer == "druidForm"
        and canonicalToken(normalizedForm(scope.form)) and type(scope.trigger) == "string" then
        local form = normalizedForm(scope.form)
        return newGroup(groups, "form:" .. form .. ":" .. scope.trigger, "form",
            "Druid Form: " .. title(form) .. " / " .. title(scope.trigger),
            { layer = "druidForm", form = form, trigger = scope.trigger },
            { form = form, trigger = scope.trigger })
    end
end

function LibraryData.ResolveCharacterContext(api)
    api = api or RPHelper.RuntimeAPI or {}
    return {
        class = canonicalToken(safeCall(api.GetPlayerClass)),
        race = canonicalToken(safeCall(api.GetPlayerRace)),
    }
end

function LibraryData.BuildSection(section, suppliedContext)
    if section ~= "generic" and section ~= "race" and section ~= "class" then
        return nil, "invalid_section"
    end
    local source = suppliedContext or LibraryData.ResolveCharacterContext()
    local context = {
        class = canonicalToken(type(source) == "table" and source.class),
        race = canonicalToken(type(source) == "table" and source.race),
    }
    local model = { section = section, context = context, groups = {} }
    if section == "race" and not context.race then
        model.emptyMessage = "Current character race is unavailable."
        return model
    end
    if section == "class" and not context.class then
        model.emptyMessage = "Current character class is unavailable."
        return model
    end

    local groups = {}
    local content = RPHelper.Content or {}
    if section == "generic" then
        addEventGroups(groups, "generic", nil, content.generic)
    elseif section == "race" then
        addEventGroups(groups, "race", context.race,
            type(content.race) == "table" and content.race[context.race])
    else
        addEventGroups(groups, "class", context.class,
            type(content.class) == "table" and content.class[context.class])
        addAbilityGroups(groups, context.class,
            type(content.ability) == "table" and content.ability[context.class])
        if context.class == "DRUID" then addDruidFormGroups(groups, content.druidForm) end
    end

    local custom, customError = UserContent.List()
    if type(custom) == "table" then
        for _, record in ipairs(custom) do
            local group = customGroup(groups, section, context, record)
            if group then group.reactions[#group.reactions + 1] = customReaction(record) end
        end
    else
        model.warning = "Custom reactions are unavailable: " .. tostring(customError or "invalid container") .. "."
    end

    for _, group in pairs(groups) do
        group.settings = groupSettings(group)
        model.groups[#model.groups + 1] = group
    end
    table.sort(model.groups, function(left, right)
        local leftOrder, rightOrder = groupOrder[left.kind] or 9, groupOrder[right.kind] or 9
        if leftOrder ~= rightOrder then return leftOrder < rightOrder end
        return left.label < right.label
    end)
    if #model.groups == 0 and not model.emptyMessage then
        model.emptyMessage = "No registered " .. title(section) .. " reactions are available for this character."
    end
    return model
end

function LibraryData.SetReactionEnabled(reaction, enabled)
    if type(reaction) ~= "table" or type(enabled) ~= "boolean" or not reaction.canActivate then
        return false, "invalid_reaction"
    end
    if reaction.provenance == "Built-in" then
        return UserContent.SetDefaultDisabled(reaction.id, not enabled)
    end
    if reaction.provenance == "Custom" then
        return UserContent.SetEnabled(reaction.id, enabled)
    end
    return false, "invalid_reaction"
end

function LibraryData.FindGroup(model, id)
    if type(model) ~= "table" or type(model.groups) ~= "table" then return nil end
    for _, group in ipairs(model.groups) do if group.id == id then return group end end
end
