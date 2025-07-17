-- Midnight-OS Uninstaller

local files_to_delete = {
    "startup.lua",
    "os",
    "midnightos.lua",
    "uninstaller.lua"
}

local function deletePath(path)
    if fs.exists(path) then
        if fs.isDir(path) then
            local files = fs.list(path)
            for _, file in ipairs(files) do
                deletePath(fs.combine(path, file))
            end
            fs.delete(path)
            print("Deleted directory: " .. path)
        else
            fs.delete(path)
            print("Deleted file: " .. path)
        end
    end
end

print("Midnight-OS Uninstaller")
term.write("Continue? (y/n): ")

if read():lower() ~= "y" then
    print("Uninstallation cancelled.")
    return
end

print("Uninstalling...")
for _, path in ipairs(files_to_delete) do
    deletePath(path)
end
print("Uninstallation complete.")