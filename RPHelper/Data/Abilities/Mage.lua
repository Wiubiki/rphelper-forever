-- RPHelper Forever - Mage ability content
-- Corpus migration from the RPhelper_twow Mage catalogue and original RoleplayingHelper lineage.
-- The legacy Mage source carried no named contributor attribution.

local A = RPHelper.Ability.MAGE
local C = RPHelper.Class.MAGE
local function add(id, ability, entryType, text)
    A[ability] = A[ability] or ability
    RPHelper.RegisterAbility(C, A[ability], { id = id, type = entryType, text = text })
end

-- =====================================================================
-- Arcane
-- =====================================================================

-- ---------------------------------------------------------------------
-- AMPLIFY_MAGIC
-- ---------------------------------------------------------------------
add("default:ability:mage:0002", "AMPLIFY_MAGIC", "say", "Power, intensified!")
add("default:ability:mage:0003", "AMPLIFY_MAGIC", "say", "Magic surges within me!")
add("default:ability:mage:0004", "AMPLIFY_MAGIC", "customemote", "channels energy, magnifying the magic around {PP}.")

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
add("default:ability:mage:0005", "ARCANE_BRILLIANCE", "say", "A gift of knowledge and strength!")
add("default:ability:mage:0006", "ARCANE_BRILLIANCE", "say", "Let wisdom and power flow through us!")
add("default:ability:mage:0007", "ARCANE_BRILLIANCE", "customemote", "bestows great magical insight upon {PP} allies.")

-- ---------------------------------------------------------------------
-- ARCANE_EXPLOSION
-- ---------------------------------------------------------------------
add("default:ability:mage:0008", "ARCANE_EXPLOSION", "say", "BOOM!")
add("default:ability:mage:0009", "ARCANE_EXPLOSION", "say", "Arcane energy, unleashed!")
add("default:ability:mage:0010", "ARCANE_EXPLOSION", "customemote", "releases a burst of raw arcane energy, striking all nearby foes.")

-- ---------------------------------------------------------------------
-- ARCANE_INTELLECT
-- ---------------------------------------------------------------------
add("default:ability:mage:0011", "ARCANE_INTELLECT", "say", "Knowledge is power, and I am overflowing!")
add("default:ability:mage:0012", "ARCANE_INTELLECT", "say", "A sharp mind is the greatest weapon.")
add("default:ability:mage:0013", "ARCANE_INTELLECT", "customemote", "channels arcane energy, sharpening {PP} intellect.")

-- ---------------------------------------------------------------------
-- ARCANE_MISSILES
-- ---------------------------------------------------------------------
add("default:ability:mage:0014", "ARCANE_MISSILES", "say", "A storm of arcane fury!")
add("default:ability:mage:0015", "ARCANE_MISSILES", "say", "Dodge this... if you can!")
add("default:ability:mage:0016", "ARCANE_MISSILES", "customemote", "unleashes a barrage of pure arcane energy at {TARGET}.")

-- ---------------------------------------------------------------------
-- ARCANE_POWER
-- ---------------------------------------------------------------------
add("default:ability:mage:0017", "ARCANE_POWER", "say", "Unlimited arcane might!")
add("default:ability:mage:0018", "ARCANE_POWER", "say", "Witness true magical destruction!")
add("default:ability:mage:0019", "ARCANE_POWER", "customemote", "glows with pure arcane energy, ready to unleash devastation.")

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
add("default:ability:mage:0020", "BLINK", "say", "Now you see me, now you don't!")
add("default:ability:mage:0021", "BLINK", "say", "A quick step through space and time!")
add("default:ability:mage:0022", "BLINK", "customemote", "disappears in a flash, reappearing a short distance away.")

-- ---------------------------------------------------------------------
-- CONJURE_FOOD
-- ---------------------------------------------------------------------
add("default:ability:mage:0023", "CONJURE_FOOD", "say", "A meal, courtesy of the arcane!")
add("default:ability:mage:0024", "CONJURE_FOOD", "customemote", "summons a feast from the ether.")

-- ---------------------------------------------------------------------
-- CONJURE_MANA_AGATE
-- ---------------------------------------------------------------------
add("default:ability:mage:0025", "CONJURE_MANA_AGATE", "say", "A small gem of energy, but still potent!")
add("default:ability:mage:0026", "CONJURE_MANA_AGATE", "customemote", "coalesces mana into a shimmering agate.")

-- ---------------------------------------------------------------------
-- CONJURE_MANA_CITRINE
-- ---------------------------------------------------------------------
add("default:ability:mage:0027", "CONJURE_MANA_CITRINE", "say", "A crystal of refined magical energy.")
add("default:ability:mage:0028", "CONJURE_MANA_CITRINE", "customemote", "crafts a gleaming citrine pulsating with mana.")

-- ---------------------------------------------------------------------
-- CONJURE_MANA_JADE
-- ---------------------------------------------------------------------
add("default:ability:mage:0029", "CONJURE_MANA_JADE", "say", "Mana condensed into a flawless jade.")
add("default:ability:mage:0030", "CONJURE_MANA_JADE", "customemote", "focuses intensely, forming a bright mana-infused jade.")

-- ---------------------------------------------------------------------
-- CONJURE_MANA_RUBY
-- ---------------------------------------------------------------------
add("default:ability:mage:0031", "CONJURE_MANA_RUBY", "say", "The pinnacle of conjured mana, a ruby of power!")
add("default:ability:mage:0032", "CONJURE_MANA_RUBY", "customemote", "forms a brilliant ruby, overflowing with mana.")

-- ---------------------------------------------------------------------
-- CONJURE_WATER
-- ---------------------------------------------------------------------
add("default:ability:mage:0033", "CONJURE_WATER", "say", "Water, summoned from the void!")
add("default:ability:mage:0034", "CONJURE_WATER", "customemote", "conjures fresh water out of thin air.")

-- ---------------------------------------------------------------------
-- COUNTERSPELL
-- ---------------------------------------------------------------------
add("default:ability:mage:0035", "COUNTERSPELL", "say", "Not today!")
add("default:ability:mage:0036", "COUNTERSPELL", "say", "Silence, fool!")
add("default:ability:mage:0037", "COUNTERSPELL", "customemote", "interrupts {TARGET}'s spell with a precise incantation.")

-- ---------------------------------------------------------------------
-- DAMPEN_MAGIC
-- ---------------------------------------------------------------------
add("default:ability:mage:0038", "DAMPEN_MAGIC", "say", "A little protection goes a long way.")
add("default:ability:mage:0039", "DAMPEN_MAGIC", "say", "Less magic, less pain!")
add("default:ability:mage:0040", "DAMPEN_MAGIC", "customemote", "envelops {PP} body in a shimmering barrier of magic.")

-- ---------------------------------------------------------------------
-- EVOCATION
-- ---------------------------------------------------------------------
add("default:ability:mage:0041", "EVOCATION", "say", "Arcane energy, restore me!")
add("default:ability:mage:0042", "EVOCATION", "say", "Mana flows through me once more!")
add("default:ability:mage:0043", "EVOCATION", "customemote", "closes {PP} eyes, drawing in pure magical essence.")

-- ---------------------------------------------------------------------
-- MAGE_ARMOR
-- ---------------------------------------------------------------------
add("default:ability:mage:0044", "MAGE_ARMOR", "say", "A mage’s best protection.")
add("default:ability:mage:0045", "MAGE_ARMOR", "say", "Woven magic, stronger than steel.")
add("default:ability:mage:0046", "MAGE_ARMOR", "customemote", "wraps themself in protective arcane energy.")

-- ---------------------------------------------------------------------
-- MANA_SHIELD
-- ---------------------------------------------------------------------
add("default:ability:mage:0047", "MANA_SHIELD", "say", "My magic, my shield!")
add("default:ability:mage:0048", "MANA_SHIELD", "say", "Try breaking through this!")
add("default:ability:mage:0049", "MANA_SHIELD", "customemote", "surrounds {PP} body with a glowing, protective barrier.")

-- ---------------------------------------------------------------------
-- POLYMORPH
-- ---------------------------------------------------------------------
add("default:ability:mage:0050", "POLYMORPH", "say", "Enjoy your new form, {TARGET}!")
add("default:ability:mage:0051", "POLYMORPH", "say", "And now, a little transformation!")
add("default:ability:mage:0052", "POLYMORPH", "customemote", "waves a hand, transforming {TARGET} into a harmless critter.")

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
add("default:ability:mage:0053", "PORTAL_DARNASSUS", "say", "Darnassus is but a step away!")
add("default:ability:mage:0054", "PORTAL_DARNASSUS", "customemote", "forms a glowing entrance to Darnassus.")

-- ---------------------------------------------------------------------
-- PORTAL_IRONFORGE
-- ---------------------------------------------------------------------
add("default:ability:mage:0055", "PORTAL_IRONFORGE", "say", "Portal to Ironforge, step right through!")
add("default:ability:mage:0056", "PORTAL_IRONFORGE", "customemote", "weaves a persistent portal to Ironforge.")

-- ---------------------------------------------------------------------
-- PORTAL_ORGRIMMAR
-- ---------------------------------------------------------------------
add("default:ability:mage:0057", "PORTAL_ORGRIMMAR", "say", "A portal to Orgrimmar stands ready!")
add("default:ability:mage:0058", "PORTAL_ORGRIMMAR", "customemote", "crafts a swirling entrance to Orgrimmar.")

-- ---------------------------------------------------------------------
-- PORTAL_STORMWIND
-- ---------------------------------------------------------------------
add("default:ability:mage:0059", "PORTAL_STORMWIND", "say", "A gateway to Stormwind is now open!")
add("default:ability:mage:0060", "PORTAL_STORMWIND", "customemote", "establishes a stable portal to Stormwind.")

-- ---------------------------------------------------------------------
-- PORTAL_THUNDER_BLUFF
-- ---------------------------------------------------------------------
add("default:ability:mage:0061", "PORTAL_THUNDER_BLUFF", "say", "Thunder Bluff, now accessible!")
add("default:ability:mage:0062", "PORTAL_THUNDER_BLUFF", "customemote", "summons a steady portal to Thunder Bluff.")

-- ---------------------------------------------------------------------
-- PORTAL_UNDERCITY
-- ---------------------------------------------------------------------
add("default:ability:mage:0063", "PORTAL_UNDERCITY", "say", "Step through to Undercity!")
add("default:ability:mage:0064", "PORTAL_UNDERCITY", "customemote", "weaves a dark-hued portal to Undercity.")

-- ---------------------------------------------------------------------
-- PRESENCE_OF_MIND
-- ---------------------------------------------------------------------
add("default:ability:mage:0065", "PRESENCE_OF_MIND", "say", "Absolute clarity of thought!")
add("default:ability:mage:0066", "PRESENCE_OF_MIND", "say", "Now, let’s cast with no hesitation!")
add("default:ability:mage:0067", "PRESENCE_OF_MIND", "customemote", "calms {PP} mind, readying for an instant cast.")

-- ---------------------------------------------------------------------
-- REMOVE_LESSER_CURSE
-- ---------------------------------------------------------------------
add("default:ability:mage:0068", "REMOVE_LESSER_CURSE", "say", "Begone, dark magic!")
add("default:ability:mage:0069", "REMOVE_LESSER_CURSE", "say", "No curse can withstand my power!")
add("default:ability:mage:0070", "REMOVE_LESSER_CURSE", "customemote", "chants an incantation, dispelling a minor curse.")

-- ---------------------------------------------------------------------
-- SLOW_FALL
-- ---------------------------------------------------------------------
add("default:ability:mage:0071", "SLOW_FALL", "say", "Float like a feather, land like a dream!")
add("default:ability:mage:0072", "SLOW_FALL", "say", "Defying gravity, one spell at a time.")
add("default:ability:mage:0073", "SLOW_FALL", "customemote", "casts a spell, allowing {PP} descent to become weightless.")

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
add("default:ability:mage:0074", "TELEPORT_DARNASSUS", "say", "A journey to the tranquil city of Darnassus!")
add("default:ability:mage:0075", "TELEPORT_DARNASSUS", "customemote", "channels magic to open a path to Darnassus.")

-- ---------------------------------------------------------------------
-- TELEPORT_IRONFORGE
-- ---------------------------------------------------------------------
add("default:ability:mage:0076", "TELEPORT_IRONFORGE", "say", "To Ironforge we go!")
add("default:ability:mage:0077", "TELEPORT_IRONFORGE", "customemote", "opens a shimmering portal to Ironforge.")

-- ---------------------------------------------------------------------
-- TELEPORT_ORGRIMMAR
-- ---------------------------------------------------------------------
add("default:ability:mage:0078", "TELEPORT_ORGRIMMAR", "say", "To the heart of the Horde, Orgrimmar!")
add("default:ability:mage:0079", "TELEPORT_ORGRIMMAR", "customemote", "conjures a swirling gateway to Orgrimmar.")

-- ---------------------------------------------------------------------
-- TELEPORT_STORMWIND
-- ---------------------------------------------------------------------
add("default:ability:mage:0080", "TELEPORT_STORMWIND", "say", "A quick trip to Stormwind!")
add("default:ability:mage:0081", "TELEPORT_STORMWIND", "customemote", "summons a glowing portal to Stormwind.")

-- ---------------------------------------------------------------------
-- TELEPORT_THUNDER_BLUFF
-- ---------------------------------------------------------------------
add("default:ability:mage:0082", "TELEPORT_THUNDER_BLUFF", "say", "To the mesas of Thunder Bluff!")
add("default:ability:mage:0083", "TELEPORT_THUNDER_BLUFF", "customemote", "calls forth a magical gateway to Thunder Bluff.")

-- ---------------------------------------------------------------------
-- TELEPORT_UNDERCITY
-- ---------------------------------------------------------------------
add("default:ability:mage:0084", "TELEPORT_UNDERCITY", "say", "Undercity awaits!")
add("default:ability:mage:0085", "TELEPORT_UNDERCITY", "customemote", "opens a dark-tinged portal to Undercity.")

-- =====================================================================
-- Fire
-- =====================================================================

-- ---------------------------------------------------------------------
-- BLAST_WAVE
-- ---------------------------------------------------------------------
add("default:ability:mage:0086", "BLAST_WAVE", "say", "Fire, expand!")
add("default:ability:mage:0087", "BLAST_WAVE", "say", "An explosion of pure heat!")
add("default:ability:mage:0088", "BLAST_WAVE", "customemote", "unleashes a wave of fire, knocking back nearby enemies.")

-- ---------------------------------------------------------------------
-- COMBUSTION
-- ---------------------------------------------------------------------
add("default:ability:mage:0089", "COMBUSTION", "say", "Now to turn up the heat!")
add("default:ability:mage:0090", "COMBUSTION", "say", "Unstoppable flames!")
add("default:ability:mage:0091", "COMBUSTION", "customemote", "focuses, causing {PP} spells to ignite with greater intensity.")

-- ---------------------------------------------------------------------
-- FIRE_BLAST
-- ---------------------------------------------------------------------
add("default:ability:mage:0092", "FIRE_BLAST", "say", "Instant combustion!")
add("default:ability:mage:0093", "FIRE_BLAST", "say", "Feel the heat!")
add("default:ability:mage:0094", "FIRE_BLAST", "customemote", "releases a sudden burst of flame at {TARGET}.")

-- ---------------------------------------------------------------------
-- FIRE_WARD
-- ---------------------------------------------------------------------
add("default:ability:mage:0095", "FIRE_WARD", "say", "Flames cannot touch me!")
add("default:ability:mage:0096", "FIRE_WARD", "customemote", "surrounds themself in a protective aura against fire.")

-- ---------------------------------------------------------------------
-- FIREBALL
-- ---------------------------------------------------------------------
add("default:ability:mage:0097", "FIREBALL", "say", "Burn!")
add("default:ability:mage:0098", "FIREBALL", "say", "A sphere of destruction, just for you!")
add("default:ability:mage:0099", "FIREBALL", "customemote", "hurls a massive fireball at {TARGET}.")

-- ---------------------------------------------------------------------
-- FLAMESTRIKE
-- ---------------------------------------------------------------------
add("default:ability:mage:0100", "FLAMESTRIKE", "say", "Rain of fire!")
add("default:ability:mage:0101", "FLAMESTRIKE", "say", "Let the ground burn beneath you!")
add("default:ability:mage:0102", "FLAMESTRIKE", "customemote", "calls down a pillar of fire upon {TARGET}'s location.")

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
add("default:ability:mage:0103", "PYROBLAST", "say", "Prepare for incineration!")
add("default:ability:mage:0104", "PYROBLAST", "say", "This will leave a mark!")
add("default:ability:mage:0105", "PYROBLAST", "customemote", "channels an immense fireball, ready to engulf {TARGET} in flames.")

-- ---------------------------------------------------------------------
-- SCORCH
-- ---------------------------------------------------------------------
add("default:ability:mage:0106", "SCORCH", "say", "A little warm-up before the real fire!")
add("default:ability:mage:0107", "SCORCH", "customemote", "sends a quick burst of fire at {TARGET}.")

-- =====================================================================
-- Frost
-- =====================================================================

-- ---------------------------------------------------------------------
-- BLIZZARD
-- ---------------------------------------------------------------------
add("default:ability:mage:0108", "BLIZZARD", "say", "Let the storm rage on!")
add("default:ability:mage:0109", "BLIZZARD", "say", "A flurry of ice to freeze my foes!")
add("default:ability:mage:0110", "BLIZZARD", "customemote", "calls forth an icy storm, engulfing the battlefield in snow and hail.")

-- ---------------------------------------------------------------------
-- COLD_SNAP
-- ---------------------------------------------------------------------
add("default:ability:mage:0111", "COLD_SNAP", "say", "Winter’s bite, renewed!")
add("default:ability:mage:0112", "COLD_SNAP", "customemote", "channels the cold, instantly resetting {PP} frost magic.")

-- ---------------------------------------------------------------------
-- CONE_OF_COLD
-- ---------------------------------------------------------------------
add("default:ability:mage:0113", "CONE_OF_COLD", "say", "A breath of winter’s fury!")
add("default:ability:mage:0114", "CONE_OF_COLD", "customemote", "unleashes a freezing gust, chilling all in its path.")

-- ---------------------------------------------------------------------
-- FROST_ARMOR
-- ---------------------------------------------------------------------
add("default:ability:mage:0115", "FROST_ARMOR", "say", "A layer of frost, my perfect defense!")
add("default:ability:mage:0116", "FROST_ARMOR", "customemote", "coats themself in a protective layer of frost.")

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
add("default:ability:mage:0117", "FROST_NOVA", "say", "Freeze where you stand!")
add("default:ability:mage:0118", "FROST_NOVA", "customemote", "unleashes a freezing pulse, rooting all nearby foes in place.")

-- ---------------------------------------------------------------------
-- FROST_WARD
-- ---------------------------------------------------------------------
add("default:ability:mage:0119", "FROST_WARD", "say", "Frost cannot harm one who wields it!")
add("default:ability:mage:0120", "FROST_WARD", "customemote", "shields themself against incoming frost magic.")

-- ---------------------------------------------------------------------
-- FROSTBOLT
-- ---------------------------------------------------------------------
add("default:ability:mage:0121", "FROSTBOLT", "say", "Cold and sharp, just like my wit!")
add("default:ability:mage:0122", "FROSTBOLT", "say", "A chill runs down your spine... literally!")
add("default:ability:mage:0123", "FROSTBOLT", "customemote", "hurls a shard of ice toward {TARGET}.")

-- ---------------------------------------------------------------------
-- ICE_ARMOR
-- ---------------------------------------------------------------------
add("default:ability:mage:0124", "ICE_ARMOR", "say", "Frozen and fortified!")
add("default:ability:mage:0125", "ICE_ARMOR", "customemote", "encases themself in a thick sheet of enchanted ice.")

-- ---------------------------------------------------------------------
-- ICE_BARRIER
-- ---------------------------------------------------------------------
add("default:ability:mage:0126", "ICE_BARRIER", "say", "Try breaking through this!")
add("default:ability:mage:0127", "ICE_BARRIER", "customemote", "summons a thick shield of ice to absorb incoming damage.")

-- ---------------------------------------------------------------------
-- ICE_BLOCK
-- ---------------------------------------------------------------------
add("default:ability:mage:0128", "ICE_BLOCK", "say", "Encased in ice, untouchable!")
add("default:ability:mage:0129", "ICE_BLOCK", "customemote", "freezes solid, becoming immune to attacks.")

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
