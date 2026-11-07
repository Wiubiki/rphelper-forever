RPHelper = RPHelper or {}
RPHelper.Output = RPHelper.Output or {}

function RPHelper.Output.IsActivityAllowed(activity)
    return activity == "world" or activity == "dungeon"
end

local function invoke(api, method, text)
    if type(api[method]) ~= "function" then return false, "unavailable", false, false end
    local ok, dispatched, status = pcall(api[method], text)
    if not ok then return false, "error", true, false end
    -- Adapter booleans describe dispatch only, never server delivery.
    if status ~= "unavailable" and status ~= "error" and status ~= "rejected"
        and status ~= "restricted_result" and status ~= "completed" then
        status = dispatched == true and "completed" or "rejected"
    end
    return dispatched == true, status, status ~= "unavailable", status ~= "error" and status ~= "unavailable"
end

function RPHelper.Output.Dispatch(candidate, api, activity, dungeonSayMode)
    local detail = { dispatchAttempted = false, apiCompleted = false, apiStatus = "not_attempted",
        localDisplayed = false, publicDelivery = "not_attempted" }
    if type(candidate) ~= "table" or type(candidate.text) ~= "string" or candidate.text == "" then
        return false, detail
    end
    if type(api) ~= "table" or not RPHelper.Output.IsActivityAllowed(activity) then
        return false, detail
    end
    local method
    if candidate.type == "say" then
        method = activity == "dungeon" and dungeonSayMode ~= "local" and "SendSay" or "DisplayLocal"
    elseif candidate.type == "emote" then
        method = "RunEmote"
    elseif candidate.type == "customemote" then
        method = "SendCustomEmote"
    end
    if not method then return false, detail end
    local isEmote = candidate.type == "emote" or candidate.type == "customemote"
    local localText = "[Local only - " .. (candidate.type == "emote" and "Emote" or "Custom Emote")
        .. "] " .. candidate.text
    -- Automatic world emotes have no verified public permission. Do not probe a
    -- protected action on every cast, or move the send into a hardware hook.
    if isEmote and activity == "world" then
        method = "DisplayLocal"
        detail.fallbackReason = "world_policy"
    end
    detail.route = method == "DisplayLocal" and "local" or "public"
    local dispatched
    dispatched, detail.apiStatus, detail.dispatchAttempted, detail.apiCompleted =
        invoke(api, method, detail.fallbackReason and localText or candidate.text)
    if detail.route == "public" then
        detail.publicDelivery = dispatched and "unverified" or "failed"
        if not dispatched and isEmote then
            detail.fallbackReason = detail.apiStatus
            detail.route = "local"
            -- Keep the public call's status even if private display succeeds.
            dispatched, detail.fallbackStatus = invoke(api, "DisplayLocal", localText)
        end
    end
    detail.localDisplayed = detail.route == "local" and dispatched
    return dispatched, detail
end
