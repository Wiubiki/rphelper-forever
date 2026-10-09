-- RPHelper Forever - Gnome English content
-- Adapted from the RPhelper_twow Gnome catalogue and original RoleplayingHelper lineage.
-- Original contributors: mithyk, Syrsa
-- Additional adaptation and new content: Wiubiki

-- ---------------------------------------------------------------------
-- ENTER COMBAT
-- ---------------------------------------------------------------------

RPHelper.RegisterRace(RPHelper.Race.GNOME, "entercombat", { type = "say", text = "For Gnomeregan!" })
RPHelper.RegisterRace(RPHelper.Race.GNOME, "entercombat", { type = "say", text = "I've calculated your odds. You won't like them." })
RPHelper.RegisterRace(RPHelper.Race.GNOME, "entercombat", { type = "say", text = "Let's put this theory to the test!" })
RPHelper.RegisterRace(RPHelper.Race.GNOME, "entercombat", { type = "say", text = "Every problem has a solution." })
RPHelper.RegisterRace(RPHelper.Race.GNOME, "entercombat", { type = "say", text = "I'm warning you, I'm seriously stressed out here!" })
RPHelper.RegisterRace(RPHelper.Race.GNOME, "entercombat", { type = "customemote", text = "makes a rapid calculation and adopts a determined stance." })

-- ---------------------------------------------------------------------
-- LEAVE COMBAT
-- ---------------------------------------------------------------------

RPHelper.RegisterRace(RPHelper.Race.GNOME, "leavecombat", { type = "say", text = "Just as calculated." })
RPHelper.RegisterRace(RPHelper.Race.GNOME, "leavecombat", { type = "say", text = "An excellent field test!" })
RPHelper.RegisterRace(RPHelper.Race.GNOME, "leavecombat", { type = "say", text = "I should write this down." })
RPHelper.RegisterRace(RPHelper.Race.GNOME, "leavecombat", { type = "customemote", text = "dusts themselves off and begins reviewing what just happened." })

-- ---------------------------------------------------------------------
-- HURT
-- ---------------------------------------------------------------------

RPHelper.RegisterRace(RPHelper.Race.GNOME, "hurt", { type = "say", text = "That was totally uncalled for!" })
RPHelper.RegisterRace(RPHelper.Race.GNOME, "hurt", { type = "say", text = "I don't find this pain agreeable at all." })
RPHelper.RegisterRace(RPHelper.Race.GNOME, "hurt", { type = "say", text = "That was not part of the plan!" })
RPHelper.RegisterRace(RPHelper.Race.GNOME, "hurt", {
    type = "say",
    template = "{1} {2}",
    choices = {
        { "Ow!", "Ouch!", "Oof!", "Ack!" },
        { "That hurts!", "Not nice!", "You'll regret that!", "Quit it!" },
    },
})
RPHelper.RegisterRace(RPHelper.Race.GNOME, "hurt", { type = "customemote", text = "winces, then seems to reconsider a calculation." })

-- ---------------------------------------------------------------------
-- DODGE AND MISS
-- ---------------------------------------------------------------------

RPHelper.RegisterRace(RPHelper.Race.GNOME, "dodge", { type = "say", text = "Precisely as predicted!" })
RPHelper.RegisterRace(RPHelper.Race.GNOME, "miss", { type = "say", text = "You forgot to account for my height." })

-- ---------------------------------------------------------------------
-- YOU CRIT
-- ---------------------------------------------------------------------

RPHelper.RegisterRace(RPHelper.Race.GNOME, "youcrit", { type = "say", text = "Everything is proceeding as planned!" })
RPHelper.RegisterRace(RPHelper.Race.GNOME, "youcrit", { type = "say", text = "Look out! Too late." })
RPHelper.RegisterRace(RPHelper.Race.GNOME, "youcrit", { type = "say", text = "A practical demonstration of applied force." })
RPHelper.RegisterRace(RPHelper.Race.GNOME, "youcrit", { type = "customemote", text = "looks delighted that the calculation proved accurate." })

-- ---------------------------------------------------------------------
-- DEATH
-- ---------------------------------------------------------------------

RPHelper.RegisterRace(RPHelper.Race.GNOME, "death", { type = "say", text = "I may have... miscalculated..." })
RPHelper.RegisterRace(RPHelper.Race.GNOME, "death", { type = "say", text = "Save my notes..." })

-- ---------------------------------------------------------------------
-- RESURRECT
-- ---------------------------------------------------------------------

RPHelper.RegisterRace(RPHelper.Race.GNOME, "resurrect", { type = "say", text = "Unexpected, but entirely welcome!" })
RPHelper.RegisterRace(RPHelper.Race.GNOME, "resurrect", { type = "say", text = "I have several revisions to make." })
RPHelper.RegisterRace(RPHelper.Race.GNOME, "resurrect", { type = "say", text = "Fascinating. Let's avoid repeating the experiment." })
RPHelper.RegisterRace(RPHelper.Race.GNOME, "resurrect", { type = "customemote", text = "checks that everything is still attached and working." })
