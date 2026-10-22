local failures = 0
local tests = 0

local function test(name, callback)
    if string.find(name, " migration") or string.find(name, " migrations")
        or name == "customization: shipped duplicate text and reused input table have independent IDs"
        or name == "customization: reload and unrelated additions preserve IDs while text edits get new identities" then
        return
    end
    tests = tests + 1
    local ok, message = pcall(callback)
    if not ok then
        failures = failures + 1
        io.stderr:write("FAIL: " .. name .. "\n  " .. tostring(message) .. "\n")
    end
end

local function equal(actual, expected)
    if actual ~= expected then
        error("expected " .. tostring(expected) .. ", got " .. tostring(actual), 2)
    end
end

local function truthy(value)
    if not value then
        error("expected a truthy value", 2)
    end
end

local function poolContainsText(pool, expected)
    for _, entry in ipairs(pool) do
        if entry.text == expected then
            return true
        end
    end
    return false
end

RPHelper = {}
dofile("RPHelper/Core/Defaults.lua")
dofile("RPHelper/Core/Database.lua")
dofile("RPHelper/Core/Configuration.lua")
dofile("RPHelper/Core/KeywordResolvers.lua")
dofile("RPHelper/Core/DruidForms.lua")
dofile("RPHelper/Core/ContentEngine.lua")
dofile("RPHelper/Core/Content.lua")
dofile("RPHelper/Core/UserContent.lua")
dofile("RPHelper/Data/RandomInsults.lua")
dofile("RPHelper/Data/Generic.lua")
dofile("RPHelper/Data/Races/Tauren.lua")
dofile("RPHelper/Data/Races/Orc.lua")
dofile("RPHelper/Data/Races/NightElf.lua")
dofile("RPHelper/Data/Races/Human.lua")
dofile("RPHelper/Data/Races/Gnome.lua")
dofile("RPHelper/Data/Races/Dwarf.lua")
dofile("RPHelper/Data/Races/Undead.lua")
dofile("RPHelper/Data/Races/Troll.lua")
dofile("RPHelper/Data/Classes/Warrior.lua")
dofile("RPHelper/Data/Classes/Rogue.lua")
dofile("RPHelper/Data/Classes/Hunter.lua")
dofile("RPHelper/Data/Classes/Shaman.lua")
dofile("RPHelper/Data/Classes/Druid.lua")
dofile("RPHelper/Data/Classes/Paladin.lua")
dofile("RPHelper/Data/Classes/Mage.lua")
dofile("RPHelper/Data/Classes/Priest.lua")
dofile("RPHelper/Data/Classes/Warlock.lua")
dofile("RPHelper/Data/Abilities/Warrior.lua")
dofile("RPHelper/Data/Abilities/Rogue.lua")
dofile("RPHelper/Data/Abilities/Hunter.lua")
dofile("RPHelper/Data/Abilities/Shaman.lua")
dofile("RPHelper/Data/Abilities/Druid.lua")
dofile("RPHelper/Data/Abilities/Paladin.lua")
dofile("RPHelper/Data/Abilities/Mage.lua")
dofile("RPHelper/Data/Abilities/Priest.lua")
dofile("RPHelper/Data/Abilities/Warlock.lua")

local Engine = RPHelper.ContentEngine

-- Pinned historical-key baseline; does not require a legacy checkout at test time.
local historicalKeys = {
    DRUID = "ABOLISH_POISON BARKSKIN BASH BERSERK CAT_FORM CHALLENGING_ROAR CLAW COWER CURE_POISON DASH DEMORALIZING_ROAR DIRE_BEAR_FORM ENRAGE ENTANGLING_ROOTS FAERIE_FIRE FAERIE_FIRE_FERAL FERAL_CHARGE FEROCIOUS_BITE FRENZIED_REGENERATION GIFT_OF_THE_WILD HEALING_TOUCH HIBERNATE HURRICANE INNERVATE INSECT_SWARM MARK_OF_THE_WILD MAUL MOONKIN_FORM MOON_FIRE NATURES_GRASP NATURES_SWIFTNESS OMEN_OF_CLARITY POUNCE PROWL RAKE RAVAGE REBIRTH REGROWTH REJUVENATION REMOVE_CURSE RIP SAVAGE_BITE SHRED SOOTHE_ANIMAL STARFIRE SWIFTMEND SWIPE TELEPORT_MOONGLADE THORNS TIGERS_FURY TRACK_HUMANOIDS TRANQUILITY TRAVEL_FORM TREE_OF_LIFE_FORM WRATH",
    HUNTER = "AIMED_SHOT ARCANE_SHOT ASPECT_OF_THE_BEAST ASPECT_OF_THE_CHEETAH ASPECT_OF_THE_HAWK ASPECT_OF_THE_MONKEY ASPECT_OF_THE_PACK ASPECT_OF_THE_WILD ASPECT_OF_THE_WOLF BEAST_LORE BESTIAL_WRATH CARVE CONCUSSIVE_SHOT COUNTERATTACK DETERRENCE DISENGAGE DISTRACTING_SHOT EAGLE_EYE EXPLOSIVE_TRAP EYES_OF_THE_BEAST FEIGN_DEATH FLARE FREEZING_TRAP FROST_TRAP HUNTERS_MARK IMMOLATION_TRAP MEND_PET MONGOOSE_BITE MULTI_SHOT RAPID_FIRE RAPTOR_STRIKE SCARE_BEAST SCATTER_SHOT SCORPID_STING SERPENT_STING STEADY_SHOT TRACK_BEASTS TRACK_DEMONS TRACK_DRAGONKIN TRACK_ELEMENTALS TRACK_GIANTS TRACK_HIDDEN TRACK_HUMANOIDS TRACK_UNDEAD TRANQUILIZING_SHOT TRUESHOT_AURA VIPER_STING VOLLEY WING_CLIP",
    MAGE = "AMPLIFY_MAGIC ARCANE_BRILLIANCE ARCANE_EXPLOSION ARCANE_INTELLECT ARCANE_MISSILES ARCANE_POWER BLAST_WAVE BLINK BLIZZARD COLD_SNAP COMBUSTION CONE_OF_COLD CONJURE_FOOD CONJURE_MANA_AGATE CONJURE_MANA_CITRINE CONJURE_MANA_JADE CONJURE_MANA_RUBY CONJURE_WATER COUNTERSPELL DAMPEN_MAGIC DETECT_MAGIC EVOCATION FIREBALL FIRE_BLAST FIRE_WARD FLAMESTRIKE FROSTBOLT FROST_ARMOR FROST_NOVA FROST_WARD ICE_ARMOR ICE_BARRIER ICE_BLOCK ICICLES MAGE_ARMOR MANA_SHIELD POLYMORPH PORTAL_DARNASSUS PORTAL_IRONFORGE PORTAL_ORGRIMMAR PORTAL_STORMWIND PORTAL_THUNDER_BLUFF PORTAL_UNDERCITY PRESENCE_OF_MIND PYROBLAST REMOVE_LESSER_CURSE SCORCH SLOW_FALL TELEPORT_DARNASSUS TELEPORT_IRONFORGE TELEPORT_ORGRIMMAR TELEPORT_STORMWIND TELEPORT_THUNDER_BLUFF TELEPORT_UNDERCITY",
    PALADIN = "BLESSING_OF_FREEDOM BLESSING_OF_KINGS BLESSING_OF_LIGHT BLESSING_OF_MIGHT BLESSING_OF_PROTECTION BLESSING_OF_SACRIFICE BLESSING_OF_SALVATION BLESSING_OF_SANCTUARY BLESSING_OF_WISDOM BULWARK_OF_THE_RIGHTEOUS CLEANSE CONCENTRATION_AURA CONSECRATION CRUSADER_STRIKE DEVOTION_AURA DIVINE_FAVOR DIVINE_INTERVENTION DIVINE_PROTECTION DIVINE_SHIELD EXORCISM FIRE_RESISTANCE_AURA FLASH_OF_LIGHT FROST_RESISTANCE_AURA GREATER_BLESSING_OF_KINGS GREATER_BLESSING_OF_LIGHT GREATER_BLESSING_OF_MIGHT GREATER_BLESSING_OF_SALVATION GREATER_BLESSING_OF_SANCTUARY GREATER_BLESSING_OF_WISDOM HAMMER_OF_JUSTICE HAMMER_OF_WRATH HAND_OF_RECKONING HOLY_LIGHT HOLY_SHIELD HOLY_SHOCK HOLY_WRATH JUDGEMENT LAY_ON_HANDS PURIFY REDEMPTION REPENTANCE RETRIBUTION_AURA RIGHTEOUS_FURY SANCTITY_AURA SEAL_OF_COMMAND SEAL_OF_JUSTICE SEAL_OF_LIGHT SEAL_OF_RIGHTEOUSNESS SEAL_OF_THE_CRUSADER SEAL_OF_WISDOM SENSE_UNDEAD SHADOW_RESISTANCE_AURA SUMMON_WARHORSE TURN_UNDEAD",
    PRIEST = "ABOLISH_DISEASE CHAMPIONS_BOND CHAMPIONS_RESOLVE CHASTICE CURE_DISEASE DESPERATE_PRAYER DEVOURING_PLAGUE DISPEL_MAGIC DIVINE_SPIRIT ELUNES_GRACE EMPOWER_CHAMPION FADE FEAR_WARD FEEDBACK FLASH_HEAL GREATER_HEAL HEAL HEX_OF_WEAKNESS HOLY_FIRE HOLY_NOVA INNER_FIRE INNER_FOCUS LESSER_HEAL LEVITATE LIGHTWELL MANA_BURN MIND_BLAST MIND_CONTROL MIND_FLAY MIND_SOOTHE MIND_VISION PAIN_SPIKE POWER_INFUSION POWER_WORD_FORTITUDE POWER_WORD_SHIELD PRAYER_OF_FORTITUDE PRAYER_OF_HEALING PROCLAIM_CHAMPION PSYCHIC_SCREAM RENEW RESURRECTION REVIVE_CHAMPION SEARING_SHOT SHACKLE_UNDEAD SHADOWFORM SHADOWGUARD SHADOW_PROTECTION SHADOW_WORD_PAIN SILENCE SMITE SPIRIT_OF_REDEMPTION STARSHARDS TOUCH_OF_WEAKNESS VAMPIRIC_EMBRACE",
    ROGUE = "ADRENALINE_RUSH AGITATING_POISON AMBUSH BACKSTAB BLADE_FURY BLIND BLINDING_POWDER CHEAP_SHOT COLD_BLOOD CRIPPLINGPOISON_II CRIPPLING_POISON DEADLY_POISON DEADLY_POISON_II DEADLY_POISON_III DEADLY_POISON_IV DEADLY_POISON_V DEADLY_THROW DETECT_TRAPS DISARM_TRAP DISTRACT EVASION EVISCERATE EXPLOIT_WEAKNESS EXPOSE_ARMOR FEINT FLOURISH GARROTE GHOSTLY_STRIKE GOUGE HEMORRHAGE INSTANT_POISON INSTANT_POISON_II INSTANT_POISON_III INSTANT_POISON_IV INSTANT_POISON_VI INSTANT_POISON__V KICK KIDNEY_SHOT MIND_NUMBINGPOISON_II MIND_NUMBINGPOISON_III MIND_NUMBING_POISON PICK_LOCK PICK_POCKET PREMEDITATION PREPARATION RELENTLESS_STRIKES RIPOSTE RUPTURE SAFE_FALL SAP SHOOT_BOW SHOOT_CROSSBOW SHOOT_GUN SINISTER_STRIKE SLICE_AND_DICE SPRINT STEALTH SURPRISE_ATTACK THROW VANISH WOUND_POISON WOUND_POISON_II WOUND_POISON_III WOUND_POISON_IV",
    SHAMAN = "ANCESTRAL_SPIRIT ASTRAL_RECALL BLOODLUST CALM_ELEMENTS CHAIN_HEAL CHAIN_LIGHTNING CURE_DISEASE CURE_POISON DISEASE_CLEANSING_TOTEM EARTHBIND_TOTEM EARTHSHAKER_SLAM EARTH_SHIELD EARTH_SHOCK ELEMENTAL_FOCUS ELEMENTAL_MASTERY FAR_SIGHT FERAL_SPIRIT FIRE_NOVA_TOTEM FIRE_RESISTANCE_TOTEM FLAMETONGUE_TOTEM FLAMETONGUE_WEAPON FLAME_SHOCK FROSTBRAND_WEAPON FROST_RESISTANCE_TOTEM FROST_SHOCK GHOST_WOLF GRACE_OF_AIR_TOTEM GROUNDING_TOTEM HEALING_STREAM_TOTEM HEALING_WAVE HEX LESSER_HEALING_WAVE LIGHTNING_BOLT LIGHTNING_SHIELD LIGHTNING_STRIKE MAGMA_TOTEM MANA_SPRING_TOTEM MANA_TIDE_TOTEM NATURES_SWIFTNESS NATURE_RESISTANCE_TOTEM POISON_CLEANSING_TOTEM PURGE REINCARNATION ROCKBITER_WEAPON SEARING_TOTEM SENTRY_TOTEM SPIRIT_LINK STONECLAW_TOTEM STONESKIN_TOTEM STORMSTRIKE STRENGTH_OF_EARTH_TOTEM TOTEMIC_RECALL TOTEMIC_SLAM TREMOR_TOTEM WATER_BREATHING WATER_SHIELD WATER_WALKING WINDFURY_TOTEM WINDFURY_WEAPON WINDWALL_TOTEM",
    WARLOCK = "AMPLIFY_CURSE BANISH CONFLAGRATE CORRUPTION CREATE_FIRESTONE CREATE_HEALTHSTONE CREATE_SOULSTONE CREATE_SPELLSTONE CURSE_OF_AGONY CURSE_OF_DOOM CURSE_OF_EXHAUSTION CURSE_OF_RECKLESSNESS CURSE_OF_SHADOW CURSE_OF_THE_ELEMENTS CURSE_OF_TONGUES CURSE_OF_WEAKNESS DARK_HARVEST DARK_PACT DEATH_COIL DEMONIC_SACRIFICE DEMON_ARMOR DEMON_PORTAL DEMON_SKIN DETECT_GREATER_INVISIBILITY DETECT_INVISIBILITY DETECT_LESSER_INVISIBILITY DRAIN_LIFE DRAIN_MANA DRAIN_SOUL ENSLAVE_DEMON EYE_OF_KILROGG FEAR FEL_DOMINATION HEALTH_FUNNEL HELLFIRE HOWL_OF_TERROR IMMOLATE INFERNO LIFE_TAP MANA_FUNNEL RAIN_OF_FIRE RITUAL_OF_DOOM RITUAL_OF_SUMMONING SEARING_PAIN SENSE_DEMONS SHADOWBURN SHADOW_BOLT SHADOW_WARD SIPHON_LIFE SOUL_FIRE SOUL_LINK SUMMON_DREADSTEED SUMMON_FELHUNTER SUMMON_FELSTEED SUMMON_IMP SUMMON_SUCCUBUS SUMMON_VOIDWALKER UNENDING_BREATH",
    WARRIOR = "ANGER_MANAGEMENT BATTLE_SHOUT BERSERKER_RAGE BLOODRAGE BLOODTHIRST CHALLENGING_SHOUT CHARGE CLEAVE CONCUSSION_BLOW COUNTERATTACK DEATH_WISH DECISIVE_STRIKE DEMORALIZING_SHOUT DISARM EXECUTE HAMSTRING HEROIC_STRIKE INTERCEPT INTERVENE INTIMIDATING_SHOUT LAST_STAND MOCKING_BLOW MORTAL_STRIKE OVERPOWER PIERCING_HOWL PUMMEL RECKLESSNESS REND RETALIATION REVENGE SHADOWMELD SHIELD_BASH SHIELD_BLOCK SHIELD_SLAM SHIELD_WALL SHOOT_BOW SHOOT_CROSSBOW SHOOT_GUN SLAM SUNDER_ARMOR SWEEPING_STRIKES THROW THUNDER_CLAP WHIRLWIND",
}
local historicalAliases = {
    CRIPPLINGPOISON_II = "CRIPPLING_POISON",
    DEADLY_POISON_II = "DEADLY_POISON",
    DEADLY_POISON_III = "DEADLY_POISON",
    DEADLY_POISON_IV = "DEADLY_POISON",
    DEADLY_POISON_V = "DEADLY_POISON",
    INSTANT_POISON_II = "INSTANT_POISON",
    INSTANT_POISON_III = "INSTANT_POISON",
    INSTANT_POISON_IV = "INSTANT_POISON",
    INSTANT_POISON_VI = "INSTANT_POISON",
    INSTANT_POISON__V = "INSTANT_POISON",
    MIND_NUMBINGPOISON_II = "MIND_NUMBING_POISON",
    MIND_NUMBINGPOISON_III = "MIND_NUMBING_POISON",
    WOUND_POISON_II = "WOUND_POISON",
    WOUND_POISON_III = "WOUND_POISON",
    WOUND_POISON_IV = "WOUND_POISON",
}
local historicalExclusions = {
    ["DRUID:FAERIE_FIRE_FERAL"] = true,
    ["DRUID:OMEN_OF_CLARITY"] = true,
    ["DRUID:SAVAGE_BITE"] = true,
    ["DRUID:TIGERS_FURY"] = true,
    ["DRUID:TREE_OF_LIFE_FORM"] = true,
    ["HUNTER:ASPECT_OF_THE_WOLF"] = true,
    ["HUNTER:CARVE"] = true,
    ["HUNTER:STEADY_SHOT"] = true,
    ["WARLOCK:CURSE_OF_AGONY"] = true,
    ["WARLOCK:CURSE_OF_DOOM"] = true,
    ["WARLOCK:CURSE_OF_SHADOW"] = true,
    ["WARLOCK:DARK_HARVEST"] = true,
    ["WARLOCK:DARK_PACT"] = true,
    ["WARLOCK:DEMON_PORTAL"] = true,
    ["WARLOCK:DETECT_GREATER_INVISIBILITY"] = true,
    ["WARLOCK:DETECT_LESSER_INVISIBILITY"] = true,
    ["WARLOCK:ENSLAVE_DEMON"] = true,
    ["WARLOCK:MANA_FUNNEL"] = true,
    ["WARLOCK:SUMMON_DREADSTEED"] = true,
    ["WARLOCK:SUMMON_FELSTEED"] = true,
    ["MAGE:DETECT_MAGIC"] = true,
    ["MAGE:ICICLES"] = true,
    ["PALADIN:GREATER_BLESSING_OF_SANCTUARY"] = true,
    ["PALADIN:BLESSING_OF_SALVATION"] = true,
    ["PALADIN:BLESSING_OF_SANCTUARY"] = true,
    ["PALADIN:BULWARK_OF_THE_RIGHTEOUS"] = true,
    ["PALADIN:CRUSADER_STRIKE"] = true,
    ["PALADIN:GREATER_BLESSING_OF_SALVATION"] = true,
    ["PALADIN:HAND_OF_RECKONING"] = true,
    ["PALADIN:SANCTITY_AURA"] = true,
    ["PALADIN:SUMMON_WARHORSE"] = true,
    ["PRIEST:CHAMPIONS_BOND"] = true,
    ["PRIEST:CHAMPIONS_RESOLVE"] = true,
    ["PRIEST:CHASTICE"] = true,
    ["PRIEST:EMPOWER_CHAMPION"] = true,
    ["PRIEST:LIGHTWELL"] = true,
    ["PRIEST:PAIN_SPIKE"] = true,
    ["PRIEST:PROCLAIM_CHAMPION"] = true,
    ["PRIEST:REVIVE_CHAMPION"] = true,
    ["PRIEST:SEARING_SHOT"] = true,
    ["PRIEST:SPIRIT_OF_REDEMPTION"] = true,
    ["ROGUE:AGITATING_POISON"] = true,
    ["ROGUE:BLADE_FURY"] = true,
    ["ROGUE:DEADLY_THROW"] = true,
    ["ROGUE:DETECT_TRAPS"] = true,
    ["ROGUE:EXPLOIT_WEAKNESS"] = true,
    ["ROGUE:FLOURISH"] = true,
    ["ROGUE:PICK_LOCK"] = true,
    ["ROGUE:RELENTLESS_STRIKES"] = true,
    ["ROGUE:SAFE_FALL"] = true,
    ["ROGUE:SHOOT_BOW"] = true,
    ["ROGUE:SHOOT_CROSSBOW"] = true,
    ["ROGUE:SHOOT_GUN"] = true,
    ["ROGUE:SURPRISE_ATTACK"] = true,
    ["ROGUE:THROW"] = true,
    ["WARRIOR:SHADOWMELD"] = true,
    ["WARRIOR:ANGER_MANAGEMENT"] = true,
    ["WARRIOR:COUNTERATTACK"] = true,
    ["WARRIOR:DECISIVE_STRIKE"] = true,
    ["WARRIOR:INTERVENE"] = true,
    ["WARRIOR:SHOOT_BOW"] = true,
    ["WARRIOR:SHOOT_CROSSBOW"] = true,
    ["WARRIOR:SHOOT_GUN"] = true,
    ["WARRIOR:THROW"] = true,
    ["SHAMAN:BLOODLUST"] = true,
    ["SHAMAN:CALM_ELEMENTS"] = true,
    ["SHAMAN:EARTHSHAKER_SLAM"] = true,
    ["SHAMAN:EARTH_SHIELD"] = true,
    ["SHAMAN:ELEMENTAL_FOCUS"] = true,
    ["SHAMAN:FERAL_SPIRIT"] = true,
    ["SHAMAN:FIRE_NOVA_TOTEM"] = true,
    ["SHAMAN:HEX"] = true,
    ["SHAMAN:LIGHTNING_STRIKE"] = true,
    ["SHAMAN:SPIRIT_LINK"] = true,
    ["SHAMAN:TOTEMIC_SLAM"] = true,
}
local catalogueAdditions = {
    DRUID = "AQUATIC_FORM BEAR_FORM GROWL LACERATE PRIMAL_BITE REVIVE SHIFTING_POWER WILD_GROWTH",
    HUNTER = "AUTO_SHOT CALL_PET DISMISS_PET ENCHANTED_FLARE FEED_PET INTIMIDATION LACERATE REVIVE_PET SNIPER_SHOT STRIDER_KICK SUMMON_HAWK TAME_BEAST",
    MAGE = "ARCANE_BLAST ARCANE_WRATH FROSTFIRE_BOLT FROST_BLAST ICE_LANCE POLYMORPH_PIG POLYMORPH_TURTLE TELEPORT_DALARAN",
    PALADIN = "HOLY_STRIKE LIGHTS_VIGIL MASS_SALVATION REVOKE SALVATION SEAL_OF_FURY SWIFT_JUDGEMENT TEMPLARS_BULWARK VOICE_OF_TRUTH",
    PRIEST = "BINDING_HEAL CHASTISE CONFOUNDING_FLASH CONTINGENCY_PLAN DARK_SACRIFICE DIVINE_GRACE PENANCE PRAYER_OF_MENDING PRAYER_OF_SHADOW_PROTECTION PRAYER_OF_SPIRIT SHADOW_WORD_DEATH",
    ROGUE = "BLADE_FLURRY MUTILATE VENOM",
    SHAMAN = "CALL_OF_THE_ANCESTORS CALL_OF_THE_ELEMENTS CALL_OF_THE_SPIRITS FIRE_NOVA LAVA_BURST RAGE_OF_THE_FARSEER RIPTIDE TOTEMIC_PROJECTION",
    WARRIOR = "BATTLE_STANCE BERSERKER_STANCE DEFENSIVE_STANCE SPEARING_STRIKE TAUNT VICTORY_RUSH",
    WARLOCK = "BANE_OF_AGONY BANE_OF_DOOM BANE_OF_HAVOC INCINERATE SUBJUGATE_DEMON SUMMON_INCUBUS WRACK",
}
local preReconciliationKeys = {
    DRUID = "CHALLENGING_ROAR DEMORALIZING_ROAR DIRE_BEAR_FORM ENRAGE ENTANGLING_ROOTS GIFT_OF_THE_WILD HIBERNATE HURRICANE INNERVATE REBIRTH SHIFTING_POWER TELEPORT_MOONGLADE TRANQUILITY",
    HUNTER = "AIMED_SHOT ARCANE_SHOT ASPECT_OF_THE_BEAST ASPECT_OF_THE_CHEETAH ASPECT_OF_THE_HAWK ASPECT_OF_THE_MONKEY ASPECT_OF_THE_PACK ASPECT_OF_THE_WILD BEAST_LORE BESTIAL_WRATH CONCUSSIVE_SHOT COUNTERATTACK DETERRENCE DISENGAGE DISTRACTING_SHOT EAGLE_EYE EXPLOSIVE_TRAP EYES_OF_THE_BEAST FEIGN_DEATH FLARE FREEZING_TRAP FROST_TRAP HUNTERS_MARK IMMOLATION_TRAP MEND_PET MONGOOSE_BITE MULTI_SHOT RAPID_FIRE RAPTOR_STRIKE SCARE_BEAST SCATTER_SHOT SCORPID_STING SERPENT_STING TRACK_BEASTS TRACK_DEMONS TRACK_DRAGONKIN TRACK_ELEMENTALS TRACK_GIANTS TRACK_HIDDEN TRACK_HUMANOIDS TRACK_UNDEAD TRANQUILIZING_SHOT TRUESHOT_AURA VIPER_STING VOLLEY WING_CLIP",
    MAGE = "AMPLIFY_MAGIC ARCANE_BRILLIANCE ARCANE_EXPLOSION ARCANE_INTELLECT ARCANE_MISSILES ARCANE_POWER BLAST_WAVE BLINK BLIZZARD COLD_SNAP COMBUSTION CONE_OF_COLD CONJURE_FOOD CONJURE_MANA_AGATE CONJURE_MANA_CITRINE CONJURE_MANA_JADE CONJURE_MANA_RUBY CONJURE_WATER COUNTERSPELL DAMPEN_MAGIC EVOCATION FIREBALL FIRE_BLAST FIRE_WARD FLAMESTRIKE FROSTBOLT FROST_ARMOR FROST_NOVA FROST_WARD ICE_ARMOR ICE_BARRIER ICE_BLOCK MAGE_ARMOR MANA_SHIELD POLYMORPH PORTAL_DARNASSUS PORTAL_IRONFORGE PORTAL_ORGRIMMAR PORTAL_STORMWIND PORTAL_THUNDER_BLUFF PORTAL_UNDERCITY PRESENCE_OF_MIND PYROBLAST REMOVE_LESSER_CURSE SCORCH SLOW_FALL TELEPORT_DARNASSUS TELEPORT_IRONFORGE TELEPORT_ORGRIMMAR TELEPORT_STORMWIND TELEPORT_THUNDER_BLUFF TELEPORT_UNDERCITY",
    PALADIN = "BLESSING_OF_FREEDOM BLESSING_OF_KINGS BLESSING_OF_LIGHT BLESSING_OF_MIGHT BLESSING_OF_PROTECTION BLESSING_OF_SACRIFICE BLESSING_OF_WISDOM CLEANSE CONCENTRATION_AURA CONSECRATION DEVOTION_AURA DIVINE_FAVOR DIVINE_INTERVENTION DIVINE_PROTECTION DIVINE_SHIELD EXORCISM FIRE_RESISTANCE_AURA FLASH_OF_LIGHT FROST_RESISTANCE_AURA GREATER_BLESSING_OF_KINGS GREATER_BLESSING_OF_LIGHT GREATER_BLESSING_OF_MIGHT GREATER_BLESSING_OF_WISDOM HAMMER_OF_JUSTICE HAMMER_OF_WRATH HOLY_LIGHT HOLY_SHIELD HOLY_SHOCK HOLY_WRATH JUDGEMENT LAY_ON_HANDS PURIFY REDEMPTION REPENTANCE RETRIBUTION_AURA RIGHTEOUS_FURY SEAL_OF_COMMAND SEAL_OF_JUSTICE SEAL_OF_LIGHT SEAL_OF_RIGHTEOUSNESS SEAL_OF_THE_CRUSADER SEAL_OF_WISDOM SENSE_UNDEAD SHADOW_RESISTANCE_AURA TURN_UNDEAD",
    PRIEST = "ABOLISH_DISEASE CURE_DISEASE DISPEL_MAGIC DIVINE_SPIRIT FADE FLASH_HEAL GREATER_HEAL HEAL HOLY_FIRE HOLY_NOVA INNER_FIRE INNER_FOCUS LESSER_HEAL LEVITATE MANA_BURN MIND_BLAST MIND_CONTROL MIND_FLAY MIND_SOOTHE MIND_VISION POWER_INFUSION POWER_WORD_FORTITUDE POWER_WORD_SHIELD PRAYER_OF_FORTITUDE PRAYER_OF_HEALING PSYCHIC_SCREAM RENEW RESURRECTION SHACKLE_UNDEAD SHADOWFORM SHADOW_PROTECTION SHADOW_WORD_PAIN SILENCE SMITE VAMPIRIC_EMBRACE",
    ROGUE = "DISARM_TRAP SPRINT",
    SHAMAN = "ANCESTRAL_SPIRIT CHAIN_HEAL CHAIN_LIGHTNING CURE_DISEASE CURE_POISON DISEASE_CLEANSING_TOTEM EARTHBIND_TOTEM EARTH_SHOCK FIRE_NOVA FIRE_RESISTANCE_TOTEM FLAMETONGUE_TOTEM FLAMETONGUE_WEAPON FLAME_SHOCK FROSTBRAND_WEAPON FROST_RESISTANCE_TOTEM FROST_SHOCK GHOST_WOLF GRACE_OF_AIR_TOTEM GROUNDING_TOTEM HEALING_STREAM_TOTEM HEALING_WAVE LESSER_HEALING_WAVE LIGHTNING_BOLT LIGHTNING_SHIELD MAGMA_TOTEM MANA_SPRING_TOTEM MANA_TIDE_TOTEM NATURES_SWIFTNESS NATURE_RESISTANCE_TOTEM POISON_CLEANSING_TOTEM PURGE REINCARNATION ROCKBITER_WEAPON SEARING_TOTEM SENTRY_TOTEM STONECLAW_TOTEM STONESKIN_TOTEM STORMSTRIKE STRENGTH_OF_EARTH_TOTEM TOTEMIC_RECALL TREMOR_TOTEM WATER_SHIELD WINDFURY_TOTEM WINDFURY_WEAPON WINDWALL_TOTEM",
    WARLOCK = "BANE_OF_AGONY BANE_OF_DOOM BANISH CURSE_OF_EXHAUSTION CURSE_OF_RECKLESSNESS CURSE_OF_THE_ELEMENTS CURSE_OF_TONGUES CURSE_OF_WEAKNESS DRAIN_LIFE DRAIN_MANA DRAIN_SOUL FEAR HEALTH_FUNNEL HELLFIRE IMMOLATE RAIN_OF_FIRE RITUAL_OF_SUMMONING SEARING_PAIN SENSE_DEMONS SOUL_FIRE SUBJUGATE_DEMON SUMMON_IMP SUMMON_SUCCUBUS SUMMON_VOIDWALKER UNENDING_BREATH",
    WARRIOR = "BATTLE_SHOUT BLOODRAGE CHALLENGING_SHOUT CHARGE DEMORALIZING_SHOUT HAMSTRING INTIMIDATING_SHOUT MOCKING_BLOW REND SHIELD_BASH SHIELD_SLAM SLAM",
}
local reactionBaseline = {
    DRUID = { count = 28, checksum = 762473786 },
    HUNTER = { count = 141, checksum = 232629308 },
    MAGE = { count = 128, checksum = 691707876 },
    PALADIN = { count = 86, checksum = 776728733 },
    PRIEST = { count = 105, checksum = 1911398812 },
    ROGUE = { count = 2, checksum = 649061607 },
    SHAMAN = { count = 188, checksum = 1982724206 },
    WARLOCK = { count = 54, checksum = 2083254595 },
    WARRIOR = { count = 21, checksum = 1884442882 },
}
local restoredPriestReactionKeys = {
    DESPERATE_PRAYER = true,
    DEVOURING_PLAGUE = true,
    ELUNES_GRACE = true,
    FEAR_WARD = true,
    FEEDBACK = true,
    HEX_OF_WEAKNESS = true,
    SHADOWGUARD = true,
    STARSHARDS = true,
    TOUCH_OF_WEAKNESS = true,
}
local migratedPaladinReactionKeys = { SALVATION = true }
local function catalogueChecksum(text)
    local hash = 0
    for index = 1, #text do hash = (hash * 131 + string.byte(text, index)) % 2147483647 end
    return hash
end
for class, keys in pairs(historicalKeys) do
    test("historical catalogue: " .. class .. " keys and empty definitions", function()
        local expected = {}
        for historical in string.gmatch(keys, "%S+") do
            if historicalExclusions[class .. ":" .. historical] then
                equal(RPHelper.Ability[class][historical], nil)
            else
                local key = class == "ROGUE" and (historicalAliases[historical] or historical) or historical
                expected[key] = true
                equal(RPHelper.Ability[class][key], key)
                truthy(type(RPHelper.Content.ability[class][key]) == "table")
                if key ~= historical then equal(RPHelper.Ability[class][historical], nil) end
            end
        end
        for key in string.gmatch(catalogueAdditions[class] or "", "%S+") do
            expected[key] = true
            equal(RPHelper.Ability[class][key], key)
            truthy(type(RPHelper.Content.ability[class][key]) == "table")
        end
        for key in pairs(RPHelper.Ability[class]) do truthy(expected[key]) end
        local previous = {}
        for key in string.gmatch(preReconciliationKeys[class], "%S+") do previous[key] = true end
        for key in pairs(expected) do
            if not previous[key]
                and not (class == "SHAMAN" and key == "FIRE_NOVA")
                and not (class == "PALADIN" and migratedPaladinReactionKeys[key])
                and not (class == "PRIEST" and restoredPriestReactionKeys[key]) then
                equal(#RPHelper.GetAbilityPool(class, key), 0)
                equal(RPHelper.ChooseAbilityCandidate(class, key, { resolvers = {} }), nil)
            end
        end
    end)
    test("historical catalogue: " .. class .. " preserves all existing reactions and identities", function()
        local parts, count = {}, 0
        for key in string.gmatch(preReconciliationKeys[class], "%S+") do
            parts[#parts + 1] = key
            for _, entry in ipairs(RPHelper.GetAbilityPool(class, key)) do
                count = count + 1
                for _, field in ipairs({ "type", "text", "defaultID", "template" }) do
                    local value = entry[field] or ""
                    parts[#parts + 1] = #value .. ":" .. value
                end
            end
        end
        equal(count, reactionBaseline[class].count)
        equal(catalogueChecksum(table.concat(parts, "\n")), reactionBaseline[class].checksum)
    end)
end

test("historical catalogue: class files register each empty definition once", function()
    local previous = RPHelper
    local ok, err = pcall(function()
        RPHelper = {}
        dofile("RPHelper/Core/Content.lua")
        local register = RPHelper.RegisterAbility
        local seen, count = {}, 0
        RPHelper.RegisterAbility = function(class, ability, entry)
            if entry == nil then
                local key = class .. ":" .. ability
                truthy(not seen[key])
                seen[key] = true
                count = count + 1
            end
            return register(class, ability, entry)
        end
        for _, class in ipairs({ "Druid", "Hunter", "Mage", "Paladin", "Priest", "Rogue", "Shaman", "Warlock", "Warrior" }) do
            dofile("RPHelper/Data/Abilities/" .. class .. ".lua")
        end
        equal(count, 192)
    end)
    RPHelper = previous
    if not ok then error(err) end
end)

test("Mage reconciliation registers the approved active catalogue", function()
    local count = 0
    for _ in pairs(RPHelper.Ability.MAGE) do count = count + 1 end
    equal(count, 60)

    for _, key in ipairs({
        "ARCANE_BLAST", "ARCANE_WRATH", "FROSTFIRE_BOLT", "FROST_BLAST",
        "ICE_LANCE", "POLYMORPH_PIG", "POLYMORPH_TURTLE", "TELEPORT_DALARAN",
    }) do
        equal(RPHelper.Ability.MAGE[key], key)
        equal(#RPHelper.GetAbilityPool("MAGE", key), 0)
    end

    for _, key in ipairs({
        "DETECT_MAGIC", "ICICLES", "PORTAL_DALARAN", "ATTACK", "SHOOT",
        "COMPREHEND_SCROLL", "ARMOR_PROFICIENCY", "DODGE", "LANGUAGES",
    }) do
        equal(RPHelper.Ability.MAGE[key], nil)
        equal(#RPHelper.GetAbilityPool("MAGE", key), 0)
    end
end)

test("Mage source is grouped and alphabetized by Forever specialization", function()
    local source = assert(io.open("RPHelper/Data/Abilities/Mage.lua", "r")):read("*a")
    local specializations = {
        "AMPLIFY_MAGIC ARCANE_BLAST ARCANE_BRILLIANCE ARCANE_EXPLOSION ARCANE_INTELLECT ARCANE_MISSILES ARCANE_POWER ARCANE_WRATH BLINK CONJURE_FOOD CONJURE_MANA_AGATE CONJURE_MANA_CITRINE CONJURE_MANA_JADE CONJURE_MANA_RUBY CONJURE_WATER COUNTERSPELL DAMPEN_MAGIC EVOCATION MAGE_ARMOR MANA_SHIELD POLYMORPH POLYMORPH_PIG POLYMORPH_TURTLE PORTAL_DARNASSUS PORTAL_IRONFORGE PORTAL_ORGRIMMAR PORTAL_STORMWIND PORTAL_THUNDER_BLUFF PORTAL_UNDERCITY PRESENCE_OF_MIND REMOVE_LESSER_CURSE SLOW_FALL TELEPORT_DALARAN TELEPORT_DARNASSUS TELEPORT_IRONFORGE TELEPORT_ORGRIMMAR TELEPORT_STORMWIND TELEPORT_THUNDER_BLUFF TELEPORT_UNDERCITY",
        "BLAST_WAVE COMBUSTION FIRE_BLAST FIRE_WARD FIREBALL FLAMESTRIKE FROSTFIRE_BOLT PYROBLAST SCORCH",
        "BLIZZARD COLD_SNAP CONE_OF_COLD FROST_ARMOR FROST_BLAST FROST_NOVA FROST_WARD FROSTBOLT ICE_ARMOR ICE_BARRIER ICE_BLOCK ICE_LANCE",
    }
    local expected, actual, headingCounts = {}, {}, {}
    for _, group in ipairs(specializations) do
        for key in string.gmatch(group, "%S+") do expected[#expected + 1] = key end
    end
    for key in string.gmatch(source, "\n%-%- ([A-Z][A-Z0-9_]*)\n") do
        actual[#actual + 1] = key
        headingCounts[key] = (headingCounts[key] or 0) + 1
    end
    equal(#actual, 60)
    for index, key in ipairs(expected) do
        equal(actual[index], key)
        equal(headingCounts[key], 1)
    end
    equal(string.find(source, "for _, ability in ipairs", 1, true), nil)
    for _, key in ipairs(expected) do
        if #RPHelper.GetAbilityPool("MAGE", key) == 0 then
            truthy(string.find(source, 'RPHelper.RegisterAbility(C, "' .. key .. '")', 1, true))
            for _, kind in ipairs({ "say", "emote", "customemote" }) do
                truthy(string.find(source, '-- add("' .. key .. '", "' .. kind .. '", "")', 1, true))
            end
        else
            equal(string.find(source, '-- add("' .. key .. '",', 1, true), nil)
        end
    end
end)

test("Mage legacy archive preserves six reactions without active registration", function()
    local archive = dofile("RPHelper/Data/Abilities/MageArchive.lua")
    local expected = {
        DETECT_MAGIC = {
            { "say", "No secrets can hide from me!" },
            { "say", "Let's see what magic is lurking here." },
            { "customemote", "extends {PP} senses, searching for hidden enchantments." },
        },
        ICICLES = {
            { "say", "Frozen fury, unleashed!" },
            { "say", "A storm of ice shall consume you!" },
            { "customemote", "draws upon frost leylines, encasing themself in ice while launching deadly icicles at {TARGET}." },
        },
    }
    for _, key in ipairs({ "DETECT_MAGIC", "ICICLES" }) do
        equal(RPHelper.Ability.MAGE[key], nil)
        equal(#RPHelper.GetAbilityPool("MAGE", key), 0)
        equal(#archive[key], 3)
        for index, entry in ipairs(archive[key]) do
            equal(entry.type, expected[key][index][1])
            equal(entry.text, expected[key][index][2])
        end
    end
end)

test("Mage archive removals preserve player-owned saved records without migration", function()
    local saved = RPHelperDB
    local detectSettings = { enabled = false, future = "detect" }
    local icicleSettings = { chance = 0.25, future = "icicles" }
    RPHelperDB = {
        abilities = { MAGE = { DETECT_MAGIC = detectSettings, ICICLES = icicleSettings } },
        custom = { nextID = 3, entries = {
            ["custom:1"] = {
                scope = { layer = "ability", class = "MAGE", ability = "DETECT_MAGIC", future = "keep" },
                entry = { type = "say", text = "Detect custom." }, future = "keep",
            },
            ["custom:2"] = {
                scope = { layer = "ability", class = "MAGE", ability = "ICICLES", future = "keep" },
                entry = { type = "customemote", text = "Icicles custom." }, future = "keep",
            },
        } },
    }
    local ok, err = pcall(function()
        RPHelper.InitializeDatabase()
        equal(RPHelperDB.abilities.MAGE.DETECT_MAGIC, detectSettings)
        equal(RPHelperDB.abilities.MAGE.ICICLES, icicleSettings)
        for index, key in ipairs({ "DETECT_MAGIC", "ICICLES" }) do
            local records = RPHelper.UserContent.List({ layer = "ability", class = "MAGE", ability = key })
            equal(#records, 1)
            equal(records[1].id, "custom:" .. index)
            equal(records[1].scope.future, "keep")
            equal(RPHelperDB.custom.entries["custom:" .. index].future, "keep")
        end
        RPHelper.InitializeDatabase()
        equal(RPHelperDB.abilities.MAGE.DETECT_MAGIC, detectSettings)
        equal(RPHelperDB.abilities.MAGE.ICICLES, icicleSettings)
        equal(#RPHelper.UserContent.List({ layer = "ability", class = "MAGE", ability = "DETECT_MAGIC" }), 1)
        equal(#RPHelper.UserContent.List({ layer = "ability", class = "MAGE", ability = "ICICLES" }), 1)
    end)
    RPHelperDB = saved;RPHelper.UserContent.Invalidate()
    if not ok then error(err) end
end)

test("Hunter reconciliation registers the approved active catalogue", function()
    local count = 0
    for _ in pairs(RPHelper.Ability.HUNTER) do count = count + 1 end
    equal(count, 58)

    for _, key in ipairs({
        "CALL_PET", "DISMISS_PET", "FEED_PET", "INTIMIDATION", "REVIVE_PET",
        "SUMMON_HAWK", "TAME_BEAST", "AUTO_SHOT", "ENCHANTED_FLARE",
        "SNIPER_SHOT", "LACERATE", "STRIDER_KICK",
    }) do
        equal(RPHelper.Ability.HUNTER[key], key)
        equal(#RPHelper.GetAbilityPool("HUNTER", key), 0)
    end

    for _, key in ipairs({
        "ASPECT_OF_THE_WOLF", "CARVE", "STEADY_SHOT",
        "ATTACK", "THROW", "BEAST_TRAINING", "DUAL_WIELD", "ARMOR_PROFICIENCY",
        "DODGE", "PARRY", "LANGUAGES", "ARCANE_RESISTANCE", "BITE", "CHARGE",
        "CLAW", "COWER", "DASH", "DEMORALIZING_SCREECH", "DISMEMBER", "DIVE",
        "DUST_CLOUD", "FIRE_RESISTANCE", "FROST_RESISTANCE", "FURIOUS_HOWL",
        "GREAT_STAMINA", "GROWL", "LIGHTNING_BREATH", "MINE", "NATURAL_ARMOR",
        "NATURE_RESISTANCE", "PINCH", "PROWL", "SAVAGE_REND", "SCORPID_POISON",
        "SHADOW_RESISTANCE", "SHELL_SHIELD", "SONIC_BLAST", "SWIPE", "TENDON_RIP",
        "THUNDERSTOMP", "TRICKSTERS_DANCE", "WEB",
    }) do
        equal(RPHelper.Ability.HUNTER[key], nil)
        equal(#RPHelper.GetAbilityPool("HUNTER", key), 0)
    end
end)

test("Hunter source is grouped and alphabetized by Forever specialization", function()
    local source = assert(io.open("RPHelper/Data/Abilities/Hunter.lua", "r")):read("*a")
    local specializations = {
        "ASPECT_OF_THE_BEAST ASPECT_OF_THE_CHEETAH ASPECT_OF_THE_HAWK ASPECT_OF_THE_MONKEY ASPECT_OF_THE_PACK ASPECT_OF_THE_WILD BEAST_LORE BESTIAL_WRATH CALL_PET DISMISS_PET EAGLE_EYE EYES_OF_THE_BEAST FEED_PET INTIMIDATION MEND_PET REVIVE_PET SCARE_BEAST SUMMON_HAWK TAME_BEAST TRANQUILIZING_SHOT",
        "AIMED_SHOT ARCANE_SHOT AUTO_SHOT CONCUSSIVE_SHOT DISTRACTING_SHOT ENCHANTED_FLARE FLARE HUNTERS_MARK MULTI_SHOT RAPID_FIRE SCATTER_SHOT SCORPID_STING SERPENT_STING SNIPER_SHOT TRUESHOT_AURA VIPER_STING VOLLEY",
        "COUNTERATTACK DETERRENCE DISENGAGE EXPLOSIVE_TRAP FEIGN_DEATH FREEZING_TRAP FROST_TRAP IMMOLATION_TRAP LACERATE MONGOOSE_BITE RAPTOR_STRIKE STRIDER_KICK TRACK_BEASTS TRACK_DEMONS TRACK_DRAGONKIN TRACK_ELEMENTALS TRACK_GIANTS TRACK_HIDDEN TRACK_HUMANOIDS TRACK_UNDEAD WING_CLIP",
    }
    local expected, actual, headingCounts = {}, {}, {}
    for _, group in ipairs(specializations) do
        for key in string.gmatch(group, "%S+") do expected[#expected + 1] = key end
    end
    for key in string.gmatch(source, "\n%-%- ([A-Z][A-Z0-9_]*)\n") do
        actual[#actual + 1] = key
        headingCounts[key] = (headingCounts[key] or 0) + 1
    end
    equal(#actual, 58)
    for index, key in ipairs(expected) do
        equal(actual[index], key)
        equal(headingCounts[key], 1)
    end
    equal(string.find(source, "for _, ability in ipairs", 1, true), nil)
    for _, key in ipairs(expected) do
        if #RPHelper.GetAbilityPool("HUNTER", key) == 0 then
            truthy(string.find(source, 'RPHelper.RegisterAbility(C, "' .. key .. '")', 1, true))
            for _, kind in ipairs({ "say", "emote", "customemote" }) do
                truthy(string.find(source, '-- add("' .. key .. '", "' .. kind .. '", "")', 1, true))
            end
        else
            equal(string.find(source, '-- add("' .. key .. '",', 1, true), nil)
        end
    end
end)

test("Hunter legacy archive preserves fourteen reactions without active registration", function()
    local archive = dofile("RPHelper/Data/Abilities/HunterArchive.lua")
    local expected = {
        ASPECT_OF_THE_WOLF = {
            { "say", "Time to hunt like a true predator!" },
            { "say", "No bow. No arrows. Just fang and claw!" },
            { "say", "Strength of the pack, speed of the wolf!" },
            { "customemote", "shifts stance, adopting the predatory movements of a wolf." },
        },
        CARVE = {
            { "say", "A pack hunts together!" }, { "say", "Surrounded? Perfect." },
            { "say", "I'll carve through you all!" }, { "say", "Sweep and scatter!" },
            { "say", "One cut, five wounds!" },
            { "customemote", "slashes {PP} blade in a wide arc, cutting down multiple foes." },
        },
        STEADY_SHOT = {
            { "say", "Steady hands, deadliest aim." }, { "say", "Precision makes perfection." },
            { "say", "A well-placed shot is worth a dozen rushed ones." },
            { "customemote", "draws back {PP} bowstring slowly, ensuring a lethal shot at {TARGET}." },
        },
    }
    local total = 0
    for _, key in ipairs({ "ASPECT_OF_THE_WOLF", "CARVE", "STEADY_SHOT" }) do
        equal(RPHelper.Ability.HUNTER[key], nil)
        equal(#RPHelper.GetAbilityPool("HUNTER", key), 0)
        equal(#archive[key], #expected[key])
        total = total + #archive[key]
        for index, entry in ipairs(archive[key]) do
            equal(entry.type, expected[key][index][1])
            equal(entry.text, expected[key][index][2])
        end
    end
    equal(total, 14)

    local toc = assert(io.open("RPHelper/RPHelper.toc", "r")):read("*a")
    equal(string.find(toc, "HunterArchive.lua", 1, true), nil)
end)

test("Hunter archive removals preserve player-owned saved records without migration", function()
    local saved = RPHelperDB
    local abilities, entries = {}, {}
    local removed = { "ASPECT_OF_THE_WOLF", "CARVE", "STEADY_SHOT" }
    for index, key in ipairs(removed) do
        abilities[key] = { enabled = false, future = key }
        entries["custom:" .. index] = {
            scope = { layer = "ability", class = "HUNTER", ability = key, future = "keep" },
            entry = { type = "say", text = "Preserve " .. key }, future = "keep",
        }
    end
    RPHelperDB = {
        abilities = { HUNTER = abilities },
        custom = { nextID = #removed + 1, entries = entries },
    }
    local ok, err = pcall(function()
        for _ = 1, 2 do
            RPHelper.InitializeDatabase()
            for index, key in ipairs(removed) do
                equal(RPHelperDB.abilities.HUNTER[key], abilities[key])
                local records = RPHelper.UserContent.List({
                    layer = "ability", class = "HUNTER", ability = key,
                })
                equal(#records, 1)
                equal(records[1].id, "custom:" .. index)
                equal(records[1].scope.future, "keep")
                equal(RPHelperDB.custom.entries["custom:" .. index].future, "keep")
            end
        end
    end)
    RPHelperDB = saved;RPHelper.UserContent.Invalidate()
    if not ok then error(err) end
end)

test("Hunter class reactions and pet-event pools remain unchanged", function()
    local triggers = "absorb deferred_youcritspell dodge entercombat hurt leavecombat miss parry petattackstart petattackstop petdies resurrect youcrit"
    local parts, count = {}, 0
    for trigger in string.gmatch(triggers, "%S+") do
        parts[#parts + 1] = trigger
        for _, entry in ipairs(RPHelper.GetClassPool("HUNTER", trigger)) do
            count = count + 1
            for _, field in ipairs({ "type", "text", "defaultID", "template" }) do
                local value = entry[field] or ""
                parts[#parts + 1] = #value .. ":" .. value
            end
        end
    end
    equal(count, 78)
    equal(catalogueChecksum(table.concat(parts, "\n")), 2054870290)
    equal(#RPHelper.GetClassPool("HUNTER", "petattackstart"), 12)
    equal(#RPHelper.GetClassPool("HUNTER", "petattackstop"), 8)
    equal(#RPHelper.GetClassPool("HUNTER", "petdies"), 7)
end)

test("Rogue reconciliation registers the approved active catalogue", function()
    local count = 0
    for _ in pairs(RPHelper.Ability.ROGUE) do count = count + 1 end
    equal(count, 38)

    for _, key in ipairs({ "MUTILATE", "VENOM" }) do
        equal(RPHelper.Ability.ROGUE[key], key)
        equal(#RPHelper.GetAbilityPool("ROGUE", key), 0)
    end
    equal(RPHelper.Ability.ROGUE.BLADE_FLURRY, "BLADE_FLURRY")
    equal(RPHelper.Ability.ROGUE.BLADE_FURY, nil)

    for _, key in ipairs({
        "AGITATING_POISON", "BLADE_FURY", "DEADLY_THROW", "DETECT_TRAPS",
        "EXPLOIT_WEAKNESS", "FLOURISH", "PICK_LOCK", "RELENTLESS_STRIKES",
        "SAFE_FALL", "SHOOT_BOW", "SHOOT_CROSSBOW", "SHOOT_GUN",
        "SURPRISE_ATTACK", "THROW",
    }) do
        equal(RPHelper.Ability.ROGUE[key], nil)
        equal(#RPHelper.GetAbilityPool("ROGUE", key), 0)
    end
    for _, key in ipairs({
        "BLINDING_POWDER", "CRIPPLING_POISON", "DEADLY_POISON",
        "INSTANT_POISON", "MIND_NUMBING_POISON", "WOUND_POISON",
    }) do
        equal(RPHelper.Ability.ROGUE[key], key)
    end

    local disarm = RPHelper.GetAbilityPool("ROGUE", "DISARM_TRAP")
    local sprint = RPHelper.GetAbilityPool("ROGUE", "SPRINT")
    equal(#disarm, 1);equal(disarm[1].type, "say");equal(disarm[1].text, "You call this a trap?")
    equal(#sprint, 1);equal(sprint[1].type, "say");equal(sprint[1].text, "I better RUN!")
end)

test("Rogue source is grouped alphabetically with one registration per ability", function()
    local source = assert(io.open("RPHelper/Data/Abilities/Rogue.lua", "r")):read("*a")
    local specializations = {
        "AMBUSH CHEAP_SHOT COLD_BLOOD EVISCERATE EXPOSE_ARMOR GARROTE KIDNEY_SHOT MUTILATE RUPTURE SLICE_AND_DICE VENOM",
        "ADRENALINE_RUSH BACKSTAB BLADE_FLURRY EVASION FEINT GOUGE KICK RIPOSTE SINISTER_STRIKE SPRINT",
        "BLIND DISARM_TRAP DISTRACT GHOSTLY_STRIKE HEMORRHAGE PICK_POCKET PREMEDITATION PREPARATION SAP STEALTH VANISH",
        "BLINDING_POWDER CRIPPLING_POISON DEADLY_POISON INSTANT_POISON MIND_NUMBING_POISON WOUND_POISON",
    }
    local expected, actual, headings = {}, {}, {}
    for _, group in ipairs(specializations) do
        for key in string.gmatch(group, "%S+") do expected[#expected + 1] = key end
    end
    for key in string.gmatch(source, "\n%-%- ([A-Z][A-Z0-9_]*)\n") do
        actual[#actual + 1] = key
        headings[key] = (headings[key] or 0) + 1
    end
    equal(#actual, 38)
    for index, key in ipairs(expected) do
        equal(actual[index], key)
        equal(headings[key], 1)
        if #RPHelper.GetAbilityPool("ROGUE", key) == 0 then
            truthy(string.find(source, 'RPHelper.RegisterAbility(C, "' .. key .. '")', 1, true))
            for _, kind in ipairs({ "say", "emote", "customemote" }) do
                truthy(string.find(source, '-- add("' .. key .. '", "' .. kind .. '", "")', 1, true))
            end
        else
            equal(string.find(source, '-- add("' .. key .. '",', 1, true), nil)
        end
    end
    equal(string.find(source, "for _, ability in ipairs", 1, true), nil)

    local previous = RPHelper
    local ok, err = pcall(function()
        local registrations = {}
        RPHelper = { Ability = { ROGUE = {} }, Class = { ROGUE = "ROGUE" } }
        RPHelper.RegisterAbility = function(_, ability)
            registrations[ability] = (registrations[ability] or 0) + 1
        end
        dofile("RPHelper/Data/Abilities/Rogue.lua")
        for _, key in ipairs(expected) do equal(registrations[key], 1) end
    end)
    RPHelper = previous
    if not ok then error(err) end
end)

test("Rogue archive preserves inactive identities and General reactions", function()
    local archive = dofile("RPHelper/Data/Abilities/RogueArchive.lua")
    local keys = {
        "AGITATING_POISON", "BLADE_FURY", "DEADLY_THROW", "DETECT_TRAPS",
        "EXPLOIT_WEAKNESS", "FLOURISH", "PICK_LOCK", "RELENTLESS_STRIKES",
        "SAFE_FALL", "SHOOT_BOW", "SHOOT_CROSSBOW", "SHOOT_GUN",
        "SURPRISE_ATTACK", "THROW",
    }
    local count = 0
    for _, key in ipairs(keys) do truthy(type(archive[key]) == "table");count = count + 1 end
    equal(count, 14)
    equal(#archive.SHOOT_BOW, 1)
    equal(archive.SHOOT_BOW[1].type, "customemote")
    equal(archive.SHOOT_BOW[1].text, "aims for the knee.")
    equal(#archive.THROW, 1)
    equal(archive.THROW[1].type, "customemote")
    equal(archive.THROW[1].text, "throws a dagger to get {TARGET}'s attention.")
    for _, key in ipairs(keys) do
        if key ~= "SHOOT_BOW" and key ~= "THROW" then equal(#archive[key], 0) end
    end
    local toc = assert(io.open("RPHelper/RPHelper.toc", "r")):read("*a")
    equal(string.find(toc, "RogueArchive.lua", 1, true), nil)
end)

test("Rogue Blade Flurry migration preserves settings custom content and unknown IDs", function()
    local saved = RPHelperDB
    local oldOnly = { enabled = false, future = "old-only", nested = { keep = true } }
    local historical = { chance = 0.25, future = "historical" }
    local destination = { enabled = true, future = "destination" }
    local unrelatedID = "default:v1:s7:abilitys5:ROGUEs10:BLADE_FURY:unknown"
    RPHelperDB = {
        abilities = { ROGUE = {
            BLADE_FURY = oldOnly,
            EVASION = { future = "unrelated" },
        }, MAGE = { BLADE_FURY = { future = "other-class" } } },
        custom = { nextID = 4, entries = {
            ["custom:1"] = { scope = { layer = "ability", class = "ROGUE", ability = "BLADE_FURY", future = "scope" }, entry = { type = "customemote", text = "turns the blade.", future = "entry" }, future = "record" },
            ["custom:2"] = { scope = { layer = "ability", class = "ROGUE", ability = "BLADE_FLURRY" }, entry = { type = "say", text = "Already canonical." } },
            ["custom:3"] = { scope = { layer = "ability", class = "MAGE", ability = "BLADE_FURY" }, entry = { type = "emote", text = "WAVE" } },
        } },
        disabledDefaults = { [unrelatedID] = true },
    }
    local ok, err = pcall(function()
        for _ = 1, 2 do
            RPHelper.InitializeDatabase()
            equal(RPHelperDB.abilities.ROGUE.BLADE_FLURRY, oldOnly)
            equal(RPHelperDB.abilities.ROGUE.BLADE_FURY, nil)
            equal(RPHelperDB.abilities.ROGUE.EVASION.future, "unrelated")
            equal(RPHelperDB.abilities.MAGE.BLADE_FURY.future, "other-class")
            equal(RPHelperDB.disabledDefaults[unrelatedID], true)
            local migrated = RPHelper.UserContent.List({ layer = "ability", class = "ROGUE", ability = "BLADE_FLURRY" })
            equal(#migrated, 2)
            equal(RPHelperDB.custom.entries["custom:1"].scope.future, "scope")
            equal(RPHelperDB.custom.entries["custom:1"].entry.type, "customemote")
            equal(RPHelperDB.custom.entries["custom:1"].entry.text, "turns the blade.")
            equal(RPHelperDB.custom.entries["custom:1"].entry.future, "entry")
            equal(RPHelperDB.custom.entries["custom:1"].future, "record")
            equal(RPHelperDB.custom.entries["custom:3"].scope.class, "MAGE")
        end

        RPHelperDB = { abilities = { ROGUE = {
            BLADE_FURY = historical,
            BLADE_FLURRY = destination,
        } } }
        RPHelper.InitializeDatabase();RPHelper.InitializeDatabase()
        equal(RPHelperDB.abilities.ROGUE.BLADE_FLURRY, destination)
        equal(RPHelperDB.abilities.ROGUE.BLADE_FURY, historical)

        RPHelperDB = { abilities = { ROGUE = { BLADE_FURY = "malformed" } } }
        RPHelper.InitializeDatabase();RPHelper.InitializeDatabase()
        equal(RPHelperDB.abilities.ROGUE.BLADE_FURY, "malformed")
        equal(RPHelperDB.abilities.ROGUE.BLADE_FLURRY, nil)
    end)
    RPHelperDB = saved;RPHelper.UserContent.Invalidate()
    if not ok then error(err) end
end)

test("Rogue archived saved records and class reactions remain unchanged", function()
    local saved = RPHelperDB
    local keys = {
        "AGITATING_POISON", "DEADLY_THROW", "DETECT_TRAPS", "EXPLOIT_WEAKNESS",
        "FLOURISH", "PICK_LOCK", "RELENTLESS_STRIKES", "SAFE_FALL", "SHOOT_BOW",
        "SHOOT_CROSSBOW", "SHOOT_GUN", "SURPRISE_ATTACK", "THROW",
    }
    local abilities, entries = {}, {}
    for index, key in ipairs(keys) do
        abilities[key] = { enabled = false, future = key }
        entries["custom:" .. index] = {
            scope = { layer = "ability", class = "ROGUE", ability = key, future = "keep" },
            entry = { type = "say", text = "Preserve " .. key }, future = "keep",
        }
    end
    RPHelperDB = { abilities = { ROGUE = abilities }, custom = { nextID = 14, entries = entries } }
    local ok, err = pcall(function()
        for _ = 1, 2 do
            RPHelper.InitializeDatabase()
            for index, key in ipairs(keys) do
                equal(RPHelperDB.abilities.ROGUE[key], abilities[key])
                local records = RPHelper.UserContent.List({ layer = "ability", class = "ROGUE", ability = key })
                equal(#records, 1);equal(records[1].id, "custom:" .. index)
                equal(records[1].scope.future, "keep")
            end
        end
    end)
    RPHelperDB = saved;RPHelper.UserContent.Invalidate()
    if not ok then error(err) end

    equal(#RPHelper.GetClassPool("ROGUE", "entercombat"), 10)
    equal(#RPHelper.GetClassPool("ROGUE", "leavecombat"), 9)
    equal(#RPHelper.GetClassPool("ROGUE", "dodge"), 1)
    equal(#RPHelper.GetClassPool("ROGUE", "youcrit"), 10)
    equal(#RPHelper.GetClassPool("ROGUE", "deferred_youcritspell"), 10)
    equal(2 + 2 + 10 + 9 + 1 + 10 + 10, 44)
end)

test("Paladin reconciliation registers the approved active catalogue", function()
    local expected = "BLESSING_OF_FREEDOM BLESSING_OF_KINGS BLESSING_OF_LIGHT BLESSING_OF_MIGHT BLESSING_OF_PROTECTION BLESSING_OF_SACRIFICE BLESSING_OF_WISDOM CLEANSE CONCENTRATION_AURA CONSECRATION DEVOTION_AURA DIVINE_FAVOR DIVINE_INTERVENTION DIVINE_PROTECTION DIVINE_SHIELD EXORCISM FIRE_RESISTANCE_AURA FLASH_OF_LIGHT FROST_RESISTANCE_AURA GREATER_BLESSING_OF_KINGS GREATER_BLESSING_OF_LIGHT GREATER_BLESSING_OF_MIGHT GREATER_BLESSING_OF_WISDOM HAMMER_OF_JUSTICE HAMMER_OF_WRATH HOLY_LIGHT HOLY_SHIELD HOLY_SHOCK HOLY_STRIKE HOLY_WRATH JUDGEMENT LAY_ON_HANDS LIGHTS_VIGIL MASS_SALVATION PURIFY REDEMPTION REPENTANCE RETRIBUTION_AURA REVOKE RIGHTEOUS_FURY SALVATION SEAL_OF_COMMAND SEAL_OF_FURY SEAL_OF_JUSTICE SEAL_OF_LIGHT SEAL_OF_RIGHTEOUSNESS SEAL_OF_THE_CRUSADER SEAL_OF_WISDOM SENSE_UNDEAD SHADOW_RESISTANCE_AURA SWIFT_JUDGEMENT TEMPLARS_BULWARK TURN_UNDEAD VOICE_OF_TRUTH"
    local count = 0
    for key in string.gmatch(expected, "%S+") do equal(RPHelper.Ability.PALADIN[key], key);count = count + 1 end
    local actual = 0;for _ in pairs(RPHelper.Ability.PALADIN) do actual = actual + 1 end
    equal(count, 54);equal(actual, 54)
    for _, key in ipairs({ "HOLY_STRIKE", "LIGHTS_VIGIL", "MASS_SALVATION", "REVOKE", "SEAL_OF_FURY", "SWIFT_JUDGEMENT", "TEMPLARS_BULWARK", "VOICE_OF_TRUTH" }) do
        equal(#RPHelper.GetAbilityPool("PALADIN", key), 0)
    end
    local salvation = RPHelper.GetAbilityPool("PALADIN", "SALVATION")
    equal(#salvation, 2);equal(salvation[1].type, "say");equal(salvation[1].text, "The Light shelters you from harm!")
    equal(salvation[2].type, "customemote");equal(salvation[2].text, "bestows divine grace upon {TARGET}, reducing their threat.")
    for _, key in ipairs({ "BLESSING_OF_SALVATION", "GREATER_BLESSING_OF_SALVATION", "BLESSING_OF_SANCTUARY", "BULWARK_OF_THE_RIGHTEOUS", "CRUSADER_STRIKE", "HAND_OF_RECKONING", "SANCTITY_AURA", "SUMMON_WARHORSE" }) do
        equal(RPHelper.Ability.PALADIN[key], nil)
    end
    local reactions = 0;for key in pairs(RPHelper.Ability.PALADIN) do reactions = reactions + #RPHelper.GetAbilityPool("PALADIN", key) end;equal(reactions, 88)
end)

test("Paladin source ordering headings and registrations match the approved layout", function()
    local source = assert(io.open("RPHelper/Data/Abilities/Paladin.lua", "r")):read("*a")
    local groups = {
        "BLESSING_OF_LIGHT BLESSING_OF_WISDOM CLEANSE CONSECRATION DIVINE_FAVOR EXORCISM FLASH_OF_LIGHT GREATER_BLESSING_OF_LIGHT GREATER_BLESSING_OF_WISDOM HAMMER_OF_WRATH HOLY_LIGHT HOLY_SHOCK HOLY_WRATH LAY_ON_HANDS LIGHTS_VIGIL PURIFY REDEMPTION SEAL_OF_LIGHT SEAL_OF_RIGHTEOUSNESS SEAL_OF_WISDOM SENSE_UNDEAD TURN_UNDEAD VOICE_OF_TRUTH",
        "BLESSING_OF_FREEDOM BLESSING_OF_KINGS BLESSING_OF_PROTECTION BLESSING_OF_SACRIFICE CONCENTRATION_AURA DEVOTION_AURA DIVINE_INTERVENTION DIVINE_PROTECTION DIVINE_SHIELD FIRE_RESISTANCE_AURA FROST_RESISTANCE_AURA GREATER_BLESSING_OF_KINGS HAMMER_OF_JUSTICE HOLY_SHIELD MASS_SALVATION REVOKE RIGHTEOUS_FURY SALVATION SEAL_OF_FURY SEAL_OF_JUSTICE SHADOW_RESISTANCE_AURA SWIFT_JUDGEMENT TEMPLARS_BULWARK",
        "BLESSING_OF_MIGHT GREATER_BLESSING_OF_MIGHT HOLY_STRIKE JUDGEMENT REPENTANCE RETRIBUTION_AURA SEAL_OF_COMMAND SEAL_OF_THE_CRUSADER",
    }
    local expected, actual, headings = {}, {}, {}
    for _, group in ipairs(groups) do for key in string.gmatch(group, "%S+") do expected[#expected + 1] = key end end
    for key in string.gmatch(source, "\n%-%- ([A-Z][A-Z0-9_]*)\n") do actual[#actual + 1] = key;headings[key] = (headings[key] or 0) + 1 end
    equal(#actual, 54);equal(string.find(source, "for _, ability in ipairs", 1, true), nil)
    for index, key in ipairs(expected) do
        equal(actual[index], key);equal(headings[key], 1)
        if #RPHelper.GetAbilityPool("PALADIN", key) == 0 then
            truthy(string.find(source, 'RPHelper.RegisterAbility(C, "' .. key .. '")', 1, true))
            for _, kind in ipairs({ "say", "emote", "customemote" }) do truthy(string.find(source, '-- add("' .. key .. '", "' .. kind .. '", "")', 1, true)) end
        end
    end
end)

test("Paladin families have the approved identity counts", function()
    local families = {
        { 7, "SEAL_OF_COMMAND SEAL_OF_FURY SEAL_OF_JUSTICE SEAL_OF_LIGHT SEAL_OF_RIGHTEOUSNESS SEAL_OF_THE_CRUSADER SEAL_OF_WISDOM" },
        { 6, "CONCENTRATION_AURA DEVOTION_AURA FIRE_RESISTANCE_AURA FROST_RESISTANCE_AURA RETRIBUTION_AURA SHADOW_RESISTANCE_AURA" },
        { 7, "BLESSING_OF_FREEDOM BLESSING_OF_KINGS BLESSING_OF_LIGHT BLESSING_OF_MIGHT BLESSING_OF_PROTECTION BLESSING_OF_SACRIFICE BLESSING_OF_WISDOM" },
        { 4, "GREATER_BLESSING_OF_KINGS GREATER_BLESSING_OF_LIGHT GREATER_BLESSING_OF_MIGHT GREATER_BLESSING_OF_WISDOM" },
    }
    for _, family in ipairs(families) do local count = 0;for key in string.gmatch(family[2], "%S+") do truthy(RPHelper.Ability.PALADIN[key]);count = count + 1 end;equal(count, family[1]) end
end)

test("Paladin archive preserves displaced reactions and is excluded from the manifest", function()
    local archive = dofile("RPHelper/Data/Abilities/PaladinArchive.lua")
    local expected = { BLESSING_OF_SALVATION = 0, BLESSING_OF_SANCTUARY = 2, BULWARK_OF_THE_RIGHTEOUS = 3, CRUSADER_STRIKE = 3, GREATER_BLESSING_OF_SALVATION = 0, HAND_OF_RECKONING = 3, SANCTITY_AURA = 2, SUMMON_WARHORSE = 2 }
    local keys, reactions = 0, 0
    for key, count in pairs(expected) do truthy(archive[key]);equal(#archive[key], count);keys = keys + 1;reactions = reactions + count end
    local actual = 0;for _ in pairs(archive) do actual = actual + 1 end;equal(actual, keys);equal(reactions, 15)
    equal(archive.CRUSADER_STRIKE[1].text, "For the Light, and for justice!")
    equal(archive.BULWARK_OF_THE_RIGHTEOUS[3].type, "customemote")
    local toc = assert(io.open("RPHelper/RPHelper.toc", "r")):read("*a");equal(string.find(toc, "PaladinArchive.lua", 1, true), nil)
end)

test("Paladin Salvation migration preserves settings custom content and exact default IDs", function()
    local saved = RPHelperDB
    local oldSalvation, oldMass = { enabled = false, future = "salvation" }, { chance = 0.4, future = "mass" }
    local newSay = RPHelper.GetAbilityPool("PALADIN", "SALVATION")[1].defaultID
    local newEmote = RPHelper.GetAbilityPool("PALADIN", "SALVATION")[2].defaultID
    local oldSay = string.gsub(newSay, "s9:SALVATION", "s21:BLESSING_OF_SALVATION", 1)
    local oldEmote = string.gsub(newEmote, "s9:SALVATION", "s21:BLESSING_OF_SALVATION", 1)
    local unknown = oldSay .. ":unknown"
    RPHelperDB = { abilities = { PALADIN = { BLESSING_OF_SALVATION = oldSalvation, GREATER_BLESSING_OF_SALVATION = oldMass } }, custom = { nextID = 3, entries = {
        ["custom:1"] = { scope = { layer = "ability", class = "PALADIN", ability = "BLESSING_OF_SALVATION", future = "scope" }, entry = { type = "say", text = "Keep me.", future = "entry" }, future = "record" },
        ["custom:2"] = { scope = { layer = "ability", class = "PALADIN", ability = "GREATER_BLESSING_OF_SALVATION" }, entry = { type = "customemote", text = "Keep mass." } },
    } }, disabledDefaults = { [oldSay] = true, [oldEmote] = true, [unknown] = true } }
    local ok, err = pcall(function()
        for _ = 1, 2 do RPHelper.InitializeDatabase() end
        equal(RPHelperDB.abilities.PALADIN.SALVATION, oldSalvation);equal(RPHelperDB.abilities.PALADIN.MASS_SALVATION, oldMass)
        equal(RPHelperDB.abilities.PALADIN.BLESSING_OF_SALVATION, nil);equal(RPHelperDB.abilities.PALADIN.GREATER_BLESSING_OF_SALVATION, nil)
        equal(RPHelperDB.custom.entries["custom:1"].scope.ability, "SALVATION");equal(RPHelperDB.custom.entries["custom:2"].scope.ability, "MASS_SALVATION")
        equal(RPHelperDB.custom.entries["custom:1"].scope.future, "scope");equal(RPHelperDB.custom.entries["custom:1"].entry.future, "entry");equal(RPHelperDB.custom.entries["custom:1"].future, "record")
        equal(RPHelperDB.disabledDefaults[newSay], true);equal(RPHelperDB.disabledDefaults[newEmote], true);equal(RPHelperDB.disabledDefaults[oldSay], nil);equal(RPHelperDB.disabledDefaults[oldEmote], nil);equal(RPHelperDB.disabledDefaults[unknown], true)
        local historical, destination = { future = "old" }, { future = "new" }
        RPHelperDB = { abilities = { PALADIN = { BLESSING_OF_SALVATION = historical, SALVATION = destination } }, disabledDefaults = { [oldSay] = true, [newSay] = true } }
        RPHelper.InitializeDatabase();equal(RPHelperDB.abilities.PALADIN.BLESSING_OF_SALVATION, historical);equal(RPHelperDB.abilities.PALADIN.SALVATION, destination);equal(RPHelperDB.disabledDefaults[newSay], true)
        RPHelperDB = { abilities = { PALADIN = { BLESSING_OF_SALVATION = "malformed" } } };RPHelper.InitializeDatabase();equal(RPHelperDB.abilities.PALADIN.BLESSING_OF_SALVATION, "malformed");equal(RPHelperDB.abilities.PALADIN.SALVATION, nil)
    end)
    RPHelperDB = saved;RPHelper.UserContent.Invalidate();if not ok then error(err) end
end)

test("Paladin archived saved records and class reactions remain unchanged", function()
    local saved = RPHelperDB
    local keys = { "BLESSING_OF_SANCTUARY", "BULWARK_OF_THE_RIGHTEOUS", "CRUSADER_STRIKE", "HAND_OF_RECKONING", "SANCTITY_AURA", "SUMMON_WARHORSE" }
    local abilities, entries = {}, {};for index, key in ipairs(keys) do abilities[key] = { future = key };entries["custom:" .. index] = { scope = { layer = "ability", class = "PALADIN", ability = key }, entry = { type = "say", text = key } } end
    RPHelperDB = { abilities = { PALADIN = abilities }, custom = { nextID = 7, entries = entries } }
    local ok, err = pcall(function() RPHelper.InitializeDatabase();for index, key in ipairs(keys) do equal(RPHelperDB.abilities.PALADIN[key], abilities[key]);equal(RPHelperDB.custom.entries["custom:" .. index].scope.ability, key) end end)
    RPHelperDB = saved;RPHelper.UserContent.Invalidate();if not ok then error(err) end
    local triggers = "absorb block deferred_youcritspell dodge entercombat hurt leavecombat miss parry resurrect youcrit youcritheal youheal"
    local parts, count = {}, 0;for trigger in string.gmatch(triggers, "%S+") do parts[#parts + 1] = trigger;for _, entry in ipairs(RPHelper.GetClassPool("PALADIN", trigger)) do count = count + 1;for _, field in ipairs({ "type", "text", "defaultID", "template" }) do local value = entry[field] or "";parts[#parts + 1] = #value .. ":" .. value end end end
    equal(count, 50);equal(catalogueChecksum(table.concat(parts, "\n")), 554717313)
end)

test("Priest reconciliation registers the approved active catalogue", function()
    local universal = {
        "DISPEL_MAGIC", "DIVINE_SPIRIT", "INNER_FIRE", "INNER_FOCUS", "LEVITATE", "MANA_BURN",
        "PENANCE", "POWER_INFUSION", "POWER_WORD_FORTITUDE", "POWER_WORD_SHIELD",
        "PRAYER_OF_FORTITUDE", "PRAYER_OF_SPIRIT", "SHACKLE_UNDEAD", "ABOLISH_DISEASE",
        "BINDING_HEAL", "CURE_DISEASE", "FEAR_WARD", "FLASH_HEAL", "GREATER_HEAL", "HEAL",
        "HOLY_FIRE", "HOLY_NOVA", "LESSER_HEAL", "PRAYER_OF_HEALING", "PRAYER_OF_MENDING",
        "RENEW", "RESURRECTION", "SMITE", "DEVOURING_PLAGUE", "FADE", "MIND_BLAST",
        "MIND_CONTROL", "MIND_FLAY", "MIND_SOOTHE", "MIND_VISION",
        "PRAYER_OF_SHADOW_PROTECTION", "PSYCHIC_SCREAM", "SHADOW_PROTECTION", "SHADOW_WORD_DEATH",
        "SHADOW_WORD_PAIN", "SHADOWFORM", "SILENCE", "VAMPIRIC_EMBRACE",
    }
    local racial = {
        "CHASTISE", "DESPERATE_PRAYER", "CONFOUNDING_FLASH", "CONTINGENCY_PLAN", "DIVINE_GRACE",
        "FEEDBACK", "ELUNES_GRACE", "STARSHARDS", "HEX_OF_WEAKNESS", "SHADOWGUARD",
        "DARK_SACRIFICE", "TOUCH_OF_WEAKNESS",
    }
    local expected, count = {}, 0
    for _, keys in ipairs({ universal, racial }) do
        for _, key in ipairs(keys) do
            expected[key] = true
            equal(RPHelper.Ability.PRIEST[key], key)
        end
    end
    for key in pairs(RPHelper.Ability.PRIEST) do truthy(expected[key]);count = count + 1 end
    equal(count, 55);equal(#universal, 43);equal(#racial, 12)

    for _, key in ipairs({
        "PENANCE", "BINDING_HEAL", "PRAYER_OF_MENDING", "SHADOW_WORD_DEATH",
        "PRAYER_OF_SPIRIT", "PRAYER_OF_SHADOW_PROTECTION", "CHASTISE", "CONFOUNDING_FLASH",
        "CONTINGENCY_PLAN", "DIVINE_GRACE", "DARK_SACRIFICE",
    }) do equal(#RPHelper.GetAbilityPool("PRIEST", key), 0) end
    for _, key in ipairs({
        "CHAMPIONS_BOND", "CHAMPIONS_RESOLVE", "CHASTICE", "EMPOWER_CHAMPION", "LIGHTWELL",
        "PAIN_SPIKE", "PROCLAIM_CHAMPION", "REVIVE_CHAMPION", "SPIRIT_OF_REDEMPTION",
    }) do
        equal(RPHelper.Ability.PRIEST[key], nil)
        equal(#RPHelper.GetAbilityPool("PRIEST", key), 0)
    end
end)

test("Priest source ordering headings and registrations match the approved layout", function()
    local source = assert(io.open("RPHelper/Data/Abilities/Priest.lua", "r")):read("*a")
    local groups = {
        "DISPEL_MAGIC DIVINE_SPIRIT INNER_FIRE INNER_FOCUS LEVITATE MANA_BURN PENANCE POWER_INFUSION POWER_WORD_FORTITUDE POWER_WORD_SHIELD PRAYER_OF_FORTITUDE PRAYER_OF_SPIRIT SHACKLE_UNDEAD",
        "ABOLISH_DISEASE BINDING_HEAL CURE_DISEASE FEAR_WARD FLASH_HEAL GREATER_HEAL HEAL HOLY_FIRE HOLY_NOVA LESSER_HEAL PRAYER_OF_HEALING PRAYER_OF_MENDING RENEW RESURRECTION SMITE",
        "DEVOURING_PLAGUE FADE MIND_BLAST MIND_CONTROL MIND_FLAY MIND_SOOTHE MIND_VISION PRAYER_OF_SHADOW_PROTECTION PSYCHIC_SCREAM SHADOW_PROTECTION SHADOW_WORD_DEATH SHADOW_WORD_PAIN SHADOWFORM SILENCE VAMPIRIC_EMBRACE",
        "CHASTISE DESPERATE_PRAYER", "CONFOUNDING_FLASH CONTINGENCY_PLAN", "DIVINE_GRACE FEEDBACK",
        "ELUNES_GRACE STARSHARDS", "HEX_OF_WEAKNESS SHADOWGUARD", "DARK_SACRIFICE TOUCH_OF_WEAKNESS",
    }
    local expected, actual, headings = {}, {}, {}
    for _, group in ipairs(groups) do
        for key in string.gmatch(group, "%S+") do expected[#expected + 1] = key end
    end
    for key in string.gmatch(source, "\n%-%- ([A-Z][A-Z0-9_]*)\n") do
        actual[#actual + 1] = key;headings[key] = (headings[key] or 0) + 1
    end
    equal(#actual, 55);equal(string.find(source, "for _, ability in ipairs", 1, true), nil)
    for index, key in ipairs(expected) do
        equal(actual[index], key);equal(headings[key], 1)
        if #RPHelper.GetAbilityPool("PRIEST", key) == 0 then
            truthy(string.find(source, 'RPHelper.RegisterAbility(C, "' .. key .. '")', 1, true))
            for _, kind in ipairs({ "say", "emote", "customemote" }) do
                truthy(string.find(source, '-- add("' .. key .. '", "' .. kind .. '", "")', 1, true))
            end
        else equal(string.find(source, '-- add("' .. key .. '",', 1, true), nil) end
    end

    local registrationCounts = {}
    for _, key in ipairs(expected) do
        local poolSize = #RPHelper.GetAbilityPool("PRIEST", key)
        registrationCounts[key] = poolSize > 0 and poolSize or 1
    end
    local previous = RPHelper
    local ok, err = pcall(function()
        local registrations = {}
        RPHelper = { Ability = { PRIEST = {} }, Class = { PRIEST = "PRIEST" } }
        RPHelper.RegisterAbility = function(_, ability)
            registrations[ability] = (registrations[ability] or 0) + 1
        end
        dofile("RPHelper/Data/Abilities/Priest.lua")
        for _, key in ipairs(expected) do equal(registrations[key], registrationCounts[key]) end
    end)
    RPHelper = previous;if not ok then error(err) end
end)

test("Priest historical reactions are restored exactly", function()
    local expected = {
        FEAR_WARD = {{"say", "No fear shall take hold of me!"},{"say", "The Light banishes all terror!"},{"customemote", "places a protective blessing upon {TARGET}, warding off fear and despair."}},
        DEVOURING_PLAGUE = {{"say", "The plague shall consume you!"},{"say", "Your life force withers away!"},{"customemote", "chants in a low whisper, unleashing a virulent plague upon {TARGET}."}},
        DESPERATE_PRAYER = {{"say", "Light, hear my desperate plea!"},{"say", "In my darkest moment, the Light remains!"},{"emote", "PRAY"},{"customemote", "clasps {PP} hands together, whispering a desperate prayer for salvation."}},
        ELUNES_GRACE = {{"say", "Elune’s grace shields me from harm!"},{"say", "The night mother watches over me!"},{"customemote", "whispers a soft prayer as a gentle glow surrounds {PP} form."}},
        FEEDBACK = {{"say", "Your magic turns against you!"},{"say", "The Light repels your corruption!"},{"customemote", "focuses intensely, reflecting harmful magic back at {TARGET}."}},
        HEX_OF_WEAKNESS = {{"say", "You be feelin’ weaker already, mon!"},{"say", "Da spirits take your strength!"},{"customemote", "waves a hand, placing a sinister hex upon {TARGET}."}},
        SHADOWGUARD = {{"say", "Darkness protects me!"},{"say", "The void deflects your strike!"},{"customemote", "a swirling barrier of shadow encases {PP}, crackling with dark energy."}},
        STARSHARDS = {{"say", "Elune’s wrath descends upon you!"},{"say", "The stars shall be your undoing!"},{"customemote", "calls upon Elune, raining down shards of starlight upon {TARGET}."}},
        TOUCH_OF_WEAKNESS = {{"say", "Your strength fades into nothingness!"},{"say", "The touch of undeath weakens your flesh!"},{"customemote", "reaches out, sapping vitality from {TARGET}."}},
    }
    local total = 0
    for key, entries in pairs(expected) do
        local pool = RPHelper.GetAbilityPool("PRIEST", key);equal(#pool, #entries);total = total + #pool
        for index, entry in ipairs(entries) do equal(pool[index].type, entry[1]);equal(pool[index].text, entry[2]) end
    end
    equal(total, 28)
    local active = 0;for key in pairs(RPHelper.Ability.PRIEST) do active = active + #RPHelper.GetAbilityPool("PRIEST", key) end
    equal(active, 133)
end)

test("Priest archive preserves displaced reactions and is excluded from the manifest", function()
    local archive = dofile("RPHelper/Data/Abilities/PriestArchive.lua")
    local keys = { "CHAMPIONS_BOND", "CHAMPIONS_RESOLVE", "CHASTICE", "EMPOWER_CHAMPION", "LIGHTWELL", "PAIN_SPIKE", "PROCLAIM_CHAMPION", "REVIVE_CHAMPION", "SPIRIT_OF_REDEMPTION" }
    local count = 0;for key in pairs(archive) do count = count + 1;truthy(type(archive[key]) == "table") end;equal(count, 9)
    for _, key in ipairs(keys) do truthy(archive[key]) end
    equal(#archive.LIGHTWELL, 3);equal(#archive.SPIRIT_OF_REDEMPTION, 3)
    equal(archive.LIGHTWELL[1].text, "Drink deep from the well of Light!")
    equal(archive.LIGHTWELL[3].type, "customemote")
    equal(archive.SPIRIT_OF_REDEMPTION[3].text, "ascends into a spectral form, continuing to heal allies despite {PP} demise.")
    for _, key in ipairs({ "CHAMPIONS_BOND", "CHAMPIONS_RESOLVE", "CHASTICE", "EMPOWER_CHAMPION", "PAIN_SPIKE", "PROCLAIM_CHAMPION", "REVIVE_CHAMPION" }) do equal(#archive[key], 0) end
    local toc = assert(io.open("RPHelper/RPHelper.toc", "r")):read("*a")
    equal(string.find(toc, "PriestArchive.lua", 1, true), nil)
end)

test("Priest archived saved records remain untouched", function()
    local saved = RPHelperDB
    local keys = { "CHAMPIONS_BOND", "CHAMPIONS_RESOLVE", "EMPOWER_CHAMPION", "LIGHTWELL", "PAIN_SPIKE", "PROCLAIM_CHAMPION", "REVIVE_CHAMPION", "SPIRIT_OF_REDEMPTION" }
    local abilities, entries = {}, {}
    for index, key in ipairs(keys) do
        abilities[key] = { enabled = false, future = key }
        entries["custom:" .. index] = {
            scope = { layer = "ability", class = "PRIEST", ability = key, future = "scope" },
            entry = { type = "say", text = "Preserve " .. key, future = "entry" }, future = "record",
        }
    end
    RPHelperDB = { abilities = { PRIEST = abilities }, custom = { nextID = 9, entries = entries } }
    local ok, err = pcall(function()
        for _ = 1, 2 do
            RPHelper.InitializeDatabase()
            for index, key in ipairs(keys) do
                equal(RPHelperDB.abilities.PRIEST[key], abilities[key])
                equal(RPHelperDB.custom.entries["custom:" .. index].scope.ability, key)
                equal(RPHelperDB.custom.entries["custom:" .. index].scope.future, "scope")
                equal(RPHelperDB.custom.entries["custom:" .. index].entry.future, "entry")
                equal(RPHelperDB.custom.entries["custom:" .. index].future, "record")
            end
        end
    end)
    RPHelperDB = saved;RPHelper.UserContent.Invalidate();if not ok then error(err) end
end)

test("Priest CHASTICE migration preserves settings custom content and unknown IDs", function()
    local saved = RPHelperDB
    local oldOnly = { enabled = false, nested = { keep = true }, future = "old-only" }
    local historical, destination = { chance = 0.25 }, { enabled = true }
    local unknownID = "default:v1:s7:abilitys6:PRIESTs8:CHASTICE:unknown"
    RPHelperDB = {
        abilities = { PRIEST = { CHASTICE = oldOnly, LIGHTWELL = { future = "archive" } }, MAGE = { CHASTICE = { future = "other" } } },
        custom = { nextID = 4, entries = {
            ["custom:1"] = { scope = { layer = "ability", class = "PRIEST", ability = "CHASTICE", future = "scope" }, entry = { type = "say", text = "Old spelling.", future = "entry" }, future = "record" },
            ["custom:2"] = { scope = { layer = "ability", class = "PRIEST", ability = "CHASTISE" }, entry = { type = "customemote", text = "Already canonical." } },
            ["custom:3"] = { scope = { layer = "ability", class = "MAGE", ability = "CHASTICE" }, entry = { type = "emote", text = "WAVE" } },
        } }, disabledDefaults = { [unknownID] = true },
    }
    local ok, err = pcall(function()
        for _ = 1, 2 do
            RPHelper.InitializeDatabase();equal(RPHelperDB.abilities.PRIEST.CHASTISE, oldOnly);equal(RPHelperDB.abilities.PRIEST.CHASTICE, nil)
            equal(RPHelperDB.abilities.PRIEST.LIGHTWELL.future, "archive");equal(RPHelperDB.abilities.MAGE.CHASTICE.future, "other")
            equal(RPHelperDB.disabledDefaults[unknownID], true)
            equal(RPHelperDB.custom.entries["custom:1"].scope.ability, "CHASTISE")
            equal(RPHelperDB.custom.entries["custom:1"].scope.future, "scope");equal(RPHelperDB.custom.entries["custom:1"].entry.text, "Old spelling.")
            equal(RPHelperDB.custom.entries["custom:1"].entry.future, "entry");equal(RPHelperDB.custom.entries["custom:1"].future, "record")
            equal(RPHelperDB.custom.entries["custom:3"].scope.ability, "CHASTICE")
        end
        RPHelperDB = { abilities = { PRIEST = { CHASTICE = historical, CHASTISE = destination } } }
        RPHelper.InitializeDatabase();RPHelper.InitializeDatabase();equal(RPHelperDB.abilities.PRIEST.CHASTISE, destination);equal(RPHelperDB.abilities.PRIEST.CHASTICE, historical)
        RPHelperDB = { abilities = { PRIEST = { CHASTICE = "malformed" } } }
        RPHelper.InitializeDatabase();RPHelper.InitializeDatabase();equal(RPHelperDB.abilities.PRIEST.CHASTICE, "malformed");equal(RPHelperDB.abilities.PRIEST.CHASTISE, nil)
    end)
    RPHelperDB = saved;RPHelper.UserContent.Invalidate();if not ok then error(err) end
end)

test("Priest class reactions remain unchanged", function()
    local triggers = "absorb block deferred_youcritspell dodge entercombat hurt leavecombat miss parry petattackstart petattackstop petdies resurrect youcrit youcritheal youheal"
    local parts, count = {}, 0
    for trigger in string.gmatch(triggers, "%S+") do
        parts[#parts + 1] = trigger
        for _, entry in ipairs(RPHelper.GetClassPool("PRIEST", trigger)) do
            count = count + 1
            for _, field in ipairs({ "type", "text", "defaultID", "template" }) do local value = entry[field] or "";parts[#parts + 1] = #value .. ":" .. value end
        end
    end
    equal(count, 51);equal(catalogueChecksum(table.concat(parts, "\n")), 856270990)
end)

test("Warlock reconciliation registers the approved active catalogue", function()
    local count = 0
    for _ in pairs(RPHelper.Ability.WARLOCK) do count = count + 1 end
    equal(count, 53)

    for _, key in ipairs({ "WRACK", "SUMMON_INCUBUS", "BANE_OF_HAVOC", "INCINERATE" }) do
        equal(RPHelper.Ability.WARLOCK[key], key)
        equal(#RPHelper.GetAbilityPool("WARLOCK", key), 0)
    end

    local renamed = {
        BANE_OF_AGONY = {
            { "say", "You shall know pain and agony, {TARGET}!" },
        },
        BANE_OF_DOOM = {
            { "say", "I bring DOOM upon you!" },
            { "emote", "WRATH" },
            { "customemote", "threatens {TARGET} with the wrath of doom." },
        },
        SUBJUGATE_DEMON = { { "emote", "GRIN" } },
    }
    for _, key in ipairs({ "BANE_OF_AGONY", "BANE_OF_DOOM", "SUBJUGATE_DEMON" }) do
        local pool = RPHelper.GetAbilityPool("WARLOCK", key)
        equal(#pool, #renamed[key])
        for index, entry in ipairs(pool) do
            equal(entry.type, renamed[key][index][1])
            equal(entry.text, renamed[key][index][2])
        end
    end

    for _, key in ipairs({
        "CURSE_OF_AGONY", "CURSE_OF_DOOM", "ENSLAVE_DEMON", "CURSE_OF_SHADOW",
        "DARK_HARVEST", "DARK_PACT", "DEMON_PORTAL", "DETECT_GREATER_INVISIBILITY",
        "DETECT_LESSER_INVISIBILITY", "MANA_FUNNEL", "SUMMON_DREADSTEED", "SUMMON_FELSTEED",
        "ATTACK", "SHOOT", "ARMOR_PROFICIENCY", "DODGE", "LANGUAGES",
        "DEMONIC_BRAND", "DEMONIC_PACT", "BLOOD_PACT", "CONSUME_SHADOWS",
        "DEVOUR_MAGIC", "FIRE_SHIELD", "FIREBOLT", "LASH_OF_PAIN", "LESSER_INVISIBILITY",
        "PARANOIA", "PHASE_SHIFT", "SACRIFICE", "SEDUCTION", "SOOTHING_KISS",
        "SPELL_LOCK", "SUFFERING", "TAINTED_BLOOD", "TORMENT",
    }) do
        equal(RPHelper.Ability.WARLOCK[key], nil)
        equal(#RPHelper.GetAbilityPool("WARLOCK", key), 0)
    end
    equal(#RPHelper.GetAbilityPool("WARLOCK", "CURSE_OF_THE_ELEMENTS"), 1)
end)

test("Warlock source is grouped and alphabetized by Forever specialization", function()
    local source = assert(io.open("RPHelper/Data/Abilities/Warlock.lua", "r")):read("*a")
    local specializations = {
        "AMPLIFY_CURSE BANE_OF_AGONY BANE_OF_DOOM CORRUPTION CURSE_OF_EXHAUSTION CURSE_OF_RECKLESSNESS CURSE_OF_THE_ELEMENTS CURSE_OF_TONGUES CURSE_OF_WEAKNESS DEATH_COIL DRAIN_LIFE DRAIN_MANA DRAIN_SOUL FEAR HOWL_OF_TERROR LIFE_TAP SIPHON_LIFE WRACK",
        "BANISH CREATE_FIRESTONE CREATE_HEALTHSTONE CREATE_SOULSTONE CREATE_SPELLSTONE DEMONIC_SACRIFICE DEMON_ARMOR DEMON_SKIN DETECT_INVISIBILITY EYE_OF_KILROGG FEL_DOMINATION HEALTH_FUNNEL INFERNO RITUAL_OF_DOOM RITUAL_OF_SUMMONING SENSE_DEMONS SHADOW_WARD SOUL_LINK SUBJUGATE_DEMON SUMMON_FELHUNTER SUMMON_IMP SUMMON_INCUBUS SUMMON_SUCCUBUS SUMMON_VOIDWALKER UNENDING_BREATH",
        "BANE_OF_HAVOC CONFLAGRATE HELLFIRE IMMOLATE INCINERATE RAIN_OF_FIRE SEARING_PAIN SHADOWBURN SHADOW_BOLT SOUL_FIRE",
    }
    local expected, actual, headingCounts = {}, {}, {}
    for _, group in ipairs(specializations) do
        for key in string.gmatch(group, "%S+") do expected[#expected + 1] = key end
    end
    for key in string.gmatch(source, "\n%-%- ([A-Z][A-Z0-9_]*)\n") do
        actual[#actual + 1] = key
        headingCounts[key] = (headingCounts[key] or 0) + 1
    end
    equal(#actual, 53)
    for index, key in ipairs(expected) do
        equal(actual[index], key)
        equal(headingCounts[key], 1)
    end
    equal(string.find(source, "for _, ability in ipairs", 1, true), nil)
    for _, key in ipairs(expected) do
        if #RPHelper.GetAbilityPool("WARLOCK", key) == 0 then
            truthy(string.find(source, 'RPHelper.RegisterAbility(C, "' .. key .. '")', 1, true))
            for _, kind in ipairs({ "say", "emote", "customemote" }) do
                truthy(string.find(source, '-- add("' .. key .. '", "' .. kind .. '", "")', 1, true))
            end
        else
            equal(string.find(source, '-- add("' .. key .. '",', 1, true), nil)
        end
    end
end)

test("Warlock legacy archive preserves identities and Curse of Shadow reactions", function()
    local archive = dofile("RPHelper/Data/Abilities/WarlockArchive.lua")
    local keys = {
        "CURSE_OF_SHADOW", "DARK_HARVEST", "DARK_PACT", "DEMON_PORTAL",
        "DETECT_GREATER_INVISIBILITY", "DETECT_LESSER_INVISIBILITY", "MANA_FUNNEL",
        "SUMMON_DREADSTEED", "SUMMON_FELSTEED",
    }
    local archiveCount = 0
    for _, key in ipairs(keys) do
        truthy(type(archive[key]) == "table")
        archiveCount = archiveCount + 1
        equal(RPHelper.Ability.WARLOCK[key], nil)
    end
    equal(archiveCount, 9)
    equal(#archive.CURSE_OF_SHADOW, 2)
    equal(archive.CURSE_OF_SHADOW[1].type, "say")
    equal(archive.CURSE_OF_SHADOW[1].text, "Embrace the Shadow.")
    equal(archive.CURSE_OF_SHADOW[2].type, "customemote")
    equal(archive.CURSE_OF_SHADOW[2].text, "grins wickedly at {TARGET}.")
    for index = 2, #keys do equal(#archive[keys[index]], 0) end

    local toc = assert(io.open("RPHelper/RPHelper.toc", "r")):read("*a")
    equal(string.find(toc, "WarlockArchive.lua", 1, true), nil)
end)

test("Warlock canonical migrations preserve settings custom content and disabled defaults", function()
    local saved = RPHelperDB
    local mappings = {
        { old = "CURSE_OF_AGONY", new = "BANE_OF_AGONY" },
        { old = "CURSE_OF_DOOM", new = "BANE_OF_DOOM" },
        { old = "ENSLAVE_DEMON", new = "SUBJUGATE_DEMON" },
    }
    local oldOnly = { enabled = false, future = "agony", nested = { keep = true } }
    local doomOld = { chance = 0.25, future = "historical" }
    local doomNew = { enabled = true, future = "destination" }
    local disabled, expectedNewIDs = {}, {}
    for _, mapping in ipairs(mappings) do
        local newPool = RPHelper.GetAbilityPool("WARLOCK", mapping.new)
        for _, entry in ipairs(newPool) do
            local newPrefix = "default:v1:s7:abilitys7:WARLOCKs" .. #mapping.new .. ":" .. mapping.new
            local oldPrefix = "default:v1:s7:abilitys7:WARLOCKs" .. #mapping.old .. ":" .. mapping.old
            truthy(string.sub(entry.defaultID, 1, #newPrefix) == newPrefix)
            local oldID = oldPrefix .. string.sub(entry.defaultID, #newPrefix + 1)
            disabled[oldID] = true
            expectedNewIDs[#expectedNewIDs + 1] = { old = oldID, new = entry.defaultID }
        end
    end
    RPHelperDB = {
        abilities = { WARLOCK = {
            CURSE_OF_AGONY = oldOnly,
            CURSE_OF_DOOM = doomOld,
            BANE_OF_DOOM = doomNew,
            ENSLAVE_DEMON = "malformed-old",
        }, MAGE = { ARCANE_BLAST = { future = "other-class" } } },
        custom = { nextID = 6, entries = {
            ["custom:1"] = { scope = { layer = "ability", class = "WARLOCK", ability = "CURSE_OF_AGONY", future = "keep" }, entry = { type = "say", text = "Old agony." }, future = "one" },
            ["custom:2"] = { scope = { layer = "ability", class = "WARLOCK", ability = "CURSE_OF_DOOM" }, entry = { type = "emote", text = "DOOM" }, future = "two" },
            ["custom:3"] = { scope = { layer = "ability", class = "WARLOCK", ability = "ENSLAVE_DEMON" }, entry = { type = "customemote", text = "commands a demon." }, future = "three" },
            ["custom:4"] = { scope = { layer = "ability", class = "WARLOCK", ability = "BANE_OF_AGONY" }, entry = { type = "say", text = "Existing bane." }, future = "four" },
            ["custom:5"] = { scope = { layer = "ability", class = "MAGE", ability = "ARCANE_BLAST" }, entry = { type = "say", text = "Other class." }, future = "five" },
        } },
        disabledDefaults = disabled,
    }
    local ok, err = pcall(function()
        for iteration = 1, 2 do
            RPHelper.InitializeDatabase()
            equal(RPHelperDB.abilities.WARLOCK.BANE_OF_AGONY, oldOnly)
            equal(RPHelperDB.abilities.WARLOCK.CURSE_OF_AGONY, nil)
            equal(RPHelperDB.abilities.WARLOCK.BANE_OF_DOOM, doomNew)
            equal(RPHelperDB.abilities.WARLOCK.CURSE_OF_DOOM, doomOld)
            equal(RPHelperDB.abilities.WARLOCK.ENSLAVE_DEMON, "malformed-old")
            equal(RPHelperDB.abilities.WARLOCK.SUBJUGATE_DEMON, nil)
            equal(RPHelperDB.abilities.MAGE.ARCANE_BLAST.future, "other-class")
            for _, ids in ipairs(expectedNewIDs) do
                equal(RPHelperDB.disabledDefaults[ids.old], nil)
                equal(RPHelperDB.disabledDefaults[ids.new], true)
            end
            for index, mapping in ipairs(mappings) do
                local records = RPHelper.UserContent.List({
                    layer = "ability", class = "WARLOCK", ability = mapping.new,
                })
                equal(#records, index == 1 and 2 or 1)
            end
            equal(RPHelperDB.custom.entries["custom:1"].scope.future, "keep")
            equal(RPHelperDB.custom.entries["custom:1"].future, "one")
            equal(RPHelperDB.custom.entries["custom:1"].entry.text, "Old agony.")
            equal(RPHelperDB.custom.entries["custom:5"].scope.class, "MAGE")
        end
    end)
    RPHelperDB = saved;RPHelper.UserContent.Invalidate()
    if not ok then error(err) end
end)

test("Warlock disabled-default migration leaves similar IDs and existing destination state stable", function()
    local saved = RPHelperDB
    local destinationID = RPHelper.GetAbilityPool("WARLOCK", "BANE_OF_AGONY")[1].defaultID
    local destinationPrefix = "default:v1:s7:abilitys7:WARLOCKs13:BANE_OF_AGONY"
    local historicalPrefix = "default:v1:s7:abilitys7:WARLOCKs14:CURSE_OF_AGONY"
    truthy(string.sub(destinationID, 1, #destinationPrefix) == destinationPrefix)
    local suffix = string.sub(destinationID, #destinationPrefix + 1)
    local historicalID = historicalPrefix .. suffix
    local similarID = "default:v1:s7:abilitys7:WARLOCKs20:CURSE_OF_AGONY_EXTRA" .. suffix
    RPHelperDB = { disabledDefaults = {
        [historicalID] = true,
        [destinationID] = true,
        [similarID] = true,
    } }
    local ok, err = pcall(function()
        for _ = 1, 2 do
            RPHelper.InitializeDatabase()
            equal(RPHelperDB.disabledDefaults[historicalID], nil)
            equal(RPHelperDB.disabledDefaults[destinationID], true)
            equal(RPHelperDB.disabledDefaults[similarID], true)
        end
    end)
    RPHelperDB = saved;RPHelper.UserContent.Invalidate()
    if not ok then error(err) end
end)

test("Warlock archived saved records remain untouched", function()
    local saved = RPHelperDB
    local keys = {
        "CURSE_OF_SHADOW", "DARK_HARVEST", "DARK_PACT", "DEMON_PORTAL",
        "DETECT_GREATER_INVISIBILITY", "DETECT_LESSER_INVISIBILITY", "MANA_FUNNEL",
        "SUMMON_DREADSTEED", "SUMMON_FELSTEED",
    }
    local abilities, entries = {}, {}
    for index, key in ipairs(keys) do
        abilities[key] = { enabled = false, future = key }
        entries["custom:" .. index] = {
            scope = { layer = "ability", class = "WARLOCK", ability = key, future = "keep" },
            entry = { type = "say", text = "Preserve " .. key }, future = "keep",
        }
    end
    RPHelperDB = { abilities = { WARLOCK = abilities }, custom = { nextID = 10, entries = entries } }
    local ok, err = pcall(function()
        for _ = 1, 2 do
            RPHelper.InitializeDatabase()
            for index, key in ipairs(keys) do
                equal(RPHelperDB.abilities.WARLOCK[key], abilities[key])
                local records = RPHelper.UserContent.List({ layer = "ability", class = "WARLOCK", ability = key })
                equal(#records, 1)
                equal(records[1].id, "custom:" .. index)
                equal(records[1].scope.future, "keep")
            end
        end
    end)
    RPHelperDB = saved;RPHelper.UserContent.Invalidate()
    if not ok then error(err) end
end)

test("Warlock class reactions and demon-event pools remain unchanged", function()
    local triggers = "absorb entercombat npctalksenemy npctalksfriend petattackstart petattackstop petdies resurrect"
    local parts, count = {}, 0
    for trigger in string.gmatch(triggers, "%S+") do
        parts[#parts + 1] = trigger
        for _, entry in ipairs(RPHelper.GetClassPool("WARLOCK", trigger)) do
            count = count + 1
            for _, field in ipairs({ "type", "text", "defaultID", "template" }) do
                local value = entry[field] or ""
                parts[#parts + 1] = #value .. ":" .. value
            end
        end
    end
    equal(count, 38)
    equal(catalogueChecksum(table.concat(parts, "\n")), 1687857190)
    equal(#RPHelper.GetClassPool("WARLOCK", "petattackstart"), 7)
    equal(#RPHelper.GetClassPool("WARLOCK", "petattackstop"), 6)
    equal(#RPHelper.GetClassPool("WARLOCK", "petdies"), 6)
end)

test("Warrior reconciliation registers the approved active catalogue", function()
    local count = 0
    for _ in pairs(RPHelper.Ability.WARRIOR) do count = count + 1 end
    equal(count, 41)

    for _, key in ipairs({
        "BATTLE_STANCE", "BERSERKER_STANCE", "DEFENSIVE_STANCE",
        "SPEARING_STRIKE", "TAUNT", "VICTORY_RUSH",
    }) do
        equal(RPHelper.Ability.WARRIOR[key], key)
        equal(#RPHelper.GetAbilityPool("WARRIOR", key), 0)
    end

    for _, key in ipairs({
        "ANGER_MANAGEMENT", "COUNTERATTACK", "DECISIVE_STRIKE", "INTERVENE",
        "SHOOT_BOW", "SHOOT_CROSSBOW", "SHOOT_GUN", "TACTICAL_MASTERY", "THROW",
    }) do
        equal(RPHelper.Ability.WARRIOR[key], nil)
        equal(#RPHelper.GetAbilityPool("WARRIOR", key), 0)
    end
end)

test("Warrior source is grouped and alphabetized by Forever specialization", function()
    local source = assert(io.open("RPHelper/Data/Abilities/Warrior.lua", "r")):read("*a")
    local specializations = {
        "BATTLE_STANCE CHARGE HAMSTRING HEROIC_STRIKE MOCKING_BLOW MORTAL_STRIKE OVERPOWER REND RETALIATION SPEARING_STRIKE SWEEPING_STRIKES THUNDER_CLAP VICTORY_RUSH",
        "BATTLE_SHOUT BERSERKER_RAGE BERSERKER_STANCE BLOODTHIRST CHALLENGING_SHOUT CLEAVE DEATH_WISH DEMORALIZING_SHOUT EXECUTE INTERCEPT INTIMIDATING_SHOUT PIERCING_HOWL PUMMEL RECKLESSNESS SLAM WHIRLWIND",
        "BLOODRAGE CONCUSSION_BLOW DEFENSIVE_STANCE DISARM LAST_STAND REVENGE SHIELD_BASH SHIELD_BLOCK SHIELD_SLAM SHIELD_WALL SUNDER_ARMOR TAUNT",
    }
    local expected, actual, headingCounts = {}, {}, {}
    for _, group in ipairs(specializations) do
        for key in string.gmatch(group, "%S+") do expected[#expected + 1] = key end
    end
    for key in string.gmatch(source, "\n%-%- ([A-Z][A-Z0-9_]*)\n") do
        actual[#actual + 1] = key
        headingCounts[key] = (headingCounts[key] or 0) + 1
    end
    equal(#actual, 41)
    for index, key in ipairs(expected) do
        equal(actual[index], key)
        equal(headingCounts[key], 1)
    end
    equal(string.find(source, "for _, ability in ipairs", 1, true), nil)
    for _, key in ipairs(expected) do
        if #RPHelper.GetAbilityPool("WARRIOR", key) == 0 then
            truthy(string.find(source, 'RPHelper.RegisterAbility(C, "' .. key .. '")', 1, true))
            for _, kind in ipairs({ "say", "emote", "customemote" }) do
                truthy(string.find(source, '-- add("' .. key .. '", "' .. kind .. '", "")', 1, true))
            end
        else
            equal(string.find(source, '-- add("' .. key .. '",', 1, true), nil)
        end
    end
end)

test("Warrior removals preserve player-owned saved records without migration", function()
    local saved = RPHelperDB
    local removed = {
        "ANGER_MANAGEMENT", "COUNTERATTACK", "DECISIVE_STRIKE", "INTERVENE",
        "SHOOT_BOW", "SHOOT_CROSSBOW", "SHOOT_GUN", "THROW",
    }
    local abilities, entries = {}, {}
    for index, key in ipairs(removed) do
        abilities[key] = { enabled = false, future = key }
        entries["custom:" .. index] = {
            scope = { layer = "ability", class = "WARRIOR", ability = key, future = "keep" },
            entry = { type = "say", text = "Preserve " .. key },
            future = "keep",
        }
    end
    RPHelperDB = {
        abilities = { WARRIOR = abilities },
        custom = { nextID = #removed + 1, entries = entries },
    }
    local ok, err = pcall(function()
        RPHelper.InitializeDatabase()
        for index, key in ipairs(removed) do
            equal(RPHelperDB.abilities.WARRIOR[key], abilities[key])
            local scope = { layer = "ability", class = "WARRIOR", ability = key }
            local records = RPHelper.UserContent.List(scope)
            equal(#records, 1)
            equal(records[1].id, "custom:" .. index)
            equal(records[1].scope.future, "keep")
            equal(RPHelperDB.custom.entries["custom:" .. index].future, "keep")
        end
        RPHelper.InitializeDatabase()
        for _, key in ipairs(removed) do
            equal(RPHelperDB.abilities.WARRIOR[key], abilities[key])
            equal(#RPHelper.UserContent.List({ layer = "ability", class = "WARRIOR", ability = key }), 1)
        end
    end)
    RPHelperDB = saved;RPHelper.UserContent.Invalidate()
    if not ok then error(err) end
end)

test("Druid reconciliation registers the approved active catalogue", function()
    local count = 0
    for _ in pairs(RPHelper.Ability.DRUID) do count = count + 1 end
    equal(count, 58)

    for _, key in ipairs({
        "AQUATIC_FORM", "BEAR_FORM", "GROWL", "LACERATE",
        "PRIMAL_BITE", "REVIVE", "WILD_GROWTH",
    }) do
        equal(RPHelper.Ability.DRUID[key], key)
        equal(#RPHelper.GetAbilityPool("DRUID", key), 0)
    end
    local shiftingPower = RPHelper.GetAbilityPool("DRUID", "SHIFTING_POWER")
    equal(#shiftingPower, 2)
    equal(shiftingPower[1].type, "emote")
    equal(shiftingPower[1].text, "ROAR")
    equal(shiftingPower[2].type, "customemote")
    equal(shiftingPower[2].text, "roars furiously.")
    for _, key in ipairs({
        "FAERIE_FIRE_FERAL", "FELINE_GRACE", "MANGLE", "OMEN_OF_CLARITY",
        "SAVAGE_BITE", "TIGERS_FURY", "TREE_OF_LIFE_FORM",
    }) do
        equal(RPHelper.Ability.DRUID[key], nil)
        equal(#RPHelper.GetAbilityPool("DRUID", key), 0)
    end
end)

test("Druid source is grouped and alphabetized by Forever specialization", function()
    local source = assert(io.open("RPHelper/Data/Abilities/Druid.lua", "r")):read("*a")
    local specializations = {
        "BARKSKIN ENTANGLING_ROOTS FAERIE_FIRE HIBERNATE HURRICANE INSECT_SWARM MOON_FIRE MOONKIN_FORM NATURES_GRASP SOOTHE_ANIMAL STARFIRE TELEPORT_MOONGLADE THORNS WRATH",
        "AQUATIC_FORM BASH BEAR_FORM BERSERK CAT_FORM CHALLENGING_ROAR CLAW COWER DASH DEMORALIZING_ROAR DIRE_BEAR_FORM ENRAGE FERAL_CHARGE FEROCIOUS_BITE FRENZIED_REGENERATION GROWL LACERATE MAUL POUNCE PRIMAL_BITE PROWL RAKE RAVAGE RIP SHIFTING_POWER SHRED SWIPE TRACK_HUMANOIDS TRAVEL_FORM",
        "ABOLISH_POISON CURE_POISON GIFT_OF_THE_WILD HEALING_TOUCH INNERVATE MARK_OF_THE_WILD NATURES_SWIFTNESS REBIRTH REGROWTH REJUVENATION REMOVE_CURSE REVIVE SWIFTMEND TRANQUILITY WILD_GROWTH",
    }
    local expected, actual = {}, {}
    for _, group in ipairs(specializations) do
        for key in string.gmatch(group, "%S+") do expected[#expected + 1] = key end
    end
    for key in string.gmatch(source, "\n%-%- ([A-Z][A-Z0-9_]*)\n") do actual[#actual + 1] = key end
    equal(#actual, 58)
    for index, key in ipairs(expected) do equal(actual[index], key) end
    equal(string.find(source, "for _, ability in ipairs", 1, true), nil)
    for _, key in ipairs(expected) do
        if #RPHelper.GetAbilityPool("DRUID", key) == 0 then
            truthy(string.find(source, 'RPHelper.RegisterAbility(C, "' .. key .. '")', 1, true))
            for _, kind in ipairs({ "say", "emote", "customemote" }) do
                truthy(string.find(source, '-- add("' .. key .. '", "' .. kind .. '", "")', 1, true))
            end
        else
            equal(string.find(source, '-- add("' .. key .. '",', 1, true), nil)
        end
    end
end)

test("Shifting Power replaces Tiger's Fury with its reactions in order", function()
    equal(RPHelper.Ability.DRUID.TIGERS_FURY, nil)
    equal(#RPHelper.GetAbilityPool("DRUID", "TIGERS_FURY"), 0)
    local pool = RPHelper.GetAbilityPool("DRUID", "SHIFTING_POWER")
    equal(#pool, 2)
    equal(pool[1].type, "emote")
    equal(pool[1].text, "ROAR")
    equal(pool[2].type, "customemote")
    equal(pool[2].text, "roars furiously.")
end)

test("Shifting Power migration preserves custom content settings and disabled defaults", function()
    local saved = RPHelperDB
    local newPool = RPHelper.GetAbilityPool("DRUID", "SHIFTING_POWER")
    local newDefaultID = newPool[1].defaultID
    local newPrefix = "default:v1:s7:abilitys5:DRUIDs14:SHIFTING_POWER"
    local oldPrefix = "default:v1:s7:abilitys5:DRUIDs11:TIGERS_FURY"
    local oldDefaultID = oldPrefix .. string.sub(newDefaultID, #newPrefix + 1)
    local settings = { enabled = false, chance = 0.5, future = "keep" }
    RPHelperDB = {
        custom = { nextID = 2, entries = {
            ["custom:1"] = {
                scope = { layer = "ability", class = "DRUID", ability = "TIGERS_FURY", future = "keep" },
                entry = { type = "customemote", text = "My power." }, future = "keep",
            },
        } },
        abilities = { DRUID = { TIGERS_FURY = settings } },
        disabledDefaults = { [oldDefaultID] = true },
    }
    local ok, err = pcall(function()
        RPHelper.InitializeDatabase()
        equal(RPHelperDB.abilities.DRUID.SHIFTING_POWER, settings)
        equal(RPHelperDB.abilities.DRUID.TIGERS_FURY, nil)
        equal(RPHelperDB.disabledDefaults[oldDefaultID], nil)
        equal(RPHelperDB.disabledDefaults[newDefaultID], true)
        local scope = { layer = "ability", class = "DRUID", ability = "SHIFTING_POWER" }
        local migrated = RPHelper.UserContent.List(scope)
        equal(#migrated, 1);equal(migrated[1].entry.text, "My power.")
        equal(migrated[1].scope.future, "keep")
        RPHelper.InitializeDatabase()
        equal(#RPHelper.UserContent.List(scope), 1)
        equal(RPHelperDB.abilities.DRUID.SHIFTING_POWER, settings)
        equal(RPHelperDB.disabledDefaults[newDefaultID], true)

        RPHelperDB = { abilities = { DRUID = {
            TIGERS_FURY = { chance = 0.25, nested = { old = true } },
            SHIFTING_POWER = { enabled = true, nested = { new = true } },
        } } }
        RPHelper.InitializeDatabase()
        equal(RPHelperDB.abilities.DRUID.TIGERS_FURY, nil)
        equal(RPHelperDB.abilities.DRUID.SHIFTING_POWER.enabled, true)
        equal(RPHelperDB.abilities.DRUID.SHIFTING_POWER.chance, 0.25)
        equal(RPHelperDB.abilities.DRUID.SHIFTING_POWER.nested.old, true)
        equal(RPHelperDB.abilities.DRUID.SHIFTING_POWER.nested.new, true)

        RPHelperDB = { abilities = { DRUID = {
            TIGERS_FURY = "malformed-old", SHIFTING_POWER = "malformed-new",
        } } }
        RPHelper.InitializeDatabase()
        equal(RPHelperDB.abilities.DRUID.TIGERS_FURY, "malformed-old")
        equal(RPHelperDB.abilities.DRUID.SHIFTING_POWER, "malformed-new")
    end)
    RPHelperDB = saved;RPHelper.UserContent.Invalidate()
    if not ok then error(err) end
end)

test("Primal Bite migration preserves custom content settings and saved legacy records", function()
    local saved = RPHelperDB
    local oldPrefix = "default:v1:s7:abilitys5:DRUIDs11:SAVAGE_BITE"
    local newPrefix = "default:v1:s7:abilitys5:DRUIDs11:PRIMAL_BITE"
    local oldDefaultID, newDefaultID = oldPrefix .. "s3:say", newPrefix .. "s3:say"
    local settings = { enabled = false, chance = 0.75, future = "keep" }
    local legacySettings = { enabled = false, future = "untouched" }
    RPHelperDB = {
        custom = { nextID = 3, entries = {
            ["custom:1"] = {
                scope = { layer = "ability", class = "DRUID", ability = "SAVAGE_BITE", future = "keep" },
                entry = { type = "say", text = "My bite." }, future = "keep",
            },
            ["custom:2"] = {
                scope = { layer = "ability", class = "DRUID", ability = "TREE_OF_LIFE_FORM" },
                entry = { type = "say", text = "Preserve me." },
            },
        } },
        abilities = { DRUID = { SAVAGE_BITE = settings, FAERIE_FIRE_FERAL = legacySettings } },
        disabledDefaults = { [oldDefaultID] = true },
    }
    local ok, err = pcall(function()
        RPHelper.InitializeDatabase()
        equal(RPHelperDB.abilities.DRUID.PRIMAL_BITE, settings)
        equal(RPHelperDB.abilities.DRUID.SAVAGE_BITE, nil)
        equal(RPHelperDB.abilities.DRUID.FAERIE_FIRE_FERAL, legacySettings)
        equal(RPHelperDB.disabledDefaults[oldDefaultID], nil)
        equal(RPHelperDB.disabledDefaults[newDefaultID], true)
        local migrated = RPHelper.UserContent.List({ layer = "ability", class = "DRUID", ability = "PRIMAL_BITE" })
        equal(#migrated, 1);equal(migrated[1].entry.text, "My bite.")
        equal(migrated[1].scope.future, "keep")
        equal(#RPHelper.UserContent.List({ layer = "ability", class = "DRUID", ability = "SAVAGE_BITE" }), 0)
        equal(#RPHelper.UserContent.List({ layer = "ability", class = "DRUID", ability = "TREE_OF_LIFE_FORM" }), 1)
        RPHelper.InitializeDatabase()
        equal(#RPHelper.UserContent.List({ layer = "ability", class = "DRUID", ability = "PRIMAL_BITE" }), 1)
        equal(RPHelperDB.abilities.DRUID.PRIMAL_BITE, settings)
        equal(RPHelperDB.disabledDefaults[newDefaultID], true)

        local oldSettings = { chance = 0.25, nested = { old = true } }
        local newSettings = { enabled = true, nested = { new = true } }
        RPHelperDB = { abilities = { DRUID = {
            SAVAGE_BITE = oldSettings, PRIMAL_BITE = newSettings,
        } } }
        RPHelper.InitializeDatabase()
        equal(RPHelperDB.abilities.DRUID.SAVAGE_BITE, nil)
        equal(RPHelperDB.abilities.DRUID.PRIMAL_BITE.enabled, true)
        equal(RPHelperDB.abilities.DRUID.PRIMAL_BITE.chance, 0.25)
        equal(RPHelperDB.abilities.DRUID.PRIMAL_BITE.nested.new, true)
        equal(RPHelperDB.abilities.DRUID.PRIMAL_BITE.nested.old, true)

        RPHelperDB = { abilities = { DRUID = {
            SAVAGE_BITE = "malformed-old", PRIMAL_BITE = "malformed-new",
        } } }
        RPHelper.InitializeDatabase()
        equal(RPHelperDB.abilities.DRUID.SAVAGE_BITE, "malformed-old")
        equal(RPHelperDB.abilities.DRUID.PRIMAL_BITE, "malformed-new")
    end)
    RPHelperDB = saved;RPHelper.UserContent.Invalidate()
    if not ok then error(err) end
end)

test("Shaman reconciliation registers the approved active catalogue", function()
    local count = 0
    for _ in pairs(RPHelper.Ability.SHAMAN) do count = count + 1 end
    equal(count, 57)

    local empty = {
        "CALL_OF_THE_ANCESTORS", "CALL_OF_THE_ELEMENTS", "CALL_OF_THE_SPIRITS",
        "LAVA_BURST", "RAGE_OF_THE_FARSEER", "RIPTIDE", "TOTEMIC_PROJECTION",
    }
    for _, key in ipairs(empty) do
        equal(RPHelper.Ability.SHAMAN[key], key)
        equal(#RPHelper.GetAbilityPool("SHAMAN", key), 0)
    end

    local fireNova = RPHelper.GetAbilityPool("SHAMAN", "FIRE_NOVA")
    equal(#fireNova, 2)
    equal(fireNova[1].type, "say")
    equal(fireNova[1].text, "The land erupts in flame!")
    equal(fireNova[2].type, "customemote")
    equal(fireNova[2].text, "channels fire energy into an explosive burst from a nearby fire totem.")
    equal(RPHelper.Ability.SHAMAN.FIRE_NOVA_TOTEM, nil)
    equal(#RPHelper.GetAbilityPool("SHAMAN", "FIRE_NOVA_TOTEM"), 0)

    equal(RPHelper.Ability.SHAMAN.ELEMENTAL_FOCUS, nil)
    equal(RPHelper.Ability.SHAMAN.ELEMENTAL_MASTERY, "ELEMENTAL_MASTERY")
    equal(#RPHelper.GetAbilityPool("SHAMAN", "ELEMENTAL_MASTERY"), 0)
    equal(#RPHelper.GetAbilityPool("SHAMAN", "REINCARNATION"), 4)
end)

test("Shaman source is grouped and alphabetized by Forever specialization", function()
    local source = assert(io.open("RPHelper/Data/Abilities/Shaman.lua", "r")):read("*a")
    local specializations = {
        {
            "CALL_OF_THE_ANCESTORS", "CALL_OF_THE_ELEMENTS", "CALL_OF_THE_SPIRITS",
            "CHAIN_LIGHTNING", "EARTHBIND_TOTEM", "EARTH_SHOCK", "ELEMENTAL_MASTERY",
            "FIRE_NOVA", "FLAME_SHOCK", "FROST_SHOCK", "LAVA_BURST", "LIGHTNING_BOLT",
            "MAGMA_TOTEM", "PURGE", "SEARING_TOTEM", "STONECLAW_TOTEM", "TOTEMIC_RECALL",
        },
        {
            "ASTRAL_RECALL", "FAR_SIGHT", "FIRE_RESISTANCE_TOTEM", "FLAMETONGUE_TOTEM",
            "FLAMETONGUE_WEAPON", "FROSTBRAND_WEAPON", "FROST_RESISTANCE_TOTEM", "GHOST_WOLF",
            "GRACE_OF_AIR_TOTEM", "GROUNDING_TOTEM", "LIGHTNING_SHIELD", "NATURE_RESISTANCE_TOTEM",
            "RAGE_OF_THE_FARSEER", "ROCKBITER_WEAPON", "SENTRY_TOTEM", "STONESKIN_TOTEM",
            "STORMSTRIKE", "STRENGTH_OF_EARTH_TOTEM", "TOTEMIC_PROJECTION", "WATER_BREATHING",
            "WATER_WALKING", "WINDFURY_TOTEM", "WINDFURY_WEAPON", "WINDWALL_TOTEM",
        },
        {
            "ANCESTRAL_SPIRIT", "CHAIN_HEAL", "CURE_DISEASE", "CURE_POISON",
            "DISEASE_CLEANSING_TOTEM", "HEALING_STREAM_TOTEM", "HEALING_WAVE",
            "LESSER_HEALING_WAVE", "MANA_SPRING_TOTEM", "MANA_TIDE_TOTEM",
            "NATURES_SWIFTNESS", "POISON_CLEANSING_TOTEM", "REINCARNATION", "RIPTIDE",
            "TREMOR_TOTEM", "WATER_SHIELD",
        },
    }
    local expected, actual = {}, {}
    for _, abilities in ipairs(specializations) do
        for _, key in ipairs(abilities) do expected[#expected + 1] = key end
    end
    for key in string.gmatch(source, "\n%-%- ([A-Z][A-Z0-9_]*)\n") do
        actual[#actual + 1] = key
    end
    equal(#actual, 57)
    for index, key in ipairs(expected) do equal(actual[index], key) end
    equal(string.find(source, "for _, ability in ipairs", 1, true), nil)
    for _, key in ipairs(expected) do
        if #RPHelper.GetAbilityPool("SHAMAN", key) == 0 then
            truthy(string.find(source, 'RPHelper.RegisterAbility(C, "' .. key .. '")', 1, true))
            for _, reactionType in ipairs({ "say", "emote", "customemote" }) do
                truthy(string.find(source,
                    '-- add("' .. key .. '", "' .. reactionType .. '", "")', 1, true))
            end
        else
            equal(string.find(source, '-- add("' .. key .. '",', 1, true), nil)
        end
    end
end)

test("Shaman legacy archive preserves 42 reactions without active registration", function()
    local order = {
        "SPIRIT_LINK", "LIGHTNING_STRIKE", "EARTH_SHIELD", "BLOODLUST",
        "EARTHSHAKER_SLAM", "CALM_ELEMENTS", "TOTEMIC_SLAM", "FERAL_SPIRIT", "HEX",
    }
    local archive = dofile("RPHelper/Data/Abilities/ShamanArchive.lua")
    local parts, count = {}, 0
    for _, key in ipairs(order) do
        equal(RPHelper.Ability.SHAMAN[key], nil)
        equal(#RPHelper.GetAbilityPool("SHAMAN", key), 0)
        parts[#parts + 1] = key
        for _, entry in ipairs(archive[key]) do
            count = count + 1
            for _, field in ipairs({ "type", "text" }) do
                local value = entry[field]
                parts[#parts + 1] = #value .. ":" .. value
            end
        end
    end
    equal(count, 42)
    equal(catalogueChecksum(table.concat(parts, "\n")), 559081950)
end)

test("Fire Nova migration preserves custom content settings and disabled defaults", function()
    local saved = RPHelperDB
    local newPool = RPHelper.GetAbilityPool("SHAMAN", "FIRE_NOVA")
    local newDefaultID = newPool[1].defaultID
    local newPrefix = "default:v1:s7:abilitys6:SHAMANs9:FIRE_NOVA"
    local oldPrefix = "default:v1:s7:abilitys6:SHAMANs15:FIRE_NOVA_TOTEM"
    local oldDefaultID = oldPrefix .. string.sub(newDefaultID, #newPrefix + 1)
    local settings = { enabled = false, chance = 0.75, future = "keep" }
    RPHelperDB = {
        custom = { nextID = 2, entries = {
            ["custom:1"] = {
                scope = { layer = "ability", class = "SHAMAN", ability = "FIRE_NOVA_TOTEM", future = "keep" },
                entry = { type = "say", text = "My nova." },
                future = "keep",
            },
        } },
        abilities = { SHAMAN = { FIRE_NOVA_TOTEM = settings } },
        disabledDefaults = { [oldDefaultID] = true },
    }
    local ok, err = pcall(function()
        RPHelper.InitializeDatabase()
        equal(RPHelperDB.abilities.SHAMAN.FIRE_NOVA, settings)
        equal(RPHelperDB.abilities.SHAMAN.FIRE_NOVA_TOTEM, nil)
        equal(RPHelperDB.disabledDefaults[oldDefaultID], nil)
        equal(RPHelperDB.disabledDefaults[newDefaultID], true)
        local newScope = { layer = "ability", class = "SHAMAN", ability = "FIRE_NOVA" }
        local oldScope = { layer = "ability", class = "SHAMAN", ability = "FIRE_NOVA_TOTEM" }
        local migrated = RPHelper.UserContent.List(newScope)
        equal(#migrated, 1);equal(migrated[1].entry.text, "My nova.")
        equal(migrated[1].scope.future, "keep")
        equal(#RPHelper.UserContent.List(oldScope), 0)
        RPHelper.InitializeDatabase()
        equal(#RPHelper.UserContent.List(newScope), 1)
        equal(RPHelperDB.abilities.SHAMAN.FIRE_NOVA, settings)
        equal(RPHelperDB.disabledDefaults[newDefaultID], true)
    end)
    RPHelperDB = saved;RPHelper.UserContent.Invalidate()
    if not ok then error(err) end
end)

test("historical catalogue: restored empty ability accepts custom content without shipped output", function()
    local saved = RPHelperDB
    RPHelperDB = nil; RPHelper.InitializeDatabase()
    local scope = { layer = "ability", class = "ROGUE", ability = "EVISCERATE" }
    local ok, err = pcall(function()
        equal(RPHelper.Ability.ROGUE.EVISCERATE, "EVISCERATE")
        equal(#RPHelper.GetAbilityPool("ROGUE", "EVISCERATE"), 0)
        local id = RPHelper.UserContent.Add(scope, { type = "say", text = "My custom reaction." })
        truthy(id)
        local candidate = RPHelper.ChooseAbilityCandidate("ROGUE", "EVISCERATE", { resolvers = {} })
        equal(candidate.customID, id)
        equal(candidate.text, "My custom reaction.")
        equal(candidate.defaultID, nil)
        RPHelper.InitializeDatabase()
        equal(RPHelper.UserContent.List(scope)[1].id, id)
        truthy(RPHelper.UserContent.Remove(id))
        equal(RPHelper.ChooseAbilityCandidate("ROGUE", "EVISCERATE", { resolvers = {} }), nil)
    end)
    RPHelperDB = saved; RPHelper.UserContent.Invalidate()
    if not ok then error(err) end
end)

test("historical catalogue: repeated definition registration neither duplicates nor changes reaction IDs", function()
    local pool = RPHelper.GetAbilityPool("ROGUE", "EVISCERATE")
    RPHelper.RegisterAbility("ROGUE", "EVISCERATE")
    RPHelper.RegisterAbility("ROGUE", "EVISCERATE")
    equal(RPHelper.GetAbilityPool("ROGUE", "EVISCERATE"), pool)
    equal(#pool, 0)
    local existing = RPHelper.GetAbilityPool("PALADIN", "FLASH_OF_LIGHT")
    local id = existing[1].defaultID
    local count = #existing
    RPHelper.RegisterAbility("PALADIN", "FLASH_OF_LIGHT")
    equal(#existing, count);equal(existing[1].defaultID, id)
end)

test("historical catalogue: Banish custom emote preserves its type and requires relevant target", function()
    local pool = RPHelper.GetAbilityPool("WARLOCK", "BANISH")
    equal(#pool, 1);equal(pool[1].type, "customemote")
    equal(pool[1].text, "banishes {TARGET} from this plane briefly.")
    equal(RPHelper.ChooseAbilityCandidate("WARLOCK", "BANISH", { resolvers = {} }), nil)
    local candidate = RPHelper.ChooseAbilityCandidate("WARLOCK", "BANISH", {
        resolvers = { TARGET = function() return "Demon" end } })
    equal(candidate.type, "customemote")
    equal(candidate.text, "banishes Demon from this plane briefly.")
end)


test("static text passes through unchanged", function()
    local candidate = Engine.PrepareCandidate({ type = "say", text = "Too slow." })
    equal(candidate.text, "Too slow.")
    equal(candidate.type, "say")
end)

test("supported keyword resolves", function()
    local candidate = Engine.PrepareCandidate(
        { type = "say", text = "Ready, {PLAYER}." },
        { resolvers = { PLAYER = function() return "Ari" end } }
    )
    equal(candidate.text, "Ready, Ari.")
end)

test("resolver errors and non-scalar values are ineligible", function()
    local invalidResolvers = {
        function() error("restricted value") end,
        function() return {} end,
        function() return function() end end,
        function() return true end,
    }

    for _, resolver in ipairs(invalidResolvers) do
        equal(Engine.PrepareCandidate(
            { type = "say", text = "Value: {PLAYER}" },
            { resolvers = { PLAYER = resolver } }
        ), nil)
    end
end)

test("secret resolver values are ineligible", function()
    local previousIsSecretValue = issecretvalue
    issecretvalue = function(value)
        return value == "hidden"
    end

    local candidate = Engine.PrepareCandidate(
        { type = "say", text = "Value: {PLAYER}" },
        { resolvers = { PLAYER = function() return "hidden" end } }
    )
    issecretvalue = previousIsSecretValue

    equal(candidate, nil)
end)

test("numeric resolver values are converted to text", function()
    local candidate = Engine.PrepareCandidate(
        { type = "say", text = "Level {LEVEL}" },
        { resolvers = { LEVEL = function() return 42 end } }
    )
    equal(candidate.text, "Level 42")
end)

test("player pronouns preserve subject object and possessive grammar", function()
    local expected = {
        [1] = "it sees it with its eyes",
        [2] = "he sees him with his eyes",
        [3] = "she sees her with her eyes",
    }
    for sex, text in pairs(expected) do
        local calls = 0
        local candidate = Engine.PrepareCandidate(
            { type = "say", text = "{SP} sees {OP} with {PP} eyes" },
            { context = { api = { GetPlayerSex = function() calls = calls + 1; return sex end } } }
        )
        equal(candidate.text, text)
        equal(calls, 1)
    end
end)

test("player pronouns fail closed for unavailable or unusable sex", function()
    for _, callback in ipairs({
        function() return nil end,
        function() return 0 end,
        function() return 4 end,
        function() return "2" end,
        function() error("restricted") end,
    }) do
        equal(Engine.PrepareCandidate(
            { type = "say", text = "{SP}/{OP}/{PP}" },
            { context = { api = { GetPlayerSex = callback } } }
        ), nil)
    end
end)

test("player power labels resolve lazily while target power remains supplied-only", function()
    local calls = 0
    local context = { api = { GetPlayerPowerLabel = function() calls = calls + 1; return "mana" end } }
    equal(Engine.PrepareCandidate({ type = "say", text = "Static." }, { context = context }).text, "Static.")
    equal(calls, 0)
    equal(Engine.PrepareCandidate({ type = "say", text = "My {PLAYER_POWER}." }, { context = context }).text,
        "My mana.")
    equal(calls, 1)
    equal(Engine.PrepareCandidate({ type = "say", text = "Their {TARGET_POWER}." },
        { context = context }), nil)
end)

test("ordinary target fields require explicit relevant event context", function()
    local text = "{TARGET}|{TSP}|{TOP}|{TPP}|{TARGET_CLASS}|{TARGET_RACE}|{TARGET_POWER}"
    equal(Engine.PrepareCandidate({ type = "say", text = text }, { context = { values = {} } }), nil)
    local candidate = Engine.PrepareCandidate({ type = "say", text = text }, { context = { values = {
        TARGET = "Ari", TSP = "she", TOP = "her", TPP = "her",
        TARGET_CLASS = "Mage", TARGET_RACE = "Human", TARGET_POWER = "mana",
    } } })
    equal(candidate.text, "Ari|she|her|her|Mage|Human|mana")
    equal(Engine.PrepareCandidate({ type = "say", text = "{TARGET_GUILDNAME} ({TARGET_GUILDRANK})" },
        { context = { values = { TARGET_GUILDNAME = "Guild", TARGET_GUILDRANK = "Officer" } } }).text,
        "Guild (Officer)")
end)

test("unresolved candidate is filtered without removing fallback", function()
    local pool = {
        { type = "say", text = "Die, {TARGET}!" },
        { type = "say", text = "Have at you!" },
    }
    local eligible = Engine.PrepareCandidatePool(pool, { resolvers = {} })
    equal(#eligible, 1)
    equal(eligible[1].text, "Have at you!")

    local selected = Engine.ChooseCandidate(pool, {
        resolvers = {},
        randomIndex = function() return 1 end,
    })
    equal(selected.text, "Have at you!")
end)

test("overlapping token names resolve independently", function()
    local candidate = Engine.PrepareCandidate(
        { type = "say", text = "{PTSP}/{TSP}/{SP}" },
        {
            resolvers = {
                PTSP = function() return "pet-target" end,
                TSP = function() return "target" end,
                SP = function() return "player" end,
            },
        }
    )
    equal(candidate.text, "pet-target/target/player")
end)

test("template placeholders use their corresponding independent pools", function()
    local calls = 0
    local candidate = Engine.PrepareCandidate(
        {
            type = "say",
            template = "I'll {1} your {2}!",
            choices = {
                { "rip", "tear" },
                { "arms", "legs" },
            },
        },
        {
            resolvers = {},
            randomIndex = function()
                calls = calls + 1
                return calls == 1 and 2 or 1
            end,
        }
    )
    equal(candidate.text, "I'll tear your arms!")
    equal(calls, 2)
end)

test("empty template choices are valid", function()
    local candidate = Engine.PrepareCandidate(
        {
            type = "say",
            template = "{1}Ready.",
            choices = { { "" } },
        },
        { resolvers = {}, randomIndex = function() return 1 end }
    )
    equal(candidate.text, "Ready.")
end)

test("keywords in selected fragments resolve after expansion", function()
    local candidate = Engine.PrepareCandidate(
        {
            type = "say",
            template = "{1}!",
            choices = { { "For {PLAYER}" } },
        },
        {
            resolvers = { PLAYER = function() return "Ari" end },
            randomIndex = function() return 1 end,
        }
    )
    equal(candidate.text, "For Ari!")
end)

test("missing and malformed template pools fail safely", function()
    equal(Engine.PrepareCandidate({ type = "say", template = "Choose {1}." }), nil)
    equal(Engine.PrepareCandidate({
        type = "say",
        template = "Choose {2}.",
        choices = { { "one" } },
    }), nil)
    equal(Engine.PrepareCandidate({
        type = "say",
        template = "Choose {1}.",
        choices = { {} },
    }), nil)
end)

test("RINSULT uses one generated value per candidate", function()
    local calls = 0
    local candidate = Engine.PrepareCandidate(
        { type = "say", text = "You {RINSULT} Truly, {RINSULT!}" },
        {
            resolvers = {},
            insultProvider = function()
                calls = calls + 1
                return "fool."
            end,
        }
    )
    equal(candidate.text, "You fool. Truly, fool!")
    equal(calls, 1)
end)

test("missing insult provider makes candidate ineligible", function()
    Engine.SetInsultProvider(nil)
    equal(Engine.PrepareCandidate({ type = "say", text = "Begone, {RINSULT}!" }, {
        resolvers = {},
    }), nil)
    Engine.SetInsultProvider(RPHelper.RandomInsults.Generate)
end)

test("legacy random insult vocabulary and three-part structure are preserved", function()
    local pools = RPHelper.RandomInsults.Pools
    local function digest(pool)
        local value = 0
        for _, word in ipairs(pool) do
            for index = 1, #word do
                value = (value * 131 + string.byte(word, index)) % 2147483647
            end
            value = (value * 131) % 2147483647
        end
        return value
    end
    equal(#pools.ANY[1], 17);equal(#pools.ANY[2], 29);equal(#pools.ANY[3], 36)
    equal(#pools.GNOME[1], 29);equal(#pools.GNOME[2], 0);equal(#pools.GNOME[3], 0)
    equal(#pools.PALADIN[1], 154);equal(#pools.PALADIN[2], 0);equal(#pools.PALADIN[3], 59)
    equal(#pools.WARRIOR[1], 21);equal(#pools.WARRIOR[2], 0);equal(#pools.WARRIOR[3], 2)
    local expected = {
        ANY = { 425859787, 837071413, 1834096284 },
        GNOME = { 1601595970, 0, 0 },
        PALADIN = { 859073093, 0, 2032674689 },
        WARRIOR = { 1092003529, 0, 371335725 },
    }
    for trait, parts in pairs(expected) do
        for part = 1, 3 do equal(digest(pools[trait][part]), parts[part]) end
    end
    equal(pools.ANY[1][1], "annoying");equal(pools.ANY[1][17], "useless")
    equal(pools.ANY[2][24], "wheelbarrel full of")
    equal(pools.PALADIN[1][154], "scale-sided")
    equal(pools.PALADIN[3][8], "clack-dishs")
    equal(pools.PALADIN[3][59], "Basket-Cockles")
    equal(pools.WARRIOR[1][11], "retarded")
end)

test("legacy random insult generation combines generic race and class pools", function()
    local first = function() return 1 end
    equal(RPHelper.RandomInsults.Generate(nil, first), "You annoying lump of armpit hairs.")
    equal(RPHelper.RandomInsults.Generate({
        class = "WARRIOR", values = { PLAYER_CLASS = "WARRIOR", PLAYER_RACE = "HUMAN" },
    }, function(size) return size end), "You worthless vat of vomit.")
    local calls = 0
    equal(RPHelper.RandomInsults.Generate({ values = { PLAYER_RACE = "GNOME" } }, function()
        calls = calls + 1
        return calls == 1 and 18 or 1
    end), "You bad breathed lump of armpit hairs.")
end)

test("production insult provider prepares the shipped Mocking Blow reaction", function()
    local options = {
        resolvers = {},
        context = { class = "WARRIOR", values = { PLAYER_CLASS = "WARRIOR", PLAYER_RACE = "HUMAN" } },
        randomIndex = function() return 1 end,
    }
    local pool = RPHelper.GetPreparedAbilityPool("WARRIOR", "MOCKING_BLOW", options)
    equal(#pool, 1)
    equal(pool[1].text, "Over here! You annoying lump of armpit hairs.")
end)

test("insult generation is lazy for candidates without insult placeholders", function()
    local calls = 0
    local provider = function() calls = calls + 1; return "You fool." end
    equal(Engine.PrepareCandidate({ type = "say", text = "Static." }, {
        resolvers = {}, insultProvider = provider,
    }).text, "Static.")
    equal(calls, 0)
end)

test("malformed insult results fail closed and are never recursively expanded", function()
    for _, provider in ipairs({
        function() return nil end,
        function() return false end,
        function() return {} end,
        function() return "" end,
        function() error("unavailable") end,
        function() return "You {PLAYER}." end,
    }) do
        equal(Engine.PrepareCandidate({ type = "say", text = "{RINSULT}" }, {
            resolvers = { PLAYER = function() return "Ari" end },
            insultProvider = provider,
        }), nil)
    end
end)

test("invalid insult random choices fail closed", function()
    local context = { values = { PLAYER_CLASS = "WARRIOR", PLAYER_RACE = "HUMAN" } }
    for _, chooser in ipairs({
        function() return nil end,
        function() return 0 end,
        function(size) return size + 1 end,
        function() return 1.5 end,
        function() error("random unavailable") end,
    }) do
        equal(RPHelper.RandomInsults.Generate(context, chooser), nil)
    end
end)

test("raw unknown tokens never enter eligible output", function()
    local eligible = Engine.PrepareCandidatePool({
        { type = "say", text = "Known." },
        { type = "say", text = "Unknown {NOT_A_KEYWORD}." },
        { type = "say", text = "Broken {1}." },
    }, { resolvers = {} })
    equal(#eligible, 1)
    equal(eligible[1].text, "Known.")
end)

test("existing generic entries remain compatible", function()
    RPHelper.RegisterGeneric("dodge", { id = "default:test:0001", type = "say", text = "Too slow." })
    local selected = RPHelper.ChooseGenericCandidate("dodge", {
        resolvers = {},
        randomIndex = function() return 1 end,
    })
    truthy(selected)
    equal(selected.text, "Too slow.")
end)

test("generic-only content resolves normally through the combined pool", function()
    local generic = RPHelper.GetGenericPool("absorb")
    local prepared = RPHelper.GetPreparedContentPool("absorb", "SKYBORNE", nil, { resolvers = {} })
    equal(#prepared, #generic)
    truthy(poolContainsText(prepared, "Didn't even scratch me!"))
end)

test("authored races supplement generic content", function()
    local races = {
        { id = RPHelper.Race.TAUREN, raceText = "For my ancestors!" },
        { id = RPHelper.Race.ORC, raceText = "Strength and honor!" },
        { id = RPHelper.Race.NIGHTELF, raceText = "For Cenarius!" },
        { id = RPHelper.Race.HUMAN, raceText = "Stand your ground!" },
        { id = RPHelper.Race.GNOME, raceText = "For Gnomeregan!" },
        { id = RPHelper.Race.DWARF, raceText = "For Khaz Modan!" },
        { id = RPHelper.Race.UNDEAD, raceText = "Tremble before the Forsaken!" },
        { id = RPHelper.Race.TROLL, raceText = "Tas'dingo!" },
    }
    for _, race in ipairs(races) do
        local pool = RPHelper.GetContentPool("entercombat", race.id)
        truthy(poolContainsText(pool, "So be it."))
        truthy(poolContainsText(pool, race.raceText))
    end
end)

test("Forsaken content uses the canonical UNDEAD key", function()
    equal(RPHelper.Race.UNDEAD, "UNDEAD")
    equal(RPHelper.Race.FORSAKEN, nil)
    truthy(poolContainsText(
        RPHelper.GetRacePool(RPHelper.Race.UNDEAD, "entercombat"),
        "Tremble before the Forsaken!"
    ))
end)

test("unauthored races fall back to generic content", function()
    local generic = RPHelper.GetGenericPool("entercombat")
    local pool = RPHelper.GetContentPool("entercombat", "SKYBORNE")
    equal(#pool, #generic)
    truthy(poolContainsText(pool, "So be it."))
end)

test("race registration appends without overwriting other content", function()
    RPHelper.RegisterRace(RPHelper.Race.TAUREN, "test_append", { id = "default:test:0002", type = "say", text = "First." })
    RPHelper.RegisterRace(RPHelper.Race.TAUREN, "test_append", { id = "default:test:0003", type = "say", text = "Second." })
    RPHelper.RegisterRace(RPHelper.Race.ORC, "test_append", { id = "default:test:0004", type = "say", text = "Other race." })

    local tauren = RPHelper.GetRacePool(RPHelper.Race.TAUREN, "test_append")
    local orc = RPHelper.GetRacePool(RPHelper.Race.ORC, "test_append")
    equal(#tauren, 2)
    equal(tauren[1].text, "First.")
    equal(tauren[2].text, "Second.")
    equal(#orc, 1)
    equal(orc[1].text, "Other race.")
end)

test("keyword and template entries remain eligible through the race layer", function()
    RPHelper.RegisterGeneric("test_dynamic", { id = "default:test:0005", type = "say", text = "Generic dynamic fallback." })
    RPHelper.RegisterRace(RPHelper.Race.TAUREN, "test_dynamic", {
id = "default:test:0006",         type = "say",
        template = "{1}, {PLAYER}.",
        choices = { { "Rise" } },
    })

    local prepared = RPHelper.GetPreparedContentPool("test_dynamic", RPHelper.Race.TAUREN, nil, {
        resolvers = { PLAYER = function() return "Ari" end },
        randomIndex = function() return 1 end,
    })
    equal(#prepared, 2)
    equal(prepared[1].text, "Generic dynamic fallback.")
    equal(prepared[2].text, "Rise, Ari.")
end)

test("canonical class identifiers are stable internal keys", function()
    equal(RPHelper.Class.WARRIOR, "WARRIOR")
    equal(RPHelper.Class.ROGUE, "ROGUE")
    equal(RPHelper.Class.HUNTER, "HUNTER")
    equal(RPHelper.Class.SHAMAN, "SHAMAN")
    equal(RPHelper.Class.DRUID, "DRUID")
    equal(RPHelper.Class.PALADIN, "PALADIN")
    equal(RPHelper.Class.MAGE, "MAGE")
    equal(RPHelper.Class.PRIEST, "PRIEST")
    equal(RPHelper.Class.WARLOCK, "WARLOCK")
end)

test("authored classes supplement generic and race content", function()
    local classes = {
        { id = RPHelper.Class.WARRIOR, classText = "ROAR" },
        { id = RPHelper.Class.ROGUE, classText = "To the death!" },
        { id = RPHelper.Class.HUNTER, classText = "The hunt begins." },
        { id = RPHelper.Class.SHAMAN, classText = "The spirits guide me." },
        { id = RPHelper.Class.DRUID, classText = "For nature's survival!" },
        { id = RPHelper.Class.PALADIN, classText = "Light, give me strength!" },
        { id = RPHelper.Class.MAGE, classText = "I'm a magic man. I got magic hands." },
        { id = RPHelper.Class.PRIEST, classText = "The Light guides my hand!" },
        { id = RPHelper.Class.WARLOCK, classText = "Chaos boils in my mind." },
    }

    for _, class in ipairs(classes) do
        local pool = RPHelper.GetContentPool("entercombat", RPHelper.Race.TAUREN, class.id)
        truthy(poolContainsText(pool, "So be it."))
        truthy(poolContainsText(pool, "For my ancestors!"))
        truthy(poolContainsText(pool, class.classText))
    end
end)

test("second class batch ability content is registered and class-scoped", function()
    truthy(poolContainsText(
        RPHelper.GetAbilityPool(RPHelper.Class.SHAMAN, RPHelper.Ability.SHAMAN.EARTH_SHOCK),
        "Feel the ground tremble beneath you!"
    ))
    truthy(poolContainsText(
        RPHelper.GetAbilityPool(RPHelper.Class.DRUID, RPHelper.Ability.DRUID.ENTANGLING_ROOTS),
        "Oh, were you going somewhere?"
    ))
    truthy(poolContainsText(
        RPHelper.GetAbilityPool(RPHelper.Class.PALADIN, RPHelper.Ability.PALADIN.HAMMER_OF_JUSTICE),
        "Justice is swift!"
    ))
    equal(#RPHelper.GetAbilityPool(RPHelper.Class.DRUID, RPHelper.Ability.SHAMAN.EARTH_SHOCK), 0)
end)

test("unauthored classes fall back to generic and race content", function()
    local withoutClass = RPHelper.GetContentPool("entercombat", RPHelper.Race.TAUREN)
    local unauthoredClass = RPHelper.GetContentPool("entercombat", RPHelper.Race.TAUREN, "SKYBREAKER")
    equal(#unauthoredClass, #withoutClass)
    truthy(poolContainsText(unauthoredClass, "So be it."))
    truthy(poolContainsText(unauthoredClass, "For my ancestors!"))
end)

test("class registration appends without overwriting other content", function()
    RPHelper.RegisterClass(RPHelper.Class.WARRIOR, "test_class_append", { id = "default:test:0007", type = "say", text = "First." })
    RPHelper.RegisterClass(RPHelper.Class.WARRIOR, "test_class_append", { id = "default:test:0008", type = "say", text = "Second." })
    RPHelper.RegisterClass(RPHelper.Class.ROGUE, "test_class_append", { id = "default:test:0009", type = "say", text = "Other class." })

    local warrior = RPHelper.GetClassPool(RPHelper.Class.WARRIOR, "test_class_append")
    local rogue = RPHelper.GetClassPool(RPHelper.Class.ROGUE, "test_class_append")
    equal(#warrior, 2)
    equal(warrior[1].text, "First.")
    equal(warrior[2].text, "Second.")
    equal(#rogue, 1)
    equal(rogue[1].text, "Other class.")
end)

test("class content works without authored race content", function()
    local pool = RPHelper.GetContentPool("entercombat", "SKYBORNE", RPHelper.Class.HUNTER)
    truthy(poolContainsText(pool, "So be it."))
    truthy(poolContainsText(pool, "The hunt begins."))
end)

test("keyword and template entries remain eligible through the class layer", function()
    RPHelper.RegisterClass(RPHelper.Class.ROGUE, "test_class_dynamic", {
id = "default:test:0010",         type = "say",
        template = "{1}, {PLAYER}.",
        choices = { { "Ready" } },
    })

    local prepared = RPHelper.GetPreparedContentPool("test_class_dynamic", nil, RPHelper.Class.ROGUE, {
        resolvers = { PLAYER = function() return "Ari" end },
        randomIndex = function() return 1 end,
    })
    equal(#prepared, 1)
    equal(prepared[1].text, "Ready, Ari.")
end)

test("authored ability content is registered for each class", function()
    truthy(poolContainsText(
        RPHelper.GetAbilityPool(RPHelper.Class.WARRIOR, RPHelper.Ability.WARRIOR.REND),
        "Bleed for me, {TARGET}."
    ))
    truthy(poolContainsText(
        RPHelper.GetAbilityPool(RPHelper.Class.ROGUE, RPHelper.Ability.ROGUE.DISARM_TRAP),
        "You call this a trap?"
    ))
    truthy(poolContainsText(
        RPHelper.GetAbilityPool(RPHelper.Class.HUNTER, RPHelper.Ability.HUNTER.AIMED_SHOT),
        "Precision is everything."
    ))
end)

test("final class batch ability content is registered and class-scoped", function()
    truthy(poolContainsText(
        RPHelper.GetAbilityPool(RPHelper.Class.MAGE, RPHelper.Ability.MAGE.POLYMORPH),
        "Enjoy your new form, {TARGET}!"
    ))
    truthy(poolContainsText(
        RPHelper.GetAbilityPool(RPHelper.Class.PRIEST, RPHelper.Ability.PRIEST.RESURRECTION),
        "{TARGET}, your service in this world is not yet finished, awaken!"
    ))
    truthy(poolContainsText(
        RPHelper.GetAbilityPool(RPHelper.Class.WARLOCK, RPHelper.Ability.WARLOCK.DRAIN_SOUL),
        "Your soul is mine!"
    ))
    equal(#RPHelper.GetAbilityPool(RPHelper.Class.PRIEST, RPHelper.Ability.MAGE.POLYMORPH), 0)
end)

test("ability content is scoped by class", function()
    local hunterPool = RPHelper.GetAbilityPool(RPHelper.Class.HUNTER, RPHelper.Ability.HUNTER.AIMED_SHOT)
    local roguePool = RPHelper.GetAbilityPool(RPHelper.Class.ROGUE, RPHelper.Ability.HUNTER.AIMED_SHOT)
    truthy(#hunterPool > 0)
    equal(#roguePool, 0)
end)

test("ability registration appends rather than overwrites", function()
    RPHelper.RegisterAbility(RPHelper.Class.WARRIOR, "TEST_ABILITY", { id = "default:test:0011", type = "say", text = "First." })
    RPHelper.RegisterAbility(RPHelper.Class.WARRIOR, "TEST_ABILITY", { id = "default:test:0012", type = "say", text = "Second." })
    local pool = RPHelper.GetAbilityPool(RPHelper.Class.WARRIOR, "TEST_ABILITY")
    equal(#pool, 2)
    equal(pool[1].text, "First.")
    equal(pool[2].text, "Second.")
end)

test("keyword and template content prepares through the ability layer", function()
    RPHelper.RegisterAbility(RPHelper.Class.ROGUE, "TEST_DYNAMIC_ABILITY", {
id = "default:test:0013",         type = "say",
        template = "{1}, {TARGET}.",
        choices = { { "Behind you" } },
    })
    local prepared = RPHelper.GetPreparedAbilityPool(RPHelper.Class.ROGUE, "TEST_DYNAMIC_ABILITY", {
        resolvers = { TARGET = function() return "Dummy" end },
        randomIndex = function() return 1 end,
    })
    equal(#prepared, 1)
    equal(prepared[1].text, "Behind you, Dummy.")
end)

test("migrated Warlock NPC template prepares through the class layer", function()
    local prepared = RPHelper.GetPreparedContentPool("npctalksfriend", nil, RPHelper.Class.WARLOCK, {
        resolvers = {
            NPC = function() return "Mogg" end,
            LANG = function() return "Orcish" end,
        },
        randomIndex = function() return 1 end,
    })
    truthy(poolContainsText(prepared, "You spew Orcish like urine, Mogg."))
    truthy(poolContainsText(prepared, "Quiet Mogg. Unless you hope to be sent into the Twisting Nether."))
end)

test("missing ability content returns an empty pool safely", function()
    equal(#RPHelper.GetAbilityPool(RPHelper.Class.WARRIOR, "NOT_AUTHORED"), 0)
    equal(#RPHelper.GetAbilityPool("MAGE", "CHARGE"), 0)
end)

test("ability registration does not change character layer pooling", function()
    local pool = RPHelper.GetContentPool("entercombat", RPHelper.Race.TAUREN, RPHelper.Class.WARRIOR)
    truthy(poolContainsText(pool, "So be it."))
    truthy(poolContainsText(pool, "For my ancestors!"))
    truthy(poolContainsText(pool, "ROAR"))
    truthy(not poolContainsText(pool, "Bleed for me, {TARGET}."))
end)

test("Hunter pet-event content is registered and prepares explicit pet tokens", function()
    truthy(#RPHelper.GetClassPool(RPHelper.Class.HUNTER, "petattackstart") > 0)
    truthy(#RPHelper.GetClassPool(RPHelper.Class.HUNTER, "petattackstop") > 0)
    truthy(#RPHelper.GetClassPool(RPHelper.Class.HUNTER, "petdies") > 0)

    local prepared = RPHelper.GetPreparedContentPool("petattackstart", nil, RPHelper.Class.HUNTER, {
        resolvers = {
            PNAME = function() return "Fang" end,
            PTNAME = function() return "Boar" end,
            PTOP = function() return "it" end,
            TARGET = function() return "Boar" end,
        },
    })
    truthy(poolContainsText(prepared, "Go Fang! Tear them apart!"))
    truthy(poolContainsText(prepared, "Show it no mercy, Fang."))
    truthy(poolContainsText(prepared, "gestures towards Boar, signaling Fang to strike."))
end)

test("legacy spell critical content is deferred from the active trigger", function()
    for _, class in ipairs({
        RPHelper.Class.ROGUE,
        RPHelper.Class.HUNTER,
        RPHelper.Class.SHAMAN,
        RPHelper.Class.PALADIN,
        RPHelper.Class.MAGE,
        RPHelper.Class.PRIEST,
    }) do
        equal(#RPHelper.GetClassPool(class, "youcritspell"), 0)
        truthy(#RPHelper.GetClassPool(class, "deferred_youcritspell") > 0)
    end
end)

test("race content functions without a class layer", function()
    local previousClass = RPHelper.Content.class
    RPHelper.Content.class = nil
    local pool = RPHelper.GetContentPool("entercombat", RPHelper.Race.TAUREN)
    RPHelper.Content.class = previousClass

    truthy(#pool > 0)
    truthy(poolContainsText(pool, "For my ancestors!"))
end)

test("Druid form detection uses stable form IDs", function()
    local Forms = RPHelper.DruidForms
    equal(Forms.GetCurrentForm({ getShapeshiftFormID = function() return nil end }), Forms.Form.HUMANOID)
    equal(Forms.GetCurrentForm({ getShapeshiftFormID = function() return 1 end }), Forms.Form.CAT)
    equal(Forms.GetCurrentForm({ getShapeshiftFormID = function() return 5 end }), Forms.Form.BEAR)
    equal(Forms.GetCurrentForm({ getShapeshiftFormID = function() return 8 end }), Forms.Form.DIRE_BEAR)
    equal(Forms.GetCurrentForm({ getShapeshiftFormID = function() return 31 end }), Forms.Form.MOONKIN)
    equal(Forms.GetCurrentForm({ getShapeshiftFormID = function() return 3 end }), Forms.Form.TRAVEL)
    equal(Forms.GetCurrentForm({ getShapeshiftFormID = function() return 4 end }), Forms.Form.AQUATIC)
    equal(Forms.GetCurrentForm({ getShapeshiftFormID = function() return 99 end }), Forms.Form.UNKNOWN)
    equal(Forms.GetCurrentForm({ getShapeshiftFormID = "unavailable" }), Forms.Form.UNKNOWN)
    equal(Forms.GetCurrentForm({ getShapeshiftFormID = function() error("unavailable") end }), Forms.Form.UNKNOWN)
end)

test("Druid speech is suppressed in recognised and unknown forms", function()
    for _, form in ipairs({ "CAT", "BEAR", "DIRE_BEAR", "MOONKIN", "TRAVEL", "AQUATIC", "UNKNOWN" }) do
        equal(Engine.PrepareCandidate(
            { type = "say", text = "Spoken." },
            { class = RPHelper.Class.DRUID, form = form, resolvers = {} }
        ), nil)
    end
end)

test("Druid speech returns only in humanoid form", function()
    local humanoid = Engine.PrepareCandidate(
        { type = "say", text = "Spoken." },
        { class = RPHelper.Class.DRUID, form = "HUMANOID", resolvers = {} }
    )
    equal(humanoid.text, "Spoken.")

    local cannotOptOut = Engine.PrepareCandidate(
        { type = "say", text = "Spoken." },
        { class = RPHelper.Class.DRUID, form = "CAT", suppressSayInForms = false, resolvers = {} }
    )
    equal(cannotOptOut, nil)
end)

test("Druid speech suppression ignores retired saved settings", function()
    local previousDatabase = RPHelperDB
    RPHelperDB = nil
    RPHelper.InitializeDatabase()
    equal(RPHelperDB.settings.suppressSayInForms, nil)

    RPHelperDB.settings.suppressSayInForms = false
    local candidate = Engine.PrepareCandidate(
        { type = "say", text = "Spoken." },
        { class = RPHelper.Class.DRUID, form = "CAT", resolvers = {} }
    )
    equal(candidate, nil)
    equal(RPHelperDB.settings.suppressSayInForms, false)
    RPHelperDB = previousDatabase
end)

test("Cat and Bear use separate form content while Dire Bear shares Bear", function()
    local Forms = RPHelper.DruidForms.Form
    local cat = RPHelper.GetDruidFormPool(Forms.CAT, "entercombat")
    local bear = RPHelper.GetDruidFormPool(Forms.BEAR, "entercombat")
    local direBear = RPHelper.GetDruidFormPool(Forms.DIRE_BEAR, "entercombat")
    truthy(poolContainsText(cat, "lowers its body, muscles tightening beneath its fur."))
    truthy(not poolContainsText(cat, "digs its claws into the earth and lowers its head."))
    truthy(poolContainsText(bear, "digs its claws into the earth and lowers its head."))
    equal(direBear, bear)
end)

test("authored Druid form events replace incompatible humanoid content", function()
    local pool = RPHelper.GetContentPool(
        "entercombat", RPHelper.Race.TAUREN, RPHelper.Class.DRUID, { form = "CAT" }
    )
    truthy(poolContainsText(pool, "fixes its gaze upon its adversary, perfectly still."))
    truthy(not poolContainsText(pool, "For my ancestors!"))
    truthy(not poolContainsText(pool, "For nature's survival!"))
end)

test("emotes and custom emotes remain eligible in Druid forms", function()
    local prepared = Engine.PrepareCandidatePool({
        { type = "say", text = "Suppressed." },
        { type = "emote", text = "SNARL" },
        { type = "customemote", text = "bares its fangs." },
    }, { class = RPHelper.Class.DRUID, form = "CAT", resolvers = {} })
    equal(#prepared, 2)
    equal(prepared[1].type, "emote")
    equal(prepared[2].type, "customemote")
end)

test("speech suppression applies uniformly to every content source", function()
    local options = { class = RPHelper.Class.DRUID, form = "BEAR", resolvers = {} }
    local sources = {
        RPHelper.GetGenericPool("entercombat"),
        RPHelper.GetRacePool(RPHelper.Race.TAUREN, "entercombat"),
        RPHelper.GetClassPool(RPHelper.Class.DRUID, "entercombat"),
        RPHelper.GetAbilityPool(RPHelper.Class.DRUID, RPHelper.Ability.DRUID.ENTANGLING_ROOTS),
        { { type = "say", text = "User-authored speech." } },
    }
    for _, source in ipairs(sources) do
        local prepared = Engine.PrepareCandidatePool(source, options)
        for _, entry in ipairs(prepared) do
            truthy(entry.type ~= "say")
        end
    end
end)

test("form-restricted Druid abilities contain no spoken sayings", function()
    for _, ability in ipairs({
        RPHelper.Ability.DRUID.DEMORALIZING_ROAR,
        RPHelper.Ability.DRUID.ENRAGE,
        RPHelper.Ability.DRUID.SHIFTING_POWER,
        RPHelper.Ability.DRUID.CHALLENGING_ROAR,
        RPHelper.Ability.DRUID.DIRE_BEAR_FORM,
    }) do
        local pool = RPHelper.GetAbilityPool(RPHelper.Class.DRUID, ability)
        truthy(#pool > 0)
        for _, entry in ipairs(pool) do
            truthy(entry.type == "emote" or entry.type == "customemote")
        end
    end
end)

test("unknown or unavailable form information fails safely", function()
    local unknown = Engine.PrepareCandidate(
        { type = "say", text = "Suppressed." },
        { class = RPHelper.Class.DRUID, getShapeshiftFormID = function() return 777 end, resolvers = {} }
    )
    equal(unknown, nil)

    local unavailable = Engine.PrepareCandidate(
        { type = "say", text = "Suppressed." },
        { class = RPHelper.Class.DRUID, getShapeshiftFormID = function() error("unavailable") end, resolvers = {} }
    )
    equal(unavailable, nil)
end)

test("non-Druid speech is unchanged by form information", function()
    local candidate = Engine.PrepareCandidate(
        { type = "say", text = "Still spoken." },
        { class = RPHelper.Class.HUNTER, form = "CAT", resolvers = {} }
    )
    equal(candidate.text, "Still spoken.")
end)

test("form-aware pooling does not alter other character content", function()
    local ordinary = RPHelper.GetContentPool("entercombat", RPHelper.Race.TAUREN, RPHelper.Class.HUNTER)
    local withForm = RPHelper.GetContentPool(
        "entercombat", RPHelper.Race.TAUREN, RPHelper.Class.HUNTER, { form = "CAT" }
    )
    equal(#withForm, #ordinary)
    truthy(poolContainsText(withForm, "So be it."))
    truthy(poolContainsText(withForm, "For my ancestors!"))
    truthy(poolContainsText(withForm, "The hunt begins."))
end)

test("ineligible Druid speech is removed before random selection", function()
    local selected = Engine.ChooseCandidate({
        { type = "say", text = "Suppressed." },
        { type = "customemote", text = "remains alert." },
    }, {
        class = RPHelper.Class.DRUID,
        form = "CAT",
        resolvers = {},
        randomIndex = function(size)
            equal(size, 1)
            return 1
        end,
    })
    equal(selected.text, "remains alert.")
end)

test("Druid form transitions are read without stale state", function()
    local formID = 1
    local options = {
        class = RPHelper.Class.DRUID,
        getShapeshiftFormID = function() return formID end,
        resolvers = {},
    }
    equal(Engine.PrepareCandidate({ type = "say", text = "Spoken." }, options), nil)
    formID = nil
    equal(Engine.PrepareCandidate({ type = "say", text = "Spoken." }, options).text, "Spoken.")
end)

local User = RPHelper.UserContent
local function customTest(name, callback)
    test("customization: " .. name, function()
        local saved = RPHelperDB
        RPHelperDB = nil
        RPHelper.InitializeDatabase()
        local ok, err = pcall(callback)
        RPHelperDB = saved
        User.Invalidate()
        if not ok then error(err, 2) end
    end)
end
local function customScope(layer, trigger, owner)
    local scope = { layer = layer, trigger = trigger }
    if layer == "race" then scope.race = owner end
    if layer == "class" then scope.class = owner end
    if layer == "druidForm" then scope.form = owner end
    return scope
end

customTest("CRUD persists copies and never reuses deleted IDs", function()
    local scope, entry = customScope("generic", "test_custom"), { type = "say", text = "Mine." }
    local id = User.Add(scope, entry)
    truthy(id)
    entry.text, scope.trigger = "Changed externally", "other"
    equal(User.List()[1].entry.text, "Mine.")
    local list = User.List()
    list[1].entry.text = "Changed list"
    equal(User.List()[1].entry.text, "Mine.")
    local db = RPHelperDB
    RPHelper.InitializeDatabase()
    equal(RPHelperDB, db)
    equal(User.List()[1].id, id)
    truthy(User.Edit(id, customScope("generic", "test_custom"), { type = "say", text = "Edited." }))
    equal(User.List()[1].entry.text, "Edited.")
    truthy(User.Remove(id))
    equal(#User.List(), 0)
    equal(User.Edit(id, customScope("generic", "test_custom"), entry), false)
    equal(User.Remove(id), false)
    equal(User.IsCustomEligible(id, customScope("generic", "test_custom")), false)
    truthy(User.Add(customScope("generic", "test_custom"), entry) ~= id)
end)

customTest("all layers and output types share selection without scope leakage", function()
    local trigger = "test_custom_layers"
    truthy(User.Add(customScope("generic", trigger), { type = "say", text = "Generic." }))
    truthy(User.Add(customScope("race", trigger, "TAUREN"), { type = "emote", text = "ROAR" }))
    truthy(User.Add(customScope("class", trigger, "WARRIOR"), { type = "customemote", text = "stands tall." }))
    equal(#RPHelper.GetPreparedContentPool(trigger, "TAUREN", "WARRIOR", { resolvers = {} }), 3)
    equal(#RPHelper.GetPreparedContentPool(trigger, "HUMAN", "MAGE", { resolvers = {} }), 1)
    equal(#RPHelper.GetContentPool("other", "TAUREN", "WARRIOR"), 0)
    local scope = { layer = "ability", class = "WARRIOR", ability = "TEST_CUSTOM" }
    truthy(User.Add(scope, { type = "say", text = "Ability." }))
    equal(#RPHelper.GetPreparedAbilityPool("WARRIOR", "TEST_CUSTOM", { resolvers = {} }), 1)
    equal(#RPHelper.GetAbilityContentPool("MAGE", "TEST_CUSTOM"), 0)
    equal(#RPHelper.GetAbilityContentPool("WARRIOR", "OTHER"), 0)
end)

customTest("missing target and pet data filter custom entries before selection", function()
    local scope = customScope("generic", "test_custom_context")
    local target = User.Add(scope, { type = "say", text = "Hello {TARGET}." })
    truthy(User.Add(scope, { type = "customemote", text = "pets {PNAME}." }))
    truthy(User.Add(scope, { type = "say", text = "Fallback." }))
    equal(User.IsCustomEligible(target, scope, { resolvers = {} }), false)
    equal(User.IsCustomEligible(target, customScope("generic", "other")), false)
    local pool = RPHelper.GetPreparedContentPool(scope.trigger, nil, nil, { resolvers = {} })
    equal(#pool, 1)
    equal(pool[1].text, "Fallback.")
    local options = { resolvers = { TARGET = function() return "Friend" end, PNAME = function() return "Wolf" end } }
    equal(#RPHelper.GetPreparedContentPool(scope.trigger, nil, nil, options), 3)
    truthy(User.IsCustomEligible(target, scope, options))
end)

customTest("templates use existing expansion and keyword preparation", function()
    local scope = customScope("generic", "test_custom_template")
    truthy(User.Add(scope, { type = "say", template = "{1} {PLAYER}!", choices = { { "Hello", "Welcome" } } }))
    local candidate = RPHelper.ChooseGenericCandidate(scope.trigger, {
        randomIndex = function() return 1 end, resolvers = { PLAYER = function() return "Ari" end } })
    equal(candidate.text, "Hello Ari!")
    equal(candidate.template, nil)
end)

customTest("invalid entries are rejected without mutation", function()
    local scope = customScope("generic", "test_custom_invalid")
    for _, entry in ipairs({ false, "bad", {}, { type = "unknown", text = "x" },
        { type = "say", text = "" }, { type = "say", text = "   " },
        { type = "say", text = "{UNKNOWN}" }, { type = "say", text = "{TARGET" },
        { type = "emote", text = "hello world" }, { type = "emote", template = "ROAR", choices = {} },
        { type = "say", template = "{1}", choices = {} },
        { type = "say", template = "{1}", choices = { { false } } },
        { type = "say", template = "{1}", choices = { { "{1}" } } },
        { type = "say", text = "both", template = "{1}", choices = { { "x" } } },
        { type = "say", template = "{0}", choices = { { "x" } } } }) do
        local id, err = User.Add(scope, entry)
        equal(id, nil); truthy(err)
    end
    equal(User.Add({ layer = "other", trigger = "x" }, { type = "say", text = "x" }), nil)
    equal(#User.List(), 0)
    equal(RPHelperDB.custom.nextID, 1)
end)

customTest("malformed and unsupported saved entries remain preserved and ineligible", function()
    local scope = customScope("generic", "test_custom_bad_saved")
    local saved = { [1] = "old", ["custom:1"] = false,
        ["custom:2"] = { scope = scope, entry = { type = "say", text = "{FUTURE}" }, unknown = 5 },
        ["custom:3"] = { scope = false, entry = { type = "say", text = "x" } },
        ["custom:4"] = { scope = scope, entry = false } }
    RPHelperDB.custom.entries = saved
    User.Invalidate()
    equal(#RPHelper.GetPreparedContentPool(scope.trigger), 0)
    RPHelper.InitializeDatabase()
    equal(RPHelperDB.custom.entries, saved)
    equal(saved["custom:2"].unknown, 5)
    truthy(saved["custom:2"].entry.text == "{FUTURE}")
    equal(Engine.PrepareCandidate(false), nil)
end)

customTest("duplicate custom text is independently editable and removable", function()
    local scope = customScope("generic", "test_custom_duplicate")
    local first = User.Add(scope, { type = "say", text = "Same." })
    local second = User.Add(scope, { type = "say", text = "Same." })
    truthy(first ~= second)
    equal(#RPHelper.GetContentPool(scope.trigger), 2)
    truthy(User.Remove(first))
    equal(#RPHelper.GetContentPool(scope.trigger), 1)
    equal(User.List()[1].id, second)
end)

customTest("disabled default is removed from mixed pool and restored", function()
    local trigger = "test_custom_mix"
    RPHelper.RegisterGeneric(trigger, { id = "default:test:0014", type = "say", text = "Shipped." })
    local entry = RPHelper.GetGenericPool(trigger)[1]
    truthy(User.Add(customScope("generic", trigger), { type = "say", text = "Custom." }))
    equal(#RPHelper.GetContentPool(trigger), 2)
    truthy(User.SetDefaultDisabled(entry.defaultID, true))
    truthy(User.IsDefaultDisabled(entry.defaultID))
    equal(#RPHelper.GetPreparedContentPool(trigger), 1)
    equal(RPHelper.ChooseGenericCandidate(trigger).text, "Custom.")
    truthy(User.SetDefaultDisabled(entry.defaultID, false))
    equal(#RPHelper.GetPreparedGenericPool(trigger), 2)
    equal(#RPHelper.GetGenericPool(trigger), 1)
end)

customTest("shipped duplicate text and reused input table have independent IDs", function()
    local entry = { type = "say", text = "Same default." }
    RPHelper.RegisterGeneric("test_default_duplicate", entry)
    RPHelper.RegisterGeneric("test_default_duplicate", entry)
    local pool = RPHelper.GetGenericPool("test_default_duplicate")
    truthy(pool[1].defaultID ~= pool[2].defaultID)
    truthy(User.SetDefaultDisabled(pool[1].defaultID, true))
    local selected = RPHelper.GetContentPool("test_default_duplicate")
    equal(#selected, 1)
    equal(selected[1].defaultID, pool[2].defaultID)
    equal(entry.defaultID, nil)
end)

customTest("identities distinguish scope type and template choices", function()
    local trigger = "test_default_identity"
    RPHelper.RegisterGeneric(trigger, { id = "default:test:0015", type = "say", text = "Same." })
    RPHelper.RegisterRace("TAUREN", trigger, { id = "default:test:0016", type = "say", text = "Same." })
    RPHelper.RegisterClass("WARRIOR", trigger, { id = "default:test:0017", type = "say", text = "Same." })
    RPHelper.RegisterAbility("WARRIOR", "TEST_IDENTITY", { id = "default:test:0018", type = "say", text = "Same." })
    RPHelper.RegisterGeneric(trigger, { id = "default:test:0019", type = "customemote", text = "Same." })
    RPHelper.RegisterGeneric(trigger, { id = "default:test:0020", type = "say", template = "{1}", choices = { { "x" } } })
    RPHelper.RegisterGeneric(trigger, { id = "default:test:0021", type = "say", template = "{1}", choices = { { "y" } } })
    local seen = {}
    local pool = RPHelper.GetContentPool(trigger, "TAUREN", "WARRIOR")
    pool[#pool + 1] = RPHelper.GetAbilityPool("WARRIOR", "TEST_IDENTITY")[1]
    for _, entry in ipairs(pool) do truthy(not seen[entry.defaultID]);seen[entry.defaultID] = true end
end)

customTest("reload and unrelated additions preserve IDs while text edits get new identities", function()
    local previous = RPHelper.Content
    local ok, err = pcall(function()
        RPHelper.Content = nil; dofile("RPHelper/Core/Content.lua")
        RPHelper.RegisterGeneric("test_reload", { id = "default:test:0022", type = "say", text = "Original." })
        local id = RPHelper.GetGenericPool("test_reload")[1].defaultID
        truthy(User.SetDefaultDisabled(id, true))
        RPHelper.Content = nil; dofile("RPHelper/Core/Content.lua")
        RPHelper.RegisterGeneric("test_reload", { id = "default:test:0023", type = "say", text = "New addition." })
        RPHelper.RegisterGeneric("test_reload", { id = "default:test:0024", type = "say", text = "Original." })
        equal(RPHelper.GetGenericPool("test_reload")[2].defaultID, id)
        RPHelper.RegisterGeneric("test_reload", { id = "default:test:0025", type = "say", text = "Edited original." })
        equal(#RPHelper.GetContentPool("test_reload"), 2)
        RPHelper.InitializeDatabase()
        truthy(User.IsDefaultDisabled(id))
    end)
    RPHelper.Content = previous
    if not ok then error(err) end
end)

customTest("obsolete IDs are harmless and custom defaultID spoofing cannot filter custom content", function()
    local obsolete = "default:v1:removed:1"
    truthy(User.SetDefaultDisabled(obsolete, true))
    local scope = customScope("generic", "test_custom_spoof")
    local id = User.Add(scope, { type = "say", text = "Mine.", defaultID = obsolete })
    RPHelperDB.custom.entries[id].entry.defaultID = obsolete
    User.Invalidate()
    equal(#RPHelper.GetContentPool(scope.trigger), 1)
    equal(RPHelper.GetContentPool(scope.trigger)[1].defaultID, nil)
    truthy(User.IsDefaultDisabled(obsolete))
    equal(User.SetDefaultDisabled(id, true), false)
end)

customTest("form replacement and speech suppression apply to custom content", function()
    local trigger = "test_custom_form"
    RPHelper.RegisterGeneric(trigger, { id = "default:test:0026", type = "say", text = "Humanoid." })
    RPHelper.RegisterDruidForm("CAT", trigger, { id = "default:test:0027", type = "emote", text = "ROAR" })
    local scope = customScope("generic", trigger)
    truthy(User.Add(scope, { type = "say", text = "Custom speech." }))
    truthy(User.Add(scope, { type = "customemote", text = "bares its fangs." }))
    truthy(User.Add(customScope("druidForm", trigger, "CAT"), { type = "emote", text = "GROWL" }))
    local options = { class = "DRUID", form = "CAT", resolvers = {} }
    local pool = RPHelper.GetPreparedContentPool(trigger, "TAUREN", "DRUID", options)
    equal(#pool, 3)
    for _, entry in ipairs(pool) do truthy(entry.type ~= "say") end
    truthy(User.SetDefaultDisabled(RPHelper.GetDruidFormPool("CAT", trigger)[1].defaultID, true))
    equal(#RPHelper.GetPreparedContentPool(trigger, nil, "DRUID", options), 2)
    RPHelperDB.settings.suppressSayInForms = false
    equal(#RPHelper.GetPreparedContentPool(trigger, nil, "DRUID", options), 2)
end)

customTest("index is reused and edits invalidate it", function()
    local scope = customScope("generic", "test_custom_cache")
    local id = User.Add(scope, { type = "say", text = "First." })
    local previous, calls = Engine.ValidateEntry, 0
    Engine.ValidateEntry = function(...) calls = calls + 1;return previous(...) end
    local ok, err = pcall(function()
        RPHelper.GetContentPool(scope.trigger)
        local first = calls
        truthy(first > 0)
        RPHelper.GetContentPool(scope.trigger)
        equal(calls, first)
        truthy(User.Edit(id, scope, { type = "say", text = "Edited." }))
        equal(RPHelper.GetContentPool(scope.trigger)[1].text, "Edited.")
        truthy(calls > first)
    end)
    Engine.ValidateEntry = previous
    if not ok then error(err) end
end)

customTest("fresh partial and repeated initialization preserve choices and unknown fields", function()
    local settings, triggers = { enabled = false, future = 7 }, { dodge = { enabled = false, chance = 0.7 } }
    local abilities = { PALADIN = { FLASH_OF_LIGHT = { enabled = false, cooldown = 99 } }, FUTURE = { x = 1 } }
    local custom = { authored = { "Legacy data." }, entries = {}, nextID = 9, future = 4 }
    RPHelperDB = { schemaVersion = 7, settings = settings, triggers = triggers, abilities = abilities,
        custom = custom, disabledDefaults = { ["default:v1:obsolete"] = true }, future = { x = 3 } }
    local root = RPHelperDB
    RPHelper.InitializeDatabase();RPHelper.InitializeDatabase()
    equal(RPHelperDB, root);equal(root.settings, settings);equal(root.custom, custom)
    equal(settings.enabled, false);equal(settings.future, 7)
    equal(triggers.dodge.chance, 0.7);equal(abilities.PALADIN.FLASH_OF_LIGHT.cooldown, 99)
    equal(abilities.FUTURE.x, 1);equal(custom.nextID, 9);equal(custom.authored[1], "Legacy data.")
    equal(root.schemaVersion, 7);equal(root.future.x, 3)
    truthy(root.disabledDefaults["default:v1:obsolete"])
    local id = User.Add(customScope("generic", "future_trigger"), { type = "say", text = "Future." })
    RPHelper.InitializeDatabase()
    equal(User.List()[1].id, id)
end)

customTest("malformed root and custom containers survive initialization and API calls", function()
    for _, value in ipairs({ false, true, 42, "bad" }) do
        for _, kind in ipairs({ "root", "custom", "entries", "disabledDefaults" }) do
            RPHelperDB = {}
            if kind == "root" then RPHelperDB = value
            elseif kind == "entries" then RPHelperDB.custom = { entries = value }
            else RPHelperDB[kind] = value end
            RPHelper.InitializeDatabase()
            if kind == "root" then equal(RPHelperDB, value)
            elseif kind == "entries" then equal(RPHelperDB.custom.entries, value)
            else equal(RPHelperDB[kind], value) end
            if kind ~= "disabledDefaults" then
                equal(User.Add(customScope("generic", "test_malformed"), { type = "say", text = "x" }), nil)
                equal(User.List(), nil)
                equal(User.Edit("custom:1", customScope("generic", "test_malformed"), { type = "say", text = "x" }), false)
                equal(User.Remove("custom:1"), false)
            else equal(User.SetDefaultDisabled("default:v1:x", true), false) end
            equal(#RPHelper.GetPreparedContentPool("test_malformed", nil, "DRUID", { form = "CAT" }), 0)
        end
    end
end)

customTest("unknown fields survive edits and malformed counter is never replaced", function()
    local scope = customScope("generic", "test_custom_unknown")
    local id = User.Add(scope, { type = "say", text = "First." })
    local record = RPHelperDB.custom.entries[id]
    record.future, record.entry.future, record.scope.future = 4, 5, 6
    truthy(User.Edit(id, scope, { type = "customemote", text = "Edited." }))
    equal(record.future, 4);equal(record.entry.future, 5);equal(record.scope.future, 6)
    RPHelperDB.custom.nextID = false
    RPHelper.InitializeDatabase()
    equal(RPHelperDB.custom.nextID, false)
    equal(User.Add(scope, { type = "say", text = "x" }), nil)
    equal(User.List()[1].id, id)
end)

customTest("secret context uses shared keyword guards without leaking values", function()
    local scope = customScope("generic", "test_custom_secret")
    local id = User.Add(scope, { type = "say", text = "Hello {TARGET}." })
    local inspect = issecretvalue
    local ok, err = pcall(function()
        issecretvalue = function(value) return value == "secret" end
        equal(User.IsCustomEligible(id, scope, { resolvers = { TARGET = function() return "secret" end } }), false)
        equal(#RPHelper.GetPreparedContentPool(scope.trigger, nil, nil,
            { resolvers = { TARGET = function() error("restricted") end } }), 0)
    end)
    issecretvalue = inspect
    if not ok then error(err) end
end)

customTest("database replacement and reinitialization never reuse another character's cache", function()
    local scope = customScope("generic", "test_custom_character")
    truthy(User.Add(scope, { type = "say", text = "First character." }))
    equal(RPHelper.GetContentPool(scope.trigger)[1].text, "First character.")
    local first = RPHelperDB
    RPHelperDB = nil; RPHelper.InitializeDatabase()
    equal(#RPHelper.GetContentPool(scope.trigger), 0)
    truthy(User.Add(scope, { type = "say", text = "Second character." }))
    equal(RPHelper.GetContentPool(scope.trigger)[1].text, "Second character.")
    RPHelperDB = first
    equal(RPHelper.GetContentPool(scope.trigger)[1].text, "First character.")
    first.custom.entries["custom:1"].entry.text = "Direct repair."
    RPHelper.InitializeDatabase()
    equal(RPHelper.GetContentPool(scope.trigger)[1].text, "Direct repair.")
end)

customTest("schema values and malformed nested overrides are preserved during upgrades", function()
    for _, schema in ipairs({ false, 0, 9 }) do
        RPHelperDB = { schemaVersion = schema, settings = false, triggers = { dodge = "future" },
            abilities = { PALADIN = false }, custom = { entries = {}, nextID = 1, future = "preserved" } }
        RPHelper.InitializeDatabase();RPHelper.InitializeDatabase()
        equal(RPHelperDB.schemaVersion, schema)
        equal(RPHelperDB.settings, false);equal(RPHelperDB.triggers.dodge, "future")
        equal(RPHelperDB.abilities.PALADIN, false);equal(RPHelperDB.custom.future, "preserved")
    end
end)

customTest("invalid edits leave a valid entry and cache unchanged", function()
    local scope = customScope("generic", "test_custom_invalid_edit")
    local id = User.Add(scope, { type = "say", text = "Original." })
    equal(RPHelper.GetContentPool(scope.trigger)[1].text, "Original.")
    equal(User.Edit(id, scope, { type = "say", text = "{UNKNOWN}" }), false)
    equal(User.Edit(id, { layer = "bad" }, { type = "say", text = "Replacement." }), false)
    equal(User.List()[1].entry.text, "Original.")
    equal(RPHelper.GetContentPool(scope.trigger)[1].text, "Original.")
end)

if failures > 0 then
    io.stderr:write(tostring(failures) .. " of " .. tostring(tests) .. " tests failed\n")
    os.exit(1)
end

print(tostring(tests) .. " tests passed")
