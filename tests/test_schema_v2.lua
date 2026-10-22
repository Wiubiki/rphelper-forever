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

test("explicit false global settings resolve without falling back", function()
    truthy(Config.SetSetting("enabled", false))
    equal(Config.GetSetting("enabled"), false)
    equal(RPHelperDB.settings.enabled, false)
    truthy(Config.ResetSetting("enabled"))
    equal(Config.GetSetting("enabled"), true)
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

test("reaction weight contract accepts only integers from 1 through 10", function()
    RPHelperDB = nil; RPHelper.InitializeDatabase()
    local defaultID = "default:test:weight_contract"
    truthy(Config.SetDefaultWeight(defaultID, 1)); equal(Config.GetDefaultWeight(defaultID), 1)
    truthy(Config.SetDefaultWeight(defaultID, 10)); equal(Config.GetDefaultWeight(defaultID), 10)
    local invalid = { 0, 11, -1, 1.5, "2", 0 / 0, math.huge, -math.huge }
    for _, value in ipairs(invalid) do
        equal(Config.SetDefaultWeight(defaultID, value), false)
        equal(Config.GetDefaultWeight(defaultID), 10)
    end

    local id = User.Add(scope, entry, { weight = 1 }); truthy(id)
    truthy(User.SetWeight(id, 10)); equal(User.GetWeight(id), 10)
    for _, value in ipairs(invalid) do
        equal(User.SetWeight(id, value), false)
        equal(User.GetWeight(id), 10)
        local added = User.Add(scope, entry, { weight = value })
        equal(added, nil)
    end
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
    truthy(User.SetEnabled(id, true)); equal(User.IsEnabled(id), true)
    equal(RPHelperDB.custom.entries[id].enabled, nil)
    truthy(User.SetEnabled(id, false))
    truthy(User.SetWeight(id, 4)); equal(User.GetWeight(id), 4)
    RPHelper.InitializeDatabase(); equal(User.List()[1].entry.type, "customemote")
    equal(User.List()[1].enabled, false); equal(User.List()[1].weight, 4)
    equal(User.SetWeight(id, -1), false); truthy(User.Remove(id)); equal(#User.List(), 0)
end)

test("custom edit applies validated metadata atomically and preserves unknown fields", function()
    RPHelperDB = nil; RPHelper.InitializeDatabase()
    local id = User.Add(scope, entry, { weight = 2 }); truthy(id)
    RPHelperDB.custom.entries[id].future = "keep"
    truthy(User.Edit(id, scope, { type = "say", text = "Changed." },
        { enabled = false, weight = 10 }))
    equal(RPHelperDB.custom.entries[id].entry.text, "Changed.")
    equal(RPHelperDB.custom.entries[id].enabled, false)
    equal(RPHelperDB.custom.entries[id].weight, 10)
    equal(RPHelperDB.custom.entries[id].future, "keep")
    equal(User.Edit(id, scope, { type = "say", text = "Rejected." },
        { enabled = true, weight = 11 }), false)
    equal(RPHelperDB.custom.entries[id].entry.text, "Changed.")
    equal(RPHelperDB.custom.entries[id].enabled, false)
    equal(RPHelperDB.custom.entries[id].weight, 10)
end)

test("modified copies retain source activation weight and immutable content", function()
    RPHelperDB = nil; RPHelper.InitializeDatabase()
    local defaultID = "default:test:copy_source"
    truthy(Config.SetDefaultWeight(defaultID, 4))
    local rejected = User.CreateModifiedCopy(defaultID, scope,
        { type = "say", text = "Rejected copy." }, { weight = 11 })
    equal(rejected, nil); equal(RPHelperDB.custom.nextID, 1)
    equal(Config.IsDefaultEnabled(defaultID), true); equal(Config.GetDefaultWeight(defaultID), 4)
    local id = User.CreateModifiedCopy(defaultID, scope,
        { type = "say", text = "Copied." }, { enabled = true, weight = 3 })
    truthy(id)
    equal(Config.IsDefaultEnabled(defaultID), true)
    equal(Config.GetDefaultWeight(defaultID), 4)
    equal(RPHelperDB.custom.entries[id].sourceDefaultID, defaultID)
    truthy(User.Edit(id, scope, { type = "say", text = "Edited copy." }))
    equal(Config.IsDefaultEnabled(defaultID), true)
    equal(Config.GetDefaultWeight(defaultID), 4)
end)

test("atomic event editor update preserves unknown fields and clears chance inheritance", function()
    RPHelperDB = nil; RPHelper.InitializeDatabase()
    RPHelperDB.triggers.dodge = { future = "keep" }
    truthy(Config.UpdateEventSettings("trigger", nil, "dodge",
        { enabled = false, chance = 0, priority = true }))
    equal(Config.GetEventOverride("trigger", nil, "dodge", "chance"), 0)
    equal(RPHelperDB.triggers.dodge.future, "keep")
    truthy(Config.UpdateEventSettings("trigger", nil, "dodge", { resetChance = true }))
    equal(Config.GetEventOverride("trigger", nil, "dodge", "chance"), nil)
    equal(Config.GetEventSetting("trigger", nil, "dodge", "chance"), 0.05)
    local record = RPHelperDB.triggers.dodge
    equal(Config.UpdateEventSettings("trigger", nil, "dodge",
        { enabled = true, chance = 2, priority = false }), false)
    equal(RPHelperDB.triggers.dodge, record)
    equal(record.enabled, false); equal(record.priority, true); equal(record.future, "keep")
end)

test("malformed values remain stored but resolve safely", function()
    RPHelperDB.settings.globalCooldown = "future"
    RPHelperDB.triggers.dodge = { enabled = "future", chance = 2, unknown = 9 }
    equal(Config.GetSetting("globalCooldown"), 20)
    equal(Config.GetEventSetting("trigger", nil, "dodge", "enabled"), true)
    equal(Config.GetEventSetting("trigger", nil, "dodge", "chance"), 0.05)
    equal(RPHelperDB.settings.globalCooldown, "future"); equal(RPHelperDB.triggers.dodge.unknown, 9)
    RPHelperDB.reactionOverrides["default:test:bad_weight"] = { weight = 11, future = true }
    local id = User.Add(scope, entry); truthy(id)
    RPHelperDB.custom.entries[id].weight = math.huge
    equal(Config.GetDefaultWeight("default:test:bad_weight"), 1)
    equal(User.GetWeight(id), 1)
    equal(RPHelperDB.reactionOverrides["default:test:bad_weight"].weight, 11)
    equal(RPHelperDB.custom.entries[id].weight, math.huge)
end)

test("invalid structures and unsupported schemas are non-destructive", function()
    local malformed = { schemaVersion = 2, settings = false, triggers = {}, abilities = {}, custom = false,
        disabledDefaults = {}, reactionOverrides = {}, future = { keep = true } }
    RPHelperDB = malformed; truthy(RPHelper.InitializeDatabase()); equal(RPHelperDB.settings, false); truthy(RPHelperDB.future.keep)
    equal(Config.GetSetting("enabled"), true); equal(Config.CanWriteSettings(), false)
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
