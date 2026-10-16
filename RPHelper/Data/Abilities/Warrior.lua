-- RPHelper Forever - Warrior ability content
-- Corpus migration from the RPhelper_twow Warrior catalogue and original RoleplayingHelper lineage.
-- The legacy Warrior source carried no named contributor attribution.

local A = RPHelper.Ability.WARRIOR
local C = RPHelper.Class.WARRIOR
local function add(ability, entryType, text)
    A[ability] = A[ability] or ability
    RPHelper.RegisterAbility(C, A[ability], { type = entryType, text = text })
end

-- =====================================================================
-- Arms
-- =====================================================================

-- ---------------------------------------------------------------------
-- BATTLE_STANCE
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "BATTLE_STANCE")

-- add("BATTLE_STANCE", "say", "")
-- add("BATTLE_STANCE", "emote", "")
-- add("BATTLE_STANCE", "customemote", "")

-- ---------------------------------------------------------------------
-- CHARGE
-- ---------------------------------------------------------------------
add("CHARGE", "emote", "CHARGE")
add("CHARGE", "customemote", "yells {PP} head off as {SP} runs into battle.")
add("CHARGE", "customemote", "charges at {TARGET}.")
add("CHARGE", "customemote", "screams a battle cry and charges into combat.")

-- ---------------------------------------------------------------------
-- HAMSTRING
-- ---------------------------------------------------------------------
add("HAMSTRING", "customemote", "hacks at {TARGET}'s hamstring.")

-- ---------------------------------------------------------------------
-- HEROIC_STRIKE
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "HEROIC_STRIKE")

-- add("HEROIC_STRIKE", "say", "")
-- add("HEROIC_STRIKE", "emote", "")
-- add("HEROIC_STRIKE", "customemote", "")

-- ---------------------------------------------------------------------
-- MOCKING_BLOW
-- ---------------------------------------------------------------------
add("MOCKING_BLOW", "say", "Over here! {RINSULT}")

-- ---------------------------------------------------------------------
-- MORTAL_STRIKE
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "MORTAL_STRIKE")

-- add("MORTAL_STRIKE", "say", "")
-- add("MORTAL_STRIKE", "emote", "")
-- add("MORTAL_STRIKE", "customemote", "")

-- ---------------------------------------------------------------------
-- OVERPOWER
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "OVERPOWER")

-- add("OVERPOWER", "say", "")
-- add("OVERPOWER", "emote", "")
-- add("OVERPOWER", "customemote", "")

-- ---------------------------------------------------------------------
-- REND
-- ---------------------------------------------------------------------
add("REND", "say", "Bleed for me, {TARGET}.")

-- ---------------------------------------------------------------------
-- RETALIATION
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "RETALIATION")

-- add("RETALIATION", "say", "")
-- add("RETALIATION", "emote", "")
-- add("RETALIATION", "customemote", "")

-- ---------------------------------------------------------------------
-- SPEARING_STRIKE
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "SPEARING_STRIKE")

-- add("SPEARING_STRIKE", "say", "")
-- add("SPEARING_STRIKE", "emote", "")
-- add("SPEARING_STRIKE", "customemote", "")

-- ---------------------------------------------------------------------
-- SWEEPING_STRIKES
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "SWEEPING_STRIKES")

-- add("SWEEPING_STRIKES", "say", "")
-- add("SWEEPING_STRIKES", "emote", "")
-- add("SWEEPING_STRIKES", "customemote", "")

-- ---------------------------------------------------------------------
-- THUNDER_CLAP
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "THUNDER_CLAP")

-- add("THUNDER_CLAP", "say", "")
-- add("THUNDER_CLAP", "emote", "")
-- add("THUNDER_CLAP", "customemote", "")

-- ---------------------------------------------------------------------
-- VICTORY_RUSH
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "VICTORY_RUSH")

-- add("VICTORY_RUSH", "say", "")
-- add("VICTORY_RUSH", "emote", "")
-- add("VICTORY_RUSH", "customemote", "")

-- =====================================================================
-- Fury
-- =====================================================================

-- ---------------------------------------------------------------------
-- BATTLE_SHOUT
-- ---------------------------------------------------------------------
add("BATTLE_SHOUT", "emote", "ROAR")

-- ---------------------------------------------------------------------
-- BERSERKER_RAGE
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "BERSERKER_RAGE")

-- add("BERSERKER_RAGE", "say", "")
-- add("BERSERKER_RAGE", "emote", "")
-- add("BERSERKER_RAGE", "customemote", "")

-- ---------------------------------------------------------------------
-- BERSERKER_STANCE
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "BERSERKER_STANCE")

-- add("BERSERKER_STANCE", "say", "")
-- add("BERSERKER_STANCE", "emote", "")
-- add("BERSERKER_STANCE", "customemote", "")

-- ---------------------------------------------------------------------
-- BLOODTHIRST
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "BLOODTHIRST")

-- add("BLOODTHIRST", "say", "")
-- add("BLOODTHIRST", "emote", "")
-- add("BLOODTHIRST", "customemote", "")

-- ---------------------------------------------------------------------
-- CHALLENGING_SHOUT
-- ---------------------------------------------------------------------
add("CHALLENGING_SHOUT", "say", "Attack me you bastards!")

-- ---------------------------------------------------------------------
-- CLEAVE
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "CLEAVE")

-- add("CLEAVE", "say", "")
-- add("CLEAVE", "emote", "")
-- add("CLEAVE", "customemote", "")

-- ---------------------------------------------------------------------
-- DEATH_WISH
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "DEATH_WISH")

-- add("DEATH_WISH", "say", "")
-- add("DEATH_WISH", "emote", "")
-- add("DEATH_WISH", "customemote", "")

-- ---------------------------------------------------------------------
-- DEMORALIZING_SHOUT
-- ---------------------------------------------------------------------
add("DEMORALIZING_SHOUT", "emote", "ROAR")

-- ---------------------------------------------------------------------
-- EXECUTE
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "EXECUTE")

-- add("EXECUTE", "say", "")
-- add("EXECUTE", "emote", "")
-- add("EXECUTE", "customemote", "")

-- ---------------------------------------------------------------------
-- INTERCEPT
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "INTERCEPT")

-- add("INTERCEPT", "say", "")
-- add("INTERCEPT", "emote", "")
-- add("INTERCEPT", "customemote", "")

-- ---------------------------------------------------------------------
-- INTIMIDATING_SHOUT
-- ---------------------------------------------------------------------
add("INTIMIDATING_SHOUT", "say", "Go away!")
add("INTIMIDATING_SHOUT", "say", "Fear me!")
add("INTIMIDATING_SHOUT", "say", "Run you bastards!")

-- ---------------------------------------------------------------------
-- PIERCING_HOWL
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "PIERCING_HOWL")

-- add("PIERCING_HOWL", "say", "")
-- add("PIERCING_HOWL", "emote", "")
-- add("PIERCING_HOWL", "customemote", "")

-- ---------------------------------------------------------------------
-- PUMMEL
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "PUMMEL")

-- add("PUMMEL", "say", "")
-- add("PUMMEL", "emote", "")
-- add("PUMMEL", "customemote", "")

-- ---------------------------------------------------------------------
-- RECKLESSNESS
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "RECKLESSNESS")

-- add("RECKLESSNESS", "say", "")
-- add("RECKLESSNESS", "emote", "")
-- add("RECKLESSNESS", "customemote", "")

-- ---------------------------------------------------------------------
-- SLAM
-- ---------------------------------------------------------------------
add("SLAM", "emote", "HI")

-- ---------------------------------------------------------------------
-- WHIRLWIND
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "WHIRLWIND")

-- add("WHIRLWIND", "say", "")
-- add("WHIRLWIND", "emote", "")
-- add("WHIRLWIND", "customemote", "")

-- =====================================================================
-- Protection
-- =====================================================================

-- ---------------------------------------------------------------------
-- BLOODRAGE
-- ---------------------------------------------------------------------
add("BLOODRAGE", "emote", "ROAR")
add("BLOODRAGE", "emote", "SNARL")
add("BLOODRAGE", "customemote", "looks like {SP}'s getting angry.")
add("BLOODRAGE", "customemote", "is going into a rage.")
add("BLOODRAGE", "customemote", "goes into a furious rage.")

-- ---------------------------------------------------------------------
-- CONCUSSION_BLOW
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "CONCUSSION_BLOW")

-- add("CONCUSSION_BLOW", "say", "")
-- add("CONCUSSION_BLOW", "emote", "")
-- add("CONCUSSION_BLOW", "customemote", "")

-- ---------------------------------------------------------------------
-- DEFENSIVE_STANCE
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "DEFENSIVE_STANCE")

-- add("DEFENSIVE_STANCE", "say", "")
-- add("DEFENSIVE_STANCE", "emote", "")
-- add("DEFENSIVE_STANCE", "customemote", "")

-- ---------------------------------------------------------------------
-- DISARM
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "DISARM")

-- add("DISARM", "say", "")
-- add("DISARM", "emote", "")
-- add("DISARM", "customemote", "")

-- ---------------------------------------------------------------------
-- LAST_STAND
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "LAST_STAND")

-- add("LAST_STAND", "say", "")
-- add("LAST_STAND", "emote", "")
-- add("LAST_STAND", "customemote", "")

-- ---------------------------------------------------------------------
-- REVENGE
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "REVENGE")

-- add("REVENGE", "say", "")
-- add("REVENGE", "emote", "")
-- add("REVENGE", "customemote", "")

-- ---------------------------------------------------------------------
-- SHIELD_BASH
-- ---------------------------------------------------------------------
add("SHIELD_BASH", "customemote", "bashes {PP} shield into {TARGET}'s face.")

-- ---------------------------------------------------------------------
-- SHIELD_BLOCK
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "SHIELD_BLOCK")

-- add("SHIELD_BLOCK", "say", "")
-- add("SHIELD_BLOCK", "emote", "")
-- add("SHIELD_BLOCK", "customemote", "")

-- ---------------------------------------------------------------------
-- SHIELD_SLAM
-- ---------------------------------------------------------------------
add("SHIELD_SLAM", "customemote", "slams {PP} shield into {TARGET}'s face.")

-- ---------------------------------------------------------------------
-- SHIELD_WALL
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "SHIELD_WALL")

-- add("SHIELD_WALL", "say", "")
-- add("SHIELD_WALL", "emote", "")
-- add("SHIELD_WALL", "customemote", "")

-- ---------------------------------------------------------------------
-- SUNDER_ARMOR
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "SUNDER_ARMOR")

-- add("SUNDER_ARMOR", "say", "")
-- add("SUNDER_ARMOR", "emote", "")
-- add("SUNDER_ARMOR", "customemote", "")

-- ---------------------------------------------------------------------
-- TAUNT
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "TAUNT")

-- add("TAUNT", "say", "")
-- add("TAUNT", "emote", "")
-- add("TAUNT", "customemote", "")
