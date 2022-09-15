RegisterCommand("setskill", function(source, args)
    if args[1] and args[2] then
        TriggerClientEvent("fivez:UpdateSkill", source, args[1], args[2])
    end
end, true)

RegisterNetEvent("fivez:GainedExp", function(skillId)
    local source = source
    local playerData = GetJoinedPlayer(source)
    if playerData then
        for k,v in pairs(Config.CustomSkills) do
            if k == skillId then
                v.gainexp(source)
            end
        end
    end
end)

RegisterNetEvent("fivez:IsRunning", function()
    local source = source
    GetJoinedPlayer(source).characterData.isRunning = true
end)

RegisterNetEvent("fivez:IsNotRunning", function()
    local source = source
    GetJoinedPlayer(source).characterData.isRunning = false
end)

RegisterNetEvent("fivez:IsShooting", function()
    local source = source
    GetJoinedPlayer(source).characterData.isShooting = true
end)

RegisterNetEvent("fivez:IsNotShooting", function()
    local source = source
    GetJoinedPlayer(source).characterData.isShooting = false
end)

RegisterNetEvent("fivez:IsDucking", function()
    local source = source
    GetJoinedPlayer(source).characterData.isDucking = true
end)

RegisterNetEvent("fivez:IsNotDucking", function()
    local source = source
    GetJoinedPlayer(source).characterData.isDucking = false
end)

RegisterNetEvent("fivez:IsMelee", function()
    local source = source
    GetJoinedPlayer(source).characterData.isMelee = true
end)

RegisterNetEvent("fivez:IsNotMelee", function()
    local source = source
    GetJoinedPlayer(source).characterData.isMelee = false
end)

RegisterNetEvent("fivez:IsUnderwater", function()
    local source = source
    GetJoinedPlayer(source).characterData.isUnderwater = true
end)

RegisterNetEvent("fivez:IsNotUnderwater", function()
    local source = source
    GetJoinedPlayer(source).characterData.isUnderwater = false
end)