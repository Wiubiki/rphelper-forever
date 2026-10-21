-- RPHelper Forever - Priest ability content
-- Corpus migration from the RPhelper_twow Priest catalogue and original RoleplayingHelper lineage.
-- The legacy Priest source carried no named contributor attribution.

local A = RPHelper.Ability.PRIEST
local C = RPHelper.Class.PRIEST
local function add(id, ability, entryType, text)
    A[ability] = A[ability] or ability
    RPHelper.RegisterAbility(C, A[ability], { id = id, type = entryType, text = text })
end

-- =====================================================================

-- Discipline

-- =====================================================================



-- ---------------------------------------------------------------------
-- DISPEL_MAGIC
-- ---------------------------------------------------------------------
add("default:ability:priest:0002", "DISPEL_MAGIC", "say", "Begone, foul sorcery!")
add("default:ability:priest:0003", "DISPEL_MAGIC", "say", "The Light cleanses all corruption!")
add("default:ability:priest:0004", "DISPEL_MAGIC", "customemote", "waves a hand, unraveling the dark magic surrounding {TARGET}.")

-- ---------------------------------------------------------------------
-- DIVINE_SPIRIT
-- ---------------------------------------------------------------------
add("default:ability:priest:0005", "DIVINE_SPIRIT", "say", "May divine spirit guide your path!")
add("default:ability:priest:0006", "DIVINE_SPIRIT", "say", "Let the Light fill your soul!")
add("default:ability:priest:0007", "DIVINE_SPIRIT", "customemote", "raises {PP} hands, calling forth divine blessings upon {TARGET}.")

-- ---------------------------------------------------------------------
-- INNER_FIRE
-- ---------------------------------------------------------------------
add("default:ability:priest:0008", "INNER_FIRE", "say", "Let the holy fire within burn bright!")
add("default:ability:priest:0009", "INNER_FIRE", "say", "Faith fuels my strength!")
add("default:ability:priest:0010", "INNER_FIRE", "customemote", "glows with an Inner Fire.")

-- ---------------------------------------------------------------------
-- INNER_FOCUS
-- ---------------------------------------------------------------------
add("default:ability:priest:0011", "INNER_FOCUS", "say", "Clarity of mind, focus of soul!")
add("default:ability:priest:0012", "INNER_FOCUS", "say", "Let my will be unshaken!")
add("default:ability:priest:0013", "INNER_FOCUS", "customemote", "closes {PP} eyes briefly, drawing upon divine concentration.")

-- ---------------------------------------------------------------------
-- LEVITATE
-- ---------------------------------------------------------------------
add("default:ability:priest:0014", "LEVITATE", "say", "Rise above, freed from earthly bonds!")
add("default:ability:priest:0015", "LEVITATE", "say", "Weightless as the heavens themselves!")
add("default:ability:priest:0016", "LEVITATE", "customemote", "gestures gently, causing {TARGET} to lift off the ground with divine grace.")

-- ---------------------------------------------------------------------
-- MANA_BURN
-- ---------------------------------------------------------------------
add("default:ability:priest:0017", "MANA_BURN", "say", "Your power dwindles before me!")
add("default:ability:priest:0018", "MANA_BURN", "say", "I strip away your arcane might!")
add("default:ability:priest:0019", "MANA_BURN", "customemote", "reaches out, siphoning mana from {TARGET} with a sinister glow.")

-- ---------------------------------------------------------------------
-- PENANCE
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "PENANCE")

-- add("PENANCE", "say", "")
-- add("PENANCE", "emote", "")
-- add("PENANCE", "customemote", "")

-- ---------------------------------------------------------------------
-- POWER_INFUSION
-- ---------------------------------------------------------------------
add("default:ability:priest:0020", "POWER_INFUSION", "say", "Feel the surge of divine might!")
add("default:ability:priest:0021", "POWER_INFUSION", "say", "Let the Light fuel your power!")
add("default:ability:priest:0022", "POWER_INFUSION", "customemote", "places a radiant hand on {TARGET}, infusing them with divine energy.")

-- ---------------------------------------------------------------------
-- POWER_WORD_FORTITUDE
-- ---------------------------------------------------------------------
add("default:ability:priest:0023", "POWER_WORD_FORTITUDE", "say", "May the Light grant you unwavering strength!")
add("default:ability:priest:0024", "POWER_WORD_FORTITUDE", "say", "The spirit is strong, and now so is the flesh!")
add("default:ability:priest:0025", "POWER_WORD_FORTITUDE", "customemote", "raises a hand, bestowing divine resilience upon {TARGET}.")

-- ---------------------------------------------------------------------
-- POWER_WORD_SHIELD
-- ---------------------------------------------------------------------
add("default:ability:priest:0026", "POWER_WORD_SHIELD", "say", "The Light shields you from harm!")
add("default:ability:priest:0027", "POWER_WORD_SHIELD", "say", "Divine protection surrounds you!")
add("default:ability:priest:0028", "POWER_WORD_SHIELD", "customemote", "chants a prayer, encasing {TARGET} in a glowing barrier of holy energy.")

-- ---------------------------------------------------------------------
-- PRAYER_OF_FORTITUDE
-- ---------------------------------------------------------------------
add("default:ability:priest:0029", "PRAYER_OF_FORTITUDE", "say", "Together, we stand unyielding!")
add("default:ability:priest:0030", "PRAYER_OF_FORTITUDE", "say", "May the Light grant us strength!")
add("default:ability:priest:0031", "PRAYER_OF_FORTITUDE", "customemote", "chants a powerful prayer, fortifying the spirits of all nearby allies.")

-- ---------------------------------------------------------------------
-- PRAYER_OF_SPIRIT
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "PRAYER_OF_SPIRIT")

-- add("PRAYER_OF_SPIRIT", "say", "")
-- add("PRAYER_OF_SPIRIT", "emote", "")
-- add("PRAYER_OF_SPIRIT", "customemote", "")

-- ---------------------------------------------------------------------
-- SHACKLE_UNDEAD
-- ---------------------------------------------------------------------
add("default:ability:priest:0032", "SHACKLE_UNDEAD", "say", "The Light binds your wretched soul!")
add("default:ability:priest:0033", "SHACKLE_UNDEAD", "say", "Return to the grave where you belong!")
add("default:ability:priest:0034", "SHACKLE_UNDEAD", "customemote", "chants a sacred incantation, restraining {TARGET} with holy power.")

-- =====================================================================

-- Holy

-- =====================================================================



-- ---------------------------------------------------------------------
-- ABOLISH_DISEASE
-- ---------------------------------------------------------------------
add("default:ability:priest:0035", "ABOLISH_DISEASE", "say", "No sickness shall take hold under my watch!")
add("default:ability:priest:0036", "ABOLISH_DISEASE", "say", "May the Light purge all ailments from you!")
add("default:ability:priest:0037", "ABOLISH_DISEASE", "customemote", "calls upon a wave of divine energy, erasing all traces of illness.")

-- ---------------------------------------------------------------------
-- BINDING_HEAL
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "BINDING_HEAL")

-- add("BINDING_HEAL", "say", "")
-- add("BINDING_HEAL", "emote", "")
-- add("BINDING_HEAL", "customemote", "")

-- ---------------------------------------------------------------------
-- CURE_DISEASE
-- ---------------------------------------------------------------------
add("default:ability:priest:0038", "CURE_DISEASE", "say", "The Light cleanses all impurities.")
add("default:ability:priest:0039", "CURE_DISEASE", "say", "Be purified, and walk in health once more.")
add("default:ability:priest:0040", "CURE_DISEASE", "customemote", "extends a hand, dissolving sickness from {TARGET}’s body.")

-- ---------------------------------------------------------------------
-- FEAR_WARD
-- ---------------------------------------------------------------------
add("default:ability:priest:0041", "FEAR_WARD", "say", "No fear shall take hold of me!")
add("default:ability:priest:0042", "FEAR_WARD", "say", "The Light banishes all terror!")
add("default:ability:priest:0043", "FEAR_WARD", "customemote", "places a protective blessing upon {TARGET}, warding off fear and despair.")

-- ---------------------------------------------------------------------
-- FLASH_HEAL
-- ---------------------------------------------------------------------
add("default:ability:priest:0044", "FLASH_HEAL", "say", "A burst of Light restores you!")
add("default:ability:priest:0045", "FLASH_HEAL", "say", "Let faith be your strength!")
add("default:ability:priest:0046", "FLASH_HEAL", "customemote", "swiftly channels divine energy into {TARGET}, mending their wounds instantly.")

-- ---------------------------------------------------------------------
-- GREATER_HEAL
-- ---------------------------------------------------------------------
add("default:ability:priest:0047", "GREATER_HEAL", "say", "The Light’s full grace restores you.")
add("default:ability:priest:0048", "GREATER_HEAL", "say", "Let the divine power renew your strength.")
add("default:ability:priest:0049", "GREATER_HEAL", "customemote", "focuses intensely, channeling a deep, radiant healing into {TARGET}.")

-- ---------------------------------------------------------------------
-- HEAL
-- ---------------------------------------------------------------------
add("default:ability:priest:0050", "HEAL", "say", "Let the Light soothe your pain.")
add("default:ability:priest:0051", "HEAL", "say", "Wounds fade before divine mercy.")
add("default:ability:priest:0052", "HEAL", "customemote", "chants a quiet prayer, guiding sacred energy into {TARGET}.")

-- ---------------------------------------------------------------------
-- HOLY_FIRE
-- ---------------------------------------------------------------------
add("default:ability:priest:0053", "HOLY_FIRE", "say", "Feel the cleansing flame of righteousness!")
add("default:ability:priest:0054", "HOLY_FIRE", "say", "Burn in the purifying fire of the divine!")
add("default:ability:priest:0055", "HOLY_FIRE", "customemote", "calls forth a blazing holy flame, engulfing {TARGET} in divine fire.")

-- ---------------------------------------------------------------------
-- HOLY_NOVA
-- ---------------------------------------------------------------------
add("default:ability:priest:0056", "HOLY_NOVA", "say", "The Light explodes forth, banishing darkness!")
add("default:ability:priest:0057", "HOLY_NOVA", "say", "A surge of divine power radiates from me!")
add("default:ability:priest:0058", "HOLY_NOVA", "customemote", "unleashes a burst of holy energy, healing allies and striking down foes.")

-- ---------------------------------------------------------------------
-- LESSER_HEAL
-- ---------------------------------------------------------------------
add("default:ability:priest:0059", "LESSER_HEAL", "say", "The Light’s touch mends your wounds.")
add("default:ability:priest:0060", "LESSER_HEAL", "say", "A gentle blessing of healing upon you.")
add("default:ability:priest:0061", "LESSER_HEAL", "customemote", "channels a soft glow of divine energy into {TARGET}.")

-- ---------------------------------------------------------------------
-- PRAYER_OF_HEALING
-- ---------------------------------------------------------------------
add("default:ability:priest:0062", "PRAYER_OF_HEALING", "say", "May the Light embrace all who need it!")
add("default:ability:priest:0063", "PRAYER_OF_HEALING", "say", "A prayer for all, healing in unity!")
add("default:ability:priest:0064", "PRAYER_OF_HEALING", "customemote", "raises {PP} hands, sending waves of healing energy to multiple allies.")

-- ---------------------------------------------------------------------
-- PRAYER_OF_MENDING
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "PRAYER_OF_MENDING")

-- add("PRAYER_OF_MENDING", "say", "")
-- add("PRAYER_OF_MENDING", "emote", "")
-- add("PRAYER_OF_MENDING", "customemote", "")

-- ---------------------------------------------------------------------
-- RENEW
-- ---------------------------------------------------------------------
add("default:ability:priest:0065", "RENEW", "say", "May the Light’s blessing restore you over time.")
add("default:ability:priest:0066", "RENEW", "say", "Healing is a journey, not a moment.")
add("default:ability:priest:0067", "RENEW", "customemote", "extends a hand, weaving an aura of slow, steady healing around {TARGET}.")

-- ---------------------------------------------------------------------
-- RESURRECTION
-- ---------------------------------------------------------------------
add("default:ability:priest:0068", "RESURRECTION", "say", "{TARGET}, your service in this world is not yet finished, awaken!")
add("default:ability:priest:0069", "RESURRECTION", "say", "Rise once more, the Light has not abandoned you!")
add("default:ability:priest:0070", "RESURRECTION", "customemote", "kneels beside {TARGET}, whispering prayers of resurrection.")

-- ---------------------------------------------------------------------
-- SMITE
-- ---------------------------------------------------------------------
add("default:ability:priest:0071", "SMITE", "say", "The Light judges you!")
add("default:ability:priest:0072", "SMITE", "say", "Feel the wrath of divine justice!")
add("default:ability:priest:0073", "SMITE", "customemote", "extends a hand, channeling holy power into a blast against {TARGET}.")

-- =====================================================================

-- Shadow

-- =====================================================================



-- ---------------------------------------------------------------------
-- DEVOURING_PLAGUE
-- ---------------------------------------------------------------------
add("default:ability:priest:0074", "DEVOURING_PLAGUE", "say", "The plague shall consume you!")
add("default:ability:priest:0075", "DEVOURING_PLAGUE", "say", "Your life force withers away!")
add("default:ability:priest:0076", "DEVOURING_PLAGUE", "customemote", "chants in a low whisper, unleashing a virulent plague upon {TARGET}.")

-- ---------------------------------------------------------------------
-- FADE
-- ---------------------------------------------------------------------
add("default:ability:priest:0077", "FADE", "say", "I become but a whisper in the void...")
add("default:ability:priest:0078", "FADE", "say", "The shadows conceal me from harm!")
add("default:ability:priest:0079", "FADE", "customemote", "blurs momentarily, fading from attention.")

-- ---------------------------------------------------------------------
-- MIND_BLAST
-- ---------------------------------------------------------------------
add("default:ability:priest:0080", "MIND_BLAST", "say", "Your thoughts shatter beneath my will!")
add("default:ability:priest:0081", "MIND_BLAST", "say", "The void erupts within your mind!")
add("default:ability:priest:0082", "MIND_BLAST", "customemote", "channels dark magic through glowing hands.")

-- ---------------------------------------------------------------------
-- MIND_CONTROL
-- ---------------------------------------------------------------------
add("default:ability:priest:0083", "MIND_CONTROL", "say", "Do not resist {TARGET}, it is futile!")
add("default:ability:priest:0084", "MIND_CONTROL", "say", "Your will bends to mine, {TARGET}!")
add("default:ability:priest:0085", "MIND_CONTROL", "customemote", "grins wickedly as {TARGET} falls under {PP} influence.")

-- ---------------------------------------------------------------------
-- MIND_FLAY
-- ---------------------------------------------------------------------
add("default:ability:priest:0086", "MIND_FLAY", "say", "Your mind is mine to unravel!")
add("default:ability:priest:0087", "MIND_FLAY", "say", "I pull at the threads of your sanity!")
add("default:ability:priest:0088", "MIND_FLAY", "customemote", "extends a hand, tendrils of shadow latching onto {TARGET}’s mind.")

-- ---------------------------------------------------------------------
-- MIND_SOOTHE
-- ---------------------------------------------------------------------
add("default:ability:priest:0089", "MIND_SOOTHE", "say", "Calm your thoughts, be at peace...")
add("default:ability:priest:0090", "MIND_SOOTHE", "say", "The void whispers serenity.")
add("default:ability:priest:0091", "MIND_SOOTHE", "customemote", "places a gentle hand on {TARGET}, soothing their mind with shadowy whispers.")

-- ---------------------------------------------------------------------
-- MIND_VISION
-- ---------------------------------------------------------------------
add("default:ability:priest:0092", "MIND_VISION", "say", "Allow me to see through your eyes, {TARGET}.")
add("default:ability:priest:0093", "MIND_VISION", "say", "What secrets lie within your gaze, {TARGET}?")
add("default:ability:priest:0094", "MIND_VISION", "customemote", "focuses intently, gazing through {TARGET}’s perspective.")

-- ---------------------------------------------------------------------
-- PRAYER_OF_SHADOW_PROTECTION
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "PRAYER_OF_SHADOW_PROTECTION")

-- add("PRAYER_OF_SHADOW_PROTECTION", "say", "")
-- add("PRAYER_OF_SHADOW_PROTECTION", "emote", "")
-- add("PRAYER_OF_SHADOW_PROTECTION", "customemote", "")

-- ---------------------------------------------------------------------
-- PSYCHIC_SCREAM
-- ---------------------------------------------------------------------
add("default:ability:priest:0095", "PSYCHIC_SCREAM", "say", "Get away from me!")
add("default:ability:priest:0096", "PSYCHIC_SCREAM", "say", "Fear grips your soul!")
add("default:ability:priest:0097", "PSYCHIC_SCREAM", "customemote", "lets out a blood-curdling scream, sending foes fleeing in terror.")

-- ---------------------------------------------------------------------
-- SHADOW_PROTECTION
-- ---------------------------------------------------------------------
add("default:ability:priest:0098", "SHADOW_PROTECTION", "say", "The darkness shall not claim you.")
add("default:ability:priest:0099", "SHADOW_PROTECTION", "say", "Shadow bends to my command, shielding you.")
add("default:ability:priest:0100", "SHADOW_PROTECTION", "customemote", "chants softly, shrouding {TARGET} in protective void energy.")

-- ---------------------------------------------------------------------
-- SHADOW_WORD_DEATH
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "SHADOW_WORD_DEATH")

-- add("SHADOW_WORD_DEATH", "say", "")
-- add("SHADOW_WORD_DEATH", "emote", "")
-- add("SHADOW_WORD_DEATH", "customemote", "")

-- ---------------------------------------------------------------------
-- SHADOW_WORD_PAIN
-- ---------------------------------------------------------------------
add("default:ability:priest:0101", "SHADOW_WORD_PAIN", "say", "The shadows creep into your soul!")
add("default:ability:priest:0102", "SHADOW_WORD_PAIN", "say", "Your agony feeds the darkness!")
add("default:ability:priest:0103", "SHADOW_WORD_PAIN", "customemote", "chants in a dark whisper, afflicting {TARGET} with searing pain.")

-- ---------------------------------------------------------------------
-- SHADOWFORM
-- ---------------------------------------------------------------------
add("default:ability:priest:0104", "SHADOWFORM", "say", "I become one with the void!")
add("default:ability:priest:0105", "SHADOWFORM", "say", "Darkness claims me as its own!")
add("default:ability:priest:0106", "SHADOWFORM", "customemote", "becomes engulfed entirely in pure shadow.")

-- ---------------------------------------------------------------------
-- SILENCE
-- ---------------------------------------------------------------------
add("default:ability:priest:0107", "SILENCE", "say", "Be silent, and know despair!")
add("default:ability:priest:0108", "SILENCE", "say", "The void consumes your voice!")
add("default:ability:priest:0109", "SILENCE", "customemote", "gestures sharply, stealing {TARGET}’s ability to speak or cast magic.")

-- ---------------------------------------------------------------------
-- VAMPIRIC_EMBRACE
-- ---------------------------------------------------------------------
add("default:ability:priest:0110", "VAMPIRIC_EMBRACE", "say", "Your essence shall sustain me!")
add("default:ability:priest:0111", "VAMPIRIC_EMBRACE", "say", "Through your suffering, I am renewed!")
add("default:ability:priest:0112", "VAMPIRIC_EMBRACE", "customemote", "dark energy pulses from {PP}, drawing vitality from {TARGET}.")

-- =====================================================================
-- Racial
-- =====================================================================
-- These are race-specific Priest spells recorded in the Forever beta.
-- They use the ordinary Priest ability catalogue; this section adds no
-- runtime race eligibility checks because the game controls availability.


-- =====================================================================

-- Dwarf

-- =====================================================================



-- ---------------------------------------------------------------------
-- CHASTISE
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "CHASTISE")

-- add("CHASTISE", "say", "")
-- add("CHASTISE", "emote", "")
-- add("CHASTISE", "customemote", "")

-- ---------------------------------------------------------------------
-- DESPERATE_PRAYER
-- ---------------------------------------------------------------------
add("default:ability:priest:0113", "DESPERATE_PRAYER", "say", "Light, hear my desperate plea!")
add("default:ability:priest:0114", "DESPERATE_PRAYER", "say", "In my darkest moment, the Light remains!")
add("default:ability:priest:0115", "DESPERATE_PRAYER", "emote", "PRAY")
add("default:ability:priest:0116", "DESPERATE_PRAYER", "customemote", "clasps {PP} hands together, whispering a desperate prayer for salvation.")

-- =====================================================================

-- Gnome

-- =====================================================================



-- ---------------------------------------------------------------------
-- CONFOUNDING_FLASH
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "CONFOUNDING_FLASH")

-- add("CONFOUNDING_FLASH", "say", "")
-- add("CONFOUNDING_FLASH", "emote", "")
-- add("CONFOUNDING_FLASH", "customemote", "")

-- ---------------------------------------------------------------------
-- CONTINGENCY_PLAN
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "CONTINGENCY_PLAN")

-- add("CONTINGENCY_PLAN", "say", "")
-- add("CONTINGENCY_PLAN", "emote", "")
-- add("CONTINGENCY_PLAN", "customemote", "")

-- =====================================================================

-- Human

-- =====================================================================



-- ---------------------------------------------------------------------
-- DIVINE_GRACE
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "DIVINE_GRACE")

-- add("DIVINE_GRACE", "say", "")
-- add("DIVINE_GRACE", "emote", "")
-- add("DIVINE_GRACE", "customemote", "")

-- ---------------------------------------------------------------------
-- FEEDBACK
-- ---------------------------------------------------------------------
add("default:ability:priest:0117", "FEEDBACK", "say", "Your magic turns against you!")
add("default:ability:priest:0118", "FEEDBACK", "say", "The Light repels your corruption!")
add("default:ability:priest:0119", "FEEDBACK", "customemote", "focuses intensely, reflecting harmful magic back at {TARGET}.")

-- =====================================================================

-- Night Elf

-- =====================================================================



-- ---------------------------------------------------------------------
-- ELUNES_GRACE
-- ---------------------------------------------------------------------
add("default:ability:priest:0120", "ELUNES_GRACE", "say", "Elune’s grace shields me from harm!")
add("default:ability:priest:0121", "ELUNES_GRACE", "say", "The night mother watches over me!")
add("default:ability:priest:0122", "ELUNES_GRACE", "customemote", "whispers a soft prayer as a gentle glow surrounds {PP} form.")

-- ---------------------------------------------------------------------
-- STARSHARDS
-- ---------------------------------------------------------------------
add("default:ability:priest:0123", "STARSHARDS", "say", "Elune’s wrath descends upon you!")
add("default:ability:priest:0124", "STARSHARDS", "say", "The stars shall be your undoing!")
add("default:ability:priest:0125", "STARSHARDS", "customemote", "calls upon Elune, raining down shards of starlight upon {TARGET}.")

-- =====================================================================

-- Troll

-- =====================================================================



-- ---------------------------------------------------------------------
-- HEX_OF_WEAKNESS
-- ---------------------------------------------------------------------
add("default:ability:priest:0126", "HEX_OF_WEAKNESS", "say", "You be feelin’ weaker already, mon!")
add("default:ability:priest:0127", "HEX_OF_WEAKNESS", "say", "Da spirits take your strength!")
add("default:ability:priest:0128", "HEX_OF_WEAKNESS", "customemote", "waves a hand, placing a sinister hex upon {TARGET}.")

-- ---------------------------------------------------------------------
-- SHADOWGUARD
-- ---------------------------------------------------------------------
add("default:ability:priest:0129", "SHADOWGUARD", "say", "Darkness protects me!")
add("default:ability:priest:0130", "SHADOWGUARD", "say", "The void deflects your strike!")
add("default:ability:priest:0131", "SHADOWGUARD", "customemote", "a swirling barrier of shadow encases {PP}, crackling with dark energy.")

-- =====================================================================

-- Undead

-- =====================================================================



-- ---------------------------------------------------------------------
-- DARK_SACRIFICE
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "DARK_SACRIFICE")

-- add("DARK_SACRIFICE", "say", "")
-- add("DARK_SACRIFICE", "emote", "")
-- add("DARK_SACRIFICE", "customemote", "")

-- ---------------------------------------------------------------------
-- TOUCH_OF_WEAKNESS
-- ---------------------------------------------------------------------
add("default:ability:priest:0132", "TOUCH_OF_WEAKNESS", "say", "Your strength fades into nothingness!")
add("default:ability:priest:0133", "TOUCH_OF_WEAKNESS", "say", "The touch of undeath weakens your flesh!")
add("default:ability:priest:0134", "TOUCH_OF_WEAKNESS", "customemote", "reaches out, sapping vitality from {TARGET}.")
