fx_version 'cerulean'
game 'gta5'

lua54 'yes'

name 'nc-base'
author 'NoCapScripts'
version '1.0.2'
description 'Custom FiveM TypeScript framework with players, jobs, gangs, vehicles, commands and permissions'


-- Dependencies

dependency 'oxmysql'
dependency 'ox_lib'
dependency 'ox_inventory'


-- Shared

shared_scripts {

}


-- Server

server_scripts {

    '@oxmysql/lib/MySQL.lua',

    'dist/server/server.js'

}



-- Client

client_scripts {

    'dist/client/client.js'

}



-- Server Exports

server_exports {

    -- Player

    'GetPlayerData',


    -- Jobs / gangs

    'GetJob',

    'GetGang',



    -- Commands

    'regCommand',



    -- Vehicles

    'GetVehicle',

    'GetPlayerVehicles',

    'AddVehicle',

    'StoreVehicle',

    'TakeOutVehicle',

    'RemoveVehicle',

    'SaveVehicle',

    'SetVehicleFuel'

}
