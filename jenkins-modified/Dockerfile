# jenkins:latest is built from "Debian GNU/Linux jessie/sid"
FROM jenkins:latest
MAINTAINER Devon Hubner <devon@hubner.org>
USER root
RUN apt-get update
RUN apt-get install -y mercurial
RUN apt-get install -y wget
RUN apt-get install -y p7zip-full
RUN wget -O /usr/src/puppetlabs-release-stable.deb https://apt.puppetlabs.com/puppetlabs-release-stable.deb
RUN dpkg -i /usr/src/puppetlabs-release-stable.deb
RUN apt-get install -y puppet-common
RUN puppet module install puppetlabs/stdlib
RUN puppet module install puppetlabs/concat
#RUN puppet module install puppetlabs/apache
RUN puppet module install maestrodev/rvm
#ADD hiera.yaml /etc/puppet/hiera.yaml
ADD jenkins.pp /etc/puppet/jenkins.pp
RUN puppet apply /etc/puppet/jenkins.pp
#RUN source /etc/profile.d/rvm.sh

#USER jenkins

