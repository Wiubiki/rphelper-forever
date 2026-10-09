-- RPHelper Forever - Rogue ability content
-- Corpus migration from the RPhelper_twow Rogue catalogue and original RoleplayingHelper lineage.
-- Original contributors: mithyk, crashinbrn

local A = RPHelper.Ability.ROGUE
local C = RPHelper.Class.ROGUE
local function add(ability, entryType, text)
    A[ability] = A[ability] or ability
    RPHelper.RegisterAbility(C, A[ability], { type = entryType, text = text })
end

-- ---------------------------------------------------------------------
-- SPRINT
-- ---------------------------------------------------------------------
add("SPRINT", "say", "I better RUN!")

-- ---------------------------------------------------------------------
-- DISARM_TRAP
-- ---------------------------------------------------------------------
add("DISARM_TRAP", "say", "You call this a trap?")

-- ---------------------------------------------------------------------
-- SHOOT_BOW
-- ---------------------------------------------------------------------
add("SHOOT_BOW", "customemote", "aims for the knee.")

-- ---------------------------------------------------------------------
-- THROW
-- ---------------------------------------------------------------------
add("THROW", "customemote", "throws a dagger to get {TARGET}'s attention.")

