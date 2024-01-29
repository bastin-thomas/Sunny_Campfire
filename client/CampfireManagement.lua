--// Gestion Feu de Camp //--
--Ajout feu de camp
RegisterNetEvent('CampFire:setcampfire')
AddEventHandler('CampFire:setcampfire', function()
    --Creation d'un nouveau feu
    FreezeEntityPosition(PlayerPedId(), true)
    animationcampfire()
    TriggerEvent("vorp:TipBottom", 'Allumage du feu', 1500)
    exports.gum_progressbars:DisplayProgressBar(5000)

    local playerPed = PlayerPedId()
    local test = exports["syn_minigame"]:taskBar(Config.miniGameDifficulty,7) -- difficulty,skillGapSent
    if test == 100 then
        local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 1.0, -1.55))
        TriggerServerEvent('CampFire:Start', x, y, z)

        Citizen.Wait(1000)
        FreezeEntityPosition(PlayerPedId(), false)
        ClearPedTasks(PlayerPedId())
    else
        TriggerServerEvent('CampFire:campfire_failed')
        FreezeEntityPosition(PlayerPedId(), false)
        ClearPedTasks(PlayerPedId())
    end
end)


--Rallumage feu de camp
RegisterNetEvent('CampFire:restartCampfire')
AddEventHandler('CampFire:restartCampfire', function(x,y,z)
    --Relancement du feu
    FreezeEntityPosition(PlayerPedId(), true)
    animationcampfire()

    TriggerEvent("vorp:TipBottom", 'Allumage du feu', 1500)
    exports.gum_progressbars:DisplayProgressBar(5000)

    local playerPed = PlayerPedId()
    local test = exports["syn_minigame"]:taskBar(Config.miniGameDifficulty,7) -- difficulty,skillGapSent
    if test == 100 then            
        TriggerServerEvent('CampFire:Restart', x, y, z)
        Citizen.Wait(1000)
        FreezeEntityPosition(PlayerPedId(), false)
        ClearPedTasks(PlayerPedId())
    else
        TriggerServerEvent('CampFire:Restart_failed',x,y,z)
        FreezeEntityPosition(PlayerPedId(), false)
        ClearPedTasks(PlayerPedId())
    end
end)

--Feu de camp s'éteind
RegisterNetEvent('CampFire:CampfireBurnOut')
AddEventHandler('CampFire:CampfireBurnOut', function(x,y,z)
    local found = false
    for i, v in pairs(CampFireList) do
        if(v.Equals(x,y,z))then
            local bo = table.remove(CampFireList, i)
            bo.BurnOutProps()
            BurnOutList[#BurnOutList+1] = bo
            found = true
            break
        end
    end
end)

--Refresh Liste feu de camp allumer
RegisterNetEvent('CampFire:RefreshClientList')
AddEventHandler('CampFire:RefreshClientList', function(x, y, z, p, fp, cft, et)
    local found = false
    for i, v in pairs(CampFireList) do
        if(v.Equals(x,y,z))then
            v.FireInProgress = fp
            v.CampFireTimer = cft
            v.EmberTimer = et
            found = true

            if(DoesObjectOfTypeExistAtCoords(x,y,z,2.0,Config.campfireProp) == false and loading == false)then
                v.CreateObject()
            end
            break
        end
    end
    if(found == false and loading == false)then
        CampFireList[#CampFireList+1] = CampFire(x, y, z, nil, fp, cft, et)
    end
end)

--Refresh Liste feu de camp éteint
RegisterNetEvent('CampFire:RefreshClientBurnOut')
AddEventHandler('CampFire:RefreshClientBurnOut', function(x, y, z, p, fp, cft, et, rip)
    local found = false
    for i, v in pairs(BurnOutList) do
        if(v.Equals(x,y,z))then
            v.FireInProgress = fp
            v.CampFireTimer = cft
            v.EmberTimer = et
            v.restartInProgress = rip
            found = true

            if(DoesObjectOfTypeExistAtCoords(x,y,z,2.0,Config.campfirePropburnout) == false and loading == false)then
                v.BurnOutProps()
            end
            if(v.EmberTimer <= 0 and loading == false)then
                local deleted = table.remove(BurnOutList,i)
                DeleteObject(deleted.Prop)
            end
            break
        end
    end
    if(found == false and loading == false)then
        BurnOutList[#BurnOutList+1] = CampFire(x, y, z, nil, fp, cft, et)
        BurnOutList[#BurnOutList].BurnOutProps()
    end
end)

--Suppression d'un feu éteint
RegisterNetEvent('CampFire:DeleteClientBurnOut')
AddEventHandler('CampFire:DeleteClientBurnOut', function(x, y, z)
    for i, v in pairs(BurnOutList) do
        if(v.Equals(x,y,z))then
            local deleted = table.remove(BurnOutList,i)
            DeleteObject(deleted.Prop)
            break
        end
    end
end)


-- Ajout du charbon
RegisterNetEvent('CampFire:addcoal')
AddEventHandler('CampFire:addcoal', function(x,y,z)
    local playerPed = PlayerPedId()
    coalInProgress = true
    FreezeEntityPosition(PlayerPedId(), true)
    TaskStartScenarioInPlace(playerPed, GetHashKey('WORLD_HUMAN_CROUCH_INSPECT'), 2000, true, false, false, false)
    exports.gum_progressbars:DisplayProgressBar(2500)
    TriggerServerEvent('CampFire:AddCoal', x,y,z)
    FreezeEntityPosition(PlayerPedId(), false)
    coalInProgress = false
end)