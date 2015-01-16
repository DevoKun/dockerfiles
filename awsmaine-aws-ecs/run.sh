docker run -ti \
  -v $(pwd)/aws-config:/root/.aws \
  -p 4000:4000 \
  awsmaine/jan2015:latest \
  /bin/bash


