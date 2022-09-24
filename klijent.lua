--ESX--
ESX = nil
local PlayerData = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = ESX.GetPlayerData()
	PlayerData = xPlayer
	PlayerData.job = xPlayer.job
	PlayerLoaded = true
end)


RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

--ESX Shit--
local isinMarker = false
local isRobbing = false
local currentATM 
--Blips

if Config.useBlips then
    Citizen.CreateThread(function()
        for k, atms in pairs(Config.Atms) do
            local blip = AddBlipForCoord(atms.x, atms.y, atms.z)
            SetBlipSprite (blip, 433)
            SetBlipScale  (blip, 0.9)
            SetBlipDisplay(blip, 4)
            SetBlipColour (blip, 55)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString(Translation[Config.Locale]['blip_text'])
            EndTextCommandSetBlipName(blip)
        end
    end)
end
--Blips


Citizen.CreateThread(function()
    while true do

        Citizen.Wait(250)

        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        

        isinMarker = false
        for k, atms in pairs(Config.Atms) do
            local distanceToATM = Vdist(playerCoords, atms.x, atms.y, atms.z)
            if (distanceToATM < 0.6) then
                currentATM = k
                isinMarker = true
                break
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do

        Citizen.Wait(0)

        if Config.showMarker then
            for k, atms in pairs(Config.Atms) do
                DrawMarker(27, atms.x, atms.y, atms.z- 0.95, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0*1.0, 1.0*1.0, 55.0, 255.0, 0, 0, 50, false, false, 2, false, false, false, false)
            end
        end

        if isRobbing then
            if IsControlJustReleased(0, Config.AbortKey) then
                ClearPedTasksImmediately(PlayerPedId())
                --endRob()
            end
        end

        if isinMarker then
            if isRobbing then
            
            else
                if Config.showInfobar then
                    showInfobar(Translation[Config.Locale]['infobar_start'])
                end
                if IsControlJustReleased(1, Config.InteractionKey) then
					if not isRobbing then
						TriggerServerEvent('rcBankomat:checkPolice', currentATM)
						isinMarker = false
					else
						ShowNotification(Translation[Config.Locale]['recently_robbed'])
					end
                end
            end
        end
		

    end
end)


local isNearATM = false
local loot = 0

RegisterNetEvent('rcBankomat:checkLockpick')
AddEventHandler('rcBankomat:checkLockpick', function()

    if Config.RequireLockpickItem then
        ESX.TriggerServerCallback('rcBankomat:haveLockpick', function(count)
            if count >= 1 then
                TriggerServerEvent('rcBankomat:removeItem', Config.LockpickItem, 1)
                TriggerEvent('rcBankomat:startRob')
            else
                ShowNotification(Translation[Config.Locale]['no_lockpick'])
            end
        end)
    else
        TriggerEvent('rcBankomat:startRob')
    end

end)

RegisterNetEvent('rcBankomat:startRob')
AddEventHandler('rcBankomat:startRob', function()

    local playerPed = PlayerPedId()
    local playerCoordsStart = GetEntityCoords(playerPed)
    isRobbing = true

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(250)
			
            if isRobbing then
                local playerCoordsActual = GetEntityCoords(playerPed)
                local distance = Vdist(playerCoordsActual, playerCoordsStart.x, playerCoordsStart.y, playerCoordsStart.z)
                if isRobbing then
                    if (distance < 3.0) then
                        isNearATM = true
                    else 
                        isNearATM = false
                        endRob()
                        break
                    end
                end
            end
        end
    end)


    ShowNotification(Translation[Config.Locale]['step_1'])
    TaskPlayAnim (playerPed, DictAnim("missheistfbi3b_ig7","lift_fibagent_loop"), true)
    local stvar = loadModel(GetHashKey('w_me_crowbar'))
    local pajser = CreateObject(stvar, GetEntityCoords(PlayerPedId()), true, false, false)
    AttachEntityToEntity(pajser, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.09, 0.03, -0.02, -28.0, 3.0, 28.0, false, true, true, true, 0, true)
    exports['progressBars']:startUI(45000, "Pljackanje bankomata!!!")
    Citizen.Wait(30000) 
    DeleteObject (pajser)
	TriggerServerEvent('rcBankomat:notifyPolice', playerCoordsStart)
    Citizen.Wait(0)
    ClearPedTasksImmediately(playerPed)
    if isNearATM then
        ClearPedTasksImmediately(playerPed)
        ShowNotification(Translation[Config.Locale]['step_4'])
        TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_PARKING_METER", 0, true)
    end


    for i = 1, Config.IntervalCount, 1 do

        Citizen.Wait(Config.IntervalTime * 1000)

                    if isNearATM then

                        local minMoney = math.floor(Config.Atms[currentATM].money.min / Config.IntervalCount)
                        local maxMoney = math.floor(Config.Atms[currentATM].money.max / Config.IntervalCount)
                        local randomint = math.random(minMoney, maxMoney)
                        loot = loot + randomint

                        if i == Config.IntervalCount then
                            ShowNotification(Translation[Config.Locale]['got_money'] ..  loot .. Translation[Config.Locale]['got_money2'])
                            TriggerServerEvent('rcBankomat:pay', loot)
                            loot = 0

                        else
                            ShowNotification(Translation[Config.Locale]['got_money'] ..  loot .. Translation[Config.Locale]['got_money3'])
                        end
                    else
                        break
                    end

                end

            end)

function endRob()

	TriggerServerEvent('rcBankomat:notifyRobAbort')

    if loot > 0 then
        ShowNotification(Translation[Config.Locale]['rob_aborted'] .. loot .. Translation[Config.Locale]['rob_aborted2'])
        TriggerServerEvent('rcBankomat:pay', loot)
        loot = 0
    else
        ShowNotification(Translation[Config.Locale]['rob_aborted_nothing'])
    end
	
	--Citizen.Wait(900000)
	isRobbing = false

end

RegisterNetEvent('rcBankomat:callPolice')
AddEventHandler('rcBankomat:callPolice', function(coords)

    local streetlabel = Citizen.InvokeNative( 0x2EB41072B4C1E4C0, coords.x, coords.y, coords.z, Citizen.PointerValueInt(), Citizen.PointerValueInt() )
    local street = GetStreetNameFromHashKey(streetlabel)
    showPictureNotification('CHAR_MP_MERRYWEATHER', Translation[Config.Locale]['cop_notify'] .. street .. Translation[Config.Locale]['cop_notify2'], Translation[Config.Locale]['cop_atm'], Translation[Config.Locale]['cop_heading'])


    local Blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    local transT = 600

    SetBlipSprite(Blip, 10)
    SetBlipColour(Blip,  2)
    SetBlipAlpha(Blip,  transT)
    SetBlipAsShortRange(Blip, 1)

    while transT ~= 0 do
        Wait(100)
        transT = transT - 1
        SetBlipAlpha(Blip, transT)
        if transT == 0 then
            SetBlipSprite(Blip, 2)
            return
        end
    end

end)

RegisterNetEvent('rcBankomat:notifyPoliceAbort')
AddEventHandler('rcBankomat:notifyPoliceAbort', function()
	showPictureNotification('CHAR_MP_MERRYWEATHER', Translation[Config.Locale]['rob_aborted_chat'], Translation[Config.Locale]['cop_atm'], Translation[Config.Locale]['rob_abort_title'])
end)

function ShowNotification(text)
	SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
	DrawNotification(false, true)
end

function showInfobar(msg)

	CurrentActionMsg  = msg
	SetTextComponentFormat('STRING')
	AddTextComponentString(CurrentActionMsg)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)

end


function showPictureNotification(icon, msg, title, subtitle)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(msg);
    SetNotificationMessage(icon, icon, true, 1, title, subtitle);
    DrawNotification(false, true);
end
DictAnim = function(animacija, animacijaIme)	
	RequestAnimDict(animacija)
	while not HasAnimDictLoaded(animacija) do
		Citizen.Wait(100)
	end
	TaskPlayAnim(PlayerPedId(), animacija, animacijaIme, 1.5, -8.0, -1, 1, 0, 0, 0, 0)
end
loadModel = function(stvar)
    while not HasModelLoaded(stvar) do Wait(0) RequestModel(stvar) end
    return stvar
end
