local characterData = nil
startThreads = false

local isShooting = false
local startedShooting = GetGameTimer()
local updatedAmmo = false
--Disable ambient sounds
Citizen.CreateThread(function()
    StartAudioScene("CHARACTER_CHANGE_IN_SKY_SCENE")
end)

RegisterNUICallback("nui_loaded", function(data, cb)
    TriggerServerEvent("fivez:NUILoaded")
    ShutdownLoadingScreen()
    cb('ok')
end)

RegisterNetEvent("fivez:LoadCharacterAppearance", function(charData)
    print("Loading character appearance data", charData, DoesEntityExist(PlayerPedId()))
    
    characterData.appearance = json.decode(charData)
    LoadCharacterAppearanceData(characterData.appearance)
end)

RegisterNetEvent("fivez:LoadCharacterData", function(charData)
    characterData = json.decode(charData)

    print("Loaded character data", characterData.health)
    print("Player ped health", GetEntityHealth(GetPlayerPed(-1)))
    --Enable PvP
    SetCanAttackFriendly(GetPlayerPed(-1), true, false)
    NetworkSetFriendlyFireOption(true)

    --Turn blackout mode on
    SetArtificialLightsState(true)
    SetArtificialLightsStateAffectsVehicles(false)
    --Set players health to their last health
    SetEntityHealth(GetPlayerPed(-1), characterData.health)
    
    print("Set player ped health", GetEntityHealth(GetPlayerPed(-1)))

    SendNUIMessage({
        type = "message",
        message = "init",
        resourceName = "fivez_main",
        plyId = characterData.Id,
        plyMoney = 0
    })
    SendNUIMessage({
        type = "fivez_notifications",
        name = "EnableNotifications"
    })
    SendNUIMessage({
        type = "fivez_hud",
        name = "EnableHUD",
        data = json.encode(characterData)
    })
    startThreads = true
    --Allow players to stand ontop of vehicles
    OverridePedsCanStandOnTopFlag(true)
    --Disable radar mini map
    DisplayRadar(false)
end)

RegisterNetEvent('fivez:CharacterStressed', function(newStress)
    if characterData.stress + newStress > Config.MaxStress then
        characterData.stress = Config.MaxStress
        if GetEntityHealth(GetPlayerPed(-1)) - 2 < 20 then
            SetEntityHealth(GetPlayerPed(-1), 20)
        else
            SetEntityHealth(GetPlayerPed(-1), GetEntityHealth(GetPlayerPed(-1)) - 2)
        end
    else
        characterData.stress = newStress
    end
    SendNUIMessage({
        type = "fivez_hud",
        message = "UpdateStress",
        data = characterData.stress
    })
end)

function UpdateCharacterInventoryItems(items)
    characterData.inventory.items = items
end

function AteFood(eatAmount)
    characterData.hunger = characterData.hunger + eatAmount

    SendNUIMessage({
        type = "fivez_hud",
        name = "UpdateHunger",
        data = characterData.hunger
    })
end

function DrankWater(drinkAmount)
    print("Drinking water", characterData.thirst)
    characterData.thirst = characterData.thirst + drinkAmount
    print("Drank water", characterData.thirst)
    SendNUIMessage({
        type = "fivez_hud",
        name = "UpdateThirst",
        data = characterData.thirst
    })
end

function ResetCharacterData()
    characterData.health = 100
    characterData.armor = 0
    characterData.hunger = 100
    characterData.thirst = 100
    characterData.stress = 0
    characterData.humanity = 0
    characterData.skills = {}
end

function GetCharacterData()
    return characterData
end

function GetCharacterInventory()
    return characterData.inventory
end

function GetCharacterHumanity()
    return characterData.humanity
end

function GetCharacterSkills()
    return characterData.skills
end

AddEventHandler("fivez:OpenCharacterCustomizer", function(spawn)
    print("Open character customizer")
    local playerPed = GetPlayerPed(-1)
    local customizerPos = Config.CharacterCustomizerPosition
    SetEntityCoords(playerPed, customizerPos.x, customizerPos.y, customizerPos.z, true, false, false, true)
    local config = {
        ped = false,
        headBlend = true,
        faceFeatures = true,
        headOverlays = false,
        components = false,
        props = false,
        tattoos = true
    }
    exports["fivem-appearance"]:startPlayerCustomization(function(appearance)
        if appearance then
            TriggerServerEvent("fivez:UpdateCharacterAppearance", json.encode(appearance))
            TriggerServerEvent("fivez:NewCharacterCreated")
        end
        SetEntityCoords(playerPed, spawn.x, spawn.y, spawn.z, true, false, false, false)
    end, config)
end)

function Draw3DText(x,y,z,textInput,fontId,scaleX,scaleY)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)    
    local scale = (1/dist)*20
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov   
    SetTextScale(scaleX*scale, scaleY*scale)
    SetTextFont(fontId)
    SetTextProportional(1)
    SetTextColour(250, 250, 250, 255)		-- You can change the text color here
    SetTextDropshadow(1, 1, 1, 1, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(textInput)
    SetDrawOrigin(x,y,z+2, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

RegisterNetEvent("fivez:GetSelectedWepAmmoCount", function()
    local currentWeapon = GetSelectedPedWeapon(GetPlayerPed(-1))
    local ammoCount = GetAmmoInPedWeapon(GetPlayerPed(-1), currentWeapon)
    TriggerServerEvent("fivez:GetSelectedWepAmmoCountCB", ammoCount)
end)

RegisterNetEvent("fivez:GetAmmoCount", function(weaponHash)
    local ammoCount = GetAmmoInPedWeapon(GetPlayerPed(-1), weaponHash)
    TriggerServerEvent("fivez:GetAmmoCountCB", ammoCount)
end)

RegisterNetEvent("fivez:IsPlayerDucking", function()
    TriggerServerEvent("fivez:IsPlayerDuckingCB", IsPedDucking(GetPlayerPed(-1)))
end)

RegisterNetEvent("fivez:SyncVehicleState", function(vehicleNetId, vehicleData)
    local vehicle = NetworkGetEntityFromNetworkId(vehicleNetId)
    if vehicle then
        vehicleData = json.decode(vehicleData)
        if vehicleData.enginehealth then
            SetVehicleEngineHealth(vehicle, vehicleData.enginehealth)
        end
        if vehicleData.bodyhealth then
            SetVehicleBodyHealth(vehicle, vehicleData.bodyhealth)
        end
        if vehicleData.fuellevel then
            SetVehicleFuelLevel(vehicle, vehicleData.fuellevel)
        end
        if vehicleData.tyres then
            for k,v in pairs(vehicleData.tyres) do
                SetTyreHealth(vehicle, k, v)
            end
        end
        SetVehicleOnGroundProperly(vehicle)
    end
end)
--Client thread to decay character hunger and thirst
Citizen.CreateThread(function()
    while true do
        while not startThreads do Citizen.Wait(0) end
        local running = 0
        if IsPedRunning(GetPlayerPed(-1)) then
            running = Config.RunningDecayIncrease
        end
        --Trigger events like decay of food/water, maybe bleeding
        TriggerServerEvent("fivez:DecayCharacter", running)
        if characterData.hunger - Config.HungerDecay < 0 then
            characterData.hunger = 0
        else
            characterData.hunger = characterData.hunger - (Config.HungerDecay + running)
        end
        if characterData.thirst - Config.ThirstDecay < 0 then
            characterData.thirst = 0
        else
            characterData.thirst = characterData.thirst - (Config.ThirstDecay + running)
        end
        Citizen.Wait(Config.CharacterDecayTimer)
    end
end)

--Client thread for damaging player health when hunger is low
Citizen.CreateThread(function()
    while true do
        while not startThreads do Citizen.Wait(0) end
        if characterData.hunger then
            local decayRate = 0
            if characterData.hunger <= 20 then
                decayRate = 1
            end
            if characterData.hunger <= 10 then
                decayRate = decayRate + 2
            end

            if characterData.hunger <= 0 then
                decayRate = decayRate + 5
            end

            if GetEntityHealth(GetPlayerPed(-1)) <= 20 then goto skip end
            
            SetEntityHealth(GetPlayerPed(-1), GetEntityHealth(GetPlayerPed(-1)) - decayRate)
            ::skip::
        end

        Citizen.Wait(Config.CharacterDecayTimer)
    end
end)

--Client thread for damaging player health when thirst is low
Citizen.CreateThread(function()
    while true do
        while not startThreads do Citizen.Wait(0) end
        if characterData.thirst then
            local decayRate = 0
            if characterData.thirst <= 20 then
                decayRate = 1
            end
            if characterData.thirst <= 10 then
                decayRate = decayRate + 2
            end

            if characterData.thirst <= 0 then
                decayRate = decayRate + 5
            end
            
            if GetEntityHealth(GetPlayerPed(-1)) <= 20 then goto skip end
            
            SetEntityHealth(GetPlayerPed(-1), GetEntityHealth(GetPlayerPed(-1)) - decayRate)

            ::skip::
        end
        Citizen.Wait(Config.CharacterDecayTimer)
    end
end)

local swingingWeapon = false
local startedSwinging = nil
--Client thread to tell server if player is shooting or swinging
Citizen.CreateThread(function()
    while true do
        if IsPedShooting(GetPlayerPed(-1)) then
            if not isShooting then
                startedShooting = GetGameTimer()
            end
            isShooting = true
        elseif isShooting and not IsPedShooting(GetPlayerPed(-1)) then
            --If player was shooting and they stopped
            isShooting = false
            TriggerServerEvent("fivez:ShootingWeapon", GetSelectedPedWeapon(GetPlayerPed(-1)))
        end
        --If player is swinging a melee weapon
        if IsPedPerformingMeleeAction(GetPlayerPed(-1)) then
            if not swingingWeapon then
                TriggerServerEvent("fivez:SwingWeapon", GetSelectedPedWeapon(GetPlayerPed(-1)))
                startedSwinging = GetGameTimer()
            end
            swingingWeapon = true
        elseif swingingWeapon and not IsPedPerformingMeleeAction(GetPlayerPed(-1)) then
            --If player was swinging and a melee weapon and is no longer swinging
            swingingWeapon = false
        end
        Citizen.Wait(0)
    end
end)

--[[ Citizen.CreateThread(function()
    while true do

        --If we haven't updated ammo and (if it's been 30 seconds since we started shooting) the timer right now minus when the time we started shooting is greater than 30 secs
        if not updatedAmmo and (GetGameTimer() - startedShooting) > 30000 then
            updatedAmmo = GetGameTimer()
            TriggerServerEvent("fivez:ShootingWeapon", GetSelectedPedWeapon(GetPlayerPed(-1)))
        elseif (GetGameTimer() - updatedAmmo) > 30000 then
            updatedAmmo = false 
        end
        
        Citizen.Wait(0)
    end
end) ]]
--Client thread for updating HUD with microphone
Citizen.CreateThread(function()
    while true do
        if MumbleIsConnected() then
            if IsControlPressed(0, 249) then
                SendNUIMessage({
                    type = "fivez_hud",
                    name = "MicOn"
                })
            else
                SendNUIMessage({
                    type = "fivez_hud",
                    name = "MicOff"
                })
            end
        end
        Citizen.Wait(1)
    end
end)
--Client thread for disabling weapon selects and health recharge
Citizen.CreateThread(function()
    while true do
        DisableControlAction(0, 37, true) --TAB
        DisableControlAction(0, 157, true) --1
        DisableControlAction(0, 158, true) --2
        DisableControlAction(0, 160, true) --3
        DisableControlAction(0, 164, true) --4
        DisableControlAction(0, 165, true) --5
        
        --Stop health regen
        SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)
        
        Citizen.Wait(0)
    end
end)

--Thread to update HUD every half a second
Citizen.CreateThread(function()
    while true do
        while not startThreads do Citizen.Wait(0) end
        SendNUIMessage({
            type = "fivez_hud",
            name = "UpdateHUD",
            data = json.encode(characterData)
        })
        Citizen.Wait(500)
    end
end)
--Update the characterData health and armor values every half a second with the players ped values
Citizen.CreateThread(function()
    while true do
        while not startThreads do Citizen.Wait(0) end
        if characterData then
            --Remove 100 hp if male model
            if GetEntityModel(GetPlayerPed(-1)) == GetHashKey("mp_m_freemode_01") then
                characterData.health = GetEntityHealth(GetPlayerPed(-1)) - 100
            else
                characterData.health = GetEntityHealth(GetPlayerPed(-1))
            end
            characterData.armor = GetPedArmour(GetPlayerPed(-1))
        end
        Citizen.Wait(450)
    end
end)
local hudShown = false
--Thread loop for knowing when ped is in car
Citizen.CreateThread(function()
    while true do
        while not startThreads do Citizen.Wait(0) end
        if characterData then
            local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
            if vehicle > 0 then
                --Don't show hud for bike
                if GetEntityModel(vehicle) ~= GetHashKey("bmx") then
                    SendNUIMessage({
                        type = "fivez_hud",
                        name = "UpdateCarHUD",
                        data = json.encode({
                            fuel = GetVehicleFuelLevel(vehicle),
                            body = GetVehicleBodyHealth(vehicle),
                            eng = GetVehicleEngineHealth(vehicle)
                        })
                    })
                    hudShown = true
                end
            else
                if hudShown then
                    SendNUIMessage({
                        type = "fivez_hud",
                        name = "RemoveCarHUD"
                    })
                    hudShown = false
                end
            end
        end
        Citizen.Wait(500)
    end
end)

RegisterCommand("pos", function()
    print(GetEntityCoords(GetPlayerPed(-1)))
end, false)

RegisterNetEvent("fivez:RefuelVehicle", function(vehicleNetId, fuel)
    local plyPed = GetPlayerPed(-1)
    local vehicle = NetworkGetEntityFromNetworkId(vehicleNetId)
    if vehicle then
        local vehicleCoords = GetEntityCoords(vehicle)
        local pedCoords = GetEntityCoords(plyPed)
        if #(pedCoords - vehicleCoords) <= 2.5 then
            SetVehicleFuelLevel(vehicle, fuel)
        end
    end
end)

RegisterCommand("flipveh", function()
    local coords = GetEntityCoords(GetPlayerPed(-1))
    local veh = GetClosestVehicle(coords.x, coords.y, coords.z, 10.0, 0, 70)
    if veh > 0 then
        PlaceObjectOnGroundProperly(veh)
    end
end, false)

--Fuel rate consumption thread
Citizen.CreateThread(function()
    while true do
        while not startThreads do Citizen.Wait(0) end
        if characterData then
            local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
            if vehicle > 0 then
                local driver = GetPedInVehicleSeat(vehicle, -1)
                --Only do the calculation if you're the driver
                if driver == PlayerPedId() then
                    local model = GetEntityModel(vehicle)
                    local vehicleSpeed = GetEntitySpeed(vehicle)
                    local speedInKM = vehicleSpeed * 3.6

                    if speedInKM > 0 then
                        local fuelRates = Config.VehicleFuelRates[model] or Config.DefaultVehicleFuelRates
                        local highestFuelRate = -1
                        for k,v in pairs(fuelRates) do
                            if speedInKM >= k then
                                if highestFuelRate < v then
                                    highestFuelRate = v
                                end
                            end
                        end
                        if highestFuelRate ~= -1 then                            
                            local fuelLevel = GetVehicleFuelLevel(vehicle)
                            if fuelLevel > 0 or fuelLevel - highestFuelRate > 0 then
                                SetVehicleFuelLevel(vehicle, fuelLevel - highestFuelRate)
                                TriggerServerEvent("fivez:DriveVehicle")
                            else
                                SetVehicleFuelLevel(vehicle, 0)
                            end
                        end
                    end
                end
            end
        end
        Citizen.Wait(Config.VehicleFuelTimer)
    end
end)