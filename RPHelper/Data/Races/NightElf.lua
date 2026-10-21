-- RPHelper Forever - Night Elf English content
-- Adapted from the RPhelper_twow Night Elf catalogue and original RoleplayingHelper lineage.
-- Original contributors: mithyk, Syrsa
-- Additional adaptation and new content: Wiubiki

-- ---------------------------------------------------------------------
-- ENTER COMBAT
-- ---------------------------------------------------------------------

RPHelper.RegisterRace(RPHelper.Race.NIGHTELF, "entercombat", { id = "default:race:nightelf:0001", type = "say", text = "For Cenarius!" })
RPHelper.RegisterRace(RPHelper.Race.NIGHTELF, "entercombat", { id = "default:race:nightelf:0002", type = "say", text = "By Elune!" })
RPHelper.RegisterRace(RPHelper.Race.NIGHTELF, "entercombat", { id = "default:race:nightelf:0003", type = "say", text = "Elune, grant me swift victory!" })
RPHelper.RegisterRace(RPHelper.Race.NIGHTELF, "entercombat", { id = "default:race:nightelf:0004", type = "say", text = "The wilds will not yield to you." })
RPHelper.RegisterRace(RPHelper.Race.NIGHTELF, "entercombat", { id = "default:race:nightelf:0005", type = "say", text = "You trespass beneath ancient boughs." })
RPHelper.RegisterRace(RPHelper.Race.NIGHTELF, "entercombat", { id = "default:race:nightelf:0006", type = "customemote", text = "falls silent, watching the enemy with ageless patience." })
RPHelper.RegisterRace(RPHelper.Race.NIGHTELF, "entercombat", {
id = "default:race:nightelf:0007",     type = "say",
    template = "You {1} {2}",
    choices = {
        { "shall", "will" },
        { "answer to Elune.", "face the forest's wrath.", "go no farther." },
    },
})

-- ---------------------------------------------------------------------
-- LEAVE COMBAT
-- ---------------------------------------------------------------------

RPHelper.RegisterRace(RPHelper.Race.NIGHTELF, "leavecombat", { id = "default:race:nightelf:0008", type = "say", text = "The forest is quiet once more." })
RPHelper.RegisterRace(RPHelper.Race.NIGHTELF, "leavecombat", { id = "default:race:nightelf:0009", type = "say", text = "Elune watched over us." })
RPHelper.RegisterRace(RPHelper.Race.NIGHTELF, "leavecombat", { id = "default:race:nightelf:0010", type = "customemote", text = "listens as stillness returns to the land." })

-- ---------------------------------------------------------------------
-- DODGE AND MISS
-- ---------------------------------------------------------------------

RPHelper.RegisterRace(RPHelper.Race.NIGHTELF, "dodge", { id = "default:race:nightelf:0011", type = "say", text = "You strike only shadows." })
RPHelper.RegisterRace(RPHelper.Race.NIGHTELF, "dodge", { id = "default:race:nightelf:0012", type = "customemote", text = "glides aside with scarcely a sound." })
RPHelper.RegisterRace(RPHelper.Race.NIGHTELF, "miss", { id = "default:race:nightelf:0013", type = "say", text = "The shadows misled your hand." })

-- ---------------------------------------------------------------------
-- YOU CRIT
-- ---------------------------------------------------------------------

RPHelper.RegisterRace(RPHelper.Race.NIGHTELF, "youcrit", { id = "default:race:nightelf:0014", type = "say", text = "Elune guides my hand." })
RPHelper.RegisterRace(RPHelper.Race.NIGHTELF, "youcrit", { id = "default:race:nightelf:0015", type = "say", text = "Ancient patience finds its moment." })
RPHelper.RegisterRace(RPHelper.Race.NIGHTELF, "youcrit", { id = "default:race:nightelf:0016", type = "customemote", text = "regards the telling blow with quiet satisfaction." })

-- ---------------------------------------------------------------------
-- DEATH
-- ---------------------------------------------------------------------

RPHelper.RegisterRace(RPHelper.Race.NIGHTELF, "death", { id = "default:race:nightelf:0017", type = "say", text = "Elune... guide me through the dark..." })
RPHelper.RegisterRace(RPHelper.Race.NIGHTELF, "death", { id = "default:race:nightelf:0018", type = "say", text = "I return... to the stars..." })

-- ---------------------------------------------------------------------
-- RESURRECT
-- ---------------------------------------------------------------------

RPHelper.RegisterRace(RPHelper.Race.NIGHTELF, "resurrect", { id = "default:race:nightelf:0019", type = "say", text = "For a moment, I felt the presence of Elune." })
RPHelper.RegisterRace(RPHelper.Race.NIGHTELF, "resurrect", { id = "default:race:nightelf:0020", type = "say", text = "By the Goddess' mercy, I live again." })
RPHelper.RegisterRace(RPHelper.Race.NIGHTELF, "resurrect", { id = "default:race:nightelf:0021", type = "say", text = "The stars have not yet claimed me." })
RPHelper.RegisterRace(RPHelper.Race.NIGHTELF, "resurrect", { id = "default:race:nightelf:0022", type = "emote", text = "PRAY" })
RPHelper.RegisterRace(RPHelper.Race.NIGHTELF, "resurrect", { id = "default:race:nightelf:0023", type = "customemote", text = "opens their eyes and whispers a prayer to Elune." })
