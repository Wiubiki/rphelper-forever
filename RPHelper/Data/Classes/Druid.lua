-- RPHelper Forever - Druid English content
-- Corpus migration from the RPhelper_twow Druid catalogue and original RoleplayingHelper lineage.
-- The legacy Druid source carried no named contributor attribution.

local C = RPHelper.Class.DRUID
local function add(id, trigger, entryType, text)
    RPHelper.RegisterClass(C, trigger, { id = id, type = entryType, text = text })
end
local function addForm(id, form, trigger, entryType, text)
    RPHelper.RegisterDruidForm(form, trigger, { id = id, type = entryType, text = text })
end

-- ---------------------------------------------------------------------
-- ENTERCOMBAT
-- ---------------------------------------------------------------------
add("default:class:druid:0003", "entercombat", "say", "I will destroy those who disrupt nature.")
add("default:class:druid:0004", "entercombat", "say", "I sense darkness in the dream.")
add("default:class:druid:0005", "entercombat", "say", "For nature's survival!")
add("default:class:druid:0006", "entercombat", "say", "The grass beneath your feet screams, I answer!")
add("default:class:druid:0007", "entercombat", "emote", "CHARGE")
add("default:class:druid:0008", "entercombat", "emote", "ROAR")

-- Shapeshifted combat reactions replace the ordinary character pool for an
-- authored form/event combination. Dire Bear shares the Bear catalogue.
local F = RPHelper.DruidForms.Form

addForm("default:class:druid:0009", F.CAT, "entercombat", "customemote", "lowers its body, muscles tightening beneath its fur.")
addForm("default:class:druid:0010", F.CAT, "entercombat", "customemote", "fixes its gaze upon its adversary, perfectly still.")
addForm("default:class:druid:0011", F.CAT, "entercombat", "emote", "SNARL")
addForm("default:class:druid:0012", F.CAT, "youcrit", "customemote", "surges forward with sudden, controlled force.")
addForm("default:class:druid:0013", F.CAT, "youcrit", "customemote", "bares its fangs, its attention fixed ahead.")
addForm("default:class:druid:0014", F.CAT, "dodge", "customemote", "twists aside in one fluid motion.")
addForm("default:class:druid:0015", F.CAT, "dodge", "customemote", "springs clear and drops immediately back into a crouch.")
addForm("default:class:druid:0016", F.CAT, "hurt", "customemote", "flattens its ears and holds its ground.")
addForm("default:class:druid:0017", F.CAT, "hurt", "customemote", "draws low to the ground, breathing hard but watchful.")
addForm("default:class:druid:0018", F.CAT, "leavecombat", "customemote", "slowly eases from its crouch, ears turning toward the quiet.")
addForm("default:class:druid:0019", F.CAT, "leavecombat", "customemote", "stands motionless for a moment, listening for further danger.")

addForm("default:class:druid:0020", F.BEAR, "entercombat", "customemote", "digs its claws into the earth and lowers its head.")
addForm("default:class:druid:0021", F.BEAR, "entercombat", "customemote", "rises onto its hind legs, presenting its full height.")
addForm("default:class:druid:0022", F.BEAR, "entercombat", "emote", "GROWL")
addForm("default:class:druid:0023", F.BEAR, "youcrit", "customemote", "drives forward with a heavy, forceful movement.")
addForm("default:class:druid:0024", F.BEAR, "youcrit", "customemote", "plants its forepaws and presses the attack.")
addForm("default:class:druid:0025", F.BEAR, "dodge", "customemote", "lurches aside with surprising speed.")
addForm("default:class:druid:0026", F.BEAR, "dodge", "customemote", "shifts its massive weight clear of the blow.")
addForm("default:class:druid:0027", F.BEAR, "hurt", "customemote", "snorts heavily and refuses to yield.")
addForm("default:class:druid:0028", F.BEAR, "hurt", "customemote", "hunches behind its shoulders, claws gripping the ground.")
addForm("default:class:druid:0029", F.BEAR, "leavecombat", "customemote", "drops back onto all fours and surveys the quiet.")
addForm("default:class:druid:0030", F.BEAR, "leavecombat", "customemote", "shakes out its fur and settles its weight.")

addForm("default:class:druid:0031", F.MOONKIN, "entercombat", "customemote", "spreads its feathered arms and stamps the ground.")
addForm("default:class:druid:0032", F.MOONKIN, "entercombat", "emote", "ROAR")
addForm("default:class:druid:0033", F.MOONKIN, "youcrit", "customemote", "beats its wings once and holds its ground.")
addForm("default:class:druid:0034", F.MOONKIN, "youcrit", "customemote", "lets out a sharp, wordless hoot.")
addForm("default:class:druid:0035", F.MOONKIN, "dodge", "customemote", "hops aside, feathers rustling.")
addForm("default:class:druid:0036", F.MOONKIN, "dodge", "customemote", "turns away from the strike with a sweep of its wings.")
addForm("default:class:druid:0037", F.MOONKIN, "hurt", "customemote", "ruffles its feathers and braces itself.")
addForm("default:class:druid:0038", F.MOONKIN, "hurt", "customemote", "hunches low, answering with a harsh screech.")
addForm("default:class:druid:0039", F.MOONKIN, "leavecombat", "customemote", "folds its wings and grows still.")
addForm("default:class:druid:0040", F.MOONKIN, "leavecombat", "customemote", "gives a low hoot as the tension passes.")
