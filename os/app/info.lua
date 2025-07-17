local bext = require("os/lib/basalt/bext")
local api = require("os/lib/api")
local ext = require("os/lib/ext")
local config = require("os/config")


local function infoApp(parent)
    -- Config
    local data_info = {
        game_day = {heading = "Day", squeeze_ratio = 3, status_option_text = "day"},
        game_date = {heading = "Date", squeeze_ratio  = 2.3, status_option_text = "date"},
        game_season = {heading = "Season", squeeze_ratio  = 2.3, status_option_text = "season"},
        game_time = {heading = "Time", squeeze_ratio = 3, status_option_text = "time"},
        game_day_or_night = {heading = "D/N", squeeze_ratio = 3, status_option_text = "d/n"},
        irl_day = {heading = "Day", squeeze_ratio = 3, status_option_text = "irl-day"},
        irl_time = {heading = "Time", squeeze_ratio = 3, status_option_text = "irl-time"},
        irl_date = {heading = "Date", squeeze_ratio = 3, status_option_text = "irl-date"},
        coords = {heading = "Coords", squeeze_ratio = 3, status_option_text = "coords"},
        player_speed = {heading = "Speed", squeeze_ratio  = 2.3, status_option_text = "speed"},
        player_direction = {heading = "Dir", squeeze_ratio  = 2.3, status_option_text = "direction"},
        [""] = {heading = "", squeeze_ratio = 3, status_option_text = ""},
    }

    -- all tables below must have same number of values
    local section_title = {"- Compass -", "- GPS -", "- Game -", "", "- IRL -"}

    local left_data_key = {"player_speed", "", "game_day", "game_date", "irl_date"}
    local mid_data_key = {"", "coords", "game_time", "", "irl_time"}
    local right_data_key = {"player_direction", "", "game_day_or_night", "game_season", "irl_day"}

    -- Variables
    local app = {}
    local data_label = {}

    -- Functions
    local function get()

    end

    local function addOptions(drop_down, list)
        for _, item in ipairs(list) do
            if item ~= "" then
                drop_down:addItem({text = data_info[item].status_option_text, args = {data_key = item}})
            end
        end
    end

    local function addTitleBar(parent, y, width, title)
        parent:addLabel()
            :setPosition(ext.getCenterPos(width, #title), y)
            :setText(title)
            :setBackground(colors.black)
            :setForeground(colors.white)
    end

    local function addHeadingBar(parent, x, y, width, left_heading, mid_heading, right_heading, left_squeeze_ratio, right_squeeze_ratio)
        local heading_frame = parent:addFrame()
            :setPosition(x, y)
            :setSize(width, 1)
            :setBackground(colors.black)

        local left_label = heading_frame:addLabel()
            :setPosition(ext.getCenterPos(width/left_squeeze_ratio, #left_heading), 1)
            :setText(left_heading)
            :setForeground(colors.lightGray)
            :setSize(#left_heading, 1)

        local mid_label = heading_frame:addLabel()
            :setPosition(ext.getCenterPos(width, #mid_heading), 1)
            :setText(mid_heading)
            :setForeground(colors.lightGray)
            :setSize(#mid_heading, 1)

        local right_label = heading_frame:addLabel()
            :setPosition(width - ext.getCenterPos(width/right_squeeze_ratio, #right_heading) - #right_heading + 2, 1)
            :setText(right_heading)
            :setForeground(colors.lightGray)
            :setSize(#right_heading, 1)
    end

    local function addDataBar(parent, x, y, width, left_key, mid_key, right_key)
        local data_frame = parent:addFrame()
            :setPosition(1, 3)
            :setSize(width, 1)
            :setBackground(colors.gray)

        data_label[left_key] = data_frame:addLabel()
            :setText("")
            :setForeground(colors.white)

        data_label[mid_key] = data_frame:addLabel()
            :setText("")
            :setForeground(colors.white)

        data_label[right_key] = data_frame:addLabel()
            :setText("")
            :setForeground(colors.white)
    end

    local function addOptionBar(parent, x, y, width)
        local data_frame = parent:addFrame()
            :setPosition(x, y)
            :setSize(width, 6)
            :setBackground(colors.black)

        local data_keys = ext.getKeys(data_info)

        local left_option = data_frame:addDropdown()
            :setPosition(ext.getCenterPos(width/3, width/3), 1)
            :setBackground(colors.gray)
            :setForeground(colors.white)
            :setSize(width/3 - 1, 1)
            :addItem({text = "None", args = {data_key = ""}})
            
        addOptions(left_option, data_keys)
        left_option:selectItem(ext.indexOf(data_keys, config.status_bar_info.left))

        left_option:onSelect(function(self, event, item)
            config.status_bar_info.left = item.args.data_key
            api.updateConfig(config)
        end)

        local mid_option = data_frame:addDropdown()
            :setPosition(ext.getCenterPos(width, width/3), 1)
            :setBackground(colors.gray)
            :setForeground(colors.white)
            :setSize(width/3 - 1, 1)
            :addItem({text = "None", args = {data_key = ""}})
            
        addOptions(mid_option, data_keys)
        mid_option:selectItem(ext.indexOf(data_keys, config.status_bar_info.mid))

        mid_option:onSelect(function(self, event, item)
            config.status_bar_info.mid = item.args.data_key
            api.updateConfig(config)
        end)

        local right_option = data_frame:addDropdown()
            :setPosition(width - ext.getCenterPos(width/3, width/3) - width/3 + 2, 1)
            :setBackground(colors.gray)
            :setForeground(colors.white)
            :setSize(width/3 - 1, 1)
            :addItem({text = "None", args = {data_key = ""}})
            
        addOptions(right_option, data_keys)
        right_option:selectItem(ext.indexOf(data_keys, config.status_bar_info.right))

        right_option:onSelect(function(self, event, item)
            config.status_bar_info.right = item.args.data_key
            api.updateConfig(config)
        end)
    end

    local function updateData()
        local frame_width = parent:getWidth() - 2
        for key, val in pairs(data_info) do
            if key ~= "" then
                local old_data = data_label[key]:getText()
                local new_data = api.getDynamicData(key)
                local squeeze_ratio = val.squeeze_ratio

                if #new_data ~= #old_data then
                    if ext.contains(left_data_key, key) then
                        data_label[key]:setPosition(ext.getCenterPos(frame_width/squeeze_ratio, #new_data), 1)
                    elseif ext.contains(mid_data_key, key) then
                        data_label[key]:setPosition(ext.getCenterPos(frame_width, #new_data), 1)
                    elseif ext.contains(right_data_key, key) then
                        data_label[key]:setPosition(frame_width - ext.getCenterPos(frame_width/squeeze_ratio, #new_data) - #new_data + 2, 1)
                    end
                    data_label[key]:setText(new_data)
                elseif new_data ~= old_data then
                    data_label[key]:setText(new_data)
                end
            end
        end
    end

    -- Main
    local main_frame = parent:addFrame()
        :setPosition(1, 2)
        :setSize(parent:getWidth(), parent:getHeight() - 2)
        :setBackground(colors.black)
    bext.addVarticalScrolling(main_frame)

    local width = main_frame:getWidth() - 2
    width = 24
    local zipped = ext.zip(section_title, left_data_key, mid_data_key, right_data_key)
    local y = 1
    for i = 1, #zipped do
        local title, left_key, mid_key, right_key = table.unpack(zipped[i])

        if title ~= "" then
            addTitleBar(main_frame, y, width, title)
            y = y + 2
        end

        local data_frame = main_frame:addFrame()
            :setPosition(2, y)
            :setSize(width, 3)
            :setBackground(colors.black)

        local left_heading = data_info[left_key].heading
        local left_squeeze_ratio = data_info[left_key].squeeze_ratio
        local mid_heading = data_info[mid_key].heading
        local right_heading = data_info[right_key].heading
        local right_squeeze_ratio = data_info[right_key].squeeze_ratio
        addHeadingBar(data_frame, 1, 1, width, left_heading, mid_heading, right_heading, left_squeeze_ratio, right_squeeze_ratio)
        addDataBar(data_frame, 1, 3, width, left_key, mid_key, right_key)
        y = y + 4
    end
    addTitleBar(main_frame, y + 1, width, "- Status Display -")
    addHeadingBar(main_frame, 2, y + 3, width, "Left", "Mid", "Right", 3, 3)
    addOptionBar(main_frame, 2, y + 5, width)

    app.update = updateData

    return app
end

local function drawIcon(canvas)
    canvas:rect(1, 1, 5, 3, "", colors.black, colors.blue)
    canvas:text(1, 1, " ", colors.black, colors.white)
    canvas:text(5, 1, " ", colors.black, colors.lightBlue)
    canvas:text(5, 3, " ", colors.black, colors.lime)
    canvas:line(2, 1, 1, 2, "", colors.black, colors.white)
    canvas:line(5, 2, 4, 3, "", colors.black, colors.green)
    canvas:line(3, 3, 3, 3, "", colors.black, colors.green)
end

return {
    name = "info",
    display_text = "Info",
    icon = drawIcon,
    app = infoApp
}