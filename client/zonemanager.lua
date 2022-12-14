local inZone = false
local zoneTriggered = false
local safeZoneId = nil

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
        if dist < 50 and inZone == false then
            inZone = true
            safeZoneId = tempZoneId
        elseif dist > 50 and inZone == true then
            inZone = false
            safeZoneId = nil
        end
        --If we are far away increase wait time since it'll take the player some time to get in range anyway 
        if dist >= 75 and dist <= 149 then
            Citizen.Wait(5000)
        elseif dist >= 150 and dist <= 199 then
            Citizen.Wait(10000)
        elseif dist >= 200 then
            Citizen.Wait(20000)
        end
        Citizen.Wait(1500)
    end
end)

local traderId = nil
local inBarber = false
local inClothes = false

Citizen.CreateThread(function()
    while true do
        while not startThreads do Citizen.Wait(1) end
        if inZone and zoneTriggered then
            DisablePlayerFiring(PlayerId(), true)
            DisableControlAction(0, 25, true)
            DisableControlAction(0, 106, true)
            DisableControlAction(0, 140, true)
            DisableControlAction(0, 141, true)
            DisableControlAction(0, 142, true)
            DisableControlAction(0, 263, true)
            DisableControlAction(0, 264, true)
            if IsDisabledControlJustPressed(0, 25) or IsDisabledControlJustPressed(0, 106) or IsDisabledControlJustPressed(0, 140) or IsDisabledControlJustPressed(0, 141) or IsDisabledControlJustPressed(0, 142) or IsDisabledControlJustPressed(0, 263) or IsDisabledControlJustPressed(0, 264) then
                TriggerEvent("fivez:AddNotification", "You cannot fire/punch in safe zone!")
            end
            local pedCoords = GetEntityCoords(GetPlayerPed(-1))
            if Config.SafeZones[safeZoneId].traders.barber then
                local barberPos = Config.SafeZones[safeZoneId].traders.barber.position
                local dist = #(pedCoords - barberPos)
                if dist <= 15 then
                    if Config.SafeZones[safeZoneId].traders.barber.markerlabel then
                        Draw3DText(barberPos.x, barberPos.y, barberPos.z, Config.SafeZones[safeZoneId].traders.barber.markerlabel, 1, 0.5, 0.5)
                    end
                    DrawMarker(1, barberPos.x, barberPos.y, barberPos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 0, 255, 0, 255, true, false, 2, false, nil, nil, false)
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
                        Draw3DText(clothesPos.x, clothesPos.y, clothesPos.z, Config.SafeZones[safeZoneId].traders.clothes.markerlabel, 1, 0.5, 0.5)
                    end
                    DrawMarker(1, clothesPos.x, clothesPos.y, clothesPos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 0, 255, 0, 255, true, false, 2, false, nil, nil, false)
                end
                if dist <= 3 then
                    inClothes = true
                elseif dist > 3 then
                    inClothes = false
                end
            end
        elseif not inZone and not zoneTriggered then
            DisablePlayerFiring(PlayerId(), false)
        end
        if inZone and not zoneTriggered then
            --Set player as invincible
            SetPlayerInvincible(PlayerId(), true)
            --Disable PvP
            SetCanAttackFriendly(GetPlayerPed(-1), false, false)
            NetworkSetFriendlyFireOption(false)
            zoneTriggered = true
            TriggerEvent("fivez:AddNotification", "Entering The Last Hold")
            Citizen.Wait(1000)
        elseif not inZone and zoneTriggered then
            --Disable invinciblity
            SetPlayerInvincible(PlayerId(), false)
            --Enable PvP
            SetCanAttackFriendly(GetPlayerPed(-1), true, false)
            NetworkSetFriendlyFireOption(true)
            --Enable punching
            DisableControlAction(0, 25, false)
            DisableControlAction(0, 106, false)
            DisableControlAction(0, 140, false)
            DisableControlAction(0, 141, false)
            DisableControlAction(0, 142, false)
            DisableControlAction(0, 263, false)
            DisableControlAction(0, 264, false)
            zoneTriggered = false
            TriggerEvent("fivez:AddNotification", "Leaving The Last Hold")
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
                exports["fivem-appearance"]:startPlayerCustomization(function()
                
                end, {ped = false, headBlend = false, faceFeatures = false, headOverlays = false, components = false, props = false, tattoos = false})
            end
        elseif inClothes then
            if IsControlJustReleased(0, 191) then
                --Trigger fivem appearance
            end
        else
            Citizen.Wait(1500)
        end
        Citizen.Wait(1)
    end
end)