RegisterNetEvent("fivez:AddExp", function(skillId, xp)
    local charSkills = GetCharacterSkills()
    --If the skill doesn't exist
    if not Config.CustomSkills[skillId] then return end
    local cfgData = Config.CustomSkills[skillId]
    if charSkills[skillId] then
        charSkills[skillId].Xp = xp
    else
        charSkills[skillId] = {
            Id = skillId,
            level = 1,
            Xp = 0
        }
    end
end)
--Every second apply client skill effects
--Because it's called every second it should update fine when player levels up
Citizen.CreateThread(function()
    while true do
        while not startThreads do Citizen.Wait(0) end

        local charSkills = GetCharacterSkills()
        for k,v in pairs(Config.CustomSkills) do
            if charSkills[v.Id] then
                v.clienteffect(source, charSkills[v.Id].Level)
            end
        end
        Citizen.Wait(1000)
    end
end)

local lastExpTick = {}
Citizen.CreateThread(function()
    while true do
        while not startThreads do Citizen.Wait(0) end
        Citizen.Wait(0)
        --Trigger exp tick for stamina
        if IsPedRunning(GetPlayerPed(-1)) or IsPedSprinting(GetPlayerPed(-1)) then
            if lastExpTick[1] == nil or lastExpTick[1] < GetGameTimer() then
                lastExpTick[1] = GetGameTimer() + Config.LevelTicks
                TriggerServerEvent("fivez:GainedExp", 1)
            end
        end
        --Trigger exp tick for strength
        if IsPedInMeleeCombat(GetPlayerPed(-1)) then
            if lastExpTick[2] == nil or lastExpTick[2] < GetGameTimer() then
                lastExpTick[2] = GetGameTimer() + Config.LevelTicks
                TriggerServerEvent("fivez:GainedExp", 2)
            end
        end
        --Trigger exp tick for lung capacity
        if IsPedSwimmingUnderWater(GetPlayerPed(-1)) then
            if lastExpTick[3] == nil or lastExpTick[3] < GetGameTimer() then
                lastExpTick[3] = GetGameTimer() + Config.LevelTicks
                TriggerServerEvent("fivez:GainedExp", 3)
            end
        end
        --Trigger exp tick for shooting ability
        if IsPedShooting(GetPlayerPed(-1)) then
            if lastExpTick[5] == nil or lastExpTick[5] < GetGameTimer() then
                lastExpTick[5] = GetGameTimer() + Config.LevelTicks
                TriggerServerEvent("fivez:GainedExp", 5)
            end
        end
        --Trigger exp tick for stealth ability
        if IsPedDucking(GetPlayerPed(-1)) then
            if lastExpTick[6] == nil or lastExpTick[6] < GetGameTimer() then
                lastExpTick[6] = GetGameTimer() + Config.LevelTicks
                TriggerServerEvent("fivez:GainedExp", 6)
            end
        end
    end
end)
local isRunning = false
local iShooting = false
local isDucking = false
local isMelee = false
local isUnderwater = false
Citizen.CreateThread(function()
    while true do
        while not startThreads do Citizen.Wait(0) end
        if (isRunning == false) and (IsPedRunning(GetPlayerPed(-1)) or IsPedSprinting(GetPlayerPed(-1))) then
            TriggerServerEvent("fivez:IsRunning")
            isRunning = true
        elseif (isRunning) and (not IsPedRunning(GetPlayerPed(-1)) and not IsPedSprinting(GetPlayerPed(-1))) then
            TriggerServerEvent("fivez:IsNotRunning")
            isRunning = false
        end

        if not isShooting and IsPedShooting(GetPlayerPed(-1)) then
            TriggerServerEvent("fivez:IsShooting")
            isShooting = true
        elseif isShooting and not IsPedShooting(GetPlayerPed(-1)) then
            TriggerServerEvent("fivez:IsNotShooting")
            isShooting = false
        end

        if not isDucking and IsPedDucking(GetPlayerPed(-1)) then
            TriggerServerEvent("fivez:IsDucking")
            isDucking = true
        elseif isDucking and not IsPedDucking(GetPlayerPed(-1)) then
            TriggerServerEvent("fivez:IsNotDucking")
            isDucking = false
        end

        if not isMelee and IsPedInMeleeCombat(GetPlayerPed(-1)) then
            TriggerServerEvent("fivez:IsMelee")
            isMelee = true
        elseif isMelee and not IsPedInMeleeCombat(GetPlayerPed(-1)) then
            TriggerServerEvent("fivez:IsNotMelee")
            isMelee = false
        end

        if not isUnderwater and IsPedSwimmingUnderWater(GetPlayerPed(-1)) then
            TriggerServerEvent("fivez:IsUnderwater")
            isUnderwater = true
        elseif isUnderwater and not IsPedSwimmingUnderWater(GetPlayerPed(-1)) then
            TriggerServerEvent("fivez:IsNotUnderwater")
            isUnderwater = false
        end
        Citizen.Wait(0)
    end
end)