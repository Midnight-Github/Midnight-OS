local function waystoneApp(parent)
    local app = {}

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

    local add_waystone_frame = main_frame:addFrame()
        :setPosition(1, main_frame:getHeight())
        :setSize(main_frame:getWidth(), 1)
        :setBackground(colors.red)

    local input_name = add_waystone_frame:addInput()
        :setPosition(1, 1)
        :setSize(5, 1)
        :setBackground(colors.gray)
        :setFocusedBackground(colors.gray)
        :setForeground(colors.white)
        :setPlaceholder("Name")
        :setPlaceholderColor(colors.lightGray)

    local input_x = add_waystone_frame:addInput()
        :setPosition(7, 1)
        :setSize(3, 1)
        :setBackground(colors.gray)
        :setFocusedBackground(colors.gray)
        :setForeground(colors.white)
        :setPlaceholder(" x")
        :setPlaceholderColor(colors.lightGray)

    local input_y = add_waystone_frame:addInput()
        :setPosition(11, 1)
        :setSize(3, 1)
        :setBackground(colors.gray)
        :setFocusedBackground(colors.gray)
        :setForeground(colors.white)
        :setPlaceholder(" y")
        :setPlaceholderColor(colors.lightGray)

    local input_z = add_waystone_frame:addInput()
        :setPosition(15, 1)
        :setSize(3, 1)
        :setBackground(colors.gray)
        :setFocusedBackground(colors.gray)
        :setForeground(colors.white)
        :setPlaceholder(" z")
        :setPlaceholderColor(colors.lightGray)

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
    name = "waystone",
    display_text = "Waystone",
    icon = drawIcon,
    app = waystoneApp
}