## docker pull ubuntu:14.04.1
## docker run -ti ubuntu:14.04.1 /bin/bash
##
## docker build -t awsmaine/dec2014 .
## docker push awsmaine/dec2014
##
## docker run -ti -v $(pwd)/:/site -p 4000:4000 awsmaine:dec2014
## cd /site
## jekyll new blog
## cd blog
## echo "highlighter: rouge" >> _config.yml
## jekyll serve
##
## boot2docker ip
##
## s3_website push


FROM ubuntu:14.04.1

MAINTAINER Devon Hubner <devon@hubner.org>

RUN apt-get update
RUN apt-get install -y vim p7zip-full wget
## development libs needed for AWS-SDK
##    or more specifically, nokogiri..
RUN apt-get install -y ruby-dev build-essential libxslt-dev libxml2-dev
## Javascript runtime for Jekyll
## install execjs and therubyracer gems, or install nodejs
RUN apt-get install -y nodejs
## jekyll
RUN gem install jekyll
## use rouge for syntax highlighting instead of pygments
RUN gem install rouge
## install pygments because jekyll complains without it
RUN apt-get install -y python-pygments
## aws-sdk for uploading to s3
RUN gem install aws-sdk
## s3_website uploads static websites, or jekyll sites, to s3/cloudfront.
## s3_website push results:
##   Downloading https://github.com/laurilehmijoki/s3_website/releases/download/v2.7.2/s3_website.jar into /var/lib/gems/1.9.1/gems/s3_website-2.7.2/s3_website-2.7.2.jar
RUN gem install s3_website
##
## s3_website *push* is written in scala and requires java
RUN apt-get install -y openjdk-7-jre-headless

EXPOSE 80 4000




