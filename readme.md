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
autostart=true
autorestart=true
```



