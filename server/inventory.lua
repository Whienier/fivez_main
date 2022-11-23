local RegisteredInventories = {}
local openInventories = {}
local inventoryMarkers = {}

function AddInventoryMarker(coords)
    table.insert(inventoryMarkers, {position = coords, created = GetGameTimer()})
    TriggerClientEvent("fivez:AddGroundMarker", -1, json.encode(coords))
end

function GetAllInventoryMarkers()
    return inventoryMarkers
end

Citizen.CreateThread(function()
    while true do
        if #inventoryMarkers >= 1 then
            for k,v in pairs(inventoryMarkers) do
                if (GetGameTimer() - v.created) > Config.DeleteInventoryMarkerTime then
                    TriggerClientEvent("fivez:RemoveGroundMarker", -1, json.encode(v.position))
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
            if v.glovebox.identifier == invId then
                return v.glovebox
            end

            if v.trunk.identifier == invId then
                return v.trunk
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

function GetClosestInventory(pedCoords)
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
    return nil
end

function CreateTempGroundInventory(pedCoords)
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
        items = items
    }

    return TempInventories[tempId]
end

function RegisterNewInventory(id, type, label, weight, maxweight, maxslots, items, position)
    if RegisteredInventories[id] then return RegisteredInventories[id] end
    RegisteredInventories[id] = {
        type = type or "inventory",
        identifier = id,
        label = label,
        weight = weight or 0,
        maxWeight = maxweight,
        maxSlots = maxslots,
        items = items,
        position = position
    }

    return RegisteredInventories[id]
end

function DeleteRegisteredInventory(id)
    if RegisteredInventories[id] then
        RegisteredInventories[id] = nil
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
        local id = "zombie:"..entity
        if RegisteredInventories[id] then
            TriggerClientEvent("fivez:LootInventoryCB", source, json.encode(RegisteredInventories[id]))
        else
            TriggerClientEvent("fivez:AddNotification", source, "Inventory doesn't exist!")
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

    --Get closest registered or temp inventory, uses position
    local closestInventory = GetClosestInventory(pedCoords)

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
    checkedClosestObject = nil
    TriggerClientEvent("fivez:CheckClosestObject", source, closestObject)
    while checkedClosestObject == nil do
        Citizen.Wait(0)
    end
    if (not closestInventory) and checkedClosestObject then
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
            closestInventory = RegisterNewInventory("temp:"..checkedClosestObject.model..":"..invCount, "inventory", "Container", weight, maxWeight, maxSlots, containerLoot, objectCoords)
            --Freeze objects position to stop people from moving boxes and creating new loot
            FreezeEntityPosition(closestObject, true)
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
            closestInventory = CreateTempGroundInventory(pedCoords)
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
    TriggerClientEvent("fivez:GetClosestInventoryCB", source, json.encode(closestInventory))
end)

function OpenInventory(inventoryId, source)
    openInventories[inventoryId] = {source}
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
    if identifier == nil then
        local plyChar = GetJoinedPlayer(source).characterData
        local itemData = Config.Items[itemId]
        if not itemData then TriggerClientEvent("fivez:AddNotification", source, "Item doesn't exist!") return end

        if plyChar.inventory.items[slot].itemId == itemId then
            local count = plyChar.inventory.items[slot].count
            local notificationItem = Config.CreateNewItemWithCountQual(plyChar.inventory.items[slot], 1, plyChar.inventory.items[slot].quality)
            TriggerClientEvent("fivez:AddInventoryNotification", source, false, json.encode(notificationItem))
            if count == 1 then
                plyChar.inventory.items[slot] = EmptySlot()
                SQL_RemoveItemFromCharacterInventory(plyChar.Id, slot)
            elseif count > 1 then
                plyChar.inventory.items[slot].count = count - 1
                SQL_UpdateItemCountInCharacterInventory(plyChar.Id, slot, count)
            end
        elseif plyChar.inventory.items[slot].itemId ~= itemId then
            TriggerClientEvent("fivez:AddNotification", source, "Item in slot isn't item you tried to use")
        end
    else
        local registeredInventory = GetInventoryWithId(identifier)

        if registeredInventory then
            if registeredInventory.items[slot].itemId == itemId then
                local count = registeredInventory.items[slot].count
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
                end
            else
                TriggerClientEvent("fivez:AddNotification", source, "Item doesn't exist in the inventory")
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

    if identifier == plyChar.Id then
        if plyChar.inventory.items[fromSlot].itemId == itemId then
            if plyChar.inventory.items[fromSlot].count <= 0 then TriggerClientEvent("fivez:AddNotification", source, "You don't have enough") return end

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
                    GiveWeaponToPed(plyPed, GetHashKey(itemData.model), ammoCount or 0, false, true)
                elseif hands == GetHashKey(itemData.model) then
                    SetPedAmmo(plyPed, GetHashKey(itemData.model), 0.0)
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
                    GiveWeaponToPed(plyPed, GetHashKey(itemData.model), ammoCount or 0, false, true)
                end

                if not holstered then
                    plyChar.inventory.hands = fromSlot
                else
                    plyChar.inventory.hands = -1
                end
            else
                --Normal item with custom functions
                --Check if the item has a client function
                if itemData.clientfunction then
                    TriggerClientEvent("fivez:InventoryUseCB", source, identifier, itemId, fromSlot)
                    Wait(50)
                end
                --Check if the item has a server function
                if itemData.serverfunction then
                    local result = itemData.serverfunction(source, plyChar.inventory.items[fromSlot].quality)
                    if result then
                        TriggerClientEvent("fivez:AddInventoryNotification", source, false, json.encode(plyChar.inventory.items[fromSlot]))
                        if plyChar.inventory.items[fromSlot].count > 1 then
                            plyChar.inventory.items[fromSlot].count = plyChar.inventory.items[fromSlot].count - 1
                            SQL_UpdateItemCountInCharacterInventory(plyChar.Id, fromSlot, plyChar.inventory.items[fromSlot].count)
                        elseif plyChar.inventory.items[fromSlot].count == 1 then
                            plyChar.inventory.items[fromSlot] = EmptySlot()
                            SQL_RemoveItemFromCharacterInventory(plyChar.Id, fromSlot)
                        end
                        TriggerClientEvent("fivez:UpdateCharacterInventoryItems", source, json.encode(plyChar.inventory.items), nil)
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
                if otherInventory.items[fromSlot].count >= 0 then TriggerClientEvent("fivez:AddNotification", source, "Inventory doesn't have enough") return end
                print("Using item from other inventory", itemData.itemId, itemData.label, itemData.serverfunction)
                --Check if the item has a server function
                if itemData.serverfunction then
                    local result = itemData.serverfunction(source)

                    if result then
                        TriggerClientEvent("fivez:AddInventoryNotification", source, false, json.encode(otherInventory.items[fromSlot]))
                        if otherInventory.items[fromSlot].count > 1 then
                            otherInventory.items[fromSlot].count = otherInventory.items[fromSlot].count - 1
                            SQL_UpdateItemCountInPersistentInventory(identifier, fromSlot, otherInventory.items[fromSlot].count)
                        elseif otherInventory.items[fromSlot].count == 1 then
                            otherInventory.items[fromSlot] = EmptySlot()
                            SQL_RemoveItemFromPersistentInventory(identifier, fromSlot)
                        end
                        TriggerClientEvent("fivez:UpdateCharacterInventoryItems", source, nil, json.encode(otherInventory.items))
                    end
                end
                --Check if the item has a client function
                if itemData.clientfunction then
                    TriggerClientEvent("fivez:InventoryUseCB", source, identifier, itemId, fromSlot)
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
                    plyChar.inventory.items[transferData.toSlot].quality = plyChar.inventory.items[transferData.toSlot].quality + plyChar.inventory.items[transferData.fromSlot].quality
                    
                    local leftOverQual = 0
                    if plyChar.inventory.items[transferData.toSlot].quality > 100 then
                        leftOverQual = plyChar.inventory.items[transferData.toSlot].quality - 100 
                        plyChar.inventory.items[transferData.toSlot].quality = 100 
                    end

                    if leftOverQual > 0 then
                        plyChar.inventory.items[transferData.fromSlot].quality = leftOverQual
                    elseif leftOverQual == 0 then
                        plyChar.inventory.items[transferData.fromSlot] = EmptySlot()
                    end

                    --[[ local tempItem = plyChar.inventory.items[transferData.toSlot]
                    plyChar.inventory.items[transferData.toSlot] = Config.CreateNewItemWithData(plyChar.inventory.items[transferData.fromSlot])
                    plyChar.inventory.items[transferData.fromSlot] = Config.CreateNewItemWithData(tempItem) ]]
                elseif plyChar.inventory.items[transferData.toSlot].quality == plyChar.inventory.items[transferData.fromSlot].quality then
                    --Set newCount to, to slot count plus amount transferring
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
                    end
                end
            elseif plyChar.inventory.items[transferData.toSlot].itemId ~= transferData.item.itemId then
                --Item is the exact same
                --Change Id of what we are moving to where we are moving it to
                SQL_ChangeItemSlotIdInCharacterInventory(plyChar.Id, transferData.fromSlot, transferData.toSlot)
                --Change Id of where we moved too where we were
                SQL_ChangeItemSlotIdWithItemIdInCharacterInventory(plyChar.Id, transferData.toSlot, plyChar.inventory.items[transferData.toSlot].itemId, transferData.fromSlot)
                local tempItem = plyChar.inventory.items[transferData.toSlot]
                plyChar.inventory.items[transferData.toSlot] = Config.CreateNewItemWithData(plyChar.inventory.items[transferData.fromSlot])
                plyChar.inventory.items[transferData.fromSlot] = Config.CreateNewItemWithData(tempItem)
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
            --If we got slot moving onto and from
            if slotMovingOnto and slotMovingFrom then
                --Moving onto empty slot
                if slotMovingOnto.model == "empty" then
                    slotMovingOnto = Config.CreateNewItemWithData(slotMovingFrom)
                    slotMovingFrom = EmptySlot()
                    if not string.match(transferData.id, "ground") and not string.match(transferData.id, "zombie") and not string.match(transferData.id, "temp") then
                        SQL_ChangeItemSlotIdInPersistentInventory(transferData.id, transferData.fromSlot, transferData.toSlot)
                    end
                else
                    --Moving onto non empty slot
                    --Moving onto the same item
                    if slotMovingFrom.itemId == slotMovingOnto.itemId then
                        if slotMovingFrom.qualtity ~= slotMovingOnto.quality then
                            local tempItem = slotMovingOnto
                            slotMovingOnto = Config.CreateNewItemWithData(slotMovingFrom)
                            slotMovingFrom = Config.CreateNewItemWithData(tempItem)

                            if not string.match(transferData.id, "ground") and not string.match(transferData.id, "zombie") and not string.match(transferData.id, "temp") then
                                SQL_ChangeItemSlotIdInPersistentInventory(transferData.id, transferData.fromSlot, transferData.toSlot)
                                SQL_ChangeItemSlotIdWithItemIdInPersistentInventory(transferData.id, transferData.toSlot, slotMovingFrom.itemId, transferData.fromSlot)
                            end
                        else
                            local newCount = slotMovingOnto.count + transferData.count
                            if newCount > itemData.maxcount then 
                                newCount = itemData.maxcount
                                transferData.count = newCount - slotMovingFrom.count
                            end
                            slotMovingOnto.count = newCount
                            --Update moving onto slot count
                            SQL_UpdateItemCountInPersistentInventory(transferData.id, transferData.toSlot, newCount)

                            if slotMovingFrom.count == transferData.count then
                                slotMovingFrom = EmptySlot()

                                if not string.match(transferData.id, "ground") and not string.match(transferData.id, "zombie") and not string.match(transferData.id, "temp") then
                                    SQL_RemoveItemFromPersistentInventory(transferData.id, transferData.fromSlot)
                                end
                            elseif slotMovingFrom.count > transferData.count then
                                slotMovingFrom.count = slotMovingFrom.count - transferData.count
                                if not string.match(transferData.id, "ground") and not string.match(transferData.id, "zombie") and not string.match(transferData.id, "temp") then
                                    --Update moving from slot count
                                    SQL_UpdateItemCountInPersistentInventory(transferData.id, transferData.fromSlot, slotMovingFrom.count)
                                end
                            end
                        end
                    elseif slotMovingFrom.itemId ~= slotMovingOnto.itemId then
                        --Not moving onto the same item
                        local tempItem = slotMovingOnto
                        slotMovingOnto = Config.CreateNewItemWithData(slotMovingFrom)
                        slotMovingFrom = Config.CreateNewItemWithData(tempItem)

                        if not string.match(transferData.id, "ground") and not string.match(transferData.id, "zombie") and not string.match(transferData.id, "temp") then
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

        --Player is transferring to own inventory
        if transferData.toId == plyChar.Id then
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
            local swappedItems = false
            
            --Slot transferring onto is empty
            if plySlot.model == "empty" then
                print("Changing ply slot", plySlot.model, invSlot.quality)
                plyChar.inventory.items[transferData.toSlot] = Config.CreateNewItemWithData(invSlot)
                plySlot = plyChar.inventory.items[transferData.toSlot]
                print("Changed ply slot", plySlot.model, plySlot.quality)
                plySlot.count = transferData.count
                SQL_InsertItemToCharacterInventory(plyChar.Id, transferData.toSlot, {id = plySlot.itemId, count = plySlot.count, quality = plySlot.quality, attachments = plySlot.attachments })
            elseif plySlot.itemId == invSlot.itemId then
                --If there is a difference in item quality
                if invSlot.quality ~= plySlot.quality then
                    --Plus the qualities together
                    plySlot.quality = invSlot.quality + plySlot.quality
                    --Check if quality is over 100
                    local leftOverQual = 0
                    if plySlot.quality > 100 then
                        --Find out how much left over quality there is
                        leftOverQual = plySlot.quality - 100
                        plySlot.quality = 100
                    end
                    --Update the item quality in database
                    SQL_UpdateItemQualityInCharacterInventory(plyChar.Id, transferData.toSlot, plySlot.quality)
                    --If there is any left over quality
                    if leftOverQual > 0 then
                        invSlot.quality = leftOverQual
                        SQL_UpdateItemQualityInPersistentInventory(transferData.fromId, transferData.fromSlot, leftOverQual)
                    --If there is no quality left over
                    elseif leftOverQual == 0 then
                        invSlot = EmptySlot()
                        SQL_RemoveItemFromPersistentInventory(transferData.fromId, transferData.fromSlot)
                    end

                    --[[ local tempItem = plySlot
                    plySlot = Config.CreateNewItemWithData(invSlot)
                    invSlot = Config.CreateNewItemWithData(tempItem)

                    if not string.match(transferData.fromId, "ground") and not string.match(transferData.fromId, "zombie") and not string.match(transferData.fromId, "temp") then
                        SQL_RemoveItemFromPersistentInventory(transferData.fromId, transferData.fromSlot)
                        SQL_InsertItemToPersistentInventory(transferData.fromId, transferData.fromSlot, {id = invSlot.itemId, count = invSlot.count, quality = invSlot.quality, attachments = invSlot.attachments})
                    end
                    --Delete the old item from database invenory
                    SQL_RemoveItemFromCharacterInventory(plyChar.Id, transferData.toSlot)
                    --Insert the new item to database inventory
                    SQL_InsertItemToCharacterInventory(plyChar.Id, transferData.toSlot, {id = plySlot.itemId, count = plySlot.count, quality = plySlot.quality, attachments = plySlot.attachments}) ]]
                    
                    swappedItems = true
                else
                    local newCount = plyChar.inventory.items[transferData.toSlot].count + transferData.count
                    if newCount > itemData.maxcount then
                        newCount = itemData.maxcount --New count is the item max count
                        transferData.count = newCount - plyChar.inventory.items[transferData.toSlot].count --The amount we are transferring now is, max count minus cur count
                    end
                    plySlot.count = newCount
                    SQL_UpdateItemCountInCharacterInventory(plyChar.Id, transferData.toSlot, newCount)
                end
            elseif plySlot.itemId ~= invSlot.itemId then
                --Not transferring onto the same item
                --Swap the items around
                local tempItem = plyChar.inventory.items[transferData.toSlot]
                print("DBUG TEMP ITEM: ", tempItem.itemId)
                plyChar.inventory.items[transferData.toSlot] = Config.CreateNewItemWithData(invSlot)
                print("DBUG AFTER TEMP ITEM: ", tempItem.itemId)
                --Remove the item we swapped from database inventory
                SQL_RemoveItemFromCharacterInventory(plyChar.Id, transferData.toSlot)
                --Save item we swapped for in database inventory
                SQL_InsertItemToCharacterInventory(plyChar.Id, transferData.toSlot, {id = plySlot.itemId, count = plySlot.count, quality = plySlot.quality, attachments = plySlot.attachments})
                
                --If transferring from admin menu don't try to swap items
                if transferData.fromId ~= "itemmenu:1" then
                    inventoryTransferringFrom.items[transferData.fromSlot] = Config.CreateNewItemWithData(tempItem)

                    if not string.match(transferData.fromId, "ground") and not string.match(transferData.fromId, "zombie") and not string.match(transferData.fromId, "temp") then
                        --First delete them item we swapped to player inventory
                        SQL_RemoveItemFromPersistentInventory(transferData.fromId, transferData.fromSlot)
                        --Then save the new item to the slot id
                        SQL_InsertItemToPersistentInventory(transferData.fromId, transferData.fromSlot, {id = invSlot.itemId, count = invSlot.count, quality = invSlot.quality, attachments = invSlot.attachments})
                    end
                    swappedItems = true
                end
            end

            --If we didn't swap items and not transferring from admin menu, set containers item slot count
            if not swappedItems and transferData.fromId ~= "itemmenu:1" then
                if invSlot.count == transferData.count then
                    inventoryTransferringFrom.items[transferData.fromSlot] = EmptySlot()
                    invSlot = inventoryTransferringFrom.items[transferData.fromSlot]
                    
                    if (not string.match(transferData.fromId, "ground")) and (not string.match(transferData.fromId, "zombie")) and (not string.match(transferData.fromId, "temp")) then
                        SQL_RemoveItemFromPersistentInventory(transferData.fromId, transferData.fromSlot)
                    end
                elseif invSlot.count > transferData.count then
                    inventoryTransferringFrom.items[transferData.fromSlot].count = invSlot.count - transferData.count
                    invSlot = inventoryTransferringFrom.items[transferData.fromSlot]
                    if not string.match(transferData.fromId, "ground") and not string.match(transferData.fromId, "zombie") and not string.match(transferData.fromId, "temp") then
                        SQL_UpdateItemCountInPersistentInventory(transferData.fromId, transferData.fromSlot, invSlot.count)
                    end
                end
            end

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
            --Player is transferring out of own inventory
            local plySlot = plyChar.inventory.items[transferData.fromSlot]
            --Check character has enough of the item in the slot or if the character has less than the amount trying to be transfered
            if plySlot.count <= 0 or plySlot.count < transferAmount then TriggerClientEvent("fivez:AddNotification", source, "You don't have enough!") return end
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
                if (not string.match(transferData.toId, "ground")) and (not string.match(transferData.toId, "zombie")) and (not string.match(transferData.toId, "temp")) then
                    SQL_InsertItemToPersistentInventory(transferData.toId, transferData.toSlot, {id = invSlot.itemId, count = invSlot.count, quality = invSlot.quality, attachments = invSlot.attachments})
                end
                SQL_RemoveItemFromCharacterInventory(plyChar.Id, transferData.fromSlot)
            elseif invSlot.itemId == plySlot.itemId then
                --If we are transferring onto the exact same item
                --If the quality from the item slot where we are transferrinmg from is not the same as the slot we are transferring to
                if plySlot.quality ~= invSlot.quality then
                    invSlot.quality = invSlot.quality + plySlot.quality

                    local leftOverQual = 0
                    if invSlot.quality > 100 then
                        leftOverQual = invSlot.quality - 100
                        invSlot.quality = 100
                    end
                    SQL_UpdateItemQualityInPersistentInventory(transferData.toId, transferData.toSlot, invSlot.quality)
                    if leftOverQual > 0 then
                        plySlot.quality = leftOverQual
                        SQL_UpdateItemQualityInCharacterInventory(plyChar.Id, transferData.fromSlot, leftOverQual)
                    elseif leftOverQual == 0 then
                        plySlot = EmptySlot()
                        SQL_RemoveItemFromCharacterInventory(plyChar.Id, transferData.fromSlot)
                    end
                    --[[ local tempItem = invSlot
                    inventoryTransferringTo.items[transferData.toSlot] = Config.CreateNewItemWithData(plySlot)
                    invSlot = inventoryTransferringTo.items[transferData.toSlot]
                    plyChar.inventory.items[transferData.fromSlot] = Config.CreateNewItemWithData(tempItem) 
                    plySlot = plyChar.inventory.items[transferData.fromSlot]

                    if not string.match(transferData.toId, "ground") and not string.match(transferData.toId, "zombie") and not string.match(transferData.toId, "temp") then
                        SQL_RemoveItemFromPersistentInventory(transferData.toId, transferData.toSlot)
                        SQL_InsertItemToPersistentInventory(transferData.toId, transferData.toSlot, {id = invSlot.itemId, count = invSlot.count, quality = invSlot.quality, attachments = invSlot.attachments})
                    end

                    SQL_RemoveItemFromCharacterInventory(plyChar.Id, transferData.fromSlot)
                    SQL_InsertItemToCharacterInventory(plyChar.Id, transferData.fromSlot, {id = plySlot.itemId, count = plySlot.count, quality = plySlot.quality, attachments = plySlot.attachments }) ]]
                else
                    --Transferring the exact same item and their quality is the same
                    local newCount = invSlot.count + transferData.count

                    if newCount > itemData.maxcount then
                        newCount = itemData.maxcount
                        transferData.count = newCount - invSlot.count
                    end
                    inventoryTransferringTo.items[transferData.toSlot].count = newCount
                    invSlot = inventoryTransferringTo.items[transferData.toSlot]
                    if not string.match(transferData.toId, "ground") and not string.match(transferData.toId, "zombie") and not string.match(transferData.toId, "temp") then
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
                    end
                end
            elseif invSlot.itemId ~= plySlot.itemId then
                --Transferring onto a different item
                local tempItem = invSlot
                inventoryTransferringTo.items[transferData.toSlot] = Config.CreateNewItemWithData(plySlot)
                invSlot = inventoryTransferringTo.items[transferData.toSlot]
                plyChar.inventory.items[transferData.fromSlot] = Config.CreateNewItemWithData(tempItem)
                plySlot = plyChar.inventory.items[transferData.fromSlot]

                if not string.match(transferData.toId, "ground") and not string.match(transferData.toId, "zombie") and not string.match(transferData.toId, "temp") then
                    SQL_RemoveItemFromPersistentInventory(transferData.toId, transferData.toSlot)
                    SQL_InsertItemToPersistentInventory(transferData.toId, transferData.toSlot, {id = invSlot.itemId, count = invSlot.count, quality = invSlot.quality, attachments = invSlot.attachments})
                end
                SQL_RemoveItemFromCharacterInventory(plyChar.Id, transferData.fromSlot)
                SQL_InsertItemToCharacterInventory(plyChar.Id, transferData.fromSlot, {id = plySlot.itemId, count = plySlot.count, quality = plySlot.quality, attachments = plySlot.attachments})
            end

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
        table.insert(items, {label = "Empty", model = "empty", weight = 0, count = 0, maxcount = 0, quality = 0, attachments = {}})
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