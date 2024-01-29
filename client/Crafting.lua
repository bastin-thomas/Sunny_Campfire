--// Gestion Craft //--
RegisterNetEvent('CampFire:finCraft')
AddEventHandler('CampFire:finCraft', function()
    isMenuOpened = false
    ClearPedTasks(PlayerPedId())
    FreezeEntityPosition(PlayerPedId(), false) 
end)

RegisterNetEvent('CampFire:closeMenu')
AddEventHandler('CampFire:closeMenu', function()
    isMenuOpened = false
    ClearPedTasks(PlayerPedId())
    FreezeEntityPosition(PlayerPedId(), false) 
end)

Citizen.CreateThread(function()
    local k = -1
    local w = "nil"
    local playerPed = PlayerPedId()

	WarMenu.CreateMenu('menu', 'Feu de Camp')
    WarMenu.SetSubTitle('menu', "")
    for i,v in pairs(Config.Craft)do 
        WarMenu.CreateSubMenu(v.MenuName, 'menu', '')
    end

	repeat
		if WarMenu.IsMenuOpened('menu') then
            for i, v in pairs(Config.Craft)do 
                if WarMenu.MenuButton(v.MenuName, v.MenuName) then 
                    k = i
                    w = v
                end
            end
            
            if WarMenu.Button("Quitter") then
                TriggerEvent('CampFire:closeMenu')
                WarMenu.CloseMenu()    
			end
            WarMenu.Display()

        elseif WarMenu.IsMenuOpened(w.MenuName) then
            for j, craft in pairs(w.Craft) do
                if WarMenu.Button(w.Craft[j].CraftName .." ".. craft.itemGain[1].qtyGain .."x") then
                    TriggerServerEvent('Campfire:Craft', k, j, currentCoords.x, currentCoords.y, currentCoords.z, false);

                    craftingInProgress = 1
                    WarMenu.CloseMenu();
                    Citizen.Wait(10)
                end
            end

            if WarMenu.Button("Quitter") then
                TriggerEvent('CampFire:closeMenu')
                WarMenu.CloseMenu()    
			end
            WarMenu.Display()
        end
        Citizen.Wait(0)	
	until false
end)

RegisterNetEvent('CampFire:progressbar')
AddEventHandler('CampFire:progressbar', function(timer)
    coalInProgress = true
    FreezeEntityPosition(PlayerPedId(), true)
    TaskStartScenarioInPlace(PlayerPedId(), GetHashKey('WORLD_HUMAN_CROUCH_INSPECT'), timer, true, false, false, false)
    exports.gum_progressbars:DisplayProgressBar(timer)
    ClearPedTasks(PlayerPedId())
    FreezeEntityPosition(PlayerPedId(), false)
    coalInProgress = false
end)











Citizen.CreateThread(function()
    local k = -1
    local w = "nil"

	WarMenu.CreateMenu('menuspecial', 'Feu de Camp')
    WarMenu.SetSubTitle('menuspecial', "")
    for i,v in pairs(Config.Craft)do 
        WarMenu.CreateSubMenu(v.MenuName, 'menuspecial', '')
    end

	repeat
		if WarMenu.IsMenuOpened('menuspecial') then
            for i, v in pairs(Config.Craft)do 
                if WarMenu.MenuButton(v.MenuName, v.MenuName) then 
                    k = i
                    w = v
                end
            end

            if WarMenu.Button("Quitter") then
                TriggerEvent('CampFire:closeMenu')
                WarMenu.CloseMenu()    
			end
            WarMenu.Display()

        elseif WarMenu.IsMenuOpened(w.MenuName) then
            for j, craft in pairs(w.Craft) do
                if WarMenu.Button(w.Craft[j].CraftName .." ".. craft.itemGain[1].qtyGain .."x") then
                    craftingInProgress = 1
                    
                    TriggerServerEvent('Campfire:Craft', k, j, 0, 0, 0, true);                   
                    WarMenu.CloseMenu();
                    Citizen.Wait(1)
                end
            end

            if WarMenu.Button("Quitter") then
                TriggerEvent('CampFire:closeMenu')
                WarMenu.CloseMenu()    
			end
            WarMenu.Display()
        end
        Citizen.Wait(0)	
	until false
end)