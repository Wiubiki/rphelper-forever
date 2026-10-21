-- RPHelper Forever - Paladin English content
-- Corpus migration from the RPhelper_twow Paladin catalogue and original RoleplayingHelper lineage.
-- The legacy Paladin source carried no named contributor attribution.

local C = RPHelper.Class.PALADIN
local function add(id, trigger, entryType, text)
    RPHelper.RegisterClass(C, trigger, { id = id, type = entryType, text = text })
end

-- ---------------------------------------------------------------------
-- ENTERCOMBAT
-- ---------------------------------------------------------------------
add("default:class:paladin:0002", "entercombat", "say", "I will bring honor to my family and my kingdom!")
add("default:class:paladin:0003", "entercombat", "say", "Light, give me strength!")
add("default:class:paladin:0004", "entercombat", "say", "My strength is the holy light!")
add("default:class:paladin:0005", "entercombat", "say", "My church is the field of battle - time to worship...")
add("default:class:paladin:0006", "entercombat", "say", "I hold you in contempt...")
add("default:class:paladin:0007", "entercombat", "say", "Shall I be your executioner?")
add("default:class:paladin:0008", "entercombat", "say", "Face the hammer of justice!")
add("default:class:paladin:0009", "entercombat", "say", "Come then, shadow spawn!")
add("default:class:paladin:0010", "entercombat", "say", "Prove your worth in the test of arms under the light!")
add("default:class:paladin:0011", "entercombat", "say", "Might I have the pleasure of your name before I crush your skull?")
add("default:class:paladin:0012", "entercombat", "say", "All must fall before the might and right of my cause, you shall be next!")
add("default:class:paladin:0013", "entercombat", "emote", "CHARGE")

-- ---------------------------------------------------------------------
-- LEAVECOMBAT
-- ---------------------------------------------------------------------
add("default:class:paladin:0014", "leavecombat", "say", "The Light sees me through another battle.")
add("default:class:paladin:0015", "leavecombat", "say", "Justice prevails once more.")
add("default:class:paladin:0016", "leavecombat", "customemote", "lowers {PP} weapon, offering a solemn nod.")

-- ---------------------------------------------------------------------
-- HURT
-- ---------------------------------------------------------------------
add("default:class:paladin:0017", "hurt", "say", "The Light shields my soul!")
add("default:class:paladin:0018", "hurt", "say", "I shall endure!")
add("default:class:paladin:0019", "hurt", "customemote", "winces but stands firm against the attack.")

-- ---------------------------------------------------------------------
-- ABSORB
-- ---------------------------------------------------------------------
add("default:class:paladin:0020", "absorb", "say", "The Light repels all harm!")
add("default:class:paladin:0021", "absorb", "say", "Faith is my shield!")
add("default:class:paladin:0022", "absorb", "customemote", "smiles confidently as the attack is nullified.")

-- ---------------------------------------------------------------------
-- BLOCK
-- ---------------------------------------------------------------------
add("default:class:paladin:0023", "block", "say", "Steel and faith protect me!")
add("default:class:paladin:0024", "block", "say", "Your strike meets only my shield!")
add("default:class:paladin:0025", "block", "customemote", "raises {PP} shield, deflecting the blow effortlessly.")

-- ---------------------------------------------------------------------
-- DODGE
-- ---------------------------------------------------------------------
add("default:class:paladin:0026", "dodge", "say", "You’ll have to do better than that!")
add("default:class:paladin:0027", "dodge", "say", "The Light guides my steps!")
add("default:class:paladin:0028", "dodge", "customemote", "sidesteps the attack with divine grace.")

-- ---------------------------------------------------------------------
-- MISS
-- ---------------------------------------------------------------------
add("default:class:paladin:0029", "miss", "say", "The Light favors me today!")
add("default:class:paladin:0030", "miss", "say", "Divine providence spares me!")
add("default:class:paladin:0031", "miss", "customemote", "smirks as the attack fails to connect.")

-- ---------------------------------------------------------------------
-- PARRY
-- ---------------------------------------------------------------------
add("default:class:paladin:0032", "parry", "say", "Your form is flawed.")
add("default:class:paladin:0033", "parry", "say", "A poor attempt at striking the righteous!")
add("default:class:paladin:0034", "parry", "customemote", "deflects the incoming strike with a precise maneuver.")

-- ---------------------------------------------------------------------
-- YOUCRIT
-- ---------------------------------------------------------------------
add("default:class:paladin:0035", "youcrit", "say", "The vultures begin circling over you.")
add("default:class:paladin:0036", "youcrit", "say", "You will pay in blood for your foolishness.")
add("default:class:paladin:0037", "youcrit", "say", "You are beaten, it is useless to resist.")
add("default:class:paladin:0038", "youcrit", "customemote", "delivers a crushing blow, filled with divine fury.")

-- ---------------------------------------------------------------------
-- DEFERRED: LEGACY YOUCRITSPELL (NOT AN ACTIVE GENERIC TRIGGER)
-- ---------------------------------------------------------------------
add("default:class:paladin:0039", "deferred_youcritspell", "say", "The Light’s judgment is absolute!")
add("default:class:paladin:0040", "deferred_youcritspell", "say", "Faith guides my magic!")
add("default:class:paladin:0041", "deferred_youcritspell", "customemote", "calls down holy power, smiting {TARGET} with radiant energy.")

-- ---------------------------------------------------------------------
-- YOUHEAL
-- ---------------------------------------------------------------------
add("default:class:paladin:0042", "youheal", "say", "Let the Light mend your wounds.")
add("default:class:paladin:0043", "youheal", "say", "Blessings of the Light be upon you!")
add("default:class:paladin:0044", "youheal", "customemote", "channels divine energy, restoring {TARGET}'s health.")

-- ---------------------------------------------------------------------
-- YOUCRITHEAL
-- ---------------------------------------------------------------------
add("default:class:paladin:0045", "youcritheal", "say", "A miracle of the Light!")
add("default:class:paladin:0046", "youcritheal", "say", "Your faith is rewarded!")
add("default:class:paladin:0047", "youcritheal", "customemote", "radiates holy power, mending wounds with divine brilliance.")

-- ---------------------------------------------------------------------
-- RESURRECT
-- ---------------------------------------------------------------------
add("default:class:paladin:0048", "resurrect", "say", "By the light! I'm alive!")
add("default:class:paladin:0049", "resurrect", "say", "The light has brought me back.")
add("default:class:paladin:0050", "resurrect", "say", "The light has seen fit for me to live again.")
add("default:class:paladin:0051", "resurrect", "emote", "PRAY")
