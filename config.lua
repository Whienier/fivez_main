Config = {}

--How long before the server will respawn a player
Config.RespawnTimer = 15000

--When player respawns clears character inventory from database and memory
Config.LoseItemsOnDeath = true
--When player respawns adds a registered inventory with the characters items where they died
Config.DropItemsOnDeath = true

--Time between airdrops
Config.AirdropTimer = 900 * 1000 --15 minutes

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

--REMEMBER TO UPDATE CARWRECKS AND CONTAINERS STREAM FILE
--Used mainly for a player hangout and customization
Config.SafeZones = {
    ["The Last Hold"] = {
        position = vector3(-183.032776, -1548.34656, 34.4813),
        color = vector4(0, 0, 255, 255),
        traders = {
            barber = {vector3(0,0,0)}, --Position of the trader
            clothes = {vector3(0,0,0)},
            playerTrading = true --Allows for player trading through-out the zone
        }
    }
}

--Safe zone protection radius, if a zombie is closer than this to a safezone it will be removed
Config.ZombieProtectionRadius = 100

--Can be areas like military base
Config.HighRiskZones = {
    {
        position = {
            tl = vector3(5, 5, 0),
            tr = vector3(5, -5, 0),
            bl = vector3(-5, 5, 0),
            br = vector3(-5, -5, 0)
        },
        color = vector4(255, 0, 0, 255),
        zombieMultipiler = 2 --Allows for increased zombie spawns in zones
    }
}

--Blips to be created
Config.Blips = {
    {position = vector3(440.131622, -982.410034, 31.090929), labelid = "POLICEBLIP", label = "Police Station", sprite = 60},
    {position = vector3(318.284, -593.79364, 44.02125), labelid = "HOSPITALBLIP", label = "Hospital", sprite = 61},
    {position = vector3(-2301.87622, 3150.99243, 39.83637), labelid = "MILITARYBLIP", label = "Military Base", sprite = 487}
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

--Positions of 'portals' where players can go inside of house interiors
Config.InteriorPortals = {
    ["VineyardHouse"] = {
        inPos = {
            [1] = vector3(301.10,201.87,103.376)
        }, --Table of entry positions to allow for multiple points of entry
        outPos = {
            [1] = vector3(308.91,266.23,82.49)
        } --Table of exit positions to allow for multiple points of exit
    },
    ["Appartment"] = {
        inPos = {
            [1] = vector3(-268.8317, -957.0762, 31.22313)
        },
        outPos = {
            [1] = vector3(-273.6685, -940.0231, 92.51086)
        }
    }
}

--Routing interiors
Config.RoutingInteriors = {
    [1] = {
        inPositions = {
            ["house1"] = {
                [1] = vector3(-990.96, -1104.87, 2.22),
                [2] = vector3(-1001.46, -1086.85, 2.1),
                [3] = vector3(-989.49, -1105.96, 7.15)
            },
            ["house2"] = {
                [1] = vector3(-1035.55, -1145.91, 2.61),
                [2] = vector3(-1024.21, -1164.67, 2.71),
                [3] = vector3(-1037.12, -1144.48, 7.6)
            }
        },
        outPosition = vector3(346.68, -1006, -98.87) --Multiple in positions for one as routing buckets will be assigned to each in position
    }
}

--Places a player can choose to spawn through the spawn menu
Config.DefinedPlayerSpawns = {
    [1] = vector3(-183.032776, -1548.34656, 34.4813), --Safezone
    [2] = vector3(50, 50, 0), --Hospital
    [3] = vector3(-50, -50, 0) --Police department
}

--Random spawns for players
Config.PlayerSpawns = {
    vector3(-951.0881, -1079.3075, 2.5),
    vector3(-1047.66492, -1152.7428, 2.5),
    vector3(-1031.24109, -1109.09021, 2.5),
    vector3(-945.2973, -1123.76025, 2.5),
    vector3(-1108.70947, -1228.6604, 3),
    vector3(-1140.951, -1155.22742, 3),
    vector3(-1352.04163, -1161.6872, 4.719),
    vector3(-1207.71875, -1309.19971, 4.658),
    vector3(-1111.27539, -1501.66711, 5),
    vector3(-1056.55664, -1591.69519, 4.5925),
    vector3(-937.5918, -1523.88135, 5.7637),
    vector3(-1028.57642, -1506.40881, 5.29033),
    vector3(-973.9607, -1432.90417, 8),
    vector3(-860.554749, -1274.84924, 6),
    vector3(292.0359, -606.3621, 44),
    vector3(377.14798, -587.366, 29.5427),
    vector3(-256.801849, -984.27124, 31.9767),
    vector3(-82.4417, -850.581543, 41.39836),
    vector3(-112.499817, -605.982849, 36.896),
    vector3(82.2866745, -853.6192, 30.8753),
    vector3(70.88344, -60.37122, 69.54499),
    vector3(161.357712, -114.107025, 62.934),
    vector3(228.815552, -161.641586, 59.4157),
    vector3(321.469238, -207.154449, 54.8306),
    vector3(417.382629, -210.097733, 60.1542),
    vector3(266.39035, -637.992, 42.35437),
    vector3(4.90391636, -934.347839, 30.3399),
    vector3(139.489731, -860.581, 31.34933),
    vector3(312.170715, -1092.337, 29.8280),
    vector3(246.894653, -1730.7627, 29.7789),
    vector3(252.887985, -1672.9281, 29.7049),
    vector3(106.266853, -1882.3479, 23.9601),
    vector3(189.234634, -1887.4613, 24.8328),
    vector3(153.696579, -1965.24963, 19.40450),
    vector3(245.70784, -1994.91272, 20.1955),
    vector3(388.97818, -1884.773, 25.526),
    vector3(331.902771, -2037.35425, 21.57861),
    vector3(310.024475, -2084.83813, 18.135276),
    vector3(374.559174, -2006.02356, 24.06244),
    vector3(114.670776, -1951.227, 20.3929),
    vector3(-17.9476433, -1855.81555, 25.0258636),
    vector3(-52.9155769, -1785.75891, 28.2486),
    vector3(-467.6496, -1719.1969, 18.755628),
    vector3(-608.3436, -1789.765, 23.410),
    vector3(-970.615662, -1581.01917, 5.19875),
    vector3(-1072.5304, -1654.9884, 4.53659),
    vector3(-1970.779, -530.78894, 12.669),
    vector3(-1920.67065, -576.8561, 12.03628),
    vector3(-1853.31042, -632.491455, 11.5326),
    vector3(-1813.91138, -666.2762, 10.897),
    vector3(-1759.65015, -714.2476, 10.416),
    vector3(-1481.28979, -904.0797, 10),
    vector3(-1463.03137, -658.559753, 29.3666),
    vector3(-1361.859, -677.5936, 25.370),
    vector3(-1304.01331, -582.4234, 29.3035),
    vector3(-586.9172, -810.307861, 26.51847),
    vector3(-483.728577, -693.935364, 33.31128),
    vector3(54.35412, -1433.784, 29.50631),
    vector3(-104.393677, -1630.36389, 32.696),
    vector3(-196.238632, -1672.1947, 33.96110),
    vector3(-119.369453, -1472.32849, 33.99975),
    vector3(-66.2717361, -1523.34912, 33.955),
    vector3(-38.39808, -1447.77222, 31.410),
    vector3(66.2866058, -1416.30469, 29.4901),
    vector3(-325.877472, -1404.6123, 32.24842)
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
    },
    [GetHashKey("weapon_assaultrifle")] = {
        silenced = 20,
        unsilenced = 50
    },
    [GetHashKey("weapon_pumpshotgun")] = {
        silenced = 20,
        unsilenced = 50
    },
    [GetHashKey("weapon_minismg")] = {
        silenced = 15,
        unsilenced = 30
    },
    [GetHashKey("weapon_smg")] = {
        silenced = 15,
        unsilenced = 30
    },
    [GetHashKey("weapon_appistol")] = {
        silenced = 10,
        unsilenced = 25
    },
    [GetHashKey("weapon_pistol50")] = {
        silenced = 25,
        unsilenced = 50
    },
    [GetHashKey("weapon_dbshotgun")] = {
        silenced = 25,
        unsilenced = 50
    },
    [GetHashKey("weapon_taser")] = {
        silenced = 0,
        unsilenced = 0
    }
}
--TODO: Add LootableAreas table that will allow for looting inside interiors with no interactable items
--Models of containers (dumpsters) players can loot
Config.LootableContainers = {
    [GetHashKey("v_res_tre_storagebox")] = {
        maxslots = 25,
        maxweight = 150,
        items = {},
        spawnall = true
    },
    [GetHashKey("v_res_tre_bedsidetable")] = {
        maxslots = 25,
        maxweight = 150,
        items = {},
        spawnall = true
    },
    [GetHashKey("v_res_mp_sofa")] = {
        maxslots = 10,
        maxweight = 25,
        items = {},
        spawnall = true
    },
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
    [GetHashKey("prop_bin_01a")] = {
        maxslots = 5,
        maxweight = 50,
        items = {
            [53] = 50
        },
        spawnall = true
    },
    [GetHashKey("prop_bin_02a")] = {
        maxslots = 5,
        maxweight = 50,
        items = {

        },
        spawnall = true
    },
    [GetHashKey("prop_bin_03a")] = {
        maxslots = 5,
        maxweight = 50,
        items = {},
        spawnall = true
    },
    [GetHashKey("prop_bin_04a")] = {
        maxslots = 5,
        maxweight = 50,
        items = {},
        spawnall = true
    },
    [GetHashKey("prop_bin_05a")] = {
        maxslots = 5,
        maxweight = 50,
        items = {},
        spawnall = true
    },
    [GetHashKey("prop_bin_08a")] = {
        maxslots = 10,
        maxweight = 75,
        items = {},
        spawnall = true
    },
    [GetHashKey("prop_bin_08open")] = {
        maxslots = 10,
        maxweight = 75,
        items = {
            [53] = 50
        },
        spawnall = true
    },
    [GetHashKey("prop_bin_11a")] = {
        maxslots = 5,
        maxweight = 50,
        items = {},
        spawnall = true
    },
    [GetHashKey("prop_bin_11b")] = {
        maxslots = 5,
        maxweight = 50,
        items = {},
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
    [GetHashKey("prop_toolchest_03")] = {
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
    [GetHashKey("prop_toolchest_04")] = {
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
    [GetHashKey("prop_medstation_01")] = {
        maxslots = 5,
        maxweight = 25,
        items = {
            [1] = 90,
            [8] = 75,
            [33] = 35,
            [75] = 45
        },
        spawnall = true
    },
    [GetHashKey("prop_mb_cargo_04a")] = {
        maxslots = 25,
        maxweight = 50,
        items = {
            [14] = 10, --Medium armor
            [15] = 5, -- Heavy armor
            [16] = 1, -- Shotgun
            [17] = 1, --Assault Rifle
            [18] = 5, --Shotgun ammo
            [19] = 5, --Assault Rifle ammo
            [20] = 15, --Cuffs
            [21] = 15, --Cuff keys
            [26] = 1, --SMG
            [27] = 5, --SMG ammo
            [46] = 1, --AP Pistol
            [47] = 1, --Mini SMG
            [48] = 1, --Pistol 50.
            [49] = 5, --AP Pistol ammo
            [50] = 5, --Mini SMG ammo
            [51] = 5, --Pistol 50. ammo
            [52] = 10, --Petrol tank
            [64] = 1, --Taser
            [65] = 2, --Taser ammo
            [69] = 1, --DB Shotgun
            [70] = 5, --DB Shotgun ammo
            [72] = 15
        },
        spawnall = false
    },
    [GetHashKey("ex_prop_adv_case")] = {
        maxslots = 30,
        maxweight = 150,
        items = {
            [15] = {minquality = 50, maxquality = 75, chance = 100},
            [16] = 50,
            [17] = {minquality = 80, maxquality = 100, chance = 75}
        },
        spawnall = true
    },
    [GetHashKey("prop_vend_soda_01")] = {
        maxslots = 5,
        maxweight = 25,
        items = {
            [6] = 85, --Water
            [28] = 75, --Ice-tea
            [29] = 75, --Chips
            [31] = 65, --Vingear chips
            [32] = 75, --Snickers
            [34] = 75, --Limonade
            [39] = 50, --Energy drink
            [40] = 75, --Pepsi
            [41] = 75, --Coke
            [42] = 75 --Sprite
        },
        spawnall = false
    },
    [GetHashKey("prop_vend_soda_02")] = {
        maxslots = 5,
        maxweight = 25,
        items = {
            [6] = 85, --Water
            [28] = 75, --Ice-tea
            [29] = 75, --Chips
            [31] = 65, --Vingear chips
            [32] = 75, --Snickers
            [34] = 75, --Limonade
            [39] = 50, --Energy drink
            [40] = 75, --Pepsi
            [41] = 75, --Coke
            [42] = 75 --Sprite
        },
        spawnall = false
    },
    [GetHashKey("prop_box_wood_04a")] = {
        maxslots = 30,
        maxweight = 150,
        items = {},
        spawnall = true
    },
    [GetHashKey("prop_box_ammo_03a")] = {
        maxslots = 5,
        maxweight = 25,
        items = {
            --TODO: Add all ammos
            [7] = 95 --Pistol ammo
        },
        spawnall = false
    },
    [GetHashKey("prop_skip_06a")] = {
        maxslots = 30,
        maxweight = 500,
        items = {},
        spawnall = true
    },
    [GetHashKey("prop_rub_cabinet01")] = {
        maxslots = 15,
        maxweight = 50,
        items = {}, --TODO: Maybe make this spawn clothes
        spawnall = true
    },
    [GetHashKey("prop_wooden_barrel")] = {
        maxslots = 30,
        maxweight = 50,
        items = {},
        spawnall = true
    }
}
--Containers that players can stash items into
Config.StashContainers = {
    [GetHashKey("prop_idol_case_01")] = {
        label = "Idol Case Stash",
        maxslots = 5,
        maxweight = 25
    }
}
--Table of bag component ids
Config.Bags = {
    [40] = {
        maxslots = 25,
        maxweight = 50
    },
    [41] = { --Component ID of the bag
        maxslots = 25, --Max slots bag can hold
        maxweight = 50 --Max weight bag can hold
    },
    [44] = {
        maxslots = 25,
        maxweight = 50
    },
    [45] = {
        maxslots = 25,
        maxweight = 50
    }
}

--Distance player is away from a lootable container to draw a marker
Config.ContainerMarkerDrawDistance = 5

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
Config.ThirstDecay = 4
--How much items will decay in a characters inventory
Config.InventoryDecay = 5
--Minimum quality spawned items can be
Config.MinQuality = 40
--Max quality spawned items can be
Config.MaxQuality = 100

Config.Items = {
    [1] = {
        itemId = 1,
        label = "Bandage",
        model = "bandage",
        description = "Slightly heals wounds",
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
        description = "Blend in with your surroundings",
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
            return true
        end
    },
    [3] = {
        itemId = 3,
        label = "Cop Uniform",
        model = "copuniform",
        description = "Become the law",
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
            return true
        end
    },
    [4] = {
        itemId = 4,
        label = "Pistol",
        model = "weapon_pistol",
        description = "Basic 9mm pistol",
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
        description = "A Chocolate Bar",
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
            return false
        end,
        spawnchance = 25
    },
    [6] = {
        itemId = 6,
        label = "Water Bottle",
        model = "water",
        description = "Bottle filled with water",
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
            return false
        end,
        spawnchance = 25
    },
    [7] = {
        itemId = 7,
        label = "Pistol Ammo",
        model = "ammunition_pistol",
        description = "Box of 9mm ammunition (25)",
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
                GiveAmmoToPlayer(source, GetHashKey("weapon_pistol"), 25)
                return true
            end
        end,
        spawnchance = 1
    },
    [8] = {
        itemId = 8,
        label = "First Aid Kit",
        model = "firstaidkit",
        description = "Basic first aid kit",
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
        description = "Baseball Bat, can be used to smash in the skulls of zombies or people",
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
        description = "Engine for a car",
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
        description = "A tyre kit fixes all vehicle wheels",
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
        description = "Body kit for vehicles",
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
        description = "Small Armor provides 15 armor",
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
        description = "Medium Armor provides 25 armor",
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
        description = "Heavy Armor provides 45 armor",
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
        description = "Pump Shotgun, useful for taking out zombies close range but is very loud",
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
        description = "Assault Rifle, useful for mowing down hordes of zombies",
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
        description = "12GA Ammunition (25)",
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
                GiveAmmoToPlayer(source, GetHashKey("weapon_pumpshotgun"), curAmmoCount + 25)
                return true
            end
        end
    },
    [19] = {
        itemId = 19,
        label = "Assault Rifle Ammo",
        model = "ammunition_rifle",
        description = "5.56mm Ammunition (25)",
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
                GiveAmmoToPlayer(source, GetHashKey("weapon_assaultrifle"), curAmmoCount + 25)
                return true
            end
        end
    },
    [20] = {
        itemId = 20,
        label = "Cuffs",
        model = "cuffs",
        description = "Useful for the locking bad people up",
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
        description = "Keys for cuffs",
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
        description = "A all-in-one suppressor",
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
        description = "Not the freshest, but will hold hunger at bay",
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
            return false
        end
    },
    [24] = {
        itemId = 24,
        label = "Zipties",
        model = "zipties",
        description = "Useful for quickly tying someone up",
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
        description = "A deadly weapon if used correctly",
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
        description = "Quick firing .45 ACP SMG that will make quick work of anything in your way",
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
        description = ".45 ACP Ammunition (25)",
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
                GiveAmmoToPlayer(source, GetHashKey("weapon_smg"), curAmmoCount + 25)
                return true
            end
        end
    },
    [28] = {
        itemId = 28,
        label = "Ice-Tea",
        model = "icetea",
        description = "Not cold ice tea but will get the job done",
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
            return false
        end,
    },
    [29] = {
        itemId = 29,
        label = "Chips",
        model = "potatochips",
        description = "Small bag of chips",
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
            return false
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
            TriggerClientEvent("fivez:AddNotification", source, "Maybe I can chop this")
        end
    },
    [31] = {
        itemId = 31,
        label = "Vinegar Chips",
        model = "vinegarchips",
        description = "Small bag of chips",
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
            return false
        end
    },
    [32] = {
        itemId = 32,
        label = "Snickers",
        model = "snickers",
        description = "A chocolate bar",
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
            local charData = GetCharacterData()
            charData.hunger = charData.hunger + 10
            return false
        end
    },
    [33] = {
        itemId = 33,
        label = "Med Bag",
        model = "medbag",
        description = "Med-Bag can be used to bring someone back who was once dead",
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
                    if GetEntityHealth(targetPed) <= 0 then
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
        description = "Hot bottle of limonade",
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
            return false
        end
    },
    [35] = {
        itemId = 35,
        label = "Fix Kit",
        model = "fixkit",
        description = "Body Fix Kit for replacing vehicles body",
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
        description = "Drinking this will give you the stamina of a horse",
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
        description = "Hot Dr. Pepper",
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
            return false
        end
    },
    [41] = {
        itemId = 41,
        label = "Coke",
        model = "drink_coke",
        description = "Hot Coca Cola",
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
            return false
        end
    },
    [42] = {
        itemId = 42,
        label = "Sprite",
        model = "drink_sprite",
        description = "Hot Sprite",
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
            return false
        end
    },
    [43] = {
        itemId = 43,
        label = "Bike Kit",
        model = "bikekit",
        description = "Can be used to create a bike",
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
        description = "Lights things on fire",
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
        description = "After a hard day of surviving the zombie apocalypse a cig or two helps relax the mind",
        weight = 3,
        maxcount = 1,
        count = 0,
        quality = 100,
        spawnchance = 25,
        attachments = {},
        containerspawn = true,
        zombiespawn = true,
        serverfunction = function(source, quality)
            local plyData = GetJoinedPlayer(source)
            if plyData then
                plyData.characterData.stress = plyData.characterData.stress - 50
                if plyData.characterData.stress < 0 then plyData.characterData.stress = 0 end
                TriggerClientEvent("fivez:CharacterStressed", source, plyData.characterData.stress)
                return true
            end
        end
    },
    [46] = {
        itemId = 46,
        label = "AP Pistol",
        model = "weapon_appistol",
        description = "Fully automatic pistol firing 9mm ammo",
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
        description = "Fully Automatic Mini-SMG",
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
        description = "A handcannon",
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
        description = "Ammunition for AP Pistol (25)",
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
                GiveAmmoToPlayer(source, GetHashKey("weapon_appistol"), curAmmoCount + 25)
                return true
            end
        end
    },
    [50] = {
        itemId = 50,
        label = "Mini SMG Ammo",
        model = "ammunition_smg",
        description = "Ammunition for Mini SMG (25)",
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
                GiveAmmoToPlayer(source, GetHashKey("weapon_minismg"), curAmmoCount + 25)
                return true
            end
        end
    },
    [51] = {
        itemId = 51,
        label = "Pistol 50. Ammo",
        model = "ammunition_pistol",
        description = "Ammunition for .50 cal pistol",
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
                GiveAmmoToPlayer(source, GetHashKey("weapon_pistol50"), curAmmoCount + 25)
                return true
            end
        end
    },
    [52] = {
        itemId = 52,
        label = "Small Petrol Tank",
        model = "smallpetroltank",
        description = "A small petrol tank fill with gasoline",
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
        description = "A crafting material",
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
        description = "A crafting tool",
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
        description = "A crafting material",
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
        description = "A crafting material",
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
        description = "A crafting material",
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
        description = "A crafting material",
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
        description = "Basic ball-point pen",
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
        description = "A placeable chain link fence, can be used to keep out any unwanted guests",
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
        description = "A placeable chain link frame",
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
        description = "A crafting material",
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
        description = "A crafting material",
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
        description = "A stun gun",
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
        description = "Ammunition for stun gun",
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
        description = "A sturdy night stick",
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
        description = "A blunt machete",
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
        description = "Some booze with a soaked rag stuck inside",
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
        description = "A powerful double barrel shotgun",
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
        description = "Ammunition for double barrel shotgun",
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
        description = "A flashlight",
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
        description = "An artifact, with an engraving 'Dr. GF' on the side",
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
        description = "Some loose cigarettes, handy for relaxing the mind",
        weight = 1,
        maxcount = 15,
        count = 0,
        quality = 100,
        spawnchance = 15,
        attachments = {},
        zombiespawn = true,
        serverfunction = function(source)
            local plyData = GetJoinedPlayer(source)
            if plyData then
                plyData.characterData.stress = plyData.characterData.stress - 5
                if plyData.characterData.stress < 0 then plyData.characterData.stress = 0 end
                TriggerClientEvent("fivez:CharacterStressed", source, plyData.characterData.stress)
                return true
            end
        end
    },
    [74] = {
        itemId = 74,
        label = "Battery",
        model = "battery",
        description = "A crafting material",
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
        description = "An advanced first aid kit for any wounds",
        weight = 3,
        maxcount = 3,
        count = 0,
        quality = 100,
        spawnchance = 1,
        attachments = {},
        clientfunction = function()
            local playerPed = GetPlayerPed(-1)
            local pedMaxHP = GetEntityMaxHealth(playerPed)
            SetEntityHealth(playerPed, GetEntityHealth(playerPed) + 75)
            if GetEntityHealth(playerPed) > pedMaxHP then
                SetEntityHealth(playerPed, pedMaxHP)
            end
        end
    },
    [76] = {
        itemId = 76,
        label = "Beer",
        model = "beer",
        description = "An old bottle with some booze left in it",
        weight = 1,
        maxcount = 5,
        count = 0,
        quality = 100,
        spawnchance = 5,
        attachments = {},
        serverfunction = function(source)
            local plyData = GetJoinedPlayer(source)
            if plyData then
                plyData.characterData.stress = plyData.characterData.stress - 10
                if plyData.characterData.stress < 0 then plyData.characterData.stess = 0 end
                TriggerClientEvent("fivez:CharacterStressed", source, plyData.characterData.stress)
                return true
            end
        end
    },
    [77] = {
        itemId = 77,
        label = "Stash",
        model = "stash",
        description = "A placeable stash used for storing items",
        weight = 15,
        maxcount = 1,
        count = 0,
        quality = 100,
        spawnchance = 0,
        attachments = {},
        serverfunction = function(source)
            local coords = GetEntityCoords(GetPlayerPed(source))
            local object = CreateObject(GetHashKey("prop_idol_case_01"), coords.x, coords.y, coords.z, true, true, false)
            while not DoesEntityExist(object) do
                Citizen.Wait(1)
            end
            Citizen.Wait(500)
            TriggerClientEvent("fivez:Building", source, NetworkGetNetworkIdFromEntity(object))
        end
    },
    [78] = {
        itemId = 78,
        label = "Duffel Bag",
        model = "duffelbag",
        description = "A wearable bag",
        weight = 5,
        maxcount = 1,
        count = 0,
        quality = 100,
        spawnchance = 0,
        attachments = {},
        serverfunction = function(source)
            local characterData = GetJoinedPlayer(source).characterData
            if characterData then
                local appearance = characterData.appearance
                if appearance.components.bag.drawable then
                    if appearance.components.bag.drawable == 40 then TriggerClientEvent("fivez:AddNotification", source, "You already have a bag!") return end
                    local existingData = SQL_GetCharacterBag(characterData.Id, 40)
                    if existingData then
                        local dataItems = SQL_GetCharacterBagInventory(characterData.Id, 40)
                        if dataItems then
                            print("Duffel bag has items", GetPlayerPed(source), GetPlayerPed(tostring(source)))
                            RegisterNewInventory("bag:40:"..characterData.Id, "inventory", "Duffel Bag", 0, 50, 25, dataItems, nil)
                            GetJoinedPlayer(source).characterData.appearance.components.bag.drawable = 40
                            SQL_UpdateCharacterAppearanceData(characterData.Id, GetJoinedPlayer(source).characterData.appearance)
                            SetPedComponentVariation(GetPlayerPed(source), 5, 40, 0, 0)
                            TriggerClientEvent("fivez:GiveBag", source, 40)
                            return true
                        end
                    else
                        local createdInv = SQL_CreateCharacterBagInventory(characterData.Id, 40)
                        if createdInv then
                            GetJoinedPlayer(source).characterData.appearance.components.bag.drawable = 40
                            print("Using duffel bag", source, GetPlayerPed(source), GetPlayerPed(tostring(source)))
                            SetPedComponentVariation(GetPlayerPed(source), 5, 40, 0, 0)
                            RegisterNewInventory("bag:40:"..characterData.Id, "inventory", "Duffel Bag", 0, 50, 25, InventoryFillEmpty(25), nil)
                            return true
                        end
                    end
                end
            end
        end
    },
    [79] = {
        itemId = 79,
        label = "Shirt",
        model = "shirt",
        description = "A basic shirt",
        weight = 2,
        maxcount = 1,
        count = 0,
        quality = 100,
        spawnchance = 0,
        attachments = {},
        serverfunction = function(source)
            local characterData = GetJoinedPlayer(source).characterData
            if characterData then
                local appearance = characterData.appearance
                appearance.components.torso.drawable = 4
                SetPedComponentVariation(GetPlayerPed(source), 3, 4, 0, 0)
                SQL_UpdateCharacterAppearanceData(characterData.Id, appearance)
                return true
            end
        end
    },
    [80] = {
        itemId = 80,
        label = "Pants",
        model = "pants",
        description = "Some pants",
        weight = 2,
        maxcount = 1,
        count = 0,
        quality = 100,
        spawnchance = 0,
        attachments = {},
        serverfunction = function(source)
            local characterData = GetJoinedPlayer(source).characterData
            if characterData then
                local appearance = characterData.appearance
                appearance.components.leg.drawable = 4
                SetPedComponentVariation(GetPlayerPed(source), 4, 4, 0, 0)
                SQL_UpdateCharacterAppearanceData(characterData.Id, appearance)
                return true
            end
        end
    },
    [81] = {
        itemId = 81,
        label = "Dunce Cap",
        model = "duncecap",
        description = "A dunce cap",
        weight = 1,
        maxcount = 1,
        count = 0,
        quality = 100,
        spawnchance = 0,
        attachments = {},
        serverfunction = function(source)
            local characterData = GetJoinedPlayer(source).characterData
            if characterData then
                local appearance = characterData.appearance
                appearance.props.hat.drawable = 1
                SetPedPropIndex(GetPlayerPed(source), 0, 1, 0, true)
                SQL_UpdateCharacterAppearanceData(characterData.Id, appearance)
                return true
            end
        end
    },
    [82] = {
        itemId = 82,
        label = "Glasses",
        model = "glasses",
        description = "Stylish glasses",
        weight = 1,
        maxcount = 1,
        count = 0,
        quality = 100,
        spawnchance = 0,
        attachments = {},
        serverfunction = function(source)
            local characterData = GetJoinedPlayer(source).characterData
            if characterData then
                local appearance = characterData.appearance
                appearance.props.glasses.drawable = 1
                SetPedPropIndex(GetPlayerPed(source), 1, 1, 0, true)
                SQL_UpdateCharacterAppearanceData(characterData.Id, appearance)
                return true
            end
        end
    },
    [83] = {
        itemId = 83,
        label = "Shoes",
        model = "shoes",
        description = "Basic shoes",
        weight = 2,
        maxcount = 1,
        count = 0,
        quality = 100,
        spawnchance = 0,
        attachments = {},
        serverfunction = function(source)
            local characterData = GetJoinedPlayer(source).characterData
            if characterData then
                local appearance = characterData.appearance
                appearance.components.shoes.drawable = 2
                appearance.components.shoes.texture = 1
                SetPedComponentVariation(GetPlayerPed(source), 6, 2, 1, 0)
                SQL_UpdateCharacterAppearanceData(characterData.Id, appearance)
                return true
            end
        end
    },
    [84] = {
        itemId = 84,
        label = "Skeleton Mask",
        model = "skeletonmask",
        description = "A spooky skeleton mask",
        weight = 1,
        maxcount = 1,
        count = 0,
        quality = 100,
        spawnchance = 0,
        attachments = {},
        serverfunction = function(source)
            local characterData = GetJoinedPlayer(source).characterData
            if characterData then
                local appearance = characterData.appearance
                appearance.components.mask.drawable = 2
                SetPedComponentVariation(GetPlayerPed(source), 1, 2, 0, 0)
                SQL_UpdateCharacterAppearanceData(characterData.Id, appearance)
                return true
            end
        end
    },
    [85] = {
        itemId = 85,
        label = "Weapon Parts",
        model = "weaponparts",
        description = "Crafting material",
        weight = 5,
        maxcount = 5,
        count = 0,
        quality = 100,
        spawnchance = 15,
        attachments = {}
    },
    [86] = {
        itemId = 86,
        label = "HG Weapon Parts",
        model = "hgweaponparts",
        description = "Crafting material",
        weight = 7,
        maxcount = 5,
        count = 0,
        qualiy = 100,
        spawnchance = 5,
        attachments = {}
    },
    [87] = {
        itemId = 87,
        label = "Gunpowder",
        model = "gunpowder",
        description = "Crafting material",
        weight = 1,
        maxcount = 15,
        count = 0,
        quality = 100,
        spawnchance = 8,
        attachments = {}
    },
    [88] = {
        itemId = 88,
        label = "Pistol Shell Casing",
        model = "pistolshellcasing",
        description = "Crafting material",
        weight = 1,
        maxcount = 15,
        count = 0,
        quality = 100,
        spawnchance = 10,
        attachments = {}
    },
    [89] = {
        itemId = 89,
        label = "Rifle Shell Casing",
        model = "rifleshellcasing",
        description = "Crafting material",
        weight = 2,
        maxcount = 15,
        count = 0,
        quality = 100,
        spawnchance = 5,
        attachments = {}
    },
    [90] = {
        itemId = 90,
        label = "Sewing Needle",
        model = "sewingneedle",
        description = "Crafting tool",
        weight = 1,
        maxcount = 5,
        count = 0,
        quality = 100,
        spawnchance = 15,
        attachments = {}
    },
    [91] = {
        itemId = 91,
        label = "Armor Plate",
        model = "armorplate",
        description = "Crafting material",
        weight = 5,
        maxcount = 5,
        count = 0,
        quality = 100,
        spawnchance = 10,
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
        description = Config.Items[itemId].description,
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
            description = v.description,
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

--Items players will respawn with
Config.StartingItems = {
    {
        slot = 1, --The slot the item should be spawned in
        item = Config.CreateNewItemWithCountQual(Config.Items[43], 1, 100) --Bike kit
    }
}

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
            Config.CreateNewItemWithCountQual(Config.Items[62], 1, 40), --Wire mesh
            Config.CreateNewItemWithCountQual(Config.Items[54], 0, 1) --Hammer
        }
    },
    {
        label = "Craft Chainlink Fence Frame",
        model = "chainlinkfenceframe",
        count = 1,
        weight = 10,
        required = {
            Config.CreateNewItemWithCountQual(Config.Items[63], 4, 40),
            Config.CreateNewItemWithCountQual(Config.Items[62], 3, 40),
            Config.CreateNewItemWithCountQual(Config.Items[54], 0, 1)
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
            Config.CreateNewItemWithCountQual(Config.Items[1], 5, 50), --Bandage or cloth
            Config.CreateNewItemWithCountQual(Config.Items[8], 5, 50),  --First aid kit
        }
    },
    {
        label = "Craft Small Armor",
        model = "armor",
        count = 1,
        weight = 10,
        required = {
            Config.CreateNewItemWithCountQual(Config.Items[91], 4, 80), --Armor plates
            Config.CreateNewItemWithCountQual(Config.Items[90], 1, 50), --Sewing needle
            Config.CreateNewItemWithCountQual(Config.Items[54], 0, 1)
        }
    },
    {
        label = "Craft Medium Armor",
        model = "medarmor",
        count = 1,
        weight = 15,
        required = {
            Config.CreateNewItemWithCountQual(Config.Items[13], 5, 40), --Small armor
            Config.CreateNewItemWithCountQual(Config.Items[90], 1, 50), --Sewing needle
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
            Config.CreateNewItemWithCountQual(Config.Items[90], 1, 50), --Sewing needle
            Config.CreateNewItemWithCountQual(Config.Items[54], 0, 1) --Hammer
        }
    },
    {
        label = "Craft Molotov",
        model = "molotov",
        count = 1,
        weight = 3,
        required = {
            Config.CreateNewItemWithCountQual(Config.Items[55], 1, 20), --Cloth
            Config.CreateNewItemWithCountQual(Config.Items[76], 1, 20) --Beer
        }
    },
    {
        label = "Craft Pistol",
        model = "weapon_pistol",
        count = 1,
        weight = 5,
        required = {
            Config.CreateNewItemWithCountQual(Config.Items[85], 4, 20), --Weapon parts
            Config.CreateNewItemWithCountQual(Config.Items[54], 0, 1) --Hammer
        }
    },
    {
        label = "Craft Mini-SMG",
        model = "weapon_minismg",
        count = 1,
        weight = 20,
        required = {
            Config.CreateNewItemWithCountQual(Config.Items[85], 4, 20), --Weapon parts
            Config.CreateNewItemWithCountQual(Config.Items[86], 2, 50), --High grade weapon parts
            Config.CreateNewItemWithCountQual(Config.Items[54], 0, 1)
        }
    },
    {
        label = "Craft Pistol Ammo",
        model = "ammunition_pistol",
        count = 2,
        weight = 2,
        required = {
            Config.CreateNewItemWithCountQual(Config.Items[87], 4, 50), --Gunpowder
            Config.CreateNewItemWithCountQual(Config.Items[88], 10, 50), --Pistol Shell Casing
            Config.CreateNewItemWithCountQual(Config.Items[54], 0, 1) --Hammer
        }
    },
    {
        label = "Craft Mini-SMG Ammo",
        model = "ammunition_smg",
        count = 1,
        weight = 2,
        required = {
            Config.CreateNewItemWithCountQual(Config.Items[87], 8, 50), --Gunpowder
            Config.CreateNewItemWithCountQual(Config.Items[89], 10, 50), --Rifle shell casing
            Config.CreateNewItemWithCountQual(Config.Items[54], 0, 1)
        }
    },
    {
        label = "Craft Duffel-Bag",
        model = "duffelbag",
        count = 1,
        weight = 10,
        required = {
            Config.CreateNewItemWithCountQual(Config.Items[55], 8, 80), --Cloth
            Config.CreateNewItemWithCountQual(Config.Items[90], 1, 50) --Sewing needle
        }
    }
}

--Amount of vehicles that can be spawned
Config.MaxSpawnedVehicles = 25
--Amount of cars that can be spawned of the maximum amount of vehicles, -1 is no limit
Config.MaxSpawnCars = 25

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
    [GetHashKey("ruiner")] = "Ruiner",
    [GetHashKey("tornado4")] = "Tornado",
    [GetHashKey("warrener")] = "Warrener"
}

--Positions where cars can spawn
Config.PotentialCarSpawns = {
    {
        models = { --What type of cars can spawn at this location
            "futo",
            "ruiner",
            "tornado4",
            "warrener"
        },
        damaged = { --Control how damaged the car will spawn
            minenginehealth = 0.0,
            maxenginehealth = 0.0,
            minbodyhealth = 0.0,
            maxbodyhealth = 0.0,
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
        maxfuel = 0.0,
        position = vector3(407.413483, -994.5586, 29.5270023),
        heading = 0.0
    },
    {
        models = { --What type of cars can spawn at this location
            "futo",
            "ruiner",
            "tornado4",
            "warrener"
        },
        damaged = { --Control how damaged the car will spawn
            minenginehealth = 0.0,
            maxenginehealth = 0.0,
            minbodyhealth = 0.0,
            maxbodyhealth = 0.0,
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
        maxfuel = 0.0,
        position = vector3(329.844818, -548.8366, 29.0561543),
        heading = 249.0
    },
    {
        models = { --What type of cars can spawn at this location
            "futo",
            "ruiner",
            "tornado4",
            "warrener"
        },
        damaged = { --Control how damaged the car will spawn
            minenginehealth = 0.0,
            maxenginehealth = 0.0,
            minbodyhealth = 0.0,
            maxbodyhealth = 0.0,
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
        maxfuel = 0.0,
        position = vector3(288.3637, -608.5036, 43.803978),
        heading = 0.0
    },
    {
        models = { --What type of cars can spawn at this location
            "futo",
            "ruiner",
            "tornado4"
        },
        damaged = { --Control how damaged the car will spawn
            minenginehealth = 0.0,
            maxenginehealth = 0.0,
            minbodyhealth = 0.0,
            maxbodyhealth = 0.0,
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
        maxfuel = 0.0,
        position = vector3(102.993294, -568.7853, 44.4533653),
        heading = 0.0
    },
    {
        models = { --What type of cars can spawn at this location
            "futo",
            "ruiner",
            "tornado4"
        },
        damaged = { --Control how damaged the car will spawn
            minenginehealth = 0.0,
            maxenginehealth = 0.0,
            minbodyhealth = 0.0,
            maxbodyhealth = 0.0,
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
        maxfuel = 0.0,
        position = vector3(195.102127, -325.622131, 45.9580154),
        heading = 358.8
    },
    {
        models = { --What type of cars can spawn at this location
            "futo",
            "ruiner",
            "tornado4"
        },
        damaged = { --Control how damaged the car will spawn
            minenginehealth = 0.0,
            maxenginehealth = 0.0,
            minbodyhealth = 0.0,
            maxbodyhealth = 0.0,
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
        maxfuel = 0.0,
        position = vector3(-249.379532, -415.0372, 30.89542),
        heading = 207.5
    },
    {
        models = { --What type of cars can spawn at this location
            "futo",
            "ruiner",
            "tornado4"
        },
        damaged = { --Control how damaged the car will spawn
            minenginehealth = 0.0,
            maxenginehealth = 0.0,
            minbodyhealth = 0.0,
            maxbodyhealth = 0.0,
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
        maxfuel = 0.0,
        position = vector3(336.761627, -1471.77063, 29.8930378),
        heading = 207.5
    },
    {
        models = { --What type of cars can spawn at this location
            "futo",
            "ruiner",
            "tornado4"
        },
        damaged = { --Control how damaged the car will spawn
            minenginehealth = 0.0,
            maxenginehealth = 0.0,
            minbodyhealth = 0.0,
            maxbodyhealth = 0.0,
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
        maxfuel = 0.0,
        position = vector3(903.009766, -1565.60352, 31.2790852),
        heading = 207.5
    },
    {
        models = { --What type of cars can spawn at this location
            "futo",
            "ruiner",
            "tornado4"
        },
        damaged = { --Control how damaged the car will spawn
            minenginehealth = 0.0,
            maxenginehealth = 0.0,
            minbodyhealth = 0.0,
            maxbodyhealth = 0.0,
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
        maxfuel = 0.0,
        position = vector3(832.437866, -1977.53137, 29.65047),
        heading = 207.5
    },
    {
        models = { --What type of cars can spawn at this location
            "futo",
            "ruiner",
            "tornado4"
        },
        damaged = { --Control how damaged the car will spawn
            minenginehealth = 0.0,
            maxenginehealth = 0.0,
            minbodyhealth = 0.0,
            maxbodyhealth = 0.0,
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
        maxfuel = 0.0,
        position = vector3(804.644958, -3032.27734, 6.84796858),
        heading = 207.5
    },
    {
        models = { --What type of cars can spawn at this location
            "futo",
            "ruiner",
            "tornado4"
        },
        damaged = { --Control how damaged the car will spawn
            minenginehealth = 0.0,
            maxenginehealth = 0.0,
            minbodyhealth = 0.0,
            maxbodyhealth = 0.0,
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
        maxfuel = 0.0,
        position = vector3(170.718842, -2992.84766, 6.66546965),
        heading = 207.5
    },
    {
        models = { --What type of cars can spawn at this location
            "futo",
            "ruiner",
            "tornado4"
        },
        damaged = { --Control how damaged the car will spawn
            minenginehealth = 0.0,
            maxenginehealth = 0.0,
            minbodyhealth = 0.0,
            maxbodyhealth = 0.0,
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
        maxfuel = 0.0,
        position = vector3(-963.386536, -2243.77441, 9.489776),
        heading = 207.5
    },
    {
        models = { --What type of cars can spawn at this location
            "futo",
            "ruiner",
            "tornado4"
        },
        damaged = { --Control how damaged the car will spawn
            minenginehealth = 0.0,
            maxenginehealth = 0.0,
            minbodyhealth = 0.0,
            maxbodyhealth = 0.0,
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
        maxfuel = 0.0,
        position = vector3(-977.102844, -1479.28625, 6.203434),
        heading = 207.5
    },
    {
        models = { --What type of cars can spawn at this location
            "futo",
            "ruiner",
            "tornado4"
        },
        damaged = { --Control how damaged the car will spawn
            minenginehealth = 0.0,
            maxenginehealth = 0.0,
            minbodyhealth = 0.0,
            maxbodyhealth = 0.0,
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
        maxfuel = 0.0,
        position = vector3(-1161.27759, -1177.86621, 6.124006),
        heading = 207.5
    },
    {
        models = { --What type of cars can spawn at this location
            "futo",
            "ruiner",
            "tornado4"
        },
        damaged = { --Control how damaged the car will spawn
            minenginehealth = 0.0,
            maxenginehealth = 0.0,
            minbodyhealth = 0.0,
            maxbodyhealth = 0.0,
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
        maxfuel = 0.0,
        position = vector3(-1035.00427, -1014.8313, 2.180781),
        heading = 207.5
    },
    {
        models = { --What type of cars can spawn at this location
            "futo",
            "ruiner",
            "tornado4"
        },
        damaged = { --Control how damaged the car will spawn
            minenginehealth = 0.0,
            maxenginehealth = 0.0,
            minbodyhealth = 0.0,
            maxbodyhealth = 0.0,
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
        maxfuel = 0.0,
        position = vector3(-1577.19385, -1019.79419, 13.8407192),
        heading = 207.5
    },
    {
        models = { --What type of cars can spawn at this location
            "futo",
            "ruiner",
            "tornado4"
        },
        damaged = { --Control how damaged the car will spawn
            minenginehealth = 0.0,
            maxenginehealth = 0.0,
            minbodyhealth = 0.0,
            maxbodyhealth = 0.0,
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
        maxfuel = 0.0,
        position = vector3(-1522.307, -557.543335, 33.9953766),
        heading = 207.5
    },
    {
        models = { --What type of cars can spawn at this location
            "futo",
            "ruiner",
            "tornado4"
        },
        damaged = { --Control how damaged the car will spawn
            minenginehealth = 0.0,
            maxenginehealth = 0.0,
            minbodyhealth = 0.0,
            maxbodyhealth = 0.0,
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
        maxfuel = 0.0,
        position = vector3(-698.6273, -136.466034, 37.9504),
        heading = 207.5
    },
    {
        models = { --What type of cars can spawn at this location
            "futo",
            "ruiner",
            "tornado4"
        },
        damaged = { --Control how damaged the car will spawn
            minenginehealth = 0.0,
            maxenginehealth = 0.0,
            minbodyhealth = 0.0,
            maxbodyhealth = 0.0,
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
        maxfuel = 0.0,
        position = vector3(-232.200989, -269.888916, 49.7785),
        heading = 207.5
    },
    {
        models = { --What type of cars can spawn at this location
            "futo",
            "ruiner",
            "tornado4"
        },
        damaged = { --Control how damaged the car will spawn
            minenginehealth = 0.0,
            maxenginehealth = 0.0,
            minbodyhealth = 0.0,
            maxbodyhealth = 0.0,
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
        maxfuel = 0.0,
        position = vector3(361.8603, 289.345062, 104.744576),
        heading = 207.5
    },
    {
        models = { --What type of cars can spawn at this location
            "futo",
            "ruiner",
            "tornado4"
        },
        damaged = { --Control how damaged the car will spawn
            minenginehealth = 0.0,
            maxenginehealth = 0.0,
            minbodyhealth = 0.0,
            maxbodyhealth = 0.0,
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
        maxfuel = 0.0,
        position = vector3(879.6287, -590.209961, 58.8258133),
        heading = 207.5
    },
    {
        models = { --What type of cars can spawn at this location
            "futo",
            "ruiner",
            "tornado4"
        },
        damaged = { --Control how damaged the car will spawn
            minenginehealth = 0.0,
            maxenginehealth = 0.0,
            minbodyhealth = 0.0,
            maxbodyhealth = 0.0,
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
        maxfuel = 0.0,
        position = vector3(1371.24768, -741.7769, 69.07517),
        heading = 207.5
    },
    {
        models = { --What type of cars can spawn at this location
            "futo",
            "ruiner",
            "tornado4"
        },
        damaged = { --Control how damaged the car will spawn
            minenginehealth = 0.0,
            maxenginehealth = 0.0,
            minbodyhealth = 0.0,
            maxbodyhealth = 0.0,
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
        maxfuel = 0.0,
        position = vector3(1147.91064, -1324.12854, 35.96179),
        heading = 207.5
    },
    {
        models = { --What type of cars can spawn at this location
            "futo",
            "ruiner",
            "tornado4"
        },
        damaged = { --Control how damaged the car will spawn
            minenginehealth = 0.0,
            maxenginehealth = 0.0,
            minbodyhealth = 0.0,
            maxbodyhealth = 0.0,
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
        maxfuel = 0.0,
        position = vector3(1381.773, -2059.35278, 53.6856575),
        heading = 207.5
    },{
        models = { --What type of cars can spawn at this location
            "futo",
            "ruiner",
            "tornado4"
        },
        damaged = { --Control how damaged the car will spawn
            minenginehealth = 0.0,
            maxenginehealth = 0.0,
            minbodyhealth = 0.0,
            maxbodyhealth = 0.0,
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
        maxfuel = 0.0,
        position = vector3(967.4494, -2228.7146, 32.1251259),
        heading = 207.5
    },
    {
        models = { --What type of cars can spawn at this location
            "futo",
            "ruiner",
            "tornado4"
        },
        damaged = { --Control how damaged the car will spawn
            minenginehealth = 0.0,
            maxenginehealth = 0.0,
            minbodyhealth = 0.0,
            maxbodyhealth = 0.0,
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
        maxfuel = 0.0,
        position = vector3(325.828156, -2083.90356, 18.1783371),
        heading = 207.5
    },
    {
        models = { --What type of cars can spawn at this location
            "futo",
            "ruiner",
            "tornado4"
        },
        damaged = { --Control how damaged the car will spawn
            minenginehealth = 0.0,
            maxenginehealth = 0.0,
            minbodyhealth = 0.0,
            maxbodyhealth = 0.0,
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
        maxfuel = 0.0,
        position = vector3(18.2806911, -1743.95813, 29.6537533),
        heading = 207.5
    },
    {
        models = { --What type of cars can spawn at this location
            "futo",
            "ruiner",
            "tornado4"
        },
        damaged = { --Control how damaged the car will spawn
            minenginehealth = 0.0,
            maxenginehealth = 0.0,
            minbodyhealth = 0.0,
            maxbodyhealth = 0.0,
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
        maxfuel = 0.0,
        position = vector3(67.10425, 118.714989, 80.1321),
        heading = 207.5
    }
}

--If the default skills are used, the default GTA levels in the pause menu
Config.DefaultSkills = true
--Time between level ticks
Config.LevelTicks = 10000
--How often client effect function of skills are run on a player
Config.ClientEffectSkillsDelay = 1000
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
                            --Players level plus one is lower than skills max level
                            if playerData.characterData.skills[1].Level + 1 < Config.CustomSkills[1].maxlevel then
                                playerData.characterData.skills[1].Level = playerData.characterData.skills[1].Level + 1
                                local remXp = playerData.characterData.skills[1].Xp - xpToNextLvl
                                playerData.characterData.skills[1].Xp = remXp
                                TriggerClientEvent("fivez:AddNotification", source, "You have leveled up Stamina!")
                            end
                        end
                        TriggerClientEvent("fivez:AddExp", source, 1, playerData.characterData.skills[1].Xp)
                        TriggerClientEvent("fivez:AddNotification", source, "Gained XP for Stamina!")
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
                    TriggerClientEvent("fivez:AddNotification", source, "Gained new skill Stamina!")
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
                                TriggerClientEvent("fivez:AddNotification", source, "You leveled up Strength!")
                            end
                        end
                        TriggerClientEvent("fivez:AddExp", source, 2, playerData.characterData.skills[2].Xp)
                        TriggerClientEvent("fivez:AddNotification", source, "Gained XP for Strength!")
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
                    TriggerClientEvent("fivez:AddNotification", source, "Gained new skill Strength!")
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
        gainexp = function(source)
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
                                TriggerClientEvent("fivez:AddNotification", source, "You leveled up Lung Capactiy!")
                            end
                        end
                        TriggerClientEvent("fivez:AddExp", source, 3, playerData.characterData.skills[3].Xp)
                        TriggerClientEvent("fivez:AddNotification", source, "Gained XP for Lung Capacity!")
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
                    TriggerClientEvent("fivez:AddNotification", source, "Gained new skill Lung Capacity!")
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
        gainexp = function(source)
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
                                TriggerClientEvent("fivez:AddNotification", source, "You leveled up Shooting!")
                            end
                        end
                        TriggerClientEvent("fivez:AddExp", source, 5, playerData.characterData.skills[5].Xp)
                        TriggerClientEvent("fivez:AddNotification", source, "Gained XP for Shooting!")
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
                    TriggerClientEvent("fivez:AddNotification", source, "Gained new skill Shooting!")
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
        gainexp = function(source)
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
                                TriggerClientEvent("fivez:AddNotification", source, "You leveled up Stealth!")
                            end
                        end
                        TriggerClientEvent("fivez:AddExp", source, 6, playerData.characterData.skills[6].Xp)
                        TriggerClientEvent("fivez:AddNotification", source, "Gained XP for Stealth!")
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
                    TriggerClientEvent("fivez:AddNotification", source, "Gained new skill Stealth!")
                end
            end
        end,
        clienteffect = function(source, level)
            local baseStealth = 0
            local newStealth = baseStealth + (1 * level)
            SetPlayerStealthPerceptionModifier(PlayerId(), newStealth)
        end
    },
    [7] = {
        label = "Crafting",
        stat = "MP0_CRAFTING",
        expperlevel = 500,
        gainexp = function(source)
            local playerData = GetJoinedPlayer(source)

            if playerData then

            end
        end
    }
}

Config.ZombieSpawns = {
    --Hospital spawn
    vector3(274.2726, -575.1154, 45.2239456),
    --Back of hospital
    vector3(384.658783, -591.6046, 29.4856129),
    --police spawn
    vector3(410.153931, -978.3029, 30.5470123),
    --Ammunation
    vector3(10.750618, -1131.77136, 30.5900154),
    --Appartment
    vector3(-234.195862, -1001.37274, 31.15371),
    --Back of appartment
    vector3(-290.925629, -916.1184, 33.3945),
    --Lucky Plucker
    vector3(130.419617, -1440.65527, 30.8028736),
    --Second hospital
    vector3(289.875946, -1427.98865, 31.531044),
    --Houses
    vector3(-63.6153145, -1468.62524, 33.95157),
    --Cul-de-sac houses
    vector3(102.777176, -1941.49744, 21.8588314),
    --Houses
    vector3(422.00116, -1801.56335, 28.9497719),
    --Arena
    vector3(-192.674011, -2014.6814, 28.8612118),
    --Up Airport
    vector3(-1036.28271, -2734.26318, 21.3609734),
    --Down airport
    vector3(-1030.19348, -2723.48779, 14.2231607),
    --Outside junkyard
    vector3(-540.443237, -1765.09863, 23.05514),
    --Beach houses
    vector3(-1296.30994, -1284.4707, 7.462434),
    --Beach appartments
    vector3(-1026.48511, -1522.80164, 5.93516874),
    --Dock
    vector3(-1654.68433, -1015.07086, 14.13902),
    --Park
    vector3(-964.759338, 313.606628, 72.3385849),
    --High-end appartment
    vector3(-1323.92542, 290.288818, 66.03393),
    --Bank
    vector3(216.911942, 204.178452, 108.378181),
    vector3(-1162.4054, -1599.42334, 5.53901),
    vector3(-1291.58423, -1405.87769, 5.02070141),
    vector3(-1243.30945, -1474.20374, 5.753479),
    vector3(-1360.6449, -1204.19458, 6.747326),
    vector3(-1262.0863, -1368.99365, 5.50411367),
    vector3(-1154.12427, -1353.44934, 5.57836962),
    vector3(-1051.0365, -1401.50867, 5.790922),
    vector3(-1217.3446, -1242.34546, 7.40976334),
    vector3(-1331.08557, -1090.46265, 8.504373),
    vector3(-1521.84741, -881.182434, 11.0616274),
    vector3(-1589.55884, -815.5768, 11.2218237),
    vector3(-1632.56372, -760.726135, 10.6155224),
    vector3(-1669.79346, -713.2009, 11.4796324),
    vector3(-1740.57312, -718.616638, 11.4226341),
    vector3(-1783.783, -657.1187, 11.6339331),
    vector3(-1832.25354, -614.895142, 11.7799034),
    vector3(-1854.67371, -612.9686, 12.1013718),
    vector3(-1886.96143, -570.7621, 12.38144),
    vector3(-1938.93762, -527.7897, 12.3584642),
    vector3(-2005.08118, -487.83902, 12.4342432),
    vector3(-1975.25269, -547.718, 11.7306089),
    vector3(-1811.34814, -687.166138, 11.3657007),
    vector3(-1707.80994, -774.1936, 10.605752),
    vector3(-1655.17029, -889.838562, 9.744274),
    vector3(-1612.89929, -967.08606, 13.6569252),
    vector3(-1622.61243, -1077.54956, 14.6662827),
    vector3(-1425.65686, -721.180237, 24.1752853),
    vector3(-1376.3562, -533.41864, 31.3896828),
    vector3(-1215.19873, -576.9761, 27.950592),
    vector3(-1044.32849, -501.978973, 37.7106056),
    vector3(-1002.46863, -444.67572, 38.2998161),
    vector3(-950.3251, -383.919434, 38.9823761),
    vector3(-952.452332, -308.026672, 39.65412),
    vector3(-1037.227, -326.41272, 39.43162),
    vector3(-1041.21484, -214.422653, 38.8473473),
    vector3(-935.1861, 96.8700256, 52.4144554),
    vector3(-1070.7627, 314.694672, 66.13238),
    vector3(-1068.057, 438.5681, 74.31735),
    vector3(-1111.85571, 475.137756, 82.80999),
    vector3(-1240.52893, 475.294952, 93.9541855),
    vector3(-1322.7, 453.769867, 100.8416),
    vector3(-1418.51782, 469.29892, 109.51329),
    vector3(-1427.13928, 549.9237, 123.302361),
    vector3(-1356.26672, 618.0972, 134.581116),
    vector3(-1360.59375, 558.165161, 129.195358),
    vector3(-1225.82617, 664.936157, 144.331879),
    vector3(-1112.871, 777.935364, 163.422119),
    vector3(-955.119934, 791.942932, 179.394592),
    vector3(-740.983, 836.2874, 216.765289),
    vector3(-708.657349, 947.1606, 237.439987),
    vector3(-426.1527, 1125.4873, 326.162079),
    vector3(-386.197418, 1232.68262, 326.9053),
    vector3(-142.97583, 960.0228, 237.263672),
    vector3(-101.370644, 855.6023, 235.98),
    vector3(277.269958, 611.0564, 155.36972),
    vector3(332.602142, 535.8572, 154.547333),
    vector3(340.771362, 464.215057, 149.012451),
    vector3(385.796661, 437.579529, 143.674561),
    vector3(441.156952, 424.082733, 141.073975),
    vector3(638.0037, 273.585, 103.843216),
    vector3(646.5777, 198.848373, 97.63557),
    vector3(744.4336, 214.277557, 87.70961),
    vector3(700.478638, 46.4931641, 84.84671),
    vector3(823.5399, -91.39693, 81.59064),
    vector3(905.3543, -141.431808, 77.9642),
    vector3(967.1143, -128.4312, 74.69757),
    vector3(938.987549, -260.298584, 68.18786),
    vector3(843.2997, -196.890259, 73.6630249),
    vector3(764.609558, -159.554413, 76.02006),
    vector3(523.3098, -141.302, 60.6640244),
    vector3(536.045166, -226.098236, 52.49044),
    vector3(226.619766, 209.349655, 107.267143),
    vector3(228.126373, 227.618362, 107.443489),
    vector3(239.7874, 203.73526, 107.41954),
    vector3(265.430237, 193.788116, 107.460129),
    vector3(161.604492, 98.3310547, 91.00197),
    vector3(154.09137, 29.35017, 72.75581),
    vector3(270.214783, -91.0775, 71.1954956),
    vector3(199.782135, -275.119446, 49.80315),
    vector3(1068.52307, -389.333618, 68.22822),
    vector3(1130.74268, -351.3155, 67.6317139),
    vector3(1168.50134, -334.941254, 69.7500839),
    vector3(1211.06372, -414.9306, 68.3204651),
    vector3(1195.65, -504.440338, 66.29159),
    vector3(1268.22864, -496.281433, 70.00646),
    vector3(1328.41541, -570.2921, 74.5407),
    vector3(1375.39954, -574.906555, 75.15261),
    vector3(1284.07349, -708.9356, 65.58658),
    vector3(1207.76379, -711.478333, 60.5401459),
    vector3(1191.74438, -614.956, 64.45214),
    vector3(1063.25134, -492.923553, 64.91743),
    vector3(1022.61047, -565.3073, 60.78203),
    vector3(968.76416, -658.7904, 59.0839),
    vector3(1043.16577, -760.894043, 59.2473679),
    vector3(1146.003, -766.377441, 58.9578819),
    vector3(1149.491, -984.1484, 46.9530334),
    vector3(1205.03772, -1453.50415, 37.01893),
    vector3(1149.60718, -1494.00037, 35.80155),
    vector3(807.964966, -1291.73608, 27.7170181),
    vector3(747.499, -980.4907, 25.8787632),
    vector3(900.6838, -1765.7865, 32.9924774),
    vector3(960.547852, -1754.13342, 32.38843),
    vector3(941.113159, -1926.99219, 31.7784042),
    vector3(816.269958, -2058.4646, 30.6050873),
    vector3(371.592133, -2020.15869, 23.5341511),
    vector3(354.2295, -2006.4043, 23.6571655),
    vector3(355.39743, -2055.29053, 21.9637051),
    vector3(272.235321, -2003.76111, 20.5553341),
    vector3(209.494263, -2028.37561, 18.1335449),
    vector3(170.198868, -2025.66309, 19.2252674),
    vector3(279.2815, -2085.6106, 17.51578),
    vector3(172.7703, -1934.21, 21.5788822),
    vector3(114.826683, -1876.78015, 24.7250233),
    vector3(4.103036, -1831.00708, 25.5984459),
    vector3(-46.9512444, -1828.03271, 27.12628),
    vector3(-65.0758743, -1753.10767, 30.5416584),
    vector3(-515.0481, -1784.05908, 23.0595016),
    vector3(-416.129272, -1742.65723, 21.1081657),
    vector3(-310.547058, -1487.80518, 32.0173225),
    vector3(-668.510437, -1210.68591, 11.4383383),
    vector3(-747.5146, -1130.79688, 11.9973259),
    vector3(-811.504456, -1085.87219, 11.8518829),
    vector3(-804.3777, -1109.62537, 11.7457218),
    vector3(-1005.4613, -1122.25085, 2.75455523),
    vector3(-1116.25879, -930.522156, 4.0407486),
    vector3(-1056.44714, -1027.59839, 3.50889349),
    vector3(-1227.54712, -860.8485, 13.6001272),
    vector3(-1314.42371, -923.228333, 12.3834944),
    vector3(-1320.47314, -654.100769, 27.03712),
    vector3(-1364.69983, -595.312744, 30.57881),
    vector3(-1521.08142, -439.436737, 37.25519),
    vector3(-1554.365, -297.612823, 48.9618645),
    vector3(-1615.69788, -219.090439, 56.58259),
    vector3(-1590.69275, -122.656876, 57.9395447),
    vector3(-1559.09338, -180.736145, 56.8066177),
    vector3(-1478.16467, -110.726952, 52.16606),
    vector3(-1411.52319, -73.53678, 54.1901169),
    vector3(-1302.8739, -71.25341, 48.5199623),
    vector3(-1236.18738, -101.13549, 43.6564827),
    vector3(-1172.80432, -135.531815, 41.0868378),
    vector3(-1088.84912, -173.805923, 39.3137627),
    vector3(-979.811462, -158.639908, 38.5488968),
    vector3(-898.854065, -121.617088, 41.5159264),
    vector3(-812.1893, -80.3278656, 38.17495),
    vector3(-710.972534, -32.0212669, 40.2080269),
    vector3(-686.1717, -76.56143, 38.538208),
    vector3(-750.704, -97.20043, 39.051548),
    vector3(-862.2284, -157.02507, 39.3210144),
    vector3(-964.304749, -211.204819, 40.4765244),
    vector3(-1078.25232, -269.7752, 39.3669434),
    vector3(-977.887634, -335.3979, 38.3816261)
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
--Drop locations for air drops to take
Config.AirdropLocations = {
    [1] = vector3(0, 0, 0)
}

--How many inventory slots a dead zombie can have
Config.ZombieInventoryMaxSlots = 6

--Max weight of dead zombie inventory
Config.ZombieInventoryMaxWeight = 50

--How often server tries to sync zombies with player, UP THIS TO LIKE 5 MINUTES ON ACTUAL TESTS
Config.ZombieSyncDelay = 30000

--Delete dead zombies after 300 seconds
Config.DeleteDeadZombiesAfter = 300000

--How close player has to be to zombie spawn before it starts spawning
Config.PlayerDistanceToZombieSpawn = 1000

--How close dynamically spawned zombies can spawn to players
Config.ZombieSpawnDistanceFromPlayer = 150

--How close zombies can spawn to other zombies
Config.ZombieSpawnDistanceFromZombie = 15

--How long between zombie spawns
Config.ZombieSpawnTime = 60000

--Distance from a player a zombie will become 'agro' to the player
Config.ZombieAttackDistance = 60

--Distance from attacking player zombie will stop chasing, should be greater than ZombieAttackDistance
Config.ZombieDeagroDistance = 61

--How many zombies will be spawned per spawn
Config.MaxZombieSpawn = 5

--Zombie night spawn enabled will spawn more zombies at night (requires weathertimesync)
Config.ZombieNightSpawn = true
--Multiplier of zombie spawns when night 
Config.ZombieNightSpawnMultiplier = 2

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