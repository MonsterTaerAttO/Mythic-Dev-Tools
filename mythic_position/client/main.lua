RegisterNetEvent("mythic_position:client:GetCoords")
AddEventHandler("mythic_position:client:GetCoords", function(name)
    TriggerServerEvent('mythic_position:server:SaveCoords', name, GetEntityCoords(GetPlayerPed(-1)), GetEntityHeading(GetPlayerPed(-1)))
end)