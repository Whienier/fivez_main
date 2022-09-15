local buildingItem = nil
local allObjects = GetGamePool("CObject")
RegisterNetEvent("fivez:Building", function(objectNetId)
    local object = NetworkGetEntityFromNetworkId(objectNetId)
    if DoesEntityExist(object) then
        allObjects = GetGamePool("CObject")
        local playerFrontX = GetEntityForwardX(GetPlayerPed(-1))
        local playerFrontY = GetEntityForwardY(GetPlayerPed(-1))

        AttachEntityToEntity(object, GetPlayerPed(-1), -1, playerFrontX, playerFrontY, 0, 0, 0, 0, false, false, false, false, 0, true)
        
        buildingItem = object
        FreezeEntityPosition(GetPlayerPed(-1), true)
    end
end)
local rotOffset = 0.0
local posZOffset = 0.0
local posXOffset = 0.0
local posYOffset = 0.0
local distance, closestObjectToBuilding = nil
Citizen.CreateThread(function()
    while true do
        if buildingItem ~= nil then
            local playerFrontX = GetEntityForwardX(GetPlayerPed(-1))
            local playerFrontY = GetEntityForwardY(GetPlayerPed(-1))
            DisableControlAction(0, 140, true)
            --W
            if IsControlPressed(0, 87) then
                posYOffset = posYOffset + 0.1
                Citizen.Wait(100)
            end
            --S
            if IsControlPressed(0, 88) then
                posYOffset = posYOffset - 0.1
                Citizen.Wait(100)
            end
            --A
            if IsControlPressed(0, 89) then
                posXOffset = posXOffset - 0.1
                Citizen.Wait(100)
            end
            --D
            if IsControlPressed(0, 90) then
                posXOffset = posXOffset + 0.1
                Citizen.Wait(100)
            end
            --R, Position the item up
            if IsControlPressed(0, 45) then
                posZOffset = posZOffset + 0.1
                Citizen.Wait(100)
            end
            --F, Position the item down
            if IsControlPressed(0, 49) then
                posZOffset = posZOffset - 0.1
                Citizen.Wait(100)
            end
            --Q, Rotate heading left
            if IsControlPressed(0, 52) then
                rotOffset = rotOffset + 0.1
            end
            --E, Rotate heading right
            if IsControlPressed(0, 51) then
                rotOffset = rotOffset - 0.1
            end
            --Shift, de-select an attached object
            if IsControlJustReleased(0, 21) then
                posXOffset = 0.0
                posYOffset = 0.0
                posZOffset = 0.0
                rotOffset = 0.0
                distance = nil
                closestObjectToBuilding = nil
            end
            --Tab, find and attach the nearest object
            if IsControlJustReleased(0, 192) then
                posXOffset = 0.0
                posYOffset = 0.0
                posZOffset = 0.0
                rotOffset = 0.0
                local tempdistance, tempclosestObjectToBuilding = GetClosestObject()
                if tempdistance <= 5 then
                    distance = tempdistance
                    closestObjectToBuilding = tempclosestObjectToBuilding
                end
            end
            if closestObjectToBuilding ~= nil then
                distance = #(GetEntityCoords(buildingItem) - GetEntityCoords(closestObjectToBuilding))
                AttachEntityToEntity(buildingItem, closestObjectToBuilding, -1, posXOffset, posYOffset, posZOffset, 0, 0, rotOffset, false, false, false, false, 0, false)
            else
                AttachEntityToEntity(buildingItem, GetPlayerPed(-1), -1, posXOffset+playerFrontX, posYOffset+playerFrontY, posZOffset, 0, 0, rotOffset, false, false, false, false, 0, true)
            end
            --Enter, stop position building item
            if IsControlJustReleased(0, 176) then
                local model = GetEntityModel(buildingItem)
                local coords = GetEntityCoords(buildingItem)
                local isDoor = false
                for k,v in pairs(Config.DoorModels) do
                    if v == model then
                        isDoor = true
                    end
                end
                if isDoor then
                    if closestObjectToBuilding ~= nil then
                        DetachEntity(buildingItem, true, true)
                        AttachEntityToEntity(buildingItem, closestObjectToBuilding, -1, posXOffset, posYOffset, posZOffset, 0, 0, rotOffset, false, true, true, false, 0, false)
                        --AttachEntityToEntity(buildingItem, closestObjectToBuilding, -1, xPos, yPos, posZOffset, 0, 0, rotOffset, false, false, true, false, 0, false)
                    end

                    AddDoorToSystem("CUSTOM_DOOR_"..DoorSystemGetSize(), model, coords.x, coords.y, coords.z, false, false, false)

                    DoorSystemSetDoorState("CUSTOM_DOOR_"..DoorSystemGetSize(), 0, true, true)
                    --DoorSystemSetOpenRatio("CUSTOM_DOOR_"..DoorSystemGetSize(), 1.0, true, true)
                    --DoorSystemSetHoldOpen("CUSTOM_DOOR_"..DoorSystemGetSize(), true)
                else
                    DetachEntity(buildingItem, true, true)
                    if closestObjectToBuilding ~= nil then
                        print("Attach building item to object")
                        AttachEntityToEntity(buildingItem, closestObjectToBuilding, -1, posXOffset, posYOffset, posZOffset, 0, 0, rotOffset, false, false, true, false, 0, false)
                    end
                end
                TriggerServerEvent("fivez:FinishBuildingPlacement", NetworkGetNetworkIdFromEntity(buildingItem))
                FreezeEntityPosition(buildingItem, false)
                buildingItem = nil
                closestObjectToBuilding = nil
                FreezeEntityPosition(GetPlayerPed(-1), false)
            end
        end
        Citizen.Wait(0)
    end
end)

function GetClosestObject()
    if buildingItem ~= nil then
        local coords = GetEntityCoords(buildingItem)
        --local closestObject = GetClosestObjectOfType(coords.x, coords.y, coords.z, 10.0, -1, false, false, false)
        local closestDistance = -1
        local object = nil
        for k,v in pairs(allObjects) do
            --Make sure the object is not a ped or vehicle
            if not IsEntityAPed(v) or not IsEntityAVehicle(v) then
                --Make sure the object isn't itself and exists
                if v ~= buildingItem and DoesEntityExist(v) then
                    local objCoords = GetEntityCoords(v)
                    local dist = #(coords - objCoords)
                    if closestDistance == -1 or dist < closestDistance then
                        object = v
                        closestDistance = dist
                    end
                end
            end
        end
        return closestDistance, object
    end
end

Citizen.CreateThread(function()
    while true do
        if closestObjectToBuilding ~= nil then
            SetTextFont(0)
            SetTextScale(0.0, 0.3)
            SetTextColour(128, 128, 128, 255)
            SetTextDropshadow(0, 0, 0, 0, 255)
            SetTextDropShadow()
            SetTextOutline()
            SetTextEntry("STRING")
            AddTextComponentString("SHIFT - Detach from object\nSelected object: "..GetEntityModel(closestObjectToBuilding).."\nDistance from building item:"..distance)
            DrawText(0.45, 0.05)
        end
        if buildingItem ~= nil then
            SetTextFont(0)
            SetTextScale(0.0, 0.3)
            SetTextColour(128, 128, 128, 255)
            SetTextDropshadow(0, 0, 0, 0, 255)
            SetTextDropShadow()
            SetTextOutline()
            SetTextEntry("STRING")
            AddTextComponentString("WASD to move, E/F for up/down,Q/E for rotating\nTAB - Attachs to closest object\nPosition:"..posXOffset..","..posYOffset..","..posZOffset.."\n".."Rotation:"..rotOffset)
            DrawText(0.005, 0.5)
        end
        Citizen.Wait(0)
    end
end)