## docker pull ubuntu:14.04.1
## docker run -ti ubuntu:14.04.1 /bin/bash
##
## docker build -t local:ubuntu1404shib .
##
##
## Interactive:
#mkdir logs
#docker run -p 443:443 -p 9001:9001 
#    -v $(pwd)/logs:/var/log \
#    -v $(pwd)/sp-cert.pem:/etc/shibboleth/sp-cert.pem \
#    -v $(pwd)/sp-key.pem:/etc/shibboleth/sp-key.pem \
#    -v $(pwd)/sp-metadata.xml:/etc/shibboleth/sp-metadata.xml \
#    -v $(pwd)/shibboleth2.xml:/etc/shibboleth/shibboleth2.xml \
#    -v $(pwd)/attribute-map.xml:/etc/shibboleth/attribute-map.xml
#    local:ubuntu1404shib
##   
##



FROM ubuntu:14.04.1

MAINTAINER Devon Hubner <devon@hubner.org>

RUN apt-get update
RUN apt-get install -y apache2

###
### Common reverse proxy modules
###
RUN a2enmod proxy
RUN a2enmod proxy_ajp
RUN a2enmod proxy_balancer
RUN a2enmod proxy_http

###
### Shibboleth-SP
###
RUN apt-get install -y libapache2-mod-shib2
RUN a2enmod shib2

RUN openssl req -new -x509 -keyout /etc/shibboleth/sp-key.pem -out /etc/shibboleth/sp-cert.pem -days 999 -nodes -subj "/C=US/ST=Maine/L=Docker/O=Docker/OU=SP/CN=docker-sp/emailAddress=docker@local"
# ./metagen.sh -2 -h .com -e .com > /etc/shibboleth/sp-metadata.xml

###
### Supervisord
###
RUN apt-get install -y supervisor
ADD files/supervisord.conf /etc/



EXPOSE 80 443 8080 8443 9001


####
#### There can only be one CMD instruction in a Dockerfile.
#### If you list more than one CMD then only the last CMD will take effect.
####
CMD ["/usr/bin/supervisord"]



