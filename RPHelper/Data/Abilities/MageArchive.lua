-- RPHelper Forever - inactive Mage ability archive
--
-- This file is intentionally not loaded by RPHelper.toc. It preserves legacy
-- authored content for review and potential recovery without registering the
-- abilities or reactions in the active catalogue.

return {
    DETECT_MAGIC = {
        { type = "say", text = "No secrets can hide from me!" },
        { type = "say", text = "Let's see what magic is lurking here." },
        { type = "customemote", text = "extends {PP} senses, searching for hidden enchantments." },
    },
    ICICLES = {
        { type = "say", text = "Frozen fury, unleashed!" },
        { type = "say", text = "A storm of ice shall consume you!" },
        { type = "customemote", text = "draws upon frost leylines, encasing themself in ice while launching deadly icicles at {TARGET}." },
    },
}
