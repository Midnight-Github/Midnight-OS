local function terminalApp(parent)
    local app = {}
    local main_frame = parent:addFrame()
        :setPosition(1, 2)
        :setSize(parent:getWidth(), parent:getHeight() - 2)
        :setBackground(colors.black)

    local prog = main_frame:addProgram()
        :setPosition(1, 1)
        :setSize(main_frame:getWidth(), main_frame:getHeight())

    prog:execute("shell")

    return app
end

local function drawIcon(canvas)
    canvas:text(1, 1, ">_  ", colors.white, colors.lightGray)
    canvas:text(5, 1, " ", colors.white, colors.red)
    canvas:rect(1, 2, 5, 2, " ", colors.white, colors.gray)
end

return {
    name = "terminal",
    display_text = "Terminal",
    icon = drawIcon,
    app = terminalApp,
}
