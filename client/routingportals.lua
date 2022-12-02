local insideRoutingInterior = false
local insideEntryMarker = false

local usedInteriorId = nil
local usedPortalId = nil

--Thread for showing in portals
Citizen.CreateThread(function()
    while true do
        while not startThreads do Citizen.Wait(1) end
        while not NetworkIsPlayerActive(PlayerId()) do Citizen.Wait(1) end

        --If we are inside a routing interior
        while insideRoutingInterior do Citizen.Wait(1) end

        local pedCoords = GetEntityCoords(GetPlayerPed(-1))
        local dist = -1
        local tempRoutingId = nil
        local tempInteriorId = nil
        local tempPortalId = nil
        for k,v in pairs(Config.RoutingInteriors) do
            tempRoutingId = k
            for k,house in pairs(v.inPositions) do
                tempInteriorId = k
                for k,portalPos in pairs(house) do
                    local distance = #(pedCoords - portalPos)

                    if dist == -1 or distance < dist then
                        dist = distance
                        tempPortalId = k
                    end
                end
            end
        end

        if dist <= 15 then
            DrawMarker(1, v.traders.barber.x, v.traders.barber.y, v.traders.barber.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 0, 255, 0, 255, true, false, 2, false, nil, nil, false)
        end

        if dist <= 3 then
            if IsControlJustPressed(0, 191) then
                usedInteriorId = tempInteriorId
                usedPortalId = tempPortalId
                TriggerServerEvent("fivez:EnterRoutingPortal", tempRoutingId, tempInteriorId, tempPortalId)
            end
        end
        Citizen.Wait(1)
    end
end)

--Thread for showing out portals
Citizen.CreateThread(function()
    while true do
        while not startThreads do Citizen.Wait(1) end
        while not NetworkIsPlayerActive(PlayerId()) do Citizen.Wait(1) end
        --If we are not inside a routing interior
        while not insideRoutingInterior do Citizen.Wait(1) end

        local pedCoords = GetEntityCoords(GetPlayerPed(-1))
        local dist = -1
        local closestCoords = nil
        local tempRoutingId = nil

        for k,v in pairs(Config.RoutingInteriors) do
            local distance = #(pedCoords - v)
            if dist == -1 or distance < dist then
                closestCoords = v
                dist = distance
                tempRoutingId = k
            end
        end

        if dist ~= -1 then
            if dist <= 15 then
                DrawMarker(1, closestCoords.x, closestCoords.y, closestCoords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 0, 255, 0, 255, true, false, 2, false, nil, nil, false)
            end

            if dist <= 3 then
                if IsControlJustPressed(0, 191) then
                    TriggerServerEvent("fivez:ExitRoutingPortal", tempRoutingId, usedInteriorId, usedPortalId)
                    usedInteriorId = nil
                    usedPortalid = nil
                end
            end
        end
        Citizen.Wait(1)
    end
end)