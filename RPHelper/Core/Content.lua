RPHelper = RPHelper or {}
RPHelper.Content = RPHelper.Content or { generic = {}, race = {}, class = {}, ability = {}, druidForm = {} }
RPHelper.Content.generic = RPHelper.Content.generic or {}
RPHelper.Content.race = RPHelper.Content.race or {}
RPHelper.Content.class = RPHelper.Content.class or {}
RPHelper.Content.ability = RPHelper.Content.ability or {}
RPHelper.Content.druidForm = RPHelper.Content.druidForm or {}
RPHelper.Race = RPHelper.Race or {
    TAUREN = "TAUREN",
    ORC = "ORC",
    NIGHTELF = "NIGHTELF",
    HUMAN = "HUMAN",
    GNOME = "GNOME",
    DWARF = "DWARF",
    UNDEAD = "UNDEAD",
    TROLL = "TROLL",
}
RPHelper.Class = RPHelper.Class or {
    WARRIOR = "WARRIOR",
    ROGUE = "ROGUE",
    HUNTER = "HUNTER",
    SHAMAN = "SHAMAN",
    DRUID = "DRUID",
    PALADIN = "PALADIN",
    MAGE = "MAGE",
    PRIEST = "PRIEST",
    WARLOCK = "WARLOCK",
}
RPHelper.Ability = RPHelper.Ability or {
    WARRIOR = {
        CHARGE = "CHARGE", REND = "REND", HAMSTRING = "HAMSTRING",
        MOCKING_BLOW = "MOCKING_BLOW", BATTLE_SHOUT = "BATTLE_SHOUT",
        DEMORALIZING_SHOUT = "DEMORALIZING_SHOUT", INTIMIDATING_SHOUT = "INTIMIDATING_SHOUT",
        CHALLENGING_SHOUT = "CHALLENGING_SHOUT", BLOODRAGE = "BLOODRAGE",
        SHIELD_BASH = "SHIELD_BASH", SHIELD_SLAM = "SHIELD_SLAM",
    },
    ROGUE = {
        SPRINT = "SPRINT", DISARM_TRAP = "DISARM_TRAP",
    },
    HUNTER = {
        ASPECT_OF_THE_MONKEY = "ASPECT_OF_THE_MONKEY", ASPECT_OF_THE_HAWK = "ASPECT_OF_THE_HAWK",
        ASPECT_OF_THE_CHEETAH = "ASPECT_OF_THE_CHEETAH", ASPECT_OF_THE_BEAST = "ASPECT_OF_THE_BEAST",
        ASPECT_OF_THE_PACK = "ASPECT_OF_THE_PACK", ASPECT_OF_THE_WILD = "ASPECT_OF_THE_WILD",
        MEND_PET = "MEND_PET", EAGLE_EYE = "EAGLE_EYE", EYES_OF_THE_BEAST = "EYES_OF_THE_BEAST",
        SCARE_BEAST = "SCARE_BEAST", BEAST_LORE = "BEAST_LORE", BESTIAL_WRATH = "BESTIAL_WRATH",
        TRANQUILIZING_SHOT = "TRANQUILIZING_SHOT", ARCANE_SHOT = "ARCANE_SHOT",
        CONCUSSIVE_SHOT = "CONCUSSIVE_SHOT", DISTRACTING_SHOT = "DISTRACTING_SHOT",
        MULTI_SHOT = "MULTI_SHOT", AIMED_SHOT = "AIMED_SHOT", SCATTER_SHOT = "SCATTER_SHOT",
        SERPENT_STING = "SERPENT_STING", SCORPID_STING = "SCORPID_STING", VIPER_STING = "VIPER_STING",
        HUNTERS_MARK = "HUNTERS_MARK", DETERRENCE = "DETERRENCE", DISENGAGE = "DISENGAGE",
        RAPID_FIRE = "RAPID_FIRE", FLARE = "FLARE", TRUESHOT_AURA = "TRUESHOT_AURA", VOLLEY = "VOLLEY",
        TRACK_BEASTS = "TRACK_BEASTS", TRACK_HUMANOIDS = "TRACK_HUMANOIDS", TRACK_UNDEAD = "TRACK_UNDEAD",
        TRACK_HIDDEN = "TRACK_HIDDEN", TRACK_ELEMENTALS = "TRACK_ELEMENTALS", TRACK_DEMONS = "TRACK_DEMONS",
        TRACK_GIANTS = "TRACK_GIANTS", TRACK_DRAGONKIN = "TRACK_DRAGONKIN",
        IMMOLATION_TRAP = "IMMOLATION_TRAP", FREEZING_TRAP = "FREEZING_TRAP",
        FROST_TRAP = "FROST_TRAP", EXPLOSIVE_TRAP = "EXPLOSIVE_TRAP",
        RAPTOR_STRIKE = "RAPTOR_STRIKE", WING_CLIP = "WING_CLIP", MONGOOSE_BITE = "MONGOOSE_BITE",
        COUNTERATTACK = "COUNTERATTACK", FEIGN_DEATH = "FEIGN_DEATH",
    },
    SHAMAN = {},
    DRUID = {},
    PALADIN = {},
    MAGE = {},
    PRIEST = {},
    WARLOCK = {},
}

local registeredIDs = {}
local function identify(entry)
    local id = entry.id
    assert(type(id) == "string" and string.match(id, "^default:[a-z0-9:_-]+$") and not registeredIDs[id],
        "built-in reactions require a unique authored id")
    registeredIDs[id] = true
    local registered = {}
    for field, value in pairs(entry) do if field ~= "id" then registered[field] = value end end
    registered.defaultID = id
    return registered
end

local function appendDefaults(pool, entries)
    local disabled = type(RPHelperDB) == "table" and RPHelperDB.disabledDefaults
    for _, entry in ipairs(entries) do
        if type(disabled) ~= "table" or not entry.defaultID or disabled[entry.defaultID] ~= true then
            pool[#pool + 1] = entry
        end
    end
end

local function appendCustom(pool, scope)
    if RPHelper.UserContent then RPHelper.UserContent.AppendCandidates(pool, scope) end
end

function RPHelper.RegisterGeneric(trigger, entry)
    entry = identify(entry)
    RPHelper.Content.generic[trigger] = RPHelper.Content.generic[trigger] or {}
    table.insert(RPHelper.Content.generic[trigger], entry)
end

function RPHelper.GetGenericPool(trigger)
    return RPHelper.Content.generic[trigger] or {}
end

function RPHelper.GetPreparedGenericPool(trigger, options)
    return RPHelper.ContentEngine.PrepareCandidatePool(RPHelper.GetContentPool(trigger, nil, nil, options), options)
end

function RPHelper.ChooseGenericCandidate(trigger, options)
    return RPHelper.ContentEngine.ChooseCandidate(RPHelper.GetContentPool(trigger, nil, nil, options), options)
end

function RPHelper.RegisterRace(race, trigger, entry)
    entry = identify(entry)
    RPHelper.Content.race[race] = RPHelper.Content.race[race] or {}
    RPHelper.Content.race[race][trigger] = RPHelper.Content.race[race][trigger] or {}
    table.insert(RPHelper.Content.race[race][trigger], entry)
end

function RPHelper.GetRacePool(race, trigger)
    local raceContent = RPHelper.Content.race[race]
    return raceContent and raceContent[trigger] or {}
end

function RPHelper.RegisterClass(class, trigger, entry)
    entry = identify(entry)
    RPHelper.Content.class = RPHelper.Content.class or {}
    RPHelper.Content.class[class] = RPHelper.Content.class[class] or {}
    RPHelper.Content.class[class][trigger] = RPHelper.Content.class[class][trigger] or {}
    table.insert(RPHelper.Content.class[class][trigger], entry)
end

function RPHelper.GetClassPool(class, trigger)
    local classContent = RPHelper.Content.class and RPHelper.Content.class[class]
    return classContent and classContent[trigger] or {}
end

function RPHelper.RegisterDruidForm(form, trigger, entry)
    entry = identify(entry)
    RPHelper.Content.druidForm[form] = RPHelper.Content.druidForm[form] or {}
    RPHelper.Content.druidForm[form][trigger] = RPHelper.Content.druidForm[form][trigger] or {}
    table.insert(RPHelper.Content.druidForm[form][trigger], entry)
end

function RPHelper.GetDruidFormPool(form, trigger)
    if form == RPHelper.DruidForms.Form.DIRE_BEAR then
        form = RPHelper.DruidForms.Form.BEAR
    end
    local formContent = RPHelper.Content.druidForm[form]
    return formContent and formContent[trigger] or {}
end

-- A nil entry registers an ability definition with an empty shipped pool.
-- Definition registration never consumes a shipped reaction identity.
function RPHelper.RegisterAbility(class, ability, entry)
    RPHelper.Ability[class] = RPHelper.Ability[class] or {}
    RPHelper.Ability[class][ability] = ability
    RPHelper.Content.ability[class] = RPHelper.Content.ability[class] or {}
    RPHelper.Content.ability[class][ability] = RPHelper.Content.ability[class][ability] or {}
    if entry ~= nil then
        entry = identify(entry)
        table.insert(RPHelper.Content.ability[class][ability], entry)
    end
end

function RPHelper.GetAbilityPool(class, ability)
    local classAbilities = RPHelper.Content.ability[class]
    return classAbilities and classAbilities[ability] or {}
end

function RPHelper.GetAbilityContentPool(class, ability)
    local pool = {}
    appendDefaults(pool, RPHelper.GetAbilityPool(class, ability))
    appendCustom(pool, { layer = "ability", class = class, ability = ability })
    return pool
end

function RPHelper.GetPreparedAbilityPool(class, ability, options)
    options = options or {}
    options.class = options.class or class
    return RPHelper.ContentEngine.PrepareCandidatePool(RPHelper.GetAbilityContentPool(class, ability), options)
end

function RPHelper.ChooseAbilityCandidate(class, ability, options)
    options = options or {}
    options.class = options.class or class
    return RPHelper.ContentEngine.ChooseCandidate(RPHelper.GetAbilityContentPool(class, ability), options)
end

-- Character pools are additive: authored Race and Class content supplement Generic.
-- A fresh table prevents callers from changing any registered layer.
function RPHelper.GetContentPool(trigger, race, class, options)
    local pool = {}
    local form
    local formPool = {}
    if class == RPHelper.Class.DRUID and RPHelper.DruidForms then
        form = RPHelper.DruidForms.GetCurrentForm(options)
        if form == RPHelper.DruidForms.Form.DIRE_BEAR then form = RPHelper.DruidForms.Form.BEAR end
        formPool = RPHelper.GetDruidFormPool(form, trigger)
    end
    -- Authored form pools still replace shipped humanoid layers, even when disabled.
    if #formPool > 0 then
        appendDefaults(pool, formPool)
    else
        appendDefaults(pool, RPHelper.GetGenericPool(trigger))
        appendDefaults(pool, RPHelper.GetRacePool(race, trigger))
        appendDefaults(pool, RPHelper.GetClassPool(class, trigger))
    end
    appendCustom(pool, { layer = "generic", trigger = trigger })
    if race then appendCustom(pool, { layer = "race", race = race, trigger = trigger }) end
    if class then appendCustom(pool, { layer = "class", class = class, trigger = trigger }) end
    if form then appendCustom(pool, { layer = "druidForm", form = form, trigger = trigger }) end
    return pool
end

function RPHelper.GetPreparedContentPool(trigger, race, class, options)
    options = options or {}
    options.class = options.class or class
    return RPHelper.ContentEngine.PrepareCandidatePool(RPHelper.GetContentPool(trigger, race, class, options), options)
end

function RPHelper.ChooseContentCandidate(trigger, race, class, options)
    options = options or {}
    options.class = options.class or class
    return RPHelper.ContentEngine.ChooseCandidate(RPHelper.GetContentPool(trigger, race, class, options), options)
end
