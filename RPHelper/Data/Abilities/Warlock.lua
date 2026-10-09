-- RPHelper Forever - Warlock ability content
-- Corpus migration from the RPhelper_twow Warlock catalogue and original RoleplayingHelper lineage.
-- The legacy Warlock source carried no named contributor attribution.

local A = RPHelper.Ability.WARLOCK
local C = RPHelper.Class.WARLOCK
local function add(ability, entryType, text)
    A[ability] = A[ability] or ability
    RPHelper.RegisterAbility(C, A[ability], { type = entryType, text = text })
end

-- ---------------------------------------------------------------------
-- CURSE_OF_WEAKNESS
-- ---------------------------------------------------------------------
add("CURSE_OF_WEAKNESS", "say", "I found your weakness, {TARGET} and now you'll meet your end.")

-- ---------------------------------------------------------------------
-- CURSE_OF_AGONY
-- ---------------------------------------------------------------------
add("CURSE_OF_AGONY", "say", "You shall know pain and agony, {TARGET}!")

-- ---------------------------------------------------------------------
-- CURSE_OF_RECKLESSNESS
-- ---------------------------------------------------------------------
add("CURSE_OF_RECKLESSNESS", "say", "Reckless actions will lead you to death, {TARGET}.")

-- ---------------------------------------------------------------------
-- CURSE_OF_TONGUES
-- ---------------------------------------------------------------------
add("CURSE_OF_TONGUES", "customemote", "makes {TARGET} speak in demonic.")

-- ---------------------------------------------------------------------
-- CURSE_OF_EXHAUSTION
-- ---------------------------------------------------------------------
add("CURSE_OF_EXHAUSTION", "say", "Your limbs are heavier and heavier, {TARGET}! Just give up...")

-- ---------------------------------------------------------------------
-- CURSE_OF_THE_ELEMENTS
-- ---------------------------------------------------------------------
add("CURSE_OF_THE_ELEMENTS", "say", "This is Elementary...")

-- ---------------------------------------------------------------------
-- CURSE_OF_SHADOW
-- ---------------------------------------------------------------------
add("CURSE_OF_SHADOW", "say", "Embrace the Shadow.")

-- ---------------------------------------------------------------------
-- CURSE_OF_SHADOW
-- ---------------------------------------------------------------------
add("CURSE_OF_SHADOW", "customemote", "grins wickedly at {TARGET}.")

-- ---------------------------------------------------------------------
-- CURSE_OF_DOOM
-- ---------------------------------------------------------------------
add("CURSE_OF_DOOM", "say", "I bring DOOM upon you!")

-- ---------------------------------------------------------------------
-- CURSE_OF_DOOM
-- ---------------------------------------------------------------------
add("CURSE_OF_DOOM", "emote", "WRATH")

-- ---------------------------------------------------------------------
-- CURSE_OF_DOOM
-- ---------------------------------------------------------------------
add("CURSE_OF_DOOM", "customemote", "threatens {TARGET} with the wrath of doom.")

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
-- DRAIN_LIFE
-- ---------------------------------------------------------------------
add("DRAIN_LIFE", "say", "I shall bleed you dry.")

-- ---------------------------------------------------------------------
-- DRAIN_MANA
-- ---------------------------------------------------------------------
add("DRAIN_MANA", "say", "You won't need that mana anymore.")

-- ---------------------------------------------------------------------
-- FEAR
-- ---------------------------------------------------------------------
add("FEAR", "say", "Prepare to know the true meaning of fear.")
add("FEAR", "say", "And once you know it - run.")

-- ---------------------------------------------------------------------
-- HEALTH_FUNNEL
-- ---------------------------------------------------------------------
add("HEALTH_FUNNEL", "customemote", "tends to {PP} demon's wounds.")

-- ---------------------------------------------------------------------
-- UNENDING_BREATH
-- ---------------------------------------------------------------------
add("UNENDING_BREATH", "say", "Your breath will be unending.")

-- ---------------------------------------------------------------------
-- SENSE_DEMONS
-- ---------------------------------------------------------------------
add("SENSE_DEMONS", "say", "Hmm, let's see if we have some demons nearby to enslave...")

-- ---------------------------------------------------------------------
-- RITUAL_OF_SUMMONING
-- ---------------------------------------------------------------------
add("RITUAL_OF_SUMMONING", "say", "Summoning {TARGET}.")

-- ---------------------------------------------------------------------
-- RITUAL_OF_SUMMONING
-- ---------------------------------------------------------------------
add("RITUAL_OF_SUMMONING", "customemote", "chants in Demonic as {TARGET}'s name echoes through the air.")

-- ---------------------------------------------------------------------
-- ENSLAVE_DEMON
-- ---------------------------------------------------------------------
add("ENSLAVE_DEMON", "emote", "GRIN")

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
-- SUMMON_VOIDWALKER
-- ---------------------------------------------------------------------
add("SUMMON_VOIDWALKER", "say", "Did you think I would let you rest, demon?")
add("SUMMON_VOIDWALKER", "say", "Demon! Get back to work!")
add("SUMMON_VOIDWALKER", "say", "Your labor is not even close to finished demon!")
add("SUMMON_VOIDWALKER", "say", "You cannot escape me that easily demon!")
add("SUMMON_VOIDWALKER", "say", "Weakness will not be tolerated, demon!")
add("SUMMON_VOIDWALKER", "say", "You will never know rest demon, your labor will never be done!")

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
-- IMMOLATE
-- ---------------------------------------------------------------------
add("IMMOLATE", "say", "Mind if I turn up the heat a bit, {TARGET}?")
add("IMMOLATE", "say", "Time to get a little hot under the collar, {TARGET}.")

-- ---------------------------------------------------------------------
-- SEARING_PAIN
-- ---------------------------------------------------------------------
add("SEARING_PAIN", "say", "Pain should be searing from THIS!")

-- ---------------------------------------------------------------------
-- RAIN_OF_FIRE
-- ---------------------------------------------------------------------
add("RAIN_OF_FIRE", "say", "Rain fire!")
add("RAIN_OF_FIRE", "say", "Fire from the sky!")
add("RAIN_OF_FIRE", "say", "Destruction by Fire!")

-- ---------------------------------------------------------------------
-- HELLFIRE
-- ---------------------------------------------------------------------
add("HELLFIRE", "say", "I shall set this world aflame!")

-- ---------------------------------------------------------------------
-- SOUL_FIRE
-- ---------------------------------------------------------------------
add("SOUL_FIRE", "say", "Your soul shall BURN!")
add("SOUL_FIRE", "say", "Feel the fire with your VERY SOUL!")
