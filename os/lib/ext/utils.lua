-- Evaluates a string as a Lua expression
local function eval(expr, env)
    env = env or _ENV
    local f, err = load("return " .. expr, "eval", "t", env)
    if not f then
        return nil, err
    end
    local ok, result = pcall(f)
    if ok then
        return result
    else
        return nil, result
    end
end

return {
    eval = eval,
}