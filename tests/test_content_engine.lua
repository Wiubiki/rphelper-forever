local failures = 0
local tests = 0

local function test(name, callback)
    tests = tests + 1
    local ok, message = pcall(callback)
    if not ok then
        failures = failures + 1
        io.stderr:write("FAIL: " .. name .. "\n  " .. tostring(message) .. "\n")
    end
end

local function equal(actual, expected)
    if actual ~= expected then
        error("expected " .. tostring(expected) .. ", got " .. tostring(actual), 2)
    end
end

local function truthy(value)
    if not value then
        error("expected a truthy value", 2)
    end
end

RPHelper = {}
dofile("RPHelper/Core/KeywordResolvers.lua")
dofile("RPHelper/Core/ContentEngine.lua")
dofile("RPHelper/Core/Content.lua")

local Engine = RPHelper.ContentEngine

test("static text passes through unchanged", function()
    local candidate = Engine.PrepareCandidate({ type = "say", text = "Too slow." })
    equal(candidate.text, "Too slow.")
    equal(candidate.type, "say")
end)

test("supported keyword resolves", function()
    local candidate = Engine.PrepareCandidate(
        { type = "say", text = "Ready, {PLAYER}." },
        { resolvers = { PLAYER = function() return "Ari" end } }
    )
    equal(candidate.text, "Ready, Ari.")
end)

test("resolver errors and non-scalar values are ineligible", function()
    local invalidResolvers = {
        function() error("restricted value") end,
        function() return {} end,
        function() return function() end end,
        function() return true end,
    }

    for _, resolver in ipairs(invalidResolvers) do
        equal(Engine.PrepareCandidate(
            { type = "say", text = "Value: {PLAYER}" },
            { resolvers = { PLAYER = resolver } }
        ), nil)
    end
end)

test("secret resolver values are ineligible", function()
    local previousIsSecretValue = issecretvalue
    issecretvalue = function(value)
        return value == "hidden"
    end

    local candidate = Engine.PrepareCandidate(
        { type = "say", text = "Value: {PLAYER}" },
        { resolvers = { PLAYER = function() return "hidden" end } }
    )
    issecretvalue = previousIsSecretValue

    equal(candidate, nil)
end)

test("numeric resolver values are converted to text", function()
    local candidate = Engine.PrepareCandidate(
        { type = "say", text = "Level {LEVEL}" },
        { resolvers = { LEVEL = function() return 42 end } }
    )
    equal(candidate.text, "Level 42")
end)

test("unresolved candidate is filtered without removing fallback", function()
    local pool = {
        { type = "say", text = "Die, {TARGET}!" },
        { type = "say", text = "Have at you!" },
    }
    local eligible = Engine.PrepareCandidatePool(pool, { resolvers = {} })
    equal(#eligible, 1)
    equal(eligible[1].text, "Have at you!")

    local selected = Engine.ChooseCandidate(pool, {
        resolvers = {},
        randomIndex = function() return 1 end,
    })
    equal(selected.text, "Have at you!")
end)

test("overlapping token names resolve independently", function()
    local candidate = Engine.PrepareCandidate(
        { type = "say", text = "{PTSP}/{TSP}/{SP}" },
        {
            resolvers = {
                PTSP = function() return "pet-target" end,
                TSP = function() return "target" end,
                SP = function() return "player" end,
            },
        }
    )
    equal(candidate.text, "pet-target/target/player")
end)

test("template placeholders use their corresponding independent pools", function()
    local calls = 0
    local candidate = Engine.PrepareCandidate(
        {
            type = "say",
            template = "I'll {1} your {2}!",
            choices = {
                { "rip", "tear" },
                { "arms", "legs" },
            },
        },
        {
            resolvers = {},
            randomIndex = function()
                calls = calls + 1
                return calls == 1 and 2 or 1
            end,
        }
    )
    equal(candidate.text, "I'll tear your arms!")
    equal(calls, 2)
end)

test("empty template choices are valid", function()
    local candidate = Engine.PrepareCandidate(
        {
            type = "say",
            template = "{1}Ready.",
            choices = { { "" } },
        },
        { resolvers = {}, randomIndex = function() return 1 end }
    )
    equal(candidate.text, "Ready.")
end)

test("keywords in selected fragments resolve after expansion", function()
    local candidate = Engine.PrepareCandidate(
        {
            type = "say",
            template = "{1}!",
            choices = { { "For {PLAYER}" } },
        },
        {
            resolvers = { PLAYER = function() return "Ari" end },
            randomIndex = function() return 1 end,
        }
    )
    equal(candidate.text, "For Ari!")
end)

test("missing and malformed template pools fail safely", function()
    equal(Engine.PrepareCandidate({ type = "say", template = "Choose {1}." }), nil)
    equal(Engine.PrepareCandidate({
        type = "say",
        template = "Choose {2}.",
        choices = { { "one" } },
    }), nil)
    equal(Engine.PrepareCandidate({
        type = "say",
        template = "Choose {1}.",
        choices = { {} },
    }), nil)
end)

test("RINSULT uses one generated value per candidate", function()
    local calls = 0
    local candidate = Engine.PrepareCandidate(
        { type = "say", text = "You {RINSULT} Truly, {RINSULT!}" },
        {
            resolvers = {},
            insultProvider = function()
                calls = calls + 1
                return "fool."
            end,
        }
    )
    equal(candidate.text, "You fool. Truly, fool!")
    equal(calls, 1)
end)

test("missing insult provider makes candidate ineligible", function()
    Engine.SetInsultProvider(nil)
    equal(Engine.PrepareCandidate({ type = "say", text = "Begone, {RINSULT}!" }, {
        resolvers = {},
    }), nil)
end)

test("raw unknown tokens never enter eligible output", function()
    local eligible = Engine.PrepareCandidatePool({
        { type = "say", text = "Known." },
        { type = "say", text = "Unknown {NOT_A_KEYWORD}." },
        { type = "say", text = "Broken {1}." },
    }, { resolvers = {} })
    equal(#eligible, 1)
    equal(eligible[1].text, "Known.")
end)

test("existing generic entries remain compatible", function()
    RPHelper.RegisterGeneric("dodge", { type = "say", text = "Too slow." })
    local selected = RPHelper.ChooseGenericCandidate("dodge", {
        resolvers = {},
        randomIndex = function() return 1 end,
    })
    truthy(selected)
    equal(selected.text, "Too slow.")
end)

if failures > 0 then
    io.stderr:write(tostring(failures) .. " of " .. tostring(tests) .. " tests failed\n")
    os.exit(1)
end

print(tostring(tests) .. " tests passed")
