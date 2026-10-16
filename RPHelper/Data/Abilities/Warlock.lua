-- RPHelper Forever - Warlock ability content
-- Corpus migration from the RPhelper_twow Warlock catalogue and original RoleplayingHelper lineage.
-- The legacy Warlock source carried no named contributor attribution.

local A = RPHelper.Ability.WARLOCK
local C = RPHelper.Class.WARLOCK
local function add(ability, entryType, text)
    A[ability] = A[ability] or ability
    RPHelper.RegisterAbility(C, A[ability], { type = entryType, text = text })
end

-- =====================================================================
-- Affliction
-- =====================================================================

-- ---------------------------------------------------------------------
-- AMPLIFY_CURSE
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "AMPLIFY_CURSE")

-- add("AMPLIFY_CURSE", "say", "")
-- add("AMPLIFY_CURSE", "emote", "")
-- add("AMPLIFY_CURSE", "customemote", "")

-- ---------------------------------------------------------------------
-- BANE_OF_AGONY
-- ---------------------------------------------------------------------
add("BANE_OF_AGONY", "say", "You shall know pain and agony, {TARGET}!")

-- ---------------------------------------------------------------------
-- BANE_OF_DOOM
-- ---------------------------------------------------------------------
add("BANE_OF_DOOM", "say", "I bring DOOM upon you!")
add("BANE_OF_DOOM", "emote", "WRATH")
add("BANE_OF_DOOM", "customemote", "threatens {TARGET} with the wrath of doom.")

-- ---------------------------------------------------------------------
-- CORRUPTION
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "CORRUPTION")

-- add("CORRUPTION", "say", "")
-- add("CORRUPTION", "emote", "")
-- add("CORRUPTION", "customemote", "")

-- ---------------------------------------------------------------------
-- CURSE_OF_EXHAUSTION
-- ---------------------------------------------------------------------
add("CURSE_OF_EXHAUSTION", "say", "Your limbs are heavier and heavier, {TARGET}! Just give up...")

-- ---------------------------------------------------------------------
-- CURSE_OF_RECKLESSNESS
-- ---------------------------------------------------------------------
add("CURSE_OF_RECKLESSNESS", "say", "Reckless actions will lead you to death, {TARGET}.")

-- ---------------------------------------------------------------------
-- CURSE_OF_THE_ELEMENTS
-- ---------------------------------------------------------------------
add("CURSE_OF_THE_ELEMENTS", "say", "This is Elementary...")

-- ---------------------------------------------------------------------
-- CURSE_OF_TONGUES
-- ---------------------------------------------------------------------
add("CURSE_OF_TONGUES", "customemote", "makes {TARGET} speak in demonic.")

-- ---------------------------------------------------------------------
-- CURSE_OF_WEAKNESS
-- ---------------------------------------------------------------------
add("CURSE_OF_WEAKNESS", "say", "I found your weakness, {TARGET} and now you'll meet your end.")

-- ---------------------------------------------------------------------
-- DEATH_COIL
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "DEATH_COIL")

-- add("DEATH_COIL", "say", "")
-- add("DEATH_COIL", "emote", "")
-- add("DEATH_COIL", "customemote", "")

-- ---------------------------------------------------------------------
-- DRAIN_LIFE
-- ---------------------------------------------------------------------
add("DRAIN_LIFE", "say", "I shall bleed you dry.")

-- ---------------------------------------------------------------------
-- DRAIN_MANA
-- ---------------------------------------------------------------------
add("DRAIN_MANA", "say", "You won't need that mana anymore.")

-- ---------------------------------------------------------------------
-- DRAIN_SOUL
-- ---------------------------------------------------------------------
add("DRAIN_SOUL", "say", "I'll swallow your soul.")
add("DRAIN_SOUL", "say", "Your soul shall burn!")
add("DRAIN_SOUL", "say", "You will know endless torment.")
add("DRAIN_SOUL", "say", "Your soul is mine!")
add("DRAIN_SOUL", "say", "Your soul will sustain my demons.")
add("DRAIN_SOUL", "say", "My demons must feast.")
add("DRAIN_SOUL", "say", "Your soul will feed my power.")

-- ---------------------------------------------------------------------
-- FEAR
-- ---------------------------------------------------------------------
add("FEAR", "say", "Prepare to know the true meaning of fear.")
add("FEAR", "say", "And once you know it - run.")

-- ---------------------------------------------------------------------
-- HOWL_OF_TERROR
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "HOWL_OF_TERROR")

-- add("HOWL_OF_TERROR", "say", "")
-- add("HOWL_OF_TERROR", "emote", "")
-- add("HOWL_OF_TERROR", "customemote", "")

-- ---------------------------------------------------------------------
-- LIFE_TAP
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "LIFE_TAP")

-- add("LIFE_TAP", "say", "")
-- add("LIFE_TAP", "emote", "")
-- add("LIFE_TAP", "customemote", "")

-- ---------------------------------------------------------------------
-- SIPHON_LIFE
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "SIPHON_LIFE")

-- add("SIPHON_LIFE", "say", "")
-- add("SIPHON_LIFE", "emote", "")
-- add("SIPHON_LIFE", "customemote", "")

-- ---------------------------------------------------------------------
-- WRACK
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "WRACK")

-- add("WRACK", "say", "")
-- add("WRACK", "emote", "")
-- add("WRACK", "customemote", "")

-- =====================================================================
-- Demonology
-- =====================================================================

-- ---------------------------------------------------------------------
-- BANISH
-- ---------------------------------------------------------------------
add("BANISH", "customemote", "banishes {TARGET} from this plane briefly.")

-- ---------------------------------------------------------------------
-- CREATE_FIRESTONE
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "CREATE_FIRESTONE")

-- add("CREATE_FIRESTONE", "say", "")
-- add("CREATE_FIRESTONE", "emote", "")
-- add("CREATE_FIRESTONE", "customemote", "")

-- ---------------------------------------------------------------------
-- CREATE_HEALTHSTONE
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "CREATE_HEALTHSTONE")

-- add("CREATE_HEALTHSTONE", "say", "")
-- add("CREATE_HEALTHSTONE", "emote", "")
-- add("CREATE_HEALTHSTONE", "customemote", "")

-- ---------------------------------------------------------------------
-- CREATE_SOULSTONE
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "CREATE_SOULSTONE")

-- add("CREATE_SOULSTONE", "say", "")
-- add("CREATE_SOULSTONE", "emote", "")
-- add("CREATE_SOULSTONE", "customemote", "")

-- ---------------------------------------------------------------------
-- CREATE_SPELLSTONE
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "CREATE_SPELLSTONE")

-- add("CREATE_SPELLSTONE", "say", "")
-- add("CREATE_SPELLSTONE", "emote", "")
-- add("CREATE_SPELLSTONE", "customemote", "")

-- ---------------------------------------------------------------------
-- DEMONIC_SACRIFICE
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "DEMONIC_SACRIFICE")

-- add("DEMONIC_SACRIFICE", "say", "")
-- add("DEMONIC_SACRIFICE", "emote", "")
-- add("DEMONIC_SACRIFICE", "customemote", "")

-- ---------------------------------------------------------------------
-- DEMON_ARMOR
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "DEMON_ARMOR")

-- add("DEMON_ARMOR", "say", "")
-- add("DEMON_ARMOR", "emote", "")
-- add("DEMON_ARMOR", "customemote", "")

-- ---------------------------------------------------------------------
-- DEMON_SKIN
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "DEMON_SKIN")

-- add("DEMON_SKIN", "say", "")
-- add("DEMON_SKIN", "emote", "")
-- add("DEMON_SKIN", "customemote", "")

-- ---------------------------------------------------------------------
-- DETECT_INVISIBILITY
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "DETECT_INVISIBILITY")

-- add("DETECT_INVISIBILITY", "say", "")
-- add("DETECT_INVISIBILITY", "emote", "")
-- add("DETECT_INVISIBILITY", "customemote", "")

-- ---------------------------------------------------------------------
-- EYE_OF_KILROGG
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "EYE_OF_KILROGG")

-- add("EYE_OF_KILROGG", "say", "")
-- add("EYE_OF_KILROGG", "emote", "")
-- add("EYE_OF_KILROGG", "customemote", "")

-- ---------------------------------------------------------------------
-- FEL_DOMINATION
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "FEL_DOMINATION")

-- add("FEL_DOMINATION", "say", "")
-- add("FEL_DOMINATION", "emote", "")
-- add("FEL_DOMINATION", "customemote", "")

-- ---------------------------------------------------------------------
-- HEALTH_FUNNEL
-- ---------------------------------------------------------------------
add("HEALTH_FUNNEL", "customemote", "tends to {PP} demon's wounds.")

-- ---------------------------------------------------------------------
-- INFERNO
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "INFERNO")

-- add("INFERNO", "say", "")
-- add("INFERNO", "emote", "")
-- add("INFERNO", "customemote", "")

-- ---------------------------------------------------------------------
-- RITUAL_OF_DOOM
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "RITUAL_OF_DOOM")

-- add("RITUAL_OF_DOOM", "say", "")
-- add("RITUAL_OF_DOOM", "emote", "")
-- add("RITUAL_OF_DOOM", "customemote", "")

-- ---------------------------------------------------------------------
-- RITUAL_OF_SUMMONING
-- ---------------------------------------------------------------------
add("RITUAL_OF_SUMMONING", "say", "Summoning {TARGET}.")
add("RITUAL_OF_SUMMONING", "customemote", "chants in Demonic as {TARGET}'s name echoes through the air.")

-- ---------------------------------------------------------------------
-- SENSE_DEMONS
-- ---------------------------------------------------------------------
add("SENSE_DEMONS", "say", "Hmm, let's see if we have some demons nearby to enslave...")

-- ---------------------------------------------------------------------
-- SHADOW_WARD
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "SHADOW_WARD")

-- add("SHADOW_WARD", "say", "")
-- add("SHADOW_WARD", "emote", "")
-- add("SHADOW_WARD", "customemote", "")

-- ---------------------------------------------------------------------
-- SOUL_LINK
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "SOUL_LINK")

-- add("SOUL_LINK", "say", "")
-- add("SOUL_LINK", "emote", "")
-- add("SOUL_LINK", "customemote", "")

-- ---------------------------------------------------------------------
-- SUBJUGATE_DEMON
-- ---------------------------------------------------------------------
add("SUBJUGATE_DEMON", "emote", "GRIN")

-- ---------------------------------------------------------------------
-- SUMMON_FELHUNTER
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "SUMMON_FELHUNTER")

-- add("SUMMON_FELHUNTER", "say", "")
-- add("SUMMON_FELHUNTER", "emote", "")
-- add("SUMMON_FELHUNTER", "customemote", "")

-- ---------------------------------------------------------------------
-- SUMMON_IMP
-- ---------------------------------------------------------------------
add("SUMMON_IMP", "say", "Did you think I would let you rest imp?")
add("SUMMON_IMP", "say", "Time to get back to work, imp.")
add("SUMMON_IMP", "say", "Your labor is not even close to finished, imp.")
add("SUMMON_IMP", "say", "You cannot escape me that easily imp.")
add("SUMMON_IMP", "say", "Weakness will not be tolerated imp.")
add("SUMMON_IMP", "say", "You will never know rest imp, your labor will never be done.")

-- ---------------------------------------------------------------------
-- SUMMON_INCUBUS
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "SUMMON_INCUBUS")

-- add("SUMMON_INCUBUS", "say", "")
-- add("SUMMON_INCUBUS", "emote", "")
-- add("SUMMON_INCUBUS", "customemote", "")

-- ---------------------------------------------------------------------
-- SUMMON_SUCCUBUS
-- ---------------------------------------------------------------------
add("SUMMON_SUCCUBUS", "say", "Did you think I would let you rest minx?")
add("SUMMON_SUCCUBUS", "say", "Succubus! Get back to work!")
add("SUMMON_SUCCUBUS", "say", "Your labor is not even close to finished, temptress!")
add("SUMMON_SUCCUBUS", "say", "You cannot escape me that easily, temptress!")
add("SUMMON_SUCCUBUS", "say", "Weakness will not be tolerated, Succubus!")
add("SUMMON_SUCCUBUS", "say", "You will never know rest temptress, your job is to heed your master!")

-- ---------------------------------------------------------------------
-- SUMMON_VOIDWALKER
-- ---------------------------------------------------------------------
add("SUMMON_VOIDWALKER", "say", "Did you think I would let you rest, demon?")
add("SUMMON_VOIDWALKER", "say", "Demon! Get back to work!")
add("SUMMON_VOIDWALKER", "say", "Your labor is not even close to finished demon!")
add("SUMMON_VOIDWALKER", "say", "You cannot escape me that easily demon!")
add("SUMMON_VOIDWALKER", "say", "Weakness will not be tolerated, demon!")
add("SUMMON_VOIDWALKER", "say", "You will never know rest demon, your labor will never be done!")

-- ---------------------------------------------------------------------
-- UNENDING_BREATH
-- ---------------------------------------------------------------------
add("UNENDING_BREATH", "say", "Your breath will be unending.")

-- =====================================================================
-- Destruction
-- =====================================================================

-- ---------------------------------------------------------------------
-- BANE_OF_HAVOC
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "BANE_OF_HAVOC")

-- add("BANE_OF_HAVOC", "say", "")
-- add("BANE_OF_HAVOC", "emote", "")
-- add("BANE_OF_HAVOC", "customemote", "")

-- ---------------------------------------------------------------------
-- CONFLAGRATE
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "CONFLAGRATE")

-- add("CONFLAGRATE", "say", "")
-- add("CONFLAGRATE", "emote", "")
-- add("CONFLAGRATE", "customemote", "")

-- ---------------------------------------------------------------------
-- HELLFIRE
-- ---------------------------------------------------------------------
add("HELLFIRE", "say", "I shall set this world aflame!")

-- ---------------------------------------------------------------------
-- IMMOLATE
-- ---------------------------------------------------------------------
add("IMMOLATE", "say", "Mind if I turn up the heat a bit, {TARGET}?")
add("IMMOLATE", "say", "Time to get a little hot under the collar, {TARGET}.")

-- ---------------------------------------------------------------------
-- INCINERATE
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "INCINERATE")

-- add("INCINERATE", "say", "")
-- add("INCINERATE", "emote", "")
-- add("INCINERATE", "customemote", "")

-- ---------------------------------------------------------------------
-- RAIN_OF_FIRE
-- ---------------------------------------------------------------------
add("RAIN_OF_FIRE", "say", "Rain fire!")
add("RAIN_OF_FIRE", "say", "Fire from the sky!")
add("RAIN_OF_FIRE", "say", "Destruction by Fire!")

-- ---------------------------------------------------------------------
-- SEARING_PAIN
-- ---------------------------------------------------------------------
add("SEARING_PAIN", "say", "Pain should be searing from THIS!")

-- ---------------------------------------------------------------------
-- SHADOWBURN
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "SHADOWBURN")

-- add("SHADOWBURN", "say", "")
-- add("SHADOWBURN", "emote", "")
-- add("SHADOWBURN", "customemote", "")

-- ---------------------------------------------------------------------
-- SHADOW_BOLT
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "SHADOW_BOLT")

-- add("SHADOW_BOLT", "say", "")
-- add("SHADOW_BOLT", "emote", "")
-- add("SHADOW_BOLT", "customemote", "")

-- ---------------------------------------------------------------------
-- SOUL_FIRE
-- ---------------------------------------------------------------------
add("SOUL_FIRE", "say", "Your soul shall BURN!")
add("SOUL_FIRE", "say", "Feel the fire with your VERY SOUL!")
