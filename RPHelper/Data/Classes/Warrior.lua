-- RPHelper Forever - Warrior English content
-- Corpus migration from the RPhelper_twow Warrior catalogue and original RoleplayingHelper lineage.
-- The legacy Warrior source carried no named contributor attribution.

local C = RPHelper.Class.WARRIOR
local function add(trigger, entryType, text)
    RPHelper.RegisterClass(C, trigger, { type = entryType, text = text })
end

-- ---------------------------------------------------------------------
-- ENTERCOMBAT
-- ---------------------------------------------------------------------
add("entercombat", "emote", "CHARGE")
add("entercombat", "emote", "ROAR")
add("entercombat", "emote", "MOCK")

-- ---------------------------------------------------------------------
-- HURT
-- ---------------------------------------------------------------------
add("hurt", "emote", "SNARL")

-- ---------------------------------------------------------------------
-- ABSORB
-- ---------------------------------------------------------------------
add("absorb", "say", "Hit me again! Let me absorb more!")

-- ---------------------------------------------------------------------
-- DODGE
-- ---------------------------------------------------------------------
add("dodge", "say", "C'mon, {TARGET_RACE}, spend some more {TARGET_POWER} on me.")

-- ---------------------------------------------------------------------
-- PARRY
-- ---------------------------------------------------------------------
add("parry", "say", "C'mon, {TARGET_RACE}, spend some more {TARGET_POWER} on me.")

-- ---------------------------------------------------------------------
-- YOUCRIT
-- ---------------------------------------------------------------------
add("youcrit", "emote", "LAUGH")
add("youcrit", "emote", "MOCK")

-- ---------------------------------------------------------------------
-- YOUCRIT
-- ---------------------------------------------------------------------
add("youcrit", "customemote", "cackles with delight at {PP} critical strike.")

-- ---------------------------------------------------------------------
-- LEGACY RANDOM TEMPLATES
-- ---------------------------------------------------------------------
RPHelper.RegisterClass(C, "entercombat", { type = "say", template = "I'll {1} your {2}!", choices = {
    { "rip", "tear", "slice", "cut", "carve", "hack", "cleave", "thrash" },
    { "arms off", "legs off", "eyeballs out", "eyes out", "face off", "teeth out", "kneecaps off", "intestines out", "stomach out", "heart out", "bowels out", "feet off", "ribs out", "spine out" },
} })
RPHelper.RegisterClass(C, "hurt", { type = "say", template = "I'll {1} your {2}!", choices = {
    { "rip", "tear", "slice", "cut", "carve", "hack", "cleave", "thrash" },
    { "arms off", "legs off", "eyeballs out", "eyes out", "face off", "teeth out", "kneecaps off", "intestines out", "stomach out", "heart out", "bowels out", "feet off", "ribs out", "spine out" },
} })
RPHelper.RegisterClass(C, "absorb", { type = "say", template = "{1}I absorb your {2} {3} like {4}.", choices = {
    { "You insect. ", "Haha! ", "" }, { "puny", "pathetic", "insignificant", "laughable", "pitiful", "useless" },
    { "hits", "blows", "attacks" }, { "they're nothing", "they're vapor", "a sponge", "a stealth aircraft absorbing most of the microwave radiation that hits it and reflecting whatever it doesn't absorb away from the microwave source... or something" },
} })
