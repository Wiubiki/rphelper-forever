-- RPHelper Forever - Priest ability content
-- Corpus migration from the RPhelper_twow Priest catalogue and original RoleplayingHelper lineage.
-- The legacy Priest source carried no named contributor attribution.

local A = RPHelper.Ability.PRIEST
local C = RPHelper.Class.PRIEST
local function add(ability, entryType, text)
    A[ability] = A[ability] or ability
    RPHelper.RegisterAbility(C, A[ability], { type = entryType, text = text })
end

-- =====================================================================

-- Discipline

-- =====================================================================



-- ---------------------------------------------------------------------
-- DISPEL_MAGIC
-- ---------------------------------------------------------------------
add("DISPEL_MAGIC", "say", "Begone, foul sorcery!")
add("DISPEL_MAGIC", "say", "The Light cleanses all corruption!")
add("DISPEL_MAGIC", "customemote", "waves a hand, unraveling the dark magic surrounding {TARGET}.")

-- ---------------------------------------------------------------------
-- DIVINE_SPIRIT
-- ---------------------------------------------------------------------
add("DIVINE_SPIRIT", "say", "May divine spirit guide your path!")
add("DIVINE_SPIRIT", "say", "Let the Light fill your soul!")
add("DIVINE_SPIRIT", "customemote", "raises {PP} hands, calling forth divine blessings upon {TARGET}.")

-- ---------------------------------------------------------------------
-- INNER_FIRE
-- ---------------------------------------------------------------------
add("INNER_FIRE", "say", "Let the holy fire within burn bright!")
add("INNER_FIRE", "say", "Faith fuels my strength!")
add("INNER_FIRE", "customemote", "glows with an Inner Fire.")

-- ---------------------------------------------------------------------
-- INNER_FOCUS
-- ---------------------------------------------------------------------
add("INNER_FOCUS", "say", "Clarity of mind, focus of soul!")
add("INNER_FOCUS", "say", "Let my will be unshaken!")
add("INNER_FOCUS", "customemote", "closes {PP} eyes briefly, drawing upon divine concentration.")

-- ---------------------------------------------------------------------
-- LEVITATE
-- ---------------------------------------------------------------------
add("LEVITATE", "say", "Rise above, freed from earthly bonds!")
add("LEVITATE", "say", "Weightless as the heavens themselves!")
add("LEVITATE", "customemote", "gestures gently, causing {TARGET} to lift off the ground with divine grace.")

-- ---------------------------------------------------------------------
-- MANA_BURN
-- ---------------------------------------------------------------------
add("MANA_BURN", "say", "Your power dwindles before me!")
add("MANA_BURN", "say", "I strip away your arcane might!")
add("MANA_BURN", "customemote", "reaches out, siphoning mana from {TARGET} with a sinister glow.")

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
add("POWER_INFUSION", "say", "Feel the surge of divine might!")
add("POWER_INFUSION", "say", "Let the Light fuel your power!")
add("POWER_INFUSION", "customemote", "places a radiant hand on {TARGET}, infusing them with divine energy.")

-- ---------------------------------------------------------------------
-- POWER_WORD_FORTITUDE
-- ---------------------------------------------------------------------
add("POWER_WORD_FORTITUDE", "say", "May the Light grant you unwavering strength!")
add("POWER_WORD_FORTITUDE", "say", "The spirit is strong, and now so is the flesh!")
add("POWER_WORD_FORTITUDE", "customemote", "raises a hand, bestowing divine resilience upon {TARGET}.")

-- ---------------------------------------------------------------------
-- POWER_WORD_SHIELD
-- ---------------------------------------------------------------------
add("POWER_WORD_SHIELD", "say", "The Light shields you from harm!")
add("POWER_WORD_SHIELD", "say", "Divine protection surrounds you!")
add("POWER_WORD_SHIELD", "customemote", "chants a prayer, encasing {TARGET} in a glowing barrier of holy energy.")

-- ---------------------------------------------------------------------
-- PRAYER_OF_FORTITUDE
-- ---------------------------------------------------------------------
add("PRAYER_OF_FORTITUDE", "say", "Together, we stand unyielding!")
add("PRAYER_OF_FORTITUDE", "say", "May the Light grant us strength!")
add("PRAYER_OF_FORTITUDE", "customemote", "chants a powerful prayer, fortifying the spirits of all nearby allies.")

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
add("SHACKLE_UNDEAD", "say", "The Light binds your wretched soul!")
add("SHACKLE_UNDEAD", "say", "Return to the grave where you belong!")
add("SHACKLE_UNDEAD", "customemote", "chants a sacred incantation, restraining {TARGET} with holy power.")

-- =====================================================================

-- Holy

-- =====================================================================



-- ---------------------------------------------------------------------
-- ABOLISH_DISEASE
-- ---------------------------------------------------------------------
add("ABOLISH_DISEASE", "say", "No sickness shall take hold under my watch!")
add("ABOLISH_DISEASE", "say", "May the Light purge all ailments from you!")
add("ABOLISH_DISEASE", "customemote", "calls upon a wave of divine energy, erasing all traces of illness.")

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
add("CURE_DISEASE", "say", "The Light cleanses all impurities.")
add("CURE_DISEASE", "say", "Be purified, and walk in health once more.")
add("CURE_DISEASE", "customemote", "extends a hand, dissolving sickness from {TARGET}’s body.")

-- ---------------------------------------------------------------------
-- FEAR_WARD
-- ---------------------------------------------------------------------
add("FEAR_WARD", "say", "No fear shall take hold of me!")
add("FEAR_WARD", "say", "The Light banishes all terror!")
add("FEAR_WARD", "customemote", "places a protective blessing upon {TARGET}, warding off fear and despair.")

-- ---------------------------------------------------------------------
-- FLASH_HEAL
-- ---------------------------------------------------------------------
add("FLASH_HEAL", "say", "A burst of Light restores you!")
add("FLASH_HEAL", "say", "Let faith be your strength!")
add("FLASH_HEAL", "customemote", "swiftly channels divine energy into {TARGET}, mending their wounds instantly.")

-- ---------------------------------------------------------------------
-- GREATER_HEAL
-- ---------------------------------------------------------------------
add("GREATER_HEAL", "say", "The Light’s full grace restores you.")
add("GREATER_HEAL", "say", "Let the divine power renew your strength.")
add("GREATER_HEAL", "customemote", "focuses intensely, channeling a deep, radiant healing into {TARGET}.")

-- ---------------------------------------------------------------------
-- HEAL
-- ---------------------------------------------------------------------
add("HEAL", "say", "Let the Light soothe your pain.")
add("HEAL", "say", "Wounds fade before divine mercy.")
add("HEAL", "customemote", "chants a quiet prayer, guiding sacred energy into {TARGET}.")

-- ---------------------------------------------------------------------
-- HOLY_FIRE
-- ---------------------------------------------------------------------
add("HOLY_FIRE", "say", "Feel the cleansing flame of righteousness!")
add("HOLY_FIRE", "say", "Burn in the purifying fire of the divine!")
add("HOLY_FIRE", "customemote", "calls forth a blazing holy flame, engulfing {TARGET} in divine fire.")

-- ---------------------------------------------------------------------
-- HOLY_NOVA
-- ---------------------------------------------------------------------
add("HOLY_NOVA", "say", "The Light explodes forth, banishing darkness!")
add("HOLY_NOVA", "say", "A surge of divine power radiates from me!")
add("HOLY_NOVA", "customemote", "unleashes a burst of holy energy, healing allies and striking down foes.")

-- ---------------------------------------------------------------------
-- LESSER_HEAL
-- ---------------------------------------------------------------------
add("LESSER_HEAL", "say", "The Light’s touch mends your wounds.")
add("LESSER_HEAL", "say", "A gentle blessing of healing upon you.")
add("LESSER_HEAL", "customemote", "channels a soft glow of divine energy into {TARGET}.")

-- ---------------------------------------------------------------------
-- PRAYER_OF_HEALING
-- ---------------------------------------------------------------------
add("PRAYER_OF_HEALING", "say", "May the Light embrace all who need it!")
add("PRAYER_OF_HEALING", "say", "A prayer for all, healing in unity!")
add("PRAYER_OF_HEALING", "customemote", "raises {PP} hands, sending waves of healing energy to multiple allies.")

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
add("RENEW", "say", "May the Light’s blessing restore you over time.")
add("RENEW", "say", "Healing is a journey, not a moment.")
add("RENEW", "customemote", "extends a hand, weaving an aura of slow, steady healing around {TARGET}.")

-- ---------------------------------------------------------------------
-- RESURRECTION
-- ---------------------------------------------------------------------
add("RESURRECTION", "say", "{TARGET}, your service in this world is not yet finished, awaken!")
add("RESURRECTION", "say", "Rise once more, the Light has not abandoned you!")
add("RESURRECTION", "customemote", "kneels beside {TARGET}, whispering prayers of resurrection.")

-- ---------------------------------------------------------------------
-- SMITE
-- ---------------------------------------------------------------------
add("SMITE", "say", "The Light judges you!")
add("SMITE", "say", "Feel the wrath of divine justice!")
add("SMITE", "customemote", "extends a hand, channeling holy power into a blast against {TARGET}.")

-- =====================================================================

-- Shadow

-- =====================================================================



-- ---------------------------------------------------------------------
-- DEVOURING_PLAGUE
-- ---------------------------------------------------------------------
add("DEVOURING_PLAGUE", "say", "The plague shall consume you!")
add("DEVOURING_PLAGUE", "say", "Your life force withers away!")
add("DEVOURING_PLAGUE", "customemote", "chants in a low whisper, unleashing a virulent plague upon {TARGET}.")

-- ---------------------------------------------------------------------
-- FADE
-- ---------------------------------------------------------------------
add("FADE", "say", "I become but a whisper in the void...")
add("FADE", "say", "The shadows conceal me from harm!")
add("FADE", "customemote", "blurs momentarily, fading from attention.")

-- ---------------------------------------------------------------------
-- MIND_BLAST
-- ---------------------------------------------------------------------
add("MIND_BLAST", "say", "Your thoughts shatter beneath my will!")
add("MIND_BLAST", "say", "The void erupts within your mind!")
add("MIND_BLAST", "customemote", "channels dark magic through glowing hands.")

-- ---------------------------------------------------------------------
-- MIND_CONTROL
-- ---------------------------------------------------------------------
add("MIND_CONTROL", "say", "Do not resist {TARGET}, it is futile!")
add("MIND_CONTROL", "say", "Your will bends to mine, {TARGET}!")
add("MIND_CONTROL", "customemote", "grins wickedly as {TARGET} falls under {PP} influence.")

-- ---------------------------------------------------------------------
-- MIND_FLAY
-- ---------------------------------------------------------------------
add("MIND_FLAY", "say", "Your mind is mine to unravel!")
add("MIND_FLAY", "say", "I pull at the threads of your sanity!")
add("MIND_FLAY", "customemote", "extends a hand, tendrils of shadow latching onto {TARGET}’s mind.")

-- ---------------------------------------------------------------------
-- MIND_SOOTHE
-- ---------------------------------------------------------------------
add("MIND_SOOTHE", "say", "Calm your thoughts, be at peace...")
add("MIND_SOOTHE", "say", "The void whispers serenity.")
add("MIND_SOOTHE", "customemote", "places a gentle hand on {TARGET}, soothing their mind with shadowy whispers.")

-- ---------------------------------------------------------------------
-- MIND_VISION
-- ---------------------------------------------------------------------
add("MIND_VISION", "say", "Allow me to see through your eyes, {TARGET}.")
add("MIND_VISION", "say", "What secrets lie within your gaze, {TARGET}?")
add("MIND_VISION", "customemote", "focuses intently, gazing through {TARGET}’s perspective.")

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
add("PSYCHIC_SCREAM", "say", "Get away from me!")
add("PSYCHIC_SCREAM", "say", "Fear grips your soul!")
add("PSYCHIC_SCREAM", "customemote", "lets out a blood-curdling scream, sending foes fleeing in terror.")

-- ---------------------------------------------------------------------
-- SHADOW_PROTECTION
-- ---------------------------------------------------------------------
add("SHADOW_PROTECTION", "say", "The darkness shall not claim you.")
add("SHADOW_PROTECTION", "say", "Shadow bends to my command, shielding you.")
add("SHADOW_PROTECTION", "customemote", "chants softly, shrouding {TARGET} in protective void energy.")

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
add("SHADOW_WORD_PAIN", "say", "The shadows creep into your soul!")
add("SHADOW_WORD_PAIN", "say", "Your agony feeds the darkness!")
add("SHADOW_WORD_PAIN", "customemote", "chants in a dark whisper, afflicting {TARGET} with searing pain.")

-- ---------------------------------------------------------------------
-- SHADOWFORM
-- ---------------------------------------------------------------------
add("SHADOWFORM", "say", "I become one with the void!")
add("SHADOWFORM", "say", "Darkness claims me as its own!")
add("SHADOWFORM", "customemote", "becomes engulfed entirely in pure shadow.")

-- ---------------------------------------------------------------------
-- SILENCE
-- ---------------------------------------------------------------------
add("SILENCE", "say", "Be silent, and know despair!")
add("SILENCE", "say", "The void consumes your voice!")
add("SILENCE", "customemote", "gestures sharply, stealing {TARGET}’s ability to speak or cast magic.")

-- ---------------------------------------------------------------------
-- VAMPIRIC_EMBRACE
-- ---------------------------------------------------------------------
add("VAMPIRIC_EMBRACE", "say", "Your essence shall sustain me!")
add("VAMPIRIC_EMBRACE", "say", "Through your suffering, I am renewed!")
add("VAMPIRIC_EMBRACE", "customemote", "dark energy pulses from {PP}, drawing vitality from {TARGET}.")

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
add("DESPERATE_PRAYER", "say", "Light, hear my desperate plea!")
add("DESPERATE_PRAYER", "say", "In my darkest moment, the Light remains!")
add("DESPERATE_PRAYER", "emote", "PRAY")
add("DESPERATE_PRAYER", "customemote", "clasps {PP} hands together, whispering a desperate prayer for salvation.")

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
add("FEEDBACK", "say", "Your magic turns against you!")
add("FEEDBACK", "say", "The Light repels your corruption!")
add("FEEDBACK", "customemote", "focuses intensely, reflecting harmful magic back at {TARGET}.")

-- =====================================================================

-- Night Elf

-- =====================================================================



-- ---------------------------------------------------------------------
-- ELUNES_GRACE
-- ---------------------------------------------------------------------
add("ELUNES_GRACE", "say", "Elune’s grace shields me from harm!")
add("ELUNES_GRACE", "say", "The night mother watches over me!")
add("ELUNES_GRACE", "customemote", "whispers a soft prayer as a gentle glow surrounds {PP} form.")

-- ---------------------------------------------------------------------
-- STARSHARDS
-- ---------------------------------------------------------------------
add("STARSHARDS", "say", "Elune’s wrath descends upon you!")
add("STARSHARDS", "say", "The stars shall be your undoing!")
add("STARSHARDS", "customemote", "calls upon Elune, raining down shards of starlight upon {TARGET}.")

-- =====================================================================

-- Troll

-- =====================================================================



-- ---------------------------------------------------------------------
-- HEX_OF_WEAKNESS
-- ---------------------------------------------------------------------
add("HEX_OF_WEAKNESS", "say", "You be feelin’ weaker already, mon!")
add("HEX_OF_WEAKNESS", "say", "Da spirits take your strength!")
add("HEX_OF_WEAKNESS", "customemote", "waves a hand, placing a sinister hex upon {TARGET}.")

-- ---------------------------------------------------------------------
-- SHADOWGUARD
-- ---------------------------------------------------------------------
add("SHADOWGUARD", "say", "Darkness protects me!")
add("SHADOWGUARD", "say", "The void deflects your strike!")
add("SHADOWGUARD", "customemote", "a swirling barrier of shadow encases {PP}, crackling with dark energy.")

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
add("TOUCH_OF_WEAKNESS", "say", "Your strength fades into nothingness!")
add("TOUCH_OF_WEAKNESS", "say", "The touch of undeath weakens your flesh!")
add("TOUCH_OF_WEAKNESS", "customemote", "reaches out, sapping vitality from {TARGET}.")
