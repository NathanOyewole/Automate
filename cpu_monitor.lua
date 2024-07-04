-- cpu_monitor.lua

local posix = require("posix")

local function get_cpu_usage()
    local file = io.open("/proc/stat", "r")
    local line = file:read("*l")
    file:close()

    local user, nice, system, idle = line:match("cpu%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)")
    return tonumber(user), tonumber(nice), tonumber(system), tonumber(idle)
end

return {
    get_cpu_usage = get_cpu_usage
}

