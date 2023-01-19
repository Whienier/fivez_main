local characterData = nil
startThreads = false

local isShooting = false
local startedShooting = GetGameTimer()
local updatedAmmo = false

--Disable ambient sounds, music
Citizen.CreateThread(function()
    StartAudioScene("DLC_MPHEIST_TRANSITION_TO_APT_FADE_IN_RADIO_SCENE")
    SetStaticEmitterEnabled("LOS_SANTOS_VANILLA_UNICORN_01_STAGE",false)
    SetStaticEmitterEnabled("LOS_SANTOS_VANILLA_UNICORN_02_MAIN_ROOM",false)
    SetStaticEmitterEnabled("LOS_SANTOS_VANILLA_UNICORN_03_BACK_ROOM",false)
    SetAmbientZoneListStatePersistent("AZL_DLC_Hei4_Island_Disabled_Zones",false,true)
    SetAmbientZoneListStatePersistent("AZL_DLC_Hei4_Island_Zones",true,true)
    SetScenarioTypeEnabled("WORLD_VEHICLE_STREETRACE",false)
    SetScenarioTypeEnabled("WORLD_VEHICLE_SALTON_DIRT_BIKE",false)
    SetScenarioTypeEnabled("WORLD_VEHICLE_SALTON",false)
    SetScenarioTypeEnabled("WORLD_VEHICLE_POLICE_NEXT_TO_CAR",false)
    SetScenarioTypeEnabled("WORLD_VEHICLE_POLICE_CAR",false)
    SetScenarioTypeEnabled("WORLD_VEHICLE_POLICE_BIKE",false)
    SetScenarioTypeEnabled("WORLD_VEHICLE_MILITARY_PLANES_SMALL",false)
    SetScenarioTypeEnabled("WORLD_VEHICLE_MILITARY_PLANES_BIG",false)
    SetScenarioTypeEnabled("WORLD_VEHICLE_MECHANIC",false)
    SetScenarioTypeEnabled("WORLD_VEHICLE_EMPTY",false)
    SetScenarioTypeEnabled("WORLD_VEHICLE_BUSINESSMEN",false)
    SetScenarioTypeEnabled("WORLD_VEHICLE_BIKE_OFF_ROAD_RACE",false)
    StartAudioScene("FBI_HEIST_H5_MUTE_AMBIENCE_SCENE")
    StartAudioScene("CHARACTER_CHANGE_IN_SKY_SCENE")
    SetAudioFlag("PoliceScannerDisabled",true)
    SetAudioFlag("DisableFlightMusic",true)
    SetRandomEventFlag(false)
    SetDeepOceanScaler(0.0)
    DistantCopCarSirens(false)
end)

--Thread for creating config POI blips
Citizen.CreateThread(function()
    for k,v in pairs(Config.Blips) do
        local radiusBlip = AddBlipForRadius(v.position.x, v.position.y, v.position.z, v.radius)
        SetBlipAlpha(radiusBlip, 64)
        local blip = AddBlipForCoord(v.position.x, v.position.y, v.position.z)
        SetBlipSprite(blip, v.sprite)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(v.label)
        EndTextCommandSetBlipName(blip)
    end
end)

Citizen.CreateThread(function()
    --Stop health regen
    SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)

    SetWeaponsNoAutoreload(true)
    SetWeaponsNoAutoswap(true)
end)

RegisterNetEvent("fivez:GetHeadingFromVector", function(x, y)
    TriggerServerEvent("fivez:GetHeadingFromVectorCB", GetHeadingFromVector_2d(x, y))
end)

local camera = nil
function DestroyCharacterMenuCamera()
    ClearFocus()
    SetCamActive(camera, false)
    DestroyCam(camera)
    RenderScriptCams(false, true, 0.0, false, false)
    camera = nil
end

RegisterNUICallback("nui_loaded", function(data, cb)
    ShutdownLoadingScreen()
    --Disable radar mini map
    DisplayRadar(false)
    local camRot = Config.CharacterMenuCamera.rotation
    local camPos = Config.CharacterMenuCamera.position
    ClearFocus()
    
    camera = CreateCameraWithParams("DEFAULT_SCRIPTED_CAMERA", camPos.x, camPos.y, camPos.z, camRot.x, camRot.y, camRot.z, 110.0, true, 2)
    SetCamActive(camera, true)
    SetCamCoord(camera, camPos.x, camPos.y, camPos.z)
    RenderScriptCams(true, true, 0.0, true, false)

    TriggerServerEvent("fivez:NUILoaded")
    cb('ok')
end)

RegisterNetEvent("fivez:SetStartFocus", function()
    SetFocusPosAndVel(Config.CharacterMenuCamera.position.x, Config.CharacterMenuCamera.position.y, Config.CharacterMenuCamera.position.z, 0.0, 0.0, 0.0)
end)

local characters = {}

RegisterNUICallback("character_createcharacter", function(data, cb)
    if characters then
        if #characters >= 1 then
            SendNUIMessage({type = "character", name = "MaxCharacters"})
            cb('ok')
            return
        end
    end
    TriggerServerEvent("fivez:CreateCharacter", json.encode({firstname = data.first, lastname = data.last, gender = data.gender}))
    cb('ok')
end)

RegisterNUICallback("character_select", function(data, cb)
    TriggerServerEvent("fivez:SelectCharacter")
    SendNUIMessage({
        type = "character",
        name = "CloseMenu"
    })
    SetNuiFocus(false, false)
    --Set it to nil since we don't need it after character selection
    characters = nil
    cb('ok')
end)

RegisterNUICallback("character_delete", function(data, cb)
    TriggerServerEvent("fivez:DeleteCharacter")
    cb('ok')
end)

RegisterNetEvent("fivez:UpdateCharacterMenu", function(encodedCharData)
    characters = json.decode(encodedCharData)
    SendNUIMessage({
        type = "character",
        name = "UpdateCharacters",
        data = characters
    })
end)

RegisterNetEvent("fivez:OpenCharacterMenu", function(encodedCharData)
    characters = json.decode(encodedCharData)
    SendNUIMessage({
        type = "character",
        name = "OpenMenu",
        data = characters
    })
    SetNuiFocus(true, true)
end)

RegisterNetEvent("fivez:LoadCharacterData", function(charData)
    characterData = json.decode(charData)
    
    print("Loaded character data", characterData.health)
    print("Player ped health", GetEntityHealth(GetPlayerPed(-1)))
    --Enable PvP
    SetCanAttackFriendly(GetPlayerPed(-1), true, false)
    NetworkSetFriendlyFireOption(true)
    if characterData.gender == 1 then
        characterData.health = 200
    end
    --Turn blackout mode on
    SetArtificialLightsState(true)
    SetArtificialLightsStateAffectsVehicles(false)
    SetEntityHealth(GetPlayerPed(-1), characterData.health)
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
    --Allow players to stand ontop of vehicles
    OverridePedsCanStandOnTopFlag(true)

    startThreads = true
end)

RegisterNetEvent("fivez:GiveBag", function(bagId)
    SetPedComponentVariation(GetPlayerPed(-1), 5, 40, 1, 0)
    print("Give bag")
end)

RegisterNetEvent('fivez:CharacterStressed', function(newStress)
    if characterData == nil then return end

    if characterData.stress + newStress > Config.MaxStress then
        characterData.stress = Config.MaxStress
        --TODO: Swap this out for blurry vision or something
        if (GetEntityHealth(GetPlayerPed(-1)) - 2) < 20 then
            SetEntityHealth(GetPlayerPed(-1), 20)
        else
            SetEntityHealth(GetPlayerPed(-1), GetEntityHealth(GetPlayerPed(-1)) - 2)
        end
    else
        characterData.stress = newStress
        if characterData.stress >= 75 then
            SetCamEffect(1)
        end
    end
    SendNUIMessage({
        type = "fivez_hud",
        name = "UpdateStress",
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
    characterData.thirst = characterData.thirst + drinkAmount
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

RegisterNetEvent("fivez:OpenCharacterCreator", function()
    exports["fivem-appearance"]:startPlayerCustomization(function(appearance)
    
    end, {ped = false, headBlend = true, faceFeatures = true, headOverlays = true, components = true, props = true, tattoos = false})
end)

AddEventHandler("fivez:OpenCharacterCustomizer", function()
    if characterData ~= nil then print("Can't open character customizer on a non new character") return end
    local config = {
        ped = false,
        headBlend = true,
        faceFeatures = true,
        headOverlays = true,
        components = false,
        props = false,
        tattoos = false
    }
    exports["fivem-appearance"]:startPlayerCustomization(function(appearance)
        if appearance then
            local dataAppearance = {
                headOverlays = appearance.headOverlays,
                faceFeatures = appearance.faceFeatures,
                headBlend = appearance.headBlend,
                props = {
                    hat = {
                        drawable = appearance.props[1].drawable,
                        texture = appearance.props[1].texture
                    },
                    glasses = {
                        drawable = appearance.props[2].drawable,
                        texture = appearance.props[2].texture
                    },
                    ear = {
                        drawable = appearance.props[3].drawable,
                        texture = appearance.props[3].texture
                    },
                    watch = {
                        drawable = appearance.props[4].drawable,
                        texture = appearance.props[4].texture
                    },
                    bracelet = {
                        drawable = appearance.props[5].drawable,
                        texture = appearance.props[5].texture
                    }
                },
                components = {
                    face = {
                        drawable = appearance.components[1].drawable,
                        texture = appearance.components[1].texture
                    },
                    mask = {
                        drawable = appearance.components[2].drawable,
                        texture = appearance.components[2].texture
                    },
                    hair = {
                        drawable = appearance.components[3].drawable,
                        texture = appearance.components[3].texture
                    },
                    torso = {
                        drawable = appearance.components[4].drawable,
                        texture = appearance.components[4].texture
                    },
                    leg = {
                        drawable = appearance.components[5].drawable,
                        texture = appearance.components[5].texture
                    },
                    bag = {
                        drawable = appearance.components[6].drawable,
                        texture = appearance.components[6].texture
                    },
                    shoes = {
                        drawable = appearance.components[7].drawable,
                        texture = appearance.components[7].texture
                    },
                    accessory = {
                        drawable = appearance.components[8].drawable,
                        texture = appearance.components[8].texture
                    },
                    undershirt = {
                        drawable = appearance.components[9].drawable,
                        texture = appearance.components[9].texture
                    },
                    kevlar = {
                        drawable = appearance.components[10].drawable,
                        texture = appearance.components[10].texture
                    },
                    badge = {
                        drawable = appearance.components[11].drawable,
                        texture = appearance.components[11].texture
                    },
                    torso2 = {
                        drawable = appearance.components[12].drawable,
                        texture = appearance.components[12].texture
                    }
                }
            }
            TriggerServerEvent("fivez:UpdateCharacterAppearance", json.encode(dataAppearance))
            TriggerServerEvent("fivez:NewCharacterCreated")
            TriggerEvent("fivez:AddNotification", "Use [I] to open your inventory!", 8)
            TriggerEvent("fivez:AddNotification", "Hold [ALT] and right click on objects to interact!", 10)
            TriggerEvent("fivez:AddNotification", "Type /webhelp or/help for more info, all keybindings are changable in settings. Good Luck!", 12)
        end
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
    print("Get ammo count", ammoCount)

    TriggerServerEvent("fivez:GetAmmoCountCB", ammoCount)
end)

RegisterNetEvent("fivez:GetAmmoInClip", function()
    local bool, ammoCount = GetAmmoInClip(GetPlayerPed(-1), GetSelectedPedWeapon(GetPlayerPed(-1)))
    if ammoCount == nil then
        ammoCount = 0
    end
    TriggerServerEvent("fivez:GetAmmoInClipCB", ammoCount)
end)

RegisterNetEvent("fivez:SetAmmoInClip", function(hands)
    local ammo = 0
    local charInventory = GetCharacterInventory()
    for k,v in pairs(charInventory.items[hands].attachments) do
        if string.match(k, "mag") then
            ammo = v
        end
    end
    print("Setting ammo in clip", ammo)
    SetAmmoInClip(GetPlayerPed(-1), GetHashKey(charInventory.items[hands].model), ammo)
end)

RegisterNetEvent("fivez:IsPlayerDucking", function()
    TriggerServerEvent("fivez:IsPlayerDuckingCB", IsPedDucking(GetPlayerPed(-1)))
end)

--Client thread to keep the vehicles loaded on the client in-sync with server values
Citizen.CreateThread(function()
    while true do
        while not startThreads do Citizen.Wait(1) end
        local vehicles = GetGamePool("CVehicle")
        for k,v in pairs(vehicles) do
            if DoesEntityExist(v) and GetEntityModel(v) ~= GetHashKey("bmx") then
                local netId = NetworkGetNetworkIdFromEntity(v)
                if NetworkDoesEntityExistWithNetworkId(netId) then
                    TriggerServerEvent("fivez:SyncVehicleState", netId)
                end
            end
        end
        Citizen.Wait(10000)
    end
end)
RegisterNetEvent("fivez:SyncVehicleStateCB", function(vehicleNetId, data)
    local vehicle = NetworkGetEntityFromNetworkId(vehicleNetId)
    if DoesEntityExist(vehicle) then
        local dataDecoded = json.decode(data)
        SetVehicleEngineHealth(vehicle, dataDecoded.enginehealth)
        SetVehicleBodyHealth(vehicle, dataDecoded.bodyhealth)
        SetVehicleFuelLevel(vehicle, dataDecoded.fuel)
        if dataDecoded.tyres then
            for k,v in pairs(dataDecoded.tyres) do
                SetTyreHealth(vehicle, k, v)
            end
        end
    end
end)

local decayStatsInSafeZone = Config.DecayStatsInSafeZone
--Client thread to decay character hunger and thirst
Citizen.CreateThread(function()
    while true do
        while not startThreads do Citizen.Wait(0) end
        --Setting to allow to stop stats to decay while in safezone
        if not decayStatsInSafeZone then
            while IsPlayerInSafeZone() do Citizen.Wait(1) end
        end
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
        --If player is in safe zone don't damage
        while IsPlayerInSafeZone() do Citizen.Wait(1) end
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

            if GetEntityHealth(GetPlayerPed(-1)) > 20 then
                SetEntityHealth(GetPlayerPed(-1), GetEntityHealth(GetPlayerPed(-1)) - decayRate)
            end
        end

        Citizen.Wait(Config.CharacterDecayTimer)
    end
end)

--Client thread for damaging player health when thirst is low
Citizen.CreateThread(function()
    while true do
        while not startThreads do Citizen.Wait(1) end
        --If player is in safe zone don't damage
        while IsPlayerInSafeZone() do Citizen.Wait(1) end
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
                        
            if GetEntityHealth(GetPlayerPed(-1)) > 20 then
                SetEntityHealth(GetPlayerPed(-1), GetEntityHealth(GetPlayerPed(-1)) - decayRate)
            end
        end
        Citizen.Wait(Config.CharacterDecayTimer)
    end
end)

local swingingWeapon = false
local startedSwinging = nil
--Client thread to tell server if player is shooting or swinging
Citizen.CreateThread(function()
    while true do
        while not startThreads do Citizen.Wait(1) end
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
        while not startThreads do Citizen.Wait(1) end
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
        else
            --Wait 15 seconds if they don't have voip enabled
            Citizen.Wait(15000)
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
        
        if GetSelectedPedWeapon(GetPlayerPed(-1)) ~= GetHashKey("weapon_unarmed") then
            DisableControlAction(0, 45, true) --Input Reload
            DisableControlAction(0, 140, true) --Light melee
            DisableControlAction(0, 263, true) --Melee attack1
            if IsDisabledControlJustReleased(0, 45) and GetSelectedPedWeapon(GetPlayerPed(-1)) ~= GetHashKey("weapon_unarmed") then
                --Trigger reloading
                print(GetWeapontypeGroup(GetSelectedPedWeapon(GetPlayerPed(-1))))
                TriggerServerEvent("fivez:AttemptReload")
            end
        end
        Citizen.Wait(1)
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
            if characterData.gender == 1 then
                characterData.health = GetEntityHealth(GetPlayerPed(-1)) - 100
            else
                characterData.health = GetEntityHealth(GetPlayerPed(-1))
            end
            characterData.armor = GetPedArmour(GetPlayerPed(-1))
            characterData.stamina = GetPlayerStamina(PlayerId())
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
                    --Maybe send check for vehicle values
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

--Voice stuff
local drawRange = false
local voiceRange = 5.0
RegisterCommand("+voicerangeincrease", function()
    voiceRange = voiceRange + 1.0
    if voiceRange > 25 then voiceRange = 25 end
    MumbleSetAudioInputDistance(voiceRange)
    drawRange = true
end, false)
RegisterCommand("-voicerangeincrease", function() end, false)
RegisterKeyMapping("+voicerangeincrease", "Increases the range of your VOIP", "keyboard", "f4")

RegisterCommand("+voicerangedecrease", function()
    voiceRange = voiceRange - 1.0
    if voiceRange < 0 then voiceRange = 0.0 end
    MumbleSetAudioInputDistance(voiceRange)
    drawRange = true
end, false)
RegisterCommand("-voicerangedecrease", function() end, false)
RegisterKeyMapping("+voicerangedecrease", "Decrease the range of your VOIP", "keyboard", "f3")

--Thread for drawing a range indicator for voice
local drawTimestamp = nil
Citizen.CreateThread(function()
    while true do
        if drawRange then
            local coords = GetEntityCoords(GetPlayerPed(-1))
            DrawSphere(coords.x, coords.y, coords.z, voiceRange, 72, 72, 156, 0.5)
        end
        if drawTimestamp == nil and drawRange then
            drawTimestamp = GetGameTimer()
        elseif drawTimestamp ~= nil then
            if drawTimestamp + 30000 < GetGameTimer() then
                drawRange = false
                drawTimestamp = nil
            end
        end
        Citizen.Wait(1)
    end
end)

--Command for ragdolling
RegisterCommand("ragdoll", function()
    local playerPed = GetPlayerPed(-1)
    print(IsPedRagdoll(playerPed))
    if IsPedRagdoll(playerPed) then
        SetPedToRagdoll(playerPed, 1.0, 1.0, 0, true, true, false)
    else
        SetPedToRagdoll(playerPed, -1, -1, 0, true, true, false)
    end
end, false)

--Teleport requesting stuff
local teleportRequests = {}

RegisterCommand("tpr", function(source, args)
    if IsPedDeadOrDying(GetPlayerPed(-1), 1) then return end
    if args[1] then
        TriggerServerEvent("fivez:TeleportRequest", args[1])
    else
        TriggerEvent("fivez:AddNotification", "Missing name argument!")
    end
end, false)

RegisterCommand("tpa", function()
    if IsPedDeadOrDying(GetPlayerPed(-1), 1) then return end
    for k,v in pairs(teleportRequests) do
        TriggerServerEvent("fivez:AcceptTeleportRequest", v)
        AddNotification("Accepted teleport request")
        break
    end
end, false)

RegisterNetEvent("fivez:SendTeleportRequest", function(senderPly)
    for k,v in pairs(teleportRequests) do
        if v == senderPly then
            return
        end
    end

    table.insert(teleportRequests, senderPly)
    AddNotification(senderPly.." has sent you a teleport request!")
end)

RegisterNetEvent("fivez:AcceptedTeleportRequest", function(accepteName)
    AddNotification(accepteName.." has accepted your teleport request!")
end)

--Debug command for getting player pos
RegisterCommand("pos", function()
    print(GetEntityCoords(GetPlayerPed(-1)))
end, false)
RegisterCommand("heading", function()
    print(GetEntityHeading(GetPlayerPed(-1)))
end, false)

--Command to flip vehicle
RegisterCommand("flipveh", function()
    local coords = GetEntityCoords(GetPlayerPed(-1))
    local veh = GetClosestVehicle(coords.x, coords.y, coords.z, 10.0, 0, 70)
    if veh > 0 then
        PlaceObjectOnGroundProperly(veh)
    end
end, false)

--Command for suicide
RegisterCommand("suicide", function()
    SetEntityHealth(GetPlayerPed(-1), 0)
end, false)

--Command for displaying help, TODO: Swap this out for an interactive HTML page
RegisterCommand("help", function()
    TriggerEvent("chat:addMessage", {
        color = {0,0,0},
        multiline = true,
        args = { "ServerHelp", "Use the discord invite code (wuhCdjv8) to join discord! Or if you want to look at the forum again type /webhelp"}
    })
end, false)

RegisterCommand("webhelp", function()
    TriggerEvent("chat:addMessage", {
        color = {0,0,0},
        multiline = true,
        args = {"ServerHelp", "For the forum type 51.161.197.99 into your web browser!"}
    })
end, false)