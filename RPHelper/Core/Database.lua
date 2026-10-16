RPHelper = RPHelper or {}

local function copyTable(value)
    if type(value) ~= "table" then
        return value
    end

    local result = {}
    for key, child in pairs(value) do
        result[key] = copyTable(child)
    end
    return result
end

local function applyMissing(target, defaults)
    for key, value in pairs(defaults) do
        if target[key] == nil then
            target[key] = copyTable(value)
        elseif type(value) == "table" and type(target[key]) == "table" then
            applyMissing(target[key], value)
        end
    end
end

-- Approved Shaman identity rename. Keep this migration narrow and idempotent:
-- saved custom entries, per-ability settings and disabled shipped reactions all
-- use the canonical ability key independently of the active catalogue.
local function migrateShamanFireNova()
    local oldKey, newKey = "FIRE_NOVA_TOTEM", "FIRE_NOVA"

    if type(RPHelperDB.custom) == "table" and type(RPHelperDB.custom.entries) == "table" then
        for _, record in pairs(RPHelperDB.custom.entries) do
            local scope = type(record) == "table" and record.scope
            if type(scope) == "table" and scope.layer == "ability"
                and scope.class == "SHAMAN" and scope.ability == oldKey then
                scope.ability = newKey
            end
        end
    end

    local shaman = type(RPHelperDB.abilities) == "table" and RPHelperDB.abilities.SHAMAN
    if type(shaman) == "table" and shaman[oldKey] ~= nil then
        if shaman[newKey] == nil then
            shaman[newKey], shaman[oldKey] = shaman[oldKey], nil
        elseif type(shaman[newKey]) == "table" and type(shaman[oldKey]) == "table" then
            applyMissing(shaman[newKey], shaman[oldKey])
            shaman[oldKey] = nil
        end
        -- Malformed conflicting values are preserved under the old key rather
        -- than guessed at or discarded.
    end

    if type(RPHelperDB.disabledDefaults) == "table" then
        local oldPrefix = "default:v1:s7:abilitys6:SHAMANs15:" .. oldKey
        local newPrefix = "default:v1:s7:abilitys6:SHAMANs9:" .. newKey
        local migrated = {}
        for id, disabled in pairs(RPHelperDB.disabledDefaults) do
            if disabled == true and type(id) == "string" and string.sub(id, 1, #oldPrefix) == oldPrefix then
                migrated[#migrated + 1] = { old = id, new = newPrefix .. string.sub(id, #oldPrefix + 1) }
            end
        end
        for _, ids in ipairs(migrated) do
            if RPHelperDB.disabledDefaults[ids.new] == nil then
                RPHelperDB.disabledDefaults[ids.new] = true
            end
            RPHelperDB.disabledDefaults[ids.old] = nil
        end
    end
end

-- Approved Druid identity rename. This deliberately mirrors the narrow Shaman
-- migration rather than introducing a general-purpose migration framework.
local function migrateDruidPrimalBite()
    local oldKey, newKey = "SAVAGE_BITE", "PRIMAL_BITE"

    if type(RPHelperDB.custom) == "table" and type(RPHelperDB.custom.entries) == "table" then
        for _, record in pairs(RPHelperDB.custom.entries) do
            local scope = type(record) == "table" and record.scope
            if type(scope) == "table" and scope.layer == "ability"
                and scope.class == "DRUID" and scope.ability == oldKey then
                scope.ability = newKey
            end
        end
    end

    local druid = type(RPHelperDB.abilities) == "table" and RPHelperDB.abilities.DRUID
    if type(druid) == "table" and druid[oldKey] ~= nil then
        if druid[newKey] == nil then
            druid[newKey], druid[oldKey] = druid[oldKey], nil
        elseif type(druid[newKey]) == "table" and type(druid[oldKey]) == "table" then
            applyMissing(druid[newKey], druid[oldKey])
            druid[oldKey] = nil
        end
        -- Malformed conflicting values remain under the old key rather than
        -- being guessed at or discarded.
    end

    if type(RPHelperDB.disabledDefaults) == "table" then
        local oldPrefix = "default:v1:s7:abilitys5:DRUIDs11:" .. oldKey
        local newPrefix = "default:v1:s7:abilitys5:DRUIDs11:" .. newKey
        local migrated = {}
        for id, disabled in pairs(RPHelperDB.disabledDefaults) do
            if disabled == true and type(id) == "string" and string.sub(id, 1, #oldPrefix) == oldPrefix then
                migrated[#migrated + 1] = { old = id, new = newPrefix .. string.sub(id, #oldPrefix + 1) }
            end
        end
        for _, ids in ipairs(migrated) do
            if RPHelperDB.disabledDefaults[ids.new] == nil then
                RPHelperDB.disabledDefaults[ids.new] = true
            end
            RPHelperDB.disabledDefaults[ids.old] = nil
        end
    end
end

-- Approved Druid identity replacement. Preserve the historical Tiger's Fury
-- saved state under Shifting Power without changing unrelated Druid records.
local function migrateDruidShiftingPower()
    local oldKey, newKey = "TIGERS_FURY", "SHIFTING_POWER"

    if type(RPHelperDB.custom) == "table" and type(RPHelperDB.custom.entries) == "table" then
        for _, record in pairs(RPHelperDB.custom.entries) do
            local scope = type(record) == "table" and record.scope
            if type(scope) == "table" and scope.layer == "ability"
                and scope.class == "DRUID" and scope.ability == oldKey then
                scope.ability = newKey
            end
        end
    end

    local druid = type(RPHelperDB.abilities) == "table" and RPHelperDB.abilities.DRUID
    if type(druid) == "table" and druid[oldKey] ~= nil then
        if druid[newKey] == nil then
            druid[newKey], druid[oldKey] = druid[oldKey], nil
        elseif type(druid[newKey]) == "table" and type(druid[oldKey]) == "table" then
            applyMissing(druid[newKey], druid[oldKey])
            druid[oldKey] = nil
        end
        -- Preserve malformed conflicting values under both keys.
    end

    if type(RPHelperDB.disabledDefaults) == "table" then
        local oldPrefix = "default:v1:s7:abilitys5:DRUIDs11:" .. oldKey
        local newPrefix = "default:v1:s7:abilitys5:DRUIDs14:" .. newKey
        local migrated = {}
        for id, disabled in pairs(RPHelperDB.disabledDefaults) do
            if disabled == true and type(id) == "string" and string.sub(id, 1, #oldPrefix) == oldPrefix then
                migrated[#migrated + 1] = { old = id, new = newPrefix .. string.sub(id, #oldPrefix + 1) }
            end
        end
        for _, ids in ipairs(migrated) do
            if RPHelperDB.disabledDefaults[ids.new] == nil then
                RPHelperDB.disabledDefaults[ids.new] = true
            end
            RPHelperDB.disabledDefaults[ids.old] = nil
        end
    end
end

-- Approved Warlock canonical renames. This remains deliberately limited to
-- the three reviewed mappings rather than becoming a general migration layer.
local function migrateWarlockAbilityRenames()
    local mappings = {
        { old = "CURSE_OF_AGONY", new = "BANE_OF_AGONY" },
        { old = "CURSE_OF_DOOM", new = "BANE_OF_DOOM" },
        { old = "ENSLAVE_DEMON", new = "SUBJUGATE_DEMON" },
    }
    local replacements = {}
    for _, mapping in ipairs(mappings) do replacements[mapping.old] = mapping.new end

    if type(RPHelperDB.custom) == "table" and type(RPHelperDB.custom.entries) == "table" then
        for _, record in pairs(RPHelperDB.custom.entries) do
            local scope = type(record) == "table" and record.scope
            local replacement = type(scope) == "table" and replacements[scope.ability]
            if type(scope) == "table" and scope.layer == "ability"
                and scope.class == "WARLOCK" and replacement then
                scope.ability = replacement
            end
        end
    end

    local warlock = type(RPHelperDB.abilities) == "table" and RPHelperDB.abilities.WARLOCK
    if type(warlock) == "table" then
        for _, mapping in ipairs(mappings) do
            local historical, destination = warlock[mapping.old], warlock[mapping.new]
            if type(historical) == "table" and destination == nil then
                warlock[mapping.new], warlock[mapping.old] = historical, nil
            end
            -- When both keys exist, the destination stays effective and the
            -- historical record remains recoverable under its inactive key.
            -- Malformed values likewise remain untouched rather than guessed.
        end
    end

    if type(RPHelperDB.disabledDefaults) == "table" then
        local migrated = {}
        for _, mapping in ipairs(mappings) do
            local oldPrefix = "default:v1:s7:abilitys7:WARLOCKs" .. #mapping.old .. ":" .. mapping.old
            local newPrefix = "default:v1:s7:abilitys7:WARLOCKs" .. #mapping.new .. ":" .. mapping.new
            for id, disabled in pairs(RPHelperDB.disabledDefaults) do
                if disabled == true and type(id) == "string"
                    and string.sub(id, 1, #oldPrefix) == oldPrefix then
                    migrated[#migrated + 1] = {
                        old = id,
                        new = newPrefix .. string.sub(id, #oldPrefix + 1),
                    }
                end
            end
        end
        for _, ids in ipairs(migrated) do
            RPHelperDB.disabledDefaults[ids.new] = true
            RPHelperDB.disabledDefaults[ids.old] = nil
        end
    end
end

function RPHelper.InitializeDatabase()
    if RPHelperDB == nil then RPHelperDB = {} end
    if type(RPHelperDB) ~= "table" then return end
    if RPHelperDB.schemaVersion == nil then RPHelperDB.schemaVersion = RPHelper.CURRENT_SCHEMA_VERSION end
    if RPHelperDB.settings == nil then RPHelperDB.settings = {} end
    if RPHelperDB.triggers == nil then RPHelperDB.triggers = {} end
    if RPHelperDB.abilities == nil then RPHelperDB.abilities = {} end
    if RPHelperDB.custom == nil then RPHelperDB.custom = {} end
    if RPHelperDB.disabledDefaults == nil then RPHelperDB.disabledDefaults = {} end

    if type(RPHelperDB.custom) == "table" then
        if RPHelperDB.custom.entries == nil then RPHelperDB.custom.entries = {} end
        if RPHelperDB.custom.nextID == nil then RPHelperDB.custom.nextID = 1 end
    end
    migrateShamanFireNova()
    migrateDruidPrimalBite()
    migrateDruidShiftingPower()
    migrateWarlockAbilityRenames()
    if RPHelper.UserContent then RPHelper.UserContent.Invalidate() end

    if type(RPHelperDB.settings) == "table" then
        applyMissing(RPHelperDB.settings, RPHelper.Defaults.settings)
    end
    if type(RPHelperDB.triggers) == "table" then
        applyMissing(RPHelperDB.triggers, RPHelper.Defaults.triggers)
    end
    if type(RPHelperDB.abilities) == "table" then
        applyMissing(RPHelperDB.abilities, RPHelper.Defaults.abilities)
    end
end
