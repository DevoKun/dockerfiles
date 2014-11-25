# docker pull ubuntu:14.04.1
# docker run -i -t ubuntu:14.04.1 /bin/bash

# https://www.atlassian.com/software/bamboo/download

##
## Interactive:
##   sudo docker run -p 8080:8080 -p 9001:9001  local:centos6java7u71cassandra
##
## Daemon mode:
##   sudo docker run -d -p 8080:8080 -p 9001:9001  local:centos6java7u71cassandra
##
## Diagnose:
##   sudo docker run -i -t -p 8080:8080 -p 9001:9001 local:centos6java7u71cassandra /bin/bash

FROM local:ubuntu1404java7

MAINTAINER Devon Hubner <devon@hubner.org>

RUN apt-get update -y
RUN apt-get install -y wget
RUN apt-get install -y fonts-liberation

#### python-software-properties provides add-apt-repository
# RUN apt-get install -y python-software-properties
# RUN add-apt-repository ppa:webupd8team/java
# RUN apt-get update
# RUN apt-get install -y oracle-java7-installer
# RUN update-alternatives --config java
#####


RUN wget -O /usr/src/bamboo-5.7.0.tar.gz http://www.atlassian.com/software/bamboo/downloads/binary/atlassian-bamboo-5.7.0.tar.gz
RUN tar zxf /usr/src/bamboo-5.7.0.tar.gz -C /opt
RUN mv /opt/atlassian-bamboo-5.7.0 /opt/bamboo
RUN echo "bamboo.home=/opt/bamboo" > /opt/bamboo/atlassian-bamboo/WEB-INF/classes/bamboo-init.properties

RUN apt-get install -y supervisor
ADD files/supervisord.conf /etc/

EXPOSE 8080 9001

####
#### There can only be one CMD instruction in a Dockerfile.
#### If you list more than one CMD then only the last CMD will take effect.
####
CMD /usr/bin/supervisord

