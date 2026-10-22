RPHelper = RPHelper or {}
RPHelper.Output = RPHelper.Output or {}

function RPHelper.Output.IsActivityAllowed(activity)
    return activity == "world" or activity == "dungeon"
end

function RPHelper.Output.Dispatch(candidate, api, activity, dungeonSayMode)
    if type(candidate) ~= "table" or type(candidate.text) ~= "string" or candidate.text == "" then
        return false
    end
    if type(api) ~= "table" or not RPHelper.Output.IsActivityAllowed(activity) then
        return false
    end
    local method
    if candidate.type == "say" then
        method = activity == "dungeon" and dungeonSayMode ~= "local" and "SendSay" or "DisplayLocal"
    elseif candidate.type == "emote" then
        method = "RunEmote"
    elseif candidate.type == "customemote" then
        method = "SendCustomEmote"
    end
    if not method or type(api[method]) ~= "function" then return false end
    local ok, dispatched = pcall(api[method], candidate.text)
    return ok and dispatched == true
end
