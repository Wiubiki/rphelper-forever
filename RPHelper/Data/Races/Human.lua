-- RPHelper Forever - Human English content
-- Adapted from the RPhelper_twow Human catalogue and original RoleplayingHelper lineage.
-- The legacy Human source carried no named contributor attribution.
-- Additional adaptation and new content: Wiubiki

-- ---------------------------------------------------------------------
-- ENTER COMBAT
-- ---------------------------------------------------------------------

RPHelper.RegisterRace(RPHelper.Race.HUMAN, "entercombat", { type = "say", text = "Stand your ground!" })
RPHelper.RegisterRace(RPHelper.Race.HUMAN, "entercombat", { type = "say", text = "We've weathered worse than this." })
RPHelper.RegisterRace(RPHelper.Race.HUMAN, "entercombat", { type = "say", text = "For hearth and home!" })
RPHelper.RegisterRace(RPHelper.Race.HUMAN, "entercombat", { type = "say", text = "One more trial. We endure." })
RPHelper.RegisterRace(RPHelper.Race.HUMAN, "entercombat", { type = "customemote", text = "sets their shoulders with stubborn resolve." })

-- ---------------------------------------------------------------------
-- LEAVE COMBAT
-- ---------------------------------------------------------------------

RPHelper.RegisterRace(RPHelper.Race.HUMAN, "leavecombat", { type = "say", text = "Another hard-won victory." })
RPHelper.RegisterRace(RPHelper.Race.HUMAN, "leavecombat", { type = "say", text = "We live to rebuild." })
RPHelper.RegisterRace(RPHelper.Race.HUMAN, "leavecombat", { type = "say", text = "That should keep the road safe a little longer." })
RPHelper.RegisterRace(RPHelper.Race.HUMAN, "leavecombat", { type = "customemote", text = "takes a weary breath, then straightens with renewed resolve." })

-- ---------------------------------------------------------------------
-- HURT
-- ---------------------------------------------------------------------

RPHelper.RegisterRace(RPHelper.Race.HUMAN, "hurt", { type = "say", text = "I've survived worse." })
RPHelper.RegisterRace(RPHelper.Race.HUMAN, "hurt", { type = "say", text = "Not enough to stop me!" })
RPHelper.RegisterRace(RPHelper.Race.HUMAN, "hurt", { type = "customemote", text = "grits their teeth and presses on." })

-- ---------------------------------------------------------------------
-- BLOCK AND PARRY
-- ---------------------------------------------------------------------

RPHelper.RegisterRace(RPHelper.Race.HUMAN, "block", { type = "say", text = "Hold the line!" })
RPHelper.RegisterRace(RPHelper.Race.HUMAN, "parry", { type = "say", text = "I've seen that move before." })

-- ---------------------------------------------------------------------
-- YOU CRIT
-- ---------------------------------------------------------------------

RPHelper.RegisterRace(RPHelper.Race.HUMAN, "youcrit", { type = "say", text = "Right where it mattered." })
RPHelper.RegisterRace(RPHelper.Race.HUMAN, "youcrit", { type = "say", text = "Training and timing." })
RPHelper.RegisterRace(RPHelper.Race.HUMAN, "youcrit", { type = "customemote", text = "seizes the opening with practiced determination." })

-- ---------------------------------------------------------------------
-- DEATH
-- ---------------------------------------------------------------------

RPHelper.RegisterRace(RPHelper.Race.HUMAN, "death", { type = "say", text = "Tell them... I held the line..." })
RPHelper.RegisterRace(RPHelper.Race.HUMAN, "death", { type = "say", text = "Remember me... at home..." })

-- ---------------------------------------------------------------------
-- RESURRECT
-- ---------------------------------------------------------------------

RPHelper.RegisterRace(RPHelper.Race.HUMAN, "resurrect", { type = "say", text = "Still standing. That will have to do." })
RPHelper.RegisterRace(RPHelper.Race.HUMAN, "resurrect", { type = "say", text = "Back to work, then." })
RPHelper.RegisterRace(RPHelper.Race.HUMAN, "resurrect", { type = "say", text = "A second chance. I won't waste it." })
RPHelper.RegisterRace(RPHelper.Race.HUMAN, "resurrect", { type = "customemote", text = "steadies themselves and gathers the will to carry on." })
