-- RPHelper Forever - Generic English content
-- Based in part on the original RoleplayingHelper content lineage.
-- Original contributors: mithyk, Syrsa
-- Additional adaptation and new content: Wiubiki

-- ---------------------------------------------------------------------
-- ENTER COMBAT
-- ---------------------------------------------------------------------

RPHelper.RegisterGeneric("entercombat", { id = "default:generic:0001", type = "say", text = "So be it." })
RPHelper.RegisterGeneric("entercombat", { id = "default:generic:0002", type = "say", text = "You chose this." })
RPHelper.RegisterGeneric("entercombat", { id = "default:generic:0003", type = "say", text = "Come on, then." })
RPHelper.RegisterGeneric("entercombat", { id = "default:generic:0004", type = "say", text = "Let's finish this." })
RPHelper.RegisterGeneric("entercombat", { id = "default:generic:0005", type = "say", text = "Have it your way." })
RPHelper.RegisterGeneric("entercombat", { id = "default:generic:0006", type = "say", text = "Very well." })
RPHelper.RegisterGeneric("entercombat", { id = "default:generic:0007", type = "say", text = "Then we fight." })
RPHelper.RegisterGeneric("entercombat", { id = "default:generic:0008", type = "say", text = "Let us settle this." })
RPHelper.RegisterGeneric("entercombat", { id = "default:generic:0009", type = "customemote", text = "sets their stance and prepares for the fight." })
RPHelper.RegisterGeneric("entercombat", { id = "default:generic:0010", type = "customemote", text = "squares up to meet the threat." })
RPHelper.RegisterGeneric("entercombat", { id = "default:generic:0011", type = "customemote", text = "steadies themselves and turns to face the enemy." })
RPHelper.RegisterGeneric("entercombat", { id = "default:generic:0012", type = "customemote", text = "shifts into a ready stance." })
RPHelper.RegisterGeneric("entercombat", { id = "default:generic:0013", type = "customemote", text = "sets their jaw and prepares for violence." })
RPHelper.RegisterGeneric("entercombat", { id = "default:generic:0014", type = "customemote", text = "focuses their attention on the coming fight." })

-- ---------------------------------------------------------------------
-- LEAVE COMBAT
-- ---------------------------------------------------------------------

RPHelper.RegisterGeneric("leavecombat", { id = "default:generic:0015", type = "say", text = "That's done." })
RPHelper.RegisterGeneric("leavecombat", { id = "default:generic:0016", type = "say", text = "It's over." })
RPHelper.RegisterGeneric("leavecombat", { id = "default:generic:0017", type = "say", text = "Finished." })
RPHelper.RegisterGeneric("leavecombat", { id = "default:generic:0018", type = "say", text = "That settles it." })
RPHelper.RegisterGeneric("leavecombat", { id = "default:generic:0019", type = "say", text = "We're done here." })
RPHelper.RegisterGeneric("leavecombat", { id = "default:generic:0020", type = "say", text = "That should be the last of them." })
RPHelper.RegisterGeneric("leavecombat", { id = "default:generic:0021", type = "customemote", text = "lowers their guard and surveys the aftermath." })
RPHelper.RegisterGeneric("leavecombat", { id = "default:generic:0022", type = "customemote", text = "relaxes slightly as the immediate danger passes." })
RPHelper.RegisterGeneric("leavecombat", { id = "default:generic:0023", type = "customemote", text = "takes a moment to steady their breathing." })
RPHelper.RegisterGeneric("leavecombat", { id = "default:generic:0024", type = "customemote", text = "looks over the battlefield once the fighting ends." })
RPHelper.RegisterGeneric("leavecombat", { id = "default:generic:0025", type = "customemote", text = "eases out of their fighting stance." })
RPHelper.RegisterGeneric("leavecombat", { id = "default:generic:0026", type = "customemote", text = "checks their surroundings for any remaining threat." })

-- ---------------------------------------------------------------------
-- HURT
-- ---------------------------------------------------------------------

RPHelper.RegisterGeneric("hurt", { id = "default:generic:0027", type = "say", text = "That one found its mark!" })
RPHelper.RegisterGeneric("hurt", { id = "default:generic:0028", type = "say", text = "I can still fight." })
RPHelper.RegisterGeneric("hurt", { id = "default:generic:0029", type = "customemote", text = "recoils from the blow." })
RPHelper.RegisterGeneric("hurt", { id = "default:generic:0030", type = "customemote", text = "grimaces and fights to keep their footing." })
RPHelper.RegisterGeneric("hurt", { id = "default:generic:0031", type = "customemote", text = "staggers briefly before recovering their stance." })

-- ---------------------------------------------------------------------
-- ABSORB
-- ---------------------------------------------------------------------

RPHelper.RegisterGeneric("absorb", { id = "default:generic:0032", type = "say", text = "Didn't even scratch me!" })
RPHelper.RegisterGeneric("absorb", { id = "default:generic:0033", type = "say", text = "I barely felt that." })
RPHelper.RegisterGeneric("absorb", { id = "default:generic:0034", type = "say", text = "That did nothing." })
RPHelper.RegisterGeneric("absorb", { id = "default:generic:0035", type = "customemote", text = "stands untouched behind their protection." })
RPHelper.RegisterGeneric("absorb", { id = "default:generic:0036", type = "customemote", text = "remains unharmed as the attack washes over their protection." })

-- ---------------------------------------------------------------------
-- MISS
-- ---------------------------------------------------------------------

RPHelper.RegisterGeneric("miss", { id = "default:generic:0037", type = "say", text = "Missed me!" })
RPHelper.RegisterGeneric("miss", { id = "default:generic:0038", type = "say", text = "That one breezed right by me." })
RPHelper.RegisterGeneric("miss", { id = "default:generic:0039", type = "say", text = "You're supposed to hit me." })
RPHelper.RegisterGeneric("miss", { id = "default:generic:0040", type = "say", text = "Not even close." })
RPHelper.RegisterGeneric("miss", { id = "default:generic:0041", type = "customemote", text = "watches the attack pass harmlessly by." })
RPHelper.RegisterGeneric("miss", { id = "default:generic:0042", type = "customemote", text = "holds their ground as the attack finds only empty air." })

-- ---------------------------------------------------------------------
-- DODGE
-- ---------------------------------------------------------------------

RPHelper.RegisterGeneric("dodge", { id = "default:generic:0043", type = "say", text = "Too slow." })
RPHelper.RegisterGeneric("dodge", { id = "default:generic:0044", type = "say", text = "Missed me." })
RPHelper.RegisterGeneric("dodge", { id = "default:generic:0045", type = "say", text = "You'll have to be quicker than that." })
RPHelper.RegisterGeneric("dodge", { id = "default:generic:0046", type = "say", text = "Won't catch me standing still." })
RPHelper.RegisterGeneric("dodge", { id = "default:generic:0047", type = "say", text = "At least try to hit me." })
RPHelper.RegisterGeneric("dodge", { id = "default:generic:0048", type = "say", text = "You call that an attack?" })
RPHelper.RegisterGeneric("dodge", { id = "default:generic:0049", type = "say", text = "Try aiming next time." })
RPHelper.RegisterGeneric("dodge", { id = "default:generic:0050", type = "say", text = "Over here." })
RPHelper.RegisterGeneric("dodge", { id = "default:generic:0051", type = "say", text = "Not even close." })
RPHelper.RegisterGeneric("dodge", { id = "default:generic:0052", type = "customemote", text = "shifts aside just before the blow lands." })
RPHelper.RegisterGeneric("dodge", { id = "default:generic:0053", type = "customemote", text = "twists neatly out of the path of the attack." })
RPHelper.RegisterGeneric("dodge", { id = "default:generic:0054", type = "customemote", text = "steps clear of the strike at the last moment." })
RPHelper.RegisterGeneric("dodge", { id = "default:generic:0055", type = "customemote", text = "slips beyond the attacker's reach." })
RPHelper.RegisterGeneric("dodge", { id = "default:generic:0056", type = "customemote", text = "leans away as the attack cuts through empty air." })
RPHelper.RegisterGeneric("dodge", { id = "default:generic:0057", type = "customemote", text = "moves just enough to let the attack pass harmlessly by." })
RPHelper.RegisterGeneric("dodge", { id = "default:generic:0058", type = "customemote", text = "sidesteps the incoming attack with practiced timing." })

-- ---------------------------------------------------------------------
-- PARRY
-- ---------------------------------------------------------------------

RPHelper.RegisterGeneric("parry", { id = "default:generic:0059", type = "say", text = "Too easy." })
RPHelper.RegisterGeneric("parry", { id = "default:generic:0060", type = "say", text = "Intercepted!" })
RPHelper.RegisterGeneric("parry", { id = "default:generic:0061", type = "say", text = "You'll have to do better than that." })
RPHelper.RegisterGeneric("parry", { id = "default:generic:0062", type = "say", text = "Not good enough." })
RPHelper.RegisterGeneric("parry", { id = "default:generic:0063", type = "say", text = "Try again." })
RPHelper.RegisterGeneric("parry", { id = "default:generic:0064", type = "say", text = "Predictable." })
RPHelper.RegisterGeneric("parry", { id = "default:generic:0065", type = "say", text = "That won't work twice." })
RPHelper.RegisterGeneric("parry", { id = "default:generic:0066", type = "say", text = "Denied." })
RPHelper.RegisterGeneric("parry", { id = "default:generic:0067", type = "customemote", text = "turns the incoming strike aside with a sharp movement." })
RPHelper.RegisterGeneric("parry", { id = "default:generic:0068", type = "customemote", text = "catches the attack and redirects it away." })
RPHelper.RegisterGeneric("parry", { id = "default:generic:0069", type = "customemote", text = "deflects the blow with practiced timing." })
RPHelper.RegisterGeneric("parry", { id = "default:generic:0070", type = "customemote", text = "meets the strike and knocks it aside." })
RPHelper.RegisterGeneric("parry", { id = "default:generic:0071", type = "customemote", text = "guides the attack harmlessly past." })
RPHelper.RegisterGeneric("parry", { id = "default:generic:0072", type = "customemote", text = "turns the weapon aside and resets their guard." })

-- ---------------------------------------------------------------------
-- BLOCK
-- ---------------------------------------------------------------------

RPHelper.RegisterGeneric("block", { id = "default:generic:0073", type = "say", text = "Blocked." })
RPHelper.RegisterGeneric("block", { id = "default:generic:0074", type = "say", text = "You'll need more than that." })
RPHelper.RegisterGeneric("block", { id = "default:generic:0075", type = "say", text = "My guard holds." })
RPHelper.RegisterGeneric("block", { id = "default:generic:0076", type = "say", text = "Not getting through." })
RPHelper.RegisterGeneric("block", { id = "default:generic:0077", type = "say", text = "Try harder." })
RPHelper.RegisterGeneric("block", { id = "default:generic:0078", type = "say", text = "That all you've got?" })
RPHelper.RegisterGeneric("block", { id = "default:generic:0079", type = "say", text = "No blow shall pass!" })
RPHelper.RegisterGeneric("block", { id = "default:generic:0080", type = "say", text = "You'll have to break through first." })
RPHelper.RegisterGeneric("block", { id = "default:generic:0081", type = "say", text = "What did my shield do to deserve that?" })
RPHelper.RegisterGeneric("block", { id = "default:generic:0082", type = "customemote", text = "braces and catches the blow on their guard." })
RPHelper.RegisterGeneric("block", { id = "default:generic:0083", type = "customemote", text = "absorbs the impact behind a firm guard." })
RPHelper.RegisterGeneric("block", { id = "default:generic:0084", type = "customemote", text = "meets the strike head-on and holds." })
RPHelper.RegisterGeneric("block", { id = "default:generic:0085", type = "customemote", text = "sets their guard and turns the blow aside." })
RPHelper.RegisterGeneric("block", { id = "default:generic:0086", type = "customemote", text = "takes the impact on their defence without yielding." })
RPHelper.RegisterGeneric("block", { id = "default:generic:0087", type = "customemote", text = "plants their feet and stops the strike cold." })

-- ---------------------------------------------------------------------
-- OFFENSIVE CRITICAL HIT
-- ---------------------------------------------------------------------

RPHelper.RegisterGeneric("youcrit", { id = "default:generic:0088", type = "say", text = "That looked like it hurt." })
RPHelper.RegisterGeneric("youcrit", { id = "default:generic:0089", type = "say", text = "Did that hurt?" })
RPHelper.RegisterGeneric("youcrit", { id = "default:generic:0090", type = "say", text = "Oh, I'll bet that hurt." })
RPHelper.RegisterGeneric("youcrit", { id = "default:generic:0091", type = "say", text = "Felt that one, didn't you?" })
RPHelper.RegisterGeneric("youcrit", { id = "default:generic:0092", type = "say", text = "That got your attention." })
RPHelper.RegisterGeneric("youcrit", { id = "default:generic:0093", type = "say", text = "That should leave a mark." })
RPHelper.RegisterGeneric("youcrit", { id = "default:generic:0094", type = "say", text = "That struck true." })
RPHelper.RegisterGeneric("youcrit", { id = "default:generic:0095", type = "say", text = "Right where I wanted it." })
RPHelper.RegisterGeneric("youcrit", { id = "default:generic:0096", type = "say", text = "A clean hit!" })
RPHelper.RegisterGeneric("youcrit", { id = "default:generic:0097", type = "emote", text = "LAUGH" })
RPHelper.RegisterGeneric("youcrit", { id = "default:generic:0098", type = "emote", text = "SMIRK" })
RPHelper.RegisterGeneric("youcrit", { id = "default:generic:0099", type = "customemote", text = "flashes a satisfied grin as the attack hits with unusual force." })
RPHelper.RegisterGeneric("youcrit", { id = "default:generic:0100", type = "customemote", text = "presses the advantage after the powerful hit." })
RPHelper.RegisterGeneric("youcrit", { id = "default:generic:0101", type = "customemote", text = "allows a brief smirk as the attack finds its mark." })
RPHelper.RegisterGeneric("youcrit", { id = "default:generic:0102", type = "customemote", text = "seems pleased by the force of the impact." })
RPHelper.RegisterGeneric("youcrit", { id = "default:generic:0103", type = "customemote", text = "watches with satisfaction as the attack hits home." })
RPHelper.RegisterGeneric("youcrit", { id = "default:generic:0104", type = "customemote", text = "holds their focus as the attack lands with devastating precision." })

-- ---------------------------------------------------------------------
-- DEATH
-- ---------------------------------------------------------------------

RPHelper.RegisterGeneric("death", { id = "default:generic:0105", type = "say", text = "This cannot be the end..." })
RPHelper.RegisterGeneric("death", { id = "default:generic:0106", type = "say", text = "I have failed..." })
RPHelper.RegisterGeneric("death", { id = "default:generic:0107", type = "say", text = "Not... yet..." })
RPHelper.RegisterGeneric("death", { id = "default:generic:0108", type = "say", text = "I... wasn't finished..." })
RPHelper.RegisterGeneric("death", { id = "default:generic:0109", type = "say", text = "No..." })
RPHelper.RegisterGeneric("death", { id = "default:generic:0110", type = "say", text = "This can't be..." })
RPHelper.RegisterGeneric("death", { id = "default:generic:0111", type = "customemote", text = "staggers and collapses to the ground." })
RPHelper.RegisterGeneric("death", { id = "default:generic:0112", type = "customemote", text = "falters before finally falling still." })
RPHelper.RegisterGeneric("death", { id = "default:generic:0113", type = "customemote", text = "drops heavily as the last of their strength gives out." })
RPHelper.RegisterGeneric("death", { id = "default:generic:0114", type = "customemote", text = "crumples to the ground, their strength spent." })
RPHelper.RegisterGeneric("death", { id = "default:generic:0115", type = "customemote", text = "falls silent as their body gives way." })

-- ---------------------------------------------------------------------
-- RESURRECT
-- ---------------------------------------------------------------------

RPHelper.RegisterGeneric("resurrect", { id = "default:generic:0116", type = "say", text = "I'm alive!" })
RPHelper.RegisterGeneric("resurrect", { id = "default:generic:0117", type = "say", text = "Huh? Wha? How'd I get here?" })
RPHelper.RegisterGeneric("resurrect", { id = "default:generic:0118", type = "say", text = "That was unpleasant." })
RPHelper.RegisterGeneric("resurrect", { id = "default:generic:0119", type = "say", text = "I'm... back?" })
RPHelper.RegisterGeneric("resurrect", { id = "default:generic:0120", type = "say", text = "Not dead yet, then." })
RPHelper.RegisterGeneric("resurrect", { id = "default:generic:0121", type = "say", text = "I thought that was the end." })
RPHelper.RegisterGeneric("resurrect", { id = "default:generic:0122", type = "say", text = "Back among the living." })
RPHelper.RegisterGeneric("resurrect", { id = "default:generic:0123", type = "say", text = "Remind me not to do that again." })
RPHelper.RegisterGeneric("resurrect", { id = "default:generic:0124", type = "customemote", text = "draws a sudden breath and slowly regains their bearings." })
RPHelper.RegisterGeneric("resurrect", { id = "default:generic:0125", type = "customemote", text = "stirs again, looking briefly disoriented." })
RPHelper.RegisterGeneric("resurrect", { id = "default:generic:0126", type = "customemote", text = "opens their eyes and takes a moment to understand where they are." })
RPHelper.RegisterGeneric("resurrect", { id = "default:generic:0127", type = "customemote", text = "returns to awareness with a sharp intake of breath." })
RPHelper.RegisterGeneric("resurrect", { id = "default:generic:0128", type = "customemote", text = "slowly rises, still shaken by the experience." })
RPHelper.RegisterGeneric("resurrect", { id = "default:generic:0129", type = "customemote", text = "checks themselves over as life returns to their body." })

-- ---------------------------------------------------------------------
-- MONSTER CALLS FOR HELP
-- ---------------------------------------------------------------------

RPHelper.RegisterGeneric("monster_emote_help", { id = "default:generic:0130", type = "say", text = "Calling for help? I don't think so." })
RPHelper.RegisterGeneric("monster_emote_help", { id = "default:generic:0131", type = "say", text = "It's too late for you now." })
RPHelper.RegisterGeneric("monster_emote_help", { id = "default:generic:0132", type = "say", text = "Call all you like." })
RPHelper.RegisterGeneric("monster_emote_help", { id = "default:generic:0133", type = "say", text = "No one is coming to save you." })
RPHelper.RegisterGeneric("monster_emote_help", { id = "default:generic:0134", type = "say", text = "We should finish this quickly." })
RPHelper.RegisterGeneric("monster_emote_help", { id = "default:generic:0135", type = "customemote", text = "glances around for approaching reinforcements." })
RPHelper.RegisterGeneric("monster_emote_help", { id = "default:generic:0136", type = "customemote", text = "presses the attack before help can arrive." })
RPHelper.RegisterGeneric("monster_emote_help", { id = "default:generic:0137", type = "customemote", text = "looks toward the source of the answering cries." })

-- ---------------------------------------------------------------------
-- MONSTER RUNS IN FEAR
-- ---------------------------------------------------------------------

RPHelper.RegisterGeneric("monster_emote_fear", { id = "default:generic:0138", type = "say", text = "Run away, coward!" })
RPHelper.RegisterGeneric("monster_emote_fear", { id = "default:generic:0139", type = "say", text = "Come back here!" })
RPHelper.RegisterGeneric("monster_emote_fear", { id = "default:generic:0140", type = "say", text = "Where do you think you're going?" })
RPHelper.RegisterGeneric("monster_emote_fear", { id = "default:generic:0141", type = "say", text = "Don't let it escape!" })
RPHelper.RegisterGeneric("monster_emote_fear", { id = "default:generic:0142", type = "say", text = "It's fleeing!" })
RPHelper.RegisterGeneric("monster_emote_fear", { id = "default:generic:0143", type = "emote", text = "CHICKEN" })
RPHelper.RegisterGeneric("monster_emote_fear", { id = "default:generic:0144", type = "customemote", text = "moves to pursue the fleeing enemy." })
RPHelper.RegisterGeneric("monster_emote_fear", { id = "default:generic:0145", type = "customemote", text = "watches the enemy turn and flee." })
RPHelper.RegisterGeneric("monster_emote_fear", { id = "default:generic:0146", type = "customemote", text = "points after the fleeing enemy." })

-- ---------------------------------------------------------------------
-- MONSTER BECOMES ENRAGED
-- ---------------------------------------------------------------------

RPHelper.RegisterGeneric("monster_emote_enrage", { id = "default:generic:0147", type = "say", text = "It's enraged!" })
RPHelper.RegisterGeneric("monster_emote_enrage", { id = "default:generic:0148", type = "say", text = "Careful - it just got angrier." })
RPHelper.RegisterGeneric("monster_emote_enrage", { id = "default:generic:0149", type = "say", text = "Watch yourself!" })
RPHelper.RegisterGeneric("monster_emote_enrage", { id = "default:generic:0150", type = "say", text = "Here it comes!" })
RPHelper.RegisterGeneric("monster_emote_enrage", { id = "default:generic:0151", type = "say", text = "Enraged? Oh, I'm so scared." })
RPHelper.RegisterGeneric("monster_emote_enrage", { id = "default:generic:0152", type = "customemote", text = "steadies themselves as the enemy flies into a rage." })
RPHelper.RegisterGeneric("monster_emote_enrage", { id = "default:generic:0153", type = "customemote", text = "raises their guard against the enraged enemy." })
RPHelper.RegisterGeneric("monster_emote_enrage", { id = "default:generic:0154", type = "customemote", text = "watches the enraged enemy warily." })
RPHelper.RegisterGeneric("monster_emote_enrage", { id = "default:generic:0155", type = "customemote", text = "shakes in their boots." })
