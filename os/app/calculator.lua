local ext = require("os/lib/ext")

local function calculatorApp(parent)
    -- Variables
    local app = {}
    local input_label, input_wrap_label, result_label
    local button_preset_frames = {}

    -- Config
    local safe_env = {
        abs = math.abs, fractional = ext.fractionalPart, factorial = ext.factorial, log = math.log,
        round = ext.round, ceil = math.ceil, floor = math.floor,
        pi = math.pi, e = math.exp(1),
        rad = math.rad, deg = math.deg,
        sin = math.sin, csc = ext.cosec, cos = math.cos, sec = ext.sec, tan = math.tan, cot = ext.cot,
        asin = math.asin, acos = math.acos, atan = math.atan, asec = ext.asec, acot = ext.acot, acosec = ext.acosec,
        sinh = ext.sinh, cosh = ext.cosh, tanh = ext.tanh, sech = ext.sech, coth = ext.coth, cosech = ext.cosech
    }

    local button_display_text_presets = {
        {
            {"abs", "fra", "fac", "log", "ce", "c", "<"},
            {"rnd", "cel", "flr", "pi",  "e",  "(", ")"},
            {"rad", "deg", "7",   "8",   "9",  "+", "-"},
            {"sin", "csc", "4",   "5",   "6",  "*", "/"},
            {"cos", "sec", "1",   "2",   "3",  "^", "%"},
            {"tan", "cot", "#",   "0",   ".",  ",", "="},
        },
        {
            {"abs", "fra", "fac", "log", "ce", "c", "<"},
            {"rnd", "cel", "flr", "pi",  "e",  "(", ")"},
            {"rad", "deg", "7",   "8",   "9",  "+", "-"},
            {"asi", "acs", "4",   "5",   "6",  "*", "/"},
            {"aco", "ase", "1",   "2",   "3",  "^", "%"},
            {"ata", "act", "#",   "0",   ".",  ",", "="},
        },
        {
            {"abs", "fra", "fac", "log", "ce", "c", "<"},
            {"rnd", "cel", "flr", "pi",  "e",  "(", ")"},
            {"rad", "deg", "7",   "8",   "9",  "+", "-"},
            {"sih", "csh", "4",   "5",   "6",  "*", "/"},
            {"coh", "seh", "1",   "2",   "3",  "^", "%"},
            {"tah", "cth", "#",   "0",   ".",  ",", "="},
        }
    }
    local selected_preset = 1

    local button_logic = {
        abs = function(input, result) return "abs("..input..")", result end,
        fra = function(input, result) return "fractional("..input..")", result end,
        fac = function(input, result) return "factorial("..input..")", result end,
        log = function(input, result) return "log("..input..",", result end,
        ce  = function(input, result) return "", "" end,
        c   = function(input, result) return result, "" end,
        rnd = function(input, result) return "round("..input..")", result end,
        cel = function(input, result) return "ceil("..input..")", result end,
        flr = function(input, result) return "floor("..input..")", result end,
        pi  = function(input, result) return input.."pi", result end,
        e   = function(input, result) return input.."e", result end,
        rad = function(input, result) return "rad("..input..")", result end,
        deg = function(input, result) return "deg("..input..")", result end,
        sin = function(input, result) return "sin("..input..")", result end,
        csc = function(input, result) return "cosec("..input..")", result end,
        cos = function(input, result) return "cos("..input..")", result end,
        sec = function(input, result) return "sec("..input..")", result end,
        tan = function(input, result) return "tan("..input..")", result end,
        cot = function(input, result) return "cot("..input..")", result end,
        asi = function(input, result) return "asin("..input..")", result end,
        aco = function(input, result) return "acos("..input..")", result end,
        acs = function(input, result) return "acosec("..input..")", result end,
        ase = function(input, result) return "asec("..input..")", result end,
        ata = function(input, result) return "atan("..input..")", result end,
        act = function(input, result) return "acot("..input..")", result end,
        sih = function(input, result) return "sinh("..input..")", result end,
        csh = function(input, result) return "cosech("..input..")", result end,
        coh = function(input, result) return "cosh("..input..")", result end,
        seh = function(input, result) return "sech("..input..")", result end,
        tah = function(input, result) return "tanh("..input..")", result end,
        cth = function(input, result) return "coth("..input..")", result end,
        ["<"] = function(input, result) return input:sub(1, -2), result end,
        ["("] = function(input, result) return input.."(", result end,
        [")"] = function(input, result) return input..")", result end,
        ["+"] = function(input, result) return input.."+", result end,
        ["-"] = function(input, result) return input.."-", result end,
        ["*"] = function(input, result) return input.."*", result end,
        ["/"] = function(input, result) return input.."/", result end,
        ["^"] = function(input, result) return input.."^", result end,
        ["%"] = function(input, result) return input.."%", result end,
        ["."] = function(input, result) return input..".", result end,
        [","] = function(input, result) return input..",", result end,
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
        button_logic[tostring(i)] = function(input, result) return input..tostring(i), result end
    end

    local button_color = {
        {colors.green, colors.green, colors.green, colors.green, colors.red, colors.red, colors.red},
        {colors.green, colors.green, colors.green, colors.cyan, colors.cyan, colors.orange, colors.orange},
        {colors.green, colors.green, colors.gray, colors.gray, colors.gray, colors.orange, colors.orange},
        {colors.lime, colors.lime, colors.gray, colors.gray, colors.gray, colors.orange, colors.orange},
        {colors.lime, colors.lime, colors.gray, colors.gray, colors.gray, colors.orange, colors.orange},
        {colors.lime, colors.lime, colors.lightGray, colors.gray, colors.lightGray, colors.orange, colors.blue},
    }

    local button_click_color = {
        {colors.lightGray, colors.lightGray, colors.lightGray, colors.lightGray, colors.lightGray, colors.lightGray, colors.lightGray},
        {colors.lightGray, colors.lightGray, colors.lightGray, colors.lightGray, colors.lightGray, colors.lightGray, colors.lightGray},
        {colors.lightGray, colors.lightGray, colors.lightGray, colors.lightGray, colors.lightGray, colors.lightGray, colors.lightGray},
        {colors.lightGray, colors.lightGray, colors.lightGray, colors.lightGray, colors.lightGray, colors.lightGray, colors.lightGray},
        {colors.lightGray, colors.lightGray, colors.lightGray, colors.lightGray, colors.lightGray, colors.lightGray, colors.lightGray},
        {colors.lightGray, colors.lightGray, colors.lightGray, colors.lightGray, colors.lightGray, colors.lightGray, colors.lightGray},
    }

    local button_font_color = {
        {colors.black, colors.black, colors.black, colors.black, colors.white, colors.white, colors.white},
        {colors.black, colors.black, colors.black, colors.black, colors.black, colors.black, colors.black},
        {colors.black, colors.black, colors.white, colors.white, colors.white, colors.black, colors.black},
        {colors.black, colors.black, colors.white, colors.white, colors.white, colors.black, colors.black},
        {colors.black, colors.black, colors.white, colors.white, colors.white, colors.black, colors.black},
        {colors.black, colors.black, colors.black, colors.white, colors.black, colors.black, colors.white},
    }
    
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
                        local input, result = button_logic[display_text](input_label:getText()..input_wrap_label:getText(), result_label:getText())
                        updateDisplay(input, result)
                    end)
            end
        end
    end
    button_preset_frames[selected_preset]:setVisible(true)

    return app
end

local function drawIcon(canvas)
    canvas:line(2, 1, 4, 1, " ", colors.white, colors.lightGray)
    canvas:rect(2, 2, 3, 3, " ", colors.white, colors.gray)
    canvas:text(2, 2, "+-", colors.white, colors.gray)
    canvas:text(4, 3, " ", colors.white, colors.orange)
end

return {
    name = "calculator",
    display_text = "Calculator",
    icon = drawIcon,
    app = calculatorApp,
}