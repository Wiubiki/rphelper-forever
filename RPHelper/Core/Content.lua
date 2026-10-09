RPHelper = RPHelper or {}
RPHelper.Content = RPHelper.Content or { generic = {}, race = {}, class = {}, ability = {} }
RPHelper.Content.generic = RPHelper.Content.generic or {}
RPHelper.Content.race = RPHelper.Content.race or {}
RPHelper.Content.class = RPHelper.Content.class or {}
RPHelper.Content.ability = RPHelper.Content.ability or {}
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
        SHOOT_BOW = "SHOOT_BOW", THROW = "THROW",
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
        CARVE = "CARVE", ASPECT_OF_THE_WOLF = "ASPECT_OF_THE_WOLF", STEADY_SHOT = "STEADY_SHOT",
    },
    SHAMAN = {},
    DRUID = {},
    PALADIN = {},
    MAGE = {},
    PRIEST = {},
    WARLOCK = {},
}

function RPHelper.RegisterGeneric(trigger, entry)
    RPHelper.Content.generic[trigger] = RPHelper.Content.generic[trigger] or {}
    table.insert(RPHelper.Content.generic[trigger], entry)
end

function RPHelper.GetGenericPool(trigger)
    return RPHelper.Content.generic[trigger] or {}
end

function RPHelper.GetPreparedGenericPool(trigger, options)
    return RPHelper.ContentEngine.PrepareCandidatePool(RPHelper.GetGenericPool(trigger), options)
end

function RPHelper.ChooseGenericCandidate(trigger, options)
    return RPHelper.ContentEngine.ChooseCandidate(RPHelper.GetGenericPool(trigger), options)
end

function RPHelper.RegisterRace(race, trigger, entry)
    RPHelper.Content.race[race] = RPHelper.Content.race[race] or {}
    RPHelper.Content.race[race][trigger] = RPHelper.Content.race[race][trigger] or {}
    table.insert(RPHelper.Content.race[race][trigger], entry)
end

function RPHelper.GetRacePool(race, trigger)
    local raceContent = RPHelper.Content.race[race]
    return raceContent and raceContent[trigger] or {}
end

function RPHelper.RegisterClass(class, trigger, entry)
    RPHelper.Content.class = RPHelper.Content.class or {}
    RPHelper.Content.class[class] = RPHelper.Content.class[class] or {}
    RPHelper.Content.class[class][trigger] = RPHelper.Content.class[class][trigger] or {}
    table.insert(RPHelper.Content.class[class][trigger], entry)
end

function RPHelper.GetClassPool(class, trigger)
    local classContent = RPHelper.Content.class and RPHelper.Content.class[class]
    return classContent and classContent[trigger] or {}
end

function RPHelper.RegisterAbility(class, ability, entry)
    RPHelper.Content.ability[class] = RPHelper.Content.ability[class] or {}
    RPHelper.Content.ability[class][ability] = RPHelper.Content.ability[class][ability] or {}
    table.insert(RPHelper.Content.ability[class][ability], entry)
end

function RPHelper.GetAbilityPool(class, ability)
    local classAbilities = RPHelper.Content.ability[class]
    return classAbilities and classAbilities[ability] or {}
end

function RPHelper.GetPreparedAbilityPool(class, ability, options)
    return RPHelper.ContentEngine.PrepareCandidatePool(RPHelper.GetAbilityPool(class, ability), options)
end

function RPHelper.ChooseAbilityCandidate(class, ability, options)
    return RPHelper.ContentEngine.ChooseCandidate(RPHelper.GetAbilityPool(class, ability), options)
end

-- Character pools are additive: authored Race and Class content supplement Generic.
-- A fresh table prevents callers from changing any registered layer.
function RPHelper.GetContentPool(trigger, race, class)
    local pool = {}
    for _, entry in ipairs(RPHelper.GetGenericPool(trigger)) do
        table.insert(pool, entry)
    end
    for _, entry in ipairs(RPHelper.GetRacePool(race, trigger)) do
        table.insert(pool, entry)
    end
    for _, entry in ipairs(RPHelper.GetClassPool(class, trigger)) do
        table.insert(pool, entry)
    end
    return pool
end

function RPHelper.GetPreparedContentPool(trigger, race, class, options)
    return RPHelper.ContentEngine.PrepareCandidatePool(RPHelper.GetContentPool(trigger, race, class), options)
end

function RPHelper.ChooseContentCandidate(trigger, race, class, options)
    return RPHelper.ContentEngine.ChooseCandidate(RPHelper.GetContentPool(trigger, race, class), options)
end
