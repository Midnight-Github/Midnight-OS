-- Midnight-OS Uploader
-- Uploades os files to pastebin.com and generates a config file.

-- imports
local config = require("config")
local pastebin = require("pastebin")

-- variables
local path = ""
local blacklist = {
    "dev",
    "about.txt",
    "midnightos_installer.lua",
    "midnightos_uninstaller.lua",
    "rom",
    "appdata"
}

-- functions
local function isBlacklisted(file, blacklist)
    for _, b in ipairs(blacklist) do
        if file == b then return true end
    end
    return false
end

local function uploadFile(dirPath, blacklist)
    local files = fs.list(dirPath)
    for _, file in ipairs(files) do
        if not isBlacklisted(file, blacklist) then
            local fullPath = fs.combine(dirPath, file)
            if fs.isDir(fullPath) then
                uploadFile(fullPath, blacklist)
            else
                if not config.pastebin_code[fullPath] or config.pastebin_code[fullPath] == "failed" then
                    local code = pastebin.put(fullPath) or "failed"
                    config.pastebin_code[fullPath] = code
                    if code then
                        print(fullPath..": "..code)
                    else
                        printError("Failed to upload: "..fullPath)
                    end
                    sleep(1)
                end
            end
        end
    end
end

-- main
print("Uploading...")
uploadFile(path, blacklist)

local config_file = fs.open("dev/upload/config.lua", "w")
config_file.write("return "..textutils.serialize(config))
config_file.close()