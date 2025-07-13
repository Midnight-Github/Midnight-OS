-- Midnight-OS Uploader
-- Uploades os files to pastebin.com and generates a config file.

-- imports
local git_path = require("git_path")

-- variables
local git_common_path = "https://raw.githubusercontent.com/Midnight-Github/Midnight-OS/refs/heads/main/"
local blacklist = {
    ".git",
    ".gitignore",
    "README.md",
    "LICENSE",
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

local function uploadFile(dir_path, blacklist)
    local files = fs.list(dir_path)
    for _, file in ipairs(files) do
        if not isBlacklisted(file, blacklist) then
            local full_path = fs.combine(dir_path, file)
            if fs.isDir(full_path) then
                uploadFile(full_path, blacklist)
            else
                git_path[full_path] = git_common_path..full_path
                print("Uploaded: "..full_path)
                --sleep(1)
            end
        end
    end
end

-- main
print("Uploading...")
uploadFile("", blacklist)

local file = fs.open("dev/upload/git_path.lua", "w")
file.write("return "..textutils.serialize(git_path))
file.close()