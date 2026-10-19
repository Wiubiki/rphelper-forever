-- RPHelper Forever - inactive Paladin ability archive
--
-- This file is intentionally not loaded by RPHelper.toc. It preserves legacy
-- identities and authored content without runtime registration.

return {
    BLESSING_OF_SALVATION = {},
    BLESSING_OF_SANCTUARY = {
        { type = "say", text = "The Light shields you from harm!" },
        { type = "customemote", text = "blesses {TARGET} with divine protection against harm." },
    },
    BULWARK_OF_THE_RIGHTEOUS = {
        { type = "say", text = "The Light shields me, and my shield strikes true!" },
        { type = "say", text = "Faith and steel, unbreakable together!" },
        { type = "customemote", text = "slams {PP} shield into {TARGET}, channeling divine power for protection." },
    },
    CRUSADER_STRIKE = {
        { type = "say", text = "For the Light, and for justice!" },
        { type = "say", text = "Let the Light sear your wickedness!" },
        { type = "customemote", text = "delivers a righteous strike, amplifying the holy power against {TARGET}." },
    },
    GREATER_BLESSING_OF_SALVATION = {},
    HAND_OF_RECKONING = {
        { type = "say", text = "Face me, coward!" },
        { type = "say", text = "The Light compels you to battle!" },
        { type = "customemote", text = "raises {PP} hand, calling {TARGET} to face divine judgment." },
    },
    SANCTITY_AURA = {
        { type = "say", text = "The sacred power of the Light flows through us!" },
        { type = "customemote", text = "radiates an aura of divine sanctity." },
    },
    SUMMON_WARHORSE = {
        { type = "say", text = "A knight must always ride with honor!" },
        { type = "customemote", text = "summons a noble warhorse, blessed by the Light." },
    },
}
