TriggerEvent('mythic_chat:server:AddChatCommand', 'debug', function(source, args, rawCommand)
	TriggerClientEvent('hud:enabledebug', source)
end)