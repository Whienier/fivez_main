spawnedVehicles = {}

persistentVehicles = {}

--Load any vehicles that should be persistent on resource start
MySQL.ready(function()
    MySQL.Async.fetchAll("SELECT * FROM persistent_vehicles", {}, function(result)
        if result[1] then
            for k,v in pairs(result) do
                local res = table.insert(persistentVehicles, {
                    model = v.vehicle_model,
                    numberplate = v.persistent_vehiclesid,
                    position = json.decode(v.vehicle_lastposition),
                    heading = v.vehicle_heading,
                    fuel = v.vehicle_fuel,
                    enginehealth = v.vehicle_enginehealth,
                    bodyhealth = v.vehicle_bodyhealth,
                    tyres = json.decode(v.vehicle_tyres),
                    trunk = {
                        type = "inventory",
                        identifier = "trunk:"..v.persistent_vehiclesid,
                        label = "Trunk",
                        weight = 0,
                        maxWeight = v.vehicle_inventory_trunkmaxweight,
                        maxSlots = v.vehicle_inventory_trunkslots,
                        items = SQL_GetPersistentVehicleInventoryData("trunk:"..v.persistent_vehiclesid, InventoryFillEmpty(v.vehicle_inventory_trunkslots))
                    },
                    glovebox = {
                        type = "inventory",
                        identifier = "glovebox:"..v.persistent_vehiclesid,
                        label = "Glovebox",
                        weight = 0,
                        maxWeight = v.vehicle_inventory_gloveboxmaxweight,
                        maxSlots = v.vehicle_inventory_gloveboxslots,
                        items = SQL_GetPersistentVehicleInventoryData("glovebox:"..v.persistent_vehiclesid, InventoryFillEmpty(v.vehicle_inventory_gloveboxslots))
                    },
                    netId = nil
                })
            end
        end
    end)
end)

function SyncVehicleStates(source)
    local data = {}
    for k,v in pairs(spawnedVehicles) do
        table.insert(data, {netId = NetworkGetNetworkIdFromEntity(v.veh), fuel = v.fuel, bodyhealth = v.bodyhealth, enginehealth = v.enginehealth, tyres = v.tyres})
    end
    TriggerClientEvent("fivez:SyncVehicleStates", source, json.encode(data))
end

function IsVehicleInSpot(coords)
    local closestDistance = -1
    local closestVehicle = 0
    for k,v in pairs(spawnedVehicles) do
        local dist = #(GetEntityCoords(v.veh) - coords)
        if closestDistance == -1 or dist <= closestDistance then
            closestDistance = dist
            closestVehicle = v.veh
        end
    end

    if closestDistance ~= -1 and closestDistance <= 20 then
        return closestVehicle
    end
    return false
end

function SpawnVehicle(model, coords, gloveboxinv, trunkinv, vehicleNumberplate)
    local createdVehicle = CreateVehicle(model, coords.x, coords.y, coords.z, 0.0, true, true)
    while not DoesEntityExist(createdVehicle) do
        Citizen.Wait(1)
    end
    --SetVehicleNumberPlateText(createdVehicle, vehicleNumberplate)
    local defaults = Config.CarStorage[model] or Config.DefaultCarStorage
    local gloveboxweight = 0
    local gloveboxitems = gloveboxinv or InventoryFillEmpty(defaults.gloveboxslots)
    local trunkweight = 0
    local trunkitems = trunkinv or InventoryFillEmpty(defaults.trunkslots)

--[[     if gloveboxinv then
        for k,v in pairs(gloveboxinv) do
            local itemData = Config.Items[v.itemId]
            if itemData then
                gloveboxweight = gloveboxweight + (v.count * itemData.weight )
            end
        end
    end

    if trunkinv then
        for k,v in pairs(trunkinv) do
            local itemData = Config.Items[v.itemId]
            if itemData then
                trunkweight = trunkweight + (v.count * itemData.weight)
            end
        end
    end ]]
    print("Created vehicle, numberplate", vehicleNumberplate)
    if model == GetHashKey("bmx") then
        table.insert(spawnedVehicles, {veh = createdVehicle, tyres = nil, created = GetGameTimer()})
    else
        table.insert(spawnedVehicles, {veh = createdVehicle, bodyhealth = 0, enginehealth = 0, fuel = 0, tyres = {}, created = GetGameTimer(), 
        glovebox = gloveboxinv or {
            type = "inventory",
            identifier = "glovebox:"..vehicleNumberplate, --Not sure if to use number plate or not
            label = "Glovebox",
            weight = gloveboxweight,
            maxWeight = defaults.gloveboxmaxweight,
            maxSlots = defaults.gloveboxslots,
            items = gloveboxitems
        }, 
        trunk = trunkinv or {
            type = "inventory",
            identifier = "trunk:"..vehicleNumberplate,
            label = "Trunk",
            weight = trunkweight,
            maxWeight = defaults.trunkmaxweight,
            maxSlots = defaults.trunkslots,
            items = trunkitems
        }
        })
    end
    
    return createdVehicle
end

--Make sure database vehicles are spawned before random generated ones
local persistentVehiclesSpawned = false
--Thread to spawn database persistent vehicles
Citizen.CreateThread(function()
    while true do
        if #GetPlayers() >= 1 then
            for k,v in pairs(GetPlayers()) do
                local plyPed = GetPlayerPed(v)
                local playerData = GetJoinedPlayer(v)
                if not DoesEntityExist(plyPed) or not playerData or not playerData.playerSpawned then
                    Citizen.Wait(0)
                end
            end
            
            Citizen.Wait(Config.DelayServerTick)
            if #persistentVehicles >= 1 then
                for k,v in pairs(persistentVehicles) do
                    local coords = vector3(v.position.x, v.position.y, v.position.z)
                    local createdVehicle = SpawnVehicle(v.model, coords, v.glovebox, v.trunk, v.numberplate)
                    SetEntityCoords(createdVehicle, coords.x, coords.y, coords.z, false, false, false, false)
                    SetVehicleNumberPlateText(createdVehicle, v.numberplate)
                    SetVehicleBodyHealth(createdVehicle, v.bodyhealth)
                    SetEntityHeading(createdVehicle, v.heading)
                    for k,spawnedVeh in pairs(spawnedVehicles) do
                        if spawnedVeh.veh == createdVehicle then
                            spawnedVeh.fuel = v.fuel
                            spawnedVeh.enginehealth = v.enginehealth
                            --LOOK AT WHATS BEING SENT TO CLIENT
                            spawnedVeh.tyres = {[1] = v.tyres[1], [2] = v.tyres[2], [4] = v.tyres[4], [5] = v.tyres[5]}
                        end
                    end
                    v.netId = createdVehicle
                end
            end
            persistentVehiclesSpawned = true
            return
        else
            Citizen.Wait(Config.DelayServerTick)
        end
        Citizen.Wait(50)
    end
end)
local spawnedRandomVehs = false
--Thread to spawn random vehicles and save them to database
Citizen.CreateThread(function()
    while true do
        if #GetPlayers() >= 1 then
            Citizen.Wait(Config.DelayServerTick)
            while not persistentVehiclesSpawned do Citizen.Wait(0) end

            if #spawnedVehicles >= Config.MaxSpawnedVehicles then spawnedRandomVehs = true return end
            --Get how many vehicles have already been spawned, aka database persistent vehicles
            for i=#spawnedVehicles,Config.MaxSpawnedVehicles do
                if Config.MaxSpawnCars ~= -1 then
                    --If the maximum amount of vehicles spawned is equal to or greater than max cars
                    if i >= Config.MaxSpawnCars then return end
                end
                for k,v in pairs(Config.PotentialCarSpawns) do
                    local carInSpot = IsVehicleInSpot(v.position)

                    --Car is in the spot trying to spawn in
                    if carInSpot then goto skip end
                    --Get a random car model
                    local carModel = v.models[math.random(#v.models)]

                    local createdVeh = SpawnVehicle(GetHashKey(carModel), v.position, nil, nil, CreateVehicleNumberPlate())

                    --Get anything that can't be set serverside to tell the client to set it
                    local fuelLevel = math.random(v.minfuel, v.maxfuel)
                    local engineHealth = -1
                    local bodyHealth = -1
                    local tyres = {[1] = -1, [2] = -1, [4] = -1, [5] = -1}
                    if v.damaged ~= nil then                        
                        engineHealth = math.random(v.damaged.minenginehealth, v.damaged.maxenginehealth)
                        --SetVehicleEngineHealth(createdVeh, v.damaged.enginehealth)

                        bodyHealth = math.random(v.damaged.minbodyhealth, v.damaged.maxbodyhealth)
                        SetVehicleBodyHealth(createdVeh, bodyHealth)

                        --How many tyres are burst?
                        if v.damaged.tyres then
                            tyres[1] = math.random(v.damaged.tyres[1].min, v.damaged.tyres[1].max)
                            tyres[2] = math.random(v.damaged.tyres[2].min, v.damaged.tyres[2].max)
                            tyres[4] = math.random(v.damaged.tyres[4].min, v.damaged.tyres[4].max)
                            tyres[5] = math.random(v.damaged.tyres[5].min, v.damaged.tyres[5].max)
                            --SetVehicleTyreBurst()
                        end
                    end

                    --Add the damaged parts to the spawned vehicle
                    for k,v in pairs(spawnedVehicles) do
                        if v.veh == createdVeh then
                            v.bodyhealth = bodyHealth
                            v.fuel = fuelLevel
                            v.enginehealth = engineHealth
                            v.tyres = tyres
                        end
                    end
                    SQL_InsertPersistentVehicle(createdVeh, Config.CarLabels[GetHashKey(carModel)], enginehealth, tyres, fuelLevel)
                    ::skip::
                end
                Citizen.Wait(500)
            end
            spawnedRandomVehs = true
            return
        else
            --Wait Config.DelayServerTick seconds per loop if no players are on
            Citizen.Wait(Config.DelayServerTick)
        end
        Citizen.Wait(0)
    end
end)
--Thread to update vehicle position and fuel
Citizen.CreateThread(function()
    while true do
        if #GetPlayers() >= 1 then
            for k,v in pairs(spawnedVehicles) do
                if DoesEntityExist(v.veh) then
                    SQL_UpdatePersistentVehiclePosition(v.veh)
                    SQL_UpdatePersistentVehicleFuel(v.veh, v.fuel)
                end
            end
        end
        Citizen.Wait(Config.DelayVehiclePosSync)
    end
end)
RegisterCommand("createvehicle", function(source, args)
    if args[1] then
        local pedCoords = GetEntityCoords(GetPlayerPed(source))
        local createdVehicle = SpawnVehicle(GetHashKey(args[1]), pedCoords)
        
        SetPedIntoVehicle(GetPlayerPed(source), createdVehicle, -1)
    end
end, true)
RegisterNetEvent("fivez:SyncVehicleState", function(vehicleNetId)
    local source = source
    local vehicle = NetworkGetEntityFromNetworkId(vehicleNetId)
    if DoesEntityExist(vehicle) then
        for k,v in pairs(spawnedVehicles) do
            if v.veh == vehicle then
                TriggerClientEvent("fivez:SyncVehicleStateCB", source, vehicleNetId, json.encode({fuel = v.fuel, bodyhealth = v.bodyhealth, enginehealth = v.enginehelath, tyres = v.tyres}))
            end
        end
    end
end)
RegisterNetEvent('fivez:DriveVehicle', function()
    local source = source
    local plyPed = GetPlayerPed(source)
    local vehicle = GetVehiclePedIsIn(plyPed, false)
    if vehicle > 0 then
        local driver = GetPedInVehicleSeat(vehicle, -1)
        if driver == plyPed then
            local vehicleModel = GetEntityModel(vehicle)
            local speedInKM = GetEntitySpeed(vehicle) * 3.6

            if speedInKM > 0 then
               local fuelRates = Config.VehicleFuelRates[vehicleModel] or Config.DefaultVehicleFuelRates
               local highestFuelRate = -1
               for k,v in pairs(fuelRates) do
                    if speedInKM >= k then
                        if highestFuelRate < v then
                            highestFuelRate = v
                        end
                    end
               end
               if highestFuelRate == -1 then
                    for k,v in pairs(spawnedVehicles) do
                        if v.veh == vehicle then
                            local fuelLevel = v.fuel

                            if fuelLevel > 0 or fuelLevel - highestFuelRate > 0 then
                                v.fuel = fuelLevel - highestFuelRate
                            else
                                v.fuel = 0
                            end
                        end
                    end
               end
            end
        end
    end
end)

function SQL_GetPersistentVehicleInventoryData(vehicleId, items)
    local gotData = nil
    MySQL.ready(function()
        MySQL.Async.fetchAll("SELECT * FROM persistent_inventory_items WHERE persistent_id = @vehicleId", {
            ["vehicleId"] = vehicleId
        }, function(result)
            if result[1] then
                for k,v in pairs(result) do
                    local itemData = Config.Items[v.item_id]
                    itemData.count = v.item_count
                    itemData.quality = v.item_quality
                    itemData = Config.CreateNewItemWithData(itemData)
                    items[v.item_slotid] = itemData
                end
                gotData = items
            else
                gotData = items
            end
        end)
    end)
    while gotData == nil do
        Citizen.Wait(0)
    end
    return gotData
end

function SQL_InsertPersistentVehicle(vehicle, vehicleLabel, enginehealth, tyres, fuel)
    local insertedData = nil
    local vehicleNumberplate = GetVehicleNumberPlateText(vehicle)
    local position = GetEntityCoords(vehicle)
    local model = GetEntityModel(vehicle)
    local heading = GetEntityHeading(vehicle)
    local bodyhealth = GetVehicleBodyHealth(vehicle)
    local inventoryparams = Config.CarStorage[model] or Config.DefaultCarStorage
    MySQL.ready(function()
        MySQL.Async.insert("INSERT INTO persistent_vehicles (persistent_vehiclesid, vehicle_label, vehicle_model, vehicle_lastposition, vehicle_heading, vehicle_bodyhealth, vehicle_enginehealth, vehicle_fuel, vehicle_tyres, vehicle_inventory_trunkslots, vehicle_inventory_gloveboxslots, vehicle_inventory_trunkmaxweight, vehicle_inventory_gloveboxmaxweight) VALUES (@vehicleId, @vehicleLabel, @model, @position, @heading, @bodyhealth, @enginehealth, @fuel, @tyres, @trunkslots, @gloveboxslots, @trunkmaxweight, @gloveboxmaxweight)", {
            ["vehicleId"] = vehicleNumberplate,
            ["vehicleLabel"] = vehicleLabel,
            ["model"] = model,
            ["position"] = json.encode(position),
            ["heading"] = heading,
            ["bodyhealth"] = bodyhealth,
            ["enginehealth"] = enginehealth,
            ["fuel"] = fuel,
            ["tyres"] = json.encode(tyres),
            ["trunkslots"] = inventoryparams.trunkslots,
            ["gloveboxslots"] = inventoryparams.gloveboxslots,
            ["trunkmaxweight"] = inventoryparams.trunkmaxweight,
            ["gloveboxmaxweight"] = inventoryparams.gloveboxmaxweight
        }, function(result)
            insertedData = result
        end)
    end)
    while insertedData == nil do
        Citizen.Wait(0)
    end
    return insertedData
end

function SQL_UpdatePersistentVehiclePosition(vehicle)
    local updatedPos = nil
    local vehicleId = GetVehicleNumberPlateText(vehicle)
    local vehicleCoords = GetEntityCoords(vehicle)
    MySQL.ready(function()
        MySQL.Async.execute("UPDATE persistent_vehicles SET vehicle_lastposition = @newPos, vehicle_heading = @newHeading WHERE persistent_vehiclesid = @vehicleId", {
            ["vehicleId"] = vehicleId,
            ["newPos"] = json.encode(vehicleCoords),
            ["newHeading"] = GetEntityHeading(vehicle)
        }, function(result)
            updatedPos = result
        end)
    end)
    while updatedPos == nil do
        Citizen.Wait(0)
    end
    return updatedPos
end

function SQL_UpdatePersistentVehicleFuel(vehicle, newFuel)
    local updatedFuel = nil
    MySQL.ready(function()
        MySQL.Async.execute("UPDATE persistent_vehicles SET vehicle_fuel = @newFuel WHERE persistent_vehiclesid = @vehicleId", {
            ["vehicleId"] = GetVehicleNumberPlateText(vehicle),
            ["newFuel"] = newFuel
        }, function(result)
            updatedFuel = result
        end)
    end)

    while updatedFuel do
        Citizen.Wait(0)
    end
    return updatedFuel
end

local characterLookup = { '1', '2', '3', '4', '5', '6', '7', '8', '9', '0', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'}
function CreateVehicleNumberPlate()
    local str = ""
    --Create a string of 8 characters
    for i=0,8 do
        local character = math.random(1, #characterLookup)
        str = str .. characterLookup[character]
    end
    return str
end