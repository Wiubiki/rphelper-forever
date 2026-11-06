-- Reviewed player-success IDs only. Candidate ranks/effects belong in research.
-- Loaded after Data/Abilities so validation uses the complete canonical registry.
RPHelper.AbilitySpellMappings = {}
local Mappings = RPHelper.AbilitySpellMappings

Mappings.Records = {
    { class = "PALADIN", spellID = 19750, rank = "Rank 1", evidenceTier = "B", ability = "FLASH_OF_LIGHT",
        mechanism = "player_success", evidence = "third_party_success",
        evidenceRef = "docs/spell_casting_api_audit.md#6-first-runtime-increment" },
    { class = "PALADIN", spellID = 20288, rank = "Rank 3", evidenceTier = "B", ability = "SEAL_OF_RIGHTEOUSNESS",
        mechanism = "player_success", evidence = "third_party_success",
        evidenceRef = "docs/spell_casting_api_audit.md#6-first-runtime-increment" },
    { class = "SHAMAN", spellID = 325, rank = "Rank 2", evidenceTier = "A", ability = "LIGHTNING_SHIELD",
        mechanism = "player_success", evidence = "owner_reported_success",
        evidenceRef = "docs/ability_detection_milestone_1.md#evidence-and-rank-limits" },
    { class = "SHAMAN", spellID = 547, rank = "Rank 3", evidenceTier = "A", ability = "HEALING_WAVE",
        mechanism = "player_success", evidence = "owner_reported_success",
        evidenceRef = "docs/ability_detection_milestone_1.md#evidence-and-rank-limits" },
}


-- These are literal, individually reviewed IDs/ranks, never inferred ranges.
-- Detailed source/role decisions (including rejected IDs) are kept out of the addon.
local function reviewed(class, ability, ranks)
    for _, rank in ipairs(ranks) do
        Mappings.Records[#Mappings.Records + 1] = {
            class = class, ability = ability, spellID = rank[1], rank = rank[2],
            mechanism = "player_success", evidence = "forever_reviewed", evidenceTier = "B",
            evidenceRef = "docs/audits/ability_mapping_expansion_review.csv",
        }
    end
end

-- DRUID
reviewed("DRUID", "ABOLISH_POISON", {
    { 2893, "unranked/unspecified" },
})
reviewed("DRUID", "BARKSKIN", {
    { 22812, "unranked/unspecified" },
})
reviewed("DRUID", "BASH", {
    { 5211, "Rank 1" }, { 6798, "Rank 2" }, { 8983, "Rank 3" },
})
reviewed("DRUID", "CHALLENGING_ROAR", {
    { 5209, "unranked/unspecified" },
})
reviewed("DRUID", "CLAW", {
    { 1082, "Rank 1" }, { 3029, "Rank 2" }, { 5201, "Rank 3" }, { 9849, "Rank 4" },
    { 9850, "Rank 5" },
})
reviewed("DRUID", "COWER", {
    { 8998, "Rank 1" }, { 9000, "Rank 2" }, { 9892, "Rank 3" },
})
reviewed("DRUID", "DASH", {
    { 1850, "Rank 1" }, { 9821, "Rank 2" },
})
reviewed("DRUID", "DEMORALIZING_ROAR", {
    { 99, "Rank 1" }, { 1735, "Rank 2" }, { 9490, "Rank 3" }, { 9747, "Rank 4" },
    { 9898, "Rank 5" },
})
reviewed("DRUID", "ENRAGE", {
    { 5229, "unranked/unspecified" },
})
reviewed("DRUID", "ENTANGLING_ROOTS", {
    { 339, "Rank 1" }, { 1062, "Rank 2" }, { 5195, "Rank 3" }, { 5196, "Rank 4" },
    { 9852, "Rank 5" }, { 9853, "Rank 6" },
})
reviewed("DRUID", "FAERIE_FIRE", {
    { 770, "Rank 1" }, { 778, "Rank 2" }, { 9749, "Rank 3" }, { 9907, "Rank 4" },
})
reviewed("DRUID", "FERAL_CHARGE", {
    { 1238122, "unranked/unspecified" },
})
reviewed("DRUID", "FRENZIED_REGENERATION", {
    { 22842, "unranked/unspecified" },
})
reviewed("DRUID", "GIFT_OF_THE_WILD", {
    { 21849, "Rank 1" }, { 21850, "Rank 2" },
})
reviewed("DRUID", "HEALING_TOUCH", {
    { 5185, "Rank 1" }, { 5186, "Rank 2" }, { 5187, "Rank 3" }, { 5188, "Rank 4" },
    { 5189, "Rank 5" }, { 6778, "Rank 6" }, { 8903, "Rank 7" }, { 9758, "Rank 8" },
    { 9888, "Rank 9" }, { 9889, "Rank 10" }, { 25297, "Rank 11" },
})
reviewed("DRUID", "HIBERNATE", {
    { 2637, "Rank 1" }, { 18657, "Rank 2" }, { 18658, "Rank 3" },
})
reviewed("DRUID", "INNERVATE", {
    { 29166, "unranked/unspecified" },
})
reviewed("DRUID", "INSECT_SWARM", {
    { 5570, "Rank 1" },
})
reviewed("DRUID", "MARK_OF_THE_WILD", {
    { 1126, "Rank 1" }, { 5232, "Rank 2" }, { 5234, "Rank 4" }, { 6756, "Rank 3" },
    { 8907, "Rank 5" }, { 9884, "Rank 6" }, { 9885, "Rank 7" },
})
reviewed("DRUID", "MOON_FIRE", {
    { 8921, "Rank 1" }, { 8924, "Rank 2" }, { 8925, "Rank 3" }, { 8926, "Rank 4" },
    { 8927, "Rank 5" }, { 8928, "Rank 6" }, { 8929, "Rank 7" }, { 9833, "Rank 8" },
    { 9834, "Rank 9" }, { 9835, "Rank 10" },
})
reviewed("DRUID", "NATURES_GRASP", {
    { 16689, "Rank 1" }, { 16810, "Rank 2" }, { 16811, "Rank 3" }, { 16812, "Rank 4" },
    { 16813, "Rank 5" }, { 17329, "Rank 6" },
})
reviewed("DRUID", "NATURES_SWIFTNESS", {
    { 17116, "unranked/unspecified" },
})
reviewed("DRUID", "POUNCE", {
    { 9005, "Rank 1" }, { 9823, "Rank 2" }, { 9827, "Rank 3" },
})
reviewed("DRUID", "PRIMAL_BITE", {
    { 407995, "Rank 1" },
})
reviewed("DRUID", "PROWL", {
    { 5215, "Rank 1" }, { 6783, "Rank 2" }, { 9913, "Rank 3" },
})
reviewed("DRUID", "RAKE", {
    { 1822, "Rank 1" }, { 1823, "Rank 2" }, { 1824, "Rank 3" }, { 9904, "Rank 4" },
})
reviewed("DRUID", "RAVAGE", {
    { 6785, "Rank 1" }, { 6787, "Rank 2" }, { 9866, "Rank 3" }, { 9867, "Rank 4" },
})
reviewed("DRUID", "REBIRTH", {
    { 20484, "Rank 1" }, { 20739, "Rank 2" }, { 20742, "Rank 3" }, { 20747, "Rank 4" },
    { 20748, "Rank 5" },
})
reviewed("DRUID", "REGROWTH", {
    { 8936, "Rank 1" }, { 8938, "Rank 2" }, { 8939, "Rank 3" }, { 8940, "Rank 4" },
    { 8941, "Rank 5" }, { 9750, "Rank 6" }, { 9856, "Rank 7" }, { 9857, "Rank 8" },
    { 9858, "Rank 9" },
})
reviewed("DRUID", "REJUVENATION", {
    { 774, "Rank 1" }, { 1058, "Rank 2" }, { 1430, "Rank 3" }, { 2090, "Rank 4" },
    { 2091, "Rank 5" }, { 3627, "Rank 6" }, { 8910, "Rank 7" }, { 9839, "Rank 8" },
    { 9840, "Rank 9" }, { 9841, "Rank 10" }, { 25299, "Rank 11" },
})
reviewed("DRUID", "REMOVE_CURSE", {
    { 2782, "unranked/unspecified" },
})
reviewed("DRUID", "REVIVE", {
    { 437138, "Rank 1" }, { 1237948, "Rank 2" }, { 1237949, "Rank 3" }, { 1237950, "Rank 4" },
    { 1237951, "Rank 5" },
})
reviewed("DRUID", "RIP", {
    { 1079, "Rank 1" }, { 9492, "Rank 2" }, { 9493, "Rank 3" }, { 9752, "Rank 4" },
    { 9894, "Rank 5" }, { 9896, "Rank 6" },
})
reviewed("DRUID", "SHRED", {
    { 5221, "Rank 1" }, { 6800, "Rank 2" }, { 8992, "Rank 3" }, { 9829, "Rank 4" },
    { 9830, "Rank 5" },
})
reviewed("DRUID", "SOOTHE_ANIMAL", {
    { 2908, "Rank 1" }, { 8955, "Rank 2" }, { 9901, "Rank 3" },
})
reviewed("DRUID", "STARFIRE", {
    { 2912, "Rank 1" }, { 8949, "Rank 2" }, { 8950, "Rank 3" }, { 8951, "Rank 4" },
    { 9875, "Rank 5" }, { 9876, "Rank 6" }, { 25298, "Rank 7" },
})
reviewed("DRUID", "SWIFTMEND", {
    { 18562, "unranked/unspecified" },
})
reviewed("DRUID", "SWIPE", {
    { 769, "Rank 3" }, { 779, "Rank 1" }, { 780, "Rank 2" }, { 9754, "Rank 4" },
    { 9908, "Rank 5" },
})
reviewed("DRUID", "TELEPORT_MOONGLADE", {
    { 18960, "unranked/unspecified" },
})
reviewed("DRUID", "THORNS", {
    { 467, "Rank 1" }, { 782, "Rank 2" }, { 1075, "Rank 3" }, { 8914, "Rank 4" },
    { 9756, "Rank 5" }, { 9910, "Rank 6" },
})
reviewed("DRUID", "WILD_GROWTH", {
    { 408120, "Rank 1" },
})
reviewed("DRUID", "WRATH", {
    { 5176, "Rank 1" }, { 5177, "Rank 2" }, { 5178, "Rank 3" }, { 5179, "Rank 4" },
    { 5180, "Rank 5" }, { 6780, "Rank 6" }, { 8905, "Rank 7" }, { 9912, "Rank 8" },
})

-- HUNTER
reviewed("HUNTER", "AIMED_SHOT", {
    { 19434, "Rank 1" }, { 20900, "Rank 2" }, { 20901, "Rank 3" }, { 20902, "Rank 4" },
    { 20903, "Rank 5" }, { 20904, "Rank 6" },
})
reviewed("HUNTER", "ARCANE_SHOT", {
    { 3044, "Rank 1" }, { 14281, "Rank 2" }, { 14282, "Rank 3" }, { 14283, "Rank 4" },
    { 14284, "Rank 5" }, { 14285, "Rank 6" }, { 14286, "Rank 7" }, { 14287, "Rank 8" },
})
reviewed("HUNTER", "ASPECT_OF_THE_BEAST", {
    { 13161, "Rank 1" }, { 1299445, "Rank 2" }, { 1299446, "Rank 3" }, { 1299447, "Rank 4" },
})
reviewed("HUNTER", "ASPECT_OF_THE_CHEETAH", {
    { 5118, "unranked/unspecified" },
})
reviewed("HUNTER", "ASPECT_OF_THE_HAWK", {
    { 13165, "Rank 1" }, { 14318, "Rank 2" }, { 14319, "Rank 3" }, { 14320, "Rank 4" },
    { 14321, "Rank 5" }, { 14322, "Rank 6" }, { 25296, "Rank 7" },
})
reviewed("HUNTER", "ASPECT_OF_THE_MONKEY", {
    { 13163, "unranked/unspecified" },
})
reviewed("HUNTER", "ASPECT_OF_THE_PACK", {
    { 13159, "unranked/unspecified" },
})
reviewed("HUNTER", "ASPECT_OF_THE_WILD", {
    { 20043, "Rank 1" }, { 20190, "Rank 2" },
})
reviewed("HUNTER", "BEAST_LORE", {
    { 1462, "unranked/unspecified" },
})
reviewed("HUNTER", "BESTIAL_WRATH", {
    { 19574, "unranked/unspecified" },
})
reviewed("HUNTER", "CONCUSSIVE_SHOT", {
    { 5116, "unranked/unspecified" },
})
reviewed("HUNTER", "COUNTERATTACK", {
    { 19306, "Rank 1" },
})
reviewed("HUNTER", "DETERRENCE", {
    { 19263, "unranked/unspecified" },
})
reviewed("HUNTER", "DISENGAGE", {
    { 781, "Rank 1" }, { 14272, "Rank 2" }, { 14273, "Rank 3" },
})
reviewed("HUNTER", "DISTRACTING_SHOT", {
    { 14274, "Rank 2" }, { 15629, "Rank 3" }, { 15630, "Rank 4" }, { 15631, "Rank 5" },
    { 15632, "Rank 6" }, { 20736, "Rank 1" },
})
reviewed("HUNTER", "EXPLOSIVE_TRAP", {
    { 13813, "Rank 1" }, { 14316, "Rank 2" }, { 14317, "Rank 3" },
})
reviewed("HUNTER", "FEIGN_DEATH", {
    { 5384, "unranked/unspecified" },
})
reviewed("HUNTER", "FREEZING_TRAP", {
    { 1499, "Rank 1" }, { 14310, "Rank 2" }, { 14311, "Rank 3" },
})
reviewed("HUNTER", "FROST_TRAP", {
    { 13809, "unranked/unspecified" },
})
reviewed("HUNTER", "HUNTERS_MARK", {
    { 1130, "Rank 1" }, { 14323, "Rank 2" }, { 14324, "Rank 3" }, { 14325, "Rank 4" },
})
reviewed("HUNTER", "IMMOLATION_TRAP", {
    { 13795, "Rank 1" }, { 14302, "Rank 2" }, { 14303, "Rank 3" }, { 14304, "Rank 4" },
    { 14305, "Rank 5" },
})
reviewed("HUNTER", "INTIMIDATION", {
    { 19577, "unranked/unspecified" },
})
reviewed("HUNTER", "LACERATE", {
    { 24118, "Rank 1" }, { 24119, "Rank 2" }, { 24120, "Rank 3" }, { 1299332, "Rank 4" },
})
reviewed("HUNTER", "MONGOOSE_BITE", {
    { 1495, "Rank 1" }, { 14269, "Rank 2" }, { 14270, "Rank 3" }, { 14271, "Rank 4" },
})
reviewed("HUNTER", "MULTI_SHOT", {
    { 2643, "unranked/unspecified" },
})
reviewed("HUNTER", "RAPID_FIRE", {
    { 3045, "unranked/unspecified" },
})
reviewed("HUNTER", "SCARE_BEAST", {
    { 1513, "Rank 1" }, { 14326, "Rank 2" }, { 14327, "Rank 3" },
})
reviewed("HUNTER", "SCATTER_SHOT", {
    { 19503, "unranked/unspecified" },
})
reviewed("HUNTER", "SCORPID_STING", {
    { 3043, "unranked/unspecified" },
})
reviewed("HUNTER", "SERPENT_STING", {
    { 1978, "Rank 1" }, { 13549, "Rank 2" }, { 13550, "Rank 3" }, { 13551, "Rank 4" },
    { 13552, "Rank 5" }, { 13553, "Rank 6" }, { 13554, "Rank 7" }, { 13555, "Rank 8" },
    { 25295, "Rank 9" },
})
reviewed("HUNTER", "SNIPER_SHOT", {
    { 1310687, "Rank 1" },
})
reviewed("HUNTER", "STRIDER_KICK", {
    { 1317257, "unranked/unspecified" },
})
reviewed("HUNTER", "SUMMON_HAWK", {
    { 1293241, "Rank 1" },
})
reviewed("HUNTER", "TRANQUILIZING_SHOT", {
    { 19801, "unranked/unspecified" },
})
reviewed("HUNTER", "TRUESHOT_AURA", {
    { 1299346, "Rank 1" },
})
reviewed("HUNTER", "VIPER_STING", {
    { 3034, "Rank 1" }, { 14279, "Rank 2" }, { 14280, "Rank 3" },
})
reviewed("HUNTER", "WING_CLIP", {
    { 2974, "Rank 1" }, { 14267, "Rank 2" }, { 14268, "Rank 3" },
})

-- MAGE
reviewed("MAGE", "AMPLIFY_MAGIC", {
    { 1008, "Rank 1" }, { 8455, "Rank 2" }, { 10169, "Rank 3" }, { 10170, "Rank 4" },
})
reviewed("MAGE", "ARCANE_BLAST", {
    { 400574, "Rank 1" },
})
reviewed("MAGE", "ARCANE_BRILLIANCE", {
    { 23028, "unranked/unspecified" },
})
reviewed("MAGE", "ARCANE_EXPLOSION", {
    { 1449, "Rank 1" }, { 8437, "Rank 2" }, { 8438, "Rank 3" }, { 8439, "Rank 4" },
    { 10201, "Rank 5" }, { 10202, "Rank 6" },
})
reviewed("MAGE", "ARCANE_INTELLECT", {
    { 1459, "Rank 1" }, { 1460, "Rank 2" }, { 1461, "Rank 3" }, { 10156, "Rank 4" },
    { 10157, "Rank 5" },
})
reviewed("MAGE", "ARCANE_POWER", {
    { 12042, "unranked/unspecified" },
})
reviewed("MAGE", "BLAST_WAVE", {
    { 11113, "Rank 1" },
})
reviewed("MAGE", "BLINK", {
    { 1953, "unranked/unspecified" },
})
reviewed("MAGE", "COLD_SNAP", {
    { 12472, "unranked/unspecified" },
})
reviewed("MAGE", "COMBUSTION", {
    { 11129, "unranked/unspecified" },
})
reviewed("MAGE", "CONE_OF_COLD", {
    { 120, "Rank 1" }, { 8492, "Rank 2" }, { 10159, "Rank 3" }, { 10160, "Rank 4" },
})
reviewed("MAGE", "CONJURE_FOOD", {
    { 587, "Rank 1" }, { 597, "Rank 2" }, { 990, "Rank 3" }, { 6129, "Rank 4" },
    { 10144, "Rank 5" }, { 10145, "Rank 6" }, { 28612, "Rank 7" },
})
reviewed("MAGE", "CONJURE_MANA_AGATE", {
    { 759, "unranked/unspecified" },
})
reviewed("MAGE", "CONJURE_MANA_CITRINE", {
    { 10053, "unranked/unspecified" },
})
reviewed("MAGE", "CONJURE_MANA_JADE", {
    { 3552, "unranked/unspecified" },
})
reviewed("MAGE", "CONJURE_MANA_RUBY", {
    { 10054, "unranked/unspecified" },
})
reviewed("MAGE", "CONJURE_WATER", {
    { 5504, "Rank 1" }, { 5505, "Rank 2" }, { 5506, "Rank 3" }, { 6127, "Rank 4" },
    { 10138, "Rank 5" }, { 10139, "Rank 6" }, { 10140, "Rank 7" },
})
reviewed("MAGE", "COUNTERSPELL", {
    { 2139, "unranked/unspecified" },
})
reviewed("MAGE", "DAMPEN_MAGIC", {
    { 604, "Rank 1" }, { 8450, "Rank 2" }, { 8451, "Rank 3" }, { 10173, "Rank 4" },
    { 10174, "Rank 5" },
})
reviewed("MAGE", "FIREBALL", {
    { 133, "Rank 1" }, { 143, "Rank 2" }, { 145, "Rank 3" }, { 3140, "Rank 4" },
    { 8400, "Rank 5" }, { 8401, "Rank 6" }, { 8402, "Rank 7" }, { 10148, "Rank 8" },
    { 10149, "Rank 9" }, { 10150, "Rank 10" }, { 10151, "Rank 11" }, { 25306, "Rank 12" },
})
reviewed("MAGE", "FIRE_BLAST", {
    { 2136, "Rank 1" }, { 2137, "Rank 2" }, { 2138, "Rank 3" }, { 8412, "Rank 4" },
    { 8413, "Rank 5" }, { 10197, "Rank 6" }, { 10199, "Rank 7" },
})
reviewed("MAGE", "FIRE_WARD", {
    { 543, "Rank 1" }, { 8457, "Rank 2" }, { 8458, "Rank 3" }, { 10223, "Rank 4" },
    { 10225, "Rank 5" },
})
reviewed("MAGE", "FROSTBOLT", {
    { 116, "Rank 1" }, { 205, "Rank 2" }, { 837, "Rank 3" }, { 7322, "Rank 4" },
    { 8406, "Rank 5" }, { 8407, "Rank 6" }, { 8408, "Rank 7" }, { 10179, "Rank 8" },
    { 10180, "Rank 9" }, { 10181, "Rank 10" }, { 25304, "Rank 11" },
})
reviewed("MAGE", "FROSTFIRE_BOLT", {
    { 401502, "Rank 1" }, { 1237312, "Rank 2" }, { 1237313, "Rank 3" },
})
reviewed("MAGE", "FROST_ARMOR", {
    { 168, "Rank 1" }, { 7300, "Rank 2" }, { 7301, "Rank 3" },
})
reviewed("MAGE", "FROST_NOVA", {
    { 122, "Rank 1" }, { 865, "Rank 2" }, { 6131, "Rank 3" }, { 10230, "Rank 4" },
})
reviewed("MAGE", "FROST_WARD", {
    { 6143, "Rank 1" }, { 8461, "Rank 2" }, { 8462, "Rank 3" }, { 10177, "Rank 4" },
    { 28609, "Rank 5" },
})
reviewed("MAGE", "ICE_ARMOR", {
    { 7302, "Rank 1" }, { 7320, "Rank 2" }, { 10219, "Rank 3" }, { 10220, "Rank 4" },
})
reviewed("MAGE", "ICE_BARRIER", {
    { 11426, "Rank 1" },
})
reviewed("MAGE", "ICE_BLOCK", {
    { 11958, "unranked/unspecified" },
})
reviewed("MAGE", "ICE_LANCE", {
    { 1312002, "Rank 1" },
})
reviewed("MAGE", "MAGE_ARMOR", {
    { 6117, "Rank 1" }, { 22782, "Rank 2" }, { 22783, "Rank 3" },
})
reviewed("MAGE", "MANA_SHIELD", {
    { 1463, "Rank 1" }, { 8494, "Rank 2" }, { 8495, "Rank 3" }, { 10191, "Rank 4" },
    { 10192, "Rank 5" }, { 10193, "Rank 6" },
})
reviewed("MAGE", "POLYMORPH", {
    { 118, "Rank 1" }, { 12824, "Rank 2" }, { 12825, "Rank 3" }, { 12826, "Rank 4" },
})
reviewed("MAGE", "PORTAL_DARNASSUS", {
    { 11419, "unranked/unspecified" },
})
reviewed("MAGE", "PORTAL_IRONFORGE", {
    { 11416, "unranked/unspecified" },
})
reviewed("MAGE", "PORTAL_ORGRIMMAR", {
    { 11417, "unranked/unspecified" },
})
reviewed("MAGE", "PORTAL_STORMWIND", {
    { 10059, "unranked/unspecified" },
})
reviewed("MAGE", "PORTAL_THUNDER_BLUFF", {
    { 11420, "unranked/unspecified" },
})
reviewed("MAGE", "PORTAL_UNDERCITY", {
    { 11418, "unranked/unspecified" },
})
reviewed("MAGE", "PRESENCE_OF_MIND", {
    { 12043, "unranked/unspecified" },
})
reviewed("MAGE", "PYROBLAST", {
    { 11366, "Rank 1" },
})
reviewed("MAGE", "REMOVE_LESSER_CURSE", {
    { 475, "unranked/unspecified" },
})
reviewed("MAGE", "SCORCH", {
    { 2948, "Rank 1" }, { 8444, "Rank 2" }, { 8445, "Rank 3" }, { 8446, "Rank 4" },
    { 10205, "Rank 5" }, { 10206, "Rank 6" }, { 10207, "Rank 7" },
})
reviewed("MAGE", "SLOW_FALL", {
    { 130, "unranked/unspecified" },
})
reviewed("MAGE", "TELEPORT_DALARAN", {
    { 1297659, "unranked/unspecified" },
})
reviewed("MAGE", "TELEPORT_DARNASSUS", {
    { 3565, "unranked/unspecified" },
})
reviewed("MAGE", "TELEPORT_IRONFORGE", {
    { 3562, "unranked/unspecified" },
})
reviewed("MAGE", "TELEPORT_ORGRIMMAR", {
    { 3567, "unranked/unspecified" },
})
reviewed("MAGE", "TELEPORT_STORMWIND", {
    { 3561, "unranked/unspecified" },
})
reviewed("MAGE", "TELEPORT_THUNDER_BLUFF", {
    { 3566, "unranked/unspecified" },
})
reviewed("MAGE", "TELEPORT_UNDERCITY", {
    { 3563, "unranked/unspecified" },
})

-- PALADIN
reviewed("PALADIN", "BLESSING_OF_FREEDOM", {
    { 1044, "unranked/unspecified" },
})
reviewed("PALADIN", "BLESSING_OF_KINGS", {
    { 20217, "unranked/unspecified" },
})
reviewed("PALADIN", "BLESSING_OF_MIGHT", {
    { 19740, "Rank 1" }, { 19834, "Rank 2" }, { 19835, "Rank 3" }, { 19836, "Rank 4" },
    { 19837, "Rank 5" }, { 19838, "Rank 6" }, { 25291, "Rank 7" },
})
reviewed("PALADIN", "BLESSING_OF_PROTECTION", {
    { 1022, "Rank 1" }, { 5599, "Rank 2" }, { 10278, "Rank 3" },
})
reviewed("PALADIN", "BLESSING_OF_SACRIFICE", {
    { 6940, "Rank 1" }, { 20729, "Rank 2" },
})
reviewed("PALADIN", "BLESSING_OF_WISDOM", {
    { 19742, "Rank 1" }, { 19850, "Rank 2" }, { 19852, "Rank 3" }, { 19853, "Rank 4" },
    { 19854, "Rank 5" }, { 25290, "Rank 6" },
})
reviewed("PALADIN", "CLEANSE", {
    { 4987, "unranked/unspecified" },
})
reviewed("PALADIN", "CONCENTRATION_AURA", {
    { 19746, "unranked/unspecified" },
})
reviewed("PALADIN", "CONSECRATION", {
    { 20116, "Rank 2" }, { 20922, "Rank 3" }, { 20923, "Rank 4" }, { 20924, "Rank 5" },
    { 26573, "Rank 1" },
})
reviewed("PALADIN", "DEVOTION_AURA", {
    { 465, "Rank 1" }, { 643, "Rank 3" }, { 1032, "Rank 5" }, { 10290, "Rank 2" },
    { 10291, "Rank 4" }, { 10292, "Rank 6" }, { 10293, "Rank 7" },
})
reviewed("PALADIN", "DIVINE_FAVOR", {
    { 20216, "unranked/unspecified" },
})
reviewed("PALADIN", "DIVINE_INTERVENTION", {
    { 19752, "unranked/unspecified" },
})
reviewed("PALADIN", "DIVINE_PROTECTION", {
    { 498, "Rank 1" }, { 5573, "Rank 2" },
})
reviewed("PALADIN", "DIVINE_SHIELD", {
    { 642, "Rank 1" }, { 1020, "Rank 2" },
})
reviewed("PALADIN", "EXORCISM", {
    { 879, "Rank 1" }, { 5614, "Rank 2" }, { 5615, "Rank 3" }, { 10312, "Rank 4" },
    { 10313, "Rank 5" }, { 10314, "Rank 6" },
})
reviewed("PALADIN", "FIRE_RESISTANCE_AURA", {
    { 19891, "Rank 1" }, { 19899, "Rank 2" }, { 19900, "Rank 3" },
})
reviewed("PALADIN", "FLASH_OF_LIGHT", {
    { 19939, "Rank 2" }, { 19940, "Rank 3" }, { 19941, "Rank 4" }, { 19942, "Rank 5" },
    { 19943, "Rank 6" },
})
reviewed("PALADIN", "FROST_RESISTANCE_AURA", {
    { 19888, "Rank 1" }, { 19897, "Rank 2" }, { 19898, "Rank 3" },
})
reviewed("PALADIN", "GREATER_BLESSING_OF_KINGS", {
    { 25898, "unranked/unspecified" },
})
reviewed("PALADIN", "GREATER_BLESSING_OF_MIGHT", {
    { 25782, "Rank 1" }, { 25916, "Rank 2" },
})
reviewed("PALADIN", "GREATER_BLESSING_OF_WISDOM", {
    { 25894, "Rank 1" }, { 25918, "Rank 2" },
})
reviewed("PALADIN", "HAMMER_OF_JUSTICE", {
    { 853, "Rank 1" }, { 5588, "Rank 2" }, { 5589, "Rank 3" }, { 10308, "Rank 4" },
})
reviewed("PALADIN", "HAMMER_OF_WRATH", {
    { 24239, "Rank 3" }, { 24274, "Rank 2" }, { 24275, "Rank 1" },
})
reviewed("PALADIN", "HOLY_LIGHT", {
    { 635, "Rank 1" }, { 639, "Rank 2" }, { 647, "Rank 3" }, { 1026, "Rank 4" },
    { 1042, "Rank 5" }, { 3472, "Rank 6" }, { 10328, "Rank 7" }, { 10329, "Rank 8" },
    { 25292, "Rank 9" },
})
reviewed("PALADIN", "HOLY_SHIELD", {
    { 20925, "Rank 1" },
})
reviewed("PALADIN", "HOLY_SHOCK", {
    { 1311606, "Rank 1" },
})
reviewed("PALADIN", "HOLY_STRIKE", {
    { 678, "Rank 2" }, { 679, "Rank 1" }, { 680, "Rank 4" }, { 1866, "Rank 3" },
    { 2495, "Rank 5" }, { 5569, "Rank 6" }, { 10332, "Rank 7" }, { 10333, "Rank 8" },
})
reviewed("PALADIN", "HOLY_WRATH", {
    { 2812, "Rank 1" }, { 10318, "Rank 2" },
})
reviewed("PALADIN", "JUDGEMENT", {
    { 20271, "unranked/unspecified" },
})
reviewed("PALADIN", "LAY_ON_HANDS", {
    { 633, "Rank 1" }, { 2800, "Rank 2" }, { 10310, "Rank 3" },
})
reviewed("PALADIN", "LIGHTS_VIGIL", {
    { 1310911, "Rank 1" },
})
reviewed("PALADIN", "PURIFY", {
    { 1152, "unranked/unspecified" },
})
reviewed("PALADIN", "REDEMPTION", {
    { 7328, "Rank 1" }, { 10322, "Rank 2" }, { 10324, "Rank 3" }, { 20772, "Rank 4" },
    { 20773, "Rank 5" },
})
reviewed("PALADIN", "REPENTANCE", {
    { 20066, "unranked/unspecified" },
})
reviewed("PALADIN", "RETRIBUTION_AURA", {
    { 7294, "Rank 1" }, { 10298, "Rank 2" }, { 10299, "Rank 3" }, { 10300, "Rank 4" },
    { 10301, "Rank 5" },
})
reviewed("PALADIN", "RIGHTEOUS_FURY", {
    { 25780, "unranked/unspecified" },
})
reviewed("PALADIN", "SEAL_OF_COMMAND", {
    { 20375, "Rank 1" },
})
reviewed("PALADIN", "SEAL_OF_FURY", {
    { 20163, "Rank 3" }, { 20419, "Rank 4" }, { 20421, "Rank 5" }, { 20422, "Rank 6" },
    { 20423, "Rank 7" }, { 1311649, "Rank 1" }, { 1311656, "Rank 2" },
})
reviewed("PALADIN", "SEAL_OF_JUSTICE", {
    { 20164, "unranked/unspecified" },
})
reviewed("PALADIN", "SEAL_OF_LIGHT", {
    { 20165, "Rank 1" }, { 20347, "Rank 2" }, { 20348, "Rank 3" }, { 20349, "Rank 4" },
})
reviewed("PALADIN", "SEAL_OF_RIGHTEOUSNESS", {
    { 20287, "Rank 2" }, { 20289, "Rank 4" }, { 20290, "Rank 5" }, { 20291, "Rank 6" },
    { 20292, "Rank 7" }, { 20293, "Rank 8" },
})
reviewed("PALADIN", "SEAL_OF_THE_CRUSADER", {
    { 20162, "Rank 2" }, { 20305, "Rank 3" }, { 20306, "Rank 4" }, { 20307, "Rank 5" },
    { 20308, "Rank 6" }, { 21082, "Rank 1" },
})
reviewed("PALADIN", "SEAL_OF_WISDOM", {
    { 20166, "Rank 1" }, { 20356, "Rank 2" }, { 20357, "Rank 3" },
})
reviewed("PALADIN", "SHADOW_RESISTANCE_AURA", {
    { 19876, "Rank 1" }, { 19895, "Rank 2" }, { 19896, "Rank 3" },
})
reviewed("PALADIN", "SWIFT_JUDGEMENT", {
    { 1310994, "unranked/unspecified" },
})
reviewed("PALADIN", "TEMPLARS_BULWARK", {
    { 1311015, "unranked/unspecified" },
})
reviewed("PALADIN", "TURN_UNDEAD", {
    { 2878, "Rank 1" }, { 5627, "Rank 2" }, { 10326, "Rank 3" },
})

-- PRIEST
reviewed("PRIEST", "ABOLISH_DISEASE", {
    { 552, "unranked/unspecified" },
})
reviewed("PRIEST", "CURE_DISEASE", {
    { 528, "unranked/unspecified" },
})
reviewed("PRIEST", "DEVOURING_PLAGUE", {
    { 2944, "Rank 1" }, { 19276, "Rank 2" }, { 19277, "Rank 3" }, { 19278, "Rank 4" },
    { 19279, "Rank 5" }, { 19280, "Rank 6" },
})
reviewed("PRIEST", "DISPEL_MAGIC", {
    { 527, "Rank 1" }, { 988, "Rank 2" },
})
reviewed("PRIEST", "DIVINE_SPIRIT", {
    { 14752, "Rank 1" }, { 14818, "Rank 2" }, { 14819, "Rank 3" }, { 27841, "Rank 4" },
})
reviewed("PRIEST", "FADE", {
    { 586, "Rank 1" }, { 9578, "Rank 2" }, { 9579, "Rank 3" }, { 9592, "Rank 4" },
    { 10941, "Rank 5" }, { 10942, "Rank 6" },
})
reviewed("PRIEST", "FEAR_WARD", {
    { 6346, "unranked/unspecified" },
})
reviewed("PRIEST", "FLASH_HEAL", {
    { 2061, "Rank 1" }, { 9472, "Rank 2" }, { 9473, "Rank 3" }, { 9474, "Rank 4" },
    { 10915, "Rank 5" }, { 10916, "Rank 6" }, { 10917, "Rank 7" },
})
reviewed("PRIEST", "GREATER_HEAL", {
    { 2060, "Rank 1" }, { 10963, "Rank 2" }, { 10964, "Rank 3" }, { 10965, "Rank 4" },
    { 25314, "Rank 5" },
})
reviewed("PRIEST", "HEAL", {
    { 2054, "Rank 1" }, { 2055, "Rank 2" }, { 6063, "Rank 3" }, { 6064, "Rank 4" },
})
reviewed("PRIEST", "HOLY_FIRE", {
    { 14914, "Rank 1" }, { 15261, "Rank 8" }, { 15262, "Rank 2" }, { 15263, "Rank 3" },
    { 15264, "Rank 4" }, { 15265, "Rank 5" }, { 15266, "Rank 6" }, { 15267, "Rank 7" },
})
reviewed("PRIEST", "HOLY_NOVA", {
    { 15237, "Rank 1" },
})
reviewed("PRIEST", "INNER_FIRE", {
    { 588, "Rank 1" }, { 602, "Rank 3" }, { 1006, "Rank 4" }, { 7128, "Rank 2" },
    { 10951, "Rank 5" }, { 10952, "Rank 6" },
})
reviewed("PRIEST", "INNER_FOCUS", {
    { 14751, "unranked/unspecified" },
})
reviewed("PRIEST", "LESSER_HEAL", {
    { 2050, "Rank 1" }, { 2052, "Rank 2" }, { 2053, "Rank 3" },
})
reviewed("PRIEST", "LEVITATE", {
    { 1706, "unranked/unspecified" },
})
reviewed("PRIEST", "MANA_BURN", {
    { 8129, "Rank 1" }, { 8131, "Rank 2" }, { 10874, "Rank 3" }, { 10875, "Rank 4" },
    { 10876, "Rank 5" },
})
reviewed("PRIEST", "MIND_BLAST", {
    { 8092, "Rank 1" }, { 8102, "Rank 2" }, { 8103, "Rank 3" }, { 8104, "Rank 4" },
    { 8105, "Rank 5" }, { 8106, "Rank 6" }, { 10945, "Rank 7" }, { 10946, "Rank 8" },
    { 10947, "Rank 9" },
})
reviewed("PRIEST", "MIND_SOOTHE", {
    { 453, "Rank 1" }, { 8192, "Rank 2" }, { 10953, "Rank 3" },
})
reviewed("PRIEST", "POWER_INFUSION", {
    { 10060, "unranked/unspecified" },
})
reviewed("PRIEST", "POWER_WORD_FORTITUDE", {
    { 1243, "Rank 1" }, { 1244, "Rank 2" }, { 1245, "Rank 3" }, { 2791, "Rank 4" },
    { 10937, "Rank 5" }, { 10938, "Rank 6" },
})
reviewed("PRIEST", "POWER_WORD_SHIELD", {
    { 17, "Rank 1" }, { 592, "Rank 2" }, { 600, "Rank 3" }, { 3747, "Rank 4" },
    { 6065, "Rank 5" }, { 6066, "Rank 6" }, { 10898, "Rank 7" }, { 10899, "Rank 8" },
    { 10900, "Rank 9" }, { 10901, "Rank 10" },
})
reviewed("PRIEST", "PRAYER_OF_FORTITUDE", {
    { 21562, "Rank 1" }, { 21564, "Rank 2" },
})
reviewed("PRIEST", "PRAYER_OF_HEALING", {
    { 596, "Rank 1" }, { 996, "Rank 2" }, { 10960, "Rank 3" }, { 10961, "Rank 4" },
    { 25316, "Rank 5" },
})
reviewed("PRIEST", "PRAYER_OF_MENDING", {
    { 401859, "Rank 1" },
})
reviewed("PRIEST", "PRAYER_OF_SHADOW_PROTECTION", {
    { 27683, "unranked/unspecified" },
})
reviewed("PRIEST", "PRAYER_OF_SPIRIT", {
    { 27681, "Rank 1" },
})
reviewed("PRIEST", "PSYCHIC_SCREAM", {
    { 8122, "Rank 1" }, { 8124, "Rank 2" }, { 10888, "Rank 3" }, { 10890, "Rank 4" },
})
reviewed("PRIEST", "RENEW", {
    { 139, "Rank 1" }, { 6074, "Rank 2" }, { 6075, "Rank 3" }, { 6076, "Rank 4" },
    { 6077, "Rank 5" }, { 6078, "Rank 6" }, { 10927, "Rank 7" }, { 10928, "Rank 8" },
    { 10929, "Rank 9" }, { 25315, "Rank 10" },
})
reviewed("PRIEST", "RESURRECTION", {
    { 2006, "Rank 1" }, { 2010, "Rank 2" }, { 10880, "Rank 3" }, { 10881, "Rank 4" },
    { 20770, "Rank 5" },
})
reviewed("PRIEST", "SHACKLE_UNDEAD", {
    { 9484, "Rank 1" }, { 9485, "Rank 2" }, { 10955, "Rank 3" },
})
reviewed("PRIEST", "SHADOW_PROTECTION", {
    { 976, "Rank 1" }, { 10957, "Rank 2" }, { 10958, "Rank 3" },
})
reviewed("PRIEST", "SHADOW_WORD_DEATH", {
    { 1309595, "Rank 1" }, { 1309633, "Rank 2" }, { 1309635, "Rank 3" }, { 1309636, "Rank 4" },
})
reviewed("PRIEST", "SHADOW_WORD_PAIN", {
    { 589, "Rank 1" }, { 594, "Rank 2" }, { 970, "Rank 3" }, { 992, "Rank 4" },
    { 2767, "Rank 5" }, { 10892, "Rank 6" }, { 10893, "Rank 7" }, { 10894, "Rank 8" },
})
reviewed("PRIEST", "SILENCE", {
    { 15487, "unranked/unspecified" },
})
reviewed("PRIEST", "SMITE", {
    { 585, "Rank 1" }, { 591, "Rank 2" }, { 598, "Rank 3" }, { 984, "Rank 4" },
    { 1004, "Rank 5" }, { 6060, "Rank 6" }, { 10933, "Rank 7" }, { 10934, "Rank 8" },
})
reviewed("PRIEST", "VAMPIRIC_EMBRACE", {
    { 15286, "unranked/unspecified" },
})

-- ROGUE
reviewed("ROGUE", "ADRENALINE_RUSH", {
    { 13750, "unranked/unspecified" },
})
reviewed("ROGUE", "AMBUSH", {
    { 8676, "Rank 1" }, { 8724, "Rank 2" }, { 8725, "Rank 3" }, { 11267, "Rank 4" },
    { 11268, "Rank 5" }, { 11269, "Rank 6" },
})
reviewed("ROGUE", "BACKSTAB", {
    { 53, "Rank 1" }, { 2589, "Rank 2" }, { 2590, "Rank 3" }, { 2591, "Rank 4" },
    { 8721, "Rank 5" }, { 11279, "Rank 6" }, { 11280, "Rank 7" }, { 11281, "Rank 8" },
    { 25300, "Rank 9" },
})
reviewed("ROGUE", "BLADE_FLURRY", {
    { 13877, "unranked/unspecified" },
})
reviewed("ROGUE", "BLIND", {
    { 2094, "unranked/unspecified" },
})
reviewed("ROGUE", "CHEAP_SHOT", {
    { 1833, "unranked/unspecified" },
})
reviewed("ROGUE", "COLD_BLOOD", {
    { 14177, "unranked/unspecified" },
})
reviewed("ROGUE", "DISARM_TRAP", {
    { 1842, "unranked/unspecified" },
})
reviewed("ROGUE", "EVASION", {
    { 5277, "unranked/unspecified" },
})
reviewed("ROGUE", "EVISCERATE", {
    { 2098, "Rank 1" }, { 6760, "Rank 2" }, { 6761, "Rank 3" }, { 6762, "Rank 4" },
    { 8623, "Rank 5" }, { 8624, "Rank 6" }, { 11299, "Rank 7" }, { 11300, "Rank 8" },
    { 31016, "Rank 9" },
})
reviewed("ROGUE", "EXPOSE_ARMOR", {
    { 8647, "Rank 1" }, { 8649, "Rank 2" }, { 8650, "Rank 3" }, { 11197, "Rank 4" },
    { 11198, "Rank 5" },
})
reviewed("ROGUE", "FEINT", {
    { 1966, "Rank 1" }, { 6768, "Rank 2" }, { 8637, "Rank 3" }, { 11303, "Rank 4" },
    { 25302, "Rank 5" },
})
reviewed("ROGUE", "GARROTE", {
    { 703, "Rank 1" }, { 8631, "Rank 2" }, { 8632, "Rank 3" }, { 8633, "Rank 4" },
    { 11289, "Rank 5" }, { 11290, "Rank 6" },
})
reviewed("ROGUE", "GHOSTLY_STRIKE", {
    { 14278, "unranked/unspecified" },
})
reviewed("ROGUE", "GOUGE", {
    { 1776, "Rank 1" }, { 1777, "Rank 2" }, { 8629, "Rank 3" }, { 11285, "Rank 4" },
    { 11286, "Rank 5" },
})
reviewed("ROGUE", "HEMORRHAGE", {
    { 16511, "unranked/unspecified" },
})
reviewed("ROGUE", "KICK", {
    { 1766, "Rank 1" }, { 1767, "Rank 2" }, { 1768, "Rank 3" }, { 1769, "Rank 4" },
})
reviewed("ROGUE", "KIDNEY_SHOT", {
    { 408, "Rank 1" }, { 8643, "Rank 2" },
})
reviewed("ROGUE", "PICK_POCKET", {
    { 921, "unranked/unspecified" },
})
reviewed("ROGUE", "PREMEDITATION", {
    { 14183, "unranked/unspecified" },
})
reviewed("ROGUE", "PREPARATION", {
    { 14185, "unranked/unspecified" },
})
reviewed("ROGUE", "RIPOSTE", {
    { 14251, "unranked/unspecified" },
})
reviewed("ROGUE", "RUPTURE", {
    { 1943, "Rank 1" }, { 8639, "Rank 2" }, { 8640, "Rank 3" }, { 11273, "Rank 4" },
    { 11274, "Rank 5" }, { 11275, "Rank 6" },
})
reviewed("ROGUE", "SAP", {
    { 2070, "Rank 2" }, { 6770, "Rank 1" }, { 11297, "Rank 3" },
})
reviewed("ROGUE", "SINISTER_STRIKE", {
    { 1752, "Rank 1" }, { 1757, "Rank 2" }, { 1758, "Rank 3" }, { 1759, "Rank 4" },
    { 1760, "Rank 5" }, { 8621, "Rank 6" }, { 11293, "Rank 7" }, { 11294, "Rank 8" },
})
reviewed("ROGUE", "SLICE_AND_DICE", {
    { 5171, "Rank 1" }, { 6774, "Rank 2" },
})
reviewed("ROGUE", "SPRINT", {
    { 2983, "Rank 1" }, { 8696, "Rank 2" }, { 11305, "Rank 3" },
})
reviewed("ROGUE", "STEALTH", {
    { 1784, "Rank 1" }, { 1785, "Rank 2" }, { 1786, "Rank 3" }, { 1787, "Rank 4" },
})
reviewed("ROGUE", "VANISH", {
    { 1856, "Rank 1" }, { 1857, "Rank 2" },
})

-- SHAMAN
reviewed("SHAMAN", "ANCESTRAL_SPIRIT", {
    { 2008, "Rank 1" }, { 20609, "Rank 2" }, { 20610, "Rank 3" }, { 20776, "Rank 4" },
    { 20777, "Rank 5" },
})
reviewed("SHAMAN", "ASTRAL_RECALL", {
    { 556, "unranked/unspecified" },
})
reviewed("SHAMAN", "CALL_OF_THE_ANCESTORS", {
    { 66843, "unranked/unspecified" },
})
reviewed("SHAMAN", "CALL_OF_THE_ELEMENTS", {
    { 66842, "unranked/unspecified" },
})
reviewed("SHAMAN", "CALL_OF_THE_SPIRITS", {
    { 66844, "unranked/unspecified" },
})
reviewed("SHAMAN", "CHAIN_HEAL", {
    { 1064, "Rank 1" }, { 10622, "Rank 2" }, { 10623, "Rank 3" },
})
reviewed("SHAMAN", "CHAIN_LIGHTNING", {
    { 421, "Rank 1" }, { 930, "Rank 2" }, { 2860, "Rank 3" }, { 10605, "Rank 4" },
})
reviewed("SHAMAN", "CURE_DISEASE", {
    { 2870, "unranked/unspecified" },
})
reviewed("SHAMAN", "CURE_POISON", {
    { 526, "unranked/unspecified" },
})
reviewed("SHAMAN", "DISEASE_CLEANSING_TOTEM", {
    { 8170, "unranked/unspecified" },
})
reviewed("SHAMAN", "EARTHBIND_TOTEM", {
    { 2484, "unranked/unspecified" },
})
reviewed("SHAMAN", "EARTH_SHOCK", {
    { 8042, "Rank 1" }, { 8044, "Rank 2" }, { 8045, "Rank 3" }, { 8046, "Rank 4" },
    { 10412, "Rank 5" }, { 10413, "Rank 6" }, { 10414, "Rank 7" },
})
reviewed("SHAMAN", "FIRE_NOVA", {
    { 408341, "Rank 1" }, { 408342, "Rank 2" }, { 408343, "Rank 3" }, { 408344, "Rank 4" },
    { 408345, "Rank 5" },
})
reviewed("SHAMAN", "FIRE_RESISTANCE_TOTEM", {
    { 8184, "Rank 1" }, { 10537, "Rank 2" }, { 10538, "Rank 3" },
})
reviewed("SHAMAN", "FLAMETONGUE_TOTEM", {
    { 8227, "Rank 1" }, { 8249, "Rank 2" }, { 10526, "Rank 3" }, { 16387, "Rank 4" },
})
reviewed("SHAMAN", "FLAMETONGUE_WEAPON", {
    { 8024, "Rank 1" }, { 8027, "Rank 2" }, { 8030, "Rank 3" }, { 16339, "Rank 4" },
    { 16341, "Rank 5" }, { 16342, "Rank 6" },
})
reviewed("SHAMAN", "FLAME_SHOCK", {
    { 8050, "Rank 1" }, { 8052, "Rank 2" }, { 8053, "Rank 3" }, { 10447, "Rank 4" },
    { 10448, "Rank 5" }, { 29228, "Rank 6" },
})
reviewed("SHAMAN", "FROSTBRAND_WEAPON", {
    { 8033, "Rank 1" }, { 8038, "Rank 2" }, { 10456, "Rank 3" }, { 16355, "Rank 4" },
    { 16356, "Rank 5" },
})
reviewed("SHAMAN", "FROST_RESISTANCE_TOTEM", {
    { 8181, "Rank 1" }, { 10478, "Rank 2" }, { 10479, "Rank 3" },
})
reviewed("SHAMAN", "FROST_SHOCK", {
    { 8056, "Rank 1" }, { 8058, "Rank 2" }, { 10472, "Rank 3" }, { 10473, "Rank 4" },
})
reviewed("SHAMAN", "GRACE_OF_AIR_TOTEM", {
    { 8835, "Rank 1" }, { 10627, "Rank 2" }, { 25359, "Rank 3" },
})
reviewed("SHAMAN", "GROUNDING_TOTEM", {
    { 8177, "unranked/unspecified" },
})
reviewed("SHAMAN", "HEALING_STREAM_TOTEM", {
    { 5394, "Rank 1" }, { 6375, "Rank 2" }, { 6377, "Rank 3" }, { 10462, "Rank 4" },
    { 10463, "Rank 5" },
})
reviewed("SHAMAN", "HEALING_WAVE", {
    { 331, "Rank 1" }, { 332, "Rank 2" }, { 913, "Rank 4" }, { 939, "Rank 5" },
    { 959, "Rank 6" }, { 8005, "Rank 7" }, { 10395, "Rank 8" }, { 10396, "Rank 9" },
    { 25357, "Rank 10" },
})
reviewed("SHAMAN", "LESSER_HEALING_WAVE", {
    { 8004, "Rank 1" }, { 8008, "Rank 2" }, { 8010, "Rank 3" }, { 10466, "Rank 4" },
    { 10467, "Rank 5" }, { 10468, "Rank 6" },
})
reviewed("SHAMAN", "LIGHTNING_BOLT", {
    { 403, "Rank 1" }, { 529, "Rank 2" }, { 548, "Rank 3" }, { 915, "Rank 4" },
    { 943, "Rank 5" }, { 6041, "Rank 6" }, { 10391, "Rank 7" }, { 10392, "Rank 8" },
    { 15207, "Rank 9" }, { 15208, "Rank 10" },
})
reviewed("SHAMAN", "LIGHTNING_SHIELD", {
    { 324, "Rank 1" }, { 905, "Rank 3" }, { 945, "Rank 4" }, { 8134, "Rank 5" },
    { 10431, "Rank 6" }, { 10432, "Rank 7" },
})
reviewed("SHAMAN", "MAGMA_TOTEM", {
    { 8190, "Rank 1" }, { 10585, "Rank 2" }, { 10586, "Rank 3" }, { 10587, "Rank 4" },
})
reviewed("SHAMAN", "MANA_SPRING_TOTEM", {
    { 5675, "Rank 1" }, { 10495, "Rank 2" }, { 10496, "Rank 3" }, { 10497, "Rank 4" },
})
reviewed("SHAMAN", "MANA_TIDE_TOTEM", {
    { 16190, "Rank 1" },
})
reviewed("SHAMAN", "NATURES_SWIFTNESS", {
    { 16188, "unranked/unspecified" },
})
reviewed("SHAMAN", "NATURE_RESISTANCE_TOTEM", {
    { 10595, "Rank 1" }, { 10600, "Rank 2" }, { 10601, "Rank 3" },
})
reviewed("SHAMAN", "POISON_CLEANSING_TOTEM", {
    { 8166, "unranked/unspecified" },
})
reviewed("SHAMAN", "PURGE", {
    { 370, "Rank 1" }, { 8012, "Rank 2" },
})
reviewed("SHAMAN", "RAGE_OF_THE_FARSEER", {
    { 425336, "unranked/unspecified" },
})
reviewed("SHAMAN", "RIPTIDE", {
    { 408521, "Rank 1" },
})
reviewed("SHAMAN", "ROCKBITER_WEAPON", {
    { 8017, "Rank 1" }, { 8018, "Rank 2" }, { 8019, "Rank 3" }, { 10399, "Rank 4" },
    { 16314, "Rank 5" }, { 16315, "Rank 6" }, { 16316, "Rank 7" },
})
reviewed("SHAMAN", "SEARING_TOTEM", {
    { 3599, "Rank 1" }, { 6363, "Rank 2" }, { 6364, "Rank 3" }, { 6365, "Rank 4" },
    { 10437, "Rank 5" }, { 10438, "Rank 6" },
})
reviewed("SHAMAN", "STONECLAW_TOTEM", {
    { 5730, "Rank 1" }, { 6390, "Rank 2" }, { 6391, "Rank 3" }, { 6392, "Rank 4" },
    { 10427, "Rank 5" }, { 10428, "Rank 6" },
})
reviewed("SHAMAN", "STONESKIN_TOTEM", {
    { 8071, "Rank 1" }, { 8154, "Rank 2" }, { 8155, "Rank 3" }, { 10406, "Rank 4" },
    { 10407, "Rank 5" }, { 10408, "Rank 6" },
})
reviewed("SHAMAN", "STORMSTRIKE", {
    { 17364, "unranked/unspecified" },
})
reviewed("SHAMAN", "STRENGTH_OF_EARTH_TOTEM", {
    { 8075, "Rank 1" }, { 8160, "Rank 2" }, { 8161, "Rank 3" }, { 10442, "Rank 4" },
    { 25361, "Rank 5" },
})
reviewed("SHAMAN", "TOTEMIC_RECALL", {
    { 36936, "unranked/unspecified" },
})
reviewed("SHAMAN", "TREMOR_TOTEM", {
    { 8143, "unranked/unspecified" },
})
reviewed("SHAMAN", "WATER_BREATHING", {
    { 131, "unranked/unspecified" },
})
reviewed("SHAMAN", "WATER_SHIELD", {
    { 408510, "unranked/unspecified" },
})
reviewed("SHAMAN", "WATER_WALKING", {
    { 546, "unranked/unspecified" },
})
reviewed("SHAMAN", "WINDFURY_TOTEM", {
    { 8512, "Rank 1" }, { 10613, "Rank 2" }, { 10614, "Rank 3" },
})
reviewed("SHAMAN", "WINDFURY_WEAPON", {
    { 8232, "Rank 1" }, { 8235, "Rank 2" }, { 10486, "Rank 3" }, { 16362, "Rank 4" },
})
reviewed("SHAMAN", "WINDWALL_TOTEM", {
    { 15107, "Rank 1" }, { 15111, "Rank 2" }, { 15112, "Rank 3" },
})

-- WARLOCK
reviewed("WARLOCK", "AMPLIFY_CURSE", {
    { 18288, "unranked/unspecified" },
})
reviewed("WARLOCK", "BANE_OF_AGONY", {
    { 980, "Rank 1" }, { 1014, "Rank 2" }, { 6217, "Rank 3" }, { 11711, "Rank 4" },
    { 11712, "Rank 5" }, { 11713, "Rank 6" },
})
reviewed("WARLOCK", "BANE_OF_DOOM", {
    { 603, "unranked/unspecified" },
})
reviewed("WARLOCK", "BANE_OF_HAVOC", {
    { 1225228, "unranked/unspecified" },
})
reviewed("WARLOCK", "BANISH", {
    { 710, "Rank 1" }, { 18647, "Rank 2" },
})
reviewed("WARLOCK", "CONFLAGRATE", {
    { 1293817, "Rank 1" },
})
reviewed("WARLOCK", "CORRUPTION", {
    { 172, "Rank 1" }, { 6222, "Rank 2" }, { 6223, "Rank 3" }, { 7648, "Rank 4" },
    { 11671, "Rank 5" }, { 11672, "Rank 6" }, { 25311, "Rank 7" },
})
reviewed("WARLOCK", "CREATE_FIRESTONE", {
    { 6366, "Rank 1" }, { 17951, "Rank 2" }, { 17952, "Rank 3" }, { 17953, "Rank 4" },
})
reviewed("WARLOCK", "CREATE_HEALTHSTONE", {
    { 5699, "Rank 3" }, { 6201, "Rank 1" }, { 6202, "Rank 2" }, { 11729, "Rank 4" },
    { 11730, "Rank 5" },
})
reviewed("WARLOCK", "CREATE_SOULSTONE", {
    { 693, "Rank 1" }, { 20752, "Rank 2" }, { 20755, "Rank 3" }, { 20756, "Rank 4" },
    { 20757, "Rank 5" },
})
reviewed("WARLOCK", "CREATE_SPELLSTONE", {
    { 2362, "Rank 1" }, { 17727, "Rank 2" }, { 17728, "Rank 3" },
})
reviewed("WARLOCK", "CURSE_OF_EXHAUSTION", {
    { 18223, "unranked/unspecified" },
})
reviewed("WARLOCK", "CURSE_OF_RECKLESSNESS", {
    { 704, "Rank 1" }, { 7658, "Rank 2" }, { 7659, "Rank 3" }, { 11717, "Rank 4" },
})
reviewed("WARLOCK", "CURSE_OF_THE_ELEMENTS", {
    { 440892, "Rank 1" }, { 1311676, "Rank 2" }, { 1311677, "Rank 3" }, { 1311680, "Rank 4" },
})
reviewed("WARLOCK", "CURSE_OF_TONGUES", {
    { 1714, "Rank 1" }, { 11719, "Rank 2" },
})
reviewed("WARLOCK", "CURSE_OF_WEAKNESS", {
    { 702, "Rank 1" }, { 1108, "Rank 2" }, { 6205, "Rank 3" }, { 7646, "Rank 4" },
    { 11707, "Rank 5" }, { 11708, "Rank 6" },
})
reviewed("WARLOCK", "DEATH_COIL", {
    { 6789, "Rank 1" }, { 17925, "Rank 2" }, { 17926, "Rank 3" },
})
reviewed("WARLOCK", "DEMONIC_SACRIFICE", {
    { 18788, "unranked/unspecified" },
})
reviewed("WARLOCK", "DEMON_ARMOR", {
    { 706, "Rank 1" }, { 1086, "Rank 2" }, { 11733, "Rank 3" }, { 11734, "Rank 4" },
    { 11735, "Rank 5" },
})
reviewed("WARLOCK", "DEMON_SKIN", {
    { 687, "Rank 1" }, { 696, "Rank 2" },
})
reviewed("WARLOCK", "DETECT_INVISIBILITY", {
    { 132, "Rank 1" }, { 2970, "Rank 2" }, { 11743, "Rank 3" },
})
reviewed("WARLOCK", "FEAR", {
    { 5782, "Rank 1" }, { 6213, "Rank 2" }, { 6215, "Rank 3" },
})
reviewed("WARLOCK", "FEL_DOMINATION", {
    { 18708, "unranked/unspecified" },
})
reviewed("WARLOCK", "HOWL_OF_TERROR", {
    { 5484, "Rank 1" }, { 17928, "Rank 2" },
})
reviewed("WARLOCK", "IMMOLATE", {
    { 348, "Rank 1" }, { 707, "Rank 2" }, { 1094, "Rank 3" }, { 2941, "Rank 4" },
    { 11665, "Rank 5" }, { 11667, "Rank 6" }, { 11668, "Rank 7" }, { 25309, "Rank 8" },
})
reviewed("WARLOCK", "INCINERATE", {
    { 412758, "Rank 1" },
})
reviewed("WARLOCK", "LIFE_TAP", {
    { 1454, "Rank 1" }, { 1455, "Rank 2" }, { 1456, "Rank 3" }, { 11687, "Rank 4" },
    { 11688, "Rank 5" }, { 11689, "Rank 6" },
})
reviewed("WARLOCK", "SEARING_PAIN", {
    { 5676, "Rank 1" }, { 17919, "Rank 2" }, { 17920, "Rank 3" }, { 17921, "Rank 4" },
    { 17922, "Rank 5" }, { 17923, "Rank 6" },
})
reviewed("WARLOCK", "SHADOWBURN", {
    { 17877, "Rank 1" },
})
reviewed("WARLOCK", "SHADOW_BOLT", {
    { 686, "Rank 1" }, { 695, "Rank 2" }, { 705, "Rank 3" }, { 1088, "Rank 4" },
    { 1106, "Rank 5" }, { 7641, "Rank 6" }, { 11659, "Rank 7" }, { 11660, "Rank 8" },
    { 11661, "Rank 9" }, { 25307, "Rank 10" },
})
reviewed("WARLOCK", "SHADOW_WARD", {
    { 6229, "Rank 1" }, { 11739, "Rank 2" }, { 11740, "Rank 3" }, { 28610, "Rank 4" },
})
reviewed("WARLOCK", "SIPHON_LIFE", {
    { 18265, "Rank 1" },
})
reviewed("WARLOCK", "SOUL_FIRE", {
    { 6353, "Rank 1" }, { 17924, "Rank 2" },
})
reviewed("WARLOCK", "SOUL_LINK", {
    { 19028, "unranked/unspecified" },
})
reviewed("WARLOCK", "SUBJUGATE_DEMON", {
    { 1098, "Rank 1" }, { 11725, "Rank 2" }, { 11726, "Rank 3" },
})
reviewed("WARLOCK", "SUMMON_INCUBUS", {
    { 713, "Summon" },
})
reviewed("WARLOCK", "UNENDING_BREATH", {
    { 5697, "unranked/unspecified" },
})

-- WARRIOR
reviewed("WARRIOR", "BATTLE_SHOUT", {
    { 5242, "Rank 2" }, { 6192, "Rank 3" }, { 6673, "Rank 1" }, { 11549, "Rank 4" },
    { 11550, "Rank 5" }, { 11551, "Rank 6" }, { 25289, "Rank 7" },
})
reviewed("WARRIOR", "BERSERKER_RAGE", {
    { 18499, "unranked/unspecified" },
})
reviewed("WARRIOR", "BLOODRAGE", {
    { 2687, "unranked/unspecified" },
})
reviewed("WARRIOR", "BLOODTHIRST", {
    { 23881, "Rank 1" },
})
reviewed("WARRIOR", "CHALLENGING_SHOUT", {
    { 1161, "unranked/unspecified" },
})
reviewed("WARRIOR", "CHARGE", {
    { 100, "Rank 1" }, { 6178, "Rank 2" }, { 11578, "Rank 3" },
})
reviewed("WARRIOR", "CONCUSSION_BLOW", {
    { 12809, "unranked/unspecified" },
})
reviewed("WARRIOR", "DEATH_WISH", {
    { 12328, "unranked/unspecified" },
})
reviewed("WARRIOR", "DEMORALIZING_SHOUT", {
    { 1160, "Rank 1" }, { 6190, "Rank 2" }, { 11554, "Rank 3" }, { 11555, "Rank 4" },
    { 11556, "Rank 5" },
})
reviewed("WARRIOR", "DISARM", {
    { 676, "unranked/unspecified" },
})
reviewed("WARRIOR", "EXECUTE", {
    { 5308, "Rank 1" }, { 20658, "Rank 2" }, { 20660, "Rank 3" }, { 20661, "Rank 4" },
    { 20662, "Rank 5" },
})
reviewed("WARRIOR", "HAMSTRING", {
    { 1715, "Rank 1" }, { 7372, "Rank 2" }, { 7373, "Rank 3" },
})
reviewed("WARRIOR", "INTERCEPT", {
    { 20252, "Rank 1" }, { 20616, "Rank 2" }, { 20617, "Rank 3" },
})
reviewed("WARRIOR", "INTIMIDATING_SHOUT", {
    { 5246, "unranked/unspecified" },
})
reviewed("WARRIOR", "LAST_STAND", {
    { 12975, "unranked/unspecified" },
})
reviewed("WARRIOR", "MOCKING_BLOW", {
    { 694, "Rank 1" }, { 7400, "Rank 2" }, { 7402, "Rank 3" }, { 20559, "Rank 4" },
    { 20560, "Rank 5" },
})
reviewed("WARRIOR", "MORTAL_STRIKE", {
    { 12294, "Rank 1" },
})
reviewed("WARRIOR", "OVERPOWER", {
    { 7384, "Rank 1" }, { 7887, "Rank 2" }, { 11584, "Rank 3" }, { 11585, "Rank 4" },
})
reviewed("WARRIOR", "PIERCING_HOWL", {
    { 12323, "unranked/unspecified" },
})
reviewed("WARRIOR", "PUMMEL", {
    { 6552, "Rank 1" }, { 6554, "Rank 2" },
})
reviewed("WARRIOR", "RECKLESSNESS", {
    { 1719, "unranked/unspecified" },
})
reviewed("WARRIOR", "REND", {
    { 772, "Rank 1" }, { 6546, "Rank 2" }, { 6547, "Rank 3" }, { 6548, "Rank 4" },
    { 11572, "Rank 5" }, { 11573, "Rank 6" }, { 11574, "Rank 7" },
})
reviewed("WARRIOR", "RETALIATION", {
    { 20230, "unranked/unspecified" },
})
reviewed("WARRIOR", "REVENGE", {
    { 6572, "Rank 1" }, { 6574, "Rank 2" }, { 7379, "Rank 3" }, { 11600, "Rank 4" },
    { 11601, "Rank 5" }, { 25288, "Rank 6" },
})
reviewed("WARRIOR", "SHIELD_BASH", {
    { 72, "Rank 1" }, { 1671, "Rank 2" }, { 1672, "Rank 3" },
})
reviewed("WARRIOR", "SHIELD_BLOCK", {
    { 2565, "unranked/unspecified" },
})
reviewed("WARRIOR", "SHIELD_SLAM", {
    { 23922, "Rank 1" },
})
reviewed("WARRIOR", "SHIELD_WALL", {
    { 871, "unranked/unspecified" },
})
reviewed("WARRIOR", "SLAM", {
    { 1464, "Rank 2" }, { 8820, "Rank 3" }, { 11604, "Rank 4" }, { 11605, "Rank 5" },
    { 1240193, "Rank 1" },
})
reviewed("WARRIOR", "SPEARING_STRIKE", {
    { 1310222, "unranked/unspecified" },
})
reviewed("WARRIOR", "SUNDER_ARMOR", {
    { 7386, "Rank 1" }, { 7405, "Rank 2" }, { 8380, "Rank 3" }, { 11596, "Rank 4" },
    { 11597, "Rank 5" },
})
reviewed("WARRIOR", "SWEEPING_STRIKES", {
    { 12292, "unranked/unspecified" },
})
reviewed("WARRIOR", "THUNDER_CLAP", {
    { 6343, "Rank 1" }, { 8198, "Rank 2" }, { 8204, "Rank 3" }, { 8205, "Rank 4" },
    { 11580, "Rank 5" }, { 11581, "Rank 6" },
})
reviewed("WARRIOR", "VICTORY_RUSH", {
    { 402927, "unranked/unspecified" },
})
reviewed("WARRIOR", "WHIRLWIND", {
    { 1680, "unranked/unspecified" },
})

for _, record in ipairs(Mappings.Records) do
    record.reviewID = "M2:" .. record.class .. ":" .. record.ability .. ":" .. record.spellID
end

local function validID(value)
    return type(value) == "number" and value > 0 and value < math.huge
        and value == value and value % 1 == 0
end

-- Validate bundled plain Lua data once, not event payloads. A record list keeps
-- duplicate declarations visible; a keyed Lua literal would overwrite them.
-- Publish no partial index if any record is invalid.
function Mappings.BuildIndex(records, abilities)
    if type(records) ~= "table" or type(abilities) ~= "table" then
        return nil, "invalid_container"
    end
    local count = 0
    for position in pairs(records) do
        if not validID(position) then return nil, "invalid_record_list" end
        count = count + 1
    end
    local index = {}
    for position = 1, count do
        local record = records[position]
        if type(record) ~= "table" then return nil, "invalid_record" end
        if not validID(record.spellID) then return nil, "invalid_spell_id" end
        local class, ability = record.class, record.ability
        if type(class) ~= "string" or type(ability) ~= "string"
            or type(abilities[class]) ~= "table" or abilities[class][ability] ~= ability then
            return nil, "unknown_ability"
        end
        if record.mechanism ~= "player_success" then return nil, "unsupported_mechanism" end
        local tier = record.evidence == "owner_reported_success" and "A"
            or ((record.evidence == "third_party_success" or record.evidence == "forever_reviewed") and "B")
        if not tier or record.evidenceTier ~= tier
            or type(record.evidenceRef) ~= "string" or record.evidenceRef == "" then
            return nil, "missing_evidence"
        end
        index[class] = index[class] or {}
        if index[class][record.spellID] ~= nil then return nil, "duplicate_spell_id" end
        index[class][record.spellID] = ability
    end
    return index
end

local index, validationError = Mappings.BuildIndex(Mappings.Records, RPHelper.Ability)
Mappings.validationError = validationError
-- The adapter, Library and offline exporter share this single compiled index.
-- Bad bundled data disables ability mappings; generic detection stays available.
RPHelper.RuntimeAPI.AbilitySpellIDs = index or {}
