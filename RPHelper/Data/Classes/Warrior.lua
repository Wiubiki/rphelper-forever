-- RPHelper Forever - Warrior English content
-- Corpus migration from the RPhelper_twow Warrior catalogue and original RoleplayingHelper lineage.
-- The legacy Warrior source carried no named contributor attribution.

local C = RPHelper.Class.WARRIOR
local function add(id, trigger, entryType, text)
    RPHelper.RegisterClass(C, trigger, { id = id, type = entryType, text = text })
end

-- ---------------------------------------------------------------------
-- ENTERCOMBAT
-- ---------------------------------------------------------------------
add("default:class:warrior:0002", "entercombat", "emote", "CHARGE")
add("default:class:warrior:0003", "entercombat", "emote", "ROAR")
add("default:class:warrior:0004", "entercombat", "emote", "MOCK")

-- ---------------------------------------------------------------------
-- HURT
-- ---------------------------------------------------------------------
add("default:class:warrior:0005", "hurt", "emote", "SNARL")

-- ---------------------------------------------------------------------
-- ABSORB
-- ---------------------------------------------------------------------
add("default:class:warrior:0006", "absorb", "say", "Hit me again! Let me absorb more!")

-- ---------------------------------------------------------------------
-- DODGE
-- ---------------------------------------------------------------------
add("default:class:warrior:0007", "dodge", "say", "C'mon, {TARGET_RACE}, spend some more {TARGET_POWER} on me.")

-- ---------------------------------------------------------------------
-- PARRY
-- ---------------------------------------------------------------------
add("default:class:warrior:0008", "parry", "say", "C'mon, {TARGET_RACE}, spend some more {TARGET_POWER} on me.")

-- ---------------------------------------------------------------------
-- YOUCRIT
-- ---------------------------------------------------------------------
add("default:class:warrior:0009", "youcrit", "emote", "LAUGH")
add("default:class:warrior:0010", "youcrit", "emote", "MOCK")
add("default:class:warrior:0011", "youcrit", "customemote", "cackles with delight at {PP} critical strike.")

-- ---------------------------------------------------------------------
-- LEGACY RANDOM TEMPLATES
-- ---------------------------------------------------------------------
RPHelper.RegisterClass(C, "entercombat", { id = "default:class:warrior:0012", type = "say", template = "I'll {1} your {2}!", choices = {
    { "rip", "tear", "slice", "cut", "carve", "hack", "cleave", "thrash" },
    { "arms off", "legs off", "eyeballs out", "eyes out", "face off", "teeth out", "kneecaps off", "intestines out", "stomach out", "heart out", "bowels out", "feet off", "ribs out", "spine out" },
} })
RPHelper.RegisterClass(C, "hurt", { id = "default:class:warrior:0013", type = "say", template = "I'll {1} your {2}!", choices = {
    { "rip", "tear", "slice", "cut", "carve", "hack", "cleave", "thrash" },
    { "arms off", "legs off", "eyeballs out", "eyes out", "face off", "teeth out", "kneecaps off", "intestines out", "stomach out", "heart out", "bowels out", "feet off", "ribs out", "spine out" },
} })
RPHelper.RegisterClass(C, "absorb", { id = "default:class:warrior:0014", type = "say", template = "{1}I absorb your {2} {3} like {4}.", choices = {
    { "You insect. ", "Haha! ", "" }, { "puny", "pathetic", "insignificant", "laughable", "pitiful", "useless" },
    { "hits", "blows", "attacks" }, { "they're nothing", "they're vapor", "a sponge", "a stealth aircraft absorbing most of the microwave radiation that hits it and reflecting whatever it doesn't absorb away from the microwave source... or something" },
} })
