function SQL_GetPlayerId(ply)
    local playerData = nil
    local steamIdentifier = ""
    local identifiers = GetPlayerIdentifiers(ply)
    for k,v in pairs(identifiers) do
        if string.match(v, "steam:") then
            steamIdentifier = v
            break
        end
    end
    MySQL.ready(function()
        MySQL.Async.fetchAll("SELECT player_dataid FROM player_data WHERE player_steam = @steamIdentifier", {
            ["steamIdentifier"] = steamIdentifier
        }, function(result)
            if result[1] then
                playerData = result[1]
            else
                playerData = false
            end
        end)
    end)

    while playerData == nil do
        Citizen.Wait(0)
    end

    return playerData
end

function SQL_CheckPlayerData(steamIdentifier)
    local checked = nil
    MySQL.Async.fetchScalar("SELECT player_steam FROM player_data WHERE player_steam = @steamId", {
        ["steamId"] = steamIdentifier
    }, function(result)
        if result[1] then
            checked = true
        else
            checked = false
        end
    end)
    while checked == nil do
        Citizen.Wait(0)
    end

    return checked
end

function SQL_GetPlayerData(ply, steamIdentifier)
    local playerData = nil
    MySQL.ready(function()
        MySQL.Async.fetchAll("SELECT * FROM player_data WHERE player_steam = @steamIdentifier", {
            ["steamIdentifier"] = steamIdentifier
        }, function(result)
            if result[1] then
                local tempplayerData = {
                    Id = result[1].player_dataid,
                    characterData = {},
                    playerSpawned = false
                }

                playerData = tempplayerData
            else
                playerData = false
            end
        end)
    end)

    while playerData == nil do
        Citizen.Wait(0)
    end

    return playerData
end

function SQL_GetPlayerBanData(ply, steamIdentifier)
    local banData = nil
    MySQL.ready(function()
        MySQL.Async.fetchAll("SELECT * FROM player_ban_data WHERE player_dataid = @steamIdentifier", {
            ["steamIdentifier"] = steamIdentifier
        }, function(result)
            if result[1] then
                banData = result[1]
            else
                banData = false
            end
        end)
    end)

    while banData == nil do
        Citizen.Wait(0)
    end
    return banData
end

function SQL_CreatePlayerData(steamIdentifier, plyName)
    local createdData = nil

    MySQL.ready(function()
        MySQL.Async.insert("INSERT INTO player_data (player_name, player_steam) VALUES (@plyName, @steamIdentifier)", {
            ["plyName"] = plyName,
            ["steamIdentifier"] = steamIdentifier
        }, function(result)
            if result > 0 then
                local tempData = {
                    Id = result,
                    characterData = {},
                    playerSpawned = false
                }

                createdData = tempData
            else
                createdData = 0
            end
        end)
    end)

    while createdData == nil do
        Citizen.Wait(0)
    end

    return createdData
end