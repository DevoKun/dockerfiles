Jenkins
=======

## Build the Jenkins container
```bash
docker build -t devokun/jenkins .
```

## Run the Jenkins container
* The Jenkins **web** interface runs on port **8080**.
* Jenkins **slaves** will connect on port **50000**.
* Jenkins 

```bash
export LOCALDIR="$(pwd)/devokunjenkins"
if [ -d $LOCALDIR ]; then
  mkdir $LOCALDIR
fi

docker run --name devokunjenkins \
  -p 8080:8080 \
  -p 50000:50000 \
  -v $LOCALDIR:/var/jenkins_home \
  devokun/jenkins
```



