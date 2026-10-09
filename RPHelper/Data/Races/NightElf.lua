-- RPHelper Forever - Night Elf English content
-- Adapted from the RPhelper_twow Night Elf catalogue and original RoleplayingHelper lineage.
-- Original contributors: mithyk, Syrsa
-- Additional adaptation and new content: Wiubiki

-- ---------------------------------------------------------------------
-- ENTER COMBAT
-- ---------------------------------------------------------------------

RPHelper.RegisterRace(RPHelper.Race.NIGHTELF, "entercombat", { type = "say", text = "For Cenarius!" })
RPHelper.RegisterRace(RPHelper.Race.NIGHTELF, "entercombat", { type = "say", text = "By Elune!" })
RPHelper.RegisterRace(RPHelper.Race.NIGHTELF, "entercombat", { type = "say", text = "Elune, grant me swift victory!" })
RPHelper.RegisterRace(RPHelper.Race.NIGHTELF, "entercombat", { type = "say", text = "The wilds will not yield to you." })
RPHelper.RegisterRace(RPHelper.Race.NIGHTELF, "entercombat", { type = "say", text = "You trespass beneath ancient boughs." })
RPHelper.RegisterRace(RPHelper.Race.NIGHTELF, "entercombat", { type = "customemote", text = "falls silent, watching the enemy with ageless patience." })
RPHelper.RegisterRace(RPHelper.Race.NIGHTELF, "entercombat", {
    type = "say",
    template = "You {1} {2}",
    choices = {
        { "shall", "will" },
        { "answer to Elune.", "face the forest's wrath.", "go no farther." },
    },
})

-- ---------------------------------------------------------------------
-- LEAVE COMBAT
-- ---------------------------------------------------------------------

RPHelper.RegisterRace(RPHelper.Race.NIGHTELF, "leavecombat", { type = "say", text = "The forest is quiet once more." })
RPHelper.RegisterRace(RPHelper.Race.NIGHTELF, "leavecombat", { type = "say", text = "Elune watched over us." })
RPHelper.RegisterRace(RPHelper.Race.NIGHTELF, "leavecombat", { type = "customemote", text = "listens as stillness returns to the land." })

-- ---------------------------------------------------------------------
-- DODGE AND MISS
-- ---------------------------------------------------------------------

RPHelper.RegisterRace(RPHelper.Race.NIGHTELF, "dodge", { type = "say", text = "You strike only shadows." })
RPHelper.RegisterRace(RPHelper.Race.NIGHTELF, "dodge", { type = "customemote", text = "glides aside with scarcely a sound." })
RPHelper.RegisterRace(RPHelper.Race.NIGHTELF, "miss", { type = "say", text = "The shadows misled your hand." })

-- ---------------------------------------------------------------------
-- YOU CRIT
-- ---------------------------------------------------------------------

RPHelper.RegisterRace(RPHelper.Race.NIGHTELF, "youcrit", { type = "say", text = "Elune guides my hand." })
RPHelper.RegisterRace(RPHelper.Race.NIGHTELF, "youcrit", { type = "say", text = "Ancient patience finds its moment." })
RPHelper.RegisterRace(RPHelper.Race.NIGHTELF, "youcrit", { type = "customemote", text = "regards the telling blow with quiet satisfaction." })

-- ---------------------------------------------------------------------
-- DEATH
-- ---------------------------------------------------------------------

RPHelper.RegisterRace(RPHelper.Race.NIGHTELF, "death", { type = "say", text = "Elune... guide me through the dark..." })
RPHelper.RegisterRace(RPHelper.Race.NIGHTELF, "death", { type = "say", text = "I return... to the stars..." })

-- ---------------------------------------------------------------------
-- RESURRECT
-- ---------------------------------------------------------------------

RPHelper.RegisterRace(RPHelper.Race.NIGHTELF, "resurrect", { type = "say", text = "For a moment, I felt the presence of Elune." })
RPHelper.RegisterRace(RPHelper.Race.NIGHTELF, "resurrect", { type = "say", text = "By the Goddess' mercy, I live again." })
RPHelper.RegisterRace(RPHelper.Race.NIGHTELF, "resurrect", { type = "say", text = "The stars have not yet claimed me." })
RPHelper.RegisterRace(RPHelper.Race.NIGHTELF, "resurrect", { type = "emote", text = "PRAY" })
RPHelper.RegisterRace(RPHelper.Race.NIGHTELF, "resurrect", { type = "customemote", text = "opens their eyes and whispers a prayer to Elune." })
