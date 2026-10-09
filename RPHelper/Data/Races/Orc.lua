-- RPHelper Forever - Orc English content
-- Adapted from the RPhelper_twow Orc catalogue and original RoleplayingHelper lineage.
-- Original contributor: mithyk
-- Additional adaptation and new content: Wiubiki

-- ---------------------------------------------------------------------
-- ENTER COMBAT
-- ---------------------------------------------------------------------

RPHelper.RegisterRace(RPHelper.Race.ORC, "entercombat", { type = "say", text = "Strength and honor!" })
RPHelper.RegisterRace(RPHelper.Race.ORC, "entercombat", { type = "say", text = "Remember Durotan!" })
RPHelper.RegisterRace(RPHelper.Race.ORC, "entercombat", { type = "say", text = "For the honor of the clans!" })
RPHelper.RegisterRace(RPHelper.Race.ORC, "entercombat", { type = "say", text = "Let battle prove our strength!" })
RPHelper.RegisterRace(RPHelper.Race.ORC, "entercombat", { type = "say", text = "Meet me with honor, {TARGET}." })
RPHelper.RegisterRace(RPHelper.Race.ORC, "entercombat", { type = "customemote", text = "bares their tusks and gives a low, challenging growl." })
RPHelper.RegisterRace(RPHelper.Race.ORC, "entercombat", { type = "emote", text = "ROAR" })

-- ---------------------------------------------------------------------
-- LEAVE COMBAT
-- ---------------------------------------------------------------------

RPHelper.RegisterRace(RPHelper.Race.ORC, "leavecombat", { type = "say", text = "A worthy struggle." })
RPHelper.RegisterRace(RPHelper.Race.ORC, "leavecombat", { type = "say", text = "Victory belongs to the strong." })
RPHelper.RegisterRace(RPHelper.Race.ORC, "leavecombat", { type = "say", text = "The clan will hear of this victory." })
RPHelper.RegisterRace(RPHelper.Race.ORC, "leavecombat", { type = "customemote", text = "draws a steadying breath and surveys the defeated." })

-- ---------------------------------------------------------------------
-- HURT
-- ---------------------------------------------------------------------

RPHelper.RegisterRace(RPHelper.Race.ORC, "hurt", { type = "say", text = "Is that all?" })
RPHelper.RegisterRace(RPHelper.Race.ORC, "hurt", { type = "say", text = "Pain is a hard teacher." })
RPHelper.RegisterRace(RPHelper.Race.ORC, "hurt", { type = "say", text = "You will need more than that to break me!" })
RPHelper.RegisterRace(RPHelper.Race.ORC, "hurt", { type = "customemote", text = "answers the wound with a defiant snarl." })

-- ---------------------------------------------------------------------
-- YOU CRIT
-- ---------------------------------------------------------------------

RPHelper.RegisterRace(RPHelper.Race.ORC, "youcrit", { type = "say", text = "You are outmatched." })
RPHelper.RegisterRace(RPHelper.Race.ORC, "youcrit", { type = "say", text = "Stand firm and face me!" })
RPHelper.RegisterRace(RPHelper.Race.ORC, "youcrit", { type = "say", text = "Strength decides this battle." })
RPHelper.RegisterRace(RPHelper.Race.ORC, "youcrit", { type = "customemote", text = "grins fiercely as the attack lands true." })

-- ---------------------------------------------------------------------
-- DEATH
-- ---------------------------------------------------------------------

RPHelper.RegisterRace(RPHelper.Race.ORC, "death", { type = "say", text = "I fall... with honor..." })
RPHelper.RegisterRace(RPHelper.Race.ORC, "death", { type = "say", text = "Let the ancestors remember me..." })

-- ---------------------------------------------------------------------
-- RESURRECT
-- ---------------------------------------------------------------------

RPHelper.RegisterRace(RPHelper.Race.ORC, "resurrect", { type = "say", text = "I return stronger than before." })
RPHelper.RegisterRace(RPHelper.Race.ORC, "resurrect", { type = "say", text = "That will make a fine scar." })
RPHelper.RegisterRace(RPHelper.Race.ORC, "resurrect", { type = "say", text = "The ancestors are not finished with me." })
RPHelper.RegisterRace(RPHelper.Race.ORC, "resurrect", { type = "customemote", text = "rises with a growl and tests their footing." })
