ESX = exports["es_extended"]:getSharedObject()

ESX.RegisterServerCallback('flyx_autorepair:checkmechanic', function(source, cb)
    local src = source
    local players = ESX.GetPlayers()
    local mechCount = 0

    for i = 1, #players do
        local xPlayer = ESX.GetPlayerFromId(players[i])
        if xPlayer.job.name == 'mechanic'then
            mechCount = mechCount + 1
        end
    end

    if mechCount >= 2 then
		cb(false)
		TriggerClientEvent('esx:showNotification', source, 'Jest zbyt wielu mechaników na służbie')
    else
		cb(true)
    end
end)

ESX.RegisterServerCallback('Flyx-autorepair:checkmoney', function(source, cb, item)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer ~= nil then
		local items = xPlayer.getInventoryItem(item)
		if items == nil then
			cb(0)
		else
			cb(items.count)
		end
	end
end)

RegisterNetEvent("Flyx-autorepair:removemoney", function(money)
	local _source = source

	exports.ox_inventory:RemoveItem(_source, 'money', money)
end)