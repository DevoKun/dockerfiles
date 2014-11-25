# docker pull ubuntu:14.04.1
# docker run -i -t ubuntu:14.04.1 /bin/bash

# docker build -t local:ubuntu1404java7 .

##
## Interactive:
##   sudo docker run -p 8080:8080 -p 9001:9001  local:ubuntu1404java7
##
## Daemon mode:
##   sudo docker run -d -p 8080:8080 -p 9001:9001  local:ubuntu1404java7
##
## Diagnose:
##   sudo docker run -i -t -p 8080:8080 -p 9001:9001 local:ubuntu1404java7 /bin/bash

FROM ubuntu:14.04.1

MAINTAINER Devon Hubner <devon@hubner.org>

RUN apt-get update -y

ADD files/jdk-7u71-linux-x64.gz /usr/src/
RUN mkdir -p /usr/java ; tar zxf /usr/src/jdk-7u71-linux-x64.gz -C /usr/java

RUN echo 'export JAVA_HOME=/usr/java/jdk1.7.0_71' >> /etc/profile.d/java.sh
RUN echo 'export JRE_HOME=/usr/java/jdk1.7.0_71/jre' >> /etc/profile.d/java.sh
RUN echo 'export PATH=$PATH:/usr/java/jdk1.7.0_71/bin:/usr/java/jdk1.7.0_71/jre/bin' >> /etc/profile.d/java.sh
RUN chmod 0755 /etc/profile.d/java.sh
RUN source /etc/profile.d/java.sh
RUN alternatives --install /usr/bin/java  java  /usr/java/jdk1.7.0_71/bin/java  2
RUN alternatives --install /usr/bin/jar   jar   /usr/java/jdk1.7.0_71/bin/jar   2
RUN alternatives --install /usr/bin/javac javac /usr/java/jdk1.7.0_71/bin/javac 2
RUN alternatives --set java  /usr/java/jdk1.7.0_71/bin/java
RUN alternatives --set jar   /usr/java/jdk1.7.0_71/bin/jar
RUN alternatives --set javac /usr/java/jdk1.7.0_71/bin/javac





