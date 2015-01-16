#!/bin/bash

##
## force-rm : remove intermediate container after unsucessful build.
## no-cache : do not use cache to build container.

##
## 'Apt-get update' cache becomes stale:
##
## E: Failed to fetch http://archive.ubuntu.com/ubuntu/pool/main/n/nss/libnss3_3.17.1-0ubuntu0.14.04.1_amd64.deb
##    404  Not Found [IP: 91.189.92.201 80]
##

docker build \
  --force-rm=true \
  --no-cache=true \
  -t awsmaine/dec2014 .

#docker build \
#  -t awsmaine/dec2014 .
