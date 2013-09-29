# Puppet manifest for my PHP dev machine

# Edit local /etc/hosts files to resolve some hostnames used on your application.
host { 'localhost.localdomain':
    ensure => 'present',
    target => '/etc/hosts',
    ip => '127.0.0.1',
    host_aliases => ['localhost','memcached','mysql','redis','sphinx']
}

# Adding EPEL repo. We'll use later to install Redis class.
class { 'epel': }

# Memcached server (12MB)
class { "memcached": memcached_port => '11211', maxconn => '2048', cachesize => '12', }

# Miscellaneous packages.
$misc_packages = ['vim-enhanced','telnet','zip','unzip','git','upstart']
package { $misc_packages: ensure => latest }
class { "ntp": autoupdate => true }
class { 'htop': }

class { 'apache':
	sendfile		=> 'off'
}

apache::vhost { 'centos.local':
    priority        => '1',
    port            => '80',
    serveraliases   => ['www.centos.local',],
	docroot         => '/www',
    docroot_owner	=> 'vagrant',
    docroot_group	=> 'vagrant',
	logroot         => '/logs/httpd',
    options         => 'FollowSymLinks MultiViews',
}

#apache::vhost { 'static.newrelax.loc':
#    priority        => '2',
#    port            => '80',
#    serveraliases   => ['*.static.newrelax.loc',],
#    template		=> '/vagrant/files/vhost-static.conf.erb',
#    docroot         => '/www/newrelax.loc/htdocs/static',
#    docroot_owner	=> 'vagrant',
#    docroot_group	=> 'vagrant',
#    logroot         => '/logs/httpd',
#    options         => 'FollowSymLinks MultiViews',
#}

#apache::vhost { 'newrelax.loc':
#    priority        => '3',
#    port            => '80',
#    serveraliases   => ['*.newrelax.loc',],
#    template		=> '/vagrant/files/vhost.conf.erb',
#    docroot         => '/www/newrelax.loc/htdocs',
#    docroot_owner	=> 'vagrant',
#    docroot_group	=> 'vagrant',
#    logroot         => '/logs/httpd',
#    options         => 'FollowSymLinks MultiViews',
#}

# MySQL packages and some configuration to automatically create a new database.
class { 'mysql': }

# PhpMyAdmin
class { 'phpmyadmin': }

# Imagick
class { 'imagemagick': }

class { 'mysql::server':
	config_hash => {
		root_password 	=> '1234',
		log_error 	=> '/logs/mysql',
		default_engine	=> 'InnoDB'
	}
}
Database {
	require => Class['mysql::server'],
}

#database { 'myDB':
#  ensure => 'present',
#  charset => 'utf8',
#}

#database_user { 'myUser@localhost':
#  password_hash => mysql_password('myPassword')
#}

#database_grant { 'myUser@localhost/myDB':
#  privileges => ['all'] ,
#}

# PostgreSQL
class { 'postgresql':
  run_initdb => true,
}->
class { 'postgresql::server':
  config_hash => {
    'listen_addresses'           => '*',
    'postgres_password'          => '',
  },
}
postgresql::pg_hba_rule { 'Allow application network to access app database':
  description => "Open up postgresql for access from 127.0.0.1/32",
  type => 'host',
  database => 'all',
  user => 'all',
  address => '127.0.0.1/32',
  auth_method => 'md5',
}

$additional_mysql_packages = [ "mysql-devel", "mysql-libs" ]
package { $additional_mysql_packages: ensure => present }

# PHP useful packages. Pending TO-DO: Personalize some modules and php.ini directy on Puppet recipe.
php::ini {
	'/etc/php.ini':
        display_errors	=> 'On',
        short_open_tag	=> 'Off',
        memory_limit	=> '256M',
        date_timezone	=> 'Europe/Minsk'
}
include php::cli
include php::mod_php5
php::module { [ 'devel', 'pear', 'pgsql', 'mbstring', 'xml', 'gd', 'tidy', 'pecl-memcache', 'pecl-imagick', 'pecl-xdebug']: }
php::zend::ini { 'pecl-xdebug':
    settings => {
        'xdebug.remote_enable'      => 'on',
        'xdebug.remote_handler' => 'dbgp',
        'xdebug.remote_port'     => '9000',
        'xdebug.remote_port'     => '9000',
        'xdebug.remote_connect_back'     => 'on',
		'xdebug.max_nesting_level'     => '250',
    },
    module_path => '/usr/lib64/php/modules/xdebug.so'
}

# Redis installation.
class redis {
    package { "redis":
        ensure => 'latest',
	    require => Yumrepo['epel'],
    }
    service { "redis":
        enable => true,
        ensure => running,
    }
}
include redis

# Java
class java {
    package { 'java-1.6.0-openjdk':
	require => Yumrepo['epel'],
    }
    package { 'java-1.6.0-openjdk-devel':
	require => Yumrepo['epel'],
    }
}
include java

# PHPUnit
exec { '/usr/bin/pear upgrade pear':
    require => Package['php-pear'],
}

define discoverPearChannel {
    exec { "/usr/bin/pear channel-discover $name":
        onlyif => "/usr/bin/pear channel-info $name | grep \"Unknown channel\"",
        require => Exec['/usr/bin/pear upgrade pear'],
    }
}
discoverPearChannel { 'pear.phpunit.de': }
discoverPearChannel { 'components.ez.no': }
discoverPearChannel { 'pear.symfony-project.com': }
discoverPearChannel { 'pear.symfony.com': }

exec { '/usr/bin/pear install --alldeps pear.phpunit.de/PHPUnit':
    onlyif => "/usr/bin/pear info phpunit/PHPUnit | grep \"No information found\"",
    require => [
        Exec['/usr/bin/pear upgrade pear'],
        DiscoverPearChannel['pear.phpunit.de'],
        DiscoverPearChannel['components.ez.no'],
        DiscoverPearChannel['pear.symfony-project.com'],
        DiscoverPearChannel['pear.symfony.com']
    ],
    user => 'root',
    timeout => 0
}

include nodejs
package { 'grunt-cli':
  ensure   => latest,
  provider => 'npm',
  require => Package['npm']
}

package { 'nodemon':
  ensure   => latest,
  provider => 'npm',
  require => Package['npm']
}