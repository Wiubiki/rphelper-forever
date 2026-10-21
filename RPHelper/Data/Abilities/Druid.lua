-- RPHelper Forever - Druid ability content
-- Corpus migration from the RPhelper_twow Druid catalogue and original RoleplayingHelper lineage.
-- The legacy Druid source carried no named contributor attribution.

local A = RPHelper.Ability.DRUID
local C = RPHelper.Class.DRUID
local function add(id, ability, entryType, text)
    A[ability] = A[ability] or ability
    RPHelper.RegisterAbility(C, A[ability], { id = id, type = entryType, text = text })
end

-- =====================================================================
-- Balance
-- =====================================================================

-- ---------------------------------------------------------------------
-- BARKSKIN
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "BARKSKIN")

-- add("BARKSKIN", "say", "")
-- add("BARKSKIN", "emote", "")
-- add("BARKSKIN", "customemote", "")

-- ---------------------------------------------------------------------
-- ENTANGLING_ROOTS
-- ---------------------------------------------------------------------
add("default:ability:druid:0002", "ENTANGLING_ROOTS", "say", "How 'bout ya stick around for awhile, {TARGET}.'")
add("default:ability:druid:0003", "ENTANGLING_ROOTS", "say", "Oh, were you going somewhere?")
add("default:ability:druid:0004", "ENTANGLING_ROOTS", "say", "I think you're better off being firmly rooted in place, {TARGET}.")

-- ---------------------------------------------------------------------
-- FAERIE_FIRE
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "FAERIE_FIRE")

-- add("FAERIE_FIRE", "say", "")
-- add("FAERIE_FIRE", "emote", "")
-- add("FAERIE_FIRE", "customemote", "")

-- ---------------------------------------------------------------------
-- HIBERNATE
-- ---------------------------------------------------------------------
add("default:ability:druid:0005", "HIBERNATE", "say", "Yoohoo... {TARGET}... Nap Time!")
add("default:ability:druid:0006", "HIBERNATE", "say", "Sleep... sleep...")
add("default:ability:druid:0007", "HIBERNATE", "say", "Take a nap {TARGET}, we'll get to you in a bit.")
add("default:ability:druid:0008", "HIBERNATE", "say", "Nighty night {TARGET}.")
add("default:ability:druid:0009", "HIBERNATE", "customemote", "suggests {TARGET} take a quick nap.")
add("default:ability:druid:0010", "HIBERNATE", "customemote", "dangles a watch in front of {TARGET}. You are feeling very sleepy...")

-- ---------------------------------------------------------------------
-- HURRICANE
-- ---------------------------------------------------------------------
add("default:ability:druid:0011", "HURRICANE", "say", "How 'bout a little thunder and lightnin'?")
add("default:ability:druid:0012", "HURRICANE", "customemote", "summons the violent forces of nature.")

-- ---------------------------------------------------------------------
-- INSECT_SWARM
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "INSECT_SWARM")

-- add("INSECT_SWARM", "say", "")
-- add("INSECT_SWARM", "emote", "")
-- add("INSECT_SWARM", "customemote", "")

-- ---------------------------------------------------------------------
-- MOON_FIRE
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "MOON_FIRE")

-- add("MOON_FIRE", "say", "")
-- add("MOON_FIRE", "emote", "")
-- add("MOON_FIRE", "customemote", "")

-- ---------------------------------------------------------------------
-- MOONKIN_FORM
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "MOONKIN_FORM")

-- add("MOONKIN_FORM", "say", "")
-- add("MOONKIN_FORM", "emote", "")
-- add("MOONKIN_FORM", "customemote", "")

-- ---------------------------------------------------------------------
-- NATURES_GRASP
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "NATURES_GRASP")

-- add("NATURES_GRASP", "say", "")
-- add("NATURES_GRASP", "emote", "")
-- add("NATURES_GRASP", "customemote", "")

-- ---------------------------------------------------------------------
-- SOOTHE_ANIMAL
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "SOOTHE_ANIMAL")

-- add("SOOTHE_ANIMAL", "say", "")
-- add("SOOTHE_ANIMAL", "emote", "")
-- add("SOOTHE_ANIMAL", "customemote", "")

-- ---------------------------------------------------------------------
-- STARFIRE
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "STARFIRE")

-- add("STARFIRE", "say", "")
-- add("STARFIRE", "emote", "")
-- add("STARFIRE", "customemote", "")

-- ---------------------------------------------------------------------
-- TELEPORT_MOONGLADE
-- ---------------------------------------------------------------------
add("default:ability:druid:0013", "TELEPORT_MOONGLADE", "customemote", "channels arcane forces within themselves and concentrates on Moonglade.")
add("default:ability:druid:0014", "TELEPORT_MOONGLADE", "customemote", "feels Moonglade's call as {SP} summons arcane powers.")

-- ---------------------------------------------------------------------
-- THORNS
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "THORNS")

-- add("THORNS", "say", "")
-- add("THORNS", "emote", "")
-- add("THORNS", "customemote", "")

-- ---------------------------------------------------------------------
-- WRATH
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "WRATH")

-- add("WRATH", "say", "")
-- add("WRATH", "emote", "")
-- add("WRATH", "customemote", "")

-- =====================================================================
-- Feral Combat
-- =====================================================================

-- ---------------------------------------------------------------------
-- AQUATIC_FORM
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "AQUATIC_FORM")

-- add("AQUATIC_FORM", "say", "")
-- add("AQUATIC_FORM", "emote", "")
-- add("AQUATIC_FORM", "customemote", "")

-- ---------------------------------------------------------------------
-- BASH
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "BASH")

-- add("BASH", "say", "")
-- add("BASH", "emote", "")
-- add("BASH", "customemote", "")

-- ---------------------------------------------------------------------
-- BEAR_FORM
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "BEAR_FORM")

-- add("BEAR_FORM", "say", "")
-- add("BEAR_FORM", "emote", "")
-- add("BEAR_FORM", "customemote", "")

-- ---------------------------------------------------------------------
-- BERSERK
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "BERSERK")

-- add("BERSERK", "say", "")
-- add("BERSERK", "emote", "")
-- add("BERSERK", "customemote", "")

-- ---------------------------------------------------------------------
-- CAT_FORM
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "CAT_FORM")

-- add("CAT_FORM", "say", "")
-- add("CAT_FORM", "emote", "")
-- add("CAT_FORM", "customemote", "")

-- ---------------------------------------------------------------------
-- CHALLENGING_ROAR
-- ---------------------------------------------------------------------
add("default:ability:druid:0015", "CHALLENGING_ROAR", "emote", "ROAR")

-- ---------------------------------------------------------------------
-- CLAW
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "CLAW")

-- add("CLAW", "say", "")
-- add("CLAW", "emote", "")
-- add("CLAW", "customemote", "")

-- ---------------------------------------------------------------------
-- COWER
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "COWER")

-- add("COWER", "say", "")
-- add("COWER", "emote", "")
-- add("COWER", "customemote", "")

-- ---------------------------------------------------------------------
-- DASH
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "DASH")

-- add("DASH", "say", "")
-- add("DASH", "emote", "")
-- add("DASH", "customemote", "")

-- ---------------------------------------------------------------------
-- DEMORALIZING_ROAR
-- ---------------------------------------------------------------------
add("default:ability:druid:0016", "DEMORALIZING_ROAR", "emote", "ROAR")

-- ---------------------------------------------------------------------
-- DIRE_BEAR_FORM
-- ---------------------------------------------------------------------
add("default:ability:druid:0017", "DIRE_BEAR_FORM", "emote", "ROAR")

-- ---------------------------------------------------------------------
-- ENRAGE
-- ---------------------------------------------------------------------
add("default:ability:druid:0018", "ENRAGE", "emote", "ROAR")

-- ---------------------------------------------------------------------
-- FERAL_CHARGE
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "FERAL_CHARGE")

-- add("FERAL_CHARGE", "say", "")
-- add("FERAL_CHARGE", "emote", "")
-- add("FERAL_CHARGE", "customemote", "")

-- ---------------------------------------------------------------------
-- FEROCIOUS_BITE
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "FEROCIOUS_BITE")

-- add("FEROCIOUS_BITE", "say", "")
-- add("FEROCIOUS_BITE", "emote", "")
-- add("FEROCIOUS_BITE", "customemote", "")

-- ---------------------------------------------------------------------
-- FRENZIED_REGENERATION
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "FRENZIED_REGENERATION")

-- add("FRENZIED_REGENERATION", "say", "")
-- add("FRENZIED_REGENERATION", "emote", "")
-- add("FRENZIED_REGENERATION", "customemote", "")

-- ---------------------------------------------------------------------
-- GROWL
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "GROWL")

-- add("GROWL", "say", "")
-- add("GROWL", "emote", "")
-- add("GROWL", "customemote", "")

-- ---------------------------------------------------------------------
-- LACERATE
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "LACERATE")

-- add("LACERATE", "say", "")
-- add("LACERATE", "emote", "")
-- add("LACERATE", "customemote", "")

-- ---------------------------------------------------------------------
-- MAUL
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "MAUL")

-- add("MAUL", "say", "")
-- add("MAUL", "emote", "")
-- add("MAUL", "customemote", "")

-- ---------------------------------------------------------------------
-- POUNCE
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "POUNCE")

-- add("POUNCE", "say", "")
-- add("POUNCE", "emote", "")
-- add("POUNCE", "customemote", "")

-- ---------------------------------------------------------------------
-- PRIMAL_BITE
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "PRIMAL_BITE")

-- add("PRIMAL_BITE", "say", "")
-- add("PRIMAL_BITE", "emote", "")
-- add("PRIMAL_BITE", "customemote", "")

-- ---------------------------------------------------------------------
-- PROWL
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "PROWL")

-- add("PROWL", "say", "")
-- add("PROWL", "emote", "")
-- add("PROWL", "customemote", "")

-- ---------------------------------------------------------------------
-- RAKE
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "RAKE")

-- add("RAKE", "say", "")
-- add("RAKE", "emote", "")
-- add("RAKE", "customemote", "")

-- ---------------------------------------------------------------------
-- RAVAGE
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "RAVAGE")

-- add("RAVAGE", "say", "")
-- add("RAVAGE", "emote", "")
-- add("RAVAGE", "customemote", "")

-- ---------------------------------------------------------------------
-- RIP
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "RIP")

-- add("RIP", "say", "")
-- add("RIP", "emote", "")
-- add("RIP", "customemote", "")

-- ---------------------------------------------------------------------
-- SHIFTING_POWER
-- ---------------------------------------------------------------------
add("default:ability:druid:0019", "SHIFTING_POWER", "emote", "ROAR")
add("default:ability:druid:0020", "SHIFTING_POWER", "customemote", "roars furiously.")

-- ---------------------------------------------------------------------
-- SHRED
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "SHRED")

-- add("SHRED", "say", "")
-- add("SHRED", "emote", "")
-- add("SHRED", "customemote", "")

-- ---------------------------------------------------------------------
-- SWIPE
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "SWIPE")

-- add("SWIPE", "say", "")
-- add("SWIPE", "emote", "")
-- add("SWIPE", "customemote", "")

-- ---------------------------------------------------------------------
-- TRACK_HUMANOIDS
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "TRACK_HUMANOIDS")

-- add("TRACK_HUMANOIDS", "say", "")
-- add("TRACK_HUMANOIDS", "emote", "")
-- add("TRACK_HUMANOIDS", "customemote", "")

-- ---------------------------------------------------------------------
-- TRAVEL_FORM
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "TRAVEL_FORM")

-- add("TRAVEL_FORM", "say", "")
-- add("TRAVEL_FORM", "emote", "")
-- add("TRAVEL_FORM", "customemote", "")

-- =====================================================================
-- Restoration
-- =====================================================================

-- ---------------------------------------------------------------------
-- ABOLISH_POISON
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "ABOLISH_POISON")

-- add("ABOLISH_POISON", "say", "")
-- add("ABOLISH_POISON", "emote", "")
-- add("ABOLISH_POISON", "customemote", "")

-- ---------------------------------------------------------------------
-- CURE_POISON
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "CURE_POISON")

-- add("CURE_POISON", "say", "")
-- add("CURE_POISON", "emote", "")
-- add("CURE_POISON", "customemote", "")

-- ---------------------------------------------------------------------
-- GIFT_OF_THE_WILD
-- ---------------------------------------------------------------------
add("default:ability:druid:0021", "GIFT_OF_THE_WILD", "customemote", "gives {PP} friends the Gift of the Wild.")

-- ---------------------------------------------------------------------
-- HEALING_TOUCH
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "HEALING_TOUCH")

-- add("HEALING_TOUCH", "say", "")
-- add("HEALING_TOUCH", "emote", "")
-- add("HEALING_TOUCH", "customemote", "")

-- ---------------------------------------------------------------------
-- INNERVATE
-- ---------------------------------------------------------------------
add("default:ability:druid:0022", "INNERVATE", "say", "Innervating {TARGET}")
add("default:ability:druid:0023", "INNERVATE", "say", "Gee {TARGET}, mana got you down? This should raise your spirit!")
add("default:ability:druid:0024", "INNERVATE", "customemote", "glances at {TARGET}'s mana, sighs, and casts Innervate on {OP}.")

-- ---------------------------------------------------------------------
-- MARK_OF_THE_WILD
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "MARK_OF_THE_WILD")

-- add("MARK_OF_THE_WILD", "say", "")
-- add("MARK_OF_THE_WILD", "emote", "")
-- add("MARK_OF_THE_WILD", "customemote", "")

-- ---------------------------------------------------------------------
-- NATURES_SWIFTNESS
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "NATURES_SWIFTNESS")

-- add("NATURES_SWIFTNESS", "say", "")
-- add("NATURES_SWIFTNESS", "emote", "")
-- add("NATURES_SWIFTNESS", "customemote", "")

-- ---------------------------------------------------------------------
-- REBIRTH
-- ---------------------------------------------------------------------
add("default:ability:druid:0025", "REBIRTH", "say", "{TARGET} you've failed at life! However, I believe in second chances...")
add("default:ability:druid:0026", "REBIRTH", "say", "You're not getting off the hook that easily, {TARGET}!")

-- ---------------------------------------------------------------------
-- REGROWTH
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "REGROWTH")

-- add("REGROWTH", "say", "")
-- add("REGROWTH", "emote", "")
-- add("REGROWTH", "customemote", "")

-- ---------------------------------------------------------------------
-- REJUVENATION
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "REJUVENATION")

-- add("REJUVENATION", "say", "")
-- add("REJUVENATION", "emote", "")
-- add("REJUVENATION", "customemote", "")

-- ---------------------------------------------------------------------
-- REMOVE_CURSE
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "REMOVE_CURSE")

-- add("REMOVE_CURSE", "say", "")
-- add("REMOVE_CURSE", "emote", "")
-- add("REMOVE_CURSE", "customemote", "")

-- ---------------------------------------------------------------------
-- REVIVE
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "REVIVE")

-- add("REVIVE", "say", "")
-- add("REVIVE", "emote", "")
-- add("REVIVE", "customemote", "")

-- ---------------------------------------------------------------------
-- SWIFTMEND
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "SWIFTMEND")

-- add("SWIFTMEND", "say", "")
-- add("SWIFTMEND", "emote", "")
-- add("SWIFTMEND", "customemote", "")

-- ---------------------------------------------------------------------
-- TRANQUILITY
-- ---------------------------------------------------------------------
add("default:ability:druid:0027", "TRANQUILITY", "say", "Elune, hear my plea and help me aid my friends!")
add("default:ability:druid:0028", "TRANQUILITY", "say", "Healing spirits, arise!")
add("default:ability:druid:0029", "TRANQUILITY", "customemote", "calls upon the healing forces of nature.")

-- ---------------------------------------------------------------------
-- WILD_GROWTH
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "WILD_GROWTH")

-- add("WILD_GROWTH", "say", "")
-- add("WILD_GROWTH", "emote", "")
-- add("WILD_GROWTH", "customemote", "")
