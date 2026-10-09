-- RPHelper Forever - Tauren English content
-- Adapted from the RPhelper_twow Tauren catalogue and original RoleplayingHelper lineage.
-- Original contributor: mithyk
-- Additional adaptation and new content: Wiubiki

-- ---------------------------------------------------------------------
-- ENTER COMBAT
-- ---------------------------------------------------------------------

RPHelper.RegisterRace(RPHelper.Race.TAUREN, "entercombat", { type = "say", text = "For my ancestors!" })
RPHelper.RegisterRace(RPHelper.Race.TAUREN, "entercombat", { type = "say", text = "May my ancestors watch over me!" })
RPHelper.RegisterRace(RPHelper.Race.TAUREN, "entercombat", { type = "say", text = "For the tribes!" })
RPHelper.RegisterRace(RPHelper.Race.TAUREN, "entercombat", { type = "say", text = "The hunt is upon you!" })
RPHelper.RegisterRace(RPHelper.Race.TAUREN, "entercombat", { type = "say", text = "The plains have taught me patience. Now they demand action." })
RPHelper.RegisterRace(RPHelper.Race.TAUREN, "entercombat", { type = "customemote", text = "lowers their horns and advances with deliberate steps." })
RPHelper.RegisterRace(RPHelper.Race.TAUREN, "entercombat", {
    type = "say",
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

RPHelper.RegisterRace(RPHelper.Race.TAUREN, "leavecombat", { type = "say", text = "The balance is restored." })
RPHelper.RegisterRace(RPHelper.Race.TAUREN, "leavecombat", { type = "say", text = "May the fallen find peace." })
RPHelper.RegisterRace(RPHelper.Race.TAUREN, "leavecombat", { type = "customemote", text = "bows their head for a moment of quiet reflection." })

-- ---------------------------------------------------------------------
-- HURT
-- ---------------------------------------------------------------------

RPHelper.RegisterRace(RPHelper.Race.TAUREN, "hurt", { type = "say", text = "Ancestors, give me strength." })
RPHelper.RegisterRace(RPHelper.Race.TAUREN, "hurt", { type = "say", text = "The old blood still runs strong." })
RPHelper.RegisterRace(RPHelper.Race.TAUREN, "hurt", { type = "customemote", text = "plants their hooves and refuses to yield." })

-- ---------------------------------------------------------------------
-- DODGE AND MISS
-- ---------------------------------------------------------------------

RPHelper.RegisterRace(RPHelper.Race.TAUREN, "dodge", { type = "say", text = "Too slow to catch even one as large as me?" })
RPHelper.RegisterRace(RPHelper.Race.TAUREN, "dodge", { type = "say", text = "The plains taught me to move. What taught you to fight?" })
RPHelper.RegisterRace(RPHelper.Race.TAUREN, "dodge", { type = "say", text = "These hooves are lighter than they look." })
RPHelper.RegisterRace(RPHelper.Race.TAUREN, "dodge", { type = "emote", text = "LAUGH" })
RPHelper.RegisterRace(RPHelper.Race.TAUREN, "miss", { type = "say", text = "How in the Earth Mother's name did you miss me?" })
RPHelper.RegisterRace(RPHelper.Race.TAUREN, "miss", { type = "say", text = "If you cannot strike a tauren standing before you, perhaps fighting is not your calling." })
RPHelper.RegisterRace(RPHelper.Race.TAUREN, "miss", { type = "say", text = "I am hardly a small target." })
RPHelper.RegisterRace(RPHelper.Race.TAUREN, "miss", { type = "emote", text = "LAUGH" })

-- ---------------------------------------------------------------------
-- YOU CRIT
-- ---------------------------------------------------------------------

RPHelper.RegisterRace(RPHelper.Race.TAUREN, "youcrit", { type = "say", text = "The strength of the earth is with me!" })
RPHelper.RegisterRace(RPHelper.Race.TAUREN, "youcrit", { type = "say", text = "The hunt nears its end." })
RPHelper.RegisterRace(RPHelper.Race.TAUREN, "youcrit", { type = "customemote", text = "lets out a deep, triumphant bellow." })

-- ---------------------------------------------------------------------
-- DEATH
-- ---------------------------------------------------------------------

RPHelper.RegisterRace(RPHelper.Race.TAUREN, "death", { type = "say", text = "Ancestors... guide me home..." })
RPHelper.RegisterRace(RPHelper.Race.TAUREN, "death", { type = "say", text = "Earth Mother... receive me..." })

-- ---------------------------------------------------------------------
-- RESURRECT
-- ---------------------------------------------------------------------

RPHelper.RegisterRace(RPHelper.Race.TAUREN, "resurrect", { type = "say", text = "The Earth Mother smiles upon me." })
RPHelper.RegisterRace(RPHelper.Race.TAUREN, "resurrect", { type = "say", text = "I have walked among the spirits." })
RPHelper.RegisterRace(RPHelper.Race.TAUREN, "resurrect", { type = "say", text = "My vision dimmed, but the ancestors sent me back." })
RPHelper.RegisterRace(RPHelper.Race.TAUREN, "resurrect", { type = "say", text = "I walk the land once more." })
RPHelper.RegisterRace(RPHelper.Race.TAUREN, "resurrect", { type = "customemote", text = "touches the earth and murmurs thanks to the ancestors." })
