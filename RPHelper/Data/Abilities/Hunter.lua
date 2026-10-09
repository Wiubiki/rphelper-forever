-- RPHelper Forever - Hunter ability content
-- Corpus migration from the RPhelper_twow Hunter catalogue and original RoleplayingHelper lineage.
-- The legacy Hunter source carried no named contributor attribution.

local A = RPHelper.Ability.HUNTER
local C = RPHelper.Class.HUNTER
local function add(ability, entryType, text)
    A[ability] = A[ability] or ability
    RPHelper.RegisterAbility(C, A[ability], { type = entryType, text = text })
end

-- ---------------------------------------------------------------------
-- ASPECT_OF_THE_MONKEY
-- ---------------------------------------------------------------------
add("ASPECT_OF_THE_MONKEY", "say", "Agility is my shield.")
add("ASPECT_OF_THE_MONKEY", "say", "You can't hit what you can't catch!")

-- ---------------------------------------------------------------------
-- ASPECT_OF_THE_MONKEY
-- ---------------------------------------------------------------------
add("ASPECT_OF_THE_MONKEY", "emote", "FIDGET")

-- ---------------------------------------------------------------------
-- ASPECT_OF_THE_MONKEY
-- ---------------------------------------------------------------------
add("ASPECT_OF_THE_MONKEY", "customemote", "shifts {PP} stance, becoming more nimble and evasive.")

-- ---------------------------------------------------------------------
-- ASPECT_OF_THE_HAWK
-- ---------------------------------------------------------------------
add("ASPECT_OF_THE_HAWK", "say", "Eyes sharp, aim true.")
add("ASPECT_OF_THE_HAWK", "say", "The sky's hunter never misses.")

-- ---------------------------------------------------------------------
-- ASPECT_OF_THE_HAWK
-- ---------------------------------------------------------------------
add("ASPECT_OF_THE_HAWK", "customemote", "narrows {PP} eyes, focusing intensely on the battlefield.")

-- ---------------------------------------------------------------------
-- ASPECT_OF_THE_CHEETAH
-- ---------------------------------------------------------------------
add("ASPECT_OF_THE_CHEETAH", "say", "Speed is survival.")
add("ASPECT_OF_THE_CHEETAH", "say", "No one outruns the hunter.")

-- ---------------------------------------------------------------------
-- ASPECT_OF_THE_CHEETAH
-- ---------------------------------------------------------------------
add("ASPECT_OF_THE_CHEETAH", "customemote", "moves with swift, feline grace.")

-- ---------------------------------------------------------------------
-- ASPECT_OF_THE_BEAST
-- ---------------------------------------------------------------------
add("ASPECT_OF_THE_BEAST", "say", "Embrace the wild within.")
add("ASPECT_OF_THE_BEAST", "say", "Predator instincts awakened.")

-- ---------------------------------------------------------------------
-- ASPECT_OF_THE_BEAST
-- ---------------------------------------------------------------------
add("ASPECT_OF_THE_BEAST", "customemote", "takes on the demeanor of a lurking predator.")

-- ---------------------------------------------------------------------
-- ASPECT_OF_THE_PACK
-- ---------------------------------------------------------------------
add("ASPECT_OF_THE_PACK", "say", "Run with the pack!")
add("ASPECT_OF_THE_PACK", "say", "Together, we are swift and strong.")

-- ---------------------------------------------------------------------
-- ASPECT_OF_THE_PACK
-- ---------------------------------------------------------------------
add("ASPECT_OF_THE_PACK", "customemote", "signals to allies, urging them to move faster.")

-- ---------------------------------------------------------------------
-- ASPECT_OF_THE_WILD
-- ---------------------------------------------------------------------
add("ASPECT_OF_THE_WILD", "say", "Nature shields me.")
add("ASPECT_OF_THE_WILD", "say", "Armor’s nice, but instincts keep you alive.")

-- ---------------------------------------------------------------------
-- ASPECT_OF_THE_WILD
-- ---------------------------------------------------------------------
add("ASPECT_OF_THE_WILD", "customemote", "draws upon nature’s strength, becoming more resilient.")

-- ---------------------------------------------------------------------
-- MEND_PET
-- ---------------------------------------------------------------------
add("MEND_PET", "say", "Stay strong, {PNAME}!")
add("MEND_PET", "say", "You’ll be back on your feet in no time, {PNAME}.")

-- ---------------------------------------------------------------------
-- MEND_PET
-- ---------------------------------------------------------------------
add("MEND_PET", "customemote", "gently tends to {PNAME}’s wounds.")

-- ---------------------------------------------------------------------
-- EAGLE_EYE
-- ---------------------------------------------------------------------
add("EAGLE_EYE", "say", "I see all from here...")
add("EAGLE_EYE", "say", "No distance is too great for my sight.")

-- ---------------------------------------------------------------------
-- EAGLE_EYE
-- ---------------------------------------------------------------------
add("EAGLE_EYE", "customemote", "glances around, reading the landscape with a practiced eye.")

-- ---------------------------------------------------------------------
-- EYES_OF_THE_BEAST
-- ---------------------------------------------------------------------
add("EYES_OF_THE_BEAST", "say", "See through your eyes, {PNAME}.")
add("EYES_OF_THE_BEAST", "say", "Guide me well, {PNAME}.")

-- ---------------------------------------------------------------------
-- EYES_OF_THE_BEAST
-- ---------------------------------------------------------------------
add("EYES_OF_THE_BEAST", "customemote", "closes {PP} eyes, linking vision with {PNAME}.")

-- ---------------------------------------------------------------------
-- SCARE_BEAST
-- ---------------------------------------------------------------------
add("SCARE_BEAST", "say", "Run while you still can!")
add("SCARE_BEAST", "say", "Fear is a beast’s greatest weakness.")

-- ---------------------------------------------------------------------
-- SCARE_BEAST
-- ---------------------------------------------------------------------
add("SCARE_BEAST", "customemote", "intimidates {TARGET} with a fierce, commanding stance.")

-- ---------------------------------------------------------------------
-- BEAST_LORE
-- ---------------------------------------------------------------------
add("BEAST_LORE", "say", "Knowledge is the best weapon.")
add("BEAST_LORE", "say", "Let’s see what we’re dealing with here.")

-- ---------------------------------------------------------------------
-- BEAST_LORE
-- ---------------------------------------------------------------------
add("BEAST_LORE", "customemote", "studies {TARGET} carefully, noting its strengths and weaknesses.")

-- ---------------------------------------------------------------------
-- BESTIAL_WRATH
-- ---------------------------------------------------------------------
add("BESTIAL_WRATH", "say", "Unleash the fury!")
add("BESTIAL_WRATH", "say", "No chains can hold my beast!")

-- ---------------------------------------------------------------------
-- BESTIAL_WRATH
-- ---------------------------------------------------------------------
add("BESTIAL_WRATH", "customemote", "lets out a battle cry as {PNAME} erupts into a furious rage.")

-- ---------------------------------------------------------------------
-- TRANQUILIZING_SHOT
-- ---------------------------------------------------------------------
add("TRANQUILIZING_SHOT", "say", "Calm yourself, {TARGET}.")
add("TRANQUILIZING_SHOT", "say", "Let’s quiet things down a bit.")

-- ---------------------------------------------------------------------
-- TRANQUILIZING_SHOT
-- ---------------------------------------------------------------------
add("TRANQUILIZING_SHOT", "customemote", "fires a precise shot, subduing {TARGET}’s energy.")

-- ---------------------------------------------------------------------
-- ARCANE_SHOT
-- ---------------------------------------------------------------------
add("ARCANE_SHOT", "say", "Magic and steel, the perfect combination!")
add("ARCANE_SHOT", "say", "A touch of the arcane never hurts... unless you're the target!")

-- ---------------------------------------------------------------------
-- ARCANE_SHOT
-- ---------------------------------------------------------------------
add("ARCANE_SHOT", "customemote", "adds some arcane power to this shot for a little more oomph.")
add("ARCANE_SHOT", "customemote", "sends the gift of an arcane shot, from me to you, {TARGET}.")
add("ARCANE_SHOT", "customemote", "blasts {TARGET} with some arcane power.")

-- ---------------------------------------------------------------------
-- CONCUSSIVE_SHOT
-- ---------------------------------------------------------------------
add("CONCUSSIVE_SHOT", "say", "Not so fast, {TARGET}!")
add("CONCUSSIVE_SHOT", "say", "Enjoy the last few seconds of your life, {TARGET}.")
add("CONCUSSIVE_SHOT", "say", "Whoah, slow down, {TARGET}!")
add("CONCUSSIVE_SHOT", "say", "Going somewhere? I think not.")

-- ---------------------------------------------------------------------
-- CONCUSSIVE_SHOT
-- ---------------------------------------------------------------------
add("CONCUSSIVE_SHOT", "customemote", "suggests {TARGET} slows down a bit.")

-- ---------------------------------------------------------------------
-- DISTRACTING_SHOT
-- ---------------------------------------------------------------------
add("DISTRACTING_SHOT", "say", "Yoohoo... look at me!")
add("DISTRACTING_SHOT", "say", "Over here, big guy!")

-- ---------------------------------------------------------------------
-- DISTRACTING_SHOT
-- ---------------------------------------------------------------------
add("DISTRACTING_SHOT", "customemote", "tries to distract {TARGET}.")

-- ---------------------------------------------------------------------
-- MULTI_SHOT
-- ---------------------------------------------------------------------
add("MULTI_SHOT", "say", "One shot, multiple problems solved!")
add("MULTI_SHOT", "say", "A hail of arrows just for you!")

-- ---------------------------------------------------------------------
-- MULTI_SHOT
-- ---------------------------------------------------------------------
add("MULTI_SHOT", "customemote", "looses multiple arrows in quick succession.")

-- ---------------------------------------------------------------------
-- AIMED_SHOT
-- ---------------------------------------------------------------------
add("AIMED_SHOT", "say", "Ready, Aim, Fire!")
add("AIMED_SHOT", "say", "Precision is everything.")

-- ---------------------------------------------------------------------
-- AIMED_SHOT
-- ---------------------------------------------------------------------
add("AIMED_SHOT", "customemote", "takes careful aim at {TARGET}.")

-- ---------------------------------------------------------------------
-- SCATTER_SHOT
-- ---------------------------------------------------------------------
add("SCATTER_SHOT", "say", "Let’s cause a little chaos!")
add("SCATTER_SHOT", "say", "Try dodging this!")

-- ---------------------------------------------------------------------
-- SCATTER_SHOT
-- ---------------------------------------------------------------------
add("SCATTER_SHOT", "customemote", "fires a wide-spread shot, throwing {TARGET} off balance.")

-- ---------------------------------------------------------------------
-- SERPENT_STING
-- ---------------------------------------------------------------------
add("SERPENT_STING", "say", "A bite worse than any snake’s.")
add("SERPENT_STING", "say", "Poison makes everything more interesting.")

-- ---------------------------------------------------------------------
-- SERPENT_STING
-- ---------------------------------------------------------------------
add("SERPENT_STING", "customemote", "watches as venom seeps into {TARGET}.")

-- ---------------------------------------------------------------------
-- SCORPID_STING
-- ---------------------------------------------------------------------
add("SCORPID_STING", "say", "Let’s see how you fight while weakened!")
add("SCORPID_STING", "say", "A little sting goes a long way.")

-- ---------------------------------------------------------------------
-- SCORPID_STING
-- ---------------------------------------------------------------------
add("SCORPID_STING", "customemote", "delivers a crippling shot to {TARGET}.")

-- ---------------------------------------------------------------------
-- VIPER_STING
-- ---------------------------------------------------------------------
add("VIPER_STING", "say", "Draining your energy one shot at a time.")
add("VIPER_STING", "say", "Mana is a resource... and now it's mine!")

-- ---------------------------------------------------------------------
-- VIPER_STING
-- ---------------------------------------------------------------------
add("VIPER_STING", "customemote", "fires a stinging shot, sapping {TARGET}'s energy.")

-- ---------------------------------------------------------------------
-- HUNTERS_MARK
-- ---------------------------------------------------------------------
add("HUNTERS_MARK", "say", "You can’t hide from me now.")
add("HUNTERS_MARK", "say", "Once marked, always hunted.")

-- ---------------------------------------------------------------------
-- HUNTERS_MARK
-- ---------------------------------------------------------------------
add("HUNTERS_MARK", "customemote", "marks {TARGET} for death with a knowing smirk.")

-- ---------------------------------------------------------------------
-- DETERRENCE
-- ---------------------------------------------------------------------
add("DETERRENCE", "say", "Try me. I dare you.")
add("DETERRENCE", "say", "You think you can hit me? Think again.")

-- ---------------------------------------------------------------------
-- DETERRENCE
-- ---------------------------------------------------------------------
add("DETERRENCE", "customemote", "adopts a defensive stance, ready to deflect incoming attacks.")

-- ---------------------------------------------------------------------
-- DISENGAGE
-- ---------------------------------------------------------------------
add("DISENGAGE", "say", "Time to reposition!")
add("DISENGAGE", "say", "A hunter knows when to back off.")

-- ---------------------------------------------------------------------
-- DISENGAGE
-- ---------------------------------------------------------------------
add("DISENGAGE", "customemote", "leaps back swiftly, avoiding danger.")

-- ---------------------------------------------------------------------
-- RAPID_FIRE
-- ---------------------------------------------------------------------
add("RAPID_FIRE", "say", "Faster, deadlier, unstoppable!")
add("RAPID_FIRE", "say", "Let’s see how fast you can dodge!")

-- ---------------------------------------------------------------------
-- RAPID_FIRE
-- ---------------------------------------------------------------------
add("RAPID_FIRE", "customemote", "fires a rapid volley of arrows at {TARGET}.")

-- ---------------------------------------------------------------------
-- FLARE
-- ---------------------------------------------------------------------
add("FLARE", "say", "Nowhere to hide!")
add("FLARE", "say", "Let’s shed some light on the situation.")

-- ---------------------------------------------------------------------
-- FLARE
-- ---------------------------------------------------------------------
add("FLARE", "customemote", "tosses a flare, illuminating hidden threats.")

-- ---------------------------------------------------------------------
-- TRUESHOT_AURA
-- ---------------------------------------------------------------------
add("TRUESHOT_AURA", "say", "Let my aim guide us all.")
add("TRUESHOT_AURA", "say", "With focus, we cannot miss.")

-- ---------------------------------------------------------------------
-- TRUESHOT_AURA
-- ---------------------------------------------------------------------
add("TRUESHOT_AURA", "customemote", "radiates an aura of precision and confidence.")

-- ---------------------------------------------------------------------
-- VOLLEY
-- ---------------------------------------------------------------------
add("VOLLEY", "say", "Raining arrows upon you!")
add("VOLLEY", "say", "You can run, but you can’t hide!")

-- ---------------------------------------------------------------------
-- VOLLEY
-- ---------------------------------------------------------------------
add("VOLLEY", "customemote", "fires a relentless volley of arrows into the air.")

-- ---------------------------------------------------------------------
-- TRACK_BEASTS
-- ---------------------------------------------------------------------
add("TRACK_BEASTS", "say", "The land speaks, and I listen.")
add("TRACK_BEASTS", "say", "No beast can hide from my sight.")
add("TRACK_BEASTS", "say", "Fresh tracks... it’s close.")

-- ---------------------------------------------------------------------
-- TRACK_BEASTS
-- ---------------------------------------------------------------------
add("TRACK_BEASTS", "customemote", "studies the ground, tracing the path of a beast.")

-- ---------------------------------------------------------------------
-- TRACK_HUMANOIDS
-- ---------------------------------------------------------------------
add("TRACK_HUMANOIDS", "say", "Every step leaves a story behind.")
add("TRACK_HUMANOIDS", "say", "Someone's been through here recently.")

-- ---------------------------------------------------------------------
-- TRACK_HUMANOIDS
-- ---------------------------------------------------------------------
add("TRACK_HUMANOIDS", "customemote", "examines the tracks, noting signs of recent movement.")

-- ---------------------------------------------------------------------
-- TRACK_UNDEAD
-- ---------------------------------------------------------------------
add("TRACK_UNDEAD", "say", "The air reeks of decay...")
add("TRACK_UNDEAD", "say", "Undeath lingers in these lands.")

-- ---------------------------------------------------------------------
-- TRACK_UNDEAD
-- ---------------------------------------------------------------------
add("TRACK_UNDEAD", "customemote", "scans the area, searching for unnatural movements.")

-- ---------------------------------------------------------------------
-- TRACK_HIDDEN
-- ---------------------------------------------------------------------
add("TRACK_HIDDEN", "say", "Shadows do not conceal from me.")
add("TRACK_HIDDEN", "say", "Something lurks nearby...")

-- ---------------------------------------------------------------------
-- TRACK_HIDDEN
-- ---------------------------------------------------------------------
add("TRACK_HIDDEN", "customemote", "carefully scans the area, looking for concealed threats.")

-- ---------------------------------------------------------------------
-- TRACK_ELEMENTALS
-- ---------------------------------------------------------------------
add("TRACK_ELEMENTALS", "say", "The elements whisper their presence.")
add("TRACK_ELEMENTALS", "say", "I feel a shift in the air...")

-- ---------------------------------------------------------------------
-- TRACK_ELEMENTALS
-- ---------------------------------------------------------------------
add("TRACK_ELEMENTALS", "customemote", "focuses intently, sensing elemental disturbances.")

-- ---------------------------------------------------------------------
-- TRACK_DEMONS
-- ---------------------------------------------------------------------
add("TRACK_DEMONS", "say", "The stench of fel magic lingers here.")
add("TRACK_DEMONS", "say", "A demon’s presence is never subtle.")

-- ---------------------------------------------------------------------
-- TRACK_DEMONS
-- ---------------------------------------------------------------------
add("TRACK_DEMONS", "customemote", "narrows {PP} eyes, feeling the presence of demonic energy.")

-- ---------------------------------------------------------------------
-- TRACK_GIANTS
-- ---------------------------------------------------------------------
add("TRACK_GIANTS", "say", "Heavy footsteps... something massive passed this way.")
add("TRACK_GIANTS", "say", "Giants leave more than footprints behind.")

-- ---------------------------------------------------------------------
-- TRACK_GIANTS
-- ---------------------------------------------------------------------
add("TRACK_GIANTS", "customemote", "studies the ground, noting deep, heavy tracks.")

-- ---------------------------------------------------------------------
-- TRACK_DRAGONKIN
-- ---------------------------------------------------------------------
add("TRACK_DRAGONKIN", "say", "The air feels charged... dragonkin are near.")
add("TRACK_DRAGONKIN", "say", "Claw marks, scorched earth... a dragon has passed through.")

-- ---------------------------------------------------------------------
-- TRACK_DRAGONKIN
-- ---------------------------------------------------------------------
add("TRACK_DRAGONKIN", "customemote", "studies the terrain, recognizing draconic signs.")

-- ---------------------------------------------------------------------
-- IMMOLATION_TRAP
-- ---------------------------------------------------------------------
add("IMMOLATION_TRAP", "say", "Fire cleanses all.")
add("IMMOLATION_TRAP", "say", "Let them burn!")

-- ---------------------------------------------------------------------
-- IMMOLATION_TRAP
-- ---------------------------------------------------------------------
add("IMMOLATION_TRAP", "customemote", "sets a fiery trap, ready to ignite anything that steps too close.")

-- ---------------------------------------------------------------------
-- FREEZING_TRAP
-- ---------------------------------------------------------------------
add("FREEZING_TRAP", "say", "Time for someone to chill out.")

-- ---------------------------------------------------------------------
-- FREEZING_TRAP
-- ---------------------------------------------------------------------
add("FREEZING_TRAP", "customemote", "places a freezing trap, prepared to ensnare the unwary.")

-- ---------------------------------------------------------------------
-- FROST_TRAP
-- ---------------------------------------------------------------------
add("FROST_TRAP", "say", "This should slow things down a bit.")

-- ---------------------------------------------------------------------
-- FROST_TRAP
-- ---------------------------------------------------------------------
add("FROST_TRAP", "customemote", "sets a trap to hinder movement with an icy touch.")

-- ---------------------------------------------------------------------
-- EXPLOSIVE_TRAP
-- ---------------------------------------------------------------------
add("EXPLOSIVE_TRAP", "say", "A little surprise for the reckless.")
add("EXPLOSIVE_TRAP", "say", "Boom!")

-- ---------------------------------------------------------------------
-- EXPLOSIVE_TRAP
-- ---------------------------------------------------------------------
add("EXPLOSIVE_TRAP", "customemote", "carefully sets a trap filled with volatile energy.")

-- ---------------------------------------------------------------------
-- RAPTOR_STRIKE
-- ---------------------------------------------------------------------
add("RAPTOR_STRIKE", "say", "A hunter fights at any range!")
add("RAPTOR_STRIKE", "say", "The claws of the raptor strike fast!")

-- ---------------------------------------------------------------------
-- RAPTOR_STRIKE
-- ---------------------------------------------------------------------
add("RAPTOR_STRIKE", "customemote", "lunges forward with a fierce melee strike.")

-- ---------------------------------------------------------------------
-- WING_CLIP
-- ---------------------------------------------------------------------
add("WING_CLIP", "say", "You won’t be running away so easily.")
add("WING_CLIP", "say", "A clipped enemy is a helpless one.")

-- ---------------------------------------------------------------------
-- WING_CLIP
-- ---------------------------------------------------------------------
add("WING_CLIP", "customemote", "slashes at {TARGET}’s legs, hindering their movement.")

-- ---------------------------------------------------------------------
-- MONGOOSE_BITE
-- ---------------------------------------------------------------------
add("MONGOOSE_BITE", "say", "Fangs faster than the eye!")
add("MONGOOSE_BITE", "say", "A mongoose never lets go!")

-- ---------------------------------------------------------------------
-- MONGOOSE_BITE
-- ---------------------------------------------------------------------
add("MONGOOSE_BITE", "customemote", "counters with a swift and deadly strike.")

-- ---------------------------------------------------------------------
-- COUNTERATTACK
-- ---------------------------------------------------------------------
add("COUNTERATTACK", "say", "Defense is the best offense!")
add("COUNTERATTACK", "say", "You strike, I counter!")

-- ---------------------------------------------------------------------
-- COUNTERATTACK
-- ---------------------------------------------------------------------
add("COUNTERATTACK", "customemote", "parries and swiftly retaliates with a powerful strike.")

-- ---------------------------------------------------------------------
-- FEIGN_DEATH
-- ---------------------------------------------------------------------
add("FEIGN_DEATH", "say", "Shhh! Don't tell them I'm not really dead.")

-- ---------------------------------------------------------------------
-- FEIGN_DEATH
-- ---------------------------------------------------------------------
add("FEIGN_DEATH", "customemote", "feigns {PP} death.")

-- ---------------------------------------------------------------------
-- CARVE
-- ---------------------------------------------------------------------
add("CARVE", "say", "A pack hunts together!")
add("CARVE", "say", "Surrounded? Perfect.")
add("CARVE", "say", "I'll carve through you all!")
add("CARVE", "say", "Sweep and scatter!")
add("CARVE", "say", "One cut, five wounds!")

-- ---------------------------------------------------------------------
-- CARVE
-- ---------------------------------------------------------------------
add("CARVE", "customemote", "slashes {PP} blade in a wide arc, cutting down multiple foes.")

-- ---------------------------------------------------------------------
-- ASPECT_OF_THE_WOLF
-- ---------------------------------------------------------------------
add("ASPECT_OF_THE_WOLF", "say", "Time to hunt like a true predator!")
add("ASPECT_OF_THE_WOLF", "say", "No bow. No arrows. Just fang and claw!")
add("ASPECT_OF_THE_WOLF", "say", "Strength of the pack, speed of the wolf!")

-- ---------------------------------------------------------------------
-- ASPECT_OF_THE_WOLF
-- ---------------------------------------------------------------------
add("ASPECT_OF_THE_WOLF", "customemote", "shifts stance, adopting the predatory movements of a wolf.")

-- ---------------------------------------------------------------------
-- STEADY_SHOT
-- ---------------------------------------------------------------------
add("STEADY_SHOT", "say", "Steady hands, deadliest aim.")
add("STEADY_SHOT", "say", "Precision makes perfection.")
add("STEADY_SHOT", "say", "A well-placed shot is worth a dozen rushed ones.")

-- ---------------------------------------------------------------------
-- STEADY_SHOT
-- ---------------------------------------------------------------------
add("STEADY_SHOT", "customemote", "draws back {PP} bowstring slowly, ensuring a lethal shot at {TARGET}.")

