NDCore = exports["ND_Core"]:GetCoreObject()
local active_leo = {}

if Config.enable_blips then
    RegisterCommand('blip', function(source, args, message)
        local status = args[1]
        if not status then
            return
        end
        status = status:lower()
        local player_name = GetPlayerName(source)
        local character = NDCore.getPlayer(source)
        
        for department, _ in pairs(Config.departments) do
            if character.job == department then
                local player_info = { name = player_name, src = source, dept = character.job }

                if status == "on" then
                    if active_leo[source] then
                        TriggerClientEvent('chatMessage', source, "[^3Dispatch^0] Your blips are already enabled!")
                    else 
                        TriggerEvent("MxDev:ADDBLIP", player_info)
                        TriggerClientEvent('chatMessage', source, "[^3Dispatch^0] You have enabled LEO blips!")
                    end
                elseif status == "off" then
                    if not active_leo[source] then
                        TriggerClientEvent('chatMessage', source, "[^3Dispatch^0] Your blips are already disabled!")
                    else 
                        TriggerEvent("MxDev:REMOVEBLIP", source)
                        TriggerClientEvent('chatMessage', source, "[^3Dispatch^0] You have disabled LEO blips!")
                    end
                end

                return  -- Exit the loop once the department is matched
            end
        end

        TriggerClientEvent('chatMessage', source, "^1 Access Denied")
    end)
end

AddEventHandler("playerDropped", function()
    active_leo[source] = nil
end)

RegisterNetEvent("MxDev:ADDBLIP")
AddEventHandler("MxDev:ADDBLIP", function(player)
    active_leo[player.src] = player
    TriggerClientEvent("MxDev:TOGGLELEOBLIP", player.src, true)
end)

RegisterServerEvent("MxDev:REMOVEBLIP")
AddEventHandler("MxDev:REMOVEBLIP", function(src)
    active_leo[src] = nil
    TriggerClientEvent("MxDev:TOGGLELEOBLIP", src, false)
end)

RegisterNetEvent('MxDev:AUTOBLIP')
AddEventHandler('MxDev:AUTOBLIP', function(source)
    local character = NDCore.getPlayer(source)
    for department, _ in pairs(Config.departments) do
        if character.job == department and not active_leo[source] then
            local player_info = { name = GetPlayerName(source), src = source, dept = character.job }
            TriggerEvent('MxDev:ADDBLIP', player_info)
            break
        elseif character.job ~= department and active_leo[source] then
            TriggerEvent('MxDev:REMOVEBLIP', source)
            active_leo[source] = nil
            break
        end
    end
end)

RegisterNetEvent('MxDev:AUTOBLIPADD')
AddEventHandler('MxDev:AUTOBLIPADD', function(source)
    --print('autov')
    for id, _ in pairs(active_leo) do
        --print('inautov')
        local leo_job = active_leo[id].dept
        active_leo[id].coords = GetEntityCoords(GetPlayerPed(id))
        TriggerClientEvent("MxDev:UPDATEBLIPS", id, active_leo, leo_job)
    end
end)