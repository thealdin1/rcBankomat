ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local lastRobbery = {}

RegisterServerEvent('rcBankomat:notifyPolice')
AddEventHandler('rcBankomat:notifyPolice', function(coords)

	local xPlayers = ESX.GetPlayers()
	

	for i=1, #xPlayers, 1 do
		
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

		if xPlayer.job.name == 'police' then
			TriggerClientEvent('rcBankomat:callPolice', xPlayer.source, coords)
	   end
   end
	
end)


RegisterServerEvent('rcBankomat:notifyRobAbort')
AddEventHandler('rcBankomat:notifyRobAbort', function(coords)
	
	local xPlayers = ESX.GetPlayers()

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			TriggerClientEvent('rcBankomat:notifyPoliceAbort', xPlayer.source, coords)
	   end
   end

end)

RegisterServerEvent('rcBankomat:pay')
AddEventHandler('rcBankomat:pay', function(amount)

	local xPlayer = ESX.GetPlayerFromId(source)

	if amount > 0 then
	
		xPlayer.addMoney(amount)
	
	end
	
end)

ESX.RegisterServerCallback('rcBankomat:haveLockpick', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    cb(xPlayer.getInventoryItem(Config.LockpickItem).count)
end)

RegisterServerEvent('rcBankomat:removeItem')
AddEventHandler('myCarthief:removeItem', function(Item, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem(Item, amount)
end)

RegisterServerEvent('rcBankomat:checkPolice')
AddEventHandler('rcBankomat:checkPolice', function(ATMIndex)

	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers = ESX.GetPlayers()

	local cops = 0
	for i=1, #xPlayers, 1 do
 		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
 		if xPlayer.job.name == 'police' then
			cops = cops + 1
		end
	end
	
	if cops >= Config.CopsRequiredToSell then
		if lastRobbery[ATMIndex] ~= nil then
			local currentTime = os.time()
			local diffTime = os.difftime(currentTime, lastRobbery[ATMIndex])
			local diffMinutes = diffTime / 60

			if diffMinutes >= Config.Atms[ATMIndex].timeout then
				TriggerClientEvent('rcBankomat:checkLockpick', _source)
				lastRobbery[ATMIndex] = os.time()
			else
				TriggerClientEvent('esx:showNotification', _source, Translation[Config.Locale]['timeout'])
			end
		else
			TriggerClientEvent('rcBankomat:checkLockpick', _source)
			lastRobbery[ATMIndex] = os.time()
		end
		
	else
		TriggerClientEvent('esx:showNotification', _source, Translation[Config.Locale]['not_enough_cops'])
	end
end)

ESX.TriggerServerCallback = function(name, requestId, source, cb, ...)
	if ESX.ServerCallbacks[name] then
		ESX.ServerCallbacks[name](source, cb, ...)
	else
		print(('Skripta od Strane RC Developmenta!'):format(name))
	end
end
