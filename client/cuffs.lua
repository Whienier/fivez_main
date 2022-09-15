local escorting = nil

RegisterCommand("cutfree", function()
    local coords = GetEntityCoords(GetPlayerPed(-1))
    for k,v in pairs(GetActivePlayers()) do
        local plyPed = GetPlayerPed(v)
        local targetCoords = GetEntityCoords(plyPed)
        local dist = #(targetCoords - coords)
        if dist <= Config.InteractWithPlayersDistance then
            if GetPedConfigFlag(plyPed, 120, true) then
                TriggerServerEvent("fivez:CutPlayerFree", v)
            end
        end
    end
end, false)

RegisterCommand("escort", function()
    local coords = GetEntityCoords(GetPlayerPed(-1))
    for k,v in pairs(GetActivePlayers()) do
        local plyPed = GetPlayerPed(v)
        local targetCoords = GetEntityCoords(plyPed)
        local dist = #(targetCoords - coords)
        if dist <= Config.InteractWithPlayersDistance then
            if GetPedConfigFlag(plyPed, 120, true) then
                TriggerServerEvent("fivez:EscortPlayer", v)
            end
        end
    end
end, false)

RegisterCommand("deescort", function()
    if escorting then
        local targetPed = GetPlayerPed(escorting)
        DetachEntity(targetPed, true, true)
    end
end, false)

RegisterNetEvent("fivez:IsPlayerCuffed", function()
    TriggerServerEvent("fivez:IsPlayerCuffedCB", GetPedConfigFlag(GetPlayerPed(-1), 120, true))
end)

RegisterNetEvent("fivez:StartEscortingPlayer", function(targetPly)
    if GetPedConfigFlag(GetPlayerPed(targetPly), 120, true) then
        escorting = targetPly
        AttachEntityToEntity(GetPlayerPed(targetPly), GetPlayerPed(-1), 0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0, true, false, false, true, true, false)
    else
        AddNotification("Client: Player isn't cuffed!")
    end
end)

--[[ Citizen.CreateThread(function()
    while true do
        if GetPedConfigFlag(GetPlayerPed(-1), 120, true) then

        end
        Citizen.Wait(0)
    end
end) ]]