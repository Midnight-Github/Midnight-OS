-- Midnight-OS Installer

-- variables
local config = {
    pastebin_code = {
        [ "midnightos_v1.lua" ] = "uZebGcLf",
        [ "os/app/chat.lua" ] = "WEM384ch",
        [ "os/lib/gps.lua" ] = "cuMBg8dM",
        [ "os/app/terminal.lua" ] = "ne0haYJr",
        [ "os/app/calculator.lua" ] = "QwdZzUAK",
        [ "os/app/info.lua" ] = "mAXqSnCa",
        [ "os/app/waystone.lua" ] = "9tkZFF1c",
        [ "os/lib/basalt/bext.lua" ] = "q8VTEJxk",
        [ "os/lib/api.lua" ] = "8mzvsFNv",
        [ "startup.lua" ] = "HFTSqhvd",
        [ "os/config.lua" ] = "0vfcyq9u",
        [ "os/const.lua" ] = "r17pY7cP",
        [ "os/lib/metrics.lua" ] = "ujvQ0QU8",
        [ "os/lib/ext.lua" ] = "ySk6eWyJ",
        [ "os/lib/basalt/main.lua" ] = "g4npwytV",
    },
}

local failed_files = {}

-- main
if not http then
    printError("Pastebin requires the http API, but it is not enabled")
    printError("Set http.enabled to true in CC: Tweaked's server config")
    return
end

print("Installing...")
for file_path, code in pairs(config.pastebin_code) do
    if code ~= "failed" then
        shell.run("pastebin get " .. code .. " " .. file_path)
    else
        local reason = "No pastebin code found"
        printError(reason.." for: "..file_path)
        failed_files[#failed_files + 1] = {file_path, reason}
    end
end
print("\nInstallation complete.")

if #failed_files == 0 then
    print("All files installed successfully.")

    local api = require("os/lib/api")
    local os_config = require("os/config")

    print("\nOS Config setup")
    term.write("Display name: ")
    os_config.settings.display_name = tostring(read())

    local offset
    repeat
        term.write("utc offset (in hours): ")
        local input = read()
        offset = tonumber(input)
        if not offset then
            printError("Invalid value.")
        end
    until offset
    os_config.settings.hours_off_set_from_utc = offset

    api.updateConfig(os_config)

    print("\nrebooting in 3 seconds...")
    sleep(3)
    shell.run("reboot")
    return
end

print("\nThe following files have failed to install:")
for file, reason in pairs(failed_files) do
    printError(file..": "..reason)
end