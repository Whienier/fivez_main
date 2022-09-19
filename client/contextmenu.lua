local ECM = exports["ContextMenu"]

ECM:Register(function(screenPos, hitSomething, worldPos, hitEntity, normalDirection)
    if IsPedDeadOrDying(GetPlayerPed(-1), 1) or GetEntityHealth(GetPlayerPed(-1)) <= 0 then return end
    if hitSomething then
        local entType = GetEntityType(hitEntity)
        if entType == 1 then
            local pedSubmenu, pedSubmenuItem = ECM:AddSubmenu(0, "Ped Menu")
            local health = GetEntityHealth(hitEntity)
            if GetEntityModel(hitEntity) == GetHashKey("mp_m_freemode_01") then
                health = health - 100
            end
            local healthItem = ECM:AddItem(pedSubmenu, "Health: "..health)
            local armorItem = ECM:AddItem(pedSubmenu, "Armor: "..GetPedArmour(hitEntity))
            --If we click on the players ped
            if hitEntity == PlayerPedId() then
                local humanityItem = ECM:AddItem(0, "Humanity: "..GetCharacterHumanity())
                local skillSubmenu, skillSubmenuItem = ECM:AddSubmenu(pedSubmenu, "Skills")
                
                local charSkills = GetCharacterSkills()
                for k,plySkill in pairs(charSkills) do
                    for k,v in pairs(Config.CustomSkills) do
                        if plySkill.Id == k then
                            ECM:AddItem(skillSubmenu, v.label..": "..plySkill.Level.." - "..plySkill.Xp)
                        end
                    end
                end
                --Test how much setting these to max effects gameplay
                --Also test if 1 and 100 values offer the same result

                local detailsItem = ECM:AddItem(0, "Use Bandage")
                ECM:OnActivate(detailsItem, function()
                    local charInventory = GetCharacterInventory()
                    for k,v in pairs(charInventory.items) do
                        if v.model == "bandage" then
                            TriggerServerEvent('fivez:InventoryUse', charInventory.Id, v.itemId, k)
                            return
                        end
                    end
                    AddNotification("You don't have any bandages")
                end)
            end
            --If ped is cuffed
            if GetPedConfigFlag(hitEntity, 120, true) then
                local uncuffItem = ECM:AddItem(0, "UnCuff Player")
                ECM:OnActivate(uncuffItem, function()
                    local charInventory = GetCharacterInventory()
                    for k,v in pairs(charInventory.items) do
                        if v.model == "cuffkeys" then
                            TriggerServerEvent("fivez:InventoryUse", charInventory.Id, v.itemId, k)
                            return
                        end
                    end
                    AddNotification("You don't have any Cuff Keys")
                end)
                local escortItem = ECM:AddItem(0, "Escort")
                ECM:OnActivate(escortItem, function()
                    ExecuteCommand("escort")
                end)
                local stopescortingItem = ECM:AddItem(0, "Stop Escorting")
                ECM:OnActivate(stopescortingItem, function()
                    ExecuteCommand("deescort")
                end)
            else
                --If ped is not cuffed
                local cuffItem = ECM:AddItem(0, "Cuff Player")
                ECM:OnActivate(cuffItem, function()
                    local charInventory = GetCharacterInventory()
                    for k,v in pairs(charInventory.items) do
                        if v.model == "cuffs" or v.model == "zipties" then
                            TriggerServerEvent("fivez:InventoryUse", charInventory.Id, v.itemId, k)
                            return
                        end
                    end
                    AddNotification("You don't have any Cuffs or Zipties")
                end)
            end
        elseif entType == 2 then
            local vehiclePedIsIn = GetVehiclePedIsIn(GetPlayerPed(-1), false)
            --Stop interacting with vehicles if in a vehicle
            if vehiclePedIsIn > 0 then
                return
            end
            local vehicleSubmenu, vehicleSubmenuItem = ECM:AddSubmenu(0, "Vehicle Menu")
            local engineHealthItem = ECM:AddItem(vehicleSubmenu, "Engine: "..GetVehicleEngineHealth(hitEntity))
            local bodyHealthItem = ECM:AddItem(vehicleSubmenu, "Body: "..GetVehicleBodyHealth(hitEntity))
            local fuelLevelItem = ECM:AddItem(vehicleSubmenu, "Fuel: "..GetVehicleFuelLevel(hitEntity))
            local tyresSubmenu = ECM:AddSubmenu(vehicleSubmenu, "Tyres")
            for i=0,GetVehicleNumberOfWheels(vehiclePedIsIn) do
                ECM:AddItem(tyresSubmenu, "Tyre "..i..':'..GetVehicleWheelHealth(vehiclePedIsIn, i))
            end
            local refuelItem = ECM:AddItem(0, "Refuel")
            ECM:OnActivate(refuelItem, function()
                local charInventory = GetCharacterInventory()
                for k,v in pairs(charInventory.items) do
                    if v.model == "smallpetroltank" then
                        TriggerServerEvent("fivez:InventoryUse", charInventory.Id, v.itemId, k)
                        return
                    end
                end
                AddNotification("You don't have any petrol tanks")
            end)
            local repairBodyItem = ECM:AddItem(0, "Repair Body")
            ECM:OnActivate(repairBodyItem, function()
                local charInventory = GetCharacterInventory()
                for k,v in pairs(charInventory.items) do
                    if v.model == "fixkit" or v.model == "bodykit" then
                        TriggerServerEvent("fivez:InventoryUse", charInventory.Id, v.itemId, k)
                        return
                    end
                end
                AddNotification("You don't have anything to fix the vehicles body")
            end)
            local repairEngineItem = ECM:AddItem(0, "Repair Engine")
            ECM:OnActivate(repairEngineItem, function()
                local charInventory = GetCharacterInventory()
                for k,v in pairs(charInventory.items) do
                    if v.model == "engine" or v.model == "fixkit" then
                        TriggerServerEvent("fivez:InventoryUse", charInventory.Id, v.itemId, k)
                        return
                    end
                end
                AddNotification("You don't have anything to fix the vehicles engine")
            end)

            local vehModel = GetEntityModel(hitEntity)
            if vehModel == GetHashKey("bmx") then
                local packbikeItem = ECM:AddItem(0, "Pack Bike")
                ECM:OnActivate(packbikeItem, function()
                    TriggerServerEvent("fivez:PackBike", NetworkGetNetworkIdFromEntity(hitEntity))
                end)
            end
        end
    end
end)