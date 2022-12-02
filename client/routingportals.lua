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
        local tempPortalId = nil
        --Loop through routing interiors and check which is the closest
        for k,v in pairs(Config.RoutingInteriors) do
            tempRoutingId = k
            for k,house in pairs(v.inPositions) do
                tempInteriorId = k
                for k,portals in pairs(house) do
                    print(portals)
                    for i=0,i<#portals do
                        local distance = #(GetEntityCoords(GetPlayerPed(-1)) - portals[i])

                        if distance <= 15 then
                            DrawMarker(1, portals[i].x, portals[i].y, portals[i].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 0, 255, 0, 255, true, false, 2, false, nil, nil, false)
                            tempPortalId = i
                        end
    
                        --Check for inputs if we are close enough
                        if distance <= 3 then
                            if IsControlJustPressed(0, 191) then
                                usedInteriorId = tempInteriorId
                                usedPortalId = tempPortalId
                                TriggerServerEvent("fivez:EnterRoutingPortal", tempRoutingId, tempInteriorId, tempPortalId)
                                insideRoutingInterior = true
                            end
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

        local dist = -1
        local closestCoords = nil
        local tempRoutingId = nil

        for k,v in pairs(Config.RoutingInteriors) do
            local distance = #(GetEntityCoords(GetPlayerPed(-1)) - v.outPosition)
            if dist == -1 or distance < dist then
                closestCoords = v.outPosition
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
                    insideRoutingInterior = false
                end
            end
        end
        Citizen.Wait(1)
    end
end)