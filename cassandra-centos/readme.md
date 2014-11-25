Cassandra + Priam
=======================

## Install Oracle Java JDK 7

```bash
yum localinstall -y jdk-7u71-linux-x64.rpm
```

* **JDK:** /usr/java/jdk1.7.0_71/bin/java
* **JRE:** /usr/java/jdk1.7.0_71/jre/bin/java

## Compile Priam
* Use the 

```bash
sudo docker run -v $(pwd)/compile_priam:/usr/src/compile_priam -i -t local:centos6java7u71 /usr/src/compile_priam/compile_priam.sh
```

## S3 Bucket



## SimpleDB domain




