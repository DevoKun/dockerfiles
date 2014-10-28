vsftpd
======

* Creates a **Docker** container for operating a vsftpd server.
* **vsftpd** is started by **supervisord**.
* Supervisord starts the vsftpd daemon and ensures it stays running by starting it in the foreground.
* To start vsftpd in the foreground, add **background=NO** to **vsftpd.conf**.


