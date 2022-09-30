function SQL_GetCharacterWeaponProf(charId, weaponHash)
    local gotData = nil
    MySQL.ready(function()
        MySQL.Async.execute("SELECT * FROM character_proficiency WHERE character_player_dataid = @characterId AND proficiency_name = @weaponHash", {
            ["characterId"] = charId,
            ["weaponHash"] = weaponHash
        }, function(result)
            if result then
                gotData = result
            else
                gotData = false
            end
        end)
    end)

    while gotData == nil do
        Citizen.Wait(1)
    end

    return gotData
end

function SQL_UpdateCharacterWeaponProf(charId, weaponHash, newProf)
    MySQL.ready(function()
        MySQL.Async.execute("UPDATE character_proficiency SET proficiency_value = @newProf WHERE character_player_dataid = @characterId AND proficiency_name = @weaponHash", {
            ["characterId"] = charId,
            ["weaponHash"] = weaponHash,
            ["newProf"] = newProf
        }, function(result)
            
        end)
    end)
end

function SQL_InsertCharacterWeaponProf(charId, weaponHash)
    MySQL.ready(function()
        MySQL.Async.insert("INSERT INTO character_proficiency(character_player_dataid, proficiency_name, proficiency_value) VALUES(@characterId, @weaponHash, 0)", {
            ["characterId"] = charId,
            ["weaponHash"] = weaponHash
        }, function(result)
            
        end)
    end)
end