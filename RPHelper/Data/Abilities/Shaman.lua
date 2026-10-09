-- RPHelper Forever - Shaman ability content
-- Corpus migration from the RPhelper_twow Shaman catalogue and original RoleplayingHelper lineage.
-- The legacy Shaman source carried no named contributor attribution.

local A = RPHelper.Ability.SHAMAN
local C = RPHelper.Class.SHAMAN
local function add(ability, entryType, text)
    A[ability] = A[ability] or ability
    RPHelper.RegisterAbility(C, A[ability], { type = entryType, text = text })
end

-- ---------------------------------------------------------------------
-- EARTH_SHOCK
-- ---------------------------------------------------------------------
add("EARTH_SHOCK", "say", "Feel the ground tremble beneath you!")
add("EARTH_SHOCK", "say", "The Earth Mother strikes!")
add("EARTH_SHOCK", "say", "Fall before the strength of the Earth!")
add("EARTH_SHOCK", "say", "The land itself rises against you!")
add("EARTH_SHOCK", "say", "Tremble, as the stones shatter your will!")

-- ---------------------------------------------------------------------
-- EARTH_SHOCK
-- ---------------------------------------------------------------------
add("EARTH_SHOCK", "customemote", "stomps the ground, sending a shockwave towards {TARGET}.")
add("EARTH_SHOCK", "customemote", "raises a hand glowing with the brown and gold hues of the earth, sending a concussive wave forward.")
add("EARTH_SHOCK", "customemote", "slams a fist into the ground, sending jagged rocks towards {TARGET}.")

-- ---------------------------------------------------------------------
-- FLAME_SHOCK
-- ---------------------------------------------------------------------
add("FLAME_SHOCK", "say", "Feel the fury of the eternal flame!")
add("FLAME_SHOCK", "say", "Cleansed by Fire!")

-- ---------------------------------------------------------------------
-- FLAME_SHOCK
-- ---------------------------------------------------------------------
add("FLAME_SHOCK", "customemote", "gestures sharply, a spark of fire igniting upon their foe.")
add("FLAME_SHOCK", "customemote", "thrusts their palm forward, a burst of fire sparking upon their enemy.")
add("FLAME_SHOCK", "customemote", "thrusts their palm forward as they summon a fiery surge.")

-- ---------------------------------------------------------------------
-- FROST_SHOCK
-- ---------------------------------------------------------------------
add("FROST_SHOCK", "say", "The chill of the ancestors claims you!")
add("FROST_SHOCK", "say", "Your movements are as frozen as your fate!")
add("FROST_SHOCK", "say", "The cold shall consume you!")

-- ---------------------------------------------------------------------
-- FROST_SHOCK
-- ---------------------------------------------------------------------
add("FROST_SHOCK", "customemote", "exhales sharply as frost gathers in their palm, releasing it with a shattering burst.")
add("FROST_SHOCK", "customemote", "takes a deep breath as a thin layer of ice crackles under their feet while they channel a frosty shock.")

-- ---------------------------------------------------------------------
-- EARTHBIND_TOTEM
-- ---------------------------------------------------------------------
add("EARTHBIND_TOTEM", "say", "The earth itself slows your steps.")
add("EARTHBIND_TOTEM", "say", "The ground resists your movement!")

-- ---------------------------------------------------------------------
-- EARTHBIND_TOTEM
-- ---------------------------------------------------------------------
add("EARTHBIND_TOTEM", "customemote", "places a totem, causing the ground to become unstable and slow movement.")

-- ---------------------------------------------------------------------
-- STONECLAW_TOTEM
-- ---------------------------------------------------------------------
add("STONECLAW_TOTEM", "say", "The earth defends its own!")
add("STONECLAW_TOTEM", "say", "Stone rises to guard me!")

-- ---------------------------------------------------------------------
-- STONECLAW_TOTEM
-- ---------------------------------------------------------------------
add("STONECLAW_TOTEM", "customemote", "places a totem, its aura hardening the ground as it taunts nearby foes.")

-- ---------------------------------------------------------------------
-- SEARING_TOTEM
-- ---------------------------------------------------------------------
add("SEARING_TOTEM", "say", "The flames shall find you!")
add("SEARING_TOTEM", "say", "The fire never rests!")

-- ---------------------------------------------------------------------
-- SEARING_TOTEM
-- ---------------------------------------------------------------------
add("SEARING_TOTEM", "customemote", "places a totem that launches bursts of fire at nearby foes.")

-- ---------------------------------------------------------------------
-- MAGMA_TOTEM
-- ---------------------------------------------------------------------
add("MAGMA_TOTEM", "say", "The land erupts with fury!")
add("MAGMA_TOTEM", "say", "Lava flows where I command!")

-- ---------------------------------------------------------------------
-- MAGMA_TOTEM
-- ---------------------------------------------------------------------
add("MAGMA_TOTEM", "customemote", "places a totem that radiates waves of molten rock, scorching all nearby.")

-- ---------------------------------------------------------------------
-- FIRE_NOVA_TOTEM
-- ---------------------------------------------------------------------
add("FIRE_NOVA_TOTEM", "say", "The land erupts in flame!")

-- ---------------------------------------------------------------------
-- FIRE_NOVA_TOTEM
-- ---------------------------------------------------------------------
add("FIRE_NOVA_TOTEM", "customemote", "plants a totem, channeling fire energy into an explosive burst.")

-- ---------------------------------------------------------------------
-- LIGHTNING_BOLT
-- ---------------------------------------------------------------------
add("LIGHTNING_BOLT", "say", "The storm’s judgment is swift!")
add("LIGHTNING_BOLT", "say", "Lightning cleaves the darkness!")
add("LIGHTNING_BOLT", "say", "Feel the storm’s wrath!")
add("LIGHTNING_BOLT", "say", "The heavens strike at my command!")
add("LIGHTNING_BOLT", "say", "The storm answers only to me!")

-- ---------------------------------------------------------------------
-- LIGHTNING_BOLT
-- ---------------------------------------------------------------------
add("LIGHTNING_BOLT", "customemote", "raises a crackling hand, hurling a bolt of lightning at {TARGET}.")

-- ---------------------------------------------------------------------
-- PURGE
-- ---------------------------------------------------------------------
add("PURGE", "say", "The spirits strip you of your corruption!")
add("PURGE", "say", "No foul magic can stand against me!")
add("PURGE", "say", "The elements cleanse your taint!")

-- ---------------------------------------------------------------------
-- PURGE
-- ---------------------------------------------------------------------
add("PURGE", "customemote", "swipes their hand through the air, sending a burst of spiritual energy to dispel the magical corruption.")
add("PURGE", "customemote", "chants a deep incantation, unraveling the dark magic surrounding {TARGET}.")

-- ---------------------------------------------------------------------
-- CHAIN_LIGHTNING
-- ---------------------------------------------------------------------
add("CHAIN_LIGHTNING", "say", "None shall escape the storm’s fury!")
add("CHAIN_LIGHTNING", "say", "The storm leaps from one to another!")
add("CHAIN_LIGHTNING", "say", "The storm’s fury knows no bounds!")
add("CHAIN_LIGHTNING", "say", "Lightning dances at my command!")
add("CHAIN_LIGHTNING", "say", "Thunder’s wrath spreads among you all!")

-- ---------------------------------------------------------------------
-- CHAIN_LIGHTNING
-- ---------------------------------------------------------------------
add("CHAIN_LIGHTNING", "customemote", "calls forth a bolt of lightning that arcs between enemies, spreading devastation.")

-- ---------------------------------------------------------------------
-- ROCKBITER_WEAPON
-- ---------------------------------------------------------------------
add("ROCKBITER_WEAPON", "say", "The strength of the mountains flows through me!")
add("ROCKBITER_WEAPON", "say", "My weapon becomes unbreakable, like the earth itself!")

-- ---------------------------------------------------------------------
-- ROCKBITER_WEAPON
-- ---------------------------------------------------------------------
add("ROCKBITER_WEAPON", "customemote", "grips {PP} weapon tightly as its surface hardens with the essence of the earth.")

-- ---------------------------------------------------------------------
-- FLAMETONGUE_WEAPON
-- ---------------------------------------------------------------------
add("FLAMETONGUE_WEAPON", "say", "Fire dances upon my weapon!")
add("FLAMETONGUE_WEAPON", "say", "Let the flames consume my foes!")

-- ---------------------------------------------------------------------
-- FLAMETONGUE_WEAPON
-- ---------------------------------------------------------------------
add("FLAMETONGUE_WEAPON", "customemote", "runs a fiery hand along {PP} weapon, causing it to glow with scorching embers.")

-- ---------------------------------------------------------------------
-- FROSTBRAND_WEAPON
-- ---------------------------------------------------------------------
add("FROSTBRAND_WEAPON", "say", "Cold bites deep, and so shall I!")
add("FROSTBRAND_WEAPON", "say", "Ice binds my enemies in place!")

-- ---------------------------------------------------------------------
-- FROSTBRAND_WEAPON
-- ---------------------------------------------------------------------
add("FROSTBRAND_WEAPON", "customemote", "channels the frost, coating {PP} weapon in a layer of jagged ice.")

-- ---------------------------------------------------------------------
-- WINDFURY_WEAPON
-- ---------------------------------------------------------------------
add("WINDFURY_WEAPON", "say", "Winds of fury, guide my strikes!")
add("WINDFURY_WEAPON", "say", "Storm and gale, lend me your strength!")
add("WINDFURY_WEAPON", "say", "The wind sings through my weapon!")
add("WINDFURY_WEAPON", "say", "Let my blows be as swift as the storm!")
add("WINDFURY_WEAPON", "say", "The tempests howl in battle with me!")

-- ---------------------------------------------------------------------
-- WINDFURY_WEAPON
-- ---------------------------------------------------------------------
add("WINDFURY_WEAPON", "customemote", "runs their hand along their weapon, a faint whirlwind forming around it as sparks of electricity dance in the air.")
add("WINDFURY_WEAPON", "customemote", "holds their weapon aloft as it gleams with storm energy and crackling thunder.")
add("WINDFURY_WEAPON", "customemote", "holds their weapon steady as a swirling storm imbues it with the ferocity of the wind.")
add("WINDFURY_WEAPON", "customemote", "chants a brief prayer as their weapon is infused with the raw power of the four winds.")

-- ---------------------------------------------------------------------
-- STONESKIN_TOTEM
-- ---------------------------------------------------------------------
add("STONESKIN_TOTEM", "say", "Stone shall shield us!")
add("STONESKIN_TOTEM", "say", "The earth hardens against our foes!")

-- ---------------------------------------------------------------------
-- STONESKIN_TOTEM
-- ---------------------------------------------------------------------
add("STONESKIN_TOTEM", "customemote", "plants a totem, its energy reinforcing the resilience of nearby allies.")

-- ---------------------------------------------------------------------
-- STRENGTH_OF_EARTH_TOTEM
-- ---------------------------------------------------------------------
add("STRENGTH_OF_EARTH_TOTEM", "say", "The earth grants us its might!")
add("STRENGTH_OF_EARTH_TOTEM", "say", "The land lends its power to our arms!")
add("STRENGTH_OF_EARTH_TOTEM", "say", "Strength flows from the deep roots of the world!")

-- ---------------------------------------------------------------------
-- STRENGTH_OF_EARTH_TOTEM
-- ---------------------------------------------------------------------
add("STRENGTH_OF_EARTH_TOTEM", "customemote", "places a totem that pulses with the power of the earth, strengthening allies.")

-- ---------------------------------------------------------------------
-- FROST_RESISTANCE_TOTEM
-- ---------------------------------------------------------------------
add("FROST_RESISTANCE_TOTEM", "say", "The cold shall not touch us!")
add("FROST_RESISTANCE_TOTEM", "say", "Frost bends before our will!")

-- ---------------------------------------------------------------------
-- FROST_RESISTANCE_TOTEM
-- ---------------------------------------------------------------------
add("FROST_RESISTANCE_TOTEM", "customemote", "places a totem that radiates warmth, shielding allies from the cold.")

-- ---------------------------------------------------------------------
-- FIRE_RESISTANCE_TOTEM
-- ---------------------------------------------------------------------
add("FIRE_RESISTANCE_TOTEM", "say", "The flames will not consume us!")
add("FIRE_RESISTANCE_TOTEM", "say", "Fire shall break upon our defenses!")

-- ---------------------------------------------------------------------
-- FIRE_RESISTANCE_TOTEM
-- ---------------------------------------------------------------------
add("FIRE_RESISTANCE_TOTEM", "customemote", "plants a totem, its aura dampening the intensity of fire-based attacks.")

-- ---------------------------------------------------------------------
-- FLAMETONGUE_TOTEM
-- ---------------------------------------------------------------------
add("FLAMETONGUE_TOTEM", "say", "Let fire dance upon our weapons!")
add("FLAMETONGUE_TOTEM", "say", "The fury of flame fuels our strikes!")
add("FLAMETONGUE_TOTEM", "say", "May our blades burn as hot as the sun!")

-- ---------------------------------------------------------------------
-- FLAMETONGUE_TOTEM
-- ---------------------------------------------------------------------
add("FLAMETONGUE_TOTEM", "customemote", "places a totem that glows red-hot, empowering nearby weapons with fire.")

-- ---------------------------------------------------------------------
-- GROUNDING_TOTEM
-- ---------------------------------------------------------------------
add("GROUNDING_TOTEM", "say", "The spirits shield us from harm!")
add("GROUNDING_TOTEM", "say", "Magic bends and breaks before our will!")
add("GROUNDING_TOTEM", "say", "Let the land absorb their spells!")

-- ---------------------------------------------------------------------
-- GROUNDING_TOTEM
-- ---------------------------------------------------------------------
add("GROUNDING_TOTEM", "customemote", "plants a totem, drawing magical energy into itself, disrupting enemy spells.")

-- ---------------------------------------------------------------------
-- NATURE_RESISTANCE_TOTEM
-- ---------------------------------------------------------------------
add("NATURE_RESISTANCE_TOTEM", "say", "The wind carries away nature’s harm!")
add("NATURE_RESISTANCE_TOTEM", "say", "The elements shield us from poison and decay!")

-- ---------------------------------------------------------------------
-- NATURE_RESISTANCE_TOTEM
-- ---------------------------------------------------------------------
add("NATURE_RESISTANCE_TOTEM", "customemote", "places a totem that hums with natural energy, shielding allies from harm.")

-- ---------------------------------------------------------------------
-- WINDFURY_TOTEM
-- ---------------------------------------------------------------------
add("WINDFURY_TOTEM", "say", "The winds will guide your strikes!")
add("WINDFURY_TOTEM", "say", "The storm is at our backs!")
add("WINDFURY_TOTEM", "say", "Swift as the tempest, strong as the gale!")

-- ---------------------------------------------------------------------
-- WINDFURY_TOTEM
-- ---------------------------------------------------------------------
add("WINDFURY_TOTEM", "customemote", "plants a totem that crackles with energy, empowering allies with the power of the wind.")

-- ---------------------------------------------------------------------
-- SENTRY_TOTEM
-- ---------------------------------------------------------------------
add("SENTRY_TOTEM", "say", "The spirits watch over us!")
add("SENTRY_TOTEM", "say", "No shadow escapes our sight!")

-- ---------------------------------------------------------------------
-- SENTRY_TOTEM
-- ---------------------------------------------------------------------
add("SENTRY_TOTEM", "customemote", "places a totem that enhances vision, watching over the battlefield.")

-- ---------------------------------------------------------------------
-- WINDWALL_TOTEM
-- ---------------------------------------------------------------------
add("WINDWALL_TOTEM", "say", "Winds, shield us from harm!")
add("WINDWALL_TOTEM", "say", "Arrows will bend before the storm!")

-- ---------------------------------------------------------------------
-- WINDWALL_TOTEM
-- ---------------------------------------------------------------------
add("WINDWALL_TOTEM", "customemote", "summons a barrier of wind, deflecting incoming projectiles.")

-- ---------------------------------------------------------------------
-- GRACE_OF_AIR_TOTEM
-- ---------------------------------------------------------------------
add("GRACE_OF_AIR_TOTEM", "say", "The air grants us speed and balance!")
add("GRACE_OF_AIR_TOTEM", "say", "The wind carries our steps!")
add("GRACE_OF_AIR_TOTEM", "say", "Move with the grace and power of the storm!")

-- ---------------------------------------------------------------------
-- GRACE_OF_AIR_TOTEM
-- ---------------------------------------------------------------------
add("GRACE_OF_AIR_TOTEM", "customemote", "places a totem that enhances agility and precision.")

-- ---------------------------------------------------------------------
-- LIGHTNING_SHIELD
-- ---------------------------------------------------------------------
add("LIGHTNING_SHIELD", "say", "The storm guards me!")
add("LIGHTNING_SHIELD", "say", "Let those who strike me taste the storm’s fury!")
add("LIGHTNING_SHIELD", "say", "The spirits surround me in thunder and lightning!")
add("LIGHTNING_SHIELD", "say", "Lightning crackles at my call!")
add("LIGHTNING_SHIELD", "say", "Touch me, and be burned by the storm!")

-- ---------------------------------------------------------------------
-- LIGHTNING_SHIELD
-- ---------------------------------------------------------------------
add("LIGHTNING_SHIELD", "customemote", "surrounds themselves with crackling arcs of lightning, ready to strike back at attackers.")

-- ---------------------------------------------------------------------
-- GHOST_WOLF
-- ---------------------------------------------------------------------
add("GHOST_WOLF", "say", "The spirit of the wolf carries me!")
add("GHOST_WOLF", "say", "I run with the ancestors!")
add("GHOST_WOLF", "say", "The wild grants me its speed!")

-- ---------------------------------------------------------------------
-- GHOST_WOLF
-- ---------------------------------------------------------------------
add("GHOST_WOLF", "customemote", "shimmers briefly as their form shifts into that of a spectral wolf.")

-- ---------------------------------------------------------------------
-- STORMSTRIKE
-- ---------------------------------------------------------------------
add("STORMSTRIKE", "say", "The storm lends me its strength!")
add("STORMSTRIKE", "say", "By the thunder’s might, fall before me!")
add("STORMSTRIKE", "say", "Feel the storm’s vengeance!")
add("STORMSTRIKE", "say", "Spirits of Storm and Thunder strike through me!")
add("STORMSTRIKE", "say", "Lightning flows through my weapon, striking with fury!")
add("STORMSTRIKE", "say", "Thunder cracks as my blow lands!")

-- ---------------------------------------------------------------------
-- STORMSTRIKE
-- ---------------------------------------------------------------------
add("STORMSTRIKE", "customemote", "surges forward, their weapon crackling with elemental energy.")
add("STORMSTRIKE", "customemote", "strikes with ferocious speed as their weapon crackles with raw lightning.")
add("STORMSTRIKE", "customemote", "surges forward, their weapon a blur of motion and electric fury.")
add("STORMSTRIKE", "customemote", "channels the power of the storm, unleashing a devastating strike.")

-- ---------------------------------------------------------------------
-- HEALING_WAVE
-- ---------------------------------------------------------------------
add("HEALING_WAVE", "say", "The ancestors' grace restores.")
add("HEALING_WAVE", "say", "The spirits guide my hands to heal.")
add("HEALING_WAVE", "say", "Let the rivers of life heal.")
add("HEALING_WAVE", "say", "May the tides of the elements cleanse your wounds.")

-- ---------------------------------------------------------------------
-- HEALING_WAVE
-- ---------------------------------------------------------------------
add("HEALING_WAVE", "customemote", "chants softly, hands glowing with a soothing energy as they mend {TARGET}’s wounds.")

-- ---------------------------------------------------------------------
-- LESSER_HEALING_WAVE
-- ---------------------------------------------------------------------
add("LESSER_HEALING_WAVE", "say", "Spirits, mend this wound swiftly!")
add("LESSER_HEALING_WAVE", "say", "The winds carry my healing to you!")

-- ---------------------------------------------------------------------
-- LESSER_HEALING_WAVE
-- ---------------------------------------------------------------------
add("LESSER_HEALING_WAVE", "customemote", "raises glowing hands and releases a quick pulse of healing energy.")

-- ---------------------------------------------------------------------
-- CURE_POISON
-- ---------------------------------------------------------------------
add("CURE_POISON", "say", "Spirits of Water cleanse body and soul.")
add("CURE_POISON", "say", "The poison fades; the spirits endure.")
add("CURE_POISON", "say", "No poison shall hold sway under my watch.")
add("CURE_POISON", "say", "Nature’s purity washes over you!")

-- ---------------------------------------------------------------------
-- CURE_POISON
-- ---------------------------------------------------------------------
add("CURE_POISON", "customemote", "sends a ripple of cleansing energy, driving out the foul influence of the poison.")

-- ---------------------------------------------------------------------
-- CURE_DISEASE
-- ---------------------------------------------------------------------
add("CURE_DISEASE", "say", "Elements of Water, cleanse {TARGET}'s body and soul.")
add("CURE_DISEASE", "say", "The disease fades; the spirits endure.")
add("CURE_DISEASE", "say", "No disease shall hold sway under my watch.")
add("CURE_DISEASE", "say", "Be cleansed by the spirits’ blessing!")

-- ---------------------------------------------------------------------
-- CURE_DISEASE
-- ---------------------------------------------------------------------
add("CURE_DISEASE", "customemote", "sends a ripple of cleansing energy, driving out the foul influence of the disease.")

-- ---------------------------------------------------------------------
-- TREMOR_TOTEM
-- ---------------------------------------------------------------------
add("TREMOR_TOTEM", "say", "The earth shakes away fear!")
add("TREMOR_TOTEM", "say", "No nightmare shall bind us!")

-- ---------------------------------------------------------------------
-- TREMOR_TOTEM
-- ---------------------------------------------------------------------
add("TREMOR_TOTEM", "customemote", "places a totem that hums with deep vibrations, shaking off fear and enchantments.")

-- ---------------------------------------------------------------------
-- POISON_CLEANSING_TOTEM
-- ---------------------------------------------------------------------
add("POISON_CLEANSING_TOTEM", "say", "The elements purge all toxins!")
add("POISON_CLEANSING_TOTEM", "say", "No poison shall take root here!")

-- ---------------------------------------------------------------------
-- POISON_CLEANSING_TOTEM
-- ---------------------------------------------------------------------
add("POISON_CLEANSING_TOTEM", "customemote", "places a totem that radiates a cleansing aura, removing poisons from nearby allies.")

-- ---------------------------------------------------------------------
-- HEALING_STREAM_TOTEM
-- ---------------------------------------------------------------------
add("HEALING_STREAM_TOTEM", "say", "The river of life flows through us!")
add("HEALING_STREAM_TOTEM", "say", "May the waters soothe our wounds!")
add("HEALING_STREAM_TOTEM", "say", "Let the spirits’ gift restore us!")

-- ---------------------------------------------------------------------
-- HEALING_STREAM_TOTEM
-- ---------------------------------------------------------------------
add("HEALING_STREAM_TOTEM", "customemote", "places a totem that pulses with the gentle flow of healing waters.")

-- ---------------------------------------------------------------------
-- MANA_SPRING_TOTEM
-- ---------------------------------------------------------------------
add("MANA_SPRING_TOTEM", "say", "The wellspring of energy is ours!")
add("MANA_SPRING_TOTEM", "say", "May the tides of mana restore us!")

-- ---------------------------------------------------------------------
-- MANA_SPRING_TOTEM
-- ---------------------------------------------------------------------
add("MANA_SPRING_TOTEM", "customemote", "places a totem that glows with mystical energy, replenishing mana over time.")

-- ---------------------------------------------------------------------
-- DISEASE_CLEANSING_TOTEM
-- ---------------------------------------------------------------------
add("DISEASE_CLEANSING_TOTEM", "say", "The elements purge all sickness!")
add("DISEASE_CLEANSING_TOTEM", "say", "No illness shall linger here!")

-- ---------------------------------------------------------------------
-- DISEASE_CLEANSING_TOTEM
-- ---------------------------------------------------------------------
add("DISEASE_CLEANSING_TOTEM", "customemote", "places a totem that hums with cleansing power, dispelling diseases.")

-- ---------------------------------------------------------------------
-- MANA_TIDE_TOTEM
-- ---------------------------------------------------------------------
add("MANA_TIDE_TOTEM", "say", "The tides rise to restore us!")
add("MANA_TIDE_TOTEM", "say", "A flood of mana returns to our spirits!")

-- ---------------------------------------------------------------------
-- MANA_TIDE_TOTEM
-- ---------------------------------------------------------------------
add("MANA_TIDE_TOTEM", "customemote", "plants a totem that surges with powerful mana-restoring energy.")

-- ---------------------------------------------------------------------
-- ANCESTRAL_SPIRIT
-- ---------------------------------------------------------------------
add("ANCESTRAL_SPIRIT", "say", "Return, {TARGET}, guided by the spirits of old.")
add("ANCESTRAL_SPIRIT", "say", "The ancestors call you, {TARGET}, back to the living.")
add("ANCESTRAL_SPIRIT", "say", "Your journey is not yet complete; rise once more, {TARGET}!")
add("ANCESTRAL_SPIRIT", "say", "The spirits are not yet finished with you, {TARGET}!")
add("ANCESTRAL_SPIRIT", "say", "The time to meet your ancestors has not arrived. Return to us, {TARGET}!")

-- ---------------------------------------------------------------------
-- ANCESTRAL_SPIRIT
-- ---------------------------------------------------------------------
add("ANCESTRAL_SPIRIT", "customemote", "kneels beside the fallen {TARGET}, whispering to the spirits as a pale light surrounds them.")

-- ---------------------------------------------------------------------
-- NATURES_SWIFTNESS
-- ---------------------------------------------------------------------
add("NATURES_SWIFTNESS", "say", "The spirits grant me speed!")
add("NATURES_SWIFTNESS", "say", "The elements quicken my magic!")

-- ---------------------------------------------------------------------
-- NATURES_SWIFTNESS
-- ---------------------------------------------------------------------
add("NATURES_SWIFTNESS", "customemote", "calls upon the spirits to hasten {PP} next spell.")

-- ---------------------------------------------------------------------
-- REINCARNATION
-- ---------------------------------------------------------------------
add("REINCARNATION", "say", "I return, for my path is not yet done.")
add("REINCARNATION", "say", "The ancestors have sent me back once more.")
add("REINCARNATION", "say", "From the spirit world, I walk again.")

-- ---------------------------------------------------------------------
-- REINCARNATION
-- ---------------------------------------------------------------------
add("REINCARNATION", "customemote", "draws breath once more as the spirits guide {PP} return.")

-- ---------------------------------------------------------------------
-- CHAIN_HEAL
-- ---------------------------------------------------------------------
add("CHAIN_HEAL", "say", "Let healing flow between us!")
add("CHAIN_HEAL", "say", "One healed, many restored!")
add("CHAIN_HEAL", "say", "The waters of life connect us all!")

-- ---------------------------------------------------------------------
-- CHAIN_HEAL
-- ---------------------------------------------------------------------
add("CHAIN_HEAL", "customemote", "sends a surge of healing energy that leaps from ally to ally.")

-- ---------------------------------------------------------------------
-- SPIRIT_LINK
-- ---------------------------------------------------------------------
add("SPIRIT_LINK", "say", "Our spirits are bound; your pain is shared!")
add("SPIRIT_LINK", "say", "Through unity, we endure!")
add("SPIRIT_LINK", "say", "The spirits weave our fates together!")

-- ---------------------------------------------------------------------
-- SPIRIT_LINK
-- ---------------------------------------------------------------------
add("SPIRIT_LINK", "customemote", "chants a deep incantation, linking the spirits of nearby allies.")

-- ---------------------------------------------------------------------
-- LIGHTNING_STRIKE
-- ---------------------------------------------------------------------
add("LIGHTNING_STRIKE", "say", "Lightning and fury, unite with my strike!")
add("LIGHTNING_STRIKE", "say", "By the storm, Elements guide my weapon!")
add("LIGHTNING_STRIKE", "say", "Lightning cleaves the darkness!")
add("LIGHTNING_STRIKE", "say", "A storm’s wrath, focused in my hands!")
add("LIGHTNING_STRIKE", "say", "Let the skies answer my call!")

-- ---------------------------------------------------------------------
-- LIGHTNING_STRIKE
-- ---------------------------------------------------------------------
add("LIGHTNING_STRIKE", "customemote", "readies their crackling weapon as the wind gathers for a strike.")

-- ---------------------------------------------------------------------
-- WATER_SHIELD
-- ---------------------------------------------------------------------
add("WATER_SHIELD", "say", "The waters flow around me, granting life and renewal.")
add("WATER_SHIELD", "say", "The Earth Mother’s rivers protect and sustain me.")
add("WATER_SHIELD", "say", "Spirits of the stream, guide my path.")
add("WATER_SHIELD", "say", "The tides answer my call, restoring my essence.")

-- ---------------------------------------------------------------------
-- WATER_SHIELD
-- ---------------------------------------------------------------------
add("WATER_SHIELD", "customemote", "is encircled by a shimmering sphere of water and gracefully swirling droplets.")
add("WATER_SHIELD", "customemote", "gestures with a flowing motion as a soothing ripple of water forms a shield around them.")

-- ---------------------------------------------------------------------
-- EARTH_SHIELD
-- ---------------------------------------------------------------------
add("EARTH_SHIELD", "say", "The earth itself rises to protect me!")
add("EARTH_SHIELD", "say", "The mountains lend me their strength.")
add("EARTH_SHIELD", "say", "The Earth Mother steadies my spirit.")
add("EARTH_SHIELD", "say", "Stone and soil guard my path!")

-- ---------------------------------------------------------------------
-- EARTH_SHIELD
-- ---------------------------------------------------------------------
add("EARTH_SHIELD", "customemote", "places a hand on the ground as stones and dust swirl into a protective aura.")

-- ---------------------------------------------------------------------
-- BLOODLUST
-- ---------------------------------------------------------------------
add("BLOODLUST", "say", "Let fury and strength flow through us!")
add("BLOODLUST", "say", "The ancestors drive us forward!")
add("BLOODLUST", "say", "Strike fast, strike true!")
add("BLOODLUST", "say", "The storm surges within us!")
add("BLOODLUST", "say", "BLOOD AND THUNDER!")
add("BLOODLUST", "say", "Rage of the spirits ignite our souls!")
add("BLOODLUST", "say", "Feel the heartbeat of the storm!")
add("BLOODLUST", "say", "Power beyond reckoning surges through us!")

-- ---------------------------------------------------------------------
-- BLOODLUST
-- ---------------------------------------------------------------------
add("BLOODLUST", "customemote", "lets out a battle cry as their body surges with unstoppable energy.")
add("BLOODLUST", "customemote", "throws their head back and howls, their form crackling with raw power.")
add("BLOODLUST", "customemote", "slams their weapon into the ground, sending out a shockwave of pure adrenaline.")

-- ---------------------------------------------------------------------
-- EARTHSHAKER_SLAM
-- ---------------------------------------------------------------------
add("EARTHSHAKER_SLAM", "say", "The ground itself fights at my side!")
add("EARTHSHAKER_SLAM", "say", "Tremble beneath the Earth’s wrath!")
add("EARTHSHAKER_SLAM", "say", "Eyes on me {RINSULT}!")

-- ---------------------------------------------------------------------
-- EARTHSHAKER_SLAM
-- ---------------------------------------------------------------------
add("EARTHSHAKER_SLAM", "customemote", "slams the ground, sending out a shockwave that commands attention.")

-- ---------------------------------------------------------------------
-- CALM_ELEMENTS
-- ---------------------------------------------------------------------
add("CALM_ELEMENTS", "say", "Rest easy, spirits of the land.")
add("CALM_ELEMENTS", "say", "The elements heed my voice and settle in peace.")

-- ---------------------------------------------------------------------
-- CALM_ELEMENTS
-- ---------------------------------------------------------------------
add("CALM_ELEMENTS", "customemote", "chants a calming prayer, soothing the anger of the elemental forces.")

-- ---------------------------------------------------------------------
-- TOTEMIC_RECALL
-- ---------------------------------------------------------------------
add("TOTEMIC_RECALL", "say", "The earth reclaims its gifts.")
add("TOTEMIC_RECALL", "say", "The spirits withdraw their totems, restoring their essence.")

-- ---------------------------------------------------------------------
-- TOTEMIC_RECALL
-- ---------------------------------------------------------------------
add("TOTEMIC_RECALL", "customemote", "chants softly, recalling their totems back into the earth.")

-- ---------------------------------------------------------------------
-- TOTEMIC_SLAM
-- ---------------------------------------------------------------------
add("TOTEMIC_SLAM", "say", "Strength and earth, one and the same!")
add("TOTEMIC_SLAM", "say", "A true warrior strikes with the weight of the land!")

-- ---------------------------------------------------------------------
-- TOTEMIC_SLAM
-- ---------------------------------------------------------------------
add("TOTEMIC_SLAM", "customemote", "slams their weapon into their foe, disrupting the foe's attack speed.")

-- ---------------------------------------------------------------------
-- FERAL_SPIRIT
-- ---------------------------------------------------------------------
add("FERAL_SPIRIT", "say", "Ancient spirits, fight by my side!")
add("FERAL_SPIRIT", "say", "The wolves of the wild heed my call!")

-- ---------------------------------------------------------------------
-- FERAL_SPIRIT
-- ---------------------------------------------------------------------
add("FERAL_SPIRIT", "customemote", "summons two ghostly wolves, their howls echoing across the battlefield.")

-- ---------------------------------------------------------------------
-- HEX
-- ---------------------------------------------------------------------
add("HEX", "say", "Da spirits say... you be a frog now!")
add("HEX", "say", "You best be learnin’ to hop, mon!")

-- ---------------------------------------------------------------------
-- HEX
-- ---------------------------------------------------------------------
add("HEX", "customemote", "cackles as they weave a hex, transforming {TARGET} into a helpless frog.")
