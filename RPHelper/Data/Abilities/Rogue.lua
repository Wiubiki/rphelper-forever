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


-- Historical ability definitions are independent of authored reactions.
-- Forever availability and automatic detection remain separately audited.
for _, ability in ipairs({
    "ADRENALINE_RUSH",
    "AGITATING_POISON",
    "AMBUSH",
    "BACKSTAB",
    "BLADE_FURY",
    "BLIND",
    "BLINDING_POWDER",
    "CHEAP_SHOT",
    "COLD_BLOOD",
    "CRIPPLING_POISON",
    "DEADLY_POISON",
    "DEADLY_THROW",
    "DETECT_TRAPS",
    "DISTRACT",
    "EVASION",
    "EVISCERATE",
    "EXPLOIT_WEAKNESS",
    "EXPOSE_ARMOR",
    "FEINT",
    "FLOURISH",
    "GARROTE",
    "GHOSTLY_STRIKE",
    "GOUGE",
    "HEMORRHAGE",
    "INSTANT_POISON",
    "KICK",
    "KIDNEY_SHOT",
    "MIND_NUMBING_POISON",
    "PICK_LOCK",
    "PICK_POCKET",
    "PREMEDITATION",
    "PREPARATION",
    "RELENTLESS_STRIKES",
    "RIPOSTE",
    "RUPTURE",
    "SAFE_FALL",
    "SAP",
    "SHOOT_CROSSBOW",
    "SHOOT_GUN",
    "SINISTER_STRIKE",
    "SLICE_AND_DICE",
    "STEALTH",
    "SURPRISE_ATTACK",
    "VANISH",
    "WOUND_POISON",
}) do
    RPHelper.RegisterAbility(C, ability)
end
