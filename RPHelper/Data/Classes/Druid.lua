-- RPHelper Forever - Druid English content
-- Corpus migration from the RPhelper_twow Druid catalogue and original RoleplayingHelper lineage.
-- The legacy Druid source carried no named contributor attribution.

local C = RPHelper.Class.DRUID
local function add(trigger, entryType, text)
    RPHelper.RegisterClass(C, trigger, { type = entryType, text = text })
end
local function addForm(form, trigger, entryType, text)
    RPHelper.RegisterDruidForm(form, trigger, { type = entryType, text = text })
end

-- ---------------------------------------------------------------------
-- ENTERCOMBAT
-- ---------------------------------------------------------------------
add("entercombat", "say", "I will destroy those who disrupt nature.")
add("entercombat", "say", "I sense darkness in the dream.")
add("entercombat", "say", "For nature's survival!")
add("entercombat", "say", "The grass beneath your feet screams, I answer!")

-- ---------------------------------------------------------------------
-- ENTERCOMBAT
-- ---------------------------------------------------------------------
add("entercombat", "emote", "CHARGE")
add("entercombat", "emote", "ROAR")

-- Shapeshifted combat reactions replace the ordinary character pool for an
-- authored form/event combination. Dire Bear shares the Bear catalogue.
local F = RPHelper.DruidForms.Form

addForm(F.CAT, "entercombat", "customemote", "lowers its body, muscles tightening beneath its fur.")
addForm(F.CAT, "entercombat", "customemote", "fixes its gaze upon its adversary, perfectly still.")
addForm(F.CAT, "entercombat", "emote", "SNARL")
addForm(F.CAT, "youcrit", "customemote", "surges forward with sudden, controlled force.")
addForm(F.CAT, "youcrit", "customemote", "bares its fangs, its attention fixed ahead.")
addForm(F.CAT, "dodge", "customemote", "twists aside in one fluid motion.")
addForm(F.CAT, "dodge", "customemote", "springs clear and drops immediately back into a crouch.")
addForm(F.CAT, "hurt", "customemote", "flattens its ears and holds its ground.")
addForm(F.CAT, "hurt", "customemote", "draws low to the ground, breathing hard but watchful.")
addForm(F.CAT, "leavecombat", "customemote", "slowly eases from its crouch, ears turning toward the quiet.")
addForm(F.CAT, "leavecombat", "customemote", "stands motionless for a moment, listening for further danger.")

addForm(F.BEAR, "entercombat", "customemote", "digs its claws into the earth and lowers its head.")
addForm(F.BEAR, "entercombat", "customemote", "rises onto its hind legs, presenting its full height.")
addForm(F.BEAR, "entercombat", "emote", "GROWL")
addForm(F.BEAR, "youcrit", "customemote", "drives forward with a heavy, forceful movement.")
addForm(F.BEAR, "youcrit", "customemote", "plants its forepaws and presses the attack.")
addForm(F.BEAR, "dodge", "customemote", "lurches aside with surprising speed.")
addForm(F.BEAR, "dodge", "customemote", "shifts its massive weight clear of the blow.")
addForm(F.BEAR, "hurt", "customemote", "snorts heavily and refuses to yield.")
addForm(F.BEAR, "hurt", "customemote", "hunches behind its shoulders, claws gripping the ground.")
addForm(F.BEAR, "leavecombat", "customemote", "drops back onto all fours and surveys the quiet.")
addForm(F.BEAR, "leavecombat", "customemote", "shakes out its fur and settles its weight.")

addForm(F.MOONKIN, "entercombat", "customemote", "spreads its feathered arms and stamps the ground.")
addForm(F.MOONKIN, "entercombat", "emote", "ROAR")
addForm(F.MOONKIN, "youcrit", "customemote", "beats its wings once and holds its ground.")
addForm(F.MOONKIN, "youcrit", "customemote", "lets out a sharp, wordless hoot.")
addForm(F.MOONKIN, "dodge", "customemote", "hops aside, feathers rustling.")
addForm(F.MOONKIN, "dodge", "customemote", "turns away from the strike with a sweep of its wings.")
addForm(F.MOONKIN, "hurt", "customemote", "ruffles its feathers and braces itself.")
addForm(F.MOONKIN, "hurt", "customemote", "hunches low, answering with a harsh screech.")
addForm(F.MOONKIN, "leavecombat", "customemote", "folds its wings and grows still.")
addForm(F.MOONKIN, "leavecombat", "customemote", "gives a low hoot as the tension passes.")
