-- Returns true if any value in the table list is true, otherwise false.
local function any(list)
    for _, value in pairs(list) do
        if value then
            return true
        end
    end

    return false
end

-- Returns true if any value in the array-like table list is true, otherwise false.
local function iany(list)
    for _, value in ipairs(list) do
        if value then
            return true
        end
    end

    return false
end

-- Returns true only if all values in the table list are true, otherwise false.
local function all(list)
    for _, value in pairs(list) do
        if not value then
            return false
        end
    end

    return true
end

-- Returns true only if all values in the array-like table list are true, otherwise false.
local function iall(list)
    for _, value in ipairs(list) do
        if not value then
            return false
        end
    end

    return true
end

return {
    any = any,
    iany = iany,
    all = all,
    iall = iall,
}