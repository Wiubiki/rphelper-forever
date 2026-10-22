-- RPHelper Forever - Shaman ability content
-- Corpus migration from the RPhelper_twow Shaman catalogue and original RoleplayingHelper lineage.
-- The legacy Shaman source carried no named contributor attribution.

local A = RPHelper.Ability.SHAMAN
local C = RPHelper.Class.SHAMAN
local function add(id, ability, entryType, text)
    A[ability] = A[ability] or ability
    RPHelper.RegisterAbility(C, A[ability], { id = id, type = entryType, text = text })
end

-- =====================================================================
-- Elemental
-- =====================================================================

-- ---------------------------------------------------------------------
-- CALL_OF_THE_ANCESTORS
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "CALL_OF_THE_ANCESTORS")

-- add("CALL_OF_THE_ANCESTORS", "say", "")
-- add("CALL_OF_THE_ANCESTORS", "emote", "")
-- add("CALL_OF_THE_ANCESTORS", "customemote", "")

-- ---------------------------------------------------------------------
-- CALL_OF_THE_ELEMENTS
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "CALL_OF_THE_ELEMENTS")

-- add("CALL_OF_THE_ELEMENTS", "say", "")
-- add("CALL_OF_THE_ELEMENTS", "emote", "")
-- add("CALL_OF_THE_ELEMENTS", "customemote", "")

-- ---------------------------------------------------------------------
-- CALL_OF_THE_SPIRITS
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "CALL_OF_THE_SPIRITS")

-- add("CALL_OF_THE_SPIRITS", "say", "")
-- add("CALL_OF_THE_SPIRITS", "emote", "")
-- add("CALL_OF_THE_SPIRITS", "customemote", "")

-- ---------------------------------------------------------------------
-- CHAIN_LIGHTNING
-- ---------------------------------------------------------------------
add("default:ability:shaman:0002", "CHAIN_LIGHTNING", "say", "None shall escape the storm’s fury!")
add("default:ability:shaman:0003", "CHAIN_LIGHTNING", "say", "The storm leaps from one to another!")
add("default:ability:shaman:0004", "CHAIN_LIGHTNING", "say", "The storm’s fury knows no bounds!")
add("default:ability:shaman:0005", "CHAIN_LIGHTNING", "say", "Lightning dances at my command!")
add("default:ability:shaman:0006", "CHAIN_LIGHTNING", "say", "Thunder’s wrath spreads among you all!")
add("default:ability:shaman:0007", "CHAIN_LIGHTNING", "customemote", "calls forth a bolt of lightning that arcs between enemies, spreading devastation.")

-- ---------------------------------------------------------------------
-- EARTHBIND_TOTEM
-- ---------------------------------------------------------------------
add("default:ability:shaman:0008", "EARTHBIND_TOTEM", "say", "The earth itself slows your steps.")
add("default:ability:shaman:0009", "EARTHBIND_TOTEM", "say", "The ground resists your movement!")
add("default:ability:shaman:0010", "EARTHBIND_TOTEM", "customemote", "places a totem, causing the ground to become unstable and slow movement.")

-- ---------------------------------------------------------------------
-- EARTH_SHOCK
-- ---------------------------------------------------------------------
add("default:ability:shaman:0011", "EARTH_SHOCK", "say", "Feel the ground tremble beneath you!")
add("default:ability:shaman:0012", "EARTH_SHOCK", "say", "The Earth Mother strikes!")
add("default:ability:shaman:0013", "EARTH_SHOCK", "say", "Fall before the strength of the Earth!")
add("default:ability:shaman:0014", "EARTH_SHOCK", "say", "The land itself rises against you!")
add("default:ability:shaman:0015", "EARTH_SHOCK", "say", "Tremble, as the stones shatter your will!")
add("default:ability:shaman:0016", "EARTH_SHOCK", "customemote", "stomps the ground, sending a shockwave towards {TARGET}.")
add("default:ability:shaman:0017", "EARTH_SHOCK", "customemote", "raises a hand glowing with the brown and gold hues of the earth, sending a concussive wave forward.")
add("default:ability:shaman:0018", "EARTH_SHOCK", "customemote", "slams a fist into the ground, sending jagged rocks towards {TARGET}.")

-- ---------------------------------------------------------------------
-- ELEMENTAL_MASTERY
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "ELEMENTAL_MASTERY")

-- add("ELEMENTAL_MASTERY", "say", "")
-- add("ELEMENTAL_MASTERY", "emote", "")
-- add("ELEMENTAL_MASTERY", "customemote", "")

-- ---------------------------------------------------------------------
-- FIRE_NOVA
-- ---------------------------------------------------------------------
add("default:ability:shaman:0019", "FIRE_NOVA", "say", "The land erupts in flame!")
add("default:ability:shaman:0020", "FIRE_NOVA", "customemote", "channels fire energy into an explosive burst from a nearby fire totem.")

-- ---------------------------------------------------------------------
-- FLAME_SHOCK
-- ---------------------------------------------------------------------
add("default:ability:shaman:0021", "FLAME_SHOCK", "say", "Feel the fury of the eternal flame!")
add("default:ability:shaman:0022", "FLAME_SHOCK", "say", "Cleansed by Fire!")
add("default:ability:shaman:0023", "FLAME_SHOCK", "customemote", "gestures sharply, a spark of fire igniting upon their foe.")
add("default:ability:shaman:0024", "FLAME_SHOCK", "customemote", "thrusts their palm forward, a burst of fire sparking upon their enemy.")
add("default:ability:shaman:0025", "FLAME_SHOCK", "customemote", "thrusts their palm forward as they summon a fiery surge.")

-- ---------------------------------------------------------------------
-- FROST_SHOCK
-- ---------------------------------------------------------------------
add("default:ability:shaman:0026", "FROST_SHOCK", "say", "The chill of the ancestors claims you!")
add("default:ability:shaman:0027", "FROST_SHOCK", "say", "Your movements are as frozen as your fate!")
add("default:ability:shaman:0028", "FROST_SHOCK", "say", "The cold shall consume you!")
add("default:ability:shaman:0029", "FROST_SHOCK", "customemote", "exhales sharply as frost gathers in their palm, releasing it with a shattering burst.")
add("default:ability:shaman:0030", "FROST_SHOCK", "customemote", "takes a deep breath as a thin layer of ice crackles under their feet while they channel a frosty shock.")

-- ---------------------------------------------------------------------
-- LAVA_BURST
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "LAVA_BURST")

-- add("LAVA_BURST", "say", "")
-- add("LAVA_BURST", "emote", "")
-- add("LAVA_BURST", "customemote", "")

-- ---------------------------------------------------------------------
-- LIGHTNING_BOLT
-- ---------------------------------------------------------------------
add("default:ability:shaman:0031", "LIGHTNING_BOLT", "say", "The storm’s judgment is swift!")
add("default:ability:shaman:0032", "LIGHTNING_BOLT", "say", "Lightning cleaves the darkness!")
add("default:ability:shaman:0033", "LIGHTNING_BOLT", "say", "Feel the storm’s wrath!")
add("default:ability:shaman:0034", "LIGHTNING_BOLT", "say", "The heavens strike at my command!")
add("default:ability:shaman:0035", "LIGHTNING_BOLT", "say", "The storm answers only to me!")
add("default:ability:shaman:0036", "LIGHTNING_BOLT", "customemote", "raises a crackling hand, hurling a bolt of lightning at {TARGET}.")

-- ---------------------------------------------------------------------
-- MAGMA_TOTEM
-- ---------------------------------------------------------------------
add("default:ability:shaman:0037", "MAGMA_TOTEM", "say", "The land erupts with fury!")
add("default:ability:shaman:0038", "MAGMA_TOTEM", "say", "Lava flows where I command!")
add("default:ability:shaman:0039", "MAGMA_TOTEM", "customemote", "places a totem that radiates waves of molten rock, scorching all nearby.")

-- ---------------------------------------------------------------------
-- PURGE
-- ---------------------------------------------------------------------
add("default:ability:shaman:0040", "PURGE", "say", "The spirits strip you of your corruption!")
add("default:ability:shaman:0041", "PURGE", "say", "No foul magic can stand against me!")
add("default:ability:shaman:0042", "PURGE", "say", "The elements cleanse your taint!")
add("default:ability:shaman:0043", "PURGE", "customemote", "swipes their hand through the air, sending a burst of spiritual energy to dispel the magical corruption.")
add("default:ability:shaman:0044", "PURGE", "customemote", "chants a deep incantation, unraveling the dark magic surrounding {TARGET}.")

-- ---------------------------------------------------------------------
-- SEARING_TOTEM
-- ---------------------------------------------------------------------
add("default:ability:shaman:0045", "SEARING_TOTEM", "say", "The flames shall find you!")
add("default:ability:shaman:0046", "SEARING_TOTEM", "say", "The fire never rests!")
add("default:ability:shaman:0047", "SEARING_TOTEM", "customemote", "places a totem that launches bursts of fire at nearby foes.")

-- ---------------------------------------------------------------------
-- STONECLAW_TOTEM
-- ---------------------------------------------------------------------
add("default:ability:shaman:0048", "STONECLAW_TOTEM", "say", "The earth defends its own!")
add("default:ability:shaman:0049", "STONECLAW_TOTEM", "say", "Stone rises to guard me!")
add("default:ability:shaman:0050", "STONECLAW_TOTEM", "customemote", "places a totem, its aura hardening the ground as it taunts nearby foes.")

-- ---------------------------------------------------------------------
-- TOTEMIC_RECALL
-- ---------------------------------------------------------------------
add("default:ability:shaman:0051", "TOTEMIC_RECALL", "say", "The earth reclaims its gifts.")
add("default:ability:shaman:0052", "TOTEMIC_RECALL", "say", "The spirits withdraw their totems, restoring their essence.")
add("default:ability:shaman:0053", "TOTEMIC_RECALL", "customemote", "chants softly, recalling their totems back into the earth.")

-- =====================================================================
-- Enhancement
-- =====================================================================

-- ---------------------------------------------------------------------
-- ASTRAL_RECALL
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "ASTRAL_RECALL")

-- add("ASTRAL_RECALL", "say", "")
-- add("ASTRAL_RECALL", "emote", "")
-- add("ASTRAL_RECALL", "customemote", "")

-- ---------------------------------------------------------------------
-- FAR_SIGHT
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "FAR_SIGHT")

-- add("FAR_SIGHT", "say", "")
-- add("FAR_SIGHT", "emote", "")
-- add("FAR_SIGHT", "customemote", "")

-- ---------------------------------------------------------------------
-- FIRE_RESISTANCE_TOTEM
-- ---------------------------------------------------------------------
add("default:ability:shaman:0054", "FIRE_RESISTANCE_TOTEM", "say", "The flames will not consume us!")
add("default:ability:shaman:0055", "FIRE_RESISTANCE_TOTEM", "say", "Fire shall break upon our defenses!")
add("default:ability:shaman:0056", "FIRE_RESISTANCE_TOTEM", "customemote", "plants a totem, its aura dampening the intensity of fire-based attacks.")

-- ---------------------------------------------------------------------
-- FLAMETONGUE_TOTEM
-- ---------------------------------------------------------------------
add("default:ability:shaman:0057", "FLAMETONGUE_TOTEM", "say", "Let fire dance upon our weapons!")
add("default:ability:shaman:0058", "FLAMETONGUE_TOTEM", "say", "The fury of flame fuels our strikes!")
add("default:ability:shaman:0059", "FLAMETONGUE_TOTEM", "say", "May our blades burn as hot as the sun!")
add("default:ability:shaman:0060", "FLAMETONGUE_TOTEM", "customemote", "places a totem that glows red-hot, empowering nearby weapons with fire.")

-- ---------------------------------------------------------------------
-- FLAMETONGUE_WEAPON
-- ---------------------------------------------------------------------
add("default:ability:shaman:0061", "FLAMETONGUE_WEAPON", "say", "Fire dances upon my weapon!")
add("default:ability:shaman:0062", "FLAMETONGUE_WEAPON", "say", "Let the flames consume my foes!")
add("default:ability:shaman:0063", "FLAMETONGUE_WEAPON", "customemote", "runs a fiery hand along {PP} weapon, causing it to glow with scorching embers.")

-- ---------------------------------------------------------------------
-- FROSTBRAND_WEAPON
-- ---------------------------------------------------------------------
add("default:ability:shaman:0064", "FROSTBRAND_WEAPON", "say", "Cold bites deep, and so shall I!")
add("default:ability:shaman:0065", "FROSTBRAND_WEAPON", "say", "Ice binds my enemies in place!")
add("default:ability:shaman:0066", "FROSTBRAND_WEAPON", "customemote", "channels the frost, coating {PP} weapon in a layer of jagged ice.")

-- ---------------------------------------------------------------------
-- FROST_RESISTANCE_TOTEM
-- ---------------------------------------------------------------------
add("default:ability:shaman:0067", "FROST_RESISTANCE_TOTEM", "say", "The cold shall not touch us!")
add("default:ability:shaman:0068", "FROST_RESISTANCE_TOTEM", "say", "Frost bends before our will!")
add("default:ability:shaman:0069", "FROST_RESISTANCE_TOTEM", "customemote", "places a totem that radiates warmth, shielding allies from the cold.")

-- ---------------------------------------------------------------------
-- GHOST_WOLF
-- ---------------------------------------------------------------------
add("default:ability:shaman:0070", "GHOST_WOLF", "say", "The spirit of the wolf carries me!")
add("default:ability:shaman:0071", "GHOST_WOLF", "say", "I run with the ancestors!")
add("default:ability:shaman:0072", "GHOST_WOLF", "say", "The wild grants me its speed!")
add("default:ability:shaman:0073", "GHOST_WOLF", "customemote", "shimmers briefly as their form shifts into that of a spectral wolf.")

-- ---------------------------------------------------------------------
-- GRACE_OF_AIR_TOTEM
-- ---------------------------------------------------------------------
add("default:ability:shaman:0074", "GRACE_OF_AIR_TOTEM", "say", "The air grants us speed and balance!")
add("default:ability:shaman:0075", "GRACE_OF_AIR_TOTEM", "say", "The wind carries our steps!")
add("default:ability:shaman:0076", "GRACE_OF_AIR_TOTEM", "say", "Move with the grace and power of the storm!")
add("default:ability:shaman:0077", "GRACE_OF_AIR_TOTEM", "customemote", "places a totem that enhances agility and precision.")

-- ---------------------------------------------------------------------
-- GROUNDING_TOTEM
-- ---------------------------------------------------------------------
add("default:ability:shaman:0078", "GROUNDING_TOTEM", "say", "The spirits shield us from harm!")
add("default:ability:shaman:0079", "GROUNDING_TOTEM", "say", "Magic bends and breaks before our will!")
add("default:ability:shaman:0080", "GROUNDING_TOTEM", "say", "Let the land absorb their spells!")
add("default:ability:shaman:0081", "GROUNDING_TOTEM", "customemote", "plants a totem, drawing magical energy into itself, disrupting enemy spells.")

-- ---------------------------------------------------------------------
-- LIGHTNING_SHIELD
-- ---------------------------------------------------------------------
add("default:ability:shaman:0082", "LIGHTNING_SHIELD", "say", "The storm guards me!")
add("default:ability:shaman:0083", "LIGHTNING_SHIELD", "say", "Let those who strike me taste the storm’s fury!")
add("default:ability:shaman:0084", "LIGHTNING_SHIELD", "say", "The spirits surround me in thunder and lightning!")
add("default:ability:shaman:0085", "LIGHTNING_SHIELD", "say", "Lightning crackles at my call!")
add("default:ability:shaman:0086", "LIGHTNING_SHIELD", "say", "Touch me, and be burned by the storm!")
add("default:ability:shaman:0087", "LIGHTNING_SHIELD", "customemote", "surrounds themselves with crackling arcs of lightning, ready to strike back at attackers.")

-- ---------------------------------------------------------------------
-- NATURE_RESISTANCE_TOTEM
-- ---------------------------------------------------------------------
add("default:ability:shaman:0088", "NATURE_RESISTANCE_TOTEM", "say", "The wind carries away nature’s harm!")
add("default:ability:shaman:0089", "NATURE_RESISTANCE_TOTEM", "say", "The elements shield us from poison and decay!")
add("default:ability:shaman:0090", "NATURE_RESISTANCE_TOTEM", "customemote", "places a totem that hums with natural energy, shielding allies from harm.")

-- ---------------------------------------------------------------------
-- RAGE_OF_THE_FARSEER
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "RAGE_OF_THE_FARSEER")

-- add("RAGE_OF_THE_FARSEER", "say", "")
-- add("RAGE_OF_THE_FARSEER", "emote", "")
-- add("RAGE_OF_THE_FARSEER", "customemote", "")

-- ---------------------------------------------------------------------
-- ROCKBITER_WEAPON
-- ---------------------------------------------------------------------
add("default:ability:shaman:0091", "ROCKBITER_WEAPON", "say", "The strength of the mountains flows through me!")
add("default:ability:shaman:0092", "ROCKBITER_WEAPON", "say", "My weapon becomes unbreakable, like the earth itself!")
add("default:ability:shaman:0093", "ROCKBITER_WEAPON", "customemote", "grips {PP} weapon tightly as its surface hardens with the essence of the earth.")

-- ---------------------------------------------------------------------
-- SENTRY_TOTEM
-- ---------------------------------------------------------------------
add("default:ability:shaman:0094", "SENTRY_TOTEM", "say", "The spirits watch over us!")
add("default:ability:shaman:0095", "SENTRY_TOTEM", "say", "No shadow escapes our sight!")
add("default:ability:shaman:0096", "SENTRY_TOTEM", "customemote", "places a totem that enhances vision, watching over the battlefield.")

-- ---------------------------------------------------------------------
-- STONESKIN_TOTEM
-- ---------------------------------------------------------------------
add("default:ability:shaman:0097", "STONESKIN_TOTEM", "say", "Stone shall shield us!")
add("default:ability:shaman:0098", "STONESKIN_TOTEM", "say", "The earth hardens against our foes!")
add("default:ability:shaman:0099", "STONESKIN_TOTEM", "customemote", "plants a totem, its energy reinforcing the resilience of nearby allies.")

-- ---------------------------------------------------------------------
-- STORMSTRIKE
-- ---------------------------------------------------------------------
add("default:ability:shaman:0100", "STORMSTRIKE", "say", "The storm lends me its strength!")
add("default:ability:shaman:0101", "STORMSTRIKE", "say", "By the thunder’s might, fall before me!")
add("default:ability:shaman:0102", "STORMSTRIKE", "say", "Feel the storm’s vengeance!")
add("default:ability:shaman:0103", "STORMSTRIKE", "say", "Spirits of Storm and Thunder strike through me!")
add("default:ability:shaman:0104", "STORMSTRIKE", "say", "Lightning flows through my weapon, striking with fury!")
add("default:ability:shaman:0105", "STORMSTRIKE", "say", "Thunder cracks as my blow lands!")
add("default:ability:shaman:0106", "STORMSTRIKE", "customemote", "surges forward, their weapon crackling with elemental energy.")
add("default:ability:shaman:0107", "STORMSTRIKE", "customemote", "strikes with ferocious speed as their weapon crackles with raw lightning.")
add("default:ability:shaman:0108", "STORMSTRIKE", "customemote", "surges forward, their weapon a blur of motion and electric fury.")
add("default:ability:shaman:0109", "STORMSTRIKE", "customemote", "channels the power of the storm, unleashing a devastating strike.")

-- ---------------------------------------------------------------------
-- STRENGTH_OF_EARTH_TOTEM
-- ---------------------------------------------------------------------
add("default:ability:shaman:0110", "STRENGTH_OF_EARTH_TOTEM", "say", "The earth grants us its might!")
add("default:ability:shaman:0111", "STRENGTH_OF_EARTH_TOTEM", "say", "The land lends its power to our arms!")
add("default:ability:shaman:0112", "STRENGTH_OF_EARTH_TOTEM", "say", "Strength flows from the deep roots of the world!")
add("default:ability:shaman:0113", "STRENGTH_OF_EARTH_TOTEM", "customemote", "places a totem that pulses with the power of the earth, strengthening allies.")

-- ---------------------------------------------------------------------
-- TOTEMIC_PROJECTION
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "TOTEMIC_PROJECTION")

-- add("TOTEMIC_PROJECTION", "say", "")
-- add("TOTEMIC_PROJECTION", "emote", "")
-- add("TOTEMIC_PROJECTION", "customemote", "")

-- ---------------------------------------------------------------------
-- WATER_BREATHING
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "WATER_BREATHING")

-- add("WATER_BREATHING", "say", "")
-- add("WATER_BREATHING", "emote", "")
-- add("WATER_BREATHING", "customemote", "")

-- ---------------------------------------------------------------------
-- WATER_WALKING
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "WATER_WALKING")

-- add("WATER_WALKING", "say", "")
-- add("WATER_WALKING", "emote", "")
-- add("WATER_WALKING", "customemote", "")

-- ---------------------------------------------------------------------
-- WINDFURY_TOTEM
-- ---------------------------------------------------------------------
add("default:ability:shaman:0114", "WINDFURY_TOTEM", "say", "The winds will guide your strikes!")
add("default:ability:shaman:0115", "WINDFURY_TOTEM", "say", "The storm is at our backs!")
add("default:ability:shaman:0116", "WINDFURY_TOTEM", "say", "Swift as the tempest, strong as the gale!")
add("default:ability:shaman:0117", "WINDFURY_TOTEM", "customemote", "plants a totem that crackles with energy, empowering allies with the power of the wind.")

-- ---------------------------------------------------------------------
-- WINDFURY_WEAPON
-- ---------------------------------------------------------------------
add("default:ability:shaman:0118", "WINDFURY_WEAPON", "say", "Winds of fury, guide my strikes!")
add("default:ability:shaman:0119", "WINDFURY_WEAPON", "say", "Storm and gale, lend me your strength!")
add("default:ability:shaman:0120", "WINDFURY_WEAPON", "say", "The wind sings through my weapon!")
add("default:ability:shaman:0121", "WINDFURY_WEAPON", "say", "Let my blows be as swift as the storm!")
add("default:ability:shaman:0122", "WINDFURY_WEAPON", "say", "The tempests howl in battle with me!")
add("default:ability:shaman:0123", "WINDFURY_WEAPON", "customemote", "runs their hand along their weapon, a faint whirlwind forming around it as sparks of electricity dance in the air.")
add("default:ability:shaman:0124", "WINDFURY_WEAPON", "customemote", "holds their weapon aloft as it gleams with storm energy and crackling thunder.")
add("default:ability:shaman:0125", "WINDFURY_WEAPON", "customemote", "holds their weapon steady as a swirling storm imbues it with the ferocity of the wind.")
add("default:ability:shaman:0126", "WINDFURY_WEAPON", "customemote", "chants a brief prayer as their weapon is infused with the raw power of the four winds.")

-- ---------------------------------------------------------------------
-- WINDWALL_TOTEM
-- ---------------------------------------------------------------------
add("default:ability:shaman:0127", "WINDWALL_TOTEM", "say", "Winds, shield us from harm!")
add("default:ability:shaman:0128", "WINDWALL_TOTEM", "say", "Arrows will bend before the storm!")
add("default:ability:shaman:0129", "WINDWALL_TOTEM", "customemote", "summons a barrier of wind, deflecting incoming projectiles.")

-- =====================================================================
-- Restoration
-- =====================================================================

-- ---------------------------------------------------------------------
-- ANCESTRAL_SPIRIT
-- ---------------------------------------------------------------------
add("default:ability:shaman:0130", "ANCESTRAL_SPIRIT", "say", "Return, {TARGET}, guided by the spirits of old.")
add("default:ability:shaman:0131", "ANCESTRAL_SPIRIT", "say", "The ancestors call you, {TARGET}, back to the living.")
add("default:ability:shaman:0132", "ANCESTRAL_SPIRIT", "say", "Your journey is not yet complete; rise once more, {TARGET}!")
add("default:ability:shaman:0133", "ANCESTRAL_SPIRIT", "say", "The spirits are not yet finished with you, {TARGET}!")
add("default:ability:shaman:0134", "ANCESTRAL_SPIRIT", "say", "The time to meet your ancestors has not arrived. Return to us, {TARGET}!")
add("default:ability:shaman:0135", "ANCESTRAL_SPIRIT", "customemote", "kneels beside the fallen {TARGET}, whispering to the spirits as a pale light surrounds them.")

-- ---------------------------------------------------------------------
-- CHAIN_HEAL
-- ---------------------------------------------------------------------
add("default:ability:shaman:0136", "CHAIN_HEAL", "say", "Let healing flow between us!")
add("default:ability:shaman:0137", "CHAIN_HEAL", "say", "One healed, many restored!")
add("default:ability:shaman:0138", "CHAIN_HEAL", "say", "The waters of life connect us all!")
add("default:ability:shaman:0139", "CHAIN_HEAL", "customemote", "sends a surge of healing energy that leaps from ally to ally.")

-- ---------------------------------------------------------------------
-- CURE_DISEASE
-- ---------------------------------------------------------------------
add("default:ability:shaman:0140", "CURE_DISEASE", "say", "Elements of Water, cleanse {TARGET}'s body and soul.")
add("default:ability:shaman:0141", "CURE_DISEASE", "say", "The disease fades; the spirits endure.")
add("default:ability:shaman:0142", "CURE_DISEASE", "say", "No disease shall hold sway under my watch.")
add("default:ability:shaman:0143", "CURE_DISEASE", "say", "Be cleansed by the spirits’ blessing!")
add("default:ability:shaman:0144", "CURE_DISEASE", "customemote", "sends a ripple of cleansing energy, driving out the foul influence of the disease.")

-- ---------------------------------------------------------------------
-- CURE_POISON
-- ---------------------------------------------------------------------
add("default:ability:shaman:0145", "CURE_POISON", "say", "Spirits of Water cleanse body and soul.")
add("default:ability:shaman:0146", "CURE_POISON", "say", "The poison fades; the spirits endure.")
add("default:ability:shaman:0147", "CURE_POISON", "say", "No poison shall hold sway under my watch.")
add("default:ability:shaman:0148", "CURE_POISON", "say", "Nature’s purity washes over you!")
add("default:ability:shaman:0149", "CURE_POISON", "customemote", "sends a ripple of cleansing energy, driving out the foul influence of the poison.")

-- ---------------------------------------------------------------------
-- DISEASE_CLEANSING_TOTEM
-- ---------------------------------------------------------------------
add("default:ability:shaman:0150", "DISEASE_CLEANSING_TOTEM", "say", "The elements purge all sickness!")
add("default:ability:shaman:0151", "DISEASE_CLEANSING_TOTEM", "say", "No illness shall linger here!")
add("default:ability:shaman:0152", "DISEASE_CLEANSING_TOTEM", "customemote", "places a totem that hums with cleansing power, dispelling diseases.")

-- ---------------------------------------------------------------------
-- HEALING_STREAM_TOTEM
-- ---------------------------------------------------------------------
add("default:ability:shaman:0153", "HEALING_STREAM_TOTEM", "say", "The river of life flows through us!")
add("default:ability:shaman:0154", "HEALING_STREAM_TOTEM", "say", "May the waters soothe our wounds!")
add("default:ability:shaman:0155", "HEALING_STREAM_TOTEM", "say", "Let the spirits’ gift restore us!")
add("default:ability:shaman:0156", "HEALING_STREAM_TOTEM", "customemote", "places a totem that pulses with the gentle flow of healing waters.")

-- ---------------------------------------------------------------------
-- HEALING_WAVE
-- ---------------------------------------------------------------------
add("default:ability:shaman:0157", "HEALING_WAVE", "say", "The ancestors' grace restores.")
add("default:ability:shaman:0158", "HEALING_WAVE", "say", "The spirits guide my hands to heal.")
add("default:ability:shaman:0159", "HEALING_WAVE", "say", "Let the rivers of life heal.")
add("default:ability:shaman:0160", "HEALING_WAVE", "say", "May the tides of the elements cleanse your wounds.")
add("default:ability:shaman:0161", "HEALING_WAVE", "customemote", "chants softly, hands glowing with a soothing energy as they mend {TARGET}’s wounds.")

-- ---------------------------------------------------------------------
-- LESSER_HEALING_WAVE
-- ---------------------------------------------------------------------
add("default:ability:shaman:0162", "LESSER_HEALING_WAVE", "say", "Spirits, mend this wound swiftly!")
add("default:ability:shaman:0163", "LESSER_HEALING_WAVE", "say", "The winds carry my healing to you!")
add("default:ability:shaman:0164", "LESSER_HEALING_WAVE", "customemote", "raises glowing hands and releases a quick pulse of healing energy.")

-- ---------------------------------------------------------------------
-- MANA_SPRING_TOTEM
-- ---------------------------------------------------------------------
add("default:ability:shaman:0165", "MANA_SPRING_TOTEM", "say", "The wellspring of energy is ours!")
add("default:ability:shaman:0166", "MANA_SPRING_TOTEM", "say", "May the tides of mana restore us!")
add("default:ability:shaman:0167", "MANA_SPRING_TOTEM", "customemote", "places a totem that glows with mystical energy, replenishing mana over time.")

-- ---------------------------------------------------------------------
-- MANA_TIDE_TOTEM
-- ---------------------------------------------------------------------
add("default:ability:shaman:0168", "MANA_TIDE_TOTEM", "say", "The tides rise to restore us!")
add("default:ability:shaman:0169", "MANA_TIDE_TOTEM", "say", "A flood of mana returns to our spirits!")
add("default:ability:shaman:0170", "MANA_TIDE_TOTEM", "customemote", "plants a totem that surges with powerful mana-restoring energy.")

-- ---------------------------------------------------------------------
-- NATURES_SWIFTNESS
-- ---------------------------------------------------------------------
add("default:ability:shaman:0171", "NATURES_SWIFTNESS", "say", "The spirits grant me speed!")
add("default:ability:shaman:0172", "NATURES_SWIFTNESS", "say", "The elements quicken my magic!")
add("default:ability:shaman:0173", "NATURES_SWIFTNESS", "customemote", "calls upon the spirits to hasten {PP} next spell.")

-- ---------------------------------------------------------------------
-- POISON_CLEANSING_TOTEM
-- ---------------------------------------------------------------------
add("default:ability:shaman:0174", "POISON_CLEANSING_TOTEM", "say", "The elements purge all toxins!")
add("default:ability:shaman:0175", "POISON_CLEANSING_TOTEM", "say", "No poison shall take root here!")
add("default:ability:shaman:0176", "POISON_CLEANSING_TOTEM", "customemote", "places a totem that radiates a cleansing aura, removing poisons from nearby allies.")

-- ---------------------------------------------------------------------
-- REINCARNATION
-- ---------------------------------------------------------------------
add("default:ability:shaman:0177", "REINCARNATION", "say", "I return, for my path is not yet done.")
add("default:ability:shaman:0178", "REINCARNATION", "say", "The ancestors have sent me back once more.")
add("default:ability:shaman:0179", "REINCARNATION", "say", "From the spirit world, I walk again.")
add("default:ability:shaman:0180", "REINCARNATION", "customemote", "draws breath once more as the spirits guide {PP} return.")

-- ---------------------------------------------------------------------
-- RIPTIDE
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "RIPTIDE")

-- add("RIPTIDE", "say", "")
-- add("RIPTIDE", "emote", "")
-- add("RIPTIDE", "customemote", "")

-- ---------------------------------------------------------------------
-- TREMOR_TOTEM
-- ---------------------------------------------------------------------
add("default:ability:shaman:0181", "TREMOR_TOTEM", "say", "The earth shakes away fear!")
add("default:ability:shaman:0182", "TREMOR_TOTEM", "say", "No nightmare shall bind us!")
add("default:ability:shaman:0183", "TREMOR_TOTEM", "customemote", "places a totem that hums with deep vibrations, shaking off fear and enchantments.")

-- ---------------------------------------------------------------------
-- WATER_SHIELD
-- ---------------------------------------------------------------------
add("default:ability:shaman:0184", "WATER_SHIELD", "say", "The waters flow around me, granting life and renewal.")
add("default:ability:shaman:0185", "WATER_SHIELD", "say", "The Earth Mother’s rivers protect and sustain me.")
add("default:ability:shaman:0186", "WATER_SHIELD", "say", "Spirits of the stream, guide my path.")
add("default:ability:shaman:0187", "WATER_SHIELD", "say", "The tides answer my call, restoring my essence.")
add("default:ability:shaman:0188", "WATER_SHIELD", "customemote", "is encircled by a shimmering sphere of water and gracefully swirling droplets.")
add("default:ability:shaman:0189", "WATER_SHIELD", "customemote", "gestures with a flowing motion as a soothing ripple of water forms a shield around them.")

-- Not in Forever Beta / Legacy Archive
-- Inactive historical reactions are preserved in ShamanArchive.lua, which is
-- intentionally absent from the addon manifest and performs no registrations.
