RPHelper = RPHelper or {}
RPHelper.Content = RPHelper.Content or { generic = {}, race = {}, class = {}, ability = {} }

function RPHelper.RegisterGeneric(trigger, entry)
    RPHelper.Content.generic[trigger] = RPHelper.Content.generic[trigger] or {}
    table.insert(RPHelper.Content.generic[trigger], entry)
end

function RPHelper.GetGenericPool(trigger)
    return RPHelper.Content.generic[trigger] or {}
end
