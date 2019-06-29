local handlingFields = {
    'fMass',
    'fInitialDragCoeff',
    'fPercentSubmerged',
    'vecCentreOfMassOffset',
    'vecInertiaMultiplier',
    'fDriveBiasFront',
    'fInitialDriveForce',
    'fDriveInertia',
    'fClutchChangeRateScaleUpShift',
    'fClutchChangeRateScaleDownShift',
    'fInitialDriveMaxFlatVel',
    'fBrakeForce',
    'fBrakeBiasFront',
    'fHandBrakeForce',
    'fSteeringLock',
    'fTractionCurveMax',
    'fTractionCurveMin',
    'fTractionCurveLateral',
    'fTractionSpringDeltaMax',
    'fLowSpeedTractionLossMult',
    'fCamberStiffnesss',
    'fTractionBiasFront',
    'fTractionLossMult',
    'fSuspensionForce',
    'fSuspensionCompDamp',
    'fSuspensionReboundDamp',
    'fSuspensionUpperLimit',
    'fSuspensionLowerLimit',
    'fSuspensionRaise',
    'fSuspensionBiasFront',
    'fAntiRollBarForce',
    'fAntiRollBarBiasFront',
    'fRollCentreHeightFront',
    'fRollCentreHeightRear',
    'fCollisionDamageMult',
    'fWeaponDamageMult',
    'fDeformationDamageMult',
    'fEngineDamageMult',
}

local handlingData = {}
local veh = nil

function starts_with(str, start)
    return str:sub(1, #start) == start
end

RegisterNetEvent('mythic_engine:client:PlayerEnteringVeh')
AddEventHandler('mythic_engine:client:PlayerEnteringVeh', function(vehicle, currentSeat, displayname, netId)
    veh = vehicle
    handlingData = {}
    for i = 1, #handlingFields, 1 do
        local value = nil
        if starts_with(handlingFields[i], 'f') then
            value = GetVehicleHandlingFloat(veh, 'CHandlingData', handlingFields[i])
        elseif starts_with(handlingFields[i], 'i') or starts_with(handlingFields[i], 'n') then
            value = GetVehicleHandlingInt(veh, 'CHandlingData', handlingFields[i])
        end

        table.insert(handlingData,  {
            index = i,
            name = handlingFields[i],
            value = value
        })
    end
end)

RegisterNUICallback("UpdateHandlingField", function(data, cb)
    if IsPedInAnyVehicle(PlayerPedId()) then
        if starts_with(data.field, 'f') then
            print(data.field == handlingFields[data.index])
            print(GetVehicleHandlingFloat(veh, 'CHandlingData', data.field))
            SetVehicleHandlingFloat(veh, 'CHandlingData', data.field, tonumber(data.value + 0.0))
            handlingData[data.index].value = tonumber(data.value)
            print(GetVehicleHandlingFloat(veh, 'CHandlingData', data.field))
        else
            print(GetVehicleHandlingInt(veh, 'CHandlingData', data.field))
            SetVehicleHandlingInt(veh, 'CHandlingData', data.field, tonumber(data.value))
            handlingData[data.index].value = tonumber(data.value)
            print(GetVehicleHandlingInt(veh, 'CHandlingData', data.field))
        end
    end
end)

RegisterNUICallback("CloseUI", function(data, cb)
    SetNuiFocus(false, false)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsPedInAnyVehicle(PlayerPedId()) then
            if IsControlJustReleased(0, 54) then
                print('bleh ' .. GetVehicleHandlingFloat(GetVehiclePedIsIn(PlayerPedId()),"CHandlingData","fInitialDriveForce"))
                SetNuiFocus(true, true)
                SendNUIMessage({
                    action = 'display',
                    handling = handlingData
                })
            end
        end
    end
end)