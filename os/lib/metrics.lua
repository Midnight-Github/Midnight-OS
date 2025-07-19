-- Imports
local config = require("os/config")
local ext = require("os/lib/ext")

-- Varibales
local last_pos, last_time
local last_dir_pos
local month_names = {"Spring", "Summer", "Autumn", "Winter"}

-- Format time as HH:MM from hours (float)
local function formatTime(time_in_hours)
    local hour = math.floor(time_in_hours) % 24
    local minute = math.floor((time_in_hours - math.floor(time_in_hours)) * 60)
    return string.format("%02d:%02d", hour, minute)
end

-- Return "Day" or "Night" based on time (hours)
local function getDayOrNight(time_in_hours)
    return (time_in_hours >= config.settings.day_hour and time_in_hours < config.settings.night_hour) and "Day" or "Night"
end

-- Return custom calendar date string dd.mm.yy (fabric seasons mod)
local function getFabricSeasonsDate(day)
    local year = math.floor((day - 1) / 112) + 1
    local month = math.floor(((day - 1) % 112) / 28) + 1
    local day_in_month = ((day - 1) % 28) + 1
    return string.format("%02d.%02d.%02d", day_in_month, month, year)
end

-- Return season name based on day (fabric seasons mod)
local function getFabricSeasonsSeason(day)
    local month = math.floor(((day - 1) % 112) / 28) + 1
    return month_names[month]
end

-- Format coordinates
local function formatCoords(x, y, z)
    if not x or not y or not z then return nil end
    return string.format("%d %d %d", ext.round(x), ext.round(y), ext.round(z))
end

-- Calculate player speed in blocks/sec
local function getMovementSpeed(x, y, z)
    if not x or not y or not z then return nil end
---@diagnostic disable-next-line: undefined-field
    local now = os.epoch("utc") / 1000
    if not last_pos then
        last_pos = {x = x, y = y, z = z}
        last_time = now
        return nil
    end
    local dt = now - last_time
    if dt == 0 then return "0" end
    local dx, dy, dz = x - last_pos.x, y - last_pos.y, z - last_pos.z
    local dist = math.sqrt(dx*dx + dy*dy + dz*dz)
    last_pos = {x = x, y = y, z = z}
    last_time = now
    return ext.round(dist / dt, 0.01)
end

-- Calculate player facing direction (8 compass points)
local function getMovementDirection(x, z)
    if not x or not z then return nil end
    if not last_dir_pos then
        last_dir_pos = {x = x, z = z}
        return nil
    end
    local dx, dz = x - last_dir_pos.x, z - last_dir_pos.z
    last_dir_pos = {x = x, z = z}
    if dx == 0 and dz == 0 then return nil end
    ---@diagnostic disable-next-line: deprecated
    local angle = math.atan2(dz, dx) * (180 / math.pi)
    if angle < 0 then angle = angle + 360 end
    local directions = {"E", "SE", "S", "SW", "W", "NW", "N", "NE"}
    local idx = math.floor((angle + 22.5) / 45) % 8 + 1
    return directions[idx]
end

-- Module exports
return {
    formatTime = formatTime,
    getDayOrNight = getDayOrNight,
    getGameDate = getFabricSeasonsDate,
    getGameSeason = getFabricSeasonsSeason,
    formatCoords = formatCoords,
    getMovementSpeed = getMovementSpeed,
    getMovementDirection = getMovementDirection,
}