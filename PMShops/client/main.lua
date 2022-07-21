local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}
ESX 			    			= nil
local Owner = false
local startPickupDelivery = false
local OrderItemsCart = {}
local Cart = {}
local FuelPrice = 0
local sent = false
local PickupFuel = false
local showblip = false
local displayedBlips = {}
local AllBlips = {}
local number = nil
local OnRobbery = false
local ItemsOrderConfirmed = {}
local PriceTotal = 0
local PriceBeforeCut = 0
local PrecentageOfValue = Config.DriverCutPerBox/100
local DriverCut = 0
local model = nil
local ModelTrailer = nil
local StartedDelivery = false
local ToDelivery = nil
local RequiredVehicle = nil
local removed = false
local vehicle = nil
local trailer = nil
local successful = false
local AmountOfShipments = 0
local Enginehealth = 0
local DeliveryBlip = nil
local ShowNotifOnce = false
local restockLocations = {}
local restockObject = {}
local restockObjectLocation = {}
local CheckCarrying = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj)
			ESX = obj
		end)
		Citizen.Wait(0)
	end
	TriggerServerEvent("ResetActiveMissionsOnStart")
end)

AddEventHandler('onResourceStop', function(resource)
	  if resource == GetCurrentResourceName() then
		  SetNuiFocus(false, false)
	  end
end)
  
RegisterNUICallback('escape', function(data, cb)
	  sent = false 

	  SetNuiFocus(false, false)
  
	  SendNUIMessage({
		  type = "close",
	  })
	  stopAnim()
end)

RegisterNUICallback("CancelOrder",function(data,cb)
	TriggerServerEvent("PM_Shops:CancelOrder",data.ID)
end)

RegisterNetEvent("PMShops:GetInfoForGasStation")
AddEventHandler("PMShops:GetInfoForGasStation",function(FuelInLiters,MaxFuel,QuantityFuelPrecentage,priceFuel)
	FuelTotalLiters = FuelInLiters
	FuelPrecentage = QuantityFuelPrecentage
	MaxFuelOrder = MaxFuel
	FuelPrice = priceFuel
end)

RegisterNUICallback("PriceFuel",function(data, cb)
	cb(Config.PriceFuel)
end)

RegisterNUICallback("GasStationNearby",function(data, cb)
	ESX.TriggerServerCallback("PM_Shop:GetGasStationNextToShop",function(result)
		if result ~= nil then
			cb(true)
		else
			cb(false)
		end
	end,number)
end)

RegisterNUICallback("FuelInLiters",function(data, cb)
	cb(FuelTotalLiters)
end)

RegisterNUICallback("MaxFuelOrder",function(data, cb)
	cb(MaxFuelOrder)
end)

RegisterNUICallback("OrderMenu",function(data, cb)
	local OrderItemsList = {}
	if data.Ordering then
		for i = 1,#Config.Items,1 do
			table.insert(OrderItemsList,{label = Config.Items[i].label,name = Config.Items[i].item,price = Config.Items[i].price,Image = Config.Images[i]})
		end
		cb(OrderItemsList)
	end
end)

RegisterNetEvent("PM_Shops:RefreshId")
AddEventHandler("PM_Shops:RefreshId",function(bool)
local boolean = bool
end)

RegisterNUICallback('putcart', function(data, cb)
	table.insert(Cart, {item = data.item, label = data.label, count = data.count, id = data.id, price = data.price})
	cb(Cart)
end)

RegisterNUICallback('OrderItemsCart', function(data, cb)
	table.insert(OrderItemsCart, {item = data.item, label = data.label,id = data.id, price = data.price})
	cb(OrderItemsCart)
end)

RegisterNUICallback('notify', function(data, cb)
	ESX.ShowNotification(data.msg)
end)

RegisterNUICallback('Owner',function(data,cb)
	ESX.TriggerServerCallback('PM_Shop:getOwnedShop', function(data)
	
		if data ~= nil then
			Owner = true
		end
		cb(Owner)
		
		Owner=false

	end)
end)

RegisterNUICallback("GetImages",function(data,cb)
	for i=1, #data.Items, 1 do
		if Config.Images[i].item == data.Items[i].name then
			data.Items[i].img = Config.Images[i].src
		end
	end
	cb(json.encode(data.Items))
end)

RegisterNUICallback('refresh', function(data, cb)
	 
    Cart = {}

	ESX.TriggerServerCallback('PM_Shop:getOwnedShop', function(data)
		ESX.TriggerServerCallback('PM_Shop:getShopItems', function(result)
			
			if data ~= nil then
				Owner = true
				end

			if result ~= nil then

				SetNuiFocus(true, true)

				SendNUIMessage({
					type = "shop",
					result = result,
					owner = Owner,
				})
			end
		end, number)
	end, number)
end)

RegisterNUICallback("DeliveryHistory",function(data, cb)
	ESX.TriggerServerCallback("PM_Shops:GetHistoryOrders",function(result)
		if(result ~= nil) then
			cb(result)
		end
	end,number)
end)

RegisterNUICallback("DeliveryActive",function(data, cb)
	ESX.TriggerServerCallback("PM_Shops:GetActiveOrders",function(result2)
		if (result2 ~= nil) then
			cb(result2)
		end
	end,number)
end)

RegisterNUICallback('emptycart', function(data, cb)
	Cart = {}
	cb(Cart)
end)

RegisterNUICallback('emptycartOrder',function(data,cb)
	OrderItemsCart = {}
	cb(OrderItemsCart)
end)

RegisterNUICallback('emptyConfirmedList',function(data,cb)
ItemsOrderConfirmed = {}
PriceBeforeCut = 0
DriverCut = 0
end)

RegisterNUICallback('FinishOrder',function(data,cb)
	TriggerServerEvent("PM_Shops:Order",data.isOrder,DriverCut,data.PriceFinal,ItemsOrderConfirmed,number)
	DriverCut = 0
	PriceBeforeCut = 0
	ItemsOrderConfirmed = {}
end)

RegisterNUICallback('buy', function(data, cb)
	TriggerServerEvent('PM_Shops:Buy', number, data.Item, data.Count)
	Cart = {}
	cb(Cart)
end)

RegisterNUICallback("PickUpDelivery",function(data,cb)
	if startPickupDelivery == false then
		ESX.TriggerServerCallback("PM_Shops:MakeDeliveryUnavailableForOthers",function(result) 
			for k,v in pairs(result) do
				TriggerEvent("PM_Shops:pickupMission",tonumber(data.Value),json.decode(v.Items),json.decode(v.Coords),data.ShopID,true,data.ID,data.DriverCut)
			end
			startPickupDelivery = true
		end,data.ID)
	else
		ESX.ShowNotification("~r~ You have chosen a delivery already at shop:"..data.ShopName..".")
	end
end)

RegisterNUICallback('PickUp',function(data,cb)
	table.insert(ItemsOrderConfirmed,{name = data.Item,count=data.Count,label = data.Label})
	PriceBeforeCut = PriceBeforeCut + data.Price
	OrderItemsCart = {}
	cb(Cart)
end)

RegisterNUICallback('Delivery',function(data,cb)
	table.insert(ItemsOrderConfirmed,{name = data.Item,count=data.Count,label=data.Label})
	DriverCut =	DriverCut + (data.Price * PrecentageOfValue)
	PriceBeforeCut = PriceBeforeCut + data.Price
	OrderItemsCart = {}
	cb(Cart)
end)

RegisterNUICallback('GetPriceFinal',function(data,cb)
	PriceTotal = DriverCut + PriceBeforeCut
	cb(PriceTotal)
	PriceTotal = 0
end)

RegisterNUICallback('Fuel', function(data, cb)
	cb(FuelPrecentage)
end)

RegisterNUICallback('Price',function(data, cb)
	local Price = tonumber(data.price);
	if  Price > Config.MaxPrice then   
		SetNotificationBackgroundColor(8)
		ESX.ShowNotification("You can't set more than "..Config.MaxPrice.."$/L")
		Price = 1
	else
	  TriggerEvent("PMFuel:Price",number,Price)
	  ESX.ShowNotification("You set your price to "..Price.."$/L")
	end
	cb(Price)
end)
RegisterNUICallback("CurrentPrice",function(data, cb)
	cb(FuelPrice)
	FuelPrice = 0
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
   PlayerData = xPlayer
end)

local ShopId           = nil
local Msg        = nil
local HasAlreadyEnteredMarker = false
local LastZone                = nil


AddEventHandler('PM_Shop:hasEnteredMarker', function(zone)
	if zone == 'center' then
		ShopId = zone
		number = zone
		Msg  = _U('press_to_open_center')
	elseif zone == 'delivery' then
		ShopId = zone
		number = zone
		Msg  = _U('press_to_open_missions')
	elseif zone <= 100 and CheckCarrying == false then
		ShopId = zone
		number = zone
		Msg  = _U('press_to_open')
	elseif zone >= 100 and CheckCarrying == false then
		ShopId = zone
		number = zone
		Msg  = _U('press_to_rob')
	end
end)

AddEventHandler('PM_Shop:hasExitedMarker', function(zone)
	ShopId = nil
end)

RegisterNUICallback("GetItemsFromShop",function(data,cb)
	ESX.TriggerServerCallback('PM_Shop:getOwnedShop', function(data)
		ESX.TriggerServerCallback('PM_Shop:getShopItems', function(result)
		
				if data ~= nil then
					Owner = true
				end

				if result ~= nil then
					cb(result)
				end

			end, number)
		end, number)
end)

Citizen.CreateThread(function ()
 	 while true do
		Citizen.Wait(1)
		if sent then
			DisableControls()
		end

		if ShopId ~= nil then

			Delay = 0

			SetTextComponentFormat('STRING')
			AddTextComponentString(Msg)
			DisplayHelpTextFromStringLabel(0, 0, 1, -1)

				if IsControlJustReleased(0, Keys['E']) then

					if ShopId == 'center' then
						OpenShopCenter()
					
					elseif ShopId == 'delivery' then
						ESX.TriggerServerCallback("PM_Shop:GetMissionData",function(result)
							SetNuiFocus(true,true)
							SendNUIMessage({
								type="delivery",
								result = result
							})
						end)
						sent = true
					elseif ShopId <= 100 then
						ESX.TriggerServerCallback('PM_Shop:getOwnedShop', function(data)
						ESX.TriggerServerCallback('PM_Shop:getShopItems', function(result)
						
								if data ~= nil then
									Owner = true
								end
	
								if result ~= nil then

									SetNuiFocus(true, true)

									local playerPed = PlayerPedId()
    								FreezePedCameraRotation(playerPed, true)

									SendNUIMessage({
										type = "shop",
										result = result,
										owner = Owner,
									})
									sent = true
								end
			
							end, number)
						end, number)
					elseif ShopId >= 100 then
						Robbery(ShopId - 100)
					end

	 	 		end
		end
	end
 end)

 
function OpenShopCenter()

	ESX.UI.Menu.CloseAll()

  	local elements = {}

		if showblip then
			table.insert(elements, {label = 'Hide ALL shops on the map', value = 'removeblip'})
		else
			table.insert(elements, {label = 'Show ALL shops on the map', value = 'showblip'})
		end

			ESX.TriggerServerCallback('PM_Shop:getShopList', function(data)

				for i=1, #data, 1 do
					table.insert(elements, {label = _U('buy_shop') .. data[i].ShopNumber .. ' [$' .. data[i].ShopValue .. ']', value = 'kop', price = data[i].ShopValue, shop = data[i].ShopNumber})
				end


					ESX.UI.Menu.Open(
					'default', GetCurrentResourceName(), 'shopcenter',
					{
						title    = 'Shop',
						align    = 'left',
						elements = elements
					},
					function(data, menu)

					if data.current.value == 'kop' then
						ESX.UI.Menu.CloseAll()

						ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'name', {
						title = _U('name_shop')
						}, function(data2, menu2)

						local name = data2.value
						TriggerServerEvent('PM_Shops:BuyShop', name, data.current.price, data.current.shop, data.current.bought)
						menu2.close()

						end,
						function(data2, menu2)
							menu2.close()
						end)
						elseif data.current.value == 'removeblip' then
							showblip = false
							createForSaleBlips()
							menu.close()
						elseif data.current.value == 'showblip' then
							showblip = true
							createForSaleBlips()
							menu.close()
						end
					end,function(data, menu)
						menu.close()
					end)
				end,function(data, menu)
		menu.close()
	end)
end

RegisterNUICallback("CompanyMoney",function(data,cb)
	ESX.TriggerServerCallback('PM_Shop:getOwnedShop', function(data)
		cb(data[1].money)
	end, number)
end)

RegisterNUICallback("CompanyName",function(data,cb)
	ESX.TriggerServerCallback('PM_Shop:getOwnedShop', function(data)
		cb(data[1].ShopName)
	end, number)
end)

RegisterNUICallback("Buttons",function(data,cb)
local amount = tonumber(data.Amount)
local name = tostring(data.Name)
	if data.Pressed then
		TriggerServerEvent('PM_Shops:addMoney', amount, number)
	elseif data.Pressed2 then
		TriggerServerEvent('PM_Shops:takeOutMoney', amount, number)
	elseif data.Pressed3 then
		TriggerServerEvent('PM_Shops:changeName', number, name)
	elseif data.Pressed4 then
		SellCompany(number)
	end
end)

function SellCompany(number)
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'sell', {
		title = 'WRITE: (YES) without parentheses to confim'
	  }, function(data4, menu4)
		
		if data4.value == 'YES' then
		  TriggerServerEvent('PM_Shops:SellShop', number)
		  menu4.close()
		end
			end,
			function(data4, menu4)
		menu4.close()
	end)
end

RegisterNUICallback("StorageItems",function(data,cb)
	ESX.TriggerServerCallback("GetStorage",function(result)
		if result ~= nil then
			cb(result)
		end
	end,number)
end)

RegisterNUICallback("ShopItems",function(data,cb)
	ESX.TriggerServerCallback("GetShopItems",function(result)
		if result ~= nil then
			cb(result)
		end
	end,number)
end)

RegisterNUICallback("ChangePriceItems",function(data,cb)
	TriggerServerEvent("PM_Shop:ChangePriceItems",data.Name,data.NewPrice,number)
end)

RegisterNUICallback("StorageToShop",function(data,cb)
	if(tonumber(data.AmountMoved) > tonumber(data.Count)) then
		data.AmountMoved = data.Count
	end
	TriggerServerEvent("PutInShop",number,tostring(data.Item),tonumber(data.AmountMoved),tostring(data.Label))
end)

RegisterNUICallback("ShopToStorage",function(data,cb)
	if(tonumber(data.AmountMoved) > tonumber(data.Count)) then
		data.AmountMoved = data.Count
	end
	TriggerServerEvent("PutInStorage",number,tostring(data.Item),tonumber(data.AmountMoved),data.Label)
end)

RegisterNUICallback("FuelPickup",function(data,cb)
	local PriceFuel = tonumber(data.OrderedFuel)*Config.PriceFuel
	if  PickupFuel == true then
		SetNotificationBackgroundColor(8)
		ESX.ShowNotification("You have already bought fuel...Please go grab it before you can order more")
	elseif data.CompanyMoney < PriceFuel then
		SetNotificationBackgroundColor(8)
		ESX.ShowNotification("Not enough money in company")
	elseif tonumber(data.OrderedFuel) < Config.MinFuelOrder then
		SetNotificationBackgroundColor(8)
		ESX.ShowNotification("You can't buy less than "..Config.MinFuelOrder.."L of fuel")
	else
		PickupFuel = true
		TriggerServerEvent("PM_Shops:OrderFuel",PriceFuel,tonumber(data.OrderedFuel),number,0)
	end
end)

RegisterNetEvent("PM_Shops:PickupMissionFuel")
AddEventHandler("PM_Shops:PickupMissionFuel",function(price,fuel,DeliveryCoords,ShopIdPickup)
	local PlayerPed = GetPlayerPed(-1)
	local DriverCut = 0
	local model = nil
	local ModelTrailer = nil
	local StartedDelivery = false
	local ToDelivery = nil
	local RequiredVehicle = nil
	local removed = false
	vehicle = nil
	trailer = nil
	local successful = false
	local PutBlipForTrailer = false
	local AmountOfShipments = 0
	local Enginehealth = 0
	local DeliveryBlip = nil
	local ShowNotifOnce = false
	local BackToDeposit = false
	local ModelTrailer = GetHashKey("tanker")
	local model = GetHashKey("phantom")
	RequestModel(ModelTrailer)
	RequestModel(model)
	while not HasModelLoaded(model) do Citizen.Wait(0) end while not HasModelLoaded(ModelTrailer) do Citizen.Wait(0) end

	local Blip = AddBlipForCoord(Config.VehicleSpawnMarker.MarkerPos.x,Config.VehicleSpawnMarker.MarkerPos.y,Config.VehicleSpawnMarker.MarkerPos.z)
	SetBlipRoute(Blip,true)
	local TargetCoords = vector3(Config.VehicleSpawnMarker.MarkerPos.x,Config.VehicleSpawnMarker.MarkerPos.y,Config.VehicleSpawnMarker.MarkerPos.z)

	local PutBlipForVehicleSpawn = true

	while(PutBlipForVehicleSpawn) do
		Citizen.Wait(1)
		DrawMarker(27, Config.VehicleSpawnMarker.MarkerPos.x,Config.VehicleSpawnMarker.MarkerPos.y,Config.VehicleSpawnMarker.MarkerPos.z+ 0.05, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 2.0, 0.2, 11,63,105, 200, false, true, 2, false, false, false, false)
		local PlayerCoords = GetEntityCoords(PlayerPed)
		if #(PlayerCoords - TargetCoords) <= 6  and IsPedInAnyVehicle(PlayerPed) == false then
			HelpPromt("Press E to get your vehicle")
			if IsControlJustReleased(1,Keys['E']) then
				TriggerServerEvent("PM_Shops:InsuranceMoney",Config.InsuranceMoney,false)
				exports['mythic_notify']:SendAlert('inform', 'You have paid '..Config.InsuranceMoney..'$ for the insurance of the vehicle!', 10000)
				vehicle = CreateVehicle(model, Config.VehicleSpawn.Pos.x, Config.VehicleSpawn.Pos.y, Config.VehicleSpawn.Pos.z, true, true)
				SetEntityAsMissionEntity(vehicle, true, true)
				local vehRotation = GetEntityRotation(vehicle)
				SetVehicleOnGroundProperly(vehicle)
				SetModelAsNoLongerNeeded(model)
				trailer = CreateVehicle(ModelTrailer, Config.VehicleSpawn.TrailerPos2.x, Config.VehicleSpawn.TrailerPos2.y, Config.VehicleSpawn.TrailerPos2.z, true, true)
				SetVehicleOnGroundProperly(trailer)
				SetModelAsNoLongerNeeded(ModelTrailer)
				RemoveBlip(Blip)
				SetBlipRoute(Blip,false)
				PutBlipForVehicleSpawn = false
				PutBlipForTrailer = true
			end
		end
	end
	while(GetVehiclePedIsIn(PlayerPed) == 0) do
		Citizen.Wait(1)
		DrawMarker(2, Config.VehicleSpawn.Pos.x, Config.VehicleSpawn.Pos.y, Config.VehicleSpawn.Pos.z + 6, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 2.0, 1.0, 11,63,105, 255, true, true, 2, false, false, false, false)
	end
	Citizen.Wait(2000)
	SetVehicleFuelLevel(vehicle, 100 + 0.0)
	local TrailerBlip = AddBlipForCoord(vector3(Config.VehicleSpawn.TrailerPos2.x, Config.VehicleSpawn.TrailerPos2.y, Config.VehicleSpawn.TrailerPos2.z))
	SetBlipRoute(TrailerBlip,true)
	Enginehealth = GetVehicleEngineHealth(vehicle)
	Citizen.Wait(1000)
	while PutBlipForTrailer do
		Citizen.Wait(1)
		DrawMarker(2, Config.VehicleSpawn.TrailerPos2.x, Config.VehicleSpawn.TrailerPos2.y, Config.VehicleSpawn.TrailerPos2.z + 6, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 2.0, 1.0, 11,63,105, 255, true, true, 2, false, false, false, false)
		if(IsVehicleAttachedToTrailer(vehicle)) then
			StartedDelivery = true
			RemoveBlip(TrailerBlip)
			SetBlipRoute(TrailerBlip,false)
			PutBlipForTrailer = false
		end
	end
	if StartedDelivery then
		local once = false
		RequiredVehicle = GetEntityModel(GetVehiclePedIsIn(PlayerPed,false))
		ToDelivery = AddBlipForCoord(vector3(DeliveryCoords.x,DeliveryCoords.y,DeliveryCoords.z))
		SetBlipRoute(ToDelivery,true)
		while Enginehealth > 0 and successful == false do
			Citizen.Wait(1)
			DrawMarker(27, DeliveryCoords.x,DeliveryCoords.y,DeliveryCoords.z+ 0.05, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 2.0, 0.2, 0, 180, 0, 200, false, true, 2, false, false, false, false)
			Enginehealth = GetVehicleEngineHealth(vehicle)
			if IsVehicleAttachedToTrailer(vehicle)==false and removed == false then
				removed = true
				RemoveBlip(ToDelivery)
				SetBlipRoute(ToDelivery,false)
				if ShowNotifOnce == false then
				ESX.ShowNotification("~r~ Reatach trailer to continue!")
				ShowNotifOnce = true
				end
			elseif IsVehicleAttachedToTrailer(vehicle) ~= false and removed == true then
				ToDelivery = AddBlipForCoord(vector3(DeliveryCoords.x,DeliveryCoords.y,DeliveryCoords.z))
				SetBlipRoute(ToDelivery,true)
				removed = false
				ShowNotifOnce = false
			end
			if GetEntityHealth(trailer) == 0 then
				ESX.ShowNotification("~r~ You lost the fuel")
				Enginehealth = 0
				break
			end
			local PlayerCoords = GetEntityCoords(PlayerPed)
			if GetEntityModel(GetVehiclePedIsIn(PlayerPed,false)) == RequiredVehicle then
				ShowNotifOnce = false
				if #(PlayerCoords - vector3(DeliveryCoords.x,DeliveryCoords.y,DeliveryCoords.z)) <= 6 then
					HelpPromt("Press E to store fuel")
					if IsControlJustReleased(1,Keys['E']) then
						TriggerEvent("mythic_progbar:client:progress", {
							name = "RefillingPumps",
							duration = 15000,
							label = "Refilling pumps",
							useWhileDead = false,
							canCancel = false,
							controlDisables = {
								disableMovement = true,
								disableCarMovement = true,
								disableMouse = false,
								disableCombat = true,
							},
						}, function(status)
							if not status then

							end
						end)
						Citizen.Wait(15000)
						RemoveBlip(ToDelivery)
						SetBlipRoute(ToDelivery,false)
						successful = true
					end
				end
			elseif DoesEntityExist(vehicle) and ShowNotifOnce == false then
				ESX.ShowNotification("~r~ Get back in the job vehicle!")
				ShowNotifOnce = true
			end
			if (Enginehealth <= 0 or DoesEntityExist(vehicle) == false or IsEntityDead(PlayerPed)) and successful == false then
				RemoveBlip(ToDelivery)
				SetBlipRoute(ToDelivery,false)
				ESX.ShowNotification("~r~ You lost the fuel")
				Enginehealth = 0
				break
			end
		end
	end
	if successful then
		BackToDeposit = true
		ESX.ShowNotification("~g~ You succesfully delivered the fuel")
		TriggerEvent("PMFuel:GetQuantity",number,fuel)
	end
	if BackToDeposit then
		local Parked = false
		local DistanceBetweenCoordsFinish = nil
		local BlipEnd = AddBlipForCoord(vector3(Config.VehicleSpawnMarker.MarkerPos.x,Config.VehicleSpawnMarker.MarkerPos.y,Config.VehicleSpawnMarker.MarkerPos.z))
		SetBlipRoute(BlipEnd,true)
		while Enginehealth > 0 do
			Citizen.Wait(1)
			local TargetCoords = vector3(Config.VehicleSpawn.Pos.x,Config.VehicleSpawn.Pos.y,Config.VehicleSpawn.Pos.z)
			if IsVehicleAttachedToTrailer(vehicle) and trailer ~= nil then
				while Enginehealth > 0 do
					Citizen.Wait(1)
					DrawMarker(27, Config.VehicleSpawn.TrailerPos.x, Config.VehicleSpawn.TrailerPos.y, Config.VehicleSpawn.TrailerPos.z -0.95, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 2.0, 0.2, 11,63,105, 200, false, true, 2, false, false, false, false)
					if GetEntityHeading(GetPlayerPed(-1)) < 300 and GetEntityHeading(GetPlayerPed(-1)) > 240 and #(GetEntityCoords(GetPlayerPed(-1)) - vector3(Config.VehicleSpawn.TrailerPos.x,Config.VehicleSpawn.TrailerPos.y,Config.VehicleSpawn.TrailerPos.z)) < 6 then
						HelpPromt("Hold H to detach trailer!")
						if IsControlJustPressed(1,Keys['H']) then
							Citizen.Wait(2000)
							break;
						end
					end
					if (Enginehealth <= 0 or DoesEntityExist(vehicle) == false or IsEntityDead(PlayerPed)) then
						RemoveBlip(BlipEnd)
						SetBlipRoute(BlipEnd,false)
						ESX.ShowNotification("~r~ You lost the insurance money")
						Enginehealth = 0
						break
					end
					if IsVehicleAttachedToTrailer(vehicle)==false and removed == false then
						removed = true
						RemoveBlip(BlipEnd)
						SetBlipRoute(BlipEnd,false)
						if ShowNotifOnce == false then
						ESX.ShowNotification("~r~ Reatach trailer to continue!")
						ShowNotifOnce = true
						end
					elseif IsVehicleAttachedToTrailer(vehicle) ~= false and removed == true then
						BlipEnd = AddBlipForCoord(vector3(Config.VehicleSpawnMarker.MarkerPos.x,Config.VehicleSpawnMarker.MarkerPos.y,Config.VehicleSpawnMarker.MarkerPos.z))
						SetBlipRoute(BlipEnd,true)
						removed = false
						ShowNotifOnce = false
					end
					if GetEntityHealth(trailer) == 0 then
						ESX.ShowNotification("~r~ You lost the insurance money")
						Enginehealth = 0
						break
					end
				end
			end
			if Parked == false then
			DrawMarker(27, Config.VehicleSpawn.Pos.x,Config.VehicleSpawn.Pos.y,Config.VehicleSpawn.Pos.z -0.95, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 2.0, 0.2, 11,63,105, 200, false, true, 2, false, false, false, false)
			end
			if #(GetEntityCoords(GetPlayerPed(-1)) - vector3(Config.VehicleSpawn.Pos.x,Config.VehicleSpawn.Pos.y,Config.VehicleSpawn.Pos.z)) < 6 and Parked == false then
				HelpPromt("Press E to park vehicle!")
				if IsControlJustPressed(1,Keys['E']) then
					TaskLeaveVehicle(PlayerPed,vehicle,1)
					FreezeEntityPosition(vehicle,true)
					FreezeEntityPosition(trailer,true)
					SetVehicleDoorsLockedForAllPlayers(vehicle,true)
					HelpPromt("Please go to the laptop to get your insurance money!")
					Parked = true
				end
			end
			if Parked then
				TargetCoords2 = vector3(Config.VehicleSpawnMarker.MarkerPos.x,Config.VehicleSpawnMarker.MarkerPos.y,Config.VehicleSpawnMarker.MarkerPos.z)
				DrawMarker(27, Config.VehicleSpawnMarker.MarkerPos.x,Config.VehicleSpawnMarker.MarkerPos.y,Config.VehicleSpawnMarker.MarkerPos.z+ 0.05, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 2.0, 0.2, 11,63,105, 200, false, true, 2, false, false, false, false)
				DistanceBetweenCoordsFinish = #(GetEntityCoords(GetPlayerPed(-1)) - vector3(Config.VehicleSpawnMarker.MarkerPos.x,Config.VehicleSpawnMarker.MarkerPos.y,Config.VehicleSpawnMarker.MarkerPos.z))
			end
			if(Parked and DistanceBetweenCoordsFinish < 2) then
				HelpPromt("Press E to get your money back!")
				if(IsControlJustPressed(1,Keys['E'])) then
					DoScreenFadeOut(1000)
					Citizen.Wait(1500)
					DeleteVehicle(vehicle)
					DeleteVehicle(trailer)
					DoScreenFadeIn(1500)
					TriggerServerEvent("PM_Shops:InsuranceMoney",Config.InsuranceMoney,true)
					exports['mythic_notify']:SendAlert('inform', 'You got your insurance money back.', 10000)
					Parked = false
					Enginehealth = 0
					RemoveBlip(BlipEnd)
					SetBlipRoute(BlipEnd,false)
					break;
				end
			end
			if (Enginehealth <= 0 or DoesEntityExist(vehicle) == false or IsEntityDead(PlayerPed)) then
				RemoveBlip(BlipEnd)
				SetBlipRoute(BlipEnd,false)
				ESX.ShowNotification("~r~ You lost the insurance money")
				Enginehealth = 0
				break
			end
		end
	end
	PickupFuel = false
end)

RegisterNetEvent('PM_Shops:pickupMission')
AddEventHandler("PM_Shops:pickupMission",function(price,items,DeliveryCoords,ShopIdPickup,isDelivery,IdDelivery,DriverCut)
	local PlayerPed = GetPlayerPed(-1)
	local model = nil
	local ModelTrailer = nil
	local StartedDelivery = false
	local ToDelivery = nil
	local RequiredVehicle = nil
	local removed = false
 	vehicle = nil
	trailer = nil
	local successful = false
	local AmountOfShipments = 0
	local Enginehealth = 0
	local DeliveryBlip = nil
	local ShowNotifOnce = false
	local Big,Small,Medium = false
	local MoveVehicleBack = false
	TriggerServerEvent("SaveData",isDelivery,IdDelivery)
	if price > 0 and price <= Config.SmallPickup then
		model = GetHashKey("mule3")
		RequestModel(model)
		while not HasModelLoaded(model) do Citizen.Wait(0) end
		AmountOfShipments = Config.SmallShipment
		Small = true
	elseif price > Config.SmallPickup and price <= Config.MediumPickup then
		model = GetHashKey("pounder")
		RequestModel(model)
		while not HasModelLoaded(model) do Citizen.Wait(0) end
		AmountOfShipments = Config.MediumShipment
		Medium = true
	elseif price > Config.MediumPickup then
		model = GetHashKey("hauler")
		ModelTrailer = GetHashKey("trailers2")
		RequestModel(ModelTrailer)
		RequestModel(model)
		while not HasModelLoaded(model) do Citizen.Wait(0)end while not HasModelLoaded(ModelTrailer) do Citizen.Wait(0)end
		AmountOfShipments = Config.BigShipment
		Big = true
	end
	local Blip = AddBlipForCoord(Config.VehicleSpawnMarker.MarkerPos.x,Config.VehicleSpawnMarker.MarkerPos.y,Config.VehicleSpawnMarker.MarkerPos.z)
	SetBlipRoute(Blip,true)
	local TargetCoords = vector3(Config.VehicleSpawnMarker.MarkerPos.x,Config.VehicleSpawnMarker.MarkerPos.y,Config.VehicleSpawnMarker.MarkerPos.z)

	local PutBlipForVehicleSpawn = true
		while PutBlipForVehicleSpawn do
			Citizen.Wait(1)
			DrawMarker(27, Config.VehicleSpawnMarker.MarkerPos.x,Config.VehicleSpawnMarker.MarkerPos.y,Config.VehicleSpawnMarker.MarkerPos.z+ 0.05, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 2.0, 0.2, 11,63,105, 200, false, true, 2, false, false, false, false)
			local PlayerCoords = GetEntityCoords(PlayerPed)
			local DistanceBetweenCoords = #(PlayerCoords-TargetCoords)
			if DistanceBetweenCoords < 3 and IsPedInAnyVehicle(PlayerPed) == false then
				HelpPromt("Press E to get your vehicle")
				if IsControlJustReleased(1,Keys['E']) then
					TriggerServerEvent("PM_Shops:InsuranceMoney",Config.InsuranceMoney,false)
					exports['mythic_notify']:SendAlert('inform', 'You have paid '..Config.InsuranceMoney..'$ for the insurance of the vehicle!', 10000)
					vehicle = CreateVehicle(model, Config.VehicleSpawn.Pos.x, Config.VehicleSpawn.Pos.y, Config.VehicleSpawn.Pos.z, true, true)
					SetEntityAsMissionEntity(vehicle, true, true)
					local vehRotation = GetEntityRotation(vehicle)
					SetVehicleOnGroundProperly(vehicle)
					SetModelAsNoLongerNeeded(model)
					if ModelTrailer ~= nil then
						trailer = CreateVehicle(ModelTrailer, Config.VehicleSpawn.TrailerPos.x, Config.VehicleSpawn.TrailerPos.y, Config.VehicleSpawn.TrailerPos.z, Config.VehicleSpawn.TrailerPos.h, true, true)
						SetVehicleOnGroundProperly(trailer)
						SetModelAsNoLongerNeeded(ModelTrailer)
					end
					RemoveBlip(Blip)
					SetBlipRoute(Blip,false)
					PutBlipForVehicleSpawn = false
					StartedDelivery = true
				end
			end
		end
		Enginehealth = GetVehicleEngineHealth(vehicle)
	Citizen.Wait(1000)
	if StartedDelivery then
		local once = false
		while (GetVehiclePedIsIn(PlayerPed) == 0) do
			Citizen.Wait(1)
			DrawMarker(2, Config.VehicleSpawn.Pos.x, Config.VehicleSpawn.Pos.y, Config.VehicleSpawn.Pos.z + 6, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 2.0, 1.0, 11,63,105, 255, true, true, 2, false, false, false, false)
		end
		while (trailer ~= nil and IsVehicleAttachedToTrailer(vehicle) == false) do 
			Citizen.Wait(1)
			DrawMarker(2, Config.VehicleSpawn.TrailerPos.x, Config.VehicleSpawn.TrailerPos.y, Config.VehicleSpawn.TrailerPos.z + 6, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 2.0, 1.0, 11,63,105, 255, true, true, 2, false, false, false, false)
		end
		Citizen.Wait(2000)
		SetVehicleFuelLevel(vehicle, 100 + 0.0)
		RequiredVehicle = GetEntityModel(GetVehiclePedIsIn(PlayerPed,false))
		while AmountOfShipments ~= 0 and Enginehealth > 0 do
			Citizen.Wait(1)
			Enginehealth = GetVehicleEngineHealth(vehicle)
			if once == false and AmountOfShipments > 0 then
			DeliveryBlip = AddBlipForCoord(Config.PickupLocations[AmountOfShipments].Pos.x,Config.PickupLocations[AmountOfShipments].Pos.y,Config.PickupLocations[AmountOfShipments].Pos.z)
			SetBlipRoute(DeliveryBlip,true)
			once = true
			end
			if trailer ~= nil then
				if IsVehicleAttachedToTrailer(vehicle)==false and removed == false then
					removed = true
					RemoveBlip(DeliveryBlip)
					SetBlipRoute(DeliveryBlip,false)
					if ShowNotifOnce == false then
					ESX.ShowNotification("~r~ Reatach trailer to continue!")
					ShowNotifOnce = true
					end
				elseif IsVehicleAttachedToTrailer(vehicle) ~= false and removed == true then
					DeliveryBlip = AddBlipForCoord(Config.PickupLocations[AmountOfShipments].Pos.x,Config.PickupLocations[AmountOfShipments].Pos.y,Config.PickupLocations[AmountOfShipments].Pos.z)
					SetBlipRoute(DeliveryBlip,true)
					removed = false
					ShowNotifOnce = false
				end
				if GetEntityHealth(trailer) == 0 then
					if isDelivery then
						ESX.ShowNotification("~r~ You lost the transport.Try again")
						TriggerServerEvent("PM_Shops:MissionFailedMakeAvailable",IdDelivery)
						startPickupDelivery = false
					else
						ESX.ShowNotification("~r~ You lost the items")
					end
					Enginehealth = 0
					break
				end
			end
			DrawMarker(27, Config.PickupLocations[AmountOfShipments].Pos.x,Config.PickupLocations[AmountOfShipments].Pos.y,Config.PickupLocations[AmountOfShipments].Pos.z+ 0.05, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 2.0, 0.2, 0, 180, 0, 200, false, true, 2, false, false, false, false)
			local PlayerCoords = GetEntityCoords(PlayerPed)
			local TargetCoordsPickup = vector3(Config.PickupLocations[AmountOfShipments].Pos.x,Config.PickupLocations[AmountOfShipments].Pos.y,Config.PickupLocations[AmountOfShipments].Pos.z)
			local DistanceBetweenCoordsPickup = #(PlayerCoords - TargetCoordsPickup)
			if GetEntityModel(GetVehiclePedIsIn(PlayerPed,false)) == RequiredVehicle then
				ShowNotifOnce = false
				if DistanceBetweenCoordsPickup <= 6 then
					HelpPromt("Press E to get your items")
					if IsControlJustReleased(1,Keys['E']) then
						local PackageCoords1 = Config.PickupLocations[AmountOfShipments].Box1
						local PackageCoords2 = Config.PickupLocations[AmountOfShipments].Box2
						local PackageCoords3 = Config.PickupLocations[AmountOfShipments].Box3
						restockLocations = {
							[1] = {PackageCoords1.x, PackageCoords1.y, PackageCoords1.z}, 
							[2] = {PackageCoords2.x, PackageCoords2.y, PackageCoords2.z}, 
							[3] = {PackageCoords3.x, PackageCoords3.y, PackageCoords3.z}, 
						}
						LoadTruck()					
						AmountOfShipments = AmountOfShipments - 1
						RemoveBlip(DeliveryBlip)
						SetBlipRoute(DeliveryBlip,false)
						once = false
					end
				end
			end
			if Enginehealth <= 0 or (DoesEntityExist(vehicle)==false or IsEntityDead(PlayerPed)) then
				RemoveBlip(DeliveryBlip)
				SetBlipRoute(DeliveryBlip,false)
				TriggerServerEvent('PM_Shops:PickupFinal',successful)
				if isDelivery then
				ESX.ShowNotification("~r~ You lost the transport.Try again")
				TriggerServerEvent("PM_Shops:MissionFailedMakeAvailable",IdDelivery)
				startPickupDelivery = false
				else
					ESX.ShowNotification("~r~ You lost the items")
				end
				Enginehealth = 0
				break
			end
		end
	end
	if Enginehealth > 0 and AmountOfShipments == 0 then
		ToDelivery = AddBlipForCoord(vector3(DeliveryCoords.x,DeliveryCoords.y,DeliveryCoords.z))
		SetBlipRoute(ToDelivery,true)
		while Enginehealth > 0 and successful == false do
			Citizen.Wait(1)
			Enginehealth = GetVehicleEngineHealth(vehicle)
			DrawMarker(27, DeliveryCoords.x,DeliveryCoords.y,DeliveryCoords.z+ 0.05, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 2.0, 0.2, 11,63,105, 200, false, true, 2, false, false, false, false)
			if trailer ~= nil then
				if IsVehicleAttachedToTrailer(vehicle)==false and removed == false then
					removed = true
					RemoveBlip(ToDelivery)
					SetBlipRoute(ToDelivery,false)
					if ShowNotifOnce == false then
					ESX.ShowNotification("~r~ Reatach trailer to continue!")
					ShowNotifOnce = true
					end
				elseif IsVehicleAttachedToTrailer(vehicle) ~= false and removed == true then
					ToDelivery = AddBlipForCoord(vector3(DeliveryCoords.x,DeliveryCoords.y,DeliveryCoords.z))
					SetBlipRoute(ToDelivery,true)
					removed = false
					ShowNotifOnce = false
				end
				if GetEntityHealth(trailer) == 0 then
					if isDelivery then
						ESX.ShowNotification("~r~ You lost the transport.Try again")
						TriggerServerEvent("PM_Shops:MissionFailedMakeAvailable",IdDelivery)
						startPickupDelivery = false
					else
						ESX.ShowNotification("~r~ You lost the items")
					end
					Enginehealth = 0
					break
				end
			end
			local PlayerCoords = GetEntityCoords(PlayerPed)
			if GetEntityModel(GetVehiclePedIsIn(PlayerPed,false)) == RequiredVehicle then
				ShowNotifOnce = false
				if #(PlayerCoords-vector3(DeliveryCoords.x,DeliveryCoords.y,DeliveryCoords.z)) <= 6 then
					HelpPromt("Press E to deliver items")
					if IsControlJustReleased(1,Keys['E']) then
						local nrBoxes = 0
						if Small then
							nrBoxes = Config.SmallPickupUnload
						elseif Medium then
							nrBoxes = Config.MediumPickupUnload
						elseif Big then
							nrBoxes = Config.BigPickupUnload
						end
						UnloadTruck(nrBoxes,ShopIdPickup)
						RemoveBlip(ToDelivery)
						SetBlipRoute(ToDelivery,false)
						successful = true
						MoveVehicleBack = true
						TriggerServerEvent('PM_Shops:PickupFinal',successful,items,ShopIdPickup)
						if isDelivery then
							local PriceFinal = DriverCut + price
							TriggerServerEvent("PM_Shops:SaveHistory",IdDelivery,tonumber(PriceFinal),items)
							Citizen.Wait(2000)
							TriggerServerEvent("PM_Shops:PayDriver",DriverCut,IdDelivery)
							exports['mythic_notify']:SendAlert('inform', 'You got '..DriverCut..'$ for this job!', 10000)
						end
						ESX.ShowNotification("~g~ You succesfully delivered the items")
					end
				end
			elseif DoesEntityExist(vehicle) and ShowNotifOnce == false then
				ESX.ShowNotification("~r~ Get back in the job vehicle!")
				ShowNotifOnce = true
			end
			if (Enginehealth <= 0 or DoesEntityExist(vehicle) == false or IsEntityDead(PlayerPed)) and successful == false then
				RemoveBlip(ToDelivery)
				SetBlipRoute(ToDelivery,false)
				TriggerServerEvent('PM_Shops:PickupFinal',successful)
				if isDelivery then
				ESX.ShowNotification("~r~ You lost the transport.Try again")
				TriggerServerEvent("PM_Shops:MissionFailedMakeAvailable",IdDelivery)
				startPickupDelivery = false
				else
				ESX.ShowNotification("~r~ You lost the items")
				end
				Enginehealth = 0
				break
			end
		end
	end
	if MoveVehicleBack then
		local TargetCoords2 = false
		local DistanceBetweenCoordsFinish = nil
		local Parked = false
		local BlipEnd = AddBlipForCoord(vector3(Config.VehicleSpawnMarker.MarkerPos.x,Config.VehicleSpawnMarker.MarkerPos.y,Config.VehicleSpawnMarker.MarkerPos.z))
		SetBlipRoute(BlipEnd,true)
		while Enginehealth > 0 do
			Citizen.Wait(1)
			local TargetCoords = vector3(Config.VehicleSpawn.Pos.x,Config.VehicleSpawn.Pos.y,Config.VehicleSpawn.Pos.z)
			if IsVehicleAttachedToTrailer(vehicle) and trailer ~= nil then
				while Enginehealth > 0 do
					Citizen.Wait(1)
					DrawMarker(27, Config.VehicleSpawn.TrailerPos.x, Config.VehicleSpawn.TrailerPos.y, Config.VehicleSpawn.TrailerPos.z -0.95, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 2.0, 0.2, 11,63,105, 200, false, true, 2, false, false, false, false)
					if GetEntityHeading(GetPlayerPed(-1)) < 300 and GetEntityHeading(GetPlayerPed(-1)) > 240 and #(GetEntityCoords(GetPlayerPed(-1)) - vector3(Config.VehicleSpawn.TrailerPos.x,Config.VehicleSpawn.TrailerPos.y,Config.VehicleSpawn.TrailerPos.z)) < 6 then
						HelpPromt("Hold H to detach trailer!")
						if IsControlJustPressed(1,Keys['H']) then
							Citizen.Wait(2000)
							break;
						end
					end
					if (Enginehealth <= 0 or DoesEntityExist(vehicle) == false or IsEntityDead(PlayerPed)) then
						RemoveBlip(BlipEnd)
						SetBlipRoute(BlipEnd,false)
						ESX.ShowNotification("~r~ You lost the insurance money")
						Enginehealth = 0
						break
					end
					if IsVehicleAttachedToTrailer(vehicle)==false and removed == false then
						removed = true
						RemoveBlip(BlipEnd)
						SetBlipRoute(BlipEnd,false)
						if ShowNotifOnce == false then
						ESX.ShowNotification("~r~ Reatach trailer to continue!")
						ShowNotifOnce = true
						end
					elseif IsVehicleAttachedToTrailer(vehicle) ~= false and removed == true then
						BlipEnd = AddBlipForCoord(vector3(Config.VehicleSpawnMarker.MarkerPos.x,Config.VehicleSpawnMarker.MarkerPos.y,Config.VehicleSpawnMarker.MarkerPos.z))
						SetBlipRoute(BlipEnd,true)
						removed = false
						ShowNotifOnce = false
					end
					if GetEntityHealth(trailer) == 0 then
						ESX.ShowNotification("~r~ You lost the insurance money")
						Enginehealth = 0
						break
					end
				end
			end
			if Parked == false then
			DrawMarker(27, Config.VehicleSpawn.Pos.x,Config.VehicleSpawn.Pos.y,Config.VehicleSpawn.Pos.z -0.95, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 2.0, 0.2, 11,63,105, 200, false, true, 2, false, false, false, false)
			end
			if #(GetEntityCoords(GetPlayerPed(-1)) - vector3(Config.VehicleSpawn.Pos.x,Config.VehicleSpawn.Pos.y,Config.VehicleSpawn.Pos.z)) < 6 and Parked == false then
				HelpPromt("Press E to park vehicle!")
				if IsControlJustPressed(1,Keys['E']) then
					TaskLeaveVehicle(PlayerPed,vehicle,1)
					FreezeEntityPosition(vehicle,true)
					FreezeEntityPosition(trailer,true)
					SetVehicleDoorsLockedForAllPlayers(vehicle,true)
					HelpPromt("Please go to the laptop to get your insurance money!")
					Parked = true
				end
			end
			if Parked then
			TargetCoords2 = vector3(Config.VehicleSpawnMarker.MarkerPos.x,Config.VehicleSpawnMarker.MarkerPos.y,Config.VehicleSpawnMarker.MarkerPos.z)
			DrawMarker(27, Config.VehicleSpawnMarker.MarkerPos.x,Config.VehicleSpawnMarker.MarkerPos.y,Config.VehicleSpawnMarker.MarkerPos.z+ 0.05, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 2.0, 0.2, 11,63,105, 200, false, true, 2, false, false, false, false)
			DistanceBetweenCoordsFinish = #(GetEntityCoords(GetPlayerPed(-1)) - vector3(Config.VehicleSpawnMarker.MarkerPos.x,Config.VehicleSpawnMarker.MarkerPos.y,Config.VehicleSpawnMarker.MarkerPos.z))
			end
			if(Parked and DistanceBetweenCoordsFinish < 2) then
				HelpPromt("Press E to get your money back!")
				if(IsControlJustPressed(1,Keys['E'])) then
					DoScreenFadeOut(1000)
					Citizen.Wait(1500)
					DeleteVehicle(vehicle)
					DeleteVehicle(trailer)
					DoScreenFadeIn(1500)
					TriggerServerEvent("PM_Shops:InsuranceMoney",Config.InsuranceMoney,true)
					exports['mythic_notify']:SendAlert('inform', 'You got your insurance money back.', 10000)
					MoveVehicleBack = false
					Parked = false
					Enginehealth = 0
					RemoveBlip(BlipEnd)
					SetBlipRoute(BlipEnd,false)
					break;
				end
			end
			if (Enginehealth <= 0 or DoesEntityExist(vehicle) == false or IsEntityDead(PlayerPed)) then
				RemoveBlip(BlipEnd)
				SetBlipRoute(BlipEnd,false)
				ESX.ShowNotification("~r~ You lost the insurance money")
				Enginehealth = 0
				break
			end
		end
	end
end)

function HelpPromt(text)
	Citizen.CreateThread(function()
		SetTextComponentFormat("STRING")
		AddTextComponentString(text)
		DisplayHelpTextFromStringLabel(0, state, 0, -1)

	end)
end

Citizen.CreateThread(function ()
	while true do
		local delay = 1000
  
	  local coords = GetEntityCoords(GetPlayerPed(-1))
  
		  for k,v in pairs(Config.Zones) do
			  if(27 ~= -1 and #(coords - vector3(v.Pos.x, v.Pos.y, v.Pos.z)) < 8.0  and CheckCarrying == false) then
				   delay = 0
				   if v.Pos.red then
					DrawMarker(27, v.Pos.x, v.Pos.y, v.Pos.z + 0.05, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.2, 180, 0, 0, 200, false, true, 2, false, false, false, false)
					DrawMarker(20, v.Pos.x, v.Pos.y, v.Pos.z + 1.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 180, 0, 0, 200, false, true, 2, false, false, false, false)		
				else
					DrawMarker(27, v.Pos.x, v.Pos.y, v.Pos.z + 0.05, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.2, 0, 180, 0, 200, false, true, 2, false, false, false, false)
					DrawMarker(20, v.Pos.x, v.Pos.y, v.Pos.z + 1.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 0, 180, 0, 200, false, true, 2, false, false, false, false)
				end
			  end
		  end
		  Citizen.Wait(delay)
	  end
  end)


Citizen.CreateThread(function ()
  while true do
	Citizen.Wait(1000)

	local coords      = GetEntityCoords(GetPlayerPed(-1))
	local isInMarker  = false
	local currentZone = nil
	if CheckCarrying == false then
		for k,v in pairs(Config.Zones) do
	   	if(#(coords-vector3(v.Pos.x, v.Pos.y, v.Pos.z)) < 1.2) then
			isInMarker  = true
			currentZone = v.Pos.number
	  	end
		end

		if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
	  	HasAlreadyEnteredMarker = true
	  	LastZone                = currentZone
	  	TriggerEvent('PM_Shop:hasEnteredMarker', currentZone)
		end

		if not isInMarker and HasAlreadyEnteredMarker then
	 	HasAlreadyEnteredMarker = false
	  	TriggerEvent('PM_Shop:hasExitedMarker', LastZone)
		end
  	  	end
	end
end)

RegisterNetEvent('PM_Shops:setBlip')
AddEventHandler('PM_Shops:setBlip', function()

  	ESX.TriggerServerCallback('PM_Shop:getOwnedBlips', function(blips)

		if blips ~= nil then
			createBlip(blips)
	  	end
   	end)
end)

RegisterNetEvent('PM_Shops:removeBlip')
AddEventHandler('PM_Shops:removeBlip', function()

	for i=1, #displayedBlips do
    	RemoveBlip(displayedBlips[i])
	end

end)

AddEventHandler('playerSpawned', function(spawn)
	Citizen.Wait(500)

	ESX.TriggerServerCallback('PM_Shop:getOwnedBlips', function(blips)

		if blips ~= nil then
			createBlip(blips)
		end
	end)
end)



Citizen.CreateThread(function()
	Citizen.Wait(500)

	ESX.TriggerServerCallback('PM_Shop:getOwnedBlips', function(blips)

		if blips ~= nil then
			createBlip(blips)
		end
	end)
end)

Citizen.CreateThread(function()
	Citizen.Wait(500)
		local blip = AddBlipForCoord(Config.Zones.ShopCenter.Pos.x,Config.Zones.ShopCenter.Pos.y,Config.Zones.ShopCenter.Pos.z)

		SetBlipSprite (blip, 606)
		SetBlipDisplay(blip, 4)
		SetBlipScale  (blip, 0.8)
		SetBlipColour (blip, 5)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('Buy Shops')
		EndTextCommandSetBlipName(blip)
end)

Citizen.CreateThread(function()
	Citizen.Wait(500)
		local blip = AddBlipForCoord(Config.Zones.DeliveryMission.Pos.x,Config.Zones.DeliveryMission.Pos.y,Config.Zones.DeliveryMission.Pos.z)

		SetBlipSprite (blip, 616)
		SetBlipDisplay(blip, 4)
		SetBlipScale  (blip, 0.8)
		SetBlipColour (blip, 5)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('Shop Delivery Missions')
		EndTextCommandSetBlipName(blip)
end)

function createBlip(blips)
	for i=1, #blips, 1 do
  		for k,v in pairs(Config.Zones) do
			if v.Pos.number == blips[i].ShopNumber then
				local blip = AddBlipForCoord(vector3(v.Pos.x, v.Pos.y, v.Pos.z))
					SetBlipSprite (blip, 52)
					SetBlipDisplay(blip, 4)
					SetBlipScale  (blip, 0.8)
					SetBlipColour (blip, 2)
					SetBlipAsShortRange(blip, true)
					BeginTextCommandSetBlipName("STRING")
					AddTextComponentString(blips[i].ShopName)
                    EndTextCommandSetBlipName(blip)
					table.insert(displayedBlips, blip)
			end
 		end
	end
end


function createForSaleBlips()
	if showblip then

		IDBLIPS = Config.createForSaleBlips

		for i=1, #IDBLIPS, 1 do

			local blip2 = AddBlipForCoord(vector3(IDBLIPS[i].x, IDBLIPS[i].y, IDBLIPS[i].z))
				
				SetBlipSprite (blip2, 525)
				SetBlipDisplay(blip2, 4)
				SetBlipScale  (blip2, 0.9)
				SetBlipColour (blip2, 46)
				SetBlipAsShortRange(blip2, true)
				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString('ID: ' .. IDBLIPS[i].n)
				EndTextCommandSetBlipName(blip2)
				table.insert(AllBlips, blip2)
		end

		else
			for i=1, #AllBlips, 1 do
				RemoveBlip(AllBlips[i])
			end
		ESX.UI.Menu.CloseAll()
	end
end

--ROBBERY
local Id = nil
local Name = nil
local res = false

function Robbery(id)

        ESX.TriggerServerCallback('PM_Shop-robbery:getUpdates', function(result)
		ESX.TriggerServerCallback('PM_Shop-robbery:getOnlinePolices', function(results)
			if result.cb ~= nil then
				if results >= Config.RequiredPolices then
					if Config.UseGCPhone then
						local playerPed = PlayerPedId()
						PedPosition		= GetEntityCoords(playerPed)
						local PlayerCoords = { x = PedPosition.x, y = PedPosition.y, z = PedPosition.z }
						TriggerServerEvent('esx_addons_gcphone:startCall', 'police', "Shop robbery at the " .. result.name .. '\'s shop', PlayerCoords, {
							PlayerCoords = { x = PedPosition.x, y = PedPosition.y, z = PedPosition.z },
						})
					else
						TriggerServerEvent('esx_phone:send', "police", "Shop robbery at the " .. result.name .. '\'s shop', true, coords)
					end
						TriggerServerEvent("NotifyPolice",result.name)
						TriggerServerEvent('PM_Shops-robbery:NotifyOwner', "~r~Your store ~b~(" .. result.name .. ')~r~ is under robbery', id)
						ESX.ShowNotification("~r~Alarm triggered Police and are on the way Hurry up!")
						OnRobbery = true
						Name = result.name
						Msg = _U("rob_controls")
						Id = id
						res = exports["pd-safe"]:createSafe({math.random(0,99),math.random(0,99),math.random(0,99)})
						StartedRobbery()
                else
					ESX.ShowNotification("~r~There is not enough polices online " .. results .. '/' .. Config.RequiredPolices)
				end
			else
				ESX.ShowNotification("~r~This shop has already bein robbed, please wait " ..  math.floor((Config.TimeBetweenRobberies - result.time)  / 60) .. ' minutes')
			end
		end)
	end, id)
end
function StartedRobbery()
while true do
     Citizen.Wait(0)
		local playerpos = GetEntityCoords(GetPlayerPed(-1))
			if OnRobbery then
				TriggerEvent("mt:missiontext", "Confirm ~g~PIN: ~w~ W~n~Cancel ~r~Robbery: ~w~ S~n~Rotate: ~w~ A ~y~OR ~w~D ", 500)
			end
			if OnRobbery and res then
			OnRobbery = false
			res = false
			TriggerServerEvent('PM_Shops-robbery:GetReward', Id)
			TriggerServerEvent("PM_Shops-robbery:NotifyOwner", '~r~The robbery on your shop ~b~(' .. Name ..')~r~ was unfortunately successful!', Id)
			ESX.ShowNotification(_U("robbery_successful"))
			TriggerServerEvent('PM_Shops-robbery:UpdateCanRob', Id)
			Msg = _U('press_to_rob')
			break;
		elseif (IsControlJustReleased(1,Keys["S"]) and OnRobbery == true and res == false) then
			OnRobbery = false
			res = false
			ESX.ShowNotification(_U("robbery_cancel"))
			Msg = _U('press_to_rob')	
			break;
		end
	end
end

RegisterNetEvent("mt:missiontext") -- credits: https://github.com/schneehaze/fivem_missiontext/blob/master/MissionText/missiontext.lua
AddEventHandler("mt:missiontext", function(text, time)
		ClearPrints()
		SetTextEntry_2("STRING")
		AddTextComponentString(text)
		DrawSubtitleTimed(time, 1)
end)

function LoadTruck()
	if trailer ~= nil then
		OpenDoors(trailer)
	else
		OpenDoors(vehicle)
	end
	local restockPackages = Config.BoxesPerStop
	local LoadingTruck = true
	local carryingPackage = {status = false, id = nil}
	for id,v in pairs(restockLocations) do 
	 restockObject[id] = CreateObject(GetHashKey("prop_cardbordbox_02a"), v[1],v[2],v[3]-0.95, true, true, true)
	 restockObjectLocation[id] = v
	 PlaceObjectOnGroundProperly(restockObject[id])
	end
	while LoadingTruck do 
		Citizen.Wait(1)
	 for id,v in pairs(restockObjectLocation) do
	  DrawMarker(2, v[1],v[2],v[3], 0,0,0,0,0,0,0.5,0.5,0.5,255,255,0,165,0,0,0,0)
	  if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),v[1],v[2],v[3],true) < 1.3 and carryingPackage.status == false then
	   HelpPromt('~w~Press ~r~[E]~w~ To Take Package')
	   if IsControlJustPressed(0, 38) then 
		AttachEntityToEntity(restockObject[id], PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 28422), 0.0, -0.03, 0.0, 5.0, 0.0, 0.0, 1, 1, 0, 1, 0, 1)
		LoadAnim("anim@heists@box_carry@")
		TaskPlayAnim(PlayerPedId(), "anim@heists@box_carry@", "idle", 8.0, 8.0, -1, 50, 0, false, false, false)
		carryingPackage.status = true
		carryingPackage.id = id
	   end
	  end
	 end
	 if carryingPackage.status then
		local bootPos = nil
		local bootPos2 = nil
		if trailer ~= nil then 
	  	bootPos = GetWorldPositionOfEntityBone(trailer, GetEntityBoneIndexByName(trailer, "door_dside_r"))
		bootPos2 = GetWorldPositionOfEntityBone(trailer, GetEntityBoneIndexByName(trailer, "door_pside_r"))
		else
		bootPos = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, "door_dside_r"))
		bootPos2 = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, "door_pside_r"))
		end
	  local playerCoords = GetEntityCoords(GetPlayerPed(-1))
	  local TargetPos1 = #(playerCoords - vector3(bootPos.x,bootPos.y,bootPos.z))
	  local TargetPos2 = #(playerCoords - vector3(bootPos2.x,bootPos2.y,bootPos2.z))
	  if TargetPos1 < 2.6 or TargetPos2 < 2.6 then 
		HelpPromt('~w~Press ~r~[E]~w~ To Put Package Into Van')
	   if IsControlJustPressed(0, 38) then 
		DeleteObject(restockObject[carryingPackage.id])
		ClearPedTasks(GetPlayerPed(-1))
		carryingPackage.status = false
		restockObjectLocation[carryingPackage.id] = {}
		restockObject[carryingPackage.id] = nil
		restockPackages = restockPackages-1
		if restockPackages == 0 then 
		 LoadingTruck = false
		 exports['mythic_notify']:SendAlert('inform', 'Get back in vehicle to continue!', 10000)
		 if trailer ~= nil then
			CloseDoors(trailer)
		 else
			CloseDoors(vehicle)
		 end
		end
	   end
	  end
	 end
	end
	return 0
end


function UnloadTruck(Boxes,ShopIdPickup)
	exports['mythic_notify']:SendAlert('inform', 'Take the items out of the back of the vehicle and into the shop!', 10000)
	local getPosOfItems = nil
	local Object = nil
	if trailer ~= nil then
		OpenDoors(trailer)
		getPosOfItems = GetWorldPositionOfEntityBone(trailer, GetEntityBoneIndexByName(trailer, "door_dside_r"))
	else
		getPosOfItems = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, "door_dside_r"))
		OpenDoors(vehicle)
	end
	local restockPackages = Boxes
	local UnloadingTruck = true
	local carryingPackage = {status = false}
	while UnloadingTruck do
		Citizen.Wait(1)
	  if #(GetEntityCoords(GetPlayerPed(-1)) - vector3(getPosOfItems.x,getPosOfItems.y,getPosOfItems.z)) < 4 and carryingPackage.status == false then
		HelpPromt("~w~Press ~r~[E]~w~ to take items from truck.")
		local ModelHash = GetHashKey("prop_sacktruck_02b")
		WaitModelLoad(ModelHash)
	   if IsControlJustPressed(0, 38) then
		CheckCarrying = true
		LoadAnim("anim@heists@box_carry@")
		TaskPlayAnim(PlayerPedId(), "anim@heists@box_carry@", "idle", 8.0, 8.0, -1, 50, 0, false, false, false)
		local PlayerPed = GetPlayerPed(-1)
		local PlayerPos = GetOffsetFromEntityInWorldCoords(PlayerPed, 0.0, 0.0, -5.0)
		Object = CreateObject(ModelHash, PlayerPos.x, PlayerPos.y, PlayerPos.z, true, true, true)
		AttachEntityToEntity(Object, PlayerPed, GetEntityBoneIndexByName(PlayerPed, "SKEL_Pelvis"), -0.075, 0.90, -0.86, -20.0, -0.5, 181.0, true, false, false, true, 1, true)
		carryingPackage.status = true
	  end
	 end
	 if carryingPackage.status then
	  local bootPos = vector3(Config.Zones['Shop' .. ShopIdPickup].Pos.x,Config.Zones['Shop' .. ShopIdPickup].Pos.y, Config.Zones['Shop' .. ShopIdPickup].Pos.z)
	  DrawMarker(2, bootPos.x,bootPos.y,bootPos.z+0.95, 0,0,0,0,0,0,0.5,0.5,0.5,11,63,105,165,0,0,0,0)
	  local playerCoords = GetEntityCoords(GetPlayerPed(-1))
	  local TargetPos = #(playerCoords - vector3(bootPos.x,bootPos.y,bootPos.z))
	  if TargetPos < 2.6 then
		HelpPromt('~w~Press ~r~[E]~w~ To Put Items in Storage')
	   if IsControlJustPressed(0, 38) then 
		CheckCarrying = false
		DetachEntity(Object)
		DeleteEntity(Object)
		ClearPedTasks(GetPlayerPed(-1))
		carryingPackage.status = false
		restockPackages = restockPackages-1
		exports['mythic_notify']:SendAlert('inform', restockPackages.."/".. Boxes .." packages left!", 3000)
		if restockPackages == 0 then
		 UnloadingTruck = false
		 exports['mythic_notify']:SendAlert('inform', 'Get the vehicle back to the deposit.', 10000)
		 if trailer ~= nil then
			CloseDoors(trailer)
		 else
			CloseDoors(vehicle)
		 end
		end
	   end
	  end
	 end
	end
	return 0
end

RegisterCommand("delivery",function()
	startAnim()
	ESX.TriggerServerCallback("PM_Shop:GetMissionData",function(result)
		SetNuiFocus(true,true)
		SendNUIMessage({
			type="delivery",
			result = result
		})
		sent = true
	end)
end)

function startAnim()
	Citizen.CreateThread(function()
	  RequestAnimDict("amb@world_human_seat_wall_tablet@female@base")
	  while not HasAnimDictLoaded("amb@world_human_seat_wall_tablet@female@base") do
	    Citizen.Wait(0)
	  end
		attachObject()
		TaskPlayAnim(GetPlayerPed(-1), "amb@world_human_seat_wall_tablet@female@base", "base" ,8.0, -8.0, -1, 50, 0, false, false, false)
	end)
end

function attachObject()
	tab = CreateObject(GetHashKey("prop_cs_tablet"), 0, 0, 0, true, true, true)
	AttachEntityToEntity(tab, GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 57005), 0.17, 0.10, -0.13, 20.0, 180.0, 180.0, true, true, false, true, 1, true)
end

function stopAnim()
	StopAnimTask(GetPlayerPed(-1), "amb@world_human_seat_wall_tablet@female@base", "base" ,8.0, -8.0, -1, 50, 0, false, false, false)
	DeleteEntity(tab)
end

function OpenDoors(type)
	SetVehicleDoorOpen(type,2,false, false)
	SetVehicleDoorOpen(type,3,false, false)
end

function CloseDoors(type)
	SetVehicleDoorShut(type,2,false, false)
	SetVehicleDoorShut(type,3,false, false)
end

function WaitModelLoad(name)
	RequestModel(name)
	while not HasModelLoaded(name) do
		Wait(0)
	end
end

function LoadAnim(animDict)
	RequestAnimDict(animDict)
  
	while not HasAnimDictLoaded(animDict) do
	  Citizen.Wait(10)
	end
  end

function DisableControls()
	DisableControlAction(2, 30, true)
	DisableControlAction(2, 31, true)
	DisableControlAction(2, 32, true)
	DisableControlAction(2, 33, true)
	DisableControlAction(2, 34, true)
	DisableControlAction(2, 35, true)

	DisableControlAction(0, 25,  true)
	DisableControlAction(0, 24,  true)
	DisableControlAction(0, 1,   true)
	DisableControlAction(0, 2,   true)
	DisableControlAction(0, 106, true)
	DisableControlAction(0, 142, true)
	DisableControlAction(0, 30,  true)
	DisableControlAction(0, 31,  true)
	DisableControlAction(0, 21,  true)
	DisableControlAction(0, 47,  true)
	DisableControlAction(0, 58,  true)
	DisableControlAction(0, 263, true)
	DisableControlAction(0, 264, true)
	DisableControlAction(0, 257, true)
	DisableControlAction(0, 140, true)
	DisableControlAction(0, 141, true)
	DisableControlAction(0, 143, true)
	DisableControlAction(0, 75,  true)

	DisableControlAction(27, 75, true)
end