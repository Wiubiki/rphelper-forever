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

    -- Classifiers supply only sanitized primitives. Copy the approved schema so
    -- callback payload tables or future classifier fields cannot be retained.
    local record = {
        event = event,
        category = category,
        result = type(detail.result) == "string" and detail.result or "classification_unavailable",
        matched = detail.matched == true,
    }
    for _, key in ipairs({ "trigger", "unit", "action", "spellID", "class", "ability" }) do
        local value = detail[key]
        if type(value) == "string" or type(value) == "number" then record[key] = value end
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

function Diagnostics.Format(record)
    if type(record) ~= "table" then return "invalid diagnostic record" end
    local text = prefix(record)
    local activity = record.activity and (" activity=" .. record.activity) or ""
    if record.category == "combat" then
        return text .. " trigger=" .. (record.trigger or "unknown") .. activity
            .. " result=" .. record.result
    end
    if record.category == "defense" then
        return text .. " unit=" .. (record.unit or "restricted")
            .. " action=" .. (record.action or "restricted") .. activity .. " result=" .. record.result
    end
    if record.category == "spellcast" then
        local spell = record.spellID and tostring(record.spellID) or "restricted"
        local class = record.class or "unavailable"
        local ability = record.ability and (" ability=" .. record.ability) or ""
        return text .. " unit=" .. (record.unit or "restricted") .. " spellID=" .. spell
            .. " class=" .. class .. ability .. activity .. " result=" .. record.result
    end
    return text .. " result=" .. record.result
end
