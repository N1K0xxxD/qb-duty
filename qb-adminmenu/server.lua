local QBCore = exports['qb-core']:GetCoreObject()

-- /admin command to open the admin menu (permission requirement: admin)
QBCore.Commands.Add('admin', 'Open the admin menu', {}, false, function(source)
    TriggerClientEvent('qb-adminmenu:client:openMenu', source)
end, 'admin')