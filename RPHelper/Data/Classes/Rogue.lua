-- RPHelper Forever - Rogue English content
-- Corpus migration from the RPhelper_twow Rogue catalogue and original RoleplayingHelper lineage.
-- Original contributors: mithyk, crashinbrn

local C = RPHelper.Class.ROGUE
local function add(trigger, entryType, text)
    RPHelper.RegisterClass(C, trigger, { type = entryType, text = text })
end

-- ---------------------------------------------------------------------
-- ENTERCOMBAT
-- ---------------------------------------------------------------------
add("entercombat", "say", "To the death!")
add("entercombat", "say", "Twin blade action, for a clean close shave every time.")
add("entercombat", "say", "My blade can cut through armor, and still cut a tomato.")
add("entercombat", "say", "Bring it on!")
add("entercombat", "say", "Time to play!")
add("entercombat", "say", "You're goin' down!")
add("entercombat", "say", "It's Game Time!")
add("entercombat", "say", "Good luck, you're gonna need it!")
add("entercombat", "say", "{TARGET}, let's dance!")

-- ---------------------------------------------------------------------
-- ENTERCOMBAT
-- ---------------------------------------------------------------------
add("entercombat", "emote", "CHARGE")

-- ---------------------------------------------------------------------
-- LEAVECOMBAT
-- ---------------------------------------------------------------------
add("leavecombat", "say", "Next.")
add("leavecombat", "say", "{TSP}'s down! Who's next?")
add("leavecombat", "say", "{TSP} shouldn't feel bad. Many others have no talent!")
add("leavecombat", "say", "Mess with the best, die like... well, like you just did.")
add("leavecombat", "say", "Keep the change...")
add("leavecombat", "say", "Just curious, why am I so good?")
add("leavecombat", "say", "Erased.")
add("leavecombat", "say", "Denied.")
add("leavecombat", "say", "Anyone else want some?")

-- ---------------------------------------------------------------------
-- DODGE
-- ---------------------------------------------------------------------
add("dodge", "say", "You can't even hit.")

-- ---------------------------------------------------------------------
-- YOUCRIT
-- ---------------------------------------------------------------------
add("youcrit", "say", "And to think, I usually have to work to look this good.")
add("youcrit", "say", "I just can't miss.")
add("youcrit", "say", "If you pay me, I might let you live longer...")
add("youcrit", "say", "Let me introduce you to pain... he's about to become your best friend.")
add("youcrit", "say", "This is where you pucker up and kiss...")
add("youcrit", "say", "What are you going to do? Bleed on me?")
add("youcrit", "say", "Gonna do something or just bleed?")
add("youcrit", "say", "You're gonna die.")
add("youcrit", "say", "I've got a present for ya!")
add("youcrit", "say", "You still want to kill me? Don't mind if I kill you first?")

-- ---------------------------------------------------------------------
-- DEFERRED: LEGACY YOUCRITSPELL (NOT AN ACTIVE GENERIC TRIGGER)
-- ---------------------------------------------------------------------
add("deferred_youcritspell", "say", "And to think, I usually have to work to look this good.")
add("deferred_youcritspell", "say", "I just can't miss.")
add("deferred_youcritspell", "say", "If you pay me, I might let you live longer...")
add("deferred_youcritspell", "say", "Let me introduce you to pain... he's about to become your best friend.")
add("deferred_youcritspell", "say", "This is where you pucker up and kiss...")
add("deferred_youcritspell", "say", "What are you going to do? Bleed on me?")
add("deferred_youcritspell", "say", "Gonna do something or just bleed?")
add("deferred_youcritspell", "say", "You're gonna die.")
add("deferred_youcritspell", "say", "I've got a present for ya!")
add("deferred_youcritspell", "say", "You still want to kill me? Don't mind if I kill you first?")
