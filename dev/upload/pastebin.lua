-- Upload a file to pastebin.com

-- Determine file to upload
local function put(file)
    if not http then
        printError("Pastebin requires the http API, but it is not enabled")
        printError("Set http.enabled to true in CC: Tweaked's server config")
        return
    end

    local sPath = shell.resolve(file)
    if not fs.exists(sPath) or fs.isDir(sPath) then
        printError("No such file")
        return
    end

    -- Read in the file
    local sName = fs.getName(sPath)
    local file = fs.open(sPath, "r")
    local sText = file.readAll()
    file.close()

    -- POST the contents to pastebin
    local key = "0ec2eb25b6166c0c27a394ae118ad829"
    local response = http.post(
        "https://pastebin.com/api/api_post.php",
        "api_option=paste&" ..
        "api_dev_key=" .. key .. "&" ..
        "api_paste_format=lua&" ..
        "api_paste_name=" .. textutils.urlEncode(sName) .. "&" ..
        "api_paste_code=" .. textutils.urlEncode(sText)
    )

    if response then
        local sResponse = response.readAll()
        response.close()

        local sCode = string.match(sResponse, "[^/]+$")
        return sCode
    else
        return false
    end
end

return {
    put = put
}