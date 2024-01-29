function CampFire(nx, ny, nz, p, fp, cft, et)
    local self = {}

    self.Coords = {
        x = nx or 0, 
        y = ny or 0, 
        z = nz or 0
    }

    self.Prop = p or myCreateObject(nx,ny,nz)
    self.FireInProgress = fp or false
    self.CampFireTimer = cft or Config.fireBaseTime
    self.EmberTimer = et or Config.EmberTimer
    self.restartInProgress = false

    self.print = function()
        local data1, data2
        if(self.FireInProgress == true) then
            data1 = 1
        else
            data1 = 0
        end

        if(self.restartInProgress == true) then
            data2 = 1
        else
            data2 = 0
        end
        print("Coords: ".. self.Coords.x .. ", ".. self.Coords.y .. ", " .. self.Coords.z .. ",  Prop: ".. self.Prop .. ", IsFire =".. data1 ..", CampFireTimer: "..self.CampFireTimer..", EmberTimer: "..self.EmberTimer..", restartInProgress: "..data2)
    end


    self.CreateObject = function()
        if(self.Prop ~= nil)then
            DeleteObject(self.Prop)
        end

        self.Prop = myCreateObject(self.Coords.x, self.Coords.y, self.Coords.z)
    end


    self.BurnOutProps = function()
        if(self.Prop ~= nil)then
            DeleteObject(self.Prop)
        end
        self.Prop = CreateObject(GetHashKey(Config.campfirePropburnout), self.Coords.x, self.Coords.y, self.Coords.z, false, true, false)  
        SetEntityAsMissionEntity(self.Prop)
        SetEntityHeading(self.Prop)
        PlaceObjectOnGroundProperly(self.Prop)
    end

    self.Start = function()
        self.FireInProgress = true
    end

    self.Stop = function()
        self.FireInProgress = false
    end

    self.TimerInscreased = function(Seconds)
        self.CampFireTimer = self.CampFireTimer + Seconds
    end

    self.TimerDecreased = function()
        self.CampFireTimer = self.CampFireTimer - 1
    end

    self.TimerReset = function()
        self.CampFireTimer = Config.fireBaseTime
    end

    self.BurnOutDecreased = function()
        self.EmberTimer = self.EmberTimer - 15
    end

    self.BurnOutReset = function()
        self.EmberTimer = Config.EmberTimer
    end

    self.Equals = function(x, y, z)
        if(self.Coords.x == x and self.Coords.y == y and self.Coords.z == z)then
            return true
        else
            return false
        end
    end

    return self
end

function myCreateObject(x,y,z)
    local prop = CreateObject(GetHashKey(Config.campfireProp), x, y, z, false, true, false)
    SetEntityAsMissionEntity(prop)
    SetEntityHeading(prop, GetEntityHeading(PlayerPedId()))
    PlaceObjectOnGroundProperly(prop)
    return prop
end