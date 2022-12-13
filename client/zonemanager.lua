local inZone = false
local zoneTriggered = false
local safeZoneId = nil

Citizen.CreateThread(function()
    while true do
        while not startThreads do Citizen.Wait(1) end

        local pedCoords = GetPlayerPed(-1)
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
        Citizen.Wait(1)
    end
end)

local traderId = nil
local inBarber = false
local inClothes = false

local healthOnEnter = 0

Citizen.CreateThread(function()
    while true do
        while not startThreads do Citizen.Wait(1) end
        if inZone and zoneTriggered then
            if healthOnEnter > 0 then
                SetEntityHealth(GetPlayerPed(-1), healthOnEnter)
            end
            DisablePlayerFiring(PlayerId(), true)
            DisableControlAction(0, 106, true)
            if IsDisabledControlJustPressed(0, 106) then
                TriggerEvent("fivez:AddNotification", "You cannot fire/punch in safe zone!")
            end
            local pedCoords = GetEntityCoords(GetPlayerPed(-1))
            if Config.SafeZones[safeZoneId].traders.barber then
                local dist = #(pedCoords - v.traders.barber)
                if dist <= 15 then
                    DrawMarker(1, v.traders.barber.x, v.traders.barber.y, v.traders.barber.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 0, 255, 0, 255, true, false, 2, false, nil, nil, false)
                end
                if dist <= 3 then
                    inBarber = true
                elseif dist > 3 then
                    inBarber = false
                end
            end

            if Config.SafeZones[safeZoneId].traders.clothes then
                local dist = #(pedCoords - v.traders.clothes)
                if dist <= 15 then
                    DrawMarker(1, v.traders.clothes.x, v.traders.clothes.y, v.traders.clothes.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 0, 255, 0, 255, true, false, 2, false, nil, nil, false)
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
            healthOnEnter = GetEntityHealth(GetPlayerPed(-1))
            zoneTriggered = true
            TriggerEvent("fivez:AddNotification", "Entering The Last Hold")
            NetworkSetFriendlyFireOption(false)
            Citizen.Wait(1000)
        elseif not inZone and zoneTriggered then
            healthOnEnter = 0
            zoneTriggered = false
            TriggerEvent("fivez:AddNotification", "Leaving The Last Hold")
            NetworkSetFriendlyFireOption(true)
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