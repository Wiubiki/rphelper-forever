-- RPHelper Forever - Tauren English content
-- Adapted from the RPhelper_twow Tauren catalogue and original RoleplayingHelper lineage.
-- Original contributor: mithyk
-- Additional adaptation and new content: Wiubiki

-- ---------------------------------------------------------------------
-- ENTER COMBAT
-- ---------------------------------------------------------------------

RPHelper.RegisterRace(RPHelper.Race.TAUREN, "entercombat", { id = "default:race:tauren:0001", type = "say", text = "For my ancestors!" })
RPHelper.RegisterRace(RPHelper.Race.TAUREN, "entercombat", { id = "default:race:tauren:0002", type = "say", text = "May my ancestors watch over me!" })
RPHelper.RegisterRace(RPHelper.Race.TAUREN, "entercombat", { id = "default:race:tauren:0003", type = "say", text = "For the tribes!" })
RPHelper.RegisterRace(RPHelper.Race.TAUREN, "entercombat", { id = "default:race:tauren:0004", type = "say", text = "The hunt is upon you!" })
RPHelper.RegisterRace(RPHelper.Race.TAUREN, "entercombat", { id = "default:race:tauren:0005", type = "say", text = "The plains have taught me patience. Now they demand action." })
RPHelper.RegisterRace(RPHelper.Race.TAUREN, "entercombat", { id = "default:race:tauren:0006", type = "customemote", text = "lowers their horns and advances with deliberate steps." })
RPHelper.RegisterRace(RPHelper.Race.TAUREN, "entercombat", {
id = "default:race:tauren:0007",     type = "say",
    template = "You {1} {2}, {3}",
    choices = {
        { "shall", "will" },
        { "breathe your last", "meet your end" },
        {
            "for the Earth Mother has found you wanting.",
            "for the Earth Mother has sent the hunt.",
            "for the hunt is now upon you.",
        },
    },
})

-- ---------------------------------------------------------------------
-- LEAVE COMBAT
-- ---------------------------------------------------------------------

RPHelper.RegisterRace(RPHelper.Race.TAUREN, "leavecombat", { id = "default:race:tauren:0008", type = "say", text = "The balance is restored." })
RPHelper.RegisterRace(RPHelper.Race.TAUREN, "leavecombat", { id = "default:race:tauren:0009", type = "say", text = "May the fallen find peace." })
RPHelper.RegisterRace(RPHelper.Race.TAUREN, "leavecombat", { id = "default:race:tauren:0010", type = "customemote", text = "bows their head for a moment of quiet reflection." })

-- ---------------------------------------------------------------------
-- HURT
-- ---------------------------------------------------------------------

RPHelper.RegisterRace(RPHelper.Race.TAUREN, "hurt", { id = "default:race:tauren:0011", type = "say", text = "Ancestors, give me strength." })
RPHelper.RegisterRace(RPHelper.Race.TAUREN, "hurt", { id = "default:race:tauren:0012", type = "say", text = "The old blood still runs strong." })
RPHelper.RegisterRace(RPHelper.Race.TAUREN, "hurt", { id = "default:race:tauren:0013", type = "customemote", text = "plants their hooves and refuses to yield." })

-- ---------------------------------------------------------------------
-- DODGE AND MISS
-- ---------------------------------------------------------------------

RPHelper.RegisterRace(RPHelper.Race.TAUREN, "dodge", { id = "default:race:tauren:0014", type = "say", text = "Too slow to catch even one as large as me?" })
RPHelper.RegisterRace(RPHelper.Race.TAUREN, "dodge", { id = "default:race:tauren:0015", type = "say", text = "The plains taught me to move. What taught you to fight?" })
RPHelper.RegisterRace(RPHelper.Race.TAUREN, "dodge", { id = "default:race:tauren:0016", type = "say", text = "These hooves are lighter than they look." })
RPHelper.RegisterRace(RPHelper.Race.TAUREN, "dodge", { id = "default:race:tauren:0017", type = "emote", text = "LAUGH" })
RPHelper.RegisterRace(RPHelper.Race.TAUREN, "miss", { id = "default:race:tauren:0018", type = "say", text = "How in the Earth Mother's name did you miss me?" })
RPHelper.RegisterRace(RPHelper.Race.TAUREN, "miss", { id = "default:race:tauren:0019", type = "say", text = "If you cannot strike a tauren standing before you, perhaps fighting is not your calling." })
RPHelper.RegisterRace(RPHelper.Race.TAUREN, "miss", { id = "default:race:tauren:0020", type = "say", text = "I am hardly a small target." })
RPHelper.RegisterRace(RPHelper.Race.TAUREN, "miss", { id = "default:race:tauren:0021", type = "emote", text = "LAUGH" })

-- ---------------------------------------------------------------------
-- YOU CRIT
-- ---------------------------------------------------------------------

RPHelper.RegisterRace(RPHelper.Race.TAUREN, "youcrit", { id = "default:race:tauren:0022", type = "say", text = "The strength of the earth is with me!" })
RPHelper.RegisterRace(RPHelper.Race.TAUREN, "youcrit", { id = "default:race:tauren:0023", type = "say", text = "The hunt nears its end." })
RPHelper.RegisterRace(RPHelper.Race.TAUREN, "youcrit", { id = "default:race:tauren:0024", type = "customemote", text = "lets out a deep, triumphant bellow." })

-- ---------------------------------------------------------------------
-- DEATH
-- ---------------------------------------------------------------------

RPHelper.RegisterRace(RPHelper.Race.TAUREN, "death", { id = "default:race:tauren:0025", type = "say", text = "Ancestors... guide me home..." })
RPHelper.RegisterRace(RPHelper.Race.TAUREN, "death", { id = "default:race:tauren:0026", type = "say", text = "Earth Mother... receive me..." })

-- ---------------------------------------------------------------------
-- RESURRECT
-- ---------------------------------------------------------------------

RPHelper.RegisterRace(RPHelper.Race.TAUREN, "resurrect", { id = "default:race:tauren:0027", type = "say", text = "The Earth Mother smiles upon me." })
RPHelper.RegisterRace(RPHelper.Race.TAUREN, "resurrect", { id = "default:race:tauren:0028", type = "say", text = "I have walked among the spirits." })
RPHelper.RegisterRace(RPHelper.Race.TAUREN, "resurrect", { id = "default:race:tauren:0029", type = "say", text = "My vision dimmed, but the ancestors sent me back." })
RPHelper.RegisterRace(RPHelper.Race.TAUREN, "resurrect", { id = "default:race:tauren:0030", type = "say", text = "I walk the land once more." })
RPHelper.RegisterRace(RPHelper.Race.TAUREN, "resurrect", { id = "default:race:tauren:0031", type = "customemote", text = "touches the earth and murmurs thanks to the ancestors." })
