-- RPHelper Forever - Warrior ability content
-- Corpus migration from the RPhelper_twow Warrior catalogue and original RoleplayingHelper lineage.
-- The legacy Warrior source carried no named contributor attribution.

local A = RPHelper.Ability.WARRIOR
local C = RPHelper.Class.WARRIOR
local function add(ability, entryType, text)
    A[ability] = A[ability] or ability
    RPHelper.RegisterAbility(C, A[ability], { type = entryType, text = text })
end

-- ---------------------------------------------------------------------
-- CHARGE
-- ---------------------------------------------------------------------
add("CHARGE", "emote", "CHARGE")

-- ---------------------------------------------------------------------
-- CHARGE
-- ---------------------------------------------------------------------
add("CHARGE", "customemote", "yells {PP} head off as {SP} runs into battle.")
add("CHARGE", "customemote", "charges at {TARGET}.")
add("CHARGE", "customemote", "screams a battle cry and charges into combat.")

-- ---------------------------------------------------------------------
-- REND
-- ---------------------------------------------------------------------
add("REND", "say", "Bleed for me, {TARGET}.")

-- ---------------------------------------------------------------------
-- HAMSTRING
-- ---------------------------------------------------------------------
add("HAMSTRING", "customemote", "hacks at {TARGET}'s hamstring.")

-- ---------------------------------------------------------------------
-- MOCKING_BLOW
-- ---------------------------------------------------------------------
add("MOCKING_BLOW", "say", "Over here! {RINSULT}")

-- ---------------------------------------------------------------------
-- BATTLE_SHOUT
-- ---------------------------------------------------------------------
add("BATTLE_SHOUT", "emote", "ROAR")

-- ---------------------------------------------------------------------
-- DEMORALIZING_SHOUT
-- ---------------------------------------------------------------------
add("DEMORALIZING_SHOUT", "emote", "ROAR")

-- ---------------------------------------------------------------------
-- INTIMIDATING_SHOUT
-- ---------------------------------------------------------------------
add("INTIMIDATING_SHOUT", "say", "Go away!")
add("INTIMIDATING_SHOUT", "say", "Fear me!")
add("INTIMIDATING_SHOUT", "say", "Run you bastards!")

-- ---------------------------------------------------------------------
-- CHALLENGING_SHOUT
-- ---------------------------------------------------------------------
add("CHALLENGING_SHOUT", "say", "Attack me you bastards!")

-- ---------------------------------------------------------------------
-- SLAM
-- ---------------------------------------------------------------------
add("SLAM", "emote", "HI")

-- ---------------------------------------------------------------------
-- BLOODRAGE
-- ---------------------------------------------------------------------
add("BLOODRAGE", "emote", "ROAR")
add("BLOODRAGE", "emote", "SNARL")

-- ---------------------------------------------------------------------
-- BLOODRAGE
-- ---------------------------------------------------------------------
add("BLOODRAGE", "customemote", "looks like {SP}'s getting angry.")
add("BLOODRAGE", "customemote", "is going into a rage.")
add("BLOODRAGE", "customemote", "goes into a furious rage.")

-- ---------------------------------------------------------------------
-- SHIELD_BASH
-- ---------------------------------------------------------------------
add("SHIELD_BASH", "customemote", "bashes {PP} shield into {TARGET}'s face.")

-- ---------------------------------------------------------------------
-- SHIELD_SLAM
-- ---------------------------------------------------------------------
add("SHIELD_SLAM", "customemote", "slams {PP} shield into {TARGET}'s face.")
