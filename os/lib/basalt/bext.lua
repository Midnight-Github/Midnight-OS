-- Library for extra basalt functions


-- Returns the overall height of all visible children in a container.
local function getChildrenHeight(container)
    local height = 0
    for _, child in ipairs(container.get("children")) do
        if(child.get("visible"))then
            local newHeight = child.get("y") + child.get("height")
            if newHeight > height then
                height = newHeight
            end
        end
    end
    return height
end

-- Returns the overall width of all visible children in a container.
local function getChildrenWidth(container)
    local width = 0
    for _, child in ipairs(container.get("children")) do
        if(child.get("visible"))then
            local newWidth = child.get("x") + child.get("width")
            if newWidth > width then
                width = newWidth
            end
        end
    end
    return width
end

-- Adds vertical scrolling behavior to the given frame. The frame will scroll vertically when scrolled.
local function addVarticalScrolling(frame)
    frame:onScroll(function(self, delta)
        local offset = math.max(0, math.min(self.get("offsetY") + delta, getChildrenHeight(self) - self.get("height")))
        self:setOffsetY(offset)
    end)
end

-- Adds horizontal scrolling behavior to the given frame. The frame will scroll horizontally when scrolled.
local function addHorizontalScrolling(frame)
    frame:onScroll(function(self, delta)
        local offset = math.max(0, math.min(self.get("offsetX") + delta, getChildrenWidth(self) - self.get("width")))
        self:setOffsetX(offset)
    end)
end

local function verticalScroll(frame, delta)
    local offset = math.max(0, math.min(frame.get("offsetY") + delta, getChildrenHeight(frame) - frame.get("height")))
    frame:setOffsetY(offset)
end

local function horizontalScroll(frame, delta)
    local offset = math.max(0, math.min(frame.get("offsetX") + delta, getChildrenWidth(frame) - frame.get("width")))
    frame:setOffsetX(offset)
end

local function verticalScrollToEnd(frame)
    local offset = math.max(0, getChildrenHeight(frame) - frame.get("height"))
    frame:setOffsetY(offset)
end

local function horizontalScrollToEnd(frame)
    local offset = math.max(0, getChildrenWidth(frame) - frame.get("width"))
    frame:setOffsetX(offset)
end


-- Return functions
return {
    getChildrenHeight = getChildrenHeight,
    getChildrenWidth = getChildrenWidth,
    addVarticalScrolling = addVarticalScrolling,
    addHorizontalScrolling = addHorizontalScrolling,
    verticalScroll = verticalScroll, -- testing required
    horizontalScroll = horizontalScroll, -- testing required
    verticalScrollToEnd = verticalScrollToEnd, -- testing required
    horizontalScrollToEnd = horizontalScrollToEnd, -- testing required
}