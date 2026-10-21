-- RPHelper Forever - Hunter English content
-- Corpus migration from the RPhelper_twow Hunter catalogue and original RoleplayingHelper lineage.
-- The legacy Hunter source carried no named contributor attribution.

local C = RPHelper.Class.HUNTER
local function add(id, trigger, entryType, text)
    RPHelper.RegisterClass(C, trigger, { id = id, type = entryType, text = text })
end

-- ---------------------------------------------------------------------
-- ENTERCOMBAT
-- ---------------------------------------------------------------------
add("default:class:hunter:0002", "entercombat", "say", "The beast with me is nothing compared to the beast within...")
add("default:class:hunter:0003", "entercombat", "say", "Looks like target practice.")
add("default:class:hunter:0004", "entercombat", "say", "The hunt begins.")
add("default:class:hunter:0005", "entercombat", "say", "You are prey. I am the hunter.")
add("default:class:hunter:0006", "entercombat", "say", "Survival of the fittest, and I am the fittest!")
add("default:class:hunter:0007", "entercombat", "emote", "CHARGE")
add("default:class:hunter:0008", "entercombat", "emote", "ROAR")
add("default:class:hunter:0009", "entercombat", "customemote", "narrows {PP} eyes, locking onto {TARGET} like a predator eyeing its prey.")

-- ---------------------------------------------------------------------
-- LEAVECOMBAT
-- ---------------------------------------------------------------------
add("default:class:hunter:0010", "leavecombat", "say", "The hunt never truly ends...")
add("default:class:hunter:0011", "leavecombat", "say", "One more trophy for the collection.")
add("default:class:hunter:0012", "leavecombat", "say", "Another hunt, another lesson.")
add("default:class:hunter:0013", "leavecombat", "emote", "SMIRK")
add("default:class:hunter:0014", "leavecombat", "customemote", "casually wipes blood off {PP} blade.")

-- ---------------------------------------------------------------------
-- HURT
-- ---------------------------------------------------------------------
add("default:class:hunter:0015", "hurt", "say", "The hunt isn’t over yet...")
add("default:class:hunter:0016", "hurt", "say", "A scratch won’t slow me down!")
add("default:class:hunter:0017", "hurt", "say", "I’ve been through worse!")
add("default:class:hunter:0018", "hurt", "emote", "WINCE")
add("default:class:hunter:0019", "hurt", "customemote", "grimaces as the attack lands but steadies {PP} stance.")

-- ---------------------------------------------------------------------
-- ABSORB
-- ---------------------------------------------------------------------
add("default:class:hunter:0020", "absorb", "say", "Not even close.")
add("default:class:hunter:0021", "absorb", "say", "That won’t work on me!")
add("default:class:hunter:0022", "absorb", "say", "My instincts shield me from harm.")
add("default:class:hunter:0023", "absorb", "emote", "GRIN")
add("default:class:hunter:0024", "absorb", "customemote", "brushes off the attack, unfazed.")

-- ---------------------------------------------------------------------
-- DODGE
-- ---------------------------------------------------------------------
add("default:class:hunter:0025", "dodge", "say", "Too slow!")
add("default:class:hunter:0026", "dodge", "say", "You’ll have to do better than that!")
add("default:class:hunter:0027", "dodge", "say", "A true hunter is never caught off guard!")
add("default:class:hunter:0028", "dodge", "emote", "LAUGH")
add("default:class:hunter:0029", "dodge", "customemote", "sidesteps swiftly, evading the attack.")

-- ---------------------------------------------------------------------
-- MISS
-- ---------------------------------------------------------------------
add("default:class:hunter:0030", "miss", "say", "You missed your mark.")
add("default:class:hunter:0031", "miss", "say", "A hunter always knows where to stand.")
add("default:class:hunter:0032", "miss", "say", "I saw that coming a mile away.")
add("default:class:hunter:0033", "miss", "emote", "SMIRK")
add("default:class:hunter:0034", "miss", "customemote", "grins as the attack whiffs past harmlessly.")

-- ---------------------------------------------------------------------
-- PARRY
-- ---------------------------------------------------------------------
add("default:class:hunter:0035", "parry", "say", "Not today!")
add("default:class:hunter:0036", "parry", "say", "Your form is sloppy.")
add("default:class:hunter:0037", "parry", "say", "I see your openings, and I take them!")
add("default:class:hunter:0038", "parry", "emote", "BLOCK")
add("default:class:hunter:0039", "parry", "customemote", "deflects the attack with practiced ease.")

-- ---------------------------------------------------------------------
-- YOUCRIT
-- ---------------------------------------------------------------------
add("default:class:hunter:0040", "youcrit", "say", "I will feed your corpse to the beasts of the wild.")
add("default:class:hunter:0041", "youcrit", "say", "A single shot to the head... priceless.")
add("default:class:hunter:0042", "youcrit", "say", "Precision and power—nothing more is needed.")
add("default:class:hunter:0043", "youcrit", "customemote", "smirks as {PP} strike lands with deadly precision.")

-- ---------------------------------------------------------------------
-- DEFERRED: LEGACY YOUCRITSPELL (NOT AN ACTIVE GENERIC TRIGGER)
-- ---------------------------------------------------------------------
add("default:class:hunter:0044", "deferred_youcritspell", "say", "Magic and might—an excellent combination.")
add("default:class:hunter:0045", "deferred_youcritspell", "say", "Even the arcane favors the hunt!")
add("default:class:hunter:0046", "deferred_youcritspell", "say", "A shot guided by nature’s will!")
add("default:class:hunter:0047", "deferred_youcritspell", "customemote", "watches as the spell strikes true, power radiating from the impact.")

-- ---------------------------------------------------------------------
-- PETATTACKSTART
-- ---------------------------------------------------------------------
add("default:class:hunter:0048", "petattackstart", "say", "Go {PNAME}! Tear them apart!")
add("default:class:hunter:0049", "petattackstart", "say", "Hunt well, {PNAME}!")
add("default:class:hunter:0050", "petattackstart", "say", "Kill {PTOP}, {PNAME}!")
add("default:class:hunter:0051", "petattackstart", "say", "Strike, {PNAME}, strike!")
add("default:class:hunter:0052", "petattackstart", "emote", "SNARL")
add("default:class:hunter:0053", "petattackstart", "customemote", "gestures towards {TARGET}, signaling {PNAME} to strike.")

-- ---------------------------------------------------------------------
-- PETATTACKSTOP
-- ---------------------------------------------------------------------
add("default:class:hunter:0054", "petattackstop", "say", "That's enough, {PNAME}.")
add("default:class:hunter:0055", "petattackstop", "say", "Good work, {PNAME}.")
add("default:class:hunter:0056", "petattackstop", "say", "The prey has fallen.")
add("default:class:hunter:0057", "petattackstop", "customemote", "gives {PNAME} an approving nod.")

-- ---------------------------------------------------------------------
-- PETDIES
-- ---------------------------------------------------------------------
add("default:class:hunter:0058", "petdies", "say", "{PNAME}! No!")
add("default:class:hunter:0059", "petdies", "say", "Hold on, {PNAME}!")
add("default:class:hunter:0060", "petdies", "say", "{PNAME}! Play dead! Oh... you're not playing, are you?")
add("default:class:hunter:0061", "petdies", "customemote", "rushes to {PNAME}’s side, grief etched in {PP} eyes.")

-- ---------------------------------------------------------------------
-- RESURRECT
-- ---------------------------------------------------------------------
add("default:class:hunter:0062", "resurrect", "say", "Back from the dead, and still hunting!")
add("default:class:hunter:0063", "resurrect", "say", "Not even death can keep me down!")
add("default:class:hunter:0064", "resurrect", "say", "The wilds have brought me back!")
add("default:class:hunter:0065", "resurrect", "emote", "STRETCH")
add("default:class:hunter:0066", "resurrect", "customemote", "shakes off the grasp of death and steadies {PP} stance.")

-- ---------------------------------------------------------------------
-- PET EVENT CORPUS FROM LEGACY ANY.LUA
-- ---------------------------------------------------------------------
add("default:class:hunter:0067", "petattackstart", "say", "Go get {PTOP}, {PNAME}!")
add("default:class:hunter:0068", "petattackstart", "say", "Kill {PTOP} for me, {PNAME}.")
add("default:class:hunter:0069", "petattackstart", "say", "Attack {PTOP}, {PNAME}.")
add("default:class:hunter:0070", "petattackstart", "say", "Hurt {PTOP} badly, {PNAME}.")
add("default:class:hunter:0071", "petattackstart", "say", "Show {PTOP} no mercy, {PNAME}.")
add("default:class:hunter:0072", "petattackstart", "say", "Could you help me with this one, {PNAME}?")
add("default:class:hunter:0073", "petattackstop", "say", "Well done, {PNAME}.")
add("default:class:hunter:0074", "petattackstop", "say", "Stay close to me, {PNAME}.")
add("default:class:hunter:0075", "petattackstop", "say", "You're doing great, {PNAME}.")
add("default:class:hunter:0076", "petattackstop", "say", "Did you have fun, {PNAME}?")
add("default:class:hunter:0077", "petdies", "say", "You killed {PNAME}!")
add("default:class:hunter:0078", "petdies", "customemote", "mourns the loss of {PNAME}.")
add("default:class:hunter:0079", "petdies", "customemote", "cries over {PNAME}'s corpse.")
