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

# Bind (DNS) Server to allow resolving all *.vm and *.local addresses to VM.
# Note: You should point to the VM as main DNS server on the host machine.
class { 'bind::server': chroot => false }
bind::server::conf { '/etc/named.conf':
	listen_on_addr => [ 'any' ],
	allow_query => [ 'any' ],
    forwarders => [ '8.8.8.8', '8.8.4.4' ],
    zones => {
        'vm.' => [
            'type master',
            'file "local.vm"',
        ],
        'local.' => [
            'type master',
            'file "local.vm"',
        ],
		'lan.' => [
	         'type master',
	         'file "local.vm"',
	    ],
    },
}
bind::server::file { 'local.vm':
    source  => '/vagrant/files/bind.txt',
}

# Memcached server (12MB)
class { "memcached": memcached_port => '11211', maxconn => '2048', cachesize => '12', }

# Miscellaneous packages.
$misc_packages = ['vim-enhanced','telnet','zip','unzip','git']
package { $misc_packages: ensure => latest }
class { "ntp": autoupdate => true }

# Iptables (Firewall) package and rules to allow ssh, http, https and dns services.
class iptables {
	package { "iptables":
		ensure => present
	}

	service { "iptables":
		require => Package["iptables"],
		hasstatus => true,
		status => "true",
		hasrestart => false,
	}

	file { "/etc/sysconfig/iptables":
		owner   => "root",
		group   => "root",
		mode    => 600,
		replace => true,
		ensure  => present,
		source  => "/vagrant/files/iptables.txt",
		require => Package["iptables"],
		notify  => Service["iptables"],
	}
}
class { 'iptables': }

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
php::module { [ 'devel', 'pear', 'mysql', 'mbstring', 'xml', 'gd', 'tidy', 'pecl-apc', 'pecl-memcache', 'pecl-imagick']: }

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