-- RPHelper Forever - Troll English content
-- Adapted from the RPhelper_twow Troll catalogue and original RoleplayingHelper lineage.
-- Original contributor: mithyk
-- Additional adaptation and new content: Wiubiki

-- ---------------------------------------------------------------------
-- ENTER COMBAT
-- ---------------------------------------------------------------------

RPHelper.RegisterRace(RPHelper.Race.TROLL, "entercombat", { id = "default:race:troll:0001", type = "say", text = "Tas'dingo!" })
RPHelper.RegisterRace(RPHelper.Race.TROLL, "entercombat", { id = "default:race:troll:0002", type = "say", text = "Here come the voodoo!" })
RPHelper.RegisterRace(RPHelper.Race.TROLL, "entercombat", { id = "default:race:troll:0003", type = "say", text = "The Loa don't favor you today." })
RPHelper.RegisterRace(RPHelper.Race.TROLL, "entercombat", { id = "default:race:troll:0004", type = "say", text = "The spirits be watching this fight." })
RPHelper.RegisterRace(RPHelper.Race.TROLL, "entercombat", { id = "default:race:troll:0005", type = "say", text = "You made a big mistake, mon." })
RPHelper.RegisterRace(RPHelper.Race.TROLL, "entercombat", { id = "default:race:troll:0006", type = "customemote", text = "rolls their shoulders and flashes a tusked grin." })
RPHelper.RegisterRace(RPHelper.Race.TROLL, "entercombat", {
id = "default:race:troll:0007",     type = "say",
    template = "You {1} {2}, {3}",
    choices = {
        { "gonna", "about to" },
        { "leave the flesh", "meet your end", "fall" },
        { "and no Loa be saving you!", "for my Loa be watching!", "before the spirits!" },
    },
})

-- ---------------------------------------------------------------------
-- LEAVE COMBAT
-- ---------------------------------------------------------------------

RPHelper.RegisterRace(RPHelper.Race.TROLL, "leavecombat", { id = "default:race:troll:0008", type = "say", text = "The spirits knew how this would end." })
RPHelper.RegisterRace(RPHelper.Race.TROLL, "leavecombat", { id = "default:race:troll:0009", type = "say", text = "Another tale for the tribe." })
RPHelper.RegisterRace(RPHelper.Race.TROLL, "leavecombat", { id = "default:race:troll:0010", type = "say", text = "The Loa be smiling today." })
RPHelper.RegisterRace(RPHelper.Race.TROLL, "leavecombat", { id = "default:race:troll:0011", type = "customemote", text = "grins and offers a quick gesture of thanks to the spirits." })

-- ---------------------------------------------------------------------
-- HURT
-- ---------------------------------------------------------------------

RPHelper.RegisterRace(RPHelper.Race.TROLL, "hurt", { id = "default:race:troll:0012", type = "say", text = "You be paying for that!" })
RPHelper.RegisterRace(RPHelper.Race.TROLL, "hurt", { id = "default:race:troll:0013", type = "say", text = "The blood will stop. Yours might not." })
RPHelper.RegisterRace(RPHelper.Race.TROLL, "hurt", { id = "default:race:troll:0014", type = "say", text = "Takes more than that to keep a troll down." })
RPHelper.RegisterRace(RPHelper.Race.TROLL, "hurt", { id = "default:race:troll:0015", type = "customemote", text = "bares their tusks and shakes off the pain." })

-- ---------------------------------------------------------------------
-- DODGE AND MISS
-- ---------------------------------------------------------------------

RPHelper.RegisterRace(RPHelper.Race.TROLL, "dodge", { id = "default:race:troll:0016", type = "say", text = "The spirits moved me, mon." })
RPHelper.RegisterRace(RPHelper.Race.TROLL, "miss", { id = "default:race:troll:0017", type = "say", text = "The Loa turned your hand aside." })

-- ---------------------------------------------------------------------
-- YOU CRIT
-- ---------------------------------------------------------------------

RPHelper.RegisterRace(RPHelper.Race.TROLL, "youcrit", { id = "default:race:troll:0018", type = "say", text = "I smell fear." })
RPHelper.RegisterRace(RPHelper.Race.TROLL, "youcrit", { id = "default:race:troll:0019", type = "say", text = "The Loa guide me well." })
RPHelper.RegisterRace(RPHelper.Race.TROLL, "youcrit", { id = "default:race:troll:0020", type = "say", text = "Now we be getting somewhere!" })
RPHelper.RegisterRace(RPHelper.Race.TROLL, "youcrit", { id = "default:race:troll:0021", type = "customemote", text = "laughs as the spirits favor the attack." })

-- ---------------------------------------------------------------------
-- DEATH
-- ---------------------------------------------------------------------

RPHelper.RegisterRace(RPHelper.Race.TROLL, "death", { id = "default:race:troll:0022", type = "say", text = "Loa... guide my spirit..." })
RPHelper.RegisterRace(RPHelper.Race.TROLL, "death", { id = "default:race:troll:0023", type = "say", text = "The spirits... be calling..." })

-- ---------------------------------------------------------------------
-- RESURRECT
-- ---------------------------------------------------------------------

RPHelper.RegisterRace(RPHelper.Race.TROLL, "resurrect", { id = "default:race:troll:0024", type = "say", text = "I be alive!" })
RPHelper.RegisterRace(RPHelper.Race.TROLL, "resurrect", { id = "default:race:troll:0025", type = "say", text = "I walked among the Loa, but now I be waking." })
RPHelper.RegisterRace(RPHelper.Race.TROLL, "resurrect", { id = "default:race:troll:0026", type = "say", text = "The Loa sent me back, mon." })
RPHelper.RegisterRace(RPHelper.Race.TROLL, "resurrect", { id = "default:race:troll:0027", type = "say", text = "That's gonna leave a fine scar." })
RPHelper.RegisterRace(RPHelper.Race.TROLL, "resurrect", { id = "default:race:troll:0028", type = "customemote", text = "draws a breath and murmurs thanks to the Loa." })
