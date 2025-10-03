-- client.lua

QBCore = exports['qb-core']:GetCoreObject()

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

-- Register Key Mapping (Optional)
RegisterKeyMapping('onduty', 'Go On Duty', 'keyboard', 'F6')  -- Keybind for On Duty
RegisterKeyMapping('offduty', 'Go Off Duty', 'keyboard', 'F7') -- Keybind for Off Duty

-- Admin Menu Command
RegisterCommand('admin', function()
    TriggerServerEvent('admin:checkPermissions')
end, false)

-- Open Admin Menu Event
RegisterNetEvent('admin:openMenu', function()
    OpenAdminMenu()
end)

-- Admin Menu Function
function OpenAdminMenu()
    local adminMenu = {
        {
            header = "🛡️ Admin Menu",
            isMenuHeader = true
        },
        {
            header = "👤 Player Management",
            txt = "Manage players on the server",
            params = {
                event = "admin:playerManagement"
            }
        },
        {
            header = "🚗 Vehicle Management",
            txt = "Spawn and manage vehicles",
            params = {
                event = "admin:vehicleManagement"
            }
        },
        {
            header = "💰 Money Management",
            txt = "Give/remove money from players",
            params = {
                event = "admin:moneyManagement"
            }
        },
        {
            header = "📦 Item Management",
            txt = "Give items to players",
            params = {
                event = "admin:itemManagement"
            }
        },
        {
            header = "🔧 Server Management",
            txt = "Server tools and utilities",
            params = {
                event = "admin:serverManagement"
            }
        },
        {
            header = "❌ Close Menu",
            txt = "Close the admin menu",
            params = {
                event = "qb-menu:client:closeMenu"
            }
        }
    }
    
    exports['qb-menu']:openMenu(adminMenu)
end

-- Player Management Menu
RegisterNetEvent('admin:playerManagement', function()
    local playerMenu = {
        {
            header = "👤 Player Management",
            isMenuHeader = true
        },
        {
            header = "👁️ Spectate Player",
            txt = "Spectate a specific player",
            params = {
                event = "admin:spectatePlayer"
            }
        },
        {
            header = "🚫 Kick Player",
            txt = "Kick a player from the server",
            params = {
                event = "admin:kickPlayer"
            }
        },
        {
            header = "🔨 Ban Player",
            txt = "Ban a player from the server",
            params = {
                event = "admin:banPlayer"
            }
        },
        {
            header = "📍 Teleport to Player",
            txt = "Teleport to a specific player",
            params = {
                event = "admin:teleportToPlayer"
            }
        },
        {
            header = "📍 Bring Player",
            txt = "Bring a player to your location",
            params = {
                event = "admin:bringPlayer"
            }
        },
        {
            header = "⬅️ Back",
            txt = "Return to main admin menu",
            params = {
                event = "admin:openMenu"
            }
        }
    }
    
    exports['qb-menu']:openMenu(playerMenu)
end)

-- Vehicle Management Menu
RegisterNetEvent('admin:vehicleManagement', function()
    local vehicleMenu = {
        {
            header = "🚗 Vehicle Management",
            isMenuHeader = true
        },
        {
            header = "🚗 Spawn Vehicle",
            txt = "Spawn a vehicle by model name",
            params = {
                event = "admin:spawnVehicle"
            }
        },
        {
            header = "🔧 Fix Vehicle",
            txt = "Repair current vehicle",
            params = {
                event = "admin:fixVehicle"
            }
        },
        {
            header = "🗑️ Delete Vehicle",
            txt = "Delete current vehicle",
            params = {
                event = "admin:deleteVehicle"
            }
        },
        {
            header = "⬅️ Back",
            txt = "Return to main admin menu",
            params = {
                event = "admin:openMenu"
            }
        }
    }
    
    exports['qb-menu']:openMenu(vehicleMenu)
end)

-- Money Management Menu
RegisterNetEvent('admin:moneyManagement', function()
    local moneyMenu = {
        {
            header = "💰 Money Management",
            isMenuHeader = true
        },
        {
            header = "💵 Give Cash",
            txt = "Give cash to a player",
            params = {
                event = "admin:giveMoney",
                args = {type = "cash"}
            }
        },
        {
            header = "🏦 Give Bank Money",
            txt = "Give bank money to a player",
            params = {
                event = "admin:giveMoney",
                args = {type = "bank"}
            }
        },
        {
            header = "❌ Remove Money",
            txt = "Remove money from a player",
            params = {
                event = "admin:removeMoney"
            }
        },
        {
            header = "⬅️ Back",
            txt = "Return to main admin menu",
            params = {
                event = "admin:openMenu"
            }
        }
    }
    
    exports['qb-menu']:openMenu(moneyMenu)
end)

-- Item Management Menu
RegisterNetEvent('admin:itemManagement', function()
    local itemMenu = {
        {
            header = "📦 Item Management",
            isMenuHeader = true
        },
        {
            header = "📦 Give Item",
            txt = "Give an item to a player",
            params = {
                event = "admin:giveItem"
            }
        },
        {
            header = "🗑️ Remove Item",
            txt = "Remove an item from a player",
            params = {
                event = "admin:removeItem"
            }
        },
        {
            header = "⬅️ Back",
            txt = "Return to main admin menu",
            params = {
                event = "admin:openMenu"
            }
        }
    }
    
    exports['qb-menu']:openMenu(itemMenu)
end)

-- Server Management Menu
RegisterNetEvent('admin:serverManagement', function()
    local serverMenu = {
        {
            header = "🔧 Server Management",
            isMenuHeader = true
        },
        {
            header = "🔄 Restart Resource",
            txt = "Restart a specific resource",
            params = {
                event = "admin:restartResource"
            }
        },
        {
            header = "📢 Announce",
            txt = "Send a server-wide announcement",
            params = {
                event = "admin:serverAnnounce"
            }
        },
        {
            header = "🌙 Toggle Noclip",
            txt = "Toggle noclip mode",
            params = {
                event = "admin:toggleNoclip"
            }
        },
        {
            header = "👻 Toggle Invisible",
            txt = "Toggle invisibility",
            params = {
                event = "admin:toggleInvisible"
            }
        },
        {
            header = "⬅️ Back",
            txt = "Return to main admin menu",
            params = {
                event = "admin:openMenu"
            }
        }
    }
    
    exports['qb-menu']:openMenu(serverMenu)
end)

-- Admin Action Events
RegisterNetEvent('admin:spawnVehicle', function()
    local dialog = exports['qb-input']:ShowInput({
        header = "Spawn Vehicle",
        submitText = "Spawn",
        inputs = {
            {
                text = "Vehicle Model",
                name = "vehicle",
                type = "text",
                isRequired = true
            }
        }
    })
    
    if dialog then
        TriggerServerEvent('admin:spawnVehicleServer', dialog.vehicle)
    end
end)

RegisterNetEvent('admin:fixVehicle', function()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    
    if vehicle ~= 0 then
        SetVehicleFixed(vehicle)
        SetVehicleDeformationFixed(vehicle)
        SetVehicleUndriveable(vehicle, false)
        SetVehicleEngineOn(vehicle, true, true)
        QBCore.Functions.Notify("Vehicle repaired!", "success")
    else
        QBCore.Functions.Notify("You are not in a vehicle!", "error")
    end
end)

RegisterNetEvent('admin:deleteVehicle', function()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    
    if vehicle ~= 0 then
        DeleteVehicle(vehicle)
        QBCore.Functions.Notify("Vehicle deleted!", "success")
    else
        QBCore.Functions.Notify("You are not in a vehicle!", "error")
    end
end)

RegisterNetEvent('admin:giveMoney', function(data)
    local dialog = exports['qb-input']:ShowInput({
        header = "Give Money",
        submitText = "Give",
        inputs = {
            {
                text = "Player ID",
                name = "playerid",
                type = "number",
                isRequired = true
            },
            {
                text = "Amount",
                name = "amount",
                type = "number",
                isRequired = true
            }
        }
    })
    
    if dialog then
        TriggerServerEvent('admin:giveMoneyServer', dialog.playerid, dialog.amount, data.type)
    end
end)

RegisterNetEvent('admin:giveItem', function()
    local dialog = exports['qb-input']:ShowInput({
        header = "Give Item",
        submitText = "Give",
        inputs = {
            {
                text = "Player ID",
                name = "playerid",
                type = "number",
                isRequired = true
            },
            {
                text = "Item Name",
                name = "item",
                type = "text",
                isRequired = true
            },
            {
                text = "Amount",
                name = "amount",
                type = "number",
                isRequired = true
            }
        }
    })
    
    if dialog then
        TriggerServerEvent('admin:giveItemServer', dialog.playerid, dialog.item, dialog.amount)
    end
end)

-- Noclip functionality
local noclip = false
local noclipSpeed = 1.0

RegisterNetEvent('admin:toggleNoclip', function()
    noclip = not noclip
    local ped = PlayerPedId()
    
    if noclip then
        SetEntityInvincible(ped, true)
        SetEntityVisible(ped, false, false)
        QBCore.Functions.Notify("Noclip enabled", "success")
        
        CreateThread(function()
            while noclip do
                local ped = PlayerPedId()
                local coords = GetEntityCoords(ped)
                
                DisableControlAction(0, 30, true)
                DisableControlAction(0, 31, true)
                DisableControlAction(0, 32, true)
                DisableControlAction(0, 33, true)
                DisableControlAction(0, 34, true)
                DisableControlAction(0, 35, true)
                
                local x, y, z = table.unpack(coords)
                
                if IsDisabledControlPressed(0, 32) then -- W
                    x = x + noclipSpeed
                end
                if IsDisabledControlPressed(0, 33) then -- S
                    x = x - noclipSpeed
                end
                if IsDisabledControlPressed(0, 34) then -- A
                    y = y - noclipSpeed
                end
                if IsDisabledControlPressed(0, 35) then -- D
                    y = y + noclipSpeed
                end
                if IsDisabledControlPressed(0, 44) then -- Q
                    z = z + noclipSpeed
                end
                if IsDisabledControlPressed(0, 46) then -- E
                    z = z - noclipSpeed
                end
                
                SetEntityCoords(ped, x, y, z, false, false, false, false)
                Wait(0)
            end
        end)
    else
        SetEntityInvincible(ped, false)
        SetEntityVisible(ped, true, false)
        QBCore.Functions.Notify("Noclip disabled", "error")
    end
end)

-- Invisibility toggle
local invisible = false

RegisterNetEvent('admin:toggleInvisible', function()
    invisible = not invisible
    local ped = PlayerPedId()
    
    SetEntityVisible(ped, not invisible, false)
    
    if invisible then
        QBCore.Functions.Notify("You are now invisible", "success")
    else
        QBCore.Functions.Notify("You are now visible", "error")
    end
end)

-- Player Management Actions
RegisterNetEvent('admin:kickPlayer', function()
    local dialog = exports['qb-input']:ShowInput({
        header = "Kick Player",
        submitText = "Kick",
        inputs = {
            {
                text = "Player ID",
                name = "playerid",
                type = "number",
                isRequired = true
            },
            {
                text = "Reason",
                name = "reason",
                type = "text",
                isRequired = false
            }
        }
    })
    
    if dialog then
        TriggerServerEvent('admin:kickPlayer', dialog.playerid, dialog.reason)
    end
end)

RegisterNetEvent('admin:banPlayer', function()
    local dialog = exports['qb-input']:ShowInput({
        header = "Ban Player",
        submitText = "Ban",
        inputs = {
            {
                text = "Player ID",
                name = "playerid",
                type = "number",
                isRequired = true
            },
            {
                text = "Reason",
                name = "reason",
                type = "text",
                isRequired = false
            },
            {
                text = "Duration (hours, or 'permanent')",
                name = "duration",
                type = "text",
                isRequired = false
            }
        }
    })
    
    if dialog then
        TriggerServerEvent('admin:banPlayer', dialog.playerid, dialog.reason, dialog.duration)
    end
end)

RegisterNetEvent('admin:teleportToPlayer', function()
    local dialog = exports['qb-input']:ShowInput({
        header = "Teleport to Player",
        submitText = "Teleport",
        inputs = {
            {
                text = "Player ID",
                name = "playerid",
                type = "number",
                isRequired = true
            }
        }
    })
    
    if dialog then
        TriggerServerEvent('admin:teleportToPlayer', dialog.playerid)
    end
end)

RegisterNetEvent('admin:bringPlayer', function()
    local dialog = exports['qb-input']:ShowInput({
        header = "Bring Player",
        submitText = "Bring",
        inputs = {
            {
                text = "Player ID",
                name = "playerid",
                type = "number",
                isRequired = true
            }
        }
    })
    
    if dialog then
        TriggerServerEvent('admin:bringPlayer', dialog.playerid)
    end
end)

RegisterNetEvent('admin:spectatePlayer', function()
    local dialog = exports['qb-input']:ShowInput({
        header = "Spectate Player",
        submitText = "Spectate",
        inputs = {
            {
                text = "Player ID",
                name = "playerid",
                type = "number",
                isRequired = true
            }
        }
    })
    
    if dialog then
        local targetPed = GetPlayerPed(GetPlayerFromServerId(dialog.playerid))
        if targetPed and targetPed ~= 0 then
            local targetCoords = GetEntityCoords(targetPed)
            SetEntityCoords(PlayerPedId(), targetCoords.x, targetCoords.y, targetCoords.z + 10.0, false, false, false, false)
            QBCore.Functions.Notify("Spectating player " .. dialog.playerid, "success")
        else
            QBCore.Functions.Notify("Player not found!", "error")
        end
    end
end)

RegisterNetEvent('admin:removeMoney', function()
    local dialog = exports['qb-input']:ShowInput({
        header = "Remove Money",
        submitText = "Remove",
        inputs = {
            {
                text = "Player ID",
                name = "playerid",
                type = "number",
                isRequired = true
            },
            {
                text = "Amount",
                name = "amount",
                type = "number",
                isRequired = true
            },
            {
                text = "Money Type (cash/bank)",
                name = "type",
                type = "text",
                isRequired = true
            }
        }
    })
    
    if dialog then
        TriggerServerEvent('admin:removeMoneyServer', dialog.playerid, dialog.amount, dialog.type)
    end
end)

RegisterNetEvent('admin:removeItem', function()
    local dialog = exports['qb-input']:ShowInput({
        header = "Remove Item",
        submitText = "Remove",
        inputs = {
            {
                text = "Player ID",
                name = "playerid",
                type = "number",
                isRequired = true
            },
            {
                text = "Item Name",
                name = "item",
                type = "text",
                isRequired = true
            },
            {
                text = "Amount",
                name = "amount",
                type = "number",
                isRequired = true
            }
        }
    })
    
    if dialog then
        TriggerServerEvent('admin:removeItemServer', dialog.playerid, dialog.item, dialog.amount)
    end
end)

RegisterNetEvent('admin:restartResource', function()
    local dialog = exports['qb-input']:ShowInput({
        header = "Restart Resource",
        submitText = "Restart",
        inputs = {
            {
                text = "Resource Name",
                name = "resource",
                type = "text",
                isRequired = true
            }
        }
    })
    
    if dialog then
        TriggerServerEvent('admin:restartResource', dialog.resource)
    end
end)

RegisterNetEvent('admin:serverAnnounce', function()
    local dialog = exports['qb-input']:ShowInput({
        header = "Server Announcement",
        submitText = "Send",
        inputs = {
            {
                text = "Message",
                name = "message",
                type = "text",
                isRequired = true
            }
        }
    })
    
    if dialog then
        TriggerServerEvent('admin:serverAnnounce', dialog.message)
    end
end)
