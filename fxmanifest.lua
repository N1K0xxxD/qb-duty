-- fxmanifest.lua
fx_version 'cerulean'
game 'gta5'

author 'n1k0'
description 'Toggle Duty Script & Admin Menu for QBCore'
version '0.0.2'

client_scripts {
    'client.lua',
}

server_scripts {
    '@mysql-async/lib/MySQL.lua', -- if you use MySQL async
    'server.lua',
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js'
}
