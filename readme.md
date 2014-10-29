Dockerfiles
===========

## Containers

* **CraftBukkit**: Minecraft Bukkit Server based on Ubuntu
* **vsFtp**: vsFTP Server based on CentOS
* **Jenkins**: Customized Jenkins based on official Jenkins which is based on Debian.
* **OpenStack Swift**: Operate the Object Storage service, Swift, from OpenStack in stand-alone mode.

## Supervisord
* Many of these Docker containers use Supervisord for starting and running the daemons.
* Supervisord starts a daemon in the foreground and restarts the daemon if it stops.

### Supervisord Daemon Recipes

#### Apache HTTPD
````ini
[program:httpd]
command=httpd -c "ErrorLog /dev/stdout" -DFOREGROUND
redirect_stderr=true
```

#### OpenLDAP
````ini
[program:slapd]
command=slapd -f /etc/slapd.conf -h ldap://0.0.0.0:8888
redirect_stderr=true
```

#### MySQL
````ini
[program:mysql]
command=pidproxy /var/run/mysqld.pid mysqld_safe
```

#### xinetd
````ini
[program:xinetd]
command=/usr/sbin/xinetd -pidfile /var/run/xinetd.pid -stayalive -inetd_compat -dontfork
```

#### vsftpd
* Requires **background=NO** is set in **vsftpd.conf**
````ini
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
[program:nodeapp]
command        = node /path/to/index.js
directory      = /path/to/
user           = nodeuser
autostart      = true
autorestart    = true
stdout_logfile = /var/log/supervisor/nodeapp.log
stderr_logfile = /var/log/supervisor/nodeapp_err.log
environment    = NODE_ENV="production"
