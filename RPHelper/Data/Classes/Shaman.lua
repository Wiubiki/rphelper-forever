-- RPHelper Forever - Shaman English content
-- Corpus migration from the RPhelper_twow Shaman catalogue and original RoleplayingHelper lineage.
-- The legacy Shaman source carried no named contributor attribution.

local C = RPHelper.Class.SHAMAN
local function add(id, trigger, entryType, text)
    RPHelper.RegisterClass(C, trigger, { id = id, type = entryType, text = text })
end

-- ---------------------------------------------------------------------
-- ENTERCOMBAT
-- ---------------------------------------------------------------------
add("default:class:shaman:0002", "entercombat", "say", "The spirits guide me.")
add("default:class:shaman:0003", "entercombat", "say", "You ever been hit by lightning where the sun don't shine?")
add("default:class:shaman:0004", "entercombat", "say", "Thunder answers my call!")
add("default:class:shaman:0005", "entercombat", "say", "Storm and fury, at my command!")
add("default:class:shaman:0006", "entercombat", "say", "Elements rise with me!")
add("default:class:shaman:0007", "entercombat", "emote", "CHARGE")
add("default:class:shaman:0008", "entercombat", "customemote", "raises {PP} weapon, calling upon the storm.")

-- ---------------------------------------------------------------------
-- LEAVECOMBAT
-- ---------------------------------------------------------------------
add("default:class:shaman:0009", "leavecombat", "say", "The storm calms... for now.")
add("default:class:shaman:0010", "leavecombat", "say", "Balance is restored.")
add("default:class:shaman:0011", "leavecombat", "say", "The battle fades, the elements appeased.")
add("default:class:shaman:0012", "leavecombat", "say", "The battle fades, the spirits are calmed.")
add("default:class:shaman:0013", "leavecombat", "customemote", "exhales deeply, feeling the elements settle.")

-- ---------------------------------------------------------------------
-- HURT
-- ---------------------------------------------------------------------
add("default:class:shaman:0014", "hurt", "say", "Pain is the price of wisdom.")
add("default:class:shaman:0015", "hurt", "say", "The storm rages within me still...")
add("default:class:shaman:0016", "hurt", "say", "The earth trembles, but I do not fall.")
add("default:class:shaman:0017", "hurt", "say", "The ancestor spirits are still with me!")
add("default:class:shaman:0018", "hurt", "emote", "WINCE")
add("default:class:shaman:0019", "hurt", "customemote", "grits {PP} teeth, channeling endurance through the elements.")

-- ---------------------------------------------------------------------
-- ABSORB
-- ---------------------------------------------------------------------
add("default:class:shaman:0020", "absorb", "say", "The spirits shield me!")
add("default:class:shaman:0021", "absorb", "say", "Like water, I bend but do not break!")
add("default:class:shaman:0022", "absorb", "say", "The elements turn your force aside!")
add("default:class:shaman:0023", "absorb", "customemote", "chants an incantation, deflecting the blow with elemental energy.")

-- ---------------------------------------------------------------------
-- BLOCK
-- ---------------------------------------------------------------------
add("default:class:shaman:0024", "block", "say", "Earth stands firm!")
add("default:class:shaman:0025", "block", "say", "You strike against stone!")
add("default:class:shaman:0026", "block", "say", "My shield is as unyielding as the mountain!")
add("default:class:shaman:0027", "block", "say", "This {PLAYER_RACE} is a Guardian of the Elements. No blow shall pass!")
add("default:class:shaman:0028", "block", "customemote", "raises {PP} shield, letting the force of the earth absorb the impact.")

-- ---------------------------------------------------------------------
-- DODGE
-- ---------------------------------------------------------------------
add("default:class:shaman:0029", "dodge", "say", "The wind whispers, and I listen.")
add("default:class:shaman:0030", "dodge", "say", "Like the river, I flow beyond your reach.")
add("default:class:shaman:0031", "dodge", "say", "Lightning moves faster than steel!")
add("default:class:shaman:0032", "dodge", "customemote", "sidesteps swiftly, carried by the wind’s guidance.")

-- ---------------------------------------------------------------------
-- MISS
-- ---------------------------------------------------------------------
add("default:class:shaman:0033", "miss", "say", "Your aim falters, as the spirits will it.")
add("default:class:shaman:0034", "miss", "say", "You strike only air and shadows {TARGET}!")
add("default:class:shaman:0035", "miss", "say", "Perhaps the winds favor me today!")
add("default:class:shaman:0036", "miss", "customemote", "smirks as the attack fails to connect, the wind swirling around {PP}.")

-- ---------------------------------------------------------------------
-- PARRY
-- ---------------------------------------------------------------------
add("default:class:shaman:0037", "parry", "say", "The storm turns aside your blade!")
add("default:class:shaman:0038", "parry", "say", "Steel cannot match the will of the elements!")
add("default:class:shaman:0039", "parry", "say", "The spirits guide my hand!")
add("default:class:shaman:0040", "parry", "say", "The elements deny you, {TARGET}!")
add("default:class:shaman:0041", "parry", "customemote", "redirects the attack with a well-timed movement, channeling elemental force.")

-- ---------------------------------------------------------------------
-- YOUCRIT
-- ---------------------------------------------------------------------
add("default:class:shaman:0042", "youcrit", "say", "The spirits strike with me!")
add("default:class:shaman:0043", "youcrit", "say", "The storm rages through my weapon!")
add("default:class:shaman:0044", "youcrit", "say", "A blow as strong as the earth itself!")
add("default:class:shaman:0045", "youcrit", "say", "The thunder sings with my strike!")
add("default:class:shaman:0046", "youcrit", "say", "Fury of the tempest, channeled through me!")
add("default:class:shaman:0047", "youcrit", "say", "Stone and storm shatter your defenses!")
add("default:class:shaman:0048", "youcrit", "customemote", "delivers a crushing strike, infused with elemental fury.")

-- ---------------------------------------------------------------------
-- DEFERRED: LEGACY YOUCRITSPELL (NOT AN ACTIVE GENERIC TRIGGER)
-- ---------------------------------------------------------------------
add("default:class:shaman:0049", "deferred_youcritspell", "say", "The fury of the storm is unleashed!")
add("default:class:shaman:0050", "deferred_youcritspell", "say", "Lightning never strikes twice... except when I command it!")
add("default:class:shaman:0051", "deferred_youcritspell", "say", "The spirits answer my call with power!")
add("default:class:shaman:0052", "deferred_youcritspell", "say", "Fire, wind, water, and earth... all against you!")
add("default:class:shaman:0053", "deferred_youcritspell", "say", "Your doom is written in the skies!")
add("default:class:shaman:0054", "deferred_youcritspell", "say", "You cannot run from the storm!")
add("default:class:shaman:0055", "deferred_youcritspell", "customemote", "chants an incantation, sending a devastating burst of elemental magic at {TARGET}.")

-- ---------------------------------------------------------------------
-- YOUHEAL
-- ---------------------------------------------------------------------
add("default:class:shaman:0056", "youheal", "say", "The waters of life flow through you.")
add("default:class:shaman:0057", "youheal", "say", "Let the spirits mend what is broken.")
add("default:class:shaman:0058", "youheal", "say", "The river carries your wounds away.")
add("default:class:shaman:0059", "youheal", "customemote", "places a steady hand on {TARGET}, channeling restorative energies.")

-- ---------------------------------------------------------------------
-- YOUCRITHEAL
-- ---------------------------------------------------------------------
add("default:class:shaman:0060", "youcritheal", "say", "The spirits pour their blessing upon you!")
add("default:class:shaman:0061", "youcritheal", "say", "The flood of life washes over you!")
add("default:class:shaman:0062", "youcritheal", "say", "The ancestors will it, and so it is done!")
add("default:class:shaman:0063", "youcritheal", "say", "Life flows through my hands!")
add("default:class:shaman:0064", "youcritheal", "say", "The tides of healing rise to meet you!")
add("default:class:shaman:0065", "youcritheal", "say", "A miracle of the elements, gifted to you!")
add("default:class:shaman:0066", "youcritheal", "customemote", "calls upon the spirits, enveloping {TARGET} in overwhelming healing energy.")
