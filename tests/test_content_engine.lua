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
dofile("RPHelper/Core/Defaults.lua")
dofile("RPHelper/Core/Database.lua")
dofile("RPHelper/Core/KeywordResolvers.lua")
dofile("RPHelper/Core/DruidForms.lua")
dofile("RPHelper/Core/ContentEngine.lua")
dofile("RPHelper/Core/Content.lua")
dofile("RPHelper/Core/UserContent.lua")
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

test("Druid form detection uses stable form IDs", function()
    local Forms = RPHelper.DruidForms
    equal(Forms.GetCurrentForm({ getShapeshiftFormID = function() return nil end }), Forms.Form.HUMANOID)
    equal(Forms.GetCurrentForm({ getShapeshiftFormID = function() return 1 end }), Forms.Form.CAT)
    equal(Forms.GetCurrentForm({ getShapeshiftFormID = function() return 5 end }), Forms.Form.BEAR)
    equal(Forms.GetCurrentForm({ getShapeshiftFormID = function() return 8 end }), Forms.Form.DIRE_BEAR)
    equal(Forms.GetCurrentForm({ getShapeshiftFormID = function() return 31 end }), Forms.Form.MOONKIN)
    equal(Forms.GetCurrentForm({ getShapeshiftFormID = function() return 3 end }), Forms.Form.TRAVEL)
    equal(Forms.GetCurrentForm({ getShapeshiftFormID = function() return 4 end }), Forms.Form.AQUATIC)
    equal(Forms.GetCurrentForm({ getShapeshiftFormID = function() return 99 end }), Forms.Form.UNKNOWN)
    equal(Forms.GetCurrentForm({ getShapeshiftFormID = "unavailable" }), Forms.Form.UNKNOWN)
    equal(Forms.GetCurrentForm({ getShapeshiftFormID = function() error("unavailable") end }), Forms.Form.UNKNOWN)
end)

test("Druid speech is suppressed in recognised and unknown forms", function()
    for _, form in ipairs({ "CAT", "BEAR", "DIRE_BEAR", "MOONKIN", "TRAVEL", "AQUATIC", "UNKNOWN" }) do
        equal(Engine.PrepareCandidate(
            { type = "say", text = "Spoken." },
            { class = RPHelper.Class.DRUID, form = form, resolvers = {} }
        ), nil)
    end
end)

test("Druid speech returns in humanoid form and can be configured later", function()
    local humanoid = Engine.PrepareCandidate(
        { type = "say", text = "Spoken." },
        { class = RPHelper.Class.DRUID, form = "HUMANOID", resolvers = {} }
    )
    equal(humanoid.text, "Spoken.")

    local optedOut = Engine.PrepareCandidate(
        { type = "say", text = "Spoken." },
        { class = RPHelper.Class.DRUID, form = "CAT", suppressSayInForms = false, resolvers = {} }
    )
    equal(optedOut.text, "Spoken.")
end)

test("Druid speech suppression follows initialized saved settings", function()
    local previousDatabase = RPHelperDB
    RPHelperDB = nil
    RPHelper.InitializeDatabase()
    equal(RPHelperDB.settings.suppressSayInForms, true)

    RPHelperDB.settings.suppressSayInForms = false
    local candidate = Engine.PrepareCandidate(
        { type = "say", text = "Spoken." },
        { class = RPHelper.Class.DRUID, form = "CAT", resolvers = {} }
    )
    equal(candidate.text, "Spoken.")
    RPHelperDB = previousDatabase
end)

test("Cat and Bear use separate form content while Dire Bear shares Bear", function()
    local Forms = RPHelper.DruidForms.Form
    local cat = RPHelper.GetDruidFormPool(Forms.CAT, "entercombat")
    local bear = RPHelper.GetDruidFormPool(Forms.BEAR, "entercombat")
    local direBear = RPHelper.GetDruidFormPool(Forms.DIRE_BEAR, "entercombat")
    truthy(poolContainsText(cat, "lowers its body, muscles tightening beneath its fur."))
    truthy(not poolContainsText(cat, "digs its claws into the earth and lowers its head."))
    truthy(poolContainsText(bear, "digs its claws into the earth and lowers its head."))
    equal(direBear, bear)
end)

test("authored Druid form events replace incompatible humanoid content", function()
    local pool = RPHelper.GetContentPool(
        "entercombat", RPHelper.Race.TAUREN, RPHelper.Class.DRUID, { form = "CAT" }
    )
    truthy(poolContainsText(pool, "fixes its gaze upon its adversary, perfectly still."))
    truthy(not poolContainsText(pool, "For my ancestors!"))
    truthy(not poolContainsText(pool, "For nature's survival!"))
end)

test("emotes and custom emotes remain eligible in Druid forms", function()
    local prepared = Engine.PrepareCandidatePool({
        { type = "say", text = "Suppressed." },
        { type = "emote", text = "SNARL" },
        { type = "customemote", text = "bares its fangs." },
    }, { class = RPHelper.Class.DRUID, form = "CAT", resolvers = {} })
    equal(#prepared, 2)
    equal(prepared[1].type, "emote")
    equal(prepared[2].type, "customemote")
end)

test("speech suppression applies uniformly to every content source", function()
    local options = { class = RPHelper.Class.DRUID, form = "BEAR", resolvers = {} }
    local sources = {
        RPHelper.GetGenericPool("entercombat"),
        RPHelper.GetRacePool(RPHelper.Race.TAUREN, "entercombat"),
        RPHelper.GetClassPool(RPHelper.Class.DRUID, "entercombat"),
        RPHelper.GetAbilityPool(RPHelper.Class.DRUID, RPHelper.Ability.DRUID.ENTANGLING_ROOTS),
        { { type = "say", text = "User-authored speech." } },
    }
    for _, source in ipairs(sources) do
        local prepared = Engine.PrepareCandidatePool(source, options)
        for _, entry in ipairs(prepared) do
            truthy(entry.type ~= "say")
        end
    end
end)

test("form-restricted Druid abilities contain no spoken sayings", function()
    for _, ability in ipairs({
        RPHelper.Ability.DRUID.DEMORALIZING_ROAR,
        RPHelper.Ability.DRUID.ENRAGE,
        RPHelper.Ability.DRUID.TIGERS_FURY,
        RPHelper.Ability.DRUID.CHALLENGING_ROAR,
        RPHelper.Ability.DRUID.DIRE_BEAR_FORM,
    }) do
        local pool = RPHelper.GetAbilityPool(RPHelper.Class.DRUID, ability)
        truthy(#pool > 0)
        for _, entry in ipairs(pool) do
            truthy(entry.type == "emote" or entry.type == "customemote")
        end
    end
end)

test("unknown or unavailable form information fails safely", function()
    local unknown = Engine.PrepareCandidate(
        { type = "say", text = "Suppressed." },
        { class = RPHelper.Class.DRUID, getShapeshiftFormID = function() return 777 end, resolvers = {} }
    )
    equal(unknown, nil)

    local unavailable = Engine.PrepareCandidate(
        { type = "say", text = "Suppressed." },
        { class = RPHelper.Class.DRUID, getShapeshiftFormID = function() error("unavailable") end, resolvers = {} }
    )
    equal(unavailable, nil)
end)

test("non-Druid speech is unchanged by form information", function()
    local candidate = Engine.PrepareCandidate(
        { type = "say", text = "Still spoken." },
        { class = RPHelper.Class.HUNTER, form = "CAT", resolvers = {} }
    )
    equal(candidate.text, "Still spoken.")
end)

test("form-aware pooling does not alter other character content", function()
    local ordinary = RPHelper.GetContentPool("entercombat", RPHelper.Race.TAUREN, RPHelper.Class.HUNTER)
    local withForm = RPHelper.GetContentPool(
        "entercombat", RPHelper.Race.TAUREN, RPHelper.Class.HUNTER, { form = "CAT" }
    )
    equal(#withForm, #ordinary)
    truthy(poolContainsText(withForm, "So be it."))
    truthy(poolContainsText(withForm, "For my ancestors!"))
    truthy(poolContainsText(withForm, "The hunt begins."))
end)

test("ineligible Druid speech is removed before random selection", function()
    local selected = Engine.ChooseCandidate({
        { type = "say", text = "Suppressed." },
        { type = "customemote", text = "remains alert." },
    }, {
        class = RPHelper.Class.DRUID,
        form = "CAT",
        resolvers = {},
        randomIndex = function(size)
            equal(size, 1)
            return 1
        end,
    })
    equal(selected.text, "remains alert.")
end)

test("Druid form transitions are read without stale state", function()
    local formID = 1
    local options = {
        class = RPHelper.Class.DRUID,
        getShapeshiftFormID = function() return formID end,
        resolvers = {},
    }
    equal(Engine.PrepareCandidate({ type = "say", text = "Spoken." }, options), nil)
    formID = nil
    equal(Engine.PrepareCandidate({ type = "say", text = "Spoken." }, options).text, "Spoken.")
end)

local User = RPHelper.UserContent
local function customTest(name, callback)
    test("customization: " .. name, function()
        local saved = RPHelperDB
        RPHelperDB = nil
        RPHelper.InitializeDatabase()
        local ok, err = pcall(callback)
        RPHelperDB = saved
        User.Invalidate()
        if not ok then error(err, 2) end
    end)
end
local function customScope(layer, trigger, owner)
    local scope = { layer = layer, trigger = trigger }
    if layer == "race" then scope.race = owner end
    if layer == "class" then scope.class = owner end
    if layer == "druidForm" then scope.form = owner end
    return scope
end

customTest("CRUD persists copies and never reuses deleted IDs", function()
    local scope, entry = customScope("generic", "test_custom"), { type = "say", text = "Mine." }
    local id = User.Add(scope, entry)
    truthy(id)
    entry.text, scope.trigger = "Changed externally", "other"
    equal(User.List()[1].entry.text, "Mine.")
    local list = User.List()
    list[1].entry.text = "Changed list"
    equal(User.List()[1].entry.text, "Mine.")
    local db = RPHelperDB
    RPHelper.InitializeDatabase()
    equal(RPHelperDB, db)
    equal(User.List()[1].id, id)
    truthy(User.Edit(id, customScope("generic", "test_custom"), { type = "say", text = "Edited." }))
    equal(User.List()[1].entry.text, "Edited.")
    truthy(User.Remove(id))
    equal(#User.List(), 0)
    equal(User.Edit(id, customScope("generic", "test_custom"), entry), false)
    equal(User.Remove(id), false)
    equal(User.IsCustomEligible(id, customScope("generic", "test_custom")), false)
    truthy(User.Add(customScope("generic", "test_custom"), entry) ~= id)
end)

customTest("all layers and output types share selection without scope leakage", function()
    local trigger = "test_custom_layers"
    truthy(User.Add(customScope("generic", trigger), { type = "say", text = "Generic." }))
    truthy(User.Add(customScope("race", trigger, "TAUREN"), { type = "emote", text = "ROAR" }))
    truthy(User.Add(customScope("class", trigger, "WARRIOR"), { type = "customemote", text = "stands tall." }))
    equal(#RPHelper.GetPreparedContentPool(trigger, "TAUREN", "WARRIOR", { resolvers = {} }), 3)
    equal(#RPHelper.GetPreparedContentPool(trigger, "HUMAN", "MAGE", { resolvers = {} }), 1)
    equal(#RPHelper.GetContentPool("other", "TAUREN", "WARRIOR"), 0)
    local scope = { layer = "ability", class = "WARRIOR", ability = "TEST_CUSTOM" }
    truthy(User.Add(scope, { type = "say", text = "Ability." }))
    equal(#RPHelper.GetPreparedAbilityPool("WARRIOR", "TEST_CUSTOM", { resolvers = {} }), 1)
    equal(#RPHelper.GetAbilityContentPool("MAGE", "TEST_CUSTOM"), 0)
    equal(#RPHelper.GetAbilityContentPool("WARRIOR", "OTHER"), 0)
end)

customTest("missing target and pet data filter custom entries before selection", function()
    local scope = customScope("generic", "test_custom_context")
    local target = User.Add(scope, { type = "say", text = "Hello {TARGET}." })
    truthy(User.Add(scope, { type = "customemote", text = "pets {PNAME}." }))
    truthy(User.Add(scope, { type = "say", text = "Fallback." }))
    equal(User.IsCustomEligible(target, scope, { resolvers = {} }), false)
    equal(User.IsCustomEligible(target, customScope("generic", "other")), false)
    local pool = RPHelper.GetPreparedContentPool(scope.trigger, nil, nil, { resolvers = {} })
    equal(#pool, 1)
    equal(pool[1].text, "Fallback.")
    local options = { resolvers = { TARGET = function() return "Friend" end, PNAME = function() return "Wolf" end } }
    equal(#RPHelper.GetPreparedContentPool(scope.trigger, nil, nil, options), 3)
    truthy(User.IsCustomEligible(target, scope, options))
end)

customTest("templates use existing expansion and keyword preparation", function()
    local scope = customScope("generic", "test_custom_template")
    truthy(User.Add(scope, { type = "say", template = "{1} {PLAYER}!", choices = { { "Hello", "Welcome" } } }))
    local candidate = RPHelper.ChooseGenericCandidate(scope.trigger, {
        randomIndex = function() return 1 end, resolvers = { PLAYER = function() return "Ari" end } })
    equal(candidate.text, "Hello Ari!")
    equal(candidate.template, nil)
end)

customTest("invalid entries are rejected without mutation", function()
    local scope = customScope("generic", "test_custom_invalid")
    for _, entry in ipairs({ false, "bad", {}, { type = "unknown", text = "x" },
        { type = "say", text = "" }, { type = "say", text = "   " },
        { type = "say", text = "{UNKNOWN}" }, { type = "say", text = "{TARGET" },
        { type = "emote", text = "hello world" }, { type = "emote", template = "ROAR", choices = {} },
        { type = "say", template = "{1}", choices = {} },
        { type = "say", template = "{1}", choices = { { false } } },
        { type = "say", template = "{1}", choices = { { "{1}" } } },
        { type = "say", text = "both", template = "{1}", choices = { { "x" } } },
        { type = "say", template = "{0}", choices = { { "x" } } } }) do
        local id, err = User.Add(scope, entry)
        equal(id, nil); truthy(err)
    end
    equal(User.Add({ layer = "other", trigger = "x" }, { type = "say", text = "x" }), nil)
    equal(#User.List(), 0)
    equal(RPHelperDB.custom.nextID, 1)
end)

customTest("malformed and unsupported saved entries remain preserved and ineligible", function()
    local scope = customScope("generic", "test_custom_bad_saved")
    local saved = { [1] = "old", ["custom:1"] = false,
        ["custom:2"] = { scope = scope, entry = { type = "say", text = "{FUTURE}" }, unknown = 5 },
        ["custom:3"] = { scope = false, entry = { type = "say", text = "x" } },
        ["custom:4"] = { scope = scope, entry = false } }
    RPHelperDB.custom.entries = saved
    User.Invalidate()
    equal(#RPHelper.GetPreparedContentPool(scope.trigger), 0)
    RPHelper.InitializeDatabase()
    equal(RPHelperDB.custom.entries, saved)
    equal(saved["custom:2"].unknown, 5)
    truthy(saved["custom:2"].entry.text == "{FUTURE}")
    equal(Engine.PrepareCandidate(false), nil)
end)

customTest("duplicate custom text is independently editable and removable", function()
    local scope = customScope("generic", "test_custom_duplicate")
    local first = User.Add(scope, { type = "say", text = "Same." })
    local second = User.Add(scope, { type = "say", text = "Same." })
    truthy(first ~= second)
    equal(#RPHelper.GetContentPool(scope.trigger), 2)
    truthy(User.Remove(first))
    equal(#RPHelper.GetContentPool(scope.trigger), 1)
    equal(User.List()[1].id, second)
end)

customTest("disabled default is removed from mixed pool and restored", function()
    local trigger = "test_custom_mix"
    RPHelper.RegisterGeneric(trigger, { type = "say", text = "Shipped." })
    local entry = RPHelper.GetGenericPool(trigger)[1]
    truthy(User.Add(customScope("generic", trigger), { type = "say", text = "Custom." }))
    equal(#RPHelper.GetContentPool(trigger), 2)
    truthy(User.SetDefaultDisabled(entry.defaultID, true))
    truthy(User.IsDefaultDisabled(entry.defaultID))
    equal(#RPHelper.GetPreparedContentPool(trigger), 1)
    equal(RPHelper.ChooseGenericCandidate(trigger).text, "Custom.")
    truthy(User.SetDefaultDisabled(entry.defaultID, false))
    equal(#RPHelper.GetPreparedGenericPool(trigger), 2)
    equal(#RPHelper.GetGenericPool(trigger), 1)
end)

customTest("shipped duplicate text and reused input table have independent IDs", function()
    local entry = { type = "say", text = "Same default." }
    RPHelper.RegisterGeneric("test_default_duplicate", entry)
    RPHelper.RegisterGeneric("test_default_duplicate", entry)
    local pool = RPHelper.GetGenericPool("test_default_duplicate")
    truthy(pool[1].defaultID ~= pool[2].defaultID)
    truthy(User.SetDefaultDisabled(pool[1].defaultID, true))
    local selected = RPHelper.GetContentPool("test_default_duplicate")
    equal(#selected, 1)
    equal(selected[1].defaultID, pool[2].defaultID)
    equal(entry.defaultID, nil)
end)

customTest("identities distinguish scope type and template choices", function()
    local trigger = "test_default_identity"
    RPHelper.RegisterGeneric(trigger, { type = "say", text = "Same." })
    RPHelper.RegisterRace("TAUREN", trigger, { type = "say", text = "Same." })
    RPHelper.RegisterClass("WARRIOR", trigger, { type = "say", text = "Same." })
    RPHelper.RegisterAbility("WARRIOR", "TEST_IDENTITY", { type = "say", text = "Same." })
    RPHelper.RegisterGeneric(trigger, { type = "customemote", text = "Same." })
    RPHelper.RegisterGeneric(trigger, { type = "say", template = "{1}", choices = { { "x" } } })
    RPHelper.RegisterGeneric(trigger, { type = "say", template = "{1}", choices = { { "y" } } })
    local seen = {}
    local pool = RPHelper.GetContentPool(trigger, "TAUREN", "WARRIOR")
    pool[#pool + 1] = RPHelper.GetAbilityPool("WARRIOR", "TEST_IDENTITY")[1]
    for _, entry in ipairs(pool) do truthy(not seen[entry.defaultID]);seen[entry.defaultID] = true end
end)

customTest("reload and unrelated additions preserve IDs while text edits get new identities", function()
    local previous = RPHelper.Content
    local ok, err = pcall(function()
        RPHelper.Content = nil; dofile("RPHelper/Core/Content.lua")
        RPHelper.RegisterGeneric("test_reload", { type = "say", text = "Original." })
        local id = RPHelper.GetGenericPool("test_reload")[1].defaultID
        truthy(User.SetDefaultDisabled(id, true))
        RPHelper.Content = nil; dofile("RPHelper/Core/Content.lua")
        RPHelper.RegisterGeneric("test_reload", { type = "say", text = "New addition." })
        RPHelper.RegisterGeneric("test_reload", { type = "say", text = "Original." })
        equal(RPHelper.GetGenericPool("test_reload")[2].defaultID, id)
        RPHelper.RegisterGeneric("test_reload", { type = "say", text = "Edited original." })
        equal(#RPHelper.GetContentPool("test_reload"), 2)
        RPHelper.InitializeDatabase()
        truthy(User.IsDefaultDisabled(id))
    end)
    RPHelper.Content = previous
    if not ok then error(err) end
end)

customTest("obsolete IDs are harmless and custom defaultID spoofing cannot filter custom content", function()
    local obsolete = "default:v1:removed:1"
    truthy(User.SetDefaultDisabled(obsolete, true))
    local scope = customScope("generic", "test_custom_spoof")
    local id = User.Add(scope, { type = "say", text = "Mine.", defaultID = obsolete })
    RPHelperDB.custom.entries[id].entry.defaultID = obsolete
    User.Invalidate()
    equal(#RPHelper.GetContentPool(scope.trigger), 1)
    equal(RPHelper.GetContentPool(scope.trigger)[1].defaultID, nil)
    truthy(User.IsDefaultDisabled(obsolete))
    equal(User.SetDefaultDisabled(id, true), false)
end)

customTest("form replacement and speech suppression apply to custom content", function()
    local trigger = "test_custom_form"
    RPHelper.RegisterGeneric(trigger, { type = "say", text = "Humanoid." })
    RPHelper.RegisterDruidForm("CAT", trigger, { type = "emote", text = "ROAR" })
    local scope = customScope("generic", trigger)
    truthy(User.Add(scope, { type = "say", text = "Custom speech." }))
    truthy(User.Add(scope, { type = "customemote", text = "bares its fangs." }))
    truthy(User.Add(customScope("druidForm", trigger, "CAT"), { type = "emote", text = "GROWL" }))
    local options = { class = "DRUID", form = "CAT", resolvers = {} }
    local pool = RPHelper.GetPreparedContentPool(trigger, "TAUREN", "DRUID", options)
    equal(#pool, 3)
    for _, entry in ipairs(pool) do truthy(entry.type ~= "say") end
    truthy(User.SetDefaultDisabled(RPHelper.GetDruidFormPool("CAT", trigger)[1].defaultID, true))
    equal(#RPHelper.GetPreparedContentPool(trigger, nil, "DRUID", options), 2)
    RPHelperDB.settings.suppressSayInForms = false
    equal(#RPHelper.GetPreparedContentPool(trigger, nil, "DRUID", options), 3)
end)

customTest("index is reused and edits invalidate it", function()
    local scope = customScope("generic", "test_custom_cache")
    local id = User.Add(scope, { type = "say", text = "First." })
    local previous, calls = Engine.ValidateEntry, 0
    Engine.ValidateEntry = function(...) calls = calls + 1;return previous(...) end
    local ok, err = pcall(function()
        RPHelper.GetContentPool(scope.trigger)
        local first = calls
        truthy(first > 0)
        RPHelper.GetContentPool(scope.trigger)
        equal(calls, first)
        truthy(User.Edit(id, scope, { type = "say", text = "Edited." }))
        equal(RPHelper.GetContentPool(scope.trigger)[1].text, "Edited.")
        truthy(calls > first)
    end)
    Engine.ValidateEntry = previous
    if not ok then error(err) end
end)

customTest("fresh partial and repeated initialization preserve choices and unknown fields", function()
    local settings, triggers = { enabled = false, future = 7 }, { dodge = { enabled = false, chance = 0.7 } }
    local abilities = { PALADIN = { FLASH_OF_LIGHT = { enabled = false, cooldown = 99 } }, FUTURE = { x = 1 } }
    local custom = { authored = { "Legacy data." }, entries = {}, nextID = 9, future = 4 }
    RPHelperDB = { schemaVersion = 7, settings = settings, triggers = triggers, abilities = abilities,
        custom = custom, disabledDefaults = { ["default:v1:obsolete"] = true }, future = { x = 3 } }
    local root = RPHelperDB
    RPHelper.InitializeDatabase();RPHelper.InitializeDatabase()
    equal(RPHelperDB, root);equal(root.settings, settings);equal(root.custom, custom)
    equal(settings.enabled, false);equal(settings.future, 7)
    equal(triggers.dodge.chance, 0.7);equal(abilities.PALADIN.FLASH_OF_LIGHT.cooldown, 99)
    equal(abilities.FUTURE.x, 1);equal(custom.nextID, 9);equal(custom.authored[1], "Legacy data.")
    equal(root.schemaVersion, 7);equal(root.future.x, 3)
    truthy(root.disabledDefaults["default:v1:obsolete"])
    local id = User.Add(customScope("generic", "future_trigger"), { type = "say", text = "Future." })
    RPHelper.InitializeDatabase()
    equal(User.List()[1].id, id)
end)

customTest("malformed root and custom containers survive initialization and API calls", function()
    for _, value in ipairs({ false, true, 42, "bad" }) do
        for _, kind in ipairs({ "root", "custom", "entries", "disabledDefaults" }) do
            RPHelperDB = {}
            if kind == "root" then RPHelperDB = value
            elseif kind == "entries" then RPHelperDB.custom = { entries = value }
            else RPHelperDB[kind] = value end
            RPHelper.InitializeDatabase()
            if kind == "root" then equal(RPHelperDB, value)
            elseif kind == "entries" then equal(RPHelperDB.custom.entries, value)
            else equal(RPHelperDB[kind], value) end
            if kind ~= "disabledDefaults" then
                equal(User.Add(customScope("generic", "test_malformed"), { type = "say", text = "x" }), nil)
                equal(User.List(), nil)
                equal(User.Edit("custom:1", customScope("generic", "test_malformed"), { type = "say", text = "x" }), false)
                equal(User.Remove("custom:1"), false)
            else equal(User.SetDefaultDisabled("default:v1:x", true), false) end
            equal(#RPHelper.GetPreparedContentPool("test_malformed", nil, "DRUID", { form = "CAT" }), 0)
        end
    end
end)

customTest("unknown fields survive edits and malformed counter is never replaced", function()
    local scope = customScope("generic", "test_custom_unknown")
    local id = User.Add(scope, { type = "say", text = "First." })
    local record = RPHelperDB.custom.entries[id]
    record.future, record.entry.future, record.scope.future = 4, 5, 6
    truthy(User.Edit(id, scope, { type = "customemote", text = "Edited." }))
    equal(record.future, 4);equal(record.entry.future, 5);equal(record.scope.future, 6)
    RPHelperDB.custom.nextID = false
    RPHelper.InitializeDatabase()
    equal(RPHelperDB.custom.nextID, false)
    equal(User.Add(scope, { type = "say", text = "x" }), nil)
    equal(User.List()[1].id, id)
end)

customTest("secret context uses shared keyword guards without leaking values", function()
    local scope = customScope("generic", "test_custom_secret")
    local id = User.Add(scope, { type = "say", text = "Hello {TARGET}." })
    local inspect = issecretvalue
    local ok, err = pcall(function()
        issecretvalue = function(value) return value == "secret" end
        equal(User.IsCustomEligible(id, scope, { resolvers = { TARGET = function() return "secret" end } }), false)
        equal(#RPHelper.GetPreparedContentPool(scope.trigger, nil, nil,
            { resolvers = { TARGET = function() error("restricted") end } }), 0)
    end)
    issecretvalue = inspect
    if not ok then error(err) end
end)

customTest("database replacement and reinitialization never reuse another character's cache", function()
    local scope = customScope("generic", "test_custom_character")
    truthy(User.Add(scope, { type = "say", text = "First character." }))
    equal(RPHelper.GetContentPool(scope.trigger)[1].text, "First character.")
    local first = RPHelperDB
    RPHelperDB = nil; RPHelper.InitializeDatabase()
    equal(#RPHelper.GetContentPool(scope.trigger), 0)
    truthy(User.Add(scope, { type = "say", text = "Second character." }))
    equal(RPHelper.GetContentPool(scope.trigger)[1].text, "Second character.")
    RPHelperDB = first
    equal(RPHelper.GetContentPool(scope.trigger)[1].text, "First character.")
    first.custom.entries["custom:1"].entry.text = "Direct repair."
    RPHelper.InitializeDatabase()
    equal(RPHelper.GetContentPool(scope.trigger)[1].text, "Direct repair.")
end)

customTest("schema values and malformed nested overrides are preserved during upgrades", function()
    for _, schema in ipairs({ false, 0, 9 }) do
        RPHelperDB = { schemaVersion = schema, settings = false, triggers = { dodge = "future" },
            abilities = { PALADIN = false }, custom = { entries = {}, nextID = 1, future = "preserved" } }
        RPHelper.InitializeDatabase();RPHelper.InitializeDatabase()
        equal(RPHelperDB.schemaVersion, schema)
        equal(RPHelperDB.settings, false);equal(RPHelperDB.triggers.dodge, "future")
        equal(RPHelperDB.abilities.PALADIN, false);equal(RPHelperDB.custom.future, "preserved")
    end
end)

customTest("invalid edits leave a valid entry and cache unchanged", function()
    local scope = customScope("generic", "test_custom_invalid_edit")
    local id = User.Add(scope, { type = "say", text = "Original." })
    equal(RPHelper.GetContentPool(scope.trigger)[1].text, "Original.")
    equal(User.Edit(id, scope, { type = "say", text = "{UNKNOWN}" }), false)
    equal(User.Edit(id, { layer = "bad" }, { type = "say", text = "Replacement." }), false)
    equal(User.List()[1].entry.text, "Original.")
    equal(RPHelper.GetContentPool(scope.trigger)[1].text, "Original.")
end)

if failures > 0 then
    io.stderr:write(tostring(failures) .. " of " .. tostring(tests) .. " tests failed\n")
    os.exit(1)
end

print(tostring(tests) .. " tests passed")
