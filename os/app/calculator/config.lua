local ext = require("os/lib/ext")

return {
    desktop = {
        button_presets = {
            {
                {"abs", "cel", "log", "fac", "7", "8", "9", "(", ")", "",  "<"},
                {"rnd", "flr", "sin", "csc", "4", "5", "6", "+", "-", "c", "ce"},
                {"fra", "deg", "cos", "sec", "1", "2", "3", "*", "/", "pi", "e"},
                {"",    "rad", "tan", "cot", "#", "0", ".", "^", "%", ",",  "="},
            },
            {
                {"abs", "cel", "log", "fac", "7", "8", "9", "(", ")", "",  "<"},
                {"rnd", "flr", "asi", "acs", "4", "5", "6", "+", "-", "c", "ce"},
                {"fra", "deg", "aco", "ase", "1", "2", "3", "*", "/", "pi", "e"},
                {"",    "rad", "ata", "act", "#", "0", ".", "^", "%", ",",  "="},
            },
            {
                {"abs", "cel", "log", "fac", "7", "8", "9", "(", ")", "",  "<"},
                {"rnd", "flr", "sih", "csh", "4", "5", "6", "+", "-", "c", "ce"},
                {"fra", "deg", "coh", "seh", "1", "2", "3", "*", "/", "pi", "e"},
                {"",    "rad", "tah", "cth", "#", "0", ".", "^", "%", ",",  "="},
            },
        },
        button_color = {
            {colors.cyan, colors.green, colors.green, colors.green, colors.gray,      colors.gray, colors.gray,      colors.orange, colors.orange, colors.red,    colors.red},
            {colors.cyan, colors.green, colors.lime,  colors.lime,  colors.gray,      colors.gray, colors.gray,      colors.orange, colors.orange, colors.red,    colors.red},
            {colors.cyan, colors.green, colors.lime,  colors.lime,  colors.gray,      colors.gray, colors.gray,      colors.orange, colors.orange, colors.cyan,   colors.cyan},
            {colors.cyan, colors.green, colors.lime,  colors.lime,  colors.lightGray, colors.gray, colors.lightGray, colors.orange, colors.orange, colors.orange, colors.blue}
        },
        button_click_color = {
            {colors.lightGray, colors.lightGray, colors.lightGray, colors.lightGray, colors.lightGray, colors.lightGray, colors.lightGray, colors.lightGray, colors.lightGray, colors.red,       colors.lightGray},
            {colors.lightGray, colors.lightGray, colors.lightGray, colors.lightGray, colors.lightGray, colors.lightGray, colors.lightGray, colors.lightGray, colors.lightGray, colors.lightGray, colors.lightGray},
            {colors.lightGray, colors.lightGray, colors.lightGray, colors.lightGray, colors.lightGray, colors.lightGray, colors.lightGray, colors.lightGray, colors.lightGray, colors.lightGray, colors.lightGray},
            {colors.cyan,      colors.lightGray, colors.lightGray, colors.lightGray, colors.lightGray, colors.lightGray, colors.lightGray, colors.lightGray, colors.lightGray, colors.lightGray, colors.lightGray}
        },
        button_font_color = {
            {colors.black, colors.black, colors.black, colors.black, colors.white, colors.white, colors.white, colors.black, colors.black, colors.white, colors.white},
            {colors.black, colors.black, colors.black, colors.black, colors.white, colors.white, colors.white, colors.black, colors.black, colors.white, colors.white},
            {colors.black, colors.black, colors.black, colors.black, colors.white, colors.white, colors.white, colors.black, colors.black, colors.black, colors.black},
            {colors.black, colors.black, colors.black, colors.black, colors.black, colors.white, colors.black, colors.black, colors.black, colors.black, colors.white}
        },
        input_wrap_height = 4
    },
    pocket = {
        button_presets = {
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
        },
        button_color = {
            {colors.green, colors.green, colors.green, colors.green, colors.red, colors.red, colors.red},
            {colors.green, colors.green, colors.green, colors.cyan, colors.cyan, colors.orange, colors.orange},
            {colors.green, colors.green, colors.gray, colors.gray, colors.gray, colors.orange, colors.orange},
            {colors.lime, colors.lime, colors.gray, colors.gray, colors.gray, colors.orange, colors.orange},
            {colors.lime, colors.lime, colors.gray, colors.gray, colors.gray, colors.orange, colors.orange},
            {colors.lime, colors.lime, colors.lightGray, colors.gray, colors.lightGray, colors.orange, colors.blue},
        },
        button_click_color = {
            {colors.lightGray, colors.lightGray, colors.lightGray, colors.lightGray, colors.lightGray, colors.lightGray, colors.lightGray},
            {colors.lightGray, colors.lightGray, colors.lightGray, colors.lightGray, colors.lightGray, colors.lightGray, colors.lightGray},
            {colors.lightGray, colors.lightGray, colors.lightGray, colors.lightGray, colors.lightGray, colors.lightGray, colors.lightGray},
            {colors.lightGray, colors.lightGray, colors.lightGray, colors.lightGray, colors.lightGray, colors.lightGray, colors.lightGray},
            {colors.lightGray, colors.lightGray, colors.lightGray, colors.lightGray, colors.lightGray, colors.lightGray, colors.lightGray},
            {colors.lightGray, colors.lightGray, colors.lightGray, colors.lightGray, colors.lightGray, colors.lightGray, colors.lightGray},
        },
        button_font_color = {
            {colors.black, colors.black, colors.black, colors.black, colors.white, colors.white, colors.white},
            {colors.black, colors.black, colors.black, colors.black, colors.black, colors.black, colors.black},
            {colors.black, colors.black, colors.white, colors.white, colors.white, colors.black, colors.black},
            {colors.black, colors.black, colors.white, colors.white, colors.white, colors.black, colors.black},
            {colors.black, colors.black, colors.white, colors.white, colors.white, colors.black, colors.black},
            {colors.black, colors.black, colors.black, colors.white, colors.black, colors.black, colors.white},
        },
        input_wrap_height = 2
    },
    common = {
        button_display_logic = {
            abs = function(input, result) return "abs("..input..")", result end,
            fra = function(input, result) return "fractional("..input..")", result end,
            fac = function(input, result) return "factorial("..input..")", result end,
            log = function(input, result) return "log("..input..",", result end,
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
        },
        eval_logic = {
            abs = math.abs, fractional = ext.fractionalPart, factorial = ext.factorial, log = math.log,
            round = ext.round, ceil = math.ceil, floor = math.floor,
            pi = math.pi, e = math.exp(1),
            rad = math.rad, deg = math.deg,
            sin = math.sin, csc = ext.cosec, cos = math.cos, sec = ext.sec, tan = math.tan, cot = ext.cot,
            asin = math.asin, acos = math.acos, atan = math.atan, asec = ext.asec, acot = ext.acot, acosec = ext.acosec,
            sinh = ext.sinh, cosh = ext.cosh, tanh = ext.tanh, sech = ext.sech, coth = ext.coth, cosech = ext.cosech
        }
    }
}