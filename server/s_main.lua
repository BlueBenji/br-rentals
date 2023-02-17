local QBCore = exports['qb-core']:GetCoreObject() 

RegisterNetEvent('b-rental:server:remove', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.RemoveMoney("bank", Config.Vehicle1Price)
end)