-- RPHelper Forever - Priest ability content
-- Corpus migration from the RPhelper_twow Priest catalogue and original RoleplayingHelper lineage.
-- The legacy Priest source carried no named contributor attribution.

local A = RPHelper.Ability.PRIEST
local C = RPHelper.Class.PRIEST
local function add(ability, entryType, text)
    A[ability] = A[ability] or ability
    RPHelper.RegisterAbility(C, A[ability], { type = entryType, text = text })
end

-- ---------------------------------------------------------------------
-- POWER_WORD_FORTITUDE
-- ---------------------------------------------------------------------
add("POWER_WORD_FORTITUDE", "say", "May the Light grant you unwavering strength!")
add("POWER_WORD_FORTITUDE", "say", "The spirit is strong, and now so is the flesh!")

-- ---------------------------------------------------------------------
-- POWER_WORD_FORTITUDE
-- ---------------------------------------------------------------------
add("POWER_WORD_FORTITUDE", "customemote", "raises a hand, bestowing divine resilience upon {TARGET}.")

-- ---------------------------------------------------------------------
-- POWER_WORD_SHIELD
-- ---------------------------------------------------------------------
add("POWER_WORD_SHIELD", "say", "The Light shields you from harm!")
add("POWER_WORD_SHIELD", "say", "Divine protection surrounds you!")

-- ---------------------------------------------------------------------
-- POWER_WORD_SHIELD
-- ---------------------------------------------------------------------
add("POWER_WORD_SHIELD", "customemote", "chants a prayer, encasing {TARGET} in a glowing barrier of holy energy.")

-- ---------------------------------------------------------------------
-- INNER_FIRE
-- ---------------------------------------------------------------------
add("INNER_FIRE", "say", "Let the holy fire within burn bright!")
add("INNER_FIRE", "say", "Faith fuels my strength!")

-- ---------------------------------------------------------------------
-- INNER_FIRE
-- ---------------------------------------------------------------------
add("INNER_FIRE", "customemote", "glows with an Inner Fire.")

-- ---------------------------------------------------------------------
-- DISPEL_MAGIC
-- ---------------------------------------------------------------------
add("DISPEL_MAGIC", "say", "Begone, foul sorcery!")
add("DISPEL_MAGIC", "say", "The Light cleanses all corruption!")

-- ---------------------------------------------------------------------
-- DISPEL_MAGIC
-- ---------------------------------------------------------------------
add("DISPEL_MAGIC", "customemote", "waves a hand, unraveling the dark magic surrounding {TARGET}.")

-- ---------------------------------------------------------------------
-- INNER_FOCUS
-- ---------------------------------------------------------------------
add("INNER_FOCUS", "say", "Clarity of mind, focus of soul!")
add("INNER_FOCUS", "say", "Let my will be unshaken!")

-- ---------------------------------------------------------------------
-- INNER_FOCUS
-- ---------------------------------------------------------------------
add("INNER_FOCUS", "customemote", "closes {PP} eyes briefly, drawing upon divine concentration.")

-- ---------------------------------------------------------------------
-- SHACKLE_UNDEAD
-- ---------------------------------------------------------------------
add("SHACKLE_UNDEAD", "say", "The Light binds your wretched soul!")
add("SHACKLE_UNDEAD", "say", "Return to the grave where you belong!")

-- ---------------------------------------------------------------------
-- SHACKLE_UNDEAD
-- ---------------------------------------------------------------------
add("SHACKLE_UNDEAD", "customemote", "chants a sacred incantation, restraining {TARGET} with holy power.")

-- ---------------------------------------------------------------------
-- MANA_BURN
-- ---------------------------------------------------------------------
add("MANA_BURN", "say", "Your power dwindles before me!")
add("MANA_BURN", "say", "I strip away your arcane might!")

-- ---------------------------------------------------------------------
-- MANA_BURN
-- ---------------------------------------------------------------------
add("MANA_BURN", "customemote", "reaches out, siphoning mana from {TARGET} with a sinister glow.")

-- ---------------------------------------------------------------------
-- DIVINE_SPIRIT
-- ---------------------------------------------------------------------
add("DIVINE_SPIRIT", "say", "May divine spirit guide your path!")
add("DIVINE_SPIRIT", "say", "Let the Light fill your soul!")

-- ---------------------------------------------------------------------
-- DIVINE_SPIRIT
-- ---------------------------------------------------------------------
add("DIVINE_SPIRIT", "customemote", "raises {PP} hands, calling forth divine blessings upon {TARGET}.")

-- ---------------------------------------------------------------------
-- POWER_INFUSION
-- ---------------------------------------------------------------------
add("POWER_INFUSION", "say", "Feel the surge of divine might!")
add("POWER_INFUSION", "say", "Let the Light fuel your power!")

-- ---------------------------------------------------------------------
-- POWER_INFUSION
-- ---------------------------------------------------------------------
add("POWER_INFUSION", "customemote", "places a radiant hand on {TARGET}, infusing them with divine energy.")

-- ---------------------------------------------------------------------
-- LEVITATE
-- ---------------------------------------------------------------------
add("LEVITATE", "say", "Rise above, freed from earthly bonds!")
add("LEVITATE", "say", "Weightless as the heavens themselves!")

-- ---------------------------------------------------------------------
-- LEVITATE
-- ---------------------------------------------------------------------
add("LEVITATE", "customemote", "gestures gently, causing {TARGET} to lift off the ground with divine grace.")

-- ---------------------------------------------------------------------
-- PRAYER_OF_FORTITUDE
-- ---------------------------------------------------------------------
add("PRAYER_OF_FORTITUDE", "say", "Together, we stand unyielding!")
add("PRAYER_OF_FORTITUDE", "say", "May the Light grant us strength!")

-- ---------------------------------------------------------------------
-- PRAYER_OF_FORTITUDE
-- ---------------------------------------------------------------------
add("PRAYER_OF_FORTITUDE", "customemote", "chants a powerful prayer, fortifying the spirits of all nearby allies.")

-- ---------------------------------------------------------------------
-- LESSER_HEAL
-- ---------------------------------------------------------------------
add("LESSER_HEAL", "say", "The Light’s touch mends your wounds.")
add("LESSER_HEAL", "say", "A gentle blessing of healing upon you.")

-- ---------------------------------------------------------------------
-- LESSER_HEAL
-- ---------------------------------------------------------------------
add("LESSER_HEAL", "customemote", "channels a soft glow of divine energy into {TARGET}.")

-- ---------------------------------------------------------------------
-- RENEW
-- ---------------------------------------------------------------------
add("RENEW", "say", "May the Light’s blessing restore you over time.")
add("RENEW", "say", "Healing is a journey, not a moment.")

-- ---------------------------------------------------------------------
-- RENEW
-- ---------------------------------------------------------------------
add("RENEW", "customemote", "extends a hand, weaving an aura of slow, steady healing around {TARGET}.")

-- ---------------------------------------------------------------------
-- HEAL
-- ---------------------------------------------------------------------
add("HEAL", "say", "Let the Light soothe your pain.")
add("HEAL", "say", "Wounds fade before divine mercy.")

-- ---------------------------------------------------------------------
-- HEAL
-- ---------------------------------------------------------------------
add("HEAL", "customemote", "chants a quiet prayer, guiding sacred energy into {TARGET}.")

-- ---------------------------------------------------------------------
-- FLASH_HEAL
-- ---------------------------------------------------------------------
add("FLASH_HEAL", "say", "A burst of Light restores you!")
add("FLASH_HEAL", "say", "Let faith be your strength!")

-- ---------------------------------------------------------------------
-- FLASH_HEAL
-- ---------------------------------------------------------------------
add("FLASH_HEAL", "customemote", "swiftly channels divine energy into {TARGET}, mending their wounds instantly.")

-- ---------------------------------------------------------------------
-- PRAYER_OF_HEALING
-- ---------------------------------------------------------------------
add("PRAYER_OF_HEALING", "say", "May the Light embrace all who need it!")
add("PRAYER_OF_HEALING", "say", "A prayer for all, healing in unity!")

-- ---------------------------------------------------------------------
-- PRAYER_OF_HEALING
-- ---------------------------------------------------------------------
add("PRAYER_OF_HEALING", "customemote", "raises {PP} hands, sending waves of healing energy to multiple allies.")

-- ---------------------------------------------------------------------
-- GREATER_HEAL
-- ---------------------------------------------------------------------
add("GREATER_HEAL", "say", "The Light’s full grace restores you.")
add("GREATER_HEAL", "say", "Let the divine power renew your strength.")

-- ---------------------------------------------------------------------
-- GREATER_HEAL
-- ---------------------------------------------------------------------
add("GREATER_HEAL", "customemote", "focuses intensely, channeling a deep, radiant healing into {TARGET}.")

-- ---------------------------------------------------------------------
-- CURE_DISEASE
-- ---------------------------------------------------------------------
add("CURE_DISEASE", "say", "The Light cleanses all impurities.")
add("CURE_DISEASE", "say", "Be purified, and walk in health once more.")

-- ---------------------------------------------------------------------
-- CURE_DISEASE
-- ---------------------------------------------------------------------
add("CURE_DISEASE", "customemote", "extends a hand, dissolving sickness from {TARGET}’s body.")

-- ---------------------------------------------------------------------
-- ABOLISH_DISEASE
-- ---------------------------------------------------------------------
add("ABOLISH_DISEASE", "say", "No sickness shall take hold under my watch!")
add("ABOLISH_DISEASE", "say", "May the Light purge all ailments from you!")

-- ---------------------------------------------------------------------
-- ABOLISH_DISEASE
-- ---------------------------------------------------------------------
add("ABOLISH_DISEASE", "customemote", "calls upon a wave of divine energy, erasing all traces of illness.")

-- ---------------------------------------------------------------------
-- SMITE
-- ---------------------------------------------------------------------
add("SMITE", "say", "The Light judges you!")
add("SMITE", "say", "Feel the wrath of divine justice!")

-- ---------------------------------------------------------------------
-- SMITE
-- ---------------------------------------------------------------------
add("SMITE", "customemote", "extends a hand, channeling holy power into a blast against {TARGET}.")

-- ---------------------------------------------------------------------
-- RESURRECTION
-- ---------------------------------------------------------------------
add("RESURRECTION", "say", "{TARGET}, your service in this world is not yet finished, awaken!")
add("RESURRECTION", "say", "Rise once more, the Light has not abandoned you!")

-- ---------------------------------------------------------------------
-- RESURRECTION
-- ---------------------------------------------------------------------
add("RESURRECTION", "customemote", "kneels beside {TARGET}, whispering prayers of resurrection.")

-- ---------------------------------------------------------------------
-- HOLY_NOVA
-- ---------------------------------------------------------------------
add("HOLY_NOVA", "say", "The Light explodes forth, banishing darkness!")
add("HOLY_NOVA", "say", "A surge of divine power radiates from me!")

-- ---------------------------------------------------------------------
-- HOLY_NOVA
-- ---------------------------------------------------------------------
add("HOLY_NOVA", "customemote", "unleashes a burst of holy energy, healing allies and striking down foes.")

-- ---------------------------------------------------------------------
-- HOLY_FIRE
-- ---------------------------------------------------------------------
add("HOLY_FIRE", "say", "Feel the cleansing flame of righteousness!")
add("HOLY_FIRE", "say", "Burn in the purifying fire of the divine!")

-- ---------------------------------------------------------------------
-- HOLY_FIRE
-- ---------------------------------------------------------------------
add("HOLY_FIRE", "customemote", "calls forth a blazing holy flame, engulfing {TARGET} in divine fire.")

-- ---------------------------------------------------------------------
-- SPIRIT_OF_REDEMPTION
-- ---------------------------------------------------------------------
add("SPIRIT_OF_REDEMPTION", "say", "Even in death, the Light shall endure.")
add("SPIRIT_OF_REDEMPTION", "say", "My spirit lingers to heal those in need.")

-- ---------------------------------------------------------------------
-- SPIRIT_OF_REDEMPTION
-- ---------------------------------------------------------------------
add("SPIRIT_OF_REDEMPTION", "customemote", "ascends into a spectral form, continuing to heal allies despite {PP} demise.")

-- ---------------------------------------------------------------------
-- LIGHTWELL
-- ---------------------------------------------------------------------
add("LIGHTWELL", "say", "Drink deep from the well of Light!")
add("LIGHTWELL", "say", "Healing flows freely to those in need!")

-- ---------------------------------------------------------------------
-- LIGHTWELL
-- ---------------------------------------------------------------------
add("LIGHTWELL", "customemote", "summons a radiant well of holy energy, offering healing to those nearby.")

-- ---------------------------------------------------------------------
-- SHADOW_WORD_PAIN
-- ---------------------------------------------------------------------
add("SHADOW_WORD_PAIN", "say", "The shadows creep into your soul!")
add("SHADOW_WORD_PAIN", "say", "Your agony feeds the darkness!")

-- ---------------------------------------------------------------------
-- SHADOW_WORD_PAIN
-- ---------------------------------------------------------------------
add("SHADOW_WORD_PAIN", "customemote", "chants in a dark whisper, afflicting {TARGET} with searing pain.")

-- ---------------------------------------------------------------------
-- FADE
-- ---------------------------------------------------------------------
add("FADE", "say", "I become but a whisper in the void...")
add("FADE", "say", "The shadows conceal me from harm!")

-- ---------------------------------------------------------------------
-- FADE
-- ---------------------------------------------------------------------
add("FADE", "customemote", "blurs momentarily, fading from attention.")

-- ---------------------------------------------------------------------
-- MIND_BLAST
-- ---------------------------------------------------------------------
add("MIND_BLAST", "say", "Your thoughts shatter beneath my will!")
add("MIND_BLAST", "say", "The void erupts within your mind!")

-- ---------------------------------------------------------------------
-- MIND_BLAST
-- ---------------------------------------------------------------------
add("MIND_BLAST", "customemote", "channels dark magic through glowing hands.")

-- ---------------------------------------------------------------------
-- PSYCHIC_SCREAM
-- ---------------------------------------------------------------------
add("PSYCHIC_SCREAM", "say", "Get away from me!")
add("PSYCHIC_SCREAM", "say", "Fear grips your soul!")

-- ---------------------------------------------------------------------
-- PSYCHIC_SCREAM
-- ---------------------------------------------------------------------
add("PSYCHIC_SCREAM", "customemote", "lets out a blood-curdling scream, sending foes fleeing in terror.")

-- ---------------------------------------------------------------------
-- MIND_FLAY
-- ---------------------------------------------------------------------
add("MIND_FLAY", "say", "Your mind is mine to unravel!")
add("MIND_FLAY", "say", "I pull at the threads of your sanity!")

-- ---------------------------------------------------------------------
-- MIND_FLAY
-- ---------------------------------------------------------------------
add("MIND_FLAY", "customemote", "extends a hand, tendrils of shadow latching onto {TARGET}’s mind.")

-- ---------------------------------------------------------------------
-- MIND_SOOTHE
-- ---------------------------------------------------------------------
add("MIND_SOOTHE", "say", "Calm your thoughts, be at peace...")
add("MIND_SOOTHE", "say", "The void whispers serenity.")

-- ---------------------------------------------------------------------
-- MIND_SOOTHE
-- ---------------------------------------------------------------------
add("MIND_SOOTHE", "customemote", "places a gentle hand on {TARGET}, soothing their mind with shadowy whispers.")

-- ---------------------------------------------------------------------
-- MIND_VISION
-- ---------------------------------------------------------------------
add("MIND_VISION", "say", "Allow me to see through your eyes, {TARGET}.")
add("MIND_VISION", "say", "What secrets lie within your gaze, {TARGET}?")

-- ---------------------------------------------------------------------
-- MIND_VISION
-- ---------------------------------------------------------------------
add("MIND_VISION", "customemote", "focuses intently, gazing through {TARGET}’s perspective.")

-- ---------------------------------------------------------------------
-- MIND_CONTROL
-- ---------------------------------------------------------------------
add("MIND_CONTROL", "say", "Do not resist {TARGET}, it is futile!")
add("MIND_CONTROL", "say", "Your will bends to mine, {TARGET}!")

-- ---------------------------------------------------------------------
-- MIND_CONTROL
-- ---------------------------------------------------------------------
add("MIND_CONTROL", "customemote", "grins wickedly as {TARGET} falls under {PP} influence.")

-- ---------------------------------------------------------------------
-- SHADOW_PROTECTION
-- ---------------------------------------------------------------------
add("SHADOW_PROTECTION", "say", "The darkness shall not claim you.")
add("SHADOW_PROTECTION", "say", "Shadow bends to my command, shielding you.")

-- ---------------------------------------------------------------------
-- SHADOW_PROTECTION
-- ---------------------------------------------------------------------
add("SHADOW_PROTECTION", "customemote", "chants softly, shrouding {TARGET} in protective void energy.")

-- ---------------------------------------------------------------------
-- SILENCE
-- ---------------------------------------------------------------------
add("SILENCE", "say", "Be silent, and know despair!")
add("SILENCE", "say", "The void consumes your voice!")

-- ---------------------------------------------------------------------
-- SILENCE
-- ---------------------------------------------------------------------
add("SILENCE", "customemote", "gestures sharply, stealing {TARGET}’s ability to speak or cast magic.")

-- ---------------------------------------------------------------------
-- VAMPIRIC_EMBRACE
-- ---------------------------------------------------------------------
add("VAMPIRIC_EMBRACE", "say", "Your essence shall sustain me!")
add("VAMPIRIC_EMBRACE", "say", "Through your suffering, I am renewed!")

-- ---------------------------------------------------------------------
-- VAMPIRIC_EMBRACE
-- ---------------------------------------------------------------------
add("VAMPIRIC_EMBRACE", "customemote", "dark energy pulses from {PP}, drawing vitality from {TARGET}.")

-- ---------------------------------------------------------------------
-- SHADOWFORM
-- ---------------------------------------------------------------------
add("SHADOWFORM", "say", "I become one with the void!")
add("SHADOWFORM", "say", "Darkness claims me as its own!")

-- ---------------------------------------------------------------------
-- SHADOWFORM
-- ---------------------------------------------------------------------
add("SHADOWFORM", "customemote", "becomes engulfed entirely in pure shadow.")
