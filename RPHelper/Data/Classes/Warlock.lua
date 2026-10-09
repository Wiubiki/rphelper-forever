-- RPHelper Forever - Warlock English content
-- Corpus migration from the RPhelper_twow Warlock catalogue and original RoleplayingHelper lineage.
-- The legacy Warlock source carried no named contributor attribution.

local C = RPHelper.Class.WARLOCK
local function add(trigger, entryType, text)
    RPHelper.RegisterClass(C, trigger, { type = entryType, text = text })
end

-- ---------------------------------------------------------------------
-- ENTERCOMBAT
-- ---------------------------------------------------------------------
add("entercombat", "say", "I shall fight fire... with fire.")
add("entercombat", "say", "Chaos boils in my mind.")
add("entercombat", "say", "Your screams will fill the air.")
add("entercombat", "say", "I'll make sure you suffer.")
add("entercombat", "say", "Your pain shall be legendary.")
add("entercombat", "say", "You shall know my wrath.")
add("entercombat", "say", "You offer yourself to me freely; the pact is sealed.")
add("entercombat", "say", "I will bleed you dry!")

-- ---------------------------------------------------------------------
-- ENTERCOMBAT
-- ---------------------------------------------------------------------
add("entercombat", "emote", "FROWN")
add("entercombat", "emote", "GRIN")
add("entercombat", "emote", "GLARE")
add("entercombat", "emote", "GROWL")
add("entercombat", "emote", "WRATH")

-- ---------------------------------------------------------------------
-- ABSORB
-- ---------------------------------------------------------------------
add("absorb", "emote", "GOLFCLAP")

-- ---------------------------------------------------------------------
-- PETATTACKSTART
-- ---------------------------------------------------------------------
add("petattackstart", "say", "Show {PTOP} the meaning of pain, {PNAME}.")
add("petattackstart", "say", "Destroy {PTOP}, {PNAME}.")
add("petattackstart", "say", "Destroy {PTOP} for me, {PNAME}.")
add("petattackstart", "say", "{PNAME}!  I want that soul!")
add("petattackstart", "say", "{PNAME}!  Keep up!")
add("petattackstart", "say", "{PNAME}!  Shred the flesh!")
add("petattackstart", "say", "{PNAME}!  Destroy the husk!")

-- ---------------------------------------------------------------------
-- PETATTACKSTOP
-- ---------------------------------------------------------------------
add("petattackstop", "say", "Try harder {PNAME}.")
add("petattackstop", "say", "Put more effort into it next time {PNAME}.")
add("petattackstop", "say", "Do you ever put real effort into anything {PNAME}?")
add("petattackstop", "say", "Do not attempt to stray from me {PNAME}.")
add("petattackstop", "say", "Well enough, you won't be punished this time {PNAME}.")
add("petattackstop", "say", "Keep it up and you'll feast on a soul this night {PNAME}.")

-- ---------------------------------------------------------------------
-- PETDIES
-- ---------------------------------------------------------------------
add("petdies", "say", "Noooo!")
add("petdies", "say", "And you call yourself a mighty demon after that, {PNAME}?")
add("petdies", "say", "You disappoint me, {PNAME}...")
add("petdies", "say", "Rotten Spawn of the Abyss!")
add("petdies", "say", "{PNAME}, you won't escape me so easily as that!")
add("petdies", "say", "{PNAME}! Get up you useless excuse for demonspawn!")

-- ---------------------------------------------------------------------
-- NPCTALKSFRIEND
-- ---------------------------------------------------------------------
add("npctalksfriend", "say", "You spew {LANG} like urine, {NPC}.")

-- ---------------------------------------------------------------------
-- NPCTALKSENEMY
-- ---------------------------------------------------------------------
add("npctalksenemy", "say", "You spew {LANG} like urine, {NPC}.")

-- ---------------------------------------------------------------------
-- RESURRECT
-- ---------------------------------------------------------------------
add("resurrect", "say", "Life... Death... A cycle unbroken.")

-- ---------------------------------------------------------------------
-- NPC TALK TEMPLATES
-- ---------------------------------------------------------------------
local npcTalkChoices = {
    { "Quiet {NPC}.", "Shut up {NPC}.", "Quit your babbling {NPC}.", "Don't break my peace {NPC}.", "Don't break my concentration {NPC}." },
    { "Unless you hope to", "Unless you want to", "Unless it's your wish to", "Unless it's your desire to", "Or I'll let you know how it feels to", "Or else you'll know how it feels to" },
    { "be sent into the Twisting Nether.", "have your soul drained from you.", "suddenly catch on fire.", "have a shadow bolt in your groin.", "have your face melt off.", "have your tongue burnt out." },
}
for _, trigger in ipairs({ "npctalksfriend", "npctalksenemy" }) do
    RPHelper.RegisterClass(C, trigger, {
        type = "say", template = "{1} {2} {3}", choices = npcTalkChoices,
    })
end
