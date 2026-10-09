-- RPHelper Forever - Dwarf English content
-- Adapted from the RPhelper_twow Dwarf catalogue and original RoleplayingHelper lineage.
-- Original contributor: mithyk
-- Additional adaptation and new content: Wiubiki

-- ---------------------------------------------------------------------
-- ENTER COMBAT
-- ---------------------------------------------------------------------

RPHelper.RegisterRace(RPHelper.Race.DWARF, "entercombat", { type = "say", text = "For Khaz Modan!" })
RPHelper.RegisterRace(RPHelper.Race.DWARF, "entercombat", { type = "say", text = "Feel the fury of the mountain!" })
RPHelper.RegisterRace(RPHelper.Race.DWARF, "entercombat", { type = "say", text = "To arms!" })
RPHelper.RegisterRace(RPHelper.Race.DWARF, "entercombat", { type = "say", text = "Stone remembers every blow. So do I." })
RPHelper.RegisterRace(RPHelper.Race.DWARF, "entercombat", { type = "say", text = "Let's see what you're forged of!" })
RPHelper.RegisterRace(RPHelper.Race.DWARF, "entercombat", { type = "customemote", text = "sets their feet as solidly as mountain stone." })

-- ---------------------------------------------------------------------
-- LEAVE COMBAT
-- ---------------------------------------------------------------------

RPHelper.RegisterRace(RPHelper.Race.DWARF, "leavecombat", { type = "say", text = "That tale will be worth a pint." })
RPHelper.RegisterRace(RPHelper.Race.DWARF, "leavecombat", { type = "say", text = "Still standing. Just as a dwarf should be." })
RPHelper.RegisterRace(RPHelper.Race.DWARF, "leavecombat", { type = "say", text = "Another victory for the ledgers." })
RPHelper.RegisterRace(RPHelper.Race.DWARF, "leavecombat", { type = "customemote", text = "steadies themselves and gives a satisfied nod." })

-- ---------------------------------------------------------------------
-- HURT AND ABSORB
-- ---------------------------------------------------------------------

RPHelper.RegisterRace(RPHelper.Race.DWARF, "hurt", { type = "say", text = "I've had avalanches hit softer than that!" })
RPHelper.RegisterRace(RPHelper.Race.DWARF, "hurt", { type = "say", text = "It'll take more than that to crack stone." })
RPHelper.RegisterRace(RPHelper.Race.DWARF, "hurt", { type = "customemote", text = "grunts and plants their feet more firmly." })
RPHelper.RegisterRace(RPHelper.Race.DWARF, "absorb", { type = "say", text = "Har! I've weathered worse underground." })

-- ---------------------------------------------------------------------
-- BLOCK AND PARRY
-- ---------------------------------------------------------------------

RPHelper.RegisterRace(RPHelper.Race.DWARF, "block", { type = "say", text = "Solid as the mountain!" })
RPHelper.RegisterRace(RPHelper.Race.DWARF, "parry", { type = "say", text = "A poor swing and poorer steel!" })

-- ---------------------------------------------------------------------
-- YOU CRIT
-- ---------------------------------------------------------------------

RPHelper.RegisterRace(RPHelper.Race.DWARF, "youcrit", { type = "say", text = "Now that's a proper strike!" })
RPHelper.RegisterRace(RPHelper.Race.DWARF, "youcrit", { type = "say", text = "Tempered by the mountain!" })
RPHelper.RegisterRace(RPHelper.Race.DWARF, "youcrit", { type = "customemote", text = "gives a booming laugh at the telling blow." })

-- ---------------------------------------------------------------------
-- DEATH
-- ---------------------------------------------------------------------

RPHelper.RegisterRace(RPHelper.Race.DWARF, "death", { type = "say", text = "Lay me beneath the mountain..." })
RPHelper.RegisterRace(RPHelper.Race.DWARF, "death", { type = "say", text = "Remember the clan..." })

-- ---------------------------------------------------------------------
-- RESURRECT
-- ---------------------------------------------------------------------

RPHelper.RegisterRace(RPHelper.Race.DWARF, "resurrect", { type = "say", text = "All patched up and ready for action!" })
RPHelper.RegisterRace(RPHelper.Race.DWARF, "resurrect", { type = "say", text = "I will bear this scar with pride." })
RPHelper.RegisterRace(RPHelper.Race.DWARF, "resurrect", { type = "say", text = "Thought I was done for that time." })
RPHelper.RegisterRace(RPHelper.Race.DWARF, "resurrect", { type = "customemote", text = "rises with a groan and checks their bruises." })
