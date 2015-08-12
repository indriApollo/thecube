The Cube minigame [thecube]
===========================

(https://forum.minetest.net/viewtopic.php?f=9&t=10609)

**The cube is a mini game for Minetest.**

It generates giant (or mini) dirt/stone/glass/sand cubes with hidden treasures (bronze blocks) hidden inside !
There is also the possibility to hide a Golden Snitch along with the bronze blocks.

The primary idea is to declare as winner the player with the most treasures.
The Golden Snitch can be an instant winner or worth more points.

But another game could be a rush to the golden snitch in a glass cube were the bronze blocks are obstacles.
The players should then break all the glass and race to the snitch :)

You make the rules !

Hope you'll enjoy this mod :D

HOWTO :
-------

```
/cube undo | do <size> <#ores> <dirt|stone|sand|glass> [1]
```

- undo : restore the nodes changed by the latest cube (clean up after game or revert accidental griefing)
- do : generate cube with following parameters
- size : give the border lenght of the cube, final cube will be size^3 (min 3)
- #ores: give the number of treasures that must be hidden in the cube (max as much as cube volume duh)
- dirt|stone|sand|glass : set the desired node the cube will be made of
- [1] : (optional) enable the Golden Snitch

**/!\ The mod does not check for area protections. Be careful were you spawn it to avoid griefing !**

Privs :
-------
thecube

Depends :
---------
default

Licence :
---------
lgpl 2.1

Installation:
-------------
Unzip the file and rename it to "thecube". Then move it to the mod directory.
