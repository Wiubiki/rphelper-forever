-- RPHelper Forever - inactive Hunter ability archive
--
-- This file is intentionally not loaded by RPHelper.toc. It preserves legacy
-- authored content for review and potential recovery without registering the
-- abilities or reactions in the active catalogue.

return {
    ASPECT_OF_THE_WOLF = {
        { type = "say", text = "Time to hunt like a true predator!" },
        { type = "say", text = "No bow. No arrows. Just fang and claw!" },
        { type = "say", text = "Strength of the pack, speed of the wolf!" },
        { type = "customemote", text = "shifts stance, adopting the predatory movements of a wolf." },
    },
    CARVE = {
        { type = "say", text = "A pack hunts together!" },
        { type = "say", text = "Surrounded? Perfect." },
        { type = "say", text = "I'll carve through you all!" },
        { type = "say", text = "Sweep and scatter!" },
        { type = "say", text = "One cut, five wounds!" },
        { type = "customemote", text = "slashes {PP} blade in a wide arc, cutting down multiple foes." },
    },
    STEADY_SHOT = {
        { type = "say", text = "Steady hands, deadliest aim." },
        { type = "say", text = "Precision makes perfection." },
        { type = "say", text = "A well-placed shot is worth a dozen rushed ones." },
        { type = "customemote", text = "draws back {PP} bowstring slowly, ensuring a lethal shot at {TARGET}." },
    },
}
