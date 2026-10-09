-- RPHelper Forever - Forsaken English content
-- Internal race key: UNDEAD
-- Adapted from the RPhelper_twow Undead catalogue and original RoleplayingHelper lineage.
-- Original contributors: mithyk, Syrsa
-- Additional adaptation and new content: Wiubiki

-- ---------------------------------------------------------------------
-- ENTER COMBAT
-- ---------------------------------------------------------------------

RPHelper.RegisterRace(RPHelper.Race.UNDEAD, "entercombat", { type = "say", text = "Tremble before the Forsaken!" })
RPHelper.RegisterRace(RPHelper.Race.UNDEAD, "entercombat", { type = "say", text = "Glory to the Forsaken!" })
RPHelper.RegisterRace(RPHelper.Race.UNDEAD, "entercombat", { type = "say", text = "Death shall reign!" })
RPHelper.RegisterRace(RPHelper.Race.UNDEAD, "entercombat", { type = "say", text = "Share my pain." })
RPHelper.RegisterRace(RPHelper.Race.UNDEAD, "entercombat", { type = "say", text = "You still fear death. How quaint." })
RPHelper.RegisterRace(RPHelper.Race.UNDEAD, "entercombat", { type = "customemote", text = "bares a deathly grin and advances without hesitation." })
RPHelper.RegisterRace(RPHelper.Race.UNDEAD, "entercombat", { type = "emote", text = "CACKLE" })

-- ---------------------------------------------------------------------
-- LEAVE COMBAT
-- ---------------------------------------------------------------------

RPHelper.RegisterRace(RPHelper.Race.UNDEAD, "leavecombat", { type = "say", text = "Death is not the end." })
RPHelper.RegisterRace(RPHelper.Race.UNDEAD, "leavecombat", { type = "say", text = "Death is our business, and business is good." })
RPHelper.RegisterRace(RPHelper.Race.UNDEAD, "leavecombat", { type = "say", text = "Another reminder of life's fragility." })
RPHelper.RegisterRace(RPHelper.Race.UNDEAD, "leavecombat", { type = "customemote", text = "checks for any newly loosened stitches." })

-- ---------------------------------------------------------------------
-- HURT
-- ---------------------------------------------------------------------

RPHelper.RegisterRace(RPHelper.Race.UNDEAD, "hurt", {
    type = "say",
    template = "{1} {2}.",
    choices = {
        { "There goes another", "I lost another", "You took another" },
        { "chunk of flesh", "bone", "finger", "rib" },
    },
})
RPHelper.RegisterRace(RPHelper.Race.UNDEAD, "hurt", { type = "say", text = "I was using that part." })
RPHelper.RegisterRace(RPHelper.Race.UNDEAD, "hurt", { type = "say", text = "Pain and I are old acquaintances." })
RPHelper.RegisterRace(RPHelper.Race.UNDEAD, "hurt", { type = "customemote", text = "glances at the wound with detached annoyance." })

-- ---------------------------------------------------------------------
-- DODGE AND MISS
-- ---------------------------------------------------------------------

RPHelper.RegisterRace(RPHelper.Race.UNDEAD, "dodge", { type = "say", text = "Too slow. Even for the dead." })
RPHelper.RegisterRace(RPHelper.Race.UNDEAD, "miss", { type = "say", text = "You missed a stationary corpse." })

-- ---------------------------------------------------------------------
-- YOU CRIT
-- ---------------------------------------------------------------------

RPHelper.RegisterRace(RPHelper.Race.UNDEAD, "youcrit", { type = "say", text = "Sooner or later, you will be dead." })
RPHelper.RegisterRace(RPHelper.Race.UNDEAD, "youcrit", { type = "say", text = "Your pain will end soon." })
RPHelper.RegisterRace(RPHelper.Race.UNDEAD, "youcrit", { type = "say", text = "Death stalks you at every turn." })
RPHelper.RegisterRace(RPHelper.Race.UNDEAD, "youcrit", { type = "customemote", text = "regards the wound with morbid satisfaction." })

-- ---------------------------------------------------------------------
-- DEATH
-- ---------------------------------------------------------------------

RPHelper.RegisterRace(RPHelper.Race.UNDEAD, "death", { type = "say", text = "Death... again..." })
RPHelper.RegisterRace(RPHelper.Race.UNDEAD, "death", { type = "say", text = "This never gets easier..." })

-- ---------------------------------------------------------------------
-- RESURRECT
-- ---------------------------------------------------------------------

RPHelper.RegisterRace(RPHelper.Race.UNDEAD, "resurrect", { type = "say", text = "I'm alive! Well... close enough." })
RPHelper.RegisterRace(RPHelper.Race.UNDEAD, "resurrect", { type = "say", text = "All the parts are sewn back in. Ready for action." })
RPHelper.RegisterRace(RPHelper.Race.UNDEAD, "resurrect", { type = "say", text = "I'll need to find a replacement for a part or two." })
RPHelper.RegisterRace(RPHelper.Race.UNDEAD, "resurrect", { type = "say", text = "That hole may be permanent." })
RPHelper.RegisterRace(RPHelper.Race.UNDEAD, "resurrect", { type = "customemote", text = "tests each limb in turn, then lurches upright." })
