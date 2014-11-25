# docker pull centos:centos6
# docker run -i -t centos:centos6 /bin/bash
#
# cp ../java7-centos/compile_priam/priam/priam-web/build/libs/priam-web-2.0.1.war files/
# cp ../java7-centos/compile_priam/priam/priam-cass-extensions/build/libs/priam-cass-extensions-2.0.1.jar  files/
# docker build -t local:centos6java7u71cassandra .
#
##
## Interactive:
##   sudo docker run -p 8080:8080 -p 9001:9001  local:centos6java7u71cassandra
##
## Daemon mode:
##   sudo docker run -d -p 8080:8080 -p 9001:9001  local:centos6java7u71cassandra
##
## Diagnose:
##   sudo docker run -i -t -p 8080:8080 -p 9001:9001 local:centos6java7u71cassandra /bin/bash



FROM local:centos6java7u71

MAINTAINER Devon Hubner <devon@hubner.org>

##### Puppet and Supervisor(d) come from EPEL
##### wget http://dl.fedoraproject.org/pub/epel/6Server/x86_64/epel-release-6-8.noarch.rpm
##### rpm2cpio epel-release-6-8.noarch.rpm | cpio -idmv
#####     ./etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6
#####     ./etc/rpm/macros.ghc-srpm
#####     ./etc/yum.repos.d/epel-testing.repo
#####     ./etc/yum.repos.d/epel.repo
#####     ./usr/share/doc/epel-release-6
#####     ./usr/share/doc/epel-release-6/GPL

ADD files/etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6 /etc/pki/rpm-gpg/
ADD files/etc/yum.repos.d/epel.repo          /etc/yum.repos.d/

# http://www.datastax.com/documentation/cassandra/2.0/cassandra/install/installRHEL_t.html
ADD files/datastax.repo /etc/yum.repos.d/

RUN echo "priority=5" >> /etc/yum.repos.d/libselinux.repo

RUN yum install -y puppet supervisor
RUN yum install -y jna
ADD files/supervisord_tomcat.sh /usr/local/sbin/
RUN chmod 0755 /usr/local/sbin/supervisord_tomcat.sh
ADD files/supervisord.conf /etc/

####
#### Sudoers required so Priam running in Tomcat can start Cassandra
####
ADD files/sudoers /etc/

####
#### Priam Configuration Properties
####
ADD files/Priam.properties /etc/
ADD files/awscredential.properties /etc/

####
#### DataStax Cassandra
#### http://rpm.datastax.com/community/noarch/
RUN yum install -y dsc20 cassandra20 opscenter

####
#### Compile Priam using the Java7 container first
####

#### 
#### Deploy Priam.war to Tomcat
####

# RUN yum install -y wget
# RUN wget -O /usr/src/tomcat-7.0.57.tar.gz http://apache.hippo.nl/tomcat/tomcat-7/v7.0.57/bin/apache-tomcat-7.0.57.tar.gz
# RUN tar -xzf /tmp/tomcat7.0.57.tar.gz -C /tmp
# RUN mkdir -p /usr/share/tomcat7
# RUN mv /tmp/apache-tomcat-7.0.57/* /usr/share/tomcat7

RUN yum install -y tomcat tomcat-admin-webapps tomcat-webapps
# ADD ../java7-centos/compile_priam/priam/priam-web/build/lib/priam/priam-web-2.0.1.war /usr/share/tomcat/webapps/
ADD files/priam-web-2.0.1.war /usr/share/tomcat/webapps/
RUN mv /usr/share/tomcat/webapps/priam-web-2.0.1.war /usr/share/tomcat/webapps/priam.war

####
#### user configuration for access to the tomcat manager app
####
ADD files/tomcat-users.xml /etc/tomcat/

####
#### Script for starting Tomcat
#### catalina.sh is not included with CentOS 6
####
ADD files/tomcat_run.sh /usr/local/sbin/
RUN chmod 0755 /usr/local/sbin/tomcat_run.sh

####
#### Priam Agent
####

# ADD ../java7-centos/compile_priam/priam/priam/build/lib/priam/priam-2.0.1-javadoc.jar
# ADD ../java7-centos/compile_priam/priam/priam/build/lib/priam/priam-2.0.1-sources.jar
# ADD ../java7-centos/compile_priam/priam/priam/build/lib/priam/priam-2.0.1.jar
# ADD ../java7-centos/compile_priam/priam/priam-agent/build/lib/priam/priam-agent-2.0.1-javadoc.jar
# ADD ../java7-centos/compile_priam/priam/priam-agent/build/lib/priam/priam-agent-2.0.1-sources.jar
# ADD ../java7-centos/compile_priam/priam/priam-agent/build/lib/priam/priam-agent-2.0.1.jar


####
#### Cassandra Extensions
####
#### Copy priam-cass-extensions-<version>.jar into your $CASS_HOME/libdirectory
####

# ADD ../java7-centos/compile_priam/priam/priam-cass-extensions/build/lib/priam/priam-cass-extensions-2.0.1-javadoc.jar /usr/share/cassandra/lib/
# ADD ../java7-centos/compile_priam/priam/priam-cass-extensions/build/lib/priam/priam-cass-extensions-2.0.1-sources.jar /usr/share/cassandra/lib/
# ADD ../java7-centos/compile_priam/priam/priam-cass-extensions/build/lib/priam/priam-cass-extensions-2.0.1.jar /usr/share/cassandra/lib/
ADD files/priam-cass-extensions-2.0.1.jar /usr/share/cassandra/lib/

####
#### DataStax Enterprise Cassandra Extensions
####

# ADD ../java7-centos/compile_priam/priam/priam-dse-extensions/build/lib/priam/priam-dse-extensions-2.0.1-javadoc.jar
# ADD ../java7-centos/compile_priam/priam/priam-dse-extensions/build/lib/priam/priam-dse-extensions-2.0.1-sources.jar
# ADD ../java7-centos/compile_priam/priam/priam-dse-extensions/build/lib/priam/priam-dse-extensions-2.0.1.jar

####
#### Priam Web
####

# ADD ../java7-centos/compile_priam/priam/priam-web/build/lib/priam/priam-web-2.0.1-javadoc.jar
# ADD ../java7-centos/compile_priam/priam/priam-web/build/lib/priam/priam-web-2.0.1-sources.jar
# ADD ../java7-centos/compile_priam/priam/priam-web/build/lib/priam/priam-web-2.0.1.jar





EXPOSE 8080 9001

####
#### There can only be one CMD instruction in a Dockerfile.
#### If you list more than one CMD then only the last CMD will take effect.
####
CMD /usr/bin/supervisord



