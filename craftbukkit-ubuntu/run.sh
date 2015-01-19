#!/bin/bash



docker run -ti \
  -v $(pwd)/server.properties:/opt/minecraft/server.properties \
  -v $(pwd)/ops.txt:/opt/minecraft/ops.txt \
  -v $(pwd)/white-list.txt:/opt/minecraft/white-list.txt \
  -p 25565:25565 \
  devokun/bukkit
  /bin/bash



