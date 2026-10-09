-- RPHelper Forever - Mage English content
-- Corpus migration from the RPhelper_twow Mage catalogue and original RoleplayingHelper lineage.
-- The legacy Mage source carried no named contributor attribution.

local C = RPHelper.Class.MAGE
local function add(trigger, entryType, text)
    RPHelper.RegisterClass(C, trigger, { type = entryType, text = text })
end

-- ---------------------------------------------------------------------
-- ENTERCOMBAT
-- ---------------------------------------------------------------------
add("entercombat", "say", "Let's get this over quick, time is mana.")
add("entercombat", "say", "I'm a magic man. I got magic hands.")
add("entercombat", "say", "I do not think you realise the gravity of your situation.")
add("entercombat", "say", "Buckle up... you're going for a ride.")
add("entercombat", "say", "This will be a lesson in arcane superiority!")

-- ---------------------------------------------------------------------
-- ENTERCOMBAT
-- ---------------------------------------------------------------------
add("entercombat", "emote", "CHARGE")

-- ---------------------------------------------------------------------
-- LEAVECOMBAT
-- ---------------------------------------------------------------------
add("leavecombat", "say", "Some lessons come hard.")
add("leavecombat", "say", "Careful. You don't want to risk learning from this.")
add("leavecombat", "say", "A satisfying conclusion to a magical duel.")

-- ---------------------------------------------------------------------
-- HURT
-- ---------------------------------------------------------------------
add("hurt", "say", "Ouch! That was uncalled for!")
add("hurt", "say", "Magic armor could use an upgrade...")
add("hurt", "say", "I prefer my battles from a distance!")

-- ---------------------------------------------------------------------
-- HURT
-- ---------------------------------------------------------------------
add("hurt", "emote", "WINCE")

-- ---------------------------------------------------------------------
-- HURT
-- ---------------------------------------------------------------------
add("hurt", "customemote", "grits {PP} teeth as the attack lands.")

-- ---------------------------------------------------------------------
-- ABSORB
-- ---------------------------------------------------------------------
add("absorb", "say", "Was that supposed to hurt?")
add("absorb", "say", "My barriers hold firm.")
add("absorb", "say", "Magic shields are wonderful, aren’t they?")

-- ---------------------------------------------------------------------
-- ABSORB
-- ---------------------------------------------------------------------
add("absorb", "emote", "GRIN")

-- ---------------------------------------------------------------------
-- ABSORB
-- ---------------------------------------------------------------------
add("absorb", "customemote", "chuckles as the attack dissipates against {PP} magical defenses.")

-- ---------------------------------------------------------------------
-- DODGE
-- ---------------------------------------------------------------------
add("dodge", "say", "I don't remember casting slow on you...")
add("dodge", "say", "Too quick for you!")
add("dodge", "say", "Magic makes everything easier, even dodging!")

-- ---------------------------------------------------------------------
-- DODGE
-- ---------------------------------------------------------------------
add("dodge", "customemote", "gracefully sidesteps the attack with a smirk.")

-- ---------------------------------------------------------------------
-- MISS
-- ---------------------------------------------------------------------
add("miss", "say", "Your aim is as bad as your tactics!")
add("miss", "say", "A simple miscalculation, I’m sure.")

-- ---------------------------------------------------------------------
-- MISS
-- ---------------------------------------------------------------------
add("miss", "customemote", "laughs as the attack whiffs harmlessly past.")

-- ---------------------------------------------------------------------
-- PARRY
-- ---------------------------------------------------------------------
add("parry", "say", "Did you really think that would land?")
add("parry", "say", "I prefer magical defenses, but that’ll do.")

-- ---------------------------------------------------------------------
-- PARRY
-- ---------------------------------------------------------------------
add("parry", "customemote", "deflects the attack with an effortless motion.")

-- ---------------------------------------------------------------------
-- YOUCRIT
-- ---------------------------------------------------------------------
add("youcrit", "say", "Even without magic, I strike true!")
add("youcrit", "say", "A rare but effective strike!")

-- ---------------------------------------------------------------------
-- YOUCRIT
-- ---------------------------------------------------------------------
add("youcrit", "customemote", "lands a surprisingly strong physical blow.")

-- ---------------------------------------------------------------------
-- DEFERRED: LEGACY YOUCRITSPELL (NOT AN ACTIVE GENERIC TRIGGER)
-- ---------------------------------------------------------------------
add("deferred_youcritspell", "say", "Magic at its finest!")
add("deferred_youcritspell", "say", "That was a lesson in devastation!")
add("deferred_youcritspell", "say", "Precision and power, the marks of a true Mage!")

-- ---------------------------------------------------------------------
-- DEFERRED: LEGACY YOUCRITSPELL (NOT AN ACTIVE GENERIC TRIGGER)
-- ---------------------------------------------------------------------
add("deferred_youcritspell", "customemote", "grins as {PP} spell strikes with overwhelming force.")

-- ---------------------------------------------------------------------
-- PETATTACKSTART
-- ---------------------------------------------------------------------
add("petattackstart", "say", "Go forth, {PNAME}, and show them magic incarnate!")
add("petattackstart", "say", "Strike them down, {PNAME}!")

-- ---------------------------------------------------------------------
-- PETATTACKSTART
-- ---------------------------------------------------------------------
add("petattackstart", "customemote", "waves a hand, directing {PNAME} toward {TARGET}.")

-- ---------------------------------------------------------------------
-- PETATTACKSTOP
-- ---------------------------------------------------------------------
add("petattackstop", "say", "That will do, {PNAME}.")
add("petattackstop", "say", "Well done, {PNAME}!")

-- ---------------------------------------------------------------------
-- PETATTACKSTOP
-- ---------------------------------------------------------------------
add("petattackstop", "customemote", "nods in satisfaction as {PNAME} returns.")

-- ---------------------------------------------------------------------
-- RESURRECT
-- ---------------------------------------------------------------------
add("resurrect", "say", "Back from the void, and ready for more!")
add("resurrect", "say", "Death is merely a setback for a master of the arcane!")
add("resurrect", "say", "I return, wiser and stronger!")

-- ---------------------------------------------------------------------
-- RESURRECT
-- ---------------------------------------------------------------------
add("resurrect", "customemote", "shakes off the remnants of death and stands tall once more.")
