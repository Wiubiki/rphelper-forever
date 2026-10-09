RPHelper = RPHelper or {}
RPHelper.Content = RPHelper.Content or { generic = {}, race = {}, class = {}, ability = {} }
RPHelper.Content.generic = RPHelper.Content.generic or {}
RPHelper.Content.race = RPHelper.Content.race or {}
RPHelper.Race = RPHelper.Race or {
    TAUREN = "TAUREN",
    ORC = "ORC",
    NIGHTELF = "NIGHTELF",
    HUMAN = "HUMAN",
    GNOME = "GNOME",
    DWARF = "DWARF",
    UNDEAD = "UNDEAD",
    TROLL = "TROLL",
}

function RPHelper.RegisterGeneric(trigger, entry)
    RPHelper.Content.generic[trigger] = RPHelper.Content.generic[trigger] or {}
    table.insert(RPHelper.Content.generic[trigger], entry)
end

function RPHelper.GetGenericPool(trigger)
    return RPHelper.Content.generic[trigger] or {}
end

function RPHelper.GetPreparedGenericPool(trigger, options)
    return RPHelper.ContentEngine.PrepareCandidatePool(RPHelper.GetGenericPool(trigger), options)
end

function RPHelper.ChooseGenericCandidate(trigger, options)
    return RPHelper.ContentEngine.ChooseCandidate(RPHelper.GetGenericPool(trigger), options)
end

function RPHelper.RegisterRace(race, trigger, entry)
    RPHelper.Content.race[race] = RPHelper.Content.race[race] or {}
    RPHelper.Content.race[race][trigger] = RPHelper.Content.race[race][trigger] or {}
    table.insert(RPHelper.Content.race[race][trigger], entry)
end

function RPHelper.GetRacePool(race, trigger)
    local raceContent = RPHelper.Content.race[race]
    return raceContent and raceContent[trigger] or {}
end

-- Character pools are additive: authored race content supplements Generic.
-- A fresh table prevents callers from changing either registered layer.
function RPHelper.GetContentPool(trigger, race)
    local pool = {}
    for _, entry in ipairs(RPHelper.GetGenericPool(trigger)) do
        table.insert(pool, entry)
    end
    for _, entry in ipairs(RPHelper.GetRacePool(race, trigger)) do
        table.insert(pool, entry)
    end
    return pool
end

function RPHelper.GetPreparedContentPool(trigger, race, options)
    return RPHelper.ContentEngine.PrepareCandidatePool(RPHelper.GetContentPool(trigger, race), options)
end

function RPHelper.ChooseContentCandidate(trigger, race, options)
    return RPHelper.ContentEngine.ChooseCandidate(RPHelper.GetContentPool(trigger, race), options)
end
