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

-- Splits the input string by the given delimiter (defaults to space) and returns a table of substrings.
local function split(input, delimiter)
    delimiter = delimiter or " "
    local result = {}
    for match in (input .. delimiter):gmatch("(.-)" .. delimiter) do
        table.insert(result, match)
    end
    return result
end

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

return {
    trim = trim,
    repeatString = repeatString,
    split = split,
    wordWrap = wordWrap,
}