local playerPedCreated = false
local playerDied = false
local camera = nil

local spawnLocations = {
    [1] = nil,
    [2] = vector3(-183.032776, -1548.34656, 34.4813), --Safezone
    [3] = vector3(50, 50, 0), --Hospital
    [4] = vector3(-50, -50, 0) --Police department
}

RegisterNUICallback("select_location", function(data, cb)
    if data.id > 0 then
        ShowSelectedSpawn(data.id)
    end
    cb('ok')
end)

RegisterNUICallback("spawn_location", function(data, cb)
    spawnLocations[1] = nil
    TriggerServerEvent("fivez:SpawnLocation", data.id)
    cb('ok')
end)

RegisterNetEvent("fivez:OpenSpawnMenu", function(encodedLastPos)
    spawnLocations[1] = json.decode(encodedLastPos)

    SendNUIMessage({
        type = "spawnmenu",
        message = "OpenMenu"
    })
end)

function IsPlayerPedCreated()
    return playerPedCreated
end

function RespawnPlayer(onSpot, newGender)
    local playerPed = GetPlayerPed(-1)
    local pedHealth = GetEntityHealth(playerPed)
    if pedHealth <= 0 or IsPedDeadOrDying(playerPed) then
        local respawnPos = nil
        if onSpot == false then
            respawnPos = Config.PlayerSpawns[math.random(#Config.PlayerSpawns)]
        elseif onSpot == true then
            respawnPos = GetEntityCoords(playerPed)
        end
        print("Got respawn pos", respawnPos)
        DoScreenFadeOut(500)

        local model = ""
        if newGender == 0 then
            model = GetHashKey("mp_f_freemode_01")
        else
            model = GetHashKey("mp_m_freemode_01")
        end

        RequestModel(model)

        while not HasModelLoaded(model) do
            RequestModel(model)

            Citizen.Wait(0)
        end

        SetPlayerModel(PlayerId(), model)
        
        SetModelAsNoLongerNeeded(model)
        while IsScreenFadingOut() do
            Citizen.Wait(0)
        end
        local newHealth = 100
        local charData = GetCharacterData()
        charData.gender = newGender
        if charData.gender == 1 then
            newHealth = 200
        end
        ClearFocus()
        --SetFocusArea(respawnPos.x, respawnPos.y, respawnPos.z, 0.0, 0.0, 0.0)
        SetEntityCoords(playerPed, respawnPos.x, respawnPos.y, respawnPos.z, false, false, false, false)
        NetworkResurrectLocalPlayer(respawnPos.x, respawnPos.y, respawnPos.z, 0.0, true, false)
        SetPedDefaultComponentVariation(PlayerPedId())
        SetPedHeadBlendData(PlayerPedId(), charData.appearance.parents.fatherShape, charData.appearance.parents.motherShape, 0, charData.appearance.parents.fatherSkin, charData.appearance.parents.motherSkin, 0, charData.appearance.parents.shapeMix, charData.appearance.parents.skinMix, 0, false)
        DoScreenFadeIn(500)
        while IsScreenFadingIn() do
            Citizen.Wait(0)
        end
        ClearPedEnvDirt(PlayerPedId())
        ClearPedWetness(PlayerPedId())
        ClearPedBloodDamage(PlayerPedId())
        ResetCharacterData()
        SetEntityHealth(playerPed, newHealth)
        SetFocusEntity(GetPlayerPed(-1))
        AddNotification("Respawned!")
        TriggerServerEvent("fivez:PlayerPedRespawned")
        playerDied = false
    end
end

function InitialSpawn(gender, lastLocation)
    local spawnLocation = lastLocation
    local new = false
    if spawnLocation == nil then
        spawnLocation = Config.PlayerSpawns[math.random(#Config.PlayerSpawns)]
        new = true
    end
    Citizen.CreateThread(function()
        local playerPed = GetPlayerPed(-1)

        DoScreenFadeOut(500)
        while not IsScreenFadedOut() do
            Citizen.Wait(0)
        end

        FreezeEntityPosition(playerPed, true)

        local model = ""
        if gender == 0 then
            model = GetHashKey("mp_f_freemode_01")
        else
            model = GetHashKey("mp_m_freemode_01")
        end

        RequestModel(model)

        while not HasModelLoaded(model) do
            RequestModel(model)

            Citizen.Wait(0)
        end

        SetPlayerModel(PlayerId(), model)
        SetPedDefaultComponentVariation(PlayerPedId())
        SetModelAsNoLongerNeeded(model)

        RequestCollisionAtCoord(spawnLocation.x, spawnLocation.y, spawnLocation.z)

        SetEntityCoordsNoOffset(playerPed, spawnLocation.x, spawnLocation.y, spawnLocation.z, true, false, false)

        NetworkResurrectLocalPlayer(spawnLocation.x, spawnLocation.y, spawnLocation.z, 0.0, true, true, false)
        local charData = GetCharacterData()
        if charData then
            SetEntityHealth(playerPed, charData.health)
            print("Set player ped health", charData.health)
        end
        ClearPedTasksImmediately(playerPed)
        
        local time = GetGameTimer()

        while (not HasCollisionLoadedAroundEntity(playerPed) and (GetGameTimer() - time) < 5000) do
            Citizen.Wait(0) 
        end

        ShutdownLoadingScreen()

        DoScreenFadeIn(500)

        while not IsScreenFadedIn() do
            Citizen.Wait(0)
        end

        FreezeEntityPosition(PlayerPedId(), false)
        if new then
            TriggerEvent("fivez:OpenCharacterCustomizer", spawnLocation)
        end
        Citizen.Wait(0)
        TriggerServerEvent("fivez:PlayerPedSpawned")
    end)
end

function ShowSelectedSpawn(locationId)
    local spawnLocation = spawnLocations[locationId]
    --If location doesn't exist must be last position
    if spawnLocation == nil then 
        if characterData.lastposition == nil then TriggerEvent("fivez:AddNotifications", "You don't have a last position!") return end
        spawnLocation = characterData.lastposition 
    end

    SetFocusPosAndVel(spawnLocation.x, spawnLocation.y, spawnLocation.z, 0.0, 0.0, 0.0)

    if camera == nil then
        camera = CreateCamWithParams("DEFAULT_SCRIPTING_CAMERA", spawnLocation.x, spawnLocation.y, spawnLocation.z, 0.0, 0.0, 0.0, 90.0, true, 0)
    end

    SetCamActive(camera, true)
    RenderScriptCams(true, false, 0, true, false)
    SetCamCoord(camera, spawnLocation.x, spawnLocation.y, spawnLocation.z)
end

RegisterNetEvent("fivez:RevivePlayerCB", function()
    RespawnPlayer(true)
end)

RegisterNetEvent("fivez:RespawnPlayer", function(newGender)
    ClearFocus()
    RenderScriptCams(false, false, 0, true, false)
    DestroyCam(camera, false)

    camera = nil
    RespawnPlayer(false, newGender)
end)
--Initial spawn for new players
RegisterNetEvent("fivez:NewSpawn", function(gender)
    InitialSpawn(gender, nil)
end)
--Intial spawn for non new players
RegisterNetEvent("fivez:SpawnAtLastLoc", function(gender, lastLocation)
    print(lastLocation)
    lastLocation = json.decode(lastLocation)
    
    InitialSpawn(gender, vector3(lastLocation.x, lastLocation.y, lastLocation.z))
end)
local spawnCountdown = 0
local deathTimestamp = 0
Citizen.CreateThread(function()
    while true do
        if playerDied then
            SetTextFont(0)
            SetTextScale(0.0, 0.3)
            SetTextColour(128, 128, 128, 255)
            SetTextDropshadow(0, 0, 0, 0, 255)
            SetTextDropShadow()
            SetTextOutline()
            SetTextEntry("STRING")
            AddTextComponentString("Spawning in:"..tostring((Config.RespawnTimer-spawnCountdown)/1000))
            DrawText(0.5, 0.5)
            spawnCountdown = GetGameTimer() - deathTimestamp
        end
        Citizen.Wait(0)
    end
end)
--Death stuff
Citizen.CreateThread(function()
    while true do

        if IsPedDeadOrDying(GetPlayerPed(-1), 1) or GetEntityHealth(GetPlayerPed(-1)) <= 0 then
            if not playerDied then
                local deathTime = Config.RespawnTimer/1000
                deathTimestamp = GetGameTimer()
                AddNotification("Please wait "..tostring(deathTime).." seconds for respawn")
                ClearFocus()

                camera = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", GetEntityCoords(PlayerPedId()), 0, 0, 0, GetGameplayCamFov())
                SetCamActive(camera, true)

                RenderScriptCams(true, true, 1000, true, false)
            end
            playerDied = true
        end
        Citizen.Wait(5000)
    end
end)
--Death camera stuff
Citizen.CreateThread(function()
    while true do
        if playerDied then
            DisableFirstPersonCamThisFrame()

            local newPos = ProcessNewPosition()

            SetFocusArea(newPos.x, newPos.y, newPos.z, 0.0, 0.0, 0.0)

            SetCamCoord(camera, newPos.x, newPos.y, newPos.z)

            local plyCoords = GetEntityCoords(PlayerPedId())
            PointCamAtCoord(camera, plyCoords.x, plyCoords.y, plyCoords.z)
        end
        Citizen.Wait(1)
    end
end)
local angleY = 0.0
local angleZ = 0.0
function ProcessNewPosition()
    local mouseX = 0.0
    local mouseY = 0.0
    
    -- keyboard
    if (IsInputDisabled(0)) then
        -- rotation
        mouseX = GetDisabledControlNormal(1, 1) * 8.0
        mouseY = GetDisabledControlNormal(1, 2) * 8.0
        
    -- controller
    else
        -- rotation
        mouseX = GetDisabledControlNormal(1, 1) * 1.5
        mouseY = GetDisabledControlNormal(1, 2) * 1.5
    end

    angleZ = angleZ - mouseX -- around Z axis (left / right)
    angleY = angleY + mouseY -- up / down
    -- limit up / down angle to 90°
    if (angleY > 89.0) then angleY = 89.0 elseif (angleY < -89.0) then angleY = -89.0 end
    
    local pCoords = GetEntityCoords(PlayerPedId())
    
    local behindCam = {
        x = pCoords.x + ((Cos(angleZ) * Cos(angleY)) + (Cos(angleY) * Cos(angleZ))) / 2 * (1.5 + 0.5),
        y = pCoords.y + ((Sin(angleZ) * Cos(angleY)) + (Cos(angleY) * Sin(angleZ))) / 2 * (1.5 + 0.5),
        z = pCoords.z + ((Sin(angleY))) * (1.5 + 0.5)
    }
    local rayHandle = StartShapeTestRay(pCoords.x, pCoords.y, pCoords.z + 0.5, behindCam.x, behindCam.y, behindCam.z, -1, PlayerPedId(), 0)
    local a, hitBool, hitCoords, surfaceNormal, entityHit = GetShapeTestResult(rayHandle)
    
    local maxRadius = 1.5
    if (hitBool and Vdist(pCoords.x, pCoords.y, pCoords.z + 0.5, hitCoords) < 1.5 + 0.5) then
        maxRadius = Vdist(pCoords.x, pCoords.y, pCoords.z + 0.5, hitCoords)
    end
    
    local offset = {
        x = ((Cos(angleZ) * Cos(angleY)) + (Cos(angleY) * Cos(angleZ))) / 2 * maxRadius,
        y = ((Sin(angleZ) * Cos(angleY)) + (Cos(angleY) * Sin(angleZ))) / 2 * maxRadius,
        z = ((Sin(angleY))) * maxRadius
    }
    
    local pos = {
        x = pCoords.x + offset.x,
        y = pCoords.y + offset.y,
        z = pCoords.z + offset.z
    }
    
    
    -- Debug x,y,z axis
    --DrawMarker(1, pCoords.x, pCoords.y, pCoords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.03, 0.03, 5.0, 0, 0, 255, 255, false, false, 2, false, 0, false)
    --DrawMarker(1, pCoords.x, pCoords.y, pCoords.z, 0.0, 0.0, 0.0, 0.0, 90.0, 0.0, 0.03, 0.03, 5.0, 255, 0, 0, 255, false, false, 2, false, 0, false)
    --DrawMarker(1, pCoords.x, pCoords.y, pCoords.z, 0.0, 0.0, 0.0, -90.0, 0.0, 0.0, 0.03, 0.03, 5.0, 0, 255, 0, 255, false, false, 2, false, 0, false)
    
    return pos
end