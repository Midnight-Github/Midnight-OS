-- imports
local basalt = require("os/lib/basalt/main")
local bext = require("os/lib/basalt/bext")
local emath = require("os/lib/ext/math")
local etable = require("os/lib/ext/table")
local ebool = require("os/lib/ext/bool")
local eui = require("os/lib/ext/ui")
local eio = require("os/lib/ext/io")
local config = require("os/config")
local const = require("os/const")
local metrics = require("os/lib/metrics")
local api = require("os/lib/api")

-- variables
local main
local slide_frame
local app_list_frame, app_container_frame
local app_data = {}
local tray_bar, home_button, back_button, settings_button
local status_frame, status_right_label, status_mid_label, status_left_label
local current_app
local traffic_queue = {}

local appdata_path = "os/appdata"

local modem, modem_side
local speaker, speaker_side

-- functions
local function setup()
    eio.ensureDirExists(appdata_path)

    if config.settings.enable_gps_onstartup then
        config.settings.gps_enabled = true
        api.updateConfig(config)
    end
end

local function showApp(app_name)
    current_app = app_name
    app_data[app_name].frame:setVisible(true)
    slide_frame:animate()
        :move(-main:getWidth(), 2, 0.2)
        :start()
end

local function hideApp()
    slide_frame:animate()
        :move(1, 2, 0.2)
        :onComplete(function()
            if not current_app then return end
            app_data[current_app].frame:setVisible(false)
            current_app = nil
        end)
        :start()
end

local function getFormattedDynamicData(key)
    if not key then return "" end

    if key == "coords" then
        local x = api.getDynamicData("x_coord")
        local y = api.getDynamicData("y_coord")
        local z = api.getDynamicData("z_coord")
        return metrics.formatCoords(x, y, z) or "-"

    else
        return tostring(api.getDynamicData(key) or "-")
    end
end

local function updateStatusBar()
    local left_status_text = getFormattedDynamicData(config.status_bar_info.left) or ""
    local mid_status_text = getFormattedDynamicData(config.status_bar_info.mid) or ""
    local right_status_text = getFormattedDynamicData(config.status_bar_info.right) or ""

    if #left_status_text ~= #status_left_label:getText() then
        status_mid_label:setPosition(#left_status_text + 2, 1)
    end
    if #right_status_text ~= #status_right_label:getText() then
        status_right_label:setPosition(status_frame:getWidth() - #right_status_text + 1, 1)
    end
    if left_status_text ~= status_left_label:getText() then
        status_left_label:setText(left_status_text)
    end
    if mid_status_text ~= status_mid_label:getText() then
        status_mid_label:setText(mid_status_text)
    end
    if right_status_text ~= status_right_label:getText() then
        status_right_label:setText(right_status_text)
    end
end

local function updateDynamicData()
    if config.settings.gps_enabled then
        local x, y, z = gps.locate()
        if x and y and z then
            api.setDynamicData("x_coord", emath.round(x))
            api.setDynamicData("y_coord", emath.round(y))
            api.setDynamicData("z_coord", emath.round(z))
        else
            api.setDynamicData("x_coord", nil)
            api.setDynamicData("y_coord", nil)
            api.setDynamicData("z_coord", nil)

            config.settings.gps_enabled = false
            api.updateConfig(config)
        end

        api.setDynamicData("player_speed", metrics.getMovementSpeed(x, y, z))
        api.setDynamicData("player_direction", metrics.getMovementDirection(x, z))
    end

    ---@diagnostic disable-next-line: undefined-field
    local game_day = os.day()
    local game_hour = os.time()
    local irl_timestamp = math.floor(api.getIRLLocalTimestamp())
    local irl_day = os.date("!%a", irl_timestamp)
    local irl_date = os.date("!%d.%m.%y", irl_timestamp)
    local irl_time = os.date("!%H:%M", irl_timestamp)

    api.setDynamicData("game_day", tostring(game_day))
    api.setDynamicData("game_date", metrics.getGameDate(game_day))
    api.setDynamicData("game_season", metrics.getGameSeason(game_day))
    api.setDynamicData("game_time", metrics.formatTime(game_hour))
    api.setDynamicData("game_day_or_night", metrics.getDayOrNight(game_hour))

    api.setDynamicData("irl_day", irl_day)
    api.setDynamicData("irl_time", irl_time)
    api.setDynamicData("irl_date", irl_date)
end

local function update()
    updateDynamicData()
    updateStatusBar()
end

local function updateApp()
    if not current_app then return end
    if not app_data[current_app].frame.visible then return end
    if not app_data[current_app].update then return end
    app_data[current_app].update()
end

local function triggerAppFunction(app_name, func_name, ...)
    if app_name == "all" then
        for _, app in pairs(app_data) do
            if app[func_name] then
                app[func_name](...)
            end
        end
    else
        if app_data[app_name] and app_data[app_name][func_name] then
            app_data[app_name][func_name](...)
        end
    end
end

local function handleTraffic()
    local sender_id, data, protocol = rednet.receive(const.protocol)
    if not sender_id then return end

    triggerAppFunction("all", "onTraffic", sender_id, data, api.getIRLLocalTimestamp())
end

local function grabTraffic()
    while true do
        local sender_id, data, protocol = rednet.receive(const.protocol)
        if sender_id then
            table.insert(traffic_queue, {sender_id, data, api.getIRLLocalTimestamp()})
        end
    end
end

local function processTraffic()
    while true do
        if #traffic_queue > 0 then
            local msg = table.remove(traffic_queue, 1)
            triggerAppFunction("all", "onTraffic", table.unpack(msg))
        else
            sleep(0.2)
        end
    end
end

local function playNotificationSound()
    local volume = 50 -- get volume from config
    if speaker then
        speaker.playNote("bell", volume)
        return
    end

    local module_ids = config.settings.peripheral_module_ids
    if #module_ids > 0 then
        for _, module_id in ipairs(module_ids) do
            rednet.send(module_id, 'speaker|playNote|bell, '..tostring(volume), const.protocol)
        end
    end
end

-- use these 2 functions in settings interface (refresh_peripheral)
local function connectModem()
    modem = peripheral.find("modem")
    if not modem then return end
    modem_side = peripheral.getName(modem)
end

local function connectSpeaker()
    speaker = peripheral.find("speaker")
    if not speaker then return end
    speaker_side = peripheral.getName(speaker)
end

local function mainLoop()
    while true do
        update()
        updateApp()
        triggerAppFunction("all", "backgroundUpdate")
        sleep(config.settings.refresh_delay)
    end
end

-- main
setup()
connectModem()
connectSpeaker()

if modem then rednet.open(peripheral.getName(modem)) end

main = basalt.getMainFrame()
    :setBackground(colors.black)

status_frame = main:addFrame()
    :setPosition(1, 1)
    :setSize(main:getWidth(), 1)
    :setBackground(colors.gray)

status_left_label = status_frame:addLabel()
    :setText("")
    :setForeground(colors.white)

status_mid_label = status_frame:addLabel()
    :setText("")
    :setForeground(colors.white)

status_right_label = status_frame:addLabel()
    :setText("")
    :setForeground(colors.white)

slide_frame = main:addFrame()
    :setPosition(1, 2)
    :setSize(main:getWidth()*2 + 1, main:getHeight() - 2)
    :setBackground(colors.black)

app_list_frame = slide_frame:addFrame()
    :setPosition(1, 2)
    :setSize(main:getWidth(), slide_frame:getHeight() - 2)
    :setBackground(colors.black)
bext.addVarticalScrolling(app_list_frame)

app_container_frame = slide_frame:addFrame()
    :setPosition(main:getWidth() + 2, 1)
    :setSize(main:getWidth(), slide_frame:getHeight())
    :setBackground(colors.black)

-- app loader
local apps = {}
for _, app_dir_name in ipairs(fs.list("os/app")) do
    if etable.contains(config.app_display_order, app_dir_name) then
        local app = require("os/app/" .. app_dir_name .. "/main")
        apps[app_dir_name] = app
    end
end

for app_name, app in pairs(apps) do
    local is_valid_app = ebool.iany({
        type(app) == "table",
        app.display_text and type(app.display_text) == "string",
        app.icon and type(app.icon) == "function",
        app.app and type(app.app) == "function"
    })

    if not is_valid_app then -- invalid app
        goto skip_app_from_list
    end

    local frame = app_list_frame:addFrame()
        :setPosition(2, 1 + 4*(etable.indexOf(config.app_display_order, app_name) - 1))
        :setSize(app_list_frame:getWidth() - 2, 3)

    local icon_canvas_frame = frame:addFrame()
        :setPosition(1, 1)
        :setSize(6, 3)
        :setBackground(colors.black)

    local icon_canvas = icon_canvas_frame:getCanvas()
    app.icon(icon_canvas)

    local launch_button = frame:addButton()
        :setText(app.display_text)
        :setPosition(7, 1)
        :setSize(frame:getWidth() - 6, 3)
        :setForeground(colors.white)
        :setBackground("{self.clicked and colors.lightGray or colors.gray}")

    local app_interface_frame = app_container_frame:addFrame()
        :setPosition(1, 1)
        :setSize(app_container_frame:getWidth(), app_container_frame:getHeight())
        :setBackground(colors.black)
        :setVisible(false)

    local parent = app_interface_frame:addFrame()
        :setPosition(1, 1)
        :setSize(app_interface_frame:getWidth(), app_interface_frame:getHeight())
        :setBackground(colors.black)

    local notification_indicator_frame = frame:addFrame()
        :setPosition(frame:getWidth(), 1)
        :setSize(1, 1)
        :setBackground(colors.red)
        :setVisible(false)

    local callback = {
        notification = function(state)
            if state then
                notification_indicator_frame:setVisible(true)
                playNotificationSound()
            else
                notification_indicator_frame:setVisible(false)
            end
        end,

        hide_app = function()
            if not app_interface_frame.visible then return end
            hideApp()
        end
    }

    local app_package = app.app(
        parent,
        appdata_path.."/"..app_name,
        callback
    )

    app_data[app_name] = {
        launch_frame = frame,
        launch_button = launch_button,
        icon_canvas = icon_canvas,

        display_text = app.display_text,
        frame = app_interface_frame,

        update = app_package.update,
        backgroundUpdate = app_package.backgroundUpdate,

        onAppFocus = app_package.onAppFocus,
        onTraffic = app_package.onTraffic,
        onHome = app_package.onHome,
        onBack = app_package.onBack
    }

    launch_button:onClickUp(function()
        if app_package.onAppFocus then app_package.onAppFocus() end
        showApp(app_name)
    end)

    ::skip_app_from_list::
end

tray_bar = main:addFrame()
    :setPosition(1, main:getHeight())
    :setSize(main:getWidth(), 1)
    :setBackground(colors.gray)

back_button = tray_bar:addButton()
    :setText("<")
    :setSize(3, 1)
    :setPosition(eui.getCenterPos(tray_bar:getWidth()/3, 1), 1)
    :setBackground("{self.clicked and colors.lightGray or colors.red}")
    :setForeground(colors.white)
    :onClickUp(function()
        if not current_app then return end
        if not app_data[current_app].frame.visible then return end
        triggerAppFunction(current_app, "onBack")
    end)

home_button = tray_bar:addButton()
    :setText("[+]")
    :setSize(3, 1)
    :setPosition(eui.getCenterPos(tray_bar:getWidth(), 3), 1)
    :setBackground("{self.clicked and colors.lightGray or colors.gray}")
    :setForeground(colors.white)
    :onClickUp(function()
        if not current_app then return end
        if not app_data[current_app].frame.visible then return end
        triggerAppFunction(current_app, "onHome")
        hideApp()
    end)

settings_button = tray_bar:addButton()
    :setText("[*]")
    :setSize(3, 1)
    :setPosition(tray_bar:getWidth() - eui.getCenterPos(tray_bar:getWidth()/3, 3) - 2, 1)
    :setBackground("{self.clicked and colors.lightGray or colors.gray}")
    :setForeground(colors.white)

basalt.schedule(grabTraffic)
basalt.schedule(processTraffic)
basalt.schedule(mainLoop)

basalt.run()