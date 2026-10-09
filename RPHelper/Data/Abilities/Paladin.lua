-- RPHelper Forever - Paladin ability content
-- Corpus migration from the RPhelper_twow Paladin catalogue and original RoleplayingHelper lineage.
-- The legacy Paladin source carried no named contributor attribution.

local A = RPHelper.Ability.PALADIN
local C = RPHelper.Class.PALADIN
local function add(ability, entryType, text)
    A[ability] = A[ability] or ability
    RPHelper.RegisterAbility(C, A[ability], { type = entryType, text = text })
end

-- ---------------------------------------------------------------------
-- DEVOTION_AURA
-- ---------------------------------------------------------------------
add("DEVOTION_AURA", "say", "The Light's protection surrounds us!")

-- ---------------------------------------------------------------------
-- DEVOTION_AURA
-- ---------------------------------------------------------------------
add("DEVOTION_AURA", "customemote", "radiates a powerful aura of divine protection.")

-- ---------------------------------------------------------------------
-- DIVINE_PROTECTION
-- ---------------------------------------------------------------------
add("DIVINE_PROTECTION", "say", "The Light shields me from harm!")

-- ---------------------------------------------------------------------
-- DIVINE_PROTECTION
-- ---------------------------------------------------------------------
add("DIVINE_PROTECTION", "customemote", "becomes encased in a shimmering barrier of divine energy.")

-- ---------------------------------------------------------------------
-- HAMMER_OF_JUSTICE
-- ---------------------------------------------------------------------
add("HAMMER_OF_JUSTICE", "say", "Justice is swift!")
add("HAMMER_OF_JUSTICE", "say", "Feel the righteous fury!")

-- ---------------------------------------------------------------------
-- HAMMER_OF_JUSTICE
-- ---------------------------------------------------------------------
add("HAMMER_OF_JUSTICE", "customemote", "raises {PP} hammer, striking down justice upon {TARGET}.")

-- ---------------------------------------------------------------------
-- BLESSING_OF_PROTECTION
-- ---------------------------------------------------------------------
add("BLESSING_OF_PROTECTION", "say", "You are safe in the Light’s embrace!")

-- ---------------------------------------------------------------------
-- BLESSING_OF_PROTECTION
-- ---------------------------------------------------------------------
add("BLESSING_OF_PROTECTION", "customemote", "bestows a divine shield upon {TARGET}, shielding them from harm.")

-- ---------------------------------------------------------------------
-- RIGHTEOUS_FURY
-- ---------------------------------------------------------------------
add("RIGHTEOUS_FURY", "say", "The Light compels my wrath!")

-- ---------------------------------------------------------------------
-- RIGHTEOUS_FURY
-- ---------------------------------------------------------------------
add("RIGHTEOUS_FURY", "customemote", "channels divine anger, drawing the attention of foes.")

-- ---------------------------------------------------------------------
-- BLESSING_OF_FREEDOM
-- ---------------------------------------------------------------------
add("BLESSING_OF_FREEDOM", "say", "Break free of your chains!")

-- ---------------------------------------------------------------------
-- BLESSING_OF_FREEDOM
-- ---------------------------------------------------------------------
add("BLESSING_OF_FREEDOM", "customemote", "empowers {TARGET} with the Light, freeing them from hindrances.")

-- ---------------------------------------------------------------------
-- BLESSING_OF_KINGS
-- ---------------------------------------------------------------------
add("BLESSING_OF_KINGS", "say", "Stand tall, as the Light’s chosen!")

-- ---------------------------------------------------------------------
-- BLESSING_OF_KINGS
-- ---------------------------------------------------------------------
add("BLESSING_OF_KINGS", "customemote", "blesses {TARGET} with the wisdom and strength of kings.")

-- ---------------------------------------------------------------------
-- CONCENTRATION_AURA
-- ---------------------------------------------------------------------
add("CONCENTRATION_AURA", "say", "The Light grants unwavering focus!")

-- ---------------------------------------------------------------------
-- CONCENTRATION_AURA
-- ---------------------------------------------------------------------
add("CONCENTRATION_AURA", "customemote", "radiates an aura that bolsters mental fortitude.")

-- ---------------------------------------------------------------------
-- SEAL_OF_JUSTICE
-- ---------------------------------------------------------------------
add("SEAL_OF_JUSTICE", "say", "Justice shall be done!")

-- ---------------------------------------------------------------------
-- SEAL_OF_JUSTICE
-- ---------------------------------------------------------------------
add("SEAL_OF_JUSTICE", "customemote", "imbues {PP} weapon with divine judgment.")

-- ---------------------------------------------------------------------
-- BLESSING_OF_SALVATION
-- ---------------------------------------------------------------------
add("BLESSING_OF_SALVATION", "say", "The Light shelters you from harm!")

-- ---------------------------------------------------------------------
-- BLESSING_OF_SALVATION
-- ---------------------------------------------------------------------
add("BLESSING_OF_SALVATION", "customemote", "bestows divine grace upon {TARGET}, reducing their threat.")

-- ---------------------------------------------------------------------
-- SHADOW_RESISTANCE_AURA
-- ---------------------------------------------------------------------
add("SHADOW_RESISTANCE_AURA", "say", "The Light repels the darkness!")

-- ---------------------------------------------------------------------
-- SHADOW_RESISTANCE_AURA
-- ---------------------------------------------------------------------
add("SHADOW_RESISTANCE_AURA", "customemote", "radiates an aura that shields against shadow magic.")

-- ---------------------------------------------------------------------
-- BLESSING_OF_SANCTUARY
-- ---------------------------------------------------------------------
add("BLESSING_OF_SANCTUARY", "say", "The Light shields you from harm!")

-- ---------------------------------------------------------------------
-- BLESSING_OF_SANCTUARY
-- ---------------------------------------------------------------------
add("BLESSING_OF_SANCTUARY", "customemote", "blesses {TARGET} with divine protection against harm.")

-- ---------------------------------------------------------------------
-- DIVINE_INTERVENTION
-- ---------------------------------------------------------------------
add("DIVINE_INTERVENTION", "say", "The Light guides my sacrifice!")

-- ---------------------------------------------------------------------
-- DIVINE_INTERVENTION
-- ---------------------------------------------------------------------
add("DIVINE_INTERVENTION", "customemote", "sacrifices themselves to protect {TARGET}, enveloping them in divine energy.")

-- ---------------------------------------------------------------------
-- FROST_RESISTANCE_AURA
-- ---------------------------------------------------------------------
add("FROST_RESISTANCE_AURA", "say", "The Light wards against the cold!")

-- ---------------------------------------------------------------------
-- FROST_RESISTANCE_AURA
-- ---------------------------------------------------------------------
add("FROST_RESISTANCE_AURA", "customemote", "radiates an aura that shields against frost magic.")

-- ---------------------------------------------------------------------
-- DIVINE_SHIELD
-- ---------------------------------------------------------------------
add("DIVINE_SHIELD", "say", "The Light makes me untouchable!")

-- ---------------------------------------------------------------------
-- DIVINE_SHIELD
-- ---------------------------------------------------------------------
add("DIVINE_SHIELD", "customemote", "becomes enveloped in an impenetrable divine barrier.")

-- ---------------------------------------------------------------------
-- FIRE_RESISTANCE_AURA
-- ---------------------------------------------------------------------
add("FIRE_RESISTANCE_AURA", "say", "The Light wards against the flames!")

-- ---------------------------------------------------------------------
-- FIRE_RESISTANCE_AURA
-- ---------------------------------------------------------------------
add("FIRE_RESISTANCE_AURA", "customemote", "radiates an aura that shields against fire magic.")

-- ---------------------------------------------------------------------
-- HOLY_SHIELD
-- ---------------------------------------------------------------------
add("HOLY_SHIELD", "say", "Divine protection, manifest!")

-- ---------------------------------------------------------------------
-- HOLY_SHIELD
-- ---------------------------------------------------------------------
add("HOLY_SHIELD", "customemote", "raises a radiant shield of holy energy.")

-- ---------------------------------------------------------------------
-- BLESSING_OF_SACRIFICE
-- ---------------------------------------------------------------------
add("BLESSING_OF_SACRIFICE", "say", "Your burden is now mine!")

-- ---------------------------------------------------------------------
-- BLESSING_OF_SACRIFICE
-- ---------------------------------------------------------------------
add("BLESSING_OF_SACRIFICE", "customemote", "takes on a portion of {TARGET}'s suffering.")

-- ---------------------------------------------------------------------
-- BLESSING_OF_MIGHT
-- ---------------------------------------------------------------------
add("BLESSING_OF_MIGHT", "say", "The Light grants you strength!")

-- ---------------------------------------------------------------------
-- BLESSING_OF_MIGHT
-- ---------------------------------------------------------------------
add("BLESSING_OF_MIGHT", "customemote", "imbues {TARGET} with divine might.")

-- ---------------------------------------------------------------------
-- JUDGEMENT
-- ---------------------------------------------------------------------
add("JUDGEMENT", "say", "Face the Light’s judgment!")

-- ---------------------------------------------------------------------
-- JUDGEMENT
-- ---------------------------------------------------------------------
add("JUDGEMENT", "customemote", "delivers a powerful verdict upon {TARGET}.")

-- ---------------------------------------------------------------------
-- SEAL_OF_THE_CRUSADER
-- ---------------------------------------------------------------------
add("SEAL_OF_THE_CRUSADER", "say", "The path of the Crusader is righteous!")

-- ---------------------------------------------------------------------
-- SEAL_OF_THE_CRUSADER
-- ---------------------------------------------------------------------
add("SEAL_OF_THE_CRUSADER", "customemote", "imbues {PP} weapon with holy fervor.")

-- ---------------------------------------------------------------------
-- RETRIBUTION_AURA
-- ---------------------------------------------------------------------
add("RETRIBUTION_AURA", "say", "Let them feel the sting of righteousness!")

-- ---------------------------------------------------------------------
-- RETRIBUTION_AURA
-- ---------------------------------------------------------------------
add("RETRIBUTION_AURA", "customemote", "radiates an aura of divine vengeance.")

-- ---------------------------------------------------------------------
-- SEAL_OF_COMMAND
-- ---------------------------------------------------------------------
add("SEAL_OF_COMMAND", "say", "The Light commands my blade!")

-- ---------------------------------------------------------------------
-- SEAL_OF_COMMAND
-- ---------------------------------------------------------------------
add("SEAL_OF_COMMAND", "customemote", "infuses {PP} weapon with divine force.")

-- ---------------------------------------------------------------------
-- SANCTITY_AURA
-- ---------------------------------------------------------------------
add("SANCTITY_AURA", "say", "The sacred power of the Light flows through us!")

-- ---------------------------------------------------------------------
-- SANCTITY_AURA
-- ---------------------------------------------------------------------
add("SANCTITY_AURA", "customemote", "radiates an aura of divine sanctity.")

-- ---------------------------------------------------------------------
-- REPENTANCE
-- ---------------------------------------------------------------------
add("REPENTANCE", "say", "Kneel and seek redemption!")

-- ---------------------------------------------------------------------
-- REPENTANCE
-- ---------------------------------------------------------------------
add("REPENTANCE", "customemote", "compels {TARGET} to reflect upon their sins.")

-- ---------------------------------------------------------------------
-- GREATER_BLESSING_OF_MIGHT
-- ---------------------------------------------------------------------
add("GREATER_BLESSING_OF_MIGHT", "say", "With great power, comes holy responsibility!")

-- ---------------------------------------------------------------------
-- GREATER_BLESSING_OF_MIGHT
-- ---------------------------------------------------------------------
add("GREATER_BLESSING_OF_MIGHT", "customemote", "bestows a grand blessing of strength upon {TARGET}.")

-- ---------------------------------------------------------------------
-- HOLY_LIGHT
-- ---------------------------------------------------------------------
add("HOLY_LIGHT", "say", "The Light’s warmth heals all wounds!")
add("HOLY_LIGHT", "say", "Let divine radiance restore you!")

-- ---------------------------------------------------------------------
-- HOLY_LIGHT
-- ---------------------------------------------------------------------
add("HOLY_LIGHT", "customemote", "channels the Light’s energy, restoring {TARGET}’s health.")

-- ---------------------------------------------------------------------
-- PURIFY
-- ---------------------------------------------------------------------
add("PURIFY", "say", "Let the Light cleanse your spirit!")

-- ---------------------------------------------------------------------
-- PURIFY
-- ---------------------------------------------------------------------
add("PURIFY", "customemote", "removes impurities from {TARGET}, restoring their purity.")

-- ---------------------------------------------------------------------
-- LAY_ON_HANDS
-- ---------------------------------------------------------------------
add("LAY_ON_HANDS", "say", "By the Light, be restored!")

-- ---------------------------------------------------------------------
-- LAY_ON_HANDS
-- ---------------------------------------------------------------------
add("LAY_ON_HANDS", "customemote", "places a radiant hand upon {TARGET}, healing them completely.")

-- ---------------------------------------------------------------------
-- SEAL_OF_RIGHTEOUSNESS
-- ---------------------------------------------------------------------
add("SEAL_OF_RIGHTEOUSNESS", "say", "My strikes are guided by divine will!")

-- ---------------------------------------------------------------------
-- SEAL_OF_RIGHTEOUSNESS
-- ---------------------------------------------------------------------
add("SEAL_OF_RIGHTEOUSNESS", "customemote", "imbues {PP} weapon with righteous fury.")

-- ---------------------------------------------------------------------
-- REDEMPTION
-- ---------------------------------------------------------------------
add("REDEMPTION", "say", "Rise again, and walk in the Light!")

-- ---------------------------------------------------------------------
-- REDEMPTION
-- ---------------------------------------------------------------------
add("REDEMPTION", "customemote", "channels divine energy to resurrect {TARGET}.")

-- ---------------------------------------------------------------------
-- BLESSING_OF_WISDOM
-- ---------------------------------------------------------------------
add("BLESSING_OF_WISDOM", "say", "Let the Light grant you wisdom!")

-- ---------------------------------------------------------------------
-- BLESSING_OF_WISDOM
-- ---------------------------------------------------------------------
add("BLESSING_OF_WISDOM", "customemote", "bestows a blessing of insight upon {TARGET}.")

-- ---------------------------------------------------------------------
-- CONSECRATION
-- ---------------------------------------------------------------------
add("CONSECRATION", "say", "The ground itself is sanctified!")

-- ---------------------------------------------------------------------
-- CONSECRATION
-- ---------------------------------------------------------------------
add("CONSECRATION", "customemote", "blesses the ground beneath {PP} feet, consecrating the battlefield.")

-- ---------------------------------------------------------------------
-- EXORCISM
-- ---------------------------------------------------------------------
add("EXORCISM", "say", "Begone, foul creature!")

-- ---------------------------------------------------------------------
-- EXORCISM
-- ---------------------------------------------------------------------
add("EXORCISM", "customemote", "channels divine wrath to smite {TARGET}.")

-- ---------------------------------------------------------------------
-- FLASH_OF_LIGHT
-- ---------------------------------------------------------------------
add("FLASH_OF_LIGHT", "say", "A swift blessing of the Light!")

-- ---------------------------------------------------------------------
-- FLASH_OF_LIGHT
-- ---------------------------------------------------------------------
add("FLASH_OF_LIGHT", "customemote", "quickly channels a burst of divine energy to heal {TARGET}.")

-- ---------------------------------------------------------------------
-- TURN_UNDEAD
-- ---------------------------------------------------------------------
add("TURN_UNDEAD", "say", "Back to the shadows with you!")

-- ---------------------------------------------------------------------
-- TURN_UNDEAD
-- ---------------------------------------------------------------------
add("TURN_UNDEAD", "customemote", "raises a holy symbol, forcing {TARGET} to flee in terror.")

-- ---------------------------------------------------------------------
-- SENSE_UNDEAD
-- ---------------------------------------------------------------------
add("SENSE_UNDEAD", "say", "I can feel the taint of undeath nearby...")

-- ---------------------------------------------------------------------
-- SENSE_UNDEAD
-- ---------------------------------------------------------------------
add("SENSE_UNDEAD", "customemote", "focuses, attuning {PP} senses to detect the undead.")

-- ---------------------------------------------------------------------
-- DIVINE_FAVOR
-- ---------------------------------------------------------------------
add("DIVINE_FAVOR", "say", "The Light smiles upon me!")

-- ---------------------------------------------------------------------
-- DIVINE_FAVOR
-- ---------------------------------------------------------------------
add("DIVINE_FAVOR", "customemote", "feels an overwhelming surge of divine favor.")

-- ---------------------------------------------------------------------
-- SEAL_OF_LIGHT
-- ---------------------------------------------------------------------
add("SEAL_OF_LIGHT", "say", "The Light empowers my every strike!")

-- ---------------------------------------------------------------------
-- SEAL_OF_LIGHT
-- ---------------------------------------------------------------------
add("SEAL_OF_LIGHT", "customemote", "imbues {PP} weapon with healing energy.")

-- ---------------------------------------------------------------------
-- SEAL_OF_WISDOM
-- ---------------------------------------------------------------------
add("SEAL_OF_WISDOM", "say", "With wisdom, I endure!")

-- ---------------------------------------------------------------------
-- SEAL_OF_WISDOM
-- ---------------------------------------------------------------------
add("SEAL_OF_WISDOM", "customemote", "imbues {PP} weapon with knowledge-giving power.")

-- ---------------------------------------------------------------------
-- BLESSING_OF_LIGHT
-- ---------------------------------------------------------------------
add("BLESSING_OF_LIGHT", "say", "May the Light guide your path!")

-- ---------------------------------------------------------------------
-- BLESSING_OF_LIGHT
-- ---------------------------------------------------------------------
add("BLESSING_OF_LIGHT", "customemote", "blesses {TARGET} with the brilliance of the Light.")

-- ---------------------------------------------------------------------
-- HOLY_SHOCK
-- ---------------------------------------------------------------------
add("HOLY_SHOCK", "say", "Divine retribution, swift and just!")

-- ---------------------------------------------------------------------
-- HOLY_SHOCK
-- ---------------------------------------------------------------------
add("HOLY_SHOCK", "customemote", "calls down a burst of holy energy upon {TARGET}.")

-- ---------------------------------------------------------------------
-- SUMMON_WARHORSE
-- ---------------------------------------------------------------------
add("SUMMON_WARHORSE", "say", "A knight must always ride with honor!")

-- ---------------------------------------------------------------------
-- SUMMON_WARHORSE
-- ---------------------------------------------------------------------
add("SUMMON_WARHORSE", "customemote", "summons a noble warhorse, blessed by the Light.")

-- ---------------------------------------------------------------------
-- CLEANSE
-- ---------------------------------------------------------------------
add("CLEANSE", "say", "The Light purges all impurities!")

-- ---------------------------------------------------------------------
-- CLEANSE
-- ---------------------------------------------------------------------
add("CLEANSE", "customemote", "cleanses {TARGET} of all afflictions.")

-- ---------------------------------------------------------------------
-- HAMMER_OF_WRATH
-- ---------------------------------------------------------------------
add("HAMMER_OF_WRATH", "say", "Feel the weight of divine judgment!")

-- ---------------------------------------------------------------------
-- HAMMER_OF_WRATH
-- ---------------------------------------------------------------------
add("HAMMER_OF_WRATH", "customemote", "hurls a mighty hammer of Light at {TARGET}.")

-- ---------------------------------------------------------------------
-- HOLY_WRATH
-- ---------------------------------------------------------------------
add("HOLY_WRATH", "say", "The Light’s fury shall consume you!")

-- ---------------------------------------------------------------------
-- HOLY_WRATH
-- ---------------------------------------------------------------------
add("HOLY_WRATH", "customemote", "calls forth a blast of holy power upon undead and demons.")

-- ---------------------------------------------------------------------
-- BULWARK_OF_THE_RIGHTEOUS
-- ---------------------------------------------------------------------
add("BULWARK_OF_THE_RIGHTEOUS", "say", "The Light shields me, and my shield strikes true!")
add("BULWARK_OF_THE_RIGHTEOUS", "say", "Faith and steel, unbreakable together!")

-- ---------------------------------------------------------------------
-- BULWARK_OF_THE_RIGHTEOUS
-- ---------------------------------------------------------------------
add("BULWARK_OF_THE_RIGHTEOUS", "customemote", "slams {PP} shield into {TARGET}, channeling divine power for protection.")

-- ---------------------------------------------------------------------
-- CRUSADER_STRIKE
-- ---------------------------------------------------------------------
add("CRUSADER_STRIKE", "say", "For the Light, and for justice!")
add("CRUSADER_STRIKE", "say", "Let the Light sear your wickedness!")

-- ---------------------------------------------------------------------
-- CRUSADER_STRIKE
-- ---------------------------------------------------------------------
add("CRUSADER_STRIKE", "customemote", "delivers a righteous strike, amplifying the holy power against {TARGET}.")

-- ---------------------------------------------------------------------
-- HAND_OF_RECKONING
-- ---------------------------------------------------------------------
add("HAND_OF_RECKONING", "say", "Face me, coward!")
add("HAND_OF_RECKONING", "say", "The Light compels you to battle!")

-- ---------------------------------------------------------------------
-- HAND_OF_RECKONING
-- ---------------------------------------------------------------------
add("HAND_OF_RECKONING", "customemote", "raises {PP} hand, calling {TARGET} to face divine judgment.")
