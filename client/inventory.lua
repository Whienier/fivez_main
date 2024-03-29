local inventories = {}
inventoryOpen = false

function ClearInventoryMarkers()
    inventories = {}
    TriggerServerEvent("fivez:SyncMarkers")
end
RegisterNetEvent("fivez:LoadInventoryMarkers", function(markers)
    inventories = json.decode(markers)
end)
RegisterNetEvent("fivez:AddGroundMarker", function(position)
    position = json.decode(position)
    table.insert(inventories, vector3(position.x, position.y, position.z))
end)
Citizen.CreateThread(function()
    while true do
        while not startThreads do Citizen.Wait(1) end
        while not NetworkIsPlayerActive(PlayerId()) do Citizen.Wait(1) end
        TriggerServerEvent("fivez:SyncMarkers")
        Citizen.Wait(15000)
    end
end)
RegisterNetEvent("fivez:SyncMarkersCB", function(encodedMarkers)
    local decodedMarkers = json.decode(encodedMarkers)
    inventories = {}
    for k,v in pairs(decodedMarkers) do
        table.insert(inventories, vector3(v.x, v.y, v.z))
    end
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
        Citizen.Wait(0)
    end
end)
--TODO: Optimize this as it slowly increases CPU usage, maybe have a hard cap or only send ones close to the player
--Draws little green markers where inventories are
Citizen.CreateThread(function()
    while true do
        --If there are inventories to draw and we aren't in a vehicle or dead
        if #inventories >= 1 and (not IsPedInAnyVehicle(PlayerPedId(), false) or GetEntityHealth(GetPlayerPed(-1)) <= 0) then
            local pedCoords = GetEntityCoords(GetPlayerPed(-1))
            for k,v in pairs(inventories) do
                if v ~= nil then
                    if v.x ~= nil and v.y ~= nil and v.z ~= nil then
                        local dist = #(v - pedCoords)
                        if dist <= 15 then
                            DrawMarker(3, v.x, v.y, v.z-0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.25, 0.1, 0.25, 0, 255, 0, 255, true, true, 2, true, NULL, NULL, false)
                        end
                    end
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

--Removing attachment from weapon
RegisterNUICallback("inventory_removeattach", function(data, cb)
    local identifier = data.identifier
    local attachmentModel = data.attachmentModel
    local item = data.item
    local itemSlot = data.itemIndex
    if identifier == "itemmenu:1" then return end
    local attachmentInfo = {
        id = identifier,
        item = item,
        slot = itemSlot,
        attachmentModel = attachmentModel
    }
    TriggerServerEvent("fivez:RemoveAttachment", json.encode(attachmentInfo))
    cb('ok')
end)

RegisterNUICallback("inventory_purchase", function(data, cb)
    TriggerServerEvent("fivez:InventoryPurchase", json.encode(data))
    cb('ok')
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

function CloseInventory()
    SetNuiFocus(false, false)
    TriggerServerEvent("fivez:CloseInventory")
    inventoryOpen = false
    SendNUIMessage({
        type = "message",
        message = "closeInventory"
    })
end

local otherInventory = nil

RegisterNetEvent("fivez:UpdateCharacterInventoryItems", function(charInventoryItems, otherInventoryItems)
    if charInventoryItems ~= nil then
        local updatedItems = json.decode(charInventoryItems)
        if updatedItems then
            print(updatedItems[1].model)
            UpdateCharacterInventoryItems(updatedItems)
        end
    end
    local charInventory = GetCharacterInventory()
    charInventory.weight = 0
    for k,v in pairs(charInventory.items) do
        if v.model ~= "empty" then
            charInventory.weight = charInventory.weight + v.weight
        end
    end

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
    local closestObject = GetClosestLootableContainer(GetEntityCoords(GetPlayerPed(-1)))
    print("Checking object status", object, closestObject)
    if closestObject == object then
        FreezeEntityPosition(closestObject, true)
        TriggerServerEvent("fivez:CheckClosestObjectCB", json.encode({pos = GetEntityCoords(closestObject), model = GetEntityModel(closestObject)}))
    else
        TriggerServerEvent("fivez:CheckClosestObjectCB", json.encode(false))
    end
end)

local lowPerformance = true

--Loop to draw 3D text on lootable container objects
Citizen.CreateThread(function()
    while true do
        if not lowPerformance then
            for k,object in pairs(GetGamePool("CObject")) do
                local netId = NetworkGetNetworkIdFromEntity(object)
                if NetworkDoesEntityExistWithNetworkId(netId) then
                    for k,v in pairs(Config.LootableContainers) do
                        if k == GetEntityModel(object) then
                            local objectCoords = GetEntityCoords(object)
                            if #(objectCoords - GetEntityCoords(GetPlayerPed(-1))) <= Config.ContainerMarkerDrawDistance then
                                Draw3DText(objectCoords.x, objectCoords.y, objectCoords.z - 0.5, "Open Lootable Container", 4, 0.1, 0.1)
                            end
                        end
                    end
                end
            end
        else
            local plyCoords = GetEntityCoords(GetPlayerPed(-1))
            local closestContainer = GetClosestLootableContainer(plyCoords)
            if closestContainer ~= nil then
                local netId = NetworkGetNetworkIdFromEntity(closestContainer)
                if NetworkDoesEntityExistWithNetworkId(netId) then
                    local objectCoords = GetEntityCoords(closestContainer)
                    if #(objectCoords - plyCoords) <= Config.ContainerMarkerDrawDistance then
                        Draw3DText(objectCoords.x, objectCoords.y, objectCoords.z - 0.5, "Open Lootable Container", 4, 0.1, 0.1)
                    end
                end
            end
        end
        Citizen.Wait(1)
    end
end)

RegisterCommand("lowperformance", function()
    lowPerformance = not lowPerformance
    local status = "disabled"
    if lowPerformance then
        status = "enabled"
    end
    TriggerEvent("fivez:AddNotification", "Low Performance:"..status)
end, false)

function GetClosestLootableContainer(plyCoords)
    for k,v in pairs(Config.LootableContainers) do
        local object = GetClosestObjectOfType(plyCoords.x, plyCoords.y, plyCoords.z, 20.0, k, true, true, true, false)
        if DoesEntityExist(object) then
            return object
        end
    end

    return nil
end
--Event for playing holster animation
RegisterNetEvent("fivez:PlayUnholsterAnimation", function()
    RequestAnimDict("reaction@intimidation@1h")
    while not HasAnimDictLoaded("reaction@intimidation@1h") do
        RequestAnimDict("reaction@intimidation@1h")
        Citizen.Wait(1)
    end
    TaskPlayAnim(GetPlayerPed(-1), "reaction@intimidation@1h", "intro", 5.0, 1.0, 500, 50, 0, 0, 0, 0)
end)
--Event for playing unholster animation
RegisterNetEvent("fivez:PlayHolsterAnimation", function()
    RequestAnimDict("reaction@intimidation@1h")
    while not HasAnimDictLoaded("reaction@intimidation@1h") do
        RequestAnimDict("reaction@intimidation@1h")
        Citizen.Wait(1)
    end
    TaskPlayAnim(GetPlayerPed(-1), "reaction@intimidation@1h", "outro", 5.0, 1.0, 500, 50, 0, 0, 0, 0)
end)
--Event for playing animation when player drops an item
RegisterNetEvent("fivez:PlayDroppedItemAnimation", function()
    RequestAnimDict("pickup_object")
    while not HasAnimDictLoaded("pickup_object") do
        RequestAnimDict("pickup_object")
        Citizen.Wait(1)
    end
    TaskPlayAnim(GetPlayerPed(-1), "pickup_object", "putdown_low", 5.0, 1.0, 500, 50, 0, 0, 0, 0)
end)

RegisterNetEvent("fivez:PlayReloadAnimation", function()
    RequestAnimDict("weapons@pistol_1h@pistol_1h_str")
    while not HasAnimDictLoaded("weapons@pistol_1h@pistol_1h_str") do
        RequestAnimDict("weapons@pistol_1h@pistol_1h_str")
        Citizen.Wait(1)
    end
    TaskPlayAnim(GetPlayerPed(-1), "weapons@pistol_1h@pistol_1h_str", "reload_aim", 8.0, -8.0, 1.0, 50, 0.0, 0, 0, 0)
    Citizen.Wait(2500)
    ClearPedTasks(GetPlayerPed(-1))
end)

RegisterNetEvent("fivez:PlayBurgerEatingAnimation", function()
    RequestAnimDict("mp_player_inteat@burger")
    while not HasAnimDictLoaded("mp_player_inteat@burger") do
        RequestAnimDict("mp_player_inteat@burger")
        Citizen.Wait(1)
    end
    TaskPlayAnim(GetPlayerPed(-1), "mp_player_inteat@burger", "mp_player_int_eat_burger_fp", 8.0, -8.0, 1.0, 49, 0.0, 0, 0, 0)
    Citizen.Wait(2000)
    ClearPedTasks(GetPlayerPed(-1))
end)

RegisterNetEvent("fivez:PlayBagEatingAnimation", function()
    RequestAnimDict("mp_player_inteat@pnq")
    while not HasAnimDictLoaded("mp_player_inteat@pnq") do
        RequestAnimDict("mp_player_inteat@pnq")
        Citizen.Wait(1)
    end
    TaskPlayAnim(GetPlayerPed(-1), "mp_player_inteat@pnq", "loop_fp", 8.0, -8.0, 1.0, 49, 0.0, 0, 0, 0)
    Citizen.Wait(2000)
    ClearPedTasks(GetPlayerPed(-1))
end)

RegisterNetEvent("fivez:PlayDrinkingAnimation", function()
    RequestAnimDict("mp_player_intdrink")
    while not HasAnimDictLoaded("mp_player_intdrink") do
        RequestAnimDict("mp_player_intdrink")
        Citizen.Wait(1)
    end
    TaskPlayAnim(GetPlayerPed(-1), "mp_player_intdrink", "loop_bottle", 8.0, -8.0, 1.0, 49, 0.0, 0, 0, 0)

    Citizen.Wait(2000)
    ClearPedTasks(GetPlayerPed(-1))
    print("played drinking animation")
end)

RegisterCommand("+inventory", function()
    if GetEntityHealth(PlayerPedId()) <= 0 then return end
    local charInventory = GetCharacterInventory()
    
    local closestLootableContainer = GetClosestLootableContainer(GetEntityCoords(GetPlayerPed(-1)))

    otherInventory = nil
    TriggerServerEvent("fivez:GetClosestInventory", closestLootableContainer)

    while otherInventory == nil do
        Citizen.Wait(0)
    end
    FreezeEntityPosition(closestLootableContainer, true)
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
            type = "combining",
            identifier = "combining",
            label = "Item Combining"
        }
    })
    SetNuiFocus(true, true)
end)

RegisterNUICallback("combine_items", function(data, cb)
    local firstSlotId = data.firstSlotId + 1
    local secondSlotId = data.secondSlotId + 1
    local slotDraggedOnto = data.slotDraggedOnto + 1

    local charInventory = GetCharacterInventory()

    local firstItem = charInventory.items[firstSlotId]
    local secondItem = charInventory.items[secondSlotId]

    if firstItem.model == "empty" or secondItem.model == "empty" then AddNotification("Can't combine empty slots!") return end
    if firstItem.itemId ~= secondItem.itemId then AddNotification("Can't combine different items ("..firstItem.model.." "..secondItem.model.."!") return end

    TriggerServerEvent("fivez:AttemptCombine", firstSlotId, secondSlotId, slotDraggedOnto)
    cb('ok')
end)