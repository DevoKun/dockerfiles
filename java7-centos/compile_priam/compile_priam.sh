#!/bin/bash

#
# docker build -t local:centos6java7u71 .
# docker run -v $(pwd)/compile_priam:/usr/src/compile_priam -i -t local:centos6java7u71 /usr/src/compile_priam/compile_priam.sh
#

source /etc/profile.d/java.sh

if [ ! -f /usr/bin/git ]; then
  yum install -y git
fi

if [ -d /usr/src/compile_priam/priam ]; then
  cd /usr/src/compile_priam/priam
  git pull
else
  git clone https://github.com/Netflix/Priam.git /usr/src/compile_priam/priam
fi

cd /usr/src/compile_priam/priam
chmod +x ./gradlew
./gradlew build



