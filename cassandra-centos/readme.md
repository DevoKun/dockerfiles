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



## Priam SimpleDB

### SimpleDB stores data in a hierarchy of:
* Domains > Items > Attributes

### Schema
**FROM:** ./priam/src/main/java/com/netflix/priam/SimpleDBConfigSource.java

* **appId**    = ASG up to first instance of '-'.  So ASG name priam-test will create appId priam, ASG priam_test will create appId priam_test.
* **property** = Key to use for configs.
* **value**    = Value to set for the given property/key.
* **region**   = Region the config belongs to. If left empty, then applies to all regions.

### Select from SimpleDB
** FROM:** ./priam/src/main/java/com/netflix/priam/SimpleDBConfigSource.java

```sql
SELECT * FROM PriamProperties WHERE appId='%s'
```







