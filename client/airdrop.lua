local planeEntity = nil
local driverEntity = nil

RegisterNetEvent("fivez:AirdropPlane", function(planeNetId)
    local entity = NetworkGetEntityFromNetworkId(planeNetId)
    if DoesEntityExist(entity) then
        SetEntityDynamic(entity, true)
        ActivatePhysics(entity)
        SetVehicleForwardSpeed(entity, 120.0)
        SetHeliBladesFullSpeed(entity)
        SetVehicleEngineOn(entity, true, true, false)
        ControlLandingGear(entity, 3)
        
        planeEntity = entity
    end
end)

RegisterNetEvent("fivez:AirdropPilot", function(dropPosX, dropPosY)
    local entity = GetPedInVehicleSeat(planeEntity, -1)
    if DoesEntityExist(entity) then
        SetBlockingOfNonTemporaryEvents(entity, false)
        SetPedKeepTask(entity, true)
        SetPlaneMinHeightAboveTerrain(planeEntity, 500.0)
        --TaskPlaneMission(entity, planeEntity, 0, 0, tonumber(dropPosX), tonumber(dropPosY), 502.0, 4, 0, 0, GetEntityHeading(planeEntity), 505.0, 500.0)
        TaskVehicleDriveToCoord(entity, planeEntity, vector3(tonumber(dropPosX)+0.0, tonumber(dropPosY)+0.0, 600.0), 120.0, 1.0, GetHashKey("alkonost"), 16777216, 1.0, true)
        print("Set task")
        driverEntity = entity
    end
end)

RegisterNetEvent("fivez:AirdropComplete", function()
    if DoesEntityExist(planeEntity) and not IsPedDeadOrDying(driverEntity, 1) then
        --TaskPlaneMission(entity, planeEntity, 0, 0, -5000, -5000, 502.0, 4, 0, 0, GetEntityHeading(planeEntity), 505.0, 500.0)
        --TaskVehicleDriveToCoord(driverEntity, planeEntity, vector3(-5000, -5000, 600.0), 120.0, 1.0, GetEntityModel(planeEntity), 16777216, 1.0, true)
    end
end)

RegisterNetEvent("fivez:AirdropAttachParachute", function(parachuteNetId, dropCrateNetId)
    local parachute = NetworkGetEntityFromNetworkId(parachuteNetId)
    local dropCrate = NetworkGetEntityFromNetworkId(dropCrateNetId)
    --Attach the parachute to the drop crate
    AttachEntityToEntity(parachute, dropCrate, -1, 0, 0, 0, 0, 0, 0, false, false, false, false, 0, true)
    ActivatePhysics(dropCrate)
    local crateCoords = GetEntityCoords(dropCrate)
    AddExplosion(crateCoords.x, crateCoords.y, crateCoords.z, 20, 0.0, true, false, 0.0)
end)

RegisterNetEvent("fivez:AirdropCrateBroken", function(crateNetId)
    local entity = NetworkGetEntityFromNetworkId(crateNetId)

    if DoesEntityExist(entity) then
        if HasObjectBeenBroken(entity) then
            TriggerServerEvent("fivez:AirdropCrateBrokenCB", true)
        else
            TriggerServerEvent("fivez:AirdropCrateBrokenCB", nil)
        end
    else
        TriggerServerEvent("fivez:AirdropCrateBrokenCB", true)
    end
end)