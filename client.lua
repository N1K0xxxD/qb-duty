-- client.lua

QBCore = exports['qb-core']:GetCoreObject()

-- Admin Menu Variables
local isAdminMenuOpen = false
local adminMenuData = {}

-- Command to go ON duty
RegisterCommand('onduty', function()
    local playerPed = PlayerPedId()
    local job = QBCore.Functions.GetPlayerData().job.name

    -- Trigger Server Event to go ON duty
    TriggerServerEvent('Toggle:Duty', job, true)
end, false)

-- Command to go OFF duty
RegisterCommand('offduty', function()
    local playerPed = PlayerPedId()
    local job = QBCore.Functions.GetPlayerData().job.name

    -- Trigger Server Event to go OFF duty
    TriggerServerEvent('Toggle:Duty', job, false)
end, false)

-- Admin Menu Command
RegisterCommand('admin', function()
    TriggerServerEvent('Admin:CheckPermission')
end, false)

-- Admin Menu Events
RegisterNetEvent('Admin:OpenMenu', function(players, adminLevel)
    if not isAdminMenuOpen then
        isAdminMenuOpen = true
        adminMenuData.players = players
        adminMenuData.adminLevel = adminLevel
        SetNuiFocus(true, true)
        SendNUIMessage({
            type = "openAdminMenu",
            players = players,
            adminLevel = adminLevel
        })
    end
end)

RegisterNetEvent('Admin:CloseMenu', function()
    if isAdminMenuOpen then
        isAdminMenuOpen = false
        SetNuiFocus(false, false)
        SendNUIMessage({
            type = "closeAdminMenu"
        })
    end
end)

-- NUI Callbacks
RegisterNUICallback('closeMenu', function(data, cb)
    TriggerEvent('Admin:CloseMenu')
    cb('ok')
end)

RegisterNUICallback('teleportToPlayer', function(data, cb)
    TriggerServerEvent('Admin:TeleportToPlayer', data.playerId)
    cb('ok')
end)

RegisterNUICallback('bringPlayer', function(data, cb)
    TriggerServerEvent('Admin:BringPlayer', data.playerId)
    cb('ok')
end)

RegisterNUICallback('kickPlayer', function(data, cb)
    TriggerServerEvent('Admin:KickPlayer', data.playerId, data.reason)
    cb('ok')
end)

RegisterNUICallback('banPlayer', function(data, cb)
    TriggerServerEvent('Admin:BanPlayer', data.playerId, data.reason, data.duration)
    cb('ok')
end)

RegisterNUICallback('spectatePlayer', function(data, cb)
    TriggerServerEvent('Admin:SpectatePlayer', data.playerId)
    cb('ok')
end)

RegisterNUICallback('healPlayer', function(data, cb)
    TriggerServerEvent('Admin:HealPlayer', data.playerId)
    cb('ok')
end)

RegisterNUICallback('revivePlayer', function(data, cb)
    TriggerServerEvent('Admin:RevivePlayer', data.playerId)
    cb('ok')
end)

RegisterNUICallback('freezePlayer', function(data, cb)
    TriggerServerEvent('Admin:FreezePlayer', data.playerId)
    cb('ok')
end)

-- Register Key Mapping (Optional)
RegisterKeyMapping('onduty', 'Go On Duty', 'keyboard', 'F6')  -- Keybind for On Duty
RegisterKeyMapping('offduty', 'Go Off Duty', 'keyboard', 'F7') -- Keybind for Off Duty
