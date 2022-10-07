local inZone = false
local outZone = false
local interior = -1
local portalId = -1

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        while not startThreads do Citizen.Wait(1) end
        local pedCoords = GetEntityCoords(GetPlayerPed(-1))
        for interiorId,portal in pairs(Config.InteriorPortals) do
            for k,v in pairs(portal.inPos) do
                if #(pedCoords - v) <= 2.5 then
                    inZone = true
                    interior = interiorId
                    portalId = k
                    --Skip past looking for out pos and inZone = false
                    goto skip
                end
            end
        end
        --If we complete the loop without being close to a zone
        inZone = false
        --Skip past inZone = false if they are in a zone
        ::skip::
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        while not startThreads do Citizen.Wait(1) end
        local pedCoords = GetEntityCoords(GetPlayerPed(-1))
        for interiorId, portal in pairs(Config.InteriorPortals) do
            for k,v in pairs(portal.outPos) do
                outZone = true
                interior = interiorId
                portalId = k
                goto skip
            end
        end
        outZone = false
        ::skip::
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        while not startThreads do Citizen.Wait(1) end
        if inZone or outZone then
            if inZone and IsControlJustReleased(0, 176) then
                local coords = Config.InteriorPortals[interior].outPos[portalId]
                if coords then
                    SetEntityCoords(GetPlayerPed(-1), coords.x, coords.y, coords.z, true, false, false, false)
                    inZone = false
                    outZone = false
                    interior = -1
                    portalId = -1
                end
            elseif outZone and IsControlJustReleased(0, 176) then
                local coords = Config.InteriorPortals[interior].inPos[portalId]
                if coords then
                    SetEntityCoords(GetPlayerPed(-1), coords.x, coords.y, coords.z, true, false, false, false)
                    inZone = false
                    outZone = false
                    interior = -1
                    portalId = -1
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        while not startThreads do Citizen.Wait(1) end
        for k,v in pairs(Config.InteriorPortals) do
            local coords = GetEntityCoords(GetPlayerPed(-1))
            for k,v in pairs(v.inPos) do
                if #(coords - v) <= 15 then
                    DrawMarker(1, v.x, v.y, v.z, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 255, 255, 255, 255, false, true, 2, true, NULL, NULL, false)
                end
            end

            for k,v in pairs(v.outPos) do
                if #(coords - v) <= 15 then
                    DrawMarker(1, v.x, v.y, v.z, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 255, 255, 255, 255, false, true, 2, true, NULL, NULL, false)
                end
            end
        end
    end
end)