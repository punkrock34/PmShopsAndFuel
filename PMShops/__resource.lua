resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

author 'pmdevmods'
description 'PM Shops'
version '1.0'

ui_page('html/index.html') 

files({
  'html/script.js',
  'html/jquery.thermometer.js',
  'html/index.html',
  'html/css/style.css',
  'html/css/jquery-ui.min.css',
  'html/img/*.png',
  'html/img/*.jpg',
})

client_scripts {
  'config.lua',
  'client/main.lua',
  '@es_extended/locale.lua',
  'locales/en.lua',
  'locales/fr.lua',	
  'locales/sv.lua',
}

server_scripts {
  '@mysql-async/lib/MySQL.lua',
  'config.lua',
  'server/main.lua'
}