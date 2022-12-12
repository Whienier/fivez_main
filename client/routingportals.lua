local insideRoutingInterior = false

local usedInteriorId = nil
local usedPortalId = nil

--Thread for showing in portals
Citizen.CreateThread(function()
    while true do
        while not startThreads do Citizen.Wait(1) end
        while not NetworkIsPlayerActive(PlayerId()) do Citizen.Wait(1) end

        --If we are inside a routing interior then wait till we get out
        while insideRoutingInterior do Citizen.Wait(1) end

        local tempRoutingId = nil
        local tempInteriorId = nil
        --Loop through routing interiors and check which is the closest
        for k,v in pairs(Config.RoutingInteriors) do
            tempRoutingId = k
            for k,house in pairs(v.inPositions) do
                tempInteriorId = k
                for k,portal in pairs(house) do
                    local distance = #(GetEntityCoords(GetPlayerPed(-1)) - portal)

                    if distance <= 15 then
                        DrawMarker(1, portal.x, portal.y, portal.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 0, 255, 0, 255, true, false, 2, false, nil, nil, false)
                    end

                    --Check for inputs if we are close enough
                    if distance <= 3 then
                        if IsControlJustPressed(0, 191) then
                            usedInteriorId = tempInteriorId
                            usedPortalId = k
                            TriggerServerEvent("fivez:EnterRoutingPortal", tempRoutingId, tempInteriorId, k)
                            insideRoutingInterior = true
                            Citizen.Wait(500)
                        end
                    end
                end
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
        --If we are not inside a routing interior wait until we are inside one
        while not insideRoutingInterior do Citizen.Wait(1) end

        for k,v in pairs(Config.RoutingInteriors) do
            local distance = #(GetEntityCoords(GetPlayerPed(-1)) - v.outPosition)
            if distance <= 15 then
                DrawMarker(1, v.outPosition.x, v.outPosition.y, v.outPosition.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 0, 255, 0, 255, true, false, 2, false, nil, nil, false)
            end

            if distance <= 3 then
                if IsControlJustPressed(0, 191) then
                    TriggerServerEvent("fivez:ExitRoutingPortal", k, usedInteriorId, usedPortalId)
                    usedInteriorId = nil
                    usedPortalid = nil
                    insideRoutingInterior = false
                    Citizen.Wait(500)
                end
            end
        end
        
        Citizen.Wait(1)
    end
end)

RegisterCommand("getinteriorname", function()
    local pedCoords = GetPlayerPed(-1)
    local interiorId = GetInteriorAtCoords(pedCoords.x, pedCoords.y, pedCoords.z)

    if interiorId > 0 then
        print("Interior info", GetInteriorLocationAndNamehash(interiorId))
    else
        print("Not in a interior")
    end
end)