lua54 'yes'
game 'gta5'
fx_version 'adamant'

client_scripts {
    '@es_extended/locale.lua',
    'client/client.lua',
    'config.lua'
}

server_scripts {
    '@es_extended/locale.lua',
    '@oxmysql/lib/MySQL.lua',
    'server/server.lua',
    'config.lua'
}

dependencies {
    'es_extended',
    'ox_lib'
}

shared_scripts {
    '@es_extended/imports.lua', -- Remove this out if using older ESX
    '@ox_lib/init.lua',
  }
  




server_scripts { '@mysql-async/lib/MySQL.lua' }