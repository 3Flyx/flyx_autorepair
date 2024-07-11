ESX = exports["es_extended"]:getSharedObject()

local oplacila = false

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
	ESX.PlayerLoaded = true
end)

Citizen.CreateThread(function()
	Citizen.Wait(2000)

	for k, conf in pairs(Config.RepairLocations) do
		local blip = AddBlipForCoord(conf.x, conf.y, conf.z)

		SetBlipSprite (blip, 446)
		SetBlipDisplay(blip, 4)
		SetBlipScale  (blip, 0.6)
		SetBlipColour (blip, 4)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName("Mechanik lokalny")
		EndTextCommandSetBlipName(blip)
	end
end)

Citizen.CreateThread(function()
    for k, conf in pairs(Config.RepairLocations) do

		local options = {
			{
				
				icon = 'fa-solid fa-wrench',
				label = 'Napraw pojazd',
				distance = 2,
				canInteract = function(vehicle)
					local coords = GetEntityCoords(vehicle)
					local distance = #(coords - vec3(conf.x, conf.y, conf.z))

					if distance < 5 then
						return true
					end
				end,
				onSelect = function(data)
					local vehicle = data.entity
					ESX.TriggerServerCallback('flyx_autorepair:checkmechanic', function(mechCount)
						if mechCount then
							ESX.TriggerServerCallback('Flyx-autorepair:checkmoney', function(qtty)
								if qtty >= Config.money then

									local alert = lib.alertDialog({
										header = 'Naprawa',
										content = "Czy napewno chcesz naprawić pojazd za kwotę "..Config.money.."$",
										centered = true,
										cancel = true,
									})
						
									if alert == 'confirm' then
										LocalPlayer.state.invBusy = true
										TriggerEvent("wait_taskbar:progress", {
											name = "Repairing Car",
											duration = 15000,
											label = "Trwa naprawianie pojazdu...",
											useWhileDead = true,
											canCancel = true,
											controlDisables = {
												disableMovement = false,
												disableCarMovement = true,
												disableMouse = false,
												disableCombat = false,
											},
										}, function(wasCancelled)
											if not wasCancelled then
												SetVehicleBodyHealth(vehicle, 1000.0)
												SetVehicleDeformationFixed(vehicle)
												SetVehicleFixed(vehicle)
												SetVehicleEngineOn(vehicle, true, true, true)
												TriggerServerEvent('Flyx-autorepair:removemoney', Config.money)
												LocalPlayer.state.invBusy = false
											else
												ESX.ShowNotification("Przestałeś naprawiać pojazd")
											end
										end)
									end

								else
									ESX.ShowNotification('Nie posiadasz wystarczającej ilości pieniędzy')
								end
							end, 'money')
						end
					end)
				end
			}
		}
		exports.ox_target:addGlobalVehicle(options)
    end
end)



RegisterNetEvent("Flyx:potwierdzplatnosc")
AddEventHandler("Flyx:potwierdzplatnosc", function(target, faktura, id, job)
	local alert = lib.alertDialog({
		header = 'Faktura',
		content = "Czy chcesz opłacić fakture o wysokości " ..faktura.."$",
		centered = true,
		cancel = true,
	})

	if alert == 'confirm' then
		TriggerServerEvent('Flyx:wystawplatnosc', target, faktura, id, job)
	end
end)