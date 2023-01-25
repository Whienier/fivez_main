RegisterNetEvent("fivez:ShootingWeapon", function(weaponHash)
    local source = source
    local playerData = GetJoinedPlayer(source)
    --Make sure the weapon the player is shooting is the one they have selected
    if weaponHash == GetSelectedPedWeapon(GetPlayerPed(source)) then
        local usingSlot = playerData.characterData.inventory.hands
        local hasAttachment = false
        if GetHashKey(playerData.characterData.inventory.items[usingSlot].model) == weaponHash then
            for k,v in pairs(playerData.characterData.inventory.items[usingSlot].attachments) do
                local configItem = Config.Items[Config.GetItemWithModel(k).itemId]
                if not configItem.isMag then
                    playerData.characterData.inventory.items[usingSlot].attachments[k] = v - 1
                    hasAttachment = true
                end
            end
            playerData.characterData.inventory.items[usingSlot].quality = playerData.characterData.inventory.items[usingSlot].quality - 1
            if playerData.characterData.inventory.items[usingSlot].quality <= 0 then
                playerData.characterData.inventory.items[usingSlot].quality = 0
                playerData.characterData.inventory.hands = -1
                SetCurrentPedWeapon(GetPlayerPed(source), GetHashKey("weapon_unarmed"), true)
            end
            if hasAttachment then
                SQL_UpdateItemAttachmentsInCharacterInventory(playerData.Id, usingSlot, playerData.characterData.inventory.items[usingSlot].attachments)
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