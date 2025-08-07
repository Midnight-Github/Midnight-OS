local bext = require("os/lib/basalt/bext")
local api = require("os/lib/api")
local eui = require("os/lib/ext/ui")
local etable = require("os/lib/ext/table")
local config = require("os/config")
local metrics = require("os/lib/metrics")

local function infoApp(parent, appdata_path, callback)
    -- Config
    local data_info = {
        game_day = {heading = "Day", squeeze_ratio = 3, status_option_text = "day"},
        game_date = {heading = "Date", squeeze_ratio  = 2, status_option_text = "date"},
        game_season = {heading = "Season", squeeze_ratio  = 2, status_option_text = "season"},
        game_time = {heading = "Time", squeeze_ratio = 3, status_option_text = "time"},
        game_day_or_night = {heading = "D/N", squeeze_ratio = 3, status_option_text = "d/n"},
        irl_day = {heading = "Day", squeeze_ratio = 3, status_option_text = "irl-day"},
        irl_time = {heading = "Time", squeeze_ratio = 3, status_option_text = "irl-time"},
        irl_date = {heading = "Date", squeeze_ratio = 3, status_option_text = "irl-date"},
        coords = {heading = "Coords", squeeze_ratio = 3, status_option_text = "coords"},
        player_speed = {heading = "Speed", squeeze_ratio  = 2, status_option_text = "speed"},
        player_direction = {heading = "Dir", squeeze_ratio  = 2, status_option_text = "direction"},
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
    local function getAlignmentPos(total_width, text_width, side, squeeze_ratio) -- default side: mid
        if side == nil then side = "mid" end
        if side == "mid" or side == "middle" then squeeze_ratio = 1 end

        local section_width = math.floor(total_width/squeeze_ratio)
        if side == "left" then
            return eui.getCenterPos(section_width, text_width)

        elseif side == "mid" or side == "middle" then
            return eui.getCenterPos(total_width, text_width)

        elseif side == "right" then
            local section_start = total_width - section_width + 1
            return section_start + eui.getCenterPos(section_width, text_width)

        else
            error("Invalid alignment side: " .. tostring(side))
        end
    end

    local function addOptions(drop_down, list)
        for _, item in ipairs(list) do
            if item ~= "" then
                drop_down:addItem({text = data_info[item].status_option_text, args = {data_key = item}})
            end
        end
    end

    local function addTitleBar(master, y, title)
        master:addLabel()
            :setPosition(eui.getCenterPos(master:getWidth(), #title), y)
            :setText(title)
            :setBackground(colors.black)
            :setForeground(colors.white)
    end

    local function addHeadingBar(master, x, y, left_heading, mid_heading, right_heading, left_squeeze_ratio, right_squeeze_ratio)
        local heading_frame = master:addFrame()
            :setPosition(x, y)
            :setSize(master:getWidth(), 1)
            :setBackground(colors.black)

        local left_label = heading_frame:addLabel()
            :setPosition(getAlignmentPos(master:getWidth(), #left_heading, "left", left_squeeze_ratio), 1)
            :setText(left_heading)
            :setForeground(colors.lightGray)
            :setSize(#left_heading, 1)

        local mid_label = heading_frame:addLabel()
            :setPosition(getAlignmentPos(master:getWidth(), #mid_heading), 1)
            :setText(mid_heading)
            :setForeground(colors.lightGray)
            :setSize(#mid_heading, 1)

        local right_label = heading_frame:addLabel()
            :setPosition(getAlignmentPos(master:getWidth(), #right_heading, "right", right_squeeze_ratio), 1)
            :setText(right_heading)
            :setForeground(colors.lightGray)
            :setSize(#right_heading, 1)
    end

    local function addDataBar(master, x, y, left_key, mid_key, right_key)
        local data_frame = master:addFrame()
            :setPosition(x, y)
            :setSize(master:getWidth(), 1)
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

    local function addOptionBar(master, x, y)
        local data_frame = master:addFrame()
            :setPosition(x, y)
            :setSize(master:getWidth(), 6)
            :setBackground(colors.black)

        local data_keys = etable.getKeys(data_info)

        local section_width = math.floor(master:getWidth() / 3)
        local left_option = data_frame:addDropdown()
            :setPosition(1, 1)
            :setBackground(colors.gray)
            :setForeground(colors.white)
            :setSize(section_width - 1, 1)
            :addItem({text = "None", args = {data_key = nil}})
        addOptions(left_option, data_keys)
        left_option:selectItem(etable.indexOf(data_keys, config.status_bar_info.left))
        left_option:onSelect(function(self, event, item)
            config.status_bar_info.left = item.args.data_key
            api.updateConfig(config)
        end)

        local mid_option = data_frame:addDropdown()
            :setPosition(eui.getCenterPos(master:getWidth(), section_width - 1), 1)
            :setBackground(colors.gray)
            :setForeground(colors.white)
            :setSize(section_width - 1, 1)
            :addItem({text = "None", args = {data_key = nil}})
        addOptions(mid_option, data_keys)
        mid_option:selectItem(etable.indexOf(data_keys, config.status_bar_info.mid))
        mid_option:onSelect(function(self, event, item)
            config.status_bar_info.mid = item.args.data_key
            api.updateConfig(config)
        end)

        local right_option = data_frame:addDropdown()
            :setPosition(master:getWidth() - (section_width - 1) + 1, 1)
            :setBackground(colors.gray)
            :setForeground(colors.white)
            :setSize(section_width - 1, 1)
            :addItem({text = "None", args = {data_key = nil}})
        addOptions(right_option, data_keys)
        right_option:selectItem(etable.indexOf(data_keys, config.status_bar_info.right))
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
                local squeeze_ratio = val.squeeze_ratio
                local new_data = ""

                if key == "coords" then
                    local x = api.getDynamicData("x_coord")
                    local y = api.getDynamicData("y_coord")
                    local z = api.getDynamicData("z_coord")
                    new_data = metrics.formatCoords(x, y, z) or "-"
                else
                    new_data = api.getDynamicData(key) or "-"
                    new_data = tostring(new_data)
                end

                if #new_data ~= #old_data then
                    if etable.contains(left_data_key, key) then -- left section
                        data_label[key]:setPosition(getAlignmentPos(frame_width, #new_data, "left", squeeze_ratio), 1)

                    elseif etable.contains(mid_data_key, key) then -- mid section
                        data_label[key]:setPosition(getAlignmentPos(frame_width, #new_data), 1)

                    elseif etable.contains(right_data_key, key) then -- right section
                        data_label[key]:setPosition(getAlignmentPos(frame_width, #new_data, "right", squeeze_ratio), 1)
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
        :setPosition(2, 2)
        :setSize(parent:getWidth() - 2, parent:getHeight() - 2)
        :setBackground(colors.black)
    bext.addVarticalScrolling(main_frame)

    local zipped = etable.zip(section_title, left_data_key, mid_data_key, right_data_key)
    local y = 1
    for i = 1, #zipped do
        local title, left_key, mid_key, right_key = table.unpack(zipped[i])

        if title ~= "" then
            addTitleBar(main_frame, y, title)
            y = y + 2
        end

        local data_frame = main_frame:addFrame()
            :setPosition(1, y)
            :setSize(main_frame:getWidth(), 3)
            :setBackground(colors.black)

        local left_heading = data_info[left_key].heading
        local left_squeeze_ratio = data_info[left_key].squeeze_ratio
        local mid_heading = data_info[mid_key].heading
        local right_heading = data_info[right_key].heading
        local right_squeeze_ratio = data_info[right_key].squeeze_ratio
        addHeadingBar(data_frame, 1, 1, left_heading, mid_heading, right_heading, left_squeeze_ratio, right_squeeze_ratio)
        addDataBar(data_frame, 1, 3, left_key, mid_key, right_key)
        y = y + 4
    end

    addTitleBar(main_frame, y + 1, "- Status Display -")
    addHeadingBar(main_frame, 1, y + 3, "Left", "Mid", "Right", 3, 3)
    addOptionBar(main_frame, 1, y + 5)

    app.update = updateData
    app.onBack = callback.hide_app

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
    display_text = "Info",
    icon = drawIcon,
    app = infoApp
}