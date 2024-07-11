local QBCore = exports['qb-core']:GetCoreObject() 


local pressedbutton = false
local enteredmenu = false

-- Events

-- Vehicles

RegisterNetEvent('b-rental:client:vehicle1', function()
    if QBCore.Functions.GetPlayerData().money['cash'] >= Config.Vehicle1Price then
        TriggerServerEvent('b-rental:server:remove')
        QBCore.Functions.SpawnVehicle(Config.Vehicle1Model, function(veh)
            SetVehicleNumberPlateText(veh, 'Rental')
            SetEntityCoords(veh, vector3(408.18, -638.68, 28.5))
            SetEntityHeading(veh, 266.76)
            exports['LegacyFuel']:SetFuel(veh, 100.0)
            TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
            TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(veh))
            SetVehicleEngineOn(veh, true, true)
        end, coords, true)
    else
        QBCore.Functions.Notify("Not Enough Money!", "error")
    end
end)

RegisterNetEvent('b-rental:client:vehicle2', function()
    if QBCore.Functions.GetPlayerData().money['cash'] >= Config.Vehicle2Price then
        TriggerServerEvent('b-rental:server:remove')
        QBCore.Functions.SpawnVehicle(Config.Vehicle2Model, function(veh)
            SetVehicleNumberPlateText(veh, 'Rental')
            SetEntityCoords(veh, vector3(408.18, -638.68, 28.5))
            SetEntityHeading(veh, 266.76)
            exports['LegacyFuel']:SetFuel(veh, 100.0)
            TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
            TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(veh))
            SetVehicleEngineOn(veh, true, true)
        end, coords, true)
    else
        QBCore.Functions.Notify("Not Enough Money!", "error")
    end
end)

-- Example event for new vehicle
 
-- RegisterNetEvent('b-rental:client:vehicle2', function()
--     if QBCore.Functions.GetPlayerData().money['cash'] >= Config.Vehicle2Price then
--         TriggerServerEvent('b-rental:server:remove')
--         QBCore.Functions.SpawnVehicle(Config.Vehicle2Model, function(veh)
--             SetVehicleNumberPlateText(veh, 'Rental')
--             SetEntityCoords(veh, vector3(408.18, -638.68, 28.5))
--             SetEntityHeading(veh, 266.76)
--             exports['LegacyFuel']:SetFuel(veh, 100.0)
--             TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
--             TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(veh))
--             SetVehicleEngineOn(veh, true, true)
--         end, coords, true)
--     else
--         QBCore.Functions.Notify("Not Enough Money!", "error")
--     end
-- end)

-- Menu

RegisterNetEvent("b-rental:client:rentcar", function()
    local rent = {
        {
            header = "Vehicle Rental",
            isMenuHeader = true,
        },
        {
            header = Config.Vehicle1Header,
            txt = Config.Vehicle1Text,
            params = {
                event = 'b-rental:client:vehicle1'
            }
        },
        {
            header = Config.Vehicle2Header,
            txt = Config.Vehicle2Text,
            params = {
                event = 'b-rental:client:vehicle2'
            }
        },
    }
    exports['qb-menu']:openMenu(rent)
end)

-- Threads

CreateThread(function()
    Rental = AddBlipForCoord(vector3(396.86, -635.68, 28.5))
    SetBlipSprite (Rental, 525)
    SetBlipDisplay(Rental, 6)
    SetBlipScale  (Rental, 0.5)
    SetBlipAsShortRange(Rental, true)
    SetBlipColour(Rental, 0)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(Config.BlipName)
    EndTextCommandSetBlipName(Rental)
end)

CreateThread(function()
    if Config.QBTarget then
        exports["qb-target"]:AddBoxZone("rental", vector3(394.88, -635.6, 28.71), 1.0, 1, {
            name="rental",
            heading=265,
            --debugPoly=true,
            minZ=25.71,
            maxZ=29.71
        }, {
            options = {
                {
                    event = "b-rental:client:rentcar",
                    icon = "fa-solid fa-key",
                    label = "Vehicle Rent Menu",
                }, 
            },
            distance = 2
        })  
    else
        while true do
            local ped = PlayerPedId()
            local pos = GetEntityCoords(ped)
            local dist = #(pos - Config.RentalLocation)

            if dist < 2 and not pressedbutton then
                DrawText3D(Config.RentalLocation, "Press ~b~[~w~E~b~]~w~ To Rent A Vehicle")
            end
            if IsControlJustPressed(0, 38) and dist < 2 and not pressedbutton then
                pressedbutton = true
            end
            if pressedbutton then
                TriggerEvent('b-rental:client:rentcar')
                pressedbutton = false    
            end
            Wait(0)
        end
    end
end)

-- Functions

function DrawText3D(coords, text)
    local onScreen, _x, _y = World3dToScreen2d(coords.x, coords.y, coords.z)
    local pX, pY, pZ = table.unpack(GetGameplayCamCoords())

    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)

    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 50, 50, 50, 50)
end
