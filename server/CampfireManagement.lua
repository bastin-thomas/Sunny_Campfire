--// Gestion Feu de Camp //--
--Thread de gestion des feux en marches
Citizen.CreateThread(function()
    while true do
        for i, v in pairs(CampFireList) do
            if(v.CampFireTimer > 0)then
                v.TimerDecreased()
                TriggerClientEvent('CampFire:RefreshClientList', -1, v.Coords.x, v.Coords.y, v.Coords.z, v.Prop, v.FireInProgress, v.CampFireTimer, v.EmberTimer)
            elseif(v.FireInProgress == true)then
                v.Stop()
                TriggerClientEvent('CampFire:RefreshClientList', -1, v.Coords.x, v.Coords.y, v.Coords.z, v.Prop, v.FireInProgress, v.CampFireTimer, v.EmberTimer)

                local bo = table.remove(CampFireList, i)
                BurnOutList[#BurnOutList+1] = bo
                TriggerClientEvent('CampFire:CampfireBurnOut', -1,  v.Coords.x, v.Coords.y, v.Coords.z)
            end
        end
        Wait(1000)
    end        
end)

--Thread de gestion des feux éteints
Citizen.CreateThread(function()
    while true do
        for i, v in pairs(BurnOutList) do
            if(v.EmberTimer > 0)then
                v.BurnOutDecreased()
                TriggerClientEvent('CampFire:RefreshClientBurnOut', -1, v.Coords.x, v.Coords.y, v.Coords.z, v.Prop, v.FireInProgress, v.CampFireTimer, v.EmberTimer, v.restartInProgress)
            else
                TriggerClientEvent('CampFire:RefreshClientBurnOut', -1, v.Coords.x, v.Coords.y, v.Coords.z, v.Prop, v.FireInProgress, v.CampFireTimer, v.EmberTimer, v.restartInProgress)
                table.remove(BurnOutList, i)
            end
        end
        Wait(15000)
    end        
end)

-- Gestion Pose du Feu de Camp:
Citizen.CreateThread(function()
	VorpInv.RegisterUsableItem(Config.fireStarterItem, function(data)
        --Check si feu proche:
        local PlayerCoords = GetEntityCoords(GetPlayerPed(data.source))
        local found = false
        for i,v in pairs(CampFireList)do
            if(GetDistanceBetweenCoords(PlayerCoords, v.Coords, false) < 4.0 )then
                found = true
                break
            end
        end
        if(found == false)then
            for i,v in pairs(BurnOutList)do
                if(GetDistanceBetweenCoords(PlayerCoords, v.Coords, false) < 4.0 )then
                    found = true
                    break
                end
            end
        end
        if(found == true)then
            TriggerClientEvent("vorp:TipBottom", data.source, 'Eloignez vous du feu existant.', 4500)
            return        
        end
        
        --Pose du feu
        local count = VorpInv.getItemCount(data.source, "campfire")	
        local count1 = VorpInv.getItemCount(data.source, "wood")

		if count1 >= 3 and count >= 1 then
			VorpInv.subItem(data.source, "campfire", 1)
			VorpInv.subItem(data.source, "wood", 3)
			TriggerClientEvent('CampFire:setcampfire', data.source)
            VorpInv.CloseInv(data.source)
		else
			TriggerClientEvent("vorp:TipBottom", data.source, 'Vous avez besoin de 1 allumette et 3 bois', 4500)
		end
	end)
end)

RegisterServerEvent('CampFire:CheckItems_addcoal')
AddEventHandler('CampFire:CheckItems_addcoal', function(x, y, z)
	local _source = source
    local count = VorpInv.getItemCount(_source, "wood")
    if count >= 1 then
        VorpInv.subItem(_source, "wood", 1)
        TriggerClientEvent('CampFire:addcoal', _source, x, y, z)
    else
        TriggerClientEvent("vorp:TipBottom", _source, "Vous n'avez plus de bois", 4500)
	end		
end)

RegisterServerEvent('CampFire:AddCoal')
AddEventHandler('CampFire:AddCoal', function(x, y, z)
	local _source = source
    for i, v in pairs(CampFireList) do
        if v.Equals(x,y,z)then
            v.TimerInscreased(Config.woodAddTime)
            TriggerClientEvent('CampFire:RefreshClientList', -1, v.Coords.x, v.Coords.y, v.Coords.z, v.Prop, v.FireInProgress, v.CampFireTimer, v.EmberTimer)
        end
    end
end)

RegisterServerEvent('CampFire:campfire_failed')
AddEventHandler('CampFire:campfire_failed', function()
	local _source = source
	VorpInv.addItem(_source, "wood", 3)
	TriggerClientEvent("vorp:TipBottom", _source,"Vous n'avez pas réussi à allumer le feu", 4000)		
end)

--Start du feu de Camp
RegisterServerEvent('CampFire:Start')
AddEventHandler('CampFire:Start', function(x, y, z)
    local tmp = CampFire(x, y, z, 0)
    CampFireList[#CampFireList+1] = tmp
    CampFireList[#CampFireList].Start()
    Wait(1000)

    TriggerClientEvent('CampFire:RefreshClientList', -1, CampFireList[#CampFireList].Coords.x, CampFireList[#CampFireList].Coords.y, CampFireList[#CampFireList].Coords.z, CampFireList[#CampFireList].Prop, CampFireList[#CampFireList].FireInProgress, CampFireList[#CampFireList].CampFireTimer)
end)

--Recherche des items disponnibles.
RegisterServerEvent('CampFire:CheckItems')
AddEventHandler('CampFire:CheckItems', function(x, y, z)
    local _source = source
    local count = VorpInv.getItemCount(_source, "wood")

    local restart
    for i,v in pairs(BurnOutList)do
        if v.Equals(x,y,z) then
            restart = v.restartInProgress
            break
        end        
    end

    if(restart == false) then
        --Pose du feu
        if count >= 2 then
            VorpInv.subItem(_source, "wood", 2)

            TriggerClientEvent('CampFire:restartCampfire', _source, x,y,z)

            for i,v in pairs(BurnOutList)do
                if v.Equals(x,y,z) then
                    v.restartInProgress = true
                    TriggerClientEvent('CampFire:RefreshClientBurnOut', -1, v.Coords.x, v.Coords.y, v.Coords.z, v.Prop, v.FireInProgress, v.CampFireTimer, v.EmberTimer, v.restartInProgress)
                    break
                end        
            end
        else
            TriggerClientEvent("vorp:TipBottom", _source, 'Vous avez besoin de 2 bois', 4500)
        end
    else
        TriggerClientEvent("vorp:TipBottom", _source, "Quelqu'un est déjà en train de rallumé le feu de camp", 4500)
    end
end)


--ReStart du feu de Camp
RegisterServerEvent('CampFire:Restart')
AddEventHandler('CampFire:Restart', function(x, y, z)

    local restart
    for i,v in pairs(BurnOutList) do
        if(v.Equals(x,y,z))then
            restart = table.remove(BurnOutList, i)
            break
        end
    end
    
    if(restart ~= nil)then
        --Remise en route
        restart.Start()
        restart.CampFireTimer = Config.fireRestartBaseTime
        restart.BurnOutReset()
        restart.restartInProgress = false

        --Refresh des clients Liste et Burnout
        CampFireList[#CampFireList+1] = restart
        TriggerClientEvent('CampFire:RefreshClientList', -1, CampFireList[#CampFireList].Coords.x, CampFireList[#CampFireList].Coords.y, CampFireList[#CampFireList].Coords.z, CampFireList[#CampFireList].Prop, CampFireList[#CampFireList].FireInProgress, CampFireList[#CampFireList].CampFireTimer)
        TriggerClientEvent('CampFire:DeleteClientBurnOut', -1, CampFireList[#CampFireList].Coords.x, CampFireList[#CampFireList].Coords.y, CampFireList[#CampFireList].Coords.z)
    end
end)


--ReStart du failed
RegisterServerEvent('CampFire:Restart_failed')
AddEventHandler('CampFire:Restart_failed', function(x, y, z)
    local _source = source

    local restart
    for i,v in pairs(BurnOutList) do
        if(v.Equals(x,y,z))then
            v.restartInProgress = false
            TriggerClientEvent('CampFire:RefreshClientBurnOut', -1, v.Coords.x, v.Coords.y, v.Coords.z, v.Prop, v.FireInProgress, v.CampFireTimer, v.EmberTimer, v.restartInProgress)
            break
        end
    end

    --Si Minijeu Fail on rend les items
    VorpInv.addItem(_source, "wood", 1)
    TriggerClientEvent("vorp:TipBottom", _source, "Vous avez rater votre allumage", 4500)
end)