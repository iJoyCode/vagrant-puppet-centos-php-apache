stage { 'repo': }
stage { 'pre': }
Stage[repo] -> Stage[pre] -> Stage[main]

# Repos
class { 'epel': 
	stage => repo,
}

# Tools
class { 'concat::setup': 
	stage => pre
}
class { 'wget': 
	stage => pre
}
# NodeJS
class { 'nodejs':
  version => 'stable',
  stage => pre,
}
package { 'grunt-cli':
  provider => npm,
}
package { 'nodemon':
  provider => npm,
}

# Edit local /etc/hosts files to resolve some hostnames used on your application.
host { 'localhost.localdomain':
    ensure => 'present',
    target => '/etc/hosts',
    ip => '127.0.0.1',
    host_aliases => ['localhost','memcached','mysql','redis','sphinx'],
}

# Iptables
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

# Apache
class { 'apache':
	sendfile		=> 'off',
}
apache::mod { 'headers': }
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

# PHP
php::ini {
	'/etc/php.ini':
        display_errors	=> 'On',
        short_open_tag	=> 'Off',
        memory_limit	=> '256M',
        date_timezone	=> 'Europe/Minsk'
}
include php::cli
include php::mod_php5
php::module { [ 'devel', 'pear', 'pgsql', 'intl', 'mbstring', 'xml', 'gd', 'opcache', 'tidy', 'pecl-memcache', 'pecl-imagick', 'pecl-redis', 'pecl-amqp']: }

# MySQL
class { '::mysql::server':
  root_password    => '1234',
  override_options => { 'mysqld' => { 'max_connections' => '1024' } }
}

# Redis
class { 'redis': }

# RabbitMQ
class { 'rabbitmq':
  port              => '5672',
  environment_variables   => {
    'RABBITMQ_NODENAME'     => 'node01',
    'RABBITMQ_SERVICENAME'  => 'RabbitMQ'
  },
}

# MongoDb
class {'::mongodb::server': }

# Pipe Viewer
package { "pv":
    ensure => "installed",
}

# Git
package { "git":
    ensure => "installed",
}

# ImageMagick
package { "ImageMagick":
    ensure => "installed",
}

# PHPUnit
class { 'phpunit': }

# PHPMyAdmin
class { 'phpmyadmin': }