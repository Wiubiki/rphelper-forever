-- RPHelper Forever - English random insult content
-- Corpus and combination structure retained from RPhelper_twow/English/RInsult.lua.
-- Original contributor attribution: mithyk.

RPHelper.RandomInsults = RPHelper.RandomInsults or {}

local RandomInsults = RPHelper.RandomInsults

RandomInsults.Pools = {
    ANY = {
        {
            "annoying", "cantankerous", "demented", "disgusting", "festering", "filthy", "infuriating",
            "insignificant", "laughable", "nauseating", "noxious", "pathetic", "pitiful", "revolting", "rotten",
            "sickening", "useless",
        },
        {
            "lump of", "crock of", "ball of", "mass of", "tub of", "loaf of", "bucket of", "mound of",
            "bunch of", "stack of", "excuse for", "glob of", "bag of", "heap of", "mountain of", "load of",
            "barrel of", "sack of", "blob of", "pile of", "clump of", "shovel full of", "bowl of",
            "wheelbarrel full of", "box of", "crate of", "collection of", "wagonload of", "vat of",
        },
        {
            "armpit hairs", "cow cud", "cow pies", "fleas", "foot fungus", "garbage", "gutter mud", "hogwash",
            "leprosy scabs", "mule froth", "nasal hairs", "navel lint", "nose pickings", "pigeon bombs",
            "pimple squeezings", "puke curds", "puke lumps", "rabbit raisins", "rubbish", "sewage",
            "sewer seepage", "sinus clots", "sinus drainage", "spittoon spillage", "stable sweepings",
            "swamp mud", "swine", "manure", "kodo manure", "murloc manure", "droppings", "kodo droppings",
            "murloc droppings", "trogg cysts", "murloc entrails", "buzzard innards",
        },
    },
    GNOME = {
        {
            "bad breathed", "boring", "contaminated", "contemptible", "crusty", "defective", "erratic",
            "imitation", "inadequate", "incapable", "inept", "infantile", "insufferable", "irrational", "lousy",
            "malignant", "mentally deficient", "monotonous", "mutilated", "obnoxious", "pitiable", "predictable",
            "putrid", "second-hand", "sloshy", "spastic", "stale", "stenchy", "unimpressive",
        },
        {},
        {},
    },
    PALADIN = {
        {
            "appalling", "deeply disturbed", "depraved", "dirty", "disgraceful", "dismal", "embarrassing", "foul",
            "grisly", "grotesque", "gruesome", "hopeless", "infested", "lazy", "moth-eaten", "nasty", "perverted",
            "repulsive", "shameless", "sick", "sloppy",

            -- From a Shakespearean insult generator; attribution retained from the legacy source: mithyk.
            "annoying", "artless", "bawdy", "beslubbering", "bootless", "churlish", "cockered", "clouted", "craven",
            "currish", "dankish", "disgusting", "dissembling", "droning", "errant", "fawning", "festering", "fobbing",
            "forward", "frothy", "gleeking", "goatish", "gorbellied", "impertinent", "infectious", "insignificant",
            "jarring", "laughable", "loggerheaded", "lumpish", "mammering", "mangled", "mewling", "nauseating",
            "pathetic", "paunchy", "pitiful", "pribbling", "puking", "puny", "qualling", "rank", "reeky", "revolting",
            "roguish", "rotten", "ruttish", "saucy", "sickening", "spleeny", "spongy", "surly", "tottering",
            "unmuzzled", "vain", "venomed", "villainous", "warped", "wayward", "weedy", "yeasty", "cullionly",
            "fusty", "calumnious", "wimpled", "burly-boned", "misbegotten", "odiferous", "poisonous", "fishified",
            "wart-necked",

            -- The legacy source stores the generator's second-part words in part one.
            "base-court", "bat-fowling", "beef-witted", "beetle-headed", "boil-brained", "clapper-clawed",
            "clay-brained", "common-kissing", "crook-pated", "dismal-dreaming", "dizzy-eyed", "doghearted",
            "dread-bolted", "earth-vexing", "elf-skinned", "fat-kidneyed", "fen-sucked", "flap-mouthed", "fly-bitten",
            "folly-fallen", "fool-born", "full-gorged", "guts-griping", "half-faced", "hasty-witted", "hedge-born",
            "hell-hated", "idle-headed", "ill-breeding", "ill-nurtured", "knotty-pated", "milk-livered", "motley-minded",
            "onion-eyed", "plume-plucked", "pottle-deep", "pox-marked", "reeling-ripe", "rough-hewn", "rude-growing",
            "rump-fed", "shard-borne", "sheep-biting", "spur-galled", "swag-bellied", "tardy-gaited", "tickle-brained",
            "toad-spotted", "unchin-snouted", "weather-bitten", "whoreson", "malmsey-nosed", "rampallian",
            "lily-livered", "scurvy-valiant", "brazen-faced", "unwash'd", "bunch-back'd", "leaden-footed",
            "muddy-mettled", "pigeon-liver'd", "scale-sided",
        },
        {},
        {
            "apple-johns", "barnacles", "bladders", "boar-pigs", "bugbears", "bum-baileys", "canker-blossoms",
            "clack-dishs", "clotpoles", "coxcombs", "codpieces", "death-tokens", "dewberries", "flap-dragons",
            "flax-wenchs", "flirt-gills", "foot-lickers", "fustilarians", "giglets", "gudgeons", "haggards", "harpies",
            "hedge-pigs", "horn-beasts", "hugger-muggers", "joitheads", "lewdsters", "louts", "maggot-pies",
            "malt-worms", "mammets", "measles", "minnows", "miscreants", "moldwarps", "mumble-news", "nut-hooks",
            "pigeon-eggs", "pignuts", "puttocks", "pumpions", "ratsbanes", "scuts", "skainsmates", "strumpets",
            "varlots", "vassals", "whey-faces", "wagtails", "knaves", "blind-worms", "popinjays", "scullians",
            "jolt-heads", "malcontents", "devil-monks", "toads", "rascals", "Basket-Cockles",
        },
    },
    WARRIOR = {
        {
            "driveling", "double ugly", "dumpy", "dumb", "fermenting", "miserable", "moldy", "pompous", "rancid",
            "raunchy", "retarded", "seething", "septic", "skaggy", "smelly", "spoiled", "steaming", "stinking",
            "stupid", "ugly", "worthless",
        },
        {},
        { "puke", "vomit" },
    },
}

local function append(target, source)
    for index = 1, #source do
        target[#target + 1] = source[index]
    end
end

local function choose(pool, randomIndex)
    local chooser = randomIndex or math.random
    local ok, index = pcall(chooser, #pool)
    if not ok or type(index) ~= "number" or index % 1 ~= 0 or index < 1 or index > #pool then
        return nil
    end
    return pool[index]
end

function RandomInsults.Generate(context, randomIndex)
    context = type(context) == "table" and context or {}
    local values = type(context.values) == "table" and context.values or {}
    local class = values.PLAYER_CLASS or context.class
    local race = values.PLAYER_RACE
    local traits = { "ANY" }
    if type(race) == "string" and race ~= "" then traits[#traits + 1] = race end
    if type(class) == "string" and class ~= "" then traits[#traits + 1] = class end

    local parts = { {}, {}, {} }
    for _, trait in ipairs(traits) do
        local pools = RandomInsults.Pools[trait]
        if pools then
            for part = 1, 3 do append(parts[part], pools[part]) end
        end
    end

    if #parts[1] == 0 or #parts[2] == 0 or #parts[3] == 0 then return nil end
    local first = choose(parts[1], randomIndex)
    local second = choose(parts[2], randomIndex)
    local third = choose(parts[3], randomIndex)
    if not first or not second or not third then return nil end
    return "You " .. first .. " " .. second .. " " .. third .. "."
end

RPHelper.ContentEngine.SetInsultProvider(RandomInsults.Generate)
