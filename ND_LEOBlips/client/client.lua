-- Import the ND_Core module
NDCore = exports["ND_Core"]:GetCoreObject()

-- Create a table to store current blips
local currentBlips = {}
local redBlueFlash = false -- Flag to track the blip color flash

-- Check if blips are enabled in the configuration
if Config.enable_blips then
    local blip_status = false

    -- Register event to toggle blip status
    RegisterNetEvent("MxDev:TOGGLELEOBLIP")
    AddEventHandler("MxDev:TOGGLELEOBLIP", function(st)
        blip_status = st
        if not blip_status then
            RemoveAnyExistingEmergencyBlips()
        end
    end)

    -- Register event to update blips
    RegisterNetEvent("MxDev:UPDATEBLIPS")
    AddEventHandler("MxDev:UPDATEBLIPS", function(activeEmergencyPersonnel, leo_job)
        if blip_status then
            RemoveAnyExistingEmergencyBlips()
            RefreshBlips(activeEmergencyPersonnel, leo_job)
        end
    end)
end

-- Create a thread to automatically update blips
Citizen.CreateThread(function()
    while true do
        local source = GetPlayerServerId(PlayerId())
        TriggerServerEvent('MxDev:AUTOBLIP', source)
        Citizen.Wait(5000)
    end
end)

-- Remove any existing emergency blips
function RemoveAnyExistingEmergencyBlips()
    for i = #currentBlips, 1, -1 do
        local b = currentBlips[i]
        if b and DoesBlipExist(b) then
            RemoveBlip(b)
        end
        table.remove(currentBlips, i)
    end
end

-- Refresh blips for active emergency personnel
function RefreshBlips(activeEmergencyPersonnel, leo_job)
    for src, info in pairs(activeEmergencyPersonnel) do
        if src ~= myServerId and info and info.coords then
            local playerIdx = GetPlayerFromServerId(src)
            local ped = GetPlayerPed(playerIdx)
            local heading = GetEntityHeading(ped)
            local isPedInVehicle = IsPedInAnyVehicle(ped, false)
            local blipType = isPedInVehicle and GetVehicleBlipType(GetVehiclePedIsIn(ped, false)) or GetPedBlipType(ped)
            
            if (isPedInVehicle or not Config.disable_show_officer_on_foot) then
                local blip = AddBlipForEntity(ped)
                SetBlipScale(blip, Config.blipscale)
                SetBlipSprite(blip, blipType)
                SetBlipCategory(blip, Config.blipcategory)
                SetBlipShrink(blip, true)
                SetBlipPriority(blip, 10)
                
                local job = NDCore.Functions.GetSelectedCharacter().job
                local leoDepartment = Config.departments[leo_job][1]
                
                local vehicle = GetVehiclePedIsIn(ped, false)
                if IsVehicleSirenOn(vehicle) then
                    if redBlueFlash then
                        SetBlipColour(blip, 1) -- Red color
                    else
                        SetBlipColour(blip, 29) -- Blue color
                    end
                else
                    SetBlipColour(blip, leoDepartment) -- Use the department color (blue)
                end
                
                SetBlipAsShortRange(blip, true)
                SetBlipDisplay(blip, 6)
                SetBlipShowCone(blip, Config.blipcone)
                
                ShowHeadingIndicatorOnBlip(blip, Config.HeadingIndicator)
                SetBlipRotation(blip, heading)
                
                local cname = NDCore.Functions.GetSelectedCharacter()
                local vehicleModel = GetEntityModel(GetVehiclePedIsIn(ped, false))
                local vehicleName = GetLabelText(GetDisplayNameFromVehicleModel(vehicleModel))
                
                BeginTextCommandSetBlipName("STRING")
                if Config.UseCharName then 
                    AddTextComponentString(job .. " | " .. cname.firstName .. " " .. cname.lastName .. " (" .. vehicleName .. ")")
                else 
                    AddTextComponentString(info.name)
                end
                EndTextCommandSetBlipName(blip)
                
                table.insert(currentBlips, blip)
            end
        end
    end
    
    -- Toggle the flash flag after each update
    redBlueFlash = not redBlueFlash
end


function GetPedBlipType(ped)
    local health = GetEntityHealth(ped)
    
    if Config.disable_show_officer_on_foot then
        -- Version 1 logic when Config.disable_show_officer_on_foot is true
        if IsPedInAnyVehicle(ped, false) then
            return GetVehicleBlipType(ped)
        elseif health == 0 then
            return 310
        else
            return Config.leofootblip
        end
    else
		-- Version 2 logic when Config.disable_show_officer_on_foot is false
        if IsPedInAnyVehicle(ped, false) then
        elseif health == 0 then
            return 310
        else
            return nil
        end
    end
end

-- Function to determine the blip type for a vehicle
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