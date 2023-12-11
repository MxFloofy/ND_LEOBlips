NDCore = exports["ND_Core"]:GetCoreObject()
local currentBlips = {}

if Config.enable_blips then
    local blip_status = false

    RegisterNetEvent("MxDev:TOGGLELEOBLIP")
    AddEventHandler("MxDev:TOGGLELEOBLIP", function(st)
        blip_status = st
        --print('toggle blip')
        --print(blip_status)
        if not blip_status then
            RemoveAnyExistingEmergencyBlips()
        else 
            TriggerServerEvent("MxDev:AUTOBLIPADD")
        end
    end)

    RegisterNetEvent("MxDev:UPDATEBLIPS")
    AddEventHandler("MxDev:UPDATEBLIPS", function(activeEmergencyPersonnel, leo_job)
        if blip_status then
            RefreshBlips(activeEmergencyPersonnel, leo_job)
        end
    end)
end

-- RegisterNetEvent('ND:updateCharacter')
-- AddEventHandler('ND:updateCharacter', function(character)
--     local source = GetPlayerServerId(PlayerId())
--     print("loaded " .. source)
--     Citizen.Wait(50)
--     TriggerServerEvent('MxDev:AUTOBLIP', source)
-- end)

RegisterNetEvent('ND:characterLoaded')
AddEventHandler('ND:characterLoaded', function(character)
    local source = GetPlayerServerId(PlayerId())
    --print("loaded " .. source)
    TriggerServerEvent('MxDev:AUTOBLIP', source)
end)

function RemoveAnyExistingEmergencyBlips()
    for i = #currentBlips, 1, -1 do
        local b = currentBlips[i]
        if b and DoesBlipExist(b) then
            RemoveBlip(b)
            table.remove(currentBlips, i)
        end
    end
end

AddTextEntry('DutyBlips', 'DUTY BLIPS')
function RefreshBlips(activeEmergencyPersonnel, leo_job)
    --local myServerId = GetPlayerServerId(PlayerId())
    for src, info in pairs(activeEmergencyPersonnel) do        
        if src ~= myServerId and info and info.coords then
            --print("blip made")
            local playerIdx = GetPlayerFromServerId(src)
            local ped = GetPlayerPed(playerIdx)
            local heading = GetEntityHeading(ped)
            local blipType = (info.coords and IsPedInAnyVehicle(ped, false)) and GetVehicleBlipType(ped) or GetPedBlipType(ped)
            local blip = AddBlipForEntity(ped)
            SetBlipScale(blip, Config.blipscale)
            SetBlipSprite(blip, blipType)
            SetBlipCategory(blip, Config.blipcategory)
            SetBlipShrink(blip, true)
            SetBlipPriority(blip, 10)
            SetBlipColour(blip, Config.departments[leo_job][1])
            SetBlipAsShortRange(blip, true)
            SetBlipDisplay(blip, 6)
            SetBlipShowCone(blip, Config.blipcone)

            ShowHeadingIndicatorOnBlip(blip, Config.HeadingIndicator)
            SetBlipRotation(blip, heading)
            
            local cname = NDCore.getPlayer()
            
            BeginTextCommandSetBlipName('STRING')
            if Config.UseCharName then 
                AddTextComponentString(cname.job:upper() .. " | " .. cname.fullname)
            else 
                AddTextComponentString(info.name)
            end
            EndTextCommandSetBlipName(blip)
            
            table.insert(currentBlips, blip)
        end
    end
end

function GetPedBlipType(ped)
    local health = GetEntityHealth(ped)
    if IsPedInAnyVehicle(ped, false) then
        return GetVehicleBlipType(ped)
    elseif Config.show_officer_on_foot and health == 0 then
        return 310
    elseif Config.show_officer_on_foot then
        return Config.leofootblip
    end
end

function GetVehicleBlipType(vehicle)
    local vehicleClass = GetVehicleClass(vehicle)
    if vehicleClass == 15 then
        return Config.helicopterblip
    elseif vehicleClass == 14 then
        return Config.boatblip
    elseif vehicleClass == 8 or vehicleClass == 13 then
        return Config.motorcycleblip
    elseif vehicleClass == 16 then
        return Config.planeblip
    else
        return Config.vehicleblip
    end
end