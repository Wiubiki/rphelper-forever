-- RPHelper Forever - Shaman English content
-- Corpus migration from the RPhelper_twow Shaman catalogue and original RoleplayingHelper lineage.
-- The legacy Shaman source carried no named contributor attribution.

local C = RPHelper.Class.SHAMAN
local function add(trigger, entryType, text)
    RPHelper.RegisterClass(C, trigger, { type = entryType, text = text })
end

-- ---------------------------------------------------------------------
-- ENTERCOMBAT
-- ---------------------------------------------------------------------
add("entercombat", "say", "The spirits guide me.")
add("entercombat", "say", "You ever been hit by lightning where the sun don't shine?")
add("entercombat", "say", "Thunder answers my call!")
add("entercombat", "say", "Storm and fury, at my command!")
add("entercombat", "say", "Elements rise with me!")

-- ---------------------------------------------------------------------
-- ENTERCOMBAT
-- ---------------------------------------------------------------------
add("entercombat", "emote", "CHARGE")

-- ---------------------------------------------------------------------
-- ENTERCOMBAT
-- ---------------------------------------------------------------------
add("entercombat", "customemote", "raises {PP} weapon, calling upon the storm.")

-- ---------------------------------------------------------------------
-- LEAVECOMBAT
-- ---------------------------------------------------------------------
add("leavecombat", "say", "The storm calms... for now.")
add("leavecombat", "say", "Balance is restored.")
add("leavecombat", "say", "The battle fades, the elements appeased.")
add("leavecombat", "say", "The battle fades, the spirits are calmed.")

-- ---------------------------------------------------------------------
-- LEAVECOMBAT
-- ---------------------------------------------------------------------
add("leavecombat", "customemote", "exhales deeply, feeling the elements settle.")

-- ---------------------------------------------------------------------
-- HURT
-- ---------------------------------------------------------------------
add("hurt", "say", "Pain is the price of wisdom.")
add("hurt", "say", "The storm rages within me still...")
add("hurt", "say", "The earth trembles, but I do not fall.")
add("hurt", "say", "The ancestor spirits are still with me!")

-- ---------------------------------------------------------------------
-- HURT
-- ---------------------------------------------------------------------
add("hurt", "emote", "WINCE")

-- ---------------------------------------------------------------------
-- HURT
-- ---------------------------------------------------------------------
add("hurt", "customemote", "grits {PP} teeth, channeling endurance through the elements.")

-- ---------------------------------------------------------------------
-- ABSORB
-- ---------------------------------------------------------------------
add("absorb", "say", "The spirits shield me!")
add("absorb", "say", "Like water, I bend but do not break!")
add("absorb", "say", "The elements turn your force aside!")

-- ---------------------------------------------------------------------
-- ABSORB
-- ---------------------------------------------------------------------
add("absorb", "customemote", "chants an incantation, deflecting the blow with elemental energy.")

-- ---------------------------------------------------------------------
-- BLOCK
-- ---------------------------------------------------------------------
add("block", "say", "Earth stands firm!")
add("block", "say", "You strike against stone!")
add("block", "say", "My shield is as unyielding as the mountain!")
add("block", "say", "This {PLAYER_RACE} is a Guardian of the Elements. No blow shall pass!")

-- ---------------------------------------------------------------------
-- BLOCK
-- ---------------------------------------------------------------------
add("block", "customemote", "raises {PP} shield, letting the force of the earth absorb the impact.")

-- ---------------------------------------------------------------------
-- DODGE
-- ---------------------------------------------------------------------
add("dodge", "say", "The wind whispers, and I listen.")
add("dodge", "say", "Like the river, I flow beyond your reach.")
add("dodge", "say", "Lightning moves faster than steel!")

-- ---------------------------------------------------------------------
-- DODGE
-- ---------------------------------------------------------------------
add("dodge", "customemote", "sidesteps swiftly, carried by the wind’s guidance.")

-- ---------------------------------------------------------------------
-- MISS
-- ---------------------------------------------------------------------
add("miss", "say", "Your aim falters, as the spirits will it.")
add("miss", "say", "You strike only air and shadows {TARGET}!")
add("miss", "say", "Perhaps the winds favor me today!")

-- ---------------------------------------------------------------------
-- MISS
-- ---------------------------------------------------------------------
add("miss", "customemote", "smirks as the attack fails to connect, the wind swirling around {PP}.")

-- ---------------------------------------------------------------------
-- PARRY
-- ---------------------------------------------------------------------
add("parry", "say", "The storm turns aside your blade!")
add("parry", "say", "Steel cannot match the will of the elements!")
add("parry", "say", "The spirits guide my hand!")
add("parry", "say", "The elements deny you, {TARGET}!")

-- ---------------------------------------------------------------------
-- PARRY
-- ---------------------------------------------------------------------
add("parry", "customemote", "redirects the attack with a well-timed movement, channeling elemental force.")

-- ---------------------------------------------------------------------
-- YOUCRIT
-- ---------------------------------------------------------------------
add("youcrit", "say", "The spirits strike with me!")
add("youcrit", "say", "The storm rages through my weapon!")
add("youcrit", "say", "A blow as strong as the earth itself!")
add("youcrit", "say", "The thunder sings with my strike!")
add("youcrit", "say", "Fury of the tempest, channeled through me!")
add("youcrit", "say", "Stone and storm shatter your defenses!")

-- ---------------------------------------------------------------------
-- YOUCRIT
-- ---------------------------------------------------------------------
add("youcrit", "customemote", "delivers a crushing strike, infused with elemental fury.")

-- ---------------------------------------------------------------------
-- DEFERRED: LEGACY YOUCRITSPELL (NOT AN ACTIVE GENERIC TRIGGER)
-- ---------------------------------------------------------------------
add("deferred_youcritspell", "say", "The fury of the storm is unleashed!")
add("deferred_youcritspell", "say", "Lightning never strikes twice... except when I command it!")
add("deferred_youcritspell", "say", "The spirits answer my call with power!")
add("deferred_youcritspell", "say", "Fire, wind, water, and earth... all against you!")
add("deferred_youcritspell", "say", "Your doom is written in the skies!")
add("deferred_youcritspell", "say", "You cannot run from the storm!")

-- ---------------------------------------------------------------------
-- DEFERRED: LEGACY YOUCRITSPELL (NOT AN ACTIVE GENERIC TRIGGER)
-- ---------------------------------------------------------------------
add("deferred_youcritspell", "customemote", "chants an incantation, sending a devastating burst of elemental magic at {TARGET}.")

-- ---------------------------------------------------------------------
-- YOUHEAL
-- ---------------------------------------------------------------------
add("youheal", "say", "The waters of life flow through you.")
add("youheal", "say", "Let the spirits mend what is broken.")
add("youheal", "say", "The river carries your wounds away.")

-- ---------------------------------------------------------------------
-- YOUHEAL
-- ---------------------------------------------------------------------
add("youheal", "customemote", "places a steady hand on {TARGET}, channeling restorative energies.")

-- ---------------------------------------------------------------------
-- YOUCRITHEAL
-- ---------------------------------------------------------------------
add("youcritheal", "say", "The spirits pour their blessing upon you!")
add("youcritheal", "say", "The flood of life washes over you!")
add("youcritheal", "say", "The ancestors will it, and so it is done!")
add("youcritheal", "say", "Life flows through my hands!")
add("youcritheal", "say", "The tides of healing rise to meet you!")
add("youcritheal", "say", "A miracle of the elements, gifted to you!")

-- ---------------------------------------------------------------------
-- YOUCRITHEAL
-- ---------------------------------------------------------------------
add("youcritheal", "customemote", "calls upon the spirits, enveloping {TARGET} in overwhelming healing energy.")
