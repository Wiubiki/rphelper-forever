-- RPHelper Forever - Hunter ability content
-- Corpus migration from the RPhelper_twow Hunter catalogue and original RoleplayingHelper lineage.
-- The legacy Hunter source carried no named contributor attribution.

local A = RPHelper.Ability.HUNTER
local C = RPHelper.Class.HUNTER
local function add(id, ability, entryType, text)
    A[ability] = A[ability] or ability
    RPHelper.RegisterAbility(C, A[ability], { id = id, type = entryType, text = text })
end

-- =====================================================================
-- Beast Mastery
-- =====================================================================

-- ---------------------------------------------------------------------
-- ASPECT_OF_THE_BEAST
-- ---------------------------------------------------------------------
add("default:ability:hunter:0002", "ASPECT_OF_THE_BEAST", "say", "Embrace the wild within.")
add("default:ability:hunter:0003", "ASPECT_OF_THE_BEAST", "say", "Predator instincts awakened.")
add("default:ability:hunter:0004", "ASPECT_OF_THE_BEAST", "customemote", "takes on the demeanor of a lurking predator.")

-- ---------------------------------------------------------------------
-- ASPECT_OF_THE_CHEETAH
-- ---------------------------------------------------------------------
add("default:ability:hunter:0005", "ASPECT_OF_THE_CHEETAH", "say", "Speed is survival.")
add("default:ability:hunter:0006", "ASPECT_OF_THE_CHEETAH", "say", "No one outruns the hunter.")
add("default:ability:hunter:0007", "ASPECT_OF_THE_CHEETAH", "customemote", "moves with swift, feline grace.")

-- ---------------------------------------------------------------------
-- ASPECT_OF_THE_HAWK
-- ---------------------------------------------------------------------
add("default:ability:hunter:0008", "ASPECT_OF_THE_HAWK", "say", "Eyes sharp, aim true.")
add("default:ability:hunter:0009", "ASPECT_OF_THE_HAWK", "say", "The sky's hunter never misses.")
add("default:ability:hunter:0010", "ASPECT_OF_THE_HAWK", "customemote", "narrows {PP} eyes, focusing intensely on the battlefield.")

-- ---------------------------------------------------------------------
-- ASPECT_OF_THE_MONKEY
-- ---------------------------------------------------------------------
add("default:ability:hunter:0011", "ASPECT_OF_THE_MONKEY", "say", "Agility is my shield.")
add("default:ability:hunter:0012", "ASPECT_OF_THE_MONKEY", "say", "You can't hit what you can't catch!")
add("default:ability:hunter:0013", "ASPECT_OF_THE_MONKEY", "emote", "FIDGET")
add("default:ability:hunter:0014", "ASPECT_OF_THE_MONKEY", "customemote", "shifts {PP} stance, becoming more nimble and evasive.")

-- ---------------------------------------------------------------------
-- ASPECT_OF_THE_PACK
-- ---------------------------------------------------------------------
add("default:ability:hunter:0015", "ASPECT_OF_THE_PACK", "say", "Run with the pack!")
add("default:ability:hunter:0016", "ASPECT_OF_THE_PACK", "say", "Together, we are swift and strong.")
add("default:ability:hunter:0017", "ASPECT_OF_THE_PACK", "customemote", "signals to allies, urging them to move faster.")

-- ---------------------------------------------------------------------
-- ASPECT_OF_THE_WILD
-- ---------------------------------------------------------------------
add("default:ability:hunter:0018", "ASPECT_OF_THE_WILD", "say", "Nature shields me.")
add("default:ability:hunter:0019", "ASPECT_OF_THE_WILD", "say", "Armor’s nice, but instincts keep you alive.")
add("default:ability:hunter:0020", "ASPECT_OF_THE_WILD", "customemote", "draws upon nature’s strength, becoming more resilient.")

-- ---------------------------------------------------------------------
-- BEAST_LORE
-- ---------------------------------------------------------------------
add("default:ability:hunter:0021", "BEAST_LORE", "say", "Knowledge is the best weapon.")
add("default:ability:hunter:0022", "BEAST_LORE", "say", "Let’s see what we’re dealing with here.")
add("default:ability:hunter:0023", "BEAST_LORE", "customemote", "studies {TARGET} carefully, noting its strengths and weaknesses.")

-- ---------------------------------------------------------------------
-- BESTIAL_WRATH
-- ---------------------------------------------------------------------
add("default:ability:hunter:0024", "BESTIAL_WRATH", "say", "Unleash the fury!")
add("default:ability:hunter:0025", "BESTIAL_WRATH", "say", "No chains can hold my beast!")
add("default:ability:hunter:0026", "BESTIAL_WRATH", "customemote", "lets out a battle cry as {PNAME} erupts into a furious rage.")

-- ---------------------------------------------------------------------
-- CALL_PET
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "CALL_PET")

-- add("CALL_PET", "say", "")
-- add("CALL_PET", "emote", "")
-- add("CALL_PET", "customemote", "")

-- ---------------------------------------------------------------------
-- DISMISS_PET
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "DISMISS_PET")

-- add("DISMISS_PET", "say", "")
-- add("DISMISS_PET", "emote", "")
-- add("DISMISS_PET", "customemote", "")

-- ---------------------------------------------------------------------
-- EAGLE_EYE
-- ---------------------------------------------------------------------
add("default:ability:hunter:0027", "EAGLE_EYE", "say", "I see all from here...")
add("default:ability:hunter:0028", "EAGLE_EYE", "say", "No distance is too great for my sight.")
add("default:ability:hunter:0029", "EAGLE_EYE", "customemote", "glances around, reading the landscape with a practiced eye.")

-- ---------------------------------------------------------------------
-- EYES_OF_THE_BEAST
-- ---------------------------------------------------------------------
add("default:ability:hunter:0030", "EYES_OF_THE_BEAST", "say", "See through your eyes, {PNAME}.")
add("default:ability:hunter:0031", "EYES_OF_THE_BEAST", "say", "Guide me well, {PNAME}.")
add("default:ability:hunter:0032", "EYES_OF_THE_BEAST", "customemote", "closes {PP} eyes, linking vision with {PNAME}.")

-- ---------------------------------------------------------------------
-- FEED_PET
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "FEED_PET")

-- add("FEED_PET", "say", "")
-- add("FEED_PET", "emote", "")
-- add("FEED_PET", "customemote", "")

-- ---------------------------------------------------------------------
-- INTIMIDATION
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "INTIMIDATION")

-- add("INTIMIDATION", "say", "")
-- add("INTIMIDATION", "emote", "")
-- add("INTIMIDATION", "customemote", "")

-- ---------------------------------------------------------------------
-- MEND_PET
-- ---------------------------------------------------------------------
add("default:ability:hunter:0033", "MEND_PET", "say", "Stay strong, {PNAME}!")
add("default:ability:hunter:0034", "MEND_PET", "say", "You’ll be back on your feet in no time, {PNAME}.")
add("default:ability:hunter:0035", "MEND_PET", "customemote", "gently tends to {PNAME}’s wounds.")

-- ---------------------------------------------------------------------
-- REVIVE_PET
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "REVIVE_PET")

-- add("REVIVE_PET", "say", "")
-- add("REVIVE_PET", "emote", "")
-- add("REVIVE_PET", "customemote", "")

-- ---------------------------------------------------------------------
-- SCARE_BEAST
-- ---------------------------------------------------------------------
add("default:ability:hunter:0036", "SCARE_BEAST", "say", "Run while you still can!")
add("default:ability:hunter:0037", "SCARE_BEAST", "say", "Fear is a beast’s greatest weakness.")
add("default:ability:hunter:0038", "SCARE_BEAST", "customemote", "intimidates {TARGET} with a fierce, commanding stance.")

-- ---------------------------------------------------------------------
-- SUMMON_HAWK
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "SUMMON_HAWK")

-- add("SUMMON_HAWK", "say", "")
-- add("SUMMON_HAWK", "emote", "")
-- add("SUMMON_HAWK", "customemote", "")

-- ---------------------------------------------------------------------
-- TAME_BEAST
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "TAME_BEAST")

-- add("TAME_BEAST", "say", "")
-- add("TAME_BEAST", "emote", "")
-- add("TAME_BEAST", "customemote", "")

-- ---------------------------------------------------------------------
-- TRANQUILIZING_SHOT
-- ---------------------------------------------------------------------
add("default:ability:hunter:0039", "TRANQUILIZING_SHOT", "say", "Calm yourself, {TARGET}.")
add("default:ability:hunter:0040", "TRANQUILIZING_SHOT", "say", "Let’s quiet things down a bit.")
add("default:ability:hunter:0041", "TRANQUILIZING_SHOT", "customemote", "fires a precise shot, subduing {TARGET}’s energy.")

-- =====================================================================
-- Marksmanship
-- =====================================================================

-- ---------------------------------------------------------------------
-- AIMED_SHOT
-- ---------------------------------------------------------------------
add("default:ability:hunter:0042", "AIMED_SHOT", "say", "Ready, Aim, Fire!")
add("default:ability:hunter:0043", "AIMED_SHOT", "say", "Precision is everything.")
add("default:ability:hunter:0044", "AIMED_SHOT", "customemote", "takes careful aim at {TARGET}.")

-- ---------------------------------------------------------------------
-- ARCANE_SHOT
-- ---------------------------------------------------------------------
add("default:ability:hunter:0045", "ARCANE_SHOT", "say", "Magic and steel, the perfect combination!")
add("default:ability:hunter:0046", "ARCANE_SHOT", "say", "A touch of the arcane never hurts... unless you're the target!")
add("default:ability:hunter:0047", "ARCANE_SHOT", "customemote", "adds some arcane power to this shot for a little more oomph.")
add("default:ability:hunter:0048", "ARCANE_SHOT", "customemote", "sends the gift of an arcane shot, from me to you, {TARGET}.")
add("default:ability:hunter:0049", "ARCANE_SHOT", "customemote", "blasts {TARGET} with some arcane power.")

-- ---------------------------------------------------------------------
-- AUTO_SHOT
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "AUTO_SHOT")

-- add("AUTO_SHOT", "say", "")
-- add("AUTO_SHOT", "emote", "")
-- add("AUTO_SHOT", "customemote", "")

-- ---------------------------------------------------------------------
-- CONCUSSIVE_SHOT
-- ---------------------------------------------------------------------
add("default:ability:hunter:0050", "CONCUSSIVE_SHOT", "say", "Not so fast, {TARGET}!")
add("default:ability:hunter:0051", "CONCUSSIVE_SHOT", "say", "Enjoy the last few seconds of your life, {TARGET}.")
add("default:ability:hunter:0052", "CONCUSSIVE_SHOT", "say", "Whoah, slow down, {TARGET}!")
add("default:ability:hunter:0053", "CONCUSSIVE_SHOT", "say", "Going somewhere? I think not.")
add("default:ability:hunter:0054", "CONCUSSIVE_SHOT", "customemote", "suggests {TARGET} slows down a bit.")

-- ---------------------------------------------------------------------
-- DISTRACTING_SHOT
-- ---------------------------------------------------------------------
add("default:ability:hunter:0055", "DISTRACTING_SHOT", "say", "Yoohoo... look at me!")
add("default:ability:hunter:0056", "DISTRACTING_SHOT", "say", "Over here, big guy!")
add("default:ability:hunter:0057", "DISTRACTING_SHOT", "customemote", "tries to distract {TARGET}.")

-- ---------------------------------------------------------------------
-- ENCHANTED_FLARE
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "ENCHANTED_FLARE")

-- add("ENCHANTED_FLARE", "say", "")
-- add("ENCHANTED_FLARE", "emote", "")
-- add("ENCHANTED_FLARE", "customemote", "")

-- ---------------------------------------------------------------------
-- FLARE
-- ---------------------------------------------------------------------
add("default:ability:hunter:0058", "FLARE", "say", "Nowhere to hide!")
add("default:ability:hunter:0059", "FLARE", "say", "Let’s shed some light on the situation.")
add("default:ability:hunter:0060", "FLARE", "customemote", "tosses a flare, illuminating hidden threats.")

-- ---------------------------------------------------------------------
-- HUNTERS_MARK
-- ---------------------------------------------------------------------
add("default:ability:hunter:0061", "HUNTERS_MARK", "say", "You can’t hide from me now.")
add("default:ability:hunter:0062", "HUNTERS_MARK", "say", "Once marked, always hunted.")
add("default:ability:hunter:0063", "HUNTERS_MARK", "customemote", "marks {TARGET} for death with a knowing smirk.")

-- ---------------------------------------------------------------------
-- MULTI_SHOT
-- ---------------------------------------------------------------------
add("default:ability:hunter:0064", "MULTI_SHOT", "say", "One shot, multiple problems solved!")
add("default:ability:hunter:0065", "MULTI_SHOT", "say", "A hail of arrows just for you!")
add("default:ability:hunter:0066", "MULTI_SHOT", "customemote", "looses multiple arrows in quick succession.")

-- ---------------------------------------------------------------------
-- RAPID_FIRE
-- ---------------------------------------------------------------------
add("default:ability:hunter:0067", "RAPID_FIRE", "say", "Faster, deadlier, unstoppable!")
add("default:ability:hunter:0068", "RAPID_FIRE", "say", "Let’s see how fast you can dodge!")
add("default:ability:hunter:0069", "RAPID_FIRE", "customemote", "fires a rapid volley of arrows at {TARGET}.")

-- ---------------------------------------------------------------------
-- SCATTER_SHOT
-- ---------------------------------------------------------------------
add("default:ability:hunter:0070", "SCATTER_SHOT", "say", "Let’s cause a little chaos!")
add("default:ability:hunter:0071", "SCATTER_SHOT", "say", "Try dodging this!")
add("default:ability:hunter:0072", "SCATTER_SHOT", "customemote", "fires a wide-spread shot, throwing {TARGET} off balance.")

-- ---------------------------------------------------------------------
-- SCORPID_STING
-- ---------------------------------------------------------------------
add("default:ability:hunter:0073", "SCORPID_STING", "say", "Let’s see how you fight while weakened!")
add("default:ability:hunter:0074", "SCORPID_STING", "say", "A little sting goes a long way.")
add("default:ability:hunter:0075", "SCORPID_STING", "customemote", "delivers a crippling shot to {TARGET}.")

-- ---------------------------------------------------------------------
-- SERPENT_STING
-- ---------------------------------------------------------------------
add("default:ability:hunter:0076", "SERPENT_STING", "say", "A bite worse than any snake’s.")
add("default:ability:hunter:0077", "SERPENT_STING", "say", "Poison makes everything more interesting.")
add("default:ability:hunter:0078", "SERPENT_STING", "customemote", "watches as venom seeps into {TARGET}.")

-- ---------------------------------------------------------------------
-- SNIPER_SHOT
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "SNIPER_SHOT")

-- add("SNIPER_SHOT", "say", "")
-- add("SNIPER_SHOT", "emote", "")
-- add("SNIPER_SHOT", "customemote", "")

-- ---------------------------------------------------------------------
-- TRUESHOT_AURA
-- ---------------------------------------------------------------------
add("default:ability:hunter:0079", "TRUESHOT_AURA", "say", "Let my aim guide us all.")
add("default:ability:hunter:0080", "TRUESHOT_AURA", "say", "With focus, we cannot miss.")
add("default:ability:hunter:0081", "TRUESHOT_AURA", "customemote", "radiates an aura of precision and confidence.")

-- ---------------------------------------------------------------------
-- VIPER_STING
-- ---------------------------------------------------------------------
add("default:ability:hunter:0082", "VIPER_STING", "say", "Draining your energy one shot at a time.")
add("default:ability:hunter:0083", "VIPER_STING", "say", "Mana is a resource... and now it's mine!")
add("default:ability:hunter:0084", "VIPER_STING", "customemote", "fires a stinging shot, sapping {TARGET}'s energy.")

-- ---------------------------------------------------------------------
-- VOLLEY
-- ---------------------------------------------------------------------
add("default:ability:hunter:0085", "VOLLEY", "say", "Raining arrows upon you!")
add("default:ability:hunter:0086", "VOLLEY", "say", "You can run, but you can’t hide!")
add("default:ability:hunter:0087", "VOLLEY", "customemote", "fires a relentless volley of arrows into the air.")

-- =====================================================================
-- Survival
-- =====================================================================

-- ---------------------------------------------------------------------
-- COUNTERATTACK
-- ---------------------------------------------------------------------
add("default:ability:hunter:0088", "COUNTERATTACK", "say", "Defense is the best offense!")
add("default:ability:hunter:0089", "COUNTERATTACK", "say", "You strike, I counter!")
add("default:ability:hunter:0090", "COUNTERATTACK", "customemote", "parries and swiftly retaliates with a powerful strike.")

-- ---------------------------------------------------------------------
-- DETERRENCE
-- ---------------------------------------------------------------------
add("default:ability:hunter:0091", "DETERRENCE", "say", "Try me. I dare you.")
add("default:ability:hunter:0092", "DETERRENCE", "say", "You think you can hit me? Think again.")
add("default:ability:hunter:0093", "DETERRENCE", "customemote", "adopts a defensive stance, ready to deflect incoming attacks.")

-- ---------------------------------------------------------------------
-- DISENGAGE
-- ---------------------------------------------------------------------
add("default:ability:hunter:0094", "DISENGAGE", "say", "Time to reposition!")
add("default:ability:hunter:0095", "DISENGAGE", "say", "A hunter knows when to back off.")
add("default:ability:hunter:0096", "DISENGAGE", "customemote", "leaps back swiftly, avoiding danger.")

-- ---------------------------------------------------------------------
-- EXPLOSIVE_TRAP
-- ---------------------------------------------------------------------
add("default:ability:hunter:0097", "EXPLOSIVE_TRAP", "say", "A little surprise for the reckless.")
add("default:ability:hunter:0098", "EXPLOSIVE_TRAP", "say", "Boom!")
add("default:ability:hunter:0099", "EXPLOSIVE_TRAP", "customemote", "carefully sets a trap filled with volatile energy.")

-- ---------------------------------------------------------------------
-- FEIGN_DEATH
-- ---------------------------------------------------------------------
add("default:ability:hunter:0100", "FEIGN_DEATH", "say", "Shhh! Don't tell them I'm not really dead.")
add("default:ability:hunter:0101", "FEIGN_DEATH", "customemote", "feigns {PP} death.")

-- ---------------------------------------------------------------------
-- FREEZING_TRAP
-- ---------------------------------------------------------------------
add("default:ability:hunter:0102", "FREEZING_TRAP", "say", "Time for someone to chill out.")
add("default:ability:hunter:0103", "FREEZING_TRAP", "customemote", "places a freezing trap, prepared to ensnare the unwary.")

-- ---------------------------------------------------------------------
-- FROST_TRAP
-- ---------------------------------------------------------------------
add("default:ability:hunter:0104", "FROST_TRAP", "say", "This should slow things down a bit.")
add("default:ability:hunter:0105", "FROST_TRAP", "customemote", "sets a trap to hinder movement with an icy touch.")

-- ---------------------------------------------------------------------
-- IMMOLATION_TRAP
-- ---------------------------------------------------------------------
add("default:ability:hunter:0106", "IMMOLATION_TRAP", "say", "Fire cleanses all.")
add("default:ability:hunter:0107", "IMMOLATION_TRAP", "say", "Let them burn!")
add("default:ability:hunter:0108", "IMMOLATION_TRAP", "customemote", "sets a fiery trap, ready to ignite anything that steps too close.")

-- ---------------------------------------------------------------------
-- LACERATE
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "LACERATE")

-- add("LACERATE", "say", "")
-- add("LACERATE", "emote", "")
-- add("LACERATE", "customemote", "")

-- ---------------------------------------------------------------------
-- MONGOOSE_BITE
-- ---------------------------------------------------------------------
add("default:ability:hunter:0109", "MONGOOSE_BITE", "say", "Fangs faster than the eye!")
add("default:ability:hunter:0110", "MONGOOSE_BITE", "say", "A mongoose never lets go!")
add("default:ability:hunter:0111", "MONGOOSE_BITE", "customemote", "counters with a swift and deadly strike.")

-- ---------------------------------------------------------------------
-- RAPTOR_STRIKE
-- ---------------------------------------------------------------------
add("default:ability:hunter:0112", "RAPTOR_STRIKE", "say", "A hunter fights at any range!")
add("default:ability:hunter:0113", "RAPTOR_STRIKE", "say", "The claws of the raptor strike fast!")
add("default:ability:hunter:0114", "RAPTOR_STRIKE", "customemote", "lunges forward with a fierce melee strike.")

-- ---------------------------------------------------------------------
-- STRIDER_KICK
-- ---------------------------------------------------------------------
RPHelper.RegisterAbility(C, "STRIDER_KICK")

-- add("STRIDER_KICK", "say", "")
-- add("STRIDER_KICK", "emote", "")
-- add("STRIDER_KICK", "customemote", "")

-- ---------------------------------------------------------------------
-- TRACK_BEASTS
-- ---------------------------------------------------------------------
add("default:ability:hunter:0115", "TRACK_BEASTS", "say", "The land speaks, and I listen.")
add("default:ability:hunter:0116", "TRACK_BEASTS", "say", "No beast can hide from my sight.")
add("default:ability:hunter:0117", "TRACK_BEASTS", "say", "Fresh tracks... it’s close.")
add("default:ability:hunter:0118", "TRACK_BEASTS", "customemote", "studies the ground, tracing the path of a beast.")

-- ---------------------------------------------------------------------
-- TRACK_DEMONS
-- ---------------------------------------------------------------------
add("default:ability:hunter:0119", "TRACK_DEMONS", "say", "The stench of fel magic lingers here.")
add("default:ability:hunter:0120", "TRACK_DEMONS", "say", "A demon’s presence is never subtle.")
add("default:ability:hunter:0121", "TRACK_DEMONS", "customemote", "narrows {PP} eyes, feeling the presence of demonic energy.")

-- ---------------------------------------------------------------------
-- TRACK_DRAGONKIN
-- ---------------------------------------------------------------------
add("default:ability:hunter:0122", "TRACK_DRAGONKIN", "say", "The air feels charged... dragonkin are near.")
add("default:ability:hunter:0123", "TRACK_DRAGONKIN", "say", "Claw marks, scorched earth... a dragon has passed through.")
add("default:ability:hunter:0124", "TRACK_DRAGONKIN", "customemote", "studies the terrain, recognizing draconic signs.")

-- ---------------------------------------------------------------------
-- TRACK_ELEMENTALS
-- ---------------------------------------------------------------------
add("default:ability:hunter:0125", "TRACK_ELEMENTALS", "say", "The elements whisper their presence.")
add("default:ability:hunter:0126", "TRACK_ELEMENTALS", "say", "I feel a shift in the air...")
add("default:ability:hunter:0127", "TRACK_ELEMENTALS", "customemote", "focuses intently, sensing elemental disturbances.")

-- ---------------------------------------------------------------------
-- TRACK_GIANTS
-- ---------------------------------------------------------------------
add("default:ability:hunter:0128", "TRACK_GIANTS", "say", "Heavy footsteps... something massive passed this way.")
add("default:ability:hunter:0129", "TRACK_GIANTS", "say", "Giants leave more than footprints behind.")
add("default:ability:hunter:0130", "TRACK_GIANTS", "customemote", "studies the ground, noting deep, heavy tracks.")

-- ---------------------------------------------------------------------
-- TRACK_HIDDEN
-- ---------------------------------------------------------------------
add("default:ability:hunter:0131", "TRACK_HIDDEN", "say", "Shadows do not conceal from me.")
add("default:ability:hunter:0132", "TRACK_HIDDEN", "say", "Something lurks nearby...")
add("default:ability:hunter:0133", "TRACK_HIDDEN", "customemote", "carefully scans the area, looking for concealed threats.")

-- ---------------------------------------------------------------------
-- TRACK_HUMANOIDS
-- ---------------------------------------------------------------------
add("default:ability:hunter:0134", "TRACK_HUMANOIDS", "say", "Every step leaves a story behind.")
add("default:ability:hunter:0135", "TRACK_HUMANOIDS", "say", "Someone's been through here recently.")
add("default:ability:hunter:0136", "TRACK_HUMANOIDS", "customemote", "examines the tracks, noting signs of recent movement.")

-- ---------------------------------------------------------------------
-- TRACK_UNDEAD
-- ---------------------------------------------------------------------
add("default:ability:hunter:0137", "TRACK_UNDEAD", "say", "The air reeks of decay...")
add("default:ability:hunter:0138", "TRACK_UNDEAD", "say", "Undeath lingers in these lands.")
add("default:ability:hunter:0139", "TRACK_UNDEAD", "customemote", "scans the area, searching for unnatural movements.")

-- ---------------------------------------------------------------------
-- WING_CLIP
-- ---------------------------------------------------------------------
add("default:ability:hunter:0140", "WING_CLIP", "say", "You won’t be running away so easily.")
add("default:ability:hunter:0141", "WING_CLIP", "say", "A clipped enemy is a helpless one.")
add("default:ability:hunter:0142", "WING_CLIP", "customemote", "slashes at {TARGET}’s legs, hindering their movement.")
