local failures, tests = 0, 0
local function test(name, fn)
    tests = tests + 1
    local ok, err = pcall(fn)
    if not ok then failures = failures + 1; io.stderr:write("FAIL: " .. name .. "\n  " .. tostring(err) .. "\n") end
end
local function equal(a, b) if a ~= b then error("expected " .. tostring(b) .. ", got " .. tostring(a), 2) end end
local function truthy(v) if not v then error("expected truthy value", 2) end end

RPHelper = {}
dofile("RPHelper/Core/Defaults.lua")
dofile("RPHelper/Core/Database.lua")
dofile("RPHelper/Core/Configuration.lua")
RPHelper.ContentEngine = { ValidateEntry = function() return true end, PrepareCandidate = function(e) return e end }
dofile("RPHelper/Core/UserContent.lua")
local Config, User = RPHelper.Configuration, RPHelper.UserContent
local scope = { layer = "generic", trigger = "dodge" }
local entry = { type = "say", text = "Too slow!" }

test("fresh character stores sparse schema v2", function()
    RPHelperDB = nil; truthy(RPHelper.InitializeDatabase())
    equal(RPHelperDB.schemaVersion, 2); equal(next(RPHelperDB.settings), nil)
    equal(next(RPHelperDB.triggers), nil); equal(next(RPHelperDB.abilities), nil)
    equal(next(RPHelperDB.reactionOverrides), nil)
end)

test("defaults resolve without materialized overrides", function()
    equal(Config.GetSetting("reactionChance"), 0.05); equal(Config.GetSetting("globalCooldown"), 20)
    equal(Config.GetSetting("encounterQuotaEnabled"), false)
    equal(Config.GetSetting("maxAutomaticOutputsPerCombat"), 2)
    equal(Config.GetSetting("dungeonSayMode"), "broadcast"); equal(next(RPHelperDB.settings), nil)
end)

test("explicit overrides persist and reset to inheritance", function()
    truthy(Config.SetSetting("reactionChance", 0)); truthy(Config.SetSetting("encounterQuotaEnabled", true))
    RPHelper.InitializeDatabase(); equal(Config.GetSetting("reactionChance"), 0); equal(Config.GetSetting("encounterQuotaEnabled"), true)
    truthy(Config.ResetSetting("reactionChance")); equal(RPHelperDB.settings.reactionChance, nil)
    equal(Config.GetSetting("reactionChance"), 0.05)
end)

test("event overrides are sparse and independently validated", function()
    truthy(Config.SetEventSetting("trigger", nil, "dodge", "enabled", false))
    truthy(Config.SetEventSetting("trigger", nil, "dodge", "chance", 0))
    truthy(Config.SetEventSetting("trigger", nil, "dodge", "priority", true))
    equal(Config.GetEventSetting("trigger", nil, "dodge", "enabled"), false)
    equal(Config.GetEventSetting("trigger", nil, "dodge", "chance"), 0)
    truthy(Config.ResetEventSetting("trigger", nil, "dodge", "chance"))
    equal(Config.GetEventSetting("trigger", nil, "dodge", "chance"), 0.05)
end)

test("built-in activation and positive weights use separate overrides", function()
    local id = "default:generic:dodge:0001"
    truthy(Config.SetDefaultEnabled(id, false)); equal(Config.IsDefaultEnabled(id), false)
    truthy(Config.SetDefaultWeight(id, 3)); equal(Config.GetDefaultWeight(id), 3)
    equal(Config.SetDefaultWeight(id, 0), false); equal(Config.GetDefaultWeight(id), 3)
    truthy(Config.ResetDefaultWeight(id)); equal(Config.GetDefaultWeight(id), 1)
    truthy(Config.SetDefaultEnabled(id, true)); equal(RPHelperDB.disabledDefaults[id], nil)
end)

test("rejected writes do not create sparse override containers", function()
    RPHelperDB = nil; RPHelper.InitializeDatabase()
    local triggers, abilities, reactions = RPHelperDB.triggers, RPHelperDB.abilities, RPHelperDB.reactionOverrides

    local ok, err = Config.SetEventSetting("trigger", nil, "dodge", "chance", 2)
    equal(ok, false); equal(err, "invalid_value"); equal(next(triggers), nil)
    equal(RPHelperDB.triggers, triggers)

    ok, err = Config.SetEventSetting("ability", "PALADIN", "FLASH_OF_LIGHT", "priority", "yes")
    equal(ok, false); equal(err, "invalid_value"); equal(next(abilities), nil)
    equal(RPHelperDB.abilities, abilities)

    ok, err = Config.SetDefaultWeight("default:generic:dodge:0001", 0)
    equal(ok, false); equal(err, "invalid_value"); equal(next(reactions), nil)
    equal(RPHelperDB.reactionOverrides, reactions)
end)

test("rejected writes preserve existing valid override records", function()
    RPHelperDB = nil; RPHelper.InitializeDatabase()
    truthy(Config.SetEventSetting("trigger", nil, "dodge", "enabled", false))
    truthy(Config.SetDefaultWeight("default:generic:dodge:0001", 4))
    local eventRecord = RPHelperDB.triggers.dodge
    local reactionRecord = RPHelperDB.reactionOverrides["default:generic:dodge:0001"]

    equal(Config.SetEventSetting("trigger", nil, "dodge", "chance", -1), false)
    equal(Config.SetDefaultWeight("default:generic:dodge:0001", 1.5), false)
    equal(RPHelperDB.triggers.dodge, eventRecord); equal(eventRecord.enabled, false)
    equal(eventRecord.chance, nil)
    equal(RPHelperDB.reactionOverrides["default:generic:dodge:0001"], reactionRecord)
    equal(reactionRecord.weight, 4)
end)

test("custom CRUD activation and weight persist", function()
    local id = User.Add(scope, entry); equal(id, "custom:1")
    truthy(User.Edit(id, scope, { type = "customemote", text = "sidesteps." }))
    truthy(User.SetEnabled(id, false)); equal(User.IsEnabled(id), false)
    truthy(User.SetWeight(id, 4)); equal(User.GetWeight(id), 4)
    RPHelper.InitializeDatabase(); equal(User.List()[1].entry.type, "customemote")
    equal(User.List()[1].enabled, false); equal(User.List()[1].weight, 4)
    equal(User.SetWeight(id, -1), false); truthy(User.Remove(id)); equal(#User.List(), 0)
end)

test("malformed values remain stored but resolve safely", function()
    RPHelperDB.settings.globalCooldown = "future"
    RPHelperDB.triggers.dodge = { enabled = "future", chance = 2, unknown = 9 }
    equal(Config.GetSetting("globalCooldown"), 20)
    equal(Config.GetEventSetting("trigger", nil, "dodge", "enabled"), true)
    equal(Config.GetEventSetting("trigger", nil, "dodge", "chance"), 0.05)
    equal(RPHelperDB.settings.globalCooldown, "future"); equal(RPHelperDB.triggers.dodge.unknown, 9)
end)

test("invalid structures and unsupported schemas are non-destructive", function()
    local malformed = { schemaVersion = 2, settings = false, triggers = {}, abilities = {}, custom = false,
        disabledDefaults = {}, reactionOverrides = {}, future = { keep = true } }
    RPHelperDB = malformed; truthy(RPHelper.InitializeDatabase()); equal(RPHelperDB.settings, false); truthy(RPHelperDB.future.keep)
    local newer = { schemaVersion = 3, future = "keep" }; RPHelperDB = newer
    equal(RPHelper.InitializeDatabase(), false); equal(RPHelperDB, newer); equal(newer.future, "keep")
end)

test("character databases remain isolated", function()
    RPHelperDB = nil; RPHelper.InitializeDatabase(); Config.SetSetting("reactionChance", 0.1); local first = RPHelperDB
    RPHelperDB = nil; RPHelper.InitializeDatabase(); equal(Config.GetSetting("reactionChance"), 0.05)
    Config.SetSetting("reactionChance", 0.2); local second = RPHelperDB
    RPHelperDB = first; equal(Config.GetSetting("reactionChance"), 0.1)
    RPHelperDB = second; equal(Config.GetSetting("reactionChance"), 0.2)
end)

if failures > 0 then io.stderr:write(failures .. " of " .. tests .. " tests failed\n"); os.exit(1) end
print(tests .. " tests passed")
