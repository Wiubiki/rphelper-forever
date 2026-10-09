RPHelper = RPHelper or {}
RPHelper.Output = RPHelper.Output or {}

function RPHelper.Output.Dispatch(candidate, api)
    if type(candidate) ~= "table" or type(candidate.text) ~= "string" or candidate.text == "" then
        return false
    end
    if type(api) ~= "table" then
        return false
    end

    if candidate.type == "say" and type(api.SendSay) == "function" then
        return api.SendSay(candidate.text) == true
    elseif candidate.type == "emote" and type(api.RunEmote) == "function" then
        return api.RunEmote(candidate.text) == true
    elseif candidate.type == "customemote" and type(api.SendCustomEmote) == "function" then
        return api.SendCustomEmote(candidate.text) == true
    end
    return false
end
