#!/bin/bash

MAXPERMSIZE="128m"
MAXPERMSIZE="512m"
export HTTP_PORT="8080"
export HTTP_HOST="localhost"
export ASGARD_HOME="/opt/asgard"

cd $ASGARD_HOME
java \
  -Xmx1024M \
  -XX:MaxPermSize=${MAXPERMSIZE} \
  -DskipCacheFill=true \
  -jar asgard-standalone.jar \
  "" $HTTP_HOST $HTTP_PORT

echo $?

