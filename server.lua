-- server.lua

QBCore = exports['qb-core']:GetCoreObject()

-- Configuration
local Config = {
    AdminGroups = {
        'god',
        'admin',
        'mod'
    }
}

-- Helper function to check if player is admin
local function IsPlayerAdmin(src)
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return false end
    
    local playerGroup = QBCore.Functions.GetPermission(src)
    
    for _, group in pairs(Config.AdminGroups) do
        if playerGroup == group then
            return true
        end
    end
    
    return false
end

-- Toggle Duty Event Handler
RegisterNetEvent('Toggle:Duty', function(job, dutyState)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if Player then
        local jobName = Player.PlayerData.job.name

        if job == jobName then
            -- Set duty state based on the command (true = on duty, false = off duty)
            if dutyState == true then
                Player.Functions.SetJobDuty(true)
                TriggerClientEvent('QBCore:Notify', src, "You are now on duty.", "success")
            else
                Player.Functions.SetJobDuty(false)
                TriggerClientEvent('QBCore:Notify', src, "You are now off duty.", "error")
            end
        else
            TriggerClientEvent('QBCore:Notify', src, "You cannot toggle duty for this job.", "error")
        end
    end
end)

-- Admin Permission Check
RegisterNetEvent('admin:checkPermissions', function()
    local src = source
    
    if IsPlayerAdmin(src) then
        TriggerClientEvent('admin:openMenu', src)
    else
        TriggerClientEvent('QBCore:Notify', src, "You don't have permission to access the admin menu!", "error")
    end
end)

-- Admin Vehicle Spawning
RegisterNetEvent('admin:spawnVehicleServer', function(vehicleModel)
    local src = source
    
    if not IsPlayerAdmin(src) then
        TriggerClientEvent('QBCore:Notify', src, "No permission!", "error")
        return
    end
    
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    
    -- Validate vehicle model
    if not IsModelInCdimage(vehicleModel) or not IsModelAVehicle(vehicleModel) then
        TriggerClientEvent('QBCore:Notify', src, "Invalid vehicle model!", "error")
        return
    end
    
    TriggerClientEvent('QBCore:Command:SpawnVehicle', src, vehicleModel)
    TriggerClientEvent('QBCore:Notify', src, "Vehicle spawned: " .. vehicleModel, "success")
end)

-- Give Money
RegisterNetEvent('admin:giveMoneyServer', function(targetId, amount, moneyType)
    local src = source
    
    if not IsPlayerAdmin(src) then
        TriggerClientEvent('QBCore:Notify', src, "No permission!", "error")
        return
    end
    
    local targetPlayer = QBCore.Functions.GetPlayer(tonumber(targetId))
    if not targetPlayer then
        TriggerClientEvent('QBCore:Notify', src, "Player not found!", "error")
        return
    end
    
    if amount <= 0 then
        TriggerClientEvent('QBCore:Notify', src, "Amount must be greater than 0!", "error")
        return
    end
    
    targetPlayer.Functions.AddMoney(moneyType, amount, "Admin gave money")
    TriggerClientEvent('QBCore:Notify', src, "Gave $" .. amount .. " " .. moneyType .. " to " .. targetPlayer.PlayerData.charinfo.firstname .. " " .. targetPlayer.PlayerData.charinfo.lastname, "success")
    TriggerClientEvent('QBCore:Notify', targetId, "You received $" .. amount .. " " .. moneyType .. " from an admin", "success")
end)

-- Give Item
RegisterNetEvent('admin:giveItemServer', function(targetId, itemName, amount)
    local src = source
    
    if not IsPlayerAdmin(src) then
        TriggerClientEvent('QBCore:Notify', src, "No permission!", "error")
        return
    end
    
    local targetPlayer = QBCore.Functions.GetPlayer(tonumber(targetId))
    if not targetPlayer then
        TriggerClientEvent('QBCore:Notify', src, "Player not found!", "error")
        return
    end
    
    if amount <= 0 then
        TriggerClientEvent('QBCore:Notify', src, "Amount must be greater than 0!", "error")
        return
    end
    
    -- Check if item exists in shared items
    local item = QBCore.Shared.Items[itemName:lower()]
    if not item then
        TriggerClientEvent('QBCore:Notify', src, "Item doesn't exist!", "error")
        return
    end
    
    targetPlayer.Functions.AddItem(itemName, amount)
    TriggerClientEvent('QBCore:Notify', src, "Gave " .. amount .. "x " .. item.label .. " to " .. targetPlayer.PlayerData.charinfo.firstname .. " " .. targetPlayer.PlayerData.charinfo.lastname, "success")
    TriggerClientEvent('QBCore:Notify', targetId, "You received " .. amount .. "x " .. item.label .. " from an admin", "success")
    TriggerClientEvent('inventory:client:ItemBox', targetId, item, "add")
end)

-- Kick Player
RegisterNetEvent('admin:kickPlayer', function(targetId, reason)
    local src = source
    
    if not IsPlayerAdmin(src) then
        TriggerClientEvent('QBCore:Notify', src, "No permission!", "error")
        return
    end
    
    local targetPlayer = QBCore.Functions.GetPlayer(tonumber(targetId))
    if not targetPlayer then
        TriggerClientEvent('QBCore:Notify', src, "Player not found!", "error")
        return
    end
    
    reason = reason or "No reason provided"
    DropPlayer(targetId, "You have been kicked: " .. reason)
    TriggerClientEvent('QBCore:Notify', src, "Player kicked successfully", "success")
end)

-- Ban Player (Simple implementation - you might want to integrate with your ban system)
RegisterNetEvent('admin:banPlayer', function(targetId, reason, duration)
    local src = source
    
    if not IsPlayerAdmin(src) then
        TriggerClientEvent('QBCore:Notify', src, "No permission!", "error")
        return
    end
    
    local targetPlayer = QBCore.Functions.GetPlayer(tonumber(targetId))
    if not targetPlayer then
        TriggerClientEvent('QBCore:Notify', src, "Player not found!", "error")
        return
    end
    
    reason = reason or "No reason provided"
    duration = duration or "Permanent"
    
    -- This is a basic implementation - integrate with your actual ban system
    local targetLicense = QBCore.Functions.GetIdentifier(targetId, 'license')
    
    -- You would typically save this to database
    -- For now, just kick the player
    DropPlayer(targetId, "You have been banned: " .. reason .. " | Duration: " .. duration)
    TriggerClientEvent('QBCore:Notify', src, "Player banned successfully", "success")
end)

-- Teleport to Player
RegisterNetEvent('admin:teleportToPlayer', function(targetId)
    local src = source
    
    if not IsPlayerAdmin(src) then
        TriggerClientEvent('QBCore:Notify', src, "No permission!", "error")
        return
    end
    
    local targetPlayer = QBCore.Functions.GetPlayer(tonumber(targetId))
    if not targetPlayer then
        TriggerClientEvent('QBCore:Notify', src, "Player not found!", "error")
        return
    end
    
    local targetPed = GetPlayerPed(targetId)
    local targetCoords = GetEntityCoords(targetPed)
    
    TriggerClientEvent('QBCore:Command:GoToMarker', src, targetCoords)
    TriggerClientEvent('QBCore:Notify', src, "Teleported to " .. targetPlayer.PlayerData.charinfo.firstname .. " " .. targetPlayer.PlayerData.charinfo.lastname, "success")
end)

-- Bring Player
RegisterNetEvent('admin:bringPlayer', function(targetId)
    local src = source
    
    if not IsPlayerAdmin(src) then
        TriggerClientEvent('QBCore:Notify', src, "No permission!", "error")
        return
    end
    
    local targetPlayer = QBCore.Functions.GetPlayer(tonumber(targetId))
    if not targetPlayer then
        TriggerClientEvent('QBCore:Notify', src, "Player not found!", "error")
        return
    end
    
    local adminPed = GetPlayerPed(src)
    local adminCoords = GetEntityCoords(adminPed)
    
    TriggerClientEvent('QBCore:Command:GoToMarker', targetId, adminCoords)
    TriggerClientEvent('QBCore:Notify', src, "Brought " .. targetPlayer.PlayerData.charinfo.firstname .. " " .. targetPlayer.PlayerData.charinfo.lastname .. " to you", "success")
    TriggerClientEvent('QBCore:Notify', targetId, "You have been teleported by an admin", "info")
end)

-- Server Announcement
RegisterNetEvent('admin:serverAnnounce', function(message)
    local src = source
    
    if not IsPlayerAdmin(src) then
        TriggerClientEvent('QBCore:Notify', src, "No permission!", "error")
        return
    end
    
    if not message or message == "" then
        TriggerClientEvent('QBCore:Notify', src, "Please provide a message!", "error")
        return
    end
    
    TriggerClientEvent('chat:addMessage', -1, {
        color = {255, 0, 0},
        multiline = true,
        args = {"[ADMIN ANNOUNCEMENT]", message}
    })
    
    TriggerClientEvent('QBCore:Notify', src, "Announcement sent", "success")
end)

-- Restart Resource
RegisterNetEvent('admin:restartResource', function(resourceName)
    local src = source
    
    if not IsPlayerAdmin(src) then
        TriggerClientEvent('QBCore:Notify', src, "No permission!", "error")
        return
    end
    
    if not resourceName or resourceName == "" then
        TriggerClientEvent('QBCore:Notify', src, "Please provide a resource name!", "error")
        return
    end
    
    if GetResourceState(resourceName) == "missing" then
        TriggerClientEvent('QBCore:Notify', src, "Resource not found!", "error")
        return
    end
    
    StopResource(resourceName)
    Wait(1000)
    StartResource(resourceName)
    
    TriggerClientEvent('QBCore:Notify', src, "Resource '" .. resourceName .. "' restarted", "success")
end)

-- Get Online Players (for admin use)
RegisterNetEvent('admin:getOnlinePlayers', function()
    local src = source
    
    if not IsPlayerAdmin(src) then
        TriggerClientEvent('QBCore:Notify', src, "No permission!", "error")
        return
    end
    
    local players = {}
    local QBPlayers = QBCore.Functions.GetQBPlayers()
    
    for k, v in pairs(QBPlayers) do
        players[#players + 1] = {
            id = k,
            name = v.PlayerData.charinfo.firstname .. " " .. v.PlayerData.charinfo.lastname,
            citizenid = v.PlayerData.citizenid,
            job = v.PlayerData.job.name
        }
    end
    
    TriggerClientEvent('admin:receivePlayerList', src, players)
end)

-- Remove Money
RegisterNetEvent('admin:removeMoneyServer', function(targetId, amount, moneyType)
    local src = source
    
    if not IsPlayerAdmin(src) then
        TriggerClientEvent('QBCore:Notify', src, "No permission!", "error")
        return
    end
    
    local targetPlayer = QBCore.Functions.GetPlayer(tonumber(targetId))
    if not targetPlayer then
        TriggerClientEvent('QBCore:Notify', src, "Player not found!", "error")
        return
    end
    
    if amount <= 0 then
        TriggerClientEvent('QBCore:Notify', src, "Amount must be greater than 0!", "error")
        return
    end
    
    if targetPlayer.Functions.RemoveMoney(moneyType, amount, "Admin removed money") then
        TriggerClientEvent('QBCore:Notify', src, "Removed $" .. amount .. " " .. moneyType .. " from " .. targetPlayer.PlayerData.charinfo.firstname .. " " .. targetPlayer.PlayerData.charinfo.lastname, "success")
        TriggerClientEvent('QBCore:Notify', targetId, "An admin removed $" .. amount .. " " .. moneyType .. " from you", "error")
    else
        TriggerClientEvent('QBCore:Notify', src, "Player doesn't have enough money!", "error")
    end
end)

-- Remove Item
RegisterNetEvent('admin:removeItemServer', function(targetId, itemName, amount)
    local src = source
    
    if not IsPlayerAdmin(src) then
        TriggerClientEvent('QBCore:Notify', src, "No permission!", "error")
        return
    end
    
    local targetPlayer = QBCore.Functions.GetPlayer(tonumber(targetId))
    if not targetPlayer then
        TriggerClientEvent('QBCore:Notify', src, "Player not found!", "error")
        return
    end
    
    if amount <= 0 then
        TriggerClientEvent('QBCore:Notify', src, "Amount must be greater than 0!", "error")
        return
    end
    
    -- Check if item exists in shared items
    local item = QBCore.Shared.Items[itemName:lower()]
    if not item then
        TriggerClientEvent('QBCore:Notify', src, "Item doesn't exist!", "error")
        return
    end
    
    if targetPlayer.Functions.RemoveItem(itemName, amount) then
        TriggerClientEvent('QBCore:Notify', src, "Removed " .. amount .. "x " .. item.label .. " from " .. targetPlayer.PlayerData.charinfo.firstname .. " " .. targetPlayer.PlayerData.charinfo.lastname, "success")
        TriggerClientEvent('QBCore:Notify', targetId, "An admin removed " .. amount .. "x " .. item.label .. " from you", "error")
        TriggerClientEvent('inventory:client:ItemBox', targetId, item, "remove")
    else
        TriggerClientEvent('QBCore:Notify', src, "Player doesn't have enough of this item!", "error")
    end
end)
