#!/bin/bash

export LOCALDIR="$(pwd)/devokunjenkins"
if [ ! -d $LOCALDIR ]; then
  mkdir $LOCALDIR
fi

sudo docker run -p 8080:8080 -p 50000:50000 -v $LOCALDIR:/var/jenkins_home devokun/jenkins

