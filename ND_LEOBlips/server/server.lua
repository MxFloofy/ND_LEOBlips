-- Import the ND_Core module
NDCore = exports["ND_Core"]:GetCoreObject()

-- Create a table to store active law enforcement officers with blips
local active_leo = {}

-- Check if blips are enabled in the configuration
if Config.enable_blips then
    -- Register the 'blip' chat command to toggle blip status
    RegisterCommand('blip', function(source, args, message)
        local status = args[1]
        if not status then
            return
        end
        status = status:lower()
        local player_name = GetPlayerName(source)
        local character = NDCore.Functions.GetPlayer(source)
        
        -- Check if the player's job matches any department
        for department, _ in pairs(Config.departments) do
            if character.job == department then
                local player_info = { name = player_name, src = source, dept = character.job }

                if status == "on" then
                    if active_leo[source] then
                        TriggerClientEvent('chatMessage', source, "^*^5[System]: Blips are already enabled.")
                    else 
                        TriggerEvent("MxDev:ADDBLIP", player_info)
                        TriggerClientEvent('chatMessage', source, "^*^5[System]: Enabled LEO blips.")
                    end
                elseif status == "off" then
                    if not active_leo[source] then
                        TriggerClientEvent('chatMessage', source, "^*^5[System]: Blips are already disabled.")
                    else 
                        TriggerEvent("MxDev:REMOVEBLIP", source)
                        TriggerClientEvent('chatMessage', source, "^*^5[System]: Disabled LEO blips.")
                    end
                end

                return  -- Exit the loop once the department is matched
            end
        end

        -- If the player's job doesn't match any department, show access denied
        TriggerClientEvent('chatMessage', source, "^*^5[System]: Access Denied")
    end)
end

-- Remove the player's blip when they disconnect
AddEventHandler("playerDropped", function()
    active_leo[source] = nil
end)

-- Register event to add a blip for a law enforcement officer
RegisterNetEvent("MxDev:ADDBLIP")
AddEventHandler("MxDev:ADDBLIP", function(player)
    active_leo[player.src] = player
    TriggerClientEvent("MxDev:TOGGLELEOBLIP", player.src, true)
end)

-- Register event to remove a blip for a law enforcement officer
RegisterServerEvent("MxDev:REMOVEBLIP")
AddEventHandler("MxDev:REMOVEBLIP", function(src)
    active_leo[src] = nil
    TriggerClientEvent("MxDev:TOGGLELEOBLIP", src, false)
end)

-- Continuously update blip positions
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(2500)
        for id, info in pairs(active_leo) do
            leo_job = active_leo[id].dept
            active_leo[id].coords = GetEntityCoords(GetPlayerPed(id))
            TriggerClientEvent("MxDev:UPDATEBLIPS", id, active_leo, leo_job)
        end
        for src, info in pairs(active_leo) do 
            local character = NDCore.Functions.GetPlayer(src)
            local jobMatches = false
            
            -- Check if the player's job matches any department
            for department, _ in pairs(Config.departments) do
                if character.job == department then
                    jobMatches = true
                    break
                end
            end
            
            -- If the player's job doesn't match any department, remove blip
            if not jobMatches then
                TriggerEvent('MxDev:REMOVEBLIP', src)
            end
        end
    end
end)
