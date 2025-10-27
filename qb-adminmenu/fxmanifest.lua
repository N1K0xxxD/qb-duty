fx_version 'cerulean'

game 'gta5'

author 'Cursor AI'
description 'Simple Admin Menu using qb-menu for QBCore'

lua54 'yes'

shared_scripts {
    '@qb-core/shared/locale.lua'
}

client_scripts {
    'client.lua'
}

server_scripts {
    'server.lua'
}

dependencies {
    'qb-core',
    'qb-menu'
}