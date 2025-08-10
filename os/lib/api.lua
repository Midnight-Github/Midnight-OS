-- import
local eio = require("os/lib/ext/io")
local config = require("os/config")

local dynamic_data = {
    game_day = nil,
    game_date = nil,
    game_season = nil,
    game_time = nil,
    game_day_or_night = nil,
    irl_day = nil,
    irl_time = nil,
    irl_date = nil,
    x_coord = nil,
    y_coord = nil,
    z_coord = nil,
    player_speed = nil,
    player_direction = nil,
}

local function getDynamicData(key)
    return dynamic_data[key]
end

local function setDynamicData(key, value)
    dynamic_data[key] = value
end

-- config
local function updateConfig(config_data)
    eio.withSafeFile("os/config.lua", "w", function(file)
        file.write("return " .. textutils.serialize(config_data))
    end)
end

-- utils
local function getIRLLocalTimestamp()
---@diagnostic disable-next-line: undefined-field
    return os.epoch("utc")/1000 + config.settings.hours_off_set_from_utc * 3600
end

return {
    getDynamicData = getDynamicData,
    setDynamicData = setDynamicData,
    updateConfig = updateConfig,
    getIRLLocalTimestamp = getIRLLocalTimestamp,
}