-- RPHelper Forever - Druid ability content
-- Corpus migration from the RPhelper_twow Druid catalogue and original RoleplayingHelper lineage.
-- The legacy Druid source carried no named contributor attribution.

local A = RPHelper.Ability.DRUID
local C = RPHelper.Class.DRUID
local function add(ability, entryType, text)
    A[ability] = A[ability] or ability
    RPHelper.RegisterAbility(C, A[ability], { type = entryType, text = text })
end

-- ---------------------------------------------------------------------
-- DEMORALIZING_ROAR
-- ---------------------------------------------------------------------
add("DEMORALIZING_ROAR", "emote", "ROAR")

-- ---------------------------------------------------------------------
-- ENRAGE
-- ---------------------------------------------------------------------
add("ENRAGE", "emote", "ROAR")

-- ---------------------------------------------------------------------
-- TIGERS_FURY
-- ---------------------------------------------------------------------
add("TIGERS_FURY", "emote", "ROAR")

-- ---------------------------------------------------------------------
-- TIGERS_FURY
-- ---------------------------------------------------------------------
add("TIGERS_FURY", "customemote", "roars furiously.")

-- ---------------------------------------------------------------------
-- CHALLENGING_ROAR
-- ---------------------------------------------------------------------
add("CHALLENGING_ROAR", "emote", "ROAR")

-- ---------------------------------------------------------------------
-- DIRE_BEAR_FORM
-- ---------------------------------------------------------------------
add("DIRE_BEAR_FORM", "emote", "ROAR")

-- ---------------------------------------------------------------------
-- ENTANGLING_ROOTS
-- ---------------------------------------------------------------------
add("ENTANGLING_ROOTS", "say", "How 'bout ya stick around for awhile, {TARGET}.'")
add("ENTANGLING_ROOTS", "say", "Oh, were you going somewhere?")
add("ENTANGLING_ROOTS", "say", "I think you're better off being firmly rooted in place, {TARGET}.")

-- ---------------------------------------------------------------------
-- HIBERNATE
-- ---------------------------------------------------------------------
add("HIBERNATE", "say", "Yoohoo... {TARGET}... Nap Time!")
add("HIBERNATE", "say", "Sleep... sleep...")
add("HIBERNATE", "say", "Take a nap {TARGET}, we'll get to you in a bit.")
add("HIBERNATE", "say", "Nighty night {TARGET}.")

-- ---------------------------------------------------------------------
-- HIBERNATE
-- ---------------------------------------------------------------------
add("HIBERNATE", "customemote", "suggests {TARGET} take a quick nap.")
add("HIBERNATE", "customemote", "dangles a watch in front of {TARGET}. You are feeling very sleepy...")

-- ---------------------------------------------------------------------
-- HURRICANE
-- ---------------------------------------------------------------------
add("HURRICANE", "say", "How 'bout a little thunder and lightnin'?")

-- ---------------------------------------------------------------------
-- HURRICANE
-- ---------------------------------------------------------------------
add("HURRICANE", "customemote", "summons the violent forces of nature.")

-- ---------------------------------------------------------------------
-- TELEPORT_MOONGLADE
-- ---------------------------------------------------------------------
add("TELEPORT_MOONGLADE", "customemote", "channels arcane forces within themselves and concentrates on Moonglade.")
add("TELEPORT_MOONGLADE", "customemote", "feels Moonglade's call as {SP} summons arcane powers.")

-- ---------------------------------------------------------------------
-- REBIRTH
-- ---------------------------------------------------------------------
add("REBIRTH", "say", "{TARGET} you've failed at life! However, I believe in second chances...")
add("REBIRTH", "say", "You're not getting off the hook that easily, {TARGET}!")

-- ---------------------------------------------------------------------
-- TRANQUILITY
-- ---------------------------------------------------------------------
add("TRANQUILITY", "say", "Elune, hear my plea and help me aid my friends!")
add("TRANQUILITY", "say", "Healing spirits, arise!")

-- ---------------------------------------------------------------------
-- TRANQUILITY
-- ---------------------------------------------------------------------
add("TRANQUILITY", "customemote", "calls upon the healing forces of nature.")

-- ---------------------------------------------------------------------
-- INNERVATE
-- ---------------------------------------------------------------------
add("INNERVATE", "say", "Innervating {TARGET}")
add("INNERVATE", "say", "Gee {TARGET}, mana got you down? This should raise your spirit!")

-- ---------------------------------------------------------------------
-- INNERVATE
-- ---------------------------------------------------------------------
add("INNERVATE", "customemote", "glances at {TARGET}'s mana, sighs, and casts Innervate on {OP}.")

-- ---------------------------------------------------------------------
-- GIFT_OF_THE_WILD
-- ---------------------------------------------------------------------
add("GIFT_OF_THE_WILD", "customemote", "gives {PP} friends the Gift of the Wild.")
