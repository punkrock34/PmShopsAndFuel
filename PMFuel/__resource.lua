fx_version 'bodacious'
game 'gta5'

author 'pmdevmods'
description 'PM Fuel'
version '1.0'

-- What to run
server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'config.lua',
	'source/server.lua'
}

client_scripts {
	'config.lua',
	'functions/functions.lua',
	'source/client.lua'
}


exports {
	'GetFuel',
	'SetFuel'
}