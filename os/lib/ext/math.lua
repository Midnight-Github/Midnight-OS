local function round(num, precision)
    precision = precision or 1
    return math.floor(num / precision + 0.5) * precision
end

local function signum(num)
    if num > 0 then
        return 1
    elseif num < 0 then
        return -1
    elseif num == 0 then
        return 0
    end
    return nil
end

local function fractionalPart(num)
    return num - math.floor(num)
end

local function factorial(num)
    if num < 0 then return nil end
    if num == 0 then return 1 end

    local res = 1
    for i = 2, num do
        res = res * i
    end
    return res
end

-- Trigonometric functions

local function cosec(x)
    return 1 / math.sin(x)
end

local function sec(x)
    return 1 / math.cos(x)
end

local function cot(x)
    return 1 / math.tan(x)
end

local function asec(x)
    if x == 0 then return nil end
    return math.acos(1 / x)
end

local function acot(x)
    if x == 0 then return math.pi / 2 end
    return math.atan(1 / x)
end

local function acosec(x)
    if x == 0 then return nil end
    return math.asin(1 / x)
end

local function sinh(x)
    return (math.exp(x) - math.exp(-x)) / 2
end
local function cosh(x)
    return (math.exp(x) + math.exp(-x)) / 2
end
local function tanh(x)
    return sinh(x) / cosh(x)
end

local function cosech(x)
    return 1 / sinh(x)
end

local function sech(x)
    return 1 / cosh(x)
end

local function coth(x)
    return 1 / tanh(x)
end

return {
    round = round,
    signum = signum,
    fractionalPart = fractionalPart,
    factorial = factorial,
    cosec = cosec,
    sec = sec,
    cot = cot,
    asec = asec,
    acot = acot,
    acosec = acosec,
    sinh = sinh,
    cosh = cosh,
    tanh = tanh,
    cosech = cosech,
    sech = sech,
    coth = coth
}