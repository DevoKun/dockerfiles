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







## Supervisord
* Many of these Docker containers use Supervisord for starting and running the daemons.
* Supervisord starts a daemon in the foreground and restarts the daemon if it stops.

### Supervisord Daemon Recipes

#### OpenSSH
```ini
[program:sshd]
command         = /usr/sbin/sshd -D
autorestart     = true
redirect_stderr = true
stdout_logfile  = /var/log/supervisor/%(program_name)s.log
```

#### Apache HTTPD
```ini
[program:httpd]
command=httpd -c "ErrorLog /dev/stdout" -DFOREGROUND
redirect_stderr=true
```

#### OpenLDAP
```ini
[program:slapd]
command=slapd -f /etc/slapd.conf -h ldap://0.0.0.0:8888
redirect_stderr=true
```

#### MySQL
```ini
[program:mysql]
command=pidproxy /var/run/mysqld.pid mysqld_safe
```

#### xinetd
```ini
[program:xinetd]
command=/usr/sbin/xinetd -pidfile /var/run/xinetd.pid -stayalive -inetd_compat -dontfork
```

#### vsftpd
* Requires **background=NO** is set in **vsftpd.conf**
```ini
[program:vsftpd]
command=/usr/sbin/vsftpd
```

#### memcached
```ini
[program:memcached]
command      = /usr/bin/memcached -u memcache
startsecs    = 3
stopwaitsecs = 3
```

#### rsyslogd
```ini
[program:rsyslog]
command      = /bin/bash -c "source /etc/default/rsyslog && /usr/sbin/rsyslogd -n -c3"
startsecs    = 5
stopwaitsecs = 5
```
#### A NodeJS Application
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




## Zookeeper
```ini
[program:zookeeper]
command        = /opt/zookeeper-3.4.5/bin/zkServer.sh start-foreground
directory      = /opt/zookeeper-3.4.5
stdout_logfile = /var/log/zookeeper.log
stderr_logfile = /var/log/zookeeper-error.log
autostart      = true
autorestart    = true
```

## ActiveMQ
```ini
[program:activemq]
command        = /opt/apache-activemq-5.10.0/bin/activemq console
directory      = /opt/apache-activemq-5.10.0
stdout_logfile = /var/log/activemq.log
stderr_logfile = /var/log/activemq-error.log
autostart      = true
autorestart    = true
```

## ETCD
```ini
[program:etcd]
command        = etcd
stdout_logfile = /var/log/etcd.log
stderr_logfile = /var/log/etcd-error.log
autostart      = true
autorestart    = true
```




