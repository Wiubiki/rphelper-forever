-- RPHelper Forever - Druid English content
-- Corpus migration from the RPhelper_twow Druid catalogue and original RoleplayingHelper lineage.
-- The legacy Druid source carried no named contributor attribution.

local C = RPHelper.Class.DRUID
local function add(trigger, entryType, text)
    RPHelper.RegisterClass(C, trigger, { type = entryType, text = text })
end

-- ---------------------------------------------------------------------
-- ENTERCOMBAT
-- ---------------------------------------------------------------------
add("entercombat", "say", "I will destroy those who disrupt nature.")
add("entercombat", "say", "I sense darkness in the dream.")
add("entercombat", "say", "For nature's survival!")
add("entercombat", "say", "The grass beneath your feet screams, I answer!")

-- ---------------------------------------------------------------------
-- ENTERCOMBAT
-- ---------------------------------------------------------------------
add("entercombat", "emote", "CHARGE")
add("entercombat", "emote", "ROAR")
