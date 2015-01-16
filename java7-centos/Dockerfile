# docker pull centos:centos6
# docker run -i -t centos:centos6 /bin/bash
# docker run -v $(pwd):/usr/src/java -i -t centos:centos6 /bin/bash
#
# docker build -t local:centos6java7u71 .
# docker run -i -t local:centos6java7u71 /bin/bash
#
FROM centos:centos6

MAINTAINER Devon Hubner <devon@hubner.org>



#RUN echo "priority=5" >> /etc/yum.repos.d/libselinux.repo
RUN /bin/bash -c "if [ -f /etc/yum.repos.d/libselinux.repo ]; then echo 'priority=5' >> /etc/yum.repos.d/libselinux.repo; fi"

##### jna comes from EPEL
##### wget http://dl.fedoraproject.org/pub/epel/6Server/x86_64/epel-release-6-8.noarch.rpm
##### rpm2cpio epel-release-6-8.noarch.rpm | cpio -idmv
ADD files/etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6 /etc/pki/rpm-gpg/
ADD files/etc/yum.repos.d/epel.repo          /etc/yum.repos.d/
RUN yum install -y jna


### Oracle Java 7u71
ADD files/jdk-7u71-linux-x64.rpm /usr/src/
RUN yum localinstall -y /usr/src/jdk-7u71-linux-x64.rpm

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


