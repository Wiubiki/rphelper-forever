RPHelper = RPHelper or {}
RPHelper.KeywordResolvers = RPHelper.KeywordResolvers or {}

local unpackValues = unpack or table.unpack

local function safeValue(callback)
    local ok, value = pcall(callback)
    if not ok or value == nil or value == "" then
        return nil
    end
    return value
end

local function call(api, ...)
    local arguments = { ... }
    return safeValue(function()
        if type(api) ~= "function" then
            return nil
        end
        return api(unpackValues(arguments))
    end)
end

local function callResult(resultIndex, api, ...)
    local arguments = { ... }
    return safeValue(function()
        if type(api) ~= "function" then
            return nil
        end
        local results = { api(unpackValues(arguments)) }
        return results[resultIndex]
    end)
end

-- Game-API access lives here so it can be revised after WoW Forever testing.
-- Trigger-specific or restricted values should be supplied through context.values
-- or explicit resolver functions, never guessed by the content engine.
function RPHelper.KeywordResolvers.Create(context)
    context = context or {}
    local values = context.values or {}

    local function supplied(keyword)
        return function()
            local value = values[keyword]
            if value == nil or value == "" then
                return nil
            end
            return value
        end
    end

    local resolvers = {
        PLAYER = function()
            return values.PLAYER or call(UnitName, "player")
        end,
        PLAYER_CLASS = function()
            return values.PLAYER_CLASS or call(UnitClass, "player")
        end,
        PLAYER_RACE = function()
            return values.PLAYER_RACE or call(UnitRace, "player")
        end,
        PLAYER_GUILDNAME = function()
            return values.PLAYER_GUILDNAME or call(GetGuildInfo, "player")
        end,
        PLAYER_GUILDRANK = function()
            return values.PLAYER_GUILDRANK or callResult(2, GetGuildInfo, "player")
        end,
        HOME = function()
            return values.HOME or call(GetBindLocation)
        end,
        MAIN_ZONE = function()
            return values.MAIN_ZONE or call(GetRealZoneText)
        end,
        SUB_ZONE = function()
            if values.SUB_ZONE then
                return values.SUB_ZONE
            end

            local subZone = call(GetSubZoneText)
            if subZone then
                return subZone
            end
            return values.MAIN_ZONE or call(GetRealZoneText)
        end,
        FFG = function()
            return values.FFG or call(UnitFactionGroup, "player")
        end,
    }

    local suppliedKeywords = {
        "SP", "OP", "PP", "PLAYER_POWER", "LEVEL",
        "TARGET", "TSP", "TOP", "TPP", "TARGET_CLASS", "TARGET_RACE",
        "TARGET_GUILDNAME", "TARGET_GUILDRANK", "TARGET_POWER",
        "PNAME", "PTNAME", "PTSP", "PTOP", "PTPP",
    }

    for _, keyword in ipairs(suppliedKeywords) do
        resolvers[keyword] = supplied(keyword)
    end

    return resolvers
end
