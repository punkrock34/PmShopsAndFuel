ESX = nil
local bl_fuelStationsData = {}
PlayerMoney = {}
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('PMFuel:payFromPump')
AddEventHandler('PMFuel:payFromPump', function(price, id, quantity)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeMoney(price)

		for k, v in pairs(bl_fuelStationsData) do
			if v.id == id then
				bl_fuelStationsData[k].quantity = bl_fuelStationsData[k].quantity - quantity
				TriggerClientEvent("PMFuel:sync", - 1, k, bl_fuelStationsData[k])
				MySQL.Async.execute('UPDATE `fuel_stations` SET `quantity` = @quantity WHERE `id` = @id', {
					['@quantity'] = bl_fuelStationsData[k].quantity,
					['@id'] = id
				})			
		end
	end
end)

RegisterServerEvent("PMFuel:PayShopOwnerForFuel")
AddEventHandler("PMFuel:PayShopOwnerForFuel",function(ShopNumber,price)
	MySQL.Async.fetchAll("SELECT * FROM owned_shops WHERE ShopNumber = @number",{['@number']=ShopNumber},function(result)
		if result[1] ~= nil then
			MySQL.Async.execute("UPDATE owned_shops SET money = @money WHERE ShopNumber = @number",{['@number']=ShopNumber,['@money']=result[1].money + price})
		end
	end)
end)

RegisterServerEvent("gas:GiveItem") 
AddEventHandler("gas:GiveItem", function()
  	local _source = source
  	local xPlayer = ESX.GetPlayerFromId(_source)
    xPlayer.addInventoryItem('WEAPON_PETROLCAN', 1)
end)

RegisterServerEvent('PMFuel:changePrice')
AddEventHandler('PMFuel:changePrice', function(number, price)

	for k, v in pairs(bl_fuelStationsData) do
		if tonumber(v.ShopNumber) == tonumber(number) then
			bl_fuelStationsData[k].price = price
			TriggerClientEvent("PMFuel:sync", - 1, k, bl_fuelStationsData[k])
			MySQL.Async.execute('UPDATE `fuel_stations` SET `price` = @price WHERE `ShopNumber` = @number', {
				['@price'] = price,
				['@number'] = number
			})
		end
	end
end)

RegisterServerEvent("GetPlayerMoney")
AddEventHandler("GetPlayerMoney",function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	TriggerClientEvent("Fuel:GetPlayerMoneyClient",-1,xPlayer.getMoney())
end)

RegisterServerEvent("PMFuel:ChangedData")
AddEventHandler("PMFuel:ChangedData",function(number,quantity)
	local xPlayer = ESX.GetPlayerFromId(source)
	for k, v in pairs(bl_fuelStationsData) do
		if tonumber(v.ShopNumber) == tonumber(number) then
			bl_fuelStationsData[k].quantity = bl_fuelStationsData[k].quantity + quantity
			TriggerClientEvent("PMFuel:sync",-1,k, bl_fuelStationsData[k])
			MySQL.Async.fetchAll("SELECT quantity FROM fuel_stations WHERE ShopNumber = @number",{['@number']=number},function(result)
				if result[1].quantity > 0 then
					MySQL.Async.execute("UPDATE fuel_stations SET quantity = @quantity WHERE ShopNumber = @number",{['@number']=number,['@quantity'] = result[1].quantity + quantity})
				else
					MySQL.Async.execute("UPDATE fuel_stations SET quantity = @quantity WHERE ShopNumber = @number",{['@number']=number,['@quantity'] = quantity})
				end
			end)
		end
	end
end)

--[[GET DB DATA]] --


function GetData()
	MySQL.Async.fetchAll('SELECT * FROM fuel_stations', {}, function(result)

		for i = 1, #result, 1 do
			bl_fuelStationsData[i] = {}
			bl_fuelStationsData[i].id = result[i].id
			bl_fuelStationsData[i].name = result[i].name
			bl_fuelStationsData[i].type = result[i].type
			bl_fuelStationsData[i].price = result[i].price
			bl_fuelStationsData[i].quantity = result[i].quantity
			bl_fuelStationsData[i].coords = json.decode(result[i].coords)
			bl_fuelStationsData[i].ShopNumber = result[i].ShopNumber
			if tonumber(result[i].ShopNumber) == 0 then
				MySQL.Async.execute("UPDATE fuel_stations SET quantity = @quantity WHERE ShopNumber = @number",{['@number']=result[i].ShopNumber,['@quantity']=Config.MaxFuelInStation})
				bl_fuelStationsData[i].quantity = Config.MaxFuelInStation
			else
				MySQL.Async.fetchAll("SELECT identifier FROM owned_shops WHERE ShopNumber = @number",{['@number']=result[i].ShopNumber},function(result2)
					if(tonumber(result2[1].identifier) == 0) then
						MySQL.Async.execute("UPDATE fuel_stations SET quantity = @quantity WHERE ShopNumber = @number",{['@number']=result[i].ShopNumber,['@quantity']=Config.MaxFuelInStation})
						bl_fuelStationsData[i].quantity = Config.MaxFuelInStation
					end
				end)
			end
		end
	end)
end

MySQL.ready(function()
	GetData()
end)

ESX.RegisterServerCallback("PMFuel:getCacheData", function(source, cb)
	cb(bl_fuelStationsData)
end)











--[[FILL DB WITH CFG]] --
--MySQL.ready(function()
--	for k, v in pairs(Config.GasStations) do
--		MySQL.Async.execute(
--			'INSERT INTO fuel_stations (quantity, price, coords, name, type) VALUES (@quantity, @price, @coords, @name, @type)',
--			{
--				['@quantity'] = 1000,
--				['@price']      = 1.00,
--				['@coords']      = json.encode({x = ESX.Round(v.x, 2), y = ESX.Round(v.y, 2), z = ESX.Round(v.z, 2)}),
--				['@name']      = "bl_fuel_station_"..k,
--				['@type']      = "bl_fuel_station"
--			}
--		)
--	end
--end)
