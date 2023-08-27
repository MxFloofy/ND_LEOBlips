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
        local character = NDCore.Functions.GetPlayer(source)
        
        for department, _ in pairs(Config.departments) do
            if character.job == department then
                local player_info = { name = player_name, src = source, dept = character.job, cname = NDCore.Functions.GetPlayer(src) }

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
    --print(active_leo[src].dept)
    TriggerClientEvent("MxDev:TOGGLELEOBLIP", player.src, true)
end)

RegisterServerEvent("MxDev:REMOVEBLIP")
AddEventHandler("MxDev:REMOVEBLIP", function(src)
    active_leo[src] = nil
    TriggerClientEvent("MxDev:TOGGLELEOBLIP", src, false)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(3000)
        for id, info in pairs(active_leo) do
            leo_job = active_leo[id].dept
            --print(leo_job)
            active_leo[id].coords = GetEntityCoords(GetPlayerPed(id))
            TriggerClientEvent("MxDev:UPDATEBLIPS", id, active_leo, leo_job)
        end
        for src, info in pairs(active_leo) do 
            local character = NDCore.Functions.GetPlayer(src)
            local jobMatches = false
            
            for department, _ in pairs(Config.departments) do
                if character.job == department then
                    jobMatches = true
                    break
                end
            end
            
            if not jobMatches then
                TriggerEvent('MxDev:REMOVEBLIP', src)
            end
        end
    end
end)

RegisterNetEvent('MxDev:AUTOBLIP')
AddEventHandler('MxDev:AUTOBLIP', function(source)
    src = source
    local character = NDCore.Functions.GetPlayer(src)
    
    for department, _ in pairs(Config.departments) do
        if character.job == department and not active_leo[src] then
            local player_info = { name = GetPlayerName(source), src = source, dept = character.job, cname = NDCore.Functions.GetPlayer(src) }
            TriggerEvent('MxDev:ADDBLIP', player_info)
            break
        elseif active_leo[src] and character.job ~= active_leo[src].dept then
            local player_info = { name = GetPlayerName(source), src = source, dept = character.job, cname = NDCore.Functions.GetPlayer(src) }
            TriggerEvent('MxDev:ADDBLIP', player_info)
            break
        end
    end
end)
