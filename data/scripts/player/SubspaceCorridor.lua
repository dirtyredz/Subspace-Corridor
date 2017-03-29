if onServer() then
    package.path = package.path .. ";data/scripts/lib/?.lua"

    require ("randomext")
    require ("stringutility")
    PassageMap = require ("passagemap")

    function initialize(x,y)
        local passageMap = PassageMap(Server().seed)
        local player = Player()
        -- check if it's blocked, if yes, don't allow the corridor to open.
        if not passageMap:passable(x, y) then
            player:sendChatMessage("Subspace Corridor",1,"Cant open a Subspace Corridor inside of a rift.")
            terminate()
            return
        end

        player:sendChatMessage("Subspace Corridor",3,"Opening Subspace Corridor..")
        local ship = player.craft
        --get ship radious to keep the corridor small
        local radius = ship:getBoundingSphere().radius
        local desc = WormholeDescriptor()
        -- plus 1 for sanity
        local size = radius + 1

        --we want to delete this corridor after we leave.
        desc:addComponents(ComponentType.DeletionTimer)
        --Set wormhole position ontop of the ship
        desc.position = MatrixLookUpPosition(vec3(0, 1, 0), vec3(1, 0, 0),  ship.translationf)
        desc.cpwormhole:setTargetCoordinates(x, y)
        --client doesnt need to see that we hacked the wormhole to act like a teleporter
        desc.cpwormhole.visible = false
        desc.cpwormhole.visualSize = size
        desc.cpwormhole.passageSize =  size
        --This is crutial it disables the exit from beign created. and allows the enterance to be deleted
        desc.cpwormhole.oneWay = true

        --Create wormhole
        local wormhole = Sector():createEntity(desc)
        print("[Subspace Corridor] Player: "..player.name.." has generated a subspace corridor to "..x..", "..y..".")
        --Create deletion timer
        local timer = DeletionTimer(wormhole.index)
        timer.timeLeft = 1 -- seconds that the wormhole will be open

        --ok here I havent figured out how destinationSectorReady() if it even works for wormholes
        --so to trick it, we create 2 wormholes first one starts the sector loading process
        --second one teleports.
        --this is necassary since were putting the wormhole ontop of the player.
        --if it was generated at a distance there would be time for the sector to load in.
        deferredCallback(2,"OpenCorridor",desc)
    end
    function OpenCorridor(desc)
        --Create wormhole using previous descriptor
        local wormhole = Sector():createEntity(desc)
        print("The Subspace Corridor has closed!")
        --Again were delting this wormhole too.
        local timer = DeletionTimer(wormhole.index)
        timer.timeLeft = 1 -- seconds that the wormhole will be open
        --terminate and return
        terminate()
        return
    end
end
