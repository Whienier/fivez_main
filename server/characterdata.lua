RegisterNetEvent("fivez:UpdateCharacterAppearance", function(_appearance)
    local appearance = json.decode(_appearance)
    --See what data it gives to save
    print(_appearance)
    local joinedPly = GetJoinedPlayer(source)

    SQL_UpdateCharacterAppearanceData(joinedPly.Id, appearance)
end)

function SQL_InsertItemToCharacterInventory(playerId, slotId, itemData)
    local insertedItem = nil
    MySQL.ready(function()
        MySQL.Async.insert("INSERT INTO inventory_items (character_player_dataid, item_slotid, item_id, item_count, item_quality, item_attachments) VALUES (@playerId, @slotId, @itemId, @count, @quality, @attachments)", {
            ["playerId"] = playerId,
            ["slotId"] = slotId,
            ["itemId"] = itemData.id or itemData.itemId,
            ["count"] = itemData.count,
            ["quality"] = itemData.quality,
            ["attachments"] = json.encode(itemData.attachments)
        }, function(result)
            if result > 0 then
                insertedItem = true
            else
                insertedItem = false
            end
        end)
    end)

    while insertedItem == nil do
        Citizen.Wait(0)
    end

    return insertedItem
end
function SQL_RemoveItemFromCharacterInventory(playerId, slotId)
    local deletedItem = nil
    MySQL.ready(function()
        MySQL.Async.execute("DELETE FROM inventory_items WHERE character_player_dataid = @playerId AND item_slotid = @slotId", {
            ["playerId"] = playerId,
            ["slotId"] = slotId
        }, function(result)
            deletedItem = true
        end)
    end)
    while deletedItem == nil do
        Citizen.Wait(0)
    end

    return deletedItem
end
--Change item_slotid to a new value
function SQL_ChangeItemSlotIdInCharacterInventory(playerId, oldSlot, newSlot)
    local slotChanged = nil
    MySQL.ready(function()
        MySQL.Async.execute("UPDATE inventory_items SET item_slotid = @newSlot WHERE character_player_dataid = @playerId AND item_slotid = @oldSlot", {
            ["playerId"] = playerId,
            ["newSlot"] = newSlot,
            ["oldSlot"] = oldSlot
        }, function(result)
            if result then
                slotChanged = true
            else
                slotChanged = false
            end
        end)
    end)
    while slotChanged == nil do
        Citizen.Wait(0)
    end
    return slotChanged
end
function SQL_ChangeItemSlotIdWithItemIdInCharacterInventory(playerId, oldSlot, oldItemId, newSlot)
    local slotChanged = nil
    MySQL.ready(function()
        MySQL.Async.execute("UPDATE inventory_items SET item_slotid = @newSlot WHERE character_player_dataid = @playerId AND item_slotid = @oldSlot AND item_id = @oldItemId;", {
            ["playerId"] = playerId,
            ["oldSlot"] = oldSlot,
            ["oldItemId"] = oldItemId,
            ["newSlot"] = newSlot 
        }, function(result)
            slotChanged = true
        end)
    end)
    while slotChanged == nil do
        Citizen.Wait(0)
    end
    return slotChanged
end
--Change item_count to a new value relative to slot id
function SQL_UpdateItemCountInCharacterInventory(playerId, slotId, newCount)
    local changedItemCount = nil
    MySQL.ready(function()
        MySQL.Async.execute("UPDATE inventory_items SET item_count = @newCount WHERE character_player_dataid = @playerId AND item_slotid = @slotId", {
            ["playerId"] = playerId,
            ["slotId"] = slotId,
            ["newCount"] = newCount
        }, function(result)
            changedItemCount = result
        end)
    end)
    while changedItemCount == nil do
        Citizen.Wait(0)
    end
    return changedItemCount
end
--Change item quality to a new value relative to slot id
function SQL_UpdateItemQualityInCharacterInventory(playerId, slotId, newQuality)
    local changedQuality = nil
    MySQL.ready(function()
        MySQL.Async.execute("UPDATE inventory_items SET item_quality = @newQuality WHERE character_player_dataid = @playerId AND item_slotid = @slotId", {
            ["playerId"] = playerId,
            ["slotId"] = slotId,
            ["newQuality"] = newQuality
        }, function(result)
            if result then
                changedQuality = true 
            else
                changedQuality = false
            end
        end)
    end)
    while changedQuality == nil do
        Citizen.Wait(0)
    end

    return changedQuality
end

function SQL_CreateCharacterInventoryData(playerId)
    local createdInventoryData = nil

    MySQL.ready(function()
        MySQL.Async.insert("INSERT INTO character_inventory (character_player_dataid, inventory_maxslots, inventory_maxweight) VALUES (@playerId, @defaultSlots, @defaultWeight)", {
            ["playerId"] = playerId,
            ["defaultSlots"] = Config.DefaultMaxSlots,
            ["defaultWeight"] = Config.DefaultMaxWeight
        }, function(result)
            if result then
                local tempData = {
                    Id = playerId,
                    weight = 0,
                    slots = Config.DefaultMaxSlots,
                    maxweight = Config.DefaultMaxWeight,
                    items = InventoryFillEmpty(Config.DefaultMaxSlots)
                }
                createdInventoryData = tempData
            else
                createdInventoryData = false
            end
        end)
    end)

    while createdInventoryData == nil do
        Citizen.Wait(0)
    end

    return createdInventoryData
end

function SQL_GetCharacterInventoryItemsData(playerId, maxSlots)
    local gotInventoryItems = nil

    MySQL.ready(function()
        MySQL.Async.fetchAll("SELECT * FROM inventory_items WHERE character_player_dataid = @playerId", {
            ["playerId"] = playerId
        }, function(result)
            if result[1] then
                local items = InventoryFillEmpty(maxSlots)

                for k,res in pairs(result) do
                    for k,v in pairs(Config.Items) do
                        if k == res.item_id then
                            items[res.item_slotid] = {
                                itemId = k,
                                label = v.label,
                                model = v.model,
                                weight = v.weight,
                                maxcount = v.maxcount,
                                count = res.item_count,
                                quality = res.item_quality,
                                attachments = json.decode(res.item_attachments)
                            }
                        end
                    end
                end

                gotInventoryItems = items
            else
                gotInventoryItems = InventoryFillEmpty(maxSlots)
            end
        end)
    end)

    while gotInventoryItems == nil do
        Citizen.Wait(0)
    end

    return gotInventoryItems
end

function SQL_ClearCharacterInventoryItems(charId)
    local clearedData = nil
    MySQL.ready(function()
        MySQL.Async.execute("DELETE FROM inventory_items WHERE character_player_dataid = @charId",{
            ["charId"] = charId
        }, function(result)
            clearedData = result
        end)
    end)
    while clearedData == nil do
        Citizen.Wait(0)
    end
    return clearedData
end

function SQL_GetCharacterInventoryData(playerId)
    local gotInventoryData = nil

    MySQL.ready(function()
        MySQL.Async.fetchAll("SELECT * FROM character_inventory WHERE character_player_dataid = @playerId",{
            ["playerId"] = playerId
        }, function(result)
            if result[1] then
                local items = SQL_GetCharacterInventoryItemsData(playerId, result[1].inventory_maxslots)
                gotInventoryData = {
                    Id = playerId,
                    slots = result[1].inventory_maxslots,
                    maxweight = result[1].inventory_maxweight,
                    weight = 0,
                    hands = -1,
                    items = items
                }
            else
                gotInventoryData = SQL_CreateCharacterInventoryData(playerId)
            end
        end)
    end)

    while gotInventoryData == nil do
        Citizen.Wait(0)
    end

    return gotInventoryData
end

function SQL_UpdateCharacterGender(playerId, newGender)
    MySQL.ready(function()
        MySQL.Async.execute("UPDATE character_data SET character_gender = @newGender WHERE player_dataid = @playerId", {
            ["playerId"] = playerId,
            ["newGender"] = newGender
        }, function(result)
        
        end)
    end)
end

function SQL_UpdateCharacterHealth(playerId, newHealth)
    MySQL.ready(function()
        MySQL.Async.execute("UPDATE character_data SET character_health = @newHealth WHERE player_dataid = @playerId", {
            ["playerId"] = playerId,
            ["newHealth"] = newHealth
        }, function(result)
        
        end)
    end)
end

function SQL_UpdateCharacterArmor(playerId, newArmor)
    MySQL.ready(function()
        MySQL.Async.execute("UPDATE character_data SET character_armor = @newArmor WHERE player_dataid = @playerId", {
            ["playerId"] = playerId,
            ["newArmor"] = newArmor
        }, function(result)
        
        end)
    end)
end

function SQL_UpdateCharacterHunger(playerId, newHunger)
    MySQL.ready(function()
        MySQL.Async.execute("UPDATE character_data SET character_hunger = @newHunger WHERE player_dataid = @playerId", {
            ["playerId"] = playerId,
            ["newHunger"] = newHunger
        }, function(result)
        
        end)
    end)
end

function SQL_UpdateCharacterThirst(playerId, newThirst)
    MySQL.ready(function()
        MySQL.Async.execute("UPDATE character_data SET character_thirst = @newThirst WHERE player_dataid = @playerId", {
            ["playerId"] = playerId,
            ["newThirst"] = newThirst
        }, function(result)
        
        end)
    end)
end

function SQL_UpdateCharacterStress(playerId, newStress)
    MySQL.ready(function()
        MySQL.Async.execute("UPDATE character_data SET character_stress = @newStress WHERE player_dataid = @playerId", {
            ["playerId"] = playerId,
            ["newStress"] = newStress
        })
    end)
end

function SQL_UpdateCharacterHumanity(playerId, newHumanity)
    MySQL.ready(function()
        MySQL.Async.execute("UPDATE character_data SET character_humanity = @newHumanity WHERE player_dataid = @playerId",{
            ["playerId"] = playerId,
            ["newHumanity"] = newHumanity
        })
    end)
end

function SQL_UpdateCharacterPosition(playerId, newPos)
    local updatedPos = false
    MySQL.ready(function()
        MySQL.Async.execute("UPDATE character_data SET character_lastposition = @lastpos WHERE player_dataid = @playerId", {
            ["playerId"] = playerId,
            ["lastpos"] = json.encode(newPos)
        }, function(result)
            updatedPos = true
        end)
    end)

    while updatedPos == false do
        Citizen.Wait(0)
    end

    return updatedPos
end

function SQL_UpdateCharacterAppearanceData(playerId, appearanceData)
    local updatedAllData = false
    
    MySQL.ready(function()
        MySQL.Async.execute("UPDATE character_headoverlays SET character_blemishes = @blemishes, character_facialhair = @facialhair, character_eyebrows = @eyebrows, character_aging = @aging, character_makeup = @makeup, character_blush = @blush, character_complexion = @complexion, character_sundamage = @sundamage, character_lipstick = @lipstick, character_moles = @moles, character_chesthair = @chesthair, character_bodyblemishes = @bodyblemishes WHERE character_data_player_dataid = @playerId", {
            ["playerId"] = playerId,
            --Gotta find a foolproof way to always get head overlay and not opacity/color
            ["blemishes"] = appearanceData.headOverlays.blemishes.style,
            ["facialhair"] = appearanceData.headOverlays.beard.style,
            ["eyebrows"] = appearanceData.headOverlays.eyebrows.style,
            ["aging"] = appearanceData.headOverlays.ageing.style,
            ["makeup"] = appearanceData.headOverlays.makeUp.style,
            ["blush"] = appearanceData.headOverlays.blush.style,
            ["complexion"] = appearanceData.headOverlays.complexion.style,
            ["hair"] = appearanceData.hair.style,
            ["sundamage"] = appearanceData.headOverlays.sunDamage.style,
            ["lipstick"] = appearanceData.headOverlays.lipstick.style,
            ["moles"] = appearanceData.headOverlays.moleAndFreckles.style,
            ["chesthair"] = appearanceData.headOverlays.chestHair.style,
            ["bodyblemishes"] = appearanceData.headOverlays.bodyBlemishes.style
        })
        
        MySQL.Async.execute("UPDATE character_headoverlays_opacity SET character_blemishes = @blemishes, character_facialhair = @facialhair, character_eyebrows = @eyebrows, character_aging = @aging, character_makeup = @makeup, character_blush = @blush, character_complexion = @complexion, character_sundamage = @sundamage, character_lipstick = @lipstick, character_moles = @moles, character_chesthair = @chesthair, character_bodyblemishes = @bodyblemishes WHERE character_data_player_dataid = @playerId", {
            ["playerId"] = playerId,
            ["blemishes"] = appearanceData.headOverlays.blemishes.opacity,
            ["facialhair"] = appearanceData.headOverlays.beard.opacity,
            ["eyebrows"] = appearanceData.headOverlays.eyebrows.opacity,
            ["aging"] = appearanceData.headOverlays.ageing.opacity,
            ["makeup"] = appearanceData.headOverlays.makeUp.opacity,
            ["blush"] = appearanceData.headOverlays.blush.opacity,
            ["complexion"] = appearanceData.headOverlays.complexion.opacity,
            ["sundamage"] = appearanceData.headOverlays.sunDamage.opacity,
            ["lipstick"] = appearanceData.headOverlays.lipstick.opacity,
            ["moles"] = appearanceData.headOverlays.moleAndFreckles.opacity,
            ["chesthair"] = appearanceData.headOverlays.chestHair.opacity,
            ["bodyblemishes"] = appearanceData.headOverlays.bodyBlemishes.opacity
        })

        MySQL.Async.execute("UPDATE character_headoverlays_color SET character_blemishes_color = @blemishes, character_facialhair_color = @facialhair, character_eyebrows_color = @eyebrows, character_aging_color = @aging, character_makeup_color = @makeup, character_blush_color = @blush, character_complexion_color = @complexion, character_sundamage_color = @sundamage, character_lipstick_color = @lipstick, character_moles_color = @moles, character_chesthair_color = @chesthair, character_bodyblemishes_color = @bodyblemishes WHERE character_data_player_dataid = @playerId", {
            ["playerId"] = playerId,
            ["blemishes"] = appearanceData.headOverlays.blemishes.color,
            ["facialhair"] = appearanceData.headOverlays.beard.color,
            ["eyebrows"] = appearanceData.headOverlays.eyebrows.color,
            ["aging"] = appearanceData.headOverlays.ageing.color,
            ["makeup"] = appearanceData.headOverlays.makeUp.color,
            ["blush"] = appearanceData.headOverlays.blush.color,
            ["complexion"] = appearanceData.headOverlays.complexion.color,
            ["sundamage"] = appearanceData.headOverlays.sunDamage.color,
            ["lipstick"] = appearanceData.headOverlays.lipstick.color,
            ["moles"] = appearanceData.headOverlays.moleAndFreckles.color,
            ["chesthair"] = appearanceData.headOverlays.chestHair.color,
            ["bodyblemishes"] = appearanceData.headOverlays.bodyBlemishes.color
        })

        MySQL.Async.execute("UPDATE character_facefeatures SET character_nosewidth = @nosewidth, character_nosepeak = @nosepeak, character_noselength = @noselength, character_nosecurve = @nosecurve, character_nosetip = @nosetip, character_nosetwist = @nosetwist, character_eyebrowheight = @eyebrowhheight, character_eyebrowlength = @eyebrowlength, character_cheeksheight = @cheekheight, character_cheekssize = @cheeksize, character_cheekswidth = @cheekwidth, character_eyeopening = @eyeopening, character_lipthickness = @lipthickness, character_jawwidth = @jawwidth, character_jawshape = @jawshape, character_chinheight = @chinheight, character_chinlength = @chinlength, character_chinshape = @chinshape, character_chinhole = @chinhole, character_neckthickness = @neckthickness WHERE character_data_player_dataid = @playerId", {
            ["playerId"] = playerId,
            ["nosewidth"] = appearanceData.faceFeatures.noseWidth,
            ["nosepeak"] = appearanceData.faceFeatures.nosePeakHigh,
            ["noselength"] = appearanceData.faceFeatures.nosePeakSize,
            ["nosecurve"] = appearanceData.faceFeatures.nosePeakLowering,
            ["nosetip"] = appearanceData.faceFeatures.noseBoneHigh,
            ["nosetwist"] = appearanceData.faceFeatures.noseBoneTwist,
            ["eyebrowheight"] = appearanceData.faceFeatures.eyeBrownHigh,
            ["eyebrowlength"] = appearanceData.faceFeatures.eyeBrownForward,
            ["cheekheight"] = appearanceData.faceFeatures.cheeksBoneHigh,
            ["cheeksize"] = appearanceData.faceFeatures.cheeksWidth,
            ["cheekwidth"] = appearanceData.faceFeatures.cheeksBoneWidth,
            ["eyeopening"] = appearanceData.faceFeatures.eyesOpening,
            ["lipthickness"] = appearanceData.faceFeatures.lipsThickness,
            ["jawwidth"] = appearanceData.faceFeatures.jawBoneWidth,
            ["jawshape"] = appearanceData.faceFeatures.jawBoneBackSize,
            ["chinheight"] = appearanceData.faceFeatures.chinBoneLowering,
            ["chinlength"] = appearanceData.faceFeatures.chinBoneLenght, --FiveM Appearance has this spelt incorrect
            ["chinshape"] = appearanceData.faceFeatures.chinBoneSize,
            ["chinhole"] = appearanceData.faceFeatures.chinHole,
            ["neckthickness"] = appearanceData.faceFeatures.neckThickness
        })

        MySQL.Async.execute("UPDATE character_parents SET character_father_shape = @fatherShape, character_mother_shape = @motherShape, character_shape_mix = @shapeMix, character_father_skin = @fatherSkin, character_mother_skin = @motherSkin, character_skin_mix = @skinMix WHERE character_data_player_dataid = @playerId", {
            ["playerId"] = playerId,
            ["fatherShape"] = appearanceData.headBlend.shapeFirst,
            ["motherShape"] = appearanceData.headBlend.shapeSecond,
            ["shapeMix"] = appearanceData.headBlend.shapeMix,
            ["fatherSkin"] = appearanceData.headBlend.skinFirst,
            ["motherSkin"] = appearanceData.headBlend.skinSecond,
            ["skinMix"] = appearanceData.headBlend.skinMix
        })

        --[[ MySQL.Async.execute("UPDATE character_tattoos SET WHERE character_data_player_dataid = @playerId", {
            ["playerId"] = playerId,
        }) ]]

        MySQL.Async.execute("UPDATE character_props SET character_hat = @hat, character_glasses = @glasses, character_ears = @ear, character_watch = @watch, character_bracelet = @bracelet WHERE character_data_player_dataid = @playerId", {
            ["playerId"] = playerId,
            ["hat"] = appearanceData.props[1].drawable,
            ["glasses"] = appearanceData.props[2].drawable,
            ["ear"] = appearanceData.props[3].drawable,
            ["watch"] = appearanceData.props[4].drawable,
            ["bracelet"] = appearanceData.props[5].drawable
        })

        MySQL.Async.execute("UPDATE character_props_textures SET character_hat = @hat, character_glasses = @glasses, character_ears = @ear, character_watch = @watch, character_bracelet = @bracelet WHERE character_data_player_dataid = @playerId", {
            ["playerId"] = playerId,
            ["hat"] = appearanceData.props[1].texture,
            ["glasses"] = appearanceData.props[2].texture,
            ["ear"] = appearanceData.props[3].texture,
            ["watch"] = appearanceData.props[4].texture,
            ["bracelet"] = appearanceData.props[5].texture
        })

        MySQL.Async.execute("UPDATE character_components SET character_face = @face, character_mask = @mask, character_hair = @hair, character_torso = @torso, character_leg = @leg, character_bag = @bag, character_shoes = @shoes, character_accessory = @accessory, character_undershirt = @undershirt, character_kevlar = @kevlar, character_badge = @badge, character_torso2 = @torso2 WHERE character_data_player_dataid = @playerId", {
            ["playerId"] = playerId,
            ["face"] = appearanceData.components[1].drawable,
            ["mask"] = appearanceData.components[2].drawable,
            ["hair"] = appearanceData.components[3].drawable,
            ["torso"] = appearanceData.components[4].drawable,
            ["leg"] = appearanceData.components[5].drawable,
            ["bag"] = appearanceData.components[6].drawable,
            ["shoes"] = appearanceData.components[7].drawable,
            ["accessory"] = appearanceData.components[8].drawable,
            ["undershirt"] = appearanceData.components[9].drawable,
            ["kevlar"] = appearanceData.components[10].drawable,
            ["badge"] = appearanceData.components[11].drawable,
            ["torso2"] = appearanceData.components[12].drawable
        })

        MySQL.Async.execute("UPDATE character_components_textures SET character_face = @face, character_mask = @mask, character_hair = @hair, character_torso = @torso, character_leg = @leg, character_bag = @bag, character_shoes = @shoes, character_accessory = @accessory, character_undershirt = @undershirt, character_kevlar = @kevlar, character_badge = @badge, character_torso2 = @torso2 WHERE character_data_player_dataid = @playerId", {
            ["playerId"] = playerId,
            ["face"] = appearanceData.components[1].texture,
            ["mask"] = appearanceData.components[2].texture,
            ["hair"] = appearanceData.components[3].texture,
            ["torso"] = appearanceData.components[4].texture,
            ["leg"] = appearanceData.components[5].texture,
            ["bag"] = appearanceData.components[6].texture,
            ["shoes"] = appearanceData.components[7].texture,
            ["accessory"] = appearanceData.components[8].texture,
            ["undershirt"] = appearanceData.components[9].texture,
            ["kevlar"] = appearanceData.components[10].texture,
            ["badge"] = appearanceData.components[11].texture,
            ["torso2"] = appearanceData.components[12].texture
        })

    end)
end

function SQL_GetCharacterAppearanceData(playerId)
    local gotAllData = false
    local gotAppearance = {
        headOverlays = {
            blemishes = {
                style = 0,
                opacity = 0,
                color = 0
            },
            facialhair = {
                style = 0,
                opacity = 0,
                color = 0
            },
            eyebrows = {
                style = 0,
                opacity = 0,
                color = 0
            },
            ageing = {
                style = 0,
                opacity = 0,
                color = 0
            },
            makeUp = {
                style = 0,
                opacity = 0,
                color = 0
            },
            blush = {
                style = 0,
                opacity = 0,
                color = 0
            },
            complexion = {
                style = 0,
                opacity = 0,
                color = 0
            },
            hair = {
                style = 0,
                opacity = 0,
                color = 0
            },
            sunDamage = {
                style = 0,
                opacity = 0,
                color = 0
            },
            lipstick = {
                style = 0,
                opacity = 0,
                color = 0
            },
            moleAndFreckles = {
                style = 0,
                opacity = 0,
                color = 0
            },
            bodyBlemishes = {
                style = 0,
                opacity = 0,
                color = 0
            },
            chesthair = {
                style = 0,
                opacity = 0,
                color = 0
            }
        },
        props = {
            hat = {
                drawable = -1,
                texture = -1
            },
            glasses = {
                drawable = -1,
                texture = -1
            },
            ear = {
                drawable = -1,
                texture = -1
            },
            watch = {
                drawable = -1,
                texture = -1
            },
            bracelet = {
                drawable = -1,
                texture = -1
            }
        },
        components = {
            face = {
                drawable = -1,
                texture = -1
            },
            mask = {
                drawable = -1,
                texture = -1
            },
            hair = {
                drawable = -1,
                texture = -1
            },
            torso = {
                drawable = -1,
                texture = -1
            },
            leg = {
                drawable = -1,
                texture = -1
            },
            bag = {
                drawable = -1,
                texture = -1
            },
            shoes = {
                drawable = -1,
                texture = -1
            },
            accessory = {
                drawable = -1,
                texture = -1
            },
            undershirt = {
                drawable = -1,
                texture = -1
            },
            kevlar = {
                drawable = -1,
                texture = -1
            },
            badge = {
                drawable = -1,
                texture = -1
            },
            torso2 = {
                drawable = -1,
                texture = -1
            }
        },
        parents = {
            fatherSkin = 0,
            motherSkin = 0,
            skinMix = 0,
            fatherShape = 0,
            motherShape = 0,
            shapeMix = 0
        },
        facefeatures = {
            noseWidth = 0,
            nosepeak = 0,
            noselength = 0,
            nosecurve = 0,
            nosetip = 0,
            nosetwist = 0,
            eyebrowheight = 0,
            eyebrowlength = 0,
            cheeksheight = 0,
            cheekssize = 0,
            cheekswidth = 0,
            eyeopening = 0,
            lipthickness = 0,
            jawwidth = 0,
            jawshape = 0,
            chinheight = 0,
            chinlength = 0,
            chinshape = 0,
            chinhole = 0,
            neckthickness = 0
        },
        tattoos = {}
    }
    --TODO: Select all data from character_headoverlays, character_props, character_components, character_parents, character_facefeatues, character_tattoos
    MySQL.ready(function()
        MySQL.Async.fetchAll("SELECT * FROM character_headoverlays WHERE character_data_player_dataid = @playerId",{
            ["playerId"] = playerId
        }, function(result)
            if result[1] then
                gotAppearance.headOverlays.blemishes.style = result[1].character_blemishes
                gotAppearance.headOverlays.facialhair.style = result[1].character_facialhair
                gotAppearance.headOverlays.eyebrows.style = result[1].character_eyebrows
                gotAppearance.headOverlays.ageing.style = result[1].character_aging
                gotAppearance.headOverlays.makeUp.style = result[1].character_makeup
                gotAppearance.headOverlays.blush.style = result[1].character_blush
                gotAppearance.headOverlays.complexion.style = result[1].character_complexion
                gotAppearance.headOverlays.hair.style = result[1].character_hair
                gotAppearance.headOverlays.sunDamage.style = result[1].character_sundamage
                gotAppearance.headOverlays.lipstick.style = result[1].character_lipstick
                gotAppearance.headOverlays.moleAndFreckles.style = result[1].character_moles
                gotAppearance.headOverlays.bodyBlemishes.style = result[1].character_bodyblemishes
                gotAppearance.headOverlays.chesthair.style = result[1].character_chesthair
            end
        end)

        MySQL.Async.fetchAll("SELECT * FROM character_headoverlays_opacity WHERE character_data_player_dataid = @playerId",{
            ["playerId"] = playerId
        }, function(result)
            if result[1] then
                --Designate into a different table?
                gotAppearance.headOverlays.blemishes.opactiy = result[1].character_blemishes
                gotAppearance.headOverlays.facialhair.opactiy = result[1].character_facialhair
                gotAppearance.headOverlays.eyebrows.opactiy = result[1].character_eyebrows
                gotAppearance.headOverlays.ageing.opactiy = result[1].character_aging
                gotAppearance.headOverlays.makeUp.opactiy = result[1].character_makeup
                gotAppearance.headOverlays.blush.opactiy = result[1].character_blush
                gotAppearance.headOverlays.complexion.opactiy = result[1].character_complexion
                gotAppearance.headOverlays.hair.opactiy = result[1].character_hair
                gotAppearance.headOverlays.sunDamage.opactiy = result[1].character_sundamage
                gotAppearance.headOverlays.lipstick.opactiy = result[1].character_lipstick
                gotAppearance.headOverlays.moleAndFreckles.opactiy = result[1].character_moles
                gotAppearance.headOverlays.bodyBlemishes.opactiy = result[1].character_bodyblemishes
                gotAppearance.headOverlays.chesthair.opactiy = result[1].character_chesthair
            end
        end)

        MySQL.Async.fetchAll("SELECT * FROM character_headoverlays_color WHERE character_data_player_dataid = @playerId", {
            ["playerId"] = playerId
        }, function(result)
            if result[1] then
                gotAppearance.headOverlays.blemishes.color = result[1].character_blemishes_color
                gotAppearance.headOverlays.facialhair.color = result[1].character_facialhair_color
                gotAppearance.headOverlays.eyebrows.color = result[1].character_eyebrows_color
                gotAppearance.headOverlays.ageing.color = result[1].character_aging_color
                gotAppearance.headOverlays.makeUp.color = result[1].character_makeup_color
                gotAppearance.headOverlays.blush.color = result[1].character_blush_color
                gotAppearance.headOverlays.complexion.color = result[1].character_complexion_color
                gotAppearance.headOverlays.hair.color = result[1].character_hair_color
                gotAppearance.headOverlays.sunDamage.color = result[1].character_sundamage_color
                gotAppearance.headOverlays.lipstick.color = result[1].character_lipstick_color
                gotAppearance.headOverlays.moleAndFreckles.color = result[1].character_moles_color
                gotAppearance.headOverlays.bodyBlemishes.color = result[1].character_bodyblemishes_color
                gotAppearance.headOverlays.chesthair.color = result[1].character_chesthair_color
            end
        end)

        MySQL.Async.fetchAll("SELECT * FROM character_props WHERE character_data_player_dataid = @playerId", {
            ["playerId"] = playerId
        }, function(result)
            if result[1] then
                gotAppearance.props.hat.drawable = result[1].character_hat
                gotAppearance.props.glasses.drawable = result[1].character_glasses
                gotAppearance.props.ear.drawable = result[1].character_ear
                gotAppearance.props.watch.drawable = result[1].character_watch
                gotAppearance.props.bracelet.drawable = result[1].character_bracelet
            end
        end)

        MySQL.Async.fetchAll("SELECT * FROM character_props_textures WHERE character_data_player_dataid = @playerId", {
            ["playerId"] = playerId
        }, function(result)
            if result[1] then
                gotAppearance.props.hat.texture = result[1].character_hat
                gotAppearance.props.glasses.texture = result[1].character_glasses
                gotAppearance.props.ear.texture = result[1].character_ear
                gotAppearance.props.watch.texture = result[1].character_watch
                gotAppearance.props.bracelet.texture = result[1].character_bracelet
            end
        end)

        MySQL.Async.fetchAll("SELECT * FROM character_components WHERE character_data_player_dataid = @playerId", {
            ["playerId"] = playerId
        }, function(result)
            if result[1] then
                gotAppearance.components.face.drawable = result[1].character_face
                gotAppearance.components.mask.drawable = result[1].character_mask
                gotAppearance.components.hair.drawable = result[1].character_hair
                gotAppearance.components.torso.drawable = result[1].character_torso
                gotAppearance.components.leg.drawable = result[1].character_leg
                gotAppearance.components.bag.drawable = result[1].character_bag
                gotAppearance.components.shoes.drawable = result[1].character_shoes
                gotAppearance.components.accessory.drawable = result[1].character_accessory
                gotAppearance.components.undershirt.drawable = result[1].character_undershirt
                gotAppearance.components.kevlar.drawable = result[1].character_kevlar
                gotAppearance.components.badge.drawable = result[1].character_badge
                gotAppearance.components.torso2.drawable = result[1].character_torso2
            end
        end)

        MySQL.Async.fetchAll("SELECT * FROM character_components_textures WHERE character_data_player_dataid = @playerId", {
            ["playerId"] = playerId
        }, function(result)
            if result[1] then
                gotAppearance.components.face.texture = result[1].character_face
                gotAppearance.components.mask.texture = result[1].character_mask
                gotAppearance.components.hair.texture = result[1].character_hair
                gotAppearance.components.torso.texture = result[1].character_torso
                gotAppearance.components.leg.texture = result[1].character_leg
                gotAppearance.components.bag.texture = result[1].character_bag
                gotAppearance.components.shoes.texture = result[1].character_shoes
                gotAppearance.components.accessory.texture = result[1].character_accessory
                gotAppearance.components.undershirt.texture = result[1].character_undershirt
                gotAppearance.components.kevlar.texture = result[1].character_kevlar
                gotAppearance.components.badge.texture = result[1].character_badge
                gotAppearance.components.torso2.texture = result[1].character_torso2
            end
        end)

        MySQL.Async.fetchAll("SELECT * FROM character_parents WHERE character_data_player_dataid = @playerId", {
            ["playerId"] = playerId
        }, function(result)
            if result[1] then
                gotAppearance.parents.fatherSkin = result[1].character_father_skin
                gotAppearance.parents.motherSkin = result[1].character_mother_skin
                gotAppearance.parents.skinMix = result[1].character_skin_mix
                gotAppearance.parents.fatherShape = result[1].character_father_shape
                gotAppearance.parents.motherShape = result[1].character_mother_shape
                gotAppearance.parents.shapeMix = result[1].character_shape_mix
            end
        end)

        MySQL.Async.fetchAll("SELECT * FROM character_facefeatures WHERE character_data_player_dataid = @playerId", {
            ["playerId"] = playerId
        }, function(result)
            if result[1] then
                gotAppearance.facefeatures.noseWidth = result[1].character_nosewidth
                gotAppearance.facefeatures.nosepeak = result[1].character_nosepeak
                gotAppearance.facefeatures.noselength = result[1].character_noselength
                gotAppearance.facefeatures.nosecurve = result[1].character_nosecurve
                gotAppearance.facefeatures.nosetip = result[1].character_nosetip
                gotAppearance.facefeatures.nosetwist = result[1].character_nosetwist
                gotAppearance.facefeatures.eyebrowheight = result[1].character_eyebrowheight
                gotAppearance.facefeatures.eyebrowlength = result[1].character_eyebrowlength
                gotAppearance.facefeatures.cheeksheight = result[1].character_cheeksheight
                gotAppearance.facefeatures.cheekssize = result[1].character_cheekssize
                gotAppearance.facefeatures.cheekswidth = result[1].character_cheekswidth
                gotAppearance.facefeatures.eyeopening = result[1].character_eyeopening
                gotAppearance.facefeatures.lipthickness = result[1].character_lipthickness
                gotAppearance.facefeatures.jawwidth = result[1].character_jawwidth
                gotAppearance.facefeatures.jawshape = result[1].character_jawshape
                gotAppearance.facefeatures.chinheight = result[1].character_chinheight
                gotAppearance.facefeatures.chinlength = result[1].character_chinlength
                gotAppearance.facefeatures.chinshape = result[1].character_chinshape
                gotAppearance.facefeatures.chinhole = result[1].character_chinhole
                gotAppearance.facefeatures.neckthickness = result[1].character_neckthickness
            end
            gotAllData = true
        end)

        --[[ MySQL.Async.fetchAll("SELECT * FROM character_tattoos WHERE character_data_player_dataid = @playerId", {
            ["playerId"] = playerId
        }, function(result)
            if result[1] then
                table.insert(gotAppearance.tattoos, result)
            end
            gotAllData = true
        end) ]]
    end)

    while not gotAllData do
        Citizen.Wait(0)
    end

    return gotAppearance
end

function SQL_UpdateCharacterSkill(playerId, skillId, newLevel, newExp)
    local updatedData = nil
    MySQL.ready(function()
        MySQL.Async.execute("UPDATE character_skills SET skill_level = @newLevel, skill_exp = @newXp WHERE character_data_player_dataid = @playerId AND skill_id = @skillId", {
            ["playerId"] = playerId,
            ["skillId"] = skillId,
            ["newLevel"] = newLevel,
            ["newXp"] = newExp
        }, function(result)
            updatedData = true    
        end)
    end)
    while updatedData == nil do
        Citizen.Wait(0)
    end
    return updatedData
end

function SQL_InsertCharacterSkillData(playerId, skillId)
    local insertedData = nil
    MySQL.ready(function()
        MySQL.Async.insert("INSERT INTO character_skills (character_data_player_dataid, skill_id) VALUES(@charId, @skillId)", {
            ["charId"] = playerId,
            ["skillId"] = skillId
        }, function(result)
            insertedData = true
        end)
    end)
    while insertedData == nil do
        Citizen.Wait(0)
    end
    return insertedData
end

function SQL_GetCharacterSkillsData(playerId)
    local skillData = nil
    MySQL.ready(function()
        MySQL.Async.fetchAll("SELECT * FROM character_skills WHERE character_data_player_dataid = @playerId", {
            ["playerId"] = playerId
        }, function(result)
            if result[1] then
                local tempData = {}
                for k,v in pairs(result) do
                    tempData[v.skill_id] = {
                        Id = v.skill_id,
                        Level = v.skill_level,
                        Xp = v.skill_exp
                    }
                end
                skillData = tempData
            else
                skillData = {}
            end
        end)
    end)
    while skillData == nil do
        Citizen.Wait(0)
    end
    return skillData
end

function SQL_GetCharacterData(playerId)
    local gotCharData = nil

    MySQL.ready(function()
        MySQL.Async.fetchAll("SELECT * FROM character_data WHERE player_dataid = @playerId", {
            ["playerId"] = playerId
        }, function(result)
            if result[1] then
                local tempgotCharData = {
                    Id = result[1].player_dataid,
                    gender = result[1].character_gender,
                    appearance = {},
                    inventory = {},
                    health = result[1].character_health,
                    armor = result[1].character_armor,
                    hunger = result[1].character_hunger,
                    thirst = result[1].character_thirst,
                    stress = result[1].character_stress,
                    humanity = result[1].character_humanity,
                    isRunning = false,
                    isShooting = false,
                    isDucking = false,
                    isMelee = false,
                    isUnderwater = false,
                    skills = {},
                    lastposition = json.decode(result[1].character_lastposition) or ""
                }
                tempgotCharData.skills = SQL_GetCharacterSkillsData(playerId)
                tempgotCharData.appearance = SQL_GetCharacterAppearanceData(playerId)
                tempgotCharData.inventory = SQL_GetCharacterInventoryData(playerId)
                
                gotCharData = tempgotCharData
            else
                gotCharData = SQL_CreateCharacterData(playerId)
            end
        end)
    end)

    while gotCharData == nil do
        Citizen.Wait(0)
    end

    return gotCharData
end

function SQL_CreateCharacterData(playerId)
    local createdChar = nil
    local gender = math.random(0,1)
    MySQL.ready(function()
        MySQL.Async.insert("INSERT INTO character_data (player_dataid, character_gender) VALUES (@playerId, @gender)", {
            ["playerId"] = playerId,
            ["gender"] = gender
        }, function(result)
            if result then
                local health = 100
                if gender == 1 then
                    health = 200
                end
                local tempcreatedChar = {
                    Id = playerId,
                    gender = gender,
                    appearance = nil,
                    inventory = nil,
                    health = health,
                    armor = 0,
                    hunger = 100,
                    thirst = 100,
                    stress = 0,
                    humanity = 0,
                    isRunning = false,
                    isShooting = false,
                    isDucking = false,
                    isMelee = false,
                    isUnderwater = false,
                    skills = {},
                    lastposition = vector3(0,0,0)
                }
                tempcreatedChar.inventory = SQL_CreateCharacterInventoryData(playerId)
                while tempcreatedChar.inventory == nil do
                    Citizen.Wait(0)
                end
                if tempcreatedChar.inventory == false then print("Something went wrong when creating character inventory") return end
                local bikekitItem = Config.CreateNewItemWithCountQual(Config.Items[43], 1, 100)
                tempcreatedChar.inventory.items[1] = bikekitItem
                SQL_InsertItemToCharacterInventory(playerId, 1, bikekitItem)

                tempcreatedChar.appearance = SQL_CreateCharacterAppearanceData(playerId)
                
                while tempcreatedChar.appearance == nil do
                    Citizen.Wait(0)
                end
                
                createdChar = tempcreatedChar
            else
                createdChar = false
            end
        end)
    end)

    while createdChar == nil do
        Citizen.Wait(0)
    end

    return createdChar
end

function SQL_CreateCharacterAppearanceData(playerId)
    local createdAppearanceData = nil
    MySQL.ready(function()
        MySQL.Async.insert("INSERT INTO character_parents (character_data_player_dataid) VALUES (@playerId)", {
            ["playerId"] = playerId
        },function(result)
            print("Created character appearance parents")
        end)

        MySQL.Async.insert("INSERT INTO character_headoverlays (character_data_player_dataid) VALUES (@playerId)", {
            ["playerId"] = playerId
        },function(result)
            print("Created character appearance headoverlays")
        end)

        MySQL.Async.insert("INSERT INTO character_headoverlays_opacity (character_data_player_dataid) VALUES (@playerId)", {
            ["playerId"] = playerId
        },function(result)
            print("Created character appearance headoverlays opacity")
        end)

        MySQL.Async.insert("INSERT INTO character_headoverlays_color (character_data_player_dataid) VALUES (@playerId)", {
            ["playerId"] = playerId
        },function(result)
            print("Created character appearance headoverlays color")
        end)

        MySQL.Async.insert("INSERT INTO character_facefeatures (character_data_player_dataid) VALUES (@playerId)", {
            ["playerId"] = playerId
        },function(result)
            print("Created character appearance facefeatures")
        end)

        MySQL.Async.insert("INSERT INTO character_components (character_data_player_dataid) VALUES (@playerId)", {
            ["playerId"] = playerId
        },function(result)
            print("Created character appearance components")
        end)

        MySQL.Async.insert("INSERT INTO character_components_textures (character_data_player_dataid) VALUES (@playerId)", {
            ["playerId"] = playerId
        },function(result)
            print("Created character appearance components textures")
        end)

        MySQL.Async.insert("INSERT INTO character_props(character_data_player_dataid) VALUES (@playerId)", {
            ["playerId"] = playerId
        },function(result)
            print("Created character appearance props")
        end)

        MySQL.Async.insert("INSERT INTO character_props_textures (character_data_player_dataid) VALUES (@playerId)", {
            ["playerId"] = playerId
        },function(result)
            print("Created character appearance props textures")
            createdAppearanceData = true
        end)
    end)
    while createdAppearanceData == nil do
        Citizen.Wait(0)
    end

    return createdAppearanceData
end

function LoadCharacterAppearanceData(ply, appearanceData)
    local playerPed = GetPlayerPed(ply)
    print(appearanceData.parents.fatherShape, GetPlayerPed(-1))
    SetPedHeadBlendData(playerPed, appearanceData.parents.fatherShape, appearanceData.parents.motherShape, 0, appearanceData.parents.fatherSkin, appearanceData.parents.motherSkin, 0, appearanceData.parents.shapeMix, appearanceData.parents.skinMix, 0, false)
    
    SetPedComponentVariation(playerPed, 0, appearanceData.components.face.drawable, appearanceData.components.face.texture, 0)
    SetPedComponentVariation(playerPed, 1, appearanceData.components.mask.drawable, appearanceData.components.mask.texture, 0)
    SetPedComponentVariation(playerPed, 2, appearanceData.components.hair.drawable, appearanceData.components.hair.texture, 0)
    SetPedComponentVariation(playerPed, 3, appearanceData.components.torso.drawable, appearanceData.components.torso.texture, 0)
    SetPedComponentVariation(playerPed, 4, appearanceData.components.leg.drawable, appearanceData.components.leg.texture, 0)
    SetPedComponentVariation(playerPed, 5, appearanceData.components.bag.drawable, appearanceData.components.bag.texture, 0)
    SetPedComponentVariation(playerPed, 6, appearanceData.components.shoes.drawable, appearanceData.components.shoes.texture, 0)
    SetPedComponentVariation(playerPed, 7, appearanceData.components.accessory.drawable, appearanceData.components.accessory.texture, 0)
    SetPedComponentVariation(playerPed, 8, appearanceData.components.undershirt.drawable, appearanceData.components.undershirt.texture, 0)
    SetPedComponentVariation(playerPed, 9, appearanceData.components.kevlar.drawable, appearanceData.components.kevlar.texture, 0)
    SetPedComponentVariation(playerPed, 10, appearanceData.components.badge.drawable, appearanceData.components.badge.texture, 0)
    SetPedComponentVariation(playerPed, 11, appearanceData.components.torso2.drawable, appearanceData.components.torso2.texture, 0)

    SetPedPropIndex(playerPed, 0, appearanceData.props.hat.drawable, appearanceData.props.hat.texture, true)
    SetPedPropIndex(playerPed, 1, appearanceData.props.glasses.drawable, appearanceData.props.glasses.texture, true)
    SetPedPropIndex(playerPed, 2, appearanceData.props.ear.drawable, appearanceData.props.ear.texture, true)
    SetPedPropIndex(playerPed, 6, appearanceData.props.watch.drawable, appearanceData.props.watch.texture, true)
    SetPedPropIndex(playerPed, 7, appearanceData.props.bracelet.drawable, appearanceData.props.bracelet.texture, true)

    SetPedFaceFeature(playerPed, 0, appearanceData.facefeatures.nosewidth)
    SetPedFaceFeature(playerPed, 1, appearanceData.facefeatures.nosepeak)
    SetPedFaceFeature(playerPed, 2, appearanceData.facefeatures.noselength)
    SetPedFaceFeature(playerPed, 3, appearanceData.facefeatures.nosecurve)
    SetPedFaceFeature(playerPed, 4, appearanceData.facefeatures.nosetip)
    SetPedFaceFeature(playerPed, 5, appearanceData.facefeatures.nosetwist)
    SetPedFaceFeature(playerPed, 6, appearanceData.facefeatures.eyebrowheight)
    SetPedFaceFeature(playerPed, 7, appearanceData.facefeatures.eyebrowlength)
    SetPedFaceFeature(playerPed, 8, appearanceData.facefeatures.cheeksheight)
    SetPedFaceFeature(playerPed, 9, appearanceData.facefeatures.cheekssize)
    SetPedFaceFeature(playerPed, 10, appearanceData.facefeatures.cheekswidth)
    SetPedFaceFeature(playerPed, 11, appearanceData.facefeatures.eyeopening)
    SetPedFaceFeature(playerPed, 12, appearanceData.facefeatures.lipthickness)
    SetPedFaceFeature(playerPed, 13, appearanceData.facefeatures.jawbonewidth)
    SetPedFaceFeature(playerPed, 14, appearanceData.facefeatures.jawboneshape)
    SetPedFaceFeature(playerPed, 15, appearanceData.facefeatures.chinheight)
    SetPedFaceFeature(playerPed, 16, appearanceData.facefeatures.chinlength)
    SetPedFaceFeature(playerPed, 17, appearanceData.facefeatures.chinshape)
    SetPedFaceFeature(playerPed, 18, appearanceData.facefeatures.chinhole)
    SetPedFaceFeature(playerPed, 19, appearanceData.facefeatures.neckthickness)

    SetPedHeadOverlay(playerPed, 0, appearanceData.headOverlays.blemishes.style, appearanceData.headOverlays.blemishes.opacity)
    SetPedHeadOverlayColor(playerPed, 0, 2, appearanceData.headOverlays.blemishes.color, 0)
    SetPedHeadOverlay(playerPed, 1, appearanceData.headOverlays.facialhair.style, appearanceData.headOverlays.facialhair.opacity)
    SetPedHeadOverlayColor(playerPed, 1, 1, appearanceData.headOverlays.facialhair.color, 0)
    SetPedHeadOverlay(playerPed, 2, appearanceData.headOverlays.eyebrows.style, appearanceData.headOverlays.eyebrows.opacity)
    SetPedHeadOverlayColor(playerPed, 2, 1, appearanceData.headOverlays.eyebrows.color, 0)
    SetPedHeadOverlay(playerPed, 3, appearanceData.headOverlays.ageing.style, appearanceData.headOverlays.ageing.opacity)
    SetPedHeadOverlayColor(playerPed, 3, 0, appearanceData.headOverlays.ageing.color, 0)
    SetPedHeadOverlay(playerPed, 4, appearanceData.headOverlays.makeUp.style, appearanceData.headOverlays.makeUp.opacity)
    SetPedHeadOverlayColor(playerPed, 4, 0, appearanceData.headOverlays.makeUp.color, 0)
    SetPedHeadOverlay(playerPed, 5, appearanceData.headOverlays.blush.style, appearanceData.headOverlays.blush.opacity)
    SetPedHeadOverlayColor(playerPed, 5, 2, appearanceData.headOverlays.blush.color, 0)
    SetPedHeadOverlay(playerPed, 6, appearanceData.headOverlays.complexion.style, appearanceData.headOverlays.complexion.opacity)
    SetPedHeadOverlayColor(playerPed, 6, 0, appearanceData.headOverlays.complexion.color, 0)
    SetPedHeadOverlay(playerPed, 7, appearanceData.headOverlays.sunDamage.style, appearanceData.headOverlays.sunDamage.opacity)
    SetPedHeadOverlayColor(playerPed, 7, 0, appearanceData.headOverlays.sunDamage.color, 0)
    SetPedHeadOverlay(playerPed, 8, appearanceData.headOverlays.lipstick.style, appearanceData.headOverlays.lipstick.opacity)
    SetPedHeadOverlayColor(playerPed, 8, 2, appearanceData.headOverlays.lipstick.color, 0)
    SetPedHeadOverlay(playerPed, 9, appearanceData.headOverlays.moleAndFreckles.style, appearanceData.headOverlays.moleAndFreckles.opacity)
    SetPedHeadOverlayColor(playerPed, 9, 0, appearanceData.headOverlays.moleAndFreckles.color, 0)
    SetPedHeadOverlay(playerPed, 10, appearanceData.headOverlays.chesthair.style, appearanceData.headOverlays.chesthair.opacity)
    SetPedHeadOverlayColor(playerPed, 10, 1, appearanceData.headOverlays.chesthair.color, 0)
    SetPedHeadOverlay(playerPed, 11, appearanceData.headOverlays.bodyBlemishes.style, appearanceData.headOverlays.bodyBlemishes.opacity)
    SetPedHeadOverlayColor(playerPed, 11, 0, appearanceData.headOverlays.bodyBlemishes.color, 0)
end