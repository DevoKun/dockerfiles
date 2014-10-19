File {
  owner => "root",
  group => "root",
  mode  => "0600",
  } ### File

Exec {
  path => $::path,
  logoutput => "true",
  } ### Exec

package { ["git", "links", "wget", "tree"]: ensure=>"latest" }

#######################################################################
#######################################################################
####
#### PHP
####
#######################################################################
#######################################################################

if ( ! defined(Package['gcc']))  { package { "gcc":  ensure=>"latest" } }
if ( ! defined(Package['make'])) { package { "make": ensure=>"latest" } }

$php5_pkgs = ["php5", "php5-cli", "php5-common", "php5-curl", "php5-dev", "php5-gd", "php5-gmp", "php5-readline", "php5-sqlite", "php5-tidy", "php5-xmlrpc", "php5-imagick", "php5-json", "php5-mcrypt", "php5-mongo", "php5-pgsql", "php5-mysql", "phpunit"]
#$php5_pkgs = ["php", "php-cli", "php-common", "php-curl", "php-dev", "php-gd", "php-gmp", "php-readline", "php-sqlite", "php-tidy", "php-xmlrpc", "php-imagick", "php-json", "php-mcrypt", "php-mongo", "php-pgsql", "php-mysql", "phpunit"]

package { $php5_pkgs: ensure=>"latest" }

#Package['gcc', 'make']->Package[$php5_pkgs]

#######################################################################
#######################################################################
####
#### Ruby
####
#######################################################################
#######################################################################

$ruby_version = "ruby-2.0.0-p576"
$ruby_gemset  = "${ruby_version}@global"

file { ['/root/.rvmrc']:
  content => 'umask u=rwx,g=rwx,o=rx
              export rvm_max_time_flag=60',
  mode    => '0664',
  before  => Class['rvm'],
  } ### file

class { 'rvm': version => '1.25.32' }
rvm_system_ruby {
  $ruby_version:
    ensure      => 'present',
    default_use => true;
  } ### rvm_system_ruby
rvm_gemset {
  $ruby_gemset:
    ensure  => present,
    require => Rvm_system_ruby[$ruby_version];
  } ### rvm_gemset

#rvm_gem {
#  "${ruby_gemset}/bundler":        require => Rvm_gemset[$ruby_gemset];
#  "${ruby_gemset}/builder":        require => Rvm_gemset[$ruby_gemset];
#  "${ruby_gemset}/ruby-inotify":   require => Rvm_gemset[$ruby_gemset];
#  "${ruby_gemset}/colored":        require => Rvm_gemset[$ruby_gemset];
#  "${ruby_gemset}/uuid":           require => Rvm_gemset[$ruby_gemset];
#  "${ruby_gemset}/sinatra":        require => Rvm_gemset[$ruby_gemset];
#  "${ruby_gemset}/sinatra-env":    require => Rvm_gemset[$ruby_gemset];
#  "${ruby_gemset}/aws-sdk":        require => Rvm_gemset[$ruby_gemset];
#  "${ruby_gemset}/json":           require => Rvm_gemset[$ruby_gemset];
#  "${ruby_gemset}/rails":          require => Rvm_gemset[$ruby_gemset];
#  "${ruby_gemset}/activesupport":  require => Rvm_gemset[$ruby_gemset];
#  "${ruby_gemset}/activemodel":    require => Rvm_gemset[$ruby_gemset];
#  "${ruby_gemset}/dynamoid":       require => Rvm_gemset[$ruby_gemset];
#  } ### rvm_gem



