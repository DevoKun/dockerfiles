##
## sudo docker build -t local:centos6java7u71stash242 .
##
## mkdir -p stash-home/log
## touch stash-home/log/atlassian-stash-mail.log
##
## Interactive:
##   sudo docker run -p 7990:7990 -v $(pwd)/stash-home:/var/lib/stash local:centos6java7u71stash242
## Daemon mode:
##   sudo docker run -d -p 7990:7990 -v $(pwd)/stash-home:/var/lib/stash local:centos6java7u71stash242
## Diagnose:
##   sudo docker run -i -t -p 7990:7990 -v $(pwd)/stash-home:/var/lib/stash local:centos6java7u71stash242 /bin/bash

FROM local:centos6java7u71

MAINTAINER Devon Hubner <devon@hubner.org>

# RUN yum install -y supervisor
# ADD files/supervisord.conf /etc/

RUN yum install -y wget tar gzip

RUN echo "priority=5" >> /etc/yum.repos.d/libselinux.repo

# Stash 2.4.2 requires git 1.7.6 or higher.

##### repoforge is supposed to have recent packages: http://pkgs.repoforge.org/git/
##### http://pkgs.repoforge.org/git/git-1.7.12.4-1.el6.rfx.x86_64.rpm
##### yum -y localinstall git-1.7.12.4-1.el6.rfx.x86_64.rpm
##### wget http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm
##### rpm2cpio rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm | cpio -idmv
# ADD files/etc/pki/rpm-gpg/RPM-GPG-KEY-rpmforge-dag    /etc/pki/rpm-gpg/
# ADD files/etc/pki/rpm-gpg/RPM-GPG-KEY-rpmforge-fabian /etc/pki/rpm-gpg/
# ADD files/etc/yum.repos.d/rpmforge.repo               /etc/yum.repos.d/
# RUN yum install -y git


##### The IUS Community repo has a 1.8 version.
##### https://iuscommunity.org/
##### IUS is a packaging effort from RackSpace to address just this sort of trailing application version in RHEL repos. Not official, but much better maintained than rpmforge. 
##### http://dl.iuscommunity.org/pub/ius/stable/CentOS/6/x86_64/repoview/ius-release.html
##### wget http://dl.iuscommunity.org/pub/ius/stable/CentOS/6/x86_64/ius-release-1.0-13.ius.centos6.noarch.rpm
##### rpm2cpio ius-release-1.0-13.ius.centos6.noarch.rpm | cpio -idmv
# ADD files/etc/pki/rpm-gpg/IUS-COMMUNITY-GPG-KEY  /etc/pki/rpm-gpg/
# ADD files/etc/yum.repos.d/ius.repo               /etc/yum.repos.d/
# RUN yum install -y git


#####
##### When in doubt, compile from scratch
##### 
RUN yum groupinstall -y "Development Tools"
##### Development Tools will install git
RUN yum remove -y git perl-Git ; true
##### Installed by Development Tools
# RUN yum install -y curl-devel expat-devel gettext-devel openssl-devel zlib-devel
RUN wget -O /usr/src/git-1.9.4.tar.gz https://github.com/git/git/archive/v1.9.4.tar.gz
RUN tar zxf /usr/src/git-1.9.4.tar.gz -C /usr/src
RUN cd /usr/src/git-1.9.4 && make configure && ./configure --without-tcltk --without-python --without-iconv --prefix=/usr && make NO_PERL=1 && make install NO_PERL=1
#  all doc info


RUN wget -O /usr/src/stash.tar.gz http://www.atlassian.com/software/stash/downloads/binary/atlassian-stash-2.4.2.tar.gz
RUN mkdir -p /opt/stash
RUN tar zxf /usr/src/stash.tar.gz --strip=1 -C /opt/stash
RUN mkdir -p /var/lib/stash
RUN groupadd -g 7990 stash
RUN useradd -d /var/lib/stash -c "Atlassian Stash" -M -r -s /bin/bash -u 7990 -g 7990 stash
RUN chown -R stash:stash /var/lib/stash
RUN chown -R stash:stash /opt/stash

EXPOSE 7990

WORKDIR /lib/stash

# USER stash

####
#### There can only be one CMD instruction in a Dockerfile.
#### If you list more than one CMD then only the last CMD will take effect.
####
# CMD /usr/local/sbin/stash-start-fg.sh
CMD (git --version && export STASH_HOME=/var/lib/stash && /opt/stash/bin/start-stash.sh -fg)


