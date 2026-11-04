-- RPHelper Forever - Forsaken English content
-- Internal race key: UNDEAD
-- Adapted from the RPhelper_twow Undead catalogue and original RoleplayingHelper lineage.
-- Original contributors: mithyk, Syrsa
-- Additional adaptation and new content: Wiubiki

-- ---------------------------------------------------------------------
-- ENTER COMBAT
-- ---------------------------------------------------------------------

RPHelper.RegisterRace(RPHelper.Race.UNDEAD, "entercombat", { id = "default:race:undead:0001", type = "say", text = "Tremble before the Forsaken!" })
RPHelper.RegisterRace(RPHelper.Race.UNDEAD, "entercombat", { id = "default:race:undead:0002", type = "say", text = "Glory to the Forsaken!" })
RPHelper.RegisterRace(RPHelper.Race.UNDEAD, "entercombat", { id = "default:race:undead:0003", type = "say", text = "Death shall reign!" })
RPHelper.RegisterRace(RPHelper.Race.UNDEAD, "entercombat", { id = "default:race:undead:0004", type = "say", text = "Share my pain." })
RPHelper.RegisterRace(RPHelper.Race.UNDEAD, "entercombat", { id = "default:race:undead:0005", type = "say", text = "You still fear death. How quaint." })
RPHelper.RegisterRace(RPHelper.Race.UNDEAD, "entercombat", { id = "default:race:undead:0006", type = "customemote", text = "bares a deathly grin and advances without hesitation." })
RPHelper.RegisterRace(RPHelper.Race.UNDEAD, "entercombat", { id = "default:race:undead:0007", type = "emote", text = "CACKLE" })

-- ---------------------------------------------------------------------
-- LEAVE COMBAT
-- ---------------------------------------------------------------------

RPHelper.RegisterRace(RPHelper.Race.UNDEAD, "leavecombat", { id = "default:race:undead:0008", type = "say", text = "Death is not the end." })
RPHelper.RegisterRace(RPHelper.Race.UNDEAD, "leavecombat", { id = "default:race:undead:0009", type = "say", text = "Death is our business, and business is good." })
RPHelper.RegisterRace(RPHelper.Race.UNDEAD, "leavecombat", { id = "default:race:undead:0010", type = "say", text = "Another reminder of life's fragility." })
RPHelper.RegisterRace(RPHelper.Race.UNDEAD, "leavecombat", { id = "default:race:undead:0011", type = "customemote", text = "checks for any newly loosened stitches." })

-- ---------------------------------------------------------------------
-- HURT
-- ---------------------------------------------------------------------

RPHelper.RegisterRace(RPHelper.Race.UNDEAD, "hurt", {
id = "default:race:undead:0012",     type = "say",
    template = "{1} {2}.",
    choices = {
        { "There goes another", "I lost another", "You took another" },
        { "chunk of flesh", "bone", "finger", "rib" },
    },
})
RPHelper.RegisterRace(RPHelper.Race.UNDEAD, "hurt", { id = "default:race:undead:0013", type = "say", text = "I was using that part." })
RPHelper.RegisterRace(RPHelper.Race.UNDEAD, "hurt", { id = "default:race:undead:0014", type = "say", text = "Pain and I are old acquaintances." })
RPHelper.RegisterRace(RPHelper.Race.UNDEAD, "hurt", { id = "default:race:undead:0015", type = "customemote", text = "glances at the wound with detached annoyance." })

-- ---------------------------------------------------------------------
-- DODGE AND MISS
-- ---------------------------------------------------------------------

RPHelper.RegisterRace(RPHelper.Race.UNDEAD, "dodge", { id = "default:race:undead:0016", type = "say", text = "Too slow. Even for the dead." })
RPHelper.RegisterRace(RPHelper.Race.UNDEAD, "miss", { id = "default:race:undead:0017", type = "say", text = "You missed a stationary corpse." })

-- ---------------------------------------------------------------------
-- YOU CRIT
-- ---------------------------------------------------------------------

RPHelper.RegisterRace(RPHelper.Race.UNDEAD, "youcrit", { id = "default:race:undead:0018", type = "say", text = "Sooner or later, you will be dead." })
RPHelper.RegisterRace(RPHelper.Race.UNDEAD, "youcrit", { id = "default:race:undead:0019", type = "say", text = "Your pain will end soon." })
RPHelper.RegisterRace(RPHelper.Race.UNDEAD, "youcrit", { id = "default:race:undead:0020", type = "say", text = "Death stalks you at every turn." })
RPHelper.RegisterRace(RPHelper.Race.UNDEAD, "youcrit", { id = "default:race:undead:0021", type = "customemote", text = "regards the wound with morbid satisfaction." })

-- ---------------------------------------------------------------------
-- DEATH
-- ---------------------------------------------------------------------

RPHelper.RegisterRace(RPHelper.Race.UNDEAD, "death", { id = "default:race:undead:0022", type = "say", text = "Death... again..." })
RPHelper.RegisterRace(RPHelper.Race.UNDEAD, "death", { id = "default:race:undead:0023", type = "say", text = "This never gets easier..." })

-- ---------------------------------------------------------------------
-- RESURRECT
-- ---------------------------------------------------------------------

RPHelper.RegisterRace(RPHelper.Race.UNDEAD, "resurrect", { id = "default:race:undead:0024", type = "say", text = "I'm alive! Well... close enough." })
RPHelper.RegisterRace(RPHelper.Race.UNDEAD, "resurrect", { id = "default:race:undead:0025", type = "say", text = "All the parts are sewn back in. Ready for action." })
RPHelper.RegisterRace(RPHelper.Race.UNDEAD, "resurrect", { id = "default:race:undead:0026", type = "say", text = "I'll need to find a replacement for a part or two." })
RPHelper.RegisterRace(RPHelper.Race.UNDEAD, "resurrect", { id = "default:race:undead:0027", type = "say", text = "That hole may be permanent." })
RPHelper.RegisterRace(RPHelper.Race.UNDEAD, "resurrect", { id = "default:race:undead:0028", type = "customemote", text = "tests each limb in turn, then lurches upright." })
