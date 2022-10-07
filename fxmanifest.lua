fx_version 'bodacious'
game 'gta5'

author 'Techy'
description 'FiveZ Main'
version '1.0.0'

client_scripts { 
    'config.lua', 
    'client/main.lua',
    'client/spawnmanager.lua',
    'client/inventory.lua',
    'client/zombie.lua',
    'client/notificationmanager.lua',
    'client/cuffs.lua',
    'client/contextmenu.lua',
    'client/skills.lua',
    'client/persistentobjects.lua',
    'client/airdrop.lua',
    'client/interiorportals.lua'
}

server_scripts { 
    'config.lua', 
    '@mysql-async/lib/mysql.lua', 
    'server/main.lua',
    'server/connectionmanager.lua',
    'server/playerdata.lua',
    'server/characterdata.lua',
    'server/persistentvehicles.lua',
    'server/persistentcrates.lua',
    'server/inventory.lua',
    'server/zombiespawner.lua',
    'server/ammo.lua',
    'server/cuffs.lua',
    'server/skills.lua',
    'server/persistentobjects.lua',
    'server/airdrop.lua',
    'server/characterproficiency.lua'
}

ui_page 'interface/index.html'

files {
	--INTERFACE
	'interface/index.html',
	'interface/listener.js',
	'interface/loader.js',
	--HTML pages and CSS
    'interface/pages/*.css',
    'interface/pages/*.html',
	--Javascript
    'interface/scripts/*.js',
    'interface/assets/inventory/*.png',
    'interface/assets/inventory/bandage.png',
	--HTML Interface Assets
	'interface/assets/libraries/axios.min.js',
	'interface/assets/libraries/vue.min.js',
	'interface/assets/libraries/vuetify.min.css',
	'interface/assets/libraries/vuetify.min.js',
    'interface/assets/libraries/jquery-3.6.0.min.js',
	--Cardealer/Garage pictures
    'interface/assets/gunshop/*.png',
    'interface/assets/vehicles/*.png'
}