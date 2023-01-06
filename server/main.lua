joinedPlayers = {}

local deadPlayers = {}
local wasDead = {}

function GetClosestDeadPlayer(coords)
    local closestPlayer = -1
    local closestDistance = -1
    if #deadPlayers >= 1 then
        for k,v in pairs(deadPlayers) do
            local targetPed = GetPlayerPed(v)
            if DoesEntityExist(targetPed) and GetEntityHealth(targetPed) <= 0 then
                local pedCoords = GetEntityCoords(targetPed)
                local dist = #(pedCoords - coords)
                if closestDistance == -1 or dist < closestDistance then
                    closestDistance = dist
                    closestPlayer = v.ply
                end
            end
        end
    end

    return closestDistance, closestPlayer
end

Citizen.CreateThread(function()
    while true do
        for k,v in pairs(Config.SafeZones) do
            if v.traders.barber then
                if v.traders.barber.pedId ~= -1 then
                    if not DoesEntityExist(v.traders.barber.pedId) then
                        print("Safe zone barber doesn't exist re-creating")
                        local barberPos = v.traders.barber.position
                        local barberPed = CreatePed(0, v.traders.barber.pedModel, barberPos.x, barberPos.y, barberPos.z, v.traders.barber.heading, true, false)
                        while not DoesEntityExist(barberPed) do
                            Citizen.Wait(1)
                        end
                        Citizen.Wait(250)
                        v.traders.barber.pedId = barberPed
                        SetEntityCoords(barberPed, barberPos.x, barberPos.y, barberPos.z, true, false, false, false)
                        FreezeEntityPosition(barberPed, true)
                        SetEntityDistanceCullingRadius(barberPed, 50000.0)
                    end
                end
            end

            if v.traders.clothes then
                if v.traders.clothes.pedId ~= -1 then
                    if not DoesEntityExist(v.traders.clothes.pedId) then
                        local clothesPos = v.traders.clothes.position
                        local clothesPed = CreatePed(0, v.traders.clothes.pedModel, clothesPos.x, clothesPos.y, clothesPos.z, v.traders.clothes.heading, true, false)
                        while not DoesEntityExist(clothesPed) do
                            Citizen.Wait(1)
                        end
                        Citizen.Wait(250)
                        v.traders.clothes.pedId = clothesPed
                        SetEntityCoords(clothesPed, clothesPos.x, clothesPos.y, clothesPos.z, true, false, false, false)
                        FreezeEntityPosition(clothesPed, true)
                        SetEntityDistanceCullingRadius(clothesPed, 50000.0)
                    end
                end
            end
        end

        Citizen.Wait(5000)
    end
end)

--Server thread to spawn any trader peds for safe zones, waits until somebody has connected before spawning peds
Citizen.CreateThread(function()
    while true do
        if #GetPlayers() >= 1 then
            SpawnSafeZonePeds()
            return
        else
            Citizen.Wait(Config.ServerDelayTick)
        end
        Citizen.Wait(1)
    end
end)

function SpawnSafeZonePeds()
    for k,v in pairs(Config.SafeZones) do
        if v.traders.barber then
            if v.traders.barber.pedId == -1 then
                print("Spawning barber ped")
                --Try to spawn ped inside thread
                Citizen.CreateThread(function()
                    local barberPos = v.traders.barber.position
                    local barberPed = CreatePed(0, v.traders.barber.pedModel, barberPos.x-0.0, barberPos.y-0.0, barberPos.z-0.0, v.traders.barber.heading, true, true)
                    while not DoesEntityExist(barberPed) do
                        Citizen.Wait(1)
                    end
                    Citizen.Wait(250)
                    SetEntityDistanceCullingRadius(barberPed, 50000.0)
                    print("Spawned barber ped", barberPed, NetworkGetNetworkIdFromEntity(barberPed))
                    v.traders.barber.pedId = barberPed
                    SetEntityCoords(barberPed, barberPos.x, barberPos.y, barberPos.z, true, false, false, false)
                    FreezeEntityPosition(barberPed, true)
                end)
                
            end
        end

        if v.traders.clothes then
            if v.traders.clothes.pedId == -1 then
                local clothesPos = v.traders.clothes.position
                local clothesPed = CreatePed(0, v.traders.clothes.pedModel, clothesPos.x, clothesPos.y, clothesPos.z, v.traders.clothes.heading, true, true)
                while not DoesEntityExist(clothesPed) do
                    Citizen.Wait(1)
                end
                Citizen.Wait(250)
                v.traders.clothes.pedId = clothesPed
                SetEntityCoords(clothesPed, clothesPos.x, clothesPos.y, clothesPos.z, true, false, false, false)
                FreezeEntityPosition(clothesPed, true)
                SetEntityDistanceCullingRadius(clothesPed, 50000.0)
                SetPedArmour(clothesPed, 10000)
            end
        end
    end
end
--Event to know when a player dies
RegisterNetEvent("baseevents:onPlayerDied", function(killedBy, pos)
    local source = source
    local alreadyDead = false
    for k,v in pairs(deadPlayers) do
        if v.ply == source or v.ply == killedBy then
            alreadyDead = true
        end
    end
    --If the dead player is already dead or the killer is dead?
    if alreadyDead then return end
    if killedBy ~= source and killedBy > 0 then
        local killerData = GetJoinedPlayer(killedBy)
        if killerData then
            killerData.humanity = killerData.humanity - Config.HumanityRates["killplayer"]
        end
    end
    local playerData = GetJoinedPlayer(source)
    
    table.insert(deadPlayers, {ply = source, died = GetGameTimer() + Config.RespawnTimer})
end)
--Event to know when a player is killed
RegisterNetEvent("baseevents:onPlayerKilled", function(killedBy, pos)
    local source = source
    local alreadyDead = false
    for k,v in pairs(deadPlayers) do
        if v.ply == source or v.ply == killedBy then
            alreadyDead = true
        end
    end
    --If the dead player is already dead or the killer is dead?
    if alreadyDead then return end
    if killedBy ~= source and killedBy > 0 then
        local killerData = GetJoinedPlayer(killedBy)
        if killerData then
            killerData.humanity = killerData.humanity - Config.HumanityRates["killplayer"]
        end
    end
    local playerData = GetJoinedPlayer(source)
    
    table.insert(deadPlayers, {ply = source, died = GetGameTimer() + Config.RespawnTimer})
end)
--Thread to respawn player after certain time
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if #GetPlayers() >= 1 then
            for k,v in pairs(deadPlayers) do
                if GetGameTimer() > v.died then
                    local playerData = GetJoinedPlayer(v.ply)
                    --local newGender = math.random(0, 1)
                    if playerData then
                        --playerData.characterData.gender = newGender
                        --SQL_UpdateCharacterGender(playerData.characterData.Id, newGender)
                        if Config.LoseItemsOnDeath then
                            if Config.DropItemsOnDeath then
                                local newInv = RegisterNewInventory("deadbody:"..v.ply, "inventory", "Dead Player", playerData.characterData.inventory.weight, playerData.characterData.inventory.maxweight, playerData.characterData.inventory.maxslots, playerData.characterData.inventory.items, GetEntityCoords(GetPlayerPed(v.ply)))
                                if newInv ~= nil then
                                    AddInventoryMarker(GetEntityCoords(GetPlayerPed(v.ply)))
                                end
                            end
                            SQL_ClearCharacterInventoryItems(playerData.characterData.Id)
                            for k,v in pairs(playerData.characterData.inventory.items) do
                                if v.itemId then
                                    playerData.characterData.inventory.items[k] = EmptySlot()
                                end
                            end
                            for k,v in pairs(Config.StartingItems) do
                                playerData.characterData.inventory.items[v.slot] = v.item
                                SQL_InsertItemToCharacterInventory(playerData.characterData.Id, v.slot, v.item)
                            end
                            TriggerClientEvent("fivez:UpdateCharacterInventoryItems", v.ply, json.encode(playerData.characterData.inventory.items), nil)
                        end
                        print("Respawning player", v.ply)
                        TriggerClientEvent("fivez:OpenSpawnMenu", v.ply, nil)
                        table.insert(wasDead, v.ply)
                        --TriggerClientEvent("fivez:RespawnPlayer", v.ply, newGender)
                        playerData.characterData.health = 100
                        playerData.characterData.armor = 0
                        playerData.characterData.hunger = 100
                        playerData.characterData.thirst = 100
                        playerData.characterData.stress = 0
                        playerData.characterData.humanity = 0
                        for k,v in pairs(playerData.characterData.skills) do
                            v.Xp = 0
                            v.Level = 1
                        end
                        SQL_ResetCharacterStats(playerData.characterData.Id, playerData.characterData.gender)
                        table.remove(deadPlayers, k)
                    end
                end
            end
        else
            Citizen.Wait(Config.DelayServerTick)
        end
        Citizen.Wait(1000)
    end
end)
--Event for respawning a player when they want to
RegisterNetEvent("fivez:DeathRespawnNow", function()
    local source = source
    for k,v in pairs(deadPlayers) do
        if v.ply == source then
            local playerData = GetJoinedPlayer(source)
            if playerData then
                if Config.LoseItemsOnDeath then
                    if Config.DropItemsOnDeath then
                        local newInv = RegisterNewInventory("deadbody:"..v.ply, "inventory", "Dead Player", playerData.characterData.inventory.weight, playerData.characterData.inventory.maxweight, playerData.characterData.inventory.maxslots, playerData.characterData.inventory.items, GetEntityCoords(GetPlayerPed(v.ply)))
                        if newInv ~= nil then
                            AddInventoryMarker(GetEntityCoords(GetPlayerPed(v.ply)))
                        end
                    end
                    SQL_ClearCharacterInventoryItems(playerData.characterData.Id)
                    for k,v in pairs(playerData.characterData.inventory.items) do
                        if v.itemId then
                            playerData.characterData.inventory.items[k] = EmptySlot()
                        end
                    end
                    for k,v in pairs(Config.StartingItems) do
                        playerData.characterData.inventory.items[k] = v.item
                        SQL_InsertItemToCharacterInventory(playerData.characterData.Id, v.slot, v.item)
                    end
                    TriggerClientEvent("fivez:UpdateCharacterInventoryItems", v.ply, json.encode(playerData.characterData.inventory.items), nil)
                end
                
                TriggerClientEvent("fivez:OpenSpawnMenu", source, nil)
                table.insert(wasDead, v.ply)
                --TriggerClientEvent("fivez:RespawnPlayer", v.ply, playerData.characterData.gender)
                playerData.characterData.health = 100
                playerData.characterData.armor = 0
                playerData.characterData.hunger = 100
                playerData.characterData.thirst = 100
                playerData.characterData.stress = 0
                playerData.characterData.humanity = 0
                for k,v in pairs(playerData.characterData.skills) do
                    v.Xp = 0
                    v.Level = 1
                end
                SQL_ResetCharacterStats(playerData.characterData.Id, playerData.characterData.gender)
                table.remove(deadPlayers, k)
            end
        end
    end
end)
--Event for reviving players
RegisterNetEvent("fivez:RevivePlayer", function(targetPly)
    local source = source
    local reviverPed = GetPlayerPed(source)
    local targetPed = GetPlayerPed(targetPly)
    local dist = #(GetEntityCoords(reviverPed) - GetEntityCoords(targetPed))
    if dist <= Config.InteractWithPlayersDistance then
        local plyDead = false
        for k,v in pairs(deadPlayers) do
            if v.ply == targetPly then
                plyDead = true
            end
        end

        if plyDead then
            local reviverData = GetJoinedPlayer(source)
            reviverData.humanity = reviverData.humanity + Config.HuamnityRates["revive"]
            local targetData = GetJoinedPlayer(targetPly)
            targetData.characterData.health = 100
            targetData.characterData.armor = 0
            targetData.characterData.hunger = 100
            targetData.characterData.thirst = 100
            targetData.characterData.stress = 0
            targetData.characterData.humanity = 0
            TriggerClientEvent("fivez:RevivePlayerCB", targetPed)
        end
    end
end)
--Stops auto-created peds spawning on default routing bucket
SetRoutingBucketPopulationEnabled(0, false)
--Restrict spawning objects to server only
SetRoutingBucketEntityLockdownMode(0, "strict")

function CheckRoutingBucket(ply)
    if GetPlayerRoutingBucket(ply) == 0 then
        return true
    end
    return false
end

function SetJoinedPlayerCharacter(playerId, characterData)
    for k,v in pairs(joinedPlayers) do
        if v.Id == playerId then
            joinedPlayers[k].characterData = characterData
        end
    end
end

--Use steam identifier to get player from joinedPlayers table
function GetJoinedPlayerWithSteam(source)
    local steamIdentifier = ""
    local identifiers = GetPlayerIdentifiers(source)

    for k,v in pairs(identifiers) do
        if string.match(v, "steam:") then
            steamIdentifier = v
            break
        end
    end

    for k,v in pairs(joinedPlayers) do
        if v.steam == steamIdentifier then
            if v.source == nil then
                v.source = tonumber(source)
            end

            return v
        end
    end
end
--Use custom id to get player from joinedPlayers table
function GetJoinedPlayerWithId(id)
    for k,v in pairs(joinedPlayers) do
        if v.Id == id then
            return v
        end
    end
end
--Use source to get player from joinedPlayers table
function GetJoinedPlayer(source)
    for k,v in pairs(joinedPlayers) do
        if v.source then
            if tonumber(v.source) == tonumber(source) then
                return v
            end
        end
    end
end

RegisterNetEvent("fivez:PlayerPedRespawned", function()
    local source = source
    local playerData = GetJoinedPlayer(source)
    if playerData then
        
    end
end)

--Triggered when a new character is created
RegisterNetEvent("fivez:NewCharacterCreated", function()
    local source = source
    --Set player back to main routing bucket
    SetPlayerRoutingBucket(source, 0)
    local playerData = GetJoinedPlayer(source)
    if playerData then
        SQL_UpdateCharacterNewState(playerData.Id)
        playerData.playerSpawned = true
        if playerData.characterData then
            TriggerClientEvent("fivez:LoadCharacterData", source, json.encode(playerData.characterData))
            TriggerClientEvent("fivez:OpenSpawnMenu", source, json.encode(playerData.characterData.lastposition))
        end
    end
end)
--Triggered when a players ped is spawned
RegisterNetEvent("fivez:PlayerPedSpawned", function()
    local source = source
    local playerData = GetJoinedPlayer(source)

    if playerData then
        SetPedHeadBlendData(GetPlayerPed(source), 0, 0, 0, 0, 0, 0, 0, 0, 0, false)
        SetPedDefaultComponentVariation(GetPlayerPed(source))
        if playerData.characterData.isNew == 0 then
            playerData.playerSpawned = true
            local charAppearance = playerData.characterData.appearance
            SetPedHeadBlendData(GetPlayerPed(source), charAppearance.parents.motherShape, charAppearance.parents.fatherShape, 0, charAppearance.parents.motherSkin, charAppearance.parents.fatherSkin, 0, charAppearance.parents.shapeMix, charAppearance.parents.skinMix, 0, false)
            LoadCharacterAppearanceData(source, charAppearance)
            TriggerClientEvent("fivez:LoadCharacterData", source, json.encode(playerData.characterData))
        end
        SyncZombieStates(source)
        --TODO: Sync vehicle states when player ped has spawned
        --SyncVehicleStates(source)
        --TriggerClientEvent("fivez:LoadInventoryMarkers", source, json.encode(GetAllInventoryMarkers()))
        if playerData.characterData.gender == 1 then
            playerData.characterData.health = playerData.characterData.health - 100
        end
        SetPedArmour(GetPlayerPed(source), playerData.characterData.armor)
        --Update last position when player ped is spawned
        --SQL_UpdateCharacterPosition(playerData.Id, GetEntityCoords(GetPlayerPed(source)))
    end
end)
--Also triggered when player ped has been spawned
AddEventHandler("entityCreated", function(handle)
    if DoesEntityExist(handle) then
        print("Entity has been created!", handle, DoesEntityExist(handle), NetworkGetNetworkIdFromEntity(handle))
        --TODO: Maybe make server loop to set weather every so often
        if #joinedPlayers == 1 then
            TriggerEvent("weathersync:setWeather", "blizzard", 0.0, false, false)
            Citizen.Wait(100)
            TriggerEvent("weathersync:setWeather", "foggy", 0.0, true, false)
        end
        print("Entity type", GetEntityType(handle))
        if GetEntityType(handle) == 2 then
            local model = GetEntityModel(handle)
            if model ~= GetHashKey("bmx") and model ~= GetHashKey("cargoplane") and model ~= GetHashKey("alkonost") then
                local damageData = {}
                for k,v in pairs(spawnedVehicles) do
                    if v.veh == handle then
                        damageData = {
                            enginehealth = v.enginehealth,
                            tyres = v.tyres,
                            bodyhealth = v.bodyhealth,
                            fuellevel = v.fuellevel
                        }
                        break
                    end
                end
                print("Getting vehicle damage data", damageData.tyres, damageData.enginehealth)
                --TriggerClientEvent("fivez:SyncVehicleState", -1, NetworkGetNetworkIdFromEntity(handle), json.encode(damageData))
            end
        end
    end
end)
--Triggered when a clients NUI frame has first loaded
RegisterNetEvent("fivez:NUILoaded", function()
    local source = source
    TriggerClientEvent("fivez:SetStartFocus", source)
    --Have to use steam identifier, since source is not server id until this point
    local playerData = GetJoinedPlayerWithSteam(source)
    if playerData.isNew then
        TriggerClientEvent("fivez:OpenCharacterMenu", source, json.encode({}))
        --Tell player to get a new spawn
        --TriggerClientEvent("fivez:NewSpawn", source, playerData.characterData.gender)
        --Set the player to a routing bucket depending on how many players are joined
        SetPlayerRoutingBucket(source, #joinedPlayers+1)
        --Disable population so we don't get spam for entity created
        SetRoutingBucketPopulationEnabled(#joinedPlayers+1, false)
    elseif not playerData.isNew then
        local charData = SQL_GetCrucialCharacterData(playerData.Id)
        TriggerClientEvent("fivez:OpenCharacterMenu", source, json.encode(charData))
        --TriggerClientEvent("fivez:SpawnAtLastLoc", source, playerData.characterData.gender, json.encode(playerData.characterData.lastposition))
    end
end)

RegisterNetEvent('fivez:SpawnLocation', function(spawnId)
    local source = source
    local spawnLocation = Config.DefinedPlayerSpawns[spawnId]
    local joinedPly = GetJoinedPlayer(source)
    print("Player health", GetEntityHealth(GetPlayerPed(source)))
    local plyWasDead = false
    for k,v in pairs(wasDead) do
        if v == source then
            plyWasDead = true
            table.remove(wasDead, k)
        end
    end
    if plyWasDead then
        TriggerClientEvent("fivez:RespawnPlayer", source, joinedPly.characterData.gender, spawnId)
        return
    end
    if spawnLocation ~= nil then
        TriggerClientEvent("fivez:SpawnAtLoc", source, joinedPly.characterData.gender, spawnId)
    elseif spawnId == 0 and spawnLocation == nil then
        if joinedPly then
            TriggerClientEvent("fivez:NewSpawn", source, joinedPly.characterData.gender)
        else
            print("No joined player data when spawning at random location")
        end
    elseif spawnId == 1 then
        if joinedPly then
            TriggerClientEvent("fivez:SpawnAtLastLoc", source, joinedPly.characterData.gender, json.encode(joinedPly.characterData.lastposition))
        else
            print("No joined player data when spawning at last loc")
        end
    end
end)

RegisterNetEvent("fivez:DecayCharacter", function(runningAmount)
    --If the running amount is not 0 and the running amount isn't the config amount
    if runningAmount ~= 0 and runningAmount ~= Config.RunningDecayIncrease then print("Something fishy going on with ", GetPlayerName(source), GetJoinedPlayer(source).Id, GetPlayerIdentifiers(source)[1]) return end
    local source = source
    local playerData = GetJoinedPlayer(source)
    if playerData then
        local plyChar = playerData.characterData

        plyChar.hunger = plyChar.hunger - (Config.HungerDecay + runningAmount)
        plyChar.thirst = plyChar.thirst - (Config.ThirstDecay + runningAmount)
    end
end)

--Loop through active players
--Updates character position every 30 seconds
Citizen.CreateThread(function()
    while true do
        local players = GetPlayers()
        if #players >= 1 then
            for k,v in pairs(players) do
                local playerPed = GetPlayerPed(v)
                if DoesEntityExist(playerPed) then
                    local pedCoords = GetEntityCoords(playerPed)
                    local playerData = GetJoinedPlayer(v)
                    --If player has moved a certain distance from last position
                    if not playerData then break end
                    local lastPos = playerData.characterData.lastposition
                    if lastPos then
                        if lastPos.x ~= nil and lastPos.y ~= nil and lastPos.z ~= nil then
                            local lastPos = vector3(playerData.characterData.lastposition.x, playerData.characterData.lastposition.y, playerData.characterData.lastposition.z)
                            if #(pedCoords - lastPos) > 10 then
                                SQL_UpdateCharacterPosition(playerData.Id, pedCoords)
                            end
                        end
                    else
                        playerData.characterData.lastposition = pedCoords
                    end
                end
                --Wait 0.5 seconds between players
                Citizen.Wait(500)
            end
            --30 seconds per loop for checking players coords
            Citizen.Wait(30000)
        else
            Citizen.Wait(Config.DelayServerTick)
        end
        Citizen.Wait(0)
    end
end)

RegisterCommand("gender", function(source, args)
    local source = source
    local playerData = GetJoinedPlayer(source)
    if playerData then
        if args[1] then
            local newGender = tonumber(args[1])
            if newGender ~= 0 and newGender ~= 1 then return end
            playerData.characterData.gender = args[1]
            SQL_UpdateCharacterGender(playerData.characterData.Id, playerData.characterData.gender)
        end
    end
end, true)

RegisterCommand("announcement", function(source, args)
    local source = source
    TriggerClientEvent("fivez:AddAnnouncement", -1, args[1], args[2])
end, true)

RegisterNetEvent("fivez:TeleportRequest", function(targetName)
    local source = source
    for k,v in pairs(GetPlayers()) do
        if string.match(GetPlayerName(v), targetName) then
            TriggerClientEvent("fivez:SendTeleportRequest", v, GetPlayerName(source))
            break
        end
    end
end)

RegisterNetEvent("fivez:AcceptTeleportRequest", function(targetName)
    local source = source
    for k,v in pairs(GetPlayers()) do
        if string.match(GetPlayerName(v), targetName) then
            TriggerClientEvent("fivez:AcceptedTeleportRequest", v, GetPlayerName(source))
            local coords = GetEntityCoords(GetPlayerPed(source))
            SetEntityCoords(GetPlayerPed(v), coords.x, coords.y, coords.z, true, false, false, false)
        end
    end
end)