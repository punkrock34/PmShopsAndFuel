Config                            = {}
Config.DrawDistance               = 20.0
Config.Locale = 'en'
Config.DeliveryTime = 10800 -- IN SECOUNDS DEFAULT (10 800) IS 3 HOURS.
Config.TimeBetweenRobberies = 43200 -- In SECOUNDS DEFAULT (43 200) IS 12 HOURS.
Config.CutOnRobbery = 25 -- IN PERCENTAGE FROM THE TARGET SHOP.
Config.RequiredPolices = 1 -- For the robbery.
Config.SellValue = 1.5 -- This is the shops value divided by 1.5
Config.ChangeNamePrice = 1000 -- In $ - how much you can change the shops name for.
Config.UseMythicNotify = true -- Change to false if not using mythic notify.

--Delivery Configs
Config.DriverCutPerBox = 2 --2% per the value of the item for example if a pistol is 25.000$ and you order 25 pistols that would equal to 25.000*25=625.000 so 2% of that would be 12.500 => Final price = 625.000+12.500=637.500 if delivery was chosen.

Config.SmallPickup = 250000   --250000$ smaller in between 0$ and 250000$ the prices of the items
Config.MediumPickup = 500000  --500000$ medium in between 250000$ and 500000$ prices of the items

Config.SmallShipment = 1  -- how many locations to pick from Config.PickupLocations in client.lua
Config.MediumShipment = 3 -- how many locations to pick from Config.PickupLocations in client.lua
Config.BigShipment = 5    -- how many locations to pick from Config.PickupLocations in client.lua
--

--Fuel Configs Shop side rest of the configs are in the other script.
Config.PriceFuel = 1.5 --$ per liter of fuel the owner buys
Config.MaxPrice = 100 -- In $ - maximum value for fuel prices
Config.MinFuelOrder = 100
-- the config for the maximum fuel hold can be found in PMFuel
Config.InsuranceMoney = 2000

Config.VehicleSpawnMarker = {
  MarkerPos = {x=152.2,   y=-3211.62,  z=4.88},
}

Config.BoxesPerStop = 3 -- How many boxes to create per stop of the vehicle.If you increase you gotta add more locations for the spawn. IMPORTANT: YOU HAVE TO ADD IT TO THE client/main.lua Specifically on lines 898 to 905
-- something like this local PackageCoords1 = Config.PickupLocations[AmountOfShipments].BoxN - n in the number.
-- in restock locations just add another new line and add [n] = {PackagedCoords.x,PackagedCoords.y,PackagedCoords.z} Where n is the number and x,y,z coords

Config.VehicleSpawn = {
  Pos = {x=181.45,   y=-3201.29,   z=5.66},  --Spawn vehicle location for mission items/fuel (Delivery available only for items for now)
  TrailerPos = {x=166.84, y=-3217.61, z=5.87, h=270.79}, --Trailer Pos for Items
  TrailerPos2 = {x=602.7,   y=2904.51,    z=39.06}       --Trailer Pos for Fuel
}
Config.SmallPickupUnload = 1  --nr of times the driver has to take from the vehicle to the store items
Config.MediumPickupUnload = 3 --nr of times the driver has to take from the vehicle to the store items
Config.BigPickupUnload = 5    --nr of times the driver has to take from the vehicle to the store items

Config.UseGCPhone = false     --message to police on phone for robbery.

Config.PickupLocations = {
[1] = {
  Pos  = {x = -1069.61,    y=-2070.47,    z=12.29}, --location the driver has to go to.
  Box1 = {x = -1077.61,    y=-2077.71,    z=13.29}, --location first box
  Box2 = {x = -1076.41,    y=-2079.41,    z=13.29}, --location second box
  Box3 = {x = -1074.29,    y=-2079.43,    z=13.29}  --location third box
},
[2] = {
  Pos  = {x = -821.09,    y=-2631.77,    z=12.81}, --location the driver has to go to.
  Box1 = {x = -821.16,    y=-2625.16,    z=13.81}, --location first box
  Box2 = {x = -817.17,    y=-2627.66,    z=13.81}, --location second box
  Box3 = {x = -814.09,    y=-2629.27,    z=13.81}  --location third box
},
[3] = {
  Pos  = {x = 845.77,    y=-2350.88,    z=29.33},  --location the driver has to go to.
  Box1 = {x = 841.66,    y=-2361.76,    z=30.35},  --location first box
  Box2 = {x = 844.6,     y=-2361.09,    z=30.35},  --location second box
  Box3 = {x = 846.73,    y=-2364.19,    z=30.35}   --location third box
},
[4] = {
  Pos  = {x = 1199.37,    y=-3237.8,     z=5.02}, --location the driver has to go to.
  Box1 = {x = 1200.74,    y=-3250.03,    z=7.1},  --location first box
  Box2 = {x = 1195.99,    y=-3249.49,    z=7.1},  --location second box
  Box3 = {x = 1205.98,    y=-3249.82,    z=7.1}   --location third box
},
[5] = {
  Pos  = {x = -503.04,    y=-2841.27,    z=5},    --location the driver has to go to.
  Box1 = {x = -499.72,    y=-2856.5,    z=7.3},   --location first box
  Box2 = {x = -496.87,    y=-2852.72,    z=7.3},  --location second box
  Box3 = {x = -493.44,    y=-2849.49,    z=7.3}   --location third box
},
}

-- CONFIG ITEMS, DON'T FORGET TO ADD CORRECT NUMBER IN THE BRACKETS
-- Make sure you have the items in the database as well in a table called items.
Config.Items = {
  [1] = {label = "Water",       item = "water",        price = 5},
  [2] = {label = "Bread",      item = "bread",       price = 5},
}
-- image folder can be found inside html folder
Config.Images = {
  [1] = {item = "water",   src = "img/water.png"},
  [2] = {item = "bread",   src = "img/bread.png"},
}

--if you want to add your own shop custom shops you need to add them
-- to the database as well including the coords that you input here
Config.Zones = {
  DeliveryMission = {
    Pos   = {x = 132.82,   y = 95.86,  z = 82.51, number = 'delivery'},
  },
  ShopCenter = {
    Pos   = {x = 5.28,   y = -708.22,  z = 44.97, number = 'center'},
  },
  Shop1 = { --Paleto Gas Station
    Pos   = {x = 161.53,   y = 6640.63,  z = 30.71, number = 1},
  },
  Shop2 = { -- Rockford Gas Station
    Pos = {x = -1423.58,  y = -269.9,  z = 45.28, number = 2},
  },
  Shop3 = { --Paleto gun shop
    Pos = {x = -332.04, y = 6082.14,  z = 30.45, number = 3},
  },
  Shop4 = { -- Little seol gun store
    Pos = {x = -662.49, y = -935.01,  z = 20.84, number = 4},
  },
  Shop5 = { -- Vinewood Plaza gun store
    Pos = {x = 252.19,  y = -49.81,  z = 68.94, number = 5},
  },
  Shop6 = { -- Rockford Gun store
    Pos = {x = -1305.92, y = -394.06,   z = 35.7, number = 6},
  },
  Shop7 = { -- Gas Station, postal code 957 Highway to Sandy
    Pos = {x = 2678.916,  y = 3280.671, z = 54.241, number = 7},
  },
  Shop8 = { -- Gas Station: Grove Street
    Pos = {x = -48.519,   y = -1757.514, z = 28.421, number = 8},
  },
  Shop9 = { -- Gas Station: Postol Code 817, North Rochford Drive
    Pos = {x = -1820.523,  y = 792.518,  z = 137.118, number = 9},
  },
  Shop10 = { -- Gas Station: Postal Code 402, Route 15
    Pos = {x = 2557.51,  y = 382.07,  z = 107.62, number = 10},
  },
  Shop11 = { -- Gas Station: Postal Code 1001, Route 66
  Pos = {x = -2540.95, y = 2313.48,  z = 32.55, number = 11},
  },
  Shop12 = { -- Gas Station: Postal Code 366 Vespucci Boulevard
    Pos = {x = -707.51,  y = -914.26,  z = 18.21, number = 12},
  },
  Shop13 = { -- Gas Station: Postal Code 3030 Paleto
  Pos = {x = 1729.22, y = 6414.13,   z = 34.03, number = 13},
  },
  Shop14 = { -- Gas Station: Postal Code 411, Mirror Park Boulevard
  Pos = {x = 1162.99,  y = -323.19, z = 68.21, number = 14},
  },
  Shop15 = { -- Gas Station: Postal Code 2013, Grapeseed Main Street
    Pos = {x = 1698.4,  y = 4924.4,  z = 41.06, number = 15},
  },
  Shop16 = { -- Nightclub/Stripclub: Vanilla Unicorn
    Pos = {x = 127.96,   y = -1285.3, z = 28.28, number = 16},
  },
  Shop17 = { -- Gas Station: Flywheels Mechanic, Sandy
    Pos = {x = 1777.59,   y = 3328.17, z = 40.43, number = 17},
  },
  Shop18 = { -- Gas Station: Davis Brouge Ave
    Pos = {x = 166.71,   y = -1555.44, z = 28.26, number = 18},
  },
  Shop19 = { -- Gas Station: Xero GS Desert 1
  Pos = {x = 45.59,   y = 2788.28, z = 56.88, number = 19},
  },
  Shop20 = { -- Gas Station: Global Oil Harmony 2
  Pos = {x = 265.88,   y = 2598.96, z = 43.77, number = 20},
  },  
  Shop21 = { -- Gas Station: Global Oil Desert 3
  Pos = {x = 1039.11,   y = 2664.9, z = 38.55, number = 21},
  },
  Shop22 = { -- Gas Station: Global Oil Desert 4
  Pos = {x = 1200.96,   y = 2656.19, z = 37.85, number = 22},
  },
  Shop23 = { -- Gas Station: Sandy Sandy 7
  Pos = {x = 2001.94,   y = 3779.27, z = 31.18, number = 23},
  },
  Shop24 = { -- Gas Station: Xero Paleto 11
  Pos = {x = -93.51,   y = 6410.45, z = 30.64, number = 24},
  },
  Shop25 = { -- Gas Station: Xero Pacific B 15
  Pos = {x = -2073.95,   y = -327.06, z = 12.32, number = 25},
  },
  Shop26 = { -- Gas Station: Xero LilS/Calaic Av 17
  Pos = {x = -530.96,   y = -1220.6, z = 17.45, number = 26},
  },
  Shop27 = { -- Gas Station: Xero StrawBerry 19
  Pos = {x = 287.84,   y = -1266.89, z = 28.44, number = 27},
  },
  Shop28 = { -- Gas Station: Ron La Mesa 20
  Pos = {x = 817.86,   y = -1039.58, z = 25.75, number = 28},
  },
  Shop29 = { -- Gas Station: Ron El Burro 21
  Pos = {x = 1211.65,   y = -1390.13, z = 34.38, number = 29},
  },
  Shop30 = { -- Gas Station: Globe Oil Vinewood 23
  Pos = {x = 645.28,   y = 267.67, z = 102.22, number = 30},
  },
  Shop31 = { -- Gas Station: Globe Oil La Puerta 27
  Pos = {x = -341.77,   y = -1483.29, z = 29.69, number = 31},
  },
  Robbery1 = {
    Pos   = {x = 168.75, y = 6644.56, z = 30.71, number = 101, red = true},
  },
  Robbery2 = {
    Pos   = {x = -1416.88, y = -261.77, z = 45.38, number = 102, red = true},
  },
  Robbery3 = {
    Pos   = {x = -331.04, y = 6085.98, z = 30.45, number = 103, red = true},
  },
  Robbery4 = {
    Pos   = {x = -660.76, y = -933.42, z = 20.83, number = 104, red = true},
  },
  Robbery5 = {
    Pos   = {x = 253.82, y = -52.05, z = 68.94, number = 105, red = true},
  },
  Robbery6 = {
    Pos   = {x = -1303.88, y = -396.17, z = 35.7, number = 106, red = true},
  },
  Robbery7 = {
    Pos   = {x = 2673.59, y = 3286.2, z = 54.24, number = 107, red = true},
  },
  Robbery8 = {
    Pos   = {x = -43.18, y = -1748.63, z = 28.42, number = 108, red = true},
  },
  Robbery9 = {
    Pos   = {x = -1827.37, y = 798.78, z = 137.16, number = 109, red = true},
  },
  Robbery10 = {
    Pos   = {x = 2549.87, y = 384.76, z = 107.62, number = 110, red = true},
  },
  Robbery11 = {
    Pos   = {x = 1734.76, y = 6420.48, z = 34.04, number = 111, red = true},
  },
  Robbery12 = {
    Pos   = {x = -709.18, y = -904.4, z = 18.22, number = 112, red = true},
  },
  Robbery13 = {
    Pos   = { x = 1159.84, y = -314.55, z = 68.21, number = 113, red = true},
  },
  Robbery14 = {
    Pos   = {x = 1707.34, y = 4920.29, z = 41.07, number = 114, red = true},
  },
  Robbery15 = {
    Pos   = {x = 93.04, y = -1291.99, z = 28.27, number = 115, red = true},
  },
  Robbery16 = {
    Pos   = {x = -1384.41, y = -628.71, z = -29.82, number = 116, red = true},
  },
  Robbery17 = {
    Pos   = {x = 1764.18, y = 3319.97, z = 40.4, number = 117, red = true},
  },
  Robbery18 = {
    Pos   = {x = 168.98, y = -1553.46, z = 28.25, number = 118, red = true},
  },
  Robbery19 = {
    Pos   = {x = 53.04, y = 2787.32, z = 56.88, number = 119, red = true},
  },
  Robbery20 = {
    Pos   = {x = 261.32, y = 2598.33, z = 43.77, number = 120, red = true},
  },
  Robbery21 = {
    Pos   = {x = 1047.82, y = 2663.34, z = 38.55, number = 121, red = true},
  },
  Robbery22 = {
    Pos   = {x = 1189.95, y = 2651, z = 36.84, number = 122, red = true},
  },
  Robbery23 = {
    Pos   = {x = 1992.4, y = 3791.6, z = 31.18, number = 123, red = true},
  },
  Robbery24 = {
    Pos   = {x = -84.28, y = 6405.8, z = 30.64, number = 124, red = true},
  },
  Robbery25 = {
    Pos   = {x = -2066.66, y = -312.09, z = 12.24, number = 125, red = true},
  },
  Robbery26 = {
    Pos   = {x = -534.36, y = -1236.13, z = 17.45, number = 126, red = true},
  },
  Robbery27 = {
    Pos   = {x = 294.4, y = -1251.32, z = 28.38, number = 127, red = true},
  },
  Robbery28 = {
    Pos   = {x = 822.59, y = -1056.41, z = 26.96, number = 128, red = true},
  },
  Robbery29 = {
    Pos   = {x = 1215.62, y = -1381.67, z = 34.36, number = 129, red = true},
  },
  Robbery30 = {
    Pos   = {x = 650.02, y = 246.3, z = 102.42, number = 130, red = true},
  },
  Robbery31 = {
    Pos   = {x = -356.37, y = -1466.54, z = 29.87, number = 131, red = true},
  },
}


Config.createForSaleBlips = {
  [1] = {x = 123.62,   y = -1034.67,  z = 28.28, n = 1},
  [2] = {x = -1423.58,  y = -269.89,  z = 46.27, n = 2},
  [3] = {x = -332.04, y = 6082.14,  z = 30.45, n = 3},
  [4] = {x = -662.49, y = -935.01,  z = 20.84, n = 4},
  [5] = {x = 252.19, y = -49.81,   z = 68.95, n = 5},
  [6] = {x = -1305.92, y = -394.05,   z = 35.69, n = 6},
  [7] = {x = 2678.91,  y = 3280.67, z = 54.24, n = 7},
  [8] = {x = -48.51,   y = -1757.51, z = 28.42, n = 8},
  [9] = {x = -1820.523,  y = 792.518,  z = 137.118, n = 9},
  [10] = {x = 2557.51,  y = 382.07,  z = 107.62, n = 10},
  [11] = {x = 1729.22, y = 6414.13,   z = 34.03, n = 11},
  [12] = {x = -707.51,  y = -914.26,  z = 18.21, n = 12},
  [13] = {x = 1162.99,  y = -323.19, z = 68.21, n = 13},
  [14] = {x = 1698.4,  y = 4924.4,  z = 41.06, n = 14},
  [15] = {x = 127.96,   y = -1285.3, z = 29.28, n = 15},
  [16] = {x = -2544.18, y = 2316.32,  z = 32.22, n = 16},
  [17] = {x = 1775.86,   y = 3323.83, z = 40.43, n = 17},
  [18] = {x = 166.71,   y = -1555.44, z = 28.26, n = 18},
  [19] = {x = 45.59,   y = 2788.28, z = 56.88, n = 19},
  [20] = {x = 261.32,   y = 2598.33, z = 43.75, n = 20},
  [21] = {x = 1039.11,   y = 2664.9, z = 38.55, n = 21},
  [22] = {x = 1200.96,   y = 2656.19, z = 37.85, n = 22},
  [23] = {x = 2001.94,   y = 3779.27, z = 31.18, n = 23},
  [24] = {x = -93.51,   y = 6410.45, z = 30.64, n = 24},
  [25] = {x = -2073.95,   y = -327.06, z = 12.32, n = 25},
  [26] = {x = -530.96,   y = -1220.6, z = 17.45, n = 26},
  [27] = {x = 287.84,   y = -1266.89, z = 28.44, n = 27},
  [28] = {x = 817.86,   y = -1039.58, z = 25.75, n = 28},
  [29] = {x = 1211.65,   y = -1390.13, z = 34.38, n = 29},
  [30] = {x = 645.28,   y = 267.67, z = 102.22, n = 30},
  [31] = {x = -341.77,   y = -1483.29, z = 29.69, n = 31},
}