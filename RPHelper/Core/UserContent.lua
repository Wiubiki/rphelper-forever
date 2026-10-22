RPHelper = RPHelper or {}
RPHelper.UserContent = RPHelper.UserContent or {}
local UserContent = RPHelper.UserContent
local cachedRoot, cachedEntries, index

local function copy(value, seen)
    if type(value) ~= "table" then return value end
    seen = seen or {}
    if seen[value] then return seen[value] end
    local result = {}
    seen[value] = result
    for key, child in pairs(value) do result[key] = copy(child, seen) end
    return result
end

local function container(name)
    if type(RPHelperDB) == "table" and type(RPHelperDB[name]) == "table" then
        return RPHelperDB[name]
    end
end

local function entries()
    local custom = container("custom")
    if custom and type(custom.entries) == "table" then return custom.entries, custom end
end

local function token(value, pattern)
    return type(value) == "string" and string.match(value, pattern) ~= nil
end

local function scopeKey(scope)
    if type(scope) ~= "table" then return nil end
    local layer, owner, key = scope.layer, "", scope.trigger
    if layer == "ability" then owner, key = scope.class, scope.ability
    elseif layer == "race" then owner = scope.race
    elseif layer == "class" then owner = scope.class
    elseif layer == "druidForm" then
        owner = scope.form == "DIRE_BEAR" and "BEAR" or scope.form
    elseif layer ~= "generic" then return nil end
    if layer ~= "generic" and not token(owner, "^[A-Z][A-Z0-9_]*$") then return nil end
    if not token(key, layer == "ability" and "^[A-Z][A-Z0-9_]*$" or "^[a-z][a-z0-9_]*$") then
        return nil
    end
    return layer .. ":" .. owner .. ":" .. key
end

local function normalizedScope(scope)
    local result = {}
    for _, key in ipairs({ "layer", "class", "race", "form", "trigger", "ability" }) do
        result[key] = scope[key]
    end
    return result
end

local function normalizedEntry(entry)
    -- Never transfer a saved defaultID into the custom candidate path.
    return { type = entry.type, text = entry.text, template = entry.template, choices = copy(entry.choices) }
end

function UserContent.Invalidate()
    cachedRoot, cachedEntries, index = nil, nil, nil
end

local function ensureIndex()
    local saved = entries()
    if index and cachedRoot == RPHelperDB and cachedEntries == saved then return end
    cachedRoot, cachedEntries, index = RPHelperDB, saved, {}
    if not saved then return end
    local ids = {}
    for id in pairs(saved) do
        if type(id) == "string" and string.match(id, "^custom:[1-9]%d*$") then ids[#ids + 1] = id end
    end
    table.sort(ids)
    for _, id in ipairs(ids) do
        local record = saved[id]
        if type(record) == "table" then
            local key = scopeKey(record.scope)
            if key and RPHelper.ContentEngine.ValidateEntry(record.entry) then
                if record.enabled ~= false then
                    local entry = normalizedEntry(record.entry)
                    entry.customID = id
                    entry.weight = RPHelper.Configuration.IsPositiveInteger(record.weight) and record.weight or 1
                    index[key] = index[key] or {}
                    index[key][#index[key] + 1] = entry
                end
            end
        end
    end
end

function UserContent.AppendCandidates(pool, scope)
    local key = scopeKey(scope)
    if not key then return end
    ensureIndex()
    for _, entry in ipairs(index[key] or {}) do pool[#pool + 1] = entry end
end

function UserContent.Add(scope, entry, metadata)
    if not scopeKey(scope) then return nil, "invalid_scope" end
    local valid, err = RPHelper.ContentEngine.ValidateEntry(entry)
    if not valid then return nil, err end
    local saved, custom = entries()
    if not saved then return nil, "invalid_container" end
    local number = custom.nextID
    if type(number) ~= "number" or number < 1 or number >= 9007199254740991 or number % 1 ~= 0 then
        return nil, "invalid_counter"
    end
    local id = "custom:" .. string.format("%.0f", number)
    while saved[id] ~= nil do
        number = number + 1
        if number >= 9007199254740991 then return nil, "invalid_counter" end
        id = "custom:" .. string.format("%.0f", number)
    end
    metadata = metadata or {}
    if type(metadata) ~= "table" then return nil, "invalid_metadata" end
    if metadata.enabled ~= nil and type(metadata.enabled) ~= "boolean" then return nil, "invalid_enabled" end
    if metadata.weight ~= nil and not RPHelper.Configuration.IsPositiveInteger(metadata.weight) then return nil, "invalid_weight" end
    if metadata.sourceDefaultID ~= nil and (type(metadata.sourceDefaultID) ~= "string"
        or not string.match(metadata.sourceDefaultID, "^default:")) then return nil, "invalid_id" end
    saved[id] = { scope = normalizedScope(scope), entry = normalizedEntry(entry) }
    if metadata.enabled == false then saved[id].enabled = false end
    if metadata.weight and metadata.weight ~= 1 then saved[id].weight = metadata.weight end
    if metadata.sourceDefaultID then saved[id].sourceDefaultID = metadata.sourceDefaultID end
    custom.nextID = number + 1
    UserContent.Invalidate()
    return id
end

function UserContent.CreateModifiedCopy(defaultID, scope, entry, metadata)
    if type(defaultID) ~= "string" or not string.match(defaultID, "^default:") then return nil, "invalid_id" end
    local wasEnabled = RPHelper.Configuration.IsDefaultEnabled(defaultID)
    metadata = copy(metadata or {})
    metadata.sourceDefaultID = defaultID
    local id, err = UserContent.Add(scope, entry, metadata)
    if not id then return nil, err end
    local ok, disableErr = RPHelper.Configuration.SetDefaultEnabled(defaultID, false)
    if not ok then
        local saved = entries()
        if saved then saved[id] = nil end
        UserContent.Invalidate()
        if wasEnabled then RPHelper.Configuration.SetDefaultEnabled(defaultID, true) end
        return nil, disableErr
    end
    return id
end

function UserContent.Edit(id, scope, entry)
    local saved = entries()
    if not saved then return false, "invalid_container" end
    if type(id) ~= "string" or type(saved[id]) ~= "table" then return false, "not_found" end
    if not scopeKey(scope) then return false, "invalid_scope" end
    local valid, err = RPHelper.ContentEngine.ValidateEntry(entry)
    if not valid then return false, err end
    local record = saved[id]
    -- Preserve unknown fields on the record, scope and entry during supported edits.
    local newScope = copy(record.scope)
    if type(newScope) ~= "table" then newScope = {} end
    for _, key in ipairs({ "layer", "class", "race", "form", "trigger", "ability" }) do
        newScope[key] = scope[key]
    end
    local newEntry = copy(record.entry)
    if type(newEntry) ~= "table" then newEntry = {} end
    for _, key in ipairs({ "type", "text", "template", "choices" }) do newEntry[key] = copy(entry[key]) end
    record.scope, record.entry = newScope, newEntry
    UserContent.Invalidate()
    return true
end

function UserContent.Remove(id)
    local saved = entries()
    if not saved then return false, "invalid_container" end
    if type(id) ~= "string" or saved[id] == nil then return false, "not_found" end
    saved[id] = nil
    UserContent.Invalidate()
    return true
end

function UserContent.List(scope)
    local saved = entries()
    if not saved then return nil, "invalid_container" end
    local key = scope and scopeKey(scope)
    if scope ~= nil and not key then return nil, "invalid_scope" end
    local list = {}
    for id, record in pairs(saved) do
        if type(id) == "string" and type(record) == "table"
            and (not key or scopeKey(record.scope) == key) then
            list[#list + 1] = { id = id, scope = copy(record.scope), entry = copy(record.entry),
                enabled = record.enabled, weight = record.weight, sourceDefaultID = record.sourceDefaultID }
        end
    end
    table.sort(list, function(a, b) return a.id < b.id end)
    return list
end

function UserContent.SetDefaultDisabled(id, disabled)
    if type(disabled) ~= "boolean" then return false, "invalid_disabled" end
    return RPHelper.Configuration.SetDefaultEnabled(id, not disabled)
end

function UserContent.IsDefaultDisabled(id)
    return type(id) == "string" and not RPHelper.Configuration.IsDefaultEnabled(id)
end

function UserContent.SetEnabled(id, enabled)
    local saved = entries()
    local record = saved and type(id) == "string" and saved[id]
    if type(record) ~= "table" then return false, "not_found" end
    if type(enabled) ~= "boolean" then return false, "invalid_enabled" end
    record.enabled = enabled and nil or false
    UserContent.Invalidate()
    return true
end

function UserContent.IsEnabled(id)
    local saved = entries()
    local record = saved and type(id) == "string" and saved[id]
    return type(record) == "table" and record.enabled ~= false
end

function UserContent.SetWeight(id, weight)
    local saved = entries()
    local record = saved and type(id) == "string" and saved[id]
    if type(record) ~= "table" then return false, "not_found" end
    if not RPHelper.Configuration.IsPositiveInteger(weight) then return false, "invalid_weight" end
    record.weight = weight == 1 and nil or weight
    UserContent.Invalidate()
    return true
end

function UserContent.GetWeight(id)
    local saved = entries()
    local record = saved and type(id) == "string" and saved[id]
    if type(record) ~= "table" then return nil, "not_found" end
    return RPHelper.Configuration.IsPositiveInteger(record.weight) and record.weight or 1
end

-- Preparation eligibility only: runtime settings, probability, routing and quota
-- are intentionally evaluated by Runtime, not by an editor preview query.
function UserContent.IsCustomEligible(id, scope, options)
    local saved = entries()
    local record = saved and type(id) == "string" and saved[id]
    if type(record) ~= "table" then return false, "not_found" end
    local key = scopeKey(scope)
    if not key or key ~= scopeKey(record.scope) then return false, "scope_mismatch" end
    local valid, err = RPHelper.ContentEngine.ValidateEntry(record.entry)
    if not valid then return false, err end
    options = copy(options or {})
    if not options.class then
        options.class = record.scope.class or (record.scope.layer == "druidForm" and "DRUID" or nil)
    end
    return RPHelper.ContentEngine.PrepareCandidate(normalizedEntry(record.entry), options) ~= nil
end
