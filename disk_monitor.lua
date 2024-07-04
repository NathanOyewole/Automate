-- disk_monitor.lua

local function get_disk_usage()
    local handle = io.popen("df -h /")
    local result = handle:read("*a")
    handle:close()

    local used, avail = result:match("/%s+%S+%s+%S+%s+(%S+)%s+(%S+)")
    return used, avail
end

return {
    get_disk_usage = get_disk_usage
}

