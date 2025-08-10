-- Returns keys of a key-value pair table
local function getKeys(tbl)
    local keys = {}
    for k, _ in pairs(tbl) do
        table.insert(keys, k)
    end
    return keys
end

-- Returns the index of value in the array-like table. nil if not found.
local function indexOf(list, value)
    for i, v in ipairs(list) do
        if v == value then
            return i
        end
    end
    return nil
end

-- Checks if val is present in a table
local function contains(list, val)
    for _, v in ipairs(list) do
        if v == val then
            return true
        end
    end
    return false
end

-- python like extend function
local function extend(dest, src)
    local insertIndex = 1
    for k, _ in pairs(dest) do
        if type(k) == "number" and k >= insertIndex then
            insertIndex = k + 1
        end
    end

    for k, v in pairs(src) do
        if type(k) == "number" then
            dest[insertIndex] = v
            insertIndex = insertIndex + 1
        else
            dest[k] = v
        end
    end
end

-- python like zip function for tables only
local function zip(...)
    local args = {...}
    local zipped = {}
    local len = math.huge
    for _, t in ipairs(args) do
        if #t < len then len = #t end
    end
    for i = 1, len do
        local tuple = {}
        for _, t in ipairs(args) do
            table.insert(tuple, t[i])
        end
        table.insert(zipped, tuple)
    end
    return zipped
end


return {
    getKeys = getKeys,
    indexOf = indexOf,
    contains = contains,
    extend = extend,
    zip = zip
}