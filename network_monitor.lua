-- network_monitor.lua

local function get_network_usage()
    local file = io.open("/proc/net/dev", "r")
    local data = file:read("*a")
    file:close()

    local interfaces = {}
    for line in data:gmatch("[^\r\n]+") do
        if line:match(":%s") then
            local interface, receive, transmit = line:match("(%w+):%s*(%d+).-%s(%d+).+")
            table.insert(interfaces, {
                interface = interface,
                receive = tonumber(receive),
                transmit = tonumber(transmit)
            })
        end
    end
    return interfaces
end

return {
    get_network_usage = get_network_usage
}

