-- RPHelper Forever - Mage ability content
-- Corpus migration from the RPhelper_twow Mage catalogue and original RoleplayingHelper lineage.
-- The legacy Mage source carried no named contributor attribution.

local A = RPHelper.Ability.MAGE
local C = RPHelper.Class.MAGE
local function add(ability, entryType, text)
    A[ability] = A[ability] or ability
    RPHelper.RegisterAbility(C, A[ability], { type = entryType, text = text })
end

-- ---------------------------------------------------------------------
-- ARCANE_INTELLECT
-- ---------------------------------------------------------------------
add("ARCANE_INTELLECT", "say", "Knowledge is power, and I am overflowing!")
add("ARCANE_INTELLECT", "say", "A sharp mind is the greatest weapon.")

-- ---------------------------------------------------------------------
-- ARCANE_INTELLECT
-- ---------------------------------------------------------------------
add("ARCANE_INTELLECT", "customemote", "channels arcane energy, sharpening {PP} intellect.")

-- ---------------------------------------------------------------------
-- ARCANE_MISSILES
-- ---------------------------------------------------------------------
add("ARCANE_MISSILES", "say", "A storm of arcane fury!")
add("ARCANE_MISSILES", "say", "Dodge this... if you can!")

-- ---------------------------------------------------------------------
-- ARCANE_MISSILES
-- ---------------------------------------------------------------------
add("ARCANE_MISSILES", "customemote", "unleashes a barrage of pure arcane energy at {TARGET}.")

-- ---------------------------------------------------------------------
-- POLYMORPH
-- ---------------------------------------------------------------------
add("POLYMORPH", "say", "Enjoy your new form, {TARGET}!")
add("POLYMORPH", "say", "And now, a little transformation!")

-- ---------------------------------------------------------------------
-- POLYMORPH
-- ---------------------------------------------------------------------
add("POLYMORPH", "customemote", "waves a hand, transforming {TARGET} into a harmless critter.")

-- ---------------------------------------------------------------------
-- DAMPEN_MAGIC
-- ---------------------------------------------------------------------
add("DAMPEN_MAGIC", "say", "A little protection goes a long way.")
add("DAMPEN_MAGIC", "say", "Less magic, less pain!")

-- ---------------------------------------------------------------------
-- DAMPEN_MAGIC
-- ---------------------------------------------------------------------
add("DAMPEN_MAGIC", "customemote", "envelops {PP} body in a shimmering barrier of magic.")

-- ---------------------------------------------------------------------
-- SLOW_FALL
-- ---------------------------------------------------------------------
add("SLOW_FALL", "say", "Float like a feather, land like a dream!")
add("SLOW_FALL", "say", "Defying gravity, one spell at a time.")

-- ---------------------------------------------------------------------
-- SLOW_FALL
-- ---------------------------------------------------------------------
add("SLOW_FALL", "customemote", "casts a spell, allowing {PP} descent to become weightless.")

-- ---------------------------------------------------------------------
-- ARCANE_EXPLOSION
-- ---------------------------------------------------------------------
add("ARCANE_EXPLOSION", "say", "BOOM!")
add("ARCANE_EXPLOSION", "say", "Arcane energy, unleashed!")

-- ---------------------------------------------------------------------
-- ARCANE_EXPLOSION
-- ---------------------------------------------------------------------
add("ARCANE_EXPLOSION", "customemote", "releases a burst of raw arcane energy, striking all nearby foes.")

-- ---------------------------------------------------------------------
-- DETECT_MAGIC
-- ---------------------------------------------------------------------
add("DETECT_MAGIC", "say", "No secrets can hide from me!")
add("DETECT_MAGIC", "say", "Let's see what magic is lurking here.")

-- ---------------------------------------------------------------------
-- DETECT_MAGIC
-- ---------------------------------------------------------------------
add("DETECT_MAGIC", "customemote", "extends {PP} senses, searching for hidden enchantments.")

-- ---------------------------------------------------------------------
-- AMPLIFY_MAGIC
-- ---------------------------------------------------------------------
add("AMPLIFY_MAGIC", "say", "Power, intensified!")
add("AMPLIFY_MAGIC", "say", "Magic surges within me!")

-- ---------------------------------------------------------------------
-- AMPLIFY_MAGIC
-- ---------------------------------------------------------------------
add("AMPLIFY_MAGIC", "customemote", "channels energy, magnifying the magic around {PP}.")

-- ---------------------------------------------------------------------
-- REMOVE_LESSER_CURSE
-- ---------------------------------------------------------------------
add("REMOVE_LESSER_CURSE", "say", "Begone, dark magic!")
add("REMOVE_LESSER_CURSE", "say", "No curse can withstand my power!")

-- ---------------------------------------------------------------------
-- REMOVE_LESSER_CURSE
-- ---------------------------------------------------------------------
add("REMOVE_LESSER_CURSE", "customemote", "chants an incantation, dispelling a minor curse.")

-- ---------------------------------------------------------------------
-- BLINK
-- ---------------------------------------------------------------------
add("BLINK", "say", "Now you see me, now you don't!")
add("BLINK", "say", "A quick step through space and time!")

-- ---------------------------------------------------------------------
-- BLINK
-- ---------------------------------------------------------------------
add("BLINK", "customemote", "disappears in a flash, reappearing a short distance away.")

-- ---------------------------------------------------------------------
-- EVOCATION
-- ---------------------------------------------------------------------
add("EVOCATION", "say", "Arcane energy, restore me!")
add("EVOCATION", "say", "Mana flows through me once more!")

-- ---------------------------------------------------------------------
-- EVOCATION
-- ---------------------------------------------------------------------
add("EVOCATION", "customemote", "closes {PP} eyes, drawing in pure magical essence.")

-- ---------------------------------------------------------------------
-- MANA_SHIELD
-- ---------------------------------------------------------------------
add("MANA_SHIELD", "say", "My magic, my shield!")
add("MANA_SHIELD", "say", "Try breaking through this!")

-- ---------------------------------------------------------------------
-- MANA_SHIELD
-- ---------------------------------------------------------------------
add("MANA_SHIELD", "customemote", "surrounds {PP} body with a glowing, protective barrier.")

-- ---------------------------------------------------------------------
-- COUNTERSPELL
-- ---------------------------------------------------------------------
add("COUNTERSPELL", "say", "Not today!")
add("COUNTERSPELL", "say", "Silence, fool!")

-- ---------------------------------------------------------------------
-- COUNTERSPELL
-- ---------------------------------------------------------------------
add("COUNTERSPELL", "customemote", "interrupts {TARGET}'s spell with a precise incantation.")

-- ---------------------------------------------------------------------
-- PRESENCE_OF_MIND
-- ---------------------------------------------------------------------
add("PRESENCE_OF_MIND", "say", "Absolute clarity of thought!")
add("PRESENCE_OF_MIND", "say", "Now, let’s cast with no hesitation!")

-- ---------------------------------------------------------------------
-- PRESENCE_OF_MIND
-- ---------------------------------------------------------------------
add("PRESENCE_OF_MIND", "customemote", "calms {PP} mind, readying for an instant cast.")

-- ---------------------------------------------------------------------
-- MAGE_ARMOR
-- ---------------------------------------------------------------------
add("MAGE_ARMOR", "say", "A mage’s best protection.")
add("MAGE_ARMOR", "say", "Woven magic, stronger than steel.")

-- ---------------------------------------------------------------------
-- MAGE_ARMOR
-- ---------------------------------------------------------------------
add("MAGE_ARMOR", "customemote", "wraps themself in protective arcane energy.")

-- ---------------------------------------------------------------------
-- ARCANE_POWER
-- ---------------------------------------------------------------------
add("ARCANE_POWER", "say", "Unlimited arcane might!")
add("ARCANE_POWER", "say", "Witness true magical destruction!")

-- ---------------------------------------------------------------------
-- ARCANE_POWER
-- ---------------------------------------------------------------------
add("ARCANE_POWER", "customemote", "glows with pure arcane energy, ready to unleash devastation.")

-- ---------------------------------------------------------------------
-- ARCANE_BRILLIANCE
-- ---------------------------------------------------------------------
add("ARCANE_BRILLIANCE", "say", "A gift of knowledge and strength!")
add("ARCANE_BRILLIANCE", "say", "Let wisdom and power flow through us!")

-- ---------------------------------------------------------------------
-- ARCANE_BRILLIANCE
-- ---------------------------------------------------------------------
add("ARCANE_BRILLIANCE", "customemote", "bestows great magical insight upon {PP} allies.")

-- ---------------------------------------------------------------------
-- CONJURE_WATER
-- ---------------------------------------------------------------------
add("CONJURE_WATER", "say", "Water, summoned from the void!")

-- ---------------------------------------------------------------------
-- CONJURE_WATER
-- ---------------------------------------------------------------------
add("CONJURE_WATER", "customemote", "conjures fresh water out of thin air.")

-- ---------------------------------------------------------------------
-- CONJURE_FOOD
-- ---------------------------------------------------------------------
add("CONJURE_FOOD", "say", "A meal, courtesy of the arcane!")

-- ---------------------------------------------------------------------
-- CONJURE_FOOD
-- ---------------------------------------------------------------------
add("CONJURE_FOOD", "customemote", "summons a feast from the ether.")

-- ---------------------------------------------------------------------
-- CONJURE_MANA_AGATE
-- ---------------------------------------------------------------------
add("CONJURE_MANA_AGATE", "say", "A small gem of energy, but still potent!")

-- ---------------------------------------------------------------------
-- CONJURE_MANA_AGATE
-- ---------------------------------------------------------------------
add("CONJURE_MANA_AGATE", "customemote", "coalesces mana into a shimmering agate.")

-- ---------------------------------------------------------------------
-- CONJURE_MANA_JADE
-- ---------------------------------------------------------------------
add("CONJURE_MANA_JADE", "say", "Mana condensed into a flawless jade.")

-- ---------------------------------------------------------------------
-- CONJURE_MANA_JADE
-- ---------------------------------------------------------------------
add("CONJURE_MANA_JADE", "customemote", "focuses intensely, forming a bright mana-infused jade.")

-- ---------------------------------------------------------------------
-- CONJURE_MANA_CITRINE
-- ---------------------------------------------------------------------
add("CONJURE_MANA_CITRINE", "say", "A crystal of refined magical energy.")

-- ---------------------------------------------------------------------
-- CONJURE_MANA_CITRINE
-- ---------------------------------------------------------------------
add("CONJURE_MANA_CITRINE", "customemote", "crafts a gleaming citrine pulsating with mana.")

-- ---------------------------------------------------------------------
-- CONJURE_MANA_RUBY
-- ---------------------------------------------------------------------
add("CONJURE_MANA_RUBY", "say", "The pinnacle of conjured mana, a ruby of power!")

-- ---------------------------------------------------------------------
-- CONJURE_MANA_RUBY
-- ---------------------------------------------------------------------
add("CONJURE_MANA_RUBY", "customemote", "forms a brilliant ruby, overflowing with mana.")

-- ---------------------------------------------------------------------
-- TELEPORT_IRONFORGE
-- ---------------------------------------------------------------------
add("TELEPORT_IRONFORGE", "say", "To Ironforge we go!")

-- ---------------------------------------------------------------------
-- TELEPORT_IRONFORGE
-- ---------------------------------------------------------------------
add("TELEPORT_IRONFORGE", "customemote", "opens a shimmering portal to Ironforge.")

-- ---------------------------------------------------------------------
-- TELEPORT_STORMWIND
-- ---------------------------------------------------------------------
add("TELEPORT_STORMWIND", "say", "A quick trip to Stormwind!")

-- ---------------------------------------------------------------------
-- TELEPORT_STORMWIND
-- ---------------------------------------------------------------------
add("TELEPORT_STORMWIND", "customemote", "summons a glowing portal to Stormwind.")

-- ---------------------------------------------------------------------
-- TELEPORT_DARNASSUS
-- ---------------------------------------------------------------------
add("TELEPORT_DARNASSUS", "say", "A journey to the tranquil city of Darnassus!")

-- ---------------------------------------------------------------------
-- TELEPORT_DARNASSUS
-- ---------------------------------------------------------------------
add("TELEPORT_DARNASSUS", "customemote", "channels magic to open a path to Darnassus.")

-- ---------------------------------------------------------------------
-- TELEPORT_ORGRIMMAR
-- ---------------------------------------------------------------------
add("TELEPORT_ORGRIMMAR", "say", "To the heart of the Horde, Orgrimmar!")

-- ---------------------------------------------------------------------
-- TELEPORT_ORGRIMMAR
-- ---------------------------------------------------------------------
add("TELEPORT_ORGRIMMAR", "customemote", "conjures a swirling gateway to Orgrimmar.")

-- ---------------------------------------------------------------------
-- TELEPORT_UNDERCITY
-- ---------------------------------------------------------------------
add("TELEPORT_UNDERCITY", "say", "Undercity awaits!")

-- ---------------------------------------------------------------------
-- TELEPORT_UNDERCITY
-- ---------------------------------------------------------------------
add("TELEPORT_UNDERCITY", "customemote", "opens a dark-tinged portal to Undercity.")

-- ---------------------------------------------------------------------
-- TELEPORT_THUNDER_BLUFF
-- ---------------------------------------------------------------------
add("TELEPORT_THUNDER_BLUFF", "say", "To the mesas of Thunder Bluff!")

-- ---------------------------------------------------------------------
-- TELEPORT_THUNDER_BLUFF
-- ---------------------------------------------------------------------
add("TELEPORT_THUNDER_BLUFF", "customemote", "calls forth a magical gateway to Thunder Bluff.")

-- ---------------------------------------------------------------------
-- PORTAL_IRONFORGE
-- ---------------------------------------------------------------------
add("PORTAL_IRONFORGE", "say", "Portal to Ironforge, step right through!")

-- ---------------------------------------------------------------------
-- PORTAL_IRONFORGE
-- ---------------------------------------------------------------------
add("PORTAL_IRONFORGE", "customemote", "weaves a persistent portal to Ironforge.")

-- ---------------------------------------------------------------------
-- PORTAL_STORMWIND
-- ---------------------------------------------------------------------
add("PORTAL_STORMWIND", "say", "A gateway to Stormwind is now open!")

-- ---------------------------------------------------------------------
-- PORTAL_STORMWIND
-- ---------------------------------------------------------------------
add("PORTAL_STORMWIND", "customemote", "establishes a stable portal to Stormwind.")

-- ---------------------------------------------------------------------
-- PORTAL_DARNASSUS
-- ---------------------------------------------------------------------
add("PORTAL_DARNASSUS", "say", "Darnassus is but a step away!")

-- ---------------------------------------------------------------------
-- PORTAL_DARNASSUS
-- ---------------------------------------------------------------------
add("PORTAL_DARNASSUS", "customemote", "forms a glowing entrance to Darnassus.")

-- ---------------------------------------------------------------------
-- PORTAL_ORGRIMMAR
-- ---------------------------------------------------------------------
add("PORTAL_ORGRIMMAR", "say", "A portal to Orgrimmar stands ready!")

-- ---------------------------------------------------------------------
-- PORTAL_ORGRIMMAR
-- ---------------------------------------------------------------------
add("PORTAL_ORGRIMMAR", "customemote", "crafts a swirling entrance to Orgrimmar.")

-- ---------------------------------------------------------------------
-- PORTAL_UNDERCITY
-- ---------------------------------------------------------------------
add("PORTAL_UNDERCITY", "say", "Step through to Undercity!")

-- ---------------------------------------------------------------------
-- PORTAL_UNDERCITY
-- ---------------------------------------------------------------------
add("PORTAL_UNDERCITY", "customemote", "weaves a dark-hued portal to Undercity.")

-- ---------------------------------------------------------------------
-- PORTAL_THUNDER_BLUFF
-- ---------------------------------------------------------------------
add("PORTAL_THUNDER_BLUFF", "say", "Thunder Bluff, now accessible!")

-- ---------------------------------------------------------------------
-- PORTAL_THUNDER_BLUFF
-- ---------------------------------------------------------------------
add("PORTAL_THUNDER_BLUFF", "customemote", "summons a steady portal to Thunder Bluff.")

-- ---------------------------------------------------------------------
-- FROSTBOLT
-- ---------------------------------------------------------------------
add("FROSTBOLT", "say", "Cold and sharp, just like my wit!")
add("FROSTBOLT", "say", "A chill runs down your spine... literally!")

-- ---------------------------------------------------------------------
-- FROSTBOLT
-- ---------------------------------------------------------------------
add("FROSTBOLT", "customemote", "hurls a shard of ice toward {TARGET}.")

-- ---------------------------------------------------------------------
-- FROST_ARMOR
-- ---------------------------------------------------------------------
add("FROST_ARMOR", "say", "A layer of frost, my perfect defense!")

-- ---------------------------------------------------------------------
-- FROST_ARMOR
-- ---------------------------------------------------------------------
add("FROST_ARMOR", "customemote", "coats themself in a protective layer of frost.")

-- ---------------------------------------------------------------------
-- FROST_NOVA
-- ---------------------------------------------------------------------
add("FROST_NOVA", "say", "Freeze where you stand!")

-- ---------------------------------------------------------------------
-- FROST_NOVA
-- ---------------------------------------------------------------------
add("FROST_NOVA", "customemote", "unleashes a freezing pulse, rooting all nearby foes in place.")

-- ---------------------------------------------------------------------
-- BLIZZARD
-- ---------------------------------------------------------------------
add("BLIZZARD", "say", "Let the storm rage on!")
add("BLIZZARD", "say", "A flurry of ice to freeze my foes!")

-- ---------------------------------------------------------------------
-- BLIZZARD
-- ---------------------------------------------------------------------
add("BLIZZARD", "customemote", "calls forth an icy storm, engulfing the battlefield in snow and hail.")

-- ---------------------------------------------------------------------
-- COLD_SNAP
-- ---------------------------------------------------------------------
add("COLD_SNAP", "say", "Winter’s bite, renewed!")

-- ---------------------------------------------------------------------
-- COLD_SNAP
-- ---------------------------------------------------------------------
add("COLD_SNAP", "customemote", "channels the cold, instantly resetting {PP} frost magic.")

-- ---------------------------------------------------------------------
-- FROST_WARD
-- ---------------------------------------------------------------------
add("FROST_WARD", "say", "Frost cannot harm one who wields it!")

-- ---------------------------------------------------------------------
-- FROST_WARD
-- ---------------------------------------------------------------------
add("FROST_WARD", "customemote", "shields themself against incoming frost magic.")

-- ---------------------------------------------------------------------
-- CONE_OF_COLD
-- ---------------------------------------------------------------------
add("CONE_OF_COLD", "say", "A breath of winter’s fury!")

-- ---------------------------------------------------------------------
-- CONE_OF_COLD
-- ---------------------------------------------------------------------
add("CONE_OF_COLD", "customemote", "unleashes a freezing gust, chilling all in its path.")

-- ---------------------------------------------------------------------
-- ICE_ARMOR
-- ---------------------------------------------------------------------
add("ICE_ARMOR", "say", "Frozen and fortified!")

-- ---------------------------------------------------------------------
-- ICE_ARMOR
-- ---------------------------------------------------------------------
add("ICE_ARMOR", "customemote", "encases themself in a thick sheet of enchanted ice.")

-- ---------------------------------------------------------------------
-- ICE_BLOCK
-- ---------------------------------------------------------------------
add("ICE_BLOCK", "say", "Encased in ice, untouchable!")

-- ---------------------------------------------------------------------
-- ICE_BLOCK
-- ---------------------------------------------------------------------
add("ICE_BLOCK", "customemote", "freezes solid, becoming immune to attacks.")

-- ---------------------------------------------------------------------
-- ICE_BARRIER
-- ---------------------------------------------------------------------
add("ICE_BARRIER", "say", "Try breaking through this!")

-- ---------------------------------------------------------------------
-- ICE_BARRIER
-- ---------------------------------------------------------------------
add("ICE_BARRIER", "customemote", "summons a thick shield of ice to absorb incoming damage.")

-- ---------------------------------------------------------------------
-- FIRE_BLAST
-- ---------------------------------------------------------------------
add("FIRE_BLAST", "say", "Instant combustion!")
add("FIRE_BLAST", "say", "Feel the heat!")

-- ---------------------------------------------------------------------
-- FIRE_BLAST
-- ---------------------------------------------------------------------
add("FIRE_BLAST", "customemote", "releases a sudden burst of flame at {TARGET}.")

-- ---------------------------------------------------------------------
-- FIREBALL
-- ---------------------------------------------------------------------
add("FIREBALL", "say", "Burn!")
add("FIREBALL", "say", "A sphere of destruction, just for you!")

-- ---------------------------------------------------------------------
-- FIREBALL
-- ---------------------------------------------------------------------
add("FIREBALL", "customemote", "hurls a massive fireball at {TARGET}.")

-- ---------------------------------------------------------------------
-- FLAMESTRIKE
-- ---------------------------------------------------------------------
add("FLAMESTRIKE", "say", "Rain of fire!")
add("FLAMESTRIKE", "say", "Let the ground burn beneath you!")

-- ---------------------------------------------------------------------
-- FLAMESTRIKE
-- ---------------------------------------------------------------------
add("FLAMESTRIKE", "customemote", "calls down a pillar of fire upon {TARGET}'s location.")

-- ---------------------------------------------------------------------
-- FIRE_WARD
-- ---------------------------------------------------------------------
add("FIRE_WARD", "say", "Flames cannot touch me!")

-- ---------------------------------------------------------------------
-- FIRE_WARD
-- ---------------------------------------------------------------------
add("FIRE_WARD", "customemote", "surrounds themself in a protective aura against fire.")

-- ---------------------------------------------------------------------
-- PYROBLAST
-- ---------------------------------------------------------------------
add("PYROBLAST", "say", "Prepare for incineration!")
add("PYROBLAST", "say", "This will leave a mark!")

-- ---------------------------------------------------------------------
-- PYROBLAST
-- ---------------------------------------------------------------------
add("PYROBLAST", "customemote", "channels an immense fireball, ready to engulf {TARGET} in flames.")

-- ---------------------------------------------------------------------
-- SCORCH
-- ---------------------------------------------------------------------
add("SCORCH", "say", "A little warm-up before the real fire!")

-- ---------------------------------------------------------------------
-- SCORCH
-- ---------------------------------------------------------------------
add("SCORCH", "customemote", "sends a quick burst of fire at {TARGET}.")

-- ---------------------------------------------------------------------
-- BLAST_WAVE
-- ---------------------------------------------------------------------
add("BLAST_WAVE", "say", "Fire, expand!")
add("BLAST_WAVE", "say", "An explosion of pure heat!")

-- ---------------------------------------------------------------------
-- BLAST_WAVE
-- ---------------------------------------------------------------------
add("BLAST_WAVE", "customemote", "unleashes a wave of fire, knocking back nearby enemies.")

-- ---------------------------------------------------------------------
-- COMBUSTION
-- ---------------------------------------------------------------------
add("COMBUSTION", "say", "Now to turn up the heat!")
add("COMBUSTION", "say", "Unstoppable flames!")

-- ---------------------------------------------------------------------
-- COMBUSTION
-- ---------------------------------------------------------------------
add("COMBUSTION", "customemote", "focuses, causing {PP} spells to ignite with greater intensity.")

-- ---------------------------------------------------------------------
-- ICICLES
-- ---------------------------------------------------------------------
add("ICICLES", "say", "Frozen fury, unleashed!")
add("ICICLES", "say", "A storm of ice shall consume you!")

-- ---------------------------------------------------------------------
-- ICICLES
-- ---------------------------------------------------------------------
add("ICICLES", "customemote", "draws upon frost leylines, encasing themself in ice while launching deadly icicles at {TARGET}.")
