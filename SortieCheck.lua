_addon.name = 'SortieCheck'
_addon.author = 'DiggsAsura'
_addon.version = '2.0'
_addon.commands = {'schk', 'sortiecheck'}

local texts = require('texts')
local packets = require('packets')
local res = require('resources')
local config = require('settings')

local remote_party_jobs = {}
local display_box = texts.new(config.overlay)
display_box:show()

local is_visible = true
local is_minimal = false

function send_my_info()
    local player = windower.ffxi.get_player()
    if player then
        local m_job = res.jobs[player.main_job_id].ens
        local s_job = player.sub_job_id and res.jobs[player.sub_job_id].ens or "NONE"
        windower.send_ipc_message(string.format("SortieCheck:%s:%s:%s", player.name, m_job, s_job))
    end
end

windower.register_event('ipc message', function(msg)
    local parts = msg:split(':')
    if parts[1] == 'SortieCheck' then
        remote_party_jobs[parts[2]] = {m_job = parts[3], s_job = parts[4]}
    end
end)

function print_help()
    windower.add_to_chat(207, '[SortieCheck] Commands:')
    windower.add_to_chat(207, ' //schk visible  - Toggles overlay on/off')
    windower.add_to_chat(207, ' //schk minimal  - Toggles between Full and Minimal mode')
    windower.add_to_chat(207, ' //schk help     - Shows this help menu')
end

windower.register_event('addon command', function(input, ...)
    local cmd = input and input:lower() or nil
    
    if cmd == 'visible' or cmd == 'show' or cmd == 'hide' then
        is_visible = not is_visible
        if is_visible then display_box:show() else display_box:hide() end
        windower.add_to_chat(207, "[SortieCheck] Visibility toggled.")
    elseif cmd == 'min' or cmd == 'minimal' then
        is_minimal = not is_minimal
        windower.add_to_chat(207, "[SortieCheck] Minimal mode: " .. (is_minimal and "ON" or "OFF"))
    else
        print_help()
    end
end)

function check_party()
    local party = windower.ffxi.get_party()
    if not party then return false, 0 end

    local ready_count = 0
    local party_count = 0
    local detailed_report = ""

    for i = 0, 5 do
        local member = party['p' .. i]
        if member and member.name ~= "" then
            party_count = party_count + 1
            local m_job, s_job = "???", "???"

            if i == 0 then
                local player = windower.ffxi.get_player()
                m_job = res.jobs[player.main_job_id].ens
                s_job = player.sub_job_id and res.jobs[player.sub_job_id].ens or "NONE"
            elseif remote_party_jobs[member.name] then
                m_job = remote_party_jobs[member.name].m_job
                s_job = remote_party_jobs[member.name].s_job
            end

            local current_full_job = string.format("%s/%s", m_job, s_job)
            local expected_sub = config.required_setup[m_job]
            
            local name_col = string.format("%-14s", member.name)
            local job_col  = string.format("%-9s", current_full_job)
            local status_col = ""
            local line_color = "\\cs(160,160,160)" -- Default grå

            if expected_sub then
                if s_job == expected_sub then
                    line_color = "\\cs(0,255,0)"
                    status_col = "(OK)"
                    ready_count = ready_count + 1
                else
                    line_color = "\\cs(255,0,0)"
                    status_col = string.format("(WANT /%s)", expected_sub)
                end
            else
                status_col = "(Not in setup)"
            end

            detailed_report = detailed_report .. string.format("%s%s %s %s\\cr\n", line_color, name_col, job_col, status_col)
        end
    end

    local final_text = ""
    if is_minimal then
        -- READY kun hvis alle 6 er OK
        if ready_count == 6 then
            final_text = "Sortie Ready Check: \\cs(0,255,0)READY\\cr"
        else
            final_text = "Sortie Ready Check: \\cs(255,0,0)NOT READY\\cr"
        end
    else
        final_text = "Sortie Ready Check:\n\n" .. detailed_report
    end
    
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
                windower.add_to_chat(167, "[SortieCheck] ENTRY BLOCKED: Party not ready!")
                return true 
            end
        end
    end
end)