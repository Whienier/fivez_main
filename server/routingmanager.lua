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
    --Disable client-side entity creation
    SetRoutingBucketEntityLockdownMode(routingBucket, "strict")
    SetRoutingBucketPopulationEnabled(routingBucket, false)
    --Set the player going into the interior to the routing bucket
    SetPlayerRoutingBucket(source, routingBucket)
end

function AddPlayerToActiveInterior(interiorId, source)
    for k,v in pairs(activeInteriors) do
        if v.interiorId == interiorId then
            --Set player to the active interiors routing bucket
            SetPlayerRoutingBucket(source, v.routingBucket)
            --Also insert them into the players table
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
                    --Set player to default routing bucket
                    SetPlayerRoutingBucket(source, 0)
                    --Remove player from the players table
                    table.remove(activeInteriors[activeInteriorId].players, k)

                    return true
                end
            end
        end
    end

    return false
end

RegisterNetEvent("fivez:EnterRoutingPortal", function(routingId, interiorId, portalId)
    local source = source
    local playerPed = GetPlayerPed(source)
    local routingPortal = Config.RoutingInteriors[routingId].inPositions[interiorId][portalId]
    --Make sure player is close enough to portal to use it
    if #(GetEntityCoords(playerPed) - routingPortal) <= 3 then
        --Get any active interiors with the same interiorId
        local activeInterior = GetActiveInterior(interiorId)
        if activeInterior ~= nil then
            --If we find an active interior that is available add player to it
            AddPlayerToActiveInterior(interiorId, source)
        else
            --If we didn't find an active interior, create one for the player
            AddActiveInterior(routingId, interiorId, source)
        end
        --Get the location of the exit portal
        local exitPortal = Config.RoutingInteriors[routingId].outPosition
        --Set player ped coords to the exit portal
        SetEntityCoords(GetPlayerPed(source), exitPortal.x, exitPortal.y, exitPortal.z, true, false, false, false)
    else
        print(routingPortal," - Not close enough to routing portal!", routingId, interiorId, portalId)
    end
end)

RegisterNetEvent("fivez:ExitRoutingPortal", function(routingId, interiorId, portalId)
    local source = source

    local routingPortal = Config.RoutingInteriors[routingId].outPosition
    if routingPortal then
        local removed = RemovePlayerFromActiveInterior(interiorId, source)

        if removed then
            local entryPortal = Config.RoutingInteriors[routingId].inPositions[interiorId][portalId]
            SetEntityCoords(GetPlayerPed(source), entryPortal.x, entryPortal.y, entryPortal.z, true, false, false, false)
        else
            print(source, GetPlayerIdentifier(source, 3), "Player didn't exist in an active interior")
        end
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