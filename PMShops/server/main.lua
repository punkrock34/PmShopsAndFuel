ESX = nil
local FuelExportedTotal = 0
local MissionData = {}
local self = MissionData
local table = {}
local DISCORD_WEBHOOK = ""
local PickupStarted = false
local DroppedIdDelivery = nil
local DroppedIsDelivery = nil
local MissionType = nil

-- ESX
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local number = {}

--GET INVENTORY ITEM
ESX.RegisterServerCallback('PM_Shop:getInventory', function(source, cb)
  local xPlayer = ESX.GetPlayerFromId(source)
  local items   = xPlayer.inventory

  cb({items = items})

end)

RegisterServerEvent("PM_Shops:CancelOrder")
AddEventHandler("PM_Shops:CancelOrder",function(ID)
    local src = source
    local identifier = ESX.GetPlayerFromId(src).identifier
    local xPlayer = ESX.GetPlayerFromId(src)
    MySQL.Async.fetchAll("SELECT ShopId,DriverCut,Value FROM deliverymissionsitems WHERE ID = @ID",{['@ID']=ID},function(result)
        MySQL.Async.fetchAll("SELECT money FROM owned_shops WHERE ShopNumber = @number",{['@number']=result[1].ShopId},function(result2)
            MySQL.Async.execute("UPDATE owned_shops SET money = @money WHERE ShopNumber=@number",{['number']=result[1].ShopId,['@money']=result2[1].money+(result[1].DriverCut+result[1].Value)})
            MySQL.Async.execute("DELETE FROM deliverymissionsitems WHERE ID = @ID",{['@ID']=ID})
            TriggerClientEvent('esx:showNotification', xPlayer.source, 'You cancelled the order and got refunded the total amount: ' .. result[1].DriverCut+result[1].Value .. '$ ')
        end)
    end)
end)

RegisterServerEvent("SaveData")
AddEventHandler("SaveData",function(isDelivery,IdDelivery)
DroppedIdDelivery = IdDelivery
DroppedIsDelivery = isDelivery
MissionType = type
end)

AddEventHandler('playerDropped', function (reason)
    if DroppedIsDelivery then
        TriggerEvent("PM_Shops:MissionFailedMakeAvailable",DroppedIdDelivery)
    end
    DroppedIsDelivery = nil
    DroppedIdDelivery = nil
    print('Player ' .. GetPlayerName(source) .. ' dropped (Reason: ' .. reason .. ')')
end)
  
-- BUYING FUEL
RegisterServerEvent("PM_Shops:PayFuel")
AddEventHandler("PM_Shops:PayFuel", function(id,price)
    if id > 100 then
        id = id-100
    end
    MySQL.Async.fetchAll(
        'SELECT * FROM owned_shops WHERE ShopNumber = @Number',
        {
            ['@Number'] = id,
        }, function(result2)

                MySQL.Async.execute("UPDATE owned_shops SET money = @money WHERE ShopNumber = @Number",
                {
                    ['@money']      = (result2[1].money + price),
                    ['@Number']     = id,
                })
    end)
end)

-- BUYING PRODUCT
RegisterServerEvent('PM_Shops:Buy')
AddEventHandler('PM_Shops:Buy', function(id, Item, ItemCount)
  local src = source
  local identifier = ESX.GetPlayerFromId(src).identifier
  local xPlayer = ESX.GetPlayerFromId(src)

        local ItemCount = tonumber(ItemCount)

        MySQL.Async.fetchAll(
        'SELECT * FROM shops WHERE ShopNumber = @Number AND item = @item',
        {
            ['@Number'] = id,
            ['@item'] = Item,
        }, function(result)

    
        MySQL.Async.fetchAll(
        'SELECT * FROM owned_shops WHERE ShopNumber = @Number',
        {
            ['@Number'] = id,
        }, function(result2)

            if xPlayer.getMoney() < ItemCount * result[1].price then
                TriggerClientEvent('esx:showNotification', src, '~r~You don\'t have enough money.')
            elseif ItemCount <= 0 then
                TriggerClientEvent('esx:showNotification', src, '~r~invalid quantity.')
            else
                xPlayer.removeMoney(ItemCount * result[1].price)
                TriggerClientEvent('esx:showNotification', xPlayer.source, '~g~You bought ' .. ItemCount .. 'x ' .. result[1].label .. ' for $' .. ItemCount * result[1].price)
                xPlayer.addInventoryItem(result[1].item, ItemCount)

                MySQL.Async.execute("UPDATE owned_shops SET money = @money WHERE ShopNumber = @Number",
                {
                    ['@money']      = result2[1].money + (result[1].price * ItemCount),
                    ['@Number']     = id,
                })
    

                if result[1].count ~= ItemCount then
                    MySQL.Async.execute("UPDATE shops SET count = @count WHERE item = @name AND ShopNumber = @Number",
                    {
                        ['@name'] = Item,
                        ['@Number'] = id,
                        ['@count'] = result[1].count - ItemCount
                    })
                elseif result[1].count == ItemCount then
                    MySQL.Async.fetchAll("DELETE FROM shops WHERE item = @name AND ShopNumber = @Number",
                    {
                        ['@Number'] = id,
                        ['@name'] = result[1].item
                    })
                end
            end
        end)
    end)
end)

ESX.RegisterServerCallback("PM_Shop:GetGasStationNextToShop",function(source, cb ,number)
    MySQL.Async.fetchAll("SELECT quantity,price FROM fuel_stations WHERE ShopNumber = @number",{['@number'] = number},function(result)
        if(result[1] ~= nil) then
            cb(result)
        else
            cb(nil)
        end
    end)
end)

--CALLBACKS
ESX.RegisterServerCallback('PM_Shop:getShopList', function(source, cb)
  local identifier = ESX.GetPlayerFromId(source).identifier
  local xPlayer = ESX.GetPlayerFromId(source)

        MySQL.Async.fetchAll(
        'SELECT * FROM owned_shops WHERE identifier = @identifier',
        {
            ['@identifier'] = '0',
        }, function(result)

      cb(result)
    end)
end)


ESX.RegisterServerCallback('PM_Shop:getOwnedBlips', function(source, cb)

        MySQL.Async.fetchAll(
        'SELECT * FROM owned_shops WHERE NOT identifier = @identifier',
        {
            ['@identifier'] = '0',
        }, function(results)
        cb(results)
    end)
end)


ESX.RegisterServerCallback('PM_Shop:GetFuelOrdered', function(source, cb, id)
    local identifier = ESX.GetPlayerFromId(source).identifier
  
          MySQL.Async.fetchAll(
          'SELECT * FROM exportedfuel WHERE id = @id AND identifier = @identifier',
          {
              ['@id'] = id,
              ['@identifier'] = identifier,
          }, function(result)
          cb(result)
      end)
  end)
ESX.RegisterServerCallback("PM_Shop:GetMissionData",function(source,cb)
    local src = source
    local identifier = ESX.GetPlayerFromId(src).identifier
    MySQL.Async.fetchAll(
        'SELECT * FROM deliverymissionsitems WHERE active = @active AND Buyer != @buyer',{['@active'] = 0, ['@buyer']=identifier}, function(result)
        for i=1,#result,1 do
            table[i] = {}
            table[i].id = result[i].ID
            table[i].name = result[i].ShopName
            table[i].DriverCut = result[i].DriverCut
            table[i].Value = result[i].Value
            table[i].active = result[i].active
            table[i].ShopId = result[i].ShopId
            table[i].Buyer = result[i].Buyer
        end
        cb(table)
        table = {}
    end)
end)

ESX.RegisterServerCallback('PM_Shops:DeliveryCoordsFuel',function(source,cb,number)
    MySQL.Async.fetchAll("SELECT delivery_coords FROM owned_shops WHERE ShopNumber = @number",{['@number']=number},function(result)
        cb(result)
    end)
end)

ESX.RegisterServerCallback('PM_Shop:getOwnedShop', function(source, cb, id)
local src = source
local identifier = ESX.GetPlayerFromId(src).identifier

        MySQL.Async.fetchAll(
        'SELECT * FROM owned_shops WHERE ShopNumber = @ShopNumber AND identifier = @identifier',
        {
            ['@ShopNumber'] = id,
            ['@identifier'] = identifier,
        }, function(result)

        if result[1] ~= nil then
            cb(result)
        else
            cb(nil)
        end
    end)
end)

ESX.RegisterServerCallback('PM_Shop:getShopItems', function(source, cb, number)
  local identifier = ESX.GetPlayerFromId(source).identifier
  
        MySQL.Async.fetchAll('SELECT * FROM shops WHERE ShopNumber = @ShopNumber',
        {
            ['@ShopNumber'] = number
        }, function(result)
        cb(result)
    end)
end)

RegisterServerEvent('PM_Shops:StoreOrderedFuel')
AddEventHandler('PM_Shops:StoreOrderedFuel', function(id)
    local _source = source
    local identifier = ESX.GetPlayerFromId(_source).identifier

    MySQL.Async.fetchAll(
    'SELECT * FROM exportedfuel WHERE id = @id AND identifier = @identifier',
    {
        ['@id'] = id,
        ['@identifier'] = identifier
    }, function(result)

        for i=1, #result, 1 do
            FuelExportedTotal = FuelExportedTotal + result[i].liters
            TriggerEvent("PMFuel:refillPump",FuelId,FuelExportedTotal)
            MySQL.Async.fetchAll('DELETE FROM exportedfuel WHERE id = @id AND identifier = @identifier',{['@id'] = id,['@identifier'] = identifier,})
        end
    end)
end)

RegisterServerEvent('PM_Shops-robbery:UpdateCanRob')
AddEventHandler('PM_Shops-robbery:UpdateCanRob', function(id)
    MySQL.Async.fetchAll("UPDATE owned_shops SET LastRobbery = @LastRobbery WHERE ShopNumber = @ShopNumber",{['@ShopNumber'] = id,['@LastRobbery']    = os.time(),})
end)


RegisterServerEvent('PM_Shop:ExportedFuel')
AddEventHandler('PM_Shop:ExportedFuel', function(id, price, liters)
  local _source = source
  local identifier = ESX.GetPlayerFromId(_source).identifier

    MySQL.Async.fetchAll('SELECT money FROM owned_shops WHERE ShopNumber = @ShopNumber AND identifier = @identifier',{['@ShopNumber'] = id,['@identifier'] = identifier,}, function(result)

        if result[1].money >= price then

            MySQL.Async.execute('INSERT INTO exportedfuel (id, label, identifier, price, liters, time) VALUES (@id, @label, @identifier, @price, @liters, @time)',{['@id']       = id,['@identifier'] = identifier,['@price']      = price,['@label']      ="Fuel",['@liters']      = liters,['@time']       = os.time()})
            MySQL.Async.fetchAll("UPDATE owned_shops SET money = @money WHERE ShopNumber = @ShopNumber",{['@ShopNumber'] = id,['@money']    = result[1].money - price,})  
        else
            TriggerClientEvent('esx:showNotification', _source, '~r~You don\'t have enough money in your shop.')
        end
    end)
end)

RegisterServerEvent('PM_Shops:BuyShop')
AddEventHandler('PM_Shops:BuyShop', function(name, price, number, hasbought)
local _source = source
local xPlayer = ESX.GetPlayerFromId(source)
local identifier = ESX.GetPlayerFromId(source).identifier
local PlayerName = GetPlayerName(source)

    MySQL.Async.fetchAll(
    'SELECT identifier FROM owned_shops WHERE ShopNumber = @ShopNumber',
    {
      ['@ShopNumber'] = number,
    }, function(result)

    if result[1].identifier == '0' then

        if xPlayer.getMoney() >= price then
            MySQL.Async.fetchAll("UPDATE owned_shops SET identifier = @identifier, ShopName = @ShopName WHERE ShopNumber = @ShopNumber",{['@identifier']  = identifier,['@ShopNumber']     = number,['@ShopName']     = name},function(result)
            xPlayer.removeMoney(price)
        end)
            TriggerClientEvent('PM_Shops:removeBlip', -1)
            TriggerClientEvent('PM_Shops:setBlip', -1)
            TriggerClientEvent('esx:showNotification', _source, '~gYou bought a shop for $' ..  price)


            local connect = {
                    {
                         ["color"] = "255",
                         ["title"] = "Business Buying",
                         ["description"] = "Player: "..PlayerName.." Bought shop number "..number.." for "..price.." $",
	                     ["footer"] = {
                         ["text"] = "ShopName: "..name,
                    },
                }
            }
             PerformHttpRequest(DISCORD_WEBHOOK, function(err, text, headers) end, 'POST', json.encode({username = "Business Buying",  avatar_url = "https://i.imgur.com/NAGTvvz.png",embeds = connect}), { ['Content-Type'] = 'application/json' })

        else    
            TriggerClientEvent('esx:showNotification', _source, '~r~You can\'t afford this shop')
        end

    else
        TriggerClientEvent('esx:showNotification', _source, '~r~You can\'t afford this shop')
        end
    end)
end)

RegisterServerEvent("PM_Shops:MissionFailedMakeAvailable")
AddEventHandler("PM_Shops:MissionFailedMakeAvailable",function(id)
    MySQL.Async.fetchAll('UPDATE deliverymissionsitems set active = @active WHERE ID=@id',{['@id']=id,['@active']=0})
end)

RegisterServerEvent("PM_Shops:PickupFinal")
AddEventHandler("PM_Shops:PickupFinal",function(bool,items,ShopIdPickup)
    if bool == true then
        for k,v in pairs(items) do
            MySQL.Async.fetchAll("SELECT * FROM owned_shops_storage WHERE ShopNumber = @number AND item = @itemname AND label = @itemlabel",{['@number']=ShopIdPickup,['@itemname']=v.name,['@itemlabel']=v.label},function(result)
                if result[1] ~= nil then
                    MySQL.Async.execute("UPDATE owned_shops_storage set count = @itemcount WHERE item = @itemname AND label = @itemlabel AND ShopNumber = @number",{['@itemcount'] = result[1].count + v.count,['@itemname']=v.name,['@itemlabel']=v.label,['@number']=ShopIdPickup})
                else
                    MySQL.Async.execute("INSERT INTO owned_shops_storage(ShopNumber,item,label,count) VALUES(@number,@itemname,@itemlabel,@itemcount)",{['@number']=ShopIdPickup,['@itemname']=v.name,['@itemlabel']=v.label,['@itemcount']=v.count})
                end
            end)
        end
    end
PickupStarted = false
end)

RegisterNetEvent("PM_Shops:InsuranceMoney",function(money,AddOrRemove)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if(AddOrRemove == true)then
        xPlayer.addMoney(money)
    else
        xPlayer.removeMoney(money)
    end
end)

RegisterNetEvent("PM_Shops:PayDriver",function(DriverCut,id)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.addMoney(DriverCut)
    MySQL.Async.fetchAll("DELETE FROM deliverymissionsitems WHERE ID = @id",{['@id']=id})
end)

ESX.RegisterServerCallback("PM_Shops:MakeDeliveryUnavailableForOthers",function(source,cb,id)
    MySQL.Async.fetchAll("SELECT Coords,Items FROM deliverymissionsitems WHERE ID = @id",{['@id']=id},function(result)
        cb(result)
    end)
    MySQL.Async.fetchAll("UPDATE deliverymissionsitems SET active = @active WHERE ID = @id",{['@active']=1,['@id']=id})
end)

RegisterServerEvent("PM_Shops:StoreGasBasedOnNumber")
AddEventHandler("PM_Shops:StoreGasBasedOnNumber",function(number,FuelBought)
    MySQL.Async.fetchAll("SELECT quantity FROM fuel_stations WHERE ShopNumber=@number",{['@number']=number},function(result)
        if result[1].quantity >= 0 then
            MySQL.Async.execute("UPDATE fuel_stations SET quantity = @quantity WHERE ShopNumber = @number",{['@number']=number,['@quantity']=result[1].quantity + FuelBought})
        else
            MySQL.Async.execute("INSERT INTO fuel_stations(quantity) VALUES(@quantity) WHERE ShopNumber = @number",{['@number']=number,['@quantity']=FuelBought})
        end
    end)
end)

RegisterNetEvent("PM_Shops:SaveHistory")
AddEventHandler("PM_Shops:SaveHistory",function(id,price,items)
    MySQL.Async.fetchAll("SELECT ID,Buyer, Date, Time, ShopId FROM deliverymissionsitems WHERE ID = @id",{['@id'] = id},function(result)
        local Time3 = result[1].Date
        Time3 = Time3/1000
        MySQL.Async.execute("INSERT INTO finished_orders(ID,identifier,ShopNumber,Value,Date,Time,DateFinished,TimeFinished,Items) VALUE(@id,@identifier,@number,@price,@StartDate,@StartTime,@EndDate,@EndTime,@Items)",{['@id']=result[1].ID,['@identifier'] = result[1].Buyer,      ['@number'] = result[1].ShopId,    ['@price'] = price,    ['@StartDate'] = os.date('%Y%m%d', Time3),     ['@StartTime'] = result[1].Time,    ['@EndDate']=os.date("%Y%m%d"),    ['@EndTime']=os.date("%H%M%S"),    ['@Items'] = json.encode(items)})
    end)
end)

ESX.RegisterServerCallback("PM_Shops:GetHistoryOrders",function(source,cb,number)
    local _source  = source
    local xPlayers = ESX.GetPlayerFromId(_source)
    local identifier = ESX.GetPlayerFromId(source).identifier
    MySQL.Async.fetchAll("SELECT * FROM finished_orders WHERE identifier = @identifier AND ShopNumber = @number",{['@identifier']=identifier,['@number']=number},function(result)
        if result[1] ~= nil then
            cb(result)
        else
            cb(nil)
        end
    end)
end)

ESX.RegisterServerCallback("PM_Shops:GetActiveOrders",function(source,cb,number)
    local _source  = source
    local xPlayers = ESX.GetPlayerFromId(_source)
    local identifier = ESX.GetPlayerFromId(source).identifier
    local DataToBeCalled = {}
    MySQL.Async.fetchAll("SELECT * FROM deliverymissionsitems WHERE Buyer = @identifier and ShopId = @number",{['@identifier']=identifier,['@number']=number},function(result)
        if result[1] ~= nil then
            cb(result)
        end
    end)
end)


RegisterServerEvent("PM_Shops:Order")
AddEventHandler("PM_Shops:Order",function(isOrder,DriverCut,PriceFinal,ItemsOrderConfirmed,number)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local identifier = ESX.GetPlayerFromId(source).identifier
    local PriceWithoutCut = PriceFinal - DriverCut
    MySQL.Async.fetchAll('SELECT * FROM owned_shops WHERE identifier = @identifier and ShopNumber = @number',{['@identifier']=identifier,['@number']=number},function(result)
        if isOrder then
            if(result[1].money-PriceFinal>=0)then
                MySQL.Async.fetchAll("UPDATE owned_shops SET money=@money WHERE identifier = @identifier AND ShopNumber = @number",{['@identifier']=identifier,['@number']=number,['@money']=result[1].money-PriceFinal})
                MySQL.Async.fetchAll("INSERT INTO deliverymissionsitems(Buyer,ShopId,ShopName,Coords,Items,DriverCut,Value,Date,Time) VALUES(@identifier,@number,@ShopName,@Coords,@Items,@DriverCut,@Value,@Date,@Time)",{['@identifier']=identifier,    ['@number']=number,   ['@ShopName']=result[1].ShopName,      ['@Coords']=result[1].delivery_coords,      ['@Items']=json.encode(ItemsOrderConfirmed),     ['@DriverCut']=DriverCut,     ['@Value']=PriceFinal-DriverCut,['@Date']=os.date("%Y%m%d"),['@Time']=os.date("%H%M%S")})
                TriggerClientEvent('esx:showNotification', xPlayer.source, '~g~You have sucessfully ordered items in value of:'..PriceFinal..'$')
            else
                TriggerClientEvent('esx:showNotification', xPlayer.source, '~r~You don\'t have enough money in your shop.You need an extra: '..PriceFinal-result[1].money..'$')
            end
        elseif isOrder == false then
            if(result[1].money-PriceWithoutCut >= 0) and PickupStarted == false then
                    MySQL.Async.fetchAll("UPDATE owned_shops SET money=@money WHERE identifier = @identifier AND ShopNumber = @number",{['@identifier']=identifier,['@number']=number,['@money']=result[1].money-PriceWithoutCut})
                    TriggerClientEvent('PM_Shops:pickupMission',-1,PriceWithoutCut,ItemsOrderConfirmed,json.decode(result[1].delivery_coords),number,false)
                    TriggerClientEvent('esx:showNotification', xPlayer.source, '~g~You have sucessfully ordered items in value of:'..PriceWithoutCut..'$')
                    PickupStarted = true
            elseif (result[1].money-PriceWithoutCut >= 0) and PickupStarted then
                TriggerClientEvent('esx:showNotification', xPlayer.source, '~r~You have already started a pickup mission.Go finish this one before starting another!')
            else
                TriggerClientEvent('esx:showNotification', xPlayer.source, '~r~You don\'t have enough money in your shop.You need an extra: '..PriceFinal+DriverCut-result[1].money..'$')
            end
        else
            TriggerClientEvent('esx:showNotification', xPlayer.source, '~r~ERROR!')
        end
    end)
end)

RegisterServerEvent("PutInStorage")
AddEventHandler("PutInStorage",function(number,Item,Amount,Label)
MySQL.Async.fetchAll(
    'SELECT count, item FROM shops WHERE item = @item AND ShopNumber = @ShopNumber',
    {
        ['@ShopNumber'] = number,
        ['@item'] = Item,
    },
    function(data)
        if data[1].count > Amount then

            MySQL.Async.fetchAll("UPDATE shops SET count = @count WHERE item = @item AND ShopNumber = @ShopNumber",
            {
                ['@item'] = Item,
                ['@ShopNumber'] = number,
                ['@count'] = data[1].count - Amount
            }, function(result)
            end)

        elseif data[1].count == Amount then

            MySQL.Async.fetchAll("UPDATE shops SET count = @count WHERE item = @name AND ShopNumber = @Number",
            {
                ['@Number'] = number,
                ['@name'] = data[1].item,
                ['@count'] = 0
            })
        end
    end)
    MySQL.Async.fetchAll("SELECT count FROM owned_shops_storage WHERE item = @item AND ShopNumber = @ShopNumber",{['@item']=Item,['@ShopNumber']=number},function(StorageData)
        if StorageData[1] ~= nil then
            MySQL.Async.execute("UPDATE owned_shops_storage SET count=@count WHERE item=@item AND ShopNumber = @ShopNumber",{['@item']=Item,['@ShopNumber']=number,['@count']=StorageData[1].count+Amount})
        else
            MySQL.Async.execute('INSERT INTO owned_shops_storage (ShopNumber, label, count, item) VALUES (@ShopNumber, @label, @count, @item)',
            {
                ['@ShopNumber']    = number,
                ['@label']         = Label,
                ['@count']         = Amount,
                ['@item']          = Item,
            })
        end
    end)
end)

RegisterServerEvent("PutInShop")
AddEventHandler("PutInShop",function(number,Item,Amount,Label)

MySQL.Async.fetchAll(
    'SELECT label, name, price FROM items WHERE name = @item',
    {
        ['@item'] = Item,
    },
    function(items)
        MySQL.Async.fetchAll(
        'SELECT item, count FROM shops WHERE item = @items AND ShopNumber = @ShopNumber',
        {
            ['@items'] = Item,
            ['@ShopNumber'] = number,
        },
        function(data)
    
        if data[1] == nil then
            imgsrc = 'img/box.png'
    
            for i=1, #Config.Images, 1 do
                if Config.Images[i].item == Item then
                    imgsrc = Config.Images[i].src
                end
            end
            MySQL.Async.execute('INSERT INTO shops (ShopNumber, src, label, count, item, price) VALUES (@ShopNumber, @src, @label, @count, @item, @price)',
            {
                ['@ShopNumber']    = number,
                ['@src']        = imgsrc,
                ['@label']         = Label,
                ['@count']         = Amount,
                ['@item']          = Item,
                ['@price']         = items[1].price,
            })
    
        elseif data[1] ~= nil then
                
            MySQL.Async.fetchAll("UPDATE shops SET count = @count WHERE item = @item AND ShopNumber = @ShopNumber",
            {
                ['@item'] = Item,
                ['@ShopNumber'] = number,
                ['@count'] = data[1].count + Amount
            }
            )
        end
    end)  
end)

MySQL.Async.fetchAll("SELECT count,item FROM owned_shops_storage WHERE ShopNumber = @number AND item = @item",{['@number']=number,['@item']=Item},function(Storage)
    if Storage[1].count > Amount then
        MySQL.Async.execute("UPDATE owned_shops_storage SET count = @count WHERE item = @item AND ShopNumber = @number",{['@count']=Storage[1].count-Amount,['@item']=Item,['@number']=number})
    elseif Storage[1].count == Amount then
        MySQL.Async.execute("UPDATE owned_shops_storage SET count = @count WHERE item = @item and ShopNumber = @number",{['@item']=Item,['@number']=number,['@count']=0})
    end
end)

end)

RegisterServerEvent("PM_Shops:OrderFuel")
AddEventHandler("PM_Shops:OrderFuel",function(Price,Fuel,number,DriverCut)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local identifier = ESX.GetPlayerFromId(source).identifier

    MySQL.Async.fetchAll("SELECT * FROM owned_shops WHERE identifier = @identifier and ShopNumber = @number",{['@identifier']=identifier,['@number']=number},function(result)
        if result[1].money-Price >= 0 then
            MySQL.Async.execute("UPDATE owned_shops SET money = @money WHERE identifier = @identifier and ShopNumber = @number",{['@identifier']=identifier,['@number']=number,['@money'] = result[1].money - Price})
            TriggerClientEvent('PM_Shops:PickupMissionFuel',-1,Price,Fuel,json.decode(result[1].delivery_coords),number,false)
            TriggerClientEvent('esx:showNotification', xPlayer.source, "Succesfully ordered:~g~ "..Fuel.."L~w~ fuel")
        else
            TriggerClientEvent('esx:showNotification', xPlayer.source, '~r~You don\'t have enough money in your shop.You need an extra: '..Price-result[1].money..'$')
        end
    end)

end)

ESX.RegisterServerCallback('GetStorage',function(source,cb,number)
    MySQL.Async.fetchAll("SELECT * FROM owned_shops_storage WHERE ShopNumber = @number",{['@number']=number},function(result)
        if result ~= nil then
            cb(result)
        else
            cb(nil)
        end
    end)
end)
ESX.RegisterServerCallback("GetShopItems",function(source,cb,number)
    MySQL.Async.fetchAll("SELECT * FROM shops WHERE ShopNumber = @number",{['@number']=number},function(result)
        if result ~= nil then
            cb(result)
        else
            cb(nil)
        end
    end)
end)

--BOSS MENU STUFF
RegisterServerEvent('PM_Shops:addMoney')
AddEventHandler('PM_Shops:addMoney', function(amount, number)
local _source = source
local xPlayer = ESX.GetPlayerFromId(_source)
local identifier = ESX.GetPlayerFromId(source).identifier

    MySQL.Async.fetchAll(
        'SELECT * FROM owned_shops WHERE identifier = @identifier AND ShopNumber = @Number',
        {
          ['@identifier'] = identifier,
          ['@Number'] = number,
        },
        function(result)
          
        if os.time() - result[1].LastRobbery <= 900 then
            time = os.time() - result[1].LastRobbery
            TriggerClientEvent('esx:showNotification', xPlayer.source, '~r~Your shop money has been locked due to robbery, please wait ' .. math.floor((900 - time) / 60) .. ' minutes')
            return
        end

        if xPlayer.getMoney() >= amount then

            MySQL.Async.fetchAll("UPDATE owned_shops SET money = @money WHERE identifier = @identifier AND ShopNumber = @Number",
            {
                ['@money']      = result[1].money + amount,
                ['@Number']     = number,
                ['@identifier'] = identifier
            })
            xPlayer.removeMoney(amount)
        TriggerClientEvent('esx:showNotification', xPlayer.source, '~g~You put in $' .. amount .. ' in your shop')
        else
        TriggerClientEvent('esx:showNotification', xPlayer.source, '~r~You can\'t put in more than you own')
        end
    end)
end)

RegisterServerEvent('PM_Shops:takeOutMoney')
AddEventHandler('PM_Shops:takeOutMoney', function(amount, number)
local src = source
local identifier = ESX.GetPlayerFromId(src).identifier
local xPlayer = ESX.GetPlayerFromId(src)


  MySQL.Async.fetchAll(
    'SELECT * FROM owned_shops WHERE identifier = @identifier AND ShopNumber = @Number',
    {
      ['@identifier'] = identifier,
      ['@Number'] = number,
    },

    function(result)

    if os.time() - result[1].LastRobbery <= 900 then
        time = os.time() - result[1].LastRobbery
        TriggerClientEvent('esx:showNotification', xPlayer.source, '~r~Your shop money has been locked due to robbery, please wait ' .. math.floor((900 - time) / 60) .. ' minutes')
        return
    end
      
        if result[1].money >= amount then
            MySQL.Async.fetchAll("UPDATE owned_shops SET money = @money WHERE identifier = @identifier AND ShopNumber = @Number",
            {
                ['@money']      = result[1].money - amount,
                ['@Number']     = number,
                ['@identifier'] = identifier
            })
            TriggerClientEvent('esx:showNotification', xPlayer.source, '~g~You took out $' .. amount .. ' from your shop')
            xPlayer.addMoney(amount)
        else
            TriggerClientEvent('esx:showNotification', xPlayer.source, '~r~You can\'t put in more than you own')
        end
        
    end)
end)



RegisterServerEvent('PM_Shops:changeName')
AddEventHandler('PM_Shops:changeName', function(number, name)
  local identifier = ESX.GetPlayerFromId(source).identifier
  local xPlayer = ESX.GetPlayerFromId(source)
      MySQL.Async.fetchAll("UPDATE owned_shops SET ShopName = @Name WHERE identifier = @identifier AND ShopNumber = @Number",
      {
        ['@Number'] = number,
        ['@Name']     = name,
        ['@identifier'] = identifier
      })
      TriggerClientEvent('PM_Shops:removeBlip', -1)
      TriggerClientEvent('PM_Shops:setBlip', -1)
end)

RegisterServerEvent('PM_Shops:SellShop')
AddEventHandler('PM_Shops:SellShop', function(number)
  local identifier = ESX.GetPlayerFromId(source).identifier
  local src = source
  local xPlayer = ESX.GetPlayerFromId(src)
  MySQL.Async.fetchAll(
    'SELECT * FROM owned_shops WHERE identifier = @identifier AND ShopNumber = @ShopNumber',
    {
      ['@identifier'] = identifier,
      ['@ShopNumber'] = number,
    },
    function(result)

        if result[1].money == 0 then
            MySQL.Async.fetchAll("UPDATE owned_shops SET identifier = @identifiers, ShopName = @ShopName WHERE identifier = @identifier AND ShopNumber = @Number",
            {
            ['@identifiers'] = '0',
            ['@identifier'] = identifier,
            ['@ShopName']    = '0',
            ['@Number'] = number,
            })
            MySQL.Async.execute("UPDATE owned_shops_storage SET count = @count WHERE ShopNumber = @number",{['@number'] = number,['@count']=0})
            MySQL.Async.execute("UPDATE shops SET count = @count WHERE ShopNumber = @number",{['@number'] = number,['@count']=0})
            xPlayer.addMoney(result[1].ShopValue / 2)
            TriggerClientEvent('PM_Shops:removeBlip', -1)
            TriggerClientEvent('PM_Shops:setBlip', -1)
            TriggerClientEvent('esx:showNotification', xPlayer.source, '~g~You sold your shop')
        else
            TriggerClientEvent('esx:showNotification', xPlayer.source, '~r~You can\'t sell your shop with money inside of it')
        end
    end)
end)

RegisterServerEvent("PM_Shop:ChangePriceItems")
AddEventHandler("PM_Shop:ChangePriceItems",function(name,new,number)
    MySQL.Async.execute("UPDATE shops SET price = @price WHERE item = @item AND ShopNumber = @number",{['@item']=name,['@price']=new,['@number']=number})
end)

ESX.RegisterServerCallback('PM_Shop:getUnBoughtShops', function(source, cb)
  local identifier = ESX.GetPlayerFromId(source).identifier
  local xPlayer = ESX.GetPlayerFromId(source)

  MySQL.Async.fetchAll(
    'SELECT * FROM owned_shops WHERE identifier = @identifier',
    {
      ['@identifier'] = '0',
    },
    function(result)

        cb(result)
    end)
end)

ESX.RegisterServerCallback('PM_Shop-robbery:getOnlinePolices', function(source, cb)
  local _source  = source
  local xPlayers = ESX.GetPlayers()
  local cops = 0

    for i=1, #xPlayers, 1 do

        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == 'police' then
        cops = cops + 1
        end
    end
    Wait(25)
    cb(cops)
end)

ESX.RegisterServerCallback('PM_Shop-robbery:getUpdates', function(source, cb, id)
    MySQL.Async.fetchAll(
    'SELECT * FROM owned_shops WHERE ShopNumber = @ShopNumber',
    {
     ['@ShopNumber'] = id,
    },
     function(result)
        if result[1].LastRobbery == 0 then
            id = id
            MySQL.Async.fetchAll("UPDATE owned_shops SET LastRobbery = @LastRobbery WHERE ShopNumber = @ShopNumber",
            {
            ['@ShopNumber'] = id,
            ['@LastRobbery']   = os.time(),
            })
        else
            if os.time() - result[1].LastRobbery >= Config.TimeBetweenRobberies then
                cb({cb = true, time = os.time() - result[1].LastRobbery, name = result[1].ShopName})
            else
                cb({cb = nil, time = os.time() - result[1].LastRobbery})
            end
        end
    end)
end)


RegisterServerEvent('PM_Shops-robbery:GetReward')
AddEventHandler('PM_Shops-robbery:GetReward', function(id)
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)


        MySQL.Async.fetchAll(
        'SELECT * FROM owned_shops WHERE ShopNumber = @ShopNumber',
        {
            ['@ShopNumber'] = id,
        }, function(result)

        id = id
        
        MySQL.Async.fetchAll("UPDATE owned_shops SET money = @money WHERE ShopNumber = @ShopNumber",
        {
            ['@ShopNumber'] = id,
            ['@money']     = result[1].money - result[1].money / Config.CutOnRobbery,
        })
        id = id
        if result[1].money == 0 then
            TriggerClientEvent('esx:showNotification', xPlayer.source, "~r~The vault is empty!")
        else
            TriggerClientEvent('esx:showNotification', xPlayer.source, "~g~You got: "..result[1].money/Config.CutOnRobbery.."$")
        xPlayer.addMoney(result[1].money / Config.CutOnRobbery)
        end
    end)
end)

RegisterServerEvent('PM_Shops-robbery:NotifyOwner')
AddEventHandler('PM_Shops-robbery:NotifyOwner', function(msg, id)
local src = source
local xPlayer = ESX.GetPlayerFromId(src)

    for i=1, #ESX.GetPlayers(), 1 do
        local identifier = ESX.GetPlayerFromId(ESX.GetPlayers()[i])
  
            MySQL.Async.fetchAll(
            'SELECT * FROM owned_shops WHERE ShopNumber = @ShopNumber',
            {
                ['@ShopNumber'] = id,
            }, function(result)

            if result[1].identifier == identifier.identifier then
                TriggerClientEvent('esx:showNotification', identifier.source, msg)
            end

        end)
    end
end)

RegisterServerEvent("NotifyPolice")
AddEventHandler("NotifyPolice",function(name)
  local _source  = source
  local xPlayers = ESX.GetPlayers()
  local cops = 0

    for i=1, #xPlayers, 1 do

        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == 'police' then
            TriggerClientEvent('esx:showNotification', xPlayer.source, "Shop robbery at the " .. name .. '\'s shop')
        end
    end
end)

RegisterServerEvent("ResetActiveMissionsOnStart")
AddEventHandler("ResetActiveMissionsOnStart",function()
    MySQL.Async.execute("UPDATE deliverymissionsitems SET active = @active",{['@active']=0})
end)