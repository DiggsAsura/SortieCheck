_addon.name = 'SortieCheck'
_addon.author = 'DiggsAsura'
_addon.version = '2.6'
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

-- Finn de korrekte ID-ene fra resources basert på engelsk navn
local tracked_items = {
    ['Panacea'] = {id = nil, key = 'p_count'},
    ['Echo Drops'] = {id = nil, key = 'e_count'},
    ['Holy Water'] = {id = nil, key = 'h_count'},
    ['Remedy'] = {id = nil, key = 'r_count'},
}

-- Populer ID-tabellen ved oppstart
for name, data in pairs(tracked_items) do
    local item_res = res.items:with('en', name)
    if item_res then
        tracked_items[name].id = item_res.id
    end
end

-- FORBEDRET: Telle-funksjon som henter alle items i sekken korrekt
function get_all_counts()
    local counts = {p_count = 0, e_count = 0, h_count = 0, r_count = 0}
    
    -- Hent hele inventar-tabellen
    local inv = windower.ffxi.get_items(0)
    if not inv then return counts end

    -- Gå gjennom hver enkelt slot i sekken (0 til 80)
    for slot = 0, 80 do
        local item = inv[slot]
        if item and item.id > 0 and item.count > 0 then
            -- Sjekk om gjenstanden er en av de vi sporer
            for name, data in pairs(tracked_items) do
                if item.id == data.id then
                    counts[data.key] = counts[data.key] + item.count
                end
            end
        end
    end
    return counts
end

function get_item_color(count)
    if count <= 2 then return "\\cs(255,0,0)"
    elseif count <= 10 then return "\\cs(255,165,0)"
    else return "\\cs(0,255,0)" end
end

function send_my_info()
    local player = windower.ffxi.get_player()
    if player then
        local m_job = res.jobs[player.main_job_id].ens
        local s_job = player.sub_job_id and res.jobs[player.sub_job_id].ens or "NONE"
        
        local c = get_all_counts()
        
        windower.send_ipc_message(string.format("SortieCheck:%s:%s:%s:%d:%d:%d:%d", 
            player.name, m_job, s_job, c.p_count, c.e_count, c.h_count, c.r_count))
    end
end

windower.register_event('ipc message', function(msg)
    local parts = msg:split(':')
    if parts[1] == 'SortieCheck' and #parts >= 8 then
        remote_party_data[parts[2]] = {
            m_job = parts[3], s_job = parts[4],
            p_count = tonumber(parts[5]) or 0,
            e_count = tonumber(parts[6]) or 0,
            h_count = tonumber(parts[7]) or 0,
            r_count = tonumber(parts[8]) or 0
        }
    end
end)

windower.register_event('addon command', function(input, ...)
    local cmd = input and input:lower() or nil
    if cmd == 'visible' or cmd == 'show' or cmd == 'hide' then
        is_visible = not is_visible
        if is_visible then display_box:show() else display_box:hide() end
    elseif cmd == 'min' or cmd == 'minimal' then
        is_minimal = not is_minimal
    elseif cmd == 'debug' then
        local c = get_all_counts()
        windower.add_to_chat(200, string.format("Debug: Pan:%d Echo:%d Holy:%d Rem:%d", c.p_count, c.e_count, c.h_count, c.r_count))
    end
end)

function check_party()
    local party = windower.ffxi.get_party()
    if not party then return false, 0 end

    local ready_count = 0
    local party_count = 0
    local detailed_report = "Sortie Ready Check:\n"
    detailed_report = detailed_report .. string.format("%-14s %-9s %-4s %-4s %-4s %-4s\n", "Name", "Job", "Pan", "Echo", "Holy", "Rem")

    for i = 0, 5 do
        local member = party['p' .. i]
        if member and member.name ~= "" then
            party_count = party_count + 1
            local data = {m_job = "???", s_job = "???", p_count = 0, e_count = 0, h_count = 0, r_count = 0}

            if i == 0 then
                local player = windower.ffxi.get_player()
                data.m_job = res.jobs[player.main_job_id].ens
                data.s_job = player.sub_job_id and res.jobs[player.sub_job_id].ens or "NONE"
                local c = get_all_counts()
                data.p_count, data.e_count, data.h_count, data.r_count = c.p_count, c.e_count, c.h_count, c.r_count
            elseif remote_party_data[member.name] then
                data = remote_party_data[member.name]
            end

            local expected_sub = config.required_setup[data.m_job]
            local is_job_ok = (expected_sub and data.s_job == expected_sub)
            if is_job_ok then ready_count = ready_count + 1 end

            local name_col = string.format("%-14s", member.name)
            local job_col  = string.format("%-9s", string.format("%s/%s", data.m_job, data.s_job))
            local p_col = get_item_color(data.p_count) .. string.format("%-4d", data.p_count) .. "\\cr"
            local e_col = get_item_color(data.e_count) .. string.format("%-4d", data.e_count) .. "\\cr"
            local h_col = get_item_color(data.h_count) .. string.format("%-4d", data.h_count) .. "\\cr"
            local r_col = get_item_color(data.r_count) .. string.format("%-4d", data.r_count) .. "\\cr"

            local job_color = is_job_ok and "\\cs(0,255,0)" or (expected_sub and "\\cs(255,0,0)" or "\\cs(160,160,160)")
            detailed_report = detailed_report .. string.format("%s%s %s\\cr %s %s %s %s\n", job_color, name_col, job_col, p_col, e_col, h_col, r_col)
        end
    end

    local final_text = is_minimal and 
        (ready_count == 6 and "Sortie Ready Check: \\cs(0,255,0)READY\\cr" or "Sortie Ready Check: \\cs(255,0,0)NOT READY\\cr") 
        or detailed_report
    
    display_box:text(final_text)
    return (ready_count == 6), party_count
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
            local is_ready = check_party()
            if not is_ready then
                windower.add_to_chat(167, "[SortieCheck] ENTRY BLOCKED: Check jobs/items!")
                return true 
            end
        end
    end
end)