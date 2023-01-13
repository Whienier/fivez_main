local inZone = false
local zoneTriggered = false
local safeZoneId = nil

function IsPlayerInSafeZone()
    return inZone
end

Citizen.CreateThread(function()
    while true do
        while not startThreads do Citizen.Wait(1) end

        local pedCoords = GetEntityCoords(GetPlayerPed(-1))
        local dist = -1
        for k,v in pairs(Config.SafeZones) do
            local distance = #(pedCoords - v.position)
            if dist == -1 or distance < dist then
                dist = distance
                tempZoneId = k
            end
        end
        local safeZoneRadius = Config.SafeZones[tempZoneId].radius or Config.DefaultSafeZoneRadius
        if dist < safeZoneRadius and inZone == false then
            inZone = true
            safeZoneId = tempZoneId
        elseif dist > safeZoneRadius and inZone == true then
            inZone = false
        end
        --If we are far away increase wait time since it'll take the player some time to get in range anyway 
        if dist >= safeZoneRadius + 75 and dist <= safeZoneRadius + 149 then
            Citizen.Wait(5000)
        elseif dist >= safeZoneRadius + 150 and dist <= safeZoneRadius + 199 then
            Citizen.Wait(10000)
        elseif dist >= safeZoneRadius + 200 then
            Citizen.Wait(20000)
        end
        Citizen.Wait(1500)
    end
end)

local traderId = nil
local inBarber = false
local inClothes = false

local lastNotif = 0

Citizen.CreateThread(function()
    while true do
        while not startThreads do Citizen.Wait(1) end
        while not NetworkIsPlayerActive(PlayerId()) do Citizen.Wait(1) end

        if inZone and zoneTriggered then
            --If the player doesn't have invincibility but is in the zone
            if not GetPlayerInvincible(-1) then SetPlayerInvincible(PlayerId(), true) end
            DisablePlayerFiring(PlayerId(), true)
            --If player is in pause menu don't tell them weapons are restricted
            if not IsPauseMenuActive() then
                DisableControlAction(0, 25, true)
                DisableControlAction(0, 106, true)
                DisableControlAction(0, 140, true)
                DisableControlAction(0, 141, true)
                DisableControlAction(0, 142, true)
                DisableControlAction(0, 263, true)
                DisableControlAction(0, 264, true)
            
                if GetGameTimer() + 5000 > lastNotif and (IsDisabledControlJustPressed(0, 25) or IsDisabledControlJustPressed(0, 106) or IsDisabledControlJustPressed(0, 140) or IsDisabledControlJustPressed(0, 141) or IsDisabledControlJustPressed(0, 142) or IsDisabledControlJustPressed(0, 263) or IsDisabledControlJustPressed(0, 264)) then
                    TriggerEvent("fivez:AddNotification", "Using weapons is restricted!")
                    lastNotif = GetGameTimer()
                end
            end

            local pedCoords = GetEntityCoords(GetPlayerPed(-1))
            if Config.SafeZones[safeZoneId].traders.barber then
                local barberPos = Config.SafeZones[safeZoneId].traders.barber.position
                local dist = #(pedCoords - barberPos)
                if dist <= 15 then
                    if Config.SafeZones[safeZoneId].traders.barber.markerlabel then
                        Draw3DText(barberPos.x, barberPos.y, barberPos.z, Config.SafeZones[safeZoneId].traders.barber.markerlabel, 7, 0.1, 0.25)
                    end
                    DrawMarker(1, barberPos.x, barberPos.y, barberPos.z-1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 0, 255, 0, 255, true, false, 2, false, nil, nil, false)
                end
                if dist <= 3 then
                    inBarber = true
                elseif dist > 3 then
                    inBarber = false
                end
            end

            if Config.SafeZones[safeZoneId].traders.clothes then
                local clothesPos = Config.SafeZones[safeZoneId].traders.clothes.position
                local dist = #(pedCoords - clothesPos)
                if dist <= 15 then
                    --TODO: Make UI for buying stuff? Or use inventory shop system
                    if Config.SafeZones[safeZoneId].traders.clothes.markerlabel then
                        Draw3DText(clothesPos.x, clothesPos.y, clothesPos.z, Config.SafeZones[safeZoneId].traders.clothes.markerlabel, 7, 0.1, 0.25)
                    end
                    DrawMarker(1, clothesPos.x, clothesPos.y, clothesPos.z-1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 0, 255, 0, 255, true, false, 2, false, nil, nil, false)
                end
                if dist <= 3 then
                    inClothes = true
                elseif dist > 3 then
                    inClothes = false
                end
            end
        end

        if inZone and not zoneTriggered then
            --Set player as invincible
            SetPlayerInvincible(PlayerId(), true)
            --Disable PvP
            SetCanAttackFriendly(GetPlayerPed(-1), false, false)
            NetworkSetFriendlyFireOption(false)
            zoneTriggered = true
            TriggerEvent("fivez:AddNotification", "Entering "..safeZoneId)
            Citizen.Wait(1000)
        elseif not inZone and zoneTriggered then
            --Disable invinciblity
            SetPlayerInvincible(PlayerId(), false)
            --Enable PvP
            SetCanAttackFriendly(GetPlayerPed(-1), true, false)
            NetworkSetFriendlyFireOption(true)
            --Enable punching
            DisablePlayerFiring(PlayerId(), false)
            DisableControlAction(0, 25, false)
            DisableControlAction(0, 106, false)
            DisableControlAction(0, 140, false)
            DisableControlAction(0, 141, false)
            DisableControlAction(0, 142, false)
            DisableControlAction(0, 263, false)
            DisableControlAction(0, 264, false)
            zoneTriggered = false
            TriggerEvent("fivez:AddNotification", "Leaving "..safeZoneId)
            safeZoneId = nil
            Citizen.Wait(1000)
        end
        Citizen.Wait(1)
    end
end)

Citizen.CreateThread(function()
    while true do
        if inBarber then
            if IsControlJustReleased(0, 191) then
                --Trigger fivem appearance
                exports["fivem-appearance"]:startPlayerCustomization(function(appearanceData)
                    if appearanceData then
                        
                    end
                end, {ped = false, headBlend = false, faceFeatures = false, headOverlays = false, components = false, props = false, tattoos = false})
            end
        elseif inClothes then
            if IsControlJustReleased(0, 191) then
                --Trigger fivem appearance
                exports["fivem-appearance"]:startPlayerCustomization(function(appearanceData)
                    if appearanceData then

                    end
                end, {ped = false, headBlend = false, faceFeatures = false, headOverlays = false, components = true, props = true, tattoos = false})
            end
        else
            Citizen.Wait(1500)
        end
        Citizen.Wait(1)
    end
end)