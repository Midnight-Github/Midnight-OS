-- Sends a redstone pulse on the specified side for the given delay (in seconds).
local function redstonePulse(side, delay)
    delay = delay or 0
    redstone.setOutput(side, true)
    sleep(delay)
    redstone.setOutput(side, false)
end

return {
    redstonePulse = redstonePulse,
}