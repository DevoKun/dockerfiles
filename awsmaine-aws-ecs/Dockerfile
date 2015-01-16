## docker pull ubuntu:14.04.1
## docker run -ti ubuntu:14.04.1 /bin/bash
##
## docker build -t awsmaine/jan2015 .
##
## the ~/.aws directory should contain the credentials needed for the AWS CLI.
## FILE: .aws/config
##    [default]
##    region=us-east-1
##    outpit=json
##
## FILE: .aws/credentials
##    [default]
##    aws_access_key_id=xxxx
##    aws_secret_access_key=xxxx
##
## docker run -ti -v $(pwd)/.aws:/root/.aws -p 4000:4000 awsmaine:jan2015
##
## boot2docker ip


FROM ubuntu:14.04.1

MAINTAINER Devon Hubner <devon@hubner.org>

RUN apt-get update
RUN apt-get install -y vim unzip
RUN apt-get install -y python

## AWS CLI
## RUN apt-get install -y awscli

## AWS ECS Preview CLI
## https://s3.amazonaws.com/ecs-preview-docs/amazon-ecs-cli-preview.tar.gz
ADD amazon-ecs-cli-preview.tar.gz /usr/src/
RUN unzip -d /usr/src/ /usr/src/amazon-ecs-cli-preview/ecs-cli.zip
RUN (cd /usr/src/awscli-bundle && ./install --install-dir=/usr/local/)


