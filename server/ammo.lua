function SQL_GetWeaponAmmoCount(characterId, weaponHash)
    local ammoCount = nil
    MySQL.ready(function()
        MySQL.Async.fetchAll("SELECT character_ammo_count FROM character_ammo WHERE character_player_dataid = @characterId AND character_ammo_weaponhash = @weaponHash", {
            ["characterId"] = characterId,
            ["weaponHash"] = weaponHash
        }, function(result)
            if result[1] then
                ammoCount = result[1].character_ammo_count
            else
                --If we don't have a DB record for the weapon hash add one
                MySQL.Async.insert("INSERT INTO character_ammo(character_player_dataid, character_ammo_weaponhash, character_ammo_count) VALUES (@characterid, @weaponHash, 0)", {
                    ["characterid"] = characterId,
                    ["weaponHash"] = weaponHash
                }, function(result)
                    ammoCount = 0
                end)
            end
        end)
    end)

    while ammoCount == nil do
        Citizen.Wait(0)
    end
    return ammoCount
end

function SQL_SetWeaponAmmoCount(characterId, weaponHash, ammoCount)
    local setData = nil
    MySQL.ready(function()
        MySQL.Async.execute("UPDATE character_ammo SET character_ammo_count = @newCount WHERE character_player_dataid = @characterId AND character_ammo_weaponhash = @weaponHash", {
            ["characterId"] = characterId,
            ["weaponHash"] = weaponHash,
            ["newCount"] = ammoCount
        }, function(result)
            setData = result
        end)
    end)
    while setData == nil do
        Citizen.Wait(0)
    end
    return setData
end

local ammoCountCB = nil
RegisterNetEvent("fivez:GetAmmoCountCB", function(ammoCount)
    ammoCountCB = ammoCount
end)

function GiveAmmoToPlayer(source, weaponHash, ammo)
    ammoCountCB = nil
    TriggerClientEvent("fivez:GetAmmoCount", source, weaponHash)
    while ammoCountCB == nil do
        Citizen.Wait(0)
    end
    SetPedAmmo(GetPlayerPed(source), weaponHash, ammoCountCB + ammo)
end

RegisterNetEvent("fivez:ShootingWeapon", function(weaponHash)
    local source = source
    local playerData = GetJoinedPlayer(source)
    --Make sure the weapon the player is shooting is the one they have selected
    if weaponHash == GetSelectedPedWeapon(GetPlayerPed(source)) then
        ammoCountCB = nil
        TriggerClientEvent("fivez:GetAmmoCount", source, weaponHash)
        while ammoCountCB == nil do
            Citizen.Wait(0)
        end
        SQL_SetWeaponAmmoCount(playerData.Id, weaponHash, ammoCountCB)

        local usingSlot = playerData.characterData.inventory.hands
        if GetHashKey(playerData.characterData.inventory.items[usingSlot].model) == weaponHash then
            playerData.characterData.inventory.items[usingSlot].quality = playerData.characterData.inventory.items[usingSlot].quality - 1
            if playerData.characterData.inventory.items[usingSlot].quality <= 0 then
                playerData.characterData.inventory.items[usingSlot].quality = 0
                playerData.characterData.inventory.hands = -1
                SetCurrentPedWeapon(GetPlayerPed(source), GetHashKey("weapon_unarmed"), true)
            end
            SQL_UpdateItemQualityInCharacterInventory(playerData.Id, usingSlot, playerData.characterData.inventory.items[usingSlot].quality)
            TriggerClientEvent("fivez:UpdateInventoryItemQuality", source, usingSlot, playerData.characterData.inventory.items[usingSlot].quality)
        end
    end
end)
--Degrade weapon for using
RegisterNetEvent("fivez:SwingWeapon", function()
    local source = source
    local playerData = GetJoinedPlayer(source)
    local usingSlot = playerData.characterData.inventory.hands
    local selectedWep = GetSelectedPedWeapon(GetPlayerPed(source))
    if selectedWep ~= GetHashKey("weapon_unarmed") then
        if GetHashKey(playerData.characterData.inventory.items[usingSlot].model) == selectedWep then
            --Degrade the weapon
            playerData.characterData.inventory.items[usingSlot].quality = playerData.characterData.inventory.items[usingSlot].quality - 1
            SQL_UpdateItemQualityInCharacterInventory(playerData.Id, usingSlot, playerData.characterData.inventory.items[usingSlot].quality)
            TriggerClientEvent("fivez:UpdateInventoryItemQuality", source, usingSlot, playerData.characterData.inventory.items[usingSlot].quality)
        end
    end
end)