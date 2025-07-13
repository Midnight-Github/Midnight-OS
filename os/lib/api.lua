-- import
local ext = require("os/lib/ext")
local config = require("os/config")

local dynamic_data = {
    game_day = "-",
    game_date = "-",
    game_season = "-",
    game_time = "-",
    game_day_or_night = "-",
    irl_day = "-",
    irl_time = "-",
    irl_date = "-",
    coords = "-",
    player_speed = "-",
    player_direction = "-",
}

local function getDynamicData(key)
    return dynamic_data[key]
end

local function setDynamicData(key, value)
    dynamic_data[key] = value
end

-- config
local function updateConfig(config)
    ext.withSafeFile("os/config.lua", "w", function(file)
        file.write("return " .. textutils.serialize(config))
    end)
end

-- utils
local function getIRLLocalTimestamp()
    return os.epoch("utc")/1000 + config.settings.hours_off_set_from_utc * 3600
end

return {
    getDynamicData = getDynamicData,
    setDynamicData = setDynamicData,
    updateConfig = updateConfig,
    getIRLLocalTimestamp = getIRLLocalTimestamp,
}