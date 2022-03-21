ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('wasabi_walk:loadWalk')
AddEventHandler('wasabi_walk:loadWalk', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.identifier
    local rawData = LoadResourceFile(GetCurrentResourceName(), "./data.json")
    local data = json.decode(rawData)
    if data[identifier] ~= nil then
        TriggerClientEvent('wasabi_walk:setWalk', source, data[identifier])
    end
end)

RegisterServerEvent('wasabi_walk:saveWalk')
AddEventHandler('wasabi_walk:saveWalk', function(walk)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.identifier
    local rawData = LoadResourceFile(GetCurrentResourceName(), "./data.json")
    local data = json.decode(rawData)
    data[identifier] = walk
    SaveResourceFile(GetCurrentResourceName(), "./data.json", json.encode(data), -1)
    TriggerClientEvent('wasabi_walk:setWalk', source, walk)
end)