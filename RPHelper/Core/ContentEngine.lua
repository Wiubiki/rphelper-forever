RPHelper = RPHelper or {}
RPHelper.ContentEngine = RPHelper.ContentEngine or {}

local ContentEngine = RPHelper.ContentEngine
local insultProvider

local function chooseIndex(size, randomIndex)
    local chooser = randomIndex or math.random
    local ok, index = pcall(chooser, size)
    if not ok or type(index) ~= "number" or index % 1 ~= 0 or index < 1 or index > size then
        return nil
    end
    return index
end

local function copyEntry(entry)
    local result = {}
    for key, value in pairs(entry) do
        result[key] = value
    end
    return result
end

function ContentEngine.SetInsultProvider(provider)
    if provider ~= nil and type(provider) ~= "function" then
        error("insult provider must be a function or nil")
    end
    insultProvider = provider
end

-- Templates use numbered tokens such as {1}; dynamic keywords use explicit
-- uppercase tokens such as {PLAYER}. No token evaluates Lua code.
function ContentEngine.ExpandTemplate(entry, randomIndex)
    if type(entry) ~= "table" then
        return nil
    end

    if entry.template == nil then
        if type(entry.text) ~= "string" or entry.text == "" then
            return nil
        end
        return entry.text
    end

    if type(entry.template) ~= "string" or type(entry.choices) ~= "table" then
        return nil
    end

    local selected = {}
    local malformed = false
    local expanded = string.gsub(entry.template, "{(%d+)}", function(rawIndex)
        local choiceNumber = tonumber(rawIndex)
        local pool = choiceNumber and entry.choices[choiceNumber]
        if type(pool) ~= "table" or #pool == 0 then
            malformed = true
            return ""
        end

        if selected[choiceNumber] == nil then
            local index = chooseIndex(#pool, randomIndex)
            local value = index and pool[index]
            if type(value) ~= "string" then
                malformed = true
                return ""
            end
            selected[choiceNumber] = value
        end

        return selected[choiceNumber]
    end)

    if malformed or string.find(expanded, "{%d+}") or expanded == "" then
        return nil
    end
    return expanded
end

function ContentEngine.ResolveKeywords(text, options)
    if type(text) ~= "string" then
        return nil
    end

    options = options or {}
    local resolvers = options.resolvers or RPHelper.KeywordResolvers.Create(options.context)
    local provider = options.insultProvider or insultProvider
    local cache = {}
    local unresolved = false

    local function resolve(keyword)
        local cacheKey = keyword == "RINSULT!" and "RINSULT" or keyword
        if cache[cacheKey] == nil then
            local resolver = resolvers[cacheKey]
            if cacheKey == "RINSULT" then
                resolver = provider
            end

            if type(resolver) ~= "function" then
                cache[cacheKey] = false
            else
                local ok, value = pcall(function()
                    local resolvedValue = resolver(options.context)
                    if type(issecretvalue) == "function" and issecretvalue(resolvedValue) then
                        return nil
                    end
                    if type(resolvedValue) ~= "string" and type(resolvedValue) ~= "number" then
                        return nil
                    end
                    if resolvedValue == "" then
                        return nil
                    end
                    return tostring(resolvedValue)
                end)
                if not ok or value == nil then
                    cache[cacheKey] = false
                else
                    cache[cacheKey] = value
                end
            end
        end

        local value = cache[cacheKey]
        if value == false then
            unresolved = true
            return ""
        end

        if keyword == "RINSULT!" then
            return (string.gsub(value, "[%.!?]+$", "")) .. "!"
        end
        return value
    end

    local resolved = string.gsub(text, "{([A-Z][A-Z0-9_]*!?)}", resolve)
    if unresolved or string.find(resolved, "{[%w_!]+}") then
        return nil
    end
    return resolved
end

function ContentEngine.PrepareCandidate(entry, options)
    options = options or {}
    local expanded = ContentEngine.ExpandTemplate(entry, options.randomIndex)
    local resolved = expanded and ContentEngine.ResolveKeywords(expanded, options)
    if not resolved or resolved == "" then
        return nil
    end

    local candidate = copyEntry(entry)
    candidate.text = resolved
    candidate.template = nil
    candidate.choices = nil
    return candidate
end

function ContentEngine.PrepareCandidatePool(pool, options)
    local eligible = {}
    if type(pool) ~= "table" then
        return eligible
    end

    for _, entry in ipairs(pool) do
        local candidate = ContentEngine.PrepareCandidate(entry, options)
        if candidate then
            table.insert(eligible, candidate)
        end
    end
    return eligible
end

function ContentEngine.ChooseCandidate(pool, options)
    options = options or {}
    local eligible = ContentEngine.PrepareCandidatePool(pool, options)
    if #eligible == 0 then
        return nil
    end

    local index = chooseIndex(#eligible, options.randomIndex)
    return index and eligible[index] or nil
end
