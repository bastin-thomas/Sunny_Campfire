CampFireList = {}
BurnOutList = {}

_userJob = "null"
loading = true
coalInProgress = false
Group_prompt = GetRandomIntInRange(0, 0xffffff)
Group_prompt2 = GetRandomIntInRange(0, 0xffffff)
Group_prompt3 = GetRandomIntInRange(0, 0xffffff)
Group_prompt4 = GetRandomIntInRange(0, 0xffffff)

currentCoords = nil
isMenuOpened = false

--Verify if you are at the end of the loading.
Citizen.CreateThread(function()
    Wait(10000)
    print("Chargement des feux de camps")
    loading = false
end)

--// Gestion Debug //--
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


--// Gestion des prompts //--
Citizen.CreateThread(function()
    Citizen.CreateThread(function()
        restart = PromptRegisterBegin() --Init Prompt
        PromptSetControlAction(restart, 0xE30CD707) -- Set de la touche
        str = CreateVarString(10, 'LITERAL_STRING', "Raviver les flammes")
        PromptSetText(restart, str)
        PromptSetEnabled(restart, 1)
        PromptSetVisible(restart, 1)
        PromptSetStandardMode(restart,1)
        PromptSetGroup(restart, Group_prompt2)
        Citizen.InvokeNative(0xC5F428EE08FA7F2C,restart, true)
        PromptRegisterEnd(restart)
    end)

    Citizen.CreateThread(function()
        Prompt = PromptRegisterBegin() --Init Prompt
        PromptSetControlAction(Prompt, 0xE30CD707) -- Set de la touche
        str = CreateVarString(10, 'LITERAL_STRING', "Fabriquer")
        PromptSetText(Prompt, str)
        PromptSetEnabled(Prompt, 1)
        PromptSetVisible(Prompt, 1)
        PromptSetStandardMode(Prompt,1)
        PromptSetGroup(Prompt, Group_prompt)
        Citizen.InvokeNative(0xC5F428EE08FA7F2C,Prompt, true)
        PromptRegisterEnd(Prompt)
    end)
    
    Citizen.CreateThread(function()
        coal = PromptRegisterBegin() --Init Prompt
        PromptSetControlAction(coal, 0xCEFD9220) -- Set de la touche
        str = CreateVarString(10, 'LITERAL_STRING', "Ajouter Bois")
        PromptSetText(coal, str)
        PromptSetEnabled(coal, 1)
        PromptSetVisible(coal, 1)
        PromptSetStandardMode(coal,1)
        PromptSetGroup(coal, Group_prompt)
        Citizen.InvokeNative(0xC5F428EE08FA7F2C,coal, true)
        PromptRegisterEnd(coal)
    end)

    Citizen.Wait(10000)
    local coords

	while true do
        Citizen.Wait(0)
        coords = GetEntityCoords(PlayerPedId())
        --Prompt, Feu Allumer
        for k, v in pairs(CampFireList) do
            if GetDistanceBetweenCoords(coords, v.Coords.x, v.Coords.y, v.Coords.z, false) < 1.7 and not IsPedDeadOrDying(PlayerPedId()) and  isMenuOpened == false and coalInProgress == false then
                local label = CreateVarString(10, 'LITERAL_STRING', "Feu de Camp: " .. v.CampFireTimer)
                PromptSetActiveGroupThisFrame(Group_prompt, label)
                if Citizen.InvokeNative(0xC92AC953F0A982AE, coal) then
                    TriggerServerEvent("CampFire:CheckItems_addcoal", v.Coords.x, v.Coords.y, v.Coords.z)
                end
                if Citizen.InvokeNative(0xC92AC953F0A982AE, Prompt) then
                    currentCoords = v.Coords
                    isMenuOpened = true
                    WarMenu.OpenMenu('menu')
                    TaskStandStill(PlayerPedId(), -1)
                    FreezeEntityPosition(PlayerPedId(), true)
                end
            end
        end

        --Prompt, Feu Eteint
        for k, v in pairs(BurnOutList) do
            if GetDistanceBetweenCoords(coords, v.Coords.x, v.Coords.y, v.Coords.z, false) < 1.7 and not IsPedDeadOrDying(PlayerPedId()) and  v.restartInProgress == false then
                local label = CreateVarString(10, 'LITERAL_STRING', "Braises Chaudes")
                PromptSetActiveGroupThisFrame(Group_prompt2, label)
                if Citizen.InvokeNative(0xC92AC953F0A982AE, restart) then
                    TriggerServerEvent("CampFire:CheckItems",v.Coords.x, v.Coords.y, v.Coords.z)
                end
            end
        end
    end
end)



function animationcampfire()
    RequestAnimDict("script_campfire@lighting_fire@male_female")
    while not HasAnimDictLoaded("script_campfire@lighting_fire@male_female") do
        Citizen.Wait(1)
		RequestAnimDict("script_campfire@lighting_fire@male_female")
    end
    TaskPlayAnim(PlayerPedId(), "script_campfire@lighting_fire@male_female", "light_fire_b_p2_male", 1.0, 8.0, -1, 1, 0, false, 0, false, 0, false)
end

Citizen.CreateThread(function()
	while true do
    	TriggerServerEvent('CampFire:GetUserJob')
		Citizen.Wait(60000)
	end
end)

RegisterNetEvent('CampFire:setUserJob')
AddEventHandler('CampFire:setUserJob', function(userJob)
    _userJob = userJob
end)


--Feu Permanent (coordonée)
Citizen.CreateThread(function()
    --Creation du prompt
    Citizen.CreateThread(function()
        Feu = PromptRegisterBegin() --Init Prompt
        PromptSetControlAction(Feu, 0xE30CD707) -- Set de la touche
        str = CreateVarString(10, 'LITERAL_STRING', "Ouvrir")

        PromptSetText(Feu, str)
        PromptSetEnabled(Feu, 1)
        PromptSetVisible(Feu, 1)
        PromptSetStandardMode(Feu,1)
        PromptSetGroup(Feu, Group_prompt3)
        Citizen.InvokeNative(0xC5F428EE08FA7F2C,Feu, true)
        PromptRegisterEnd(Feu)
    end)

	while true do
        Citizen.Wait(1)
        local coords = GetEntityCoords(PlayerPedId())

        for k, v in pairs(Config.feu) do
            if GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < 1.0 and not IsPedDeadOrDying(PlayerPedId()) and isMenuOpened == false then  
                --Instanciation group prompt
                local label = CreateVarString(10, 'LITERAL_STRING', "Fabriquer")
                PromptSetActiveGroupThisFrame(Group_prompt3, label)

                if Citizen.InvokeNative(0xC92AC953F0A982AE,Feu,0) then
                    isMenuOpened = true
                    WarMenu.OpenMenu('menuspecial')
                    TaskStandStill(PlayerPedId(), -1)
                    FreezeEntityPosition(PlayerPedId(), true)
                end
            end
        end
    end
end)


-- Feu Permanent (Props)
--[[ Citizen.CreateThread(function()
    --Creation du prompt
    Citizen.CreateThread(function()
        Feu2 = PromptRegisterBegin() --Init Prompt
        PromptSetControlAction(Feu, 0xE30CD707) -- Set de la touche
        str = CreateVarString(10, 'LITERAL_STRING', "Ouvrir")

        PromptSetText(Feu2, str)
        PromptSetEnabled(Feu2, 1)
        PromptSetVisible(Feu2, 1)
        PromptSetStandardMode(Feu2,1)
        PromptSetGroup(Feu2, Group_prompt4)
        Citizen.InvokeNative(0xC5F428EE08FA7F2C,Feu2, true)
        PromptRegisterEnd(Feu2)
    end)

	while true do
        Citizen.Wait(1)
        local coords = GetEntityCoords(PlayerPedId())

        if DoesObjectOfTypeExistAtCoords(coords.x, coords.y, coords.z, 1.7, Config.PermanentFireProp) and not IsPedDeadOrDying(PlayerPedId()) and isMenuOpened == false then  
            --Instanciation group prompt
            local label = CreateVarString(10, 'LITERAL_STRING', "Fabriquer")
            PromptSetActiveGroupThisFrame(Group_prompt3, label)

            if Citizen.InvokeNative(0xC92AC953F0A982AE,Feu2,0) then
                isMenuOpened = true
                WarMenu.OpenMenu('menuspecial')
                TaskStandStill(PlayerPedId(), -1)
                FreezeEntityPosition(PlayerPedId(), true)
            end
        end
    end
end) ]]