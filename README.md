# Subspace Corridor

![alt text](http://imgur.com/QjimETA.png)
___
This is a modders recources, designed to mimick /teleport, due to server commands not being available through the api.


## FAQ
___
#### What does this mod do?
   This mod is a modders recource giving modders access to a teleport command. which they can call inside thier scripts.

#### Does the client have to fly through a wormhole?
   No. the picture is just an a nice picture. If you watch the gif below youll see that the client is simply teleported to thier destination.

#### does the client need to be an admin?
   No. This script will teleport any player.

#### Whats an example use of this mod?
   Thier is a command included with the mod showing how you would call this command via /corridor. For examplea modder could limit the where the script is allowed to teleport allowing servers to give strict teleport command to their players. IE players can teleport back to their home base.

#### Why did you make this mod?
   Ive got a mod in development that would not work without access to /teleport. So I made this allowing me to accomplish my mod.

#### Can I use this in my mods?
   Yes, Thats why im posting it here. Some credit would be appreciated though.
___   

[Demo Gif](http://i.imgur.com/crwVmq9.gifv)



## INSTALL
___
Place the SubspaceCorridor.lua inside data/scripts/player/
Access the script like so:

     local x = 1
     local y = 1
     player:addScriptOnce("SubspaceCorridor.lua",x,y)

The script will then teleport the player to that destination.
The script has built in safegaurds preventing a teleportation inside of a rift.
In later versions i'll be making the script easier to use with 'require()' this will allow me to return an error if the x,y provided are not reachable. Or if their is an error in teleporting.

## UNINSTALL
___
Just delete the files, and remove refrences to them out of your own scripts.

## Downloads
___
__Version 1.1.0__
[Subspace-Corridor v1.1.0](https://github.com/dirtyredz/Subspace-Corridor/releases/download/1.1.0/Subspace-Corridor-v1.1.0.zip)

__Version 1.-.0__
https://www.dropbox.com/s/9p1qbkz98nwo6pj/Subspace-Corridor-V1.0.0.zip?dl=0

## Changelog
___
Version 1.1.0
-Added more print outs
-Added check to identify if to close to other entities
-Added configs page, (no required)
-Cleaned up code for performance

## GITHUB
___
https://github.com/dirtyredz/Subspace-Corridor


## DOWNLOAD
___
