-- RPHelper Forever - Warlock English content
-- Corpus migration from the RPhelper_twow Warlock catalogue and original RoleplayingHelper lineage.
-- The legacy Warlock source carried no named contributor attribution.

local C = RPHelper.Class.WARLOCK
local function add(id, trigger, entryType, text)
    RPHelper.RegisterClass(C, trigger, { id = id, type = entryType, text = text })
end

-- ---------------------------------------------------------------------
-- ENTERCOMBAT
-- ---------------------------------------------------------------------
add("default:class:warlock:0002", "entercombat", "say", "I shall fight fire... with fire.")
add("default:class:warlock:0003", "entercombat", "say", "Chaos boils in my mind.")
add("default:class:warlock:0004", "entercombat", "say", "Your screams will fill the air.")
add("default:class:warlock:0005", "entercombat", "say", "I'll make sure you suffer.")
add("default:class:warlock:0006", "entercombat", "say", "Your pain shall be legendary.")
add("default:class:warlock:0007", "entercombat", "say", "You shall know my wrath.")
add("default:class:warlock:0008", "entercombat", "say", "You offer yourself to me freely; the pact is sealed.")
add("default:class:warlock:0009", "entercombat", "say", "I will bleed you dry!")
add("default:class:warlock:0010", "entercombat", "emote", "FROWN")
add("default:class:warlock:0011", "entercombat", "emote", "GRIN")
add("default:class:warlock:0012", "entercombat", "emote", "GLARE")
add("default:class:warlock:0013", "entercombat", "emote", "GROWL")
add("default:class:warlock:0014", "entercombat", "emote", "WRATH")

-- ---------------------------------------------------------------------
-- ABSORB
-- ---------------------------------------------------------------------
add("default:class:warlock:0015", "absorb", "emote", "GOLFCLAP")

-- ---------------------------------------------------------------------
-- PETATTACKSTART
-- ---------------------------------------------------------------------
add("default:class:warlock:0016", "petattackstart", "say", "Show {PTOP} the meaning of pain, {PNAME}.")
add("default:class:warlock:0017", "petattackstart", "say", "Destroy {PTOP}, {PNAME}.")
add("default:class:warlock:0018", "petattackstart", "say", "Destroy {PTOP} for me, {PNAME}.")
add("default:class:warlock:0019", "petattackstart", "say", "{PNAME}!  I want that soul!")
add("default:class:warlock:0020", "petattackstart", "say", "{PNAME}!  Keep up!")
add("default:class:warlock:0021", "petattackstart", "say", "{PNAME}!  Shred the flesh!")
add("default:class:warlock:0022", "petattackstart", "say", "{PNAME}!  Destroy the husk!")

-- ---------------------------------------------------------------------
-- PETATTACKSTOP
-- ---------------------------------------------------------------------
add("default:class:warlock:0023", "petattackstop", "say", "Try harder {PNAME}.")
add("default:class:warlock:0024", "petattackstop", "say", "Put more effort into it next time {PNAME}.")
add("default:class:warlock:0025", "petattackstop", "say", "Do you ever put real effort into anything {PNAME}?")
add("default:class:warlock:0026", "petattackstop", "say", "Do not attempt to stray from me {PNAME}.")
add("default:class:warlock:0027", "petattackstop", "say", "Well enough, you won't be punished this time {PNAME}.")
add("default:class:warlock:0028", "petattackstop", "say", "Keep it up and you'll feast on a soul this night {PNAME}.")

-- ---------------------------------------------------------------------
-- PETDIES
-- ---------------------------------------------------------------------
add("default:class:warlock:0029", "petdies", "say", "Noooo!")
add("default:class:warlock:0030", "petdies", "say", "And you call yourself a mighty demon after that, {PNAME}?")
add("default:class:warlock:0031", "petdies", "say", "You disappoint me, {PNAME}...")
add("default:class:warlock:0032", "petdies", "say", "Rotten Spawn of the Abyss!")
add("default:class:warlock:0033", "petdies", "say", "{PNAME}, you won't escape me so easily as that!")
add("default:class:warlock:0034", "petdies", "say", "{PNAME}! Get up you useless excuse for demonspawn!")

-- ---------------------------------------------------------------------
-- NPCTALKSFRIEND
-- ---------------------------------------------------------------------
add("default:class:warlock:0035", "npctalksfriend", "say", "You spew {LANG} like urine, {NPC}.")

-- ---------------------------------------------------------------------
-- NPCTALKSENEMY
-- ---------------------------------------------------------------------
add("default:class:warlock:0036", "npctalksenemy", "say", "You spew {LANG} like urine, {NPC}.")

-- ---------------------------------------------------------------------
-- RESURRECT
-- ---------------------------------------------------------------------
add("default:class:warlock:0037", "resurrect", "say", "Life... Death... A cycle unbroken.")

-- ---------------------------------------------------------------------
-- NPC TALK TEMPLATES
-- ---------------------------------------------------------------------
local npcTalkChoices = {
    { "Quiet {NPC}.", "Shut up {NPC}.", "Quit your babbling {NPC}.", "Don't break my peace {NPC}.", "Don't break my concentration {NPC}." },
    { "Unless you hope to", "Unless you want to", "Unless it's your wish to", "Unless it's your desire to", "Or I'll let you know how it feels to", "Or else you'll know how it feels to" },
    { "be sent into the Twisting Nether.", "have your soul drained from you.", "suddenly catch on fire.", "have a shadow bolt in your groin.", "have your face melt off.", "have your tongue burnt out." },
}
local npcTalkIDs = {
    npctalksfriend = "default:class:warlock:0038:friend",
    npctalksenemy = "default:class:warlock:0038:enemy",
}
for _, trigger in ipairs({ "npctalksfriend", "npctalksenemy" }) do
    RPHelper.RegisterClass(C, trigger, {
        id = npcTalkIDs[trigger],
        type = "say", template = "{1} {2} {3}", choices = npcTalkChoices,
    })
end
