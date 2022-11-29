local inventories = {}
inventoryOpen = false

RegisterNetEvent("fivez:LoadInventoryMarkers", function(markers)
    inventories = json.decode(markers)
end)
RegisterNetEvent("fivez:AddGroundMarker", function(position)
    position = json.decode(position)
    table.insert(inventories, {pos = position})
end)
RegisterNetEvent("fivez:RemoveGroundMarker", function(position)
    position = json.decode(position)
    for k,v in pairs(inventories) do
        if v.pos == position then
            table.remove(inventories, k)
        end
    end
end)
--Draw text over ped dead bodies
Citizen.CreateThread(function()
    while true do
        local plyCoords = GetEntityCoords(GetPlayerPed(-1))
        for k,v in pairs(GetGamePool("CPed")) do
            if GetEntityHealth(v) >= 1 then goto skip end
            local pedCoords = GetEntityCoords(v)
            local dist = #(plyCoords - pedCoords)
            if dist <= Config.ContainerMarkerDrawDistance then
                Draw3DText(pedCoords.x, pedCoords.y, pedCoords.z-0.25, "Open Lootable Body", 4, 0.1, 0.1)
            end
            ::skip::
        end
        for k,v in pairs(GetActivePlayers()) do
            local targetPed = GetPlayerPed(v)
            if GetEntityHealth(targetPed) <= 0 then
                local targetCoords = GetEntityCoords(targetPed)
                local dist = #(targetCoords - plyCoords)
                if dist <= Config.ContainerMarkerDrawDistance then
                    Draw3DText(targetCoords.x, targetCoords.y, targetCoords.z-0.25, "Open Dead Player", 4, 0.1, 0.1)
                end
            end
        end
        Citizen.Wait(0)
    end
end)
--Draws little green markers where inventories are
Citizen.CreateThread(function()
    while true do
        if #inventories >= 1 then
            for k,v in pairs(inventories) do
                if v.pos ~= nil then
                    DrawMarker(3, v.pos.x, v.pos.y, v.pos.z-0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.25, 0.1, 0.25, 0, 255, 0, 255, true, true, 2, true, NULL, NULL, false)
                end
            end
        end
        Citizen.Wait(0)
    end
end)
RegisterNetEvent("fivez:UpdateInventoryItemQuality", function(slot, newQual)
    local charInv = GetCharacterInventory()
    if charInv then
        charInv.items[slot].quality = newQual
    end
end)

--Moving items inside inventory
RegisterNUICallback("inventory_move", function(data, cb)
    local identifier = data.identifier
    local fromSlot = data.fromIndex
    local toSlot = data.toIndex
    local count = data.count
    local item = data.item
    local moveData = {
        id = identifier,
        fromSlot = fromSlot,
        toSlot = toSlot,
        count = count,
        item = item
    }
    --If player is trying to move items around in the admin item menu
    if identifier == "itemmenu:1" then return end
    TriggerServerEvent('fivez:InventoryMove', json.encode(moveData))
    cb("ok")
end)

--Moving items across inventories
RegisterNUICallback("inventory_transfer", function(data, cb)
    --Inventory moving from
    local fromIdentifier = data.fromIdentifier
    --Inventory moving to
    local toIdentifier = data.toIdentifier
    --Item count moving across
    local count = data.count
    --Item moving across
    local item = data.item
    --Slot moving from
    local fromSlot = data.fromIndex
    --Slot moving to
    local toSlot = data.toIndex

    local transferData = {
        fromId = fromIdentifier,
        toId = toIdentifier,
        count = count,
        item = item,
        fromSlot = fromSlot,
        toSlot = toSlot
    }
    --If player is trying to transfer to admin item menu
    if toIdentifier == "itemmenu:1" then return end
    TriggerServerEvent("fivez:InventoryTransfer", json.encode(transferData))
    cb('ok')
end)

RegisterNUICallback("close_inventory", function(data, cb)
    SetNuiFocus(false, false)
    TriggerServerEvent("fivez:CloseInventory")
    inventoryOpen = false
    cb('ok')
end)

local otherInventory = nil

RegisterNetEvent("fivez:UpdateCharacterInventoryItems", function(charInventoryItems, otherInventoryItems)
    local updatedItems = json.decode(charInventoryItems)
    if updatedItems then
        print(updatedItems[1].model)
        UpdateCharacterInventoryItems(updatedItems)
    end
    local charInventory = GetCharacterInventory()

    if otherInventoryItems ~= nil then
        otherInventory.items = json.decode(otherInventoryItems)

        SendNUIMessage({
            type = "message",
            message = "refreshInventory",
            playerInventory = {
                type = "inventory",
                identifier = charInventory.Id,
                label = "Inventory",
                weight = charInventory.weight, --TODO: Calculate weight
                maxWeight = charInventory.maxWeight,
                maxSlots = charInventory.slots,
                items = charInventory.items
            },
            otherInventory = {
                type = otherInventory.type or "inventory",
                identifier = otherInventory.id,
                label = otherInventory.label,
                weight = otherInventory.weight,
                maxWeight = otherInventory.maxWeight,
                maxSlots = otherInventory.maxSlots,
                items = otherInventory.items
            }
        })
    elseif otherInventoryItems == nil then
        SendNUIMessage({
            type = "message",
            message = "refreshInventory",
            playerInventory = {
                type = "inventory",
                identifier = charInventory.Id,
                label = "Inventory",
                weight = charInventory.weight, --TODO: Calculate weight
                maxWeight = charInventory.maxWeight,
                maxSlots = charInventory.slots,
                items = charInventory.items
            }
        })
    end
end)

RegisterNetEvent("fivez:LootInventoryCB", function(inventoryData)
    otherInventory = json.decode(inventoryData)
    if otherInventory then
        local charInventory = GetCharacterInventory()
        
        SendNUIMessage({
            type = "message",
            message = "openInventory",
            playerInventory = {
                type = "inventory",
                identifier = charInventory.Id,
                label = "Inventory",
                weight = charInventory.weight, --TODO: Calculate weight
                maxWeight = charInventory.maxWeight,
                maxSlots = charInventory.slots,
                items = charInventory.items
            },
            otherInventory = {
                type = otherInventory.type or "inventory",
                identifier = otherInventory.identifier,
                label = otherInventory.label,
                weight = otherInventory.weight,
                maxWeight = otherInventory.maxWeight,
                maxSlots = otherInventory.maxSlots,
                items = otherInventory.items
            }
        })
        SetNuiFocus(true, true)
    end
end)

RegisterNetEvent("fivez:GetClosestInventoryCB", function(closestInventoryData)
    otherInventory = json.decode(closestInventoryData)
end)

RegisterNetEvent("fivez:CheckClosestObject", function(object)
    local dist, closestObject = GetClosestLootableContainer()
    print("Checking object status", object, closestObject)
    if closestObject == object then
        FreezeEntityPosition(closestObject, true)
        TriggerServerEvent("fivez:CheckClosestObjectCB", json.encode({pos = GetEntityCoords(closestObject), model = GetEntityModel(closestObject)}))
    else
        TriggerServerEvent("fivez:CheckClosestObjectCB", json.encode(false))
    end
end)

--Loop to draw 3D text on lootable container objects
Citizen.CreateThread(function()
    while true do
        local allObjects = GetGamePool("CObject")

        for k,object in pairs(allObjects) do
            for k,v in pairs(Config.LootableContainers) do
                if k == GetEntityModel(object) then
                    local objectCoords = GetEntityCoords(object)
                    if #(objectCoords - GetEntityCoords(GetPlayerPed(-1))) <= Config.ContainerMarkerDrawDistance then
                        Draw3DText(objectCoords.x, objectCoords.y, objectCoords.z - 0.5, "Open Lootable Container", 4, 0.1, 0.1)
                    end
                end
            end
        end
        Citizen.Wait(0)
    end
end)

function GetClosestLootableContainer()
    local plyCoords = GetEntityCoords(GetPlayerPed(-1))
    local dist = -1
    local closestObject = nil
    for k,object in pairs(GetGamePool("CObject")) do
        for k,v in pairs(Config.LootableContainers) do
            if GetEntityModel(object) == k then
                local distance = #(plyCoords - GetEntityCoords(object))
                if dist == -1 or dist < distance then
                    dist = distance
                    closestObject = object
                end
            end
        end
    end
    
    return dist, closestObject

--[[     for k,v in pairs(Config.LootableContainers) do
        local object = GetClosestObjectOfType(plyCoords.x, plyCoords.y, plyCoords.z, 20.0, k, true, true, true, false)
        if DoesEntityExist(object) then
            return object
        end
    end

    return nil ]]
end

RegisterCommand("+inventory", function()
    if GetEntityHealth(PlayerPedId()) <= 0 then return end
    local charInventory = GetCharacterInventory()
    
    local dist, closestLootableContainer = GetClosestLootableContainer()

    otherInventory = nil
    TriggerServerEvent("fivez:GetClosestInventory", closestLootableContainer)

    while otherInventory == nil do
        Citizen.Wait(0)
    end
    FreezeEntityPosition(closestLootableContainer, true)
    print("Open inventory", closestLootableContainer)
    charInventory.weight = 0
    for k,v in pairs(charInventory.items) do
        if v.model ~= "empty" then
            charInventory.weight = charInventory.weight + v.weight
        end
    end
    SendNUIMessage({
        type = "message",
        message = "openInventory",
        playerInventory = {
            type = "inventory",
            identifier = charInventory.Id,
            label = "Inventory",
            weight = charInventory.weight,
            maxWeight = charInventory.maxWeight,
            maxSlots = charInventory.slots,
            items = charInventory.items
        },
        otherInventory = {
            type = otherInventory.type or "inventory",
            identifier = otherInventory.identifier,
            label = otherInventory.label,
            weight = otherInventory.weight,
            maxWeight = otherInventory.maxWeight,
            maxSlots = otherInventory.maxSlots,
            items = otherInventory.items
        }
    })
    SetNuiFocus(true, true)
    inventoryOpen = true
end, false)
RegisterCommand("-inventory", function() end, false)

RegisterKeyMapping("+inventory", "Opens Inventory", "keyboard", "i")

RegisterNetEvent("fivez:OpenItemMenu", function(itemmenuData)
    local charInventory = GetCharacterInventory()
    otherInventory = json.decode(itemmenuData)

    SendNUIMessage({
        type = "message",
        message = "openInventory",
        playerInventory = {
            type = "inventory",
            identifier = charInventory.Id,
            label = "Inventory",
            weight = charInventory.weight,
            maxWeight = charInventory.maxWeight,
            maxSlots = charInventory.slots,
            items = charInventory.items
        },
        otherInventory = {
            type = otherInventory.type,
            identifier = otherInventory.identifier,
            label = otherInventory.label,
            weight = otherInventory.weight,
            maxWeight = otherInventory.maxWeight,
            maxSlots = otherInventory.maxSlots,
            items = otherInventory.items
        }
    })
    SetNuiFocus(true, true)
end)

RegisterNetEvent("fivez:VehicleTrunkPos", function(veh)
    local vehicle = NetworkGetEntityFromNetworkId(veh)
    if DoesEntityExist(vehicle) then
        local forwardX = GetEntityForwardX(vehicle)
        local forwardY = GetEntityForwardY(vehicle)
        TriggerServerEvent("fivez:VehicleTrunkPosCB", json.encode({x = forwardX, y = forwardY}))
        return
    end
    TriggerServerEvent("fivez:VehicleTrunkPosCB", json.encode(nil))
end)

RegisterNetEvent("fivez:InventoryUseCB", function(identifier, itemId, slot)
    local charInventory = GetCharacterInventory()
    local itemData = Config.Items[itemId]
    if not itemData then print("Item trying to use doesn't exist!") return end
    if charInventory.items[slot].itemId == itemId then
        if itemData.clientfunction then
            local result = itemData.clientfunction()

            if result then
                TriggerServerEvent("fivez:ItemUsed", itemId, slot)
            end
        else
            print("DEBUG: Item doesn't have client function")
        end
    elseif charInventory.items[slot].model == "empty" then
        AddNotification("Slot you're trying to use is empty!")
    elseif charInventory.items[slot].itemId ~= itemId then
        AddNotification("Item you are trying to use doesn't exist in that slot")
    else
        AddNotification("Something went wrong")
    end
end)

RegisterNUICallback("inventory_useItem", function(data, cb)
    local fromIdentifier = data.fromIdentifier
    local item = data.item
    local fromSlot = data.fromIndex

    TriggerServerEvent("fivez:InventoryUse", fromIdentifier, item.itemId, fromSlot)

    cb('ok')
end)
--Fast slot 1
RegisterCommand("+fastslot1", function()
    if GetEntityHealth(PlayerPedId()) <= 0 then return end

    local hotkeyItems = {}
    local charInventory = GetCharacterInventory()
    for i=0,4 do
        table.insert(hotkeyItems, charInventory.items[i])
    end
    SendNUIMessage({
        type = "message",
        message = "pressHotkey",
        index = 1,
        hotkeyItems = hotkeyItems
    })
    TriggerServerEvent("fivez:InventoryUse", charInventory.Id, charInventory.items[1].itemId, 1)
end, false)
RegisterCommand("-fastslot1", function() end, false)
RegisterKeyMapping("+fastslot1", "Uses item in first fast slot", "keyboard", "1")

--Fast slot 2
RegisterCommand("+fastslot2", function()
    if GetEntityHealth(PlayerPedId()) <= 0 then return end

    local hotkeyItems = {}
    local charInventory = GetCharacterInventory()
    for i=0,4 do
        table.insert(hotkeyItems, charInventory.items[i])
    end
    SendNUIMessage({
        type = "message",
        message = "pressHotkey",
        index = 2,
        hotkeyItems = hotkeyItems
    })
    TriggerServerEvent("fivez:InventoryUse", charInventory.Id, charInventory.items[2].itemId, 2)
end, false)
RegisterCommand("-fastslot2", function() end, false)
RegisterKeyMapping("+fastslot2", "Uses item in second fast slot", "keyboard", "2")

--Fast slot 3
RegisterCommand("+fastslot3", function()
    if GetEntityHealth(PlayerPedId()) <= 0 then return end

    local hotkeyItems = {}
    local charInventory = GetCharacterInventory()
    for i=0,4 do
        table.insert(hotkeyItems, charInventory.items[i])
    end
    SendNUIMessage({
        type = "message",
        message = "pressHotkey",
        index = 3,
        hotkeyItems = hotkeyItems
    })
    TriggerServerEvent("fivez:InventoryUse", charInventory.Id, charInventory.items[3].itemId, 3)
end, false)
RegisterCommand("-fastslot3", function() end, false)
RegisterKeyMapping("+fastslot3", "Uses item in third fast slot", "keyboard", "3")

--Fast slot 4
RegisterCommand("+fastslot4", function()
    if GetEntityHealth(PlayerPedId()) <= 0 then return end

    local hotkeyItems = {}
    local charInventory = GetCharacterInventory()
    for i=0,4 do
        table.insert(hotkeyItems, charInventory.items[i])
    end
    SendNUIMessage({
        type = "message",
        message = "pressHotkey",
        index = 4,
        hotkeyItems = hotkeyItems
    })
    TriggerServerEvent("fivez:InventoryUse", charInventory.Id, charInventory.items[4].itemId, 4)
end, false)
RegisterCommand("-fastslot4", function() end, false)
RegisterKeyMapping("+fastslot4", "Uses item in fourth fast slot", "keyboard", "4")


RegisterCommand("craft", function()
    local charInventory = GetCharacterInventory()
    SendNUIMessage({
        type = "message",
        message = "openInventory",
        playerInventory = {
            type = "inventory",
            identifier = charInventory.Id,
            label = "Inventory",
            weight = charInventory.weight,
            maxWeight = charInventory.maxWeight,
            maxSlots = charInventory.slots,
            items = charInventory.items
        },
        otherInventory = {
            type = "crafting",
            identifier = "inventorycrafting",
            label = "Inventory Crafting",
            recipes = Config.Recipes
        }
    })
    SetNuiFocus(true, true)
end, false)

RegisterNUICallback("craft", function(data, cb)
    print("Craft item")
    local identifier = data.identifier
    local recipe = data.recipe
    for k,v in pairs(recipe) do
        print(k,v)
    end
    for k,v in pairs(Config.Recipes) do
        if v.model == recipe.model then
            print("Found recipe to craft")
            --Tell the server we are trying to craft this recipe
            TriggerServerEvent("fivez:AttemptCraft", k)
        end
    end
    cb('ok')
end)

RegisterCommand("combine", function()
    SendNUIMessage({
        type = "message",
        message = "openInventory",
        playerInventory = {

        },
        otherInventory = {
            type = "combining",
            identifier = "combining",
            label = "Inventory Combining"
        }
    })
    SetNuiFocus(true, true)
end)

RegisterNUICallback("combine", function(data, cb)

    cb('ok')
end)