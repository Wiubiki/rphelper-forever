RPHelper = RPHelper or {}

RPHelper.CURRENT_SCHEMA_VERSION = 1

RPHelper.Defaults = {
    settings = {
        enabled = true,
        frequencyPreset = "normal",
        globalCooldown = 10,
        maxAutomaticOutputsPerCombat = 2,
    },
    triggers = {
        enter_combat = { enabled = true, chance = 0.20, cooldown = 30 },
        leave_combat = { enabled = false, chance = 0.15, cooldown = 30 },
        crit = { enabled = true, chance = 0.08, cooldown = 20 },
        spell_crit = { enabled = true, chance = 0.08, cooldown = 20 },
        dodge = { enabled = true, chance = 0.08, cooldown = 20 },
        parry = { enabled = true, chance = 0.08, cooldown = 20 },
        block = { enabled = true, chance = 0.08, cooldown = 20 },
        death = { enabled = true, chance = 1.00, cooldown = 0 },
        resurrect = { enabled = true, chance = 1.00, cooldown = 0 },
        level_up = { enabled = true, chance = 1.00, cooldown = 0 },
    },
}
