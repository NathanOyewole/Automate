-- alerts.lua

local function check_memory_alert(total_mem, free_mem)
    local used_mem = total_mem - free_mem
    local mem_usage_percent = (used_mem / total_mem) * 100
    if mem_usage_percent > 80 then
        print("ALERT: High memory usage!")
    end
end

return {
    check_memory_alert = check_memory_alert
}

