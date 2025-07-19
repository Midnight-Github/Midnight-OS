-- Library for utility functions


-- Rednet functions

-- Function to pair your sender with a receiver
local function pairSender(receiver_id, protocol) 
    while true do
        rednet.send(receiver_id, "pair", protocol)
        local received_id, msg, received_protocol = rednet.receive(protocol, 3)

        if received_id == receiver_id and msg == "paired" and received_protocol == protocol then
            return {true, nil}
        end
    end
end

-- Function to pair your receiver with a sender
local function pairReceiver(sender_id, protocol) 
    local received_id, msg, received_protocol = rednet.receive(protocol)

    if received_id == sender_id and msg == "pair" and received_protocol == protocol then
        sleep(1)
        rednet.send(sender_id, "paired", protocol)
        return {true, nil}
    end

    return {false, {received_id, msg, received_protocol}}
end

-- Function to receive a message from a specified sender with a specified protocol
local function getMessage(sender_id, protocol)
    local received_id, msg, received_protocol
    repeat
        received_id, msg, received_protocol = rednet.receive(protocol)
    until received_id == sender_id and received_protocol == protocol
    return msg
end


-- Math functions

local function round(num, precision)
    precision = precision or 1
    return math.floor(num / precision + 0.5) * precision
end

local function signum(num)
    if num > 0 then
        return 1
    elseif num < 0 then
        return -1
    elseif num == 0 then
        return 0
    end
    return nil
end

local function fractionalPart(num)
    return num - math.floor(num)
end

local function factorial(num)
    if num < 0 then return nil end
    if num == 0 then return 1 end

    local res = 1
    for i = 2, num do
        res = res * i
    end
    return res
end

-- Trigonometric functions

local function cosec(x)
    return 1 / math.sin(x)
end

local function sec(x)
    return 1 / math.cos(x)
end

local function cot(x)
    return 1 / math.tan(x)
end

local function asec(x)
    if x == 0 then return nil end
    return math.acos(1 / x)
end

local function acot(x)
    if x == 0 then return math.pi / 2 end
    return math.atan(1 / x)
end

local function acosec(x)
    if x == 0 then return nil end
    return math.asin(1 / x)
end

local function sinh(x)
    return (math.exp(x) - math.exp(-x)) / 2
end
local function cosh(x)
    return (math.exp(x) + math.exp(-x)) / 2
end
local function tanh(x)
    return sinh(x) / cosh(x)
end

local function cosech(x)
    return 1 / sinh(x)
end

local function sech(x)
    return 1 / cosh(x)
end

local function coth(x)
    return 1 / tanh(x)
end


-- Iter functions

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

-- python like zip function
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

-- Splits the input string by the given delimiter (defaults to space) and returns a table of substrings.
local function split(input, delimiter)
    delimiter = delimiter or " "
    local result = {}
    for match in (input .. delimiter):gmatch("(.-)" .. delimiter) do
        table.insert(result, match)
    end
    return result
end

-- Checks if val is present in a table list
local function contains(list, val)
    for _, v in ipairs(list) do
        if v == val then 
            return true 
        end
    end
    return false
end

-- Returns the index of value in the array-like table list, or nil if not found.
local function indexOf(list, value)
    for i, v in ipairs(list) do
        if v == value then
            return i
        end
    end
    return nil
end

-- Returns keys of a key-value pair table
local function getKeys(tbl)
    local keys = {}
    for k, _ in pairs(tbl) do
        table.insert(keys, k)
    end
    return keys
end

-- Evaluates a string as a Lua expression
local function eval(expr, env)
    env = env or _ENV
    local f, err = load("return " .. expr, "eval", "t", env)
    if not f then
        return nil, err
    end
    local ok, result = pcall(f)
    if ok then
        return result
    else
        return nil, result
    end
end

-- Removes any trailing or leading white spaces
local function trim(string)
    return (string:gsub("^%s*(.-)%s*$", "%1"))
end

-- Python like string multiplication
local function repeatString(str, count)
    if count <= 0 then return "" end

    local result = ""
    for i = 1, count do
        result = result..str
    end
    return result
end


-- Redstone functions

-- Sends a redstone pulse on the specified side for the given delay (in seconds).
local function redstonePulse(side, delay)
    delay = delay or 0
    redstone.setOutput(side, true)
    sleep(delay)
    redstone.setOutput(side, false)
end


-- UI functions
-- Returns the center position of text
local function getCenterPos(screen_length, text_length)
    return math.max(1, math.floor((screen_length - text_length) / 2) + 1)
end


-- IO functions
-- Returns file path and extension
local function splitPathExtension(file_path)
    local base, ext = file_path:match("(.+)%.([^%.]+)$")
    if base and ext then
        return base, ext
    else
        return file_path, nil
    end
end

-- Wrapper function that ensures safe file access by file locking mechanism.
local function withSafeFile(path, mode, callback)
    local base, ext = splitPathExtension(path)
    local file_lock_path = base..".lock"
    while fs.exists(file_lock_path) do sleep(0.05) end

    local lock = fs.open(file_lock_path, "w")
    lock.close()

    local file = fs.open(path, mode)
    local ok, result = pcall(callback, file)

    if file then file.close() end
    if fs.exists(file_lock_path) then fs.delete(file_lock_path) end

    if ok then return result
    else error(result, 2)
    end
end

-- Moves a file to a new location and inserts a timestamp to its name.
local function archiveFile(file_path, archive_file_path, timestamp)
    if not fs.exists(file_path) then return false end

    local base, ext = splitPathExtension(archive_file_path)
    ext = ext or "txt"

    local archive_dir = fs.getDir(archive_file_path)
    if not fs.exists(archive_dir) then
        fs.makeDir(archive_dir)
    end

    fs.move(file_path, base .. "-" .. timestamp .. "." .. ext)

    return true
end

-- Truncates the archive directory by deleting old files until only max_files remains.
-- Assumes files are named in the format: base-<timestamp>.extension
-- Files without the format are ignored.
local function truncateArchiveDir(archive_dir_path, max_files)
    if not fs.exists(archive_dir_path) then return end

    local files = fs.list(archive_dir_path)
    local archive_files = {}

    -- Only include files with a timestamp in their name
    for _, fname in ipairs(files) do
        if fname:match("%-(%d+)%..-$") then
            table.insert(archive_files, fname)
        end
    end

    if #archive_files <= max_files then return end

    table.sort(archive_files, function(a, b)
        local a_time = tonumber(a:match("%-(%d+)%..-$"))
        local b_time = tonumber(b:match("%-(%d+)%..-$"))
        return a_time < b_time
    end)

    for i = 1, #archive_files - max_files do
        fs.delete(fs.combine(archive_dir_path, archive_files[i]))
    end
end

-- Utiltiy functions
-- Returns a table of lines that are wrapped to the specified width.
local function wordWrap(text, width)
    local lines = {}
    -- Split text into lines, preserving empty lines
    for line in text:gmatch("([^\n]*)\n?") do
        -- If the line is empty (from consecutive \n), preserve it
        if line == "" then
            table.insert(lines, "")
        else
            local current = ""
            for word in line:gmatch("%S+") do
                while #word > width do
                    if #current > 0 then
                        table.insert(lines, current)
                        current = ""
                    end
                    table.insert(lines, word:sub(1, width))
                    word = word:sub(width + 1)
                end
                if #current + #word + (current == "" and 0 or 1) > width then
                    table.insert(lines, current)
                    current = word
                else
                    if current ~= "" then
                        current = current .. " "
                    end
                    current = current .. word
                end
            end
            if current ~= "" then
                table.insert(lines, current)
            end
        end
    end
    -- Remove the last empty line if the text doesn't end with \n
    if lines[#lines] == "" and text:sub(-1) ~= "\n" then
        table.remove(lines, #lines)
    end
    return lines
end


-- Return functions
return {
    pairSender = pairSender,
    pairReceiver = pairReceiver,
    getMessage = getMessage,
    round = round,
    signum = signum,
    fractionalPart = fractionalPart,
    factorial = factorial,
    cosec = cosec,
    sec = sec,
    cot = cot,
    asec = asec,
    acot = acot,
    acosec = acosec,
    sinh = sinh,
    cosh = cosh,
    tanh = tanh,
    cosech = cosech,
    sech = sech,
    coth = coth,
    any = any,
    iany = iany,
    all = all,
    iall = iall,
    zip = zip,
    split = split,
    contains = contains,
    indexOf = indexOf,
    getKeys = getKeys,
    eval = eval,
    trim = trim,
    repeatString = repeatString,
    redstonePulse = redstonePulse,
    getCenterPos = getCenterPos,
    splitPathExtension = splitPathExtension,
    withSafeFile = withSafeFile,
    archiveFile = archiveFile,
    truncateArchiveDir = truncateArchiveDir,
    wordWrap = wordWrap
}