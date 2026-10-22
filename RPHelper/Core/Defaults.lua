RPHelper = RPHelper or {}

RPHelper.CURRENT_SCHEMA_VERSION = 2

RPHelper.Defaults = {
    settings = {
        enabled = true,
        reactionChance = 0.05,
        globalCooldown = 20,
        encounterQuotaEnabled = false,
        maxAutomaticOutputsPerCombat = 2,
        dungeonSayMode = "broadcast",
    },
    event = { enabled = true, priority = false },
    reaction = { weight = 1 },
}
