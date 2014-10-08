# docker pull centos:centos6
# docker build -t local:vsftp .
# docker run -i -t local:vsftp /bin/bash
# docker run -p 2200:22 -v logs:/var/logs -t -i local:vsftp

FROM centos:centos6

MAINTAINER Devon Hubner <devon@hubner.org>

##### Puppet comes from EPEL
ADD epel.repo /etc/yum.repos.d/
RUN yum install -y puppet

##### vsFTP install and setup through Puppet
ADD vsftp.pp  /usr/src/
RUN puppet apply /usr/src/vsftp.pp

EXPOSE 20 21 22 80 443 9001
#CMD ["/usr/bin/supervisord"]



