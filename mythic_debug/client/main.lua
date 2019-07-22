
local dickheaddebug = false

RegisterNetEvent("hud:enabledebug")
AddEventHandler("hud:enabledebug",function()
	dickheaddebug = not dickheaddebug
    if dickheaddebug then
        exports['mythic_base']:DoHudText('inform', 'Debug Enabled')
        print("Debug: Enabled")
    else
        exports['mythic_base']:DoHudText('inform', 'Debug Disabled')
        print("Debug: Disabled")
    end
end)

local inFreeze = false
local lowGrav = false

function drawTxt(x,y ,width,height,scale, text, r,g,b,a)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(0.25, 0.25)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

function Print3DText(coords, text)
	local onScreen, _x, _y = World3dToScreen2d(coords.x, coords.y, coords.z)

	if onScreen then
		SetTextScale(0.35, 0.35)
		SetTextFont(4)
		SetTextProportional(1)
		SetTextColour(255, 255, 255, 255)
		SetTextDropShadow(0, 0, 0, 55)
		SetTextEdge(0, 0, 0, 150)
		SetTextDropShadow()
		SetTextOutline()
		SetTextEntry("STRING")
		SetTextCentre(1)
		AddTextComponentString(text)
		DrawText(_x,_y)

		local factor = (string.len(text)) / 370
		DrawRect(_x,_y + 0.0125, 0.015 + factor, 0.03, 255, 0, 0, 68)
	end
end

function GetVehicle()
    local playerped = PlayerPedId()
    local playerCoords = GetEntityCoords(playerped)
    local handle, ped = FindFirstVehicle()
    local success
    local rped = nil
    local distanceFrom
    repeat
        local pos = GetOffsetFromEntityInWorldCoords(ped, 0, 0, 1.0)
        local pos2 = GetOffsetFromEntityInWorldCoords(ped, 0, 0, 0.75)
        local distance = #(vector3(pos.x, pos.y, pos.z) - playerCoords)
        if canPedBeUsed(ped) and distance < 30.0 and (distanceFrom == nil or distance < distanceFrom) then
            distanceFrom = distance
            rped = ped
            local exterior = DecorExistOn(ped, 'car-exterior-' .. GetVehicleNumberPlateText(ped))
            local interior = DecorExistOn(ped, 'car-interior-' .. GetVehicleNumberPlateText(ped))
           -- FreezeEntityPosition(ped, inFreeze)
            if IsEntityTouchingEntity(PlayerPedId(), ped) then
                Print3DText(pos, "Veh: " .. ped .. " Model: " .. GetEntityModel(ped) .. " IN CONTACT")
                Print3DText(pos2, "Interior: " .. tostring(interior) .. " ~c~- ~s~Exterior: " .. tostring(exterior))
	    	else
                Print3DText(pos, "Veh: " .. ped .. " Model: " .. GetEntityModel(ped) .. " IN CONTACT")
                Print3DText(pos2, "Interior: " .. tostring(interior) .. " ~c~- ~s~Exterior: " .. tostring(exterior))
	    	end
            if lowGrav then
            	SetEntityCoords(ped,pos["x"],pos["y"],pos["z"]+5.0)
            end
        end
        success, ped = FindNextVehicle(handle)
    until not success
    EndFindVehicle(handle)
    return rped
end

function GetObject()
    local playerped = PlayerPedId()
    local playerCoords = GetEntityCoords(playerped)
    local handle, ped = FindFirstObject()
    local success
    local rped = nil
    local distanceFrom
    repeat
        local objPos = GetEntityCoords(ped)
        local pos = GetOffsetFromEntityInWorldCoords(ped, 0, 0, 1.0)
        local pos2 = GetOffsetFromEntityInWorldCoords(ped, 0, 0, 0.75)
        local distance = #(vector3(pos.x, pos.y, pos.z) - playerCoords)
        if distance < 10.0 then
            distanceFrom = distance
            rped = ped
            --FreezeEntityPosition(ped, inFreeze)
	    	if IsEntityTouchingEntity(PlayerPedId(), ped) then
                Print3DText(pos, "Obj: " .. ped .. " Model: " .. GetEntityModel(ped) .. " IN CONTACT" )
	    	else
                Print3DText(pos, "Obj: " .. ped .. " Model: " .. GetEntityModel(ped) .. "" )
            end
            
            Print3DText(pos2, "Pos: x" .. objPos.x .. " y " .. objPos.y .. " z " .. objPos.z )

            if lowGrav then
            	--ActivatePhysics(ped)
            	SetEntityCoords(ped,pos["x"],pos["y"],pos["z"]+0.1)
            	FreezeEntityPosition(ped, false)
            end
        end

        success, ped = FindNextObject(handle)
    until not success
    EndFindObject(handle)
    return rped
end




function getNPC()
    local playerped = PlayerPedId()
    local playerCoords = GetEntityCoords(playerped)
    local handle, ped = FindFirstPed()
    local success
    local rped = nil
    local distanceFrom
    repeat
        local pos = GetEntityCoords(ped)
        local distance = #(vector3(pos.x, pos.y, pos.z) - playerCoords)
        if canPedBeUsed(ped) and distance < 30.0 and (distanceFrom == nil or distance < distanceFrom) then
            distanceFrom = distance
            rped = ped

	    	if IsEntityTouchingEntity(PlayerPedId(), ped) then
                Print3DText(pos, "Ped: " .. ped .. " Model: " .. GetEntityModel(ped) .. " Relationship HASH: " .. GetPedRelationshipGroupHash(ped) .. " IN CONTACT" )
	    	else
                Print3DText(pos, "Ped: " .. ped .. " Model: " .. GetEntityModel(ped) .. " Relationship HASH: " .. GetPedRelationshipGroupHash(ped))
	    	end

            FreezeEntityPosition(ped, inFreeze)
            if lowGrav then
            	SetPedToRagdoll(ped, 511, 511, 0, 0, 0, 0)
            	SetEntityCoords(ped,pos["x"],pos["y"],pos["z"]+0.1)
            end
        end
        success, ped = FindNextPed(handle)
    until not success
    EndFindPed(handle)
    return rped
end

function canPedBeUsed(ped)
    if ped == nil then
        return false
    end
    if ped == PlayerPedId() then
        return false
    end
    if not DoesEntityExist(ped) then
        return false
    end
    return true
end



Citizen.CreateThread( function()

    while true do 
        
        Citizen.Wait(1)
        
        if dickheaddebug then
            local player = PlayerPedId()
            local pos = GetEntityCoords(player)

            local forPos = GetOffsetFromEntityInWorldCoords(player, 0, 1.0, 0.0)
            local backPos = GetOffsetFromEntityInWorldCoords(player, 0, -1.0, 0.0)
            local LPos = GetOffsetFromEntityInWorldCoords(player, 1.0, 0.0, 0.0)
            local RPos = GetOffsetFromEntityInWorldCoords(player -1.0, 0.0, 0.0) 

            local forPos2 = GetOffsetFromEntityInWorldCoords(player, 0, 2.0, 0.0)
            local backPos2 = GetOffsetFromEntityInWorldCoords(player, 0, -2.0, 0.0)
            local LPos2 = GetOffsetFromEntityInWorldCoords(player, 2.0, 0.0, 0.0)
            local RPos2 = GetOffsetFromEntityInWorldCoords(player, -2.0, 0.0, 0.0)    

            local x, y, z = table.unpack(GetEntityCoords(player, true))
            local currentStreetHash, intersectStreetHash = GetStreetNameAtCoord(x, y, z, currentStreetHash, intersectStreetHash)
            currentStreetName = GetStreetNameFromHashKey(currentStreetHash)

            drawTxt(0.8, 0.50, 0.4,0.4,0.30, "Heading: " .. GetEntityHeading(player), 55, 155, 55, 255)
            drawTxt(0.8, 0.52, 0.4,0.4,0.30, "Coords: " .. pos, 55, 155, 55, 255)
            drawTxt(0.8, 0.54, 0.4,0.4,0.30, "Attached Ent: " .. GetEntityAttachedTo(player), 55, 155, 55, 255)
            drawTxt(0.8, 0.56, 0.4,0.4,0.30, "Health: " .. GetEntityHealth(player), 55, 155, 55, 255)
            drawTxt(0.8, 0.58, 0.4,0.4,0.30, "H a G: " .. GetEntityHeightAboveGround(player), 55, 155, 55, 255)
            drawTxt(0.8, 0.60, 0.4,0.4,0.30, "Model: " .. GetEntityModel(player), 55, 155, 55, 255)
            drawTxt(0.8, 0.62, 0.4,0.4,0.30, "Speed: " .. GetEntitySpeed(player), 55, 155, 55, 255)
            drawTxt(0.8, 0.64, 0.4,0.4,0.30, "Frame Time: " .. GetFrameTime(), 55, 155, 55, 255)
            drawTxt(0.8, 0.66, 0.4,0.4,0.30, "Street: " .. currentStreetName, 55, 155, 55, 255)
            
            
            DrawLine(pos,forPos, 255,0,0,115)
            DrawLine(pos,backPos, 255,0,0,115)

            DrawLine(pos,LPos, 255,255,0,115)
            DrawLine(pos,RPos, 255,255,0,115)           

            DrawLine(forPos,forPos2, 255,0,255,115)
            DrawLine(backPos,backPos2, 255,0,255,115)

            DrawLine(LPos,LPos2, 255,255,255,115)
            DrawLine(RPos,RPos2, 255,255,255,115)     

            local nearped = getNPC()

            local veh = GetVehicle()

            local nearobj = GetObject()

            if IsControlJustReleased(0, 38) then
                if inFreeze then
                    inFreeze = false
                    exports['mythic_base']:DoHudText('inform', 'Freeze Disabled')
                else
                    inFreeze = true
                    exports['mythic_base']:DoHudText('inform', 'Freeze Enabled')     
                end
            end

            if IsControlJustReleased(0, 47) then
                if lowGrav then
                    lowGrav = false
                    exports['mythic_base']:DoHudText('inform', 'Low Grav Disabled')
                else
                    lowGrav = true              
                    exports['mythic_base']:DoHudText('inform', 'Low Grav Enabled')     
                end
            end

        else
            Citizen.Wait(5000)
        end
    end
end)