CampFireList = {}
BurnOutList = {}

VorpCore = {}
VorpInv = {}

local fireManager

VorpInv = exports.vorp_inventory:vorp_inventoryApi()
TriggerEvent("getCore",function(core)
    VorpCore = core
end)

Citizen.CreateThread(function() 
    if(Config.Debug)then
        while true do
            print()
            print("Liste feu Allumé:")
            for i,v in pairs(CampFireList)do
                v.print()
            end

            print()
            print("Liste feu éteint:")
            for i,v in pairs(BurnOutList)do
                v.print()
            end
            Citizen.Wait(30000)
        end
    end
end)

function GetDistanceBetweenCoords(coords1, coords2, is3D)
    if(is3D)then
        local dx = coords1.x - coords2.x
        local dy = coords1.y - coords2.y
        local dz = coords1.z - coords2.z
        return math.sqrt (dx * dx + dy * dy + dz * dz)
    else
        local dx = coords1.x - coords2.x
        local dy = coords1.y - coords2.y
        return math.sqrt (dx * dx + dy * dy)
    end
end    


RegisterNetEvent('CampFire:GetUserJob')
AddEventHandler('CampFire:GetUserJob', function()
    local _source = source
    local User = VorpCore.getUser(_source)
    local _userJob = User.getUsedCharacter.job

    TriggerClientEvent('CampFire:setUserJob', _source, _userJob)
end)


RegisterNetEvent('CampFire:SetManager')
AddEventHandler('CampFire:SetManager', function()
    local _source = source
    fireManager = _source
end)