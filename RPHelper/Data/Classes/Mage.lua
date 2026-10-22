-- RPHelper Forever - Mage English content
-- Corpus migration from the RPhelper_twow Mage catalogue and original RoleplayingHelper lineage.
-- The legacy Mage source carried no named contributor attribution.

local C = RPHelper.Class.MAGE
local function add(id, trigger, entryType, text)
    RPHelper.RegisterClass(C, trigger, { id = id, type = entryType, text = text })
end

-- ---------------------------------------------------------------------
-- ENTERCOMBAT
-- ---------------------------------------------------------------------
add("default:class:mage:0002", "entercombat", "say", "Let's get this over quick, time is mana.")
add("default:class:mage:0003", "entercombat", "say", "I'm a magic man. I got magic hands.")
add("default:class:mage:0004", "entercombat", "say", "I do not think you realise the gravity of your situation.")
add("default:class:mage:0005", "entercombat", "say", "Buckle up... you're going for a ride.")
add("default:class:mage:0006", "entercombat", "say", "This will be a lesson in arcane superiority!")
add("default:class:mage:0007", "entercombat", "emote", "CHARGE")

-- ---------------------------------------------------------------------
-- LEAVECOMBAT
-- ---------------------------------------------------------------------
add("default:class:mage:0008", "leavecombat", "say", "Some lessons come hard.")
add("default:class:mage:0009", "leavecombat", "say", "Careful. You don't want to risk learning from this.")
add("default:class:mage:0010", "leavecombat", "say", "A satisfying conclusion to a magical duel.")

-- ---------------------------------------------------------------------
-- HURT
-- ---------------------------------------------------------------------
add("default:class:mage:0011", "hurt", "say", "Ouch! That was uncalled for!")
add("default:class:mage:0012", "hurt", "say", "Magic armor could use an upgrade...")
add("default:class:mage:0013", "hurt", "say", "I prefer my battles from a distance!")
add("default:class:mage:0014", "hurt", "emote", "WINCE")
add("default:class:mage:0015", "hurt", "customemote", "grits {PP} teeth as the attack lands.")

-- ---------------------------------------------------------------------
-- ABSORB
-- ---------------------------------------------------------------------
add("default:class:mage:0016", "absorb", "say", "Was that supposed to hurt?")
add("default:class:mage:0017", "absorb", "say", "My barriers hold firm.")
add("default:class:mage:0018", "absorb", "say", "Magic shields are wonderful, aren’t they?")
add("default:class:mage:0019", "absorb", "emote", "GRIN")
add("default:class:mage:0020", "absorb", "customemote", "chuckles as the attack dissipates against {PP} magical defenses.")

-- ---------------------------------------------------------------------
-- DODGE
-- ---------------------------------------------------------------------
add("default:class:mage:0021", "dodge", "say", "I don't remember casting slow on you...")
add("default:class:mage:0022", "dodge", "say", "Too quick for you!")
add("default:class:mage:0023", "dodge", "say", "Magic makes everything easier, even dodging!")
add("default:class:mage:0024", "dodge", "customemote", "gracefully sidesteps the attack with a smirk.")

-- ---------------------------------------------------------------------
-- MISS
-- ---------------------------------------------------------------------
add("default:class:mage:0025", "miss", "say", "Your aim is as bad as your tactics!")
add("default:class:mage:0026", "miss", "say", "A simple miscalculation, I’m sure.")
add("default:class:mage:0027", "miss", "customemote", "laughs as the attack whiffs harmlessly past.")

-- ---------------------------------------------------------------------
-- PARRY
-- ---------------------------------------------------------------------
add("default:class:mage:0028", "parry", "say", "Did you really think that would land?")
add("default:class:mage:0029", "parry", "say", "I prefer magical defenses, but that’ll do.")
add("default:class:mage:0030", "parry", "customemote", "deflects the attack with an effortless motion.")

-- ---------------------------------------------------------------------
-- YOUCRIT
-- ---------------------------------------------------------------------
add("default:class:mage:0031", "youcrit", "say", "Even without magic, I strike true!")
add("default:class:mage:0032", "youcrit", "say", "A rare but effective strike!")
add("default:class:mage:0033", "youcrit", "customemote", "lands a surprisingly strong physical blow.")

-- ---------------------------------------------------------------------
-- DEFERRED: LEGACY YOUCRITSPELL (NOT AN ACTIVE GENERIC TRIGGER)
-- ---------------------------------------------------------------------
add("default:class:mage:0034", "deferred_youcritspell", "say", "Magic at its finest!")
add("default:class:mage:0035", "deferred_youcritspell", "say", "That was a lesson in devastation!")
add("default:class:mage:0036", "deferred_youcritspell", "say", "Precision and power, the marks of a true Mage!")
add("default:class:mage:0037", "deferred_youcritspell", "customemote", "grins as {PP} spell strikes with overwhelming force.")

-- ---------------------------------------------------------------------
-- PETATTACKSTART
-- ---------------------------------------------------------------------
add("default:class:mage:0038", "petattackstart", "say", "Go forth, {PNAME}, and show them magic incarnate!")
add("default:class:mage:0039", "petattackstart", "say", "Strike them down, {PNAME}!")
add("default:class:mage:0040", "petattackstart", "customemote", "waves a hand, directing {PNAME} toward {TARGET}.")

-- ---------------------------------------------------------------------
-- PETATTACKSTOP
-- ---------------------------------------------------------------------
add("default:class:mage:0041", "petattackstop", "say", "That will do, {PNAME}.")
add("default:class:mage:0042", "petattackstop", "say", "Well done, {PNAME}!")
add("default:class:mage:0043", "petattackstop", "customemote", "nods in satisfaction as {PNAME} returns.")

-- ---------------------------------------------------------------------
-- RESURRECT
-- ---------------------------------------------------------------------
add("default:class:mage:0044", "resurrect", "say", "Back from the void, and ready for more!")
add("default:class:mage:0045", "resurrect", "say", "Death is merely a setback for a master of the arcane!")
add("default:class:mage:0046", "resurrect", "say", "I return, wiser and stronger!")
add("default:class:mage:0047", "resurrect", "customemote", "shakes off the remnants of death and stands tall once more.")
