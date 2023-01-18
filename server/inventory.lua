local RegisteredInventories = {}
local openInventories = {}
local inventoryMarkers = {}

--Adds inventory marker to table, client asks for this info
function AddInventoryMarker(coords)
    table.insert(inventoryMarkers, {position = coords, created = GetGameTimer()})
end

RegisterNetEvent("fivez:SyncMarkers", function()
    local source = source
    local pedCoords = GetEntityCoords(GetPlayerPed(-1))
    local markersToSend = {}
    for k,v in pairs(inventoryMarkers) do
        local sameRoutingBucket = false
        if v.routingBucket then
            if v.routingBucket == GetPlayerRoutingBucket(source) then
                sameRoutingBucket = true
            end
        end
        if #(v.position - pedCoords) <= Config.InventoryMarkersSyncDistance and sameRoutingBucket then
            table.insert(markersToSend, v.position)
        end
    end
    TriggerClientEvent("fivez:SyncMarkersCB", source, json.encode(markersToSend))
end)

function GetAllInventoryMarkers()
    return inventoryMarkers
end

Citizen.CreateThread(function()
    while true do
        if #inventoryMarkers >= 1 then
            for k,v in pairs(inventoryMarkers) do
                if (GetGameTimer() - v.created) > Config.DeleteInventoryMarkerTime then
                    --TriggerClientEvent("fivez:RemoveGroundMarker", -1, json.encode(v.position))
                    table.remove(inventoryMarkers, k)
                end
            end
        end
        Citizen.Wait(30000)
    end
end)

RegisteredInventories["itemmenu:1"] = {
    type = "inventory",
    identifier = "itemmenu:1",
    label = "Admin Item Menu",
    weight = -1,
    maxWeight = -1,
    maxSlots = #Config.Items,
    items = Config.ItemsWithoutFunctions()
}
for k,v in pairs(RegisteredInventories["itemmenu:1"].items) do
    v.count = v.maxcount
    v.weight = v.weight * v.count
end

RegisterCommand("oim", function(source)
    local source = source

    if openInventories["itemmenu:1"] then
        table.insert(openInventories["itemmenu:1"], tostring(source))
    elseif openInventories["itemmenu:1"] == nil then
        openInventories["itemmenu:1"] = {tostring(source)}
    end

    TriggerClientEvent("fivez:OpenItemMenu", source, json.encode(RegisteredInventories["itemmenu:1"]))
end, true)

local TempInventories = {}

function GetInventoryWithId(invId)
    --If the inventory is not registered check if it's a temp inventory to create permentently
    if not RegisteredInventories[invId] then
        --Check spawned vehicles
        for k,v in pairs(spawnedVehicles) do
            if v.glovebox then
                if v.glovebox.identifier == invId then
                    return v.glovebox
                end
            else
                print("Glovebox inventory didn't exist", invId)
            end

            if v.trunk then
                if v.trunk.identifier == invId then
                    return v.trunk
                end
            else
                print("Trunk inventory didn't exist", invId)
            end
        end
        --If the inventory is a temp inventory
        if TempInventories[invId] then
            --Swap over temp inventory to a registered inventorty and set the temp inventory to nil
            RegisteredInventories[invId] = TempInventories[invId]
            TempInventories[invId] = nil
        end
    end
    return RegisteredInventories[invId]
end

function GetClosestInventory(pedCoords, plyRoutingBucket)
    if plyRoutingBucket == 0 then
        for k,v in pairs(RegisteredInventories) do
            if v.position then
                if #(pedCoords - v.position) <= Config.OpenInventoryDistance then
                    return v
                end
            end
        end
        for k,v in pairs(TempInventories) do
            if v.position then
                if #(pedCoords - v.position) <= Config.OpenInventoryDistance then
                    return v
                end
            end
        end
    elseif plyRoutingBucket > 0 then
        for k,v in pairs(RegisteredInventories) do
            if v.position and v.routingBucket then
                if plyRoutingBucket == v.routingBucket and #(pedCoords - v.position) <= Config.OpenInventoryDistance then
                    return v
                end
            end
        end
        for k,v in pairs(TempInventories) do
            if v.position and v.routingBucket then
                if plyRoutingBucket == v.routingBucket and #(pedCoords - v.position) <= Config.OpenInventoryDistance then
                    return v
                end
            end
        end
    end
    return nil
end

function CreateTempGroundInventory(pedCoords, routingBucket)
    local tempId = #RegisteredInventories + 1
    tempId = "ground:"..tempId

    local items = InventoryFillEmpty(Config.DefaultMaxSlots)

    TempInventories[tempId] = {
        type = "inventory",
        identifier = tempId,
        label = "Ground",
        weight = 0,
        maxWeight = Config.DefaultMaxWeight,
        maxSlots = Config.DefaultMaxSlots,
        position = pedCoords,
        items = items,
        routingBucket = routingBucket or 0
    }

    return TempInventories[tempId]
end

function RegisterNewInventory(id, type, label, weight, maxweight, maxslots, items, position, routingBucket)
    if RegisteredInventories[id] then return RegisteredInventories[id] end
    RegisteredInventories[id] = {
        type = type or "inventory",
        identifier = id,
        label = label,
        weight = weight or 0,
        maxWeight = maxweight,
        maxSlots = maxslots,
        items = items,
        position = position,
        routingBucket = routingBucket or 0
    }

    return RegisteredInventories[id]
end

function DeleteRegisteredInventory(id)
    if RegisteredInventories[id] then
        RegisteredInventories[id] = nil
    end
end

function DeleteAllGroundInventoriesWithBucket(routingBucket)
    for k,v in pairs(RegisteredInventories) do
        if v.routingBucket == routingBucket then
            RegisteredInventories[k] = nil
        end
    end

    for k,v in pairs(TempInventories) do
        if v.routingBucket == routingBucket then
            TempInventories[k] = nil
        end
    end
end

RegisterNetEvent("fivez:PackBike", function(bikeEntity)
    local source = source
    local bike = NetworkGetEntityFromNetworkId(bikeEntity)
    if bike then
        local plyCoords = GetEntityCoords(GetPlayerPed(source))
        local bikeCoords = GetEntityCoords(bike)
        if #(bikeCoords - plyCoords) <= 2.5 then
            local playerData = GetJoinedPlayer(source)
            local freeSlot = -1
            for k,v in pairs(playerData.characterData.inventory.items) do
                if v.model == "empty" then
                    freeSlot = k
                    break
                end
            end
            if freeSlot ~= -1 then
                local bikeHealth = GetVehicleBodyHealth(bike)
                local quality = (bikeHealth/1000) * 100
                local bikeKit = Config.CreateNewItemWithData(Config.Items[43])
                bikeKit.count = 1
                bikeKit.quality = quality
                playerData.characterData.inventory.items[freeSlot] = bikeKit
                DeleteEntity(bike)
                TriggerClientEvent("fivez:UpdateCharacterInventoryItems", source, json.encode(playerData.characterData.inventory.items))
                SQL_InsertItemToCharacterInventory(playerData.characterData.Id, freeSlot, playerData.characterData.inventory.items[freeSlot])
            end
        end
    end
end)

local checkedClosestObject = nil
RegisterNetEvent("fivez:CheckClosestObjectCB", function(result)
    checkedClosestObject = json.decode(result)
end)
local entityForward = nil
RegisterNetEvent("fivez:VehicleTrunkPosCB", function(result)
    entityForward = json.decode(result)
end)

RegisterNetEvent("fivez:LootInventory", function(entityNetId)
    local source = source
    local entity = NetworkGetEntityFromNetworkId(entityNetId)
    if DoesEntityExist(entity) then
        if GetEntityModel(entity) == GetHashKey(Config.ZombieModels[1]) then
            local id = "zombie:"..entity
        
            if RegisteredInventories[id] then
                OpenInventory(id, source)
                TriggerClientEvent("fivez:LootInventoryCB", source, json.encode(RegisteredInventories[id]))
            else
                TriggerClientEvent("fivez:AddNotification", source, "Inventory doesn't exist!")
            end
        else
            local routingBucket = GetPlayerRoutingBucket(source)

        end
    else
        TriggerClientEvent("fivez:AddNotification", source, "Entity doesn't exist")
    end
end)
--Get's closest inventory, searches registeredInventories, looks for closest dead zombie, or creates a temp ground inventory
RegisterNetEvent("fivez:GetClosestInventory", function(closestObject)
    local source = source
    local playerPed = GetPlayerPed(source)
    local pedCoords = GetEntityCoords(playerPed)

    --Get closest registered or temp inventory, uses position and routing bucket
    local closestInventory = GetClosestInventory(pedCoords, GetPlayerRoutingBucket(source))

    --Check if player is in vehicle
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    if vehicle > 0 then
        for k,v in pairs(spawnedVehicles) do
            if v.veh == vehicle then
                closestInventory = v.glovebox
            end
        end
    else
        vehicle = GetVehiclePedIsIn(playerPed, true)
        if vehicle > 0 then
            local vehCoords = GetEntityCoords(vehicle)
            if #(vehCoords - pedCoords) <= 2.5 then
                entityForward = nil
                TriggerClientEvent("fivez:VehicleTrunkPos", source, NetworkGetNetworkIdFromEntity(vehicle))
                while entityForward == nil do
                    Citizen.Wait(0)
                end
                local vehCoords = GetEntityCoords(vehicle)
                local vehForwardX = vehCoords.x - entityForward.x
                local vehForwardY = vehCoords.y - entityForward.y
                local coords = vector3(vehForwardX, vehForwardY, vehCoords.z)
                if #(coords - GetEntityCoords(playerPed)) <= 3 then
                    for k,v in pairs(spawnedVehicles) do
                        if v.veh == vehicle then
                            closestInventory = v.trunk
                        end
                    end
                end
            end
        end
    end
    --Checks dynamic lootable containers around the players ped
    if not closestInventory then
        checkedClosestObject = nil
        TriggerClientEvent("fivez:CheckClosestObject", source, closestObject)
        while checkedClosestObject == nil do
            Citizen.Wait(0)
        end
        if checkedClosestObject then
            local objectCoords = vector3(checkedClosestObject.pos.x, checkedClosestObject.pos.y, checkedClosestObject.pos.z)
            if #(objectCoords - GetEntityCoords(playerPed)) <= 2 then
                local maxSlots = 0
                local maxWeight = 0
                for k,v in pairs(Config.LootableContainers) do
                    if k == checkedClosestObject.model then
                        maxSlots = v.maxslots
                        maxWeight = v.maxweight
                    end
                end
                local weight, containerLoot = CalculateLootableContainer(checkedClosestObject.model)
                local invCount = 0
                for k,v in pairs(RegisteredInventories) do
                    invCount = invCount + 1
                end
                closestInventory = RegisterNewInventory("temp:"..checkedClosestObject.model..":"..invCount, "inventory", "Container", weight, maxWeight, maxSlots, containerLoot, objectCoords, GetPlayerRoutingBucket(source))
                --Freeze objects position to stop people from moving boxes and creating new loot
                FreezeEntityPosition(closestObject, true)
            end
        end
    end
    --Check dead players and see if we are near any
    if not closestInventory then
        local closestDist, deadPlayer = GetClosestDeadPlayer()

        if closestDist <= Config.InteractWithPlayersDistance then
            local playerData = GetJoinedPlayer(deadPlayer)
            if playerData then
                closestInventory = playerData.characterData.inventory
            end
        end
    end

    if not closestInventory then
        local deadZombieClose, deadZombie, deadZombieModel = CheckCoordForDeadZombie(pedCoords)

        --If we are further than 5 units away from a dead zombie
        if deadZombieClose == -1 or deadZombieClose > 5 then
            print("Creating temp ground")
            --Create temporary ground inventory
            closestInventory = CreateTempGroundInventory(pedCoords, GetPlayerRoutingBucket(source))
            TriggerClientEvent("fivez:AddGroundMarker", -1, json.encode(pedCoords))
            table.insert(inventoryMarkers, {position = pedCoords, created = GetGameTimer()})
        elseif deadZombieClose <= 5 then
            --Calculate zombies loot from model
            local weight, zombieLoot = CalculateZombieLoot(deadZombieModel)
            local invId = "zombie:"..deadZombie
            closestInventory = RegisterNewInventory(invId, "inventory", "Dead Zombie", weight, Config.ZombieInventoryMaxWeight, Config.ZombieInventoryMaxSlots, zombieLoot, GetEntityCoords(deadZombie))
            TriggerClientEvent("fivez:AddGroundMarker", -1, json.encode(GetEntityCoords(deadZombie)))
            table.insert(inventoryMarkers, {position = GetEntityCoords(deadZombie), created = GetGameTimer()})
        end
    end

    if openInventories[closestInventory.identifier] then
        table.insert(openInventories[closestInventory.identifier], source)
    else
        openInventories[closestInventory.identifier] = {source}
    end
    print("Opening closest inventory", closestInventory.identifier)
    TriggerClientEvent("fivez:PlayDroppedItemAnimation", source)
    TriggerClientEvent("fivez:GetClosestInventoryCB", source, json.encode(closestInventory))
end)

function OpenInventory(inventoryId, source)
    if openInventories[inventoryId] then
        table.insert(openInventories[inventoryId], source)
    else
        openInventories[inventoryId] = {source}
    end
end

RegisterNetEvent("fivez:CloseInventory", function()
    local source = source
    local invId = -1
    for openInvId,openInv in pairs(openInventories) do
        for k,ply in pairs(openInv) do
            if ply == source then
                invId = openInvId
                table.remove(openInventories[openInvId], k)
                break
            end
        end
    end

    if openInventories[invId] == nil or #openInventories[invId] == 0 then
        openInventories[invId] = nil
    end
end)

RegisterNetEvent("fivez:ItemUsed", function(itemId, slot, identifier)
    local source = source
    local reduceQualAmount = Config.QualRemPerItemUse
    local itemData = Config.Items[itemId]
    if not itemData then TriggerClientEvent("fivez:AddNotification", source, "Item doesn't exist!") return end
    if itemData.qualRemPerUse then reduceQualAmount = itemData.qualRemPerUse end

    if identifier == nil then
        local plyChar = GetJoinedPlayer(source).characterData
        
        if plyChar.inventory.items[slot].itemId == itemId then
            local quality = plyChar.inventory.items[slot].quality
            if quality < reduceQualAmount then TriggerClientEvent("fivez:AddNotification", source, "Item doesn't have enough quality ("..reduceQualAmount.." needed)") return end
            local notificationItem = Config.CreateNewItemWithCountQual(plyChar.inventory.items[slot], 1, plyChar.inventory.items[slot].quality)
            TriggerClientEvent("fivez:AddInventoryNotification", source, false, json.encode(plyChar.inventory.items[slot]))

            if quality > reduceQualAmount then
                plyChar.inventory.items[slot].quality = quality - reduceQualAmount
                SQL_UpdateItemQualityInCharacterInventory(plyChar.Id, slot, plyChar.inventory.items[slot].quality)
            elseif quality == reduceQualAmount then
                plyChar.inventory.items[slot] = EmptySlot()
                SQL_RemoveItemFromCharacterInventory(plyChar.Id, slot)
            end
            TriggerClientEvent("fivez:UpdateCharacterInventoryItems", source, json.encode(plyChar.inventory.items), nil)
            --OLD
            --[[ local count = plyChar.inventory.items[slot].count
            local notificationItem = Config.CreateNewItemWithCountQual(plyChar.inventory.items[slot], 1, plyChar.inventory.items[slot].quality)
            TriggerClientEvent("fivez:AddInventoryNotification", source, false, json.encode(notificationItem))
            if count == 1 then
                plyChar.inventory.items[slot] = EmptySlot()
                SQL_RemoveItemFromCharacterInventory(plyChar.Id, slot)
            elseif count > 1 then
                plyChar.inventory.items[slot].count = count - 1
                SQL_UpdateItemCountInCharacterInventory(plyChar.Id, slot, count)
            end ]]
        elseif plyChar.inventory.items[slot].itemId ~= itemId then
            TriggerClientEvent("fivez:AddNotification", source, "Item in slot isn't item you tried to use")
        end
    else
        local registeredInventory = GetInventoryWithId(identifier)

        if registeredInventory then
            if registeredInventory.items[slot].itemId == itemId then
                local quality = registeredInventory.items[slot].quality
                if quality < reduceQualAmount then TriggerClientEvent("fivez:AddNotification", source, "Item doesn't have enough quality("..reduceQualAmount.." needed)") return end
                local isGround = false
                if string.match(identifier, "ground") or string.match(identifier, "zombie") or string.match(identifier, "temp") then isGround = true end

                if quality > reduceQualAmount then
                    registeredInventory.items[slot].quality = quality - reduceQualAmount
                    if not isGround then
                        SQL_UpdateItemQualityInPersistentInventory(identifier, slot, registeredInventory.items[slot].quality)
                    end
                elseif quality == reduceQualAmount then
                    registeredInventory.items[slot] = EmptySlot()
                    if not isGround then
                        SQL_RemoveItemFromPersistentInventory(identifier, slot)
                    end
                end
                TriggerClientEvent("fivez:UpdateCharacterInventoryItems", source, json.encode(plyChar.inventory.items), json.encode(registeredInventory))
                --OLD
--[[                 local count = registeredInventory.items[slot].count
                TriggerClientEvent("fivez:AddInventoryNotification", source, false, json.encode(registeredInventory.items[slot]))
                if count == 1 then
                    registeredInventory.items[slot] = EmptySlot()
                    if not string.match(identifier, "ground") then
                        SQL_RemoveItemFromPersistentInventory(identifier, slot)
                    end
                elseif count > 1 then
                    count = count - 1
                    if not string.match(identifier, "ground") then
                        SQL_UpdateItemCountInPersistentInventory(identifier, slot, count)
                    end
                end ]]
            else
                TriggerClientEvent("fivez:AddNotification", source, "Tried to use a non existing item from another inventory")
                print(GetPlayerName(source)+" tried to use a non existing item from another inventory [" ..identifier.."]")
                return
            end
        end
    end
end)

local gotAmmoCountCB = nil
RegisterNetEvent("fivez:GetSelectedWepAmmoCountCB", function(ammo)
    gotAmmoCountCB = tonumber(ammo)
end)

RegisterNetEvent("fivez:InventoryUse", function(identifier, itemId, fromSlot)
    local source = source
    local plyChar = GetJoinedPlayer(source).characterData
    local itemData = Config.Items[itemId]
    if not itemData then TriggerClientEvent("fivez:AddNotification", source, "Item doesn't exist") return end
    local reduceQualAmount = Config.QualRemPerItemUse
    if itemData.qualRemPerUse then reduceQualAmount = itemData.qualRemPerUse end
    
    if identifier == plyChar.Id then
        if plyChar.inventory.items[fromSlot].itemId == itemId then
            if plyChar.inventory.items[fromSlot].quality < reduceQualAmount then TriggerClientEvent("fivez:AddNotification", source, "Item's quality is not high enough ("..reduceQualAmount.." needed)") return end

            --If item was a weapon
            if string.match(plyChar.inventory.items[fromSlot].model, "weapon_") then
                local plyPed = GetPlayerPed(source)
                local hands = GetSelectedPedWeapon(plyPed)
                local holstered = false
                --Has no weapon equip
                if hands == GetHashKey("weapon_unarmed") then
                    local amountCount = nil
                    if itemData.melee == nil then
                        ammoCount = SQL_GetWeaponAmmoCount(plyChar.Id, GetHashKey(itemData.model))
                    end
                    TriggerClientEvent("fivez:PlayUnholsterAnimation", source)
                    GiveWeaponToPed(plyPed, GetHashKey(itemData.model), ammoCount or 0, false, true)
                elseif hands == GetHashKey(itemData.model) then
                    SetPedAmmo(plyPed, GetHashKey(itemData.model), 0.0)
                    TriggerClientEvent("fivez:PlayHolsterAnimation", source)
                    RemoveWeaponFromPed(plyPed, GetHashKey(itemData.model))
                    holstered = true
                else
                    local ammoCount = nil
                    if itemData.melee == nil then
                        gotAmmoCountCB = nil
                        TriggerClientEvent("fivez:GetSelectedWepAmmoCount", source)
                        while gotAmmoCountCB == nil do
                            Citizen.Wait(0)
                        end
                        SQL_SetWeaponAmmoCount(plyChar.Id, hands, gotAmmoCountCB)
                        ammoCount = SQL_GetWeaponAmmoCount(plyChar.Id, GetHashKey(itemData.model))
                    end
                    SetPedAmmo(plyPed, hands, 0.0)
                    TriggerClientEvent("fivez:PlayUnholsterAnimation", source)
                    GiveWeaponToPed(plyPed, GetHashKey(itemData.model), ammoCount or 0, false, true)
                end

                if not holstered then
                    plyChar.inventory.hands = fromSlot
                else
                    plyChar.inventory.hands = -1
                end
            else
                --Item was not a weapon
                local hasClientFunc = false
                --Check if the item has a client function
                if itemData.clientfunction then
                    hasClientFunc = true
                    TriggerClientEvent("fivez:InventoryUseCB", source, identifier, itemId, fromSlot)
                    Wait(50)
                end
                --Check if the item has a server function
                if itemData.serverfunction then
                    local result = itemData.serverfunction(source, plyChar.inventory.items[fromSlot].quality)
                    if result then
                        --If the item doesn't have a client function then we've used the item
                        if not hasClientFunc then
                            TriggerClientEvent("fivez:AddInventoryNotification", source, false, json.encode(plyChar.inventory.items[fromSlot]))
                            if plyChar.inventory.items[fromSlot].quality > reduceQualAmount then
                                plyChar.inventory.items[fromSlot].quality = plyChar.inventory.items[fromSlot].quality - reduceQualAmount
                                SQL_UpdateItemQualityInCharacterInventory(plyChar.Id, fromSlot, plyChar.inventory.items[fromSlot].quality)
                            elseif plyChar.inventory.items[fromSlot].quality == reduceQualAmount then
                                plyChar.inventory.items[fromSlot] = EmptySlot()
                                SQL_RemoveItemFromCharacterInventory(plyChar.Id, fromSlot)
                            end
                            TriggerClientEvent("fivez:UpdateCharacterInventoryItems", source, json.encode(plyChar.inventory.items), nil)
                        end
                    end
                end
            end  
        else
            TriggerClientEvent("fivez:AddNotification", source, "You don't have that item!")
        end
    else
        local otherInventory = GetInventoryWithId(identifier)

        if otherInventory then
            if otherInventory.items[fromSlot].itemId == itemId then
                --Check if player is trying to use weapon from other inventory
                if string.match(plyChar.inventory.items[fromSlot].model, "weapon_") then TriggerClientEvent("fivez:AddNotification", source, "Can't use weapons from inventories that are not your own!") return end
                --Check the other inventory actually has enough count
                if otherInventory.items[fromSlot].quality <= reduceQualAmount then TriggerClientEvent("fivez:AddNotification", source, "Item doesn't have enough quality ("..reduceQualAmount.." needed)") return end
                --Check if the item has a client function
                local hasClientFunc = false
                if itemData.clientfunction then
                    hasClientFunc = true
                    TriggerClientEvent("fivez:InventoryUseCB", source, identifier, itemId, fromSlot)
                    Wait(50)
                end

                print("Using item from other inventory", itemData.itemId, itemData.label, itemData.serverfunction)
                --Check if the item has a server function
                if itemData.serverfunction then
                    local result = itemData.serverfunction(source)

                    if result then
                        if not hasClientFunc then
                            TriggerClientEvent("fivez:AddInventoryNotification", source, false, json.encode(otherInventory.items[fromSlot]))
                            if otherInventory.items[fromSlot].quality > reduceQualAmount then
                                otherInventory.items[fromSlot].quality = otherInventory.items[fromSlot].quality - reduceQualAmount
                                SQL_UpdateItemQualityInPersistentInventory(identifier, fromSlot, otherInventory.items[fromSlot].quality)
                            elseif otherInventory.items[fromSlot].quality == reduceQualAmount then
                                otherInventory.items[fromSlot] = EmptySlot()
                                SQL_RemoveItemFromPersistentInventory(identifier, fromSlot)
                            end
                            TriggerClientEvent("fivez:UpdateCharacterInventoryItems", source, nil, json.encode(otherInventory.items))
                        end
                    end
                end
            else
                TriggerClientEvent("fivez:AddNotification", source, "Inventory doesn't have that item")
            end
        end
    end
end)

--Player trying to move item locally inside inventory
RegisterNetEvent("fivez:InventoryMove", function(transferData)
    local source = source

    transferData = json.decode(transferData)

    if transferData then
        local plyChar = GetJoinedPlayer(source).characterData
        local itemData = Config.Items[transferData.item.itemId]
        if not itemData then TriggerClientEvent("fivez:AddNotification", source, "Item doesn't exist") return end
        --If player is moving items in own inventory
        if transferData.id == plyChar.Id then
            if plyChar.inventory.hands == transferData.fromSlot then TriggerClientEvent("fivez:AddNotification", source, "Can't move item in hands") return end
            if plyChar.inventory.items[transferData.fromSlot].itemId ~= transferData.item.itemId then TriggerClientEvent("fivez:AddNotification", source, "Item doesn't exist in your inventory") return end
            --Item to slot is empty
            if plyChar.inventory.items[transferData.toSlot].model == "empty" then
                plyChar.inventory.items[transferData.toSlot] = Config.CreateNewItemWithData(plyChar.inventory.items[transferData.fromSlot])
                plyChar.inventory.items[transferData.fromSlot] = EmptySlot()
                --Update database
                SQL_ChangeItemSlotIdInCharacterInventory(plyChar.Id, transferData.fromSlot, transferData.toSlot)
            --If the item is the same
            elseif plyChar.inventory.items[transferData.toSlot].itemId == transferData.item.itemId then
                --If the quality is different
                if plyChar.inventory.items[transferData.toSlot].quality ~= plyChar.inventory.items[transferData.fromSlot].quality then
                    --[[ plyChar.inventory.items[transferData.toSlot].quality = plyChar.inventory.items[transferData.toSlot].quality + plyChar.inventory.items[transferData.fromSlot].quality
                    
                    local leftOverQual = 0
                    if plyChar.inventory.items[transferData.toSlot].quality > 100 then
                        leftOverQual = plyChar.inventory.items[transferData.toSlot].quality - 100 
                        plyChar.inventory.items[transferData.toSlot].quality = 100 
                    end

                    if leftOverQual > 0 then
                        plyChar.inventory.items[transferData.fromSlot].quality = leftOverQual
                    elseif leftOverQual == 0 then
                        plyChar.inventory.items[transferData.fromSlot] = EmptySlot()
                    end ]]

                    local tempItem = plyChar.inventory.items[transferData.toSlot]
                    plyChar.inventory.items[transferData.toSlot] = Config.CreateNewItemWithData(plyChar.inventory.items[transferData.fromSlot])
                    plyChar.inventory.items[transferData.fromSlot] = Config.CreateNewItemWithData(tempItem)
                elseif plyChar.inventory.items[transferData.toSlot].quality == plyChar.inventory.items[transferData.fromSlot].quality then
                    --SAME ITEM AND SAME QUALITY DON'T DO ANYTHING?
                    --[[ --Set newCount to, to slot count plus amount transferring
                    local newCount = plyChar.inventory.items[transferData.toSlot].count + transferData.count
                    --If the new count is greater than the item max count
                    if newCount > itemData.maxcount then
                        --Set newCount to item max count
                        newCount = itemData.maxcount
                        --Set the amount we are transferring to, newCount minus the count in the from slot
                        transferData.count = newCount - plyChar.inventory.items[transferData.fromSlot].count
                    end
                    --Update to slot count with new count
                    plyChar.inventory.items[transferData.toSlot].count = newCount
                    --Update character inventory database
                    SQL_UpdateItemCountInCharacterInventory(plyChar.Id, transferData.toSlot, newCount)
                     --If player is moving exactly the amount in the from slot
                    if plyChar.inventory.items[transferData.fromSlot].count == transferData.count then
                        --Replace item with empty slot in character inventory memory
                        plyChar.inventory.items[transferData.fromSlot] = EmptySlot()
                        --Remove item from character inventory database
                        SQL_RemoveItemFromCharacterInventory(plyChar.Id, transferData.fromSlot)
                    elseif plyChar.inventory.items[transferData.fromSlot].count > transferData.count then
                        --If player is moving less than the amount in the from slot
                        --
                        plyChar.inventory.items[transferData.fromSlot].count = plyChar.inventory.items[transferData.fromSlot].count - transferData.count
                        SQL_UpdateItemCountInCharacterInventory(plyChar.Id, transferData.fromSlot, plyChar.inventory.items[transferData.fromSlot].count)
                    end ]]
                end
            elseif plyChar.inventory.items[transferData.toSlot].itemId ~= transferData.item.itemId then
                --Item isn't the exact same
                local combined = false
                if itemData.isAmmo then
                    if itemData.combiningfunction then
                        local result = itemData.combiningfunction(plyChar.inventory.items[transferData.toSlot], plyChar.inventory.items[transferData.fromSlot])

                        if result == nil then
                            print("[ERROR] Tried combining function of item -", itemData.itemId," returned nil -")
                        elseif result == false then
                            print("[ERROR] Tried combining function of item -", itemData.itemId, " returned false -", itemData.count)
                        elseif result[1] == false then
                            TriggerClientEvent("fivez:AddNotification", source, result[2])
                        else
                            plyChar.inventory.items[transferData.toSlot] = result[1]
                            plyChar.inventory.items[transferData.fromSlot] = result[2]
                            if plyChar.inventory.items[transferData.fromSlot].count == 0 then
                                plyChar.inventory.items[transferData.fromSlot] = EmptySlot()
                                SQL_RemoveItemFromCharacterInventory(plyChar.Id, transferData.fromSlot)
                            else
                                SQL_UpdateItemCountInCharacterInventory(plyChar.Id, transferData.fromSlot, plyChar.inventory.items[transferData.fromSlot].count)
                            end

                            SQL_UpdateItemAttachmentsInCharacterInventory(plyChar.Id, transferData.toSlot, plyChar.inventory.items[transferData.toSlot])
                        end
                        
                        combined = true
                    end
                end
                if not combined then
                    --Change Id of what we are moving to where we are moving it to
                    SQL_ChangeItemSlotIdInCharacterInventory(plyChar.Id, transferData.fromSlot, transferData.toSlot)
                    --Change Id of where we moved too where we were
                    SQL_ChangeItemSlotIdWithItemIdInCharacterInventory(plyChar.Id, transferData.toSlot, plyChar.inventory.items[transferData.toSlot].itemId, transferData.fromSlot)
                    local tempItem = plyChar.inventory.items[transferData.toSlot]
                    plyChar.inventory.items[transferData.toSlot] = Config.CreateNewItemWithData(plyChar.inventory.items[transferData.fromSlot])
                    plyChar.inventory.items[transferData.fromSlot] = Config.CreateNewItemWithData(tempItem)
                end
            end
            TriggerClientEvent("fivez:UpdateCharacterInventoryItems", source, json.encode(plyChar.inventory.items), nil)
        else
            --Player is moving items in other inventory
            --Get the inventory player is moving around
            local inventoryData = GetInventoryWithId(transferData.id)

            if not inventoryData then
                inventoryData = GetJoinedPlayerWithId(transferData.id).characterData.inventory

                if not inventoryData then
                    TriggerClientEvent("fivez:AddNotification", source, "No inventory found!")
                    return
                end
            end
            --Get the slot moving onto
            local slotMovingOnto = inventoryData.items[transferData.toSlot]
            --Get the slot moving from
            local slotMovingFrom = inventoryData.items[transferData.fromSlot]
            --If player is moving item that doesn't exist in the from slot
            if slotMovingFrom.itemId ~= transferData.item.itemId then TriggerClientEvent("fivez:AddNotification", source, "Item doesn't exist in inventory") return end
            local tempInventory = false
            if string.match(transferData.id, "ground") or string.match(transferData.id, "zombie") or string.match(transferData.id, "temp") then tempInventory = true end
            --If we got slot moving onto and from
            if slotMovingOnto and slotMovingFrom then
                --Moving onto empty slot
                if slotMovingOnto.model == "empty" then
                    slotMovingOnto = Config.CreateNewItemWithData(slotMovingFrom)
                    slotMovingFrom = EmptySlot()
                    if not tempInventory then
                        SQL_ChangeItemSlotIdInPersistentInventory(transferData.id, transferData.fromSlot, transferData.toSlot)
                    end
                else
                    --TODO: DO SOME THINKING HERE
                    --Moving onto non empty slot
                    --Moving onto the same item
                    if slotMovingFrom.itemId == slotMovingOnto.itemId then
                        if slotMovingFrom.qualtity ~= slotMovingOnto.quality then
                            local tempItem = slotMovingOnto
                            slotMovingOnto = Config.CreateNewItemWithData(slotMovingFrom)
                            slotMovingFrom = Config.CreateNewItemWithData(tempItem)

                            if not tempInventory then
                                SQL_ChangeItemSlotIdInPersistentInventory(transferData.id, transferData.fromSlot, transferData.toSlot)
                                SQL_ChangeItemSlotIdWithItemIdInPersistentInventory(transferData.id, transferData.toSlot, slotMovingFrom.itemId, transferData.fromSlot)
                            end
                        else
                            --Moving onto the same item that has the same quality
                            --[[ local newCount = slotMovingOnto.count + transferData.count
                            if newCount > itemData.maxcount then 
                                newCount = itemData.maxcount
                                transferData.count = newCount - slotMovingFrom.count
                            end
                            slotMovingOnto.count = newCount
                            --Update moving onto slot count
                            SQL_UpdateItemCountInPersistentInventory(transferData.id, transferData.toSlot, newCount)

                            if slotMovingFrom.count == transferData.count then
                                slotMovingFrom = EmptySlot()

                                if not tempInventory then
                                    SQL_RemoveItemFromPersistentInventory(transferData.id, transferData.fromSlot)
                                end
                            elseif slotMovingFrom.count > transferData.count then
                                slotMovingFrom.count = slotMovingFrom.count - transferData.count
                                if not tempInventory then
                                    --Update moving from slot count
                                    SQL_UpdateItemCountInPersistentInventory(transferData.id, transferData.fromSlot, slotMovingFrom.count)
                                end
                            end ]]
                        end
                    elseif slotMovingFrom.itemId ~= slotMovingOnto.itemId then
                        --Not moving onto the same item
                        local tempItem = slotMovingOnto
                        slotMovingOnto = Config.CreateNewItemWithData(slotMovingFrom)
                        slotMovingFrom = Config.CreateNewItemWithData(tempItem)

                        if not tempInventory then
                            SQL_ChangeItemSlotIdInPersistentInventory(transferData.id, transferData.toSlot, transferData.fromSlot)
                            SQL_ChangeItemSlotIdWithItemIdInPersistentInventory(transferData.id, transferData.fromSlot, slotMovingOnto.itemId, transferData.toSlot)
                        end
                    end
                end
            end

            for k,v in pairs(openInventories[transferData.id]) do
                TriggerClientEvent("fivez:UpdateCharacterInventoryItems", v, nil, json.encode(inventoryData.items))
            end
        end
    end
end)

--Player trying to move item from one inventory to another
RegisterNetEvent("fivez:InventoryTransfer", function(transferData)
    local source = source
    
    transferData = json.decode(transferData)

    if transferData then
        local transferAmount = transferData.count
        local plyChar = GetJoinedPlayer(source).characterData
        local itemData = Config.Items[transferData.item.itemId]
        if not itemData then print("Couldn't find registered item") return end
        local tempInventory = false
        --Player is transferring to own inventory
        if transferData.toId == plyChar.Id then
            if string.match(transferData.fromId, "routinginterior") or string.match(transferData.fromId, "ground") or string.match(transferData.fromId, "zombie") or string.match(transferData.fromId, "temp") then tempInventory = true end
            --Get the slot in inventory we are transferring to
            local plySlot = plyChar.inventory.items[transferData.toSlot]
            --Get the inventory we are transferring from
            local inventoryTransferringFrom = GetInventoryWithId(transferData.fromId)
            --If we couldn't find a registered or temp inventory, find player inventory
            if not inventoryTransferringFrom then
                --Transferring from another player
                inventoryTransferringFrom = GetJoinedPlayerWithId(transferData.fromId).characterData.inventory

                if not inventoryTransferringFrom then
                    TriggerClientEvent("fivez:AddNotification", source, "Couldn't find inventory!")
                    return
                end
            end
            --Get the slot we are transferring from
            local invSlot = inventoryTransferringFrom.items[transferData.fromSlot]
            --Check if we are surpassing the max weight for the player inventory
            if plyChar.inventory.weight + (itemData.weight * transferData.count) > plyChar.inventory.maxweight then TriggerClientEvent("fivez:AddNotification", source, "You would be too heavy") return end
            --Check if the other inventory has enough item count
            if invSlot.count <= 0 or invSlot.count < transferData.count then TriggerClientEvent("fivez:AddNotification", source, "Inventory transferring from doesn't have enough") return end
            --Check if the other inventory has the item
            if invSlot.itemId ~= transferData.item.itemId then TriggerClientEvent("fivez:AddNotification", source, "Inventory transferring from doesn't have that item") return end
            
            --Slot transferring onto is empty
            if plySlot.model == "empty" then
                print("Changing ply slot", plySlot.model, invSlot.quality)
                plyChar.inventory.items[transferData.toSlot] = Config.CreateNewItemWithData(invSlot)
                plySlot = plyChar.inventory.items[transferData.toSlot]
                
                print("Changed ply slot", plySlot.model, plySlot.quality)
                plySlot.count = transferData.count
                SQL_InsertItemToCharacterInventory(plyChar.Id, transferData.toSlot, {id = plySlot.itemId, count = plySlot.count, quality = plySlot.quality, attachments = plySlot.attachments })
                --If we are not transferring from the admin item menu
                if transferData.fromId ~= "itemmenu:1" then
                    inventoryTransferringFrom.items[transferData.fromSlot] = EmptySlot()
                    invSlot = inventoryTransferringFrom.items[transferData.fromSlot]
                end
                if not tempInventory then
                    SQL_RemoveItemFromPersistentInventory(transferData.fromId, transferData.fromSlot)
                end
            elseif plySlot.itemId == invSlot.itemId then
                --Transferring onto same item type
                --If there is a difference in item quality
                if invSlot.quality ~= plySlot.quality then
                    --[[ plySlot.count = plySlot.count + transferData.count
                    local leftOverCount = 0
                    if plySlot.count > itemData.maxcount then
                        leftOverCount = plySlot.count - itemData.maxcount
                        plySlot.count = itemData.maxcount
                    end
                    --Plus the qualities together
                    plySlot.quality = invSlot.quality + plySlot.quality
                    --Check if quality is over 100
                    local leftOverQual = 0
                    if plySlot.quality > 100 then
                        --Find out how much left over quality there is
                        leftOverQual = plySlot.quality - 100
                        plySlot.quality = 100
                    end
                    --Update item count in database
                    SQL_UpdateItemCountInCharacterInventory(plyChar.Id, transferData.toSlot, plySlot.count)
                    --Update the item quality in database
                    SQL_UpdateItemQualityInCharacterInventory(plyChar.Id, transferData.toSlot, plySlot.quality)
                    --If there is any left over quality and count
                    if (leftOverQual > 0 and leftOverCount > 0) then
                        invSlot.count = leftOverCount
                        invSlot.quality = leftOverQual
                        if not string.match(transferData.fromId, "ground") and not string.match(transferData.fromId, "zombie") and not string.match(transferData.fromId, "temp") then
                            SQL_UpdateItemCountInPersistentInventory(transferData.fromId, transferData.fromSlot, leftOverCount)
                            SQL_UpdateItemQualityInPersistentInventory(transferData.fromId, transferData.fromSlot, leftOverQual)
                        end
                    --If there is no quality left over
                    end
                    if leftOverQual == 0 or leftOverCount == 0 then
                        inventoryTransferringFrom.items[transferData.fromSlot] = EmptySlot()
                        if not string.match(transferData.fromId, "ground") and not string.match(transferData.fromId, "zombie") and not string.match(transferData.fromId, "temp") then
                            SQL_RemoveItemFromPersistentInventory(transferData.fromId, transferData.fromSlot)
                        end
                    end ]]
                    local tempItem = plySlot
                    plyChar.inventory.items[transferData.toSlot] = Config.CreateNewItemWithData(invSlot)
                    inventoryTransferringFrom.items[transferData.fromSlot] = Config.CreateNewItemWithData(tempItem)
                    SQL_RemoveItemFromCharacterInventory(plyChar.Id, transferData.toSlot)
                    SQL_InsertItemToCharacterInventory(plyChar.Id, transferData.toSlot, {id = plySlot.itemId, count = plySlot.count, quality = plySlot.quality, attachments = plySlot.attachments})
                    if not tempInventory and not transferData.fromId ~= "itemmenu:1" then
                        SQL_RemoveItemFromPersistentInventory(transferData.fromId, transferData.fromSlot)
                        SQL_InsertItemToPersistentInventory(transferData.fromId, transferData.fromSlot, {id = invSlot.itemId, count = invSlot.count, quality = invSlot.quality, attachments = invSlot.attachments})
                    end
                else
                    --Same item same quality
                    --[[ local newCount = plyChar.inventory.items[transferData.toSlot].count + transferData.count
                    if newCount > itemData.maxcount then
                        newCount = itemData.maxcount --New count is the item max count
                        transferData.count = newCount - plyChar.inventory.items[transferData.toSlot].count --The amount we are transferring now is, max count minus cur count
                    end
                    plySlot.count = newCount
                    SQL_UpdateItemCountInCharacterInventory(plyChar.Id, transferData.toSlot, newCount) ]]
                end
            elseif plySlot.itemId ~= invSlot.itemId then
                --Not transferring onto the same item
                --Swap the items around
                local tempItem = plyChar.inventory.items[transferData.toSlot]
                plyChar.inventory.items[transferData.toSlot] = Config.CreateNewItemWithData(invSlot)
                --Remove the item we swapped from database inventory
                SQL_RemoveItemFromCharacterInventory(plyChar.Id, transferData.toSlot)
                --Save item we swapped for in database inventory
                SQL_InsertItemToCharacterInventory(plyChar.Id, transferData.toSlot, {id = plySlot.itemId, count = plySlot.count, quality = plySlot.quality, attachments = plySlot.attachments})
                
                --If transferring from admin menu don't try to swap items
                if transferData.fromId ~= "itemmenu:1" then
                    inventoryTransferringFrom.items[transferData.fromSlot] = Config.CreateNewItemWithData(tempItem)

                    if not tempInventory then
                        --First delete them item we swapped to player inventory
                        SQL_RemoveItemFromPersistentInventory(transferData.fromId, transferData.fromSlot)
                        --Then save the new item to the slot id
                        SQL_InsertItemToPersistentInventory(transferData.fromId, transferData.fromSlot, {id = invSlot.itemId, count = invSlot.count, quality = invSlot.quality, attachments = invSlot.attachments})
                    end
                end
            end

            TriggerClientEvent("fivez:PlayDroppedItemAnimation", source)
            if openInventories[inventoryTransferringFrom.identifier] ~= nil then
                --Update any clients with the same inventory open
                for k,v in pairs(openInventories[inventoryTransferringFrom.identifier]) do
                    if v == source then
                        TriggerClientEvent("fivez:AddInventoryNotification", v, true, json.encode(plySlot))
                    else
                        TriggerClientEvent("fivez:AddInventoryNotification", v, false, json.encode(invSlot))
                    end
                    TriggerClientEvent("fivez:UpdateCharacterInventoryItems", v, json.encode(plyChar.inventory.items), json.encode(inventoryTransferringFrom.items))
                end
            elseif openInventories[inventoryTransferringFrom.identifier] == nil then
                print(inventoryTransferringFrom.identifier, " this inventory isn't in the open inventories table")
            end
        elseif transferData.fromId == plyChar.Id then
            if string.match(transferData.toId, "ground") or string.match(transferData.toId, "zombie") or string.match(transferData.toId, "temp") then tempInventory = true end
            --Player is transferring out of own inventory
            local plySlot = plyChar.inventory.items[transferData.fromSlot]
            --Check character has enough of the item in the slot or if the character has less than the amount trying to be transfered
            if plySlot.quality <= 0 then TriggerClientEvent("fivez:AddNotification", source, "Item doesn't have enough quality ("..reduceQualAmount.." needed)") return end
            --Check if the item transferring is an item the character has
            if plySlot.itemId ~= itemData.itemId then TriggerClientEvent("fivez:AddNotification", source, "You don't have that item!") return end
            --Find the other inventory we have open
            local inventoryTransferringTo = GetInventoryWithId(transferData.toId)
            --Couldn't find pre-registered inventory, find a players inventory
            if not inventoryTransferringTo then
                inventoryTransferringTo = GetJoinedPlayerWithId(transferData.toId).characterData.inventory
            end
            
            if not inventoryTransferringTo then
                TriggerClientEvent("fivez:AddNotification", source, "No inventories found!")
                return
            end
            --Get the inventorys max weight
            local inventoryMaxweight = inventoryTransferringTo.maxweight or inventoryTransferringTo.maxWeight
            --Check the amount we are trying to move over isn't over the inventorys max weight
            if inventoryTransferringTo.weight + (itemData.weight * transferData.count) > inventoryMaxweight then TriggerClientEvent("fivez:AddNotification", source, "Inventory is too heavy") return end
            --Get the slot we are transferring to
            local invSlot = inventoryTransferringTo.items[transferData.toSlot]
            --Transferring onto empty slot
            if invSlot.model == "empty" then
                --Change the item in to slot to the item from characters inventory
                inventoryTransferringTo.items[transferData.toSlot] = Config.CreateNewItemWithData(plySlot)
                invSlot = inventoryTransferringTo.items[transferData.toSlot]
                invSlot.quality = transferData.item.quality
                invSlot.count = transferData.count
                plyChar.inventory.items[transferData.fromSlot] = EmptySlot()
                plySlot = plyChar.inventory.items[transferData.fromSlot]
                if not tempInventory then
                    SQL_InsertItemToPersistentInventory(transferData.toId, transferData.toSlot, {id = invSlot.itemId, count = invSlot.count, quality = invSlot.quality, attachments = invSlot.attachments})
                end
                SQL_RemoveItemFromCharacterInventory(plyChar.Id, transferData.fromSlot)
            elseif invSlot.itemId == plySlot.itemId then
                --If we are transferring onto the exact same item
                --If the quality from the item slot where we are transferrinmg from is not the same as the slot we are transferring to
                if plySlot.quality ~= invSlot.quality then
                    --[[ invSlot.count = invSlot.count + transferData.count
                    local leftOverCount = 0
                    if invSlot.count > itemData.maxcount then
                        leftOverCount = invSlot.count - itemData.maxcount
                        invSlot.count = itemData.maxcount
                    end
                    invSlot.quality = invSlot.quality + plySlot.quality

                    local leftOverQual = 0
                    if invSlot.quality > 100 then
                        leftOverQual = invSlot.quality - 100
                        invSlot.quality = 100
                    end
                    if not tempInventory then
                        SQL_UpdateItemCountInPersistentInventory(transferData.toId, transferData.toSlot, invSlot.count)
                        SQL_UpdateItemQualityInPersistentInventory(transferData.toId, transferData.toSlot, invSlot.quality)
                    end
                    if leftOverQual > 0 or leftOverCount > 0 then
                        plySlot.quality = leftOverQual
                        plySlot.count = leftOverCount
                        
                        SQL_UpdateItemCountInCharacterInventory(plyChar.Id, transferData.fromSlot, leftOverCount)
                        SQL_UpdateItemQualityInCharacterInventory(plyChar.Id, transferData.fromSlot, leftOverQual)
                    elseif leftOverQual == 0 or leftOverCount == 0 then
                        plySlot = EmptySlot()
                        SQL_RemoveItemFromCharacterInventory(plyChar.Id, transferData.fromSlot)
                    end ]]

                    local tempItem = invSlot
                    inventoryTransferringTo.items[transferData.toSlot] = Config.CreateNewItemWithData(plySlot)
                    --invSlot = inventoryTransferringTo.items[transferData.toSlot]
                    plyChar.inventory.items[transferData.fromSlot] = Config.CreateNewItemWithData(tempItem)
                    invSlot = inventoryTransferringTo.items[transferData.toSlot]
                    plySlot = plyChar.inventory.items[transferData.fromSlot]
                    if not tempInventory then
                        SQL_RemoveItemFromPersistentInventory(transferData.toId, transferData.toSlot)
                        SQL_InsertItemToPersistentInventory(transferData.toId, transferData.toSlot, {id = invSlot.itemId, count = invSlot.count, quality = invSlot.quality, attachments = invSlot.attachments})
                    end

                    SQL_RemoveItemFromCharacterInventory(plyChar.Id, transferData.fromSlot)
                    SQL_InsertItemToCharacterInventory(plyChar.Id, transferData.fromSlot, {id = plySlot.itemId, count = plySlot.count, quality = plySlot.quality, attachments = plySlot.attachments })
                else
                    --Transferring the exact same item and their quality is the same
                    --[[ local newCount = invSlot.count + transferData.count

                    if newCount > itemData.maxcount then
                        newCount = itemData.maxcount
                        transferData.count = newCount - invSlot.count
                    end
                    inventoryTransferringTo.items[transferData.toSlot].count = newCount
                    invSlot = inventoryTransferringTo.items[transferData.toSlot]
                    if not tempInventory then
                        SQL_UpdateItemCountInPersistentInventory(transferData.toId, transferData.toSlot, newCount)
                    end
                    --Item slot count is equal to the amount character is transferring
                    if plySlot.count == transferData.count then
                        --Change the item from slot to an empty slot
                        plyChar.inventory.items[transferData.fromSlot] = EmptySlot()
                        plySlot = plyChar.inventory.items[transferData.fromSlot]
                        SQL_RemoveItemFromCharacterInventory(plyChar.Id, transferData.fromSlot)
                    elseif plySlot.count > transferData.count then
                        --Item slot count is greater than the amount character is transferring
                        plyChar.inventory.items[transferData.fromSlot].count = plySlot.count - transferData.count
                        plySlot = plyChar.inventory.items[transferData.fromSlot]
                        SQL_UpdateItemCountInCharacterInventory(plyChar.Id, transferData.fromSlot, plySlot.count)
                    end ]]
                end
            elseif invSlot.itemId ~= plySlot.itemId then
                --Transferring onto a different item
                local tempItem = invSlot
                inventoryTransferringTo.items[transferData.toSlot] = Config.CreateNewItemWithData(plySlot)
                invSlot = inventoryTransferringTo.items[transferData.toSlot]
                plyChar.inventory.items[transferData.fromSlot] = Config.CreateNewItemWithData(tempItem)
                plySlot = plyChar.inventory.items[transferData.fromSlot]

                if not tempInventory then
                    SQL_RemoveItemFromPersistentInventory(transferData.toId, transferData.toSlot)
                    SQL_InsertItemToPersistentInventory(transferData.toId, transferData.toSlot, {id = invSlot.itemId, count = invSlot.count, quality = invSlot.quality, attachments = invSlot.attachments})
                end
                SQL_RemoveItemFromCharacterInventory(plyChar.Id, transferData.fromSlot)
                SQL_InsertItemToCharacterInventory(plyChar.Id, transferData.fromSlot, {id = plySlot.itemId, count = plySlot.count, quality = plySlot.quality, attachments = plySlot.attachments})
            end
            TriggerClientEvent("fivez:PlayDroppedItemAnimation", source)
            for k,v in pairs(openInventories[inventoryTransferringTo.identifier]) do
                if v == source then
                    --If the person transferring to this inventory, notify we transferred
                    TriggerClientEvent("fivez:AddInventoryNotification", v, false, json.encode(inventoryTransferringTo.items[transferData.toSlot]))
                else
                    TriggerClientEvent("fivez:AddInventoryNotification", v, true, json.encode(inventoryTransferringTo.items[transferData.toSlot]))
                end
                TriggerClientEvent("fivez:UpdateCharacterInventoryItems", v, json.encode(plyChar.inventory.items), json.encode(inventoryTransferringTo.items))
            end
        end
    end
end)

function InventoryFillEmpty(maxSlots)
    local items = {}
    for i=1, maxSlots do
        table.insert(items, {itemId = -1, label = "Empty", model = "empty", weight = 0, count = 0, maxcount = 0, quality = 0, attachments = {}})
    end

    return items
end

function EmptySlot()
    return {label = "Empty", model = "empty", weight = 0, count = 0, maxcount = 0, quality = 0, attachments = {}}
end

RegisterNetEvent("fivez:AttemptCraft", function(recipeId)
    if Config.Recipes[recipeId] then
        local source = source
        local plyData = GetJoinedPlayer(source)
        if plyData then
            if plyData.characterData then
                local foundItems = {}
                local charInventory = plyData.characterData.inventory
                --Loop through required items and find them in character inventory
                for k,reqItem in pairs(Config.Recipes[recipeId].required) do
                    for k,v in pairs(charInventory.items) do
                        if reqItem.itemId == v.itemId then
                            --If the item we found has enough count and quality
                            if v.count >= reqItem.count and v.quality >= reqItem.quality then
                                table.insert(foundItems, {id = reqItem.itemId, slot = k, count = reqItem.count})
                            end
                        elseif reqItem[1] then
                            for i=0,#reqItem do
                                if reqItem[i].itemId == v.itemId then
                                    if v.count >= reqItem[i].count and v.quality >= reqItem[i].quality then
                                        table.insert(foundItems, {id = reqItem[i].itemId, slot = k, count = reqItem[i].count})
                                    end
                                end
                            end
                        end
                    end
                end
                if #foundItems == #Config.Recipes[recipeId].required then
                    local freeSlot = -1
                    for k,v in pairs(charInventory.items) do
                        if v.model == "empty" then
                            freeSlot = k
                            break
                        end
                    end
                    if freeSlot ~= -1 then
                        --Remove the used items from players inventory
                        for k,v in pairs(foundItems) do
                            if plyData.characterData.inventory.items[v.slot].count == v.count then
                                plyData.characterData.inventory.items[v.slot] = EmptySlot()
                                SQL_RemoveItemFromCharacterInventory(plyData.Id, v.slot)
                            elseif plyData.characterData.inventory.items[v.slot].count > v.count then
                                if v.count == 0 then
                                    plyData.characterData.inventory.items[v.slot].quality = plyData.characterData.inventory.items[v.slot].quality - Config.CraftQualityDecay
                                    SQL_UpdateItemQualityInCharacterInventory(plyData.Id, v.slot, plyData.characterData.inventory.items[v.slot].quality)
                                else
                                    plyData.characterData.inventory.items[v.slot].count = plyData.characterData.inventory.items[v.slot].count - v.count
                                    SQL_UpdateItemCountInCharacterInventory(plyData.Id, v.slot, plyData.characterData.inventory.items[v.slot].count)
                                end
                            end
                        end
                        --Create the new crafted item
                        local craftedItem = Config.GetItemWithModel(Config.Recipes[recipeId].model)
                        plyData.characterData.inventory.items[freeSlot] = Config.CreateNewItemWithCountQual(craftedItem, Config.Recipes[recipeId].count, 100)
                        
                        SQL_InsertItemToCharacterInventory(plyData.Id, freeSlot, craftedItem)
                        TriggerClientEvent("fivez:UpdateCharacterInventoryItems", source, json.encode(plyData.characterData.inventory.items), nil)
                    end
                else
                    TriggerClientEvent("fivez:AddNotification", source, "You don't have enough resources")
                end
            end
        end
    end
end)

RegisterNetEvent("fivez:AttemptCombine", function(firstSlotId, secondSlotId, slotDraggedOnto)
    local source = source
    local playerData = GetJoinedPlayer(source)

    if IsPedDeadOrDying(GetPlayerPed(source), 1) then return end

    if playerData then
        local inventoryData = playerData.characterData.inventory

        if inventoryData.items[slotDraggedOnto].model ~= "empty" then TriggerClientEvent("fivez:AddNotification", source, "Drag the combined item onto an empty slot!") return end
        
        if inventoryData.items[firstSlotId].itemId == inventoryData.items[secondSlotId].itemId then
            local combinedQuality = inventoryData.items[firstSlotId].quality + inventoryData.items[secondSlotId].quality

            if combinedQuality > 100 then combinedQuality = 100 end

            playerData.characterData.inventory.items[slotDraggedOnto] = inventoryData.items[firstSlotId]
            playerData.characterData.inventory.items[slotDraggedOnto].quality = combinedQuality

            playerData.characterData.inventory.items[firstSlotId] = EmptySlot()

            playerData.characterData.inventory.items[secondSlotId] = EmptySlot()

            SQL_RemoveItemFromCharacterInventory(playerData.Id, firstSlotId)
            SQL_RemoveItemFromCharacterInventory(playerData.Id, secondSlotId)
            SQL_InsertItemToCharacterInventory(playerData.Id, slotDraggedOnto, playerData.characterData.inventory.items[slotDraggedOnto])

            local combineInventory = {
                type = "combining",
                identifier = "combining",
                label = "Combining"
            }
            TriggerClientEvent("fivez:UpdateCharacterInventoryItems", source, json.encode(playerData.characterData.inventory.items), json.encode(combineInventory))
        end
    end
end)

RegisterNetEvent("fivez:AttemptReload", function()
    local source = source
    local playerData = GetJoinedPlayer(source)
    if playerData then
        local currentWeapon = GetSelectedPedWeapon(GetPlayerPed(source))

        if currentWeapon ~= GetHashKey("weapon_unarmed") then
            local inventoryData = playerData.characterData.inventory
            if inventoryData then
                for k,v in pairs(inventoryData.items) do
                    if v.model ~= "empty" then
                        local item = v
                        local itemSlot = k
                        local configItem = Config.Item[item.itemId]
                        if configItem then
                            if configItem.isMag then
                                local ammoInMag = -1
                                for k,v in pairs(item.attachments) do
                                    ammoInMag = v
                                end
                                if ammoInMag ~= -1 then
                                    for k,v in pairs(configItem.compatibleWeapons) do
                                        if v == currentWeapon then
                                            local hands = inventoryData.hands
                                            if hands > 0 then
                                                if inventoryData.items[hands].attachments then
                                                    local hasAttachments = false
                                                    local hasMag = false
                                                    local attachmentModel = nil
                                                    if #inventoryData.items[hands].attachments > 0 then
                                                        hasAttachments = true
                                                        for k,v in pairs(inventoryData.items[hands].attachments) do
                                                            if string.match(v, "mag") then
                                                                hasMag = true
                                                                attachmentModel = k
                                                            end
                                                        end
                                                    end

                                                    --If the gun doesn't have a mag attachment
                                                    if not hasMag then
                                                        --If the gun has no attachments at all
                                                        if not hasAttachments then
                                                            inventoryData.items[hands].attachments[configItem.model] = ammoInMag

                                                            item = EmptySlot()
                                                            SQL_RemoveItemFromCharacterInventory(playerData.Id, itemSlot)
                                                        else
                                                            local tempAttachments = {}
                                                            for k,v in pairs(inventoryData.items[hands].attachments) do
                                                                tempAttachments[k] = v
                                                            end
                                                            tempAttachments[configItem.model] = ammoInMag

                                                            inventoryData.items[hands].attachments = tempAttachments

                                                            item = EmptySlot()
                                                            SQL_RemoveItemFromCharacterInventory(playerData.Id, itemSlot)
                                                        end
                                                    else
                                                        if attachmentModel ~= nil then
                                                            if attachmentModel == configItem.model then
                                                                local tempAmmo = inventoryData.items[hands].attachments[attachmentModel]
                                                                inventoryData.items[hands].attachments[attachmentModel] = ammoInMag
                                                                for k,v in pairs(item.attachments) do
                                                                    item.attachments[k] = tempAmmo
                                                                end
                                                                SQL_UpdateItemAttachmentsInCharacterInventory(playerData.Id, itemSlot, item.attachments)
                                                            else
                                                                --TODO: Swap over the different mags
                                                                local tempAttachments = {}
                                                                for k,v in pairs(inventoryData.items[hands].attachments) do
                                                                    if k ~= attachmentModel then
                                                                        tempAttachments[k] = v
                                                                    end
                                                                end
                                                                tempAttachments[configItem.model] = ammoInMag
                                                                local tempItem = Config.GetItemWithModel(attachmentModel)
                                                                for k,v in pairs(tempItem.attachments) do
                                                                    tempItem.attachments[k] = inventoryData.items[hands].attachments[attachmentModel]
                                                                end
                                                                
                                                                inventoryData.items[itemSlot] = tempItem

                                                                SQL_InsertItemToCharacterInventory(playerData.Id, itemSlot, tempItem)
                                                            end
                                                        end
                                                    end

                                                    SQL_UpdateItemAttachmentsInCharacterInventory(playerData.Id, hands, inventoryData.items[hands].attachments)
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)

RegisterCommand("bag", function(source)
    local playerPed = GetPlayerPed(source)
    if IsPedDeadOrDying(playerPed, 1) then return end
    if DoesEntityExist(playerPed) then
        local playerData = GetJoinedPlayer(source)
        local characterData = playerData.characterData
        if characterData then
            local appearance = characterData.appearance
            if appearance then
                for k,v in pairs(Config.Bags) do
                    if k == appearance.components.bag.drawable then
                        local bagInventory = RegisteredInventories["bag:"..k..":"..characterData.Id]
                        if bagInventory then
                            OpenInventory("bag:"..k..":"..characterData.Id, source)
                            TriggerClientEvent("fivez:LootInventoryCB", source, json.encode(bagInventory))
                            return
                        else
                            --TODO: Add checking for items in the database
                            local bagData = SQL_GetCharacterBag(characterData.Id, k)
                            if bagData ~= -1 then
                                bagInventory = SQL_GetCharacterBagInventory(characterData.Id, k)
                                if bagInventory then
                                    bagInventory = RegisterNewInventory("bag:"..k..":"..characterData.Id, "inventory", "Duffel Bag", 0, 50, 25, bagInventory, nil)
                                else
                                    bagInventory = RegisterNewInventory("bag:"..k..":"..characterData.Id, "inventory", "Duffel Bag", 0, 50, 25, InventoryFillEmpty(25), nil)
                                end
                            else
                                local createdInv = SQL_CreateCharacterBagInventory(characterData.Id, k)

                                if createdInv then
                                    bagInventory = RegisterNewInventory("bag:"..k..":"..characterData.Id, "inventory", "Duffel Bag", 0, 50, 25, InventoryFillEmpty(25), nil)
                                end
                            end
                            OpenInventory("bag:"..k..":"..characterData.Id, source)
                            TriggerClientEvent("fivez:LootInventoryCB", source, json.encode(bagInventory))
                            return 
                        end
                        TriggerClientEvent("fivez:AddNotification", source, "Bag doesn't have an inventory, re-use bag!")
                    end
                end
                TriggerClientEvent("fivez:AddNotification", source, "You don't have a bag on!")
            end
        end
    end
end, false)

function SQL_CreateCharacterBagInventory(charId, bagId)
    local bagIdentifier = "bag:"..bagId..":"..charId
    MySQL.ready(function()
        MySQL.Async.insert("INSERT INTO character_bags (character_bagsid) VALUES (@bagId)", {
            ["bagId"] = bagIdentifier
        })
    end)
    return true
end

function SQL_GetCharacterBag(charId, bagId)
    local bagIdentifier = "bag:"..bagId..":"..charId
    local gotData = nil
    MySQL.ready(function()
        MySQL.Async.fetchAll("SELECT character_bagsid FROM character_bags WHERE character_bagsid = @bagId", {
            ["bagId"] = bagIdentifier
        }, function(result)
            if result then
                gotData = result
                return gotData
            end
            gotData = -1
        end)
    end)

    while gotData == nil do
        Citizen.Wait(1)
    end

    return gotData
end

function SQL_GetCharacterBagInventory(charId, bagId)
    local bagIdentifier = "bag:"..bagId..":"..charId
    local gotData = -1
    MySQL.ready(function()
        MySQL.Async.fetchAll("SELECT * FROM persistent_inventory_items WHERE persistent_id = @bagId", {
            ["bagId"] = bagIdentifier
        }, function(result)
            if result[1] then
                local tempData = InventoryFillEmpty(25)
                for k,v in pairs(result) do
                    local itemData = Config.Items[v.item_id]
                    tempData[v.item_slotid] = {
                        itemId = v.item_id,
                        label = itemData.label,
                        model = itemData.model,
                        weight = itemData.weight,
                        maxcount = itemData.maxcount,
                        count = v.item_count,
                        quality = v.item_quality,
                        attachments = v.item_attachments
                    }
                end
                gotData = tempData
            else
                gotData = nil
            end
        end)
    end)

    while gotData == -1 do
        Citizen.Wait(1)
    end
    return gotData
end