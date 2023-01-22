function PlayAnimationOnPlayer(source, animDict, animName)
    local targetCoords = GetEntityCoords(GetPlayerPed(source))
    for k,v in pairs(GetPlayers()) do
        if v ~= source then
            local pedCoords = GetEntityCoords(GetPlayerPed(v))
            if #(pedCoords - targetCoords) <= 50 then
                TriggerClientEvent("fivez:PlayAnimationOnNetworkPlayer", v, NetworkGetNetworkIdFromEntity(GetPlayerPed(source)), animDict, animName)
            end
        end
    end
end