fx_version "adamant"

games { 'rdr3' }

rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'


server_scripts {
    'server/CampfireManagement.lua',
    'server/server.lua',
    'server/Crafting.lua'
}
shared_script{
    'CampFire.lua',
    'config.lua'
}
client_scripts {
    'client/CampfireManagement.lua',
	'client/client.lua',
    'client/Crafting.lua',
    'warmenu.lua'
}