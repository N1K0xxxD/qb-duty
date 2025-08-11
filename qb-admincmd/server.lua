local QBCore = exports['qb-core']:GetCoreObject()

local function isAllowed(source)
    for _, group in ipairs(Config.AllowedGroups) do
        if QBCore.Functions.HasPermission(source, group) then
            return true
        end
    end
    return false
end

QBCore.Commands.Add('admin', 'Open Admin Menu', {}, false, function(source, _)
    if not isAllowed(source) then
        TriggerClientEvent('QBCore:Notify', source, 'You do not have permission to use this.', 'error')
        return
    end
    TriggerClientEvent('qbadmincmd:client:openMenu', source)
end)