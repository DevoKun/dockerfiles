## Build
##   sudo docker build -t local:centos6java7u71asgard .
##
## Interactive:
##   sudo docker run -p 8080:8080 -p 9001:9001 -v $(pwd)/files/Config.groovy:/opt/asgard/Config.groovy local:centos6java7u71asgard
##
## Daemon mode:
##   sudo docker run -d -p 8080:8080 -p 9001:9001 -v $(pwd)/files/Config.groovy:/opt/asgard/Config.groovy local:centos6java7u71asgard
##
## Diagnose:
##   sudo docker run -i -t -p 8080:8080 -p 9001:9001 -v $(pwd)/files/Config.groovy:/opt/asgard/Config.groovy local:centos6java7u71asgard /bin/bash

# sudo docker run -p 8080:8080 -p 9001:9001 -v $(pwd)/files/Config.groovy:/opt/asgard/Config.groovy local:centos6java7u71asgard

# REF: https://github.com/Netflix-Skunkworks/zerotodocker/blob/master/asgard/Dockerfile
# FROM netflixoss/tomcat:7
FROM local:centos6java7u71

MAINTAINER Devon Hubner <devon@hubner.org>

####
#### https://netflixoss.ci.cloudbees.com/job/asgard-master/
#### https://netflixoss.ci.cloudbees.com/job/asgard-master/lastSuccessfulBuild/artifact/target/asgard.war
#### https://netflixoss.ci.cloudbees.com/job/asgard-master/lastSuccessfulBuild/artifact/asgard-standalone.jar
####

RUN yum install -y wget


#############
############# Run inside Tomcat
#############
# ADD files/etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6 /etc/pki/rpm-gpg/
# ADD files/etc/yum.repos.d/epel.repo          /etc/yum.repos.d/
# RUN echo "priority=5" >> /etc/yum.repos.d/libselinux.repo
# RUN yum install -y tomcat tomcat-admin-webapps tomcat-webapps
# ADD files/tomcat-users.xml /etc/tomcat/
# RUN wget -O /usr/share/tomcat/webapps/asgard.war https://netflixoss.ci.cloudbees.com/job/asgard-master/lastSuccessfulBuild/artifact/target/asgard.war
#
#CMD ["/usr/local/sbin/tomcat_run.sh"]

#############
############# Run standalone
#############
RUN mkdir /opt/asgard
RUN wget -O /opt/asgard/asgard-standalone.jar https://netflixoss.ci.cloudbees.com/job/asgard-master/lastSuccessfulBuild/artifact/asgard-standalone.jar
ADD files/asgard-standalone.sh /opt/asgard/
RUN chmod 0755 /opt/asgard/asgard-standalone.sh
####### -v $(pwd)/files/Config.groovy:/opt/asgard/Config.groovy
# ADD files/Config.groovy /opt/asgard/
#######

CMD ["/opt/asgard/asgard-standalone.sh"]

EXPOSE 8080 9001




