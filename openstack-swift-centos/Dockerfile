# docker pull centos:centos6
# docker run -i -t centos:centos6 /bin/bash
#
# docker build --no-cache=true --rm=true -t local:swift .
#
# docker run -i -t local:swift /bin/bash
#
# docker run -p 8080:8080 -v srv:/srv -v logs:/var/logs -t -i local:vsftp
#
FROM centos:centos6

MAINTAINER Devon Hubner <devon@hubner.org>

RUN echo -e "\n\n\033[37;1m  * \033[33;1mPuppet and Supervisord from EPEL\033[37;0m"

##### Puppet and Supervisor(d) come from EPEL
# http://dl.fedoraproject.org/pub/epel/6Server/x86_64/epel-release-6-8.noarch.rpm
##### rpm2cpio epel-release-6-8.noarch.rpm | cpio -idmv
# ADD files/epel.repo /etc/yum.repos.d/
ADD files/etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6 /etc/pki/rpm-gpg/
ADD files/etc/yum.repos.d/epel.repo          /etc/yum.repos.d/

#RUN echo "priority=5" >> /etc/yum.repos.d/libselinux.repo
RUN /bin/bash -c "if [ -f /etc/yum.repos.d/libselinux.repo ]; then echo 'priority=5' >> /etc/yum.repos.d/libselinux.repo; fi"

RUN yum install -y puppet supervisor

ADD files/supervisord.conf /etc/



RUN echo -e "\n\n\033[37;1m  * \033[33;1mMemcached\033[37;0m"

##### Swift uses memcached
##### XFSprogs aren't required unless a loopback device is created/used
##### xinetd is needed to start rsyncd
##### rsync is used to synchronize data between nodes,
#####       effectively providing the consistency in "eventual consistency",
RUN yum install -y memcached xinetd rsync
#RUN yum install -y xfsprogs


RUN echo -e "\n\n\033[37;1m  * \033[33;1mRsyncd\033[37;0m"

##### RsyncD: Used to transfer files between swift nodes
#####         run by xinetd. Not needed unless running multiple nodes.
ADD files/rsyncd.conf /etc/
ADD files/etc_xinetd.d_rsync /usr/src/
RUN cat /usr/src/etc_xinetd.d_rsync > /etc/xinetd.d/rsync


RUN echo -e "\n\n\033[37;1m  * \033[33;1mRDO \033[37;0m"

##### Install the RDO package repository:
# ADD files/rdo-release-icehouse-4.noarch.rpm /usr/src/
# RUN yum localinstall -y /usr/src/rdo-release-icehouse-4.noarch.rpm
##### rpm2cpio rdo-release-icehouse-4.noarch.rpm | cpio -idmv
ADD files/etc/pki/rpm-gpg/RPM-GPG-KEY-RDO-Icehouse /etc/pki/rpm-gpg/
ADD files/etc/pki/rpm-gpg/RPM-GPG-KEY-foreman      /etc/pki/rpm-gpg/
ADD files/etc/pki/rpm-gpg/RPM-GPG-KEY-puppetlabs   /etc/pki/rpm-gpg/
ADD files/etc/yum.repos.d/foreman.repo             /etc/yum.repos.d/
ADD files/etc/yum.repos.d/puppetlabs.repo          /etc/yum.repos.d/
ADD files/etc/yum.repos.d/rdo-release.repo         /etc/yum.repos.d/

RUN sed -i 's/%FDIST%%RELEASEVER%/el6/g'    /etc/yum.repos.d/foreman.repo
RUN sed -i 's/%DIST%-%RELEASEVER%/epel-6/g' /etc/yum.repos.d/rdo-release.repo
RUN sed -i 's/%DIST%/el/g'                  /etc/yum.repos.d/puppetlabs.repo
RUN sed -i 's/%RELEASEVER%/6/g'             /etc/yum.repos.d/puppetlabs.repo

RUN echo -e "\n\n\033[37;1m  * \033[33;1mSwift\033[37;0m"

##### Swift
RUN yum install -y openstack-swift-proxy python-swiftclient python-keystone-auth-token
RUN yum install -y openstack-swift-account openstack-swift-container openstack-swift-object
ADD files/account-server.conf    /etc/swift/
ADD files/container-server.conf  /etc/swift/
ADD files/object-server.conf     /etc/swift/
ADD files/proxy-server.conf      /etc/swift/
ADD files/swift.conf             /etc/swift/

ADD files/swift_ring_init.sh     /usr/local/sbin/
RUN chmod 0755 /usr/local/sbin/swift_ring_init.sh




EXPOSE 8080 9001

####
#### There can only be one CMD instruction in a Dockerfile.
#### If you list more than one CMD then only the last CMD will take effect.
####
CMD ["/usr/local/sbin/swift_ring_init.sh"]



