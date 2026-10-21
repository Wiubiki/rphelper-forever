-- RPHelper Forever - Paladin ability content
-- Corpus migration from the RPhelper_twow Paladin catalogue and original RoleplayingHelper lineage.
-- The legacy Paladin source carried no named contributor attribution.

local A = RPHelper.Ability.PALADIN
local C = RPHelper.Class.PALADIN
local function add(id, ability, entryType, text)
    A[ability] = A[ability] or ability
    RPHelper.RegisterAbility(C, A[ability], { id = id, type = entryType, text = text })
end

-- =====================================================================

-- Holy

-- =====================================================================



-- ---------------------------------------------------------------------
-- BLESSING_OF_LIGHT
-- ---------------------------------------------------------------------
add("default:ability:paladin:0002", "BLESSING_OF_LIGHT", "say", "May the Light guide your path!")
add("default:ability:paladin:0003", "BLESSING_OF_LIGHT", "customemote", "blesses {TARGET} with the brilliance of the Light.")

-- ---------------------------------------------------------------------
-- BLESSING_OF_WISDOM
-- ---------------------------------------------------------------------
add("default:ability:paladin:0004", "BLESSING_OF_WISDOM", "say", "Let the Light grant you wisdom!")
add("default:ability:paladin:0005", "BLESSING_OF_WISDOM", "customemote", "bestows a blessing of insight upon {TARGET}.")

-- ---------------------------------------------------------------------
-- CLEANSE
-- ---------------------------------------------------------------------
add("default:ability:paladin:0006", "CLEANSE", "say", "The Light purges all impurities!")
add("default:ability:paladin:0007", "CLEANSE", "customemote", "cleanses {TARGET} of all afflictions.")

-- ---------------------------------------------------------------------
-- CONSECRATION
-- ---------------------------------------------------------------------
add("default:ability:paladin:0008", "CONSECRATION", "say", "The ground itself is sanctified!")
add("default:ability:paladin:0009", "CONSECRATION", "customemote", "blesses the ground beneath {PP} feet, consecrating the battlefield.")

-- ---------------------------------------------------------------------
-- DIVINE_FAVOR
-- ---------------------------------------------------------------------
add("default:ability:paladin:0010", "DIVINE_FAVOR", "say", "The Light smiles upon me!")
add("default:ability:paladin:0011", "DIVINE_FAVOR", "customemote", "feels an overwhelming surge of divine favor.")

-- ---------------------------------------------------------------------
-- EXORCISM
-- ---------------------------------------------------------------------
add("default:ability:paladin:0012", "EXORCISM", "say", "Begone, foul creature!")
add("default:ability:paladin:0013", "EXORCISM", "customemote", "channels divine wrath to smite {TARGET}.")

-- ---------------------------------------------------------------------
-- FLASH_OF_LIGHT
-- ---------------------------------------------------------------------
add("default:ability:paladin:0014", "FLASH_OF_LIGHT", "say", "A swift blessing of the Light!")
add("default:ability:paladin:0015", "FLASH_OF_LIGHT", "customemote", "quickly channels a burst of divine energy to heal {TARGET}.")

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
add("default:ability:paladin:0016", "HAMMER_OF_WRATH", "say", "Feel the weight of divine judgment!")
add("default:ability:paladin:0017", "HAMMER_OF_WRATH", "customemote", "hurls a mighty hammer of Light at {TARGET}.")

-- ---------------------------------------------------------------------
-- HOLY_LIGHT
-- ---------------------------------------------------------------------
add("default:ability:paladin:0018", "HOLY_LIGHT", "say", "The Light’s warmth heals all wounds!")
add("default:ability:paladin:0019", "HOLY_LIGHT", "say", "Let divine radiance restore you!")
add("default:ability:paladin:0020", "HOLY_LIGHT", "customemote", "channels the Light’s energy, restoring {TARGET}’s health.")

-- ---------------------------------------------------------------------
-- HOLY_SHOCK
-- ---------------------------------------------------------------------
add("default:ability:paladin:0021", "HOLY_SHOCK", "say", "Divine retribution, swift and just!")
add("default:ability:paladin:0022", "HOLY_SHOCK", "customemote", "calls down a burst of holy energy upon {TARGET}.")

-- ---------------------------------------------------------------------
-- HOLY_WRATH
-- ---------------------------------------------------------------------
add("default:ability:paladin:0023", "HOLY_WRATH", "say", "The Light’s fury shall consume you!")
add("default:ability:paladin:0024", "HOLY_WRATH", "customemote", "calls forth a blast of holy power upon undead and demons.")

-- ---------------------------------------------------------------------
-- LAY_ON_HANDS
-- ---------------------------------------------------------------------
add("default:ability:paladin:0025", "LAY_ON_HANDS", "say", "By the Light, be restored!")
add("default:ability:paladin:0026", "LAY_ON_HANDS", "customemote", "places a radiant hand upon {TARGET}, healing them completely.")

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
add("default:ability:paladin:0027", "PURIFY", "say", "Let the Light cleanse your spirit!")
add("default:ability:paladin:0028", "PURIFY", "customemote", "removes impurities from {TARGET}, restoring their purity.")

-- ---------------------------------------------------------------------
-- REDEMPTION
-- ---------------------------------------------------------------------
add("default:ability:paladin:0029", "REDEMPTION", "say", "Rise again, and walk in the Light!")
add("default:ability:paladin:0030", "REDEMPTION", "customemote", "channels divine energy to resurrect {TARGET}.")

-- ---------------------------------------------------------------------
-- SEAL_OF_LIGHT
-- ---------------------------------------------------------------------
add("default:ability:paladin:0031", "SEAL_OF_LIGHT", "say", "The Light empowers my every strike!")
add("default:ability:paladin:0032", "SEAL_OF_LIGHT", "customemote", "imbues {PP} weapon with healing energy.")

-- ---------------------------------------------------------------------
-- SEAL_OF_RIGHTEOUSNESS
-- ---------------------------------------------------------------------
add("default:ability:paladin:0033", "SEAL_OF_RIGHTEOUSNESS", "say", "My strikes are guided by divine will!")
add("default:ability:paladin:0034", "SEAL_OF_RIGHTEOUSNESS", "customemote", "imbues {PP} weapon with righteous fury.")

-- ---------------------------------------------------------------------
-- SEAL_OF_WISDOM
-- ---------------------------------------------------------------------
add("default:ability:paladin:0035", "SEAL_OF_WISDOM", "say", "With wisdom, I endure!")
add("default:ability:paladin:0036", "SEAL_OF_WISDOM", "customemote", "imbues {PP} weapon with knowledge-giving power.")

-- ---------------------------------------------------------------------
-- SENSE_UNDEAD
-- ---------------------------------------------------------------------
add("default:ability:paladin:0037", "SENSE_UNDEAD", "say", "I can feel the taint of undeath nearby...")
add("default:ability:paladin:0038", "SENSE_UNDEAD", "customemote", "focuses, attuning {PP} senses to detect the undead.")

-- ---------------------------------------------------------------------
-- TURN_UNDEAD
-- ---------------------------------------------------------------------
add("default:ability:paladin:0039", "TURN_UNDEAD", "say", "Back to the shadows with you!")
add("default:ability:paladin:0040", "TURN_UNDEAD", "customemote", "raises a holy symbol, forcing {TARGET} to flee in terror.")

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
add("default:ability:paladin:0041", "BLESSING_OF_FREEDOM", "say", "Break free of your chains!")
add("default:ability:paladin:0042", "BLESSING_OF_FREEDOM", "customemote", "empowers {TARGET} with the Light, freeing them from hindrances.")

-- ---------------------------------------------------------------------
-- BLESSING_OF_KINGS
-- ---------------------------------------------------------------------
add("default:ability:paladin:0043", "BLESSING_OF_KINGS", "say", "Stand tall, as the Light’s chosen!")
add("default:ability:paladin:0044", "BLESSING_OF_KINGS", "customemote", "blesses {TARGET} with the wisdom and strength of kings.")

-- ---------------------------------------------------------------------
-- BLESSING_OF_PROTECTION
-- ---------------------------------------------------------------------
add("default:ability:paladin:0045", "BLESSING_OF_PROTECTION", "say", "You are safe in the Light’s embrace!")
add("default:ability:paladin:0046", "BLESSING_OF_PROTECTION", "customemote", "bestows a divine shield upon {TARGET}, shielding them from harm.")

-- ---------------------------------------------------------------------
-- BLESSING_OF_SACRIFICE
-- ---------------------------------------------------------------------
add("default:ability:paladin:0047", "BLESSING_OF_SACRIFICE", "say", "Your burden is now mine!")
add("default:ability:paladin:0048", "BLESSING_OF_SACRIFICE", "customemote", "takes on a portion of {TARGET}'s suffering.")

-- ---------------------------------------------------------------------
-- CONCENTRATION_AURA
-- ---------------------------------------------------------------------
add("default:ability:paladin:0049", "CONCENTRATION_AURA", "say", "The Light grants unwavering focus!")
add("default:ability:paladin:0050", "CONCENTRATION_AURA", "customemote", "radiates an aura that bolsters mental fortitude.")

-- ---------------------------------------------------------------------
-- DEVOTION_AURA
-- ---------------------------------------------------------------------
add("default:ability:paladin:0051", "DEVOTION_AURA", "say", "The Light's protection surrounds us!")
add("default:ability:paladin:0052", "DEVOTION_AURA", "customemote", "radiates a powerful aura of divine protection.")

-- ---------------------------------------------------------------------
-- DIVINE_INTERVENTION
-- ---------------------------------------------------------------------
add("default:ability:paladin:0053", "DIVINE_INTERVENTION", "say", "The Light guides my sacrifice!")
add("default:ability:paladin:0054", "DIVINE_INTERVENTION", "customemote", "sacrifices themselves to protect {TARGET}, enveloping them in divine energy.")

-- ---------------------------------------------------------------------
-- DIVINE_PROTECTION
-- ---------------------------------------------------------------------
add("default:ability:paladin:0055", "DIVINE_PROTECTION", "say", "The Light shields me from harm!")
add("default:ability:paladin:0056", "DIVINE_PROTECTION", "customemote", "becomes encased in a shimmering barrier of divine energy.")

-- ---------------------------------------------------------------------
-- DIVINE_SHIELD
-- ---------------------------------------------------------------------
add("default:ability:paladin:0057", "DIVINE_SHIELD", "say", "The Light makes me untouchable!")
add("default:ability:paladin:0058", "DIVINE_SHIELD", "customemote", "becomes enveloped in an impenetrable divine barrier.")

-- ---------------------------------------------------------------------
-- FIRE_RESISTANCE_AURA
-- ---------------------------------------------------------------------
add("default:ability:paladin:0059", "FIRE_RESISTANCE_AURA", "say", "The Light wards against the flames!")
add("default:ability:paladin:0060", "FIRE_RESISTANCE_AURA", "customemote", "radiates an aura that shields against fire magic.")

-- ---------------------------------------------------------------------
-- FROST_RESISTANCE_AURA
-- ---------------------------------------------------------------------
add("default:ability:paladin:0061", "FROST_RESISTANCE_AURA", "say", "The Light wards against the cold!")
add("default:ability:paladin:0062", "FROST_RESISTANCE_AURA", "customemote", "radiates an aura that shields against frost magic.")

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
add("default:ability:paladin:0063", "HAMMER_OF_JUSTICE", "say", "Justice is swift!")
add("default:ability:paladin:0064", "HAMMER_OF_JUSTICE", "say", "Feel the righteous fury!")
add("default:ability:paladin:0065", "HAMMER_OF_JUSTICE", "customemote", "raises {PP} hammer, striking down justice upon {TARGET}.")

-- ---------------------------------------------------------------------
-- HOLY_SHIELD
-- ---------------------------------------------------------------------
add("default:ability:paladin:0066", "HOLY_SHIELD", "say", "Divine protection, manifest!")
add("default:ability:paladin:0067", "HOLY_SHIELD", "customemote", "raises a radiant shield of holy energy.")

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
add("default:ability:paladin:0068", "RIGHTEOUS_FURY", "say", "The Light compels my wrath!")
add("default:ability:paladin:0069", "RIGHTEOUS_FURY", "customemote", "channels divine anger, drawing the attention of foes.")

-- ---------------------------------------------------------------------
-- SALVATION
-- ---------------------------------------------------------------------
add("default:ability:paladin:0070", "SALVATION", "say", "The Light shelters you from harm!")
add("default:ability:paladin:0071", "SALVATION", "customemote", "bestows divine grace upon {TARGET}, reducing their threat.")

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
add("default:ability:paladin:0072", "SEAL_OF_JUSTICE", "say", "Justice shall be done!")
add("default:ability:paladin:0073", "SEAL_OF_JUSTICE", "customemote", "imbues {PP} weapon with divine judgment.")

-- ---------------------------------------------------------------------
-- SHADOW_RESISTANCE_AURA
-- ---------------------------------------------------------------------
add("default:ability:paladin:0074", "SHADOW_RESISTANCE_AURA", "say", "The Light repels the darkness!")
add("default:ability:paladin:0075", "SHADOW_RESISTANCE_AURA", "customemote", "radiates an aura that shields against shadow magic.")

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
add("default:ability:paladin:0076", "BLESSING_OF_MIGHT", "say", "The Light grants you strength!")
add("default:ability:paladin:0077", "BLESSING_OF_MIGHT", "customemote", "imbues {TARGET} with divine might.")

-- ---------------------------------------------------------------------
-- GREATER_BLESSING_OF_MIGHT
-- ---------------------------------------------------------------------
add("default:ability:paladin:0078", "GREATER_BLESSING_OF_MIGHT", "say", "With great power, comes holy responsibility!")
add("default:ability:paladin:0079", "GREATER_BLESSING_OF_MIGHT", "customemote", "bestows a grand blessing of strength upon {TARGET}.")

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
add("default:ability:paladin:0080", "JUDGEMENT", "say", "Face the Light’s judgment!")
add("default:ability:paladin:0081", "JUDGEMENT", "customemote", "delivers a powerful verdict upon {TARGET}.")

-- ---------------------------------------------------------------------
-- REPENTANCE
-- ---------------------------------------------------------------------
add("default:ability:paladin:0082", "REPENTANCE", "say", "Kneel and seek redemption!")
add("default:ability:paladin:0083", "REPENTANCE", "customemote", "compels {TARGET} to reflect upon their sins.")

-- ---------------------------------------------------------------------
-- RETRIBUTION_AURA
-- ---------------------------------------------------------------------
add("default:ability:paladin:0084", "RETRIBUTION_AURA", "say", "Let them feel the sting of righteousness!")
add("default:ability:paladin:0085", "RETRIBUTION_AURA", "customemote", "radiates an aura of divine vengeance.")

-- ---------------------------------------------------------------------
-- SEAL_OF_COMMAND
-- ---------------------------------------------------------------------
add("default:ability:paladin:0086", "SEAL_OF_COMMAND", "say", "The Light commands my blade!")
add("default:ability:paladin:0087", "SEAL_OF_COMMAND", "customemote", "infuses {PP} weapon with divine force.")

-- ---------------------------------------------------------------------
-- SEAL_OF_THE_CRUSADER
-- ---------------------------------------------------------------------
add("default:ability:paladin:0088", "SEAL_OF_THE_CRUSADER", "say", "The path of the Crusader is righteous!")
add("default:ability:paladin:0089", "SEAL_OF_THE_CRUSADER", "customemote", "imbues {PP} weapon with holy fervor.")
