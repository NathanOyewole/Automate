-- sys_monitor.lua

local argparse = require("argparse")
local alerts = require("alerts")
local posix = require("posix")

local cpu_monitor = require("cpu_monitor")
local memory_monitor = require("memory_monitor")
local disk_monitor = require("disk_monitor")
local network_monitor = require("network_monitor")
local logging = require("logging")

local parser = argparse("sys_monitor", "System Monitoring Tool")
parser:option("-i --interval", "Refresh interval in seconds", "5"):convert(tonumber)
parser:flag("-c --cpu", "Monitor CPU usage")
parser:flag("-m --memory", "Monitor memory usage")
parser:flag("-d --disk", "Monitor disk usage")
parser:flag("-l --load", "Monitor CPU load average")
parser:flag("-n --network", "Monitor network usage")

local total_mem = 8295652
local free_mem = 2163292

if alerts.check_memory_alert then
    alerts.check_memory_alert(total_mem, free_mem)
else
    print("Error: check_memory_alert function not found in alerts.lua")
end

local args = parser:parse()
local interval = args.interval

-- Main monitoring and logging loop
local function monitor_and_log()
    if args.cpu then
        local user, nice, system, idle = cpu_monitor.get_cpu_usage()
        print("CPU Usage:")
        print(string.format("  User: %d", user))
        print(string.format("  Nice: %d", nice))
        print(string.format("  System: %d", system))
        print(string.format("  Idle: %d", idle))
        print("")
        alerts.check_cpu_alert(user, system, idle)
    end

    if args.memory then
        local total_mem, free_mem = memory_monitor.get_memory_usage()
        print("Memory Usage:")
        print(string.format("  Total: %d kB", total_mem))
        print(string.format("  Free: %d kB", free_mem))
        print("")
        alerts.check_memory_alert(total_mem, free_mem)
    end

    if args.disk then
        local used_disk, avail_disk = disk_monitor.get_disk_usage()
        print("Disk Usage (/):")
        print(string.format("  Used: %s", used_disk))
        print(string.format("  Available: %s", avail_disk))
        print("")
        alerts.check_disk_alert(used_disk)
    end

    if args.load then
        local load1, load5, load15 = cpu_monitor.get_cpu_load()
        print("CPU Load Average:")
        print(string.format("  1 minute: %.2f", load1))
        print(string.format("  5 minutes: %.2f", load5))
        print(string.format("  15 minutes: %.2f", load15))
        print("")
    end

    if args.network then
        local network_usage = network_monitor.get_network_usage()
        print("Network Usage:")
        for _, iface in ipairs(network_usage) do
            print(string.format("  %s: Receive: %d bytes, Transmit: %d bytes",
                iface.interface, iface.receive, iface.transmit))
        end
        print("")
    end

    -- Log metrics
    local log_file = io.open("system_metrics.log", "a")
    logging.log_system_usage(log_file)
    log_file:close()
end

-- Main loop
while true do
    monitor_and_log()
    posix.sleep(interval)
end

