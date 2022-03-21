ESX = nil

CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Wait(0)
    end
    TriggerEvent('chat:addSuggestion', '/'..Config.saveCommand, 'Set a walking style to save.', {{ name='style', help='Use command /'..Config.walkListCommand..' for a list of walking styles.'}})
    TriggerEvent('chat:addSuggestion', '/'..Config.walkListCommand, 'List of avaliable walking styles.')
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
    loadPlayerWalk()
end)

AddEventHandler('esx:onPlayerSpawn', function()
    loadPlayerWalk()
end)


RegisterNetEvent('wasabi_walk:setWalk')
AddEventHandler('wasabi_walk:setWalk', function(style)
    local animSet = loadAnimSet(style)
    SetPedMovementClipset(PlayerPedId(), animSet, true)
end)

RegisterCommand(Config.saveCommand, function(source, args)
    if args[1] then
        local walkingStyle = string.lower(args[1])
        if Config.Walks[walkingStyle] then
            TriggerServerEvent('wasabi_walk:saveWalk', Config.Walks[walkingStyle])
        else
            ShowNotification(Language['invalid_style'])
        end
    else
        ShowNotification(Language['invalid_usage'])
    end
end)

RegisterCommand(Config.walkListCommand, function() chatMessage() end)

loadAnimSet = function(set)
    RequestAnimSet(set)
    while not HasAnimSetLoaded(set) do Wait(0) end
    return set
end


loadPlayerWalk = function()
    TriggerServerEvent('wasabi_walk:loadWalk')
end

pairsByKeys = function(t, f)
    local a = {}
    for n in pairs(t) do
        table.insert(a, n)
    end
    table.sort(a, f)
    local i = 0 
    local iter = function ()
        i = i + 1
        if a[i] == nil then
            return nil
        else
            return a[i], t[a[i]]
        end
    end
    return iter
end

chatMessage = function()
    local walkingStyles = ''
    for k in pairsByKeys(Config.Walks) do
        walkingStyles = walkingStyles..''..string.lower(k)..', '
    end
    TriggerEvent('chat:addMessage', {
        multiline = true,
        args = {"^1Walks", ' '..walkingStyles}
      })
end

ShowNotification = function(msg)
	SetNotificationTextEntry('STRING')
	AddTextComponentString(msg)
	DrawNotification(0,1)
end
