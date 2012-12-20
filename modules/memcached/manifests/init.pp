#
# Class: memcached
#
# A module to install and configure memcached on a node.
# It defaults to the usual memcached configuration settings but they can all be changed
# by passing the parameters to the class.
#
# Example:
# class { "memcached":
#   memcached_port => '11211',
#   maxconn        => '2048',
#   cachesize      => '20000',
# }
#

class memcached (
    $memcached_port = '11211',
    $maxconn = '1024',
    $cachesize = '64'
    ) {

    package { "memcached":
        ensure => installed
    }

    $memcached_config_file = $::operatingsystem ? {
        # FIXME: Debian based distros not tested yet
        /Debian|Ubuntu/         => "/etc/memcached.conf",
        /RedHat|CentOs|Fedora/  => "/etc/sysconfig/memcached",
        default                 => "/etc/memcached.conf"
    }

    $memcached_template_file = $::operatingsystem ? {
        /Debian|Ubuntu/         => "memcached/memcached.debian.erb",
        default                 => "memcached/memcached.sysconfig.erb"
    }

    file {
        "$memcached_config_file":
            mode    => 0444,
            owner   => root,
            group   => root,
            ensure  => present,
            content => template($memcached_template_file),
            require => Package["memcached"],
    }

    service { "memcached":
        ensure      => true,
        enable      => true,
        hasstatus   => true,
        hasrestart  => true,
        require     => [File["$memcached_config_file"],Package["memcached"]],
    }
}
