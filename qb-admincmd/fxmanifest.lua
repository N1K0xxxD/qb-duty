fx_version 'cerulean'
game 'gta5'

name 'qb-admincmd'
description 'Simple /admin menu opener for QBCore'
author 'cursor-gpt'
version '1.0.0'

lua54 'yes'

shared_scripts {
  'config.lua'
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