local activeInteriors = {}

function GetActiveRoutingInterior(routingId)

end

function GetActiveInterior(interiorId)
    for k,v in pairs(activeInteriors) do
        if v.interiorId == interiorId then
            return v
        end
    end

    return nil
end

--Looks for the lowest routing bucket number it could have, then the highest if 1 is already taken
function GetRoutingBucket()
    local disallowedNums = {}
    for k,v in pairs(activeInteriors) do
        table.insert(disallowedNums, v.routingBucket)
    end

    local lowestNum = -1
    for k,v in pairs(disallowedNums) do
        if lowestNum == -1 or v < lowestNum then
            lowestNum = v
        end
    end

    if lowestNum ~= -1 then
        --If the lowest number is 1 then get the highest number
        if lowestNum == 1 then
            local highestNum = -1
            for k,v in pairs(disallowedNums) do
                if highestNum == -1 or v > highestNum then
                    highestNum = v
                end
            end
            if highestNum ~= -1 then
                return highestNum + 1
            end
        elseif lowestNum > 1 then
            return lowestNum - 1
        end
    else
        return 1
    end
end

function AddActiveInterior(routingId, interiorId, source)
    local routingBucket = GetRoutingBucket()
    table.insert(activeInteriors, {
        routingId = routingId,
        interiorId = interiorId,
        routingBucket = routingBucket,
        players = {
            source
        }
    })
    SetPlayerRoutingBucket(source, routingBucket)
end

function AddPlayerToActiveInterior(interiorId, source)
    for k,v in pairs(activeInteriors) do
        if v.interiorId == interiorId then
            SetPlayerRoutingBucket(source, v.routingBucket)
            table.insert(v.players, source)
        end
    end
end

function RemovePlayerFromActiveInterior(interiorId, source)
    for k,v in pairs(activeInteriors) do
        if v.interiorId == interiorId then
            local activeInteriorId = k
            for k,v in pairs(v.players) do
                if v == source then
                    SetPlayerRoutingBucket(source, 0)
                    table.remove(activeInteriors[activeInteriorId].players, k)
                end
            end
        end
    end
end

RegisterNetEvent("fivez:EnterRoutingPortal", function(routingId, interiorId, portalId)
    local source = source
    local playerPed = GetPlayerPed(source)
    local routingPortal = Config.RoutingInteriors[routingId].inPositions[interiorId][portalId]
    if #(GetEntityCoords(playerPed) - routingPortal) <= 3 then
        local activeInterior = GetActiveInterior(interiorId)
        if activeInterior ~= nil then
            AddPlayerToActiveInterior(interiorId, source)
        else
            AddActiveInterior(routingId, interiorId, source)
        end
        local exitPortal = Config.RoutingInteriors[routingId].outPosition
        SetEntityCoords(GetPlayerPed(source), exitPortal.x, exitPortal.y, exitPortal.z, true, false, false, false)
    else
        print(routingPortal," - Not close enough to routing portal!", routingId, interiorId, portalId)
    end
end)

RegisterNetEvent("fivez:ExitRoutingPortal", function(routingId, interiorId, portalId)
    local source = source

    local routingPortal = Config.RoutingInteriors[routingId].outPosition
    if routingPortal then
        RemovePlayerFromActiveInterior(interiorId, source)

        local entryPortal = Config.RoutingInteriors[routingId].inPosition[interiorId][portalId]
        SetEntityCoords(GetPlayerPed(-1), entryPortal.x, entryPortal.y, entryPortal.z, true, false, false, false)
    else
        print(routingPortal, " - Routing Portal doesn't exist!", routingId)
    end
end)

--Thread to clean up the active interiors table when nobody is inside the interior
Citizen.CreateThread(function()
    while true do
        for k,v in pairs(activeInteriors) do
            if #v.players == 0 then
                table.remove(activeInteriors, k)
            end
        end
        --Wait 30 seconds between checks
        Citizen.Wait(30000)
    end
end)