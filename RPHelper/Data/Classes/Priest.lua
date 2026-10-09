-- RPHelper Forever - Priest English content
-- Corpus migration from the RPhelper_twow Priest catalogue and original RoleplayingHelper lineage.
-- The legacy Priest source carried no named contributor attribution.

local C = RPHelper.Class.PRIEST
local function add(trigger, entryType, text)
    RPHelper.RegisterClass(C, trigger, { type = entryType, text = text })
end

-- ---------------------------------------------------------------------
-- ENTERCOMBAT
-- ---------------------------------------------------------------------
add("entercombat", "say", "The Light guides my hand!")
add("entercombat", "say", "Darkness, prepare to be purged!")

-- ---------------------------------------------------------------------
-- ENTERCOMBAT
-- ---------------------------------------------------------------------
add("entercombat", "customemote", "raises {PP} staff, calling upon divine power.")

-- ---------------------------------------------------------------------
-- LEAVECOMBAT
-- ---------------------------------------------------------------------
add("leavecombat", "say", "May the Light grant us peace once more.")
add("leavecombat", "say", "Balance has been restored.")

-- ---------------------------------------------------------------------
-- LEAVECOMBAT
-- ---------------------------------------------------------------------
add("leavecombat", "customemote", "lowers {PP} hands, whispering a quiet prayer.")

-- ---------------------------------------------------------------------
-- HURT
-- ---------------------------------------------------------------------
add("hurt", "say", "Pain is but a test of faith.")
add("hurt", "say", "The Light shall mend me.")

-- ---------------------------------------------------------------------
-- HURT
-- ---------------------------------------------------------------------
add("hurt", "customemote", "winces but steadies {PP} resolve.")

-- ---------------------------------------------------------------------
-- ABSORB
-- ---------------------------------------------------------------------
add("absorb", "say", "The Light shields me!")
add("absorb", "say", "Your blows are nothing before divine protection!")

-- ---------------------------------------------------------------------
-- ABSORB
-- ---------------------------------------------------------------------
add("absorb", "customemote", "chants a quiet prayer as a holy barrier absorbs the attack.")

-- ---------------------------------------------------------------------
-- BLOCK
-- ---------------------------------------------------------------------
add("block", "say", "Faith deflects your strike!")
add("block", "say", "Your weapon falters before the Light!")

-- ---------------------------------------------------------------------
-- BLOCK
-- ---------------------------------------------------------------------
add("block", "customemote", "raises {PP} staff, deflecting the attack with divine energy.")

-- ---------------------------------------------------------------------
-- DODGE
-- ---------------------------------------------------------------------
add("dodge", "say", "The Light grants me swiftness!")
add("dodge", "say", "You shall not touch me!")

-- ---------------------------------------------------------------------
-- DODGE
-- ---------------------------------------------------------------------
add("dodge", "customemote", "steps gracefully aside, avoiding the attack.")

-- ---------------------------------------------------------------------
-- MISS
-- ---------------------------------------------------------------------
add("miss", "say", "Faith makes me untouchable!")
add("miss", "say", "The Light guides me away from harm!")

-- ---------------------------------------------------------------------
-- MISS
-- ---------------------------------------------------------------------
add("miss", "customemote", "smiles as the attack fails to connect.")

-- ---------------------------------------------------------------------
-- PARRY
-- ---------------------------------------------------------------------
add("parry", "say", "Your darkness cannot break my resolve!")
add("parry", "say", "The Light turns aside your attack!")

-- ---------------------------------------------------------------------
-- PARRY
-- ---------------------------------------------------------------------
add("parry", "customemote", "redirects the attack with a fluid motion.")

-- ---------------------------------------------------------------------
-- YOUCRIT
-- ---------------------------------------------------------------------
add("youcrit", "say", "The Light smites you!")
add("youcrit", "say", "Faith fuels my strike!")

-- ---------------------------------------------------------------------
-- YOUCRIT
-- ---------------------------------------------------------------------
add("youcrit", "customemote", "lands a decisive blow, divine energy crackling at the impact.")

-- ---------------------------------------------------------------------
-- DEFERRED: LEGACY YOUCRITSPELL (NOT AN ACTIVE GENERIC TRIGGER)
-- ---------------------------------------------------------------------
add("deferred_youcritspell", "say", "The heavens answer my call!")
add("deferred_youcritspell", "say", "Be purged by divine might!")

-- ---------------------------------------------------------------------
-- DEFERRED: LEGACY YOUCRITSPELL (NOT AN ACTIVE GENERIC TRIGGER)
-- ---------------------------------------------------------------------
add("deferred_youcritspell", "customemote", "raises {PP} hands as radiant energy bursts forth.")

-- ---------------------------------------------------------------------
-- YOUHEAL
-- ---------------------------------------------------------------------
add("youheal", "say", "The Light soothes your wounds.")
add("youheal", "say", "Be blessed with divine grace.")

-- ---------------------------------------------------------------------
-- YOUHEAL
-- ---------------------------------------------------------------------
add("youheal", "customemote", "places a hand on {TARGET}, whispering a healing prayer.")

-- ---------------------------------------------------------------------
-- YOUCRITHEAL
-- ---------------------------------------------------------------------
add("youcritheal", "say", "A miracle of the Light!")
add("youcritheal", "say", "The Light restores you completely!")

-- ---------------------------------------------------------------------
-- YOUCRITHEAL
-- ---------------------------------------------------------------------
add("youcritheal", "customemote", "channels overwhelming divine energy, enveloping {TARGET} in a radiant glow.")

-- ---------------------------------------------------------------------
-- PETATTACKSTART
-- ---------------------------------------------------------------------
add("petattackstart", "say", "Go forth, {PNAME}, and do my bidding!")
add("petattackstart", "say", "Strike down your former allies, {PNAME}!")
add("petattackstart", "say", "Your will is mine, {PNAME}! Attack!")

-- ---------------------------------------------------------------------
-- PETATTACKSTART
-- ---------------------------------------------------------------------
add("petattackstart", "customemote", "smirks as {PNAME} turns against {PTNAME}, now a puppet of {PP} will.")

-- ---------------------------------------------------------------------
-- PETATTACKSTOP
-- ---------------------------------------------------------------------
add("petattackstop", "say", "Enough, {PNAME}. Your service is no longer required.")
add("petattackstop", "say", "You are free once more, {PNAME}... for now.")

-- ---------------------------------------------------------------------
-- PETATTACKSTOP
-- ---------------------------------------------------------------------
add("petattackstop", "customemote", "waves a dismissive hand, releasing {PNAME} from {PP} control.")

-- ---------------------------------------------------------------------
-- PETDIES
-- ---------------------------------------------------------------------
add("petdies", "say", "Your usefulness has ended, {PNAME}.")
add("petdies", "say", "Such a fragile mind, {PNAME}... easily broken.")

-- ---------------------------------------------------------------------
-- PETDIES
-- ---------------------------------------------------------------------
add("petdies", "customemote", "shrugs as {PNAME} collapses, their mind shattered beyond repair.")

-- ---------------------------------------------------------------------
-- RESURRECT
-- ---------------------------------------------------------------------
add("resurrect", "say", "Rise again, for your time is not yet over.")
add("resurrect", "say", "The Light calls you back, {TARGET}.")
add("resurrect", "say", "Your journey does not end here, {TARGET}.")

-- ---------------------------------------------------------------------
-- RESURRECT
-- ---------------------------------------------------------------------
add("resurrect", "emote", "PRAY")

-- ---------------------------------------------------------------------
-- RESURRECT
-- ---------------------------------------------------------------------
add("resurrect", "customemote", "kneels beside {TARGET}, whispering a sacred prayer as divine energy surrounds them.")
