-- Returns file path and extension
local function splitPathExtension(file_path)
    local base, ext = file_path:match("(.+)%.([^%.]+)$")
    if base and ext then
        return base, ext
    else
        return file_path, nil
    end
end

-- Wrapper function that ensures safe file access by file locking mechanism.
local function withSafeFile(path, mode, callback)
    local base, ext = splitPathExtension(path)
    local file_lock_path = base..".lock"
    while fs.exists(file_lock_path) do sleep(0.05) end

    local lock = fs.open(file_lock_path, "w")
    lock.close()

    local file = fs.open(path, mode)
    local ok, result = pcall(callback, file)

    if file then file.close() end
    if fs.exists(file_lock_path) then fs.delete(file_lock_path) end

    if ok then return result
    else error(result, 2)
    end
end

-- Moves a file to a new location and inserts a timestamp to its name.
local function archiveFile(file_path, archive_file_path, timestamp)
    if not fs.exists(file_path) then return false end

    local base, ext = splitPathExtension(archive_file_path)
    ext = ext or "txt"

    local archive_dir = fs.getDir(archive_file_path)
    if not fs.exists(archive_dir) then
        fs.makeDir(archive_dir)
    end

    fs.move(file_path, base .. "-" .. timestamp .. "." .. ext)

    return true
end

-- Ensures that the directory exists, creating it if necessary.
local function ensureDirExists(dir_path)
    if not fs.exists(dir_path) then
        fs.makeDir(dir_path)
    end
end

-- Truncates the archive directory by deleting old files until only max_files remains.
-- Assumes files are named in the format: base-<timestamp>.extension
-- Files without the format are ignored.
local function truncateArchiveDir(archive_dir_path, max_files)
    if not fs.exists(archive_dir_path) then return end

    local files = fs.list(archive_dir_path)
    local archive_files = {}

    -- Only include files with a timestamp in their name
    for _, fname in ipairs(files) do
        if fname:match("%-(%d+)%..-$") then
            table.insert(archive_files, fname)
        end
    end

    if #archive_files <= max_files then return end

    table.sort(archive_files, function(a, b)
        local a_time = tonumber(a:match("%-(%d+)%..-$"))
        local b_time = tonumber(b:match("%-(%d+)%..-$"))
        return a_time < b_time
    end)

    for i = 1, #archive_files - max_files do
        fs.delete(fs.combine(archive_dir_path, archive_files[i]))
    end
end

return {
    splitPathExtension = splitPathExtension,
    withSafeFile = withSafeFile,
    archiveFile = archiveFile,
    ensureDirExists = ensureDirExists,
    truncateArchiveDir = truncateArchiveDir,
}