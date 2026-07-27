fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'nc-base'
author 'NoCapScripts'
version '1.0.1'
description 'Custom FiveM framework TypeScriptis: playerid, jobid, gangid ja events'

-- oxmysql on andmebaasi jaoks kohustuslik dependency
dependency 'oxmysql'

server_scripts {
  '@oxmysql/lib/MySQL.lua',
  'dist/server/server.js'
}

client_scripts {
  'dist/client/client.js'
}

-- kliendi <-> serveri jagatud data (nt configid) ekspordiks
exports {
  'GetPlayerData'
}

server_exports {
  'GetPlayerData',
  'GetJob',
  'GetGang',
  'regCommand'
}
