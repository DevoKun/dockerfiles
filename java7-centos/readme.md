Java7 on CentOS 6 Container
===========================

* [Download the Java 7 SDK from Oracle](http://www.java.com/) and copy the RPM in to the files directory.
* Current **Dockerfile** expects: **jdk-7u71-linux-x64.rpm**.

## Compile Netflix Priam
* Includes a bash script for downloading and compiling Netflix Priam.

```bash
sudo docker build -t local:centos6java7u71 .
sudo docker run -v $(pwd)/compile_priam:/usr/src/compile_priam -i -t local:centos6java7u71 /usr/src/compile_priam/compile_priam.sh
```



