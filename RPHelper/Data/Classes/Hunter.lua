-- RPHelper Forever - Hunter English content
-- Corpus migration from the RPhelper_twow Hunter catalogue and original RoleplayingHelper lineage.
-- The legacy Hunter source carried no named contributor attribution.

local C = RPHelper.Class.HUNTER
local function add(trigger, entryType, text)
    RPHelper.RegisterClass(C, trigger, { type = entryType, text = text })
end

-- ---------------------------------------------------------------------
-- ENTERCOMBAT
-- ---------------------------------------------------------------------
add("entercombat", "say", "The beast with me is nothing compared to the beast within...")
add("entercombat", "say", "Looks like target practice.")
add("entercombat", "say", "The hunt begins.")
add("entercombat", "say", "You are prey. I am the hunter.")
add("entercombat", "say", "Survival of the fittest, and I am the fittest!")

-- ---------------------------------------------------------------------
-- ENTERCOMBAT
-- ---------------------------------------------------------------------
add("entercombat", "emote", "CHARGE")
add("entercombat", "emote", "ROAR")

-- ---------------------------------------------------------------------
-- ENTERCOMBAT
-- ---------------------------------------------------------------------
add("entercombat", "customemote", "narrows {PP} eyes, locking onto {TARGET} like a predator eyeing its prey.")

-- ---------------------------------------------------------------------
-- LEAVECOMBAT
-- ---------------------------------------------------------------------
add("leavecombat", "say", "The hunt never truly ends...")
add("leavecombat", "say", "One more trophy for the collection.")
add("leavecombat", "say", "Another hunt, another lesson.")

-- ---------------------------------------------------------------------
-- LEAVECOMBAT
-- ---------------------------------------------------------------------
add("leavecombat", "emote", "SMIRK")

-- ---------------------------------------------------------------------
-- LEAVECOMBAT
-- ---------------------------------------------------------------------
add("leavecombat", "customemote", "casually wipes blood off {PP} blade.")

-- ---------------------------------------------------------------------
-- HURT
-- ---------------------------------------------------------------------
add("hurt", "say", "The hunt isn’t over yet...")
add("hurt", "say", "A scratch won’t slow me down!")
add("hurt", "say", "I’ve been through worse!")

-- ---------------------------------------------------------------------
-- HURT
-- ---------------------------------------------------------------------
add("hurt", "emote", "WINCE")

-- ---------------------------------------------------------------------
-- HURT
-- ---------------------------------------------------------------------
add("hurt", "customemote", "grimaces as the attack lands but steadies {PP} stance.")

-- ---------------------------------------------------------------------
-- ABSORB
-- ---------------------------------------------------------------------
add("absorb", "say", "Not even close.")
add("absorb", "say", "That won’t work on me!")
add("absorb", "say", "My instincts shield me from harm.")

-- ---------------------------------------------------------------------
-- ABSORB
-- ---------------------------------------------------------------------
add("absorb", "emote", "GRIN")

-- ---------------------------------------------------------------------
-- ABSORB
-- ---------------------------------------------------------------------
add("absorb", "customemote", "brushes off the attack, unfazed.")

-- ---------------------------------------------------------------------
-- DODGE
-- ---------------------------------------------------------------------
add("dodge", "say", "Too slow!")
add("dodge", "say", "You’ll have to do better than that!")
add("dodge", "say", "A true hunter is never caught off guard!")

-- ---------------------------------------------------------------------
-- DODGE
-- ---------------------------------------------------------------------
add("dodge", "emote", "LAUGH")

-- ---------------------------------------------------------------------
-- DODGE
-- ---------------------------------------------------------------------
add("dodge", "customemote", "sidesteps swiftly, evading the attack.")

-- ---------------------------------------------------------------------
-- MISS
-- ---------------------------------------------------------------------
add("miss", "say", "You missed your mark.")
add("miss", "say", "A hunter always knows where to stand.")
add("miss", "say", "I saw that coming a mile away.")

-- ---------------------------------------------------------------------
-- MISS
-- ---------------------------------------------------------------------
add("miss", "emote", "SMIRK")

-- ---------------------------------------------------------------------
-- MISS
-- ---------------------------------------------------------------------
add("miss", "customemote", "grins as the attack whiffs past harmlessly.")

-- ---------------------------------------------------------------------
-- PARRY
-- ---------------------------------------------------------------------
add("parry", "say", "Not today!")
add("parry", "say", "Your form is sloppy.")
add("parry", "say", "I see your openings, and I take them!")

-- ---------------------------------------------------------------------
-- PARRY
-- ---------------------------------------------------------------------
add("parry", "emote", "BLOCK")

-- ---------------------------------------------------------------------
-- PARRY
-- ---------------------------------------------------------------------
add("parry", "customemote", "deflects the attack with practiced ease.")

-- ---------------------------------------------------------------------
-- YOUCRIT
-- ---------------------------------------------------------------------
add("youcrit", "say", "I will feed your corpse to the beasts of the wild.")
add("youcrit", "say", "A single shot to the head... priceless.")
add("youcrit", "say", "Precision and power—nothing more is needed.")

-- ---------------------------------------------------------------------
-- YOUCRIT
-- ---------------------------------------------------------------------
add("youcrit", "customemote", "smirks as {PP} strike lands with deadly precision.")

-- ---------------------------------------------------------------------
-- DEFERRED: LEGACY YOUCRITSPELL (NOT AN ACTIVE GENERIC TRIGGER)
-- ---------------------------------------------------------------------
add("deferred_youcritspell", "say", "Magic and might—an excellent combination.")
add("deferred_youcritspell", "say", "Even the arcane favors the hunt!")
add("deferred_youcritspell", "say", "A shot guided by nature’s will!")

-- ---------------------------------------------------------------------
-- DEFERRED: LEGACY YOUCRITSPELL (NOT AN ACTIVE GENERIC TRIGGER)
-- ---------------------------------------------------------------------
add("deferred_youcritspell", "customemote", "watches as the spell strikes true, power radiating from the impact.")

-- ---------------------------------------------------------------------
-- PETATTACKSTART
-- ---------------------------------------------------------------------
add("petattackstart", "say", "Go {PNAME}! Tear them apart!")
add("petattackstart", "say", "Hunt well, {PNAME}!")
add("petattackstart", "say", "Kill {PTOP}, {PNAME}!")
add("petattackstart", "say", "Strike, {PNAME}, strike!")

-- ---------------------------------------------------------------------
-- PETATTACKSTART
-- ---------------------------------------------------------------------
add("petattackstart", "emote", "SNARL")

-- ---------------------------------------------------------------------
-- PETATTACKSTART
-- ---------------------------------------------------------------------
add("petattackstart", "customemote", "gestures towards {TARGET}, signaling {PNAME} to strike.")

-- ---------------------------------------------------------------------
-- PETATTACKSTOP
-- ---------------------------------------------------------------------
add("petattackstop", "say", "That's enough, {PNAME}.")
add("petattackstop", "say", "Good work, {PNAME}.")
add("petattackstop", "say", "The prey has fallen.")

-- ---------------------------------------------------------------------
-- PETATTACKSTOP
-- ---------------------------------------------------------------------
add("petattackstop", "customemote", "gives {PNAME} an approving nod.")

-- ---------------------------------------------------------------------
-- PETDIES
-- ---------------------------------------------------------------------
add("petdies", "say", "{PNAME}! No!")
add("petdies", "say", "Hold on, {PNAME}!")
add("petdies", "say", "{PNAME}! Play dead! Oh... you're not playing, are you?")

-- ---------------------------------------------------------------------
-- PETDIES
-- ---------------------------------------------------------------------
add("petdies", "customemote", "rushes to {PNAME}’s side, grief etched in {PP} eyes.")

-- ---------------------------------------------------------------------
-- RESURRECT
-- ---------------------------------------------------------------------
add("resurrect", "say", "Back from the dead, and still hunting!")
add("resurrect", "say", "Not even death can keep me down!")
add("resurrect", "say", "The wilds have brought me back!")

-- ---------------------------------------------------------------------
-- RESURRECT
-- ---------------------------------------------------------------------
add("resurrect", "emote", "STRETCH")

-- ---------------------------------------------------------------------
-- RESURRECT
-- ---------------------------------------------------------------------
add("resurrect", "customemote", "shakes off the grasp of death and steadies {PP} stance.")

-- ---------------------------------------------------------------------
-- PET EVENT CORPUS FROM LEGACY ANY.LUA
-- ---------------------------------------------------------------------
add("petattackstart", "say", "Go get {PTOP}, {PNAME}!")
add("petattackstart", "say", "Kill {PTOP} for me, {PNAME}.")
add("petattackstart", "say", "Attack {PTOP}, {PNAME}.")
add("petattackstart", "say", "Hurt {PTOP} badly, {PNAME}.")
add("petattackstart", "say", "Show {PTOP} no mercy, {PNAME}.")
add("petattackstart", "say", "Could you help me with this one, {PNAME}?")
add("petattackstop", "say", "Well done, {PNAME}.")
add("petattackstop", "say", "Stay close to me, {PNAME}.")
add("petattackstop", "say", "You're doing great, {PNAME}.")
add("petattackstop", "say", "Did you have fun, {PNAME}?")
add("petdies", "say", "You killed {PNAME}!")
add("petdies", "customemote", "mourns the loss of {PNAME}.")
add("petdies", "customemote", "cries over {PNAME}'s corpse.")
