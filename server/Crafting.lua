--// Gestion Craft //--
RegisterServerEvent('Campfire:Craft')
AddEventHandler('Campfire:Craft', function(i, j, x, y, z, isSpecialFire)
    local _source = source;
    local CampFire = nil;

    if(isSpecialFire == false)then
        for k,v in pairs(CampFireList)do
            if v.Equals(x,y,z)then
                CampFire = v
                break
            end
        end
    end
    
    
    craft(_source,  Config.Craft[i].Craft[j].itemUtil, Config.Craft[i].Craft[j].itemGain, Config.Craft[i].Craft[j].UnlockItem, CampFire, 
                    Config.Craft[i].Craft[j].CraftingTime*1000, isSpecialFire);
end)


function craft(_source, itemUtil, itemGain, Job, CampFire, CraftingTime, isSpecialFire)
    local CanteenFound = GetCanteen(_source)
    local isprop = false

    if(isSpecialFire == false)then 
        --Si le feu n'est plus allumer, on annuler.
        if(CampFire == nil)then
            TriggerClientEvent("vorp:TipBottom", _source, 'Le feu doit être Allumer', 4500)
            TriggerClientEvent("CampFire:closeMenu", _source)
            return
        end
        if CampFire.CampFireTimer <= 5 then
            TriggerClientEvent("vorp:TipBottom", _source, 'Le feu doit être Allumer', 4500)
            TriggerClientEvent("CampFire:closeMenu", _source)
            return
        end
    end

    


    --Creation des counts:
    for i, item in ipairs(itemUtil) do
        if item.weapon == true then
            if item.id == "knife" and IsKnife(_source) == true then
                item.count = 1
            else
                TriggerClientEvent("vorp:TipBottom", _source, "Vous avez besoin d'un couteau", 5000)
                TriggerClientEvent("CampFire:closeMenu", _source)
                return
            end
        else
            if item.id ~= "canteen" then
                item.count = VorpInv.getItemCount(_source, item.id)
            else
                item.count = VorpInv.getItemCount(_source, CanteenFound)
            end
        end
    end

    for i, item in ipairs(itemGain) do
        if item.IsProp == false and item.weapon == false then
            if item.id ~= "canteen" then
                item.count = VorpInv.getItemCount(_source, item.id)
            else
                item.count = VorpInv.getItemCount(_source, NextCanteen(CanteenFound))
            end
        elseif item.IsProp == true then
            isprop = true
        end
    end

    --Test si il y a assez de place pour chaque type d'item gagner
    local isCraftable = true
    
    for j, item in ipairs(itemGain) do
        if item.id ~= "canteen" then
            if item.weapon == true then
                local canCarry = VorpInv.canCarryWeapons(_source, item.qtyGain, function(cb)
                    if cb then
                        return true
                    else
                        return false
                    end
                end)
    
                if canCarry == false then
                    TriggerClientEvent("vorp:TipBottom", _source, "Vous ne pouvez pas portez plus d'armes", 5000)
                    TriggerClientEvent("CampFire:closeMenu", _source)
                    return
                end
            elseif item.IsProp then
                
            elseif VorpInv.canCarryItem(_source, item.id, item.qtyGain) == false then
                TriggerClientEvent("vorp:TipBottom", _source, "Vous n'avez pas assez d'espace", 5000)
                TriggerClientEvent("CampFire:closeMenu", _source)
                return
            end
        else
            if(CanteenFound == "null")then
                TriggerClientEvent("vorp:TipBottom", _source, "Vous portez trop de gourde, ou n'avez pas assez d'espace", 5000)
                TriggerClientEvent("CampFire:closeMenu", _source)
                return
            end
        end
    end 
    
    -- Test si on a assez de place au total pour tout les items gagner
    if(isCraftable == true)then
        isCraftable = false

        local AllqtyGain = 0
        for j, item in ipairs(itemGain) do
            if item.weapon == false and item.IsProp == false then
                AllqtyGain = AllqtyGain + item.qtyGain
            end
        end

        if VorpInv.canCarryItems(_source, AllqtyGain) == true or AllqtyGain == 0 then
            isCraftable = true
        end
    end
    
    --Si pas Craftable car trop d'item sur soit on annule
    if isCraftable == false then
        TriggerClientEvent("vorp:TipBottom", _source, "Vous n'avez pas assez d'espace", 5000)
    else
        --SiNon, on regarde si on a assez de matériaux/outils a utiliser
        isCraftable = true
        for j, item in ipairs(itemUtil) do            
            if item.count < item.qty then
                isCraftable = false
                break
            end
        end

        --Si Craftable, on retire les itemUtiles, (sauf outils)
        if isCraftable == true then            
            for j, item in ipairs(itemUtil) do
                if item.tool == false then
                    if item.id ~= "canteen" then
                        VorpInv.subItem(_source, item.id, item.qty) 
                    else
                        VorpInv.subItem(_source, CanteenFound, item.qty) 
                        --subitem de la bonne gourde
                    end
                end
            end
            
            if isprop == false then
                TriggerClientEvent("CampFire:progressbar", _source, CraftingTime)
                Wait(CraftingTime)
            end

            for j, item in ipairs(itemGain) do
                if item.weapon then
                    --AddWeapon    
                    VorpInv.createWeapon(_source, item.id)
                elseif item.IsProp then
                    --PlaceProps
                    --TriggerClientEvent(Config.ScriptName..":PlaceProps", _source, item.id, CraftingTime)
                elseif item.id ~= "canteen" then
                    VorpInv.addItem(_source, item.id, item.qtyGain) --On ajoute tout les items en réconpenses
                else
                    --addItem de la bonne gourde en fonction de celle supprimer
                    VorpInv.addItem(_source, NextCanteen(CanteenFound), item.qtyGain)
                end
            end
            TriggerClientEvent("CampFire:finCraft", _source)

        else
            TriggerClientEvent("vorp:TipBottom", _source, "Il vous manque des ressources.", 1500)

            local message = "Vous avez besoin : "
            --Si il manque des matériaux on prévient l'utilisateur
            for j, item in ipairs(itemUtil) do
                if (item.qty - item.count) > 0 then
                    local myItem
                    if item.id ~= "canteen" then
                        myItem = VorpInv.getDBItem(_source, item.id)
                    else
                        myItem.label = "Gourde" 
                    end
                    message = message .. item.qty - item.count ..' '.. myItem.label .. ',  '
                end
                if(j == 1)then
                    TriggerClientEvent("CampFire:closeMenu", _source)
                end
            end
            message = message:sub(1, -4)
            TriggerClientEvent("vorp:TipBottom", _source, message..".", 5000)
        end
    end
    TriggerClientEvent("CampFire:closeMenu", _source)
end

--[[ -- Fonction générique de Craft d'item
function craft(_source, itemUtil, itemGain, Job, CampFire, CraftingTime)
    local CanteenFound = GetCanteen(_source)

    --Si le feu n'est plus allumer, on annuler.
    if(CampFire == nil)then
        TriggerClientEvent("vorp:TipBottom", _source, 'Le feu doit être Allumer', 4500)
        TriggerClientEvent("CampFire:closeMenu", _source)
        return
    end
    if CampFire.CampFireTimer <= 5 then
        TriggerClientEvent("vorp:TipBottom", _source, 'Le feu doit être Allumer', 4500)
        TriggerClientEvent("CampFire:closeMenu", _source)
        return
    end


    --Creation des counts:
    for i, item in ipairs(itemUtil) do
        if item.id ~= "canteen" then
            item.count = VorpInv.getItemCount(_source, item.id)
        else
            item.count = VorpInv.getItemCount(_source, CanteenFound)
        end
    end

    for i, item in ipairs(itemGain) do
        if item.id ~= "canteen" then
            item.count = VorpInv.getItemCount(_source, item.id)
        else
            item.count = VorpInv.getItemCount(_source, NextCanteen(CanteenFound))
        end
    end

    --Test si il y a assez de place pour chaque type d'item gagner
    local isCraftable = true
    
    for i, item in ipairs(itemGain) do
        if item.id ~= "canteen" then
            if VorpInv.canCarryItem(_source, item.id, item.qtyGain) == false then
                isCraftable = false
                break
            end
        else
            if(CanteenFound == "null")then
                isCraftable = false
                TriggerClientEvent("vorp:TipBottom", _source, "Vous avez besoin d'une gourde", 5000)
                TriggerClientEvent("CampFire:closeMenu", _source)
                return
            end
        end
    end 
    
    -- Test si on a assez de place au total pour tout les items gagner
    if(isCraftable == true)then
        local AllqtyGain = 0
        for i, item in ipairs(itemGain) do
            AllqtyGain = AllqtyGain + item.qtyGain
        end

        if VorpInv.canCarryItems(_source, AllqtyGain) == true then
            isCraftable = true
        end
    end
    
    --Si pas Craftable car trop d'item sur soit on annule
    if isCraftable == false then
        TriggerClientEvent("vorp:TipBottom", _source, "Vous n'avez pas assez d'espace", 5000)
    else
        --SiNon, on regarde si on a assez de matériaux/outils a utiliser
        isCraftable = true
        for i, item in ipairs(itemUtil) do            
            if item.count < item.qty then
                isCraftable = false
                break
            end
        end
        --Si Craftable, on retire les itemUtiles, (sauf outils)
        if isCraftable == true then            
            for i, item in ipairs(itemUtil) do
                if item.tool == false then
                    if item.id ~= "canteen" then
                        VorpInv.subItem(_source, item.id, item.qty) 
                    else
                        VorpInv.subItem(_source, CanteenFound, item.qty) 
                        --subitem de la bonne gourde
                    end
                end
            end
            
            TriggerClientEvent("CampFire:progressbar", _source, CraftingTime-1000)
            Wait(CraftingTime)
            
            for i, item in ipairs(itemGain) do
                if item.id ~= "canteen" then
                    VorpInv.addItem(_source, item.id, item.qtyGain) --On ajoute tout les items en réconpenses
                else
                    --addItem de la bonne gourde en fonction de celle supprimer
                    VorpInv.addItem(_source, NextCanteen(CanteenFound), item.qtyGain)
                end
            end
        else
            --Si il manque des matériaux on prévient l'utilisateur
            for i, item in ipairs(itemUtil) do
                if (item.qty - item.count) > 0 then
                    local myItem
                    if item.id ~= "canteen"then
                        myItem = VorpInv.getDBItem(_source, item.id)
                    else
                        myItem.label = "Gourde" 
                    end
                    
                    if(item.tool == false) then
                        TriggerClientEvent("vorp:TipBottom", _source, 'Matériaux manquants: '.. item.qty ..' '.. myItem.label .. '.', 1500)
                        TriggerClientEvent("CampFire:closeMenu", _source)
                    else
                        TriggerClientEvent("vorp:TipBottom", _source, 'Outils manquant: '.. item.qty ..' '.. myItem.label .. '.', 1500)
                        TriggerClientEvent("CampFire:closeMenu", _source)
                    end
                    Citizen.Wait(1500)
                end
            end
        end
    end

    if(CampFire == nil)then
        TriggerClientEvent("CampFire:closeMenu", _source)
        return
    end

    if(CampFire.CampFireTimer > 5)then
        TriggerClientEvent("CampFire:finCraft", _source)   
    else
        TriggerClientEvent("CampFire:closeMenu", _source)
    end
end ]]









function GetCanteen(_source)
    if IsCanteenUsable(_source) then
        for i,canteen in pairs(Config.Canteen) do
            if VorpInv.getItemCount(_source, canteen) == 1 and  (canteen ~= Config.Canteen[#Config.Canteen])then
                return canteen
            end
        end
    end
    return "null"
end

function IsCanteenUsable(_source)
    local count = 0
    for i, can in pairs(Config.Canteen)do
        if(VorpInv.getItemCount(_source, can) >= 1)then
            count = count + 1
        end
    end
    
    if(count <= 1)then
        return true
    else
        return false
    end
end

function NextCanteen(canteen)
    local index = 0
    for i,can in pairs(Config.Canteen)do
        if(canteen == can)then
            index = i+1
            break
        end
    end

    if index == 0 then
        return "null"
    else
        return Config.Canteen[index]
    end
end

function IsKnife(_source)
    local weapons = VorpInv.getUserWeapons(_source)
    for i, weapon in pairs(weapons)do
        if Contains(Config.Knife, weapon.name) then
            return true
        end
    end
    return false
end

function Contains(list,item)
    for i,v in pairs(list) do
        if(item == v)then
            return true
        end
    end
    return false
end