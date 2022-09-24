--Table for single created zombies
local zombies = {}
--Table for dead zombies
local deadZombies = {}

RegisterCommand("createzombie", function(source, args)
    local source = source
    if args[1] then
        for i=1, tonumber(args[1]) do
            CreateZombie(GetEntityCoords(GetPlayerPed(source)))
        end
    else
        CreateZombie(GetEntityCoords(GetPlayerPed(source)))
    end
end, true)
--Goto zombie
RegisterCommand("gtz", function(source, args)
    local source = source
    if args[1] ~= nil then
        for k,v in pairs(zombies) do
            if tostring(v.zombie) == tostring(args[1]) then
                local zomCoords = GetEntityCoords(v.zombie)
                SetEntityCoords(GetPlayerPed(source), zomCoords.x, zomCoords.y, zomCoords.z, true, false, false, false)
            end
        end
    end
end, true)

function CheckCoordForDeadZombie(coords)
    local closestDistance = -1
    local closestDeadZombie = -1
    local closestDeadModel = -1
    local distance = -1
    for k,v in pairs(deadZombies) do
        distance = #(coords - v.position)
        if closestDistance == -1 or distance < closestDistance then
            closestDistance = distance
            closestDeadZombie = v.ped
            closestDeadModel = v.model
        end
    end

    return closestDistance, closestDeadZombie, closestDeadModel
end

function CreateZombie(coords)
    local zombieModel = Config.ZombieModels[math.random(#Config.ZombieModels)]
    local createdZombie = CreatePed(0, GetHashKey(zombieModel), coords.x-0.0, coords.y-0.0, coords.z-0.0, 0.0, true, true)
    
    --Wait until the ped has become networked and spawned
    Citizen.Wait(250)
    SetPedArmour(createdZombie, 100.0)
    SetEntityCoords(createdZombie, coords.x-0.0, coords.y-0.0, coords.z-0.0, true, false, false, false)
    
    SetPedConfigFlag(createdZombie, 424, true) --Falls like aircraft
    SetPedConfigFlag(createdZombie, 430, true) --Ignore being on fire
    SetPedConfigFlag(createdZombie, 140, false) --Can attack friendlies

    SetPedConfigFlag(createdZombie, 281, false) --Write mode
    SetPedConfigFlag(createdZombie, 100, true) --Is drunk
    SetPedConfigFlag(createdZombie, 33, false) --Dies when ragdoll
    SetPedConfigFlag(createdZombie, 128, false) --Can be agitated
    SetPedConfigFlag(createdZombie, 188, true) --Disable hurt
    --SetPedConfigFlag(zomPed, 223, true) --Shrink

    SetPedConfigFlag(createdZombie, 294, true) --Disable shocking events
    SetPedConfigFlag(createdZombie, 329, true) --Disable talk to
    SetPedConfigFlag(createdZombie, 421, true) --Flaming footprints

    table.insert(zombies, {zombie = createdZombie, spawned = GetGameTimer(), position = coords})

    TriggerClientEvent("fivez:SpawnZombie", -1, NetworkGetNetworkIdFromEntity(createdZombie))
end

function SyncZombieStates(source)
    local zombieData = {}
    for k,v in pairs(zombies) do
        print("Syncing zombies", NetworkGetNetworkIdFromEntity(v.zombie))
        table.insert(zombieData, NetworkGetNetworkIdFromEntity(v.zombie))
    end

    TriggerClientEvent("fivez:SyncZombieState", source, json.encode(zombieData))
end

function CheckCoordForZombies(coords)
    local closestZombie = -1
    local closestDistance = -1
    for k,v in pairs(zombies) do
        if v then
            if DoesEntityExist(v.zombie) then
                local zombieCoords = GetEntityCoords(v.zombie)
                if closestDistance == -1 or #(zombieCoords - coords) <= closestDistance then
                    closestZombie = v
                    closestDistance = #(zombieCoords - coords)
                end
            end
        end
    end

    return closestDistance, closestZombie
end

local lootSpawned = {}
--Returns table of items that zombie dropped
function CalculateZombieLoot(zombieModel)
    local items = InventoryFillEmpty(Config.ZombieInventoryMaxSlots)

    local possibleLoot = nil
    for k,v in pairs(Config.ZombieLootTable) do
        if k == zombieModel then
            possibleLoot = v
        end
    end
    if possibleLoot == nil then
        possibleLoot = Config.ZombieLootTable["undefined"]
    end

    local weight = 0

    lootSpawned = {}
    
    for k,v in pairs(items) do
        if v.model == "empty" then
            for itemId, item in pairs(possibleLoot) do
                --Try to stop spawning the same loot more than once
                local alreadySpawned = false
                for k,v in pairs(lootSpawned) do
                    if v == itemId then
                        alreadySpawned = true
                    end
                end

                if alreadySpawned then goto skip end

                local rng = math.random(0, 100)
                local itemData = Config.ItemsWithoutFunctions()[itemId]
                if rng < (item.chance or itemData.spawnchance) then
                    rng = math.random(1, item.maxcount)
                    itemData.count = rng
                    rng = math.random(Config.MinQuality, Config.MaxQuality)
                    itemData.quality = rng
                    weight = weight + (itemData.count * itemData.weight)
                    items[k] = itemData
                    table.insert(lootSpawned, itemId)
                end
                ::skip::
            end
        end
    end

    for k,v in pairs(items) do
        if v.model == "empty" then
            for _,v in pairs(Config.ItemsWithoutFunctions()) do
                local alreadySpawned = false
                for k,loot in pairs(lootSpawned) do
                    if loot == v.itemId then
                        alreadySpawned = true
                    end
                end
                if not v.zombiespawn then goto skip end
                if alreadySpawned then goto skip end

                local rng = math.random(0, 100)
                if rng < v.spawnchance then
                    rng = math.random(1, v.maxcount)
                    weight = weight + (rng * v.weight)
                    local itemData = v
                    itemData.count = rng
                    rng = math.random(Config.MinQuality, Config.MaxQuality)
                    itemData.quality = rng
                    items[k] = itemData
                    table.insert(lootSpawned, itemData.itemId)
                end

                ::skip::
            end
        end
    end

    return weight, items
end


local gotGround = nil
RegisterNetEvent("fivez:GetGroundForZombieCB", function(result)
    gotGround = json.decode(result)
end)

--Server thread for spawning zombies
Citizen.CreateThread(function()
    while true do
        local players = GetPlayers()

        if #players >= 1 then
            for k,v in pairs(players) do
                --Make sure player is in the correct routing bucket
                if CheckRoutingBucket(v) then
                    --Skip loop iteration if player isn't joined properly
                    if GetJoinedPlayer(v) == nil then goto skip end
                    if GetJoinedPlayer(v).source == nil then goto skip end
                    local plyPed = GetPlayerPed(v)
                    local plyCoords = GetEntityCoords(plyPed)
                    --Define the random position off how far a zombie should spawn from a player 
                    local rngSpawn = math.random(-Config.ZombieSpawnDistanceFromPlayer, Config.ZombieSpawnDistanceFromPlayer)
                    local zombieSpawn = plyCoords + vector3(rngSpawn, rngSpawn, 0)
                    --While the zombe spawn distance to the players coords is less than the config spawn distance, plus vector3(5,5,0)
                    local rngSpawnY = 0
                    while #(zombieSpawn - plyCoords) < Config.ZombieSpawnDistanceFromPlayer do
                        rngSpawn = math.random(-15, 15)
                        rngSpawnY = math.random(-15, 15)
                        zombieSpawn = zombieSpawn + vector3(rngSpawn, rngSpawnY, 0)
                        Citizen.Wait(0)
                    end
                    --Zombie spawn should be far enough away from player now
                    local closestDistance, closestZombie = CheckCoordForZombies(zombieSpawn)
                    --If another zombie is too close to where we are trying to spawn
                    if closestDistance ~= -1 and closestDistance <= 15 then goto skip end
                    gotGround = nil
                    TriggerClientEvent("fivez:GetGroundForZombie", v, json.encode(zombieSpawn))
                    while gotGround == nil do
                        Citizen.Wait(0)
                    end
                    if gotGround ~= false then
                        zombieSpawn = vector3(gotGround.x, gotGround.y, gotGround.z)
                    end

                    local zombieAmount = Config.MaxZombieSpawn
                    if Config.ZombieNightSpawn then
                        local time = exports["weathertimesync"]:getTime()
                        if time.hour then
                            if time.hour >= 16 or time.hour <= 4 then
                                zombieAmount = Config.MaxZombieSpawn * Config.ZombieNightSpawnMultiplier
                            end
                        end
                    end
                    local numZombies = math.random(1, zombieAmount)
                    print("Spawning ", numZombies, " zombies")
                    for i=1, numZombies do
                        CreateZombie(zombieSpawn)
                    end
                    --Wait a second before spawning zombies on the next player
                    Citizen.Wait(1000)
                    ::skip::
                end
            end
            Citizen.Wait(Config.ZombieSpawnTime)
        elseif #players == 0 then
            Citizen.Wait(Config.DelayServerTick)
        end
        Citizen.Wait(0)
    end
end)

--Server thread for checking if a zombie dies, checks zombie hordes and single zombies
Citizen.CreateThread(function()
    while true do
        if #GetPlayers() >= 1 then
            if #zombies >= 1 then
                for k,v in pairs(zombies) do
                    if v then
                        local zomPed = v.zombie
                        if DoesEntityExist(zomPed) then
                            if GetEntityHealth(zomPed) <= 0 then
                                print("Zombie has died", zomPed, GetEntityModel(zomPed))
                                table.insert(deadZombies, {ped = zomPed, died = GetGameTimer(), model = GetEntityModel(zomPed), position = GetEntityCoords(zomPed)})
                                table.remove(zombies, k)
                            end
                        elseif not DoesEntityExist(zomPed) then
                            table.remove(zombies, k)
                        end
                    end
                end
            end
            --Check if a zombie is dead every half a second
            Citizen.Wait(500)
        elseif #GetPlayers() == 0 then
            Citizen.Wait(Config.DelayServerTick)
        end
        Citizen.Wait(0)
    end
end)

--Thread to remove dead zombies after a time
Citizen.CreateThread(function()
    while true do
        if #GetPlayers() >= 1 then
            if #deadZombies >= 1 then
                for k,v in pairs(deadZombies) do
                    if (GetGameTimer() - v.died) > Config.DeleteDeadZombiesAfter then
                        DeleteEntity(v.ped)
                        TriggerClientEvent("fivez:DeleteZombie", -1, NetworkGetNetworkIdFromEntity(v.ped))
                        local invId = "zombie:"..v.ped
                        DeleteRegisteredInventory(invId)
                        table.remove(deadZombies, k)
                    end
                end
            end
        elseif #GetPlayers() == 0 then
            Citizen.Wait(Config.DelayServerTick)
        end
        Citizen.Wait(0)
    end
end)

--[[ --Server thread for updating zombies positions
Citizen.CreateThread(function()
    while true do
        if #zombies >= 1 then 
            for k,v in pairs(zombies) do
                if DoesEntityExist(v.zombie) then
                    local currentPos = GetEntityCoords(v.zombie)
                    --If the zombie has moved greater than 5 units
                    if #(currentPos - v.position) > 5 then
                        v.position = currentPos
                    end
                end
            end
        end
        Citizen.Wait(Config.ServerZombiePositionTick)
    end
end) ]]

--TODO: Run an intial thread to spawn 100+ zombies dotted around the ma

local duckingCB = nil
RegisterNetEvent("fivez:IsPlayerDuckingCB", function(ducking)
    duckingCB = ducking
end)
local lastStress = {}
--Stress server loop
Citizen.CreateThread(function()
    while true do
        if #GetPlayers() >= 1 then
            for k,ply in pairs(GetPlayers()) do
                if lastStress[ply] == nil or lastStress[ply] < GetGameTimer() then
                    local plyData = GetJoinedPlayer(ply)
                    local plyPed = GetPlayerPed(ply)
                    if DoesEntityExist(plyPed) then
                        local pedCoords = GetEntityCoords(plyPed)
                        if #zombies >= 1 then
                            for k,v in pairs(zombies) do
                                local zomPed = v.zombie
                                if DoesEntityExist(zomPed) then
                                    local zomCoords = GetEntityCoords(zomPed)
                                    local dist = #(pedCoords - zomCoords)
                                    local stressRate = 0
                                    for k,v in pairs(Config.StressRates) do
                                        if dist <= k then
                                            stressRate = v
                                        end
                                    end
                                    if stressRate > 0 then
                                        if plyData.characterData.stress + stressRate > Config.MaxStress then
                                            plyData.characterData.stress = Config.MaxStress
                                        else
                                            plyData.characterData.stress = plyData.characterData.stress + stressRate
                                        end
                                        TriggerClientEvent("fivez:CharacterStressed", ply, plyData.characterData.stress)
                                        lastStress[ply] = GetGameTimer() + Config.TimeBetweenStress
                                    end
                                end
                            end
                        end
                    end
                end
            end
        else
            Citizen.Wait(Config.DelayServerTick)
        end
        Citizen.Wait(1000)
    end
end)

local zombiesAttacking = {}
--Thread to control zombie AI
--[[ Citizen.CreateThread(function()
    while true do
        if #zombies >= 1 then
            for k,v in pairs(zombies) do
                local zomPed = v.zombie
                if DoesEntityExist(zomPed) then
                    local zomCoords = GetEntityCoords(zomPed)
                    for k,v in pairs(GetPlayers()) do
                        local plyPed = GetPlayerPed(v)
                        if DoesEntityExist(plyPed) then
                            local pedCoords = GetEntityCoords(plyPed)
                            
                            if #(zomCoords - pedCoords) <= 15 then
                                print("Target is close")
                                local vehicle = GetVehiclePedIsIn(plyPed, false)
                                if vehicle > 0 then
                                    print("Target is in vehicle, go enter it")
                                    --TaskGoToEntity(zomPed, vehicle, -1, 4.0, 3.0, 0, 0)
                                    TaskEnterVehicle(zomPed, vehicle, -1, -1, 1.0, 8, 0)
                                    Citizen.Wait(10000)
                                end
                            end
                        end
                    end
                end
            end
        end
        Citizen.Wait(1000)
    end
end) ]]
--If a player is within attack distance zombies are tasked to combat that ped
--[[ Citizen.CreateThread(function()
    while true do
        if #zombies >=1 then
            for k,v in pairs(zombies) do
                --If the zombie ent doesn't exist skip
                if not DoesEntityExist(v.zombie) then goto skip end
                local zombie = v.zombie
                local zombieCoords = GetEntityCoords(zombie)
                local alreadyAttacking = nil
                for k,v in pairs(GetPlayers()) do
                    --Add ducking property to characterData that updates when the player ducks then check it here
                    duckingCB = nil
                    TriggerClientEvent("fivez:IsPlayerDucking", v)
                    while duckingCB == nil do
                        Citizen.Wait(0)
                    end
                    for k,attackingZombie in pairs(zombiesAttacking) do
                        if attackingZombie.zombie == zombie then
                            if attackingZombie.attacking == v then
                                goto skipplayer
                            elseif attackingZombie.attacking ~= v then
                                alreadyAttacking = attackingZombie
                            end
                        end
                    end
                    
                    if GetEntityHealth(GetPlayerPed(v)) <= 0 then goto skipplayer end

                    local plyCoords = GetEntityCoords(GetPlayerPed(v))
                    --If player is not ducking and the zombie is within attack range
                    if #(zombieCoords - plyCoords) <= Config.ZombieAttackDistance then
                        print("Setting zombie to attack player", zombie, v)
                        if alreadyAttacking then
                            TaskGoToEntity(zombie, GetPlayerPed(v), -1, 0.5, 1.0, 1073741824, 0)
                            alreadyAttacking.attacking = v
                            alreadyAttacking.started = GetGameTimer()
                            TriggerClientEvent("fivez:ZombieStartedAttacking", -1, NetworkGetNetworkIdFromEntity(zombie), v)
                        end
                        --TaskCombatPed(zombie, GetPlayerPed(v), 0, 16)
                        if not alreadyAttacking then
                            TaskGoToEntity(zombie, GetPlayerPed(v), -1, 0.5, 1.0, 1073741824, 0)
                            TriggerClientEvent("fivez:ZombieStartedAttacking", -1, NetworkGetNetworkIdFromEntity(zombie), v)
                            table.insert(zombiesAttacking, {zombie = zombie, attacking = v, started = GetGameTimer()})
                        end
                    end
                    ::skipplayer::
                end
                ::skip::
            end
        end
        Citizen.Wait(0)
    end
end) ]]

--[[ Citizen.CreateThread(function()
    while true do
        if #zombiesAttacking >= 1 then
            for zombieAttackingId,v in pairs(zombiesAttacking) do
                if not DoesEntityExist(v.zombie) then goto skip end
                if IsPedDeadOrDying(v.zombie) or GetEntityHealth(v.zombie) <= 0 then table.remove(zombiesAttacking, zombieAttackingId) goto skip end
                local zombie = v.zombie
                local zombieCoords = GetEntityCoords(zombie)
                local attackingTarget = v.attacking
                for k,v in pairs(GetPlayers()) do
                    if v == attackingTarget then
                        local plyCoords = GetEntityCoords(GetPlayerPed(v))
                        local pedTask = GetPedScriptTaskCommand(zombie)
                        if #(plyCoords - zombieCoords) >= Config.ZombieDeagroDistance then
                            --Stop the zombie from chasing after a certain distance
                            TriggerClientEvent("fivez:ZombieStoppedAttacking", -1, NetworkGetNetworkIdFromEntity(zombie))
                            table.remove(zombiesAttacking, zombieAttackingId)
                        elseif GetEntityHealth(GetPlayerPed(v)) <= 1 then
                            --Stop attacking if the player is dead
                            TriggerClientEvent("fivez:ZombieStoppedAttacking", -1, NetworkGetNetworkIdFromEntity(zombie))
                            table.remove(zombiesAttacking, zombieAttackingId)
                        elseif pedTask == 0 then
                            --If the zombie ped has no task, yet it should be attacking
                            print("Attacking zombie doing nothing, sending it to attack", pedTask)
                            TaskGoToEntity(zombie, GetPlayerPed(attackingTarget), -1, 0.0, 2.0, 1073741824, 0)
                        elseif #(plyCoords - zombieCoords) < 5 then
                            if pedTask ~= 780511057 then
                                TaskCombatPed(zombie, GetPlayerPed(attackingTarget), 0, 16)
                                print("Set combat ped", GetPedScriptTaskCommand(zombie))
                                Citizen.Wait(25)
                            end
                        elseif #(plyCoords - zombieCoords) > 5 and pedTask == 780511057 then
                            print("Start walking after player")
                            TriggerClientEvent("fivez:ZombieWalk", -1, NetworkGetNetworkIdFromEntity(zombie))
                            ClearPedTasksImmediately(zombie)
                            ClearPedTasks(zombie)
                            ClearPedSecondaryTask(zombie)
                            TaskGoToEntity(zombie, GetPlayerPed(attackingTarget), -1, 0.0, 2.0, 1073741824, 0)
                        end
                    end
                end
                ::skip::
            end
        end
        Citizen.Wait(0)
    end
end) ]]

RegisterNetEvent("fivez:ShootingWeapon", function(weaponShooting)
    local source = source
    local pedCoords = GetEntityCoords(GetPlayerPed(source))
    local weaponNoise = Config.WeaponNoise[weaponShooting]
    for k,v in pairs(zombies) do
        --If the distance between the zombie and player is closer than how loud the weapon was
        if #(GetEntityCoords(v.zombie) - pedCoords) <= weaponNoise.unsilenced then
            --Tell the zombie to go investigate the noise
            TaskGoToCoordAnyMeans(v.zombie, pedCoords.x, pedCoords.y, pedCoords.z, 5.0, 0, 0, 786603, 0)
            --TaskGoToEntity(v.zombie, GetPlayerPed(source), -1, 0.0, 5.0, 1073741824, 0)
        end
    end
end)