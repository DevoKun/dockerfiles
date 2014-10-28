
package { "vsftpd": ensure=>"latest" }
file { "/etc/vsftpd/vsftpd.conf":
  owner   => "root",
  group   => "root",
  mode    => "0644",
  content => "
anonymous_enable=YES
local_enable=YES
write_enable=YES
local_umask=022
dirmessage_enable=YES
xferlog_enable=YES
connect_from_port_20=YES
xferlog_std_format=YES
listen=YES

background=NO

pam_service_name=vsftpd
userlist_enable=YES
tcp_wrappers=YES

# pasv_address=23.20.106.96
pasv_max_port=33333
pasv_min_port=30000

ssl_enable=YES
rsa_cert_file=/etc/vsftpd/vsftpd.pem
rsa_private_key_file=/etc/vsftpd/vsftpd.pem
force_local_logins_ssl=YES
ssl_tlsv1=YES
ssl_sslv2=YES
ssl_sslv3=YES
ssl_ciphers=HIGH
require_ssl_reuse=NO
dual_log_enable=YES
log_ftp_protocol=YES

",
  } ### file

# Generate SSL certificate for vsFTPd
# /etc/vsftpd/vsftpd.pem
$ssl_country = "US"
$ssl_state   = "NH"
$ssl_city    = "Chesterfield"
$ssl_company = "None"
$ssl_dept    = "None"
$ssl_email   = "no-reply@none"
$ssl_server  = "vsftp-server"
$ssl_subject = "/C=${ssl_country}/ST=${ssl_state}/L=${ssl_city}/O=${ssl_company}/OU=${ssl_dept}/CN=${ssl_server}/emailAddress=${ssl_email}"

Exec { path=>$::path }
$ssl_certdir = "/etc/vsftpd" 
exec {
  "generate-vsftpd-key":
    command => "openssl genrsa -out vsftpd.key 4096",
    cwd     => $ssl_certdir;
  "generate-vsftpd-crt":
    command => "openssl req -new -sha256 -key vsftpd.key -x509 -out vsftpd.crt -days 999 -subj ${ssl_subject}",
    cwd=>$ssl_certdir;
  "combine-crt-key-into-pem":
    command => "cat vsftpd.{crt,key} > vsftpd.pem",
    cwd     => $ssl_certdir;
  } ### exec

Package['vsftpd']->Exec["generate-vsftpd-key"]->Exec["generate-vsftpd-crt"]->Exec["combine-crt-key-into-pem"]


##############################################################################3
##############################################################################3
##############################################################################3
##############################################################################3


package { "supervisor": ensure=>"latest" }

file { "/etc/supervisord.conf":
  owner   => "root",
  group   => "root",
  mode    => "0644",
  content => '
[supervisord]
nodaemon=true

[inet_http_server]
port=*:9001
username=admin
password=!supervisord!

[program:vsftpd]
#command=/bin/bash -c "exec /usr/sbin/vsftpd"
command=/usr/sbin/vsftpd
autostart=true
autorestart=true

',
  } ### file

Package['supervisor']->File['/etc/supervisord.conf']

