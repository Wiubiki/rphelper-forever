-- RPHelper Forever - Rogue ability content
-- Corpus migration from the RPhelper_twow Rogue catalogue and original RoleplayingHelper lineage.
-- Original contributors: mithyk, crashinbrn

local A = RPHelper.Ability.ROGUE
local C = RPHelper.Class.ROGUE
local function add(id, ability, entryType, text)
    A[ability] = A[ability] or ability
    RPHelper.RegisterAbility(C, A[ability], { id = id, type = entryType, text = text })
end

-- =====================================================================
-- Assassination
-- =====================================================================

-- ---------------------------------------------------------------------
-- AMBUSH
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "AMBUSH")

-- add("AMBUSH", "say", "")
-- add("AMBUSH", "emote", "")
-- add("AMBUSH", "customemote", "")

-- ---------------------------------------------------------------------
-- CHEAP_SHOT
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "CHEAP_SHOT")

-- add("CHEAP_SHOT", "say", "")
-- add("CHEAP_SHOT", "emote", "")
-- add("CHEAP_SHOT", "customemote", "")

-- ---------------------------------------------------------------------
-- COLD_BLOOD
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "COLD_BLOOD")

-- add("COLD_BLOOD", "say", "")
-- add("COLD_BLOOD", "emote", "")
-- add("COLD_BLOOD", "customemote", "")

-- ---------------------------------------------------------------------
-- EVISCERATE
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "EVISCERATE")

-- add("EVISCERATE", "say", "")
-- add("EVISCERATE", "emote", "")
-- add("EVISCERATE", "customemote", "")

-- ---------------------------------------------------------------------
-- EXPOSE_ARMOR
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "EXPOSE_ARMOR")

-- add("EXPOSE_ARMOR", "say", "")
-- add("EXPOSE_ARMOR", "emote", "")
-- add("EXPOSE_ARMOR", "customemote", "")

-- ---------------------------------------------------------------------
-- GARROTE
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "GARROTE")

-- add("GARROTE", "say", "")
-- add("GARROTE", "emote", "")
-- add("GARROTE", "customemote", "")

-- ---------------------------------------------------------------------
-- KIDNEY_SHOT
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "KIDNEY_SHOT")

-- add("KIDNEY_SHOT", "say", "")
-- add("KIDNEY_SHOT", "emote", "")
-- add("KIDNEY_SHOT", "customemote", "")

-- ---------------------------------------------------------------------
-- MUTILATE
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "MUTILATE")

-- add("MUTILATE", "say", "")
-- add("MUTILATE", "emote", "")
-- add("MUTILATE", "customemote", "")

-- ---------------------------------------------------------------------
-- RUPTURE
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "RUPTURE")

-- add("RUPTURE", "say", "")
-- add("RUPTURE", "emote", "")
-- add("RUPTURE", "customemote", "")

-- ---------------------------------------------------------------------
-- SLICE_AND_DICE
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "SLICE_AND_DICE")

-- add("SLICE_AND_DICE", "say", "")
-- add("SLICE_AND_DICE", "emote", "")
-- add("SLICE_AND_DICE", "customemote", "")

-- ---------------------------------------------------------------------
-- VENOM
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "VENOM")

-- add("VENOM", "say", "")
-- add("VENOM", "emote", "")
-- add("VENOM", "customemote", "")

-- =====================================================================
-- Combat
-- =====================================================================

-- ---------------------------------------------------------------------
-- ADRENALINE_RUSH
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "ADRENALINE_RUSH")

-- add("ADRENALINE_RUSH", "say", "")
-- add("ADRENALINE_RUSH", "emote", "")
-- add("ADRENALINE_RUSH", "customemote", "")

-- ---------------------------------------------------------------------
-- BACKSTAB
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "BACKSTAB")

-- add("BACKSTAB", "say", "")
-- add("BACKSTAB", "emote", "")
-- add("BACKSTAB", "customemote", "")

-- ---------------------------------------------------------------------
-- BLADE_FLURRY
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "BLADE_FLURRY")

-- add("BLADE_FLURRY", "say", "")
-- add("BLADE_FLURRY", "emote", "")
-- add("BLADE_FLURRY", "customemote", "")

-- ---------------------------------------------------------------------
-- EVASION
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "EVASION")

-- add("EVASION", "say", "")
-- add("EVASION", "emote", "")
-- add("EVASION", "customemote", "")

-- ---------------------------------------------------------------------
-- FEINT
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "FEINT")

-- add("FEINT", "say", "")
-- add("FEINT", "emote", "")
-- add("FEINT", "customemote", "")

-- ---------------------------------------------------------------------
-- GOUGE
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "GOUGE")

-- add("GOUGE", "say", "")
-- add("GOUGE", "emote", "")
-- add("GOUGE", "customemote", "")

-- ---------------------------------------------------------------------
-- KICK
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "KICK")

-- add("KICK", "say", "")
-- add("KICK", "emote", "")
-- add("KICK", "customemote", "")

-- ---------------------------------------------------------------------
-- RIPOSTE
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "RIPOSTE")

-- add("RIPOSTE", "say", "")
-- add("RIPOSTE", "emote", "")
-- add("RIPOSTE", "customemote", "")

-- ---------------------------------------------------------------------
-- SINISTER_STRIKE
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "SINISTER_STRIKE")

-- add("SINISTER_STRIKE", "say", "")
-- add("SINISTER_STRIKE", "emote", "")
-- add("SINISTER_STRIKE", "customemote", "")

-- ---------------------------------------------------------------------
-- SPRINT
-- ---------------------------------------------------------------------
add("default:ability:rogue:0002", "SPRINT", "say", "I better RUN!")

-- =====================================================================
-- Subtlety
-- =====================================================================

-- ---------------------------------------------------------------------
-- BLIND
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "BLIND")

-- add("BLIND", "say", "")
-- add("BLIND", "emote", "")
-- add("BLIND", "customemote", "")

-- ---------------------------------------------------------------------
-- DISARM_TRAP
-- ---------------------------------------------------------------------
add("default:ability:rogue:0003", "DISARM_TRAP", "say", "You call this a trap?")

-- ---------------------------------------------------------------------
-- DISTRACT
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "DISTRACT")

-- add("DISTRACT", "say", "")
-- add("DISTRACT", "emote", "")
-- add("DISTRACT", "customemote", "")

-- ---------------------------------------------------------------------
-- GHOSTLY_STRIKE
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "GHOSTLY_STRIKE")

-- add("GHOSTLY_STRIKE", "say", "")
-- add("GHOSTLY_STRIKE", "emote", "")
-- add("GHOSTLY_STRIKE", "customemote", "")

-- ---------------------------------------------------------------------
-- HEMORRHAGE
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "HEMORRHAGE")

-- add("HEMORRHAGE", "say", "")
-- add("HEMORRHAGE", "emote", "")
-- add("HEMORRHAGE", "customemote", "")

-- ---------------------------------------------------------------------
-- PICK_POCKET
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "PICK_POCKET")

-- add("PICK_POCKET", "say", "")
-- add("PICK_POCKET", "emote", "")
-- add("PICK_POCKET", "customemote", "")

-- ---------------------------------------------------------------------
-- PREMEDITATION
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "PREMEDITATION")

-- add("PREMEDITATION", "say", "")
-- add("PREMEDITATION", "emote", "")
-- add("PREMEDITATION", "customemote", "")

-- ---------------------------------------------------------------------
-- PREPARATION
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "PREPARATION")

-- add("PREPARATION", "say", "")
-- add("PREPARATION", "emote", "")
-- add("PREPARATION", "customemote", "")

-- ---------------------------------------------------------------------
-- SAP
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "SAP")

-- add("SAP", "say", "")
-- add("SAP", "emote", "")
-- add("SAP", "customemote", "")

-- ---------------------------------------------------------------------
-- STEALTH
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "STEALTH")

-- add("STEALTH", "say", "")
-- add("STEALTH", "emote", "")
-- add("STEALTH", "customemote", "")

-- ---------------------------------------------------------------------
-- VANISH
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "VANISH")

-- add("VANISH", "say", "")
-- add("VANISH", "emote", "")
-- add("VANISH", "customemote", "")

-- =====================================================================
-- Poisons
-- =====================================================================

-- ---------------------------------------------------------------------
-- BLINDING_POWDER
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "BLINDING_POWDER")

-- add("BLINDING_POWDER", "say", "")
-- add("BLINDING_POWDER", "emote", "")
-- add("BLINDING_POWDER", "customemote", "")

-- ---------------------------------------------------------------------
-- CRIPPLING_POISON
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "CRIPPLING_POISON")

-- add("CRIPPLING_POISON", "say", "")
-- add("CRIPPLING_POISON", "emote", "")
-- add("CRIPPLING_POISON", "customemote", "")

-- ---------------------------------------------------------------------
-- DEADLY_POISON
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "DEADLY_POISON")

-- add("DEADLY_POISON", "say", "")
-- add("DEADLY_POISON", "emote", "")
-- add("DEADLY_POISON", "customemote", "")

-- ---------------------------------------------------------------------
-- INSTANT_POISON
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "INSTANT_POISON")

-- add("INSTANT_POISON", "say", "")
-- add("INSTANT_POISON", "emote", "")
-- add("INSTANT_POISON", "customemote", "")

-- ---------------------------------------------------------------------
-- MIND_NUMBING_POISON
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "MIND_NUMBING_POISON")

-- add("MIND_NUMBING_POISON", "say", "")
-- add("MIND_NUMBING_POISON", "emote", "")
-- add("MIND_NUMBING_POISON", "customemote", "")

-- ---------------------------------------------------------------------
-- WOUND_POISON
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "WOUND_POISON")

-- add("WOUND_POISON", "say", "")
-- add("WOUND_POISON", "emote", "")
-- add("WOUND_POISON", "customemote", "")
