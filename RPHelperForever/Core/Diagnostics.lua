RPHelper = RPHelper or {}
RPHelper.Diagnostics = RPHelper.Diagnostics or {}

local Diagnostics = RPHelper.Diagnostics

Diagnostics.Capacity = 100

local enabled = false
local records = {}
local first = 1
local count = 0
local sequence = 0
local lastTime

local function finite(value)
    return type(value) == "number" and value == value
        and value > -math.huge and value < math.huge
end

local function append(record)
    sequence = sequence + 1
    record.sequence = sequence
    if count < Diagnostics.Capacity then
        records[((first + count - 1) % Diagnostics.Capacity) + 1] = record
        count = count + 1
    else
        records[first] = record
        first = (first % Diagnostics.Capacity) + 1
    end
end

function Diagnostics.Initialize()
    enabled = false
    records = {}
    first = 1
    count = 0
    sequence = 0
    lastTime = nil
end

function Diagnostics.SetEnabled(value)
    enabled = value == true
end

function Diagnostics.IsEnabled()
    return enabled
end

function Diagnostics.Clear()
    records = {}
    first = 1
    count = 0
end

function Diagnostics.Count()
    return count
end

function Diagnostics.Observe(event, category, detail)
    if not enabled or type(event) ~= "string" or type(category) ~= "string"
        or type(detail) ~= "table" then return false end

    -- Classifiers/runtime supply only sanitized primitives. Copy the approved schema so
    -- callback payload tables or future classifier fields cannot be retained.
    local record = {
        event = event,
        category = category,
        result = type(detail.result) == "string" and detail.result or "classification_unavailable",
        matched = detail.matched == true,
    }
    for _, key in ipairs({ "trigger", "unit", "action", "spellID", "class", "ability",
        "spellName", "outcome", "outputType", "route", "apiStatus", "publicDelivery",
        "fallbackReason", "fallbackStatus" }) do
        local value = detail[key]
        if type(value) == "string" or type(value) == "number" then record[key] = value end
    end
    if detail.eligible == "not_evaluated" or (finite(detail.eligible) and detail.eligible >= 0) then
        record.eligible = detail.eligible
    end
    for _, key in ipairs({ "chance", "roll" }) do
        if finite(detail[key]) then record[key] = detail[key] end
    end
    for _, key in ipairs({ "selected", "emitted", "dispatchAttempted", "apiCompleted", "localDisplayed" }) do
        if type(detail[key]) == "boolean" then record[key] = detail[key] end
    end
    if finite(detail.time) and detail.time >= 0
        and (lastTime == nil or detail.time >= lastTime) then
        record.time = detail.time
        lastTime = detail.time
    end
    if detail.activity == "world" or detail.activity == "dungeon" or detail.activity == "raid" then
        record.activity = detail.activity
    end
    append(record)
    return true
end

function Diagnostics.GetRecords(limit)
    if type(limit) ~= "number" or limit < 0 or limit % 1 ~= 0 then limit = count end
    local amount = math.min(limit, count)
    local result = {}
    local offset = count - amount
    for index = 1, amount do
        local position = ((first + offset + index - 2) % Diagnostics.Capacity) + 1
        local source = records[position]
        local copy = {}
        for key, value in pairs(source) do copy[key] = value end
        result[index] = copy
    end
    return result
end

local function prefix(record)
    local text = "#" .. record.sequence
    if record.time ~= nil then text = text .. " t=" .. string.format("%.3f", record.time) end
    return text .. " " .. record.event
end

local function outputFields(record)
    if not record.outcome then return "" end
    local policy = " outcome=" .. record.outcome
        .. " eligible=" .. tostring(record.eligible or "not_evaluated")
        .. " selected=" .. (record.selected and "yes" or "no")
        .. " emitted=" .. (record.emitted and "yes" or "no")
    if record.outputType then policy = policy .. " type=" .. record.outputType end
    for _, key in ipairs({ "route", "apiStatus", "publicDelivery", "fallbackReason", "fallbackStatus" }) do
        if record[key] then policy = policy .. " " .. key .. "=" .. record[key] end
    end
    for _, key in ipairs({ "dispatchAttempted", "apiCompleted", "localDisplayed" }) do
        if record[key] ~= nil then policy = policy .. " " .. key .. "=" .. (record[key] and "yes" or "no") end
    end
    if record.chance then policy = policy .. " chance=" .. tostring(record.chance) end
    if record.roll then policy = policy .. " roll=" .. string.format("%.3f", record.roll) end
    return policy
end

function Diagnostics.Format(record)
    if type(record) ~= "table" then return "invalid diagnostic record" end
    local text = prefix(record)
    local activity = record.activity and (" activity=" .. record.activity) or ""
    if record.category == "combat" then
        return text .. " trigger=" .. (record.trigger or "unknown") .. activity
            .. " result=" .. record.result .. outputFields(record)
    end
    if record.category == "defense" then
        return text .. " unit=" .. (record.unit or "restricted")
            .. " action=" .. (record.action or "restricted") .. activity .. " result=" .. record.result .. outputFields(record)
    end
    if record.category == "spellcast" then
        local spell = record.spellID and tostring(record.spellID) or "restricted"
        local class = record.class or "unavailable"
        local ability = record.ability and (" ability=" .. record.ability) or ""
        local name = record.spellName and (' spellName="' .. record.spellName .. '"') or " spellName=unavailable"
        return text .. " unit=" .. (record.unit or "restricted") .. " spellID=" .. spell
            .. name .. " class=" .. class .. ability .. activity .. " result=" .. record.result
            .. " matched=" .. (record.matched and "yes" or "no") .. outputFields(record)
    end
    return text .. " result=" .. record.result
end
