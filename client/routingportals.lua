local insideRoutingInterior = false

local usedRoutingId = nil
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
                        DrawMarker(1, portal.x, portal.y, portal.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 0, 255, 0, 255, false, false, 2, false, nil, nil, false)
                    end

                    --Check for inputs if we are close enough
                    if distance <= 3 then
                        Draw3DText(portal.x, portal.y, portal.z, "[ENTER]", 7, 0.1, 0.25)
                        if IsControlJustPressed(0, 191) then
                            usedInteriorId = tempInteriorId
                            usedRoutingId = tempRoutingId
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

        if usedRoutingId ~= nil then
            local playerPos = GetEntityCoords(GetPlayerPed(-1))
            local outPos = Config.RoutingInteriors[usedRoutingId].outPosition
            local distance = #(playerPos - outPos)
            if distance <= 15 then
                DrawMarker(1, outPos.x, outPos.y, outPos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 0, 255, 0, 255, false, false, 2, false, nil, nil, false)
            end

            if distance <= 3 then
                Draw3DText(outPos.x, outPos.y, outPos.z, "[ENTER]", 7, 0.1, 0.25)
                if IsControlJustPressed(0, 191) then
                    ClearInventoryMarkers()
                    TriggerServerEvent("fivez:ExitRoutingPortal", usedRoutingId, usedInteriorId, usedPortalId)
                    usedInteriorId = nil
                    usedRoutingId = nil
                    usedPortalid = nil
                    insideRoutingInterior = false
                    Citizen.Wait(500)
                end
            end
        end
        
        Citizen.Wait(1)
    end
end)

--Thread for shwoing lootable areas when in routing interior
Citizen.CreateThread(function()
    while true do
        while not startThreads do Citizen.Wait(1) end
        while not NetworkIsPlayerActive(PlayerId()) do Citizen.Wait(1) end
        while not insideRoutingInterior do Citizen.Wait(1) end
        
        if usedRoutingId ~= nil then
            for k,v in pairs(Config.RoutingInteriors[usedRoutingId].lootableAreas) do
                local distance = #(GetEntityCoords(GetPlayerPed(-1)) - v.position)
                if distance <= 15 then
                    DrawMarker(1, v.position.x, v.position.y, v.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 0, 255, 0, 255, true, false, 2, false, nil, nil, false)
                end

                if distance <= 3 then
                    Draw3DText(v.position.x, v.position.y, v.position.z, "[Lootable Area]", 7, 0.1, 0.25)
                end
            end
        end
        Citizen.Wait(1)
    end
end)

RegisterCommand("getinteriorname", function()
    local pedCoords = GetEntityCoords(GetPlayerPed(-1))
    local interiorId = GetInteriorAtCoords(pedCoords.x, pedCoords.y, pedCoords.z)

    if interiorId > 0 then
        local intPos, intHash = GetInteriorLocationAndNamehash(interiorId)
        print("Interior info", intPos, intHash)
    else
        print("Not in a interior")
    end
end)