package.path = package.path .. ";data/scripts/lib/?.lua"


--THIS IS AN EXAMPLE OF HOW THE SUBSPACE CORRIDOR CAN BE USED.
--PLEASE DONT ACTUALLY USE THIS LIKE THIS AS THE /TELEPORT COMMAND IS BETTER ON PERFORMANCE
--THIS SCRIPT CAN BE USED BY MODDERS TO ADD TELEPORTATION TO THEIR SCRIPTS SINCE SCRIPT DONT HAVE
--HAVE ACCESS TO SERVER COMMANDS.
function execute(sender, commandName, ...)
    local args = {...}
    local player = Player(sender)
    player:addScriptOnce("SubspaceCorridor.lua",args[1],args[2])
    return 0, "", ""
end

function getDescription()
    return "An example of how you can use the Subspace Corridor."
end

function getHelp()
    return "An example of how you can use the Subspace Corridor. Usage: /corridor 12 12"
end
