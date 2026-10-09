-- RPHelper Forever - Paladin English content
-- Corpus migration from the RPhelper_twow Paladin catalogue and original RoleplayingHelper lineage.
-- The legacy Paladin source carried no named contributor attribution.

local C = RPHelper.Class.PALADIN
local function add(trigger, entryType, text)
    RPHelper.RegisterClass(C, trigger, { type = entryType, text = text })
end

-- ---------------------------------------------------------------------
-- ENTERCOMBAT
-- ---------------------------------------------------------------------
add("entercombat", "say", "I will bring honor to my family and my kingdom!")
add("entercombat", "say", "Light, give me strength!")
add("entercombat", "say", "My strength is the holy light!")
add("entercombat", "say", "My church is the field of battle - time to worship...")
add("entercombat", "say", "I hold you in contempt...")
add("entercombat", "say", "Shall I be your executioner?")
add("entercombat", "say", "Face the hammer of justice!")
add("entercombat", "say", "Come then, shadow spawn!")
add("entercombat", "say", "Prove your worth in the test of arms under the light!")
add("entercombat", "say", "Might I have the pleasure of your name before I crush your skull?")
add("entercombat", "say", "All must fall before the might and right of my cause, you shall be next!")

-- ---------------------------------------------------------------------
-- ENTERCOMBAT
-- ---------------------------------------------------------------------
add("entercombat", "emote", "CHARGE")

-- ---------------------------------------------------------------------
-- LEAVECOMBAT
-- ---------------------------------------------------------------------
add("leavecombat", "say", "The Light sees me through another battle.")
add("leavecombat", "say", "Justice prevails once more.")

-- ---------------------------------------------------------------------
-- LEAVECOMBAT
-- ---------------------------------------------------------------------
add("leavecombat", "customemote", "lowers {PP} weapon, offering a solemn nod.")

-- ---------------------------------------------------------------------
-- HURT
-- ---------------------------------------------------------------------
add("hurt", "say", "The Light shields my soul!")
add("hurt", "say", "I shall endure!")

-- ---------------------------------------------------------------------
-- HURT
-- ---------------------------------------------------------------------
add("hurt", "customemote", "winces but stands firm against the attack.")

-- ---------------------------------------------------------------------
-- ABSORB
-- ---------------------------------------------------------------------
add("absorb", "say", "The Light repels all harm!")
add("absorb", "say", "Faith is my shield!")

-- ---------------------------------------------------------------------
-- ABSORB
-- ---------------------------------------------------------------------
add("absorb", "customemote", "smiles confidently as the attack is nullified.")

-- ---------------------------------------------------------------------
-- BLOCK
-- ---------------------------------------------------------------------
add("block", "say", "Steel and faith protect me!")
add("block", "say", "Your strike meets only my shield!")

-- ---------------------------------------------------------------------
-- BLOCK
-- ---------------------------------------------------------------------
add("block", "customemote", "raises {PP} shield, deflecting the blow effortlessly.")

-- ---------------------------------------------------------------------
-- DODGE
-- ---------------------------------------------------------------------
add("dodge", "say", "You’ll have to do better than that!")
add("dodge", "say", "The Light guides my steps!")

-- ---------------------------------------------------------------------
-- DODGE
-- ---------------------------------------------------------------------
add("dodge", "customemote", "sidesteps the attack with divine grace.")

-- ---------------------------------------------------------------------
-- MISS
-- ---------------------------------------------------------------------
add("miss", "say", "The Light favors me today!")
add("miss", "say", "Divine providence spares me!")

-- ---------------------------------------------------------------------
-- MISS
-- ---------------------------------------------------------------------
add("miss", "customemote", "smirks as the attack fails to connect.")

-- ---------------------------------------------------------------------
-- PARRY
-- ---------------------------------------------------------------------
add("parry", "say", "Your form is flawed.")
add("parry", "say", "A poor attempt at striking the righteous!")

-- ---------------------------------------------------------------------
-- PARRY
-- ---------------------------------------------------------------------
add("parry", "customemote", "deflects the incoming strike with a precise maneuver.")

-- ---------------------------------------------------------------------
-- YOUCRIT
-- ---------------------------------------------------------------------
add("youcrit", "say", "The vultures begin circling over you.")
add("youcrit", "say", "You will pay in blood for your foolishness.")
add("youcrit", "say", "You are beaten, it is useless to resist.")

-- ---------------------------------------------------------------------
-- YOUCRIT
-- ---------------------------------------------------------------------
add("youcrit", "customemote", "delivers a crushing blow, filled with divine fury.")

-- ---------------------------------------------------------------------
-- DEFERRED: LEGACY YOUCRITSPELL (NOT AN ACTIVE GENERIC TRIGGER)
-- ---------------------------------------------------------------------
add("deferred_youcritspell", "say", "The Light’s judgment is absolute!")
add("deferred_youcritspell", "say", "Faith guides my magic!")

-- ---------------------------------------------------------------------
-- DEFERRED: LEGACY YOUCRITSPELL (NOT AN ACTIVE GENERIC TRIGGER)
-- ---------------------------------------------------------------------
add("deferred_youcritspell", "customemote", "calls down holy power, smiting {TARGET} with radiant energy.")

-- ---------------------------------------------------------------------
-- YOUHEAL
-- ---------------------------------------------------------------------
add("youheal", "say", "Let the Light mend your wounds.")
add("youheal", "say", "Blessings of the Light be upon you!")

-- ---------------------------------------------------------------------
-- YOUHEAL
-- ---------------------------------------------------------------------
add("youheal", "customemote", "channels divine energy, restoring {TARGET}'s health.")

-- ---------------------------------------------------------------------
-- YOUCRITHEAL
-- ---------------------------------------------------------------------
add("youcritheal", "say", "A miracle of the Light!")
add("youcritheal", "say", "Your faith is rewarded!")

-- ---------------------------------------------------------------------
-- YOUCRITHEAL
-- ---------------------------------------------------------------------
add("youcritheal", "customemote", "radiates holy power, mending wounds with divine brilliance.")

-- ---------------------------------------------------------------------
-- RESURRECT
-- ---------------------------------------------------------------------
add("resurrect", "say", "By the light! I'm alive!")
add("resurrect", "say", "The light has brought me back.")
add("resurrect", "say", "The light has seen fit for me to live again.")

-- ---------------------------------------------------------------------
-- RESURRECT
-- ---------------------------------------------------------------------
add("resurrect", "emote", "PRAY")
