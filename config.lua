Config = {}

--How long before the server will respawn a player
Config.RespawnTimer = 30000

--When player respawns clears character inventory from database and memory
Config.LoseItemsOnDeath = false
--When player respawns adds a registered inventory with the characters items where they died
Config.DropItemsOnDeath = false

Config.MaxStress = 100
--Time between stress ticks
Config.TimeBetweenStress = 15000

Config.StressRates = {
    [30] = 1,
    [20] = 2,
    [10] = 3
}
--Players can not build within these coords
Config.RestrictedBuildingZones  = {
    {
        topleft = vector3(5,5,0), --Z coord doesn't matter
        topright = vector3(5,-5,0),
        bottomleft = vector3(-5,5,0),
        bottomright = vector3(-5,-5,0)
    }
}

--How often to sync vehicle pos
Config.DelayVehiclePosSync = 30000

--Delay server ticks by this amount when no players are on
Config.DelayServerTick = 15000

--Delay server tick for updating zombies positions by this amount
Config.ServerZombiePositionTick = 10000

--How often client thread checks to reduce fuel
Config.VehicleFuelTimer = 1000
--The rate at which fuel is drained
Config.VehicleFuelRates = {
    [GetHashKey("futo")] = {
        [30] = 0.5,
        [60] = 1,
        [120] = 1.5
    }
}
--Default fuel rates if the model is not found above
Config.DefaultVehicleFuelRates = {
    [5] = 0.25,
    [30] = 0.5,
    [60] = 1,
    [120] = 1.5,
    [150] = 2,
    [180] = 2.5
}
--[[ 
Main LS Customs X:-365.425 Y:-131.809 Z:37.873

Yacht X:-2023.661 Y:-1038.038 Z:5.577 IPL needed

Carrier (MP Only) X:3069.330 Y:-4704.220 Z:15.043 IPL needed

Fort Zankudo UFO X:2052.000 Y:3237.000 Z:1456.973 IPL needed

Very High Up X:-129.964 Y:8130.873 Z:6705.307

IAA Roof X:134.085 Y:-637.859 Z:262.851

FIB Roof X:150.126 Y:-754.591 Z:262.865

Maze Bank Roof X:-75.015 Y:-818.215 Z:326.176

Top of the Mt Chilad X:450.718 Y:5566.614 Z:806.183

Most Northerly Point X:24.775 Y:7644.102 Z:19.055

Vinewood Bowl Stage X:686.245 Y:577.950 Z:130.461

Sisyphus Theater Stage X:205.316 Y:1167.378 Z:227.005

Director Mod Trailer X:-20.004 Y:-10.889 Z:500.602 Might Not Work

Galileo Observatory Roof X:-438.804 Y:1076.097 Z:352.411

Kortz Center X:-2243.810 Y:264.048 Z:174.615

Chumash Historic Family Pier X:-3426.683 Y:967.738 Z:8.347

Paleto Bay Pier X:-275.522 Y:6635.835 Z:7.425

God’s thumb X:-1006.402 Y:6272.383 Z:1.503

Calafia Train Bridge X:-517.869 Y:4425.284 Z:89.795

Altruist Cult Camp X:-1170.841 Y:4926.646 Z:224.295

Maze Bank Arena Roof X:-324.300 Y:-1968.545 Z:67.002

Marlowe Vineyards X:-1868.971 Y:2095.674 Z:139.115

Hippy Camp X:2476.712 Y:3789.645 Z:41.226

Devin Weston’s House X:-2639.872 Y:1866.812 Z:160.135

Abandon Mine X:-595.342 Y: 2086.008 Z:131.412

Weed Farm X:2208.777 Y:5578.235 Z:53.735

Stab City X: 126.975 Y:3714.419 Z:46.827

Airplane Graveyard Airplane Tail X:2395.096 Y:3049.616 Z:60.053 MISSED

Satellite Dish Antenna X:2034.988 Y:2953.105 Z:74.602

Satellite Dishes X: 2062.123 Y:2942.055 Z:47.431

Windmill Top X:2026.677 Y:1842.684 Z:133.313 MISSED

Sandy Shores Building Site Crane X:1051.209 Y:2280.452 Z:89.727 MISSED

Rebel Radio X:736.153 Y:2583.143 Z:79.634 MISSED

Quarry X:2954.196 Y:2783.410 Z:41.004

Palmer-Taylor Power Station Chimney X: 2732.931 Y: 1577.540 Z:83.671

Merryweather Dock X: 486.417 Y:-3339.692 Z:6.070

Cargo Ship X:899.678 Y:-2882.191 Z:19.013

Del Perro Pier X:-1850.127 Y:-1231.751 Z:13.017

Play Boy Mansion X:-1475.234 Y:167.088Z:55.841

Jolene Cranley-Evans Ghost X:3059.620 Y:5564.246 Z:197.091

NOOSE Headquarters X:2535.243 Y:-383.799 Z:92.993

Snowman X: 971.245 Y:-1620.993 Z:30.111

Oriental Theater X:293.089 Y:180.466 Z:104.301

Beach Skatepark X:-1374.881 Y:-1398.835 Z:6.141

Underpass Skatepark X:718.341 Y:-1218.714 Z: 26.014

Casino X:925.329 Y:46.152 Z:80.908

University of San Andreas X:-1696.866 Y:142.747 Z:64.372

La Puerta Freeway Bridge X: -543.932 Y:-2225.543 Z:122.366

Land Act Dam X: 1660.369 Y:-12.013 Z:170.020

Mount Gordo X: 2877.633 Y:5911.078 Z:369.624

Little Seoul X:-889.655 Y:-853.499 Z:20.566

Epsilon Building X:-695.025 Y:82.955 Z:55.855 Z:55.855

The Richman Hotel X:-1330.911 Y:340.871 Z:64.078

Vinewood sign X:711.362 Y:1198.134 Z:348.526

Los Santos Golf Club X:-1336.715 Y:59.051 Z:55.246

Chicken X:-31.010 Y:6316.830 Z:40.083

Little Portola X:-635.463 Y:-242.402 Z:38.175

Pacific Bluffs Country Club X:-3022.222 Y:39.968 Z:13.611

Vinewood Cemetery X:-1659993 Y:-128.399 Z:59.954

Paleto Forest Sawmill Chimney X:-549.467 Y:5308.221 Z:114.146

Mirror Park X:1070.206 Y:-711.958 Z:58.483

Rocket X:1608.698 Y:6438.096 Z:37.637

El Gordo Lighthouse X:3430.155 Y:5174.196 Z:41.280

Mile High Club X:-144.274 Y:-946.813 Z:269.135
 ]]
Config.PlayerSpawns = {
    vector3(-365.425, -131.809, 37.873),
    vector3(134.085, -637.859, 262.851),
    vector3(150.126, -754.591, 262.865),
    vector3(-75.015, -818.215, 326.176),
    vector3(450.718, 5566.614, 806.183),
    vector3(24.775, 7644.102, 19.055),
    vector3(686.245, 577.950, 130.461),
    vector3(205.316, 1167.378, 227.005),
    vector3(-438.804, 1076.097, 352.411),
    vector3(-2243.810, 264.048, 174.615),
    vector3(-3426.683, 967.738, 8.347),
    vector3(-275.522, 6635.835, 7.425),
    vector3(-1006.402, 6272.383, 1.503),
    vector3(-517.869, 4425.284, 89.795),
    vector3(-1170.841, 4926.646, 224.295),
    vector3(-324.300, -1968.545, 67.002),
    vector3(-1868.971, 2095.674, 139.115),
    vector3(2476.712, 3789.645, 41.226),
    vector3(-2639.872, 1866.812, 160.135),
    vector3(-595.342, 2086.008, 131.412),
    vector3(2208.777, 5578.235, 53.735),
    vector3(126.975, 3714.419, 46.827),
    vector3(2034.988, 2953.105, 74.602),
    vector3(2062.123, 2942.055, 47.431),
    vector3(2954.196, 2783.410, 41.004)
}

--New character customization position
Config.CharacterCustomizerPosition = vector3(-74.73, -819.58, 325.57)
--Rates for humanity
Config.HumanityRates = {
    ["revive"] = 750, --Used for when a player revives another, adds
    ["killplayer"] = 1500 --Used for when a player kills another, minus
}

Config.LootCrates = {
    {
        label = "Crate",
        model = "adv_prop",
        maxslots = 10,
        maxweight = 5,
        items = { --Override the chances of the potential items spawning
            [1] = 10, --Now a bandage item only has 10% chance to spawn
            [2] = -1, -- -1 for no change in spawn chance
            [3] = 90,
            [4] = 100
        }
    }
}

Config.WeaponNoise = {
    [GetHashKey("weapon_pistol")] = {
        silenced = 5,
        unsilenced = 15
    }
}

--Models of containers (dumpsters) players can loot
Config.LootableContainers = {
    [GetHashKey("p_dumpster_t")] = {
        maxslots = 10,
        maxweight = 50,
        items = {
            [1] = 10 --Same as above
        },
        spawnall = true --Spawns all Config.Items as well, will override chances with above
    },
    [GetHashKey("prop_cs_dumpster_01a")] = {
        maxslots = 10,
        maxweight = 50,
        items = {

        },
        spawnall = true
    },
    [GetHashKey("prop_dumpster_01a")] = {
        maxslots = 10,
        maxweight = 50,
        items = {

        },
        spawnall = true
    },
    [GetHashKey("prop_dumpster_02a")] = {
        maxslots = 10,
        maxweight = 50,
        items = {

        },
        spawnall = true
    },
    [GetHashKey("prop_dumpster_02b")] = {
        maxslots = 10,
        maxweight = 50,
        items = {

        },
        spawnall = true
    },
    [GetHashKey("prop_dumpster_3a")] = {
        maxslots = 10,
        maxweight = 50,
        items = {

        },
        spawnall = true
    },
    [GetHashKey("prop_dumpster_4a")] = {
        maxslots = 10,
        maxweight = 50,
        items = {

        },
        spawnall = true
    },
    [GetHashKey("prop_dumpster_4b")] = {
        maxslots = 10,
        maxweight = 50,
        items = {

        },
        spawnall = true
    },
    [GetHashKey("prop_snow_dumpster_01")] = {
        maxslots = 10,
        maxweight = 50,
        items = {

        },
        spawnall = true
    },
    [GetHashKey("prop_bin_05a")] = {
        maxslots = 5,
        maxweight = 50,
        items = {
            [53] = 50
        },
        spawnall = true
    },
    [GetHashKey("prop_cratepile_07a")] = {
        maxslots = 25,
        maxweight = 50,
        items = {
            [52] = 10
        },
        spawnall = true
    },
    [GetHashKey('prop_toolchest_05')] = {
        maxslots = 25,
        maxweight = 50,
        items = {
            [53] = 10,
            [54] = 10,
            [62] = 10,
            [63] = 10
        },
        spawnall = false
    },
    [GetHashKey("prop_toolchest_02")] = {
        maxslots = 25,
        maxweight = 50,
        items = {
            [53] = 10,
            [54] = 10,
            [62] = 10,
            [63] = 10
        },
        spawnall = false
    },
    [GetHashKey("prop_medstation_01")] = {
        maxslots = 5,
        maxweight = 25,
        items = {
            [1] = 90,
            [8] = 75,
            [33] = 35
        },
        spawnall = true
    },
    [GetHashKey("prop_mb_cargo_04a")] = {
        maxslots = 25,
        maxweight = 50,
        items = {
            [52] = 10
        },
        spawnall = true
    }
}

--Distance player is away from a lootable container to draw a marker
Config.ContainerMarkerDrawDistance = 15

--Delete inventory markers every 2 minutes
Config.DeleteInventoryMarkerTime = 120000

--How close one player has to be to another to interact with them, cuffs
Config.InteractWithPlayersDistance = 2.5

--Distance that inventories can be opened
Config.OpenInventoryDistance = 2.5
Config.DefaultMaxSlots = 15
Config.DefaultMaxWeight = 100

--How long between each 'decay' timer for a players character
Config.CharacterDecayTimer = 30000
--If running will decay this amount from both
Config.RunningDecayIncrease = 5
--How much hunger is decayed each time
Config.HungerDecay = 1
--How much thirst is decayed each time
Config.ThirstDecay = 1
--How much items will decay in a characters inventory
Config.InventoryDecay = 5
--Minimum quality spawned items can be
Config.MinQuality = 1
--Max quality spawned items can be
Config.MaxQuality = 100

Config.Items = {
    [1] = {
        itemId = 1,
        label = "Bandage",
        model = "bandage",
        weight = 1,
        maxcount = 5,
        count = 0,
        quality = 100,
        attachments = {},
        containerspawn = true,
        zombiespawn = true,
        clientfunction = function()
            local plyPed = GetPlayerPed(-1)
            if GetEntityMaxHealth(plyPed) < (GetEntityHealth(plyPed) + 5) then SetEntityHealth(plyPed, GetEntityMaxHealth(plyPed)) return true end
            SetEntityHealth(plyPed, GetEntityHealth(plyPed) + 5)
            return true
        end,
        spawnchance = 40 --Control the percent chances of the item spawning
    },
    [2] = {
        itemId = 2,
        label = "Hunter Uniform",
        model = "hunteruniform",
        weight = 1,
        maxcount = 1,
        count = 0,
        quality = 100,
        attachments = {},
        zombiespawn = true,
        spawnchance = 1,
        serverfunction = function(source)
            local plyPed = GetPlayerPed(source)
            SetPedRandomComponentVariation(plyPed, 0)
            SetPedRandomProps(plyPed)
        end
    },
    [3] = {
        itemId = 3,
        label = "Cop Uniform",
        model = "copuniform",
        weight = 1, 
        maxcount = 1,
        count = 0,
        quality = 100,
        attachments = {},
        zombiespawn = true,
        spawnchance = 1,
        serverfunction = function(source)
            local plyPed = GetPlayerPed(source)
            SetPedRandomComponentVariation(plyPed, 0)
            SetPedRandomProps(plyPed)
        end
    },
    [4] = {
        itemId = 4,
        label = "Pistol",
        model = "weapon_pistol",
        weight = 5,
        maxcount = 1,
        count = 0,
        quality = 100,
        decay = false,
        militaryspawn = true,
        attachments = {},
        spawnchance = 1
    },
    [5] = {
        itemId = 5,
        label = "Mars Bar",
        model = "mars",
        weight = 1,
        maxcount = 10,
        count = 0,
        quality = 100,
        attachments = {},
        zombiespawn = true,
        containerspawn = true,
        decay = false, --Stops the item from decaying each Config.CharacterDecayTimer
        serverfunction = function(source)
            local playerData = GetJoinedPlayer(source)
            if playerData then
                playerData.characterData.hunger = playerData.characterData.hunger + 5
                return true
            end
        end,
        clientfunction = function(source)
            AteFood(5)
        end,
        spawnchance = 25
    },
    [6] = {
        itemId = 6,
        label = "Water Bottle",
        model = "water",
        weight = 1,
        maxcount = 10,
        count = 0,
        quality = 100,
        attachments = {},
        zombiespawn = true,
        containerspawn = true,
        serverfunction = function(source)
            local playerData = GetJoinedPlayer(source)
            if playerData then
                playerData.characterData.thirst = playerData.characterData.thirst + 20
                return true
            end
        end,
        clientfunction = function()
            DrankWater(20)
        end,
        spawnchance = 25
    },
    [7] = {
        itemId = 7,
        label = "Pistol Ammo",
        model = "ammo_pistol",
        weight = 1,
        maxcount = 5,
        count = 0,
        quality = 100,
        attachments = {},
        containerspawn = true,
        serverfunction = function(source)
            local playerData = GetJoinedPlayer(source)
            if playerData then
                local plyPed = GetPlayerPed(source)
                local curAmmoCount = SQL_GetWeaponAmmoCount(playerData.Id, GetHashKey("weapon_pistol"))
                SQL_SetWeaponAmmoCount(playerData.Id, GetHashKey("weapon_pistol"), curAmmoCount + 25)
                --GiveAmmoToPlayer(source, GetHashKey("weapon_pistol"), 25)
                return true
            end
        end,
        spawnchance = 1
    },
    [8] = {
        itemId = 8,
        label = "First Aid Kit",
        model = "firstaidkit",
        weight = 5,
        maxcount = 2,
        count = 0,
        quality = 100,
        attachments = {},
        clientfunction = function()
            local plyPed = GetPlayerPed(-1)
            if GetEntityMaxHealth(plyPed) < GetEntityHealth(plyPed) + 40 then SetEntityHealth(plyPed, GetEntityMaxHealth(plyPed)) return true end
            SetEntityHealth(plyPed, GetEntityHealth(plyPed) + 40)
            return true
        end,
        spawnchance = 10
    },
    [9] = {
        itemId = 9,
        label = "Baseball Bat",
        model = "weapon_bat",
        weight = 10,
        maxcount = 1,
        count = 0,
        quality = 100,
        attachments = {},
        spawnchance = 0,
        melee = true
    },
    [10] = {
        itemId = 10,
        label = "Engine",
        model = "engine",
        weight = 15,
        maxcount = 1,
        count = 0,
        quality = 100,
        attachments = {},
        spawnchance = 5,
        containerspawn = true,
        clientfunction = function()
            local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), true)

            if vehicle > 0 then
                SetVehicleEngineHealth(vehicle, 1000.0)
                return true
            end
            return false
        end
    },
    [11] = {
        itemId = 11,
        label = "Tyre Kit",
        model = "tyrekit",
        weight = 5,
        maxcount = 2,
        count = 0,
        quality = 100,
        attachments = {},
        spawnchance = 5,
        containerspawn = true,
        clientfunction = function()
            local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), true)

            if vehicle > 0 then
                local tyre = -1
                local lowestTyreHealth = -1
                for i=0,GetVehicleNumberOfWheels(vehicle) do
                    if i > 2 then i = i + 2 end
                    local tyre = GetVehicleWheelHealth(vehicle, i)
                    if lowestTyreHealth == -1 or tyre < lowestTyreHealth then
                        tyre = i
                        lowestTyreHealth = tyre
                    end
                end
                if tyre ~= -1 then
                    SetVehicleTyreFixed(vehicle, tyre)
                    return true
                end
            end
            return false
        end
    },
    [12] = {
        itemId = 12,
        label = "Vehicle Body Kit",
        model = "bodykit",
        weight = 15,
        maxcount = 1,
        count = 0,
        quality = 100,
        attachments = {},
        spawnchance = 5,
        containerspawn = true,
        serverfunction = function()
            local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), true)

            if vehicle > 0 then
                SetVehicleBodyHealth(vehicle, 1000.0)
                return true
            end
            return false
        end
    },
    [13] = {
        itemId = 13,
        label = "Small Armor",
        model = "armor",
        weight = 10,
        maxcount = 3,
        count = 0,
        quality = 100,
        attachments = {},
        spawnchance = 1,
        serverfunction = function(source)
            local plyPed = GetPlayerPed(source)
            local pedArmor = GetPedArmour(plyPed)
            if pedArmor == 30 then return false end
            if pedArmor + 15 > 30 then
                local dif = 30 - pedArmor
                SetPedArmour(plyPed, dif)
                return true
            end
            SetPedArmour(plyPed, pedArmor + 15)
            return true
        end,
        zombiespawn = true
    },
    [14] = {
        itemId = 14,
        label = "Medium Armor",
        model = "medarmor",
        weight = 20,
        maxcount = 2,
        count = 0,
        quality = 100,
        attachments = {},
        spawnchance = 1,
        serverfunction = function(source)
            local plyPed = GetPlayerPed(source)
            local pedArmor = GetPedArmour(plyPed)
            if pedArmor == 60 then return false end
            if pedArmor + 25 > 60 then
                local dif = 60 - pedArmor
                SetPedArmour(plyPed, dif)
                return true
            end
            SetPedArmour(plyPed, pedArmor + 25)
            return true
        end,
        militaryspawn = true
    },
    [15] = {
        itemId = 15,
        label = "Heavy Armor",
        model = "heavyarmor",
        weight = 35,
        maxcount = 1,
        count = 0,
        quality = 100,
        attachments = {},
        spawnchance = 1,
        serverfunction = function(source)
            local plyPed = GetPlayerPed(source)
            local pedArmor = GetPedArmour(plyPed)
            if pedArmor == 100 then return false end
            if pedArmor + 45 > 100 then
                local dif = 100 - pedArmor
                SetPedArmour(plyPed, dif)
                return true
            end
            SetPedArmour(plyPed, pedArmor + 45)
            return true
        end,
        militaryspawn = true
    },
    [16] = {
        itemId = 16,
        label = "Shotgun",
        model = "weapon_pumpshotgun",
        weight = 15,
        maxcount = 1,
        count = 0,
        quality = 100,
        attachments = {},
        spawnchance = 1,
        militaryspawn = true
    },
    [17] = {
        itemId = 17,
        label = "Assault Rifle",
        model = "weapon_assaultrifle",
        weight = 20,
        maxcount = 1,
        count = 0,
        quality = 100,
        attachments = {},
        spawnchance = 1,
        militaryspawn = true
    },
    [18] = {
        itemId = 18,
        label = "Shotgun Ammo",
        model = "ammunition_shotgun",
        weight = 2,
        maxcount = 5,
        count = 0,
        quality = 100,
        attachments = {},
        spawnchance = 5,
        militaryspawn = true,
        serverfunction = function(source)
            local playerData = GetJoinedPlayer(source)

            if playerData then
                local plyPed = GetPlayerPed(source)
                local curAmmoCount = SQL_GetWeaponAmmoCount(playerData.Id, GetHashKey("weapon_pumpshotgun"))
                SQL_SetWeaponAmmoCount(playerData.Id, GetHashKey("weapon_pumpshotgun"), curAmmoCount + 25)
                return true
            end
        end
    },
    [19] = {
        itemId = 19,
        label = "Assault Rifle Ammo",
        model = "ammunition_rifle",
        weight = 3,
        maxcount = 5,
        count = 0,
        quality = 100,
        attachments = {},
        spawnchance = 3,
        militaryspawn = true,
        serverfunction = function(source)
            local playerData = GetJoinedPlayer(source)

            if playerData then
                local plyPed = GetPlayerPed(source)
                local curAmmoCount = SQL_GetWeaponAmmoCount(playerData.Id, GetHashKey("weapon_assaultrifle"))
                SQL_SetWeaponAmmoCount(playerData.Id, GetHashKey("weapon_assaultrifle"), curAmmoCount + 25)
                return true
            end
        end
    },
    [20] = {
        itemId = 20,
        label = "Cuffs",
        model = "cuffs",
        weight = 2,
        maxcount = 1,
        count = 0,
        quality = 100,
        attachments = {},
        spawnchance = 10,
        militaryspawn = true,
        serverfunction = function(source)
            local plyPed = GetPlayerPed(source)
            local pedCoords = GetEntityCoords(plyPed)
            for k,v in pairs(GetPlayers()) do
                local targetPed = GetPlayerPed(v)
                local targetCoords = GetEntityCoords(targetPed)
                if #(targetCoords - pedCoords) <= Config.InteractWithPlayersDistance then
                    --TODO: Add check they are cuffed
                    CuffPlayer(v, "cuffs")
                    SetPedConfigFlag(targetPed, 120, true)
                    return true
                end
            end

            return false
        end
    },
    [21] = {
        itemId = 21,
        label = "Cuff Keys",
        model = "cuffkeys",
        weight = 1,
        maxcount = 1,
        count = 0,
        quality = 100,
        attachments = {},
        spawnchance = 10,
        militaryspawn = true,
        serverfunction = function(source)
            local plyPed = GetPlayerPed(source)
            local pedCoords = GetEntityCoords(plyPed)
            for k,v in pairs(GetPlayers()) do
                local targetPed = GetPlayerPed(v)
                local targetCoords = GetEntityCoords(targetPed)
                if #(targetCoords - pedCoords) <= Config.InteractWithPlayersDistance then
                    --TODO: Add check they are cuffed
                    SetPedConfigFlag(targetPed, 120, false)
                    return true
                end
            end

            return false
        end
    },
    [22] = {
        itemId = 22,
        label = "Suppressor",
        model = "suppressor",
        weight = 1,
        maxcount = 1,
        count = 0,
        quality  = 100,
        attachments = {},
        spawnchance = 1,
        militaryspawn = true,
        serverfunction = function(source)
            local playerData = GetJoinedPlayer(source)

            if playerData then
                local plyChar = playerData.characterData
                --If we are holding a weapon
                if plyChar.inventory.hands ~= -1 then
                    --Figure out how to add attachments to guns
                    local weaponInHand = plyChar.inventory.items[plyChar.inventory.hands].model
                    --GetHashNameForComponent()
                    
                end
            end
        end
    },
    [23] = {
        itemId = 23,
        label = "Burger",
        model = "burger",
        weight = 1,
        maxcount = 5,
        count = 0,
        quality = 100,
        attachments = {},
        spawnchance = 15,
        zombiespawn = true,
        containerspawn = true,
        serverfunction = function(source)
            local playerData = GetJoinedPlayer(source)
            
            if playerData then
                playerData.characterData.hunger = playerData.characterData.hunger + 25
                return true
            end
        end,
        clientfunction = function()
            AteFood(25)
        end
    },
    [24] = {
        itemId = 24,
        label = "Zipties",
        model = "zipties",
        weight = 1,
        maxcount = 5,
        count = 0,
        quality = 100,
        attachments = {},
        spawnchance = 10,
        zombiespawn = true,
        containerspawn = true,
        serverfunction = function (source)
            local plyPed = GetPlayerPed(source)
            local pedCoords = GetEntityCoords(plyPed)
            for k,v in pairs(GetPlayers()) do
                local targetPed = GetPlayerPed(v)
                local targetCoords = GetEntityCoords(targetPed)
                if #(targetCoords - pedCoords) <= Config.InteractWithPlayersDistance then
                    --TODO: Add check they aren't already cuffed
                    SetPedConfigFlag(targetPed, 120, true)
                    return true
                end
            end

            return false
        end
    },
    [25] = {
        itemId = 25,
        label = "Knife",
        model = "weapon_knife",
        weight = 2,
        maxcount = 1,
        count = 0,
        quality = 100,
        attachments = {},
        spawnchance = 10,
        zombiespawn = true,
        containerspawn = true
    },
    [26] = {
        itemId = 26,
        label = "SMG",
        model = "weapon_smg",
        weight = 12,
        maxcount = 1,
        count = 0,
        quality = 100,
        attachments = {},
        spawnchance = 15,
        militaryspawn = true
    },
    [27] = {
        itemId = 27,
        label = "SMG Ammo",
        model = "ammunition_smg",
        weight = 2,
        maxcount = 5,
        count = 0,
        quality = 100,
        attachments = {},
        spawnchance = 15,
        militaryspawn = true,
        serverfunction = function(source)
            local playerData = GetJoinedPlayer(source)
            if playerData then
                local plyPed = GetPlayerPed(source)
                local curAmmoCount = SQL_GetWeaponAmmoCount(playerData.Id, GetHashKey("weapon_smg"))
                SQL_SetWeaponAmmoCount(playerData.Id, GetHashKey("weapon_smg"), curAmmoCount + 25)
                return true
            end
        end
    },
    [28] = {
        itemId = 28,
        label = "Ice-Tea",
        model = "icetea",
        weight = 1,
        maxcount = 5,
        count = 0,
        quality = 100,
        attachments = {},
        spawnchance = 35,
        zombiespawn = true,
        containerspawn = true,
        serverfunction = function(source)
            local playerData = GetJoinedPlayer(source)
            if playerData then
                playerData.characterData.thirst = playerData.characterData.thirst + 30
                return true
            end
        end,
        clientfunction = function()
            DrankWater(30)
        end,
    },
    [29] = {
        itemId = 29,
        label = "Chips",
        model = "potatochips",
        weight = 1,
        maxcount = 5,
        count = 0,
        quality = 100,
        attachments = {},
        spawnchance = 35,
        zombiespawn = true,
        containerspawn = true,
        serverfunction = function(source)
            local playerData = GetJoinedPlayer(source)
            if playerData then
                playerData.characterData.hunger = playerData.characterData.hunger + 15
                return true
            end
        end,
        clientfunction = function()
            AteFood(15)
        end
    },
    [30] = {
        itemId = 30,
        label = "Weed",
        model = "weed",
        weight = 1,
        maxcount = 10,
        count = 0,
        quality = 100,
        attachments = {},
        spawnchance = 0,
        serverfunction = function(source)

        end
    },
    [31] = {
        itemId = 31,
        label = "Vinegar Chips",
        model = "vinegarchips",
        weight = 1,
        maxcount = 5,
        count = 0,
        quality = 100,
        attachments = {},
        spawnchance = 25,
        zombiespawn = true,
        containerspawn = true,
        serverfunction = function(source)
            local playerData = GetJoinedPlayer(source)
            if playerData then
                playerData.characterData.hunger = playerData.characterData.hunger + 10
                return true
            end
        end,
        clientfunction = function()
            AteFood(10)
        end
    },
    [32] = {
        itemId = 32,
        label = "Snickers",
        model = "snickers",
        weight = 1,
        maxcount = 10,
        count = 0,
        quality = 100,
        spawnchance = 35,
        attachments = {},
        zombiespawn = true,
        containerspawn = true,
        serverfunction = function(source)
            local playerData = GetJoinedPlayer(source)
            if playerData then
                playerData.characterData.hunger = playerData.characterData.hunger + 10
                return true
            end
        end,
        clientfunction = function()
            AteFood(10)
        end
    },
    [33] = {
        itemId = 33,
        label = "Med Bag",
        model = "medbag",
        weight = 10,
        maxcount = 1,
        count = 0,
        quality = 100,
        spawnchance = 5,
        attachments = {},
        serverfunction = function(source)
            local plyPed = GetPlayerPed(source)
            local pedCoords = GetEntityCoords(plyPed)
            for k,v in pairs(GetPlayers()) do
                local targetPed = GetPlayerPed(v)
                local targetCoords = GetEntityCoords(targetPed)
                local dist = #(targetCoords - pedCoords)
                if dist <= Config.InteractWithPlayersDistance then
                    if IsPedDeadOrDying(targetPed) or GetEntityHealth(targetPed) <= 0 then
                        TriggerServerEvent("fivez:RevivePlayer", v)
                        return true
                    end
                end
            end
        end
    },
    [34] = {
        itemId = 34,
        label = "Limonade",
        model = "limonade",
        weight = 2,
        maxcount = 2,
        count = 0,
        quality = 100,
        spawnchance = 35,
        attachments = {},
        zombiespawn = true,
        containerspawn = true,
        serverfunction = function(source)
            local playerData = GetJoinedPlayer(source)
            if playerData then
                playerData.characterData.thirst = playerData.characterData.thirst + 40
                return true
            end
        end,
        clientfunction = function()
            DrankWater(40)
        end
    },
    [35] = {
        itemId = 35,
        label = "Fix Kit",
        model = "fixkit",
        weight = 15,
        maxcount = 2,
        count = 0,
        quality = 100,
        spawnchance = 5,
        attachments = {},
        containerspawn = true,
        serverfunction = function(source)
            local plyPed = GetPlayerPed(source)
            local vehicle = GetVehiclePedIsIn(plyPed, true)

            if vehicle > 0 then
                --Also set it to fix vehicle engine
                SetVehicleBodyHealth(vehicle, 1000.0)
                return true
            end
        end
    },
    [36] = {
        itemId = 36,
        label = "Fish",
        model = "fish",
        weight = 1,
        maxcount = 15,
        count = 0,
        quality = 100,
        spawnchance = 0,
        attachments = {}
    },
    [37] = {
        itemId = 37,
        label = "Fishing Bait",
        model = "fishbait",
        weight = 1,
        maxcount = 15,
        count = 0,
        quality = 100,
        spawnchance = 0,
        attachments = {}
    },
    [38] = {
        itemId = 38,
        label = "Fishing Rod",
        model = "fishingrod",
        weight = 5,
        maxcount = 1,
        count = 0,
        quality = 100,
        spawnchance = 0,
        attachments = {}
    },
    [39] = {
        itemId = 39,
        label = "Energy Drink",
        model = "energy",
        weight = 3,
        maxcount = 5,
        count = 0,
        quality = 100,
        spawnchance = 25,
        attachments = {},
        zombiespawn = true,
        containerspawn = true,
        clientfunction = function()
            RestorePlayerStamina(PlayerId(), 100.0)
            return true
        end
    },
    [40] = {
        itemId = 40,
        label = "Dr Pepper",
        model = "drpepper",
        weight = 2,
        maxcount = 4,
        count = 0,
        quality = 100,
        spawnchance = 35,
        attachments = {},
        zombiespawn = true,
        containerspawn = true,
        serverfunction = function(source)
            local playerData = GetJoinedPlayer(source)
            if playerData then
                playerData.characterData.thirst = playerData.characterData.thirst + 10
                return true
            end
        end,
        clientfunction = function()
            DrankWater(10)
        end
    },
    [41] = {
        itemId = 41,
        label = "Coke",
        model = "drink_coke",
        weight = 1,
        maxcount = 4,
        count = 0,
        quality = 100,
        spawnchance = 35,
        attachments = {},
        zombiespawn = true,
        containerspawn = true,
        serverfunction = function(source)
            local playerData = GetJoinedPlayer(source)
            if playerData then
                playerData.characterData.thirst = playerData.characterData.thirst + 10
                return true
            end
        end,
        clientfunction = function()
            DrankWater(10)
        end
    },
    [42] = {
        itemId = 42,
        label = "Sprite",
        model = "drink_sprite",
        weight = 1,
        maxcount = 4,
        count = 0,
        quality = 100,
        spawnchance = 35,
        attachments = {},
        zombiespawn = true,
        containerspawn = true,
        serverfunction = function(source)
            local playerData = GetJoinedPlayer(source)
            if playerData then
                playerData.characterData.thirst = playerData.characterData.thirst + 10
                return true
            end
        end,
        clientfunction = function()
            DrankWater(10)
        end
    },
    [43] = {
        itemId = 43,
        label = "Bike Kit",
        model = "bikekit",
        weight = 25,
        maxcount = 1,
        count = 0,
        quality = 100,
        spawnchance = 5,
        attachments = {},
        containerspawn = true,
        serverfunction = function(source)
            local plyPed = GetPlayerPed(source)
            local pedCoords = GetEntityCoords(plyPed)
            local createdBike = SpawnVehicle(GetHashKey("bmx"), pedCoords)
            return true
        end
    },
    [44] = {
        itemId = 44,
        label = "Lighter",
        model = "lighter",
        weight = 2,
        maxcount = 1,
        count = 0,
        quality = 100,
        spawnchance = 35,
        attachments = {},
        zombiespawn = true,
        containerspawn = true,
        serverfunction = function(source)

        end,
        clientfunction = function()
            print("LIGHT HAS NO USE RIGHT NOW")
        end
    },
    [45] = {
        itemId = 45,
        label = "Whinny Blues",
        model = "cigarettepack",
        weight = 3,
        maxcount = 1,
        count = 0,
        quality = 100,
        spawnchance = 25,
        attachments = {},
        containerspawn = true,
        zombiespawn = true,
        serverfunction = function(source)
            --TODO: Add stress or something
            local plyData = GetJoinedPlayer(source)
            if plyData then
                plyData.characterData.stress = plyData.characterData.stress - 15
                TriggerClientEvent("fivez:CharacterStressed", source, plyData.characterData.stress)
                return true
            end
        end
    },
    [46] = {
        itemId = 46,
        label = "AP Pistol",
        model = "weapon_appistol",
        weight = 15,
        maxcount = 1,
        count = 0,
        qualtiy = 100,
        spawnchance = 1,
        attachments = {},
        militaryspawn = true
    },
    [47] = {
        itemId = 47,
        label = "Mini SMG",
        model = "weapon_minismg",
        weight = 18,
        maxcount = 1,
        count = 0,
        quality = 100,
        spawnchance = 1,
        attachments = {},
        militaryspawn = true
    },
    [48] = {
        itemId = 48,
        label = "Pistol .50",
        model = "weapon_pistol50",
        weight = 17,
        maxcount = 1,
        count = 0,
        quality = 100,
        spawnchance = 1,
        attachments = {},
        militaryspawn = true
    },
    [49] = {
        itemId = 49,
        label = "AP Pistol Ammo",
        model = "ammunition_pistol",
        weight = 2,
        maxcount = 5,
        count = 0,
        quality = 100,
        spawnchance = 2,
        attachments = {},
        militaryspawn = true,
        serverfunction = function(source)
            local playerData = GetJoinedPlayer(source)
            if playerData then
                local plyPed = GetPlayerPed(source)
                local curAmmoCount = SQL_GetWeaponAmmoCount(playerData.Id, GetHashKey("weapon_appistol"))
                SQL_SetWeaponAmmoCount(playerData.Id, GetHashKey("weapon_appistol"), curAmmoCount + 25)
                return true
            end
        end
    },
    [50] = {
        itemId = 50,
        label = "Mini SMG Ammo",
        model = "ammunition_smg",
        weight = 2,
        maxcount = 5,
        count = 0,
        quality = 100,
        spawnchance = 2,
        attachments = {},
        militaryspawn = true,
        serverfunction = function(source)
            local playerData = GetJoinedPlayer(source)
            if playerData then
                local plyPed = GetPlayerPed(source)
                local curAmmoCount = SQL_GetWeaponAmmoCount(playerData.Id, GetHashKey("weapon_minismg"))
                SQL_SetWeaponAmmoCount(playerData.Id, GetHashKey("weapon_minismg"), curAmmoCount + 25)
                return true
            end
        end
    },
    [51] = {
        itemId = 51,
        label = "Pistol 50. Ammo",
        model = "ammunition_pistol",
        weight = 2,
        maxcount = 5,
        count = 0,
        quality = 100,
        spawnchance = 2,
        attachments = {},
        militaryspawn = true,
        serverfunction = function(source)
            local playerData = GetJoinedPlayer(source)
            if playerData then
                local plyPed = GetPlayerPed(source)
                local curAmmoCount = SQL_GetWeaponAmmoCount(playerData.Id, GetHashKey("weapon_pistol50"))
                SQL_SetWeaponAmmoCount(playerData.Id, GetHashKey("weapon_pistol50"), curAmmoCount + 25)
                return true
            end
        end
    },
    [52] = {
        itemId = 52,
        label = "Small Petrol Tank",
        model = "smallpetroltank",
        weight = 5,
        maxcount = 5,
        count = 0,
        quality = 100, --Quality can be how much it refuels
        spawnchance = 2,
        attachments = {},
        containerspawn = true,
        serverfunction = function(source, quality)
            local plyPed = GetPlayerPed(source)
            local pedCoords = GetEntityCoords(plyPed)
            for k,v in pairs(spawnedVehicles) do
                local vehCoords = GetEntityCoords(v.veh)
                local dist = #(vehCoords - pedCoords)
                if dist <= 2.5 then
                    print("Vehicle fuel", v.fuel)
                    v.fuel = (v.fuel + quality)+0.0
                    print("Setting vehicle fuel", v.fuel)
                    TriggerClientEvent("fivez:RefuelVehicle", source, NetworkGetNetworkIdFromEntity(v.veh), v.fuel)
                    return true
                end
            end
            return false
        end
    },
    [53] = {
        itemId = 53,
        label = "Scrap Metal",
        model = "scrapmetal",
        weight = 5,
        maxcount = 5,
        count = 0,
        quality = 100,
        spawnchance = 15,
        attachments = {},
        containerspawn = true
    },
    [54] = {
        itemId = 54,
        label = "Hammer",
        model = "hammer",
        weight = 2,
        maxcount = 1,
        count = 0,
        quality = 100,
        spawnchance = 5,
        attachments = {},
        containerspawn = true
    },
    [55] = {
        itemId = 55,
        label = "Cloth",
        model = "cloth",
        weight = 1,
        maxcount = 15,
        count = 0,
        quality = 100,
        spawnchance = 5,
        attachments = {},
        zombiespawn = true,
        containerspawn = true
    },
    [56] = {
        itemId = 56,
        label = "Stone",
        model = "stone",
        weight = 5,
        maxcount = 15,
        count = 0,
        quality = 100,
        spawnchance = 0,
        attachments = {}
    },
    [57] = {
        itemId = 57,
        label = "Stick",
        model = "stick",
        weight = 3,
        maxcount = 5,
        count = 0,
        quality = 100,
        spawnchance = 0,
        attachments = {}
    },
    [58] = {
        itemId = 58,
        label = "Paper",
        model = "paper",
        weight = 1,
        maxcount = 15,
        count = 0,
        quality = 100,
        spawnchance = 0,
        attachments = {}
    },
    [59] = {
        itemId = 59,
        label = "Pen",
        model = "pen",
        weight = 1,
        maxcount = 15,
        count = 0,
        quality = 100,
        spawnchance = 0,
        attachments = {}
    },
    [60] = {
        itemId = 60,
        label = "Chain-link Fence",
        model = "chainlinkfence",
        weight = 15,
        maxcount = 1,
        count = 0,
        quality = 100,
        spawnchance = 0,
        attachments = {},
        serverfunction = function(source)
            local coords = GetEntityCoords(GetPlayerPed(source))
            local object = CreateObject(GetHashKey("prop_fnclink_04a"), coords.x, coords.y, coords.z, true, true, false)
            while not DoesEntityExist(object) do
                Citizen.Wait(1)
            end
            Citizen.Wait(500)
            TriggerClientEvent("fivez:Building", source, NetworkGetNetworkIdFromEntity(object))
        end
    },
    [61] = {
        itemId = 61,
        label = "Chain-link Fence Frame",
        model = "chainlinkfenceframe",
        weight = 15,
        maxcount = 1,
        count = 0,
        quality = 100,
        spawnchance = 0,
        attachments = {},
        serverfunction = function(source)
            local coords = GetEntityCoords(GetPlayerPed(source))
            local object = CreateObject(GetHashKey("prop_fnclink_09frame"), coords.x, coords.y, coords.z, true, true, false)
            while not DoesEntityExist(object) do
                Citizen.Wait(1)
            end
            Citizen.Wait(500)
            TriggerClientEvent("fivez:Building", source, NetworkGetNetworkIdFromEntity(object))
        end
    },
    [62] = {
        itemId = 62,
        label = "Wire Mesh",
        model = "wiremesh",
        weight = 5,
        maxcount = 5,
        count = 0,
        quality = 100,
        spawnchance = 0,
        attachments = {}
    },
    [63] = {
        itemId = 63,
        label = "Metal Pole",
        model = "metalpole",
        weight = 10,
        maxcount = 4,
        count = 0,
        quality = 100,
        spawnchance = 0,
        attachments = {}
    },
    [64] = {
        itemId = 64,
        label = "X26 Taser",
        model = "weapon_stungun",
        weight = 5,
        maxcount = 1,
        count = 0,
        quality = 100,
        spawnchance = 0,
        attachments = {}
    },
    [65] = {
        itemId = 65,
        label = "Taser Cartridge",
        model = "ammunition_cartridge",
        weight = 1,
        maxcount = 5,
        count = 0,
        quality = 100,
        spawnchance = 0,
        attachments = {}
    },
    [66] = {
        itemId = 66,
        label = "Nightstick",
        model = "weapon_nightstick",
        weight = 3,
        maxcount = 1,
        count = 0,
        quality = 100,
        spawnchance = 0,
        attachments = {},
        melee = true
    },
    [67] = {
        itemId = 67,
        label = "Machete",
        model = "weapon_machete",
        weight = 6,
        maxcount = 1,
        count = 0,
        quality = 100,
        spawnchance = 0,
        attachments = {},
        melee = true
    },
    [68] = {
        itemId = 68,
        label = "Molotov",
        model = "weapon_molotov",
        weight = 3,
        maxcount = 5,
        count = 0,
        quality = 100,
        spawnchance = 0,
        attachments = {}
    },
    [69] = {
        itemId = 69,
        label = "Double Barrel Shotgun",
        model = "weapon_dbshotgun",
        weight = 8,
        maxcount = 1,
        count = 0,
        qualtity = 100,
        spawnchance = 0,
        attachments = {}
    },
    [70] = {
        itemId = 70,
        label = "DB Rounds",
        model = "ammunition_shotgun",
        weight = 2,
        maxcount = 8,
        count = 0,
        quality = 100,
        spawnchance = 0,
        attachments = {}
    },
    [71] = {
        itemId = 71,
        label = "Flashlight",
        model = "weapon_flashlight",
        weight = 4,
        maxcount = 1,
        count = 0,
        quality = 100,
        spawnchance = 0,
        attachments = {},
        melee = true
    },
    [72] = {
        itemId = 72,
        label = "Crowbar",
        model = "weapon_crowbar",
        weight = 12,
        maxcount = 1,
        count = 0,
        quality = 100,
        spawnchance = 0,
        attachments = {},
        melee = true
    },
    [73] = {
        itemId = 73,
        label = "Loose Cigs",
        model = "cigarett",
        weight = 1,
        maxcount = 15,
        count = 0,
        quality = 100,
        spawnchance = 15,
        attachments = {},
        zombiespawn = true
    },
    [74] = {
        itemId = 74,
        label = "Battery",
        model = "battery",
        weight = 1,
        maxcount = 5,
        count = 0,
        quality = 100,
        spawnchance = 5,
        attachments = {},
        zombiespawn = true,
        containerspawn = true
    },
    [75] = {
        itemId = 75,
        label = "AFAK",
        model = "afak",
        weight = 3,
        maxcount = 3,
        count = 0,
        quality = 100,
        spawnchance = 1,
        attachments = {}
    }
}

Config.GetRandomItem = function()
    local rng = math.random(1, #Config.Items)
    return Config.ItemsWithoutFunctions()[rng]
end

Config.GetItemWithoutFunction = function(itemId)
    local newItem = {
        itemId = Config.Items[itemId].itemId,
        label = Config.Items[itemId].label,
        model = Config.Items[itemId].model,
        weight = Config.Items[itemId].weight,
        maxcount = Config.Items[itemId].maxcount,
        count = Config.Items[itemId].count,
        quality = Config.Items[itemId].quality,
        attachments = Config.Items[itemId].attachments,
        spawnchance = Config.Items[itemId].spawnchance,
        zombiespawn = Config.Items[itemId].zombiespawn,
        militaryspawn = Config.Items[itemId].militaryspawn,
        containerspawn = Config.Items[itemId].containerspawn
    }

    return newItem
end

Config.CreateNewItemWithData = function(itemData)
    local newItem = {
        itemId = itemData.itemId,
        label = itemData.label,
        model = itemData.model,
        weight = itemData.weight,
        maxcount = itemData.maxcount,
        count = itemData.count,
        quality = itemData.quality,
        attachments = itemData.attachments,
        spawnchance = itemData.spawnchance,
        zombiespawn = itemData.zombiespawn,
        militaryspawn = itemData.militaryspawn,
        containerspawn = itemData.containerspawn
    }
    return newItem
end

Config.CreateNewItemWithCountQual = function(itemData, count, quality)
    local newItem = {
        itemId = itemData.itemId,
        label = itemData.label,
        model = itemData.model,
        weight = itemData.weight,
        maxcount = itemData.maxcount,
        count = count,
        quality = quality,
        attachments = itemData.attachments,
        spawnchance = itemData.spawnchance,
        zombiespawn = itemData.zombiespawn,
        militaryspawn = itemData.militaryspawn,
        containerspawn = itemData.containerspawn
    }
    return newItem
end

Config.ItemsWithoutFunctions = function()
    local items = {}
    for k,v in pairs(Config.Items) do
        table.insert(items,{
            itemId = k,
            label = v.label,
            model = v.model,
            weight = v.weight,
            maxcount = v.maxcount,
            count = v.count,
            quality = v.quality,
            attachments = v.attachments,
            spawnchance = v.spawnchance,
            zombiespawn = v.zombiespawn,
            militaryspawn = v.militaryspawn,
            containerspawn = v.containerspawn
        })
    end
    return items
end

Config.GetItemWithModel = function(itemModel)
    local newItem = EmptySlot()
    for k,v in pairs(Config.Items) do
        if v.model == itemModel then
            newItem = v
            return newItem
        end
    end
end

--Amount of quality removed from items that are used for crafting
Config.CraftQualityDecay = 5

Config.Recipes = {
    {
        label = "Craft Bike Kit",
        model = "bikekit",
        count = 1,
        weight = 5,
        required = {
            Config.CreateNewItemWithCountQual(Config.Items[53], 2, 40) --Set the min amount you need and the quality the item should higher than
        }
    },
    {
        label = "Craft Baseball Bat",
        model = "weapon_bat",
        count = 1,
        weight = 10,
        required = {
            Config.CreateNewItemWithCountQual(Config.Items[53], 2, 40),
            Config.CreateNewItemWithCountQual(Config.Items[54], 0, 1) --A count of 0 means the quality of the item will be used not the count
        }
    },
    {
        label = "Craft Chainlink Fence",
        model = "chainlinkfence",
        count = 1,
        weight = 10,
        required = {
            Config.CreateNewItemWithCountQual(Config.Items[63], 2, 40), --Metal pole
            Config.CreateNewItemWithCountQual(Config.Items[62], 1, 40) --Wire mesh
        }
    },
    {
        label = "Craft Chainlink Fence Frame",
        model = "chainlinkfenceframe",
        count = 1,
        weight = 10,
        required = {
            Config.CreateNewItemWithCountQual(Config.Items[63], 4, 40),
            Config.CreateNewItemWithCountQual(Config.Items[62], 3, 40)
        }
    },
    {
        label = "Craft Metal Pole",
        model = "metalpole",
        count = 4,
        weight = 40,
        required = {
            Config.CreateNewItemWithCountQual(Config.Items[53], 12, 20),
            Config.CreateNewItemWithCountQual(Config.Items[54], 0, 1)
        }
    },
    {
        label = "Craft Bandage",
        model = "bandage",
        count = 1,
        weight = 1,
        required = {
            Config.CreateNewItemWithCountQual(Config.Items[55], 1, 50)
        }
    },
    {
        label = "Craft Med-Bag",
        model = "medbag",
        count = 1,
        weight = 10,
        required = {
            Config.CreateNewItemWithCountQual(Config.Items[1], 15, 50), --Bandage
            Config.CreateNewItemWithCountQual(Config.Items[8], 5, 50),  --First aid kit
            Config.CreateNewItemWithCountQual(Config.Items[55], 10, 50) --Cloth
        }
    },
    {
        label = "Craft Medium Armor",
        model = "medarmor",
        count = 1,
        weight = 15,
        required = {
            Config.CreateNewItemWithCountQual(Config.Items[13], 5, 40),
            Config.CreateNewItemWithCountQual(Config.Items[54], 0, 1) --Hammer
        }
    },
    {
        label = "Craft Heavy Armor",
        model = "heavyarmor",
        count = 1,
        weight = 25,
        required = {
            Config.CreateNewItemWithCountQual(Config.Items[13], 2, 40), --Small armor
            Config.CreateNewItemWithCountQual(Config.Items[14], 3, 40), --Medium armor
            Config.CreateNewItemWithCountQual(Config.Items[54], 0, 1)
        }
    }
}

--Amount of vehicles that can be spawned
Config.MaxSpawnedVehicles = 25
--Amount of cars that can be spawned of the maximum amount of vehicles, -1 is no limit
Config.MaxSpawnCars = 10
--Amount of bikes that can be spawned of the maximum amount of vehicles, -1 is no limit 
Config.MaxSpawnBikes = -1

Config.DefaultCarStorage = {
    trunkslots = 10,
    trunkmaxweight = 50,
    gloveboxslots = 5,
    gloveboxmaxweight = 15
}

Config.CarStorage = {
    [GetHashKey("futo")] = {
        trunkslots = 10,
        trunkmaxweight = 50,
        gloveboxslots = 5,
        gloveboxmaxweight = 15
    }
}

Config.CarLabels = {
    [GetHashKey("futo")] = "Futo",
    [GetHashKey("adder")] = "Adder",
    [GetHashKey("zentorno")] = "Zentorno",
    [GetHashKey("ruiner")] = "Ruiner"
}

--Positions where cars can spawn
Config.PotentialCarSpawns = {
    {
        models = { --What type of cars can spawn at this location
            "zentorno",
            "adder"
        },
        damaged = { --Control how damaged the car will spawn
            minenginehealth = 500.0,
            maxenginehealth = 1000.0,
            minbodyhealth = 500.0,
            maxbodyhealth = 1000.0,
            tyres = {
                [1] = { --Tyre health?
                    min = 0.0,
                    max = 100.0
                },
                [2] = {
                    min = 0.0,
                    max = 100.0
                },
                [4] = {
                    min = 0.0,
                    max = 100.0
                },
                [5] = {
                    min = 0.0,
                    max = 100.0
                }
            }
        },
        minfuel = 0.0,
        maxfuel = 100.0,
        position = vector3(-403.89, 1200.28, 325.1),
        heading = 0.0
    },
    {
        models = { --What type of cars can spawn at this location
            "zentorno",
            "adder"
        },
        damaged = { --Control how damaged the car will spawn
            minenginehealth = 500.0,
            maxenginehealth = 1000.0,
            minbodyhealth = 500.0,
            maxbodyhealth = 1000.0,
            tyres = {
                [1] = { --Tyre health?
                    min = 0.0,
                    max = 100.0
                },
                [2] = {
                    min = 0.0,
                    max = 100.0
                },
                [4] = {
                    min = 0.0,
                    max = 100.0
                },
                [5] = {
                    min = 0.0,
                    max = 100.0
                }
            }
        },
        minfuel = 0.0,
        maxfuel = 100.0,
        position = vector3(-2408, 3281.21, 32.55),
        heading = 249.0
    },
    {
        models = { --What type of cars can spawn at this location
            "zentorno",
            "adder"
        },
        damaged = { --Control how damaged the car will spawn
            minenginehealth = 500.0,
            maxenginehealth = 1000.0,
            minbodyhealth = 500.0,
            maxbodyhealth = 1000.0,
            tyres = {
                [1] = { --Tyre health?
                    min = 0.0,
                    max = 100.0
                },
                [2] = {
                    min = 0.0,
                    max = 100.0
                },
                [4] = {
                    min = 0.0,
                    max = 100.0
                },
                [5] = {
                    min = 0.0,
                    max = 100.0
                }
            }
        },
        minfuel = 0.0,
        maxfuel = 100.0,
        position = vector3(-2423.1, 3294.19, 32.55),
        heading = 0.0
    },
    {
        models = { --What type of cars can spawn at this location
            "zentorno",
            "adder"
        },
        damaged = { --Control how damaged the car will spawn
            minenginehealth = 500.0,
            maxenginehealth = 1000.0,
            minbodyhealth = 500.0,
            maxbodyhealth = 1000.0,
            tyres = {
                [1] = { --Tyre health?
                    min = 0.0,
                    max = 100.0
                },
                [2] = {
                    min = 0.0,
                    max = 100.0
                },
                [4] = {
                    min = 0.0,
                    max = 100.0
                },
                [5] = {
                    min = 0.0,
                    max = 100.0
                }
            }
        },
        minfuel = 0.0,
        maxfuel = 100.0,
        position = vector3(-2397.94, 3298.76, 32.55),
        heading = 0.0
    },
    {
        models = { --What type of cars can spawn at this location
            "zentorno",
            "adder"
        },
        damaged = { --Control how damaged the car will spawn
            minenginehealth = 500.0,
            maxenginehealth = 1000.0,
            minbodyhealth = 500.0,
            maxbodyhealth = 1000.0,
            tyres = {
                [1] = { --Tyre health?
                    min = 0.0,
                    max = 100.0
                },
                [2] = {
                    min = 0.0,
                    max = 100.0
                },
                [4] = {
                    min = 0.0,
                    max = 100.0
                },
                [5] = {
                    min = 0.0,
                    max = 100.0
                }
            }
        },
        minfuel = 0.0,
        maxfuel = 100.0,
        position = vector3(-1098.25, 2700.12, 18.63),
        heading = 358.8
    },
    {
        models = { --What type of cars can spawn at this location
            "zentorno",
            "adder"
        },
        damaged = { --Control how damaged the car will spawn
            minenginehealth = 500.0,
            maxenginehealth = 1000.0,
            minbodyhealth = 500.0,
            maxbodyhealth = 1000.0,
            tyres = {
                [1] = { --Tyre health?
                    min = 0.0,
                    max = 100.0
                },
                [2] = {
                    min = 0.0,
                    max = 100.0
                },
                [4] = {
                    min = 0.0,
                    max = 100.0
                },
                [5] = {
                    min = 0.0,
                    max = 100.0
                }
            }
        },
        minfuel = 0.0,
        maxfuel = 100.0,
        position = vector3(1956.3, 3762.53, 32),
        heading = 207.5
    }
}

Config.PotentialBikeSpawns = {
    {
        models = {
            "bmx"
        },
        position = vector3(-761.4, 1645.44, 204.8),
        heading = 0.0
    },
    {
        models = {
            "bmx"
        },
        position = vector3(-801.2, 1840.5, 165.4),
        heading = 0.0
    },
    {
        models = {
            "bmx"
        },
        position = vector3(-1580.43, 2104.57, 67.16),
        heading = 0.0
    },
    {
        models = {
            "bmx"
        },
        position = vector3(-1132.77, 2695.98, 18.0),
        heading = 270.0
    },
    {
        models = {
            "bmx"
        },
        position = vector3(-4581.89, 2858.38, 34.62),
        heading = 270.0
    },
    {
        models = {
            "bmx"
        },
        position = vector3(-295.39, 2816.95, 58.8),
        heading = 270.0
    },
    {
        models = {
            "bmx"
        },
        position = vector3(251.5, 3119.64, 42.3),
        heading = 270.0
    },
    {
        models = {
            "bmx"
        },
        position = vector3(916.56, 3658.75, 32.3),
        heading = 270.0
    },
    {
        models = {
            "bmx"
        },
        position = vector3(1543.2, 3779.68, 33.8),
        heading = 270.0
    },
    {
        models = {
            "bmx"
        },
        position = vector3(2460, 4073.7, 37.8),
        heading = 270.0
    }
}

--If the default skills are used, the default GTA levels in the pause menu
Config.DefaultSkills = true
--Time between level ticks
Config.LevelTicks = 10000

--Custom skills that 
Config.CustomSkills = {
    [1] = {
        label = "Stamina", --What will be displayed to players
        stat = "MP0_STAMINA",
        expperlevel = 500, --How much exp is needed per level
        maxlevel = 100, --Max level a player can reach
        maxexp = 20000000, --Max exp a player can reach
        gainexppertick = false, --Changes how the skill is leveled up
        gainexp = function(source) --This function is run serverside, create your own checks to make sure the player isn't cheating
            local playerData = GetJoinedPlayer(source)
            if playerData then
                if playerData.characterData.isRunning then
                    local skills = playerData.characterData.skills
                    if skills[1] then
                        local xpToNextLvl = Config.CustomSkills[1].expperlevel * playerData.characterData.skills[1].Level
                        playerData.characterData.skills[1].Xp = playerData.characterData.skills[1].Xp + 1
                        if playerData.characterData.skills[1].Xp >= xpToNextLvl then
                            --Hard cap at level 100
                            if playerData.characterData.skills[1].Level + 1 < 100 then
                                playerData.characterData.skills[1].Level = playerData.characterData.skills[1].Level + 1
                                local remXp = playerData.characterData.skills[1].Xp - xpToNextLvl
                                playerData.characterData.skills[1].Xp = remXp
                                TriggerClientEvent("fivez:AddNotification", source, "You have leveled up Stamina!")
                            end
                        end
                        TriggerClientEvent("fivez:AddExp", source, 1, playerData.characterData.skills[1].Xp)
                        SQL_UpdateCharacterSkill(playerData.characterData.Id, 1, playerData.characterData.skills[1].Level, playerData.characterData.skills[1].Xp)
                        return
                    end
                    --If we don't have the skill add it
                    playerData.characterData.skills[1] = {
                        Id = 1,
                        Level = 1,
                        Xp = 0
                    }
                    SQL_InsertCharacterSkillData(playerData.characterData.Id, 1)
                    TriggerClientEvent("fivez:AddExp", source, 1, 0)
                end
            end
        end,
        clienteffect = function(source, level)
            local plyPed = GetPlayerPed(source)
            if DoesEntityExist(plyPed) then
                local baseStam = 95
                print(maxStam)
                local newStam = baseStam + (5 * level)
                --If we have already affected the maximum stam
                if GetPlayerMaxStamina(PlayerId()) == newStam then return end
                SetPlayerMaxStamina(PlayerId(), newStam)
            end
        end
    },
    [2] = {
        label = "Strength",
        stat = "MP0_STRENGTH",
        expperlevel = 500,
        maxlevel = 100,
        maxexp = 2000000,
        gainexp = function(source)
            local playerData = GetJoinedPlayer(source)

            if playerData then
                if playerData.characterData.isMelee then
                    local skills = playerData.characterData.skills
                    if skills[2] then
                        local xpToNextLevel = Config.CustomSkills[2].expperlevel * playerData.characterData.skills[2].Level
                        playerData.characterData.skills[2].Xp = playerData.characterData.skills[2].Xp + 1
                        if playerData.characterData.skills[2].Xp >= xpToNextLevel then
                            --Hard cap at level 100
                            if playerData.characterData.skills[2].Level + 1 < 100 then
                                playerData.characterData.skills[2].Level = playerData.characterData.skills[2].Level + 1
                                local remXp = playerData.characterData.skills[2].Xp - xpToNextLevel
                                playerData.characterData.skills[2].Xp = remXp
                                TriggerClientEvent("fivez:AddNotification", source, "You leveled up strength")
                            end
                        end
                        TriggerClientEvent("fivez:AddExp", source, 2, playerData.characterData.skills[2].Xp)
                        SQL_UpdateCharacterSkill(playerData.characterData.Id, 2, playerData.characterData.skills[2].Level, playerData.characterData.skills[2].Xp)
                        return
                    end

                    playerData.characterData.skills[2] = {
                        Id = 2,
                        Level = 1,
                        Xp = 0
                    }
                    SQL_InsertCharacterSkillData(playerData.characterData.Id, 2)
                    TriggerClientEvent("fivez:AddExp", source, 2, 0)
                end
            end
        end,
        clienteffect = function(source, level)
            local plyPed = GetPlayerPed(source)
            if DoesEntityExist(plyPed) then
                local baseHealth = 95
                local newHealth = baseHealth + (5 * level)
                if GetPedMaxHealth(plyPed) == newHealth then return end
                SetPedMaxHealth(plyPed, newHealth)
            end
        end
    },
    [3] = {
        label = "Lung Capacity",
        stat = "MP0_LUNG_CAPACITY",
        expperlevel = 500,
        gainexp = function()
            local playerData = GetJoinedPlayer(source)

            if playerData then
                if playerData.characterData.isUnderwater then
                    local skills = playerData.characterData.skills
                    if skills[3] then
                        local xpToNextLevel = Config.CustomSkills[3].expperlevel * playerData.characterData.skills[3].Level
                        playerData.characterData.skills[3].Xp = playerData.characterData.skills[3].Xp + 1
                        if playerData.characterData.skills[3].Xp >= xpToNextLevel then
                            --Hard cap at level 100
                            if playerData.characterData.skills[3].Level + 1 < 100 then
                                playerData.characterData.skills[3].Level = playerData.characterData.skills[3].Level + 1
                                local remXp = playerData.characterData.skills[3].Xp - xpToNextLevel
                                playerData.characterData.skills[3].Xp = remXp
                                TriggerClientEvent("fivez:AddNotification", source, "You leveled up strength")
                            end
                        end
                        TriggerClientEvent("fivez:AddExp", source, 3, playerData.characterData.skills[3].Xp)
                        SQL_UpdateCharacterSkill(playerData.characterData.Id, 3, playerData.characterData.skills[3].Level, playerData.characterData.skills[3].Xp)
                        return
                    end

                    playerData.characterData.skills[3] = {
                        Id = 3,
                        Level = 1,
                        Xp = 0
                    }
                    SQL_InsertCharacterSkillData(playerData.characterData.Id, 3)
                    TriggerClientEvent("fivez:AddExp", source, 3, 0)
                end
            end
        end,
        clienteffect = function(source, level)
            local plyPed = GetPlayerPed(source)
            if DoesEntityExist(plyPed) then
                local baseUnderwater = 14
                local newMax = baseUnderwater + (1 * level)
                --TODO: Figure out way to check
                SetPedMaxTimeUnderwater(plyPed, newMax)
            end
        end
    },
    [4] = {
        label = "Wheelie Ability",
        stat = "MP0_WHEELIE_ABILITY",
        gainexp = function()
            print("Gained exp for wheelie")
        end
    },
    [5] = {
        label = "Shooting Skill",
        stat = "MP0_SHOOTING_ABILITY",
        expperlevel = 500,
        gainexp = function()
            local playerData = GetJoinedPlayer(source)

            if playerData then
                if playerData.characterData.isShooting then
                    local skills = playerData.characterData.skills
                    if skills[5] then
                        local xpToNextLevel = Config.CustomSkills[5].expperlevel * playerData.characterData.skills[5].Level
                        playerData.characterData.skills[5].Xp = playerData.characterData.skills[5].Xp + 1
                        if playerData.characterData.skills[5].Xp >= xpToNextLevel then
                            --Hard cap at level 100
                            if playerData.characterData.skills[5].Level + 1 < 100 then
                                playerData.characterData.skills[5].Level = playerData.characterData.skills[5].Level + 1
                                local remXp = playerData.characterData.skills[5].Xp - xpToNextLevel
                                playerData.characterData.skills[5].Xp = remXp
                                TriggerClientEvent("fivez:AddNotification", source, "You leveled up strength")
                            end
                        end
                        TriggerClientEvent("fivez:AddExp", source, 5, playerData.characterData.skills[5].Xp)
                        SQL_UpdateCharacterSkill(playerData.characterData.Id, 5, playerData.characterData.skills[5].Level, playerData.characterData.skills[5].Xp)
                        return
                    end

                    playerData.characterData.skills[5] = {
                        Id = 5,
                        Level = 1,
                        Xp = 0
                    }
                    SQL_InsertCharacterSkillData(playerData.characterData.Id, 5)
                    TriggerClientEvent("fivez:AddExp", source, 5, 0)
                end
            end
        end,
        clienteffect = function(source, level)
            local plyPed = GetPlayerPed(source)
            if DoesEntityExist(plyPed) then

            end
        end
    },
    [6] = {
        label = "Stealth",
        stat = "MP0_STEALTH_ABILITY",
        expperlevel = 500,
        gainexp = function()
            local playerData = GetJoinedPlayer(source)

            if playerData then
                if playerData.characterData.isDucking then
                    local skills = playerData.characterData.skills
                    if skills[6] then
                        local xpToNextLevel = Config.CustomSkills[6].expperlevel * playerData.characterData.skills[6].Level
                        playerData.characterData.skills[6].Xp = playerData.characterData.skills[6].Xp + 1
                        if playerData.characterData.skills[6].Xp >= xpToNextLevel then
                            --Hard cap at level 100
                            if playerData.characterData.skills[6].Level + 1 < 100 then
                                playerData.characterData.skills[6].Level = playerData.characterData.skills[6].Level + 1
                                local remXp = playerData.characterData.skills[6].Xp - xpToNextLevel
                                playerData.characterData.skills[6].Xp = remXp
                                TriggerClientEvent("fivez:AddNotification", source, "You leveled up strength")
                            end
                        end
                        TriggerClientEvent("fivez:AddExp", source, 6, playerData.characterData.skills[6].Xp)
                        SQL_UpdateCharacterSkill(playerData.characterData.Id, 6, playerData.characterData.skills[6].Level, playerData.characterData.skills[6].Xp)
                        return
                    end

                    playerData.characterData.skills[6] = {
                        Id = 6,
                        Level = 1,
                        Xp = 0
                    }
                    SQL_InsertCharacterSkillData(playerData.characterData.Id, 6)
                    TriggerClientEvent("fivez:AddExp", source, 6, 0)
                end
            end
        end,
        clienteffect = function(source, level)
            local baseStealth = 0
            local newStealth = baseStealth + (1 * level)
            SetPlayerStealthPerceptionModifier(PlayerId(), newStealth)
        end
    }
}

--Allows control over loot zombies can drop, undefined is for every zombie but if a ped model is defined
--It will override undefined
Config.ZombieLootTable = {
    [GetHashKey("HC_Gunman")] = {
        [4] = {chance = 20, maxcount = 1}
    },
    ["undefined"] = {
        [4] = {chance = 1, maxcount = 1}
    }
}

--How many inventory slots a dead zombie can have
Config.ZombieInventoryMaxSlots = 6

--Max weight of dead zombie inventory
Config.ZombieInventoryMaxWeight = 50

--How often server tries to sync zombies with player, UP THIS TO LIKE 5 MINUTES ON ACTUAL TESTS
Config.ZombieSyncDelay = 30000

--Delete dead zombies after 300 seconds
Config.DeleteDeadZombiesAfter = 300000

--How close zombies can spawn to players
Config.ZombieSpawnDistanceFromPlayer = 150

--How long between zombie spawns
Config.ZombieSpawnTime = 30000

--Distance from a player a zombie will become 'agro' to the player
Config.ZombieAttackDistance = 60

--Distance from attacking player zombie will stop chasing, should be greater than ZombieAttackDistance
Config.ZombieDeagroDistance = 61

--How many zombies will be spawned per spawn
Config.MaxZombieSpawn = 5

Config.ZombieModels = {
	"U_M_Y_Zombie_01"
}

Config.DoorModels = {
    GetHashKey("02gate3_l")
}

--[[
    This Is How Damage Must Be Applied To Trigger The Limb Damage Aspect
]]
Config.HealthDamage = 10
Config.ArmorDamage = 5

--[[
    This Is The Timer For How Long The Player Will Be In The Bed When They Check-In To Be Healed Automatically, This Is In Seconds
]]
Config.AIHealTimer = 5

--[[ 
    TIMERS This Is In Seconds - This Will Decide How Long The Thread Controlling This Functionality Is Slept For
]]
Config.BleedTickRate = 30

--[[
    This is how many seconds is taken away from the bleed tick rate if the player is walking, jogging, or sprinting
]]
Config.BleedMovementTick = 10
Config.BleedMovementAdvance = 3

--[[ 
    How Many Bleed Ticks You Want To Occur Before A Screen Fade Happens
]]
Config.FadeOutTimer = 2

--[[
    This Is How Many Intervals Pass Before You Blackout | This Is Calculated By BleedTickRate * FadeOutTimer = 1 Blackouttimer Tick 
    So Setting This To 10 with the above set to default would be 10 minutes ((30 * 2) * 10) = 600
]]
Config.BlackoutTimer = 10

--[[
    How Many Bleed Ticks Occur Before Your Bleed Level Is Increased
]]
Config.AdvanceBleedTimer = 10

--[[
    How many times, in seconds, are certain injury types checked to have side-effects applied
]]
Config.HeadInjuryTimer = 30
Config.ArmInjuryTimer = 30
Config.LegInjuryTimer = 15

--[[
    The Chance, In Percent, That Certain Injury Side-Effects Get Applied
]]
Config.HeadInjuryChance = 25
Config.ArmInjuryChance = 25
Config.LegInjuryChance = {
    Running = 50,
    Walking = 15
}

Config.ArmorStaggerChance = 65 -- Note : Small caliber weapons are this % halved

--[[
    The Base Damage That Is Multiplied By Bleed Level Every Time A Bleed Tick Occurs
]]
Config.BleedTickDamage = 4

Config.ShockTillUnconscious = 20 --How much shock value a player can take before becoming unconscious

--How much shock damage that weapon classes deal
Config.WeaponShockValues = {
    ['SMALL_CALIBER'] = 1,
    ['MEDIUM_CALIBER'] = 2,
    ['HIGH_CALIBER'] = 8,
    ['SHOTGUN'] = 12,
    ['CUTTING'] = 5,
    ['LIGHT_IMPACT'] = 1,
    ['HEAVY_IMPACT'] = 3,
    ['EXPLOSIVE'] = 15,
    ['FIRE'] = 10,
    ['SUFFOCATING'] = 0,
    ['OTHER'] = 0,
    ['WILDLIFE'] = 0,
    ['NOTHING'] = 0
}

--[[ ------------------------------------------------------------------------------------------------------------------------------------- ]]
--[[ ------------------------------------------------------------------------------------------------------------------------------------- ]]
--[[ ------------------------------------------------------------------------------------------------------------------------------------- ]]
--[[ ------------------------------------------------------------------------------------------------------------------------------------- ]]
--[[ ------------------------------------------------------------------------------------------------------------------------------------- ]]
--[[ ------------------------------------------------------------------------------------------------------------------------------------- ]]

Config.WeaponClasses = {
    ['SMALL_CALIBER'] = 1,
    ['MEDIUM_CALIBER'] = 2,
    ['HIGH_CALIBER'] = 3,
    ['SHOTGUN'] = 4,
    ['CUTTING'] = 5,
    ['LIGHT_IMPACT'] = 6,
    ['HEAVY_IMPACT'] = 7,
    ['EXPLOSIVE'] = 8,
    ['FIRE'] = 9,
    ['SUFFOCATING'] = 10,
    ['OTHER'] = 11,
    ['WILDLIFE'] = 12,
    ['NOTHING'] = 13
}

Config.WoundStates = {
    'Irritated',
    'Fairly Painful',
    'Extremely Painful',
    'Unbearably Painful',
}

Config.BleedingStates = {
    'Minor Bleeding',
    'Significant Bleeding',
    'Major Bleeding',
    'Extreme Bleeding',
}

Config.MovementRate = {
    0.98,
    0.96,
    0.94,
    0.92,
}

Config.Bones = {
    [0]     = 'NONE',
    [31085] = 'HEAD',
    [31086] = 'HEAD',
    [39317] = 'NECK',
    [57597] = 'SPINE',
    [23553] = 'SPINE',
    [24816] = 'SPINE',
    [24817] = 'SPINE',
    [24818] = 'SPINE',
    [10706] = 'UPPER_BODY',
    [64729] = 'UPPER_BODY',
    [11816] = 'LOWER_BODY',
    [45509] = 'LARM',
    [61163] = 'LARM',
    [18905] = 'LHAND',
    [4089] = 'LFINGER',
    [4090] = 'LFINGER',
    [4137] = 'LFINGER',
    [4138] = 'LFINGER',
    [4153] = 'LFINGER',
    [4154] = 'LFINGER',
    [4169] = 'LFINGER',
    [4170] = 'LFINGER',
    [4185] = 'LFINGER',
    [4186] = 'LFINGER',
    [26610] = 'LFINGER',
    [26611] = 'LFINGER',
    [26612] = 'LFINGER',
    [26613] = 'LFINGER',
    [26614] = 'LFINGER',
    [58271] = 'LLEG',
    [63931] = 'LLEG',
    [2108] = 'LFOOT',
    [14201] = 'LFOOT',
    [40269] = 'RARM',
    [28252] = 'RARM',
    [57005] = 'RHAND',
    [58866] = 'RFINGER',
    [58867] = 'RFINGER',
    [58868] = 'RFINGER',
    [58869] = 'RFINGER',
    [58870] = 'RFINGER',
    [64016] = 'RFINGER',
    [64017] = 'RFINGER',
    [64064] = 'RFINGER',
    [64065] = 'RFINGER',
    [64080] = 'RFINGER',
    [64081] = 'RFINGER',
    [64096] = 'RFINGER',
    [64097] = 'RFINGER',
    [64112] = 'RFINGER',
    [64113] = 'RFINGER',
    [36864] = 'RLEG',
    [51826] = 'RLEG',
    [20781] = 'RFOOT',
    [52301] = 'RFOOT',
}

Config.Weapons = {
    --[[ Small Caliber ]]--
    [`WEAPON_PISTOL`] = Config.WeaponClasses['SMALL_CALIBER'],
    [`WEAPON_COMBATPISTOL`] = Config.WeaponClasses['SMALL_CALIBER'],
    [`WEAPON_APPISTOL`] = Config.WeaponClasses['SMALL_CALIBER'],
    [`WEAPON_COMBATPDW`] = Config.WeaponClasses['SMALL_CALIBER'],
    [`WEAPON_MACHINEPISTOL`] = Config.WeaponClasses['SMALL_CALIBER'],
    [`WEAPON_MICROSMG`] = Config.WeaponClasses['SMALL_CALIBER'],
    [`WEAPON_MINISMG`] = Config.WeaponClasses['SMALL_CALIBER'],
    [`WEAPON_PISTOL_MK2`] = Config.WeaponClasses['SMALL_CALIBER'],
    [`WEAPON_SNSPISTOL`] = Config.WeaponClasses['SMALL_CALIBER'],
    [`WEAPON_SNSPISTOL_MK2`] = Config.WeaponClasses['SMALL_CALIBER'],
    [`WEAPON_VINTAGEPISTOL`] = Config.WeaponClasses['SMALL_CALIBER'],

    --[[ Medium Caliber ]]--
    [`WEAPON_ADVANCEDRIFLE`] = Config.WeaponClasses['MEDIUM_CALIBER'],
    [`WEAPON_ASSAULTSMG`] = Config.WeaponClasses['MEDIUM_CALIBER'],
    [`WEAPON_BULLPUPRIFLE`] = Config.WeaponClasses['MEDIUM_CALIBER'],
    [`WEAPON_BULLPUPRIFLE_MK2`] = Config.WeaponClasses['MEDIUM_CALIBER'],
    [`WEAPON_CARBINERIFLE`] = Config.WeaponClasses['MEDIUM_CALIBER'],
    [`WEAPON_CARBINERIFLE_MK2`] = Config.WeaponClasses['MEDIUM_CALIBER'],
    [`WEAPON_COMPACTRIFLE`] = Config.WeaponClasses['MEDIUM_CALIBER'],
    [`WEAPON_DOUBLEACTION`] = Config.WeaponClasses['MEDIUM_CALIBER'],
    [`WEAPON_GUSENBERG`] = Config.WeaponClasses['MEDIUM_CALIBER'],
    [`WEAPON_HEAVYPISTOL`] = Config.WeaponClasses['MEDIUM_CALIBER'],
    [`WEAPON_MARKSMANPISTOL`] = Config.WeaponClasses['MEDIUM_CALIBER'],
    [`WEAPON_PISTOL50`] = Config.WeaponClasses['MEDIUM_CALIBER'],
    [`WEAPON_REVOLVER`] = Config.WeaponClasses['MEDIUM_CALIBER'],
    [`WEAPON_REVOLVER_MK2`] = Config.WeaponClasses['MEDIUM_CALIBER'],
    [`WEAPON_SMG`] = Config.WeaponClasses['MEDIUM_CALIBER'],
    [`WEAPON_SMG_MK2`] = Config.WeaponClasses['MEDIUM_CALIBER'],
    [`WEAPON_SPECIALCARBINE`] = Config.WeaponClasses['MEDIUM_CALIBER'],
    [`WEAPON_SPECIALCARBINE_MK2`] = Config.WeaponClasses['MEDIUM_CALIBER'],

    --[[ High Caliber ]]--
    [`WEAPON_ASSAULTRIFLE`] = Config.WeaponClasses['HIGH_CALIBER'],
    [`WEAPON_ASSAULTRIFLE_MK2`] = Config.WeaponClasses['HIGH_CALIBER'],
    [`WEAPON_COMBATMG`] = Config.WeaponClasses['HIGH_CALIBER'],
    [`WEAPON_COMBATMG_MK2`] = Config.WeaponClasses['HIGH_CALIBER'],
    [`WEAPON_HEAVYSNIPER`] = Config.WeaponClasses['HIGH_CALIBER'],
    [`WEAPON_HEAVYSNIPER_MK2`] = Config.WeaponClasses['HIGH_CALIBER'],
    [`WEAPON_MARKSMANRIFLE`] = Config.WeaponClasses['HIGH_CALIBER'],
    [`WEAPON_MARKSMANRIFLE_MK2`] = Config.WeaponClasses['HIGH_CALIBER'],
    [`WEAPON_MG`] = Config.WeaponClasses['HIGH_CALIBER'],
    [`WEAPON_MINIGUN`] = Config.WeaponClasses['HIGH_CALIBER'],
    [`WEAPON_MUSKET`] = Config.WeaponClasses['HIGH_CALIBER'],
    [`WEAPON_RAILGUN`] = Config.WeaponClasses['HIGH_CALIBER'],

    --[[ Shotguns ]]--
    [`WEAPON_ASSAULTSHOTGUN`] = Config.WeaponClasses['SHOTGUN'],
    [`WEAPON_BULLUPSHOTGUN`] = Config.WeaponClasses['SHOTGUN'],
    [`WEAPON_DBSHOTGUN`] = Config.WeaponClasses['SHOTGUN'],
    [`WEAPON_HEAVYSHOTGUN`] = Config.WeaponClasses['SHOTGUN'],
    [`WEAPON_PUMPSHOTGUN`] = Config.WeaponClasses['SHOTGUN'],
    [`WEAPON_PUMPSHOTGUN_MK2`] = Config.WeaponClasses['SHOTGUN'],
    [`WEAPON_SAWNOFFSHOTGUN`] = Config.WeaponClasses['SHOTGUN'],
    [`WEAPON_SWEEPERSHOTGUN`] = Config.WeaponClasses['SHOTGUN'],

    --[[ Animals ]]--
    [`WEAPON_ANIMAL`] = Config.WeaponClasses['WILDLIFE'], -- Animal
    [`WEAPON_COUGAR`] = Config.WeaponClasses['WILDLIFE'], -- Cougar
    [`WEAPON_BARBED_WIRE`] = Config.WeaponClasses['WILDLIFE'], -- Barbed Wire
    
    --[[ Cutting Weapons ]]--
    [`WEAPON_BATTLEAXE`] = Config.WeaponClasses['CUTTING'],
    [`WEAPON_BOTTLE`] = Config.WeaponClasses['CUTTING'],
    [`WEAPON_DAGGER`] = Config.WeaponClasses['CUTTING'],
    [`WEAPON_HATCHET`] = Config.WeaponClasses['CUTTING'],
    [`WEAPON_KNIFE`] = Config.WeaponClasses['CUTTING'],
    [`WEAPON_MACHETE`] = Config.WeaponClasses['CUTTING'],
    [`WEAPON_SWITCHBLADE`] = Config.WeaponClasses['CUTTING'],

    --[[ Light Impact ]]--
    --[`WEAPON_GARBAGEBAG`] = Config.WeaponClasses['LIGHT_IMPACT'], -- Garbage Bag
    --[`WEAPON_BRIEFCASE`] = Config.WeaponClasses['LIGHT_IMPACT'], -- Briefcase
    --[`WEAPON_BRIEFCASE_02`] = Config.WeaponClasses['LIGHT_IMPACT'], -- Briefcase 2
    --[`WEAPON_BALL`] = Config.WeaponClasses['LIGHT_IMPACT'],
    --[`WEAPON_FLASHLIGHT`] = Config.WeaponClasses['LIGHT_IMPACT'],
    [`WEAPON_KNUCKLE`] = Config.WeaponClasses['LIGHT_IMPACT'],
    --[`WEAPON_NIGHTSTICK`] = Config.WeaponClasses['LIGHT_IMPACT'],
    --[`WEAPON_SNOWBALL`] = Config.WeaponClasses['LIGHT_IMPACT'],
    --[`WEAPON_UNARMED`] = Config.WeaponClasses['LIGHT_IMPACT'],
    --[`WEAPON_PARACHUTE`] = Config.WeaponClasses['LIGHT_IMPACT'],
    --[`WEAPON_NIGHTVISION`] = Config.WeaponClasses['LIGHT_IMPACT'],
    
    --[[ Heavy Impact ]]--
    [`WEAPON_BAT`] = Config.WeaponClasses['HEAVY_IMPACT'],
    [`WEAPON_CROWBAR`] = Config.WeaponClasses['HEAVY_IMPACT'],
    [`WEAPON_FIREEXTINGUISHER`] = Config.WeaponClasses['HEAVY_IMPACT'],
    [`WEAPON_FIRWORK`] = Config.WeaponClasses['HEAVY_IMPACT'],
    [`WEAPON_GOLFLCUB`] = Config.WeaponClasses['HEAVY_IMPACT'],
    [`WEAPON_HAMMER`] = Config.WeaponClasses['HEAVY_IMPACT'],
    [`WEAPON_PETROLCAN`] = Config.WeaponClasses['HEAVY_IMPACT'],
    [`WEAPON_POOLCUE`] = Config.WeaponClasses['HEAVY_IMPACT'],
    [`WEAPON_WRENCH`] = Config.WeaponClasses['HEAVY_IMPACT'],
    
    --[[ Explosives ]]--
    [`WEAPON_EXPLOSION`] = Config.WeaponClasses['EXPLOSIVE'], -- Explosion
    [`WEAPON_GRENADE`] = Config.WeaponClasses['EXPLOSIVE'],
    [`WEAPON_COMPACTLAUNCHER`] = Config.WeaponClasses['EXPLOSIVE'],
    [`WEAPON_HOMINGLAUNCHER`] = Config.WeaponClasses['EXPLOSIVE'],
    [`WEAPON_PIPEBOMB`] = Config.WeaponClasses['EXPLOSIVE'],
    [`WEAPON_PROXMINE`] = Config.WeaponClasses['EXPLOSIVE'],
    [`WEAPON_RPG`] = Config.WeaponClasses['EXPLOSIVE'],
    [`WEAPON_STICKYBOMB`] = Config.WeaponClasses['EXPLOSIVE'],
    
    --[[ Other ]]--
    [`WEAPON_FALL`] = Config.WeaponClasses['OTHER'], -- Fall
    [`WEAPON_HIT_BY_WATER_CANNON`] = Config.WeaponClasses['OTHER'], -- Water Cannon
    [`WEAPON_RAMMED_BY_CAR`] = Config.WeaponClasses['OTHER'], -- Rammed
    [`WEAPON_RUN_OVER_BY_CAR`] = Config.WeaponClasses['OTHER'], -- Ran Over
    [`WEAPON_HELI_CRASH`] = Config.WeaponClasses['OTHER'], -- Heli Crash
    [`WEAPON_STUNGUN`] = Config.WeaponClasses['OTHER'],
    
    --[[ Fire ]]--
    [`WEAPON_ELECTRIC_FENCE`] = Config.WeaponClasses['FIRE'], -- Electric Fence 
    [`WEAPON_FIRE`] = Config.WeaponClasses['FIRE'], -- Fire
    [`WEAPON_MOLOTOV`] = Config.WeaponClasses['FIRE'],
    [`WEAPON_FLARE`] = Config.WeaponClasses['FIRE'],
    [`WEAPON_FLAREGUN`] = Config.WeaponClasses['FIRE'],

    --[[ Suffocate ]]--
    [`WEAPON_DROWNING`] = Config.WeaponClasses['SUFFOCATING'], -- Drowning
    [`WEAPON_DROWNING_IN_VEHICLE`] = Config.WeaponClasses['SUFFOCATING'], -- Drowning Veh
    [`WEAPON_EXHAUSTION`] = Config.WeaponClasses['SUFFOCATING'], -- Exhaust
    [`WEAPON_BZGAS`] = Config.WeaponClasses['SUFFOCATING'],
    [`WEAPON_SMOKEGRENADE`] = Config.WeaponClasses['SUFFOCATING'],
}