-- memory_monitor.lua

local function get_memory_usage()
    local file = io.open("/proc/meminfo", "r")
    local total, free = file:read("*a"):match("MemTotal:%s+(%d+)%s+kB\nMemFree:%s+(%d+)%s+kB")
    file:close()

    return tonumber(total), tonumber(free)
end

return {
    get_memory_usage = get_memory_usage
}

