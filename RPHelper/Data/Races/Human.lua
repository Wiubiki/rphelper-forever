-- RPHelper Forever - Human English content
-- Adapted from the RPhelper_twow Human catalogue and original RoleplayingHelper lineage.
-- The legacy Human source carried no named contributor attribution.
-- Additional adaptation and new content: Wiubiki

-- ---------------------------------------------------------------------
-- ENTER COMBAT
-- ---------------------------------------------------------------------

RPHelper.RegisterRace(RPHelper.Race.HUMAN, "entercombat", { id = "default:race:human:0001", type = "say", text = "Stand your ground!" })
RPHelper.RegisterRace(RPHelper.Race.HUMAN, "entercombat", { id = "default:race:human:0002", type = "say", text = "We've weathered worse than this." })
RPHelper.RegisterRace(RPHelper.Race.HUMAN, "entercombat", { id = "default:race:human:0003", type = "say", text = "For hearth and home!" })
RPHelper.RegisterRace(RPHelper.Race.HUMAN, "entercombat", { id = "default:race:human:0004", type = "say", text = "One more trial. We endure." })
RPHelper.RegisterRace(RPHelper.Race.HUMAN, "entercombat", { id = "default:race:human:0005", type = "customemote", text = "sets their shoulders with stubborn resolve." })

-- ---------------------------------------------------------------------
-- LEAVE COMBAT
-- ---------------------------------------------------------------------

RPHelper.RegisterRace(RPHelper.Race.HUMAN, "leavecombat", { id = "default:race:human:0006", type = "say", text = "Another hard-won victory." })
RPHelper.RegisterRace(RPHelper.Race.HUMAN, "leavecombat", { id = "default:race:human:0007", type = "say", text = "We live to rebuild." })
RPHelper.RegisterRace(RPHelper.Race.HUMAN, "leavecombat", { id = "default:race:human:0008", type = "say", text = "That should keep the road safe a little longer." })
RPHelper.RegisterRace(RPHelper.Race.HUMAN, "leavecombat", { id = "default:race:human:0009", type = "customemote", text = "takes a weary breath, then straightens with renewed resolve." })

-- ---------------------------------------------------------------------
-- HURT
-- ---------------------------------------------------------------------

RPHelper.RegisterRace(RPHelper.Race.HUMAN, "hurt", { id = "default:race:human:0010", type = "say", text = "I've survived worse." })
RPHelper.RegisterRace(RPHelper.Race.HUMAN, "hurt", { id = "default:race:human:0011", type = "say", text = "Not enough to stop me!" })
RPHelper.RegisterRace(RPHelper.Race.HUMAN, "hurt", { id = "default:race:human:0012", type = "customemote", text = "grits their teeth and presses on." })

-- ---------------------------------------------------------------------
-- BLOCK AND PARRY
-- ---------------------------------------------------------------------

RPHelper.RegisterRace(RPHelper.Race.HUMAN, "block", { id = "default:race:human:0013", type = "say", text = "Hold the line!" })
RPHelper.RegisterRace(RPHelper.Race.HUMAN, "parry", { id = "default:race:human:0014", type = "say", text = "I've seen that move before." })

-- ---------------------------------------------------------------------
-- YOU CRIT
-- ---------------------------------------------------------------------

RPHelper.RegisterRace(RPHelper.Race.HUMAN, "youcrit", { id = "default:race:human:0015", type = "say", text = "Right where it mattered." })
RPHelper.RegisterRace(RPHelper.Race.HUMAN, "youcrit", { id = "default:race:human:0016", type = "say", text = "Training and timing." })
RPHelper.RegisterRace(RPHelper.Race.HUMAN, "youcrit", { id = "default:race:human:0017", type = "customemote", text = "seizes the opening with practiced determination." })

-- ---------------------------------------------------------------------
-- DEATH
-- ---------------------------------------------------------------------

RPHelper.RegisterRace(RPHelper.Race.HUMAN, "death", { id = "default:race:human:0018", type = "say", text = "Tell them... I held the line..." })
RPHelper.RegisterRace(RPHelper.Race.HUMAN, "death", { id = "default:race:human:0019", type = "say", text = "Remember me... at home..." })

-- ---------------------------------------------------------------------
-- RESURRECT
-- ---------------------------------------------------------------------

RPHelper.RegisterRace(RPHelper.Race.HUMAN, "resurrect", { id = "default:race:human:0020", type = "say", text = "Still standing. That will have to do." })
RPHelper.RegisterRace(RPHelper.Race.HUMAN, "resurrect", { id = "default:race:human:0021", type = "say", text = "Back to work, then." })
RPHelper.RegisterRace(RPHelper.Race.HUMAN, "resurrect", { id = "default:race:human:0022", type = "say", text = "A second chance. I won't waste it." })
RPHelper.RegisterRace(RPHelper.Race.HUMAN, "resurrect", { id = "default:race:human:0023", type = "customemote", text = "steadies themselves and gathers the will to carry on." })
