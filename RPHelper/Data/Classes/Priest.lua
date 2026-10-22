-- RPHelper Forever - Priest English content
-- Corpus migration from the RPhelper_twow Priest catalogue and original RoleplayingHelper lineage.
-- The legacy Priest source carried no named contributor attribution.

local C = RPHelper.Class.PRIEST
local function add(id, trigger, entryType, text)
    RPHelper.RegisterClass(C, trigger, { id = id, type = entryType, text = text })
end

-- ---------------------------------------------------------------------
-- ENTERCOMBAT
-- ---------------------------------------------------------------------
add("default:class:priest:0002", "entercombat", "say", "The Light guides my hand!")
add("default:class:priest:0003", "entercombat", "say", "Darkness, prepare to be purged!")
add("default:class:priest:0004", "entercombat", "customemote", "raises {PP} staff, calling upon divine power.")

-- ---------------------------------------------------------------------
-- LEAVECOMBAT
-- ---------------------------------------------------------------------
add("default:class:priest:0005", "leavecombat", "say", "May the Light grant us peace once more.")
add("default:class:priest:0006", "leavecombat", "say", "Balance has been restored.")
add("default:class:priest:0007", "leavecombat", "customemote", "lowers {PP} hands, whispering a quiet prayer.")

-- ---------------------------------------------------------------------
-- HURT
-- ---------------------------------------------------------------------
add("default:class:priest:0008", "hurt", "say", "Pain is but a test of faith.")
add("default:class:priest:0009", "hurt", "say", "The Light shall mend me.")
add("default:class:priest:0010", "hurt", "customemote", "winces but steadies {PP} resolve.")

-- ---------------------------------------------------------------------
-- ABSORB
-- ---------------------------------------------------------------------
add("default:class:priest:0011", "absorb", "say", "The Light shields me!")
add("default:class:priest:0012", "absorb", "say", "Your blows are nothing before divine protection!")
add("default:class:priest:0013", "absorb", "customemote", "chants a quiet prayer as a holy barrier absorbs the attack.")

-- ---------------------------------------------------------------------
-- BLOCK
-- ---------------------------------------------------------------------
add("default:class:priest:0014", "block", "say", "Faith deflects your strike!")
add("default:class:priest:0015", "block", "say", "Your weapon falters before the Light!")
add("default:class:priest:0016", "block", "customemote", "raises {PP} staff, deflecting the attack with divine energy.")

-- ---------------------------------------------------------------------
-- DODGE
-- ---------------------------------------------------------------------
add("default:class:priest:0017", "dodge", "say", "The Light grants me swiftness!")
add("default:class:priest:0018", "dodge", "say", "You shall not touch me!")
add("default:class:priest:0019", "dodge", "customemote", "steps gracefully aside, avoiding the attack.")

-- ---------------------------------------------------------------------
-- MISS
-- ---------------------------------------------------------------------
add("default:class:priest:0020", "miss", "say", "Faith makes me untouchable!")
add("default:class:priest:0021", "miss", "say", "The Light guides me away from harm!")
add("default:class:priest:0022", "miss", "customemote", "smiles as the attack fails to connect.")

-- ---------------------------------------------------------------------
-- PARRY
-- ---------------------------------------------------------------------
add("default:class:priest:0023", "parry", "say", "Your darkness cannot break my resolve!")
add("default:class:priest:0024", "parry", "say", "The Light turns aside your attack!")
add("default:class:priest:0025", "parry", "customemote", "redirects the attack with a fluid motion.")

-- ---------------------------------------------------------------------
-- YOUCRIT
-- ---------------------------------------------------------------------
add("default:class:priest:0026", "youcrit", "say", "The Light smites you!")
add("default:class:priest:0027", "youcrit", "say", "Faith fuels my strike!")
add("default:class:priest:0028", "youcrit", "customemote", "lands a decisive blow, divine energy crackling at the impact.")

-- ---------------------------------------------------------------------
-- DEFERRED: LEGACY YOUCRITSPELL (NOT AN ACTIVE GENERIC TRIGGER)
-- ---------------------------------------------------------------------
add("default:class:priest:0029", "deferred_youcritspell", "say", "The heavens answer my call!")
add("default:class:priest:0030", "deferred_youcritspell", "say", "Be purged by divine might!")
add("default:class:priest:0031", "deferred_youcritspell", "customemote", "raises {PP} hands as radiant energy bursts forth.")

-- ---------------------------------------------------------------------
-- YOUHEAL
-- ---------------------------------------------------------------------
add("default:class:priest:0032", "youheal", "say", "The Light soothes your wounds.")
add("default:class:priest:0033", "youheal", "say", "Be blessed with divine grace.")
add("default:class:priest:0034", "youheal", "customemote", "places a hand on {TARGET}, whispering a healing prayer.")

-- ---------------------------------------------------------------------
-- YOUCRITHEAL
-- ---------------------------------------------------------------------
add("default:class:priest:0035", "youcritheal", "say", "A miracle of the Light!")
add("default:class:priest:0036", "youcritheal", "say", "The Light restores you completely!")
add("default:class:priest:0037", "youcritheal", "customemote", "channels overwhelming divine energy, enveloping {TARGET} in a radiant glow.")

-- ---------------------------------------------------------------------
-- PETATTACKSTART
-- ---------------------------------------------------------------------
add("default:class:priest:0038", "petattackstart", "say", "Go forth, {PNAME}, and do my bidding!")
add("default:class:priest:0039", "petattackstart", "say", "Strike down your former allies, {PNAME}!")
add("default:class:priest:0040", "petattackstart", "say", "Your will is mine, {PNAME}! Attack!")
add("default:class:priest:0041", "petattackstart", "customemote", "smirks as {PNAME} turns against {PTNAME}, now a puppet of {PP} will.")

-- ---------------------------------------------------------------------
-- PETATTACKSTOP
-- ---------------------------------------------------------------------
add("default:class:priest:0042", "petattackstop", "say", "Enough, {PNAME}. Your service is no longer required.")
add("default:class:priest:0043", "petattackstop", "say", "You are free once more, {PNAME}... for now.")
add("default:class:priest:0044", "petattackstop", "customemote", "waves a dismissive hand, releasing {PNAME} from {PP} control.")

-- ---------------------------------------------------------------------
-- PETDIES
-- ---------------------------------------------------------------------
add("default:class:priest:0045", "petdies", "say", "Your usefulness has ended, {PNAME}.")
add("default:class:priest:0046", "petdies", "say", "Such a fragile mind, {PNAME}... easily broken.")
add("default:class:priest:0047", "petdies", "customemote", "shrugs as {PNAME} collapses, their mind shattered beyond repair.")

-- ---------------------------------------------------------------------
-- RESURRECT
-- ---------------------------------------------------------------------
add("default:class:priest:0048", "resurrect", "say", "Rise again, for your time is not yet over.")
add("default:class:priest:0049", "resurrect", "say", "The Light calls you back, {TARGET}.")
add("default:class:priest:0050", "resurrect", "say", "Your journey does not end here, {TARGET}.")
add("default:class:priest:0051", "resurrect", "emote", "PRAY")
add("default:class:priest:0052", "resurrect", "customemote", "kneels beside {TARGET}, whispering a sacred prayer as divine energy surrounds them.")
