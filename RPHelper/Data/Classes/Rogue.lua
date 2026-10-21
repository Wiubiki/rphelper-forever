-- RPHelper Forever - Rogue English content
-- Corpus migration from the RPhelper_twow Rogue catalogue and original RoleplayingHelper lineage.
-- Original contributors: mithyk, crashinbrn

local C = RPHelper.Class.ROGUE
local function add(id, trigger, entryType, text)
    RPHelper.RegisterClass(C, trigger, { id = id, type = entryType, text = text })
end

-- ---------------------------------------------------------------------
-- ENTERCOMBAT
-- ---------------------------------------------------------------------
add("default:class:rogue:0002", "entercombat", "say", "To the death!")
add("default:class:rogue:0003", "entercombat", "say", "Twin blade action, for a clean close shave every time.")
add("default:class:rogue:0004", "entercombat", "say", "My blade can cut through armor, and still cut a tomato.")
add("default:class:rogue:0005", "entercombat", "say", "Bring it on!")
add("default:class:rogue:0006", "entercombat", "say", "Time to play!")
add("default:class:rogue:0007", "entercombat", "say", "You're goin' down!")
add("default:class:rogue:0008", "entercombat", "say", "It's Game Time!")
add("default:class:rogue:0009", "entercombat", "say", "Good luck, you're gonna need it!")
add("default:class:rogue:0010", "entercombat", "say", "{TARGET}, let's dance!")
add("default:class:rogue:0011", "entercombat", "emote", "CHARGE")

-- ---------------------------------------------------------------------
-- LEAVECOMBAT
-- ---------------------------------------------------------------------
add("default:class:rogue:0012", "leavecombat", "say", "Next.")
add("default:class:rogue:0013", "leavecombat", "say", "{TSP}'s down! Who's next?")
add("default:class:rogue:0014", "leavecombat", "say", "{TSP} shouldn't feel bad. Many others have no talent!")
add("default:class:rogue:0015", "leavecombat", "say", "Mess with the best, die like... well, like you just did.")
add("default:class:rogue:0016", "leavecombat", "say", "Keep the change...")
add("default:class:rogue:0017", "leavecombat", "say", "Just curious, why am I so good?")
add("default:class:rogue:0018", "leavecombat", "say", "Erased.")
add("default:class:rogue:0019", "leavecombat", "say", "Denied.")
add("default:class:rogue:0020", "leavecombat", "say", "Anyone else want some?")

-- ---------------------------------------------------------------------
-- DODGE
-- ---------------------------------------------------------------------
add("default:class:rogue:0021", "dodge", "say", "You can't even hit.")

-- ---------------------------------------------------------------------
-- YOUCRIT
-- ---------------------------------------------------------------------
add("default:class:rogue:0022", "youcrit", "say", "And to think, I usually have to work to look this good.")
add("default:class:rogue:0023", "youcrit", "say", "I just can't miss.")
add("default:class:rogue:0024", "youcrit", "say", "If you pay me, I might let you live longer...")
add("default:class:rogue:0025", "youcrit", "say", "Let me introduce you to pain... he's about to become your best friend.")
add("default:class:rogue:0026", "youcrit", "say", "This is where you pucker up and kiss...")
add("default:class:rogue:0027", "youcrit", "say", "What are you going to do? Bleed on me?")
add("default:class:rogue:0028", "youcrit", "say", "Gonna do something or just bleed?")
add("default:class:rogue:0029", "youcrit", "say", "You're gonna die.")
add("default:class:rogue:0030", "youcrit", "say", "I've got a present for ya!")
add("default:class:rogue:0031", "youcrit", "say", "You still want to kill me? Don't mind if I kill you first?")

-- ---------------------------------------------------------------------
-- DEFERRED: LEGACY YOUCRITSPELL (NOT AN ACTIVE GENERIC TRIGGER)
-- ---------------------------------------------------------------------
add("default:class:rogue:0032", "deferred_youcritspell", "say", "And to think, I usually have to work to look this good.")
add("default:class:rogue:0033", "deferred_youcritspell", "say", "I just can't miss.")
add("default:class:rogue:0034", "deferred_youcritspell", "say", "If you pay me, I might let you live longer...")
add("default:class:rogue:0035", "deferred_youcritspell", "say", "Let me introduce you to pain... he's about to become your best friend.")
add("default:class:rogue:0036", "deferred_youcritspell", "say", "This is where you pucker up and kiss...")
add("default:class:rogue:0037", "deferred_youcritspell", "say", "What are you going to do? Bleed on me?")
add("default:class:rogue:0038", "deferred_youcritspell", "say", "Gonna do something or just bleed?")
add("default:class:rogue:0039", "deferred_youcritspell", "say", "You're gonna die.")
add("default:class:rogue:0040", "deferred_youcritspell", "say", "I've got a present for ya!")
add("default:class:rogue:0041", "deferred_youcritspell", "say", "You still want to kill me? Don't mind if I kill you first?")
