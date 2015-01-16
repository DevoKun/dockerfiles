# docker pull ubuntu:14.04.1
# docker run -i -t ubuntu:14.04.1 /bin/bash
#
## Build
##   sudo docker build -t local:ubuntu1404etcd046 .
##
## Interactive:
##   sudo docker run -p 8080:8080 -p 9001:9001 local:ubuntu1404etcd046
##
## Daemon mode:
##   sudo docker run -d -p 8080:8080 -p 9001:9001 local:ubuntu1404etcd046
##
## Bind etcd.conf:
##   sudo docker run -p 8080:8080 -p 9001:9001 -v $(pwd)/files/etcd.conf:/etc/etcd.conf local:ubuntu1404etcd046
##
## Diagnose:
##   sudo docker run -i -t -p 8080:8080 -p 9001:9001 local:ubuntu1404etcd046 /bin/bash


FROM ubuntu:14.04.1

MAINTAINER Devon Hubner <devon@hubner.org>

# https://github.com/coreos/etcd/tags


ADD files/etcd_0.4.6_amd64.deb /usr/src/
RUN dpkg -i /usr/src/etcd_0.4.6_amd64.deb
RUN mkdir -p /var/lib/etcd /etc/etcd
ADD files/etcd.conf /etc/etcd/


EXPOSE 8080 9001

####
#### There can only be one CMD instruction in a Dockerfile.
#### If you list more than one CMD then only the last CMD will take effect.
####
CMD ["/usr/bin/etcd"]


