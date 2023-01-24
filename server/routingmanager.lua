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

RegisterCommand("getroutingbucket", function(source, args)
    local target = source
    if args[1] ~= nil then
        target = args[1]
    end
    TriggerClientEvent("fivez:AddNotification", source, "Routing Bucket of player is: "..GetPlayerRoutingBucket(tonumber(target)))
end, true)

RegisterCommand("setroutingbucket", function(source, args)
    local target = tonumber(args[1])
    local destRouting = tonumber(args[2])
    SetPlayerRoutingBucket(target, destRouting)
end, true)

RegisterCommand("fakeinteriorplayer", function(source, args)
    local routingId = args[1]
    local interiorId = args[2]
    AddActiveInterior(tonumber(routingId), interiorId, -2)
end, true)

RegisterCommand("cis", function(source)
    local infoString = ""
    for k,v in pairs(activeInteriors) do
        local interiorId = k
        for k,v in pairs(v.players) do
            if v == source then
                infoString = activeInteriors[k].routingId.." - "..activeInteriors[k].interiorId.." - "..activeInteriors[k].routingBucket.." - "..#activeInteriors[k].players
            end
        end
    end
    TriggerClientEvent("fivez:AddAnnouncement", source, infoString)
end, true)

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
    if source ~= -2 then
        --Set the player going into the interior to the routing bucket
        SetPlayerRoutingBucket(source, routingBucket)
    end
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

                    --If the last person in the interior left, remove it from active interiors
                    if #activeInteriors[activeInteriorId].players <= 0 then
                        --TODO: Add removal of all registered inventories linking to this interior
                        DeleteRegisteredInventory("routinginterior:"..activeInteriors[activeInteriorId].routingBucket..":"..activeInteriorId)
                        DeleteAllGroundInventoriesWithBucket(activeInteriors[activeInteriorId].routingBucket)
                        table.remove(activeInteriors, activeInteriorId)
                    end
                    return true
                end
            end
        end
    end

    return false
end

function CalculateLootableAreaItems(routingId, lootableAreaId)
    if Config.RoutingInteriors[routingId] then
        if Config.RoutingInteriors[routingId].lootableAreas[lootableAreaId] then
            local inventoryItems = InventoryFillEmpty(30)
            local weight = 0
            local lootAreaInfo = Config.RoutingInteriors[routingId].lootableAreas[lootableAreaId]
            if Config.LootGrades[lootAreaInfo.lootGrade] then
                local potentialItems = {}
                for k,v in pairs(Config.LootGrades[lootAreaInfo.lootGrade]) do
                    local itemModel = v
                    for k,v in pairs(Config.ItemsWithoutFunctions()) do
                        if v.model == itemModel then
                            local itemData = v
                            itemData.count = 1
                            table.insert(potentialItems, itemData)
                        end
                    end
                end

                if #potentialItems >= 1 then
                    for k,v in pairs(potentialItems) do
                        local spawnChance = math.random(0, 100)
                        if spawnChance >= 50 then
                            print("Spawning", v.model)
                            local potentialItem = v
                            for k,v in pairs(inventoryItems) do
                                if v.itemId == -1 then
                                    weight = weight + potentialItem.weight

                                    inventoryItems[k] = potentialItem
                                    break
                                end
                            end
                        end
                        table.remove(potentialItems, k)
                    end

                    return weight, inventoryItems
                end
            end
        end
    end
end

RegisterNetEvent("fivez:EnterRoutingPortal", function(routingId, interiorId, portalId)
    local source = source
    local playerPed = GetPlayerPed(source)
    if GetVehiclePedIsIn(playerPed, false) > 0 then TriggerClientEvent("fivez:AddNotification", source, "Cannot enter interior when inside a vehicle!") return end
    local routingPortal = Config.RoutingInteriors[routingId].inPositions[interiorId][portalId]
    --Make sure player is close enough to portal to use it
    if #(GetEntityCoords(playerPed) - routingPortal) <= 3 then
        --Get any active interiors with the same interiorId
        local activeInterior = GetActiveInterior(interiorId)
        --Found an active interior and the routing interior is NOT unique
        if activeInterior ~= nil and not Config.RoutingInteriors[routingId].isUnique then
            --If we find an active interior that is available add player to it
            AddPlayerToActiveInterior(interiorId, source)
        elseif activeInterior == nil or Config.RoutingInteriors[routingId].isUnique then
            --If we didn't find an active interior or the routing interior IS unique, create one for the player
            AddActiveInterior(routingId, interiorId, source)

            for k,v in pairs(Config.RoutingInteriors[routingId].lootableAreas) do
                local weight, items = CalculateLootableAreaItems(routingId, k)

                local inventory = RegisterNewInventory("routinginterior:"..GetPlayerRoutingBucket(source)..":"..interiorId, "inventory", "Lootable Area", weight, v.maxWeight, v.maxSlots, items, v.position, GetPlayerRoutingBucket(source))
            end
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
    if GetVehiclePedIsIn(GetPlayerPed(source), false) > 0 then TriggerClientEvent("fivez:AddNotification", source, "Cannot enter interior when inside a vehicle!") return end
    local routingPortal = Config.RoutingInteriors[routingId].outPosition
    if routingPortal then
        local removed = RemovePlayerFromActiveInterior(interiorId, source)

        if removed then
            local entryPortal = Config.RoutingInteriors[routingId].inPositions[interiorId][portalId]
            SetEntityCoords(GetPlayerPed(source), entryPortal.x, entryPortal.y, entryPortal.z, true, false, false, false)
        else
            TriggerClientEvent("fivez:AddNotification", source, "Error removing you from the active interiors, contact staff")
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