-- Midnight-OS Installer

-- variables
local failed_files = {}
local git_path = {
    [ "os/lib/api.lua" ] = "https://raw.githubusercontent.com/Midnight-Github/Midnight-OS/refs/heads/main/os/lib/api.lua",
    [ "os/app/chat.lua" ] = "https://raw.githubusercontent.com/Midnight-Github/Midnight-OS/refs/heads/main/os/app/chat.lua",
    [ "os/lib/metrics.lua" ] = "https://raw.githubusercontent.com/Midnight-Github/Midnight-OS/refs/heads/main/os/lib/metrics.lua",
    [ "os/lib/basalt/bext.lua" ] = "https://raw.githubusercontent.com/Midnight-Github/Midnight-OS/refs/heads/main/os/lib/basalt/bext.lua",
    [ "uninstaller.lua" ] = "https://raw.githubusercontent.com/Midnight-Github/Midnight-OS/refs/heads/main/uninstaller.lua",
    [ "os/lib/ext.lua" ] = "https://raw.githubusercontent.com/Midnight-Github/Midnight-OS/refs/heads/main/os/lib/ext.lua",
    [ "os/app/waystone.lua" ] = "https://raw.githubusercontent.com/Midnight-Github/Midnight-OS/refs/heads/main/os/app/waystone.lua",
    [ "midnightos.lua" ] = "https://raw.githubusercontent.com/Midnight-Github/Midnight-OS/refs/heads/main/midnightos.lua",
    [ "os/app/info.lua" ] = "https://raw.githubusercontent.com/Midnight-Github/Midnight-OS/refs/heads/main/os/app/info.lua",
    [ "startup.lua" ] = "https://raw.githubusercontent.com/Midnight-Github/Midnight-OS/refs/heads/main/startup.lua",
    [ "os/config.lua" ] = "https://raw.githubusercontent.com/Midnight-Github/Midnight-OS/refs/heads/main/os/config.lua",
    [ "os/app/calculator.lua" ] = "https://raw.githubusercontent.com/Midnight-Github/Midnight-OS/refs/heads/main/os/app/calculator.lua",
    [ "os/app/terminal.lua" ] = "https://raw.githubusercontent.com/Midnight-Github/Midnight-OS/refs/heads/main/os/app/terminal.lua",
    [ "os/const.lua" ] = "https://raw.githubusercontent.com/Midnight-Github/Midnight-OS/refs/heads/main/os/const.lua",
    [ "os/lib/basalt/main.lua" ] = "https://raw.githubusercontent.com/Midnight-Github/Midnight-OS/refs/heads/main/os/lib/basalt/main.lua",
}

-- main
if not http then
    printError("http is required for OS installation, but it is not enabled")
    printError("Set http.enabled to true in CC: Tweaked's server config")
    return
end

print("\nInstalling...")
for file_path, git_file_path in pairs(git_path) do
    local response = http.get(git_file_path)
    if response then
        local file = fs.open(file_path, "w")
        if file then
            file.write(response.readAll())
            file.close()
            print("Installed: " .. file_path)
        else
            printError("Failed to open file: " .. file_path)
            table.insert(failed_files, file_path)
        end
    else
        printError("Failed to download: " .. file_path)
        table.insert(failed_files, file_path)
    end
end

if #failed_files > 0 then
    printError("\nSome files failed to install:")
    for _, file in ipairs(failed_files) do
        printError(file)
    end
    printError("\nPlease install them manually or try again.")
    return
end

print("\nInstallation complete.")

local api = require("os/lib/api")
local config = require("os/config")

print("\nOS Config setup")
term.write("Display name: ")
config.settings.display_name = tostring(read())

local offset
repeat
    term.write("UTC offset (in hours): ")
    local input = read()
    offset = tonumber(input)
    if not offset then
        printError("Invalid value.")
    end
until offset
config.settings.hours_off_set_from_utc = offset
api.updateConfig(config)

print()
for i = 3, 1, -1 do
    print("rebooting in "..i)
    sleep(1)
end

shell.run("reboot")