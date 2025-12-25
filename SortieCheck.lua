_addon.name = 'SortieCheck'
_addon.author = 'Digg'
_addon.version = '1.7'
_addon.commands = {'sc', 'sortiecheck'}

local texts = require('texts')
local packets = require('packets')
local res = require('resources')
local config = require('settings')

local remote_party_jobs = {}
local display_box = texts.new(config.overlay)
display_box:show()

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

function check_party()
    local party = windower.ffxi.get_party()
    if not party then return false, 0 end

    -- Overskrift med litt luft
    local status_report = "Sortie Ready Check:\n\n"
    local all_ok = true
    local member_count = 0

    for i = 0, 5 do
        local member = party['p' .. i]
        if member and member.name ~= "" then
            member_count = member_count + 1
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
            
            -- DEFINER KOLONNE-BREDDER HER
            -- %-14s betyr: Venstrestilt, 14 tegn bredde
            -- %-9s  betyr: Venstrestilt, 9 tegn bredde (plass til f.eks "RDM/DRK")
            local name_col = string.format("%-14s", member.name)
            local job_col  = string.format("%-9s", current_full_job)
            local status_col = ""

            local line_color = "\\cs(255,255,255)" -- Standard hvit

            if expected_sub then
                if s_job == expected_sub then
                    line_color = "\\cs(0,255,0)"
                    status_col = "(OK)"
                else
                    line_color = "\\cs(255,0,0)"
                    status_col = string.format("(WANT /%s)", expected_sub)
                    all_ok = false
                end
            else
                line_color = "\\cs(160,160,160)"
                status_col = "(Not in setup)"
            end

            -- Sett sammen linjen med faste bredder
            status_report = status_report .. string.format("%s%s %s %s\\cr\n", line_color, name_col, job_col, status_col)
        end
    end
    
    display_box:text(status_report)
    return all_ok, member_count
end

windower.register_event('prerender', function()
    if os.clock() % 1.0 < 0.01 then
        send_my_info()
        check_party()
    end
end)

windower.register_event('outgoing chunk', function(id, data)
    if id == 0x05B then
        local packet = packets.parse('outgoing', data)
        local target = windower.ffxi.get_mob_by_id(packet['Target'])
        
        if target and target.name == "Diaphanous Gadget" then
            local is_ok, count = check_party()
            if not is_ok then
                windower.add_to_chat(167, "[SortieCheck] ENTRY BLOCKED: Check your subjobs!")
                return true 
            end
        end
    end
end)