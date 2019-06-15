TriggerEvent('mythic_chat:server:AddAdminChatCommand', 'position', function(source, args, rawCommand)
    TriggerClientEvent('mythic_position:client:GetCoords', source, args)
end, {
    help = "Save Current Position To positions.txt",
    params = {{
            name = "Name",
            help = "Label For Coords"
        }
    }
}, 1)

RegisterServerEvent('mythic_position:server:SaveCoords')
AddEventHandler('mythic_position:server:SaveCoords', function(name, coords, heading)
    local f,err = io.open('positions.txt','a')
    if not f then return print(err) end

    f:write('{ name = "' .. name[1] .. '", x = ' .. coords.x .. ', y = ' .. coords.y .. ', z = ' .. coords.z .. ', h = ' .. heading .. ' }\n')

	f:close()
end)