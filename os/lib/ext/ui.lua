-- Returns the center position of text
local function getCenterPos(screen_length, text_length)
    return math.max(1, math.floor((screen_length - text_length) / 2) + 1)
end

return {
    getCenterPos = getCenterPos,
}