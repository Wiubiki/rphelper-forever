-- Output boundary tests: no real client APIs or public transmissions.
local tests, failures = 0, 0
local function equal(actual, expected)
    if actual ~= expected then error("expected " .. tostring(expected) .. ", got " .. tostring(actual), 2) end
end
local function test(name, callback)
    tests = tests + 1
    local ok, err = pcall(callback)
    C_ChatInfo, SendChatMessage, DoEmote, DEFAULT_CHAT_FRAME, issecretvalue = nil, nil, nil, nil, nil
    if not ok then failures = failures + 1; io.stderr:write("FAIL: " .. name .. "\n  " .. tostring(err) .. "\n") end
end
RPHelper = {}
dofile("RPHelperForever/Core/RuntimeAPI.lua")
dofile("RPHelperForever/Core/Output.lua")
local api = RPHelper.RuntimeAPI
local function dispatch(kind, activity, mode)
    return RPHelper.Output.Dispatch({ type = kind, text = kind == "emote" and "ROAR" or "resolved action." },
        api, activity, mode)
end
local function localDisplay()
    local lines = {}
    DEFAULT_CHAT_FRAME = { AddMessage = function(_, text) lines[#lines + 1] = text end }
    return lines
end

test("world emotes display labelled private output without touching public APIs", function()
    local lines = localDisplay()
    C_ChatInfo = {
        SendChatMessage = function() error("must not call public chat") end,
        PerformEmote = function() error("must not call native emote") end,
    }
    for _, kind in ipairs({ "emote", "customemote" }) do
        local ok, detail = dispatch(kind, "world")
        equal(ok, true); equal(detail.route, "local"); equal(detail.localDisplayed, true)
        equal(detail.publicDelivery, "not_attempted"); equal(detail.fallbackReason, "world_policy")
        equal(detail.dispatchAttempted, true); equal(detail.apiCompleted, true)
    end
    equal(lines[1], "|cffb8a0df[RPHelper]|r [Local only - Emote] ROAR")
    equal(lines[2], "|cffb8a0df[RPHelper]|r [Local only - Custom Emote] resolved action.")
end)

test("dungeon uses documented namespaced APIs without claiming delivery", function()
    local calls, lines = {}, localDisplay()
    SendChatMessage, DoEmote = function() error("legacy chat") end, function() error("legacy emote") end
    C_ChatInfo = {
        SendChatMessage = function(text, channel) calls[#calls + 1] = { text, channel } end,
        PerformEmote = function(token) calls[#calls + 1] = { token, "native" }; return true end,
    }
    for _, kind in ipairs({ "say", "customemote", "emote" }) do
        local ok, detail = dispatch(kind, "dungeon")
        equal(ok, true); equal(detail.route, "public"); equal(detail.apiStatus, "completed")
        equal(detail.apiCompleted, true); equal(detail.publicDelivery, "unverified")
        equal(detail.localDisplayed, false)
    end
    equal(calls[1][2], "SAY"); equal(calls[2][2], "EMOTE"); equal(calls[3][2], "native")
    equal(calls[3][1], "ROAR"); equal(#lines, 0)
end)

test("legacy APIs remain a compatibility path only when namespaced APIs are absent", function()
    local calls = 0
    SendChatMessage = function() calls = calls + 1 end
    DoEmote = function() calls = calls + 1 end
    for _, kind in ipairs({ "say", "customemote", "emote" }) do
        local ok, detail = dispatch(kind, "dungeon")
        equal(ok, true); equal(detail.publicDelivery, "unverified")
    end
    equal(calls, 3)
end)

for _, kind in ipairs({ "emote", "customemote" }) do
    for _, failure in ipairs({ "unavailable", "error", "rejected", "restricted_result" }) do
        test(kind .. " observable " .. failure .. " uses private fallback without retry", function()
            local lines, calls = localDisplay(), 0
            local function failed()
                calls = calls + 1
                if failure == "error" then error("blocked action (mock)") end
                if failure == "restricted_result" then return {} end
                return false
            end
            if failure ~= "unavailable" then
                C_ChatInfo = { PerformEmote = failed, SendChatMessage = failed }
            end
            issecretvalue = function(value) return type(value) == "table" end
            local ok, detail = dispatch(kind, "dungeon")
            equal(ok, true); equal(detail.route, "local"); equal(detail.apiStatus, failure)
            equal(detail.apiCompleted, failure ~= "error" and failure ~= "unavailable")
            equal(detail.publicDelivery, "failed"); equal(detail.localDisplayed, true)
            equal(detail.fallbackReason, failure); equal(detail.fallbackStatus, "completed")
            equal(calls, failure == "unavailable" and 0 or 1); equal(#lines, 1)
        end)
    end
end

test("PerformEmote nil is not a documented boolean success", function()
    local lines = localDisplay()
    C_ChatInfo = { PerformEmote = function() end }
    local ok, detail = dispatch("emote", "dungeon")
    equal(ok, true); equal(detail.apiStatus, "rejected"); equal(#lines, 1)
end)

test("failed namespaced calls never retry a legacy public function", function()
    localDisplay()
    C_ChatInfo = { PerformEmote = function() error("blocked") end,
        SendChatMessage = function() return false end }
    DoEmote, SendChatMessage = function() error("must not retry") end, function() error("must not retry") end
    equal(dispatch("emote", "dungeon"), true)
    equal(dispatch("customemote", "dungeon"), true)
end)

for _, state in ipairs({ "unavailable", "error", "rejected" }) do
    test("private display " .. state .. " fails honestly without public escalation", function()
        if state ~= "unavailable" then
            DEFAULT_CHAT_FRAME = { AddMessage = function()
                if state == "error" then error("UI unavailable") end
                return false
            end }
        end
        SendChatMessage = function() error("must not escalate to public") end
        for _, kind in ipairs({ "say", "emote", "customemote" }) do
            local ok, detail = dispatch(kind, "world")
            equal(ok, false); equal(detail.localDisplayed, false); equal(detail.apiStatus, state)
        end
        local ok, detail = dispatch("emote", "dungeon")
        equal(ok, false); equal(detail.apiStatus, "unavailable"); equal(detail.fallbackStatus, state)
        equal(detail.localDisplayed, false)
    end)
end

test("Say retains world local dungeon public and dungeon local preference", function()
    local lines, calls = localDisplay(), 0
    C_ChatInfo = { SendChatMessage = function() calls = calls + 1 end }
    equal(dispatch("say", "world"), true)
    equal(dispatch("say", "dungeon", "local"), true)
    equal(#lines, 2); equal(calls, 0)
    equal(dispatch("say", "dungeon"), true); equal(calls, 1)
    C_ChatInfo.SendChatMessage = function() return false end
    local ok, detail = dispatch("say", "dungeon")
    equal(ok, false); equal(detail.apiStatus, "rejected"); equal(detail.localDisplayed, false)
    equal(#lines, 2) -- no new implicit Say fallback
end)

test("raids and unknown activities suppress public and private output", function()
    local lines = localDisplay()
    C_ChatInfo = { SendChatMessage = function() error("must not send") end,
        PerformEmote = function() error("must not emote") end }
    for _, activity in ipairs({ "raid", "pvp", "unknown" }) do
        for _, kind in ipairs({ "say", "emote", "customemote" }) do
            local ok, detail = dispatch(kind, activity)
            equal(ok, false); equal(detail.dispatchAttempted, false)
            equal(detail.apiStatus, "not_attempted"); equal(detail.localDisplayed, false)
        end
    end
    equal(#lines, 0)
end)

if failures > 0 then
    io.stderr:write(failures .. " of " .. tests .. " output tests failed\n"); os.exit(1)
end
print(tests .. " output tests passed")
