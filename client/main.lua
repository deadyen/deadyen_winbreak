local notified = false

CreateThread(function()
    while true do
        local sleep = 1000
        local ped = PlayerPedId()

        if IsPedInAnyVehicle(ped, true) then
            sleep = 100
            if IsPedArmed(ped, 4) or GetSelectedPedWeapon(ped) ~= `WEAPON_UNARMED` then
                sleep = 0
                if IsPedDoingDriveby(ped) then
                    if GetIsTaskActive(ped, 204) then
                        ClearPedTasks(ped)
                        if not notified then
                            notified = true
                            SendNotification(Config.Locales["notify"])
                        end
                    end
                else
                    notified = false
                end
            end
        end
        Wait(sleep)
    end
end)

if Config.WindowRoll then
    RegisterCommand(Config.WindowRollCommand, function()
        local ped = PlayerPedId()
        if IsPedInAnyVehicle(ped, true) then
            local veh = GetVehiclePedIsIn(ped, false)
            local seat = nil

            for i = -1, GetVehicleModelNumberOfSeats(GetEntityModel(veh)) do
                if GetPedInVehicleSeat(veh, i) == ped then
                    seat = (i + 1)
                end
            end

            if seat ~= nil then
                if IsVehicleWindowIntact(veh, seat) then
                    RollDownWindow(veh, seat)
                else
                    RollUpWindow(veh, seat)
                end
            end
        end
    end, false)
end