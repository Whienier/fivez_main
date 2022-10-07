local playerPedCreated = false
local playerDied = false
local camera = nil

function IsPlayerPedCreated()
    return playerPedCreated
end

function RespawnPlayer(onSpot)
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
        while IsScreenFadingOut() do
            Citizen.Wait(0)
        end
        local newHealth = 100
        local charData = GetCharacterData()
        if charData.gender == 1 then
            newHealth = 200
        end
        ClearFocus()
        --SetFocusArea(respawnPos.x, respawnPos.y, respawnPos.z, 0.0, 0.0, 0.0)
        SetEntityCoords(playerPed, respawnPos.x, respawnPos.y, respawnPos.z, false, false, false, false)
        NetworkResurrectLocalPlayer(respawnPos.x, respawnPos.y, respawnPos.z, 0.0, true, false)
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

RegisterNetEvent("fivez:RevivePlayerCB", function()
    RespawnPlayer(true)
end)

RegisterNetEvent("fivez:RespawnPlayer", function()
    ClearFocus()
    RenderScriptCams(false, false, 0, true, false)
    DestroyCam(camera, false)

    camera = nil
    RespawnPlayer(false)
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