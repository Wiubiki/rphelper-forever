-- RPHelper Forever - Gnome English content
-- Adapted from the RPhelper_twow Gnome catalogue and original RoleplayingHelper lineage.
-- Original contributors: mithyk, Syrsa
-- Additional adaptation and new content: Wiubiki

-- ---------------------------------------------------------------------
-- ENTER COMBAT
-- ---------------------------------------------------------------------

RPHelper.RegisterRace(RPHelper.Race.GNOME, "entercombat", { id = "default:race:gnome:0001", type = "say", text = "For Gnomeregan!" })
RPHelper.RegisterRace(RPHelper.Race.GNOME, "entercombat", { id = "default:race:gnome:0002", type = "say", text = "I've calculated your odds. You won't like them." })
RPHelper.RegisterRace(RPHelper.Race.GNOME, "entercombat", { id = "default:race:gnome:0003", type = "say", text = "Let's put this theory to the test!" })
RPHelper.RegisterRace(RPHelper.Race.GNOME, "entercombat", { id = "default:race:gnome:0004", type = "say", text = "Every problem has a solution." })
RPHelper.RegisterRace(RPHelper.Race.GNOME, "entercombat", { id = "default:race:gnome:0005", type = "say", text = "I'm warning you, I'm seriously stressed out here!" })
RPHelper.RegisterRace(RPHelper.Race.GNOME, "entercombat", { id = "default:race:gnome:0006", type = "customemote", text = "makes a rapid calculation and adopts a determined stance." })

-- ---------------------------------------------------------------------
-- LEAVE COMBAT
-- ---------------------------------------------------------------------

RPHelper.RegisterRace(RPHelper.Race.GNOME, "leavecombat", { id = "default:race:gnome:0007", type = "say", text = "Just as calculated." })
RPHelper.RegisterRace(RPHelper.Race.GNOME, "leavecombat", { id = "default:race:gnome:0008", type = "say", text = "An excellent field test!" })
RPHelper.RegisterRace(RPHelper.Race.GNOME, "leavecombat", { id = "default:race:gnome:0009", type = "say", text = "I should write this down." })
RPHelper.RegisterRace(RPHelper.Race.GNOME, "leavecombat", { id = "default:race:gnome:0010", type = "customemote", text = "dusts themselves off and begins reviewing what just happened." })

-- ---------------------------------------------------------------------
-- HURT
-- ---------------------------------------------------------------------

RPHelper.RegisterRace(RPHelper.Race.GNOME, "hurt", { id = "default:race:gnome:0011", type = "say", text = "That was totally uncalled for!" })
RPHelper.RegisterRace(RPHelper.Race.GNOME, "hurt", { id = "default:race:gnome:0012", type = "say", text = "I don't find this pain agreeable at all." })
RPHelper.RegisterRace(RPHelper.Race.GNOME, "hurt", { id = "default:race:gnome:0013", type = "say", text = "That was not part of the plan!" })
RPHelper.RegisterRace(RPHelper.Race.GNOME, "hurt", {
id = "default:race:gnome:0014",     type = "say",
    template = "{1} {2}",
    choices = {
        { "Ow!", "Ouch!", "Oof!", "Ack!" },
        { "That hurts!", "Not nice!", "You'll regret that!", "Quit it!" },
    },
})
RPHelper.RegisterRace(RPHelper.Race.GNOME, "hurt", { id = "default:race:gnome:0015", type = "customemote", text = "winces, then seems to reconsider a calculation." })

-- ---------------------------------------------------------------------
-- DODGE AND MISS
-- ---------------------------------------------------------------------

RPHelper.RegisterRace(RPHelper.Race.GNOME, "dodge", { id = "default:race:gnome:0016", type = "say", text = "Precisely as predicted!" })
RPHelper.RegisterRace(RPHelper.Race.GNOME, "miss", { id = "default:race:gnome:0017", type = "say", text = "You forgot to account for my height." })

-- ---------------------------------------------------------------------
-- YOU CRIT
-- ---------------------------------------------------------------------

RPHelper.RegisterRace(RPHelper.Race.GNOME, "youcrit", { id = "default:race:gnome:0018", type = "say", text = "Everything is proceeding as planned!" })
RPHelper.RegisterRace(RPHelper.Race.GNOME, "youcrit", { id = "default:race:gnome:0019", type = "say", text = "Look out! Too late." })
RPHelper.RegisterRace(RPHelper.Race.GNOME, "youcrit", { id = "default:race:gnome:0020", type = "say", text = "A practical demonstration of applied force." })
RPHelper.RegisterRace(RPHelper.Race.GNOME, "youcrit", { id = "default:race:gnome:0021", type = "customemote", text = "looks delighted that the calculation proved accurate." })

-- ---------------------------------------------------------------------
-- DEATH
-- ---------------------------------------------------------------------

RPHelper.RegisterRace(RPHelper.Race.GNOME, "death", { id = "default:race:gnome:0022", type = "say", text = "I may have... miscalculated..." })
RPHelper.RegisterRace(RPHelper.Race.GNOME, "death", { id = "default:race:gnome:0023", type = "say", text = "Save my notes..." })

-- ---------------------------------------------------------------------
-- RESURRECT
-- ---------------------------------------------------------------------

RPHelper.RegisterRace(RPHelper.Race.GNOME, "resurrect", { id = "default:race:gnome:0024", type = "say", text = "Unexpected, but entirely welcome!" })
RPHelper.RegisterRace(RPHelper.Race.GNOME, "resurrect", { id = "default:race:gnome:0025", type = "say", text = "I have several revisions to make." })
RPHelper.RegisterRace(RPHelper.Race.GNOME, "resurrect", { id = "default:race:gnome:0026", type = "say", text = "Fascinating. Let's avoid repeating the experiment." })
RPHelper.RegisterRace(RPHelper.Race.GNOME, "resurrect", { id = "default:race:gnome:0027", type = "customemote", text = "checks that everything is still attached and working." })
