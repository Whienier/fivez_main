local persistentObjects = {}

MySQL.ready(function()
    MySQL.Async.fetchAll("SELECT * FROM persistent_custom_objects", {}, function(result)
        if result[1] then
            for k,v in pairs(result) do
                table.insert(persistentObjects, {
                    Id = v.persistent_object_id,
                    model = v.persistent_object_model,
                    position = json.decode(v.persistent_object_position),
                    heading = v.persistent_object_heading,
                    health = v.persistent_object_health,
                    door = v.persistent_object_door,
                    locked = v.persistent_object_locked
                })
            end
        end
    end)
end)

function SQL_InsertObject(objectModel, objectPosition, objectHeading, objectHealth, door)
    MySQL.ready(function()
        MySQL.Async.insert("INSERT INTO persistent_custom_objects (persistent_object_model, persistent_object_position, persistent_object_heading, persistent_object_health, persistent_object_door, persistent_object_locked) VALUES (@model, @position, @heading, @health, @door, @islocked)", {
            ["model"] = objectModel,
            ["position"] = json.encode(objectPosition),
            ["heading"] = objectHeading,
            ["health"] = objectHealth,
            ["door"] = door,
            ["islocked"] = false
        }, function(result)
            if result then
                table.insert(persistentObjects, {
                    Id = result,
                    model = objectModel,
                    position = objectPosition,
                    heading = objectHeading,
                    health = objectHealth,
                    door = isDoor,
                    locked = false
                })
            end
        end)
    end)
end

function SQL_DeleteObject(objectId)
    MySQL.ready(function()
        MySQL.Async.execute("DELETE FROM persistent_custom_objects WHERE persistent_object_id = @objectId", {
            ["objectId"] = objectId
        }, function(result)
            
        end)
    end)
end

function SQL_UpdateObjectPosition(objectId, newPosition, newHeading)
    MySQL.ready(function()
        MySQL.Async.execute("UPDATE persistent_custom_objects SET persistent_object_position = @newPosition, persistent_object_heading = @newHeading WHERE persistent_object_id = @objectId", {
            ["objectId"] = objectId,
            ["newPosition"] = newPosition,
            ["newHeading"] = newHeading
        }, function(result)
        
        end)
    end)
end

function SQL_UpdateObjectHealth(objectId, newHealth)
    MySQL.ready(function()
        MySQL.Async.execute("UPDATE persistent_custom_objects SET persistent_object_health = @newHealth WHERE persistent_object_id = @objectId", {
            ["objectId"] = objectId,
            ["newHealth"] = newHealth
        },function(result)
            
        end)
    end)
end

RegisterNetEvent("fivez:FinishBuildingPlacement", function(netId)
    local object = NetworkGetEntityFromNetworkId(netId)
    if DoesEntityExist(object) then
        --FreezeEntityPosition(object, false)
        local model = GetEntityModel(object)
        local isStash = false
        local label = ""
        local stashSlots = 0
        local stashWeight = 0
        for k,v in pairs(Config.StashContainers) do
            if v == model then
                isStash = true
                label = v.label
                stashSlots = v.maxslots
                stashWeight = v.maxweight
            end
        end
        local coords = GetEntityCoords(object)
        local heading = GetEntityHeading(object)
        local health = GetEntityHealth(object)
        if not isStash then
            SQL_InsertObject(model, coords, heading, health, isdoor)
        else
            SQL_CreatePersistentCrate(label, model, coords, health, stashSlots, stashWeight)
        end
    end
end)

local spawnedObjects = false

Citizen.CreateThread(function()
    while true do
        if #GetPlayers() >= 1 and not spawnedObjects then
            for k,v in pairs(persistentObjects) do
                local createdObject = CreateObject(v.model, v.position.x, v.position.y, v.position.z, true, true, v.door)
                while not DoesEntityExist(createdObject) do
                    Citizen.Wait(1)
                end
            end
            spawnedObjects = true
        elseif spawnedObjects then
            return
        end
        Citizen.Wait(Config.DelayServerTick)
    end
end)