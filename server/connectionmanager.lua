RegisterNetEvent("playerConnecting", function(plyName, setKickReason, deferrals)
    print("Player ", plyName, " is connecting")
    local source = source
    local steamIdentifier = ""
    local identifiers = GetPlayerIdentifiers(source)
    deferrals.defer()

    Citizen.Wait(0)

    deferrals.update("Welcome "..plyName.." to NoCap FiveZ! Checking SteamID, Standby")

    for _,v in pairs(identifiers) do
        if string.find(v, "steam:") then
            steamIdentifier = v
        end
    end

    Citizen.Wait(0)

    if not steamIdentifier then
        deferrals.done("Not connected to steam!")
    else
        deferrals.update("Checking for existing data!")
        local playerData = SQL_GetPlayerData(ply, steamIdentifier)
        Citizen.Wait(500)
        if playerData then
            local isBanned = SQL_GetPlayerBanData(ply, steamIdentifier)

            if isBanned then
                deferrals.done("You are banned")
            end
            table.insert(joinedPlayers, {
                Id = playerData.Id,
                steam = steamIdentifier,
                source = nil,
                name = plyName,
                characterData = playerData.characterData,
                isNew = false
            })
        else
            deferrals.update('No data found! Creating data')
            local createdData = nil
            createdData = SQL_CreatePlayerData(steamIdentifier, plyName)
            while createdData == nil do
                Citizen.Wait(0)
            end
            deferrals.update("Created data, enjoy your stay!")
            table.insert(joinedPlayers, {
                Id = createdData.Id,
                steam = steamIdentifier,
                source = nil,
                name = plyName,
                characterData = createdData.characterData,
                isNew = true
            })
        end
        deferrals.done()
    end
end)

RegisterNetEvent("playerJoining", function(oldId)
    local source = source
    local playerData = GetJoinedPlayer(source)
    if playerData then
        TriggerClientEvent("fivez:AddNotification", -1, GetPlayerName(source).." has joined!")
    end
end)

RegisterNetEvent("playerDropped", function(reason)
    local source = source
    local steamIdentifier = ""
    local identifiers = GetPlayerIdentifiers(source)
    for _,v in pairs(identifiers) do
        if string.find(v, "steam:") then
            steamIdentifier = v
        end
    end

    local joinedPlayer = GetJoinedPlayer(source)
    if joinedPlayer then
        local playerPed = GetPlayerPed(source)
        local charHealth = GetEntityHealth(playerPed)
        local charArmor = GetPedArmour(playerPed)
        local charCoords = GetEntityCoords(playerPed)
        SQL_UpdateCharacterPosition(joinedPlayer.Id, charCoords)
        SQL_UpdateCharacterHealth(joinedPlayer.Id, charHealth)
        SQL_UpdateCharacterArmor(joinedPlayer.Id, charArmor)
        SQL_UpdateCharacterHunger(joinedPlayer.Id, joinedPlayer.characterData.hunger)
        SQL_UpdateCharacterThirst(joinedPlayer.Id, joinedPlayer.characterData.thirst)
        SQL_UpdateCharacterStress(joinedPlayer.Id, joinedPlayer.characterData.stress)
        

        for k,v in pairs(joinedPlayers) do
            if v.source == source then
                print("Player has left - ", joinedPlayer.name, " - Reason - ", reason)
                table.remove(joinedPlayers, k)
            end
        end
    end
end)