Dockerfiles
===========

## Containers

* **CraftBukkit**: Minecraft Bukkit Server based on Ubuntu
* **vsFtp**: vsFTP Server based on CentOS
* **Jenkins**: Customized Jenkins based on official Jenkins which is based on Debian.
* **OpenStack Swift**: Operate the Object Storage service, Swift, from OpenStack in stand-alone mode.
* **java7-centos**: Used for creating a CentOS container with Oracle Java 7 installed. ***Also used for compiling Netflix Priam***.
* **cassandra-centos**: Operate Cassandra on CentOS us Netflix Priam
* **stash-centos**: Operate Atlassian Stash on CentOS


## Dead Docker Container Cleanup
* Docker leaves behind containers after exiting them.
* If the container is a named container, as apposed to the default random name combo, then attempting to launch a future named container of the same name will fail.

### List containers
```raw
sudo docker ps -a
CONTAINER ID        IMAGE                            COMMAND                CREATED             STATUS                       PORTS               NAMES
7366e22199c1        mysql:latest                     "/entrypoint.sh mysq   32 minutes ago      Exited (-1) 12 minutes ago                       mysql-master           
3ecef8e5f213        local:centos6java7u71cassandra   "/bin/bash"            6 days ago          Exited (0) 6 days ago                            romantic_euclid        
```

### kill exited containers
```bash
sudo docker ps -a | awk '{if (substr($0, 97, 6)=="Exited") print "sudo docker rm "$1;}' | sh
```


## Using items from outside the container
* **-v** *(--volume=[])* will bind directories or files from outside the container to locations inside the container.

### Bind Directories
```bash
docker run -ti -v $(pwd)/logs:/var/logs ubuntu:14.04.1 /bin/bash
```

### Bind Individual Files
* If the file is one that will be created inside the container, it is best to pre-create the file outside the container.
* If the bind target does not exist as a file outside the container Docker will assume the file is a directory and create it as such.
```bash
touch $(pwd)/hosts
docker run -ti -v $(pwd)/hosts:/etc/hosts ubuntu:14.04.1 /bin/bash
```




## Supervisord
* Many of these Docker containers use Supervisord for starting and running the daemons.
* Supervisord starts a daemon in the foreground and restarts the daemon if it stops.

### Supervisord Daemon Recipes






#### ActiveMQ
```ini
[program:activemq]
command        = /opt/apache-activemq-5.10.0/bin/activemq console
directory      = /opt/apache-activemq-5.10.0
stdout_logfile = /var/log/activemq.log
stderr_logfile = /var/log/activemq-error.log
autostart      = true
autorestart    = true
```


#### Apache HTTPD
```ini
[program:httpd]
command=httpd -c "ErrorLog /dev/stdout" -DFOREGROUND
redirect_stderr=true
```



#### Atlassian Stash
```ini
[program:stash]
command        = /opt/stash/bin/start-stash.sh -fg
autostart      = true
autorestart    = true
stdout_logfile = /var/log/stash.log
stderr_logfile = /var/log/stash-error.log
environment    = STASH_HOME=/opt/stash/home
user           = stash
directory      = /opt/stash
```

#### Atlassian Bamboo
```ini
[program:bamboo]
command        = /opt/bamboo/bin/start-bamboo.sh -fg
autostart      = true
autorestart    = true
stdout_logfile = /var/log/bamboo.log
stderr_logfile = /var/log/bamboo-error.log
environment    = BAMBOO_HOME=/opt/bamboo/home
user           = bamboo
directory      = /opt/bamboo
```



### Cassandra
```ini
[program:cassandra]
command        = cassandra -f
stdout_logfile = /var/log/cassandra.log
stderr_logfile = /var/log/cassandra-error.log
autostart      = true
autorestart    = true
```

#### Netflix Priam
* Priam is run from inside Tomcat.
* Start Tomcat *(see above)*


#### ETCD
```ini
[program:etcd]
command        = /usr/sbin/etcd
stdout_logfile = /var/log/etcd.log
stderr_logfile = /var/log/etcd-error.log
autostart      = true
autorestart    = true
environment    = ETCD_NAME=etcd1,ETCD_LISTEN_CLIENT_URLS="http://0.0.0.0:2379",ETCD_ADVERTISE_CLIENT_URLS="http://0.0.0.0:2379",ETCD_ENDPOINTS="http://0.0.0.0:2379",ETCD_LISTEN_PEER_URLS="http://0.0.0.0:2380",ETCD_INITIAL_CLUSTER="etcd1=http://10.10.100.10:2380,etcd2=http://10.10.100.20:2380,etcd3=http://10.10.100.30:2380",ETCD_INITIAL_ADVERTISE_PEER_URLS="http://0.0.0.0:2380",ETCD_INITIAL_CLUSTER_STATE="existing",ETCD_INITIAL_CLUSTER_TOKEN="etcd-cluster"

```




#### MySQL
```ini
[program:mysql]
command=pidproxy /var/run/mysqld.pid mysqld_safe
```



#### OpenLDAP
```ini
[program:slapd]
command=slapd -f /etc/slapd.conf -h ldap://0.0.0.0:8888
redirect_stderr=true
```

#### OpenSSH
```ini
[program:sshd]
command         = /usr/sbin/sshd -D
autorestart     = true
redirect_stderr = true
stdout_logfile  = /var/log/supervisor/%(program_name)s.log
```

#### Puppet Master
```ini
[program:puppetmaster]
command = /usr/bin/puppet master --no-daemon
autorestart = true
stdout_logfile = /var/log/puppetmaster.log
stderr_logfile = /var/log/puppetmaster-error.log
```


#### Logstash
```ini
[program:logstash]
command        = /opt/logstash/bin/logstashagent -f /etc/logstash/conf.d -l /var/log/logstash.log --verbose
autostart      = true
autorestart    = true
stdout_logfile = /var/log/logstash.log
stderr_logfile = /var/log/logstash-error.log
environment    = LS_HOME="/var/lib/logstash",LS_HEAP_SIZE="500m",LS_JAVA_OPTS="-Djava.io.tmpdir=/var/lib/logstash",JAVA_OPTS="-Djava.io.tmpdir=/var/lib/logstash"
user           = logstash
directory      = /var/lib/logstash
```

#### NodeJS Application
```ini
[program:nodeapp]
command        = node /path/to/index.js
directory      = /path/to/
user           = nodeuser
autostart      = true
autorestart    = true
stdout_logfile = /var/log/supervisor/nodeapp.log
stderr_logfile = /var/log/supervisor/nodeapp_err.log
environment    = NODE_ENV="production"
```


#### memcached
```ini
[program:memcached]
command      = /usr/bin/memcached -u memcache
startsecs    = 3
stopwaitsecs = 3
```

#### PHP-fpm *(php5-fpm)*
```ini
[program:php5-fpm]
command        = /usr/sbin/php5-fpm --fpm-config /etc/php5/fpm/php-fpm.conf
directory      = /etc/php5/fpm/
stdout_logfile = /var/log/php5-fpm.log
stderr_logfile = /var/log/php5-fpm-error.log
autostart      = true
autorestart    = true
```

#### rsyslogd
```ini
[program:rsyslog]
command      = /bin/bash -c "source /etc/default/rsyslog && /usr/sbin/rsyslogd -n -c3"
startsecs    = 5
stopwaitsecs = 5
```

#### Shibboleth-SP
```ini
[program:shibd]
command      = shibd -F -c /etc/shibboleth/shibboleth2.xml -f -w 30
user         = shibd
autostart    = true
autorestart  = true
```








#### Tomcat 6
```ini
[program:tomcat6-8300]
command=/opt/tomcat6/bin/catalina.sh run
environment=JAVA_OPTS=\"-Xms512m -Xmx512m -XX:+CMSClassUnloadingEnabled -XX:+CMSPermGenSweepingEnabled\"
directory=/opt/tomcat6/bin
stopsignal=QUIT
autostart=false
autorestart=true
user=nobody
group=nobody
```



#### Tomcat 7 on CentOS 6
```ini
[program:tomcat]
directory      = /usr/share/tomcat
command        = /usr/local/sbin/supervisord_tomcat.sh
stdout_logfile = /var/log/tomcat.log
stderr_logfile = /var/log/tomcat-error.log
user           = tomcat
```


**FILE**: /usr/local/sbin/tomcat_run.sh
```bash
#!/bin/bash

if [ -f /etc/tomcat/tomcat.conf ]; then
  source /etc/tomcat/tomcat.conf
fi

export JAVA_HOME="/usr/lib/jvm/jre"
export _RUNJAVA="/usr/bin/java"
export LOGGING_CONFIG="-Djava.util.logging.config.file=/usr/share/tomcat/conf/logging.properties"
export LOGGING_MANAGER="-Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager"
export JAVA_OPTS=""
export CATALINA_OPTS=""
export CATALINA_BASE="/usr/share/tomcat"
export CATALINA_HOME="/usr/share/tomcat"
export CATALINA_TMPDIR="/var/cache/tomcat/temp"
export CLASSPATH="${CATALINA_BASE}/bin/bootstrap.jar:${CATALINA_BASE}/bin/tomcat-juli.jar"
export JAVA_ENDORSED_DIRS="${CATALINA_BASE}/endorsed"

eval exec "\"$_RUNJAVA\"" "\"$LOGGING_CONFIG\"" $LOGGING_MANAGER $JAVA_OPTS $CATALINA_OPTS \
  -Djava.endorsed.dirs="\"$JAVA_ENDORSED_DIRS\"" -classpath "\"$CLASSPATH\"" \
  -Dcatalina.base="\"$CATALINA_BASE\"" \
  -Dcatalina.home="\"$CATALINA_HOME\"" \
  -Djava.io.tmpdir="\"$CATALINA_TMPDIR\"" \
  org.apache.catalina.startup.Bootstrap "$@" start
```




#### Tomcat 7 with Wrapper
```ini
[program:tomcat]
directory      = /usr/local/tomcat
command        = /usr/local/sbin/supervisord_tomcat.sh
stdout_logfile = /var/log/tomcat.log
stderr_logfile = /var/log/tomcat-error.log
user           = tomcat
```


**FILE**: /usr/local/sbin/supervisord_tomcat.sh
```bash
#!/bin/bash

# Source:
#   https://confluence.atlassian.com/plugins/viewsource/viewpagesrc.action?pageId=252348917
#   http://serverfault.com/questions/425132/controlling-tomcat-with-supervisor

function shutdown() {
    date
    echo "Shutting down Tomcat"
    unset CATALINA_PID    # Necessary in some cases
    unset LD_LIBRARY_PATH # Necessary in some cases
    unset JAVA_OPTS       # Necessary in some cases

    $TOMCAT_HOME/bin/catalina.sh stop
} ### shutdown

date
echo "Starting Tomcat"
# export JAVA_HOME=/usr/java/jdk1.7.0_71/
source /etc/profile.d/java.sh
echo "  * JAVA_HOME: $JAVA_HOME"
export CATALINA_PID=/tmp/$$
export LD_LIBRARY_PATH=/usr/local/apr/lib
export JAVA_OPTS="-Dcom.sun.management.jmxremote.port=8999 -Dcom.sun.management.jmxremote.password.file=/etc/tomcat.jmx.pwd -Dcom.sun.management.jmxremote.access.file=/etc/tomcat.jmxremote.access -Dcom.sun.management.jmxremote.ssl=false -Xms128m -Xmx3072m -XX:MaxPermSize=256m"

# remove old unpack
rm -rf /usr/share/tomcat7/webapps/ROOT

# Uncomment to increase Tomcat's maximum heap allocation
# export JAVA_OPTS=-Xmx512M $JAVA_OPTS

# . $TOMCAT_HOME/bin/catalina.sh start
# /usr/share/tomcat7/bin/catalina.sh run
export TOMCAT_SCRIPT="/usr/sbin/tomcat"
# $SU - $TOMCAT_USER -c "${TOMCAT_SCRIPT} start-security
${TOMCAT_SCRIPT} start

# Allow any signal which would kill a process to stop Tomcat
trap shutdown HUP INT QUIT ABRT KILL ALRM TERM TSTP

echo "Waiting for $(cat $CATALINA_PID)"
wait $(cat $CATALINA_PID)
```








#### vsftpd
* Requires **background=NO** is set in **vsftpd.conf**
```ini
[program:vsftpd]
command=/usr/sbin/vsftpd
```



#### xinetd
```ini
[program:xinetd]
command=/usr/sbin/xinetd -pidfile /var/run/xinetd.pid -stayalive -inetd_compat -dontfork
```



#### Zookeeper
```ini
[program:zookeeper]
command        = /opt/zookeeper-xxx/bin/zkServer.sh start-foreground
directory      = /opt/zookeeper-xxx
stdout_logfile = /var/log/zookeeper.log
stderr_logfile = /var/log/zookeeper-error.log
autostart      = true
autorestart    = true
```










## SublimeText Dockerfile Syntax Highlighting

### Create Package directories

#### On MacOS X
```bash
cd "~/Library/Application Support/Sublime Text 2/Packages/"
mkdir Dockerfile
cd Dockerfile
```

### Download tmLanguage and tmPreferences
```bash
wget https://raw.githubusercontent.com/asbjornenge/Docker.tmbundle/master/Syntaxes/Dockerfile.tmLanguage

wget https://raw.githubusercontent.com/asbjornenge/Docker.tmbundle/master/Preferences/Dockerfile.tmPreferences

```


## Private Docker Registry

* A git repository for images.
* *example:* https://github.com/lukaspustina/docker-registry-demo

### Tag a Docker container and push to registry

* Every single command in a Dockerfile yields a new Docker image with an individual id similar to a commit in git.
* This commit can be tagged for easy reference with a Docker Tag.
* In addition, tags are the means to share images on public and private repositories.

#### assuming your registry is listening on localhost port 5000:

```bash
 docker tag lukaspustina/registry-demo localhost:5000/registry-demo
 docker push localhost:5000/registry-demo
```

### Run a Docker registry container

* **Official Docker registry**: https://github.com/dotcloud/docker-registry

```bash
docker run \
         -e SETTINGS_FLAVOR=s3 \
         -e AWS_BUCKET=mybucket \
         -e STORAGE_PATH=/registry \
         -e AWS_KEY=myawskey \
         -e AWS_SECRET=myawssecret \
         -p 5000:5000 \
         registry

```

### Flavor Settings
* **common**: used by all other flavors as base settings
* **local**: stores data on the local filesystem
* **s3**: stores data in an AWS S3 bucket
* **ceph-s3**: stores data in a Ceph cluster via a Ceph Object Gateway, using the S3 API
* **azureblob**: stores data in an Microsoft Azure Blob Storage ((docs))
* **dev**: basic configuration using the local flavor
* **test**: used by unit tests
* **prod**: production configuration (basically a synonym for the s3 flavor)
* **gcs**: stores data in Google cloud storage
* **swift**: stores data in OpenStack Swift
* **glance**: stores data in OpenStack Glance, with a fallback to local storage
* **glance-swift**: stores data in OpenStack Glance, with a fallback to Swift
* **elliptics**: stores data in Elliptics key/value storage

#### AWS Simple Storage Service options

* **s3_access_key**: string, S3 access key
* **s3_secret_key**: string, S3 secret key
* **s3_bucket**: string, S3 bucket name
* **s3_region**: S3 region where the bucket is located
* **s3_encrypt**: boolean, if true, the container will be encrypted on the server-side by S3 and will be stored in an encrypted form while at rest in S3.
* **s3_secure**: boolean, true for HTTPS to S3
* **s3_use_sigv4**: boolean, true for USE_SIGV4 (boto_host needs to be set or use_sigv4 will be ignored by boto.)
* **boto_bucket**: string, the bucket name for non-Amazon S3-compliant object store
* **boto_host**: string, host for non-Amazon S3-compliant object store
* **boto_port**: for non-Amazon S3-compliant object store
* **boto_debug**: for non-Amazon S3-compliant object store
* **boto_calling_format**: string, the fully qualified class name of the boto calling format to use when accessing S3 or a non-Amazon S3-compliant object store
* **storage_path**: string, the sub "folder" where image data will be stored.

#### Example:

```yaml
prod:
  storage: s3
  s3_region: us-east-1
  s3_bucket: my-docker-bucket
  storage_path: /registry
  s3_access_key: AKIkkkkkkkkkkkkkk
  s3_secret_key: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

### Storage Backends
* Docker registry supports multiple storage backends:
# local file system
# Amazon S3
# OpenStack Glance

### config/config.yml secret key
* set a **secret_key** in the configuration file **config/config.yml** to a 64 characters long value.
* Otherwise, you will get very confusing errors if you run more than one worker thread.

https://github.com/docker/docker-registry/blob/master/config/config_sample.yml

```bash
SECRET_KEY=$(openssl rand -base64 48)

```

### Start the registry

```bash
SETTINGS_FLAVOR=prod
DOCKER_REGISTRY_CONFIG=/registry-conf/docker_registry_config.yml

sudo docker run -p 5000:5000 -v $(pwd)/:/registry-conf -e SETTINGS_FLAVOR=${SETTINGS_FLAVOR} -e DOCKER_REGISTRY_CONFIG=${DOCKER_REGISTRY_CONFIG} registry
```


