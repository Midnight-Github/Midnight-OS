local ext = require("os/lib/ext")
local config = require("os/app/calculator/config")

local function calculatorApp(parent, appdata_path, callback)
    -- Variables
    local app = {}
    local input_label, input_wrap_label, result_label
    local button_preset_frames = {}
    local selected_preset = 1

    -- Config extraction
    local button_display_text_presets, button_color, button_click_color, button_font_color
    if pocket then
        button_display_text_presets = config.pocket.button_presets
        button_color = config.pocket.button_color
        button_click_color = config.pocket.button_click_color
        button_font_color = config.pocket.button_font_color
    else
        button_display_text_presets = config.desktop.button_presets
        button_color = config.desktop.button_color
        button_click_color = config.desktop.button_click_color
        button_font_color = config.desktop.button_font_color
    end

    local safe_env = config.common.eval_logic

    local button_display_logic = { -- default logic
        ce  = function(input, result) return "", "" end,
        c   = function(input, result) return result, "" end,
        ["="] = function(input, result)
            local evalResult = ext.eval(input, safe_env)
            if evalResult == nil then
                return input, "Err"
            else
                return input, tostring(evalResult)
            end
        end,
        ["#"] = function(input, result)
            button_preset_frames[selected_preset]:setVisible(false)
            selected_preset = selected_preset + 1
            if selected_preset > #button_display_text_presets then
                selected_preset = 1
            end
            button_preset_frames[selected_preset]:setVisible(true)

            return input, result
        end
    }
    for i=0,9 do
        button_display_logic[tostring(i)] = function(input, result) return input..tostring(i), result end
    end
    ext.extend(button_display_logic, config.common.button_display_logic) -- adding/overriding logic from config

    -- Function
    local function updateInput(input)
        local max_input_len = parent:getWidth()
        if #input > max_input_len then
            input_label:setText(input:sub(1, max_input_len))
            input_wrap_label:setText(input:sub(max_input_len + 1))
        else
            input_label:setText(input)
        end
    end

    local function updateDisplay(input, result)
        input_label:setText("")
        input_wrap_label:setText("")
        result_label:setText("")

        updateInput(input)
        result_label:setText(result)
    end

    -- Main
    local main_frame = parent:addFrame()
        :setPosition(1, 2)
        :setSize(parent:getWidth(), parent:getHeight() - 2)
        :setBackground(colors.black)

    input_label = main_frame:addLabel()
        :setText("")
        :setPosition(1, 1)
        :setSize(main_frame:getWidth(), 1)
        :setForeground(colors.lightGray)

    input_wrap_label = main_frame:addLabel()
        :setText("")
        :setPosition(1, 2)
        :setSize(main_frame:getWidth(), 1)
        :setForeground(colors.lightGray)

    result_label = main_frame:addLabel()
        :setText("")
        :setPosition(1, 4)
        :setSize(main_frame:getWidth(), 1)
        :setForeground(colors.white)

    local button_frame_width = #button_display_text_presets[1][1]*4 - 1
    local button_frame_height = #button_display_text_presets[1]*2 - 1
    local button_frame = main_frame:addFrame()
        :setPosition(ext.getCenterPos(main_frame:getWidth(), button_frame_width), main_frame:getHeight() - button_frame_height + 1)
        :setSize(button_frame_width, button_frame_height)
        :setBackground(colors.black)

    for i, preset in ipairs(button_display_text_presets) do
        button_preset_frames[i] = button_frame:addFrame()
            :setPosition(1, 1)
            :setSize(button_frame:getWidth(), button_frame:getHeight())
            :setBackground(colors.black)
            :setVisible(false)

        for row, rowButtons in ipairs(preset) do
            for col, display_text in ipairs(rowButtons) do
                button_preset_frames[i]:addButton()
                    :setSize(3, 1)
                    :setPosition(1 + (col-1)*4, 1 + (row-1)*2)
                    :setText(display_text)
                    :setBackground(button_color[row][col])
                    :setForeground(button_font_color[row][col])
                    :onClick(function(self)
                        self:setBackground(button_click_color[row][col])
                    end)
                    :onClickUp(function(self)
                        self:setBackground(button_color[row][col])
                        local input, result = button_display_logic[display_text](input_label:getText()..input_wrap_label:getText(), result_label:getText())
                        updateDisplay(input, result)
                    end)
            end
        end
    end
    button_preset_frames[selected_preset]:setVisible(true)

    app.onBack = callback.hide_app

    return app
end

local function drawIcon(canvas)
    canvas:line(2, 1, 4, 1, " ", colors.white, colors.lightGray)
    canvas:rect(2, 2, 3, 3, " ", colors.white, colors.gray)
    canvas:text(2, 2, "+-", colors.white, colors.gray)
    canvas:text(4, 3, " ", colors.white, colors.orange)
end

return {
    display_text = "Calculator",
    icon = drawIcon,
    app = calculatorApp,
}