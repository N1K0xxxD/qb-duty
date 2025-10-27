local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('qbadmincmd:client:openMenu', function()
    local menu = {
        { header = 'Admin Menu', isMenuHeader = true },
        {
            header = 'Teleport to Waypoint',
            txt = 'Teleport to your map waypoint',
            params = { event = 'qbadmincmd:client:tpToWaypoint' }
        },
        {
            header = 'Revive Self',
            txt = 'Revive your ped',
            params = { event = 'qbadmincmd:client:reviveSelf' }
        },
        {
            header = 'Toggle Noclip',
            txt = 'Toggle simple noclip mode',
            params = { event = 'qbadmincmd:client:toggleNoclip' }
        },
        { header = 'Close', params = { event = 'qb-menu:client:closeMenu' } }
    }
    exports['qb-menu']:openMenu(menu)
end)

-- Teleport to waypoint
RegisterNetEvent('qbadmincmd:client:tpToWaypoint', function()
    local waypointBlip = GetFirstBlipInfoId(8)
    if not DoesBlipExist(waypointBlip) then
        QBCore.Functions.Notify('No waypoint set.', 'error')
        return
    end

    local coords = GetBlipInfoIdCoord(waypointBlip)
    local foundGround = false
    local groundZ = 0.0

    for height = 1, 1000 do
        SetPedCoordsKeepVehicle(PlayerPedId(), coords.x + 0.0, coords.y + 0.0, height + 0.0)
        foundGround, groundZ = GetGroundZFor_3dCoord(coords.x + 0.0, coords.y + 0.0, height + 0.0, false)
        if foundGround then
            SetPedCoordsKeepVehicle(PlayerPedId(), coords.x + 0.0, coords.y + 0.0, groundZ + 1.0)
            break
        end
        Wait(5)
    end

    if not foundGround then
        -- Fallback: place high in the air
        SetPedCoordsKeepVehicle(PlayerPedId(), coords.x + 0.0, coords.y + 0.0, 1200.0)
    end
end)

-- Revive self (simple local revive)
RegisterNetEvent('qbadmincmd:client:reviveSelf', function()
    local ped = PlayerPedId()
    SetEntityHealth(ped, 200)
    ClearPedTasksImmediately(ped)
    ResetPedRagdollTimer(ped)
    QBCore.Functions.Notify('Revived.', 'success')
end)

-- Simple noclip implementation
local noclipEnabled = false
local noclipSpeed = 1.5

local function handleNoclipTick()
    local ped = PlayerPedId()
    local x, y, z = table.unpack(GetEntityCoords(ped))

    -- Camera forward vector from heading
    local camRot = GetGameplayCamRot(2)
    local heading = math.rad(camRot.z)
    local forwardX = math.sin(heading)
    local forwardY = math.cos(heading)

    if IsControlPressed(0, 32) then -- W
        x = x + forwardX * noclipSpeed
        y = y + forwardY * noclipSpeed
    end
    if IsControlPressed(0, 33) then -- S
        x = x - forwardX * noclipSpeed
        y = y - forwardY * noclipSpeed
    end
    if IsControlPressed(0, 44) then -- Q
        z = z + noclipSpeed
    end
    if IsControlPressed(0, 20) then -- Z
        z = z - noclipSpeed
    end

    SetEntityCoordsNoOffset(ped, x, y, z, true, true, true)
end

local function setNoclip(enabled)
    local ped = PlayerPedId()
    if enabled then
        SetEntityInvincible(ped, true)
        SetEntityVisible(ped, false, false)
        SetEntityCollision(ped, false, false)
        FreezeEntityPosition(ped, true)
        CreateThread(function()
            while noclipEnabled do
                handleNoclipTick()
                Wait(0)
            end
        end)
    else
        SetEntityInvincible(ped, false)
        SetEntityVisible(ped, true, false)
        SetEntityCollision(ped, true, true)
        FreezeEntityPosition(ped, false)
    end
end

RegisterNetEvent('qbadmincmd:client:toggleNoclip', function()
    noclipEnabled = not noclipEnabled
    setNoclip(noclipEnabled)
    QBCore.Functions.Notify(noclipEnabled and 'Noclip enabled' or 'Noclip disabled', 'primary')
end)