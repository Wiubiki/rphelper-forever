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

local function poolContainsText(pool, expected)
    for _, entry in ipairs(pool) do
        if entry.text == expected then
            return true
        end
    end
    return false
end

RPHelper = {}
dofile("RPHelper/Core/KeywordResolvers.lua")
dofile("RPHelper/Core/ContentEngine.lua")
dofile("RPHelper/Core/Content.lua")
dofile("RPHelper/Data/Generic.lua")
dofile("RPHelper/Data/Races/Tauren.lua")
dofile("RPHelper/Data/Races/Orc.lua")
dofile("RPHelper/Data/Races/NightElf.lua")
dofile("RPHelper/Data/Races/Human.lua")
dofile("RPHelper/Data/Races/Gnome.lua")
dofile("RPHelper/Data/Races/Dwarf.lua")
dofile("RPHelper/Data/Races/Undead.lua")
dofile("RPHelper/Data/Races/Troll.lua")
dofile("RPHelper/Data/Classes/Warrior.lua")
dofile("RPHelper/Data/Classes/Rogue.lua")
dofile("RPHelper/Data/Classes/Hunter.lua")
dofile("RPHelper/Data/Classes/Shaman.lua")
dofile("RPHelper/Data/Classes/Druid.lua")
dofile("RPHelper/Data/Classes/Paladin.lua")
dofile("RPHelper/Data/Classes/Mage.lua")
dofile("RPHelper/Data/Classes/Priest.lua")
dofile("RPHelper/Data/Classes/Warlock.lua")
dofile("RPHelper/Data/Abilities/Warrior.lua")
dofile("RPHelper/Data/Abilities/Rogue.lua")
dofile("RPHelper/Data/Abilities/Hunter.lua")
dofile("RPHelper/Data/Abilities/Shaman.lua")
dofile("RPHelper/Data/Abilities/Druid.lua")
dofile("RPHelper/Data/Abilities/Paladin.lua")
dofile("RPHelper/Data/Abilities/Mage.lua")
dofile("RPHelper/Data/Abilities/Priest.lua")
dofile("RPHelper/Data/Abilities/Warlock.lua")

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

test("generic-only content resolves normally through the combined pool", function()
    local generic = RPHelper.GetGenericPool("absorb")
    local prepared = RPHelper.GetPreparedContentPool("absorb", "SKYBORNE", nil, { resolvers = {} })
    equal(#prepared, #generic)
    truthy(poolContainsText(prepared, "Didn't even scratch me!"))
end)

test("authored races supplement generic content", function()
    local races = {
        { id = RPHelper.Race.TAUREN, raceText = "For my ancestors!" },
        { id = RPHelper.Race.ORC, raceText = "Strength and honor!" },
        { id = RPHelper.Race.NIGHTELF, raceText = "For Cenarius!" },
        { id = RPHelper.Race.HUMAN, raceText = "Stand your ground!" },
        { id = RPHelper.Race.GNOME, raceText = "For Gnomeregan!" },
        { id = RPHelper.Race.DWARF, raceText = "For Khaz Modan!" },
        { id = RPHelper.Race.UNDEAD, raceText = "Tremble before the Forsaken!" },
        { id = RPHelper.Race.TROLL, raceText = "Tas'dingo!" },
    }
    for _, race in ipairs(races) do
        local pool = RPHelper.GetContentPool("entercombat", race.id)
        truthy(poolContainsText(pool, "So be it."))
        truthy(poolContainsText(pool, race.raceText))
    end
end)

test("Forsaken content uses the canonical UNDEAD key", function()
    equal(RPHelper.Race.UNDEAD, "UNDEAD")
    equal(RPHelper.Race.FORSAKEN, nil)
    truthy(poolContainsText(
        RPHelper.GetRacePool(RPHelper.Race.UNDEAD, "entercombat"),
        "Tremble before the Forsaken!"
    ))
end)

test("unauthored races fall back to generic content", function()
    local generic = RPHelper.GetGenericPool("entercombat")
    local pool = RPHelper.GetContentPool("entercombat", "SKYBORNE")
    equal(#pool, #generic)
    truthy(poolContainsText(pool, "So be it."))
end)

test("race registration appends without overwriting other content", function()
    RPHelper.RegisterRace(RPHelper.Race.TAUREN, "test_append", { type = "say", text = "First." })
    RPHelper.RegisterRace(RPHelper.Race.TAUREN, "test_append", { type = "say", text = "Second." })
    RPHelper.RegisterRace(RPHelper.Race.ORC, "test_append", { type = "say", text = "Other race." })

    local tauren = RPHelper.GetRacePool(RPHelper.Race.TAUREN, "test_append")
    local orc = RPHelper.GetRacePool(RPHelper.Race.ORC, "test_append")
    equal(#tauren, 2)
    equal(tauren[1].text, "First.")
    equal(tauren[2].text, "Second.")
    equal(#orc, 1)
    equal(orc[1].text, "Other race.")
end)

test("keyword and template entries remain eligible through the race layer", function()
    RPHelper.RegisterGeneric("test_dynamic", { type = "say", text = "Generic dynamic fallback." })
    RPHelper.RegisterRace(RPHelper.Race.TAUREN, "test_dynamic", {
        type = "say",
        template = "{1}, {PLAYER}.",
        choices = { { "Rise" } },
    })

    local prepared = RPHelper.GetPreparedContentPool("test_dynamic", RPHelper.Race.TAUREN, nil, {
        resolvers = { PLAYER = function() return "Ari" end },
        randomIndex = function() return 1 end,
    })
    equal(#prepared, 2)
    equal(prepared[1].text, "Generic dynamic fallback.")
    equal(prepared[2].text, "Rise, Ari.")
end)

test("canonical class identifiers are stable internal keys", function()
    equal(RPHelper.Class.WARRIOR, "WARRIOR")
    equal(RPHelper.Class.ROGUE, "ROGUE")
    equal(RPHelper.Class.HUNTER, "HUNTER")
    equal(RPHelper.Class.SHAMAN, "SHAMAN")
    equal(RPHelper.Class.DRUID, "DRUID")
    equal(RPHelper.Class.PALADIN, "PALADIN")
    equal(RPHelper.Class.MAGE, "MAGE")
    equal(RPHelper.Class.PRIEST, "PRIEST")
    equal(RPHelper.Class.WARLOCK, "WARLOCK")
end)

test("authored classes supplement generic and race content", function()
    local classes = {
        { id = RPHelper.Class.WARRIOR, classText = "ROAR" },
        { id = RPHelper.Class.ROGUE, classText = "To the death!" },
        { id = RPHelper.Class.HUNTER, classText = "The hunt begins." },
        { id = RPHelper.Class.SHAMAN, classText = "The spirits guide me." },
        { id = RPHelper.Class.DRUID, classText = "For nature's survival!" },
        { id = RPHelper.Class.PALADIN, classText = "Light, give me strength!" },
        { id = RPHelper.Class.MAGE, classText = "I'm a magic man. I got magic hands." },
        { id = RPHelper.Class.PRIEST, classText = "The Light guides my hand!" },
        { id = RPHelper.Class.WARLOCK, classText = "Chaos boils in my mind." },
    }

    for _, class in ipairs(classes) do
        local pool = RPHelper.GetContentPool("entercombat", RPHelper.Race.TAUREN, class.id)
        truthy(poolContainsText(pool, "So be it."))
        truthy(poolContainsText(pool, "For my ancestors!"))
        truthy(poolContainsText(pool, class.classText))
    end
end)

test("second class batch ability content is registered and class-scoped", function()
    truthy(poolContainsText(
        RPHelper.GetAbilityPool(RPHelper.Class.SHAMAN, RPHelper.Ability.SHAMAN.EARTH_SHOCK),
        "Feel the ground tremble beneath you!"
    ))
    truthy(poolContainsText(
        RPHelper.GetAbilityPool(RPHelper.Class.DRUID, RPHelper.Ability.DRUID.ENTANGLING_ROOTS),
        "Oh, were you going somewhere?"
    ))
    truthy(poolContainsText(
        RPHelper.GetAbilityPool(RPHelper.Class.PALADIN, RPHelper.Ability.PALADIN.HAMMER_OF_JUSTICE),
        "Justice is swift!"
    ))
    equal(#RPHelper.GetAbilityPool(RPHelper.Class.DRUID, RPHelper.Ability.SHAMAN.EARTH_SHOCK), 0)
end)

test("unauthored classes fall back to generic and race content", function()
    local withoutClass = RPHelper.GetContentPool("entercombat", RPHelper.Race.TAUREN)
    local unauthoredClass = RPHelper.GetContentPool("entercombat", RPHelper.Race.TAUREN, "SKYBREAKER")
    equal(#unauthoredClass, #withoutClass)
    truthy(poolContainsText(unauthoredClass, "So be it."))
    truthy(poolContainsText(unauthoredClass, "For my ancestors!"))
end)

test("class registration appends without overwriting other content", function()
    RPHelper.RegisterClass(RPHelper.Class.WARRIOR, "test_class_append", { type = "say", text = "First." })
    RPHelper.RegisterClass(RPHelper.Class.WARRIOR, "test_class_append", { type = "say", text = "Second." })
    RPHelper.RegisterClass(RPHelper.Class.ROGUE, "test_class_append", { type = "say", text = "Other class." })

    local warrior = RPHelper.GetClassPool(RPHelper.Class.WARRIOR, "test_class_append")
    local rogue = RPHelper.GetClassPool(RPHelper.Class.ROGUE, "test_class_append")
    equal(#warrior, 2)
    equal(warrior[1].text, "First.")
    equal(warrior[2].text, "Second.")
    equal(#rogue, 1)
    equal(rogue[1].text, "Other class.")
end)

test("class content works without authored race content", function()
    local pool = RPHelper.GetContentPool("entercombat", "SKYBORNE", RPHelper.Class.HUNTER)
    truthy(poolContainsText(pool, "So be it."))
    truthy(poolContainsText(pool, "The hunt begins."))
end)

test("keyword and template entries remain eligible through the class layer", function()
    RPHelper.RegisterClass(RPHelper.Class.ROGUE, "test_class_dynamic", {
        type = "say",
        template = "{1}, {PLAYER}.",
        choices = { { "Ready" } },
    })

    local prepared = RPHelper.GetPreparedContentPool("test_class_dynamic", nil, RPHelper.Class.ROGUE, {
        resolvers = { PLAYER = function() return "Ari" end },
        randomIndex = function() return 1 end,
    })
    equal(#prepared, 1)
    equal(prepared[1].text, "Ready, Ari.")
end)

test("authored ability content is registered for each class", function()
    truthy(poolContainsText(
        RPHelper.GetAbilityPool(RPHelper.Class.WARRIOR, RPHelper.Ability.WARRIOR.REND),
        "Bleed for me, {TARGET}."
    ))
    truthy(poolContainsText(
        RPHelper.GetAbilityPool(RPHelper.Class.ROGUE, RPHelper.Ability.ROGUE.DISARM_TRAP),
        "You call this a trap?"
    ))
    truthy(poolContainsText(
        RPHelper.GetAbilityPool(RPHelper.Class.HUNTER, RPHelper.Ability.HUNTER.AIMED_SHOT),
        "Precision is everything."
    ))
end)

test("final class batch ability content is registered and class-scoped", function()
    truthy(poolContainsText(
        RPHelper.GetAbilityPool(RPHelper.Class.MAGE, RPHelper.Ability.MAGE.POLYMORPH),
        "Enjoy your new form, {TARGET}!"
    ))
    truthy(poolContainsText(
        RPHelper.GetAbilityPool(RPHelper.Class.PRIEST, RPHelper.Ability.PRIEST.RESURRECTION),
        "{TARGET}, your service in this world is not yet finished, awaken!"
    ))
    truthy(poolContainsText(
        RPHelper.GetAbilityPool(RPHelper.Class.WARLOCK, RPHelper.Ability.WARLOCK.DRAIN_SOUL),
        "Your soul is mine!"
    ))
    equal(#RPHelper.GetAbilityPool(RPHelper.Class.PRIEST, RPHelper.Ability.MAGE.POLYMORPH), 0)
end)

test("ability content is scoped by class", function()
    local hunterPool = RPHelper.GetAbilityPool(RPHelper.Class.HUNTER, RPHelper.Ability.HUNTER.AIMED_SHOT)
    local roguePool = RPHelper.GetAbilityPool(RPHelper.Class.ROGUE, RPHelper.Ability.HUNTER.AIMED_SHOT)
    truthy(#hunterPool > 0)
    equal(#roguePool, 0)
end)

test("ability registration appends rather than overwrites", function()
    RPHelper.RegisterAbility(RPHelper.Class.WARRIOR, "TEST_ABILITY", { type = "say", text = "First." })
    RPHelper.RegisterAbility(RPHelper.Class.WARRIOR, "TEST_ABILITY", { type = "say", text = "Second." })
    local pool = RPHelper.GetAbilityPool(RPHelper.Class.WARRIOR, "TEST_ABILITY")
    equal(#pool, 2)
    equal(pool[1].text, "First.")
    equal(pool[2].text, "Second.")
end)

test("keyword and template content prepares through the ability layer", function()
    RPHelper.RegisterAbility(RPHelper.Class.ROGUE, "TEST_DYNAMIC_ABILITY", {
        type = "say",
        template = "{1}, {TARGET}.",
        choices = { { "Behind you" } },
    })
    local prepared = RPHelper.GetPreparedAbilityPool(RPHelper.Class.ROGUE, "TEST_DYNAMIC_ABILITY", {
        resolvers = { TARGET = function() return "Dummy" end },
        randomIndex = function() return 1 end,
    })
    equal(#prepared, 1)
    equal(prepared[1].text, "Behind you, Dummy.")
end)

test("migrated Warlock NPC template prepares through the class layer", function()
    local prepared = RPHelper.GetPreparedContentPool("npctalksfriend", nil, RPHelper.Class.WARLOCK, {
        resolvers = {
            NPC = function() return "Mogg" end,
            LANG = function() return "Orcish" end,
        },
        randomIndex = function() return 1 end,
    })
    truthy(poolContainsText(prepared, "You spew Orcish like urine, Mogg."))
    truthy(poolContainsText(prepared, "Quiet Mogg. Unless you hope to be sent into the Twisting Nether."))
end)

test("missing ability content returns an empty pool safely", function()
    equal(#RPHelper.GetAbilityPool(RPHelper.Class.WARRIOR, "NOT_AUTHORED"), 0)
    equal(#RPHelper.GetAbilityPool("MAGE", "CHARGE"), 0)
end)

test("ability registration does not change character layer pooling", function()
    local pool = RPHelper.GetContentPool("entercombat", RPHelper.Race.TAUREN, RPHelper.Class.WARRIOR)
    truthy(poolContainsText(pool, "So be it."))
    truthy(poolContainsText(pool, "For my ancestors!"))
    truthy(poolContainsText(pool, "ROAR"))
    truthy(not poolContainsText(pool, "Bleed for me, {TARGET}."))
end)

test("Hunter pet-event content is registered and prepares explicit pet tokens", function()
    truthy(#RPHelper.GetClassPool(RPHelper.Class.HUNTER, "petattackstart") > 0)
    truthy(#RPHelper.GetClassPool(RPHelper.Class.HUNTER, "petattackstop") > 0)
    truthy(#RPHelper.GetClassPool(RPHelper.Class.HUNTER, "petdies") > 0)

    local prepared = RPHelper.GetPreparedContentPool("petattackstart", nil, RPHelper.Class.HUNTER, {
        resolvers = {
            PNAME = function() return "Fang" end,
            PTNAME = function() return "Boar" end,
            PTOP = function() return "it" end,
            TARGET = function() return "Boar" end,
        },
    })
    truthy(poolContainsText(prepared, "Go Fang! Tear them apart!"))
    truthy(poolContainsText(prepared, "Show it no mercy, Fang."))
    truthy(poolContainsText(prepared, "gestures towards Boar, signaling Fang to strike."))
end)

test("legacy spell critical content is deferred from the active trigger", function()
    for _, class in ipairs({
        RPHelper.Class.ROGUE,
        RPHelper.Class.HUNTER,
        RPHelper.Class.SHAMAN,
        RPHelper.Class.PALADIN,
        RPHelper.Class.MAGE,
        RPHelper.Class.PRIEST,
    }) do
        equal(#RPHelper.GetClassPool(class, "youcritspell"), 0)
        truthy(#RPHelper.GetClassPool(class, "deferred_youcritspell") > 0)
    end
end)

test("race content functions without a class layer", function()
    local previousClass = RPHelper.Content.class
    RPHelper.Content.class = nil
    local pool = RPHelper.GetContentPool("entercombat", RPHelper.Race.TAUREN)
    RPHelper.Content.class = previousClass

    truthy(#pool > 0)
    truthy(poolContainsText(pool, "For my ancestors!"))
end)

if failures > 0 then
    io.stderr:write(tostring(failures) .. " of " .. tostring(tests) .. " tests failed\n")
    os.exit(1)
end

print(tostring(tests) .. " tests passed")
