local isCuffed = nil
RegisterNetEvent("fivez:IsPlayerCuffedCB", function(result)
    isCuffed = result
end)

RegisterNetEvent("fivez:EscortPlayer", function(targetPly)
    local source = source
    local plyPed = GetPlayerPed(source)
    local targetPed = GetPlayerPed(targetPly)
    if targetPed then
        local targetCoords = GetEntityCoords(targetPed)
        local plyCoords = GetEntityCoords(plyPed)
        local dist = #(targetCoords - plyCoords)
        if dist <= Config.InteractWithPlayersDistance then
            isCuffed = nil
            TriggerClientEvent("fivez:IsPlayerCuffed", targetPly)
            while isCuffed == nil do
                Citizen.Wait(0)
            end
            if isCuffed then
                TriggerClientEvent("fivez:StartEscortingPlayer", source, targetPly)
            else
                TriggerClientEvent("fivez:AddNotification", source, "Player is not cuffed!")
            end
        else
            TriggerClientEvent("fivez:AddNotification", source, "Player isn't close enough")
        end
    else
        TriggerClientEvent("fivez:AddNotification", source, "No target")
    end
end)

RegisterNetEvent("fivez:CutPlayerFree", function(targetPly)
    --TODO: Add check that player has a knife or something
    local source = source
    local plyPed = GetPlayerPed(v)
    local targetPed = GetPlayerPed(targetPly)
    if DoesEntityExist(targetPed) then
        local targetCoords = GetEntityCoords(targetPed)
        local plyCoords = GetEntityCoords(plyPed)
        local dist = #(targetCoords - plyCoords)
        if dist <= Config.InteractWithPlayersDistance then
            isCuffed = nil
            TriggerClientEvent("fivez:IsPlayerCuffed", targetPly)
            while isCuffed == nil do
                Citizen.Wait(0)
            end
            if isCuffed then
                SetPedConfigFlag(targetPed, 120, false)
            else
                TriggerClientEvent("fivez:AddNotification", source, "Player isn't cuffed!")
            end
        else
            TriggerClientEvent("fivez:AddNotification", source, "Player isn't close enough!")
        end
    else
        TriggerClientEvent("fivez:AddNotification", source, "No Target!")
    end
end)

local cuffedPlayers = {}

function CuffPlayer(ply, handcuffs)
    table.insert(cuffedPlayers, {
        ply = ply,
        handcuffs = handcuffs
    })
end