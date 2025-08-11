-- fxmanifest.lua
fx_version 'cerulean'
game 'gta5'

author 'n1k0'
description 'Toggle Duty Script with Admin Menu for QBCore'
version '1.0.0'

dependencies {
    'qb-core',
    'qb-menu',
    'qb-input'
}

client_scripts {
    'client.lua',
}

server_scripts {
    '@mysql-async/lib/MySQL.lua', -- if you use MySQL async
    'server.lua',
}
