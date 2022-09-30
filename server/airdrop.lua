local headingCB = nil
RegisterNetEvent("fivez:GetHeadingFromVectorCB", function(result)
    headingCB = result
end)

function StartAirDropWIP(dropPos)
    Citizen.CreateThread(function()
        --Get a random heading
        local rHeading = math.random(0, 360)+0.0
        --How far the plane spawns from the drop coord
        local spawnDistance = 1500.0
        --Theta of random heading
        local theta = (rHeading/180) * 3.14
        --Get the planes spawn
        local rPlanespawn = vector3(dropPos.x, dropPos.y, dropPos.z) - vector3(math.cos(theta) * spawnDistance, math.sin(theta) * spawnDistance, -500)
        local dx = dropPos.x - rPlanespawn.x
        local dy = dropPos.y - rPlanespawn.y
        headingCB = nil
        --Trigger client event to do a calculation for server
        TriggerClientEvent("fivez:GetHeadingFromVector", GetPlayers()[1], dx, dy)
        while headingCB == nil do
            Citizen.Wait(1)
        end
        --local heading = GetHeadingFromVector_2d(dx, dy)
        --Create the plane that will drop the crate
        local plane = CreateVehicle(GetHashKey("alkonost"), rPlanespawn.x, rPlanespawn.y, rPlanespawn.z, headingCB, true, true)
        while not DoesEntityExist(plane) do
            Citizen.Wait(1)
        end
        TriggerClientEvent("fivez:AirdropPlane", -1, NetworkGetNetworkIdFromEntity(plane))
        SetEntityHeading(plane, headingCB)
        SetVehicleDoorsLocked(plane, 2)
        SetEntityDistanceCullingRadius(plane, 50000.0)
        --Create the ped driver that will be told where to go
        local driver = CreatePedInsideVehicle(plane, 0, GetHashKey("s_m_m_pilot_02"), -1, true, true)
        
        while not DoesEntityExist(driver) do
            Citizen.Wait(1)
        end
        TriggerClientEvent("fivez:AirdropPilot", -1, dropPos.x, dropPos.y)
        --Go to drop pos, keep z same as start position so ped doesn't nose dive
        --TaskGoToCoordAnyMeans(driver, dropPos.x, dropPos.y, 500.0, 120.0, 0.0, true, 0.0, 0.0)
        --TaskGoStraightToCoord(driver, dropPos.x, dropPos.y, 500.0, 120.0, -1, headingCB, 0.0)
        --TaskGoStraightToCoord(driver, vector3(dropPos.x, dropPos.y, dropPos.z) + vector3(0.0, 0.0, 500.0), 60.0, -1, headingCB, 0.0)
        --TaskVehicleDriveToCoord(driver, plane, dropPos.x, dropPos.y, 1500.0, 120.0, 1.0, GetEntityModel(plane), 16777216, 1.0, 1.0)
        local dist = #(GetEntityCoords(plane) - vector3(dropPos.x, dropPos.y, 500))
        while dist > 100 do
            dist = #(GetEntityCoords(plane) - vector3(dropPos.x, dropPos.y, 500))
            Citizen.Wait(1)
        end
        local planeCoords = GetEntityCoords(plane)
        TriggerClientEvent("fivez:AirdropComplete", -1)
        --TaskGoStraightToCoord(driver, -5000.0, -5000.0, 500.0, 120.0, -1, headingCB, 0.0)
        --TaskVehicleDriveToCoord(driver, plane, -5000, -5000, 1500.0, 120.0, 1.0, GetEntityModel(plane), 16777216, 1.0, 1.0)
        --Create the crate to drop, place it below the plane so it doesn't cause any issues with it
        local dropCrate = CreateObject(GetHashKey("prop_box_wood02a_pu"), planeCoords.x, planeCoords.y, planeCoords.z-2.0, true, true, false)
        while not DoesEntityExist(dropCrate) do
            Citizen.Wait(1)
        end
        FreezeEntityPosition(dropCrate, false)

        --Let the crate free fall for a second in a half
        Citizen.Wait(1500)
        --Get the crate position
        local crateCoords = GetEntityCoords(dropCrate)
        --Create a parachute to attach to the crate to stop it from falling as quick
        local parachute = CreateObject(GetHashKey("p_cargo_chute_s"), crateCoords.x, crateCoords.y, crateCoords.z, true, true, false)
        while not DoesEntityExist(parachute) do
            Citizen.Wait(1)
        end
        TriggerClientEvent("fivez:AirdropAttachParachute", -1, NetworkGetNetworkIdFromEntity(parachute), NetworkGetNetworkIdFromEntity(dropCrate))
        --Wait until the drop crate hits the ground
        while DoesEntityExist(dropCrate) do
            Citizen.Wait(50)
        end
        --Get the parachutes position
        crateCoords = GetEntityCoords(parachute)
        --Delete the parachute
        DeleteEntity(parachute)
        --Create the actual loot crate
        local lootCrate = CreateObject(GetHashKey("ex_prop_adv_case"), crateCoords.x, crateCoords.y, crateCoords.z, true, true, false)
        while not DoesEntityExist(lootCrate) do
            Citizen.Wait(1)
        end
        TriggerClientEvent("fivez:AddNotification", -1, "Airdrop has touched ground! Find and loot it!")
        return
    end)
end

local crateBroken = nil

RegisterNetEvent("fivez:AirdropCrateBrokenCB", function(result)
    crateBroken = result
end)

function StartAirDrop(dropPos)
    Citizen.CreateThread(function()
        TriggerClientEvent("fivez:AddNotification", -1, "Airdrop has dropped! Look to the skies!")
        local dropCrate = CreateObject(GetHashKey("prop_box_wood02a_pu"), dropPos.x+0.0, dropPos.y+0.0, 500.0, true, true, false)
        while not DoesEntityExist(dropCrate) do
            Citizen.Wait(1)
        end
        
        local crateCoords = GetEntityCoords(dropCrate)
        local parachute = CreateObject(GetHashKey("p_cargo_chute_s"), crateCoords.x+0.0, crateCoords.y+0.0, crateCoords.z+0.0, true, true, false)
        while not DoesEntityExist(parachute) do
            Citizen.Wait(1)
        end
        TriggerClientEvent("fivez:AirdropAttachParachute", -1, NetworkGetNetworkIdFromEntity(parachute), NetworkGetNetworkIdFromEntity(dropCrate))
        FreezeEntityPosition(dropCrate, false)
        FreezeEntityPosition(parachute, false)
        crateBroken = nil
        TriggerClientEvent("fivez:AirdropCrateBroken", GetPlayers()[1], NetworkGetNetworkIdFromEntity(dropCrate))
        while crateBroken == nil do
            Citizen.Wait(500)
            TriggerClientEvent("fivez:AirdropCrateBroken", GetPlayers()[1], NetworkGetNetworkIdFromEntity(dropCrate))
        end
        print("Crate broke")
        crateCoords = GetEntityCoords(parachute)
        DeleteEntity(parachute)
        local lootCrate = CreateObject(GetHashKey("ex_prop_adv_case"), crateCoords.x+0.0, crateCoords.y+0.0, crateCoords.z+0.0, true, true, false)
        while not DoesEntityExist(lootCrate) do
            Citizen.Wait(1)
        end
        TriggerClientEvent("fivez:AddNotification", -1, "Airdrop has touched ground! Find and loot it!")
        
        return
    end)
end
--Create Air Drop
RegisterCommand("cad", function(source)
    local airdropConfig = Config.AirdropLocations[math.random(1, #Config.AirdropLocations)]
    if airdropConfig then
        StartAirDrop(airdropConfig)
    else
        print("Couldn't find a randomized air drop route!")
    end
end, true)

Citizen.CreateThread(function()
    while true do
        if #GetPlayers() >= 1 then
            Citizen.Wait(Config.AirdropTimer)
            local airdropConfig = Config.AirdropLocations[math.random(1, #Config.AirdropLocations)]
            if airdropConfig then
                StartAirDrop(airdropConfig)
            end
        else
            Citizen.Wait(Config.ServerDelayTick)
        end
        Citizen.Wait(1)
    end
end)