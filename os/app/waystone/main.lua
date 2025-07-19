local ext = require("os/lib/ext")
local bext = require("os/lib/basalt/bext")
local api = require("os/lib/api")

local function waystoneApp(parent, appdata_path, callback)
    -- Variables
    local app = {}

    -- Functions
    local function addWaystone(name, x, y, z)

    end

    -- Main
    local main_frame = parent:addFrame()
        :setPosition(2, 2)
        :setSize(parent:getWidth() - 2, parent:getHeight() - 2)
        :setBackground(colors.black)

    local target_frame = main_frame:addFrame()
        :setPosition(1, 1)
        :setSize(main_frame:getWidth(), 2)

    local waystone_selection_frame = main_frame:addFrame()
        :setPosition(1, 4)
        :setSize(main_frame:getWidth(), main_frame:getHeight() - 5)
        :setBackground(colors.blue)
    bext.addHorizontalScrolling(waystone_selection_frame)

    local add_waystone_frame = main_frame:addFrame()
        :setPosition(1, main_frame:getHeight())
        :setSize(main_frame:getWidth(), 1)
        :setBackground(colors.black)

    local name_box_size = math.floor(add_waystone_frame:getWidth() * 2 / 5 - 3)
    local coord_box_size = math.min(math.floor((add_waystone_frame:getWidth() * 2 / 5) / 3), 7)
    local coord_input_indent = ext.repeatString(" ", ext.getCenterPos(coord_box_size, 1) - 1)

    local input_name = add_waystone_frame:addInput()
        :setPosition(1, 1)
        :setSize(name_box_size, 1)
        :setBackground(colors.gray)
        :setFocusedBackground(colors.gray)
        :setForeground(colors.white)
        :setPlaceholder(ext.repeatString(" ", ext.getCenterPos(name_box_size, 4) - 1).."Name")
        :setPlaceholderColor(colors.lightGray)

    local input_x = add_waystone_frame:addInput()
        :setPosition(name_box_size + 2, 1)
        :setSize(coord_box_size, 1)
        :setBackground(colors.gray)
        :setFocusedBackground(colors.gray)
        :setForeground(colors.white)
        :setPlaceholder(coord_input_indent.."x")
        :setPlaceholderColor(colors.lightGray)

    local input_y = add_waystone_frame:addInput()
        :setPosition(name_box_size + 1 + coord_box_size + 2, 1)
        :setSize(coord_box_size, 1)
        :setBackground(colors.gray)
        :setFocusedBackground(colors.gray)
        :setForeground(colors.white)
        :setPlaceholder(coord_input_indent.."y")
        :setPlaceholderColor(colors.lightGray)

    local input_z = add_waystone_frame:addInput()
        :setPosition(name_box_size + 1 + (coord_box_size + 1) * 2 + 1, 1)
        :setSize(coord_box_size, 1)
        :setBackground(colors.gray)
        :setFocusedBackground(colors.gray)
        :setForeground(colors.white)
        :setPlaceholder(coord_input_indent.."z")
        :setPlaceholderColor(colors.lightGray)

    local submit_button = add_waystone_frame:addButton()
        :setPosition(add_waystone_frame:getWidth(), 1)
        :setSize(1, 1)
        :setText("+")
        :setBackground("{self.clicked and colors.lightGray or colors.black}")
        :setForeground(colors.red)

    local input_current_coords_button = add_waystone_frame:addButton()
        :setPosition(add_waystone_frame:getWidth() - 2, 1)
        :setSize(1, 1)
        :setText("*")
        :setBackground("{self.clicked and colors.lightGray or colors.black}")
        :setForeground(colors.cyan)
        :onClickUp(function()
            if ext.iall({api.getDynamicData("x_coord"), api.getDynamicData("y_coord"), api.getDynamicData("z_coord")}) then
                return
            end
            input_x:setText(api.getDynamicData("x_coord"))
            input_y:setText(api.getDynamicData("y_coord"))
            input_z:setText(api.getDynamicData("z_coord"))
        end)

    app.onBack = callback.hide_app

    return app
end

local function drawIcon(canvas)
    canvas:rect(1, 1, 5, 3, " ", colors.black, colors.gray)
    canvas:text(1, 1, " ", colors.black, colors.black)
    canvas:text(5, 1, " ", colors.black, colors.black)
    canvas:text(2, 2, "   ", colors.black, colors.lightGray)
    canvas:text(2, 3, "   ", colors.black, colors.lightGray)
end

return {
    display_text = "Waystone",
    icon = drawIcon,
    app = waystoneApp
}