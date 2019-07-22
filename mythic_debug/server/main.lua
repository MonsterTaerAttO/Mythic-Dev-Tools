Citizen.CreateThread(function()
    Citizen.Wait(1000)
    exports['mythic_chat']:AddAdminChatCommand('debug', function(source, args, rawCommand)
		TriggerClientEvent('hud:enabledebug', source)
    end, {
        help = 'Toggle Debug Mode',
	}, 0)
end)