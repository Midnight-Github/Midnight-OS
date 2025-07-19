local ext = require("os/lib/ext")
local api = require("os/lib/api")
local bext = require("os/lib/basalt/bext")
local config = require("os/config")
local const = require("os/const")

local function chatApp(parent, appdata_path, callback)
    -- Variables
    local app = {}
    local chat_textfield, input_box
    local users_config
    local global_dir_path = appdata_path.."/message/global"
    local direct_dir_path = appdata_path.."/message/direct"
    local users_path = appdata_path.."/users.lua"
    local current_group = "global" -- global, direct-<user_id>, group-<group_id>
    local computer_id = os.getComputerID()
    local CHAT_TEXT_PREFIX = ": "

    -- Functions
    local function scrollChatboxToBottom()
        local lines = chat_textfield:getText()
        local height = chat_textfield:getHeight()
        local offset = math.max(0, #ext.split(lines, '\n') - height + 2)
        chat_textfield:setScrollY(offset)
    end

    local function saveUserMap(data)
        ext.withSafeFile(users_path, "w", function(file)
            file.write("return "..textutils.serialize(data))
        end)
    end

    local function shrinkChatData(dir_path)
        local active_file_path = dir_path.."/active.txt"
        if fs.exists(active_file_path) and fs.getSize(active_file_path) > config.settings.max_msg_archive_file_size then
            ext.archiveFile(active_file_path, dir_path.."/archive.txt", api.getIRLLocalTimestamp())
        end
        ext.truncateArchiveDir(global_dir_path, config.settings.max_msg_archive_files)
    end

    local function setup()
        if not fs.exists(global_dir_path) then
            fs.makeDir(global_dir_path)
        end
        shrinkChatData(global_dir_path)

        if not fs.exists(direct_dir_path) then
            fs.makeDir(direct_dir_path)
        end
        for _, id in ipairs(fs.list(direct_dir_path)) do
            shrinkChatData(direct_dir_path.."/"..id)
        end

        if not fs.exists(users_path) then
            ext.withSafeFile(users_path, "w", function(file)
                file.write("return "..textutils.serialize({usermap = {}}))
            end)
        end
        users_config = dofile(users_path)
    end

    local function appendMsgToChatbox(msg, prefix)
        prefix = prefix or ""
        local text = chat_textfield:getText()

        local new_text = ""
        for _, line in ipairs(ext.wordWrap(msg, chat_textfield:getWidth() - #prefix)) do
            new_text = new_text .. prefix .. line .. "\n"
        end
        chat_textfield:setText(text..new_text)
    end

    local function appendGlobalFormattedMsgToChatbox(timestamp, sender_id, display_name, msg)
        local time = os.date("!%H:%M", timestamp)
        local date = os.date("!%d.%m.%y", timestamp)
        appendMsgToChatbox("["..time.." | "..date.."]")
        appendMsgToChatbox(display_name.."("..sender_id..")")
        appendMsgToChatbox(msg, CHAT_TEXT_PREFIX)
        appendMsgToChatbox("\n")
    end

    local function appendDirectFormattedMsgToChatbox(timestamp, display_name, msg)
        local time = os.date("!%H:%M", timestamp)
        local date = os.date("!%d.%m.%y", timestamp)
        appendMsgToChatbox("["..time.." | "..date.."]")
        appendMsgToChatbox(display_name)
        appendMsgToChatbox(msg, CHAT_TEXT_PREFIX)
        appendMsgToChatbox("\n")
    end

    local function update()
        chat_textfield:setFocused(false)
    end

    local function appendMsgToFile(data, timestamp, dir_path)
        local active_file_path = dir_path.."/active.txt"

        local mode
        if fs.exists(active_file_path) then mode = "a"
        else mode = "w"
        end

        ext.withSafeFile(active_file_path, mode, function(file)
            file.writeLine(data)
        end)

        shrinkChatData(dir_path)
    end

    local function onTraffic(sender_id, data, timestamp)
        local group, display_name, msg = data:match("([^|]*)|([^|]*)|(.*)")
        if not group or not display_name or not msg then return end

        if group == "global" then
            if current_group == "global" then
                appendGlobalFormattedMsgToChatbox(timestamp, sender_id, display_name, msg)
            end
            appendMsgToFile(sender_id.."|"..timestamp.."|"..msg, timestamp, global_dir_path)
        elseif group == "direct" then
            if current_group == "direct-"..sender_id then
                appendDirectFormattedMsgToChatbox(timestamp, display_name, msg)
            end
            appendMsgToFile(timestamp.."|"..msg, timestamp, direct_dir_path.."/"..sender_id)
        else
            return
        end

        users_config.usermap[sender_id] = display_name
        saveUserMap(users_config)

        rednet.send(sender_id, "received", const.protocol)
        scrollChatboxToBottom()
        callback.notification(true)
    end

    local function sendMsg()
        local text = input_box:getText()
        if not text or #text == 0 then return end

        local timestamp = api.getIRLLocalTimestamp()
        local data = current_group:sub(1, #"direct").."|"..config.settings.display_name.."|"..text
        if current_group == "global" then
            rednet.broadcast(data, const.protocol)
            appendGlobalFormattedMsgToChatbox(timestamp, computer_id, "You", text)
            appendMsgToFile(computer_id.."|"..timestamp.."|"..text, timestamp, global_dir_path)

        elseif current_group:sub(1, #"direct") == "direct" then
            local id = current_group:sub(#"direct" + 2)
            rednet.send(id, data, const.protocol)
            if rednet.receive(2, const.protocol) ~= "received" then return end -- handle failure
            appendDirectFormattedMsgToChatbox(timestamp, "You", text)
            appendMsgToFile(timestamp.."|"..text, timestamp, direct_dir_path.."/"..id)
        
        elseif current_group:sub(1, #"group") == "group" then -- group chat
            -- todo
        end
        scrollChatboxToBottom()
        input_box:setText("")
        input_box:setCursorPos(1)
    end

    -- Main
    setup()

    local main_frame = parent:addFrame()
        :setPosition(2, 2)
        :setSize(parent:getWidth() - 2, parent:getHeight() - 2)
        :setBackground(colors.black)

    local title_frame = main_frame:addFrame()
        :setPosition(4, 1)
        :setSize(main_frame:getWidth() - 3, 1)
        :setBackground(colors.gray)

    local chat_select_button = main_frame:addButton()
        :setText("...")
        :setPosition(1, 1)
        :setSize(3, 1)
        :setBackground("{self.clicked and colors.lightGray or colors.blue}")

    local title_label = title_frame:addLabel()
        :setPosition(ext.getCenterPos(title_frame:getWidth(), #"Global") - chat_select_button:getWidth() + 1, 1)
        :setText(current_group:sub(1, 1):upper() .. current_group:sub(2))
        :setForeground(colors.white)

    local chat_frame = main_frame:addFrame()
        :setPosition(1, 3)
        :setSize(main_frame:getWidth(), main_frame:getHeight() - 4)
        :setBackground(colors.gray)
        :setForeground(colors.white)

    chat_textfield = chat_frame:addTextBox()
        :setPosition(1, 1)
        :setSize(chat_frame:getWidth(), chat_frame:getHeight() + 3)
        :setBackground(colors.gray)
        :setForeground(colors.lightGray)
        :setEditable(false)
        :addSyntaxPattern(".*%(%d+%)", colors.lime) -- other user
        :addSyntaxPattern(".*%("..computer_id.."%)", colors.cyan) -- you
        :addSyntaxPattern("^"..CHAT_TEXT_PREFIX..".*", colors.white) -- user msg

    local input_frame = main_frame:addFrame()
        :setPosition(1, main_frame:getHeight())
        :setSize(main_frame:getWidth() - 3, 1)
        :setBackground(colors.gray)

    input_box = input_frame:addInput()
        :setPosition(1, 1)
        :setSize(input_frame:getWidth(), 1)
        :setBackground(colors.gray)
        :setFocusedBackground(colors.gray)
        :setForeground(colors.white)
        :setPlaceholder("Type here...")
        :setPlaceholderColor(colors.lightGray)
        :onKey(function(self, key)
            if key == keys.enter then sendMsg() end
        end)

    local send_button = main_frame:addButton()
        :setText(">")
        :setPosition(main_frame:getWidth() - 2, main_frame:getHeight())
        :setSize(3, 1)
        :setBackground("{self.clicked and colors.lightGray or colors.green}")
        :setForeground(colors.white)
        :onClickUp(function(self) sendMsg() end)

    -- local autoscroll_button = main_frame:addButton()
    --     :setText("!")
    --     :setPosition()

    ext.withSafeFile(global_dir_path.."/active.txt", "r", function(file)
        if not file then return end

        local contents = file.readAll()
        for line in contents:gmatch("([^\n]+)") do
            local sender_id, timestamp, msg = line:match("([^|]*)|([^|]*)|(.*)")
            sender_id = tonumber(sender_id)
            timestamp = tonumber(timestamp)
            local display_name = users_config.usermap[sender_id]
            if sender_id == computer_id then
                display_name = "You"
            end
            appendGlobalFormattedMsgToChatbox(timestamp, sender_id, display_name, msg)
        end
    end)
    scrollChatboxToBottom()

    app.update = update
    app.onTraffic = onTraffic
    app.onBack = callback.hide_app
    return app
end

local function drawIcon(canvas)
    canvas:rect(1, 2, 5, 3, " ", colors.black, colors.white)
    canvas:text(3, 3, "ooo", colors.black, colors.white)
end

return {
    display_text = "Chat",
    icon = drawIcon,
    app = chatApp
}