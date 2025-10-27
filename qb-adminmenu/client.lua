local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('qb-adminmenu:client:openMenu', function()
    local menu = {
        {
            header = 'Admin Menu',
            isMenuHeader = true
        },
        {
            header = 'Teleport to Waypoint',
            txt = 'Teleport to your current waypoint',
            params = {
                event = 'qb-adminmenu:client:teleportToWaypoint'
            }
        },
        {
            header = 'Revive Self',
            txt = 'Revive yourself instantly',
            params = {
                isServer = false,
                event = 'hospital:client:Revive'
            }
        },
        {
            header = 'Close',
            txt = '',
            params = {
                event = 'qb-menu:closeMenu'
            }
        }
    }

    exports['qb-menu']:openMenu(menu)
end)

RegisterNetEvent('qb-adminmenu:client:teleportToWaypoint', function()
    local ped = PlayerPedId()
    local waypoint = GetFirstBlipInfoId(8)
    if DoesBlipExist(waypoint) then
        local coord = GetBlipInfoIdCoord(waypoint)
        FreezeEntityPosition(ped, true)
        SetEntityCoordsNoOffset(ped, coord.x, coord.y, coord.z, false, false, false)
        local timeout = 0
        while not HasCollisionLoadedAroundEntity(ped) and timeout < 5000 do
            Wait(10)
            timeout = timeout + 10
        end
        FreezeEntityPosition(ped, false)
    else
        QBCore.Functions.Notify('No waypoint found', 'error')
    end
end)