Atlassian Stash on CentOS
=========================

## Use the pre-built container with CentOS 6 and Oracle Java 7

* centos6java7u71

## Stash Ports

* Stash operates a Tomcat HTTP server on tcp port 7990
* Access it via a web browser: http://localhost:7990/stash

## Build Container
```bash
sudo docker build -t local:centos6java7u71stash242 .
```

## Create local directories for persistent data storage
```bash
mkdir -p stash-home/log
touch stash-home/log/atlassian-stash-mail.log
```

### stash-home/log/atlassian-stash-mail.log
* Stash will produce an error if this directory/file is not pre-existing.

```raw
13:36:48,257 |-ERROR in ch.qos.logback.core.rolling.RollingFileAppender[stash.maillog] - Failed to create parent directories for [/var/lib/stash/log/atlassian-stash-mail.log]
13:36:48,257 |-ERROR in ch.qos.logback.core.rolling.RollingFileAppender[stash.maillog] - openFile(/var/lib/stash/log/atlassian-stash-mail.log,true) call failed. java.io.FileNotFoundException: /var/lib/stash/log/atlassian-stash-mail.log (No such file or directory)
	at java.io.FileNotFoundException: /var/lib/stash/log/atlassian-stash-mail.log (No such file or directory)
```

## JNA
```raw
The APR based Apache Tomcat Native library which allows optimal performance in production environments was not found on the java.library.path: /opt/stash/lib/native:/var/lib/stash/lib/native
```

## Git
* **Stash 2.4.2** requires **git 1.7.6** or higher.
* CentOS 6 (RHEL6) Only has git 1.7.1 available.
* The commandline options for git have changed between 1.7.1 and newer versions, explaining why git is stuck at 1.7.1 in RHEL6.
* There are several mentions of the RepoForge (RPMForge) and IUS repositories having git versions newer than 1.7.1.


## Run the Stash Container
### Interactive:
```bash
sudo docker run -p 7990:7990 -v $(pwd)/stash-home:/var/lib/stash local:centos6java7u71stash242
```

### Daemon mode:
```bash
sudo docker run -d -p 7990:7990 -v $(pwd)/stash-home:/var/lib/stash local:centos6java7u71stash242
```

### Diagnose:
```bash
sudo docker run -i -t -p 7990:7990 -v $(pwd)/stash-home:/var/lib/stash local:centos6java7u71stash242 /bin/bash
```

