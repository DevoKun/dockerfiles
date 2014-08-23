Bukkit Server Dockerfile
======================

* Using the Dockerfiles is as simple as having the docker daemon run one.
* The output after executing the script will be the ID of the new docker image.


## Build an image using the Dockerfile at current location
```bash
sudo docker build -t bukkit .
```


## Run an image
```bash
# sudo docker run -name bukkit -i -t bukkit
# sudo docker run -name bukkit -i -t 25565 bukkit:latest
sudo docker run -name bukkit -i -t 25565:49153 bukkit:latest
```
## Run an image interactively
```bash
sudo docker run -i -t ubuntu /bin/bash
```

## To get a running container's ip address
```bash
docker ps
docker inspect container_name | grep IPAddress
```bash

## To expose the container's port

* If you EXPOSE a port, the service in the container is not accessible from outside Docker, but from inside other Docker containers.
* EXPOSE effectively sets up inter-container communication ports.
# If you EXPOSE a port and run docker with -p, the port in the container is accessible from anywhere, even outside Docker.

## Port forward from the host system to the docker container
```bash
iptables -t nat -A  DOCKER -p tcp --dport 8002 -j DNAT --to-destination 172.17.0.19:8000
sudo docker run -i -p 22 -p 8000:80 -m /data:/data -t foo/live /bin/bash
```

## Troubleshooting
### Minecraft client can not connect to CraftBukkit server

01:52:50 [INFO] /172.17.42.1:47255 lost connection
* What is your client version?
* If it's 1.7.2, you need to edit your profile and select 1.6.4 to match craftbukkit.


## Server Commands
* http://wiki.ess3.net/wiki/Command_Reference

### Summon
summon Sheep 397 66 267


### Control the Weather
weather thunder 600

### Experience Points
xp 1000 DevoKun

### Give
give DevoKun 50 64
give DevoKun 5 64

#### Item ID's
* 1 : smooth Stone
* 2 : Dirt Block with Grass
* 3 : Plain Dirt Block
* 4 : Cobblestone
* 5 : Wood (Plank)
* 6 : Shrub
* 7 : Adminium/bedrock
* 8 : water (Spring)
* 9 : water (Block)
* 10: Lava (Spring)
* 11: Lava (Block)
* 12: Sand
* 13: Gravel
* 14: Gold Ore Block
* 15: Iron Ore Block
* 16: Coal Block
* 17: Wood (Tree Trunk)
* 18: Leaf Block
* 19: Sponge
* 20: Glass
* 37: Yellow Flower
* 38: Red Rose
* 39: Brown Mushroom
* 40: Red Mushroom
* 41: Gold Block
* 42: Iron Block
* 43: Step Block (Double)
* 44: Step Block (Single)
* 45: Brick Block
* 46: TNT
* 47: Bookcase
* 48: Mossy Cobblestone
* 49: Obsidian
* 50: Torch
* 51: Fire
* 52: Pig Spawner (Mob Spawner)
* 53: Wooden Stairs
* 54: Treasure Chest
* 55: Redstone Dust (Wire)
* 56: Diamond (Ore Block)
* 57: Diamond (Solid Block)
* 58: Crafting Bench
* 59: Crops (like from a Seed)
* 60: Dirt Tilled
* 61: Furnace
* 62: Furnace (Burning)
* 63: Sign
* 64: Wood Door (Bottom Half)
* 65: Ladder
* 66: Rails
* 67: Cobblestone Stairs
* 68: Sign (Like on a Wall)
* 69: Lever
* 70: Pressure Plate (Stone)
* 71: Iron Door (Bottom half only)
* 72: Pressure Plate (Wooden)
* 73: Redstone (Ore Block)
* 74: Redstone (Ore Block, glowing)
* 75: Redstone torch (off state)
* 76: Redstone torch (on state)
* 77: Button
* 78: Snow (like ontop of a block)
* 79: Ice Block
* 80: Snow (Block)
* 81: Cactus Piece
* 82: Clay (Block)
* 83: Bamboo
* 84: Jukebox
* 256: Iron Spade
* 257: Iron Pickaxe
* 258: Iron Axe
* 259: Flint and Steel
* 260: Apple
* 261: Bow
* 262: Arrow
* 263: Coal
* 264: Diamond
* 265: Iron Ingot
* 266: Gold Ingot
* 267: Iron Sword
* 268: Wooden Sword
* 269: Wooden Spade
* 270: Wooden Pickaxe
* 271: Wooden Axe
* 272: Stone Sword
* 273: Stone Spade
* 274: Stone Pickaxe
* 275: Stone Axe
* 276: Diamond Sword
* 277: Diamond Spade
* 278: Diamond Pickaxe
* 279: Diamond Axe
* 280: Stick
* 281: Bowl
* 282: Mushroom Soup
* 283: Gold Sword
* 284: Gold Spade
* 285: Gold Pickaxe
* 286: Gold Axe
* 287: String
* 288: Feather
* 289: Gunpowder
* 290: Wooden Hoe
* 291: Stone Hoe
* 292: Iron Hoe
* 293: Diamond Hoe
* 294: Gold Hoe
* 295: Seeds
* 296: Wheat
* 297: Bread
* 298: Leather Helmet
* 299: Leather Chestplate
* 300: Leather Pants
* 301: Leather Boots
* 302: Chainmail Helmet
* 303: Chainmail Chestplate
* 304: Chainmail Pants
* 305: Chainmail Boots
* 306: Iron Helmet
* 307: Iron Chestplate
* 308: Iron Pants
* 309: Iron Boots
* 310: Diamond Helmet
* 311: Diamond Chestplate
* 312: Diamond Pants
* 313: Diamond Boots
* 314: Gold Helmet
* 315: Gold Chestplate
* 316: Gold Pants
* 317: Gold Boots
* 318: Flint
* 319: Pork
* 320: Grilled Pork
* 321: Paintings
* 322: Golden apple
* 323: Sign
* 324: Wooden door
* 325: Bucket
* 326: Water bucket
* 327: Lava bucket
* 328: Mine cart
* 329: Saddle
* 330: Iron door
* 331: Redstone
* 332: Snowball
* 333: Boat
* 334: Leather
* 335: Milk Bucket
* 336: Clay Brick
* 337: Clay Balls
* 338: Papyrus
* 339: Paper
* 340: Book
* 341: Slime Ball
* 342: Storage Minecart
* 343: Powered Minecart
* 344: Egg
* 2256: Gold Record
* 2257: Green Record


### Essentials Plugins
fly DevoKun on

bigtree redwood
















