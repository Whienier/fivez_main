local persistentCrates = {}

MySQL.ready(function()
    MySQL.Async.fetchAll("SELECT * FROM persistent_crates", {}, function(result)
        if result[1] then
            for k,v in pairs(result) do
                persistentCrates[v.persistent_cratesid] = {
                    id = v.persistent_cratesid,
                    label = v.crate_label,
                    model = v.crate_model,
                    position = json.decode(v.crate_position),
                    health = v.crate_health,
                    inventory = {
                        label = v.crate_label,
                        identifier = v.crate_model..":"..v.persistent_cratesid,
                        maxSlots = v.crate_maxslots,
                        maxWeight = v.crate_maxweight,
                        weight = 0,
                        items = {}
                    }
                }

                persistentCrates[v.persistent_cratesid].inventory.items = SQL_GetPersistentInventoryItems(v.persistent_cratesid, persistentCrates[v.persistent_cratesid].items)
                local persistentCrateInv = persistentCrates[v.persistent_cratesid].inventory
                RegisterNewInventory(persistentCrateInv.identifier, "inventory", persistentCrateInv.label, persistentCrateInv.maxWeight, persistentCrateInv.maxSlots, persistentCrateInv.items, persistentCrates[v.persistent_cratesid].position)
            end
        end
    end)
end)

function SQL_CreatePersistentCrate(label, model, position, health, maxslots, maxweight)
    local createdCrate = nil
    MySQL.ready(function()
        MySQL.Async.insert("INSERT INTO persistent_crates (crate_label, crate_model, crate_position, crate_health, crate_maxslots, crate_maxweight) VALUES (@label, @model, @position, @health, @maxslots, @maxweight)", {
            ["label"] = label,
            ["model"] = model,
            ["position"] = json.encode(position),
            ["health"] = health,
            ["maxslots"] = maxslots,
            ["maxweight"] = maxweight
        }, function(result)
            if result > 0 then
                createdCrate = true
                --Register the crate into memory
                persistentCrates[result] = {
                    id = result,
                    label = label,
                    model = model,
                    position = position,
                    health = health,
                    inventory = {
                        label = label,
                        identifier = model..":"..result,
                        maxSlots = maxslots,
                        maxWeight = maxweight,
                        weight = 0,
                        items = InventoryFillEmpty(maxSlots)
                    }
                }
                --After it's created in DB, register an inventory for it
                RegisterNewInventory(model..":"..result, "inventory", label, maxweight, maxslots, InventoryFillEmpty(maxslots), position)
            else
                createdCrate = false
            end
        end)
    end)
    while createdCrate == nil do
        Citizen.Wait(0)
    end
    return createdCrate
end
--crateId can also be vehicle id, like glovebox:[numberplate] or trunk:[numberplate]
function SQL_GetPersistentInventoryItems(crateId, items)
    MySQL.ready(function()
        MySQL.Async.fetchAll("SELECT * FROM persistent_inventory_items WHERE persistent_id = @crateId", {
            ["crateId"] = crateId
        }, function(result)
            if result[1] then
                for k,res in pairs(result) do
                    for k,v in pairs(Config.Items) do
                        if k == res.item_id then
                            items[res.item_slotid] = {
                                itemId = k,
                                label = v.label,
                                model = v.model,
                                weight = v.weight,
                                maxcount = v.maxcount,
                                count = res.item_count,
                                quality = res.item_quality
                            }
                        end
                    end
                end

                return items
            end
            return items
        end)
    end)
end

function SQL_ChangeItemSlotIdInPersistentInventory(persistentId, oldSlot, newSlot)
    local changedItemSlot = nil
    MySQL.ready(function()
        MySQL.Async.execute("UPDATE persistent_inventory_items SET item_slotid = @newSlot WHERE persistent_id = @persistentId AND item_slotid = @oldSlot", {
            ["persistentId"] = persistentId,
            ["newSlot"] = newSlot,
            ["oldSlot"] = oldSlot
        }, function(result)
            changedItemSlot = true
        end)
    end)
    while changedItemSlot == nil do
        Citizen.Wait(0)
    end

    return changedItemSlot
end

--Uses the both slot id and item id
function SQL_ChangeItemSlotIdWithItemIdInPersistentInventory(persistentId, oldSlotId, oldSlotItemId, newSlotId)
    local changedItemSlot = nil
    MySQL.ready(function()
        MySQL.Async.execute("UPDATE persistent_inventory_items SET item_slotid = @newSlot WHERE persistent_id = @persistentId AND item_slotid = @oldSlot AND item_id = @oldSlotItemId", {
            ["persistentId"] = persistentId,
            ["oldSlot"] = oldSlotId,
            ["newSlot"] = newSlotId,
            ["oldSlotItemId"] = oldSlotItemId
        }, function(result)
            changedItemCount = true
        end)
    end)
    while changedItemSlot == nil do
        Citizen.Wait(0)
    end

    return changedItemSlot
end

function SQL_UpdateItemCountInPersistentInventory(persistentId, slotId, newCount)
    local updatedItemCount = nil
    MySQL.ready(function()
        MySQL.Async.execute("UPDATE persistent_inventory_items SET item_count = @newCount WHERE persistent_id = @persistentId AND item_slotid = @slotId", {
            ["persistentId"] = persistentId,
            ["slotId"] = slotId,
            ["newCount"] = newCount
        }, function(result)
            updatedItemCount = true
        end)
    end)
    while updatedItemCount == nil do
        Citizen.Wait(0)
    end

    return updatedItemCOunt
end

function SQL_UpdateItemQualityInPersistentInventory(persistentId, slotId, newQuality)
    local updatedItemQual = nil
    MySQL.ready(function()
        MySQL.Async.execute("UPDATE persistent_inventory_items SET item_quality = @newQuality WHERE persistent_id = @persistentId AND item_slotid = @slotId", {
            ["slotId"] = slotId,
            ["persistentId"] = persistentId,
            ["newQuality"] = newQuality
        }, function(result)
            if result then
                updatedItemQual = true
            else
                updatedItemQual = false
            end
        end)
    end)

    while updatedItemQual == nil do
        Citizen.Wait(1)
    end

    return updatedItemQual
end

function SQL_InsertItemToPersistentInventory(persistentId, slotId, itemData)
    local insertedItem = nil
    MySQL.ready(function()
        MySQL.Async.insert("INSERT INTO persistent_inventory_items (persistent_id, item_id, item_slotid, item_count, item_quality, item_attachments) VALUES (@inventoryId, @itemId, @slotId, @count, @quality, @attachments)", {
            ["inventoryId"] = persistentId,
            ["itemId"] = itemData.id,
            ["slotId"] = slotId,
            ["count"] = itemData.count,
            ["quality"] = itemData.quality,
            ["attachments"] = json.encode(itemData.attachments)
        }, function(result)
            if result > 0 then
                insertedItem = true
            else
                insertedItem = false
            end
        end)
    end)
    while insertedItem == nil do
        Citizen.Wait(0)
    end

    return insertedItem
end

function SQL_RemoveItemFromPersistentInventory(persistentId, slotId)
    local deletedItem = nil
    MySQL.ready(function()
        MySQL.Async.execute("DELETE FROM persistent_inventory_items WHERE persistent_id = @persistentId AND item_slotid = @slotId", {
            ["persistentId"] = persistentId,
            ["slotId"] = slotId
        }, function(result)
            deletedItem = true
        end)
    end)

    while deletedItem == nil do
        Citizen.Wait(0)
    end
    return deletedItem
end

Citizen.CreateThread(function()
    while true do
        if #GetPlayers() >= 1 then
            --Creates special crates 
            for k,v in pairs(persistentCrates) do
                SpawnPersistentCrate(v.model, v.position)
                --AddPersistentCrate(createdModel, crateInventory)
            end
            --Wait 5 seconds per loop if players are on
            Citizen.Wait(5000)
        end
        --Wait 10 seconds per loop if no player are on
        Citizen.Wait(10000)
    end
end)

function SpawnPersistentCrate(model, position)
    local createdObject = CreateObject(model, position.x, position.y, position.z, true, true, false)
end

function CreatePersistentCrate()
    local crateData = {
        label = label,
        model = model,
        health = health,
        position = poisition,

    }
    local createdModel = CreateObject(GetHashKey(v.model), 0, 0, 0, true, true, false)
    local inventoryWeight = 0
    local crateInventory = {
        label = v.label,
        identifier = v.model..":"..k,
        maxslots = v.maxslots or Config.DefaultCrateSlots,
        maxweight = v.maxweight or Config.DefaultCrateWeight,
        weight = 0,
        items = {}
    }

    for _,ochance in pairs(v.items) do
        local itemData = Config.Items[_]

        if itemData then
            local chance = itemData.spawnchance
            if ochance ~= -1 then
                chance = ochance
            end

            local randomNum = math.random(0, 100)
            if randomNum < chance then
                local randomCount = math.random(1, itemData.maxcount)
                local itemWeight = randomCount * itemData.weight
                inventoryWeight = inventoryWeight + itemWeight
                crateInventory.items[#crateInventory.items+1] = {
                    label = itemData.label,
                    model = itemData.model,
                    count = randomCount,
                    weight = randomCount * itemData.weight,
                    maxcount = itemData.maxcount
                }
            end
        end
    end
    crateInventory.weight = inventoryWeight
end

local lootSpawned = {}

function CalculateLootableContainer(model)
    for k,container in pairs(Config.LootableContainers) do
        if k == model then
            local inventoryWeight = 0
            local items = InventoryFillEmpty(container.maxslots)
            local hasItems = false
            for k,v in pairs(container.items) do
                if k ~= nil then
                    hasItems = true
                    break
                end
            end
            --If the container containers any items that should override spawns
            if hasItems then
                --If the container spawns all items as well as overriden spawns
                if container.spawnall then
                    lootSpawned = {}
                    for configItemId,configItem in pairs(Config.ItemsWithoutFunctions()) do
                        local override = false
                        local alreadySpawned = false
                        for _,loot in pairs(lootSpawned) do
                            if tonumber(loot) == tonumber(configItemId) then
                                alreadySpawned = true
                            end
                        end
                        if alreadySpawned then
                            goto skip
                        end

                        local rng = math.random(0, 100)

                        for ochanceItemId,ochance in pairs(container.items) do
                            local itemChance = ochance
                            local itemMinQuality = configItem.minquality or Config.MinQuality
                            local itemMaxQuality = configItem.maxquality or Config.MaxQuality
                            if type(ochance) == "table" then
                                itemChance = ochance.chance
                                itemMinQuality = ochance.minquality
                                itemMaxQuality = ochance.maxquality
                            end
                            
                            if ochanceItemId == configItemId then
                                override = true
                                if rng < itemChance then
                                    rng = math.random(1, configItem.maxcount)
                                    configItem.count = rng
                                    configItem.weight = configItem.weight * rng
                                    if inventoryWeight + configItem.weight > container.maxweight then break end
                                    rng = math.random(itemMinQuality, itemMaxQuality)
                                    configItem.quality = rng
                                    inventoryWeight = inventoryWeight + configItem.weight
                                    for k,v in pairs(items) do
                                        if v.model == "empty" then
                                            items[k] = configItem
                                            table.insert(lootSpawned, configItemId)
                                            break
                                        end
                                    end
                                end
                            end
                        end
                        
                        if not override then
                            rng = math.random(0, 100)
                            if rng < configItem.spawnchance then
                                rng = math.random(1, configItem.maxcount)
                                configItem.count = rng
                                configItem.weight = configItem.weight * rng
                                if inventoryWeight + configItem.weight > container.maxweight then break end
                                rng = math.random(configItem.minquality or Config.MinQuality, configItem.quality or Config.MaxQuality)
                                configItem.quality = rng
                                inventoryWeight = inventoryWeight + configItem.weight
                                for k,v in pairs(items) do
                                    if v.model == "empty" then
                                        items[k] = configItem
                                        table.insert(lootSpawned, configItemId)
                                        break
                                    end
                                end
                            end
                        end
                        ::skip::
                    end
                else
                    --If container should only spawn whats in the override items table
                    lootSpawned = {}
                    for k,chance in pairs(container.items) do
                        local alreadySpawned = false
                        for _,loot in pairs(lootSpawned) do
                            if tonumber(loot) == tonumber(k) then
                                alreadySpawned = true
                            end
                        end

                        local rng = math.random(0, 100)
                        local itemData = Config.ItemsWithoutFunctions()[k]
                        --Try to get the chance index if it's a table, if not just a number
                        local itemChance = -1
                        
                        if isnumber(chance) then
                            if chance > -1 then
                                itemChance = chance
                            elseif chance == -1 then
                                itemChance = itemData.spawnchance
                            end
                        else
                            itemChance = chance.chance
                        end

                        if not alreadySpawned and rng < itemChance then
                            rng = math.random(1, itemData.maxcount)
                            itemData.count = rng
                            itemData.weight = itemData.weight * rng
                            local minQuality = chance.minquality or configItem.minquality or Config.MinQuality
                            local maxQuality = chance.maxquality or configItem.quality or Config.MaxQuality
                            rng = math.random(minQuality, maxQuality)
                            itemData.quality = rng
                            --If adding this item puts the inventory over max weight break
                            if inventoryWeight + item.weight > container.maxweight then break end
                            inventoryWeight = inventoryWeight + itemData.weight
                            for k,v in pairs(items) do
                                if v.model == "empty" then
                                    items[k] = itemData
                                    table.insert(lootSpawned, itemData.itemId)
                                end
                            end
                        end
                    end
                end
            else
                --If the container doesn't have any items in the override table
                lootSpawned = {}
                if container.spawnall then
                    for itemId,item in pairs(Config.ItemsWithoutFunctions()) do
                        
                        if item.containerspawn == nil then goto itemadded end

                        for _,loot in pairs(lootSpawned) do
                            if tonumber(loot) == tonumber(itemId) then
                                goto itemadded
                            end
                        end
                        
                        local rng = math.random(0,100)

                        if rng < item.spawnchance then
                            rng = math.random(1, item.maxcount)
                            item.count = rng
                            item.weight = item.weight * rng
                            rng = math.random(item.minquality or Config.MinQuality, item.quality or Config.MaxQuality)
                            item.quality = rng
                            
                            if inventoryWeight + item.weight > container.maxweight then print("Container at max weight, can't spawn more items in it") break end

                            inventoryWeight = inventoryWeight + item.weight
                            for k,v in pairs(items) do
                                if v.model == "empty" then
                                    items[k] = item
                                    print("Add item to loot spawned", itemId)
                                    table.insert(lootSpawned, itemId)
                                    goto itemadded
                                end
                            end
                        end
                        ::itemadded::
                    end
                end
            end

            return inventoryWeight, items
        end
    end
end