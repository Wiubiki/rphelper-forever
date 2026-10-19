-- RPHelper Forever - Paladin ability content
-- Corpus migration from the RPhelper_twow Paladin catalogue and original RoleplayingHelper lineage.
-- The legacy Paladin source carried no named contributor attribution.

local A = RPHelper.Ability.PALADIN
local C = RPHelper.Class.PALADIN
local function add(ability, entryType, text)
    A[ability] = A[ability] or ability
    RPHelper.RegisterAbility(C, A[ability], { type = entryType, text = text })
end

-- =====================================================================

-- Holy

-- =====================================================================



-- ---------------------------------------------------------------------
-- BLESSING_OF_LIGHT
-- ---------------------------------------------------------------------
add("BLESSING_OF_LIGHT", "say", "May the Light guide your path!")
add("BLESSING_OF_LIGHT", "customemote", "blesses {TARGET} with the brilliance of the Light.")

-- ---------------------------------------------------------------------
-- BLESSING_OF_WISDOM
-- ---------------------------------------------------------------------
add("BLESSING_OF_WISDOM", "say", "Let the Light grant you wisdom!")
add("BLESSING_OF_WISDOM", "customemote", "bestows a blessing of insight upon {TARGET}.")

-- ---------------------------------------------------------------------
-- CLEANSE
-- ---------------------------------------------------------------------
add("CLEANSE", "say", "The Light purges all impurities!")
add("CLEANSE", "customemote", "cleanses {TARGET} of all afflictions.")

-- ---------------------------------------------------------------------
-- CONSECRATION
-- ---------------------------------------------------------------------
add("CONSECRATION", "say", "The ground itself is sanctified!")
add("CONSECRATION", "customemote", "blesses the ground beneath {PP} feet, consecrating the battlefield.")

-- ---------------------------------------------------------------------
-- DIVINE_FAVOR
-- ---------------------------------------------------------------------
add("DIVINE_FAVOR", "say", "The Light smiles upon me!")
add("DIVINE_FAVOR", "customemote", "feels an overwhelming surge of divine favor.")

-- ---------------------------------------------------------------------
-- EXORCISM
-- ---------------------------------------------------------------------
add("EXORCISM", "say", "Begone, foul creature!")
add("EXORCISM", "customemote", "channels divine wrath to smite {TARGET}.")

-- ---------------------------------------------------------------------
-- FLASH_OF_LIGHT
-- ---------------------------------------------------------------------
add("FLASH_OF_LIGHT", "say", "A swift blessing of the Light!")
add("FLASH_OF_LIGHT", "customemote", "quickly channels a burst of divine energy to heal {TARGET}.")

-- ---------------------------------------------------------------------
-- GREATER_BLESSING_OF_LIGHT
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "GREATER_BLESSING_OF_LIGHT")

-- add("GREATER_BLESSING_OF_LIGHT", "say", "")
-- add("GREATER_BLESSING_OF_LIGHT", "emote", "")
-- add("GREATER_BLESSING_OF_LIGHT", "customemote", "")

-- ---------------------------------------------------------------------
-- GREATER_BLESSING_OF_WISDOM
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "GREATER_BLESSING_OF_WISDOM")

-- add("GREATER_BLESSING_OF_WISDOM", "say", "")
-- add("GREATER_BLESSING_OF_WISDOM", "emote", "")
-- add("GREATER_BLESSING_OF_WISDOM", "customemote", "")

-- ---------------------------------------------------------------------
-- HAMMER_OF_WRATH
-- ---------------------------------------------------------------------
add("HAMMER_OF_WRATH", "say", "Feel the weight of divine judgment!")
add("HAMMER_OF_WRATH", "customemote", "hurls a mighty hammer of Light at {TARGET}.")

-- ---------------------------------------------------------------------
-- HOLY_LIGHT
-- ---------------------------------------------------------------------
add("HOLY_LIGHT", "say", "The Light’s warmth heals all wounds!")
add("HOLY_LIGHT", "say", "Let divine radiance restore you!")
add("HOLY_LIGHT", "customemote", "channels the Light’s energy, restoring {TARGET}’s health.")

-- ---------------------------------------------------------------------
-- HOLY_SHOCK
-- ---------------------------------------------------------------------
add("HOLY_SHOCK", "say", "Divine retribution, swift and just!")
add("HOLY_SHOCK", "customemote", "calls down a burst of holy energy upon {TARGET}.")

-- ---------------------------------------------------------------------
-- HOLY_WRATH
-- ---------------------------------------------------------------------
add("HOLY_WRATH", "say", "The Light’s fury shall consume you!")
add("HOLY_WRATH", "customemote", "calls forth a blast of holy power upon undead and demons.")

-- ---------------------------------------------------------------------
-- LAY_ON_HANDS
-- ---------------------------------------------------------------------
add("LAY_ON_HANDS", "say", "By the Light, be restored!")
add("LAY_ON_HANDS", "customemote", "places a radiant hand upon {TARGET}, healing them completely.")

-- ---------------------------------------------------------------------
-- LIGHTS_VIGIL
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "LIGHTS_VIGIL")

-- add("LIGHTS_VIGIL", "say", "")
-- add("LIGHTS_VIGIL", "emote", "")
-- add("LIGHTS_VIGIL", "customemote", "")

-- ---------------------------------------------------------------------
-- PURIFY
-- ---------------------------------------------------------------------
add("PURIFY", "say", "Let the Light cleanse your spirit!")
add("PURIFY", "customemote", "removes impurities from {TARGET}, restoring their purity.")

-- ---------------------------------------------------------------------
-- REDEMPTION
-- ---------------------------------------------------------------------
add("REDEMPTION", "say", "Rise again, and walk in the Light!")
add("REDEMPTION", "customemote", "channels divine energy to resurrect {TARGET}.")

-- ---------------------------------------------------------------------
-- SEAL_OF_LIGHT
-- ---------------------------------------------------------------------
add("SEAL_OF_LIGHT", "say", "The Light empowers my every strike!")
add("SEAL_OF_LIGHT", "customemote", "imbues {PP} weapon with healing energy.")

-- ---------------------------------------------------------------------
-- SEAL_OF_RIGHTEOUSNESS
-- ---------------------------------------------------------------------
add("SEAL_OF_RIGHTEOUSNESS", "say", "My strikes are guided by divine will!")
add("SEAL_OF_RIGHTEOUSNESS", "customemote", "imbues {PP} weapon with righteous fury.")

-- ---------------------------------------------------------------------
-- SEAL_OF_WISDOM
-- ---------------------------------------------------------------------
add("SEAL_OF_WISDOM", "say", "With wisdom, I endure!")
add("SEAL_OF_WISDOM", "customemote", "imbues {PP} weapon with knowledge-giving power.")

-- ---------------------------------------------------------------------
-- SENSE_UNDEAD
-- ---------------------------------------------------------------------
add("SENSE_UNDEAD", "say", "I can feel the taint of undeath nearby...")
add("SENSE_UNDEAD", "customemote", "focuses, attuning {PP} senses to detect the undead.")

-- ---------------------------------------------------------------------
-- TURN_UNDEAD
-- ---------------------------------------------------------------------
add("TURN_UNDEAD", "say", "Back to the shadows with you!")
add("TURN_UNDEAD", "customemote", "raises a holy symbol, forcing {TARGET} to flee in terror.")

-- ---------------------------------------------------------------------
-- VOICE_OF_TRUTH
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "VOICE_OF_TRUTH")

-- add("VOICE_OF_TRUTH", "say", "")
-- add("VOICE_OF_TRUTH", "emote", "")
-- add("VOICE_OF_TRUTH", "customemote", "")

-- =====================================================================

-- Protection

-- =====================================================================



-- ---------------------------------------------------------------------
-- BLESSING_OF_FREEDOM
-- ---------------------------------------------------------------------
add("BLESSING_OF_FREEDOM", "say", "Break free of your chains!")
add("BLESSING_OF_FREEDOM", "customemote", "empowers {TARGET} with the Light, freeing them from hindrances.")

-- ---------------------------------------------------------------------
-- BLESSING_OF_KINGS
-- ---------------------------------------------------------------------
add("BLESSING_OF_KINGS", "say", "Stand tall, as the Light’s chosen!")
add("BLESSING_OF_KINGS", "customemote", "blesses {TARGET} with the wisdom and strength of kings.")

-- ---------------------------------------------------------------------
-- BLESSING_OF_PROTECTION
-- ---------------------------------------------------------------------
add("BLESSING_OF_PROTECTION", "say", "You are safe in the Light’s embrace!")
add("BLESSING_OF_PROTECTION", "customemote", "bestows a divine shield upon {TARGET}, shielding them from harm.")

-- ---------------------------------------------------------------------
-- BLESSING_OF_SACRIFICE
-- ---------------------------------------------------------------------
add("BLESSING_OF_SACRIFICE", "say", "Your burden is now mine!")
add("BLESSING_OF_SACRIFICE", "customemote", "takes on a portion of {TARGET}'s suffering.")

-- ---------------------------------------------------------------------
-- CONCENTRATION_AURA
-- ---------------------------------------------------------------------
add("CONCENTRATION_AURA", "say", "The Light grants unwavering focus!")
add("CONCENTRATION_AURA", "customemote", "radiates an aura that bolsters mental fortitude.")

-- ---------------------------------------------------------------------
-- DEVOTION_AURA
-- ---------------------------------------------------------------------
add("DEVOTION_AURA", "say", "The Light's protection surrounds us!")
add("DEVOTION_AURA", "customemote", "radiates a powerful aura of divine protection.")

-- ---------------------------------------------------------------------
-- DIVINE_INTERVENTION
-- ---------------------------------------------------------------------
add("DIVINE_INTERVENTION", "say", "The Light guides my sacrifice!")
add("DIVINE_INTERVENTION", "customemote", "sacrifices themselves to protect {TARGET}, enveloping them in divine energy.")

-- ---------------------------------------------------------------------
-- DIVINE_PROTECTION
-- ---------------------------------------------------------------------
add("DIVINE_PROTECTION", "say", "The Light shields me from harm!")
add("DIVINE_PROTECTION", "customemote", "becomes encased in a shimmering barrier of divine energy.")

-- ---------------------------------------------------------------------
-- DIVINE_SHIELD
-- ---------------------------------------------------------------------
add("DIVINE_SHIELD", "say", "The Light makes me untouchable!")
add("DIVINE_SHIELD", "customemote", "becomes enveloped in an impenetrable divine barrier.")

-- ---------------------------------------------------------------------
-- FIRE_RESISTANCE_AURA
-- ---------------------------------------------------------------------
add("FIRE_RESISTANCE_AURA", "say", "The Light wards against the flames!")
add("FIRE_RESISTANCE_AURA", "customemote", "radiates an aura that shields against fire magic.")

-- ---------------------------------------------------------------------
-- FROST_RESISTANCE_AURA
-- ---------------------------------------------------------------------
add("FROST_RESISTANCE_AURA", "say", "The Light wards against the cold!")
add("FROST_RESISTANCE_AURA", "customemote", "radiates an aura that shields against frost magic.")

-- ---------------------------------------------------------------------
-- GREATER_BLESSING_OF_KINGS
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "GREATER_BLESSING_OF_KINGS")

-- add("GREATER_BLESSING_OF_KINGS", "say", "")
-- add("GREATER_BLESSING_OF_KINGS", "emote", "")
-- add("GREATER_BLESSING_OF_KINGS", "customemote", "")

-- ---------------------------------------------------------------------
-- HAMMER_OF_JUSTICE
-- ---------------------------------------------------------------------
add("HAMMER_OF_JUSTICE", "say", "Justice is swift!")
add("HAMMER_OF_JUSTICE", "say", "Feel the righteous fury!")
add("HAMMER_OF_JUSTICE", "customemote", "raises {PP} hammer, striking down justice upon {TARGET}.")

-- ---------------------------------------------------------------------
-- HOLY_SHIELD
-- ---------------------------------------------------------------------
add("HOLY_SHIELD", "say", "Divine protection, manifest!")
add("HOLY_SHIELD", "customemote", "raises a radiant shield of holy energy.")

-- ---------------------------------------------------------------------
-- MASS_SALVATION
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "MASS_SALVATION")

-- add("MASS_SALVATION", "say", "")
-- add("MASS_SALVATION", "emote", "")
-- add("MASS_SALVATION", "customemote", "")

-- ---------------------------------------------------------------------
-- REVOKE
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "REVOKE")

-- add("REVOKE", "say", "")
-- add("REVOKE", "emote", "")
-- add("REVOKE", "customemote", "")

-- ---------------------------------------------------------------------
-- RIGHTEOUS_FURY
-- ---------------------------------------------------------------------
add("RIGHTEOUS_FURY", "say", "The Light compels my wrath!")
add("RIGHTEOUS_FURY", "customemote", "channels divine anger, drawing the attention of foes.")

-- ---------------------------------------------------------------------
-- SALVATION
-- ---------------------------------------------------------------------
add("SALVATION", "say", "The Light shelters you from harm!")
add("SALVATION", "customemote", "bestows divine grace upon {TARGET}, reducing their threat.")

-- ---------------------------------------------------------------------
-- SEAL_OF_FURY
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "SEAL_OF_FURY")

-- add("SEAL_OF_FURY", "say", "")
-- add("SEAL_OF_FURY", "emote", "")
-- add("SEAL_OF_FURY", "customemote", "")

-- ---------------------------------------------------------------------
-- SEAL_OF_JUSTICE
-- ---------------------------------------------------------------------
add("SEAL_OF_JUSTICE", "say", "Justice shall be done!")
add("SEAL_OF_JUSTICE", "customemote", "imbues {PP} weapon with divine judgment.")

-- ---------------------------------------------------------------------
-- SHADOW_RESISTANCE_AURA
-- ---------------------------------------------------------------------
add("SHADOW_RESISTANCE_AURA", "say", "The Light repels the darkness!")
add("SHADOW_RESISTANCE_AURA", "customemote", "radiates an aura that shields against shadow magic.")

-- ---------------------------------------------------------------------
-- SWIFT_JUDGEMENT
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "SWIFT_JUDGEMENT")

-- add("SWIFT_JUDGEMENT", "say", "")
-- add("SWIFT_JUDGEMENT", "emote", "")
-- add("SWIFT_JUDGEMENT", "customemote", "")

-- ---------------------------------------------------------------------
-- TEMPLARS_BULWARK
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "TEMPLARS_BULWARK")

-- add("TEMPLARS_BULWARK", "say", "")
-- add("TEMPLARS_BULWARK", "emote", "")
-- add("TEMPLARS_BULWARK", "customemote", "")

-- =====================================================================

-- Retribution

-- =====================================================================



-- ---------------------------------------------------------------------
-- BLESSING_OF_MIGHT
-- ---------------------------------------------------------------------
add("BLESSING_OF_MIGHT", "say", "The Light grants you strength!")
add("BLESSING_OF_MIGHT", "customemote", "imbues {TARGET} with divine might.")

-- ---------------------------------------------------------------------
-- GREATER_BLESSING_OF_MIGHT
-- ---------------------------------------------------------------------
add("GREATER_BLESSING_OF_MIGHT", "say", "With great power, comes holy responsibility!")
add("GREATER_BLESSING_OF_MIGHT", "customemote", "bestows a grand blessing of strength upon {TARGET}.")

-- ---------------------------------------------------------------------
-- HOLY_STRIKE
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "HOLY_STRIKE")

-- add("HOLY_STRIKE", "say", "")
-- add("HOLY_STRIKE", "emote", "")
-- add("HOLY_STRIKE", "customemote", "")

-- ---------------------------------------------------------------------
-- JUDGEMENT
-- ---------------------------------------------------------------------
add("JUDGEMENT", "say", "Face the Light’s judgment!")
add("JUDGEMENT", "customemote", "delivers a powerful verdict upon {TARGET}.")

-- ---------------------------------------------------------------------
-- REPENTANCE
-- ---------------------------------------------------------------------
add("REPENTANCE", "say", "Kneel and seek redemption!")
add("REPENTANCE", "customemote", "compels {TARGET} to reflect upon their sins.")

-- ---------------------------------------------------------------------
-- RETRIBUTION_AURA
-- ---------------------------------------------------------------------
add("RETRIBUTION_AURA", "say", "Let them feel the sting of righteousness!")
add("RETRIBUTION_AURA", "customemote", "radiates an aura of divine vengeance.")

-- ---------------------------------------------------------------------
-- SEAL_OF_COMMAND
-- ---------------------------------------------------------------------
add("SEAL_OF_COMMAND", "say", "The Light commands my blade!")
add("SEAL_OF_COMMAND", "customemote", "infuses {PP} weapon with divine force.")

-- ---------------------------------------------------------------------
-- SEAL_OF_THE_CRUSADER
-- ---------------------------------------------------------------------
add("SEAL_OF_THE_CRUSADER", "say", "The path of the Crusader is righteous!")
add("SEAL_OF_THE_CRUSADER", "customemote", "imbues {PP} weapon with holy fervor.")
