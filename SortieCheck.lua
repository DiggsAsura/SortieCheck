_addon.name = 'SortieCheck'
_addon.author = 'DiggsAsura'
_addon.version = '3.4'
_addon.commands = {'schk', 'sortiecheck'}

local texts = require('texts')
local packets = require('packets')
local res = require('resources')
local config = require('settings')

local remote_party_data = {}
local display_box = texts.new(config.overlay)
display_box:show()

local is_visible = true
local is_minimal = false

local all_bags = {0,1,2,4,5,6,7,8,9,10,11,12,13,14,15}

local tracked_items = {
    ['Panacea'] = {id = nil, key = 'p'},
    ['Echo Drops'] = {id = nil, key = 'e'},
    ['Holy Water'] = {id = nil, key = 'h'},
    ['Remedy'] = {id = nil, key = 'r'},
    [config.required_food] = {id = nil, key = 'f'},
}

for name, data in pairs(tracked_items) do
    local item_res = res.items:with('en', name)
    if item_res then tracked_items[name].id = item_res.id end
end

function get_complex_counts()
    local results = {}
    for _, data in pairs(tracked_items) do
        results[data.key] = {inv = 0, tot = 0}
    end

    local free_slots = 0
    local inv_info = windower.ffxi.get_bag_info(0)
    if inv_info then
        free_slots = inv_info.max - inv_info.count 
    end

    for _, bag_id in ipairs(all_bags) do
        local bag = windower.ffxi.get_items(bag_id)
        if bag then 
            for i = 0, (bag.max or 80) do
                local item = bag[i]
                if item and item.id > 0 and item.count > 0 then
                    for name, data in pairs(tracked_items) do
                        if item.id == data.id then
                            if bag_id == 0 then 
                                results[data.key].inv = results[data.key].inv + item.count
                            end
                            results[data.key].tot = results[data.key].tot + item.count
                        end
                    end
                end
            end
        end
    end
    return results, free_slots
end

-- Mat følger nå samme fargeregel: 0-2 Rød, 3-10 Oransje, 11+ Grønn
function format_item_str(inv, tot)
    local color = "\\cs(0,255,0)"
    if inv <= 2 then color = "\\cs(255,0,0)"
    elseif inv <= 10 then color = "\\cs(255,165,0)"
    end
    
    local val_str = (tot > inv) and string.format("%d(%d)", inv, tot) or tostring(inv)
    local padded = string.format("%-8s", val_str)
    return color .. padded .. "\\cr"
end

function send_my_info()
    local player = windower.ffxi.get_player()
    if player then
        local m_job = res.jobs[player.main_job_id].ens
        local s_job = player.sub_job_id and res.jobs[player.sub_job_id].ens or "NONE"
        local c, free = get_complex_counts()
        windower.send_ipc_message(string.format("SortieCheck:%s:%s:%s:%d:%d:%d:%d:%d:%d:%d:%d:%d:%d:%d", 
            player.name, m_job, s_job, c.p.inv, c.p.tot, c.e.inv, c.e.tot, c.h.inv, c.h.tot, c.r.inv, c.r.tot, c.f.inv, c.f.tot, free))
    end
end

windower.register_event('ipc message', function(msg)
    local parts = msg:split(':')
    if parts[1] == 'SortieCheck' and #parts >= 15 then
        remote_party_data[parts[2]] = {
            m_job = parts[3], s_job = parts[4],
            p_i = tonumber(parts[5]), p_t = tonumber(parts[6]),
            e_i = tonumber(parts[7]), e_t = tonumber(parts[8]),
            h_i = tonumber(parts[9]), h_t = tonumber(parts[10]),
            r_i = tonumber(parts[11]), r_t = tonumber(parts[12]),
            f_i = tonumber(parts[13]), f_t = tonumber(parts[14]),
            free = tonumber(parts[15])
        }
    end
end)

windower.register_event('addon command', function(input)
    local cmd = input and input:lower() or nil
    if cmd == 'visible' then 
        is_visible = not is_visible
        if is_visible then display_box:show() else display_box:hide() end
    elseif cmd == 'minimal' or cmd == 'min' then 
        is_minimal = not is_minimal
    end
end)

function check_party()
    local party = windower.ffxi.get_party()
    if not party then return false end

    local ready_count = 0
    local report = "Sortie Ready Check:\n"
    -- 1. Free omdøpes til Inv
    report = report .. string.format("%-12s %-10s %-8s %-8s %-8s %-8s %-8s %-4s\n", "Name", "Job", "Pan", "Echo", "Holy", "Rem", "Food", "Inv")

    for i = 0, 5 do
        local member = party['p' .. i]
        if member and member.name ~= "" then
            local d = {m_job="???", s_job="???", p_i=0, p_t=0, e_i=0, e_t=0, h_i=0, h_t=0, r_i=0, r_t=0, f_i=0, f_t=0, free=0}
            if i == 0 then
                local player = windower.ffxi.get_player()
                local c, free = get_complex_counts()
                d = {m_job=res.jobs[player.main_job_id].ens, s_job=player.sub_job_id and res.jobs[player.sub_job_id].ens or "NONE",
                     p_i=c.p.inv, p_t=c.p.tot, e_i=c.e.inv, e_t=c.e.tot, h_i=c.h.inv, h_t=c.h.tot, r_i=c.r.inv, r_t=c.r.tot, f_i=c.f.inv, f_t=c.f.tot, free=free}
            elseif remote_party_data[member.name] then 
                d = remote_party_data[member.name] 
            end

            local exp = config.required_setup[d.m_job]
            local ok = (exp and d.s_job == exp)
            if ok then ready_count = ready_count + 1 end
            
            local job_c = ok and "\\cs(0,255,0)" or (exp and "\\cs(255,0,0)" or "\\cs(160,160,160)")
            
            -- Nye fargekrav for ledig plass:
            local free_c = "\\cs(0,255,0)" -- Grønn (20+)
            if d.free < 10 then 
                free_c = "\\cs(255,0,0)" -- 2. Rød (< 10)
            elseif d.free < 20 then 
                free_c = "\\cs(255,165,0)" -- 3. Oransje (< 20)
            end

            report = report .. string.format("%s%-12s %-10s\\cr %s %s %s %s %s %s%-4d\\cr\n", 
                job_c, member.name, d.m_job..'/'..d.s_job, 
                format_item_str(d.p_i, d.p_t), format_item_str(d.e_i, d.e_t), 
                format_item_str(d.h_i, d.h_t), format_item_str(d.r_i, d.r_t),
                format_item_str(d.f_i, d.f_t), free_c, d.free)
        end
    end

    display_box:text(is_minimal and (ready_count == 6 and "Sortie: \\cs(0,255,0)READY\\cr" or "Sortie: \\cs(255,0,0)NOT READY\\cr") or report)
    return (ready_count == 6)
end

windower.register_event('prerender', function()
    if os.clock() % 1.0 < 0.01 then
        send_my_info()
        if is_visible then check_party() end
    end
end)

windower.register_event('outgoing chunk', function(id, data)
    if id == 0x05B then
        local packet = packets.parse('outgoing', data)
        local target = windower.ffxi.get_mob_by_id(packet['Target'])
        if target and target.name == "Diaphanous Gadget" then
            if not check_party() then
                windower.add_to_chat(167, "[SortieCheck] ENTRY BLOCKED: Check jobs/items!")
                return true 
            end
        end
    end
end)