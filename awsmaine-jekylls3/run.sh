#!/bin/bash

docker run -ti \
  -v $(pwd)/../../../sites/aws-maine/aws-maine.org:/site \
  -p 4000:4000 \
  awsmaine:dec2014



