-- RPHelper Forever - Generic English content
-- Based in part on the original RoleplayingHelper content lineage.
-- Original contributors: mithyk, Syrsa
-- Additional adaptation and new content: Wiubiki

-- ---------------------------------------------------------------------
-- ENTER COMBAT
-- ---------------------------------------------------------------------

RPHelper.RegisterGeneric("entercombat", { type = "say", text = "So be it." })
RPHelper.RegisterGeneric("entercombat", { type = "say", text = "You chose this." })
RPHelper.RegisterGeneric("entercombat", { type = "say", text = "Come on, then." })
RPHelper.RegisterGeneric("entercombat", { type = "say", text = "Let's finish this." })
RPHelper.RegisterGeneric("entercombat", { type = "say", text = "Have it your way." })
RPHelper.RegisterGeneric("entercombat", { type = "say", text = "Very well." })
RPHelper.RegisterGeneric("entercombat", { type = "say", text = "Then we fight." })
RPHelper.RegisterGeneric("entercombat", { type = "say", text = "Let us settle this." })
RPHelper.RegisterGeneric("entercombat", { type = "customemote", text = "sets their stance and prepares for the fight." })
RPHelper.RegisterGeneric("entercombat", { type = "customemote", text = "squares up to meet the threat." })
RPHelper.RegisterGeneric("entercombat", { type = "customemote", text = "steadies themselves and turns to face the enemy." })
RPHelper.RegisterGeneric("entercombat", { type = "customemote", text = "shifts into a ready stance." })
RPHelper.RegisterGeneric("entercombat", { type = "customemote", text = "sets their jaw and prepares for violence." })
RPHelper.RegisterGeneric("entercombat", { type = "customemote", text = "focuses their attention on the coming fight." })

-- ---------------------------------------------------------------------
-- LEAVE COMBAT
-- ---------------------------------------------------------------------

RPHelper.RegisterGeneric("leavecombat", { type = "say", text = "That's done." })
RPHelper.RegisterGeneric("leavecombat", { type = "say", text = "It's over." })
RPHelper.RegisterGeneric("leavecombat", { type = "say", text = "Finished." })
RPHelper.RegisterGeneric("leavecombat", { type = "say", text = "That settles it." })
RPHelper.RegisterGeneric("leavecombat", { type = "say", text = "We're done here." })
RPHelper.RegisterGeneric("leavecombat", { type = "say", text = "That should be the last of them." })
RPHelper.RegisterGeneric("leavecombat", { type = "customemote", text = "lowers their guard and surveys the aftermath." })
RPHelper.RegisterGeneric("leavecombat", { type = "customemote", text = "relaxes slightly as the immediate danger passes." })
RPHelper.RegisterGeneric("leavecombat", { type = "customemote", text = "takes a moment to steady their breathing." })
RPHelper.RegisterGeneric("leavecombat", { type = "customemote", text = "looks over the battlefield once the fighting ends." })
RPHelper.RegisterGeneric("leavecombat", { type = "customemote", text = "eases out of their fighting stance." })
RPHelper.RegisterGeneric("leavecombat", { type = "customemote", text = "checks their surroundings for any remaining threat." })

-- ---------------------------------------------------------------------
-- HURT
-- ---------------------------------------------------------------------

RPHelper.RegisterGeneric("hurt", { type = "say", text = "That one found its mark!" })
RPHelper.RegisterGeneric("hurt", { type = "say", text = "I can still fight." })
RPHelper.RegisterGeneric("hurt", { type = "customemote", text = "recoils from the blow." })
RPHelper.RegisterGeneric("hurt", { type = "customemote", text = "grimaces and fights to keep their footing." })
RPHelper.RegisterGeneric("hurt", { type = "customemote", text = "staggers briefly before recovering their stance." })

-- ---------------------------------------------------------------------
-- ABSORB
-- ---------------------------------------------------------------------

RPHelper.RegisterGeneric("absorb", { type = "say", text = "Didn't even scratch me!" })
RPHelper.RegisterGeneric("absorb", { type = "say", text = "I barely felt that." })
RPHelper.RegisterGeneric("absorb", { type = "say", text = "That did nothing." })
RPHelper.RegisterGeneric("absorb", { type = "customemote", text = "stands untouched behind their protection." })
RPHelper.RegisterGeneric("absorb", { type = "customemote", text = "remains unharmed as the attack washes over their protection." })

-- ---------------------------------------------------------------------
-- MISS
-- ---------------------------------------------------------------------

RPHelper.RegisterGeneric("miss", { type = "say", text = "Missed me!" })
RPHelper.RegisterGeneric("miss", { type = "say", text = "That one breezed right by me." })
RPHelper.RegisterGeneric("miss", { type = "say", text = "You're supposed to hit me." })
RPHelper.RegisterGeneric("miss", { type = "say", text = "Not even close." })
RPHelper.RegisterGeneric("miss", { type = "customemote", text = "watches the attack pass harmlessly by." })
RPHelper.RegisterGeneric("miss", { type = "customemote", text = "holds their ground as the attack finds only empty air." })

-- ---------------------------------------------------------------------
-- DODGE
-- ---------------------------------------------------------------------

RPHelper.RegisterGeneric("dodge", { type = "say", text = "Too slow." })
RPHelper.RegisterGeneric("dodge", { type = "say", text = "Missed me." })
RPHelper.RegisterGeneric("dodge", { type = "say", text = "You'll have to be quicker than that." })
RPHelper.RegisterGeneric("dodge", { type = "say", text = "Won't catch me standing still." })
RPHelper.RegisterGeneric("dodge", { type = "say", text = "At least try to hit me." })
RPHelper.RegisterGeneric("dodge", { type = "say", text = "You call that an attack?" })
RPHelper.RegisterGeneric("dodge", { type = "say", text = "Try aiming next time." })
RPHelper.RegisterGeneric("dodge", { type = "say", text = "Over here." })
RPHelper.RegisterGeneric("dodge", { type = "say", text = "Not even close." })
RPHelper.RegisterGeneric("dodge", { type = "customemote", text = "shifts aside just before the blow lands." })
RPHelper.RegisterGeneric("dodge", { type = "customemote", text = "twists neatly out of the path of the attack." })
RPHelper.RegisterGeneric("dodge", { type = "customemote", text = "steps clear of the strike at the last moment." })
RPHelper.RegisterGeneric("dodge", { type = "customemote", text = "slips beyond the attacker's reach." })
RPHelper.RegisterGeneric("dodge", { type = "customemote", text = "leans away as the attack cuts through empty air." })
RPHelper.RegisterGeneric("dodge", { type = "customemote", text = "moves just enough to let the attack pass harmlessly by." })
RPHelper.RegisterGeneric("dodge", { type = "customemote", text = "sidesteps the incoming attack with practiced timing." })

-- ---------------------------------------------------------------------
-- PARRY
-- ---------------------------------------------------------------------

RPHelper.RegisterGeneric("parry", { type = "say", text = "Too easy." })
RPHelper.RegisterGeneric("parry", { type = "say", text = "Intercepted!" })
RPHelper.RegisterGeneric("parry", { type = "say", text = "You'll have to do better than that." })
RPHelper.RegisterGeneric("parry", { type = "say", text = "Not good enough." })
RPHelper.RegisterGeneric("parry", { type = "say", text = "Try again." })
RPHelper.RegisterGeneric("parry", { type = "say", text = "Predictable." })
RPHelper.RegisterGeneric("parry", { type = "say", text = "That won't work twice." })
RPHelper.RegisterGeneric("parry", { type = "say", text = "Denied." })
RPHelper.RegisterGeneric("parry", { type = "customemote", text = "turns the incoming strike aside with a sharp movement." })
RPHelper.RegisterGeneric("parry", { type = "customemote", text = "catches the attack and redirects it away." })
RPHelper.RegisterGeneric("parry", { type = "customemote", text = "deflects the blow with practiced timing." })
RPHelper.RegisterGeneric("parry", { type = "customemote", text = "meets the strike and knocks it aside." })
RPHelper.RegisterGeneric("parry", { type = "customemote", text = "guides the attack harmlessly past." })
RPHelper.RegisterGeneric("parry", { type = "customemote", text = "turns the weapon aside and resets their guard." })

-- ---------------------------------------------------------------------
-- BLOCK
-- ---------------------------------------------------------------------

RPHelper.RegisterGeneric("block", { type = "say", text = "Blocked." })
RPHelper.RegisterGeneric("block", { type = "say", text = "You'll need more than that." })
RPHelper.RegisterGeneric("block", { type = "say", text = "My guard holds." })
RPHelper.RegisterGeneric("block", { type = "say", text = "Not getting through." })
RPHelper.RegisterGeneric("block", { type = "say", text = "Try harder." })
RPHelper.RegisterGeneric("block", { type = "say", text = "That all you've got?" })
RPHelper.RegisterGeneric("block", { type = "say", text = "No blow shall pass!" })
RPHelper.RegisterGeneric("block", { type = "say", text = "You'll have to break through first." })
RPHelper.RegisterGeneric("block", { type = "say", text = "What did my shield do to deserve that?" })
RPHelper.RegisterGeneric("block", { type = "customemote", text = "braces and catches the blow on their guard." })
RPHelper.RegisterGeneric("block", { type = "customemote", text = "absorbs the impact behind a firm guard." })
RPHelper.RegisterGeneric("block", { type = "customemote", text = "meets the strike head-on and holds." })
RPHelper.RegisterGeneric("block", { type = "customemote", text = "sets their guard and turns the blow aside." })
RPHelper.RegisterGeneric("block", { type = "customemote", text = "takes the impact on their defence without yielding." })
RPHelper.RegisterGeneric("block", { type = "customemote", text = "plants their feet and stops the strike cold." })

-- ---------------------------------------------------------------------
-- OFFENSIVE CRITICAL HIT
-- ---------------------------------------------------------------------

RPHelper.RegisterGeneric("youcrit", { type = "say", text = "That looked like it hurt." })
RPHelper.RegisterGeneric("youcrit", { type = "say", text = "Did that hurt?" })
RPHelper.RegisterGeneric("youcrit", { type = "say", text = "Oh, I'll bet that hurt." })
RPHelper.RegisterGeneric("youcrit", { type = "say", text = "Felt that one, didn't you?" })
RPHelper.RegisterGeneric("youcrit", { type = "say", text = "That got your attention." })
RPHelper.RegisterGeneric("youcrit", { type = "say", text = "That should leave a mark." })
RPHelper.RegisterGeneric("youcrit", { type = "say", text = "That struck true." })
RPHelper.RegisterGeneric("youcrit", { type = "say", text = "Right where I wanted it." })
RPHelper.RegisterGeneric("youcrit", { type = "say", text = "A clean hit!" })
RPHelper.RegisterGeneric("youcrit", { type = "emote", text = "LAUGH" })
RPHelper.RegisterGeneric("youcrit", { type = "emote", text = "SMIRK" })
RPHelper.RegisterGeneric("youcrit", { type = "customemote", text = "flashes a satisfied grin as the attack hits with unusual force." })
RPHelper.RegisterGeneric("youcrit", { type = "customemote", text = "presses the advantage after the powerful hit." })
RPHelper.RegisterGeneric("youcrit", { type = "customemote", text = "allows a brief smirk as the attack finds its mark." })
RPHelper.RegisterGeneric("youcrit", { type = "customemote", text = "seems pleased by the force of the impact." })
RPHelper.RegisterGeneric("youcrit", { type = "customemote", text = "watches with satisfaction as the attack hits home." })
RPHelper.RegisterGeneric("youcrit", { type = "customemote", text = "holds their focus as the attack lands with devastating precision." })

-- ---------------------------------------------------------------------
-- DEATH
-- ---------------------------------------------------------------------

RPHelper.RegisterGeneric("death", { type = "say", text = "This cannot be the end..." })
RPHelper.RegisterGeneric("death", { type = "say", text = "I have failed..." })
RPHelper.RegisterGeneric("death", { type = "say", text = "Not... yet..." })
RPHelper.RegisterGeneric("death", { type = "say", text = "I... wasn't finished..." })
RPHelper.RegisterGeneric("death", { type = "say", text = "No..." })
RPHelper.RegisterGeneric("death", { type = "say", text = "This can't be..." })
RPHelper.RegisterGeneric("death", { type = "customemote", text = "staggers and collapses to the ground." })
RPHelper.RegisterGeneric("death", { type = "customemote", text = "falters before finally falling still." })
RPHelper.RegisterGeneric("death", { type = "customemote", text = "drops heavily as the last of their strength gives out." })
RPHelper.RegisterGeneric("death", { type = "customemote", text = "crumples to the ground, their strength spent." })
RPHelper.RegisterGeneric("death", { type = "customemote", text = "falls silent as their body gives way." })

-- ---------------------------------------------------------------------
-- RESURRECT
-- ---------------------------------------------------------------------

RPHelper.RegisterGeneric("resurrect", { type = "say", text = "I'm alive!" })
RPHelper.RegisterGeneric("resurrect", { type = "say", text = "Huh? Wha? How'd I get here?" })
RPHelper.RegisterGeneric("resurrect", { type = "say", text = "That was unpleasant." })
RPHelper.RegisterGeneric("resurrect", { type = "say", text = "I'm... back?" })
RPHelper.RegisterGeneric("resurrect", { type = "say", text = "Not dead yet, then." })
RPHelper.RegisterGeneric("resurrect", { type = "say", text = "I thought that was the end." })
RPHelper.RegisterGeneric("resurrect", { type = "say", text = "Back among the living." })
RPHelper.RegisterGeneric("resurrect", { type = "say", text = "Remind me not to do that again." })
RPHelper.RegisterGeneric("resurrect", { type = "customemote", text = "draws a sudden breath and slowly regains their bearings." })
RPHelper.RegisterGeneric("resurrect", { type = "customemote", text = "stirs again, looking briefly disoriented." })
RPHelper.RegisterGeneric("resurrect", { type = "customemote", text = "opens their eyes and takes a moment to understand where they are." })
RPHelper.RegisterGeneric("resurrect", { type = "customemote", text = "returns to awareness with a sharp intake of breath." })
RPHelper.RegisterGeneric("resurrect", { type = "customemote", text = "slowly rises, still shaken by the experience." })
RPHelper.RegisterGeneric("resurrect", { type = "customemote", text = "checks themselves over as life returns to their body." })

-- ---------------------------------------------------------------------
-- MONSTER CALLS FOR HELP
-- ---------------------------------------------------------------------

RPHelper.RegisterGeneric("monster_emote_help", { type = "say", text = "Calling for help? I don't think so." })
RPHelper.RegisterGeneric("monster_emote_help", { type = "say", text = "It's too late for you now." })
RPHelper.RegisterGeneric("monster_emote_help", { type = "say", text = "Call all you like." })
RPHelper.RegisterGeneric("monster_emote_help", { type = "say", text = "No one is coming to save you." })
RPHelper.RegisterGeneric("monster_emote_help", { type = "say", text = "We should finish this quickly." })
RPHelper.RegisterGeneric("monster_emote_help", { type = "customemote", text = "glances around for approaching reinforcements." })
RPHelper.RegisterGeneric("monster_emote_help", { type = "customemote", text = "presses the attack before help can arrive." })
RPHelper.RegisterGeneric("monster_emote_help", { type = "customemote", text = "looks toward the source of the answering cries." })

-- ---------------------------------------------------------------------
-- MONSTER RUNS IN FEAR
-- ---------------------------------------------------------------------

RPHelper.RegisterGeneric("monster_emote_fear", { type = "say", text = "Run away, coward!" })
RPHelper.RegisterGeneric("monster_emote_fear", { type = "say", text = "Come back here!" })
RPHelper.RegisterGeneric("monster_emote_fear", { type = "say", text = "Where do you think you're going?" })
RPHelper.RegisterGeneric("monster_emote_fear", { type = "say", text = "Don't let it escape!" })
RPHelper.RegisterGeneric("monster_emote_fear", { type = "say", text = "It's fleeing!" })
RPHelper.RegisterGeneric("monster_emote_fear", { type = "emote", text = "CHICKEN" })
RPHelper.RegisterGeneric("monster_emote_fear", { type = "customemote", text = "moves to pursue the fleeing enemy." })
RPHelper.RegisterGeneric("monster_emote_fear", { type = "customemote", text = "watches the enemy turn and flee." })
RPHelper.RegisterGeneric("monster_emote_fear", { type = "customemote", text = "points after the fleeing enemy." })

-- ---------------------------------------------------------------------
-- MONSTER BECOMES ENRAGED
-- ---------------------------------------------------------------------

RPHelper.RegisterGeneric("monster_emote_enrage", { type = "say", text = "It's enraged!" })
RPHelper.RegisterGeneric("monster_emote_enrage", { type = "say", text = "Careful - it just got angrier." })
RPHelper.RegisterGeneric("monster_emote_enrage", { type = "say", text = "Watch yourself!" })
RPHelper.RegisterGeneric("monster_emote_enrage", { type = "say", text = "Here it comes!" })
RPHelper.RegisterGeneric("monster_emote_enrage", { type = "say", text = "Enraged? Oh, I'm so scared." })
RPHelper.RegisterGeneric("monster_emote_enrage", { type = "customemote", text = "steadies themselves as the enemy flies into a rage." })
RPHelper.RegisterGeneric("monster_emote_enrage", { type = "customemote", text = "raises their guard against the enraged enemy." })
RPHelper.RegisterGeneric("monster_emote_enrage", { type = "customemote", text = "watches the enraged enemy warily." })
RPHelper.RegisterGeneric("monster_emote_enrage", { type = "customemote", text = "shakes in their boots." })
