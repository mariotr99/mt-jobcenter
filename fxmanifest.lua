fx_version 'cerulean'
game 'gta5'

author 'mariotr_'
description 'qbcore Job Center'
version '1.0.0'

shared_scripts {
    'config.lua',
}

client_scripts {
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    'client/client.lua',
}

server_scripts {
    'server/server.lua',
}

files {
    'html/index.html',
    'html/style.css',
    'html/script.js',
    'html/fonts/AGENCYB.ttf',
    'html/img/*.png',
    'html/sounds/click.mp3'
}

ui_page 'html/index.html'

dependencies {
    'qb-core',
    'PolyZone'
}
