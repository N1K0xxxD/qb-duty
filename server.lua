-- server.lua

QBCore = exports['qb-core']:GetCoreObject()

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
RegisterNetEvent('Admin:CheckPermission', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if Player then
        local adminLevel = Player.PlayerData.admin
        local players = {}
        
        -- Check if player has admin permissions
        if adminLevel and adminLevel > 0 then
            -- Get all online players
            local QBCorePlayers = QBCore.Functions.GetQBPlayers()
            for _, player in pairs(QBCorePlayers) do
                table.insert(players, {
                    id = player.PlayerData.source,
                    name = player.PlayerData.charinfo.firstname .. " " .. player.PlayerData.charinfo.lastname,
                    job = player.PlayerData.job.label,
                    grade = player.PlayerData.job.grade.level,
                    admin = player.PlayerData.admin or 0
                })
            end
            
            TriggerClientEvent('Admin:OpenMenu', src, players, adminLevel)
        else
            TriggerClientEvent('QBCore:Notify', src, "You don't have permission to access the admin menu.", "error")
        end
    end
end)

-- Admin Actions
RegisterNetEvent('Admin:TeleportToPlayer', function(targetId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local Target = QBCore.Functions.GetPlayer(targetId)
    
    if Player and Target and Player.PlayerData.admin and Player.PlayerData.admin > 0 then
        local targetCoords = GetEntityCoords(GetPlayerPed(targetId))
        SetEntityCoords(GetPlayerPed(src), targetCoords.x, targetCoords.y, targetCoords.z)
        TriggerClientEvent('QBCore:Notify', src, "Teleported to player.", "success")
    end
end)

RegisterNetEvent('Admin:BringPlayer', function(targetId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local Target = QBCore.Functions.GetPlayer(targetId)
    
    if Player and Target and Player.PlayerData.admin and Player.PlayerData.admin > 0 then
        local adminCoords = GetEntityCoords(GetPlayerPed(src))
        SetEntityCoords(GetPlayerPed(targetId), adminCoords.x, adminCoords.y, adminCoords.z)
        TriggerClientEvent('QBCore:Notify', targetId, "You have been brought by an admin.", "info")
        TriggerClientEvent('QBCore:Notify', src, "Player brought to you.", "success")
    end
end)

RegisterNetEvent('Admin:KickPlayer', function(targetId, reason)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if Player and Player.PlayerData.admin and Player.PlayerData.admin > 0 then
        reason = reason or "Kicked by admin"
        DropPlayer(targetId, reason)
        TriggerClientEvent('QBCore:Notify', src, "Player kicked.", "success")
    end
end)

RegisterNetEvent('Admin:BanPlayer', function(targetId, reason, duration)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if Player and Player.PlayerData.admin and Player.PlayerData.admin > 0 then
        reason = reason or "Banned by admin"
        duration = duration or 0 -- 0 = permanent
        
        -- This is a basic ban implementation
        -- You might want to integrate with your existing ban system
        MySQL.insert('INSERT INTO bans (name, license, discord, ip, reason, expire, bannedby) VALUES (?, ?, ?, ?, ?, ?, ?)', {
            GetPlayerName(targetId),
            GetPlayerIdentifiers(targetId)[1],
            GetPlayerIdentifiers(targetId)[3],
            GetPlayerEndpoint(targetId),
            reason,
            duration > 0 and os.time() + duration or 2147483647,
            Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname
        })
        
        DropPlayer(targetId, reason)
        TriggerClientEvent('QBCore:Notify', src, "Player banned.", "success")
    end
end)

RegisterNetEvent('Admin:SpectatePlayer', function(targetId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if Player and Player.PlayerData.admin and Player.PlayerData.admin > 0 then
        TriggerClientEvent('Admin:StartSpectate', src, targetId)
    end
end)

RegisterNetEvent('Admin:HealPlayer', function(targetId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if Player and Player.PlayerData.admin and Player.PlayerData.admin > 0 then
        TriggerClientEvent('Admin:Heal', targetId)
        TriggerClientEvent('QBCore:Notify', src, "Player healed.", "success")
        TriggerClientEvent('QBCore:Notify', targetId, "You have been healed by an admin.", "success")
    end
end)

RegisterNetEvent('Admin:RevivePlayer', function(targetId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if Player and Player.PlayerData.admin and Player.PlayerData.admin > 0 then
        TriggerClientEvent('Admin:Revive', targetId)
        TriggerClientEvent('QBCore:Notify', src, "Player revived.", "success")
        TriggerClientEvent('QBCore:Notify', targetId, "You have been revived by an admin.", "success")
    end
end)

RegisterNetEvent('Admin:FreezePlayer', function(targetId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if Player and Player.PlayerData.admin and Player.PlayerData.admin > 0 then
        TriggerClientEvent('Admin:Freeze', targetId)
        TriggerClientEvent('QBCore:Notify', src, "Player freeze toggled.", "success")
    end
end)
