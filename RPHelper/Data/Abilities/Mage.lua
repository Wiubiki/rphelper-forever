-- RPHelper Forever - Mage ability content
-- Corpus migration from the RPhelper_twow Mage catalogue and original RoleplayingHelper lineage.
-- The legacy Mage source carried no named contributor attribution.

local A = RPHelper.Ability.MAGE
local C = RPHelper.Class.MAGE
local function add(ability, entryType, text)
    A[ability] = A[ability] or ability
    RPHelper.RegisterAbility(C, A[ability], { type = entryType, text = text })
end

-- =====================================================================
-- Arcane
-- =====================================================================

-- ---------------------------------------------------------------------
-- AMPLIFY_MAGIC
-- ---------------------------------------------------------------------
add("AMPLIFY_MAGIC", "say", "Power, intensified!")
add("AMPLIFY_MAGIC", "say", "Magic surges within me!")
add("AMPLIFY_MAGIC", "customemote", "channels energy, magnifying the magic around {PP}.")

-- ---------------------------------------------------------------------
-- ARCANE_BLAST
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "ARCANE_BLAST")

-- add("ARCANE_BLAST", "say", "")
-- add("ARCANE_BLAST", "emote", "")
-- add("ARCANE_BLAST", "customemote", "")

-- ---------------------------------------------------------------------
-- ARCANE_BRILLIANCE
-- ---------------------------------------------------------------------
add("ARCANE_BRILLIANCE", "say", "A gift of knowledge and strength!")
add("ARCANE_BRILLIANCE", "say", "Let wisdom and power flow through us!")
add("ARCANE_BRILLIANCE", "customemote", "bestows great magical insight upon {PP} allies.")

-- ---------------------------------------------------------------------
-- ARCANE_EXPLOSION
-- ---------------------------------------------------------------------
add("ARCANE_EXPLOSION", "say", "BOOM!")
add("ARCANE_EXPLOSION", "say", "Arcane energy, unleashed!")
add("ARCANE_EXPLOSION", "customemote", "releases a burst of raw arcane energy, striking all nearby foes.")

-- ---------------------------------------------------------------------
-- ARCANE_INTELLECT
-- ---------------------------------------------------------------------
add("ARCANE_INTELLECT", "say", "Knowledge is power, and I am overflowing!")
add("ARCANE_INTELLECT", "say", "A sharp mind is the greatest weapon.")
add("ARCANE_INTELLECT", "customemote", "channels arcane energy, sharpening {PP} intellect.")

-- ---------------------------------------------------------------------
-- ARCANE_MISSILES
-- ---------------------------------------------------------------------
add("ARCANE_MISSILES", "say", "A storm of arcane fury!")
add("ARCANE_MISSILES", "say", "Dodge this... if you can!")
add("ARCANE_MISSILES", "customemote", "unleashes a barrage of pure arcane energy at {TARGET}.")

-- ---------------------------------------------------------------------
-- ARCANE_POWER
-- ---------------------------------------------------------------------
add("ARCANE_POWER", "say", "Unlimited arcane might!")
add("ARCANE_POWER", "say", "Witness true magical destruction!")
add("ARCANE_POWER", "customemote", "glows with pure arcane energy, ready to unleash devastation.")

-- ---------------------------------------------------------------------
-- ARCANE_WRATH
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "ARCANE_WRATH")

-- add("ARCANE_WRATH", "say", "")
-- add("ARCANE_WRATH", "emote", "")
-- add("ARCANE_WRATH", "customemote", "")

-- ---------------------------------------------------------------------
-- BLINK
-- ---------------------------------------------------------------------
add("BLINK", "say", "Now you see me, now you don't!")
add("BLINK", "say", "A quick step through space and time!")
add("BLINK", "customemote", "disappears in a flash, reappearing a short distance away.")

-- ---------------------------------------------------------------------
-- CONJURE_FOOD
-- ---------------------------------------------------------------------
add("CONJURE_FOOD", "say", "A meal, courtesy of the arcane!")
add("CONJURE_FOOD", "customemote", "summons a feast from the ether.")

-- ---------------------------------------------------------------------
-- CONJURE_MANA_AGATE
-- ---------------------------------------------------------------------
add("CONJURE_MANA_AGATE", "say", "A small gem of energy, but still potent!")
add("CONJURE_MANA_AGATE", "customemote", "coalesces mana into a shimmering agate.")

-- ---------------------------------------------------------------------
-- CONJURE_MANA_CITRINE
-- ---------------------------------------------------------------------
add("CONJURE_MANA_CITRINE", "say", "A crystal of refined magical energy.")
add("CONJURE_MANA_CITRINE", "customemote", "crafts a gleaming citrine pulsating with mana.")

-- ---------------------------------------------------------------------
-- CONJURE_MANA_JADE
-- ---------------------------------------------------------------------
add("CONJURE_MANA_JADE", "say", "Mana condensed into a flawless jade.")
add("CONJURE_MANA_JADE", "customemote", "focuses intensely, forming a bright mana-infused jade.")

-- ---------------------------------------------------------------------
-- CONJURE_MANA_RUBY
-- ---------------------------------------------------------------------
add("CONJURE_MANA_RUBY", "say", "The pinnacle of conjured mana, a ruby of power!")
add("CONJURE_MANA_RUBY", "customemote", "forms a brilliant ruby, overflowing with mana.")

-- ---------------------------------------------------------------------
-- CONJURE_WATER
-- ---------------------------------------------------------------------
add("CONJURE_WATER", "say", "Water, summoned from the void!")
add("CONJURE_WATER", "customemote", "conjures fresh water out of thin air.")

-- ---------------------------------------------------------------------
-- COUNTERSPELL
-- ---------------------------------------------------------------------
add("COUNTERSPELL", "say", "Not today!")
add("COUNTERSPELL", "say", "Silence, fool!")
add("COUNTERSPELL", "customemote", "interrupts {TARGET}'s spell with a precise incantation.")

-- ---------------------------------------------------------------------
-- DAMPEN_MAGIC
-- ---------------------------------------------------------------------
add("DAMPEN_MAGIC", "say", "A little protection goes a long way.")
add("DAMPEN_MAGIC", "say", "Less magic, less pain!")
add("DAMPEN_MAGIC", "customemote", "envelops {PP} body in a shimmering barrier of magic.")

-- ---------------------------------------------------------------------
-- EVOCATION
-- ---------------------------------------------------------------------
add("EVOCATION", "say", "Arcane energy, restore me!")
add("EVOCATION", "say", "Mana flows through me once more!")
add("EVOCATION", "customemote", "closes {PP} eyes, drawing in pure magical essence.")

-- ---------------------------------------------------------------------
-- MAGE_ARMOR
-- ---------------------------------------------------------------------
add("MAGE_ARMOR", "say", "A mage’s best protection.")
add("MAGE_ARMOR", "say", "Woven magic, stronger than steel.")
add("MAGE_ARMOR", "customemote", "wraps themself in protective arcane energy.")

-- ---------------------------------------------------------------------
-- MANA_SHIELD
-- ---------------------------------------------------------------------
add("MANA_SHIELD", "say", "My magic, my shield!")
add("MANA_SHIELD", "say", "Try breaking through this!")
add("MANA_SHIELD", "customemote", "surrounds {PP} body with a glowing, protective barrier.")

-- ---------------------------------------------------------------------
-- POLYMORPH
-- ---------------------------------------------------------------------
add("POLYMORPH", "say", "Enjoy your new form, {TARGET}!")
add("POLYMORPH", "say", "And now, a little transformation!")
add("POLYMORPH", "customemote", "waves a hand, transforming {TARGET} into a harmless critter.")

-- ---------------------------------------------------------------------
-- POLYMORPH_PIG
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "POLYMORPH_PIG")

-- add("POLYMORPH_PIG", "say", "")
-- add("POLYMORPH_PIG", "emote", "")
-- add("POLYMORPH_PIG", "customemote", "")

-- ---------------------------------------------------------------------
-- POLYMORPH_TURTLE
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "POLYMORPH_TURTLE")

-- add("POLYMORPH_TURTLE", "say", "")
-- add("POLYMORPH_TURTLE", "emote", "")
-- add("POLYMORPH_TURTLE", "customemote", "")

-- ---------------------------------------------------------------------
-- PORTAL_DARNASSUS
-- ---------------------------------------------------------------------
add("PORTAL_DARNASSUS", "say", "Darnassus is but a step away!")
add("PORTAL_DARNASSUS", "customemote", "forms a glowing entrance to Darnassus.")

-- ---------------------------------------------------------------------
-- PORTAL_IRONFORGE
-- ---------------------------------------------------------------------
add("PORTAL_IRONFORGE", "say", "Portal to Ironforge, step right through!")
add("PORTAL_IRONFORGE", "customemote", "weaves a persistent portal to Ironforge.")

-- ---------------------------------------------------------------------
-- PORTAL_ORGRIMMAR
-- ---------------------------------------------------------------------
add("PORTAL_ORGRIMMAR", "say", "A portal to Orgrimmar stands ready!")
add("PORTAL_ORGRIMMAR", "customemote", "crafts a swirling entrance to Orgrimmar.")

-- ---------------------------------------------------------------------
-- PORTAL_STORMWIND
-- ---------------------------------------------------------------------
add("PORTAL_STORMWIND", "say", "A gateway to Stormwind is now open!")
add("PORTAL_STORMWIND", "customemote", "establishes a stable portal to Stormwind.")

-- ---------------------------------------------------------------------
-- PORTAL_THUNDER_BLUFF
-- ---------------------------------------------------------------------
add("PORTAL_THUNDER_BLUFF", "say", "Thunder Bluff, now accessible!")
add("PORTAL_THUNDER_BLUFF", "customemote", "summons a steady portal to Thunder Bluff.")

-- ---------------------------------------------------------------------
-- PORTAL_UNDERCITY
-- ---------------------------------------------------------------------
add("PORTAL_UNDERCITY", "say", "Step through to Undercity!")
add("PORTAL_UNDERCITY", "customemote", "weaves a dark-hued portal to Undercity.")

-- ---------------------------------------------------------------------
-- PRESENCE_OF_MIND
-- ---------------------------------------------------------------------
add("PRESENCE_OF_MIND", "say", "Absolute clarity of thought!")
add("PRESENCE_OF_MIND", "say", "Now, let’s cast with no hesitation!")
add("PRESENCE_OF_MIND", "customemote", "calms {PP} mind, readying for an instant cast.")

-- ---------------------------------------------------------------------
-- REMOVE_LESSER_CURSE
-- ---------------------------------------------------------------------
add("REMOVE_LESSER_CURSE", "say", "Begone, dark magic!")
add("REMOVE_LESSER_CURSE", "say", "No curse can withstand my power!")
add("REMOVE_LESSER_CURSE", "customemote", "chants an incantation, dispelling a minor curse.")

-- ---------------------------------------------------------------------
-- SLOW_FALL
-- ---------------------------------------------------------------------
add("SLOW_FALL", "say", "Float like a feather, land like a dream!")
add("SLOW_FALL", "say", "Defying gravity, one spell at a time.")
add("SLOW_FALL", "customemote", "casts a spell, allowing {PP} descent to become weightless.")

-- ---------------------------------------------------------------------
-- TELEPORT_DALARAN
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "TELEPORT_DALARAN")

-- add("TELEPORT_DALARAN", "say", "")
-- add("TELEPORT_DALARAN", "emote", "")
-- add("TELEPORT_DALARAN", "customemote", "")

-- ---------------------------------------------------------------------
-- TELEPORT_DARNASSUS
-- ---------------------------------------------------------------------
add("TELEPORT_DARNASSUS", "say", "A journey to the tranquil city of Darnassus!")
add("TELEPORT_DARNASSUS", "customemote", "channels magic to open a path to Darnassus.")

-- ---------------------------------------------------------------------
-- TELEPORT_IRONFORGE
-- ---------------------------------------------------------------------
add("TELEPORT_IRONFORGE", "say", "To Ironforge we go!")
add("TELEPORT_IRONFORGE", "customemote", "opens a shimmering portal to Ironforge.")

-- ---------------------------------------------------------------------
-- TELEPORT_ORGRIMMAR
-- ---------------------------------------------------------------------
add("TELEPORT_ORGRIMMAR", "say", "To the heart of the Horde, Orgrimmar!")
add("TELEPORT_ORGRIMMAR", "customemote", "conjures a swirling gateway to Orgrimmar.")

-- ---------------------------------------------------------------------
-- TELEPORT_STORMWIND
-- ---------------------------------------------------------------------
add("TELEPORT_STORMWIND", "say", "A quick trip to Stormwind!")
add("TELEPORT_STORMWIND", "customemote", "summons a glowing portal to Stormwind.")

-- ---------------------------------------------------------------------
-- TELEPORT_THUNDER_BLUFF
-- ---------------------------------------------------------------------
add("TELEPORT_THUNDER_BLUFF", "say", "To the mesas of Thunder Bluff!")
add("TELEPORT_THUNDER_BLUFF", "customemote", "calls forth a magical gateway to Thunder Bluff.")

-- ---------------------------------------------------------------------
-- TELEPORT_UNDERCITY
-- ---------------------------------------------------------------------
add("TELEPORT_UNDERCITY", "say", "Undercity awaits!")
add("TELEPORT_UNDERCITY", "customemote", "opens a dark-tinged portal to Undercity.")

-- =====================================================================
-- Fire
-- =====================================================================

-- ---------------------------------------------------------------------
-- BLAST_WAVE
-- ---------------------------------------------------------------------
add("BLAST_WAVE", "say", "Fire, expand!")
add("BLAST_WAVE", "say", "An explosion of pure heat!")
add("BLAST_WAVE", "customemote", "unleashes a wave of fire, knocking back nearby enemies.")

-- ---------------------------------------------------------------------
-- COMBUSTION
-- ---------------------------------------------------------------------
add("COMBUSTION", "say", "Now to turn up the heat!")
add("COMBUSTION", "say", "Unstoppable flames!")
add("COMBUSTION", "customemote", "focuses, causing {PP} spells to ignite with greater intensity.")

-- ---------------------------------------------------------------------
-- FIRE_BLAST
-- ---------------------------------------------------------------------
add("FIRE_BLAST", "say", "Instant combustion!")
add("FIRE_BLAST", "say", "Feel the heat!")
add("FIRE_BLAST", "customemote", "releases a sudden burst of flame at {TARGET}.")

-- ---------------------------------------------------------------------
-- FIRE_WARD
-- ---------------------------------------------------------------------
add("FIRE_WARD", "say", "Flames cannot touch me!")
add("FIRE_WARD", "customemote", "surrounds themself in a protective aura against fire.")

-- ---------------------------------------------------------------------
-- FIREBALL
-- ---------------------------------------------------------------------
add("FIREBALL", "say", "Burn!")
add("FIREBALL", "say", "A sphere of destruction, just for you!")
add("FIREBALL", "customemote", "hurls a massive fireball at {TARGET}.")

-- ---------------------------------------------------------------------
-- FLAMESTRIKE
-- ---------------------------------------------------------------------
add("FLAMESTRIKE", "say", "Rain of fire!")
add("FLAMESTRIKE", "say", "Let the ground burn beneath you!")
add("FLAMESTRIKE", "customemote", "calls down a pillar of fire upon {TARGET}'s location.")

-- ---------------------------------------------------------------------
-- FROSTFIRE_BOLT
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "FROSTFIRE_BOLT")

-- add("FROSTFIRE_BOLT", "say", "")
-- add("FROSTFIRE_BOLT", "emote", "")
-- add("FROSTFIRE_BOLT", "customemote", "")

-- ---------------------------------------------------------------------
-- PYROBLAST
-- ---------------------------------------------------------------------
add("PYROBLAST", "say", "Prepare for incineration!")
add("PYROBLAST", "say", "This will leave a mark!")
add("PYROBLAST", "customemote", "channels an immense fireball, ready to engulf {TARGET} in flames.")

-- ---------------------------------------------------------------------
-- SCORCH
-- ---------------------------------------------------------------------
add("SCORCH", "say", "A little warm-up before the real fire!")
add("SCORCH", "customemote", "sends a quick burst of fire at {TARGET}.")

-- =====================================================================
-- Frost
-- =====================================================================

-- ---------------------------------------------------------------------
-- BLIZZARD
-- ---------------------------------------------------------------------
add("BLIZZARD", "say", "Let the storm rage on!")
add("BLIZZARD", "say", "A flurry of ice to freeze my foes!")
add("BLIZZARD", "customemote", "calls forth an icy storm, engulfing the battlefield in snow and hail.")

-- ---------------------------------------------------------------------
-- COLD_SNAP
-- ---------------------------------------------------------------------
add("COLD_SNAP", "say", "Winter’s bite, renewed!")
add("COLD_SNAP", "customemote", "channels the cold, instantly resetting {PP} frost magic.")

-- ---------------------------------------------------------------------
-- CONE_OF_COLD
-- ---------------------------------------------------------------------
add("CONE_OF_COLD", "say", "A breath of winter’s fury!")
add("CONE_OF_COLD", "customemote", "unleashes a freezing gust, chilling all in its path.")

-- ---------------------------------------------------------------------
-- FROST_ARMOR
-- ---------------------------------------------------------------------
add("FROST_ARMOR", "say", "A layer of frost, my perfect defense!")
add("FROST_ARMOR", "customemote", "coats themself in a protective layer of frost.")

-- ---------------------------------------------------------------------
-- FROST_BLAST
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "FROST_BLAST")

-- add("FROST_BLAST", "say", "")
-- add("FROST_BLAST", "emote", "")
-- add("FROST_BLAST", "customemote", "")

-- ---------------------------------------------------------------------
-- FROST_NOVA
-- ---------------------------------------------------------------------
add("FROST_NOVA", "say", "Freeze where you stand!")
add("FROST_NOVA", "customemote", "unleashes a freezing pulse, rooting all nearby foes in place.")

-- ---------------------------------------------------------------------
-- FROST_WARD
-- ---------------------------------------------------------------------
add("FROST_WARD", "say", "Frost cannot harm one who wields it!")
add("FROST_WARD", "customemote", "shields themself against incoming frost magic.")

-- ---------------------------------------------------------------------
-- FROSTBOLT
-- ---------------------------------------------------------------------
add("FROSTBOLT", "say", "Cold and sharp, just like my wit!")
add("FROSTBOLT", "say", "A chill runs down your spine... literally!")
add("FROSTBOLT", "customemote", "hurls a shard of ice toward {TARGET}.")

-- ---------------------------------------------------------------------
-- ICE_ARMOR
-- ---------------------------------------------------------------------
add("ICE_ARMOR", "say", "Frozen and fortified!")
add("ICE_ARMOR", "customemote", "encases themself in a thick sheet of enchanted ice.")

-- ---------------------------------------------------------------------
-- ICE_BARRIER
-- ---------------------------------------------------------------------
add("ICE_BARRIER", "say", "Try breaking through this!")
add("ICE_BARRIER", "customemote", "summons a thick shield of ice to absorb incoming damage.")

-- ---------------------------------------------------------------------
-- ICE_BLOCK
-- ---------------------------------------------------------------------
add("ICE_BLOCK", "say", "Encased in ice, untouchable!")
add("ICE_BLOCK", "customemote", "freezes solid, becoming immune to attacks.")

-- ---------------------------------------------------------------------
-- ICE_LANCE
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "ICE_LANCE")

-- add("ICE_LANCE", "say", "")
-- add("ICE_LANCE", "emote", "")
-- add("ICE_LANCE", "customemote", "")

-- Not in Forever Beta / Legacy Archive
-- Detect Magic and Icicles reactions are preserved in MageArchive.lua,
-- which is intentionally absent from the addon manifest and performs no registrations.
