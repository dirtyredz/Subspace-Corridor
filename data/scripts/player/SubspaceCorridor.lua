if onServer() then
    package.path = package.path .. ";data/scripts/lib/?.lua"

    require ("randomext")
    require ("stringutility")
    PassageMap = require ("passagemap")

    -- Don't remove or alter the following comment, it tells the game the namespace this script lives in. If you remove it, the script will break.
    -- namespace SubspaceCorridor
    SubspaceCorridor = {}

    --For EXTERNAL configuration files
    package.path = package.path .. ";configs/?.lua"
    SubspaceCorridorConfig = nil
    exsist, SubspaceCorridorConfig = pcall(require, 'subspacecorridorconfig')

    --Config Settings
    SubspaceCorridor.ModPrefix = "[Subspace Corridor]";
    SubspaceCorridor.Version = "[1.1.0]";
    SubspaceCorridor.SafeJump = SubspaceCorridorConfig.SafeJump or true -- if True will prevent jumps when to close to other entities.
    SubspaceCorridor.Debug = SubspaceCorridorConfig.Debug or false -- if true displays additional logs to console.

    local transferrer = nil
    local desc = nil
    local first_wormhole = nil
    local player = nil

    function SubspaceCorridor.print(...)
      local args = table.pack(...)
      if args[1] ~= nil then
        args[1] = SubspaceCorridor.ModPrefix .. SubspaceCorridor.Version .. args[1]
        print(table.unpack(args))
      else
        print(SubspaceCorridor.ModPrefix .. SubspaceCorridor.Version .. " nil")
      end
    end

    function SubspaceCorridor.initialize(x,y)
      if SubspaceCorridor.Debug then
        SubspaceCorridor.print('SubspaceCorridor initialize')
        SubspaceCorridor.print('SubspaceCorridor initialize with coordinates:',x,y)
      end
      if not x or not y then
        terminate()
        return
      end

      local sx, sy = Sector():getCoordinates()
      local player = Player()

      if sx == x and sy == y then
        SubspaceCorridor.print('Cant teleport to the same location.')
        player:sendChatMessage("Subspace Corridor",1,"Cant teleport to the same location.")
        terminate()
        return
      end

      local playerIndex = Player.index
      local xy = "("..x..", "..y..")"
      local passageMap = PassageMap(Server().seed)

      -- check if it's blocked, if yes, don't allow the corridor to open.
      if not passageMap:passable(x, y) then
          SubspaceCorridor.print('Passage is not passable, teleporting into a rift? ')
          player:sendChatMessage("Subspace Corridor",1,"Cant open a Subspace Corridor inside of a rift.")
          terminate()
          return
      end

      --player:sendChatMessage("Subspace Corridor",3,"Opening Subspace Corridor..")
      local ship = player.craft
      --get ship radious to keep the corridor small
      local sphere = ship:getBoundingSphere()
      local radius = sphere.radius
      desc = WormholeDescriptor()
      -- plus 1 for sanity
      local size = radius + 1

      local entities = {Sector():getEntitiesByLocation(sphere)}
      if #entities > 1 then
        SubspaceCorridor.print('Attempting to create wormhole, to close to other entities: ', #entities)
      end
      if SubspaceCorridor.SafeJump and #entities > 1 then
        if SubspaceCorridor.Debug then
          SubspaceCorridor.print('Safe jump is true, stopping wormhole creation. ')
        end
        player:sendChatMessage("Subspace Corridor",1,"Cant open a Subspace Corridor to close to other entities.")
        terminate()
        return
      end
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
      first_wormhole = Sector():createEntity(desc)

      transferrer = EntityTransferrer(first_wormhole.index)

      SubspaceCorridor.print('(' .. playerIndex .. ') has generated a subspace corridor to: ',xy)
    end

    function SubspaceCorridor.updateServer( timestep )
      if transferrer then
        if transferrer.sectorReady then
          SubspaceCorridor.print('Wormhole is ready.',xy)
          SubspaceCorridor.OpenCorridor(desc)
          Sector():deleteEntityJumped(first_wormhole)
        end
      end
    end

    function SubspaceCorridor.OpenCorridor(desc)
      if SubspaceCorridor.Debug then
        SubspaceCorridor.print('SubspaceCorridor OpenCorridor')
      end
      --Create wormhole using previous descriptor
      local wormhole = Sector():createEntity(desc)

      if SubspaceCorridor.Debug then
        SubspaceCorridor.print('Closed first wormhole and opening second.')
      end
      --Again were delting this wormhole too.
      local timer = DeletionTimer(wormhole.index)
      timer.timeLeft = 1 -- seconds that the wormhole will be open
      --terminate and return
      terminate()
      return
    end
end
